#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÂÄÂÄÂÄÂÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ TMKR0001³ Autor ³ ANDRE SALGADO / INTRODE          ³ Data 30/03/2021 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³  APRESENTAR EM TELA AS NOTAS EMITIDAS CONTRA O CLIENTE SELECIONADO ³±±
±±³ Solicitado ³                       	                     			            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³   Solicitação - Luana / Daniella - Autorização Genilson              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/
User Function TMKR0001()

Local nx:=0
Private oWindow
Private oOK 		:= LoadBitmap(GetResources(),'br_verde')
Private oNO 		:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias		:= GetNextAlias()
Private oFont 		:= TFont():New('Courier new',,-14,.F.,.T.)
Private oFont1		:= TFont():New('Courier new',,-14,.F.,.T.)
Private cGet1		:= Space(6)
Private aBrowse		:= {}

Private cCodCli		:= ""
Private cCliente    := ""
Private cCnpj		:= ""	
Private cMun		:= ""
Private cUf			:= ""
Private cNomeTra    := ""

Private nCont		:= 0
Private nQtdVol     := 0
Private nTotVB		:= 0				//Total por Valor
Private nTotPB		:= 0				//Total por Pesos
Private nTotVol		:= 0				//Total Volume
Private nTotOcor	:= 0				//Total por Ocorrencia
Private nTotOcor2	:= 0				//Total por Ocorrencia
Private dInic1		:= ddatabase-365	//Sugestão da Data Inicial da Pesquisa
Private dInic2		:= ddatabase		//Sugestão da Data Final da Pesquisa
Private cLoja1      := "01"				//Deixei como padrão a Loja "01" mais o usuario pode alterar
Private lRep		:= .F.

Private _cVend1		:= space(06)	//Sugestão da Data Inicial da Pesquisa
Private _cVend2		:= "ZZZZZZ"		//Sugestão da Data Inicial da Pesquisa

//Apresenta Tela do Usuario
TELAPV()

Return()


Static Function TELAPV() 

//Arry dos Campos
If Len(aBrowse) == 0
	aAdd(aBrowse,{.F.,SPACE(07), SPACE(12), CTOD(" / / "), 0, 0, 0, SPACE(20),SPACE(15), SPACE(15), SPACE(10), SPACE(20)})
Endif

aSize 		:= {}
aObjects	:= {}

aSize	:= MsAdvSize( .F. )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 100, 060, .T., .T. } )

aPosObj	:= MsObjSize(aInfo,aObjects)
aPosGet	:= MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

DEFINE MSDIALOG oWindow FROM aSize[7],aSize[1] TO aSize[6],aSize[5] TITLE Alltrim(OemToAnsi("ANALISE DO MOVIMENTO DO CLIENTE")) Pixel

@ 002, 005 To aPosObj[1][3]-30, aPosObj[1][4]+4 Label Of oWindow Pixel

oSay3  	:= TSay():New(009.5,010,{|| "CLIENTE: " },oWindow,,oFont,,,,.T.,)
@ 008,060 Get cGet1  picture "@E 999999" F3"SA1" size 44.5,10 //OF oWindow PIXEL
@ 008,105 Get cLoja1 picture "@E 99" 

@ 008,130 Button "PESQUISAR"  size 65,12 action Processa( {|| BUSCARPV()}, "AGUARDE...", "PESQUISANDO...") OF oWindow PIXEL

oSay1  	:= TSay():New(028,010,{|| "CODIGO/CLIENTE: " },oWindow,,oFont,,,,.T.,)
oSay5  	:= tSay():New(028,080,{|| cCodCli +" - "+ Alltrim(cCliente) },oWindow,,oFont,,,,.T.,,,350,20)

oSay1  	:= TSay():New(009.5,240,{|| "Periodo NF: " },oWindow,,oFont,,,,.T.,)
@ 008,290 Get dInic1 size 44.5,10 
oSay1  	:= TSay():New(009.5,345,{|| "a" },oWindow,,oFont,,,,.T.,)
@ 008,360 Get dInic2 size 44.5,10 

/*
oSay1  	:= TSay():New(028.5,240,{|| "Vendedor De: " },oWindow,,oFont,,,,.T.,)
@ 028,290 Get _cVend1 F3"SA3" size 44.5,10 
oSay1  	:= TSay():New(028.5,345,{|| "a" },oWindow,,oFont,,,,.T.,)
@ 028,360 Get _cVend2 F3"SA3" size 44.5,10 
*/

oSay1  	:= TSay():New(042,010,{|| "CNPJ " },oWindow,,oFont,,,,.T.,)
oSay5  	:= tSay():New(042,080,{|| if(len(cCnpj)>=12,transform(cCnpj,"@R 99.999.999/9999-99"),transform(cCnpj,"@R 999.999.999-99"))},oWindow,,oFont,,,,.T.,,,200,20)

oSay1  	:= TSay():New(054,010,{|| "MUN / EST " },oWindow,,oFont,,,,.T.,)
oSay5  	:= tSay():New(054,080,{|| Alltrim(cMun) +" / "+ Alltrim(cUf) },oWindow,,oFont,,,,.T.,,,200,20)

//oSay9  	:= TSay():New(054,aPosGet[1][3]+60,{|| "% Ocorrencia: " + Alltrim(Transfor(round(nTotOcor,2)/round(nCont,2),"@E 9999.99")) },oWindow,,oFont,,,,.T.,)
oSay9  	:= TSay():New(054,aPosGet[1][3]+60,{|| "% Ocorrencia: " + Alltrim(Transfor((1-(round(nTotOcor2,2)/round(nCont,2)))*100,"@E 9999.99")) },oWindow,,oFont,,,,.T.,)


@ 008,aPosGet[1][3]+60 Button "FECHAR"  size 65,12 action oWindow:End() OF oWindow PIXEL
@ 024,aPosGet[1][3]+60 Button "EXCEL"   size 65,12 action (geraexcel(), oWindow:End())



//Rodape com os Totais
oSay4  	:= TSay():New(aPosObj[2][3]-20,010,{|| "Total de NF's Selecionadas: " + Transfor(nCont,"@999999") },oWindow,,oFont,,,,.T.,)
oSay6  	:= TSay():New(aPosObj[2][3]-20,aSize[6]-420,{|| "Total Valor NF: " + Alltrim(Transfor(nTotVB,"@E 999,999,999.99")) },oWindow,,oFont,,,,.T.,)
oSay7  	:= TSay():New(aPosObj[2][3]-20,aSize[6]-270,{|| "Total Peso: " + Alltrim(Transfor(nTotPB,"@E 999,999.9999")) },oWindow,,oFont,,,,.T.,)
oSay8  	:= TSay():New(aPosObj[2][3]-20,aSize[6]-120,{|| "Total Volumes: " + Alltrim(Transfor(nTotVol,"@E 999,999")) },oWindow,,oFont,,,,.T.,)
oSay9  	:= TSay():New(aPosObj[2][3]-20,aSize[6]-020,{|| "Ocorrencia: " + Alltrim(Transfor(nTotOcor,"@E 999,999")) },oWindow,,oFont,,,,.T.,)

oListBox	:= twBrowse():New(0075,0005,aPosObj[1][4]-1,aPosObj[2][3]-100,,{" ","DISTR.","NOTA FISCAL","EMISSAO","VALOR NF","PESO","VOLUME","TRANSPORTADORA","GERENTE","VENDEDOR","CHAMADO","OCORRENCIA"},{02,02,10,40,30,30,40,40,40,10,10,40},oWindow,,,,,,,oFont1,,,,,.F.,,.T.,,.F.,,,)

//Check
oListBox:SetArray(aBrowse)
oListBox:bLine := {||{ IIf(aBrowse[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),; //flag
aBrowse[oListBox:nAt,02],;
aBrowse[oListBox:nAt,03],;
aBrowse[oListBox:nAt,04],;
aBrowse[oListBox:nAt,05],;
aBrowse[oListBox:nAt,06],;
aBrowse[oListBox:nAt,07],;
aBrowse[oListBox:nAt,08],;
aBrowse[oListBox:nAt,09],;
aBrowse[oListBox:nAt,10],;
aBrowse[oListBox:nAt,11],;
aBrowse[oListBox:nAt,12]}} 

oListBox:bLDblClick := {|| Iif(oListBox:nColPos <> 5,(aBrowse[oListBox:nAt,1] := !aBrowse[oListBox:nAt,1]),(aBrowse[oListBox:nAt,1] := .T.,)), oListBox:Refresh(), ATUACOLS(), oSay4:Refresh(), oSay6:Refresh(), oSay7:Refresh(), oSay8:Refresh() } 

oWindow:Refresh()
oListBox:Refresh()
oSay4:Refresh()
oSay6:Refresh()
oSay7:Refresh()
oSay8:Refresh()

ACTIVATE MSDIALOG oWindow centered

Return()

//========================================================================//
// 								Pesquisar								  //
//========================================================================//
Static Function BUSCARPV()

aBrowse	:= {}

If Select("TRBSC6A") > 0
	TRBSC6A->( dbCloseArea() )
EndIf


cQrySZO :=	" SELECT "

//Distribuidoras
cQrySZO	+= " CASE F2_FILIAL WHEN '0101' THEN 'CIMEX' WHEN '0201' THEN 'CROZE' WHEN '0301' THEN 'KOPEK'"
cQrySZO	+= "                WHEN '0401' THEN 'MACO'  WHEN '0501' THEN 'QUBIT' WHEN '0601' THEN 'ROJA'"
cQrySZO	+= "                WHEN '0701' THEN 'VIXEN' WHEN '0801' THEN 'MAIZE' WHEN '0901' THEN 'DEVINTEX'"
cQrySZO	+= "                WHEN '1101' THEN 'BIZEZ' WHEN '1201' THEN 'ZAKAT' WHEN '1301' THEN 'HEXIL'"
cQrySZO	+= "                ELSE F2_FILIAL END F2_FILIAL,"

//Cabeçalho
cQrySZO +=	" F2_CLIENTE+'/'+F2_LOJA F2_CLIENTE, A1_NOME, A1_CGC, A1_MUN,A1_EST, "

//Linha
cQrySZO +=	" F2_DOC, F2_EMISSAO, F2_VALBRUT, F2_PBRUTO, F2_VOLUME1, A4_NREDUZ, "
cQrySZO +=	" AG.A3_NREDUZ GERENTE, A3.A3_NREDUZ F2_VEND1, CHAMADO, U9_DESC"

cQrySZO +=	" FROM SF2020 F2 (NOLOCK)"
cQrySZO +=	" INNER JOIN SA1020 A1 (NOLOCK) ON F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' '"
cQrySZO +=	" LEFT JOIN  SA3020 A3 (NOLOCK) ON F2_VEND1=A3.A3_COD AND A3.D_E_L_E_T_=' ' "
cQrySZO +=	" LEFT JOIN  SA4020 A4 (NOLOCK) ON F2_TRANSP=A4_COD AND A4.D_E_L_E_T_=' ' "
cQrySZO +=	" LEFT JOIN  SA3020 AG (NOLOCK) ON A3.A3_GEREN=AG.A3_COD AND AG.D_E_L_E_T_=' ' "

cQrySZO +=	" LEFT JOIN ("
cQrySZO +=	" SELECT MAX(UD_CODIGO+'-'+UD_ITEM) CHAMADO, UD_FILIAL, RIGHT('000000000'+RTRIM(UD_NNF),9) NOTA,"
cQrySZO +=	" UD_OCORREN, U9_DESC "
cQrySZO +=	" FROM SUD020 UD (NOLOCK)"
cQrySZO +=	" INNER JOIN SU9020 U9 (NOLOCK) ON UD_OCORREN= U9_CODIGO AND U9.D_E_L_E_T_=' '"
cQrySZO +=	" WHERE UD.D_E_L_E_T_=' ' AND UD_NNF<>' '  AND UD_DATA>='20210101'"
cQrySZO +=	" GROUP BY UD_FILIAL, UD_OCORREN,U9_DESC, UD_NNF)CALL ON F2_FILIAL=UD_FILIAL AND F2_DOC=NOTA"

cQrySZO +=	" WHERE F2.D_E_L_E_T_=' ' "

//Solicitação Luana, não filtar pela Filial Logada, trazer todas 
//cQrySZO +=	"       AND F2_FILIAL = '"+xFilial("SF2")+"' "

//Conforme solicitação da Luana/CallCenter, trazer automatico o periodo do Faturamento dos ultimos 12 meses
cQrySZO +=	" AND F2_EMISSAO BETWEEN '"+dtos(dInic1)+"' AND '"+dtos(dInic2)+"' "
cQrySZO +=	" AND F2_VEND1   BETWEEN '"+_cVend1+"' AND '"+_cVend2+"' "
cQrySZO +=	" AND F2_CLIENTE = '"+cGet1+"'  "
cQrySZO +=	" AND F2_LOJA    = '"+cLoja1+"' "
cQrySZO +=	" ORDER BY F2_FILIAL, F2_CLIENTE, F2_DOC"

TCQUERY cQrySZO NEW ALIAS "TRBSC6A"
dbSelectArea("TRBSC6A")
TRBSC6A->(dbGoTop())

lImp        := .T.
nCont       := 0
nTotVB		:= 0
nTotPB		:= 0
nTotVol		:= 0
nTotOcor	:= 0
nTotOcor2	:= 0

cCodCli		:= TRBSC6A->F2_CLIENTE
cCliente    := TRBSC6A->A1_NOME
cCnpj		:= TRBSC6A->A1_CGC
cMun		:= TRBSC6A->A1_MUN
cUf			:= TRBSC6A->A1_EST

While TRBSC6A->(!EOF())   

	// 11/01/2022 Não Marcar as Notas Repetidas
	For nX := 1 To Len(aBrowse)
		If Alltrim(TRBSC6A->F2_DOC) = Alltrim(aBrowse[nX][3])
			lRep := .T.
		Endif
	Next

//    nCont++
    
	aAdd(aBrowse,{lImp,;
	Alltrim(TRBSC6A->F2_FILIAL),;
	Alltrim(TRBSC6A->F2_DOC),;
	DTOC(STOD(TRBSC6A->F2_EMISSAO)),;
	Transform(TRBSC6A->F2_VALBRUT,"@E 999,999,999.99"),;
	Transfor(TRBSC6A->F2_PBRUTO,"@E 999,999.9999"),;
	Transform(TRBSC6A->F2_VOLUME1,"@E 9999,999"),;
	Alltrim(TRBSC6A->A4_NREDUZ),;
	Alltrim(TRBSC6A->GERENTE),;
	Alltrim(TRBSC6A->F2_VEND1),;
	Alltrim(TRBSC6A->CHAMADO),;
    Alltrim(TRBSC6A->U9_DESC)})

//	nTotVB 	+= TRBSC6A->F2_VALBRUT
//	nTotPB	+= TRBSC6A->F2_PBRUTO
//	nTotVol	+= TRBSC6A->F2_VOLUME1

	if !Empty(TRBSC6A->CHAMADO)
		nTotOcor += 1
	Endif


//oSay9  	:= TSay():New(054,aPosGet[1][3]+60,{|| "% Ocorrencia: " + Alltrim(Transfor(round(nTotOcor,2)/round(nCont,2),"@E 9999.99")) },oWindow,,oFont,,,,.T.,)

	If !lRep

		if !Empty(TRBSC6A->CHAMADO)
			nTotOcor2 += 1
		Endif


		nCont++
		nTotVB 	+= TRBSC6A->F2_VALBRUT
		nTotPB	+= TRBSC6A->F2_PBRUTO
		nTotVol	+= TRBSC6A->F2_VOLUME1
	Endif

	lRep := .F.	

	TRBSC6A->(dbSkip())

Enddo

//geraexcel()

oListBox:SetArray(aBrowse)
oListBox:bLine := {||{ IIf(aBrowse[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),; //flag
aBrowse[oListBox:nAt,02],;
aBrowse[oListBox:nAt,03],;
aBrowse[oListBox:nAt,04],;
aBrowse[oListBox:nAt,05],;
aBrowse[oListBox:nAt,06],;
aBrowse[oListBox:nAt,07],;
aBrowse[oListBox:nAt,08],;
aBrowse[oListBox:nAt,09],;
aBrowse[oListBox:nAt,10],;
aBrowse[oListBox:nAt,11],;
aBrowse[oListBox:nAt,12]}} 

//a tabela esta populada

oWindow:Refresh()
oSay5:Refresh()

//TRBSC6A->(DbCloseArea())

Return()

//========================================================================//
// 			ATUALIZAR ACOLS DO QUE FOI FLEGADO (INCLUIR)				  //
//========================================================================//

Static Function ATUACOLS()

Local nx:=0
nCont 	:= 0	//Sempre Zera para Calcular novamente
nTotVB	:= 0
nTotPB	:= 0
nTotVol	:= 0
nTotOcor:= 0 

For nx := 1 To Len(aBrowse)
	
	If aBrowse[nx][1]	//Campo MARCADO (.T.)
		nCont 	+= 1
		nTotVB	+= Val(StrTran(StrTran(aBrowse[nx][5],".",""),",","."))
		nTotPB	+= Val(StrTran(StrTran(aBrowse[nx][6],".",""),",","."))
		nTotVol	+= Val(StrTran(StrTran(aBrowse[nx][7],".",""),",","."))

		IF !EMPTY(aBrowse[nx][11])
			nTotOcor += 1
		ENDIF

	Endif
			
Next nx

Return()




//Gera Arquivo Em Excel
Static Function GeraExcel()

Local oExcel
Local oFWMsExcel
Local aWorkSheet	:= {}
Local cWorkSheet	:= "Relatorio de Conta Corrente"
Local cTable		:= cWorkSheet
Local aColunas		:= {}
Local cHora		    := Time()
Local cFilePath		:= GetTempPath()+'Conta Corrente_' +substr(cCodcli,1,6)+'_'+ DtoS(dinic1) + '_' + DtoS(dinic2)+'.xls'
Local aLinhaAux		:= {}
Private aXMLCol		:= {}
Private aXMLRow		:= {}


If Select("TRBSC6A") > 0

	TRBSC6A->(dbgotop()) 

	aAdd(aWorkSheet,'Conta Corrente - '+TRBSC6A->F2_CLIENTE+' '+trim(TRBSC6A->A1_NOME))
	oFWMsExcel:= FWMSExcel():New()
	oFWMsExcel:AddworkSheet( aWorkSheet[1] )    
	oFWMsExcel:AddTable( aWorkSheet[1], aWorkSheet[1] )
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "FILIAL"		,2,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "DOC"		,1,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "EMISSAO"	,2,1,.F.)	
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "VALOR"		,2,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "PESO"		,2,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "VOLUME"		,2,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "TRANSPORTADORA"	,2,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "GERENTE"	,1,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "VENDEDOR"	,3,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "CHAMADO"	,3,1,.F.)
	oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "OCORRENCIA"	,3,1,.F.)


	While TRBSC6A->(!EOF())   

		oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], ;
		{Alltrim(TRBSC6A->F2_FILIAL), ;
		Alltrim(TRBSC6A->F2_DOC), ;
		DTOC(STOD(TRBSC6A->F2_EMISSAO)),;
		Transform(TRBSC6A->F2_VALBRUT,"@E 999,999,999.99"),;
		Transfor(TRBSC6A->F2_PBRUTO,"@E 999,999.9999"),;
		Transform(TRBSC6A->F2_VOLUME1,"@E 9999,999"),;
		Alltrim(TRBSC6A->A4_NREDUZ),;
		Alltrim(TRBSC6A->GERENTE),;
		Alltrim(TRBSC6A->F2_VEND1),;
		Alltrim(TRBSC6A->CHAMADO),;
		Alltrim(TRBSC6A->U9_DESC)})
		TRBSC6A->(dbSkip())

	Enddo
	TRBSC6A->(dbclosearea())

	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cFilePath)
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cFilePath)
	oExcel:SetVisible(.T.)
	oExcel:Destroy()
	
Endif

Return
