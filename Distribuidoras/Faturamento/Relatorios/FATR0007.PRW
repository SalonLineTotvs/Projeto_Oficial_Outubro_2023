#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

//Programa - Relatorio Analise Faturamento c/ST x Valor Financeiro
//Solicitado - Adelma/Fiscal
//Autor - Andre Salgado / Introde - 01/11/2018

/* *****************************************       MELHORIAS     *****************************************
Data 06/11/2018 - André Salgado / Introde - Sol. Adelma - Incluir COLUNA com SALDO BAIXADO do Titulo
OBS. Informei "BAIXADO" porque pode ter varios tipo de Baixa pelo Financeiro como: (Compensador, Descontados, Dação e Recebidos em Banco)

*/

User function FATR0007()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("RFATR07",10,"X")
Private cTitulo		:= "Relatorio Faturamento c/ST com Valor Financeiro"


If TRepInUse()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que cria as perguntas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg, .T. )
		
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport)},"Este relatorio ira imprimir, conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SA3","SD2","SC5","SF4"})

TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(10))
TRCell():New(oSection1,"D2_DOC"			,"TRB",,,(10))
TRCell():New(oSection1,"D2_SERIE"		,"TRB",,,(03))
TRCell():New(oSection1,"D2_EMISSAO"		,"TRB",,,(10))
TRCell():New(oSection1,"D2_CLIENTE"		,"TRB",,,(10))
TRCell():New(oSection1,"A1_NOME"		,"TRB",,,(50))
TRCell():New(oSection1,"A1_CGC"			,"TRB",,,(15))
TRCell():New(oSection1,"A1_EST"			,"TRB",,,(02))
TRCell():New(oSection1,"D2_CF"			,"TRB",,,(05))
TRCell():New(oSection1,"D2_QUANT"		,"TRB",,,(15))
TRCell():New(oSection1,"D2_TOTAL"		,"TRB",,,(15))
TRCell():New(oSection1,"D2_VALBRUT"		,"TRB",,,(15))
TRCell():New(oSection1,"D2_ICMSRET"		,"TRB",,,(15))
TRCell():New(oSection1,"VL_SE1"			,"TRB","Vlr.Financeiro",,(15))
TRCell():New(oSection1,"BAIXADO"		,"TRB","Vlr.Baixado Financ",,(15))

Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()
BeginSQL alias 'TRB'
	
SELECT CASE 
	WHEN D2_FILIAL='0101' THEN 'CIMEX' 
	WHEN D2_FILIAL='0201' THEN 'CROZE' 
	WHEN D2_FILIAL='0301' THEN 'KOPEX' 
	WHEN D2_FILIAL='0401' THEN 'MACO' 
	WHEN D2_FILIAL='0501' THEN 'QUBIT' 
	WHEN D2_FILIAL='0601' THEN 'ROJA' 
	WHEN D2_FILIAL='0701' THEN 'VIXEN' 
	WHEN D2_FILIAL='0801' THEN 'MAIZE' 
	WHEN D2_FILIAL='0901' THEN 'DEVINTEX' 
	WHEN D2_FILIAL='0902' THEN 'DEVINTEX/MG' 
	ELSE D2_FILIAL END EMPRESA,
	
	D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE+D2_LOJA D2_CLIENTE, A1_NOME, A1_EST, A1_CGC, D2_CF, 
	SUM(D2_QUANT) D2_QUANT, SUM(D2_TOTAL) D2_TOTAL, SUM(D2_VALBRUT) D2_VALBRUT, VL_SE1, BAIXADO, SUM(D2_ICMSRET) D2_ICMSRET
	
		FROM %table:SD2% D2
		INNER JOIN %table:SF2% F2 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2.D_E_L_E_T_=' '
		INNER JOIN %table:SA1% A1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 

		LEFT JOIN (
		SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_CLIENTE, E1_LOJA, SUM(E1_VALOR) VL_SE1, ABS(SUM(E1_VALOR)-SUM(E1_SALDO)) BAIXADO
		FROM %table:SE1% WHERE D_E_L_E_T_=' ' AND E1_TIPO NOT IN ('RA','NCC') 
		GROUP BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_CLIENTE, E1_LOJA
		)FIN ON D2_FILIAL=E1_FILIAL AND D2_SERIE=E1_PREFIXO AND D2_DOC=E1_NUM AND D2_CLIENTE=E1_CLIENTE AND D2_LOJA=E1_LOJA
		
	WHERE D2.D_E_L_E_T_=' ' 
		AND D2_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%

GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE,D2_LOJA,D2_CF, A1_NOME, A1_EST, A1_CGC, VL_SE1, BAIXADO
ORDER BY 1,2

	
EndSQL
oSection1:EndQuery()
oSection1:Print()

return