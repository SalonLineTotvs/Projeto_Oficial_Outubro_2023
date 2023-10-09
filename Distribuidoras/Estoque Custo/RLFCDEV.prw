#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function RLFCDEV()

//Local aFields		:= {}
Private cTitulo		:= "Relacao das Devolucoes"
Private cPerg		:= "RLFCDEV"

IF !Pergunte("RLFCDEV",.T.)  // Pergunta no SX1
   Return
Endif

Processa({|| GeraExcel()	, "Gerando Arquivo Excel das Devolucoes ..."})

Return

Static Function GeraExcel()

//Local nFormat		:= 1
Local oExcel
Local oFWMsExcel
Local aWorkSheet	:= {}
Local cWorkSheet	:= "Relatorio de Devolucoes"
Local cTable		:= cWorkSheet
Local aColunas		:= {}
Local cHora		    := Time()
Local cFilePath		:= GetTempPath()+'Devolucoes_' + DtoS(ddatabase) + '_' + SubStr(cHora,1,2) + SubStr(cHora,4,2) + '.xls'
Local aLinhaAux		:= {}
Private oExcel
Private aXMLCol		:= {}
Private aXMLRow		:= {}

aAdd(aWorkSheet,'Devolucoes '+dtoc(mv_par01)+' a '+dtoc(mv_par02))

oFWMsExcel:= FWMSExcel():New()
oFWMsExcel:AddworkSheet( aWorkSheet[1] )    

oFWMsExcel:AddTable( aWorkSheet[1], aWorkSheet[1] )

oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "EMPRESA"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "DT_DIGIT"	,1,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "NOTA"		,2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "COD_FORN"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "LOJA"		,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "RAZAO_S"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "CFOP"		,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "EMISSAO"	,1,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "TOTAL"		,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "DESCONTO"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "PROD_LIQ"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "ICMS_ST"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "NF_ORIG"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "SERIE"		,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "FORM_PROP"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "TIP"		,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "PRODUTO"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "DESCRIC"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "VLR_FECP"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "CLASFIS"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "MENS_NF"	,2,1,.F.)

//BeginSql alias "TRB"

	cquery:= " SELECT CASE D1_FILIAL "
	cquery+= " WHEN '0101' THEN 'CIMEX'       "
	cquery+= " WHEN '0201' THEN 'CROZE'       "
	cquery+= " WHEN '0301' THEN 'KOPEK'       "
	cquery+= " WHEN '0401' THEN 'MACO '       "
	cquery+= " WHEN '0501' THEN 'QUBIT'       "
	cquery+= " WHEN '0601' THEN 'ROJA '       "
	cquery+= " WHEN '0701' THEN 'VIXEN'       "
	cquery+= " WHEN '0801' THEN 'MAIZE'       "
	cquery+= " WHEN '0901' THEN 'DEVINTEX FILIAL'  "
	cquery+= " WHEN '0902' THEN 'DEVINTEX FILIAL - MG'"
	cquery+= " WHEN '1001' THEN 'GLAZY'"
	cquery+= " WHEN '1101' THEN 'BIZEZ'"
	cquery+= " WHEN '1201' THEN 'ZAKAT'"
	cquery+= " WHEN '1301' THEN 'HEXIL' END EMPRESA, "

	cquery+= " D1_DTDIGIT DT_DIGIT, "
	cquery+= " D1_DOC NOTA, D1_FORNECE COD_FORN, D1_LOJA LOJA, A1_NOME RAZAO_S, D1_CF CFOP, "
	cquery+= " D1_EMISSAO EMISSAO, D1_TOTAL TOTAL, D1_VALDESC DESCONTO,  (D1_TOTAL - D1_VALDESC) PROD_LIQ, "
	cquery+= " D1_ICMSRET ICMS_ST, D1_NFORI NF_ORIG, D1_SERIE SERIE, D1_FORMUL FORM_PROP, D1_TIPO TIP, "
	cquery+= " D1_COD PRODUTO, B1_DESC DESCRIC, D1_VFECPST VLR_FECP, D1_CLASFIS CLASFIS, F1_MENNOTA MENS_NF"
	cquery+= " FROM SD1020 D1 (NOLOCK)"
	cquery+= " INNER JOIN SF1020 F1 (NOLOCK) ON F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE"
	cquery+= " 				AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND F1_TIPO = D1_TIPO AND F1.D_E_L_E_T_ = ''"
	cquery+= " 	INNER JOIN SA1020 A1 (NOLOCK) ON A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA AND A1.D_E_L_E_T_ = ''"
	cquery+= " 	INNER JOIN SB1020 B1 (NOLOCK) ON B1.D_E_L_E_T_ = ''AND  B1_COD = D1_COD"
	cquery+= " WHERE D1.D_E_L_E_T_ = '' "
	cquery+= " AND D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cquery+= " AND D1_TIPO = 'D'"
	cquery+= " ORDER BY 1 , 2"

	MPSysOpenQuery( cQuery, "QRY" )
	DbSelectArea("QRY")

	While QRY->( !Eof() )
		oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], {  QRY->EMPRESA, stod(QRY->DT_DIGIT), QRY->NOTA	, QRY->COD_FORN, QRY->LOJA, QRY->RAZAO_S, QRY->CFOP, stod(QRY->EMISSAO), QRY->TOTAL, QRY->DESCONTO, QRY->PROD_LIQ, QRY->ICMS_ST, QRY->NF_ORIG, QRY->SERIE, QRY->FORM_PROP, QRY->TIP, QRY->PRODUTO, QRY->DESCRIC, QRY->VLR_FECP, QRY->CLASFIS, QRY->MENS_NF } )
		QRY->( Dbskip() )
	End
	
	DBSELECTAREA("QRY")
	DBSKIP()
	
//END

MsgAlert("Planilha Gerada em: "+(cFilePath)) 

oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cFilePath)
oExcel := MsExcel():New()
oExcel:WorkBooks:Open(cFilePath)
oExcel:SetVisible(.T.)
oExcel:Destroy()

Return

//cria as perguntas
Static Function AjustaSX1()
PutSx1('RLFCDEV', "01", "Data De?" , "Ordem ?", 		"Ordem ?", 		  "mv_ch1", "D", 08, 0, 1, "G","","", "", "", "mv_par01",,,,,,,,,,,,,,,,,	{"Emissao da Fatura De", "", ""},{},{} )
PutSx1('RLFCDEV', "02", "Data Ate?", "Ordem ?", 		"Ordem ?", 		  "mv_ch2", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Emissao da Fatura Ate", "", ""},{},{} )
Return
