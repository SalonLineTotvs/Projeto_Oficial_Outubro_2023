#INCLUDE "RPTDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
/*                                                                                                                                                       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SendMail ³ Autor ³ Genilson Moreira Lucas  ³ Data ³ 01/02/2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para enviar e-mail configura para Salon Line.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³ Data       ³            Motivo da Alteracao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³		         ³ 			  ³ N/A		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
			//U_SendMail( cMail,_cTo,, cAssunto, cBody, )
User Function SendMail( cPara, cCopia, cOculCop, cAssunto, cBody,cAnexo )
	Local oServer		:= NIL
	Local oMessage 		:= NIL   
	Local oXml			:= NIL				/* teste */		
	Local cError        := ""   	     	/* teste */
	Local cAviso        := ""       	 	/* teste */
	Local cWarning		:= ""				/* teste */
	Local nret			:= 0
	Local cSMTPServer	:= SuperGetMv( "MV_RELSERV" )//"smtp-relay.gmail.com" //SuperGetMv( "MV_RELSERV" )
	Local cAccount 		:= SuperGetMv( "MV_RELACNT" )
	Local cPass 		:= SuperGetMv( "MV_RELPSW" )
	Local lAuth			:= SuperGetMV("MV_RELAUTH",,.F.)
	Local cUser			:= SuperGetMv( "MV_RELACNT" )
	Local cPort 		:= "587" //SuperGetMv( "MV_SHPORT","587",.T. )
	Local nTimeout		:= 60

	oServer := TMailManager():New()
	oServer:SetUseTLS(.T.)
	oServer:Init( "", cSMTPServer, cAccount, cPass, 0, val( cPort ) )
	IF( nTimeout <= 0 )
		conout( "[TIMEOUT] DISABLE" )
	ELSE
		conout( "[TIMEOUT] ENABLE()" )
		nRet := oServer:SetSmtpTimeOut( 120 )
		IF nRet != 0
			conout( "[TIMEOUT] Fail to set" )
			conout( "[TIMEOUT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
			Return .F.
		EndIF
	EndiF
	Conout( "[SMTPCONNECT] connecting ..." )
	nRet := oServer:SmtpConnect()
	IF nRet != 0
		conout( "[SMTPCONNECT] Falha ao conectar" )
		conout( "[SMTPCONNECT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
		Return .F.
	ELSE
		conout( "[SMTPCONNECT] Sucesso ao conectar" )
	EndIF
	IF lAuth
		conout( "[AUTH] ENABLE" )
		conout( "[AUTH] TRY with ACCOUNT() and PASS()" )
		// try with account and pass
		nRet := oServer:SMTPAuth( cAccount, cPass )
		IF nRet != 0
			conout( "[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			conout( "[AUTH][ERROR] " + str(nRet,6) , oServer:GetErrorString( nRet ) )
			conout( "[AUTH] TRY with USER() and PASS()" )
			// try with user and pass
			nRet := oServer:SMTPAuth( cUser, cPass )
			IF nRet != 0
				conout( "[AUTH] FAIL TRY with USER() and PASS()" )
				conout( "[AUTH][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
				Return .F.
			ELSE
				conout( "[AUTH] SUCEEDED TRY with USER() and PASS()" )
			EndIF
		ELSE
			conout( "[AUTH] SUCEEDED TRY with ACCOUNT and PASS" )
		EndIF
	ELSE
		conout( "[AUTH] DISABLE" )
	EndIF
	conout( "[MESSAGE] Criando mail message" )
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom          := cAccount
	oMessage:cTo            := cPara
	oMessage:cCc            := cCopia
	oMessage:cBcc           := cOculCop
	oMessage:cSubject       := cAssunto
	oMessage:cBody	 		:= cBody	
//	oMessage:GetAttachCount() 
	oMessage:GetAttach(1,cAnexo)
	
	conout( "[SEND] Sending ..." )
	nRet := oMessage:Send( oServer )
	IF nRet != 0
		conout( "[SEND] Fail to send message" )
		conout( "[SEND][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
	ELSE
		conout( "[SEND] Success to send message" )
	EndIF
	conout( "[DISCONNECT] smtp disconnecting ... " )
	nRet := oServer:SmtpDisconnect()
	IF nRet != 0
		conout( "[DISCONNECT] Fail smtp disconnecting ... " )
		conout( "[DISCONNECT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
	ELSE
		conout( "[DISCONNECT] Success smtp disconnecting ... " )
	EndIF
Return()
