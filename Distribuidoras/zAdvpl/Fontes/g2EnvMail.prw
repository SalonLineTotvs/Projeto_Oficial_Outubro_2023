#INCLUDE "RWMAKE.CH"
#include "protheus.ch"  
#DEFINE  ENTER CHR(13)+CHR(10)
	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ g2EnvMail º Autor ³ Gnesis/Gustavo 	 º Data ³  06/09/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ WF - Notificação para Email                                  ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
/*/ EXEMPLO
aAnexos := {}
aAdd(aAnexos, "\pasta\arquivo1.pdf")
u_g2EnvMail("teste@genesisconsulting.com.br", "Teste",  "Teste TMailMessage com anexos", aAnexos)
u_g2EnvMail("teste@genesisconsulting.com.br", "Teste2", "Teste TMailMessage", , .T.)
>> Deve-se configurar os parâmetros:
/*/
*------------------------------------------------------------------------------------------------------------------*
User Function g2EnvMail(_cPara,_cCopia,_cCC, _cAssunto, _cCorpo, _aAnexos, _cProc,_lMostraLog, _lUsaTLS, _lMaskFrom)
*------------------------------------------------------------------------------------------------------------------*
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
Local _cStatus     := '1'	//1=Enviado;2=Erro Cfg e-mail;3=Erro Conteudo
Local cContaAuth   := ""
Local cPassAuth    := ""
Local _lRH_WF      := FWIsInCallStack("U_SNWFRAJ")

PRIVATE __lAmb_TST := GetGlbValue('__zAmb_TST') == 'TRUE'

Default _cProc      := "WF | "+AllTrim(FWFilialName())
Default _cPara      := ""
Default _cCopia     := ""
Default _cCC        := ""
Default _cAssunto   := ""
Default _cCorpo     := ""
Default _aAnexos    := {}
Default _lMostraLog := .F.
Default _lUsaTLS    := .T.

IF __lAmb_TST .And. Upper(GetEnvServer()) <> 'JOB'
	MsgInfo('Base teste diagnosticada, e-mail será enviado para ADM TI','Controle de Ambiente')
	_cPara    := GetMV('GN_RPOTEST',.F.,'gustavo@gsconsulti.com.br')
	_cAssunto := AllTrim(_cAssunto)+' >> TESTE <<'
ENDIF

//Se tiver em branco o destinatário, o assunto ou o corpo do email
If Empty(_cPara) .Or. Empty(_cAssunto) .Or. Empty(_cCorpo)
	_cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
	_lWfRet := .F.
EndIf

//Log de envio OK
_cLogOk := 	"+--[ OK ]-----------------| SEND E-MAIL |--------------------+" + CRLF + ;
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

		ELSEIF _lRH_WF //Caso for processo do RH
			IF !Empty(_cMailUsr  := Alltrim(GetMV('SN_MLWFRAJ',.F.,'xxxx@xxxx.com.br')))
				//Caso contenha o @dominio cadastrado no e-mail do usuario fara substituicao do 'FROM'
				_cDomin := SubStr(AllTrim(cFrom),At('@',AllTrim(cFrom))+1,Len(cFrom))
				IF ( _cDomin $ _cMailUsr)
					//Desabilitado por conta do office365
					cFrom := _cMailUsr
				ENDIF		
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
	//_cPara:= "tiago.santosjob@gmail.com"
	oMsg:cTo      := _cPara
	oMsg:cSubject := _cAssunto
	oMsg:cBody    := _cCorpo
	
	IF !Empty(_cCopia)	//Com Cópia
		oMsg:cCC := _cCopia
	ENDIF
	IF !Empty(_cCC)		//Com Cópia Oculta
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
		_lWfRet  := .F.
		 
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
			_lWfRet  := .F.
			_cStatus := '2' //2=Erro Cfg e-mail
		EndIf
		
		If _lWfRet
			//Realiza a autenticação do usuário e senha
			nRet := oSrv:SmtpAuth(cContaAuth, cPassAuth)
			If nRet <> 0
				_cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				_lWfRet  := .F.
				_cStatus := '2' //2=Erro Cfg e-mail
			EndIf
			
			If _lWfRet
				//Envia a mensagem
				nRet := oMsg:Send(oSrv)
				If nRet <> 0
					_cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
					_lWfRet  := .F.
					_cStatus := '3' //3=Erro Conteudo
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
	_cStatus := '2'
	_cLog := 	"+--[ERRO]-----------------| SEND E-MAIL |--------------------+" + CRLF + ;
				"Envio     - " + dToC(Date())+ " " + Time() + CRLF + ;
				"Funcao    - " + FunName() + CRLF + ;
				"Processos - " + _cProc + CRLF + ;
				"De - " + cFrom + CRLF + ;
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

Return({_lWfRet,_cLog,_cStatus,cFrom})
