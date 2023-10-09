//Solicitado - Luana / Marcelo Winter
//Autor - Andre Salgado / Introde - 21/08/2021
//Atualizado - 16/11/2022
//****************************************************
#include "Protheus.ch"

User function RFATR115()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "RFATR0114" //PADR("RFATR013",10,"X")
Private cTitulo		:= "Relacao de Ocorrencias BI COM ITENS"

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

	TRCell():New(oSection1,"UC_DATA"	        ,"TRB","Data Ocorrencia"                ,,(06))
    TRCell():New(oSection1,"UC_X_DTEVE"	        ,"TRB","Data de Evento"                 ,,(20))
    TRCell():New(oSection1,"NUM_OCOR"	        ,"TRB","Atendimento"                    ,,(10))
    TRCell():New(oSection1,"UC_XPAI"			,"TRB","Atendimento Herdado"		    ,,(10))
    TRCell():New(oSection1,"NOMEMPRESA"	        ,"TRB","Distribuidora"                  ,,(10))
    TRCell():New(oSection1,"CLIENTE"	        ,"TRB","Cod Cliente"                    ,,(02))
    TRCell():New(oSection1,"LOJA" 		        ,"TRB","Loja Cliente"                   ,,(02))
    TRCell():New(oSection1,"PRODUTO" 	        ,"TRB","Cod Produto"                    ,,(02))
    TRCell():New(oSection1,"DESC_PRD" 	        ,"TRB","Descr Produto"                  ,,(02))
    TRCell():New(oSection1,"COD_OCOR"	        ,"TRB","Motivo da Ocorrencia"           ,,(10))
    TRCell():New(oSection1,"MOT_OCOR"	        ,"TRB","Descricao da Ocorrencia"        ,,(10))
    TRCell():New(oSection1,"AREA_F"		        ,"TRB","Area OC"                        ,,(02))
    TRCell():New(oSection1,"NOME_CLI"	        ,"TRB","Nome Cliente"                   ,,(09))
    TRCell():New(oSection1,"CANAL_CLIENTE"		,"TRB","Canal do Cliente"               ,,(30))
    TRCell():New(oSection1,"A1_MUN"	            ,"TRB","Municipio"                      ,,(30))
    TRCell():New(oSection1,"ESTADO"             ,"TRB","UF"                             ,,(09))
    TRCell():New(oSection1,"VIP"                ,"TRB","VIP"                            ,,(10))
    TRCell():New(oSection1,"A1_TPRESS"          ,"TRB","Tipo Ressarc"                   ,,(50))
    // TIPO DE RESSARC TICKET 710 
	TRCell():New(oSection1,"SITMER_"            ,"TRB","Status Mercadoria"              ,,(20))
	TRCell():New(oSection1,"UD_DATA"	        ,"TRB","Data Acao"                      ,,(06))
	TRCell():New(oSection1,"UQ_DESC"	        ,"TRB","Desc Acao"                      ,,(30))
	TRCell():New(oSection1,"UD_NNF"             ,"TRB","Nota Fiscal"                    ,,(12))
	TRCell():New(oSection1,"UD_X_TES"           ,"TRB","TES"		                    ,,(12))
	TRCell():New(oSection1,"F4_TEXTO"       	,"TRB","TES Desc"                 		,,(25))
	TRCell():New(oSection1,"NOME_OPE"	        ,"TRB","Nome Atendente"                 ,,(20))
    TRCell():New(oSection1,"UCSTATUS"           ,"TRB","Status"                         ,,(40))
 	TRCell():New(oSection1,"A3_NREDUZ"	        ,"TRB","Nome Vendedor"                  ,,(20))
    TRCell():New(oSection1,"A3_EMAIL"	        ,"TRB","Email"                          ,,(20))
    TRCell():New(oSection1,"GTEL"	        	,"TRB","Telefone"                       ,,(30)) 
    TRCell():New(oSection1,"GERENTE"	        ,"TRB","Gerencia"                       ,,(20))
    TRCell():New(oSection1,"NR_MANIF"	        ,"TRB","Manifesto"                      ,,(20))
    TRCell():New(oSection1,"TRANSPO"            ,"TRB","Transp Manifesto"               ,,(20))
    TRCell():New(oSection1,"Z1_DTMA"	        ,"TRB","Data Manifesto"                 ,,(12))
    TRCell():New(oSection1,"UC_X_ARMAZ"	        ,"TRB","Armazem"                        ,,(20))
    TRCell():New(oSection1,"UC_X_REENT"	        ,"TRB","Reentrega"                      ,,(20)) 
    TRCell():New(oSection1,"UC_X_DIA"	        ,"TRB","Diaria"                         ,,(20))
    TRCell():New(oSection1,"UC_X_PERN"	        ,"TRB","Pernoite"                       ,,(20))
    TRCell():New(oSection1,"UC_X_CCUST"	        ,"TRB","Reentrega sem Custo"            ,,(20)) 
    TRCell():New(oSection1,"UC_X_SDEVL"	        ,"TRB","Solic. Dev."                    ,,(20))
	TRCell():New(oSection1,"UCXFINAN"           ,"TRB","Financeiro"                     ,,(20))
	TRCell():New(oSection1,"CDFINAL"	        ,"TRB","Codigo de Finalizacao"          ,,(06))
    TRCell():New(oSection1,"DSFINAL"	        ,"TRB","Desc de Finalizacao"            ,,(06))
    TRCell():New(oSection1,"UD_OBS"	            ,"TRB","Observacao"                     ,,(12))
    TRCell():New(oSection1,"NFD"                ,"TRB","NF Devol"                       ,,(10))
	TRCell():New(oSection1,"UCXDEVOL"           ,"TRB","Devol"                          ,,(20))
	TRCell():New(oSection1,"VLRTOT"             ,"TRB","Vlr Nota Origem"                ,,(12))
    TRCell():New(oSection1,"VLRTOTA"            ,"TRB","R$"                             ,,(12))
    TRCell():New(oSection1,"VLRTXML"			,"TRB","Vlr NFD XML"     				,,(12))
	TRCell():New(oSection1,"UC_XENCFIN"	        ,"TRB","Fin. Financeiro"                ,,(06))
	
Return oReport

//Gera o Relatorio da Devoluçao
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)
#IFDEF TOP
        oSection1:BeginQuery()
BeginSQL alias 'TRB'

SELECT 
        CASE 
			WHEN UD_FILIAL='0101' THEN 'CIMEX'
	        WHEN UD_FILIAL='0201' THEN 'CROZE'
	        WHEN UD_FILIAL='0301' THEN 'KOPEK'
	        WHEN UD_FILIAL='0401' THEN 'MACO'
	        WHEN UD_FILIAL='0501' THEN 'QUBIT'
	        WHEN UD_FILIAL='0601' THEN 'ROJA'
	        WHEN UD_FILIAL='0701' THEN 'VIXEN'
	        WHEN UD_FILIAL='0801' THEN 'MAIZE'
	        WHEN UD_FILIAL IN('0902','0901') THEN 'DEVINTEX'
            WHEN UD_FILIAL='1101' THEN 'BIZEZ'
	        WHEN UD_FILIAL='1201' THEN 'ZAKAT'
	        WHEN UD_FILIAL='1301' THEN 'HEXIL'
            WHEN UD_FILIAL='1401' THEN 'TROLL'
			ELSE    UD_FILIAL END NOMEMPRESA,
		UC_X_ARMAZ,
		CASE UC_X_FINAN
		WHEN '1' THEN 'Gerar Financeiro - Pagamento de Boleto'
		WHEN '2' THEN 'Bonificação SVC'
		WHEN '3' THEN 'Bonificação Troca'
		WHEN '4' THEN 'Gerar Financeiro'
		ELSE UC_X_FINAN END AS UCXFINAN,				
		UC_X_CCUST,
		UD_DATA,
		UD_FILIAL AS NUMFILIAL,
    	UD_ASSUNTO, 
		UC_DATA, 
		A1_COD AS CLIENTE, 
		A1_LOJA AS LOJA,
		A1_NOME AS NOME_CLI, 
    	CASE WHEN A1_X_PRIOR IN('01','02') THEN 'VIP' ELSE 'DEMAIS' END TIPODECLI,
		A1_EST AS ESTADO, 
        A1_TPRESS AS TIPO_RESSARC,
		UD_XNRMAN AS NR_MANIF,
		UD_X_NOMTR  AS TRANSPO,
		UC_X_NFD AS NOTA_DEV, 
		UD_XDTNFD, 
		UC_X_NFO AS NF_ORIGINAL, 
		UD_NNF,
		UD_XDTNFO, 
	    CASE WHEN F2_DUPL=' ' THEN 'BONIFICAÇÃO' ELSE 'VENDA' END TP_NFO,
	    UD_CODIGO AS NUM_OCOR, 
        UC_XPAI,
		UD_OCORREN AS COD_OCOR, 
		U9_DESC AS MOT_OCOR, 
		UD_PRODUTO AS PRODUTO,

    	UC_DTENCER AS DTFINAL,
	    UC_CODENCE AS CDFINAL,
	    UC_CODCANC AS CDCANCE,
	    UN_DESC AS DSFINAL,
	    UC_X_NFD AS NFD,
		UC_XNFDVL2 AS VLRTXML,

        CASE UC_X_DEVOL
		    WHEN '1' THEN 'Parcial'
		    WHEN '2' THEN 'Total'
		    WHEN '3' THEN 'Retorno'
		ELSE UC_X_DEVOL END AS UCXDEVOL,

		B1_DESC AS DESC_PRD, 
		UD_QTDAJU AS QTDAJU, 
		UD_VLRTOTA AS VLRTOTA, 
		UD_QTD AS QUANT, 
		UD_VLRUNT AS UNI_E, 
		(UD_QTD*UD_VLRUNT) AS VLRTOT, 
		UC_OPERADO AS COD_OPE, 
		U7_NOME AS NOME_OPE, 
	    CASE
			WHEN UC_X_STMER='1' THEN  'COLETA TRANSP (NO ATO)'
    	    WHEN UC_X_STMER='2' THEN  'COLETA TRANSP (PÓS ENTREGA)'
   	     	WHEN UC_X_STMER='3' THEN  'COLETA REP'
   	     	WHEN UC_X_STMER='4' THEN  'DESCARTE REP'
        	WHEN UC_X_STMER='5' THEN  'DESCARTE CLIENTE'
        	WHEN UC_X_STMER='6' THEN 'DÉBITO TRANSP'
        	WHEN UC_X_STMER='7' THEN 'FALTA'
        	ELSE ' ' END SITMER_,      
		D1_LOCAL AS ARMAZEM, 
    	CASE
			WHEN D1_LOCAL = '01' THEN  'ARMAZEM 01'
        	WHEN D1_LOCAL = '02' THEN  'ARMAZEM 02'
        	WHEN D1_LOCAL = '03' THEN  'ARMAZEM 03'
        	WHEN D1_LOCAL = 'AN' THEN  'ARMAZEM AN'
        	WHEN D1_LOCAL = '90' THEN  'ARMAZEM 90'
        	ELSE ' ' END AMZOBS, 
    	CASE WHEN D1_LOCAL NOT IN('03','AN','90') THEN  (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_BOM,
    	CASE D1_LOCAL WHEN '03' THEN (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_RUIM,
    	CASE D1_LOCAL WHEN '90' THEN (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_QUAREN,
    	CASE D1_LOCAL WHEN 'AN' THEN  (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_FALTA,
		D1_CHASSI AS MALMO, 
		D1_MOVEST, 
		0 AS DTETR, 
		'' AS NFTR, 
		0 AS DTDTR ,
		'' AS VLRNDTR, 
		'' VLRPGTR, 
		0 AS DTPGTR,
		A1_MUN,
		
		(SELECT TOP 1 SX5RAS.X5_DESCRI FROM SX5020 SX5RAS WHERE SX5RAS.X5_TABELA = 'Z2' AND SX5RAS.X5_CHAVE = A1_SATIV2 ) AS CANAL_CLIENTE,
    	CASE 	WHEN A1_X_PRIOR IN('0','1') THEN 'VIP' ELSE 'DEMAIS' END VIP,
    	CASE 	WHEN UC_CODCANC =  '' AND UC_STATUS = '2' THEN 'PENDENTE' 
        		WHEN UC_CODCANC =  '' AND UC_STATUS = '3' THEN 'ENCERRADO'
        		WHEN UC_CODCANC =  '' AND UC_STATUS = '1' THEN 'PENDENTE' 
        		WHEN UC_CODCANC <> '' THEN 'CANCELADO'
         		ELSE ' ' END UCSTATUS,
		UD_XSOLUCA AS XACAO,
		UC_X_DTEVE, 
		UN_DESC,
		UC_X_ACAO UNDESC, // kelsen 06/10
		UQ_DESC,
		UC_X_REENT,
		UC_X_DIA,
		UC_X_PERN,
		UC_X_DEVOL,
		UC_X_FINAN,
		UC_X_SDEVL,
		UD_OBS,
		UC_XENCFIN,
		UC_CODENCE,
		SA3.A3_NREDUZ,
		SA3.A3_EMAIL,
//		SA3.A3_TEL,
        (SA3.A3_DDDTEL + SA3.A3_TEL) AS GTEL,
		SA3.A3_GEREN,
		SA3G.A3_NREDUZ AS GERENTE, 
		Z1_DTMA, 
		X5_DESCRI AS AREA_F,
		UD_X_TES,
		SF4.F4_TEXTO

FROM SUD020
	LEFT  JOIN SUC020 SUC ON UD_FILIAL =UC_FILIAL AND UD_CODIGO = UC_CODIGO
	LEFT  JOIN SUN020 ON LEFT(UN_FILIAL,2) = LEFT(UD_FILIAL ,2) AND UN_ENCERR = UC_CODENCE 
	LEFT  JOIN SD1020 ON UD_FILIAL =D1_FILIAL AND UD_PRODUTO= D1_COD AND D1_DOC = UC_X_NFD AND (D1_FORNECE+D1_LOJA) = UC_CHAVE
	LEFT  JOIN SD2020 ON D1_FILIAL =D2_FILIAL AND D1_COD=D2_COD AND D1_NFORI=D2_DOC AND SD2020.D_E_L_E_T_=' ' 
	LEFT  JOIN SC5020 ON D2_FILIAL =C5_FILIAL AND D2_PEDIDO=C5_NUM
	LEFT  JOIN SZ1020 ON Z1_FILIAL =C5_FILIAL AND Z1_NRMA=C5_X_MANIF
	LEFT  JOIN SA4020 ON A4_COD=Z1_TRANSP
	LEFT  JOIN SF2020 ON D2_FILIAL =F2_FILIAL AND D2_DOC=F2_DOC
	LEFT  JOIN SB1020 ON UD_PRODUTO = B1_COD
	LEFT  JOIN SU7020 ON U7_COD    = UC_OPERADO
	LEFT  JOIN SU9020 ON U9_FILIAL = '' AND UD_OCORREN = U9_CODIGO  AND UD_ASSUNTO = U9_ASSUNTO
	LEFT  JOIN SA1020 ON A1_COD+A1_LOJA=UC_CHAVE
	LEFT  JOIN SF1020 ON F1_FILIAL = UD_FILIAL AND F1_DOC = UC_X_NFD AND (F1_FORNECE+F1_LOJA) = UC_CHAVE 
	LEFT  JOIN SUQ120 SUQ ON SUQ.D_E_L_E_T_ = '' AND SUQ.UQ_SOLUCAO = UD_XSOLUCA AND SUQ.UQ_DESC <> ''
//  DESCRICAO DA ACAO LEFT ACIMA
    INNER JOIN SA3020 SA3  ON SA3.A3_COD = A1_VEND  AND SA3.D_E_L_E_T_ = '' 
    LEFT JOIN SA3020 SA3G ON SA3G.A3_COD = SA3.A3_GEREN AND SA3G.D_E_L_E_T_ = '' 
	LEFT JOIN SX5020 SX5    ON SX5.D_E_L_E_T_ = '' AND SX5.X5_FILIAL = UD_FILIAL AND SX5.X5_CHAVE = UD_ASSUNTO AND SX5.X5_TABELA = 'T1'
	LEFT JOIN SF4020 SF4 ON SF4.F4_FILIAL = UD_FILIAL AND SF4.F4_CODIGO = UD_X_TES AND SF4.D_E_L_E_T_ = ''

WHERE 
 	UC_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND UC_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND SUC.UC_OPERADO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND (	
        (%Exp:MV_PAR07% = '1' AND  UC_CODCANC = '' AND UC_STATUS IN ('1','2')
	OR 	(%Exp:MV_PAR07% = '2' AND  UC_CODCANC = '' AND UC_STATUS = '3') 
	OR 	(%Exp:MV_PAR07% = '3' AND  UC_CODCANC <> '' ) 
	OR 	(%Exp:MV_PAR07% = '4' ) ) 
    )
ORDER BY NOMEMPRESA, UC_DATA, UD_CODIGO, UD_ITEM

ENDSQL
	oSection1:EndQuery()
#ENDIF
//AND UC_STATUS BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%

oSection1:Print()
return

// MOTIVO DA OCORRENCIA REPETINDO
// DESCRICAO DA OCORRENCIA REPETINDO
// AREA OC REPETINDO
// DATA ACAO REPETINDO
// DESCRICAO DA ACAO EM BRANCO
// AREA ENCAMINHAMENTO REPETINDO
