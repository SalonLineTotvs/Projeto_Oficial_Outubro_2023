//Programa - Relatorio DA COMISSAO com (FATURAMENTO / DEVOLUCAO / ABATIMENTO) conforme Solicitação Denise
//Solicitado - Denise/Tesouraria
//Autor - Andre Salgado / Introde - 27/04/2018
#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

User function FINR0003()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("RFIN03",10,"X")
Private cTitulo		:= "RELATORIO COMISSAO"


If TRepInUse()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que cria as perguntas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX1()
	Pergunte(cPerg, .T. )
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport)},"Este relatorio ira imprimir, conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SA3","SE1"})
TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(05))	//Empresa
TRCell():New(oSection1,"TIPO"			,"TRB",,,(05))	//Empresa
TRCell():New(oSection1,"E1_VEND1"		,"TRB",,,(40))	//Cliente
TRCell():New(oSection1,"A3_NREDUZ"		,"TRB",,,(02))	//Tipo
TRCell():New(oSection1,"A3_X_CSINF"		,"TRB",,,(03))	//Prefixo
TRCell():New(oSection1,"E1_NUM"			,"TRB",,,(09))	//Nr Titulo
TRCell():New(oSection1,"E1_PREFIXO"		,"TRB",,,(09))	//Nr Titulo
TRCell():New(oSection1,"E1_PARCELA"		,"TRB",,,(01))	//Parcela
TRCell():New(oSection1,"E1_NOMCLI"		,"TRB",,,(01))	//Parcela
TRCell():New(oSection1,"E1_EMISSAO"		,"TRB",,,(10))	//Emissao
TRCell():New(oSection1,"E1_VENCREA"		,"TRB",,,(10))	//Venco Real
TRCell():New(oSection1,"E1_VALOR"		,"TRB","Valor",,(15))	//Saldo do Titulo
TRCell():New(oSection1,"E1_HIST"		,"TRB",,,(50))	//Historico

Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)



	oSection1:BeginQuery()
	BeginSQL alias 'TRB'

		SELECT 
		
		CASE 
		WHEN E1_FILIAL='0101' THEN 'CIMEX'
		WHEN E1_FILIAL='0201' THEN 'CROZE'
		WHEN E1_FILIAL='0301' THEN 'KOPEK'
		WHEN E1_FILIAL='0401' THEN 'MACO'
		WHEN E1_FILIAL='0501' THEN 'QUBIT'
		WHEN E1_FILIAL='0601' THEN 'ROJA'
		WHEN E1_FILIAL='0701' THEN 'VIXEN'
		WHEN E1_FILIAL='0801' THEN 'MAIZE'
		WHEN E1_FILIAL='0901' THEN 'DEVINTEX'
		ELSE E1_FILIAL END EMPRESA, * FROM (


//BUSCA DADOS DOS TITULOS FATURADOS NO PERIODO QUE ESTÃO NO CONTAS A RECEBER (-) o valor da ST na Primeira Parcela!!!
SELECT 
'1 - FATURADO' TIPO,
E1_VEND1, A3_NREDUZ, A3_X_CSINF,
E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO, E1_NOMCLI,  E1_FILIAL, 
E1_EMISSAO, E1_VENCREA, E1_VALOR - CASE WHEN E1_PARCELA IN (' ','1','A') THEN F2_ICMSRET ELSE 0   END E1_VALOR, E1_HIST

FROM SE1020 E1
LEFT JOIN SF2020 F2 ON E1_FILIAL =F2_FILIAL  AND E1_NUM =F2_DOC  AND E1_PREFIXO=F2_SERIE AND F2.D_E_L_E_T_=' ' 
LEFT JOIN SA3020 A3 ON E1_VEND1=A3_COD AND A3.D_E_L_E_T_=' ' 
WHERE E1.D_E_L_E_T_=' ' 
AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
AND E1_TIPO NOT IN ('RA','NCC')



//BUSCA DADOS DAS DEVOLUÇÕES NO PERIODO QUE ESTÃO NO CONTAS A RECEBER
UNION ALL
SELECT 
'2 - DEVOLUCAO' TIPO,
A1_VEND, A3_NREDUZ, A3_X_CSINF,
E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO, E1_NOMCLI, E1_FILIAL,
E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_HIST

FROM SE1020 E1
LEFT JOIN SA1020 A1 ON E1_CLIENTE+E1_LOJA=A1_COD+A1_LOJA AND A1.D_E_L_E_T_=' ' 
LEFT JOIN SA3020 A3 ON A1_VEND=A3_COD AND A3.D_E_L_E_T_=' ' 
WHERE E1.D_E_L_E_T_=' ' 
AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
AND E1_TIPO ='NCC'



//BUSCA TODOS OS TITULOS EM ABERTO ATE A DATA FINAL DA EMISSAO DO PERIODO DO PAGAMENTO DA COMISSÃO !
UNION ALL
SELECT 
'3 - INADIMPLENTE' TIPO,
E1_VEND1, A3_NREDUZ, A3_X_CSINF,
E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO,  E1_FILIAL,
E1_NOMCLI,  E1_EMISSAO, E1_VENCREA, E1_SALDO- CASE WHEN E1_PARCELA IN (' ','1','A') THEN F2_ICMSRET ELSE 0   END E1_VALOR, E1_HIST

FROM %table:SE1% E1
LEFT JOIN %table:SF2% F2 ON E1_FILIAL =F2_FILIAL  AND E1_NUM =F2_DOC  AND E1_PREFIXO=F2_SERIE AND F2.D_E_L_E_T_=' ' 
LEFT JOIN %table:SA3% A3 ON E1_VEND1=A3_COD AND A3.D_E_L_E_T_=' ' 
WHERE E1.D_E_L_E_T_=' ' 
AND E1_VENCREA < %Exp:DTOS(MV_PAR02)%
AND E1_SALDO>0
AND E1_TIPO NOT IN ('RA','NCC')


//BUSCA TODOS OS DESCONTOS EFETUADOS NO PERIODO DO FATURAMENTO - CONFORME ESTA INFORMAÇÃO !
//IMPORTANTE - Os desconto são considerados conforme baixas PARCIAIS feita pela equipe do Contas a Receber
UNION ALL
SELECT 
'4 - ABATIMENTO' TIPO,
E1_VEND1, A3_NREDUZ, A3_X_CSINF,
E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO,  E1_FILIAL,
E1_NOMCLI,  E1_EMISSAO, E5_DATA E1_VENCREA, E5_VLDESCO, E5_HISTOR E1_HIST

FROM %table:SE1% E1
INNER JOIN %table:SE5% E5 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E5.D_E_L_E_T_=' ' 
AND E5_TIPODOC='VL'
AND E5_RECPAG='R'
AND E5_VALOR=0
AND E5_VLDESCO>0
AND E5_DATA BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
LEFT JOIN %table:SA3% A3 ON E1_VEND1=A3_COD AND A3.D_E_L_E_T_=' ' 

WHERE E1.D_E_L_E_T_=' ' 
AND E1_TIPO NOT IN ('RA','NCC')

)A 
WHERE E1_FILIAL  BETWEEN %Exp:MV_PAR05% and %Exp:MV_PAR06%
ORDER BY 1, 2, 3, 6,7,8
		
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()
	
return



//cria as perguntas
Static Function AjustaSX1()
//PutSx1( cPerg, "01", "Ordem ?", 		"Ordem ?", 		"Ordem ?", 		  "mv_ch1", "N", 01, 0, 1, "C","","", "", "", "mv_par01","Sintetico","Sintetico","Sintetico","Analitico","Analitico","Analitico","","","",,,,,,,,	{"Ordem do Relatório", "", ""},{},{} )
PutSx1( cPerg, "01", "Data Fatura De ?", "Ordem ?", 	"Ordem ?", 		  "mv_ch1", "D", 08, 0, 1, "G","","", "", "", "mv_par01",,,,,,,,,,,,,,,,,	{"Data Faturamento Inicial", "", ""},{},{} )
PutSx1( cPerg, "02", "Data Fatura Ate?", "Ordem ?", 	"Ordem ?", 		  "mv_ch2", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Data Faturamento Final", "", ""},{},{} )
PutSx1( cPerg, "03", "Data Devoluc. De?", "Ordem ?", 	"Ordem ?", 		  "mv_ch3", "D", 08, 0, 1, "G","","", "", "", "mv_par03",,,,,,,,,,,,,,,,,	{"Vencto Real Fatura De", "", ""},{},{} )
PutSx1( cPerg, "04", "Data Devoluc.Ate?", "Ordem ?", 	"Ordem ?", 		  "mv_ch4", "D", 08, 0, 1, "G","","", "", "", "mv_par04",,,,,,,,,,,,,,,,,	{"Vencto Real Fatura De", "", ""},{},{} )
PutSx1( cPerg, "05", "Filial De ?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch4", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par04",,,,,,,,,,,,,,,,,{"Filial De ", "", ""},{},{} )
PutSx1( cPerg, "06", "Filial Ate?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch5", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par05",,,,,,,,,,,,,,,,,{"Filial Ate", "", ""},{},{} )
Return
