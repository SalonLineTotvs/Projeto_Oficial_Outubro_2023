//****************************************************
//Programa - Relatório Pedidos Aprovados
//Solicitado - 
//Autor -  - 21/08/2021
//****************************************************
#include "Protheus.ch"

User function FATR0999()

Local oReport
Private oSection1	:= Nil
Private cArq        := "FATR0999"+StrTran( Time(), ":", "" )
Private cPerg 		:= "FATR0999" //PADR("RFATR013",10,"X")
Private cTitulo		:= "Liberação de Crédito Financeiro"
Private _BasCGC     := LEFT(Alltrim(TRB->A1_CGC),8) + "%"
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
//oReport:nFontBody   := 11

oSection1 := TRSection():New(oReport,"Liberação de Crédito Financeiro",{"SE1","SA1"})

    TRCell():New(oSection1,"C9_FILIAL"	    ,"SLTRB", "Empresa"       ,,(10))
    TRCell():New(oSection1,"C9_PEDIDO"	    ,"SLTRB", "Pedido"        ,,(15))
    TRCell():New(oSection1,"VALOR"	        ,"SLTRB", "Valor"         ,,(15))
    TRCell():New(oSection1,"C9_CLIENTE"	    ,"SLTRB", "Cliente"       ,,(15))
    TRCell():New(oSection1,"C9_LOJA"  	    ,"SLTRB", "Loja"          ,,(10))
    TRCell():New(oSection1,"A1_NOME"  	    ,"SLTRB", "Nome Cliente"  ,,(30))
    TRCell():New(oSection1,"C5_XDTLIBM"	    ,"SLTRB", "Data Liberação",,(15))
    TRCell():New(oSection1,"C5_XUSRLIB"	    ,"SLTRB", "Usuário"       ,,(30))

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

oSection1:Init()
oSection1:BeginQuery()

BeginSQL alias 'SLTRB'

SELECT DISTINCT C9_FILIAL, C9_PEDIDO, SUM(C6_VALOR) 'VALOR', C9_CLIENTE, C9_LOJA, A1_NOME, C5_XDTLIBM, C5_XUSRLIB
FROM %Table:SC9% C9
INNER JOIN %Table:SC6% C6 ON C6_FILIAL = C9_FILIAL AND C6_NUM= C9_PEDIDO AND C6_CLI = C9_CLIENTE AND C6.%NotDel%
AND C6_PRODUTO = C9_PRODUTO
INNER JOIN SF4020 F4 ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES AND F4_DUPLIC='S'
AND (F4_TEXTO LIKE 'VENDA%' OR F4_TEXTO LIKE 'VD%') AND F4.D_E_L_E_T_=' '
INNER JOIN %Table:SA1% A1 ON  A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND A1.%NotDel%
INNER JOIN %Table:SC5% C5 ON C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C5_XDTLIBM <> '' 
WHERE C9.%NotDel%
AND C5_XDTLIBM BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
GROUP BY C9_FILIAL, C9_PEDIDO, C9_CLIENTE, C9_LOJA, A1_NOME, C5_XDTLIBM, C5_XUSRLIB
ORDER BY C5_XDTLIBM

EndSQL

oSection1:EndQuery()
oSection1:Print()
oReport:Section(1):Finish()

("SLTRB")->(DbCloseArea())

return
