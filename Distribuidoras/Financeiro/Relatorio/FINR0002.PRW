//Programa - Relatorio Contas a Receber com filtro de Campos e Colunas conforme Solicitação Denise
//Solicitado - Denise/Tesouraria
//Autor - Andre Salgado / Introde - 13/04/2018
#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

User function FINR0002()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("RFIN02",10,"X")
Private cTitulo		:= "CONTAS A RECEBER EM ABERTO - FLUXO DE CAIXA"

//Revalida vencimento
cUpdQ := " UPDATE SE1020 SET E1_VENCREA ="
cUpdQ += " CONVERT(VARCHAR(10),"
cUpdQ += " dateadd(day,"
cUpdQ += " CASE "
cUpdQ += " WHEN RIGHT(E1_VENCREA,4) IN ('0907','1012','1102','1231') THEN 3"
cUpdQ += " WHEN RIGHT(E1_VENCREA,4) IN ('0501','1511','2011','2512') THEN 1"
cUpdQ += " WHEN Datepart(weekday, E1_VENCREA)=7 THEN 2"
cUpdQ += " WHEN Datepart(weekday, E1_VENCREA)=1 THEN 1"
cUpdQ += " ELSE E1_VENCREA END"
cUpdQ += " ,E1_VENCREA) ,112) WHERE"
cUpdQ += " D_E_L_E_T_=' '"
cUpdQ += " AND E1_VENCREA >= '20181101'"
cUpdQ += " AND (Datepart(weekday, E1_VENCREA) in ('1','7') OR RIGHT(E1_VENCREA,4) IN ('0501','0907','1012','1102','1511','2011','2512','1231'))"
cUpdQ += " AND E1_SALDO>0"

TcSqlExec(cUpdQ)


If TRepInUse()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que cria as perguntas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX1()
	Pergunte(cPerg, .T. )
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport)},"Este relatorio ira imprimir, conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SA3","SE1"})

IF MV_PAR01 = 1   //Relatorio Analitico do Contas a Receber
	TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(05))	//Empresa
	TRCell():New(oSection1,"A1_NOME"		,"TRB",,,(40))	//Cliente
	TRCell():New(oSection1,"E1_TIPO"		,"TRB",,,(02))	//Tipo
	TRCell():New(oSection1,"E1_PREFIXO"		,"TRB",,,(03))	//Prefixo
	TRCell():New(oSection1,"E1_NUM"			,"TRB",,,(09))	//Nr Titulo
	TRCell():New(oSection1,"E1_PARCELA"		,"TRB",,,(01))	//Parcela
	TRCell():New(oSection1,"E1_EMISSAO"		,"TRB",,,(10))	//Emissao
	TRCell():New(oSection1,"E1_VENCREA"		,"TRB",,,(10))	//Venco Real
	TRCell():New(oSection1,"E1_SALDO"		,"TRB","Valor Em Aberto",,(15))	//Saldo do Titulo
	
Else			//Relatorio Sintetico
	TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(05))	//Empresa
	TRCell():New(oSection1,"E1_VENCREA"		,"TRB",,,(10))	//Venco Real
	TRCell():New(oSection1,"E1_SALDO"		,"TRB","Valor Em Aberto",,(15))	//Saldo do Titulo
Endif


Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)



IF MV_PAR01 = 1   //Relatorio Analitico do Contas a Receber
	
	oSection1:BeginQuery()
	BeginSQL alias 'TRB'
	
		SELECT 
		
		CASE 
		WHEN E1_FILIAL='0101' THEN 'CIMEX'
		WHEN E1_FILIAL='0201' THEN 'CROZE'
		WHEN E1_FILIAL='0301' THEN 'KOPEK'
		WHEN E1_FILIAL='0401' THEN 'MACO'
		WHEN E1_FILIAL='0501' THEN 'QUBIT'
		WHEN E1_FILIAL='0601' THEN 'ROJA'
		WHEN E1_FILIAL='0701' THEN 'VIXEN'
		WHEN E1_FILIAL='0801' THEN 'MAIZE'
		WHEN E1_FILIAL='0901' THEN 'DEVINTEX'
		ELSE E1_FILIAL END EMPRESA,
		
		E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, 
		E1_CLIENTE, E1_LOJA, E1_NOMCLI, A1_EST, A1_CGC, A1_NOME, A1_NREDUZ,
		E1_EMISSAO, E1_VENCREA, E1_PORTADO,
		CASE WHEN E1_TIPO IN ('NCC','RA') THEN E1_VALOR *-1   ELSE E1_VALOR END E1_VALOR,
		CASE WHEN E1_TIPO IN ('NCC','RA') THEN E1_SALDO *-1   ELSE E1_SALDO END E1_SALDO
		 
		FROM %table:SE1% E1
		LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD     AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
		
		WHERE 
		E1.D_E_L_E_T_=' '
		AND E1_TIPO NOT in ('NCC','RA') 	//Denise, solicitou para analisar SÓ o valor programado para receber !!!
		AND E1_SALDO>0
		AND E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR02)% and %Exp:DTOS(MV_PAR03)%
		AND E1_FILIAL  BETWEEN %Exp:MV_PAR04% and %Exp:MV_PAR05%
		
		ORDER BY E1_FILIAL, E1_VENCREA, E1_PARCELA, E1_NUM //E1_CLIENTE, E1_EMISSAO
		
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()


//Relatorio Sintetico
Else
	
	oSection1:BeginQuery()
	BeginSQL alias 'TRB'
	
		SELECT 
		
		CASE 
		WHEN E1_FILIAL='0101' THEN 'CIMEX'
		WHEN E1_FILIAL='0201' THEN 'CROZE'
		WHEN E1_FILIAL='0301' THEN 'KOPEK'
		WHEN E1_FILIAL='0401' THEN 'MACO'
		WHEN E1_FILIAL='0501' THEN 'QUBIT'
		WHEN E1_FILIAL='0601' THEN 'ROJA'
		WHEN E1_FILIAL='0701' THEN 'VIXEN'
		WHEN E1_FILIAL='0801' THEN 'MAIZE'
		WHEN E1_FILIAL='0901' THEN 'DEVINTEX'
		ELSE E1_FILIAL END EMPRESA,
		
		E1_VENCREA,
		SUM(E1_SALDO) E1_SALDO
		 
		FROM %table:SE1% E1
		LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD     AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
		
		WHERE 
		E1.D_E_L_E_T_=' '
		AND E1_TIPO NOT in ('NCC','RA') 	//Denise, solicitou para analisar SÓ o valor programado para receber !!!
		AND E1_SALDO>0
		AND E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR02)% and %Exp:DTOS(MV_PAR03)%
		AND E1_FILIAL  BETWEEN %Exp:MV_PAR04% and %Exp:MV_PAR05%

		GROUP BY E1_FILIAL,	E1_VENCREA
		ORDER BY 1,2
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()

Endif
	
return



//cria as perguntas
Static Function AjustaSX1()
PutSx1( cPerg, "01", "Ordem ?", 		"Ordem ?", 		"Ordem ?", 		  "mv_ch1", "N", 01, 0, 1, "C","","", "", "", "mv_par01","Sintetico","Sintetico","Sintetico","Analitico","Analitico","Analitico","","","",,,,,,,,	{"Ordem do Relatório", "", ""},{},{} )
PutSx1( cPerg, "02", "Venc.Real NF De?", "Ordem ?", 	"Ordem ?", 		  "mv_ch2", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Vencto Real Fatura De", "", ""},{},{} )
PutSx1( cPerg, "03", "Venc.Real NF Ate?", "Ordem ?", 	"Ordem ?", 		  "mv_ch3", "D", 08, 0, 1, "G","","", "", "", "mv_par03",,,,,,,,,,,,,,,,,	{"Vencto Real Fatura Ate", "", ""},{},{} )
PutSx1( cPerg, "04", "Filial De ?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch4", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par04",,,,,,,,,,,,,,,,,{"Filial De ", "", ""},{},{} )
PutSx1( cPerg, "05", "Filial Ate?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch5", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par05",,,,,,,,,,,,,,,,,{"Filial Ate", "", ""},{},{} )
Return
