#include "rwmake.ch"
#INCLUDE "protheus.ch"
#Include "TOPCONN.CH"
#INCLUDE "SPEDNFE.ch"                     	
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#Include "AP5Mail.ch"

#DEFINE TAMMAXXML 400000 //- Tamanho maximo do XML em  bytes
#DEFINE VBOX       080
#DEFINE HMARGEM    030
#DEFINE _EOL chr(13) + chr(10)

#DEFINE ENTER CHR(13) + CHR(10)

/*------------------------------------------------------------------------//
//Programa:	 MCFATA03
//Autor:     Genesis / Gustavo Markx
//Data:		 25/06/2019
//Descricao: Envio de Danfe, .XML e Boleto para clientes na impressão da Danfe.
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
*---------------------------------------------------------------*
User Function MCFATA03(_cFil, _cFilOri, cNum, cPrefixo, aFilePDF,cNumNfes)               
*---------------------------------------------------------------*
Local _cBkEmp 		:= cEmpAnt
Local _cBkFil 		:= cFilAnt
Local _lTrocaFil 	:= _cFilOri <> cFilAnt
Local _cChave       := ''
Local _cChaveNfe    := ''
Local _cDirXml 		:= ''
Private _aEmp       := {}

If .T.//cFilAnt ==  _cFil .Or. Empty(_cFil)

	_cToEmp := cEmpAnt
	_cToFil := _cFilOri

	//ChangeEmp(_cToEmp, _cToFil, @_lTrocaFil) //EMPRESA - Abre empresa DESTINO
		_aEmp		:= xEmpFil(cFilAnt)
	/*Envio de XML e Danfe
	IF Empty(cNumNfes)
		_cDirXml   	:= u_zSpedXML(cNum, cPrefixo, @_cChaveNfe,Nil,Nil) //--Gerando arquivo .XML da NF-e em questao
		_cDirDanfe  := u_zGerDanfe(cNum,cPrefixo,,@aFilePDF)
	Endif	
	*/
		MCFATA03B(_cFil,_cFilOri,cNum,cPrefixo,aFilePDF,_cChave,_cDirXml,_cChaveNfe,cNumNfes) //--Enviando E-mail com .XML e Boleto Anexado
	//ChangeEmp(_cBkEmp, _cBkFil, @_lTrocaFil) //EMPRESA - Retorna empresa ORIGEM

Else
	Msginfo("Filial Logada "+cFilAnt+" Filial boleto "+_cFil+". Não é possivel envio de boleto e xml para documento diferente da filial logada.", "Envia XML Cliente" )
EndIf

Return()

*-------------------------------------------------------*
Static Function ChangeEmp(_cAbreEmp,_cAbreFil,_lTrocaFil)
*-------------------------------------------------------*
//DbcloseAll()
cEmpAnt := _cAbreEmp
cFilAnt := _cAbreFil 

IF _lTrocaFil
	OpenSM0(_cAbreEmp,.F.)
	OpenFile(_cAbreEmp+_cAbreFil)
	_lTrocaFil := .T.
ENDIF

//RPCClearEnv()
//RPCSetEnv(_cEmp, _cFil)
Return

/*------------------------------------------------------------------------//
//Programa:	 MCFATA03A
//Autor:     Renato Pereira
//Data:		 25/06/2019
//Descricao: Gerador de .XML dos documentos fiscais espécie SPED
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
Static Function MCFATA03A(_cFil,_cFilOri,cNum,cPrefixo)

Local _aAux   := {}
Local i       := 0
Local _aParam := {cEmpAnt,_cFil,cPrefixo,cNum}

DbSelectArea("SF2"); SF2->(DbSetOrder(1))
IF SF2->(Dbseek(xFilial('SF2') + Padr(cNum,9) + cPrefixo))
//If SF2->(Found())
	If Alltrim(SF2->F2_ESPECIE) <> 'RPS' //--RPS não terá exportação e envio de .xml
		SpedExport(1,cPrefixo,cNum)
	EndIf
Else
	Msginfo("Nota Fiscal " + cNum + " - " + cPrefixo + " não encontrada!!!", "Envia XML Cliente" )
Endif

Return(SF2->F2_CHVNFE)

/*------------------------------------------------------------------------//
//Programa:	 MCFATA03B
//Autor:     Renato Pereira
//Data:		 25/06/2019
//Descricao: Envio de E-mail para clientes
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
Static Function MCFATA03B(_cFil,_cFilOri,cNum,cPrefixo,aFilePDF,_cChave,_cDirXml,_cChaveNfe,cNumNfes)
Local lRet        := .F.
Local cMailConta  := ''
Local cMailServer := ''
Local cMailSenha  := ''
Local cMailCtaAut := ''
Local cAttach     := ''
Local lSmtpAuth   := GetMv("MC_F03AUTH",,.F.)
Local lSmtpTLS    := GetMv("MC_F03TLS",,.F.)
Local lSmtpSSL    := GetMv("MC_F03SSL",,.F.)
Local cDest       := ''
Local cCc		  := ''
Local cBcc		  := AllTrim(GetMV('SN_BOL_CCO',.F.,''))
Local cSubject    := ''
Local cBody       := ''
Local lSendOk     := .F.
Local lOk         := .F.
Local lAuthOk     := .F.
Local lColor      := .F.

Local cCodUser    := ''
Local aAllUsers   := {}
Local cCodArea    := ''
Local nPos        := 0
Local nCount      := 0
Local _aFiles	  := {}
Local cFile		  := '\xmlnf\'
Local cMsgMail    := 'MENSAGEM DE TESTE'
Local _aEmail     := {}
Local _aAnexo 	  := {}
Local _lGrv 	  := .F.
Local _n1         := 0
Local _nF         := 0
Private _cRodapeAss := ''
Private _cAlFinAss  := 'Logo'+cFilAnt+'.png' 
Private _cIniFile  := GetADV97()
Private _cDirLoad  := GetPvProfString(GetEnvServer(),"StartPath","ERROR", _cIniFile )

//--Recupera os parametros para envio
//--do e-mail:
cMailConta  := GETMV('MC_F03CNT',, '')
cMailServer := GETMV('MC_F03SERV',, '')
cMailSenha  := GETMV('MC_F03PSW',, '')
cMailCtaAut := If(Empty(GETMV("MC_F03CNT",, '')), cMailConta, GETMV("MC_F03CNT",, ''))

//Posiciona na nota fiscal para trazer dados do cliente
DbSelectArea("SF2"); SF2->(DbSetOrder(1))
//SF2->(Dbseek(_cFil+Padr(cNum,9)+cPrefixo))
_lSF2 := SF2->(Dbseek(xFilial('SF2')+Padr(cNum,9)+cPrefixo))

DbSelectArea("SA1"); SA1->(DbSetOrder(1))
_lSA1 := SA1->(Dbseek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))


cDest := AllTrim(SA1->A1_X_MAILC)//AllTrim(SA1->A1_EMAIL)  //Inserir aqui regra dos e-mails que serão notificados.
cDest := cDest+'; '+cBcc 
//cDest := 'gustavo@gsconsulti.com.br'//; cBcc  := ''

If !Empty(cDest) .And. _lSA1
	
	//Lista de email´s (Logistica) que receberao em copia oculta o email enviado ao cliente
	_aSM0 := SM0->(GetArea())
	SM0->( dbSeek( cEmpAnt + SF2->F2_FILIAL ))

	If Alltrim(SF2->F2_ESPECIE) <> 'RPS' //--RPS não deve levar o numero da NFS-e
		cSubject := Alltrim(SM0->M0_FILIAL)+' - Boleto NF-e : ' +cNum
	Else
		cSubject := Alltrim(SM0->M0_FILIAL)+' - Boleto NFS-e : ' +StrZero(Val(cNumNfes),9)
	Endif
	SM0->(RestArea(_aSM0))
	
	//Anexando XML ao email
	//ADIR(cFile+"*"+Alltrim(SM0->M0_CGC)+'55'+cPrefixo+Strzero(Val(cNum),9)+"*.XML",_aFiles)
	//cAttach := cFile+_aFiles[1]
	
	//--Formata o e-mail para envio:
	cBody := ''

	cBody += " <html><body> "+iIF(_lGrv,ENTER,'')
	cBody += " <title>@ Boleto Salon</title> "+iIF(_lGrv,ENTER,'')
	cBody += ' <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> '+iIF(_lGrv,ENTER,'')
	cBody += " <style type='text/css'> "+iIF(_lGrv,ENTER,'')
	cBody += " 	td.tabela 	{ "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-size: 10px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-family: verdana,tahoma,arial,sans-serif; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-width: 1px;  "+iIF(_lGrv,ENTER,'')
	cBody += " 					padding: 0px;  "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-style: dotted; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-color: gray;  "+iIF(_lGrv,ENTER,'')
	cBody += " 					-moz-border-radius: ;  "+iIF(_lGrv,ENTER,'')
	cBody += " 				} "+iIF(_lGrv,ENTER,'')
	cBody += " 	td.tabela2	{ "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-size: 10px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-family: verdana,tahoma,arial,sans-serif; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-width: 1px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					padding: 0px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-style: dotted; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-color: gray; "+iIF(_lGrv,ENTER,'')
	cBody += " 					-moz-border-radius: ;;"+iIF(_lGrv,ENTER,'')
	cBody += " 					font-color: blue; "+iIF(_lGrv,ENTER,'')
	cBody += " 				}"+iIF(_lGrv,ENTER,'')
	cBody += " 	td.xl24   	{	mso-style-parent:style0; "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-size: 10px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					mso-number-format:\@; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-width: 1px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					padding: 0px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-style: dotted; "+iIF(_lGrv,ENTER,'')
	cBody += " 					border-color: gray; "+iIF(_lGrv,ENTER,'')
	cBody += " 					-moz-border-radius: ; "+iIF(_lGrv,ENTER,'')
	cBody += " 				}"+iIF(_lGrv,ENTER,'')
	cBody += " 	td.titulo 	{"+iIF(_lGrv,ENTER,'')
	cBody += " 					font-size: 13px; "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-family: verdana,tahoma,arial,sans-serif; "+iIF(_lGrv,ENTER,'')
	cBody += " 					font-weight: bold; "+iIF(_lGrv,ENTER,'')
	cBody += " 					padding: 0px; "+iIF(_lGrv,ENTER,'')
	cBody += " 				}"+iIF(_lGrv,ENTER,'')
	cBody += " </style>"+iIF(_lGrv,ENTER,'')
	cBody += " "+iIF(_lGrv,ENTER,'')

	cBody += '  <br><br> '+iIF(_lGrv,ENTER,'')

	cBody += ' '+iIF(_lGrv,ENTER,'')
	cBody += ' <body>'+iIF(_lGrv,ENTER,'')
	cBody += ' '+iIF(_lGrv,ENTER,'')
	//cBody += ' <table Border="0" Width="800" align="center">'+iIF(_lGrv,ENTER,'') // comentado LH SALONLINE
	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	cBody += '     </tr>'+iIF(_lGrv,ENTER,'')
	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	//cBody += '         <td Colspan="2" Rowspan="4">  </td>'+iIF(_lGrv,ENTER,'')
	IF File(_cDirLoad + _cAlFinAss)
		cBody += '	<td Colspan="4" Rowspan="4" Width="150"> <img src="cid:'+_cAlFinAss+'" height="80" width="250"> </td> '+iIF(_lGrv,ENTER,'')
		aadd(_aAnexo, _cDirLoad+_cAlFinAss)
	Else
		_cLinkL := RetLogo(cFilAnt) 
		cBody += '	<td Colspan="4" Rowspan="4" Width="150"> <img Src="'+_cLinkL+'" width="250"> </td>		'+iIF(_lGrv,ENTER,'')
	ENDIF
	cBody += '     </tr>'+iIF(_lGrv,ENTER,'')
	_cSite  := RetSite(cFilAnt)
	// cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	// //cBody += '     <td Colspan="6" align="center"><font face = "Courier New" size="4" ><b>'+ AllTrim(_aEmp[1]) +'</b></font></th>'+iIF(_lGrv,ENTER,'')
	// cBody += '     <td><font face = "Courier New" size="4" ><b><center>'+ AllTrim(_aEmp[1]) +'</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	// //cBody += '     <td><font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#FF0000"><b><center>Mensagem automatica, favor n&atilde;o responder este e-mail.</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	// /*cBody += '     </tr>'+iIF(_lGrv,ENTER,'')
	// cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	// cBody += '         <td Colspan="6"><div align="center" class="style3"><font Face="Arial" Size="2">'+ OemToAnsi( AllTrim(_aEmp[2])+' - '+AllTrim(_aEmp[3])+' - ' + AllTrim(_aEmp[4])+' - '+AllTrim(_aEmp[5])+' - CEP.: '+AllTrim(_aEmp[6])) +'</font></td>'+iIF(_lGrv,ENTER,'')
	// */
	// cBody += '     </tr>'+iIF(_lGrv,ENTER,'')

	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '     <td><font face = "Courier New" size="4" color="WHITE"><b><center>'+ AllTrim(_aEmp[1]) +'</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')

	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	//cBody += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" >'+ OemToAnsi('CNPJ: '+AllTrim(_aEmp[9]) +' - I.E.: '+AllTrim(_aEmp[8]) ) +'</font></td>'+iIF(_lGrv,ENTER,'')
	cBody += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" color="WHITE"><center>'+ OemToAnsi('CNPJ: '+AllTrim(_aEmp[9]) )+'</center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody += '    </tr>'+iIF(_lGrv,ENTER,'')

	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	cBody += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" color="WHITE"><center>Fone: 55-</center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody += ' 	</tr>'+iIF(_lGrv,ENTER,'')

	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	cBody += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" color="WHITE"><center>Mensagem automatica, favor n&atilde;o responder este e-mail.</center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody += ' 	</tr>'+iIF(_lGrv,ENTER,'')

	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '     	   <td Colspan="6"><div align="center"class="style3"><font face="Arial" size="3" color="#FF0000"><b><center>Para visualizar o Boleto utilize a senha: S mais os 5 primeiros dígitos do seu CNPJ</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')

	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '     	   <td Colspan="6"><div align="center"class="style3"><font face = "Courier New" size="4" ><b><center>'+ AllTrim(_aEmp[1]) +'</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')

	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	cBody += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" ><center>'+ OemToAnsi('CNPJ: '+AllTrim(_aEmp[9]) )+'</center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody += '    </tr>'+iIF(_lGrv,ENTER,'')
	
	cBody += '     <tr>'+iIF(_lGrv,ENTER,'')
	cBody += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" ><center>Site: '+_cSite+'</center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody += ' 	</tr>'+iIF(_lGrv,ENTER,'')



	//	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	//cBody += '     </tr>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// cBody += '     <td><font face = "Courier New" size="4" ><b><center>'+ AllTrim(_aEmp[1]) +'</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')

	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')	
	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="#FF0000"><b><center>Mensagem automatica, favor n&atilde;o responder este e-mail.</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	//cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	If cFilAnt == '0101' 
	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="BLACK"><center>Caso tenha alguma dúvida, entre em contato conosco por meio do e-mail cobranca@salonline.com.br</center></font></td>'+iIF(_lGrv,ENTER,'')
		cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="BLACK"><center>ou no telefone (11) 4210-5959  </center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	Elseif cFilAnt == '0201'
	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="BLACK"><center>Caso tenha alguma dúvida, entre em contato conosco por meio do e-mail cobranca@salonline.com.br</center></font></td>'+iIF(_lGrv,ENTER,'')
		cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="BLACK"><center>ou no telefone (11) 4210-5959  </center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	Else
	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="BLACK"><center>Caso tenha alguma dúvida, entre em contato conosco por meio do e-mail cobranca@salonline.com.br</center></font></td>'+iIF(_lGrv,ENTER,'')
		cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
		cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="2" color="BLACK"><center>ou no telefone (11) 4210-5959  </center></font></td>'+iIF(_lGrv,ENTER,'')
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	Endif	


	//cBody += ' </table>'+iIF(_lGrv,ENTER,'') //comentado LH SALONLINE
	cBody += '  '+iIF(_lGrv,ENTER,'')
	cBody += '<br><br>'+iIF(_lGrv,ENTER,'')
/*
	cBody += '<table style="width: 1238px; background-color: rgb(247, 247, 247); text-align: left; margin-left: auto; margin-right: auto;" border="1" bordercolor="#e5e5e5" cellpadding="6" cellspacing="0" align="center">'+iIF(_lGrv,ENTER,'')
	cBody += '<tbody>'+iIF(_lGrv,ENTER,'')
	cBody += '<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '  <td style="border: 1px solid rgb(192, 192, 192); width: 1224px;" class="titulo TituloMenor TituloDestaques" bordercolor="#FFFFFF">'+iIF(_lGrv,ENTER,'')
	cBody += '  <table style="height: 25px; width: 100%;" border="0" cellpadding="2" cellspacing="1">'+iIF(_lGrv,ENTER,'')
	cBody += '  <tbody>'+iIF(_lGrv,ENTER,'')
	IF Empty(SA1->A1_NREDUZ)
		cBody += '	<tr>Sr.(a) Cliente,'+iIF(_lGrv,ENTER,'')
	ELSE
		cBody += '	<tr>Olá '+AllTrim(Capital(SA1->A1_NREDUZ))+','+iIF(_lGrv,ENTER,'')
	Endif	
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '  <tbody>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	
	If Alltrim(SF2->F2_ESPECIE) <> 'RPS' //--RPS não terá exportação e envio de .xml
   		cBody += '  <td width="60%">Em anexo Boleto e XML, de acordo com faturamento abaixo:'+iIF(_lGrv,ENTER,'')
	Else
   		cBody += '  <td width="60%">Em anexo Boleto, de acordo com faturamento abaixo:'+iIF(_lGrv,ENTER,'')
	EndIf
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += ' <td width="20%">Cliente: </td>'+iIF(_lGrv,ENTER,'')
	cBody += ' <td width="80%">['+ALLTRIM(SA1->A1_NOME)+']</td>'+iIF(_lGrv,ENTER,'')
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '		<td width="20%">'+If(SA1->A1_PESSOA='J','CNPJ','CPF')+': </td>'+iIF(_lGrv,ENTER,'')
	cBody += '		<td width="80%">['+Transform(ALLTRIM(SA1->A1_CGC),If(SA1->A1_PESSOA='J',"@R 99.999.999/9999-99","@R 999.999.999-99"))+']</td>'+iIF(_lGrv,ENTER,'')
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	If Alltrim(SF2->F2_ESPECIE) <> 'RPS'
		cBody += '		<td width="20%">Chave de Acesso: </td>'+iIF(_lGrv,ENTER,'')
		cBody += '		<td width="80%">[NF-e: '+SF2->F2_CHVNFE+']</td>'+iIF(_lGrv,ENTER,'')
	Else
		cBody += '		<td width="20%">NF de Serviços Eletrônica: </td>'+iIF(_lGrv,ENTER,'')
		cBody += '		<td width="80%">[NFS-e: '+StrZero(Val(SF2->F2_NFELETR),9)+']</td>'+iIF(_lGrv,ENTER,'')
	Endif
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '		<td>&nbsp;</td>'+iIF(_lGrv,ENTER,'')
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '		<td width="20%">Faturamento: </td>'+iIF(_lGrv,ENTER,'')
	cBody += '		<td width="80%">'+Dtoc(SF2->F2_EMISSAO)+'</td>'+iIF(_lGrv,ENTER,'')
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '	<tr>'+iIF(_lGrv,ENTER,'')
	cBody += '		<td>&nbsp;</td>'+iIF(_lGrv,ENTER,'')
	cBody += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '</tbody>'+iIF(_lGrv,ENTER,'')
	cBody += '</table>'+iIF(_lGrv,ENTER,'')
	cBody += '</tr>'+iIF(_lGrv,ENTER,'')
	cBody += '</tbody>'+iIF(_lGrv,ENTER,'')
	cBody += '</table>'+iIF(_lGrv,ENTER,'')
	cBody += '<br><br>'+iIF(_lGrv,ENTER,'')
*/
	//cBody  += '	</tr>'+iIF(_lGrv,ENTER,'') //COMENTADO LH SALONLINE
	// cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// cBody += '     </tr>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// cBody += '     <td><font face = "Courier New" size="4" ><b><center>'+ AllTrim(_aEmp[1]) +'</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')	
	// cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="#FF0000"><b><center>'+'        '+'Mensagem automatica, favor n&atilde;o responder este e-mail.</center></b></font></td>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	// cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// If cFilAnt == '0101' 
	// 	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="BLACK"><center>'+'        '+'Caso tenha alguma dúvida, entre em contato conosco por meio do e-mail cobranca@salonline.com.br</center></font></td>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="BLACK"><center>'+'        '+'ou no telefone (11) 4210-5959  </center></font></td>'+iIF(_lGrv,ENTER,'')
	// Elseif cFilAnt == '0201'
	// 	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="BLACK"><center>'+'        '+'Caso tenha alguma dúvida, entre em contato conosco por meio do e-mail cobranca@salonline.com.br</center></font></td>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="BLACK"><center>'+'        '+'ou no telefone (11) 4210-5959  </center></font></td>'+iIF(_lGrv,ENTER,'')
	// Else
	// 	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="BLACK"><center>'+'        '+'Caso tenha alguma dúvida, entre em contato conosco por meio do e-mail cobranca@salonline.com.br</center></font></td>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '	<tr>'+iIF(_lGrv,ENTER,'')
	// 	cBody  += '		<td Colspan="6"><div align="center" class="style3"><font face="Arial" size="-2" color="BLACK"><center>'+'        '+'ou no telefone (11) 4210-5959  </center></font></td>'+iIF(_lGrv,ENTER,'')
	// Endif	
	
	cBody  += '	</tr>'+iIF(_lGrv,ENTER,'')
	cBody  += '</html>'+iIF(_lGrv,ENTER,'')

	cAccount    := cMailConta
	cPassword   := cMailSenha
	cServer     := cMailServer
	cFrom       := cMailConta
	lSMTPauth   := lSmtpAuth
	
	cEmailTo :=alltrim(cDest)  //Destinatários   "luiz.vasconcelos@salonline.com.br"
	cEmailCc := cCc	            //Com cópia
	cEmailBcc:= cBcc		    //Com cópia oculta

	//Adiciona um attach caso espécie do documento seja diferente de "RPS" 
	nRegXML := 0 
	If Alltrim(SF2->F2_ESPECIE) <> 'RPS' //--RPS não terá exportação e envio de .xml
	//	aadd(aFilePDF,{cFile+_cChave+"-nfe.XML",cFile+_cChave+"-nfe.XML"})  // adiciona o XML   -- Voltar aqui
	//	nRegXML := 1
	EndIf

	If Len(aFilePDF) > 0
		For _n1=1 to len(aFilePDF)
			//--Copia o arquivo para o servidor o arquivo do boleto
			If _n1 <= Len(aFilePDF)//-nRegXML//--Tratamento para que não considere o ultimo registro do array, pois se trata do .xml
				cCaminho := aFilePDF[_N1][1]
				cCaminho2:= aFilePDF[_N1][2]
				//CpyT2S(cCaminho,'\spool\',.T.)
				//CpyT2S(cCaminho,'\spool\')
				u_TSTCOPY()

				// FUNÇÃO PRINCIPAL
				u_T151FWMSG()
	
					////////////////////////////////////
					// 				files := {'\spool\'+aFilePDF[_N1][2]}
					
					// nret := FZip("\boleto"+alltrim(str(_N1))+".zip",files)
					// if nret!=0
					// 	conout("Não foi possível criar o arquivo zip")
					// else
					// 	conout("Arquivo zip criado com sucesso")
					// endif
					
					// nret := FZip("\spool\boleto"+alltrim(str(_N1))+".zip",files,"\spool\","123456")
					// if nret!=0
					// 	conout("Não foi possível criar o arquivo zip")
					// else
					// 	conout("Arquivo zip criado com sucesso")
					// endif
					//////////////////////////////////
				//__CopyFile(cCaminho, cCaminho+cArquivo+"2")
				aFilePDF[_N1][2] := '\x_arquivos\'+aFilePDF[_N1][2]
			EndIf
			IF File(aFilePDF[_N1][2])
				//aadd(_aAnexo, "\spool\boleto"+alltrim(str(_N1))+".zip")
				aadd(_aAnexo, aFilePDF[_N1][2] )
			ENDIF
			//If oMessage:AttachFile(aFilePDF[_N1][2]) < 0
			//	Alert( "Erro ao atachar o arquivo" )
			//	Return .F.
			//EndIf
		Next
	EndIf


	//Anexo - Arquivo do XML////
	IF !EMPTY(_cDirXml)
		IF File(_cDirXml)
			aadd(_aAnexo, _cDirXml)
		ENDIF
	ENDIF
	_cCopia   	:= cEmailCc		//Copia
	_cCC  		:= cEmailBcc	//Copia Oculta
	_cHeader	:= cSubject 	//Assunto
	_cCorpo 	:= cBody 		//cMensagem
	_cTo 		:= cEmailTo //"luiz.vasconcelos@salonline.com.br"//cEmailTo		//Destino
	_aSendo   	:= u_g2EnvMail(_cTo,_cCopia,_cCC, _cHeader, _cCorpo, _aAnexo,'', .F., ,.F.)
	_lSend    	:= _aSendo[1]
	_cLogMail 	:= AllTrim(_aSendo[2])

	//Apaga todos os arquivos de Anexo
	For _nF:=1 To Len(_aAnexo)
		IF !('.png' $ _aAnexo[_nF]) .And. !('C:\Boleto' $ _aAnexo[_nF])
			FErase(_aAnexo[_nF])
		ENDIF
		//FErase(_cDirXml)
	Next
	//Apaga todos os arquivos temporario
	For _nF:=1 To Len(aFilePDF)
		IF !('.png' $ aFilePDF[_nF,1]) .And. !('C:\Boleto' $ aFilePDF[_nF,1])
			FErase(aFilePDF[_nF,1])
		ENDIF
		IF !('.png' $ aFilePDF[_nF,2]) .And. !('C:\Boleto' $ aFilePDF[_nF,2])
			FErase(aFilePDF[_nF,2])
		ENDIF
	Next
	
EndIf
Return


					User function T151FWMSG()
							Local oSay := NIL // CAIXA DE DIÁLOGO GERADA

							// GERA A TELA DE PROCESSAMENTO
							FwMsgRun(NIL, {|oSay| RunMessage(oSay)}, "Processing", "Starting process...")
						Return (NIL)

						// FUNÇÃO PARA ALTERAÇÃO DA MENSAGEM
						Static Function RunMessage(oSay)
							Local nX := 0 // CONTROLE CONTADOR DO LAÇO

							// SIMULA A PREPARAÇÃO PARA EXECUÇÃO
							Sleep(1000)

							// LAÇO COM PAUSA DE UM SEGUNDO PARA SIMULAÇÃO
							For nX := 1 To 1
								oSay:SetText("Working at: " + StrZero(nX, 6)) // ALTERA O TEXTO CORRETO
								ProcessMessages() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

								Sleep(1000) // SIMULA O PROCESSAMENTO DA FUNÇÃO
							Next nX
						Return (NIL)

						User Function TSTCOPY()
local lRet := .F.

lRet := __CopyFile(cCaminho, "\x_arquivos\"+ccaminho2,,,.F.)

If lRet
 //Alert("Arquivo copiado com sucesso")
Else
 Alert("Arquivo não copiado")
EndIf

Return
/*------------------------------------------------------------------------//
//Programa:	 SpedExport
//Autor:     TOTVS S/A
//Data:		 25/06/2019
//Descricao: Rotina complementar para exportar .XML
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
Static Function SpedExport(nTipo,cPrefixo,cNum)

Local cIdEnt   := ""
Local aPerg    := {}
Local aParam   := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(60),CToD(""),CToD(""),Space(14),Space(14)}
Local cParNfeExp := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEEXP"
Local lObrigat := .F.

DEFAULT nTipo  := 1

cNum :=cNum
cDirDest :='\xmlnf\'
dDatade  :=CTOD("01/01/10")
dDataAte :=CTOD("31/12/49")
cCnpjDIni:= ""
cCnpjDFim:= "ZZZZZZZZZZZZZZ"

lRet := ExistDir("\xmlnf")
nRet := 0

If !lRet
	nRet := MakeDir("\xmlnf")
	If nRet != 0
		MsgInfo ( "Não foi possível criar o diretório - \xmlnf. Erro: " + cValToChar( FError() ) )
	EndIf
Endif

//

lObrigat:=If(nTipo == 2,lObrigat:=.F.,.T.)

aParam[01] := cPrefixo   //ParamLoad(cParNfeExp,aPerg,1,aParam[01])
aParam[02] := cNum //ParamLoad(cParNfeExp,aPerg,2,aParam[02])
aParam[03] := cNum //ParamLoad(cParNfeExp,aPerg,3,aParam[03])
aParam[04] := cDirDest //ParamLoad(cParNfeExp,aPerg,4,aParam[04])
aParam[05] := dDatade //ParamLoad(cParNfeExp,aPerg,5,aParam[05])
aParam[06] := dDataAte //ParamLoad(cParNfeExp,aPerg,6,aParam[06])
If nTipo == 1
	aParam[07] := cCnpjDini //ParamLoad(cParNfeExp,aPerg,7,aParam[07])
	aParam[08] := cCnpjDfim //ParamLoad(cParNfeExp,aPerg,8,aParam[08])
EndIF

If IsReady()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIdEnt := GetIdEnt()
	If !Empty(cIdEnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Instancia a classe                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cIdEnt)
			
			//If ParamBox(aPerg,"SPED - NFe",@aParam,,,,,,,cParNfeExp,.T.,.T.)
			
			If nTipo == 1//NFe
				//Processa({|lEnd| SpedPExp(cIdEnt,aParam[01],aParam[02],aParam[03],aParam[04],lEnd,aParam[05],IIF(Empty(aParam[06]),dDataBase,aParam[06]),aParam[07],aParam[08],nTipo)},"Processando","Aguarde, exportando arquivos",.F.)
				//Substituido para usar a função Date(), para trazer a data do servidor    Analista: Renato Pereira
				SpedPExp(cIdEnt,aParam[01],aParam[02],aParam[03],aParam[04],lEnd,aParam[05],IIF(Empty(aParam[06]),Date(),aParam[06]),aParam[07],aParam[08],nTipo)
			ElseIf nTipo == 2//CCe
				//Processa({|lEnd| SpedPExp(cIdEnt,aParam[01],aParam[02],aParam[03],aParam[04],lEnd,aParam[05],IIF(Empty(aParam[06]),dDataBase,aParam[06]),,,nTipo)},"Processando","Aguarde, exportando arquivos",.F.)
				//Substituido para usar a função Date(), para trazer a data do servidor    Analista: Renato Pereira
				SpedPExp(cIdEnt,aParam[01],aParam[02],aParam[03],aParam[04],lEnd,aParam[05],IIF(Empty(aParam[06]),Date(),aParam[06]),,,nTipo)
			EndIf
			
			//EndIf
		EndIf
	Else
		Aviso("SPED",STR0021,{STR0114},3)	//"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
	EndIf
Else
	Aviso("SPED",STR0021,{STR0114},3) //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	 SpedPExp
//Autor:
//Data:		 25/06/2019
//Descricao: Rotina complementar para exportar .XML
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
Static Function SpedPExp(cIdEnt,cPrefixo,cNum,cNum,cDirDest,lEnd, dDataDe,dDataAte,cCnpjDIni,cCnpjDFim,nTipo)

Local aDeleta  := {}

Local cAlias	:= GetNextAlias()
Local cAnoInut  := ""
Local cAnoInut1 := ""
Local cCanc		:= ""
Local cChvIni  	:= ""
Local cChvFin	:= ""
Local cChvNFe  	:= ""
Local cCNPJDEST := Space(14)
Local cCondicao	:= ""
Local cDestino 	:= ""
Local cDrive   	:= ""
Local cIdflush  := cPrefixo+cNum
Local cModelo  	:= ""
Local cNFes     := ""
Local cPrefixo 	:= ""
Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cXmlInut  := ""
Local cXml		:= ""
Local cWhere	:= ""
Local cXmlProt	:= ""
local cAviso    := ""
local cErro     := ""

Local lOk      	:= .F.
Local lFlush  	:= .T.
Local lFinal   	:= .F.

Local nHandle  	:= 0
Local nX        := 0

Local oRetorno
Local oWS
Local oXML
Local cFile := '\xmlnf'

Default nTipo	:= 1
Default cNum:=""
Default cNum:=""
Default dDataDe:=CtoD("  /  /  ")
Default dDataAte:=CtoD("  /  /  ")

ProcRegua(Val(cNum)-Val(cNum))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corrigi diretorio de destino                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SplitPath(cDirDest,@cDrive,@cDestino,"","")
cDestino := cDrive+cDestino
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia processamento                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While lFlush
	If nTipo=1
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt
		oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cIdInicial        := cIdflush // cNum
		oWS:cIdFinal          := cIdflush //cPrefixo+cNum
		oWS:dDataDe           := dDataDe
		oWS:dDataAte          := dDataAte
		oWS:cCNPJDESTInicial  := cCnpjDIni
		oWS:cCNPJDESTFinal    := cCnpjDFim
		oWS:nDiasparaExclusao := 0
		lOk:= oWS:RETORNAFX()
		oRetorno := oWS:oWsRetornaFxResult
		
		If lOk
			ProcRegua(Len(oRetorno:OWSNOTAS:OWSNFES3))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exporta as notas                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
				
				//Ponto de Entrada para permitir filtrar as NF
				If ExistBlock("SPDNFE01")
					If !ExecBlock("SPDNFE01",.f.,.f.,{oRetorno:OWSNOTAS:OWSNFES3[nX]})
						loop
					Endif
				Endif
				
				oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
				oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
				cXML	:= ""
				If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U"
					cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
					cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
				Else
					cCNPJDEST := ""
				EndIf
				cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
				cVerCte := Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
				If !Empty(oXml:oWSNFe:cProtocolo)
					cNum := oXml:cID
					cIdflush := cNum
					cNFes := cNFes+cNum+CRLF
					cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
					cModelo := cChvNFe
					cModelo := StrTran(cModelo,"NFe","")
					cModelo := StrTran(cModelo,"CTe","")
					cModelo := SubStr(cModelo,21,02)
					
					Do Case
						Case cModelo == "57"
							cPrefixo := "CTe"
						OtherWise
							cPrefixo := "NFe"
					EndCase
					
					nHandle := FCreate(cDestino+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")
					If nHandle > 0
						cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
						If cModelo == "57"
							cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
							cRodap := '</cteProc>'
						Else
							Do Case
								Case cVerNfe <= "1.07"
									cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
								Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
									cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
								OtherWise
									cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
							EndCase
							cRodap := '</nfeProc>'
						EndIf
						FWrite(nHandle,AllTrim(cCab1))
						FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
						FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
						FWrite(nHandle,AllTrim(cRodap))
						FClose(nHandle)
						aadd(aDeleta,oXml:cID)
						cXML := AllTrim(cCab1)+AllTrim(oXml:oWSNFe:cXML)+AllTrim(cRodap)
						If !Empty(cXML)
							If ExistBlock("FISEXPNFE")
								ExecBlock("FISEXPNFE",.f.,.f.,{cXML})
							Endif
						EndIF
						
					EndIf
				EndIf
				
				If oXml:OWSNFECANCELADA <>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
					cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
					cNum := oXml:cID
					cIdflush := cNum
					cNFes := cNFes+cNum+CRLF
					If !"INUT"$oXml:oWSNFeCancelada:cXML
						nHandle := FCreate(cDestino+SubStr(cChvNFe,3,44)+"-ped-can.xml")
						If nHandle > 0
							cCanc := oXml:oWSNFeCancelada:cXML
							oXml:oWSNFeCancelada:cXML := '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + oXml:oWSNFeCancelada:cXML + "</procCancNFe>"
							FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
							FClose(nHandle)
							aadd(aDeleta,oXml:cID)
						EndIf
						nHandle := FCreate(cDestino+"\"+SubStr(cChvNFe,3,44)+"-can.xml")
						If nHandle > 0
							FWrite(nHandle,'<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + cCanc + oXml:oWSNFeCancelada:cXMLPROT + "</procCancNFe>")
							FClose(nHandle)
						EndIf
					Else
						
						//						If Type("oXml:OWSNFECANCELADA:CXML")<>"U"
						cXmlInut  := oXml:OWSNFECANCELADA:CXML
						cAnoInut1 := At("<ano>",cXmlInut)+5
						cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
						cXmlProt  := EncodeUtf8(oXml:oWSNFeCancelada:cXMLPROT)
						//					 	EndIf
						nHandle := FCreate(cDestino+SubStr(cChvNFe,3,2)+cAnoInut+SubStr(cChvNFe,5,39)+"-ped-inu.xml")
						If nHandle > 0
							FWrite(nHandle,oXml:OWSNFECANCELADA:CXML)
							FClose(nHandle)
							aadd(aDeleta,oXml:cID)
						EndIf
						nHandle := FCreate(cDestino+"\"+cAnoInut+SubStr(cChvNFe,5,39)+"-inu.xml")
						If nHandle > 0
							FWrite(nHandle,cXmlProt)
							FClose(nHandle)
						EndIf
					EndIf
				EndIf
				IncProc()
			Next nX
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui as notas                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(aDeleta) .And. GetNewPar("MV_SPEDEXP",0)<>0
				oWS:= WSNFeSBRA():New()
				oWS:cUSERTOKEN        := "TOTVS"
				oWS:cID_ENT           := cIdEnt
				oWS:nDIASPARAEXCLUSAO := GetNewPar("MV_SPEDEXP",0)
				oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
				oWS:oWSNFEID          := NFESBRA_NFES2():New()
				oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
				For nX := 1 To Len(aDeleta)
					aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
					Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aDeleta[nX]
				Next nX
				If !oWS:RETORNANOTAS()
					Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0046},3)
					lFlush := .F.
				EndIf
			EndIf
			aDeleta  := {}
			If Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .And. Empty(cNfes)
				Aviso("SPED",STR0106+" "+cNum,{"Ok"})	// "Não há dados"
				lFlush := .F.
			EndIf
		Else
			// Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+CRLF+STR0046,{"OK"},3)
			lFinal := .T.
		EndIf
		
		cIdflush := AllTrim(Substr(cIdflush,1,3) + StrZero((Val( Substr(cIdflush,4,Len(AllTrim(cFile))))) + 1 ,Len(AllTrim(cFile))))
		If cIdflush <= AllTrim(cNum) .Or. Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .Or. Empty(cNfes) .Or. ;
			cIdflush <= Substr(cNum,1,3)+Replicate('0',Len(AllTrim(cFile))-Len(Substr(Rtrim(cNum),4)))+Substr(Rtrim(cNum),4)// Importou o range completo
			lFlush := .F.
			If !Empty(cNfes)
				//If Aviso("SPED",STR0152,{"Sim","Não"}) == 1	//"Solicitação processada com sucesso."
				//	Aviso(STR0126,STR0151+" "+Upper(cDestino)+CRLF+CRLF+cNFes,{"Ok"})
				//EndIf
			EndIf
		EndIf
	ElseIf nTipo == 2  //Carta de Correcao
		
		cWhere:="D_E_L_E_T_=''"
		If !Empty(cPrefixo)
			If cTipoNfe == "SAIDA"
				cWhere		+= " AND F2_SERIE ='"+cPrefixo+"'"
				cCondicao	+= AllTrim("F2_SERIE ='"+cPrefixo+"'")
			Else
				cWhere		+= " AND F1_SERIE ='"+cPrefixo+"'"
				cCondicao	+= AllTrim("F1_SERIE ='"+cPrefixo+"'")
			Endif
		EndIf
		If !Empty(cNum)
			If cTipoNfe == "SAIDA"
				cWhere		+= " AND F2_DOC >='"+cNum+"'"
				cCondicao 	+= AllTrim(" .AND. F2_DOC >='"+cNum+"'")
			Else
				cWhere		+= " AND F1_DOC >='"+cNum+"'"
				cCondicao 	+= AllTrim(" .AND. F1_DOC >='"+cNum+"'")
			Endif
		EndIf
		If !Empty(cNum)
			If cTipoNfe == "SAIDA"
				cWhere		+= " AND F2_DOC <='"+cNum+"'"
				cCondicao 	+= AllTrim(" .AND. F2_DOC <='"+cNum+"'")
			Else
				cWhere		+= " AND F1_DOC <='"+cNum+"'"
				cCondicao 	+= AllTrim(" .AND. F1_DOC <='"+cNum+"'")
			Endif
		EndIf
		If !Empty(dDataDe)
			If cTipoNfe == "SAIDA"
				cWhere		+= " AND F2_EMISSAO >='"+DtoS(dDataDe)+"'"
				cCondicao 	+= " .AND. DTOS(F2_EMISSAO) >='"+DtoS(dDataDe)+"'"
			Else
				cWhere		+= " AND F1_EMISSAO >='"+DtoS(dDataDe)+"'"
				cCondicao 	+= " .AND. DTOS(F1_EMISSAO) >='"+DtoS(dDataDe)+"'"
			Endif
		EndIf
		If !Empty(dDataAte)
			If cTipoNfe == "SAIDA"
				cWhere		+= " AND F2_EMISSAO <='"+DtoS(dDataAte)+"'"
				cCondicao	+= " .AND. DTOS(F2_EMISSAO) <='"+DtoS(dDataAte)+"'"
			Else
				cWhere		+= " AND F1_EMISSAO <='"+DtoS(dDataAte)+"'"
				cCondicao	+= " .AND. DTOS(F1_EMISSAO) <='"+DtoS(dDataAte)+"'"
			Endif
		EndiF
		cWhere:="%"+cWhere+"%"
		#IFDEF TOP
			If cTipoNfe == "SAIDA"
				BeginSql Alias cAlias
					SELECT MIN(R_E_C_N_O_) AS RECINI,MAX(R_E_C_N_O_) AS RECFIN
					FROM %Table:SF2%
					WHERE F2_FILIAL= %xFilial:SE1%
					AND	%Exp:cWhere%
				EndSql
				SF2->(dbGoTo((cAlias)->RECINI))
				cChvIni := SF2->F2_CHVNFE
				SF2->(dbGoTo((cAlias)->RECFIN))
				cChvFin := SF2->F2_CHVNFE
				lExporta:=!(cAlias)->(Eof())
			Else
				BeginSql Alias cAlias
					SELECT MIN(R_E_C_N_O_) AS RECINI,MAX(R_E_C_N_O_) AS RECFIN
					FROM %Table:SF1%
					WHERE F1_FILIAL= %xFilial:SE1%
					AND	%Exp:cWhere%
				EndSql
				SF1->(dbGoTo((cAlias)->RECINI))
				cChvIni := SF1->F1_CHVNFE
				SF1->(dbGoTo((cAlias)->RECFIN))
				cChvFin := SF1->F1_CHVNFE
				lExporta:=!(cAlias)->(Eof())
			Endif
		#ELSE
			If cTipoNfe == "SAIDA"
				cAlias := "SF2"
				dbSetFilter({|| &cCondicao},cCondicao)
				
				(cAlias)->(dbGotop())
				cChvIni := SF2->F2_CHVNFE
				(cAlias)->(DbGoBottom())
				cChvFin := SF2->F2_CHVNFE
				lExporta:=!SF2->(Eof())
				(cAlias)->(dbClearFilter())
			Else
				cAlias := "SF1"
				dbSetFilter({|| &cCondicao},cCondicao)
				
				(cAlias)->(dbGotop())
				cChvIni := SF1->F1_CHVNFE
				(cAlias)->(DbGoBottom())
				cChvFin := SF1->F1_CHVNFE
				lExporta:=!SF1->(Eof())
				(cAlias)->(dbClearFilter())
			Endif
		#ENDIF
		
		
		If lExporta
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN	:= "TOTVS"
			oWS:cID_ENT		:= cIdEnt
			oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
			oWS:cChvInicial	:= cChvIni
			oWS:cChvFinal	:= cChvFin
			lOk:= oWS:NFEEXPORTAEVENTO()
			oRetorno := oWS:oWSNFEEXPORTAEVENTORESULT
			
			If lOk
				
				ProcRegua(Len(oRetorno:CSTRING))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exporta as cartas                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				For nX := 1 To Len(oRetorno:CSTRING)
					cXml    := oRetorno:CSTRING[nX]
					oXmlExp := XmlParser(cXml,"_",@cErro,@cAviso)
					If Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID")<>"U"
						cIdCCe	:= oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID:TEXT
					Else
						cIdCCe  := oXmlExp:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID:TEXT
					Endif
					nHandle := FCreate(cDestino+SubStr(cIdCCe,3)+"-CCe.xml")
					If nHandle > 0
						FWrite(nHandle,AllTrim(cXml))
						FClose(nHandle)
					EndIf
					IncProc()
					cNFes+=SubStr(cIdCCe,31,3)+"/"+SubStr(cIdCCe,34,9)+CRLF
				Next nX
				
				If Aviso("SPED",STR0152,{"Sim","Não"}) == 1	//"Solicitação processada com sucesso."//
					Aviso(STR0126,STR0151+" "+Upper(cDestino)+CRLF+CRLF+cNFes,{STR0114},3)
				EndIf
			Else
				Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
				lFinal := .T.
			EndIF
		EndIf
		#IFDEF TOP
			If select (cAlias)>0
				(cAlias)->(dbCloseArea())
			EndIf
		#ENDIF
		lFlush := .F.
	EndIF
EndDo

Return(.T.)

/*------------------------------------------------------------------------//
//Programa:	 IsReady
//Autor:     TOTVS S/A
//Data:		 25/06/2019
//Descricao: Rotina complementar para exportar .XML
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
Static Function IsReady(cURL,nTipo,lHelp)
Local nX       := 0
Local cHelp    := ""
Local oWS
Local lRetorno := .F.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.
If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "MV_SPEDURL"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "URL SPED NFe"
	MsUnLock()
	PutMV("MV_SPEDURL",cURL)
EndIf
SuperGetMv() //Limpa o cache de parametros - nao retirar
DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o servidor da Totvs esta no ar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
If oWs:CFGCONNECT()
	lRetorno := .T.
Else
	If lHelp
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
	EndIf
	lRetorno := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo <> 1 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWs:CFGReady()
		lRetorno := .T.
	Else
		If nTipo == 3
			cHelp := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			If lHelp .And. !"003" $ cHelp
				Aviso("SPED",cHelp,{STR0114},3)
				lRetorno := .F.
			EndIf
		Else
			lRetorno := .F.
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 2 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWs:CFGStatusCertificate()
		If Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE) > 0
			For nX := 1 To Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE)
				If oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nx]:DVALIDTO-30 <= Date()
					
					Aviso("SPED",STR0127+Dtoc(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nX]:DVALIDTO),{STR0114},3) //"O certificado digital irá vencer em: "
					
				EndIf
			Next nX
		EndIf
	EndIf
EndIf

Return(lRetorno)

/*------------------------------------------------------------------------//
//Programa:	 GetIdEnt
//Autor:     TOTVS S/A
//Data:		 25/06/2019
//Descricao: Rotina complementar para exportar .XML
//Uso:       Salon
//Parametros:
//Retorno:   Nil
//------------------------------------------------------------------------*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
EndIf

RestArea(aArea)
Return(cIdEnt)  

*--------------------------*
Static Function xEmpFil(_cFil)
*--------------------------*
Local _aRet := {}
aADD(_aRet, AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_NOMECOM')))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_ENDENT'))))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_BAIRENT'))))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_CIDENT'))))
aADD(_aRet, AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_ESTENT')))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_CEPENT'),'@r 99999-999'))
aADD(_aRet, RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_INSC'),'@r 999.999.999.999'))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_CGC'),"@r 99.999.999/9999-99"))
//aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'),'@r 9999-9999'))
aADD(_aRet, RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'))

//CapitalAce()
//Capital()
Return(_aRet)

*-------------------------------*
Static Function RetLogo(_cFilial)                              
*-------------------------------*          

 //  Return("http://www.merc.com.br/wp-content/uploads/2018/02/merc.jpg")
Return("")

*-------------------------------*
Static Function RetSite(_cFilial)                              
*-------------------------------*          

   Return("www.salonline.com.br/")
