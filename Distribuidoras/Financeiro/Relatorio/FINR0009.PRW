#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function FINR0009
    Relatório Contas a Receber por Filial e Grupo de Cliente]
    fonte convertido do FINR0001
    @type    
    @author Claudio Gaspar
    @since 30/09/2022
    @version 1.0
    /*/
User Function FINR0009()
   
    Local   oReport     := Nil
    Local   cTitulo		:= "ANALISE CONTAS A RECEBER EM ABERTO POR GRUPO DE CLIENTE"

    Private cPerg       := Padr("FINR0009",10)
   
        
    If FindFunction('TRepInUse') .And. TRepInUse()

        oReport := ReportDef(cTitulo)
        oReport:PrintDialog()
    
    EndIf

Return

Static Function ReportDef(cTitulo)
    Local cAliasTRB := GetNextAlias()
    Local oReport   := Nil 
    Local oSection1 := Nil
    oReport   := TReport():New(cPerg,cTitulo,cPerg,{|oReport|RptPrint(oReport, cAliasTRB)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
    oReport:DisableOrientation()
    oReport:SetLandscape()

    //validperg()


    Pergunte(oReport:uParam, .f. )
 
    
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Criacao da Sessao 2                                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oSection1:= TRSection():New(oReport,"Contas a Receber",{"SE1","SE4","SF2","SA1","SA3","SA1","ZD0"}) // "Contas a Receber"
    
    //TRCell():New(oSection1,"A1_CNPJBAS"      ,cAliasTRB,'GRUPO'      ,cPictGrp,40)	//Grupo
    TRCell():New(oSection1,"A1_CNPJBAS"      ,cAliasTRB,,,(06))	//Grupo
    TRCell():New(oSection1,"ZD0_NOMGRP"     ,cAliasTRB,,,(20))	//Descricao Grupo
    TRCell():New(oSection1,"EMPRESA"		,cAliasTRB,,,(05))	//Empresa
    TRCell():New(oSection1,"E1_NUM"			,cAliasTRB,,,(09))	//Nr Titulo
    TRCell():New(oSection1,"E1_PARCELA"		,cAliasTRB,,,(01))	//Parcela
    TRCell():New(oSection1,"E1_TIPO"		,cAliasTRB,,,(02))	//Tipo
    TRCell():New(oSection1,"E1_CLIENTE"		,cAliasTRB,,,(06))	//Cod.Cliente
    TRCell():New(oSection1,"E1_LOJA"		,cAliasTRB,,,(02))	//Loja
    TRCell():New(oSection1,"A1_NOME"		,cAliasTRB,,,(40))	//Cliente
    TRCell():New(oSection1,"A1_NREDUZ"		,cAliasTRB,,,(20))	//Fantasia
    TRCell():New(oSection1,"A1_EST"			,cAliasTRB,,,(02))	//UF
    TRCell():New(oSection1,"A1_CGC"			,cAliasTRB,,,(16))	//CNPJ
    TRCell():New(oSection1,"E1_EMISSAO"		,cAliasTRB,,,(10))	//Emissao
    TRCell():New(oSection1,"E1_VENCORI"		,cAliasTRB,"Venc.Orig",,(10))	//Venco Original
    TRCell():New(oSection1,"E1_VENCREA"		,cAliasTRB,,,(10))	//Venco Real
    TRCell():New(oSection1,"E1_BAIXA"		,cAliasTRB,,,(10))	//Venco Real

    TRCell():New(oSection1,"E1_PORTADO"		,cAliasTRB,,,(03))	//Banco
    TRCell():New(oSection1,"E1_AGEDEP"		,cAliasTRB,,,(03))	//Agencia
    TRCell():New(oSection1,"E1_CONTA"		,cAliasTRB,,,(03))	//Conta
    TRCell():New(oSection1,"E1_VALOR"		,cAliasTRB,,,(15))	//Valor do Titulo
    TRCell():New(oSection1,"E1_SALDO"		,cAliasTRB,,,(15))	//Saldo do Titulo
    TRCell():New(oSection1,"F2_ICMSRET"		,cAliasTRB,,,(15))	//Icms Ret (ST)
    TRCell():New(oSection1,"E1_HIST"		,cAliasTRB,,,(40))	//Historico

    TRCell():New(oSection1,"E1_INSTR2"		,cAliasTRB,,,(02))	//Situacao Cobrança
    TRCell():New(oSection1,"E1_VEND1"		,cAliasTRB,,,(06))	//Vendedor
    TRCell():New(oSection1,"VENDEDOR"		,cAliasTRB,,,(15))	//Nome Vendedor
    TRCell():New(oSection1,"A3_GEREN"		,cAliasTRB,,,(06))	//Gerente
    TRCell():New(oSection1,"GERENTE"		,cAliasTRB,,,(15))	//Nome Gerente
    TRCell():New(oSection1,"E4_DESCRI"		,cAliasTRB,,,(30))	//Condiçao de Pagamento
    TRCell():New(oSection1,"A1_X_PROT"		,cAliasTRB,,,(30))	//Pode ter Protesto

    TRCell():New(oSection1,"SEG1"	,cAliasTRB,"Segmento 1",,(15))	//Descrição Segmento 1
    TRCell():New(oSection1,"SEG2"	,cAliasTRB,"Segmento 2",,(15))	//Descrição Segmento 2

    //oSection1:SetPageBreak(.f.)

Return oReport

Static Function RptPrint(oReport, cAliasTRB)
    Local oSection1 := oReport:Section(1)
    
    oSection1:BeginQuery()
        BeginSQL alias cAliasTRB
                
        SELECT 
        A1_CNPJBAS, ZD0_NOMGRP,
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
        LEFT JOIN %table:SA1% A1 ON E1_CLIENTE=A1_COD       AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
        INNER JOIN %table:ZD0% ZD0 ON A1_CNPJBAS=ZD0_RAIZCN AND ZD0.D_E_L_E_T_=' '
        LEFT JOIN %table:SF2% F2 ON E1_FILIAL =F2_FILIAL    AND E1_NUM =F2_DOC  AND E1_PREFIXO=F2_SERIE AND F2.D_E_L_E_T_=' ' 
        LEFT JOIN %table:SE4% E4 ON F2_COND=E4_CODIGO       AND E4.D_E_L_E_T_=' ' 
        LEFT JOIN %table:SX5% X51 ON X51.X5_FILIAL = E1_FILIAL AND X51.X5_TABELA='T3' AND X51.X5_CHAVE=A1_SATIV1 AND X51.D_E_L_E_T_=' '
        LEFT JOIN %table:SX5% X52 ON X52.X5_FILIAL = E1_FILIAL AND X52.X5_TABELA='Z2' AND X52.X5_CHAVE=A1_SATIV2 AND X52.D_E_L_E_T_=' '
        LEFT JOIN %table:SA3% A3 ON E1_VEND1  = A3.A3_COD   AND A3.D_E_L_E_T_=' ' 
        LEFT JOIN %table:SA3% AG ON A3.A3_GEREN = AG.A3_COD AND AG.D_E_L_E_T_=' ' 
               
        WHERE 
        E1.D_E_L_E_T_=' '
        AND E1_SALDO>0
        AND E1_EMISSAO BETWEEN %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
        AND E1_VENCREA BETWEEN %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
        AND E1_FILIAL  BETWEEN %Exp:MV_PAR05% and %Exp:MV_PAR06%
        AND A1_CNPJBAS  BETWEEN %Exp:MV_PAR07% and %Exp:MV_PAR08%
     
        
        ORDER BY E1_FILIAL, E1_CLIENTE, E1_EMISSAO
        
            
        EndSQL
    
        
        oSection1:EndQuery()

        oSection1:Print()
	        
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_PutSx1    ³ Autor ³Wagner                 ³ Data ³ 14/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f. 


	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme       == Nil, " ", cPyme           )
	cF3      := Iif( cF3         == NIl, " ", cF3        )
	cGrpSxg  := Iif( cGrpSxg     == Nil, " ", cGrpSxg    )
	cCnt01   := Iif( cCnt01      == Nil, "" , cCnt01     )
	cHelp := Iif( cHelp          == Nil, "" , cHelp           )


	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP  With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort 
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa 
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return



