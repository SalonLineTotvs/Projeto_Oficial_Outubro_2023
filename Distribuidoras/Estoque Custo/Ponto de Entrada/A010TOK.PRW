#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'

/*/ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A010TOK º Autor ³ Genilson M Lucas	 º Data ³  14/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada após confirmação do produto. 		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SalonLine										          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function A010TOK()

Local aArea	:=	GetArea()
Local lRet		:=	.T.

Local cAssunto 		:= " Novo "+M->B1_TIPO+ iif(inclui, " Cadastrado - ", " Alterado - " )+ ALLTRIM(M->B1_COD) + " - " + ALLTRIM(M->B1_DESC)
Local cEmail	    := ""
Local cBody		 	:= ""
Local cAnexo    	:= "" 
Local lVldProd      := Inclui .or. Altera //M->B1_TIPO == "PA"
Local cCodUser      := RetCodUsr() //Retorna o Codigo do Usuario
Local cNamUser      := UsrRetName( cCodUser )//Retorna o nome do usuario 
Local aPars 		:= {}

Local cQuery		:= ""
Local cNomeUser		:= SUBSTR(UsrFullName(__CUSERID),1,15)

//----> CONTROLE DE ENDEREÇO 
M->B1_LOCALIZ	:= "N"

//----> CONTROLE DE RASTRO
M->B1_RASTRO	:= "N"

//LOCAL PADRÃO
M->B1_LOCPAD	:= "01" 


If M->B1_TIPO = 'PA'
		//01 B1_X_ENCOM	02 B1_PROC
		//		    	000005 ALFALOG
		//				002196 DEVINTEX
		
	//NÃO DEIXA CADASTRAR OUTRA ENCOMENDANTE - ALFALOG E DEVINTEX
	If !Empty(M->B1_PROC) .and. !(M->B1_PROC $ "000005/002196")
		MsgInfo("Fornecedor não pertence ao grupo ou não cadastrado, favor verificar.","Atenção")
		lRet := .F.
	EndIf

	If Empty(M->B1_PROC)
		MsgAlert ("Favor informar o FORNECEDOR no campo Forn. Padrão. 000005 para Alfalog ou 002196 para Devintex. Caso tenha alguma dúvida, favor consultar o Depto. Fiscal.",;
		"Informar Fornecedor") 
		lRet := .F.
	EndIf
	
	If M->B1_PESO = 0 .or. M->B1_PESBRU = 0
		MsgInfo("Favor informar o Peso Líquido e/ou Bruto do Produto.","Cadastrar Peso")
		lRet := .F.
	EndIf
	
	If M->B1_QE = 0
		MsgInfo("Favor informar a quantidade por embalagem!","Quantidade Por Embalagem")
		lRet := .F.
	EndIf	
	
EndIf


//***********************************************
// FAZ CORTE DO PRODUTO
//***********************************************
If M->B1_X_MSBLQ == '1' .AND. M->B1_X_MSBLQ <> SB1->B1_X_MSBLQ

	If MsgYesNo("Confirma realizar o corte do produto?",'Corte do Produto') 
		cQuery	:= " UPDATE SC6020 SET C6_X_RESID='X', D_E_L_E_T_='*' , C6_DESCRI='CORTE EM "+dtoc(Ddatabase)+" - " +cNomeUser+"' FROM "
		cQuery	+= " SC6020 C6 "
		cQuery	+= " INNER JOIN SC5020 C5 ON C5_FILIAL  = C6_FILIAL AND C5_NUM=C6_NUM AND C5.D_E_L_E_T_=' ' AND C5_NOTA = '' AND C5_X_STAPV='0' "
		cQuery	+= " INNER JOIN SA1020 A1 ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_='' AND A1_SATIV1 NOT IN ('000003','000004','000006') "
		cQuery	+= " WHERE C6.D_E_L_E_T_ = '' AND C6_NOTA = ''  AND C6_PRODUTO IN ('"+M->B1_COD+"') "
		TcSqlExec(cQuery)	
		
		
		cQuery	:= " UPDATE SC9020 SET C9_SERIENF='X', D_E_L_E_T_='*' "
		cQuery	+= " FROM SC9020 C9 "
		cQuery	+= " INNER JOIN SC5020 C5 ON C5_FILIAL=C9_FILIAL AND C5_NUM=C9_PEDIDO AND C5.D_E_L_E_T_=' ' AND C5_X_STAPV='0' AND C5_NOTA = '' "
		cQuery	+= " INNER JOIN SA1020 A1 ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_='' AND A1_SATIV1 NOT IN ('000003','000004','000006') "
		cQuery	+= " WHERE C9.D_E_L_E_T_ = '' AND C9_NFISCAL = '' AND  C9_PRODUTO IN ('"+M->B1_COD+"') "
		TcSqlExec(cQuery)
	EndIf
	
EndIf


//***********************************************
// ENVIO DE E-MAIL
//***********************************************
If lVldProd .and. lRet
	
	If M->B1_TIPO = 'PA'
		cEmail	    :=     SuperGetMV("ES_RELACN1",.F.,"protheus.logs@salonline.com.br")
		cEmail		+= ";"+SuperGetMV("ES_RELACN2",.F.,"protheus.logs@salonline.com.br")
	Else
		cEmail	    :=     SuperGetMV("ES_RELACN3",.F.,"protheus.logs@salonline.com.br")
	EndIf
	
	iif(M->B1_PESO==0,cPesol := "Nao Informado",cPesol :=  CVALTOCHAR(M->B1_PESO))
	iif(empty(M->B1_PROC),cEncom := "Nao Informado",cEncom := M->B1_PROC)
	iif(M->B1_PESBRU==0,cPesoB := "Nao Informado",cPesoB := CVALTOCHAR(M->B1_PESBRU))
	iif(M->B1_PICM==0,cIcms := "Nao Informado",cIcms := CVALTOCHAR(M->B1_PICM))
	iif(M->B1_IPI==0,cIpi := "Nao Informado",cIpi := CVALTOCHAR(M->B1_IPI))
      
    cBody	:= '<html>'
	cBody	+= '	<head>'
	cBody	+= '		<meta content="text/html; charset=ISO-8859-1"http-equiv="content-type">'
	cBody	+= '		<title></title>
	cBody	+= '	</head>
	cBody	+= '	<body>
	cBody	+= '	<span style="font-family: Arial;">Novo '+M->B1_TIPO+' cadastrado pelo <b>' + cCodUser + ' - ' + cNamUser +'</b></span><br style="font-family: Arial;">
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">
	cBody+= '<table border="1" color="#000000" cellspacing="0" cellpadding="0" width="70%">'
	
	
   cBody+= '<tr> <center>'
	   cBody+= '<td width="15%" BGCOLOR="#D8D8D8">'
	   cBody+= '<font size="2" face="Verdana"><B>DADOS</B></font></td>'  
      cBody+= '<td width="55%" BGCOLOR="#D8D8D8">'
	   cBody+= '<font size="2" face="Verdana"><B>CADASTRAIS</B></font></td>'
	cBody+= '</center> </tr> ' 
			
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>C&Oacute;DIGO:</B></font></td>'   
		 cBody+= '<td width="55%">' 
		 cBody+= '<font size="2" face="Verdana">'+M->B1_COD+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>DESCRI&Ccedil;&Atilde;O:</B></font></td>'   
		 cBody+= '<td width="55%">' 
		 cBody+= '<font size="2" face="Verdana">'+M->B1_DESC+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="20%">'
		 cBody+= '<font size="2" face="Verdana"><B>UNIDADE DE MEDIDA:</B></font></td>'   
		 cBody+= '<td width="55%">' 
		 cBody+= '<font size="2" face="Verdana">'+M->B1_UM+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="20%">'
		 cBody+= '<font size="2" face="Verdana"><B>ARMAZ&Eacute;M PADR&Atilde;O:</B></font></td>'   
		 cBody+= '<td width="55%">' 
		 cBody+= '<font size="2" face="Verdana">'+M->B1_LOCPAD+'</font></td>'
		cBody+= '</tr>'
		
	    cBody+= '<tr>'
		 cBody+= '<td width="20%">'
		 cBody+= '<font size="2" face="Verdana"><B>PESO LIQUIDO(KG):</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ cPesol +'</font></td>'
		cBody+= '</tr>'
	
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>PESO BRUTO(KG):</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ cPesoB +'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>CONTROLA LOTE:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ M->B1_RASTRO +'</font></td>'
		cBody+= '</tr>'
		
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>CONTROLA ENDERE&Ccedil;O:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ M->B1_LOCALIZ +'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>C&Oacute;DIGO DE BARRAS:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+M->B1_CODBAR+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>ENCOMENDANTE:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ cEncom+'</font></td>'
		cBody+= '</tr>'
		
       cBody+= '<tr> <center>'
	   cBody+= '<td width="15%" BGCOLOR="#D8D8D8">'
	   cBody+= '<font size="2" face="Verdana"><B>DADOS</B></font></td>'  
       cBody+= '<td width="55%" BGCOLOR="#D8D8D8">'
	   cBody+= '<font size="2" face="Verdana"><B>IMPOSTOS</B></font></td>'  
	   cBody+= '</center> </tr>' 
	   
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>ALIQ ICMS:</B></font></td>'   
		 cBody+= '<td width="55%">' 
		 cBody+= '<font size="2" face="Verdana">'+ cIcms +'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>ALIQ IPI:</B></font></td>'   
		 cBody+= '<td width="55%">' 
		 cBody+= '<font size="2" face="Verdana">'+ cIpi +'</font></td>'
		cBody+= '</tr>'
		
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>NCM:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+M->B1_POSIPI+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>EX-NCM:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+M->B1_EX_NCM+'</font></td>'
		cBody+= '</tr>'
		
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>ORIGEM:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ CVALTOCHAR(M->B1_ORIGEM)+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>CLASS. FISCAL:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+CVALTOCHAR(M->B1_CLASFIS)+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>GRUPO TRIB:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+CVALTOCHAR(M->B1_GRTRIB)+'</font></td>'
		cBody+= '</tr>'
	    
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>CEST:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+M->B1_CEST+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr> <center>'
	     cBody+= '<td width="15%" BGCOLOR="#D8D8D8">'
	     cBody+= '<font size="2" face="Verdana"><B>DADOS</B></font></td>'  
         cBody+= '<td width="55%" BGCOLOR="#D8D8D8">'
	     cBody+= '<font size="2" face="Verdana"><B>MRP SUPRIMENTOS</B></font></td>'  
	    cBody+= '</center> </tr>' 
	    
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>QTD EMBALAGEM:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ CVALTOCHAR(M->B1_QE) +'</font></td>'
		cBody+= '</tr>'
		
	   	cBody+= '<tr> <center>'
	     cBody+= '<td width="15%" BGCOLOR="#D8D8D8">'
	     cBody+= '<font size="2" face="Verdana"><B>DADOS</B></font></td>'  
         cBody+= '<td width="55%" BGCOLOR="#D8D8D8">'
	     cBody+= '<font size="2" face="Verdana"><B>QUALIDADE</B></font></td>'  
	    cBody+= '</center> </tr>'
	    
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>NOTA MINIMA:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+ cvaltochar(M->B1_NOTAMIN)+'</font></td>'
		cBody+= '</tr>'
		
		cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>TIPO CQ:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+M->B1_TIPOCQ+'</font></td>'
		cBody+= '</tr>'
	    
	    cBody+= '<tr>'
		 cBody+= '<td width="15%">'
		 cBody+= '<font size="2" face="Verdana"><B>PRODU&Ccedil;&Atilde;O CQ:</B></font></td>'   
		 cBody+= '<td width="55%">'
		 cBody+= '<font size="2" face="Verdana">'+cvaltochar(M->B1_NUMCQPR) + '</font></td>'
		cBody+= '</tr>' 
		
	   cBody+= '<tr> <center>'
	   cBody+= '<td width="15%" BGCOLOR="#D8D8D8">'
	   cBody+= '<font size="2" face="Verdana"><B>PROGRAMA</B></font></td>'  
       cBody+= '<td width="55%" BGCOLOR="#D8D8D8">'
	   cBody+= '<font size="2" face="Verdana"><B>A010TOK</B></font></td>'
	   cBody+= '</center></tr>' 
	
	cBody += '</table>' 
	cBody += '</body>' 
	cBody += '</html>
    
 
	If !Empty(cBody)
		U_SendMail( cEmail,,, cAssunto, cBody,cAnexo )
	End If
			
EndIf

RestArea(aArea)
Return(lRet)
