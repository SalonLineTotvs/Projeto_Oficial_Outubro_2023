#include "Protheus.ch"

User function FINR0007()

Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel

	pergunte("FINR0007")	
	oReport := ReportDef()
	oReport:PrintDialog()
	
EndIf

Return


Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("FINR0007","Títulos a Rec. P/ Vendedor","FINR0007",{|oReport|PrintReport(oReport)},"Este relatório emite os títulos a Receber P/ Vendedor")

oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"Títulos a Rec. P/ Vendedor",{"SE1","SA1","SA3"})
TRCell():New(oSection1,"E1_VEND1"	,"TRB","Vendedor"	,,tamSx3("E1_VEND1")[1])
TRCell():New(oSection1,"A3_NREDUZ"	,"TRB","Nome"	    ,,tamSx3("A3_NREDUZ")[1])
TRCell():New(oSection1,"E1_PREFIXO"	,"TRB","Prefixo"	,,tamSx3("E1_PREFIXO")[1])
TRCell():New(oSection1,"E1_NUM" 	,"TRB","Título" 	,,10)
TRCell():New(oSection1,"E1_PARCELA"	,"TRB","Parc"		,,tamSx3("E1_PARCELA")[1])
TRCell():New(oSection1,"E1_TIPO"	,"TRB","Tipo"		,,tamSx3("E1_TIPO")[1])
TRCell():New(oSection1,"E1_CLIENTE"	,"TRB","Cliente"	,,7)
TRCell():New(oSection1,"E1_LOJA"	,"TRB","Loja"		,,tamSx3("E1_LOJA")[1])
TRCell():New(oSection1,"A1_NOME"	,"TRB","Nome"		,,tamSx3("A1_NOME")[1])
TRCell():New(oSection1,"E1_EMISSAO"	,"TRB","Emissao"	,pesqPict("SE1","E1_EMISSAO"),tamSx3("E1_EMISSAO")[1])
TRCell():New(oSection1,"E1_VENCREA"	,"TRB","Vencimento"	,pesqPict("SE1","E1_VENCREA"),tamSx3("E1_VENCREA")[1])
TRCell():New(oSection1,"E1_VALOR"	,"TRB","Valor"  	,pesqPict("SE1","E1_VALOR")  ,tamSx3("E1_VALOR")[1])
TRCell():New(oSection1,"E1_SALDO"	,"TRB","Saldo"  	,pesqPict("SE1","E1_SALDO")  ,tamSx3("E1_SALDO")[1])
TRCell():New(oSection1,"E1_HIST"	,"TRB","Histórico"	,,50)

oSection1:Cell("E1_VALOR"):SetHeaderAlign("RIGHT")
oSection1:Cell("E1_SALDO"):SetHeaderAlign("RIGHT")

Return oReport


Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1) 

#IFDEF TOP
	
	oSection1:BeginQuery()
	    
	BeginSQL alias 'TRB'

        SELECT E1_VEND1, A3_NREDUZ, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, 
        E1_CLIENTE, E1_LOJA, A1_NOME, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_HIST
        FROM %Table:SE1% E1
        INNER JOIN %Table:SA1% A1 ON E1_CLIENTE+E1_LOJA=A1_COD+A1_LOJA AND A1.%NotDel%
        INNER JOIN %Table:SA3% A3 ON E1_VEND1=A3_COD AND A3.%NotDel%
        WHERE E1.%NotDel% AND E1_SALDO > 0
        AND E1_TIPO NOT IN ('NCC') AND E1_FILIAL = %xFilial:SE1%
        AND E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR01)% AND %EXP:DTOS(MV_PAR02)%
        AND E1_VEND1 BETWEEN %Exp:MV_PAR03% AND %EXP:MV_PAR04% 
							
	EndSQL
	    
	oSection1:EndQuery()
			
#ENDIF          

oSection1:Print()

Return

Static function AjustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "NCM DE ?"	  , "", "", "mv_ch1", "C", tamSx3("B1_POSIPI")[1], 0, 0, "G", "", "SYD", "", "", "mv_par01")
	putSx1(cPerg, "02", "NCM ATE?"	  , "", "", "mv_ch2", "C", tamSx3("B1_POSIPI")[1], 0, 0, "G", "", "SYD", "", "", "mv_par02")
Return