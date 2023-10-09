//****************************************************
//Programa - Mod.Faturamento - Relatorio de BonificaÃ§Ã£o
//Solicitado - Claudia Vericio / Fernando Caliari
//Autor - Andre Salgado / Introde - 15/09/2022
//****************************************************

#include "Protheus.ch"

User function RFATR118()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "RFATR118" //PADR("RFATR013",10,"X")
Private cTitulo		:= "ANALISE DE PEDIDOS BONIFICADOS"

Pergunte(cPerg) 
oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 

oReport := TReport():New(cPerg,cTitulo+' - '+'ATENDIMENTOS',cPerg,{|oReport|PrintReport(oReport, aOrdem)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7

oSection1 := TRSection():New(oReport,"RELATORIO",{"SB1","SD1","SD2","SUD","SU9","SF2","SA4","SA1"},aOrdem)
    

    TRCell():New(oSection1,"EMPRESA"			,"TRB","Distribuidora"     		,,(10))
    TRCell():New(oSection1,"PEDIDO"	    		,"TRB","Pedido"           		,,(10))
    TRCell():New(oSection1,"NOMECLIENTE"		,"TRB","Cliente"     			,,(30))
    TRCell():New(oSection1,"CODIGOCLIENTE"	    ,"TRB","Cod. Cliente"           ,,(06))
    TRCell():New(oSection1,"LOJA" 				,"TRB","Loja"         			,,(02))
    TRCell():New(oSection1,"TIPODECLIENTE"		,"TRB","Canal"  				,,(10))
 	TRCell():New(oSection1,"DTEMISSAO"			,"TRB","Data Pedido"     		,,(11))
	TRCell():New(oSection1,"EMISSAONOTA"		,"TRB","Data Emissao"     		,,(11))
	TRCell():New(oSection1,"NUMERONOTA"			,"TRB","Nota"  					,,(09))
	TRCell():New(oSection1,"CODIGOPRODUTO"		,"TRB","Cod. Produto"     		,,(30))
	TRCell():New(oSection1,"DESCRICAOPRODUTO"	,"TRB","Desc. Produto"    		,,(75))
	TRCell():New(oSection1,"VLTITEM"			,"TRB","Valor"  				,,(12))
	TRCell():New(oSection1,"VLRDESCONTO"		,"TRB","Valor Desconto"  		,,(12))
	TRCell():New(oSection1,"QTDEPEDIDO"			,"TRB","Qtde"  					,,(06))
	TRCell():New(oSection1,"CFOP"				,"TRB","CFOP"  					,,(06))
	TRCell():New(oSection1,"STATUS"				,"TRB","Status Pedido"     		,,(30))
	TRCell():New(oSection1,"TIPOPEDIDO"			,"TRB","Tipo de Pedido"     	,,(30))
	TRCell():New(oSection1,"TRANSPORTADORA"		,"TRB","Transportadora"     	,,(30))
 	TRCell():New(oSection1,"VENDEDOR"			,"TRB","Vendedor"  				,,(20))
    TRCell():New(oSection1,"NOMEGERENTE"		,"TRB","Gerencia"  				,,(20))

Return oReport

//Gera o Relatorio de Bonificacao
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)
Local cDatIni 	:= DtoS(MV_PAR03)
Local cDatFim 	:= DtoS(MV_PAR04)


#IFDEF TOP
        oSection1:BeginQuery()
BeginSQL alias 'TRB'

SELECT
	C5_FILIAL AS [CODIGO EMPRESA], 
CASE 
	WHEN C6_FILIAL='0101' THEN 'CIMEX'
	WHEN C6_FILIAL='0201' THEN 'CROZE'
	WHEN C6_FILIAL='0301' THEN 'KOPEK'
	WHEN C6_FILIAL='0401' THEN 'MACO'
	WHEN C6_FILIAL='0501' THEN 'QUBIT'
	WHEN C6_FILIAL='0601' THEN 'ROJA'
	WHEN C6_FILIAL='0701' THEN 'VIXEN'
	WHEN C6_FILIAL='0801' THEN 'MAIZE'
	WHEN C6_FILIAL IN('0902','0901') THEN 'DEVINTEX'
    WHEN C6_FILIAL='1101' THEN 'BIZEZ'
	WHEN C6_FILIAL='1201' THEN 'ZAKAT'
	WHEN C6_FILIAL='1301' THEN 'HEXIL'
	WHEN C6_FILIAL='1401' THEN 'TROLL'
	ELSE C6_FILIAL END EMPRESA,

	C5_NUM AS [PEDIDO],
	A1_NOME AS [NOMECLIENTE],
	C5_CLIENTE AS [CODIGOCLIENTE],
	C5_LOJACLI AS [LOJA],
	CASE WHEN A1_X_PRIOR IN('01','02') THEN 'VIP' ELSE 'DEMAIS' END [TIPODECLIENTE],
	A1_EST AS [UF],
	A1_MUN AS [CIDADE],
	C5_EMISSAO AS [DTEMISSAO],
	D2_EMISSAO AS [EMISSAONOTA],
	C6_NOTA AS [NUMERONOTA],
	C6_PRODUTO AS [CODIGOPRODUTO],
	B1_DESC AS [DESCRICAOPRODUTO],
	C6_VALOR AS [VLTITEM],
	C6_VALDESC AS [VLRDESCONTO],
	C6_QTDVEN AS [QTDEPEDIDO],
	C6_CF AS [CFOP],
	C5_TRANSP AS [CODIGOTRANSPORTADORA],
	A4_NOME AS [TRANSPORTADORA],
	C5_VEND1 AS [CODIGOVENEDEDOR],
	A3.A3_NREDUZ AS [VENDEDOR],
	A3.A3_GEREN AS [CODIGOGERENTE], 
		(
		SELECT VEND.A3_NOME FROM SA3020 VEND 
		WHERE VEND.A3_COD = A3.A3_GEREN
		) AS [NOMEGERENTE],
CASE 
	C5_X_STAPV	
	WHEN '0' THEN 'PV GERADO' 
	WHEN '1' THEN 'PV LIBERADO'  
	WHEN '2' THEN 'SEPARACAO'  
	WHEN '3' THEN 'SEP. FINALIZADA' 
	WHEN '4' THEN 'EM CONFERENCIA' 
	WHEN '5' THEN 'CONFERENCIA FINALIZADA' 
	WHEN '6' THEN 'FATURADO' 
	WHEN '7' THEN 'MANIFESTO IMPRESSO' 
	WHEN 'A' THEN 'ANTECIPADO' 
	WHEN 'C' THEN 'CANCELADO'
	WHEN 'D' THEN 'DEVOLUCAO' 
	ELSE 'SEM STATUS' END AS [STATUS],

CASE 
	WHEN F2_DUPL=' ' THEN 'BONIFICAÇÃO' 
	ELSE 'VENDA' END  AS [TIPOPEDIDO],

	C6_ENTREG AS [ENTREGAPREVISTA],
	C5_FECENT AS [DTENTREGA],
	C5_X_DTAGE AS [DTREAGENDADA]

FROM SC6020 AS C6
	INNER JOIN SC5020 C5 ON C5_FILIAL = C6_FILIAL AND C5_NUM=C6_NUM
	INNER JOIN SA1020 A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI
	LEFT JOIN SA4020 A4 ON A4_COD = C5_TRANSP 
	LEFT JOIN SD2020 D2 ON D2_DOC = C6_NOTA AND D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_COD = C6_PRODUTO
	INNER JOIN SB1020 B1 ON B1_COD = C6_PRODUTO
	INNER JOIN SA3020 A3 ON A3_COD = C5_VEND1
	LEFT JOIN SF2020 F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC

WHERE C6_CF = '5910' //CFOP de Bonificação
AND D2.D_E_L_E_T_ = ''
AND B1.D_E_L_E_T_ = ''
AND C6.D_E_L_E_T_ = ''
AND C5.D_E_L_E_T_ = ''
AND A4.D_E_L_E_T_ = ''
AND C6.C6_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C5.C5_EMISSAO BETWEEN %Exp:cDatIni% AND %Exp:cDatFim%
AND C5.C5_X_STAPV = %Exp:MV_PAR05%
ORDER BY C6_FILIAL, C5_EMISSAO

ENDSQL

	oSection1:EndQuery()

#ENDIF
oSection1:Print()
return

// perguntas
// 0. C6_FILIAL DE - ATE
// 1. C5_EMISSAO DE - ATE
// 2. C5_X_STAPV SELECAO UNICA
