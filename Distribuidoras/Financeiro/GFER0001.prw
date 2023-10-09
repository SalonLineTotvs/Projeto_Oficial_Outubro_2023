//*********************************************************
//Programa - Mod.Faturamento - Relatorio Analise do CTE
//Solicitado - Pedro / Marcio / Jose do Frete
//Autor - Andre Salgado / Introde - 26/04/2022
//**********************************************************
#include "Protheus.ch"

User function GFER0001()

Local oReport
Local aRet		:= {ctod("  /  /  "),ctod("  /  /  "),ctod("  /  /  "),ctod("  /  /  "),space(10),"ZZZZZZZZZZ",SPace(14),"99999999999999"}
Private oSection1	:= Nil
Private cTitulo		:= "Relacao Analise do Frete x CTE x Fatura x N.Fiscal Saida"

//Local nSomaProc := 0

If !ParamBox( {;
	{1,"Dt Inicial da Fatura ?"	,aRet[1],"@!",,,,70,.F.},;
	{1,"Dt Final da Fatura ?"	,aRet[2],"@!",,,,70,.F.},;
	{1,"Vencto Inicial ?"	    ,aRet[3],"@!",,,,70,.F.},;
	{1,"Vencto Final ?"	        ,aRet[4],"@!",,,,70,.F.},;
	{1,"Fatura De "	            ,aRet[5],"@!",,,,70,.F.},;
	{1,"Fatura Ate"	            ,aRet[6],"@!",,,,70,.F.},;
    {1,"Transportadora"	        ,aRet[7],"@!",,"GU3TRP",,70,.F.},;
    {1,"Transportadora"	        ,aRet[8],"@!",,"GU3TRP",,70,.F.};
	},"Informação para Filtro do CTE x Fatura", @aRet,,,,,,,,.T.,.T. )
	Return
End If


//Variaveis
MV_PAR01	:= DTOS(aRet[1])       //Data Inicial = D1_DTDIGIT
MV_PAR02    := DTOS(aRet[2])       //Data Final   = D1_DTDIGIT
MV_PAR03	:= DTOS(aRet[3])       //Data Inicial Vencimento = D1_DTDIGIT
MV_PAR04    := DTOS(aRet[4])       //Data Final  Vencimento  = D1_DTDIGIT
MV_PAR05	:= aRet[5]             //Fatura Inicial
MV_PAR06    := aRet[6]             //Fatura Final
MV_PAR07	:= aRet[7]             //Cod.Transportadora Inicial
MV_PAR08	:= aRet[8]             //Cod.Transportadora Final


//Pergunte(cPerg)
oReport := ReportDef()
oReport:PrintDialog()
Return


Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 
Local cPerg:=""

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport, aOrdem)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7


oSection1 := TRSection():New(oReport,"RELATORIO",{"SF2","GXI","GXJ","GXG","SA2","SA1"},aOrdem)

    TRCell():New(oSection1,"EMPRESA"	,"TRB",                   ,,(10))
    TRCell():New(oSection1,"GXI_NRFAT"	,"TRB","Nr.Fatura"        ,,(10))
    TRCell():New(oSection1,"GXI_DTEMIS"	,"TRB",,,(10))
    TRCell():New(oSection1,"GXI_DTVENC" ,"TRB",,,(10))
    TRCell():New(oSection1,"GXI_VLFATU"	,"TRB",,,(12))
    TRCell():New(oSection1,"GXJ_EMISDF"	,"TRB","Cnpj CTE",,(12))
    TRCell():New(oSection1,"GU7_CDUF"	,"TRB",,,(04))
    TRCell():New(oSection1,"CFOP"	    ,"TRB",,,(04))
    TRCell():New(oSection1,"XML_CHAVE"	,"TRB",,,(04))
    TRCell():New(oSection1,"A2_NOME" 	,"TRB",,,(30))
    TRCell():New(oSection1,"A2_COD"	    ,"TRB","Cod.Forn.",,(06))
    TRCell():New(oSection1,"GXJ_NRDF"   ,"TRB","Nr.CTE",,(10))
    TRCell():New(oSection1,"GXG_DTEMIS"	,"TRB",,,(10))
    TRCell():New(oSection1,"GXG_VLDF"   ,"TRB",,,(12))
    TRCell():New(oSection1,"GXG_BASIMP"	,"TRB",,,(12))
    TRCell():New(oSection1,"GXG_PCIMP"	,"TRB",,,(06))
    TRCell():New(oSection1,"GXG_VLIMP"  ,"TRB",,,(12))
    TRCell():New(oSection1,"NFS"        ,"TRB","NF Saida",,(09))
    TRCell():New(oSection1,"F2_VALBRUT" ,"TRB",,,(14))
    TRCell():New(oSection1,"F2_EMISSAO"	,"TRB","Dt Emis NFs",,(10))
    TRCell():New(oSection1,"F2_CLIENTE"	,"TRB",,,(06))
    TRCell():New(oSection1,"F2_LOJA"    ,"TRB",,,(02))
    TRCell():New(oSection1,"A1_NOME"	,"TRB",,,(30))
    TRCell():New(oSection1,"A1_NREDUZ"  ,"TRB",,,(20))
    TRCell():New(oSection1,"A1_MUN"     ,"TRB",,,(30))
    TRCell():New(oSection1,"F2_EST"     ,"TRB",,,(12))

    TRCell():New(oSection1,"TRANS_NF"	,"TRB","Trans.NF",,(30))
    TRCell():New(oSection1,"CNPJ_TRA"   ,"TRB","CNPJ T.NF",,(14))

    TRCell():New(oSection1,"A4_NREDUZ"  ,"TRB","Trans.Fatura",,(30))
    TRCell():New(oSection1,"CNPJ_TRA"      ,"TRB","CNPJ T.Fatura",,(14))
//    TRCell():New(oSection1,"IET"        ,"TRB","I.E. T.Fatura",,(14))
    TRCell():New(oSection1,"ESTT"        ,"TRB","UF T.Fatura",,(14))
    


Return oReport



//Gera o Relatorio 
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)

#IFDEF TOP

    //,RIGHT(GXH_NRDC,9) NFS, F2_VALBRUT, F2_EMISSAO, F2_EST, F2_CLIENTE, F2_LOJA, A1_NOME, A1_NREDUZ, A1_MUN

	oSection1:BeginQuery()
	
	BeginSQL alias 'TRB'

    SELECT DISTINCT 
    LEFT(X5_DESCRI,10) EMPRESA, GXI_NRFAT, GXI_DTEMIS, GXI_DTVENC, GXI_VLFATU, 
    ISNULL(XML_EMIT,GXJ_EMISDF) GXJ_EMISDF, GU7_CDUF, ISNULL(A2_NOME,'!!! CADASTRAR O FORNECEDOR !!!') A2_NOME, A2_COD, A2_LOJA, GXJ_NRDF, GXJ_SERDF,
    GXG_DTEMIS, GXG_VLDF, GXG_BASIMP, GXG_PCIMP, GXG_VLIMP
    ,RIGHT(GXH_NRDC,9) NFS, 
ISNULL(F2_VALBRUT,F1_VALBRUT)F2_VALBRUT, ISNULL(F2_EMISSAO,F1_DTDIGIT) F2_EMISSAO, ISNULL(F2_EST,F1_EST)F2_EST, ISNULL(F2_CLIENTE,F1_FORNECE)F2_CLIENTE, 
ISNULL(F2_LOJA,F1_LOJA) F2_LOJA, ISNULL(A1_NOME,'DEVINTEX') A1_NOME, ISNULL(A1_NREDUZ,'DEVINTEX') A1_NREDUZ, ISNULL(A1_MUN,'SAO PAULO') A1_MUN

    ,F2_TRANSP+' '+A4_NREDUZ TRANS_NF, A4_CGC CNPJ_TRA
    ,GU3_IDFED CNPJT, GU3_IE IET, GU3_NMEMIT TRANST, A4_EST ESTT, A4_NREDUZ,
    XML_CHAVE
    ,CASE WHEN RIGHT(RTRIM(XML_MUNMT),2)=RIGHT(RTRIM(XML_MUNDT),2) THEN '5353' ELSE LEFT(XML_NATOPE,4) END CFOP

    FROM GXI020 GXI (NOLOCK)
    INNER JOIN GXJ020 GXJ (NOLOCK) ON GXI_FILIAL=GXJ_FILIAL AND GXJ_NRIMP=GXI_NRIMP AND GXJ.D_E_L_E_T_=' ' 
    //INNER JOIN GXG020 GXG (NOLOCK) ON GXI_FILIAL=GXG_FILIAL AND LTRIM(GXJ_NRDF) = LTRIM(ROUND(GXG_NRDF,0)) AND GXG.D_E_L_E_T_=' ' 
    INNER JOIN GXG020 GXG (NOLOCK) ON GXI_FILIAL=GXG_FILIAL AND 
    LTRIM(GXJ_NRDF) = SUBSTRING(GXG_NRDF, PATINDEX('%[^0]%', GXG_NRDF), LEN(GXG_NRDF)) AND GXG.D_E_L_E_T_=' '  //AND GXI_DTIMP=GXG_DTIMP AND GXG.D_E_L_E_T_=' ' 
    INNER JOIN GXH020 GXH (NOLOCK) ON GXG_FILIAL=GXH_FILIAL AND GXG_NRIMP=GXH_NRIMP AND GXH.D_E_L_E_T_=' ' AND GXH_SEQ='00001'
    INNER JOIN SX5020 X5  (NOLOCK) ON X5_FILIAL='0101' AND X5_TABELA='ZE' AND GXI_FILIAL=LEFT(X5_CHAVE,4) AND X5.D_E_L_E_T_=' '
    INNER JOIN GU3020 GU3 (NOLOCK) ON GXI_EMIFAT=GU3_CDEMIT AND GU3.D_E_L_E_T_=' '
    INNER JOIN GU7020 GU7 (NOLOCK) ON GU3_NRCID=GU7_NRCID AND GU7.D_E_L_E_T_=' ' 

    LEFT JOIN CONDORXML   (NOLOCK) ON  LEFT(GU3_IDFED,8)=LEFT(XML_EMIT,8) AND RIGHT('000000000'+RTRIM(GXJ_NRDF),9) = RIGHT(RTRIM(XML_NUMNF),9) AND GXG_DTEMIS=XML_EMISSA
    //LEFT JOIN CONDORXML   (NOLOCK) ON  LEFT(GU3_IDFED,8)=LEFT(XML_EMIT,8) AND RIGHT('000000000'+RTRIM(GXJ_NRDF),9) = RIGHT(RTRIM(XML_NUMNF),9) 

    LEFT JOIN SF2020 SF2 (NOLOCK) ON GXH_FILIAL=F2_FILIAL AND RIGHT(GXH_NRDC,9)=F2_DOC AND SF2.D_E_L_E_T_=' ' AND GXH_CNPJEM NOT IN ('01773518000635')
    LEFT JOIN SF1020 SF1 (NOLOCK) ON GXH_FILIAL=F1_FILIAL AND RIGHT(GXH_NRDC,9)=F1_DOC AND SF1.D_E_L_E_T_=' ' AND F1_FORNECE='002196' AND GXH_CNPJEM='01773518000635'
    LEFT JOIN SA2020 SA2 (NOLOCK) ON LEFT(GU3_IDFED,14)=A2_CGC AND SA2.D_E_L_E_T_=' ' 
    LEFT JOIN SA1020 SA1 (NOLOCK) ON F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_=' '
    LEFT JOIN SA4020 SA4 (NOLOCK) ON F2_TRANSP=A4_COD AND SA4.D_E_L_E_T_=' ' 

    WHERE 
    GXI.D_E_L_E_T_=' ' 
    and XML_CHAVE is not null
    AND GXI_DTEMIS BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    AND GXI_DTVENC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
    AND GXI_NRFAT  BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
    AND GXI_EMIFAT BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%

	EndSQL
	oSection1:EndQuery()
	
#ENDIF
oSection1:Print()
return
