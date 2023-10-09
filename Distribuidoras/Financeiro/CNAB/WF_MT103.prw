#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "tbiconn.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡„o	 ³ ADFINA91 ³ Autor ³ Gensis/Gustavo Maarkx ³ Data ³ 01/08/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ WF - NOTIFICAÇÃO NF X PC                                   ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function XWFMT103
RpcSetType(3)
PREPARE ENVIRONMENT EMPRESA ( "01" ) FILIAL ( "0301" ) MODULO "COM" TABLES "SA2", "SF1", "SD1"
u_WF_MT103()
Return

*--------------------*
User Function WF_MT103
*--------------------*
Private _aDest   := {'','','','','',''}

_aDest[1] := Alltrim(GetMV("MC_WFMT13P",.F.,'gustavo.oliveira@genesisconsulting.com.br; thiago.vanucci@genesisconsulting.com.br'))
_aDest[2] := Alltrim(GetMV("MC_WFMT13C",.F.,''))

Processa({|| gWfMail(_aDest) ,"WF de notificação"})

Return

*-----------------------------*
Static Function gWfMail(_aDest)
*-----------------------------*
Local _nF       := 0
Local _lSend    := .T.
Local _lAllSend := .T.
Local _aBk_All  := {}

Private _cRodapeAss := ''
Private _cDirArq    := ''

Default _aAllSend := {}
Default _aDest    := {} //CODIGO | NOME | CONTATO | EMAIL | LISTA
Default _aColsOn  := {}
Default _aAll_OFF := {} 
Default _lSolto   := .F.

_cTo     := AllTrim(_aDest[1])  //EMAIL
_cCopia  := ''
_aAnexo  := {}
_cCC     := AllTrim(_aDest[2])  //CC EMAIL
	             
_cHeader := 'WF | '+AllTrim(FWFilialName())+' - Divergência Documento de Entrada x Pedido de Compras'
_cCorpo  := CorpoWF(_aDest) //'Olá '+Capital(SA1->A1_XWFFINC)+', <br><br> Tudo bem ?'
_cProc   := 'WF | '+AllTrim(FWFilialName())+' - Divergência Documento de Entrada x Pedido de Compras'

IF Empty(_cCorpo)
	Return
ENDIF

IF File(_cRodapeAss)	
   	aADD(_aAnexo,_cRodapeAss)
ENDIF
    
Sleep(500)     
	         
_aSendo   := u_g2EnvMail(_cTo,_cCopia,_cCC, _cHeader, _cCorpo, _aAnexo,_cProc, .F., ,.T.)	
_lSend    := _aSendo[1]
_cLogMail := AllTrim(_aSendo[2])

IF !_lAllSend .And. !IsBlind()
	MsgAlert("<b>Workflow não enviado!</b> <br><br> Verifique o log dos titulos selecionados.<br><br>"+_cLogMail, "Atenção")
ENDIF

Return
/*/ EXEMPLO
aAnexos := {}
aAdd(aAnexos, "\pasta\arquivo1.pdf")
u_g2EnvMail("teste@genesisconsulting.com.br", "Teste",  "Teste TMailMessage com anexos", aAnexos)
u_g2EnvMail("teste@genesisconsulting.com.br", "Teste2", "Teste TMailMessage", , .T.)
>> Deve-se configurar os parâmetros:
/*/
*---------------------------------------------------------------------------------------------*
User Function g2EnvMail(_cPara,_cCopia,_cCC, _cAssunto, _cCorpo, _aAnexos, _cProc,_lMostraLog, _lUsaTLS, _lMaskFrom)
*---------------------------------------------------------------------------------------------*
Local aArea        := GetArea()
Local nAtual       := 0
Local _lWfRet      := .T.
Local oMsg         := Nil
Local oSrv         := Nil
Local nRet         := 0
Local cFrom        := Alltrim(GetMV("MV_RELACNT"))
Local cUser        := SubStr(cFrom, 1, At('@', cFrom)-1)
Local cPass        := Alltrim(GetMV("MV_RELPSW"))
Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
Local cServer      := ""
Local nPort        := 0
Local nTimeOut     := GetMV("MV_RELTIME")
Local _cLog        := ""
Local cContaAuth   := ""
Local cPassAuth    := ""
Local nAtu         := 0

Default _cProc      := "WF | "+AllTrim(FWFilialName())
Default _cPara      := ""
Default _cCopia     := ""
Default _cCC        := ""
Default _cAssunto   := ""
Default _cCorpo     := ""
Default _aAnexos    := {}
Default _lMostraLog := .F.
Default _lUsaTLS    := .T.

/*
IF __zAmb_TST
	MsgInfo('Base teste diagnosticada, e-mail será enviado para ADM TI','Controle de Ambiente')
	_zPara    := alltrim(GetMV('GN_RPOTEST',.F.,'gustavo@gsconsulti.com.br'))
	IF !Empty(_zPara)
		_cPara:= _zPara
	Endif
	_cAssunto := AllTrim(_cAssunto)+' >> TESTE <<'
ENDIF
*/


//Se tiver em branco o destinatário, o assunto ou o corpo do email
If Empty(_cPara) .Or. Empty(_cAssunto) .Or. Empty(_cCorpo)
	_cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
	_lWfRet := .F.
EndIf

//Log de envio OK
_cLogOk := "+--[ OK ]-----------------| SEND E-MAIL |--------------------+" + CRLF + ;
"Envio     - " + dToC(Date())+ " " + Time() + CRLF + ;
"Funcao    - " + FunName() + CRLF + ;
"Processos - " + _cProc + CRLF + ;
"Para      - " + _cPara + CRLF + ;
"Assunto   - " + _cAssunto

If _lWfRet
	//Grava Autenticacao
	cContaAuth := cFrom
	cPassAuth  := cPass
	
	If _lMaskFrom
		IF !Empty(_cMailUsr  := UsrRetMail(__cUserID))
			//Caso contenha o @dominio cadastrado no e-mail do usuario fara substituicao do 'FROM'
			_cDomin := SubStr(AllTrim(cFrom),At('@',AllTrim(cFrom))+1,Len(cFrom))
			IF ( _cDomin $ _cMailUsr)
				//Desabilitado por conta do office365
				cFrom := _cMailUsr
			ENDIF
		ENDIF
	EndIf
	
	cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
	nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
	
	//Cria a nova mensagem
	oMsg := TMailMessage():New()
	oMsg:Clear()
	
	//Define os atributos da mensagem
	//oMsg:cDate  := cValToChar(Date())
	oMsg:cFrom    := cFrom
	oMsg:cTo      := _cPara
	oMsg:cSubject := _cAssunto
	oMsg:cBody    := _cCorpo

/*	Alteração do bloco para envio da copia oculta
	IF Empty(_cCopia)
		oMsg:cBCC := _cCopia
	ENDIF
	IF Empty(_cCC)
		oMsg:cBCC := _cCC
	ENDIF
*/	
	IF !Empty(_cCopia)
		oMsg:cCc := _cCopia
	ENDIF
	IF !Empty(_cCC)
		oMsg:cBCC := _cCC
	ENDIF
	//Percorre os anexos
	For nAtual := 1 To Len(_aAnexos)
		//Se o arquivo existir
		If File(_aAnexos[nAtual])
			//Anexa o arquivo na mensagem de e-Mail
			nRet := oMsg:AttachFile(_aAnexos[nAtual])
			If nRet < 0
				_cLog += "002 - Nao foi possivel anexar o arquivo '"+_aAnexos[nAtual]+"'!" + CRLF
			EndIf
			//Senao, acrescenta no log
		Else
			_cLog += "003 - Arquivo '"+_aAnexos[nAtual]+"' nao encontrado!" + CRLF
		EndIf
	Next
	
	//Cria servidor para disparo do e-Mail
	oSrv := tMailManager():New()
	
	//Define se irá utilizar o TLS
	If _lUsaTLS
		oSrv:SetUseTLS(.T.)
	EndIf
	
	//Inicializa conexão
	nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
	If nRet != 0
		_cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
		_lWfRet := .F.
	EndIf
	
	If _lWfRet
		//Define o time out
		nRet := oSrv:SetSMTPTimeout(nTimeOut)
		If nRet != 0
			_cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
		EndIf
		
		//Conecta no servidor
		nRet := oSrv:SMTPConnect()
		If nRet <> 0
			_cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
			_lWfRet := .F.
		EndIf
		
		If _lWfRet
			//Realiza a autenticação do usuário e senha
			nRet := oSrv:SmtpAuth(cContaAuth, cPassAuth)
			If nRet <> 0
				_cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				_lWfRet := .F.
			EndIf
			
			If _lWfRet
				//Envia a mensagem
				nRet := oMsg:Send(oSrv)
				If nRet <> 0
					_cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
					_lWfRet := .F.
				EndIf
			EndIf
			
			//Disconecta do servidor
			nRet := oSrv:SMTPDisconnect()
			If nRet <> 0
				_cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
			EndIf
		EndIf
	EndIf
EndIf

//Se tiver log de avisos/erros
If !Empty(_cLog)
	_cLog := "+--[ERRO]-----------------| SEND E-MAIL |--------------------+" + CRLF + ;
	"Envio     - " + dToC(Date())+ " " + Time() + CRLF + ;
	"Funcao    - " + FunName() + CRLF + ;
	"Processos - " + _cProc + CRLF + ;
	"Para      - " + _cPara + CRLF + ;
	"Assunto   - " + _cAssunto + CRLF + ;
	"Existem mensagens de aviso: "+ CRLF +;
	_cLog
	
	//Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
	If _lMostraLog .And. !IsBlind()
		Aviso("Log", _cLog, {"Ok"}, 2) 
	EndIf
Else
	_cLog := _cLogOk
EndIf

RestArea(aArea)

Return({_lWfRet,_cLog})

*-----------------------------*
Static Function CorpoWF(_aDest)
*-----------------------------*
Local _LGRV        := .F.   
Local _cCliPros    :=  ''
Local _cMsTemp     := ''
Local _nSumSaldo   := 0
Local _cNomeFil    := AllTrim(FWFilialName())
Local _cFrase      := ''        
//Local _cDirArq   := 'logo'+FWFilial()+'.png' //'WfFin92.png'
Local _cDirArq     := 'logo'+cFilAnt+'.png' //'WfFin92.png'
Local cIniFile     := GetADV97()
Local _cDirLoad    := GetPvProfString(GetEnvServer(),	"StartPath","ERROR", cIniFile )
Local _lStatus     := .F.

//Coleta imagem para rodape do e-mail
IF File(_cDirLoad + _cDirArq)
	_cRodapeAss := _cDirLoad + _cDirArq
ENDIF 

//_cMsTemp += ' 	  <img src="cid:'+_cRodapeAss+'" height="120" width="400"> '+iIF(_lGrv,ENTER,'')

_cQry := " SELECT D1_EMISSAO, C7_NUM, C7_ITEM, C7_USER, 	 "+ENTER
_cQry += " 		D1_DOC, D1_SERIE, D1_PEDIDO, D1_ITEMPC, D1_FORNECE, D1_LOJA, A2_DOC.A2_NOME FORNEC_NOTA , D1_COD, D1_XDESCRI, D1_ITEM D1ITEM, D1_QUANT, D1_VUNIT, D1_TOTAL, "+ENTER
_cQry += " 		'<< | >>' AS 'NOTA <<|>> PED',  "+ENTER
_cQry += " 		D1_PEDIDO, D1_ITEMPC, C7_FORNECE, C7_LOJA, A2_DOC.A2_NOME FORNEC_PED  , C7_PRODUTO, C7_QUANT, C7_QUJE, (C7_QUANT-C7_QUJE) SALDO_PED ,C7_PRECO, C7_TOTAL, C7_USER "+ENTER
_cQry += "  FROM "+RetSqlName('SD1')+" SD1  "+ENTER
_cQry += "  LEFT JOIN "+RetSqlName('SC7')+" SC7    ON SC7.D_E_L_E_T_    = '' AND C7_FILIAL = D1_FILIAL AND C7_NUM=D1_PEDIDO AND C7_ITEM=D1_ITEMPC "+ENTER
_cQry += "  LEFT JOIN "+RetSqlName('SA2')+" A2_DOC ON A2_DOC.D_E_L_E_T_ = '' AND A2_DOC.A2_FILIAL = '"+xFilial('SA2')+"' AND A2_DOC.A2_COD = D1_FORNECE AND A2_DOC.A2_LOJA = D1_LOJA "+ENTER
_cQry += "  LEFT JOIN "+RetSqlName('SA2')+" A2_PED ON A2_PED.D_E_L_E_T_ = '' AND A2_PED.A2_FILIAL = '"+xFilial('SA2')+"' AND A2_PED.A2_COD = C7_FORNECE AND A2_PED.A2_LOJA = C7_LOJA "+ENTER
_cQry += "    WHERE SD1.D_E_L_E_T_='' "+ENTER 
_cQry += "      AND D1_TIPO    = 'N' "+ENTER
_cQry += "      AND D1_FILIAL  = '"+SF1->F1_FILIAL+"' "+ENTER
_cQry += "      AND D1_DOC     = '"+SF1->F1_DOC+"' "+ENTER
_cQry += "      AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "+ENTER
_cQry += "      AND D1_LOJA    = '"+SF1->F1_LOJA+"' "+ENTER
_cQry += " ORDER BY D1_ITEM "+ENTER

If Select("_TRB") > 0
	_TRB->(DbCloseArea())
EndIf                                                        
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TRB",.F.,.T.) 	
DbSelectArea("_TRB");_TRB->(dbGoTop()) 
_nMax := Contar('_TRB',"!Eof()"); _TRB->(DbGoTop())

IF _nMax == 0
	Return(_cMsTemp)
ENDIF

//POSICIONA NO CABECALHO DA NOTA DE ENTRADA
DbSelectArea('SF1'); SF1->(DbSetOrder(1)) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
SF1->(DbSeek(xFilial('SF1')+_TRB->D1_DOC+_TRB->D1_SERIE+_TRB->D1_FORNECE+_TRB->D1_LOJA))

Private aMens := {}
Private cCliente := SF1->F1_FORNECE
Private cCliMen  := SF1->F1_FORNECE +"-"+ _TRB->FORNEC_NOTA
Private cLojaCli := SF1->F1_LOJA
Private nOrcam   := SF1->F1_DOC +'/'+SF1->F1_SERIE  
Private dEmiss   := SF1->F1_EMISSAO
Private nAcresc  := 0
Private nAcresc  := 0
Private tTransp  := ""
Private _cMsgObs := ''
		
Private cNumero := _TRB->D1_PEDIDO 					//numero do pedido

//dados da empresa corrente
Private cNomEmp := SM0->M0_NOMECOM					//nome da empresa coorente
Private cEnd    := SM0->M0_ENDENT					//endereco
Private cTel    := SM0->M0_TEL						//telefone
Private cMun    := SM0->M0_CIDENT					//municipio
Private cEst    := SM0->M0_ESTENT					//Estado
Private cCNPJ   := Transform(SM0->M0_CGC,PesqPict("SA1","A1_CGC"))	//cnpj

Private _cMsgRod := 'Gentileza atentar para a divergência apontada abaixo, entre o pedido de compras e o respectivo documento de entrada.'

//POSICIONA NO CLIENTE
DbSelectArea('SA2'); SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial('SA2')+_TRB->D1_FORNECE+_TRB->D1_LOJA))

//dados do Fornecedor
Private cCliente := SA2->A2_COD + " / " + SA2->A2_LOJA		//codigo + loja
Private cNomCli  := SA2->A2_NOME								//razao social do cliente
Private cContato := SA2->A2_CONTATO							//conato
Private cTelCli  := SA2->A2_TEL								//telefone
Private cEndCli  := SA2->A2_END								//Endereco
Private cCEPCli  := Transform( SA2->A2_CEP, "@R 99999-999" )	//cep
Private cFaxCli  := SA2->A2_FAX								//fax
Private cMunCli  := SA2->A2_MUN								//municipio
Private cEstCli  := SA2->A2_EST								//estado
Private cCNPJCli := Transform(SA2->A2_CGC,PesqPict("SA1","A1_CGC"))			//cnpj
Private cIECli   := Transform(SA2->A2_INSCR ,"@R 999.999.999.999") //inscricao estadual

//dados da entrega
Private cEndEnt := (SA2->A2_END)								//endereco de entrega
Private cCEPEnt := (Transform( SA2->A2_CEP, "@R 99999-999" ))	//cep de entrega
Private cMunEnt := (SA2->A2_MUN)								//municipio de entrega
Private cEstEnt := (SA2->A2_EST)								//estado de entrega
Private cTelEnt := (SA2->A2_TEL )								//telefone de entrega
//dados da cobranca
Private cEndCob := (SA2->A2_END)								//endereço de cobrança
Private cCEPCob := (Transform( SA2->A2_CEP, "@R 99999-999" ))	//cep de cobranca
Private cMunCob := (SA2->A2_MUN)								//municipio de cobranca
Private cEstCob := (SA2->A2_EST)								//estado de cobranca
Private cTelCob := (SA2->A2_TEL)								//telefone de cobranca

//Condicao de pagamento
Private cCondPg := ''
Private cDescPg := ''
DbSelectArea('SE4');SE4->(DbSetOrder(1))
IF SE4->(DbSeek(xFilial('SE4')+SF1->F1_COND))
	cCondPg := SE4->E4_CODIGO
	cDescPg := AllTrim(SE4->E4_DESCRI)
ENDIF

//Transportadora
Private cCodTrans := ''; DbSelectArea('SA4');SA4->(DbSetOrder(1))
IF SA4->(DbSeek(xFilial('SE4')+SF1->F1_TRANSP))		
	cCodTrans := AllTrim(SA4->A4_NOME)
ENDIF
		
_cMsTemp := '<html> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<head> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<title>WF Grupo Merc</title> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<style type="text/css"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<!-- '+iIF(_lGrv,ENTER,'')
_cMsTemp += '.style1 { '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	font-family: Arial, Helvetica, sans-serif; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	color: #FF0000; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	font-size: 16px; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '} '+iIF(_lGrv,ENTER,'')
_cMsTemp += '.style3 { '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	font-family: Arial, Helvetica, sans-serif; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	font-size: 10px; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '} '+iIF(_lGrv,ENTER,'')
_cMsTemp += '.style4 {font-family: Arial, Helvetica, sans-serif} '+iIF(_lGrv,ENTER,'')
_cMsTemp += '.style5 {font-size: 10px} '+iIF(_lGrv,ENTER,'')
_cMsTemp += '.style6 { '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	color: #FF0000; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	font-weight: bold; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	font-family: Arial, Helvetica, sans-serif; '+iIF(_lGrv,ENTER,'')
_cMsTemp += '} '+iIF(_lGrv,ENTER,'')
_cMsTemp += '--> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '</style> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '</head> '+iIF(_lGrv,ENTER,'')
_cMsTemp += ' '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<body> '+iIF(_lGrv,ENTER,'')

_cMsTemp += '<br>'
//_cMsTemp += '  <center> '+ '<font face="Arial" size="3" color="#FF0000"><b>'+_cMsgRod+'<b></font>' +' </center> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '<font face="Arial" size="3" color="#FF0000"><b>'+_cMsgRod+'<b></font>'+iIF(_lGrv,ENTER,'')
_cMsTemp += '<br><br>'

_cMsTemp += '  <table width="1055" border="0"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '    <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '      <th bgcolor="#ffffdf" scope="col"><table width="1055" border="0"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        <tr> '+iIF(_lGrv,ENTER,'')

//_cMsTemp += '		  		<th width="0" height="0" scope="col"><p class="style1"><img align=Left src="http://www.merc.com.br/wp-content/uploads/2018/02/merc.jpg" width="250" height="60" hspace="1"> </p>            </th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '		  		<th width="0" height="0" scope="col"><p class="style1"><img src="cid:'+_cDirArq+'" width="250" height="60" hspace="1"> </p>   </th> '+iIF(_lGrv,ENTER,'')

_cMsTemp += '          	<th width="1049" height="71" scope="col"><p class="style1">Workflow - Nota Fiscal de Entrada n.: '+SF1->F1_DOC+' / '+SF1->F1_SERIE+' </p>  </th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	  </th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '      </table> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        <table width="1056" border="0" bgcolor="#FFFFFF"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th width="323" valign="top" bgcolor="#ffffdf" scope="col"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '              <table width="323" border="0"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr valign="top"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="3" class="style3" scope="col"><div align="left">'+cNomEmp+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr valign="top"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="3" class="style3" scope="col"><div align="left">'+cEnd+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr valign="top"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="70" class="style3" scope="col"><div align="left">'+cTel+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="156" class="style3" scope="col"><div align="left">'+cMun+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="63" class="style3" scope="col"><div align="left">'+cEst+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr valign="top"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="3" class="style3" scope="col"><div align="left">'+cCNPJ+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '              </table> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '              <h1 align="left" class="style3">&nbsp;</h1></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th width="697" valign="top" bgcolor="#ffffdf" scope="col"><table width="670" border="0" align="center"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="66" scope="col"><div align="left" class="style4 style5">FORNECEDOR:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="109" scope="col"><div align="left" class="style3">'+cCliente+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="197" scope="col"><div align="left" class="style3">'+cNomCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="39" scope="col"><div align="left" class="style3">Contao:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="107" scope="col"><div align="left" class="style3">'+cContato+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="36" scope="col"><div align="left" class="style3">Tel:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="81" scope="col"><div align="left" class="style3">'+cTelCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th height="22" scope="col"><div align="left" class="style3">End:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="2" scope="col"><div align="left" class="style3">'+cEndCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left" class="style3">CEP:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left" class="style3">'+cCepCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left" class="style3">Fax:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left" class="style3">'+cFaxCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th height="21" scope="col"><div align="left" class="style3">Cidade:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="2" scope="col"><div align="left" class="style3">'+cMunCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left" class="style3">UF:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left" class="style3">'+cEstCli+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left"><span class="style4"><span class="style5"></span></span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left"><span class="style4"><span class="style5"></span></span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th height="21" scope="col"><div align="left"><span class="style3">CNPJ:</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="2" scope="col"><div align="left"><span class="style3">'+cCNPJCli+'</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left"><span class="style3">I.E.:</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left"><span class="style3">'+cIECli+'</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left"></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th scope="col"><div align="left"></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            </table></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        </table> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        <table width="1055" height="96" border="0"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th width="475" height="50" valign="top" bgcolor="#ffffdf" scope="col"><table width="550" border="3" bordercolor="#FFFFFF"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="98" scope="col"><div align="left" class="style3">End.Entrega:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="3" scope="col"><div align="left" class="style3">'+cEndEnt+'</div>                    </th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="64" scope="col"><div align="left" class="style3">CEP:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="59" scope="col"><div align="left" class="style3">'+cCepEnt+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td><div align="left" class="style3">Cidade:</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td width="94"><div align="left" class="style3">'+cMunEnt+'</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td width="26"><div align="left" class="style3">UF:</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td width="86"><div align="left" class="style3">'+cEstEnt+'</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td><div align="left" class="style3">Tel:</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td><div align="left" class="style3">'+cTelEnt+'</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            </table></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th width="517" valign="top" bgcolor="#ffffdf" scope="col"><table width="501" border="3" bordercolor="#FFFFFF"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="114" scope="col"><div align="left" class="style3">End.Cobran&ccedil;a:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th colspan="3" scope="col"><div align="left" class="style3">'+cEndCob+'</div>                    </th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="39" scope="col"><div align="left" class="style3">CEP:</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <th width="83" scope="col"><div align="left" class="style3">'+cCepCob+'</div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td><div align="left" class="style3">Cidade:</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td width="102"><div align="left" class="style3">'+cMunCob+'</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td width="27"><div align="left" class="style3">UF:</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td width="94"><div align="left" class="style3">'+cEstCob+'</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td><div align="left" class="style3">Tel:</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                  <td valign="top"><div align="left" class="style3">'+cTelCob+'</div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            </table>            </th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th height="28" colspan="2" valign="top" bgcolor="#ffffdf" scope="col"><table width="1055" border="3" bordercolor="#FFFFFF"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '              <tr bgcolor="#ffffdf"> '+iIF(_lGrv,ENTER,'')

_cMsTemp += '               <th width="105" scope="col"><div align="left" class="style5"><span class="style4">Cod.Pagamento</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '               <th width="91"  scope="col"><div align="left" class="style5"><span class="style4">'+cCondPg+'</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '               <th width="439" scope="col"><div align="left" class="style5"><span class="style4">'+cDescPg+'</span></div></th> '+iIF(_lGrv,ENTER,'')

_cMsTemp += '   			<th width="105" scope="col"><div align="left" class="style5"><span class="style4">User PED:</span></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '               <th width="200"  scope="col"><div align="left" class="style5"><span class="style4">'+AllTrim(UsrFullName(_TRB->C7_USER))+'</span></div></th>  '+iIF(_lGrv,ENTER,'')
_cMsTemp += '   			<th width="105" scope="col"><div align="left" class="style5"><span class="style4">User NF:</span></div></th>  '+iIF(_lGrv,ENTER,'')
_cMsTemp += '               <th width="200"  scope="col"><div align="left" class="style5"><span class="style4">'+AllTrim(UsrFullName(RetCodUsr()))+'</span></div></th>  '+iIF(_lGrv,ENTER,'')
                
_cMsTemp += '                </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            </table></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        </table> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        <table width="1055" border="3" bordercolor="#FFFFFF"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          <tr bgcolor="#ffffdf"> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '	    <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">ORIGEM</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Item</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Produto</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Descrição</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Ped.Compras</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Item</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Quantidade</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Valor</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <th scope="col"><div align="left"><strong><span class="style4"><span class="style5">Total</span></span></strong></div></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += ' '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += ' '+iIF(_lGrv,ENTER,'')

Do While _TRB->(!Eof())
	_cMsTemp += '	          <tr bgcolor="#FFFFFF"> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '		    <td><div align="left"><span class="style4"><span class="style5"><B>NOTA FISCAL</B></span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->D1ITEM   										+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->D1_COD   										+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->D1_XDESCRI 									+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->D1_PEDIDO 										+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->D1_ITEMPC 										+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ TransForm(_TRB->D1_QUANT,PesqPict('SD1','D1_QUANT')) + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ TransForm(_TRB->D1_VUNIT,PesqPict('SD1','D1_VUNIT')) + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ TransForm(_TRB->D1_TOTAL,PesqPict('SD1','D1_TOTAL')) + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	          </tr> '+iIF(_lGrv,ENTER,'')
	
	IF _TRB->C7_QUANT <> _TRB->D1_QUANT .OR. _TRB->D1_VUNIT <> _TRB->C7_PRECO    
		_cMsTemp += '	          <tr bgcolor="#F8E0E0"> '+iIF(_lGrv,ENTER,'')
		_cStatus := 'DIV'
		_lStatus := .T.
	ELSE
		_cMsTemp += '	          <tr bgcolor="#E3F8E0"> '+iIF(_lGrv,ENTER,'')
		_cStatus := 'OK'
	ENDIF

	_cMsTemp += '		    <td><div align="Right"><span class="style4"><span class="style5"><B>PED.COMPRAS</B></span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5"><b>'+_cStatus+'</b></span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ ''   												+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ '' 													+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->C7_NUM 										+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ _TRB->C7_ITEM 										+ '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	
	IF _TRB->C7_QUANT <> _TRB->D1_QUANT
		_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ '<font color="#FF0000"><b>'+ TransForm(_TRB->C7_QUANT,PesqPict('SC7','C7_QUANT')) +'<b></font>' + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	ELSE
		_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ TransForm(_TRB->C7_QUANT,PesqPict('SC7','C7_QUANT')) + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')	
	ENDIF
	
	IF _TRB->D1_VUNIT <> _TRB->C7_PRECO 
		_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ '<font color="#FF0000"><b>'+ TransForm(_TRB->C7_PRECO,PesqPict('SC7','C7_PRECO')) +'<b></font>' + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')		
	ELSE
		_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ TransForm(_TRB->C7_PRECO,PesqPict('SC7','C7_PRECO')) + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')	
	ENDIF
	
	IF _cStatus == 'DIV'
		_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ '<font color="#FF0000"><b>'+ TransForm(_TRB->C7_TOTAL,PesqPict('SC7','C7_TOTAL')) +'<b></font>' + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	ELSE
		_cMsTemp += '	            <td><div align="left"><span class="style4"><span class="style5">'+ TransForm(_TRB->C7_TOTAL,PesqPict('SC7','C7_TOTAL')) + '</span></span></div></td> '+iIF(_lGrv,ENTER,'')
	ENDIF
	_cMsTemp += '	          </tr> '+iIF(_lGrv,ENTER,'')	
	
	_TRB->(DbSkip())
EndDo

cTotalPrc := TransForm(SF1->F1_VALBRUT,PesqPict('SF1','F1_VALBRUT'))

_cMsTemp += '          <tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <td height="26" colspan="8"><div align="left"><span class="style3">Total Nota Fiscal (c/ impostos)</span></div></td> '+iIF(_lGrv,ENTER,'')
//_cMsTemp += '            <td>&nbsp;</td> '+iIF(_lGrv,ENTER,'')
//_cMsTemp += '            <td><div align="left"></div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '            <td><div align="left"><span class="style3"> <font color="#FF0000"><b>'+cTotalPrc+'<b></font> </span></div></td> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '          </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '        </table></th> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '    </tr> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '  </table> '+iIF(_lGrv,ENTER,'')

IF .F. //!Empty(_cMsgObs)
	_cMsTemp += '	  <table table width="1055" border="3" bordercolor="#ffffdf" bordercolorlight="#ffffdf" '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	    bordercolordark="#ffffdf"> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	    <tr> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	      <td width="100%"><table border="0" width="100%"> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	           '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	          <tr> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            <td width="78%"><font size="2"> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	              <textarea '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	                    name="S1" rows="4" cols="67">'+_cMsgObs+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	               </textarea> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	            </font></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	          </tr> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	
	_cMsTemp += '	      </table></td> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	    </tr> '+iIF(_lGrv,ENTER,'')
	_cMsTemp += '	  </table> '+iIF(_lGrv,ENTER,'')
ENDIF

_cMsTemp += '  <!-- <p align="center" class="style6"> Este or&ccedil;amento cancela e substitui todos os or&ccedil;amentos anteriores </p> --> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '  <center><font face="Arial" size="0.3">*** ATENCAO: MENSAGEM ENVIADA AUTOMATICAMENTE, POR FAVOR NAO RESPONDA ESSE EMAIL***</font></center> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '</form> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '</body> '+iIF(_lGrv,ENTER,'')
_cMsTemp += '</html> '+iIF(_lGrv,ENTER,'')

IF !_lStatus
	_cMsTemp := ''
ENDIF

Return(_cMsTemp)  


/*
USE [protheus12_teste]
GO
CREATE NONCLUSTERED INDEX [SA1010_ALFIN92_1]
ON [dbo].[SE1010] ([E1_FILIAL],[E1_TIPO],[D_E_L_E_T_],[E1_VENCREA],[E1_SALDO])
INCLUDE ([E1_CLIENTE],[E1_LOJA],[E1_VENCORI],[E1_XWFSTTS])
GO
*/
