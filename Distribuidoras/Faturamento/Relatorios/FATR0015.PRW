#include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

//Programa - Relatorio Titulso Baixados
//Solicitado - Adelma
//Autor - Andre Salgado / Introde - 20/02/2019

User function FATR0015()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "RFAT015"
Private cTitulo		:= "Relatorio Notas Emitidas"

If TRepInUse()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que cria as perguntas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg, .T. )
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport)},"Este relatorio ira imprimir, conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1","SE1","SE5","SD2","SB1"})

IF 2=2
//nota aberto por produto
	TRCell():New(oSection1,"EMPRESA"		,"TRB",,,(20))
	TRCell():New(oSection1,"D2_DOC"			,"TRB",,,(10))
	TRCell():New(oSection1,"D2_SERIE"		,"TRB",,,(03))
	TRCell():New(oSection1,"D2_EMISSAO"		,"TRB",,,(10))
	TRCell():New(oSection1,"ANO_MES"		,"TRB",,,(10))
	TRCell():New(oSection1,"D2_CLIENTE"		,"TRB",,,(03))
	TRCell():New(oSection1,"D2_LOJA"		,"TRB",,,(02))
	TRCell():New(oSection1,"D2_TIPO"		,"TRB",,,(03))
	TRCell():New(oSection1,"A1_NOME"		,"TRB",,,(40))
	TRCell():New(oSection1,"A1_EST"			,"TRB",,,(02))
	TRCell():New(oSection1,"D2_CF"			,"TRB",,,(04))
	TRCell():New(oSection1,"D2_COD"			,"TRB",,,(15))
	TRCell():New(oSection1,"B1_DESC"		,"TRB",,,(40))
	
	TRCell():New(oSection1,"B1_POSIPI"		,"TRB",,,(10))
	TRCell():New(oSection1,"D2_QUANT"		,"TRB","Quantidade"	,,(16))
	TRCell():New(oSection1,"P_ICMS"			,"TRB","% ICMS"		,,(10))
	TRCell():New(oSection1,"P_ICMSRE"		,"TRB","% I.RET"	,,(10))
	TRCell():New(oSection1,"TOT_NF"			,"TRB","Vlr.Bruto NF"	,,(16))
	TRCell():New(oSection1,"VAL_MERC"		,"TRB","Vlr.Mercadoria"	,,(16))
	TRCell():New(oSection1,"BASE_ICM"		,"TRB","Base Icms"		,,(16))
	TRCell():New(oSection1,"IMP_ICMS"		,"TRB","ICMS"			,,(16))	
	TRCell():New(oSection1,"ICMS_RET"		,"TRB","ICMS Retido"	,,(16))		
	
//DEVOLUCA
ELSE

	/* SINTETICO
	TRCell():New(oSection1,"E1_FILIAL"		,"TRB",,,(04))
	TRCell():New(oSection1,"E1_CLIENTE"		,"TRB",,,(06))
	TRCell():New(oSection1,"E1_LOJA"		,"TRB",,,(02))
	TRCell():New(oSection1,"A1_NOME"		,"TRB",,,(40))
	TRCell():New(oSection1,"E1_SALDO"		,"TRB",,,(16))
	TRCell():New(oSection1,"DEV"			,"TRB","Saldo NCC",,(15))
	*/
	
	//ANALITICO
	TRCell():New(oSection1,"E1_FILIAL"		,"TRB",,,(04))
	TRCell():New(oSection1,"E1_TIPO"		,"TRB",,,(02))
	TRCell():New(oSection1,"E1_CLIENTE"		,"TRB",,,(06))
	TRCell():New(oSection1,"E1_LOJA"		,"TRB",,,(02))
	TRCell():New(oSection1,"E1_NOMCLI"		,"TRB",,,(40))
	TRCell():New(oSection1,"E1_PREFIXO"		,"TRB",,,(03))
	TRCell():New(oSection1,"E1_NUM"			,"TRB",,,(10))
	TRCell():New(oSection1,"E1_PARCELA"		,"TRB",,,(03))
	TRCell():New(oSection1,"E1_PORTADO"		,"TRB",,,(03))
	TRCell():New(oSection1,"E1_EMISSAO"		,"TRB",,,(10))
	TRCell():New(oSection1,"E1_VENCTO"		,"TRB",,,(05))
	TRCell():New(oSection1,"E1_VENCREA"		,"TRB",,,(10))
	TRCell():New(oSection1,"E1_SALDO"		,"TRB",,,(16))
	TRCell():New(oSection1,"DEV"			,"TRB","Saldo NCC",,(15))
	TRCell():New(oSection1,"E1_HIST"		,"TRB","Historico Titulo",,(05))
	
ENDIF


Return oReport



Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)


IF 2=2
//RELATORIO POR PRODUTO DE FATURAMENTO
	oSection1:BeginQuery()
	BeginSQL alias 'TRB'
		

	SELECT 
	D2_FILIAL EMPRESA, D2_DOC, D2_SERIE, D2_EMISSAO, LEFT(D2_EMISSAO,6) ANO_MES, D2_CLIENTE, D2_LOJA, D2_TIPO, R_SOCIAL A1_NOME, D2_EST A1_EST, D2_CF,
	D2_COD, B1_DESC, B1_POSIPI, D2_QUANT, D2_PICM P_ICMS,D2_ALIQSOL P_ICMSRE,
	SUM(D2_VALBRUT) TOT_NF, SUM(D2_TOTAL) VAL_MERCAD, SUM(D2_BASEICM) BASE_ICM, SUM(D2_VALICM) IMP_ICMS, SUM(D2_ICMSRET) ICMS_RET, 
	SUM(D2_BASEIPI) BASE_IPI, SUM(D2_VALIPI) IMP_IPI
	FROM (
	 
	SELECT 
	D2_FILIAL, 
	D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_TIPO, ISNULL(A1_NOME,A2_NOME) R_SOCIAL, ISNULL(A1_CGC,A2_CGC) CNPJ_CPF,D2_EST, D2_VALBRUT, D2_TOTAL, D2_BASEICM, D2_VALICM, D2_CF,
	D2_COD, B1_DESC, B1_POSIPI, D2_QUANT, D2_PICM,
	CASE WHEN D2_VALBRUT= D2_TOTAL THEN 0 ELSE D2_BRICMS END D2_BRICMS,
	CASE WHEN D2_VALBRUT= D2_TOTAL THEN 0 ELSE D2_ALIQSOL END D2_ALIQSOL,
	CASE WHEN D2_VALBRUT= D2_TOTAL THEN 0 ELSE D2_MARGEM END D2_MARGEM,
	CASE WHEN D2_VALBRUT= D2_TOTAL THEN 0 ELSE D2_ICMSRET END D2_ICMSRET,
	D2_BASEIPI, D2_VALIPI
	
	
	FROM %table:SD2% D2
	INNER JOIN %table:SB1% B1 ON D2_COD=B1_COD AND B1.D_E_L_E_T_=' ' 
	INNER JOIN %table:SF2% F2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND F2_FIMP='S' AND F2.D_E_L_E_T_=' ' 
	LEFT  JOIN %table:SA1% A1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' AND D2_TIPO NOT IN ('D','B')
	LEFT  JOIN %table:SA2% A2 ON D2_CLIENTE=A2_COD AND D2_LOJA=A2_LOJA AND A2.D_E_L_E_T_=' ' AND D2_TIPO IN ('D','B')
	
	WHERE 
	D2.D_E_L_E_T_=' '
	AND D2_EMISSAO  BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
	AND D2_FILIAL   BETWEEN %Exp:MV_PAR03% 		 and %Exp:MV_PAR04%
	
	)A 
	GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_TIPO, R_SOCIAL, D2_EST, D2_CF
	,D2_COD, B1_DESC, B1_POSIPI, D2_QUANT, D2_PICM,D2_ALIQSOL
	
	ORDER BY 1,2,3, D2_COD
	



	EndSQL
	oSection1:EndQuery()

    
//****************************
//  RELATORIO POR NOTA
//****************************
ELSE
	oSection1:BeginQuery()
	BeginSQL alias 'TRB'


SELECT * FROM SA1010


	
			
	EndSQL
	oSection1:EndQuery()

ENDIF
oSection1:Print()

return
