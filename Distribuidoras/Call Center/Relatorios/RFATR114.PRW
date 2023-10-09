//Solicitado - Luana / Marcelo Winter
//Autor - Andre Salgado / Introde - 21/08/2021
//Atualizado - 16/11/2022
//****************************************************
#include "Protheus.ch"

User function RFATR14()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "RFATR0114" //PADR("RFATR013",10,"X")
Private cTitulo		:= "Relacao de Ocorrencias BI"

Pergunte(cPerg) 
oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 

oReport := TReport():New(cPerg,cTitulo+' - '+'ATENDIMENTOS',cPerg,{|oReport|PrintReport(oReport, aOrdem)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7

oSection1 := TRSection():New(oReport,"RELATORIO",{"SB1","SD1","SD2","SUD","SU9","SF2","SA4","SA1"},aOrdem)
    
	TRCell():New(oSection1,"UC_DATA"			,"TRB","Data Ocorrencia"        	,,(06))
    TRCell():New(oSection1,"UC_X_DTEVE"			,"TRB","Data de Evento"  			,,(20))
    TRCell():New(oSection1,"UC_CODIGO"			,"TRB","Atendimento"				,,(10))
	TRCell():New(oSection1,"UC_XPAI"			,"TRB","Atendimento Herdado"		,,(10))
    TRCell():New(oSection1,"NOMEMPRESA"			,"TRB","Distribuidora"     			,,(10))
    TRCell():New(oSection1,"A1_COD"	    		,"TRB","Cod Cliente"               	,,(02))
    TRCell():New(oSection1,"A1_LOJA" 			,"TRB","Loja Cliente"         		,,(02))
//  TRCell():New(oSection1,"OCORREN"			,"TRB","Cod Ocorrencia"     		,,(12))
    TRCell():New(oSection1,"OCORREN"			,"TRB","Motivo da Ocorrencia"       ,,(10))
    TRCell():New(oSection1,"U9_DESC"			,"TRB","Descricao da Ocorrencia"    ,,(10))
    TRCell():New(oSection1,"AREA_F"				,"TRB","Area OC"					,,(02))
    TRCell():New(oSection1,"A1_NOME"			,"TRB","Nome Cliente"     			,,(09))
    TRCell():New(oSection1,"CANAL_CLIENTE"		,"TRB","Canal do Cliente"  			,,(30))
    TRCell():New(oSection1,"A1_MUN"	    		,"TRB","Municipio"   				,,(30))
    TRCell():New(oSection1,"A1_EST"         	,"TRB","UF"      					,,(09))
    TRCell():New(oSection1,"VIP"        		,"TRB","VIP"						,,(10))
	TRCell():New(oSection1,"A1_TPRESS"          ,"TRB","Tipo Ressarc"               ,,(50))
// 	TIPO DE RESSARC TICKET 710 
	TRCell():New(oSection1,"UCXSTMER" 			,"TRB","Status Mercadoria"  		,,(20))
	TRCell():New(oSection1,"UD_DATA"			,"TRB","Data Acao"        			,,(06))
//	TRCell():New(oSection1,"UC_DATA"			,"TRB","Data Acao"        			,,(06))
	TRCell():New(oSection1,"UN_DESC"			,"TRB","Desc Acao"        			,,(30))
//  TRCell():New(oSection1,"DSFINAL"			,"TRB","Desc Acao"        			,,(30))
    TRCell():New(oSection1,"AREA"				,"TRB","Area Encaminhamento"  		,,(30))
	TRCell():New(oSection1,"NF"					,"TRB","Nota Fiscal"    			,,(12))
	TRCell():New(oSection1,"U7_NOME"			,"TRB","Nome Atendente"  			,,(02))
    TRCell():New(oSection1,"UCSTATUS"  			,"TRB","Status"       				,,(40))
 	TRCell():New(oSection1,"A3_NREDUZ"			,"TRB","Nome Vendedor"  			,,(20))
    TRCell():New(oSection1,"A3_EMAIL"			,"TRB","Email"  					,,(20))
    TRCell():New(oSection1,"A3_TEL"	    		,"TRB","Telefone"   				,,(30)) 
    TRCell():New(oSection1,"A3_GEREN"			,"TRB","Gerencia"  					,,(20))
    TRCell():New(oSection1,"MANIF"				,"TRB","Manifesto"                 	,,(20))
    TRCell():New(oSection1,"TRMANIF"			,"TRB","Transp Manifesto"      		,,(20))
    TRCell():New(oSection1,"DTMANIFX"			,"TRB","Data Manifesto" 			,,(12))
    TRCell():New(oSection1,"UC_X_ARMAZ"			,"TRB","Armazem"  					,,(20))
    TRCell():New(oSection1,"UC_X_REENT"			,"TRB","Reentrega"   				,,(20)) 
    TRCell():New(oSection1,"UC_X_DIA"			,"TRB","Diaria"  					,,(20))
    TRCell():New(oSection1,"UC_X_PERN"			,"TRB","Pernoite"  					,,(20))
    TRCell():New(oSection1,"UC_X_CCUST"			,"TRB","Reentrega sem Custo"   		,,(20)) 
    TRCell():New(oSection1,"UC_X_SDEVL"			,"TRB","Solic. Dev."  				,,(20))
	TRCell():New(oSection1,"UCXFINAN" 			,"TRB","Financeiro"  				,,(20))
	TRCell():New(oSection1,"CDFINAL"			,"TRB","Codigo de Finalizacao"     	,,(06))
    TRCell():New(oSection1,"DSFINAL"			,"TRB","Desc de Finalizacao"     	,,(06))
    TRCell():New(oSection1,"UD_OBS"	    		,"TRB","Observacao"   				,,(12))
    TRCell():New(oSection1,"NFD"        		,"TRB","NF Devol" 					,,(10))
	TRCell():New(oSection1,"UCXDEVOL" 			,"TRB","Devol"  					,,(20))
	TRCell():New(oSection1,"VLRNFORIGEM"		,"TRB","Vlr Nota Origem"  			,,(12))
    TRCell():New(oSection1,"RS"         		,"TRB","R$"            				,,(12))
	TRCell():New(oSection1,"VLRTXML"			,"TRB","Vlr NFD XML"     			,,(12))
    TRCell():New(oSection1,"UC_XENCFIN"			,"TRB","Fin. Financeiro"  			,,(06))
    //TRCell():New(oSection1,"UC_CODCANC"		,"TRB","Codigo de Cancelamento"     ,,(06))
    //TRCell():New(oSection1,"UC_DTCODENCE"		,"TRB","COD. ENCER"       			,,(10))
    //TRCell():New(oSection1,"UC_DTENCER"		,"TRB","Data Encerramento"     		,,(30))
    //TRCell():New(oSection1,"U7_NREDUZ"		,"TRB","Login Atendente"     		,,(02))
    //TRCell():New(oSection1,"PEDIDO"	    	,"TRB","Pedido"           			,,(10))
    //TRCell():New(oSection1,"ULTIMO"	    	,"TRB","Ultimo"        				,,(06))
    //TRCell():New(oSection1,"A1_X_PRIOR" 		,"TRB","Prioridade"        			,,(06))
    //TRCell():New(oSection1,"UD_DATA"			,"TRB","Data Ocorrencia"        	,,(06))
    //TRCell():New(oSection1,"SOLUCAO"			,"TRB","SOLUCAO"   					,,(25))
    //TRCell():New(oSection1,"NFORIGEM"			,"TRB","Nota Origem"  				,,(20))
    //TRCell():New(oSection1,"UC_X_ASS"			,"TRB","ASS"           				,,(20))
    //TRCell():New(oSection1,"A1_VEND"			,"TRB","Vendedor"   				,,(20)) 
   
Return oReport

//Gera o Relatorio da Devoluçao
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)

#IFDEF TOP
        oSection1:BeginQuery()
BeginSQL alias 'TRB'

SELECT DISTINCT 
		CASE UC_FILIAL 
		WHEN '0101' THEN 'CIMEX'
		WHEN '0201' THEN 'CROZE'
		WHEN '0301' THEN 'KOPEK'
		WHEN '0401' THEN 'MACO'
		WHEN '0501' THEN 'QUBIT'
		WHEN '0601' THEN 'ROJA'
		WHEN '0701' THEN 'VIXEN'
		WHEN '0801' THEN 'MAIZE'
		WHEN '0901' THEN 'DEV-FILIAL'
		WHEN '0901' THEN 'DEV-MG'
   		WHEN '1101' THEN 'BIZEZ'
		WHEN '1201' THEN 'ZAKAT'
		WHEN '1301' THEN 'HEXIL'
		WHEN '1401' THEN 'TROLL'
		ELSE UC_FILIAL END AS NOMEMPRESA
	, SUC.UC_FILIAL
	, SUC.UC_CODIGO
	, SUC.UC_XPAI
	, SUC.UC_DATA
	, SUC.UC_STATUS
	, SU7.U7_NOME
	, SA1.A1_COD
	, SA1.A1_LOJA
	, SA1.A1_MUN
	, SA1.A1_NOME
	, SA1.A1_TPRESS
	, SA1.A1_SATIV2
	, (SELECT TOP 1 SX5RAS.X5_DESCRI FROM SX5020 SX5RAS WHERE SX5RAS.X5_TABELA = 'Z2' AND SX5RAS.X5_CHAVE = SA1.A1_SATIV2 ) AS CANAL_CLIENTE
    , CASE WHEN SA1.A1_X_PRIOR IN('0','1') THEN 'VIP' ELSE 'DEMAIS' END VIP
    , CASE  WHEN UC_CODCANC =  '' AND UC_STATUS = '2' THEN 'PENDENTE' 
            WHEN UC_CODCANC =  '' AND UC_STATUS = '3' THEN 'ENCERRADO'
            WHEN UC_CODCANC =  '' AND UC_STATUS = '1' THEN 'PENDENTE' //pLANEJADO
            WHEN UC_CODCANC <> '' THEN 'CANCELADO'
            ELSE ' ' END UCSTATUS
	, SA1.A1_EST 
	, SUC.UC_X_NFD AS NFD
	, UC_XNFDVL2 AS VLRTXML
	, UC_DTENCER AS DTFINAL
	, UC_CODENCE AS CDFINAL
	, UC_CODCANC AS CDCANCE
	, UN_DESC AS DSFINAL
	, UC_X_ACAO UN_DESC // kelsen 06/10
	, UC_XENCFIN
    , SUDX.RS
    , SUDX.UD_OCORREN AS OCORREN 
	, U9_DESC
    , SUDX.UD_DATA
    , SUDX.AREA
    , SUDX.AREA_F
    , SUDX.U9_DESC
    , SUDX.NF
    , SUDX.UD_OBS
	, (substring(SUDX.DTMANIF,7,2)+'/'+substring(SUDX.DTMANIF,5,2)+'/'+substring(SUDX.DTMANIF,1,4)) AS DTMANIFX
    , SUDX.VLRNFORIGEM
    , SUDX.MANIF
	, SUDX.TRMANIF
    , CASE UC_X_DEVOL
		WHEN '1' THEN 'Parcial'
		WHEN '2' THEN 'Total'
		WHEN '3' THEN 'Retorno'
		ELSE UC_X_DEVOL END AS UCXDEVOL
	, CASE UC_X_STMER
		WHEN '1' THEN 'COLETA TRANSP (NO ATO)'
		WHEN '2' THEN 'COLETA TRANSP (POS ENTR.)'
		WHEN '3' THEN 'COLETA REP'
		WHEN '4' THEN 'DESCARTE/ACAO REP'
		WHEN '5' THEN 'DESCARTE CLIENTE'
		WHEN '6' THEN 'DEBITO TRANSP'
		WHEN '7' THEN 'FALTA'
		ELSE UC_X_STMER END AS UCXSTMER
	, CASE UC_X_FINAN
		WHEN '1' THEN 'Gerar Financeiro - Pagamento de Boleto'
		WHEN '2' THEN 'Bonificação SVC'
		WHEN '3' THEN 'Bonificação Troca'
		WHEN '4' THEN 'Gerar Financeiro'
		ELSE UC_X_FINAN END AS UCXFINAN
	, UC_X_DTEVE
	, UC_X_ARMAZ
	, UC_X_REENT
	, UC_X_DIA
	, UC_X_PERN
	, UC_X_CCUST
	, UC_X_SDEVL
	, SA3.A3_NREDUZ
	, SA3.A3_EMAIL
	, A3_TEL = SA3.A3_DDDTEL + SA3.A3_TEL
	, A3_GEREN = SA3G.A3_NOME

FROM  SUC020 SUC 
      INNER JOIN SA1020 SA1	ON SUC.UC_CHAVE = SA1.A1_COD + SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' 
      LEFT JOIN SA3020 SA3  ON SA3.A3_COD = SA1.A1_VEND  AND SA3.D_E_L_E_T_ = '' 
      LEFT JOIN SA3020 SA3G ON SA3G.A3_COD = SA3.A3_GEREN AND SA3G.D_E_L_E_T_ = '' 
      LEFT JOIN SU7020 SU7  ON SU7.U7_COD = SUC.UC_OPERADO AND SU7.D_E_L_E_T_ = '' 
      
	  LEFT JOIN SUN020 UN	ON LEFT(UN_FILIAL,2) = LEFT(UC_FILIAL,2) AND UN_ENCERR = UC_CODENCE AND UN.D_E_L_E_T_ = ''
	  LEFT JOIN (	  
				SELECT D1.UD_FILIAL
					  ,D1.UD_CODIGO
					  ,RS = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_OCO  THEN D2.UD_VLRTOTA END),'')
					  ,UD_OCORREN = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_MIN  THEN UD_OCORREN END),'')
					  ,U9_DESC = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_MIN  THEN U9_DESC END),'')
					  ,UD_DATA = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_DT  THEN UD_DATA END),'')
					  ,SOLUÇÃO = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_SL  THEN UQ_DESC END),'')
					  ,AREA = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_MX  THEN X5_DESCRI END),'')
					  ,AREA_F = ISNULL(MIN(CASE WHEN UD_ITEM = UD_ITEM_MIN  THEN X5_DESCRI END),'')
					  ,NF = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_NF  THEN UD_NNF END),'')
					  ,UD_OBS = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_OB  THEN UD_OBS END),'')
					  ,DTMANIF = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_NF  THEN Z1_DTMA END),'')
					  ,VLRNFORIGEM = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_NF  THEN F2_VALMERC END),'')
					  ,NFORIGEM = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_NF  THEN C5_NOTA END),'')
					  ,MANIF = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_NF  THEN Z1_NRMA END),'')
					  ,TRMANIF = ISNULL(MAX(CASE WHEN UD_ITEM = UD_ITEM_NF  THEN A4_NREDUZ END),'') 
				FROM (SELECT UD_FILIAL
							   ,UD_CODIGO
							   ,UD_ITEM
							   ,UD_OCORREN
							   ,UD_OBS
							   ,UD_DATA
							   ,UD_NNF  = REPLICATE('0', 9 - LEN(UD_NNF)) + UD_NNF
							   ,C5_NOTA = SC5x.C5_NOTA
							   ,SC5.C5_X_MANIF
							   ,Z1_TRANSP
							   ,Z1_NRMA
							   ,Z1_DTMA
							   ,A4_NREDUZ
							   ,UQ_DESC
							   ,F2_VALMERC
							   ,U9_DESC
							   ,X5_DESCRI
						FROM SUD020 SUD 
								LEFT JOIN SUQ120 SUQ	ON SUQ.D_E_L_E_T_ = '' AND SUQ.UQ_SOLUCAO = UD_XSOLUCA AND SUQ.UQ_DESC <> ''
								LEFT JOIN SC5020 SC5    ON SC5.D_E_L_E_T_ = '' AND SC5.C5_FILIAL  = UD_FILIAL AND SC5.C5_NOTA = REPLICATE('0', 9 - LEN(UD_NNF)) + UD_NNF
								LEFT JOIN SC5020 SC5X   ON SC5x.D_E_L_E_T_ = '' AND SC5x.C5_FILIAL  = SC5.C5_FILIAL AND SC5x.C5_NUM = SC5.C5_X_PEDOR
								
							    LEFT JOIN SZ1020 SZ1    ON SZ1.D_E_L_E_T_ = '' AND Z1_FILIAL = SC5.C5_FILIAL AND Z1_NRMA = SC5.C5_X_MANIF
							    LEFT JOIN SA4020 SA4    ON SA4.D_E_L_E_T_ = '' AND A4_COD = Z1_TRANSP
							    LEFT JOIN SF2020 SF2    ON SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = SC5.C5_FILIAL AND SF2.F2_DOC = SC5.C5_NOTA
							    LEFT JOIN (SELECT U9_CODIGO, U9_DESC = MAX(U9_DESC) FROM SU9020 WHERE D_E_L_E_T_ = '' AND U9_DESC <> '' GROUP BY U9_CODIGO) SU9 ON SU9.U9_CODIGO = SUD.UD_OCORREN
							    
							    LEFT JOIN SX5020 SX5    ON SX5.D_E_L_E_T_ = '' AND SX5.X5_FILIAL = SUD.UD_FILIAL AND SX5.X5_CHAVE = SUD.UD_ASSUNTO AND SX5.X5_TABELA = 'T1'                               
							WHERE SUD.D_E_L_E_T_ = '') D1
					,(SELECT UD_FILIAL
						, UD_CODIGO
						, UD_VLRTOTA = SUM(CASE WHEN UD_OCORREN <> '' THEN UD_VLRTOTA ELSE 0 END)
						, UD_ITEM_MIN  = MIN(UD_ITEM)
						, UD_ITEM_MX  = MAX(UD_ITEM)
						, UD_ITEM_OCO  = MAX(CASE WHEN UD_OCORREN <> '' THEN UD_ITEM ELSE '' END)
						, UD_ITEM_DT  = MAX(CASE WHEN UD_DATA <> '' THEN UD_ITEM ELSE '' END)
						, UD_ITEM_SL  = MAX(CASE WHEN UD_XSOLUCA <> '' THEN UD_ITEM ELSE '' END)
						, UD_ITEM_NF  = MIN(CASE WHEN ISNULL(UD_NNF, '') <> '' THEN UD_ITEM ELSE '99' END)
						, UD_ITEM_OB  = MIN(CASE WHEN UD_OBS <> '' THEN UD_ITEM ELSE '99' END)
						, UD_ITEM_AS  = MAX(CASE WHEN UD_PRODUTO <> '' AND UD_OCORREN <> '' THEN UD_ITEM ELSE '' END)
						, UD_ITEM_AS2  = MAX(CASE WHEN UD_OCORREN NOT IN ('000093','') THEN UD_ITEM ELSE '' END)

					FROM SUD020 AS SUD    (NOLOCK)
					WHERE D_E_L_E_T_ = ''
					GROUP BY  UD_FILIAL, UD_CODIGO ) D2       
				WHERE D1.UD_FILIAL = D2.UD_FILIAL
				AND D1.UD_CODIGO = D2.UD_CODIGO
				GROUP BY D1.UD_FILIAL ,D1.UD_CODIGO	 ) SUDX ON SUDX.UD_FILIAL  = UC_FILIAL AND SUDX.UD_CODIGO = UC_CODIGO
WHERE SUC.D_E_L_E_T_ <> '*' 
AND UC_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND UC_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND SUC.UC_OPERADO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND (	
        (%Exp:MV_PAR07% = '1' AND  UC_CODCANC = '' AND UC_STATUS IN ('1','2')
	OR 	(%Exp:MV_PAR07% = '2' AND  UC_CODCANC = '' AND UC_STATUS = '3') 
	OR 	(%Exp:MV_PAR07% = '3' AND  UC_CODCANC <> '' ) 
	OR 	(%Exp:MV_PAR07% = '4' ) ) 
    )
ORDER BY UC_DATA, NOMEMPRESA
ENDSQL
	oSection1:EndQuery()
#ENDIF
//AND UC_STATUS BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
oSection1:Print()
return
