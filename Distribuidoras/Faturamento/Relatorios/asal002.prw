//*****************************************************
// Programa - Relatorio em Excel dos Pedidos em Aberto
// Solicitação - Clovis / Claudia
// Autor - Rogerio/Andre / Introde - 27/08/2021
//*****************************************************
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function asal002()

Private cTitulo		:= "Relacao Pedidos em Aberto"
Private cPerg		:= "asal002"

Processa({|| GeraExcel()	, "Gerando Arquivo Excel ..."})

Return


//Processa o arquivo Excel
Static Function GeraExcel() 

//Local nFormat		:= 1
Local oExcel
Local oFWMsExcel
Local aWorkSheet	:= {}
Local cWorkSheet	:= "Relatorio"
Local cTable		:= cWorkSheet
Local aColunas		:= {}
Local cHora		    := Time()
Local cFilePath		:= GetTempPath()+'Relatorio_' + DtoS(ddatabase) + '_' + SubStr(cHora,1,2) + SubStr(cHora,4,2) + '.xls'
Local aLinhaAux		:= {}
Private oExcel
Private aXMLCol		:= {}
Private aXMLRow		:= {}

aAdd(aWorkSheet,'Pedido_Aberto')

oFWMsExcel:= FWMSExcel():New()
oFWMsExcel:AddworkSheet( aWorkSheet[1] )    

oFWMsExcel:AddTable( aWorkSheet[1], aWorkSheet[1] )

oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "EMPRESA"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "PEDIDO"	,1,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "PRIORID"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "COD_CLI"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "CLIENTE"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "EMISSAO"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "STATUS_"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "COND_PA"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "GERENTE"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "REPRESE"	,1,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "UF"		,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "CIDADE"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "TRANSPO"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "PESO"	,3,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "QUANT"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "VALOR"	,2,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "NR_ONDA"	,2,1,.F.)


//BeginSql alias "TRB"
        cQuery1 := " SELECT "
        cQuery1 += " LEFT(X5_DESCRI,10) EMPRESA, C5_NUM PEDIDO, "
        cQuery1 += " CASE A1_X_PRIOR WHEN '0' THEN '0=VIP' WHEN '1' THEN '1=VIP' ELSE 'Normal' end PRIORID,"
        cQuery1 += " C5_CLIENTE+' '+C5_LOJACLI COD_CLI, A1_NOME CLIENTE, C5_EMISSAO EMISSAO, "
        cQuery1 += " CASE C5_X_STAPV WHEN '0' THEN 'PV GERADO' WHEN '1' THEN 'PV LIBERADO'  WHEN '5' THEN 'CONFERENCIA FINALIZADA' ELSE 'FATURADO' END AS STATUS_, E4_DESCRI COND_PA,"
        cQuery1 += " AG.A3_NREDUZ GERENTE,"
        cQuery1 += " A3.A3_NREDUZ REPRESE,"
        cQuery1 += " A1_EST UF, A1_BAIRRO CIDADE, A4_NOME TRANSPO,"
        cQuery1 += " ROUND(SUM(C6_QTDVEN*B1_PESBRU),2) PESO,"
        cQuery1 += " SUM(C6_QTDVEN) QUANT, SUM(C6_VALOR) VALOR,"
        cQuery1 += " C5_X_NONDA NR_ONDA"

        cQuery1 += " FROM SC5020 C5 (NOLOCK)"
        cQuery1 += " INNER JOIN SC6020 C6 (NOLOCK) ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C6.D_E_L_E_T_=' ' "
        cQuery1 += " INNER JOIN SA1020 A1 (NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND  A1.D_E_L_E_T_=' ' "
        cQuery1 += " INNER JOIN SE4020 E4 (NOLOCK) ON C5_CONDPAG=E4_CODIGO AND E4.D_E_L_E_T_=' ' "
        cQuery1 += " INNER JOIN SB1020 B1 (NOLOCK) ON C6_PRODUTO=B1_COD AND B1.D_E_L_E_T_=' ' "
        cQuery1 += " INNER JOIN SX5020 X5 (NOLOCK) ON X5_FILIAL='0101' AND X5_TABELA='ZE' AND C5_FILIAL=LEFT(X5_CHAVE,4) AND X5.D_E_L_E_T_=' '"
        cQuery1 += " LEFT JOIN SA4020 A4 (NOLOCK) ON C5_TRANSP=A4_COD AND A4.D_E_L_E_T_='' "
        cQuery1 += " LEFT JOIN SA3020 A3 (NOLOCK) ON C5_VEND1=A3.A3_COD AND A3.D_E_L_E_T_=' ' "
        cQuery1 += " LEFT JOIN SA3020 AG (NOLOCK) ON A3.A3_GEREN=AG.A3_COD AND AG.D_E_L_E_T_=' ' "

        cQuery1 += " WHERE C5.D_E_L_E_T_=' ' "
        cQuery1 += " AND C5_EMISSAO>='20210801' "
        cQuery1 += " AND C5_NOTA=' ' "
        cQuery1 += " AND C5_X_STAPV<>'C' "

        cQuery1 += " GROUP BY "
        cQuery1 += " C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO,C5_X_STAPV, E4_DESCRI,AG.A3_NREDUZ,A3.A3_NREDUZ,A1_EST, A1_BAIRRO, A4_NOME,C5_X_NONDA"
        cQuery1 += " ,A1_X_PRIOR ,LEFT(X5_DESCRI,10)"

        cQuery1 += " ORDER BY 1,3,2"

	MPSysOpenQuery( cQuery1, "QRY" )
	DbSelectArea("QRY")

	While QRY->( !Eof() )
		oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], { QRY->EMPRESA, QRY->PEDIDO, QRY->PRIORID, QRY->COD_CLI, QRY->CLIENTE, stod(QRY->EMISSAO), QRY->STATUS_, QRY->COND_PA, QRY->GERENTE, QRY->REPRESE, QRY->UF, QRY->CIDADE, QRY->TRANSPO, QRY->PESO, QRY->QUANT, QRY->VALOR, QRY->NR_ONDA } )
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
