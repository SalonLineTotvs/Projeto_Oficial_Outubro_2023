//Autor - Gustavo Luna
//Atualizado - 29/12/2022
//****************************************************
#include "Protheus.ch"

User function FATR0022()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "FATR0022"
Private cTitulo		:= "Conferencia Distribuidoras"

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

oSection1 := TRSection():New(oReport,"RELATORIO",{"SF2","SA1","SA3","SC5","SA4"},aOrdem)

	TRCell():New(oSection1,"F2_DOC"	        ,"TRB","Numero"                ,,(15))
    TRCell():New(oSection1,"D2_PEDIDO"	    ,"TRB","No do Pedido"          ,,(15))
    TRCell():New(oSection1,"F2_CLIENTE"	    ,"TRB","Cod.Clie"              ,,(10))
    TRCell():New(oSection1,"F2_LOJA"		,"TRB","Loja"				   ,,(06))
    TRCell():New(oSection1,"A1_NOME"	    ,"TRB","Cliente"               ,,(20))
    TRCell():New(oSection1,"F2_EMISSAO"	    ,"TRB","DT Emissao"            ,,(10))
    TRCell():New(oSection1,"F2_VALBRUT" 	,"TRB","Vlr.NF"                ,,(15))
    TRCell():New(oSection1,"A3_NREDUZ" 	    ,"TRB","Representant"          ,,(15))
    TRCell():New(oSection1,"C5_VOLUME1" 	,"TRB","Caixa"         		   ,,(05))
    TRCell():New(oSection1,"C5_VOLUME2"	    ,"TRB","Granel"		           ,,(05))
    TRCell():New(oSection1,"F2_VOLUME1"	    ,"TRB","Volume"        		   ,,(10))
    TRCell():New(oSection1,"F2_PBRUTO"		,"TRB","Peso"                  ,,(15))
    TRCell():New(oSection1,"A1_BAIRRO"	    ,"TRB","Bairro"                ,,(20))
    TRCell():New(oSection1,"F2_TRANSP"		,"TRB","Transp."               ,,(10))
    TRCell():New(oSection1,"A4_NREDUZ"	    ,"TRB","Transportadora "       ,,(20))

Return oReport

Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)
#IFDEF TOP
        oSection1:BeginQuery()
BeginSQL alias 'TRB'

SELECT DISTINCT F2_DOC, D2_PEDIDO, F2_CLIENTE , F2_LOJA, A1_NOME , F2_EMISSAO,
F2_VALBRUT, A3_NREDUZ, C5_VOLUME1, C5_VOLUME2, F2_VOLUME1, F2_PBRUTO, A1_BAIRRO, F2_TRANSP, A4_NREDUZ
FROM SF2020 F2
INNER JOIN SD2020 D2 ON D2.D_E_L_E_T_ ='' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA
INNER JOIN SA1020 A1 ON A1.D_E_L_E_T_ ='' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA
INNER JOIN SC5020 C5 ON C5.D_E_L_E_T_ ='' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE AND C5_LOJACLI = D2_LOJA 
LEFT JOIN SA3020 A3 ON A3.D_E_L_E_T_='' AND A3_COD = C5_VEND1
LEFT JOIN SA4020 A4 ON A4.D_E_L_E_T_='' AND A4_COD = F2_TRANSP
WHERE F2.D_E_L_E_T_ ='' AND F2_FILIAL = %Exp:CFILANT% AND 
F2_EMISSAO = %Exp:MV_PAR01%
ORDER BY F2_DOC

ENDSQL
	oSection1:EndQuery()
#ENDIF

oSection1:Print()
Return
