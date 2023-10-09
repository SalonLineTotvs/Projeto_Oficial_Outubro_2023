#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

//Programa - Relatorio Analise Faturamento Distribuidora x Entrada Nota
//Solicitado - Adelma/Fiscal
//Autor - Andre Salgado / Introde - 14/06/2019

//*********************************************************************************************
//
//Melhoria 31/07/2019 - André Salgado - Sol.Adelma, incluir o Fornecedor 000005 Alfalog
//
//*********************************************************************************************

User function FATR0012()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("RFATR12",10,"X")
Private cTitulo		:= "Relatorio Distribuidora x Entrada Nota"

//Pergunta:
//MV_PAR01 - Tipo D - Data da Emissão Nota Inicial (Entrada e Saida)
//MV_PAR02 - Tipo D - Data da Emissão Nota Final (Entrada e Saida)


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

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SA3","SD2","SC5","SF4","SB1"})

TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(10))
TRCell():New(oSection1,"PERIODO"		,"TRB",,,(10))
TRCell():New(oSection1,"PRODUTO"		,"TRB",,,(15))
TRCell():New(oSection1,"B1_DESC"		,"TRB",,,(30))
TRCell():New(oSection1,"B1_POSIPI"		,"TRB",,,(10))
TRCell():New(oSection1,"QTD_D1"			,"TRB","Qtd.Rem",,(16))
TRCell():New(oSection1,"QTD_D2"			,"TRB","Qtd.Vda",,(16))
TRCell():New(oSection1,"DIF"			,"TRB","Qtd.Dif",,(16))

Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()
BeginSQL alias 'TRB'
	

SELECT 
	FILIAL, 
	CASE 
	WHEN FILIAL='0101' THEN 'CIMEX'
	WHEN FILIAL='0201' THEN 'CROZE'
	WHEN FILIAL='0301' THEN 'KOPEK'
	WHEN FILIAL='0401' THEN 'MACO'
	WHEN FILIAL='0501' THEN 'QUBIT'
	WHEN FILIAL='0601' THEN 'ROJA'
	WHEN FILIAL='0701' THEN 'VIXEN'
	WHEN FILIAL='0801' THEN 'MAIZE'
	WHEN FILIAL='0901' THEN 'DEVINTEX'
	WHEN FILIAL='0902' THEN 'DEVINTEX-MG'
	ELSE FILIAL END EMPRESA,
	
	PERIODO, PRODUTO, B1_DESC, B1_POSIPI, SUM(QTD_D1) QTD_D1, SUM(QTD_D2) QTD_D2,SUM(QTD_D1) -SUM(QTD_D2) DIF FROM(
	
		SELECT 
		D1_FILIAL FILIAL, D1_EMISSAO PERIODO, D1_COD PRODUTO, D1_QUANT QTD_D1, 0 QTD_D2
		FROM SD1020 D1
		
		WHERE D1.D_E_L_E_T_=' ' 
		AND D1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
		AND D1_TIPO='N' AND D1_FORNECE IN('002196','000005')	//Só Fornecedor DEVINTEX e ALFALOG
		
	UNION ALL
		SELECT 
		D2_FILIAL FILIAL, D2_EMISSAO PERIODO, D2_COD PRODUTO, 0 QTD_D1, D2_QUANT QTD_D2
		FROM SD2020 D2
		
		WHERE D2.D_E_L_E_T_=' ' 
		AND D2_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
		AND D2_TIPO='N'
		
	)A 
		INNER JOIN SB1020 B1 ON PRODUTO=B1_COD AND B1.D_E_L_E_T_=' ' 
		GROUP BY FILIAL, PERIODO, PRODUTO, B1_DESC, B1_POSIPI
	ORDER BY 1,2,3,4

	
EndSQL
oSection1:EndQuery()
oSection1:Print()

//		FROM %table:SD2% D2
return