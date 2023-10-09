//****************************************************
//Programa - Mod.Faturamento - Relatorio Devolução
//Solicitado - Luana / Marcelo Winter
//Autor - Andre Salgado / Introde - 21/08/2021
//****************************************************
#include "Protheus.ch"

User function RFATR013()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "RFATR013" //PADR("RFATR013",10,"X")
Private cTitulo		:= "Relacao de Devoluções"

Pergunte(cPerg)
oReport := ReportDef()
oReport:PrintDialog()

Return


Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport, aOrdem)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7

oSection1 := TRSection():New(oReport,"RELATORIO",{"SB1","SD1","SF2","SA4","SA1"},aOrdem)

    TRCell():New(oSection1,"EMPRESA"	,"TRB",,,(10))
    TRCell():New(oSection1,"D1_DTDIGIT"	,"TRB",,,(10))
    TRCell():New(oSection1,"A1_COD"		,"TRB",,,(06))
    TRCell():New(oSection1,"A1_NOME"	,"TRB",,,(40))
    TRCell():New(oSection1,"A4_NREDUZ"	,"TRB","Transportadora",,(30))
    TRCell():New(oSection1,"NFD"	    ,"TRB","NF Devolução"       ,,(09))
    TRCell():New(oSection1,"D1_EMISSAO" ,"TRB","Data NF Devolucao"  ,,(10))
    TRCell():New(oSection1,"NFO"	    ,"TRB","NF Original"        ,,(09))
    TRCell():New(oSection1,"F2_EMISSAO" ,"TRB","Data NF Original"   ,,(10))
    TRCell():New(oSection1,"TP_NFO"	    ,"TRB","Tp NFO"             ,,(10))
    TRCell():New(oSection1,"D1_COD"	    ,"TRB",,,(10))
    TRCell():New(oSection1,"B1_DESC"	,"TRB",,,(30))
    TRCell():New(oSection1,"D1_QUANT"	,"TRB",,,(12))
    TRCell():New(oSection1,"D1_VUNIT"	,"TRB",,,(12))
    TRCell():New(oSection1,"D1_LOCAL"	,"TRB",                 ,,(02))
    TRCell():New(oSection1,"STATUS_"	,"TRB","Obs."           ,,(10))
    TRCell():New(oSection1,"TOT_BOM"	,"TRB","Total Bom"      ,,(12))
    TRCell():New(oSection1,"TOT_RUIM"	,"TRB","Total Ruim"     ,,(12))
    TRCell():New(oSection1,"TOT_FALTA"	,"TRB","Total Falta"    ,,(12))
    TRCell():New(oSection1,"D1_TOTAL"	,"TRB","Total Geral"    ,,(12))

//TRCell():New(oSection1,"SALARIO"	,"TRB","Salario",pesqPict("SRA","RA_SALARIO"),(14))
//oBreak  := TRBreak():New(oSection1,oSection1:Cell("EMPRESA"),"Sub-Total") 
//TRFunction():New(oSection1:Cell("D1_TOTAL")	,NIL,"SUM",oBreak,,/*cPicture*/,/*uFormula*/,.F.,.T.,.F.,oSection1)
Return oReport


//Gera o Relatorio da Devoluçao
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)


#IFDEF TOP
	
	oSection1:BeginQuery()
	
	BeginSQL alias 'TRB'

        SELECT
            LEFT(X5_DESCRI,10) EMPRESA,
            D1_DTDIGIT, D1_FORNECE+D1_LOJA A1_COD, A1_NOME,  F2_TRANSP, A4_NREDUZ, 
            D1_DOC NFD, D1_EMISSAO, 
            D1_NFORI NFO, F2_EMISSAO, 
            CASE WHEN F2_DUPL=' ' THEN 'BONIFICAÇÃO' ELSE 'VENDA' END TP_NFO,
            D1_COD, B1_DESC, D1_QUANT, D1_VUNIT, D1_LOCAL,
            CASE D1_LOCAL WHEN '03' THEN 'RUIM' WHEN 'AN' THEN 'FALTA' ELSE 'BOM' END STATUS_,
            CASE WHEN D1_LOCAL NOT IN('03','AN') THEN D1_TOTAL ELSE 0 END TOT_BOM,
            CASE D1_LOCAL WHEN '03' THEN D1_TOTAL ELSE 0 END TOT_RUIM,
            CASE D1_LOCAL WHEN 'AN' THEN D1_TOTAL ELSE 0 END TOT_FALTA,
            D1_TOTAL

        FROM SD1020 D1 (NOLOCK)
            INNER JOIN SA1020 A1 (NOLOCK) ON D1_FORNECE=A1_COD AND D1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
            INNER JOIN SB1020 B1 (NOLOCK) ON D1_COD=B1_COD AND B1.D_E_L_E_T_=' ' 
            INNER JOIN SF2020 F2 (NOLOCK) ON D1_FILIAL=F2_FILIAL AND D1_NFORI=F2_DOC AND F2.D_E_L_E_T_=' ' 
            INNER JOIN SX5020 X5 (NOLOCK) ON D1_FILIAL=LEFT(X5_CHAVE,4) AND X5.D_E_L_E_T_=' ' 
                                                AND X5_FILIAL='0101' AND X5_TABELA='ZE' 
            LEFT JOIN SA4020 A4 (NOLOCK) ON F2_TRANSP=A4_COD AND A4.D_E_L_E_T_=' ' 
        WHERE 
            D1.D_E_L_E_T_='  '
            AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND D1_FILIAL  BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
            //AND D1_COD NOT IN ('NF COMPL ICMS')
            AND D1_TIPO = 'D'
        ORDER BY 1,4,2,12

//			FROM %table:SRA% RA
//		ORDER BY  %Exp:cOrdem%
	EndSQL
	oSection1:EndQuery()
	
#ENDIF
oSection1:Print()
return
