//****************************************************
//Programa - Mod.Faturamento - Relatorio Devolução
//Solicitado - Luana / Marcelo Winter
//Autor - Andre Salgado / Introde - 21/08/2021
//****************************************************
#include "Protheus.ch"

User function RFATR013()

Local oReport
Private atend:= 'SIM'
Private oSection1	:= Nil
Private cPerg 		:= "RFATR013" //PADR("RFATR013",10,"X")
Private cTitulo		:= "Relacao de Devoluções"

Pergunte(cPerg) 
oReport := ReportDef()
oReport:PrintDialog()

Return


Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 

oReport := TReport():New(cPerg,cTitulo+' - >>>>> '+IIF(ATEND='SIM','DEVOLUCOES','ATENDIMENTOS'),cPerg,{|oReport|PrintReport(oReport, aOrdem)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7


oSection1 := TRSection():New(oReport,"RELATORIO",{"SB1","SD1","SD2","SUD","SU9","SF2","SA4","SA1"},aOrdem)

    TRCell():New(oSection1,"EMPRESA"	  ,"TRB",                   ,,(10))
    TRCell():New(oSection1,"D1_DTDIGIT"	,"TRB","Data Dig."        ,,(10))
    TRCell():New(oSection1,"CODCLI"	   	,"TRB","Codigo+loja"      ,,(06))
    TRCell():New(oSection1,"A1_NOME"  	,"TRB","Cliente"          ,,(40))
    TRCell():New(oSection1,"TipCli_"	 	,"TRB","Tipo Cliente"     ,,(06))
    TRCell():New(oSection1,"A1_EST"	    ,"TRB","UF"               ,,(02))
    TRCell():New(oSection1,"Z1_NRMA" 	  ,"TRB","Nr Manif"         ,,(02))
    TRCell():New(oSection1,"A4_NREDUZ"	,"TRB","Transportadora"   ,,(30))
    TRCell():New(oSection1,"NFD"	      ,"TRB","NF Devolução"     ,,(09))
    TRCell():New(oSection1,"D1_EMISSAO" ,"TRB","Data NF Devolucao",,(10))
    TRCell():New(oSection1,"NFO"	      ,"TRB","NF Original"      ,,(09))
    TRCell():New(oSection1,"D2_EMISSAO" ,"TRB","Data NF Original" ,,(10))
    TRCell():New(oSection1,"TP_NFO"	    ,"TRB","Tp NFO"           ,,(10))
    TRCell():New(oSection1,"UD_CODIGO"	,"TRB","NUM OCORR"        ,,(06))
    TRCell():New(oSection1,"COD_OCOR"  ,"TRB","COD OCORR"        ,,(06))
    TRCell():New(oSection1,"DESC_OCOR"  	,"TRB","MOTIVO OCORR"     ,,(30))
    TRCell():New(oSection1,"D2_COD"	    ,"TRB","COD. PROD."       ,,(10))
    TRCell():New(oSection1,"B1_DESC"	  ,"TRB","DESCRIÇÃO"        ,,(30))
    TRCell():New(oSection1,"D1_QUANT"	  ,"TRB",                   ,,(12))
    TRCell():New(oSection1,"D2_PRCVEN"	,"TRB","VLR UNIT NFO"     ,,(12))
    TRCell():New(oSection1,"VLRDEV"	    ,"TRB","VLR UNIT ENTRADA" ,,(12))
    TRCell():New(oSection1,"UC_OPERADO"	,"TRB","COD OPER."        ,,(06))
    TRCell():New(oSection1,"U7_NREDUZ"	,"TRB","NOME OPERA"   ,,(25))
    TRCell():New(oSection1,"SITMER_"	,"TRB","STATUS MERC"  ,,(30))
    TRCell():New(oSection1,"D1_LOCAL"	,"TRB",               ,,(02))
    TRCell():New(oSection1,"STATUS_"	,"TRB","Obs."         ,,(10))
    TRCell():New(oSection1,"TOT_BOM"	,"TRB","Total Bom"    ,,(12))
    TRCell():New(oSection1,"TOT_RUIM"	,"TRB","Total Ruim"   ,,(12))
    TRCell():New(oSection1,"TOT_QUAREN"	,"TRB","Total QUAREN" ,,(12))
    TRCell():New(oSection1,"TOT_FALTA"	,"TRB","Total Falta"  ,,(12))
    TRCell():New(oSection1,"MOVEST"	,"TRB","Movim Almox"  ,,(20))
 // rogerio - incluir os novos campos que a rosangela imagina da SUD  
    TRCell():New(oSection1,"DMOVEST"	,"TRB","dT Movim Almox"  ,,(20))
    TRCell():New(oSection1,"DCENVTR,"	,"TRB","Data envio transportadora"  ,,(20))
//    TRCell():New(oSection1,"DCRECTR,"	,"TRB","Doc Reco TR"  ,,(20))
    TRCell():New(oSection1,"NFFATTR,"	,"TRB","Nº da nota de débito"  ,,(20))
    TRCell():New(oSection1,"DTFATTR,"	,"TRB","Data de faturamento Nota de débito"  ,,(20))
    TRCell():New(oSection1,"VLRFTTR,"	,"TRB","Valor   Nota de Débito"  ,,(20))
    TRCell():New(oSection1,"VLRPGTR,"	,"TRB","Valor Pago  transportadora  Nota de débito"  ,,(20))
    TRCell():New(oSection1,"DTPGTR"	,"TRB","Data do pagamento da nota de débito"   ,,(20)) 

Return oReport

//Gera o Relatorio da Devoluçao
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)

#IFDEF TOP
        oSection1:BeginQuery()
IF ATEND = 'SIM'
        BeginSQL alias 'TRB'
SELECT DISTINCT B.EMPRESA, B.D1_DTDIGIT, B.CODCLI, B.A1_NOME, B.TIPCLI_, B.A1_EST, PV.Z1_NRMA, B.Z1_TRANSP, B.A4_NREDUZ,
B.NFO, B.D2_EMISSAO, B.NFD, B.D1_EMISSAO, B.D1_NFORI, B.TP_NFO, B.UD_CODIGO, B.COD_OCOR, B.DESC_OCOR, B.D2_COD, B.B1_DESC,
B.D1_QUANT, B.D2_PRCVEN, B.VLRDEV, B.UC_OPERADO, B.U7_NREDUZ, B.UC_X_STMER, SITMER_, B.D1_LOCAL, B.STATUS_, B.TOT_BOM, B.TOT_RUIM, B.TOT_FALTA,B.TOT_QUAREN, B.C5_NUM, B.MOVEST 
, B.DCENVTR,B.DCRECTR,B.NFFATTR,B.DTFATTR,B.VLRFTTR,B.VLRPGTR,B.DTPGTR 

FROM(
SELECT DISTINCT
CASE 
	WHEN D1_FILIAL='0101' THEN 'CIMEX'
	WHEN D1_FILIAL='0201' THEN 'CROZE'
	WHEN D1_FILIAL='0301' THEN 'KOPEK'
	WHEN D1_FILIAL='0401' THEN 'MACO'
	WHEN D1_FILIAL='0501' THEN 'QUBIT'
	WHEN D1_FILIAL='0601' THEN 'ROJA'
	WHEN D1_FILIAL='0701' THEN 'VIXEN'
	WHEN D1_FILIAL='0801' THEN 'MAIZE'
	WHEN D1_FILIAL IN('0902','0901') THEN 'DEVINTEX'
  WHEN D1_FILIAL='1101' THEN 'BIZEZ'
	WHEN D1_FILIAL='1201' THEN 'ZAKAT'
	WHEN D1_FILIAL='1301' THEN 'HEXIL'
	ELSE D1_FILIAL END

       EMPRESA, D1.D1_DTDIGIT, D1.D1_FORNECE+D1_LOJA CODCLI, A1_NOME, D1.D1_CHASSI MOVEST, D1.D1_MOVEST DMOVEST, UD_DCENVTR DCENVTR, UD_DCRECTR DCRECTR, UD_NFFATTR NFFATTR, UD_DTFATTR DTFATTR, UD_VLRFTTR VLRFTTR, UD_VLRPGTR VLRPGTR, UD_DTPGTR DTPGTR,   // rogerio - incluir os novos campos que a rosangela imagina da SUD

   CASE WHEN A1.A1_X_PRIOR IN('01','02') THEN 'VIP' ELSE 'DEMAIS' END TIPCLI_,
           A1_EST, Z1.Z1_NRMA, Z1.Z1_TRANSP, A4_NREDUZ, D2.D2_DOC NFO,D2.D2_EMISSAO, D1_DOC NFD, D1_EMISSAO, D1.D1_NFORI, 
   CASE WHEN F2_DUPL=' ' THEN 'BONIFICAÇÃO' ELSE 'VENDA' END TP_NFO,
           UD_CODIGO, U9_CODIGO COD_OCOR, U9_DESC DESC_OCOR,
           D2.D2_COD, B1.B1_DESC, D1.D1_QUANT, D2.D2_PRCVEN,
           ((D1.D1_TOTAL-D1.D1_VALDESC)/D1.D1_QUANT) VLRDEV,UC.UC_OPERADO, U7.U7_NREDUZ,
           UC.UC_X_STMER,
   CASE
        WHEN UC_X_STMER='1' THEN  'COLETA TRANSP (NO ATO)'
        WHEN UC_X_STMER='2' THEN  'COLETA TRANSP (PÓS ENTREGA)'
        WHEN UC_X_STMER='3' THEN  'COLETA REP'
        WHEN UC_X_STMER='4' THEN  'DESCARTE REP'
        WHEN UC_X_STMER='5' THEN  'DESCARTE CLIENTE'
        WHEN UC_X_STMER='6' THEN 'DÉBITO TRANSP'
        WHEN UC_X_STMER='7' THEN 'FALTA'
        ELSE ' ' END SITMER_,      
           D1_LOCAL,
   CASE D1_LOCAL WHEN '03' THEN 'RUIM' WHEN 'AN' THEN 'FALTA' WHEN '90' THEN 'QUAREN' ELSE 'BOM' END STATUS_,
   CASE WHEN D1_LOCAL NOT IN('03','AN','90') THEN  (D1_QUANT*D2_PRCVEN) ELSE 0 END TOT_BOM,
   CASE D1_LOCAL WHEN '03' THEN (D1_QUANT*D2_PRCVEN) ELSE 0 END TOT_RUIM,
   CASE D1_LOCAL WHEN '90' THEN (D1_QUANT*D2_PRCVEN) ELSE 0 END TOT_QUAREN,
   CASE D1_LOCAL WHEN 'AN' THEN  (D1_QUANT*D2_PRCVEN) ELSE 0 END TOT_FALTA,
           C5.C5_NUM, C5.C5_X_MANIF
FROM SD1020 D1
INNER JOIN SA1020 A1 (NOLOCK) ON D1.D1_FORNECE=A1.A1_COD AND D1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 
INNER JOIN SB1020 B1 (NOLOCK) ON D1_COD=B1_COD AND B1.D_E_L_E_T_=' '
INNER JOIN SD2020 D2 (NOLOCK) ON D1.D1_FILIAL=D2.D2_FILIAL AND D1_COD=D2_COD AND D1_NFORI=D2_DOC AND D2.D_E_L_E_T_=' ' 
INNER JOIN SC5020 C5 (NOLOCK) ON D2.D2_FILIAL=C5.C5_FILIAL AND D2_PEDIDO=C5.C5_NUM
INNER JOIN SZ1020 Z1 (NOLOCK) ON Z1.Z1_FILIAL=C5_FILIAL AND Z1.Z1_NRMA=C5.C5_X_MANIF
INNER JOIN SA4020 A4 (NOLOCK) ON A4.A4_COD=Z1.Z1_TRANSP
INNER JOIN SF2020 F2 (NOLOCK) ON D2.D2_FILIAL=F2.F2_FILIAL AND D2.D2_DOC=F2.F2_DOC
LEFT JOIN SUD020 UD (NOLOCK) ON D1.D1_FILIAL=UD.UD_FILIAL AND D1_COD=UD_PRODUTO AND D1_NFORI=REPLICATE('0', 9 - LEN(UD.UD_NNF))+UD.UD_NNF AND UD.D_E_L_E_T_=' '
        AND UD.UD_CODIGO<>''
LEFT JOIN SUC020 UC (NOLOCK) ON UD.UD_FILIAL=UC.UC_FILIAL AND UD.UD_CODIGO=UC.UC_CODIGO AND UC.D_E_L_E_T_=' '
        AND UC.UC_X_STMER<>' '
LEFT JOIN SU7020 U7 (NOLOCK) ON UC.UC_OPERADO=U7.U7_COD AND U7.D_E_L_E_T_=' '
LEFT JOIN SU9020 U9 (NOLOCK) ON UD.UD_ASSUNTO=U9.U9_ASSUNTO AND UD.UD_OCORREN=U9.U9_CODIGO AND U9.D_E_L_E_T_=' '
WHERE
     D1.D_E_L_E_T_='  '
// POR ENTRADA
AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
//     AND D1_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
     AND D1_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
//     AND D1_COD NOT IN ('NF COMPL ICMS')
     AND D1_TIPO = 'D'
     //and D1_DOC='000255377'
)B INNER JOIN SZ1020 PV ON B.C5_X_MANIF=PV.Z1_NRMA

ORDER BY EMPRESA, B.D1_DTDIGIT, B.CODCLI

//%Exp:MV_PAR01% AND %Exp:MV_PAR02%
	EndSQL
ELSE

ENDIF

	oSection1:EndQuery()
	
#ENDIF
oSection1:Print()
return
