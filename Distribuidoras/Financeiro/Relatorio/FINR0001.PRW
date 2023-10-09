//Programa - Relatorio Contas a Receber por Filial
//Solicitado - Renato
//Autor - Andre Salgado / Introde - 20/03/2018


/* ************************* MELHORIAS  *********************
Data 07/08/2018 - André Salgado - Inclui as colunas TIPO DE COBRANÇA e Nf Devoluçao Original
Data 14/11/2018 - André Salgado - Incluir o MV_PAR07 (Filta Somente Titulos a Receber) SIM ou NAO, para Renato gerar o rel.conforme solicitação interna


*/ 

#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

User function FINR0001()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("RFIN01",10,"X")
Private cTitulo		:= "ANALISE CONTAS A RECEBER EM ABERTO"
Private nLinPrint 	:= 999999

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

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SA3","SE1","SF2","SX5"})

TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(05))	//Empresa
TRCell():New(oSection1,"E1_NUM"			,"TRB",,,(09))	//Nr Titulo
TRCell():New(oSection1,"E1_PARCELA"		,"TRB",,,(01))	//Parcela
TRCell():New(oSection1,"E1_TIPO"		,"TRB",,,(02))	//Tipo
TRCell():New(oSection1,"E1_CLIENTE"		,"TRB",,,(06))	//Cod.Cliente
TRCell():New(oSection1,"E1_LOJA"		,"TRB",,,(02))	//Loja
TRCell():New(oSection1,"A1_NOME"		,"TRB",,,(40))	//Cliente
TRCell():New(oSection1,"A1_NREDUZ"		,"TRB",,,(20))	//Fantasia
TRCell():New(oSection1,"A1_EST"			,"TRB",,,(02))	//UF
TRCell():New(oSection1,"A1_CGC"			,"TRB",,,(16))	//CNPJ
TRCell():New(oSection1,"E1_EMISSAO"		,"TRB",,,(10))	//Emissao
TRCell():New(oSection1,"E1_VENCORI"		,"TRB","Venc.Orig",,(10))	//Venco Original
TRCell():New(oSection1,"E1_VENCREA"		,"TRB",,,(10))	//Venco Real
TRCell():New(oSection1,"E1_BAIXA"		,"TRB",,,(10))	//Venco Real

TRCell():New(oSection1,"E1_PORTADO"		,"TRB",,,(03))	//Banco
TRCell():New(oSection1,"E1_AGEDEP"		,"TRB",,,(03))	//Agencia
TRCell():New(oSection1,"E1_CONTA"		,"TRB",,,(03))	//Conta
TRCell():New(oSection1,"E1_VALOR"		,"TRB",,,(15))	//Valor do Titulo
//TRCell():New(oSection1,"D1_TOTAL"		,"TRB","Total Nf Devol",,(15))	//Valor da NF Devolução
TRCell():New(oSection1,"E1_SALDO"		,"TRB",,,(15))	//Saldo do Titulo
TRCell():New(oSection1,"F2_ICMSRET"		,"TRB",,,(15))	//Icms Ret (ST)
TRCell():New(oSection1,"E1_HIST"		,"TRB",,,(40))	//Historico
//TRCell():New(oSection1,"NF_DEVOL"		,"TRB",,,(09))	//NF DEVOLUCAO

TRCell():New(oSection1,"E1_INSTR2"		,"TRB",,,(02))	//Situacao Cobrança
TRCell():New(oSection1,"E1_VEND1"		,"TRB",,,(06))	//Vendedor
TRCell():New(oSection1,"VENDEDOR"		,"TRB",,,(15))	//Nome Vendedor
TRCell():New(oSection1,"A3_GEREN"		,"TRB",,,(06))	//Gerente
TRCell():New(oSection1,"GERENTE"		,"TRB",,,(15))	//Nome Gerente
TRCell():New(oSection1,"E4_DESCRI"		,"TRB",,,(30))	//Condiçao de Pagamento
TRCell():New(oSection1,"A1_X_PROT"		,"TRB",,,(30))	//Pode ter Protesto

TRCell():New(oSection1,"SEG1"	,"TRB","Segmento 1",,(15))	//Descrição Segmento 1
TRCell():New(oSection1,"SEG2"	,"TRB","Segmento 2",,(15))	//Descrição Segmento 2


Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)


//MV_PAR07 = SIM   -   FILTRA SOMENTE TITULOS A RECEBER
IF MV_PAR07 = 1

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
	WHEN E1_FILIAL='0902' THEN 'DEVINTEX-MG'
	WHEN E1_FILIAL='1001' THEN 'GLAZY
	WHEN E1_FILIAL='1101' THEN 'BIZEZ'
	WHEN E1_FILIAL='1201' THEN 'ZAKAT'
	WHEN E1_FILIAL='1301' THEN 'HEXIL'
	WHEN E1_FILIAL='1401' THEN 'TROLL'

	ELSE E1_FILIAL END EMPRESA,
	
	E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, 
	E1_CLIENTE, E1_LOJA, E1_NOMCLI, A1_EST, A1_CGC, A1_NOME, A1_NREDUZ,
	E1_EMISSAO, E1_VENCREA, E1_PORTADO,E1_AGEDEP,E1_CONTA,A1_X_PROT,
	
	//Regra para Busca Vencimento Original
	CASE 
	WHEN E1_X_DTMAN<>' ' THEN E1_VENCORI
	WHEN E1_VENCORI=' '  THEN E1_VENCTO 
	WHEN DATEDIFF ( DAY , E1_VENCORI, E1_VENCREA  )<4 THEN E1_VENCREA
	ELSE E1_VENCORI END E1_VENCORI, E1_BAIXA,
	
	CASE WHEN E1_TIPO IN ('NCC','RA','AB-') THEN E1_VALOR *-1   ELSE E1_VALOR END E1_VALOR, 
	
	//CASE WHEN E1_TIPO IN ('NCC') THEN D1_TOTAL ELSE 0 END D1_TOTAL,

	CASE WHEN E1_TIPO IN ('NCC') THEN E1_SALDO *-1 
		 WHEN E1_TIPO IN ('RA')  THEN E1_SALDO *-1 ELSE E1_SALDO END E1_SALDO,

	CASE WHEN E1_PARCELA IN (' ','1','A') THEN F2_ICMSRET ELSE 0 END F2_ICMSRET,
	E1_HIST, E1_SITUACA, E1_INSTR2 ,
	E1_VEND1, A3.A3_NREDUZ VENDEDOR,
	A3.A3_GEREN, AG.A3_NREDUZ GERENTE, E4_DESCRI, //, ISNULL(D1_NFORI,' ') NF_DEVOL
	X51.X5_DESCRI SEG1, X52.X5_DESCRI SEG2
	 
	FROM %table:SE1% E1
	LEFT JOIN %table:SF2% F2 ON E1_FILIAL =F2_FILIAL  AND E1_NUM =F2_DOC  AND E1_PREFIXO=F2_SERIE AND F2.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SE4% E4 ON F2_COND=E4_CODIGO AND E4.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD     AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SX5% X51 ON X51.X5_FILIAL = E1_FILIAL AND X51.X5_TABELA='T3' AND X51.X5_CHAVE=A1_SATIV1 AND X51.D_E_L_E_T_=' '
	LEFT JOIN %table:SX5% X52 ON X52.X5_FILIAL = E1_FILIAL AND X52.X5_TABELA='Z2' AND X52.X5_CHAVE=A1_SATIV2 AND X52.D_E_L_E_T_=' '
	LEFT JOIN %table:SA3% A3 ON E1_VEND1  = A3.A3_COD AND A3.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SA3% AG ON A3.A3_GEREN = AG.A3_COD AND AG.D_E_L_E_T_=' ' 
	
	//LEFT JOIN (
	//SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_FORNECE, SUM(D1_TOTAL)-SUM(D1_VALDESC)+SUM(D1_ICMSRET) D1_TOTAL
	//FROM %table:SD1% D1
	//WHERE D1.D_E_L_E_T_=' ' AND D1_TIPO='D'
	//GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_FORNECE)DEV 
	//ON E1_FILIAL=D1_FILIAL AND E1_NUM=D1_DOC AND E1_PREFIXO=D1_SERIE AND E1_CLIENTE=D1_FORNECE AND E1_TIPO='NCC'
	
	WHERE 
	E1.D_E_L_E_T_=' '
	AND E1_SALDO>0
	AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
	AND E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
	AND E1_FILIAL  BETWEEN %Exp:MV_PAR05% and %Exp:MV_PAR06%
	
	ORDER BY E1_FILIAL, E1_CLIENTE, E1_EMISSAO
	
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()
	

//MV_PAR07 = NAO   -   APRESENTA TODOS OS TITULOS DO SISTEMA
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
	WHEN E1_FILIAL='0902' THEN 'DEVINTEX-MG'
	WHEN E1_FILIAL='1001' THEN 'GLAZY
	WHEN E1_FILIAL='1101' THEN 'BIZEZ'
	WHEN E1_FILIAL='1201' THEN 'ZAKAT'
	WHEN E1_FILIAL='1301' THEN 'HEXIL'
	WHEN E1_FILIAL='1401' THEN 'TROLL'
	
	ELSE E1_FILIAL END EMPRESA,
	
	E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, 
	E1_CLIENTE, E1_LOJA, E1_NOMCLI, A1_EST, A1_CGC, A1_NOME, A1_NREDUZ,
	E1_EMISSAO, E1_VENCREA, E1_PORTADO,E1_AGEDEP,E1_CONTA,A1_X_PROT, X51.X5_DESCRI SEG1, X52.X5_DESCRI SEG2, 
	
	//Regra para Busca Vencimento Original
	CASE 
	WHEN E1_X_DTMAN<>' ' THEN E1_VENCORI
	WHEN E1_VENCORI=' '  THEN E1_VENCTO 
	WHEN DATEDIFF ( DAY , E1_VENCORI, E1_VENCREA  )<4 THEN E1_VENCREA
	ELSE E1_VENCORI END E1_VENCORI, E1_BAIXA,
	
	CASE WHEN E1_TIPO IN ('NCC','RA') THEN E1_VALOR *-1   ELSE E1_VALOR END E1_VALOR,
	CASE WHEN E1_TIPO IN ('NCC','RA') THEN E1_SALDO *-1   ELSE E1_SALDO END E1_SALDO,
	CASE WHEN E1_PARCELA IN (' ','1','A') THEN F2_ICMSRET ELSE 0        END F2_ICMSRET,
	E1_HIST, E1_SITUACA, E1_INSTR2 ,
	E1_VEND1, A3.A3_NREDUZ VENDEDOR,
	A3.A3_GEREN, AG.A3_NREDUZ GERENTE, E4_DESCRI, ISNULL(D1_NFORI,' ') NF_DEVOL
	 
	FROM %table:SE1% E1
	LEFT JOIN %table:SF2% F2 ON E1_FILIAL =F2_FILIAL  AND E1_NUM =F2_DOC  AND E1_PREFIXO=F2_SERIE AND F2.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SE4% E4 ON F2_COND=E4_CODIGO AND E4.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD     AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
	LEFT JOIN SX5020 X51 ON X51.X5_FILIAL = E1_FILIAL AND X51.X5_TABELA='T3' AND X51.X5_CHAVE=A1_SATIV1 AND X51.D_E_L_E_T_=' '
	LEFT JOIN SX5020 X52 ON X52.X5_FILIAL = E1_FILIAL AND X52.X5_TABELA='Z2' AND X52.X5_CHAVE=A1_SATIV2 AND X52.D_E_L_E_T_=' '
	LEFT JOIN %table:SA3% A3 ON E1_VEND1  = A3.A3_COD AND A3.D_E_L_E_T_=' ' 
	LEFT JOIN %table:SA3% AG ON A3.A3_GEREN = AG.A3_COD AND AG.D_E_L_E_T_=' ' 
	LEFT JOIN (
	SELECT DISTINCT D1_FILIAL,D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_FORNECE
	FROM %table:SD1% D1
	WHERE D1.D_E_L_E_T_=' ' AND D1_TIPO='D')DEV ON E1_FILIAL=D1_FILIAL AND E1_NUM=D1_DOC AND E1_PREFIXO=D1_SERIE AND E1_CLIENTE=D1_FORNECE AND E1_TIPO='NCC'
	
	WHERE 
	E1.D_E_L_E_T_=' '
	//AND E1_SALDO>0
	AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
	AND E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
	AND E1_FILIAL  BETWEEN %Exp:MV_PAR05% and %Exp:MV_PAR06%
	
	ORDER BY E1_FILIAL, E1_CLIENTE, E1_EMISSAO
	
		
	EndSQL
	oSection1:EndQuery()
	oSection1:Print()
	
Endif

return



//cria as perguntas
Static Function AjustaSX1()
PutSx1( cPerg, "01", "Emissao NF De?", "Ordem ?", 		"Ordem ?", 		  "mv_ch1", "D", 08, 0, 1, "G","","", "", "", "mv_par01",,,,,,,,,,,,,,,,,	{"Emissao da Fatura De", "", ""},{},{} )
PutSx1( cPerg, "02", "Emissao NF Ate?", "Ordem ?", 		"Ordem ?", 		  "mv_ch2", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Emissao da Fatura Ate", "", ""},{},{} )
PutSx1( cPerg, "03", "Venc.Real NF De?", "Ordem ?", 	"Ordem ?", 		  "mv_ch3", "D", 08, 0, 1, "G","","", "", "", "mv_par03",,,,,,,,,,,,,,,,,	{"Vencto Real Fatura De", "", ""},{},{} )
PutSx1( cPerg, "03", "Venc.Real NF Ate?", "Ordem ?", 	"Ordem ?", 		  "mv_ch4", "D", 08, 0, 1, "G","","", "", "", "mv_par04",,,,,,,,,,,,,,,,,	{"Vencto Real Fatura Ate", "", ""},{},{} )
PutSx1( cPerg, "05", "Filial De ?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch5", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par05",,,,,,,,,,,,,,,,,{"Filial De ", "", ""},{},{} )
PutSx1( cPerg, "06", "Filial Ate?", "Ordem ?", 		    "Ordem ?", 		  "mv_ch6", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par06",,,,,,,,,,,,,,,,,{"Filial Ate", "", ""},{},{} )
Return
