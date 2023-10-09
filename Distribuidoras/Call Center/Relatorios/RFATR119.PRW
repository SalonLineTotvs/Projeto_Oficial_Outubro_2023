//****************************************************
//Programa - Mod.Faturamento - Relatorio de Analise de Pedidos Trade
//Solicitado - Claudia Vericio / Fernanda Grecco
//Autor - Andre Salgado / Introde - 15/09/2022
//****************************************************

#include "Protheus.ch"

User function RFATR119()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "TR119" //PADR("RFATR013",10,"X") //REVER OS PERGUNTES
Private cTitulo		:= "ANALISE DE PEDIDOS TRADE"

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
    TRCell():New(oSection1,"DESCRICAO PRODUTO"	,"TRB","Desc. Produto"    		,,(75))
    TRCell():New(oSection1,"QTDE PEDIDO"		,"TRB","Qtde"  					,,(06))
    TRCell():New(oSection1,"CODIGO CLIENTE"	    ,"TRB","Cod. Cliente"           ,,(06))
    TRCell():New(oSection1,"NOME CLIENTE"		,"TRB","Cliente"     			,,(30))
    TRCell():New(oSection1,"LOJA" 				,"TRB","Loja"         			,,(02))
    TRCell():New(oSection1,"UF"					,"TRB","UF"  			    	,,(04))
    TRCell():New(oSection1,"CIDADE"				,"TRB","Municipio"		    	,,(20))
 	TRCell():New(oSection1,"DATA EMISSAO"		,"TRB","Data Pedido"     		,,(10))
	TRCell():New(oSection1,"EMISSAO NOTA"		,"TRB","Data Emissao"     		,,(10))
	TRCell():New(oSection1,"NUMERO NOTA"		,"TRB","Nota"  					,,(20))
	TRCell():New(oSection1,"TRANSPORTADORA"		,"TRB","Transportadora"     	,,(30))
 	TRCell():New(oSection1,"VENDEDOR"			,"TRB","Vendedor"  				,,(20))
    TRCell():New(oSection1,"NOMEGERENTE"		,"TRB","Gerencia"  				,,(20))
    TRCell():New(oSection1,"STATUS"		        ,"TRB","Status"  				,,(20))
    TRCell():New(oSection1,"TIPO"		        ,"TRB","Tipo"  			    	,,(20))
    TRCell():New(oSection1,"ENTREGA PREVISTA"	,"TRB","Entrega Prevista"     	,,(10))
 	TRCell():New(oSection1,"DATA ENTREGA"		,"TRB","Data Entrega"     		,,(10))
 	TRCell():New(oSection1,"DATA REAGENDADA"	,"TRB","Data Reagendada"     	,,(10))


Return oReport

//Gera o Relatorio de Analise de Pedidos Trade
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)

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
	C5_CLIENTE AS [CODIGO CLIENTE],
	C5_LOJACLI AS [LOJA],
	A1_NOME AS [NOME CLIENTE],
	A1_EST AS [UF],
	A1_MUN AS [CIDADE],
	C5_EMISSAO AS [DATA EMISSAO],
	D2_EMISSAO AS [EMISSAO NOTA],
	C6_NOTA AS [NUMERO NOTA],
	C6_PRODUTO AS [CODIGO PRODUTO],
	B1_DESC AS [DESCRICAO PRODUTO],
	C6_QTDVEN AS [QTDE PEDIDO],
	C5_TRANSP AS [CODIGO TRANSPORTADORA],
	A4_NOME AS [TRANSPORTADORA],
	C5_VEND1 AS [CODIGO VENEDEDOR],
	A3.A3_NREDUZ AS [VENDEDOR],
	A3.A3_GEREN AS [CODIGO GERENTE], 
		(
		SELECT VEND.A3_NOME FROM SA3020 VEND 
		WHERE VEND.A3_COD = A3.A3_GEREN
		) AS [NOME GERENTE],
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
	ELSE 'VENDA' END  AS [TIPO],

	C6_ENTREG AS [ENTREGA PREVISTA],
	C5_FECENT AS [DATA ENTREGA],
	C5_X_DTAGE AS [DATA REAGENDADA]

FROM SC6020 AS C6
	INNER JOIN %table:SC5% C5 ON C5_FILIAL = C6_FILIAL AND C5_NUM=C6_NUM
	INNER JOIN %table:SA1% A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI
	LEFT JOIN %table:SA4% A4 ON A4_COD = C5_TRANSP 
	LEFT JOIN %table:SD2% D2 ON D2_DOC = C6_NOTA AND D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_COD = C6_PRODUTO
	INNER JOIN %table:SB1% B1 ON B1_COD = C6_PRODUTO
	INNER JOIN %table:SA3% A3 ON A3_COD = C5_VEND1
	LEFT JOIN %table:SF2% F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC

WHERE	D2.D_E_L_E_T_ = ''
AND		B1.D_E_L_E_T_ = ''
AND		C6.D_E_L_E_T_ = ''
AND		C5.D_E_L_E_T_ = ''
AND		A4.D_E_L_E_T_ = ''
AND C5.C5_CLIENTE = %Exp:MV_PAR01% 
AND C5.C5_LOJACLI = %Exp:MV_PAR02%
AND C6.C6_FILIAL = %Exp:MV_PAR03%
AND C5.C5_FECENT = %Exp:MV_PAR04% 
AND C5.C5_X_DTAGE = %Exp:MV_PAR05%
AND C5.C5_VEND1 = %Exp:MV_PAR06% 
AND A3.A3_GEREN = %Exp:MV_PAR07%
ORDER BY C6_FILIAL, C5_EMISSAO

ENDSQL

	oSection1:EndQuery()

#ENDIF
oSection1:Print()
return

// perguntas
//FILTRO POR CLIENTE/FILIAL CODIGO
//FILIAL
//DATA DE ENTREGA / REAGENDADA
//FILTRO POR VENDEDOR / REGIONAL
