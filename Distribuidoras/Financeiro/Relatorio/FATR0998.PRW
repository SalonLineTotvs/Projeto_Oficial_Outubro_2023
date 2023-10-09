//****************************************************
//Programa - Liberação X Faturamento
//Solicitado - Jacqueline Mamede
//Autor -  - 05/01/2023
//****************************************************
#include "Protheus.ch"

User function FATR0998()

Local oReport
Private oSection1	:= Nil
Private cArq        := "FATR0998"+StrTran( Time(), ":", "" )
Private cPerg 		:= "FATR0998"
Private cTitulo		:= "Liberação X Faturamento"
Private _cAlias 

Pergunte(cPerg) 
oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New(cArq,cTitulo,cPerg,{|oReport|PrintReport(oReport)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Liberação X Faturamento",{"SC5","SC6","SA1","SC9","SF2"})

    TRCell():New(oSection1,"C5_FILIAL"	    ,"FATR0998", "Empresa"        ,,(10))
    TRCell():New(oSection1,"C5_NUM"	        ,"FATR0998", "Pedido"         ,,(15))
    TRCell():New(oSection1,"VALOR"	        ,"FATR0998", "Valor"          ,,(15))
    TRCell():New(oSection1,"C5_CLIENTE"	    ,"FATR0998", "Cliente"        ,,(15))
    TRCell():New(oSection1,"C5_LOJACLI"  	,"FATR0998", "Loja"           ,,(10))
    TRCell():New(oSection1,"A1_NOME"  	    ,"FATR0998", "Nome Cliente"   ,,(30))
    TRCell():New(oSection1,"C5_EMISSAO"	    ,"FATR0998", "Data Emissão PV",,(15))
    TRCell():New(oSection1,"C9_DATALIB"	    ,"FATR0998", "Data Lib PV"    ,,(15))
    TRCell():New(oSection1,"F2_EMISSAO"	    ,"FATR0998", "Data Faturamento PV",,(15))
    TRCell():New(oSection1,"F2_DOC"	        ,"FATR0998", "Nota Fiscal"    ,,(20))

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:Init()
oSection1:BeginQuery()

BeginSQL alias 'FATR0998'

SELECT DISTINCT C5_FILIAL, C5_NUM, ROUND(SUM(C6_VALOR),2) 'VALOR', C5_CLIENTE, C5_LOJACLI, A1_NOME, 
C5_EMISSAO, C9_DATALIB, F2_EMISSAO, F2_DOC
FROM %Table:SC5% C5
INNER JOIN %Table:SC6% C6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.%NotDel%
INNER JOIN %Table:SA1% A1 ON A1_COD = C6_CLI AND A1_LOJA = C6_LOJA AND A1.%NotDel%
INNER JOIN %Table:SC9% C9 ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_PRODUTO = C6_PRODUTO AND C9.%NotDel% 
INNER JOIN %Table:SF2% F2 ON F2_FILIAL = C5_FILIAL AND F2_DOC = C5_NOTA AND F2_CLIENTE = C5_CLIENTE AND F2.%NotDel%
WHERE C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C5.%NotDel% AND C5_NOTA <> ''
AND (
    (%Exp:MV_PAR03% = '1' ) OR
    (%Exp:MV_PAR03% = '2' AND F2_EMISSAO >= (DATEADD(DAY,7,C9_DATALIB))) OR
    (%Exp:MV_PAR03% = '3' AND F2_EMISSAO >= (DATEADD(DAY,15,C9_DATALIB)))
    ) 
GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C9_DATALIB, F2_EMISSAO, F2_DOC
ORDER BY C5_FILIAL, C5_NUM

EndSQL

oSection1:EndQuery()
oSection1:Print()
oReport:Section(1):Finish()

("FATR0998")->(DbCloseArea())

Return
