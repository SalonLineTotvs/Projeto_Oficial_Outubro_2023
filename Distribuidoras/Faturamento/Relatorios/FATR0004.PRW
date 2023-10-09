//Programa - Relatorio Analise das Saidas (NF-e) 
//Solicitado - Fernando Medeiros / Autorizado Genilson Lucas
//Autor - Andre Salgado / Introde - 14/05/2018
#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

User function FATR0004()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("FATR04",10,"X")
Private cTitulo		:= "RELATORIO ANALISE ITENS SAIDA (NFE)"


If TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que cria as perguntas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	AjustaSX1()
	Pergunte(cPerg, .T. )
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport)},"Este relatorio ira imprimir, conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SD2","SB1","SC5","SF4"})


TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(10))
TRCell():New(oSection1,"D2_PEDIDO"		,"TRB",,,(06))
TRCell():New(oSection1,"C5_EMISSAO"		,"TRB","Dt Pedido",,(10))
TRCell():New(oSection1,"D2_CLIENTE"		,"TRB",,,(06))
TRCell():New(oSection1,"D2_LOJA"		,"TRB",,,(02))
TRCell():New(oSection1,"A1_NOME"		,"TRB",,,(40))
TRCell():New(oSection1,"D2_DOC"			,"TRB",,,(09))
TRCell():New(oSection1,"D2_EMISSAO"		,"TRB","Dt Nota",,(10))

//***********************
//Relatorio Analitico
//***********************
IF MV_PAR01=1
	TRCell():New(oSection1,"D2_COD"			,"TRB",,,(15))
	TRCell():New(oSection1,"B1_DESC"		,"TRB",,,(40))
Endif

TRCell():New(oSection1,"D2_QUANT"		,"TRB",,,(14))
TRCell():New(oSection1,"D2_TOTAL"		,"TRB",,,(14))
TRCell():New(oSection1,"D2_TES"			,"TRB",,,(03))
TRCell():New(oSection1,"D2_CF"			,"TRB",,,(04))
TRCell():New(oSection1,"F4_TEXTO"		,"TRB",,,(30))
TRCell():New(oSection1,"F4_ESTOQUE"		,"TRB",,,(01))
TRCell():New(oSection1,"F4_DUPLIC"		,"TRB",,,(01))


Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)


//***********************
//Relatorio Analitico
//***********************
IF MV_PAR01=1

	oSection1:BeginQuery()
	BeginSQL alias 'TRB'


	SELECT
             CASE
             WHEN D2_FILIAL='0101' THEN 'CIMEX'
             WHEN D2_FILIAL='0201' THEN 'CROZE'
             WHEN D2_FILIAL='0301' THEN 'KOPEK'
             WHEN D2_FILIAL='0401' THEN 'MACO'
             WHEN D2_FILIAL='0501' THEN 'QUBIT'
             WHEN D2_FILIAL='0601' THEN 'ROJA'
             WHEN D2_FILIAL='0701' THEN 'VIXEN'
             WHEN D2_FILIAL='0801' THEN 'MAIZE'
             WHEN D2_FILIAL='0901' THEN 'DEVINTEX'
             ELSE D2_FILIAL END EMPRESA, D2_PEDIDO, C5_EMISSAO, D2_CLIENTE, D2_LOJA,A1_NOME, D2_DOC, D2_EMISSAO, D2_COD,
                    B1_DESC, D2_QUANT, D2_TOTAL, D2_TES, D2_CF, F4_TEXTO, F4_ESTOQUE, F4_DUPLIC

	FROM %table:SD2% D2
       INNER JOIN %table:SC5% C5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND C5.D_E_L_E_T_ = ''
       INNER JOIN %table:SF4% F4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4.D_E_L_E_T_ = ''
       INNER JOIN %table:SA1% A1 ON A1_COD = D2_CLIENTE AND D2_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ''
       INNER JOIN %table:SB1% B1 ON D2_COD = B1_COD AND B1.D_E_L_E_T_ = ''

	WHERE D2.D_E_L_E_T_ = ''
	//	--FILTRAR POR EMISSÃO NF/pedido E FILIAL
		AND D2_EMISSAO BETWEEN %Exp:DTOS(MV_PAR02)% and %Exp:DTOS(MV_PAR03)%
		AND C5_NUM     BETWEEN %Exp:MV_PAR04% and %Exp:MV_PAR05%
		AND D2_FILIAL  BETWEEN %Exp:MV_PAR06% and %Exp:MV_PAR07% 

	ORDER BY 1, 2
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()



//***********************
//Relatorio Sintetico
//***********************
ElseIF MV_PAR01=2

	oSection1:BeginQuery()
	BeginSQL alias 'TRB'


	SELECT
             CASE
             WHEN D2_FILIAL='0101' THEN 'CIMEX'
             WHEN D2_FILIAL='0201' THEN 'CROZE'
             WHEN D2_FILIAL='0301' THEN 'KOPEK'
             WHEN D2_FILIAL='0401' THEN 'MACO'
             WHEN D2_FILIAL='0501' THEN 'QUBIT'
             WHEN D2_FILIAL='0601' THEN 'ROJA'
             WHEN D2_FILIAL='0701' THEN 'VIXEN'
             WHEN D2_FILIAL='0801' THEN 'MAIZE'
             WHEN D2_FILIAL='0901' THEN 'DEVINTEX'
             ELSE D2_FILIAL END EMPRESA, 
             	D2_PEDIDO, C5_EMISSAO, D2_CLIENTE, D2_LOJA,A1_NOME, D2_DOC, D2_EMISSAO, D2_TES, D2_CF, F4_TEXTO, F4_ESTOQUE, F4_DUPLIC,
				SUM(D2_QUANT) D2_QUANT, SUM(D2_TOTAL) D2_TOTAL

	FROM %table:SD2% D2
       INNER JOIN %table:SC5% C5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND C5.D_E_L_E_T_ = ''
       INNER JOIN %table:SF4% F4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4.D_E_L_E_T_ = ''
       INNER JOIN %table:SA1% A1 ON A1_COD = D2_CLIENTE AND D2_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ''
       INNER JOIN %table:SB1% B1 ON D2_COD = B1_COD AND B1.D_E_L_E_T_ = ''

	WHERE D2.D_E_L_E_T_ = ''
	//	--FILTRAR POR EMISSÃO NF/pedido E FILIAL
		AND D2_EMISSAO BETWEEN %Exp:DTOS(MV_PAR02)% and %Exp:DTOS(MV_PAR03)%
		AND C5_NUM     BETWEEN %Exp:MV_PAR04% and %Exp:MV_PAR05%
		AND D2_FILIAL  BETWEEN %Exp:MV_PAR06% and %Exp:MV_PAR07% 
		
	GROUP BY D2_FILIAL,D2_PEDIDO, C5_EMISSAO, D2_CLIENTE, D2_LOJA,A1_NOME, D2_DOC, D2_EMISSAO, D2_TES, D2_CF, F4_TEXTO, F4_ESTOQUE, F4_DUPLIC
	ORDER BY 1, 2
				
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()
Endif

return

//cria as perguntas
/*
Static Function AjustaSX1()
PutSx1( cPerg, "01", "Ordem ?", 		"Ordem ?", 		"Ordem ?", 		  "mv_ch0", "N", 01, 0, 1, "C","","", "", "", "mv_par01","Analitico","","","Sintetico","","","","","",,,,,,,,	{"Ordem do Relatório", "", ""},{},{} )
PutSx1( cPerg, "02", "Data Fatura De ?", "Ordem ?", 	"Ordem ?", 		  "mv_ch0", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Data Faturamento Inicial", "", ""},{},{} )
PutSx1( cPerg, "03", "Data Fatura Ate?", "Ordem ?", 	"Ordem ?", 		  "mv_ch0", "D", 08, 0, 1, "G","","", "", "", "mv_par03",,,,,,,,,,,,,,,,,	{"Data Faturamento Final", "", ""},{},{} )
PutSx1( cPerg, "04", "Numero Pedido de?", "Ordem ?", 	"Ordem ?", 		  "mv_ch0", "C", 06, 0, 1, "G","","SC5", "", "", "mv_par04",,,,,,,,,,,,,,,,,{"Vencto Real Fatura De", "", ""},{},{} )
PutSx1( cPerg, "05", "Numero Pedido Ate?", "Ordem ?", 	"Ordem ?", 		  "mv_ch0", "C", 06, 0, 1, "G","","SC5", "", "", "mv_par05",,,,,,,,,,,,,,,,,{"Vencto Real Fatura De", "", ""},{},{} )
PutSx1( cPerg, "06", "Filial De ?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch0", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par06",,,,,,,,,,,,,,,,,{"Filial De ", "", ""},{},{} )
PutSx1( cPerg, "07", "Filial Ate?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch0", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par07",,,,,,,,,,,,,,,,,{"Filial Ate", "", ""},{},{} )
Return
*/