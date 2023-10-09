#include "Protheus.ch"

User function FISR0001()

Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel

	pergunte("FISR0001")	
	oReport := ReportDef()
	oReport:PrintDialog()
	
EndIf

Return


Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("FISR0001","Apuração Pis/Cofins","FISR0001",{|oReport|PrintReport(oReport)},"Este relatório tem como objetivo emitir a Apuração Pis/Cofins")

oSection1 := TRSection():New(oReport,"Apuração Pis/Cofins",{"SD2","SB1"})

TRCell():New(oSection1,"D2_FILIAL"	,"TRB","Filial"	,,tamSx3("D2_FILIAL")[1])
TRCell():New(oSection1,"D2_EMISSAO"	,"TRB","Emissao",pesqPict("SD2","D2_EMISSAO"),tamSx3("D2_EMISSAO")[1])
TRCell():New(oSection1,"D2_DOC"	    ,"TRB","Nota"	,,tamSx3("D2_DOC")[1])
TRCell():New(oSection1,"D2_SERIE" 	,"TRB","Serie" 	,,tamSx3("D2_SERIE")[1])
TRCell():New(oSection1,"D2_COD"	    ,"TRB","Produto",,tamSx3("D2_COD")[1])
TRCell():New(oSection1,"B1_ORIGEM"	,"TRB","Origem"	,,tamSx3("B1_ORIGEM")[1])
TRCell():New(oSection1,"B1_POSIPI"	,"TRB","NCM"	,,tamSx3("B1_POSIPI")[1])
TRCell():New(oSection1,"D2_CF"	    ,"TRB","CFOP"	,,tamSx3("D2_CF")[1])
TRCell():New(oSection1,"D2_TOTAL"	,"TRB","Valor"  ,pesqPict("SD2","D2_TOTAL")  ,tamSx3("D2_TOTAL")[1])
TRCell():New(oSection1,"D2_VALIMP6"	,"TRB","PIS"  	,pesqPict("SD2","D2_VALIMP6") ,tamSx3("D2_VALIMP6")[1])
TRCell():New(oSection1,"D2_VALIMP5"	,"TRB","COFINS" ,pesqPict("SD2","D2_VALIMP5") ,tamSx3("D2_VALIMP5")[1])

oSection1:Cell("D2_TOTAL"):SetHeaderAlign("RIGHT")
oSection1:Cell("D2_VALIMP6"):SetHeaderAlign("RIGHT")
oSection1:Cell("D2_VALIMP5"):SetHeaderAlign("RIGHT")

Return oReport


Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1) 

#IFDEF TOP
	
	oSection1:BeginQuery()
	    
	BeginSQL alias 'TRB'

        SELECT D2_FILIAL, D2_EMISSAO, D2_DOC, D2_SERIE, D2_COD, B1_ORIGEM, 
        B1_POSIPI, D2_CF, D2_TOTAL, D2_VALIMP6, D2_VALIMP5
        FROM %Table:SD2% D2 
        INNER JOIN %Table:SB1% B1 ON D2_COD = B1_COD AND B1.%NotDel%
        WHERE D2.%NotDel% AND B1_ORIGEM='2'
        AND D2_FILIAL  BETWEEN %Exp:MV_PAR01% AND %EXP:MV_PAR02%
        AND D2_EMISSAO BETWEEN %Exp:DTOS(MV_PAR03)% AND %EXP:DTOS(MV_PAR04)%
        ORDER BY 1,2,3,5

    EndSQL
	    
	oSection1:EndQuery()
			
#ENDIF          

oSection1:Print()

Return