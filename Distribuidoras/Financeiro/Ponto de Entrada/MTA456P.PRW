#Include "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

User Function MTA456P()
Local lRet      := .T.
Local _cRisco   := ""
Local _BasCGC   := ""
Local _dData    := Date()
Local _cQuery   := ""
Local _cTMP     := GetNextAlias()
Local _lTitulo  := .F.
Local _lPVvend  := .F.
Local _nOpca    := PARAMIXB[1]
Local _cNomUser := USRRETNAME(RetCodUsr())

Private _cCodCli  := SC9->C9_CLIENTE
Private _cLojCli  := SC9->C9_LOJA
Private _cPedido  := SC9->C9_PEDIDO
Private _cPvloja  := SC9->C9_FILIAL
Private _cPVTipo  := GetAdvFVal("SC5","C5_TIPO", _cPvloja+_cPedido )
Private _cPVStat  := GetAdvFVal("SC5","C5_X_STAPV", _cPvloja+_cPedido )

If _nOpca == 0
    Return lRet
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+_cCodCli+_cLojCli)
_cRisco := AllTrim(SA1->A1_RISCO)
_BasCGC := LEFT(Alltrim(SA1->A1_CGC),8)

Do Case
    Case _cRisco == "B"
        _dData := DaySub(_dData, 3)
        _dData := DataValida(_dData, .F.)
    Case _cRisco == "C"
        _dData := DaySub(_dData, 1)
        _dData := DataValida(_dData, .F.)
EndCase

If _cRisco != "A" .AND. _cPVTipo == "N" .AND. _cPVStat == '0' //Verifica se o Cliente não é A e se o PV é tipo N
    //Busca ti­tulos em aberto do cliente/loja
    _cQuery := " SELECT TIPO, SUM(TOTAL) SALDO " + CRLF
    _cQuery += " FROM( " + CRLF
    _cQuery += " SELECT  " + CRLF
    _cQuery += " CASE WHEN E1_TIPO='NF' THEN '2 - TITULO' WHEN E1_TIPO='RA' THEN '3 - RA' WHEN E1_TIPO='NCC' THEN '4 - NCC' ELSE '5 - '+E1_TIPO END TIPO, " + CRLF
    _cQuery += " E1_CLIENTE CLIENTE, E1_SALDO AS TOTAL " + CRLF
    _cQuery += " FROM SE1020 E1 " + CRLF
    _cQuery += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_ = '' AND A1_CGC LIKE '"+_BasCGC+"%' " + CRLF
    _cQuery += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 " + CRLF
    _cQuery += " AND E1_TIPO='NF' AND E1_VENCREA < '"+Dtos(_dData)+"' ) A " + CRLF
    _cQuery += " GROUP BY TIPO " + CRLF

    dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cTMP , .F., .T. )

    DbSelectArea( _cTMP )
    (_cTMP)->( DbGoTop() )
    If(_cTMP)->( ! EOF() )
        _lTitulo := .T.
    EndIf
    (_cTMP)->( DbCloseArea() )

    If _lTitulo //Se achou títulos vencidos parao grupo do cliente
        _cTMP     := GetNextAlias()
        _cQuery := " SELECT C6_NUM FROM SC6020 C6 " + CRLF
        _cQuery += " INNER JOIN SF4020 F4 ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES AND F4_DUPLIC='S' " + CRLF
        _cQuery += " AND (F4_TEXTO LIKE 'VENDA%' OR F4_TEXTO LIKE 'VD%') AND F4.D_E_L_E_T_=' ' " + CRLF
        _cQuery += " WHERE C6_FILIAL ='"+_cPvloja+"' AND  C6_NUM ='"+_cPedido+"' AND C6.D_E_L_E_T_ ='' " + CRLF

        dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cTMP , .F., .T. )

        DbSelectArea( _cTMP )
        (_cTMP)->( DbGoTop() )
        If(_cTMP)->( ! EOF() )
            _lPVvend := .T.
        EndIf
        (_cTMP)->( DbCloseArea() )

        If _lPVvend //Se o PV gera título. Caracterizando venda.
            lRet := .F.

            _cQuery := ""
            _cQuery := " UPDATE "+RetSqlName("SC9")+"  "+CRLF
            _cQuery += " SET C9_BLCRED = '01' "+CRLF
            _cQuery += " WHERE C9_CLIENTE = '"+_cCodCli+"' AND C9_LOJA ='"+_cLojCli+"' "+CRLF
            _cQuery += " AND C9_NFISCAL = '' AND D_E_L_E_T_ ='' AND C9_PEDIDO = '"+_cPedido+"' AND C9_FILIAL = '"+_cPvloja+"'"+CRLF
            TcSqlExec(_cQuery)

            _cQuery := ""
            _cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='4', C5_XLBCRED = 'T' "+CRLF
            _cQuery += " WHERE "+CRLF
            _cQuery += " D_E_L_E_T_ = '' AND C5_NUM = '"+ _cPedido+"' AND C5_FILIAL = '"+_cPvloja+"' "+CRLF
            TcSqlExec(_cQuery)

            dbSelectArea("ZA1")
            dbSetOrder(1)
            RecLock("ZA1", .T.)
            ZA1->ZA1_FILIAL := _cPvloja
            ZA1->ZA1_PEDIDO := _cPedido
            ZA1->ZA1_DTBLQ  := Date()
            ZA1->ZA1_USER   := UsrRetName(RetCodUsr())
            ZA1->ZA1_HORA   := Time()
            ZA1->(MsUnlock())

            EnvMail()

            MsgAlert("O grupo do cliente "+_cCodCli+"/"+_cLojCli+" possui titulos vencidos em aberto."+CRLF+;
            "Contate o departamento Financeiro.", "MTA456P: Atencao...")
        EndIf
    Else
            _cQuery := ""
            _cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='0', C5_XLBCRED = 'F' "+CRLF
            _cQuery += " WHERE "+CRLF
            _cQuery += " D_E_L_E_T_ = '' AND C5_NUM = '"+ _cPedido+"' AND C5_FILIAL = '"+_cPvloja+"' "+CRLF
            TcSqlExec(_cQuery) 

            _cQuery := ""
            _cQuery := " UPDATE "+RetSqlName("SC9")+"  "+CRLF
            _cQuery += " SET C9_DATALIB = '"+Dtos(Date())+"' "+CRLF
            _cQuery += " WHERE C9_CLIENTE = '"+_cCodCli+"' AND C9_LOJA ='"+_cLojCli+"' "+CRLF
            _cQuery += " AND C9_NFISCAL = '' AND D_E_L_E_T_ ='' AND C9_PEDIDO = '"+_cPedido+"' AND C9_FILIAL = '"+_cPvloja+"'"+CRLF
            TcSqlExec(_cQuery)

            dbSelectArea("ZA1")
            dbSetOrder(1)
            RecLock("ZA1", .T.)
            ZA1->ZA1_FILIAL := _cPvloja
            ZA1->ZA1_PEDIDO := _cPedido
            ZA1->ZA1_DTLIB  := Date()
            ZA1->ZA1_USER   := UsrRetName(RetCodUsr())
            ZA1->ZA1_HORA   := Time()
            ZA1->(MsUnlock())

    EndIf

EndIf

Return lRet


Static Function EnvMail()

#define CHR_LINE				'<hr>'
#define CHR_CENTER_OPEN			'<div align="center" >'
#define CHR_CENTER_CLOSE   		'</div>'
#define CHR_FONT_DET_OPEN		'<font face="Courier New" size="2">'
#define CHR_FONT_DET_CLOSE		'</font>'
#define CHR_ENTER				'<br>'
#define CHR_NEGRITO				'<b>'
#define CHR_NOTNEGRITO			'</b>'

Local cCodUser 		:= RetCodUsr()
Local cEmailCom1	:= SuperGetMV( "SL_MAILCRE", Nil, "alessandra.januario@salonline.com.br;jacqueline.farias@salonline.com.br;" )	
//Local cEmailCom1	:= "gustavo.luna@salonline.com.br"
Local	_cSmtpSrv 	:= "smtp.gmail.com:587",;
_cAccount 	:= AllTrim("noreply1@salonline.com.br"),;
_cPassSmtp	:= AllTrim("NO$4l0nL1n3RY"),;
_cSmtpError	:= '',;
_lOk		:= .f.,;
_cTitulo 	:= "Aviso: Bloqueio Liberação de Crédito" ,;
_cTo		:= cEmailCom1,;
_cCC		:= '',;
_cCo		:= '' ,;  //COPIA OCULTA
_cFrom		:= alltrim(UsrRetMail(cCodUser)),;
_cMensagem	:= '',;
_lReturn	:= .f.,;
lAuth       := .F.

_cMensagem	+= CHR_CENTER_OPEN + CHR_CENTER_CLOSE
_cMensagem	+= CHR_FONT_DET_OPEN
_cMensagem	+= OemToAnsi('Prezado,') + CHR_ENTER
_cMensagem	+= OemToAnsi('O cliente '+_cCodCli+'/'+_cLojCli+' possui o pedido '+_cPedido+' para liberação de crédito. ')+CHR_ENTER + CHR_ENTER 
_cMensagem	+= OemToAnsi('Por favor verificar... ')+CHR_ENTER
_cMensagem	+= CHR_ENTER
_cMensagem	+= CHR_FONT_DET_CLOSE

CONNECT SMTP SERVER _cSmtpSrv ACCOUNT _cAccount PASSWORD _cPassSmtp RESULT _lOk
lAuth := MAILAUTH(_cAccount,_cPassSmtp)

ConOut('Conectando com o Servidor SMTP')

If	( _lOk )
	ConOut('Enviando o e-mail')
	SEND MAIL FROM _cFrom TO _cTo Cc _cCC BCC _cCo SUBJECT _cTitulo BODY _cMensagem RESULT _lOk
	ConOut('De........: ' + _cFrom)
	ConOut('Para......: ' + _cTo)
	ConOut('Assunto...: ' + _cTitulo)
	ConOut('Status....: Enviado com Sucesso')
	
	If	( ! _lOk )
		GET MAIL ERROR _cSmtpError
		ConOut(_cSmtpError)
		_lReturn := .f.
		ConOut("FALHA NO ENVIO DO E-MAIL !!!")
	Else
        ConOut("E-mail enviado com Sucesso!")
	EndIf
	
	DISCONNECT SMTP SERVER
	ConOut('Desconectando do Servidor')
	_lReturn := .t.
Else
	GET MAIL ERROR _cSmtpError
	ConOut(_cSmtpError)
	_lReturn := .f.
EndIF
    
Return
