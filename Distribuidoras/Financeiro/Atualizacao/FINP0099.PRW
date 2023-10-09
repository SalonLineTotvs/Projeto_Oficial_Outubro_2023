#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "topconn.ch"
#Include "TBICONN.CH"
#Include "COLORS.CH"
#Include "RPTDEF.CH"
#Include "Rwmake.ch"

User Function FINP0099()

Local _cEmpx        := "02"
Local _cFilx        := "0101"
Local _cAlias       := "FINP99"
Local _cQuery       := ""
Local _cPvfil       := ""
Local _cPedido      := ""
Local _cCliente     := ""
Local _cCliloja     := ""
Local _cCGC         := ""
Local _cRisco       := ""
Local _dDtlib       := ""
Local _dDtVld       := ""

Private _aDados    := {}

Prepare Environment Empresa _cEmpx Filial _cFilx Modulo "FINANCEIRO"

//VALIDA O VENCIMENTO DOS PEDIDOS LIBERADOS PELO FINANCEIRO QUE AINDA NAO FORAM PARA A ONDA
_cQuery := " SELECT C5_FILIAL, C5_NUM, C5_TIPO, C5_CLIENTE, C5_LOJACLI, A1_RISCO,  " + CRLF
_cQuery += " A1_CGC, C5_X_STACR, C5_XLBCRED , C5_XDTLIBM ,C5_XUSRLIB  " + CRLF
_cQuery += " FROM SC5020 C5  " + CRLF
_cQuery += " INNER JOIN SA1020 A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_RISCO <> 'A'    " + CRLF
_cQuery += " WHERE C5_X_STAPV = '0' AND C5_NOTA = '' AND C5_TIPO = 'N'   " + CRLF
_cQuery += " AND C5.D_E_L_E_T_ ='' AND C5_XDTLIBM > '20230111' " + CRLF
_cQuery += " ORDER BY C5_FILIAL, C5_NUM  " + CRLF
dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cAlias , .F., .T. )

DbSelectArea( _cAlias )
(_cAlias)->( DbGoTop() )
While (_cAlias)->( ! EOF() )

    _cPvfil     := (_cAlias)->C5_FILIAL
    _cPedido    := (_cAlias)->C5_NUM
    _cCliente   := (_cAlias)->C5_CLIENTE
    _cCliloja   := (_cAlias)->C5_LOJACLI
    _cCGC       := LEFT(AllTrim((_cAlias)->A1_CGC),8)
    _cRisco     := (_cAlias)->A1_RISCO
    _dDtlib     := StoD((_cAlias)->C5_XDTLIBM)

    LibVenc(_cPvfil,_cPedido,_cCliente,_cCliloja,_cCGC,_cRisco,_dDtlib)

(_cAlias)->( DbSkip() )
EndDo

(_cAlias)->( DbCloseArea() )

_aDados    := {}

_dDtVld := Date()
_dDtVld := DaySub(_dDtVld, 2)
_dDtVld := DataValida(_dDtVld, .F.)

//VALIDA TITULOS VENCIDOS DE PEDIDOS EM ABERTO QUE NAO FORAM PARA A ONDA
_cQuery := " SELECT DISTINCT C5_FILIAL, C5_NUM, C5_TIPO, C5_CLIENTE, C5_LOJACLI, A1_RISCO,  " + CRLF
_cQuery += " A1_CGC, C5_X_STACR, C5_XLBCRED , C5_XDTLIBM ,C5_XUSRLIB, C9_DATALIB  " + CRLF
_cQuery += " FROM SC5020 C5  " + CRLF
_cQuery += " INNER JOIN SA1020 A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_RISCO <> 'A'    " + CRLF
_cQuery += " INNER JOIN SC9020 C9 ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C9.D_E_L_E_T_ = '' AND C9_BLCRED = '' " + CRLF
_cQuery += " WHERE C5_X_STAPV = '0' AND C5_NOTA = '' AND C5_TIPO = 'N'   " + CRLF
_cQuery += " AND C5.D_E_L_E_T_ ='' AND C5_EMISSAO > '20230111' AND C5_XDTLIBM = '' AND C9_DATALIB < '"+Dtos(_dDtVld)+"' " + CRLF
_cQuery += " ORDER BY C5_FILIAL, C5_NUM  " + CRLF
dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cAlias , .F., .T. )

DbSelectArea( _cAlias )
(_cAlias)->( DbGoTop() )
While (_cAlias)->( ! EOF() )

    _cPvfil     := (_cAlias)->C5_FILIAL
    _cPedido    := (_cAlias)->C5_NUM
    _cCliente   := (_cAlias)->C5_CLIENTE
    _cCliloja   := (_cAlias)->C5_LOJACLI
    _cCGC       := LEFT(AllTrim((_cAlias)->A1_CGC),8)
    _cRisco     := (_cAlias)->A1_RISCO
    _dDtlib     := StoD((_cAlias)->C9_DATALIB)

    _dDtVld := Date()
    Do Case
        Case _cRisco == "B"
            _dDtlib := DaySum(_dDtlib, 5)
            _dDtlib := DataValida(_dDtlib, .T.)
        OTHERWISE
            _dDtlib := DaySum(_dDtlib, 2)
            _dDtlib := DataValida(_dDtlib, .T.)
    EndCase

    If _dDtVld > _dDtlib
        TitVenc(_cPvfil,_cPedido,_cCliente,_cCliloja,_cCGC,_cRisco)
    EndIf

(_cAlias)->( DbSkip() )
EndDo

(_cAlias)->( DbCloseArea() )

If ! Empty(_aDados)
    EnvMail()
EndIf

Reset Environment
    
Return


/************* TitVenc ***********

*********************************/
Static Function TitVenc(_cPvfil,_cPedido,_cCliente,_cCliloja,_cCGC,_cRisco)

Local _cTMP     := ""
Local _cQuery   := ""
Local lTitVenc  := .F.
Local _dData	:= Date()

Do Case
    Case _cRisco == "B"
        _dData := DaySub(_dData, 3)
        _dData := DataValida(_dData, .F.)
    Case _cRisco == "C"
        _dData := DaySub(_dData, 1)
        _dData := DataValida(_dData, .F.)
EndCase

_cTMP   := GetNextAlias()
_cQuery := " SELECT TIPO, SUM(TOTAL) SALDO " + CRLF
_cQuery += " FROM( " + CRLF
_cQuery += " SELECT  " + CRLF
_cQuery += " CASE WHEN E1_TIPO='NF' THEN '2 - TITULO' WHEN E1_TIPO='RA' THEN '3 - RA' WHEN E1_TIPO='NCC' THEN '4 - NCC' ELSE '5 - '+E1_TIPO END TIPO, " + CRLF
_cQuery += " E1_CLIENTE CLIENTE, E1_SALDO AS TOTAL " + CRLF
_cQuery += " FROM SE1020 E1 " + CRLF
_cQuery += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_ = '' AND A1_CGC LIKE '"+_cCGC+"%' " + CRLF
_cQuery += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 " + CRLF
_cQuery += " AND E1_TIPO='NF' AND E1_VENCREA < '"+Dtos(_dData)+"' ) A " + CRLF
_cQuery += " GROUP BY TIPO " + CRLF

dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cTMP , .F., .T. )

DbSelectArea( _cTMP )
(_cTMP)->( DbGoTop() )
If (_cTMP)->( ! EOF() )
    lTitVenc := .T.
EndIf
(_cTMP)->( DbCloseArea() )

If lTitVenc

    _cQuery := ""
    _cQuery := " UPDATE "+RetSqlName("SC9")+"  "+CRLF
    _cQuery += " SET C9_BLCRED = '01' "+CRLF
    _cQuery += " WHERE C9_CLIENTE = '"+_cCliente+"' AND C9_LOJA ='"+_cCliloja+"' "+CRLF
    _cQuery += " AND C9_NFISCAL = '' AND D_E_L_E_T_ ='' AND C9_PEDIDO = '"+_cPedido+"' AND C9_FILIAL = '"+_cPvfil+"'"+CRLF
    TcSqlExec(_cQuery)

    _cQuery := ""
    _cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='4', C5_XLBCRED = 'T' "+CRLF
    _cQuery += " WHERE "+CRLF
    _cQuery += " D_E_L_E_T_ = '' AND C5_NUM = '"+_cPedido+"' AND C5_FILIAL = '"+_cPvfil+"' "+CRLF
    TcSqlExec(_cQuery)

    dbSelectArea("ZA1")
    dbSetOrder(1)
    RecLock("ZA1", .T.)
    ZA1->ZA1_FILIAL := _cPvfil
    ZA1->ZA1_PEDIDO := _cPedido
    ZA1->ZA1_DTBLQ  := Date()
    ZA1->ZA1_USER   := "JOB"
    ZA1->ZA1_HORA   := Time()
    ZA1->(MsUnlock())

    AAdd(_aDados,{_cPvfil,_cPedido,_cCliente,_cCliloja})

EndIf

Return


/************* LibVenc ***********

*********************************/
Static Function LibVenc(_cPvfil,_cPedido,_cCliente,_cCliloja,_cCGC,_cRisco,_dDtlib)

Local _dDtHoje := Date()
Local lLibVenc := .F.

Do Case
    Case _cRisco == "B"
        _dDtlib := DaySum(_dDtlib, 5)
        _dDtlib := DataValida(_dDtlib, .T.)
    OTHERWISE
        _dDtlib := DaySum(_dDtlib, 2)
        _dDtlib := DataValida(_dDtlib, .T.)
EndCase

If _dDtHoje > _dDtlib
    lLibVenc := .T.
EndIf

If lLibVenc

    _cQuery := ""
    _cQuery := " UPDATE "+RetSqlName("SC9")+"  "+CRLF
    _cQuery += " SET C9_BLCRED = '01' "+CRLF
    _cQuery += " WHERE C9_CLIENTE = '"+_cCliente+"' AND C9_LOJA ='"+_cCliloja+"' "+CRLF
    _cQuery += " AND C9_NFISCAL = '' AND D_E_L_E_T_ ='' AND C9_PEDIDO = '"+_cPedido+"' AND C9_FILIAL = '"+_cPvfil+"'"+CRLF
    TcSqlExec(_cQuery)

    _cQuery := ""
    _cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='4', C5_XLBCRED = 'T' "+CRLF
    _cQuery += " WHERE "+CRLF
    _cQuery += " D_E_L_E_T_ = '' AND C5_NUM = '"+ _cPedido+"' AND C5_FILIAL = '"+_cPvfil+"' "+CRLF
    TcSqlExec(_cQuery)

    dbSelectArea("ZA1")
    dbSetOrder(1)
    RecLock("ZA1", .T.)
    ZA1->ZA1_FILIAL := _cPvfil
    ZA1->ZA1_PEDIDO := _cPedido
    ZA1->ZA1_DTBLQ  := Date()
    ZA1->ZA1_USER   := "JOB"
    ZA1->ZA1_HORA   := Time()
    ZA1->(MsUnlock())

EndIf

Return

/************* EnvMail ***********

*********************************/
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
lAuth       := .F.,;
nX          := 0

_cMensagem	+= CHR_CENTER_OPEN + CHR_CENTER_CLOSE
_cMensagem	+= CHR_FONT_DET_OPEN
_cMensagem	+= OemToAnsi('Prezado,') + CHR_ENTER
_cMensagem	+= OemToAnsi('Os Pedidos abaixo foram bloqueados:')+CHR_ENTER + CHR_ENTER
 For nX := 1 To Len(_aDados)
 //  AAdd(_aDados,{_cPvfil,_cPedido,_cCliente,_cCliloja})
    _cMensagem	+= OemToAnsi('Filial: '+_aDados[nX,1]+', Pedido: '+_aDados[nX,2]+', Cliente: '+_aDados[nX,3]+', Loja: '+_aDados[nX,4]+'')+CHR_ENTER + CHR_ENTER
 Next nX
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
