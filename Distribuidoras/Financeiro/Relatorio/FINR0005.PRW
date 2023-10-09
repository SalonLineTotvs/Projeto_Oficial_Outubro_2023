//Programa - Relatorio Contas a Receber por Filial
//Solicitado - Renato
//Autor - Andre Salgado / Introde - 20/03/2018

#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

User function FINR0005()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= PADR("RFIN05",10,"X")
Private cTitulo		:= "ANALISE ICMS RETIDO EM TITULOS"
Private nLinPrint 	:= 999999

If TRepInUse()
	
	//==============================
	//?uncao que cria as perguntas.?
	//==============================
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

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SE1","SF2"})

TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(05))	//Empresa
TRCell():New(oSection1,"PREFIXO"		,"TRB",,,(03))	//Nr Titulo
TRCell():New(oSection1,"NUMTIT"			,"TRB",,,(09))	//Nr Titulo
TRCell():New(oSection1,"PARCELA"		,"TRB",,,(01))	//Parcela
TRCell():New(oSection1,"TIPOTIT"		,"TRB",,,(02))	//Tipo
TRCell():New(oSection1,"CLITIT" 		,"TRB",,,(06))	//Cod.Cliente
TRCell():New(oSection1,"LOJTIT"	        ,"TRB",,,(02))	//Loja
TRCell():New(oSection1,"NOMETIT"		,"TRB",,,(40))	//Cliente
TRCell():New(oSection1,"ESTTIT"			,"TRB",,,(02))	//UF
TRCell():New(oSection1,"CGCTIT"			,"TRB",,,(16))	//CNPJ
TRCell():New(oSection1,"EMITIT" 		,"TRB",,,(10))	//Emissao
TRCell():New(oSection1,"VENTIT" 		,"TRB",,,(10))	//Venco Real
TRCell():New(oSection1,"VALOR"	    	,"TRB",,,(15))	//Valor do Titulo
TRCell():New(oSection1,"BAITIT" 		,"TRB",,,(10))	//Data de Baixa
TRCell():New(oSection1,"HISTTIT"		,"TRB",,,(40))	//Historico
TRCell():New(oSection1,"TOTALNF"		,"TRB",,,(15))	//Valor Total da NF
TRCell():New(oSection1,"MERCADORIA"		,"TRB",,,(15))	//Valor MERCADORIA
TRCell():New(oSection1,"ICMSRET"		,"TRB",,,(15))	//Valor ICMS retido
TRCell():New(oSection1,"CONDPAGTO"		,"TRB",,,(LEN(SE4->E4_COND)))	//Condicao de Pagamento
Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()
// Se a informacao em "DATA DE BAIXA DE :" for em branco pego todos os titulos ( abertos ou baixados )  
If MV_PAR03 = CTOD("  /  /  ")

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
E1_PREFIXO AS PREFIXO ,
E1_NUM AS NUMTIT ,
E1_PARCELA AS PARCELA ,
E1_TIPO AS TIPOTIT , 
E1_CLIENTE AS CLITIT ,
E1_LOJA AS LOJTIT ,
A1_EST AS ESTTIT , 
A1_CGC AS CGCTIT ,
A1_NOME AS NOMETIT ,
SUBSTRING(E1_EMISSAO,7,2)+'/'+SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) AS EMITIT ,
SUBSTRING(E1_VENCREA,7,2)+'/'+SUBSTRING(E1_VENCREA,5,2)+'/'+SUBSTRING(E1_VENCREA,1,4) AS VENTIT ,
SUBSTRING(E1_BAIXA,7,2)+'/'+SUBSTRING(E1_BAIXA,5,2)+'/'+SUBSTRING(E1_BAIXA,1,4) AS BAITIT,
E1_VALOR AS VALOR ,
E1_HIST AS HISTTIT ,
F2_VALBRUT AS TOTALNF ,
F2_VALMERC AS MERCADORIA,
F2_ICMSRET AS ICMSRET, 
F2_COND,
E4_COND AS CONDPAGTO
 
FROM %table:SE1% E1
LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD AND E1_LOJA=A1_LOJA     AND A1.D_E_L_E_T_=' ' 
LEFT JOIN %table:SF2% F2 ON E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC AND F2.D_E_L_E_T_=' ' 
LEFT JOIN %table:SE4% E4 ON E4_CODIGO = F2_COND AND E4.D_E_L_E_T_ = ''

WHERE 

E1.D_E_L_E_T_=' '
//AND E1_SALDO = 0
AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
//AND E1_BAIXA   BETWEEN %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
AND E1_FILIAL  BETWEEN %Exp:MV_PAR05%       and %Exp:MV_PAR06%
AND E1_PARCELA IN (' ','A','1')
AND F2_ICMSRET <> 0

ORDER BY E1_FILIAL, E1_CLIENTE, E1_EMISSAO

	
EndSQL
Else
// Caso contrario eu filtro somente para os baixados.
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
E1_PREFIXO AS PREFIXO ,
E1_NUM AS NUMTIT ,
E1_PARCELA AS PARCELA ,
E1_TIPO AS TIPOTIT , 
E1_CLIENTE AS CLITIT ,
E1_LOJA AS LOJTIT ,
A1_EST AS ESTTIT , 
A1_CGC AS CGCTIT ,
A1_NOME AS NOMETIT ,
SUBSTRING(E1_EMISSAO,7,2)+'/'+SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) AS EMITIT ,
SUBSTRING(E1_VENCREA,7,2)+'/'+SUBSTRING(E1_VENCREA,5,2)+'/'+SUBSTRING(E1_VENCREA,1,4) AS VENTIT ,
SUBSTRING(E1_BAIXA,7,2)+'/'+SUBSTRING(E1_BAIXA,5,2)+'/'+SUBSTRING(E1_BAIXA,1,4) AS BAITIT,
E1_VALOR AS VALOR ,
E1_HIST AS HISTTIT ,
F2_VALBRUT AS TOTALNF ,
F2_VALMERC AS MERCADORIA,
F2_ICMSRET AS ICMSRET, 
F2_COND,
E4_COND AS CONDPAGTO
 
FROM %table:SE1% E1
LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD AND E1_LOJA=A1_LOJA     AND A1.D_E_L_E_T_=' ' 
LEFT JOIN %table:SF2% F2 ON E1_PREFIXO = F2_SERIE AND E1_NUM = F2_DOC AND F2.D_E_L_E_T_=' ' 
LEFT JOIN %table:SE4% E4 ON E4_CODIGO = F2_COND AND E4.D_E_L_E_T_ = ''

WHERE 

E1.D_E_L_E_T_=' '
//AND E1_SALDO = 0
AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
AND E1_BAIXA   BETWEEN %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
AND E1_FILIAL  BETWEEN %Exp:MV_PAR05%       and %Exp:MV_PAR06%
AND E1_PARCELA IN (' ','A','1')
AND F2_ICMSRET <> 0

ORDER BY E1_FILIAL, E1_CLIENTE, E1_EMISSAO

	
EndSQL

EndIf
oSection1:EndQuery()
oSection1:Print()

return



//cria as perguntas
Static Function AjustaSX1()
PutSx1( cPerg, "01", "Emissao NF De?" , "Ordem ?", 		"Ordem ?", 		  "mv_ch1", "D", 08, 0, 1, "G","","", "", "", "mv_par01",,,,,,,,,,,,,,,,,	{"Emissao da Fatura De", "", ""},{},{} )
PutSx1( cPerg, "02", "Emissao NF Ate?", "Ordem ?", 		"Ordem ?", 		  "mv_ch2", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Emissao da Fatura Ate", "", ""},{},{} )
PutSx1( cPerg, "03", "Baixados De ?"  , "Ordem ?", 		"Ordem ?", 		  "mv_ch3", "D", 08, 0, 1, "G","","", "", "", "mv_par03",,,,,,,,,,,,,,,,,	{"Data de Baixa De", "", ""},{},{} )
PutSx1( cPerg, "04", "Baixados Ate?"  , "Ordem ?", 		"Ordem ?", 		  "mv_ch4", "D", 08, 0, 1, "G","","", "", "", "mv_par04",,,,,,,,,,,,,,,,,	{"Data de Baixa Ate", "", ""},{},{} )
PutSx1( cPerg, "05", "Filial De ?"    , "Ordem ?", 		"Ordem ?", 		  "mv_ch5", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par05",,,,,,,,,,,,,,,,,{"Filial De ", "", ""},{},{} )
PutSx1( cPerg, "06", "Filial Ate?"    , "Ordem ?", 		"Ordem ?", 		  "mv_ch6", "C", 04, 0, 1, "G","","SM0", "", "", "mv_par06",,,,,,,,,,,,,,,,,{"Filial Ate", "", ""},{},{} )
Return
