#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR0003  ºAutor³ André Salgado/ Introde  ºData³ 13/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão Carta de Correção conforme layout indicado.      º±±
±±º          ³ Não vale como Documento Oficial                            º±±
±±º			 ³ Doc.: http://tdn.totvs.com/display/public/mp/FWMsPrinter	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento \ SalonLine                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// alterado pro CJDECAMPOS - AJuste Municipio e Telefone
// ajustado cce de nota de entrada. - CJDECMAPOS 31/08/2018
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATR0003()

Private oPrint  := Nil
Private oFont07 := TFont():New("Times New Roman",07,07,,.F.)// 3
Private oFont07N:= TFont():New("Times New Roman",07,07,,.T.)// 2
Private oFont08 := TFont():New("Times New Roman",08,08,,.F.)// 4
Private oFont08N:= TFont():New("Times New Roman",08,08,,.T.)// 5
Private oFont09 := TFont():New("Times New Roman",09,09,,.F.)// 7
Private oFont09N:= TFont():New("Times New Roman",09,09,,.T.)// 6
Private oFont10 := TFont():New("Times New Roman",10,10,,.F.)// 8
Private oFont10N:= TFont():New("Times New Roman",10,10,,.T.)// 11
Private oFont11 := TFont():New("Times New Roman",11,11,,.F.)// 9
Private oFont11N:= TFont():New("Times New Roman",11,11,,.T.)// 11
Private oFont12 := TFont():New("Times New Roman",12,12,,.F.)// 10
Private oFont12N:= TFont():New("Times New Roman",12,12,,.T.)// 11
Private oFont14 := TFont():New("Times New Roman",14,14,,.F.)// 10
Private oFont14N:= TFont():New("Times New Roman",14,14,,.T.)// 11
Private oFont16N:= TFont():New("Times New Roman",16,16,,.T.)// 12
Private	cPerg	:= "PRINTCCE"
Private cGet1	:= ""
Private cCliFor	:= ""

Pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao do objeto grafico                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oPrint == Nil
	lPreview := .T.
	oPrint 	:= FWMSPrinter():New("CCe_"+ALLTRIM(MV_PAR02),IMP_PDF,.T.,,.F.,.F.,)
	//	oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	//	oPrint:SetMargin(60,60,60,60)
	//	oPrint:Setup()
EndIf
oPrint:StartPage()

If MV_PAR01 == 1
	DadosSai() //1- Saída
Else
	DadosEnt() //2- Entrada
EndIF

EnvMail()

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ/
//³Carta de Correção Saída               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ/
Static Function DadosSai()
Local	aArea  := GetArea()
Local 	cDBOra := "MSSQL/TSS_8082"	// alterar o alias/dsn para o banco/conexão que está utilizando
Local 	cSrvOra:= "10.50.1.10" 		//192.168.0.31" // alterar para o ip do DbAccess

dbSelectArea("SF2")
dbSetOrder(1)     //DOC + SERIE
dbSeek(xFilial("SF2")+MV_PAR02+MV_PAR03)

If Found()
	
	If Select("TMP") >0
		TMP->(DbCloseArea())
	Endif

	nHwnd := TCLink(cDBOra, cSrvOra, 7890)
	if nHwnd >= 0
		conout("Conectado")  
	endif

                     
	/* TOP 1 - Para pegar sempre a ultima carta de correcao da nf-e  */
	cQry := " SELECT TOP 1 ID_EVENTO,TPEVENTO,SEQEVENTO,AMBIENTE,DATE_EVEN,TIME_EVEN,VERSAO,VEREVENTO,VERTPEVEN,VERAPLIC,CORGAO,CSTATEVEN,CMOTEVEN,"
	cQry += " PROTOCOLO,NFE_CHV,ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_ERP)),'') AS TMEMO1,"
	cQry += " ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_RET)),'') AS TMEMO2 "
	//cQry += " FROM TSS_8082.dbo.SPED150 "
	cQry += " FROM SPED150 "
	//cQry += " FROM OpenDataSource('SQLOLEDB','Data Source=192.168.0.12;User ID=sa;Password=T1$4l0nL1n3#SQL').TSS_8082.dbo.SPED150 "
	cQry += " WHERE D_E_L_E_T_ = ' ' AND STATUS = 6 "
	cQry += " AND NFE_CHV = '"+SF2->F2_CHVNFE+"' "
	cQry += " ORDER BY SEQEVENTO DESC"        // cQry += " ORDER BY LOTE DESC" (Valmir 05/04) Imprimir sempre a ultima carta
	
	cQry := ChangeQuery(cQry)
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
	
	TcSetField("TMP","DATE_EVEN","D",08,0)
	
	dbSelectArea("TMP")
	dbGoTop()
	
	IF ( EOF() )
		MsgStop("Atenção! Não existe Carta de Correção para a Nota Fiscal informada.")
		TMP->(dbCloseArea())
		RestArea(aArea)
		
		Return
	ENDIF
	
	MontarCCe()
	
	cMMEMO1     := TMP->TMEMO1     ///Relativo ao envio
	cMMEMO2     := TMP->TMEMO2     ///Retorno da SEFAZ
	dMDATE_EVEN := DTOC(TMP->DATE_EVEN)
	cMTIME_EVEN := TMP->TIME_EVEN
	cMPROTOCOLO := STR(TMP->PROTOCOLO,15)
	
	TMP->(dbCloseArea())
	TCUnlink()
	
	RestArea(aArea)
	
	/* Extrair o texto da Carta de Correção do Campo Memo. */
	cMDESCEVEN := ""
	iw1 := AT("<xCorrecao>" , cMMEMO1 )
	iw2 := AT("</xCorrecao>" , cMMEMO1 )
	IF ( iw1 > 0 )
		iw3 := ( iw2 - iw1 )
		cMDESCEVEN += SUBS(cMMEMO1 , ( iw1+11 ) , ( iw2 - ( iw1 + 11 ) ) )
		//cMDESCEVEN += SPACE(10)
		iw1 := 1
	ENDIF
	
	oPrint:Say(0360,1140, SF2->F2_DOC ,oFont11)
	oPrint:Say(0400,1140, SF2->F2_SERIE ,oFont11)
	oPrint:Code128c(0200, 1480, SF2->F2_CHVNFE, 28)
	oPrint:Say(0270,1460, Transform(SF2->F2_CHVNFE,"@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont11)
	
	oPrint:Say(0525,0100, Transform(dMDATE_EVEN,"99/99/9999"),oFont11)
	oPrint:Say(0525,1460, cMPROTOCOLO+SPACE(10)+dMDATE_EVEN+SPACE(2)+cMTIME_EVEN ,oFont11)
	
	oPrint:Say(0620,0100, Transform(SM0->M0_INSC,"@R 999.999.999.999"),oFont11)
	oPrint:Say(0620,1535, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont11)
	
	If SF2->F2_TIPO != "B"
		cCliFor	:= POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_NOME") 
		cGet1 	:= POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_EMAIL")
		 
		oPrint:Say(0775,0100, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_NOME") 	,oFont11)
		oPrint:Say(0775,1535, Transform(POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_CGC"),"@R 99.999.999/9999-99")  ,oFont11)
		oPrint:Say(0860,0100, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_END")  	,oFont11)
		oPrint:Say(0860,1040, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_BAIRRO")	,oFont11)
		oPrint:Say(0860,1735, Transform(POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_CEP"), "@R 99999-999") ,oFont11)
// ajuste CJDECAMPOS 14/06/2018
//		oPrint:Say(0950,0100, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_BAIRRO"),oFont11)
//		oPrint:Say(0950,0910, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_MUN")   ,oFont11)
		oPrint:Say(0950,0100, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_MUN")		,oFont11)
		oPrint:Say(0950,0910, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_DDD") +" "+ POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_TEL")   	,oFont11)
		oPrint:Say(0950,1445, POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_EST")   	,oFont11)
		oPrint:Say(0950,1610, Transform(POSICIONE("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_INSCR"),"@R 999.999.999.999") ,oFont11)
	Else
		cCliFor	:= POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME")
		cGet1 := POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_EMAIL")
		
		oPrint:Say(0775,0100, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME") 	,oFont11)
		oPrint:Say(0775,1535, Transform(POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_CGC"),"@R 99.999.999/9999-99")  ,oFont11)
		oPrint:Say(0860,0100, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_END")  	,oFont11)
		oPrint:Say(0860,1040, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_BAIRRO")	,oFont11)
		oPrint:Say(0860,1735, Transform(POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_CEP"), "@R 99999-999") ,oFont11)
// ajuste CJDECAMPOS 14/06/2018
//		oPrint:Say(0950,0100, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_BAIRRO"),oFont11)
//		oPrint:Say(0950,0910, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_MUN")   ,oFont11)
		oPrint:Say(0950,0100, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_MUN")		,oFont11)
		oPrint:Say(0950,0910, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_DDD") +" "+ POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_TEL")  	,oFont11)
		oPrint:Say(0950,1445, POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_EST")  	,oFont11)
		oPrint:Say(0950,1610, Transform(POSICIONE("SA2",1,xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA),"A2_INSCR"),"@R 999.999.999.999") ,oFont11)	
	EndIf
	
	nLin		:= 1060
	nTam		:=	Len(cMDESCEVEN)/121
	nTam		+=	Iif(nTam>Round(nTam,0),Round(nTam,0)+1-nTam,nTam)
	For nX := 1 To nTam
		oPrint:Say(nLin,0100,SubStr(cMDESCEVEN,Iif(nX==1,1,((nX-1)*121)+1),121), oFont11 )
		nLin+=40
	Next nX
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variavel de Impressão			                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Preview()

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carta Correção Entrada	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function DadosEnt()
Local   aArea   := GetArea()
Local 	cDBOra := "MSSQL/TSS_8082"	// alterar o alias/dsn para o banco/conexão que está utilizando
Local 	cSrvOra:= "10.50.1.10" 		//192.168.0.31" // alterar para o ip do DbAccess

dbSelectArea("SF1")
dbSetOrder(1)     //DOC + SERIE
dbSeek(xFilial("SF1")+MV_PAR02+MV_PAR03)

If Found()
	
	If Select("TMP") >0
		TMP->(DbCloseArea())
	Endif
	
     
	nHwnd := TCLink(cDBOra, cSrvOra, 7890)
	if nHwnd >= 0
		conout("Conectado")  
	endif
	
	/* TOP 1 - Para pegar sempre a ultima carta de correcao da nf-e  */
//	cQry := "USE TSS_8082 "+CHR(13)
//	cQry += "GO "+CHR(13)
	cQry := "SELECT TOP 1 ID_EVENTO,TPEVENTO,SEQEVENTO,AMBIENTE,DATE_EVEN,TIME_EVEN,VERSAO,VEREVENTO,VERTPEVEN,VERAPLIC,CORGAO,CSTATEVEN,CMOTEVEN,"
	cQry += "PROTOCOLO,NFE_CHV,ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_ERP)),'') AS TMEMO1,"
	cQry += "ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),XML_RET)),'') AS TMEMO2 "
	cQry += "FROM SPED150 "
	cQry += "WHERE D_E_L_E_T_ = ' ' AND STATUS = 6 "
	cQry += "AND NFE_CHV = '"+SF1->F1_CHVNFE+"' "
	cQry += "ORDER BY SEQEVENTO DESC"	// cQry += " ORDER BY LOTE DESC" (Valmir 05/04) Imprimir sempre a ultima carta
	
	cQry := ChangeQuery(cQry)
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
	
	TcSetField("TMP","DATE_EVEN","D",08,0)
	
	dbSelectArea("TMP")
	dbGoTop()
	
	IF ( EOF() )
		MsgStop("Atenção! Não existe Carta de Correção para a Nota Fiscal informada.")
		TMP->(dbCloseArea())
		RestArea(aArea)
		
		Return
	ENDIF
	
	MontarCCe()
	
	cMMEMO1     := TMP->TMEMO1     ///Relativo ao envio
	cMMEMO2     := TMP->TMEMO2     ///Retorno da SEFAZ
	dMDATE_EVEN := DTOC(TMP->DATE_EVEN)
	cMTIME_EVEN := TMP->TIME_EVEN
	cMPROTOCOLO := STR(TMP->PROTOCOLO,15)
	
	TMP->(dbCloseArea())
	
	RestArea(aArea)
	
	/* Extrair o texto da Carta de Correção do Campo Memo. */
	cMDESCEVEN := ""
	iw1 := AT("<xCorrecao>" , cMMEMO1 )
	iw2 := AT("</xCorrecao>" , cMMEMO1 )
	IF ( iw1 > 0 )
		iw3 := ( iw2 - iw1 )
		cMDESCEVEN += SUBS(cMMEMO1 , ( iw1+11 ) , ( iw2 - ( iw1 + 11 ) ) )
		//cMDESCEVEN += SPACE(10)
		iw1 := 1
	ENDIF
	
	oPrint:Say(0360,1140, SF1->F1_DOC ,oFont11)
	oPrint:Say(0400,1140, SF1->F1_SERIE ,oFont11)

	oPrint:Code128c(0200, 1480, SF1->F1_CHVNFE, 28)
	oPrint:Say(0270,1460, Transform(SF1->F1_CHVNFE,"@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont11)
	
	oPrint:Say(0525,0100, Transform(dMDATE_EVEN,"99/99/9999"),oFont11)
	oPrint:Say(0525,1460, cMPROTOCOLO+SPACE(10)+dMDATE_EVEN+SPACE(2)+cMTIME_EVEN ,oFont11)
	
	oPrint:Say(0620,0100, Transform(SM0->M0_INSC,"@R 999.999.999.999"),oFont11)
	oPrint:Say(0620,1535, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont11)

	cCliFor	:= POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_NOME")
	cGet1	:= POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_EMAIL")
	
	oPrint:Say(0775,0100, POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_NOME") ,oFont11)
	oPrint:Say(0775,1535, Transform(POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_CGC"),"@R 99.999.999/9999-99")  ,oFont11)
	oPrint:Say(0860,0100, POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_END")  ,oFont11)
	oPrint:Say(0860,1040, POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_BAIRRO"),oFont11)
	oPrint:Say(0860,1735, Transform(POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_CEP"), "@R 99999-999") ,oFont11)
	oPrint:Say(0950,0100, POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_BAIRRO"),oFont11)
	oPrint:Say(0950,0910, POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_MUN")   ,oFont11)
	oPrint:Say(0950,1445, POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_EST")   ,oFont11)
	oPrint:Say(0950,1610, Transform(POSICIONE("SA2",1,xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_INSCR"),"@R 999.999.999.999") ,oFont11)
	
	nLin		:= 1060
	nTam		:=	Len(cMDESCEVEN)/121
	nTam		+=	Iif(nTam>Round(nTam,0),Round(nTam,0)+1-nTam,nTam)
	For nX := 1 To nTam
		oPrint:Say(nLin,0100,SubStr(cMDESCEVEN,Iif(nX==1,1,((nX-1)*121)+1),121), oFont11 )
		nLin+=40
	Next nX
	
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variavel de Impressão			                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Preview()

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ/
//³Montar Layout da Carta de Correção    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ/
Static Function MontarCCe()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 1 IDENTIFICACAO DO EMITENTE                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrint:Box(0095,0080,0450,2295)
oPrint:Box(0095,1005,0450,1450)
oPrint:Box(0095,1450,0210,2300)
oPrint:Box(0210,1450,0305,2300)
oPrint:Box(0305,1450,0450,2300)

oPrint:Box(0450,0080,0640,2295)
oPrint:Box(0450,1450,0550,2300)
oPrint:Box(0550,0080,0640,0685)
oPrint:Box(0550,0685,0640,1515)
oPrint:Box(0550,1515,0640,2300)

//COMENTADO IMPRESSÃO DO LOGO
//oPrint:SayBitmap(0100,0090,"\system\lgrl01.bmp",0370,0320)

oPrint:Say(0180,0100, Alltrim(SM0->M0_NOMECOM),oFont10N)
oPrint:Say(0220,0100, Alltrim(SM0->M0_ENDCOB),oFont10N)
oPrint:Say(0260,0100, "COMPLEMENTO: "+Alltrim(SM0->M0_COMPCOB),oFont10N)
oPrint:Say(0300,0100, Alltrim(SM0->M0_BAIRCOB)+" - CEP: "+Transform(SM0->M0_CEPCOB,"99999999"),oFont10N)
oPrint:Say(0340,0100, Alltrim(SM0->M0_CIDCOB)+"/"+Alltrim(SM0->M0_ESTCOB),oFont10N)
oPrint:Say(0380,0100, "FONE: "+Transform(SM0->M0_TEL,"99999999999999"),oFont10N)
													
oPrint:Say(0125,1120, "           CC-e   ",oFont11N)
oPrint:Say(0155,1120, "Carta de Correção",oFont11N)
oPrint:Say(0185,1120, "       Eletrônica",oFont11N)
oPrint:Say(0230,1020, "0 - Entrada",oFont11N)
oPrint:Say(0270,1020, "1 - Saída"  ,oFont11N)
oPrint:Box(0250,1300,0300,1350)
oPrint:Say(0280,1320, Iif(MV_PAR01=1,"1","0") ,oFont09N)
oPrint:Say(0360,1020, "Nº NF-e: ",oFont11N)
oPrint:Say(0400,1020, "SÉRIE: ",oFont11N)
oPrint:Say(0440,1020, "FOLHA: 1/1",oFont11N)

oPrint:Say(0235,1460, "CHAVE DE ACESSO",oFont10N)
oPrint:Say(0475,0090, "DATA EMISSÃO",oFont10N)
oPrint:Say(0475,1460, "PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont10N)
oPrint:Say(0575,0090, "INSCRIÇÃO ESTADUAL",oFont10N)
oPrint:Say(0575,0695, "INSC. EST. DO SUBST. TRIBUTÁRIO",oFont10N)
oPrint:Say(0575,1525, "CNPJ",oFont10N)

oPrint:Say(0360,1460, "Consulta de autenticidade no Portal Nacional da NF-e",oFont11N)
oPrint:Say(0400,1460, "www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont11N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 2 IDENTIFICACAO DO DESTINATARIO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Box(0700,0080,0790,2300)
oPrint:Line(0700,1515,0790,1515)
oPrint:Box(0790,0080,0880,2300)
oPrint:Line(0790,1020,0880,1020)
oPrint:Line(0790,1715,0880,1715)
oPrint:Box(0880,0080,0970,2300)
oPrint:Line(0880,0890,0970,0890)
oPrint:Line(0880,1425,0970,1425)
oPrint:Line(0880,1590,0970,1590)
//oPrint:Box(0700,2015,0790,2300)
oPrint:Say(0680,0080,"DADOS DO DESTINATÁRIO",oFont11N)

oPrint:Say(0730,0090,"NOME RAZÃO SOCIAL",oFont10N)
oPrint:Say(0730,1525,"CNPJ",oFont10N)
oPrint:Say(0815,0090,"ENDEREÇO",oFont10N)
oPrint:Say(0815,1030,"BAIRRO/DISTRITO",oFont10N)
oPrint:Say(0815,1725,"CEP",oFont10N)
oPrint:Say(0905,0090,"MUNICÍPIO",oFont10N)
oPrint:Say(0905,0900,"TELEFONE",oFont10N)
oPrint:Say(0905,1435,"UF",oFont10N)
oPrint:Say(0905,1600,"INSCRIÇÃO ESTADUAL",oFont10N)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 3 INFORMACOES DE CORRECAO		                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Box(1020,0080,1970,2300)
oPrint:Say(1000,0080,"INFORMAÇÕES A SEREM CONSIDERADAS",oFont11N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 4 OBSERVACOES						                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Box(2010,0080,2500,2300)

oPrint:Say(2070,0100,"A Carta de Correcao é disciplinada pelo § 1º-A do art. 7º do Convênio S/Nº, de 15 de Dezembro de 1970 e pode ser utilizada para",oFont11N)
oPrint:Say(2110,0100,"regularização  de  erro ocorrido na  emissão de  documento  fiscal, desde que o erro não esteja relacionado com:",oFont11N)
oPrint:Say(2170,0100,"I - as variáveis que determinam o valor do imposto tais como: base de cálculo, alíquota, diferença de preço, quantidade, valor da operação ou da prestação;",oFont11N)
oPrint:Say(2230,0100,"II - a correção de dados cadastrais que implique mudança do remetente ou do destinatário;",oFont11N)
oPrint:Say(2290,0100,"III - a data de emissão ou de saída.",oFont11N)

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Enviar CC-e por e-mail	          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function EnvMail()

if MsgYesNo("Deseja enviar e-mail da CC-e para o cliente?","Atenção")
	
	
	cArqCpy := oPrint:cPathPDF+substr(oPrint:cFileName,1,Len(oPrint:cFileName)-4)+".pdf"
	COPY FILE &cArqCpy to "\system\danfe_pdf\"+"cce_"+ALLTRIM(MV_PAR02)+".pdf"
	
	/*
	// Acha os e-mails dos clientes
	if MV_PAR01=1 //Saída
		cCliente	:= posicione("SF2",1,xFilial("SF2")+MV_PAR02+MV_PAR03,"F2_CLIENTE")+posicione("SF2",1,xFilial("SF2")+MV_PAR02+MV_PAR03,"F2_LOJA")
		cGet1		:= posicione("SA1",1,xFilial("SA1")+cCliente,"A1_EMAIL")
	else
		cCliente 	:= posicione("SF1",1,xFilial("SF1")+MV_PAR02+MV_PAR03,"F1_FORNECE")+posicione("SF1",1,xFilial("SF1")+MV_PAR02+MV_PAR03,"F1_LOJA")
		cGet1 		:= posicione("SA1",1,xFilial("SA1")+cCliente,"A1_EMAIL")
	endif
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a tela para a nova mensagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oFont		:= TFont():New("Tahoma",,-13,.T.,,,,,.F.)
	oDlg		:=  MSDialog():New(10,10,300,400,"Nova Mensagem",,,,,,,,,.T.)
	oSayLn1		:=  tSay()  :New(10,05,{|| IIF( MV_PAR01 = 2, "Fornecedor : "+cCliFor, "Cliente : "+cCliFor) },oDlg,,oFont,,,,.T.,,,270,40)
	
	oSayLn1		:=  tSay()  :New(35,05,{||"Para: "},oDlg,,oFont,,,,.T.,,,270,40)
	oGet1		:=	tGet()  :New(45,05,{|u| if(Pcount()>0,cGet1:=u,cGet1) },,180,08,,,,,,,,.T.,,,,,,,,,,"cGet1")
	oButton6	:=    tButton() :New(120,100,"&OK",oDlg,{|| oDlg:End()},30,12,,,,.T.)
	
	oDlg:Activate(,,,.T.,,,)
	
	cServer   		:= ALLTRIM(GETMV("MV_RELSERV")) //ALLTRIM(GETMV("MV_RELSERV"))+":587"
	cAccount  		:= GETMV("MV_RELACNT")
	cEnvia    		:= GETMV("MV_RELACNT")
	cPassword 		:= GETMV("MV_RELPSW")
	cRecebe			:= "asalgado@introde.com.br" //cGet1 //"raltafini@introde.com.br"
	cMensagem		:= ""
	aFiles 			:= { "SYSTEM\DANFE_PDF\"+"CCE_"+ALLTRIM(MV_PAR02)+".pdf" }
	
	cMensagem		:='<html>'
	cMensagem		+='<body>'
	cMensagem		+='<font face="Arial" size=3>Senhor Cliente,<p>'
	cMensagem		+='Segue em anexo a Carta de Correção referente a nota fiscal eletrônica nr.: '+alltrim(mv_par02)+'.</font><p>'
	cMensagem		+='<font face="Arial" size=3> Para consultar validade legal, acesse o site da Sefaz (http://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx) digite a chave de acesso constante na CC-e.</font><p>'
	cMensagem		+='<font face="Arial" size=5 color=#FF0000><u><b>Mensagem automática, favor não responder este e-mail.</b></u></font><p>'
	cMensagem		+='<font face="Arial" size=3> Atenciosamente,<br>'
	cMensagem		+='Departamento de Faturamento<br>'
	cMensagem		+='</body>'
	cMensagem		+='</html>'
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	MAILAUTH(cAccount,cPassword)
	
	SEND MAIL FROM cEnvia;
	TO cRecebe;
	SUBJECT "CC-e "+alltrim(MV_PAR02)+" - "+SM0->M0_NOMECOM ;
	BODY cMensagem ;
	ATTACHMENT aFiles[1];
	RESULT lEnviado
	
	If lEnviado
		Aviso("","E-Mail Enviado!",{"OK"})
	Else
		cMensagem := ""
		GET MAIL ERROR cMensagem
		Alert(cMensagem)
	Endif
	
	DISCONNECT SMTP SERVER Result lDisConectou
	
endif

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Potno Entrada P/ Adicionar a Rotina no Menu SPEDNFE	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function FISTRFNFE()
aadd(aRotina,{'Imprimir CCe','U_PrintCCe' , 0 , 3,0,NIL})
Return Nil
