//****************************************************
//Programa - Mod.Faturamento - Relatorio Devolução
//Solicitado - Luana / Marcelo Winter
//Autor - Andre Salgado / Introde - 21/08/2021
//****************************************************
#include "Protheus.ch"

User function RFATR113()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "RFATR113" //PADR("RFATR013",10,"X")
Private cTitulo		:= "Relacao de Ocorrencias Transporte"
Private _cAlias         := GetNextAlias()

Pergunte(cPerg) 
oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 

oReport := TReport():New(cPerg,cTitulo+' - '+'ATENDIMENTOS',cPerg,{|oReport|PrintReport(oReport, aOrdem, _cAlias)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7

oSection1 := TRSection():New(oReport,"RELATORIO",{"SB1","SD1","SD2","SUD","SU9","SF2","SA4","SA1"},aOrdem)

    TRCell():New(oSection1,"UD_ASSUNTO"	,"TRB","ASSUNTO",,(10))
    TRCell():New(oSection1,"NOMEMPRESA"	,"TRB","Nome Distribuidora",,(10))
    TRCell():New(oSection1,"UC_DATA"	,"TRB","Data Atendimento"  ,,(06))
    TRCell():New(oSection1,"CLIENTE"  	,"TRB","Cod Cliente"       ,,(40))
    TRCell():New(oSection1,"LOJA"	,"TRB","Loja Cliente"     ,,(06))
    TRCell():New(oSection1,"NOME_CLI"	,"TRB","Nome Cliente"     ,,(02))
    TRCell():New(oSection1,"TIPODECLI"	,"TRB","Tipo de Cliente"  ,,(02))
    TRCell():New(oSection1,"ESTADO"	,"TRB","UF"               ,,(02))
    TRCell():New(oSection1,"NR_MANIF" 	,"TRB","Nr Manif"         ,,(02))
    TRCell():New(oSection1,"TRANSPO"	,"TRB","Transportadora"   ,,(30))
    TRCell():New(oSection1,"NOTA_DEV"	,"TRB","NF Devolução"     ,,(09))
    TRCell():New(oSection1,"UD_XDTNFD"  ,"TRB","Data NF Devolucao",,(10))
    TRCell():New(oSection1,"NF_ORIGINAL","TRB","NF Original"      ,,(09))
    TRCell():New(oSection1,"UD_XDTNFO"  ,"TRB","Data NF Original" ,,(10))
    TRCell():New(oSection1,"TP_NFO"	,"TRB","Tp NFO"           ,,(10))
    TRCell():New(oSection1,"NUM_OCOR"	,"TRB","NUM OCORR"        ,,(06))
    TRCell():New(oSection1,"COD_OCOR"   ,"TRB","COD OCORR"        ,,(06))
    TRCell():New(oSection1,"MOT_OCOR"  	,"TRB","MOTIVO OCORR"     ,,(30))
    TRCell():New(oSection1,"PRODUTO"	,"TRB","COD. PROD."       ,,(10))
    TRCell():New(oSection1,"DESC_PRD"	,"TRB","DESCRIÇÃO"        ,,(30))
    TRCell():New(oSection1,"QUANT"      ,"TRB","QUANT"            ,,(12))
    TRCell():New(oSection1,"UNI_E"	,"TRB","VLR UNIT NFO"     ,,(12))
    TRCell():New(oSection1,"VLRTOT"	,"TRB","VLR TOTAL"     ,,(12))
    TRCell():New(oSection1,"QTDAJU"     ,"TRB","Qtd Ajuste"    ,,(12))
    TRCell():New(oSection1,"VLRTOTA"	,"TRB","Vlr Total DV"     ,,(12))
    TRCell():New(oSection1,"COD_OPE"	,"TRB","COD OPER."        ,,(06))
    TRCell():New(oSection1,"NOME_OPE"	,"TRB","NOME OPERA"   ,,(25))
    TRCell():New(oSection1,"SITMER_"	,"TRB","STATUS MERC"  ,,(30))
    TRCell():New(oSection1,"ARMAZEM"	,"TRB","Local Armazem",,(02))
    TRCell():New(oSection1,"AMZOBS"	,"TRB","oBS Armazem",,(02))
    TRCell():New(oSection1,"TOT_BOM"	,"TRB","Total Bom"    ,,(12))
    TRCell():New(oSection1,"TOT_RUIM"	,"TRB","Total Ruim"   ,,(12))
    TRCell():New(oSection1,"TOT_QUAREN"	,"TRB","Total QUAREN" ,,(12))
    TRCell():New(oSection1,"TOT_FALTA"	,"TRB","Total Falta"  ,,(12))
    TRCell():New(oSection1,"D1_MOVEST"	,"TRB","dT Movim Almox"                 ,,(20))
    TRCell():New(oSection1,"X5_NUM"	,"TRB","Pedido da nota de débito"           ,,(20))
    TRCell():New(oSection1,"E1_NUM"	,"TRB","Nº da nota de débito"           ,,(20))
    TRCell():New(oSection1,"E1_EMISSAO"	,"TRB","Data de faturamento Nota de débito"  ,,(20))
    TRCell():New(oSection1,"E1_VALOR"	,"TRB","Valor da nota de débito"  ,,(12))
    TRCell():New(oSection1,"E4_DESCRI"	,"TRB","Condição de Pagamento"  ,,(12))
    TRCell():New(oSection1,"E1_VENCREA"	,"TRB","Vencimento"                 ,,(20))
    TRCell():New(oSection1,"E1_VALLIQ"	,"TRB","Valor Pago transportadora nota de débito"  ,,(20))
    TRCell():New(oSection1,"E1_BAIXA"	,"TRB","Data do pagamento da nota de débito"   ,,(20)) 

Return oReport

//Gera o Relatorio da Devoluçao
Static Function PrintReport(oReport, aOrdem, _cAlias)
Local oSection1 := oReport:Section(1)
Local _cQuery := ""

IF Select( _cAlias ) > 0
	_cAlias->( dbCloseArea() )
Endif

_cQuery := " SELECT UD_FILIAL AS NUMFILIAL, "+CRLF
_cQuery += " CASE "+CRLF
_cQuery += "	WHEN UD_FILIAL='0101' THEN 'CIMEX'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0201' THEN 'CROZE'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0301' THEN 'KOPEK'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0401' THEN 'MACO'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0501' THEN 'QUBIT'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0601' THEN 'ROJA'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0701' THEN 'VIXEN'"+CRLF
_cQuery += "	WHEN UD_FILIAL='0801' THEN 'MAIZE'"+CRLF
_cQuery += "	WHEN UD_FILIAL IN('0902','0901') THEN 'DEVINTEX'"+CRLF
_cQuery += "    WHEN UD_FILIAL='1101' THEN 'BIZEZ'"+CRLF
_cQuery += "	WHEN UD_FILIAL='1201' THEN 'ZAKAT'"+CRLF
_cQuery += "	WHEN UD_FILIAL='1301' THEN 'HEXIL'"+CRLF
_cQuery += "	ELSE UD_FILIAL END NOMEMPRESA,"+CRLF
_cQuery += "    UD_ASSUNTO, "+CRLF
_cQuery += "	UC_DATA, "+CRLF
_cQuery += "	A1_COD AS CLIENTE,"+CRLF 
_cQuery += "	A1_LOJA AS LOJA,"+CRLF
_cQuery += "	A1_NOME AS NOME_CLI, "+CRLF
_cQuery += "        CASE WHEN A1_X_PRIOR IN('01','02') THEN 'VIP' ELSE 'DEMAIS' END TIPODECLI,"+CRLF
_cQuery += "	A1_EST AS ESTADO, "+CRLF
_cQuery += "	UD_XNRMAN AS NR_MANIF,"+CRLF
_cQuery += "	UD_X_NOMTR  AS TRANSPO,"+CRLF
_cQuery += "	UC_X_NFD AS NOTA_DEV, "+CRLF
_cQuery += "	UD_XDTNFD, "+CRLF
_cQuery += "	UC_X_NFO AS NF_ORIGINAL, "+CRLF
_cQuery += "	UD_XDTNFO, "+CRLF
_cQuery += "        CASE WHEN F2_DUPL=' ' THEN 'BONIFICAÇÃO' ELSE 'VENDA' END TP_NFO,"+CRLF
_cQuery += "        UD_CODIGO AS NUM_OCOR, "+CRLF
_cQuery += "	UD_OCORREN AS COD_OCOR, "+CRLF
_cQuery += "	U9_DESC AS MOT_OCOR, "+CRLF
_cQuery += "	UD_PRODUTO AS PRODUTO, "+CRLF
_cQuery += "	B1_DESC AS DESC_PRD, "+CRLF
_cQuery += "	UD_QTDAJU AS QTDAJU, "+CRLF
_cQuery += "	UD_VLRTOTA AS VLRTOTA, "+CRLF
_cQuery += "	UD_QTD AS QUANT, "+CRLF
_cQuery += "	UD_VLRUNT AS UNI_E, "+CRLF
_cQuery += "    (UD_QTD*UD_VLRUNT) AS VLRTOT, "+CRLF
_cQuery += "	UC_OPERADO AS COD_OPE, "+CRLF
_cQuery += "	U7_NOME AS NOME_OPE, "+CRLF
_cQuery += "   CASE"+CRLF
_cQuery += "        WHEN UC_X_STMER='1' THEN  'COLETA TRANSP (NO ATO)'"+CRLF
_cQuery += "        WHEN UC_X_STMER='2' THEN  'COLETA TRANSP (PÓS ENTREGA)'"+CRLF
_cQuery += "        WHEN UC_X_STMER='3' THEN  'COLETA REP'"+CRLF
_cQuery += "        WHEN UC_X_STMER='4' THEN  'DESCARTE REP'"+CRLF
_cQuery += "        WHEN UC_X_STMER='5' THEN  'DESCARTE CLIENTE'"+CRLF
_cQuery += "        WHEN UC_X_STMER='6' THEN 'DÉBITO TRANSP'"+CRLF
_cQuery += "        WHEN UC_X_STMER='7' THEN 'FALTA'"+CRLF
_cQuery += "        ELSE ' ' END SITMER_,      "+CRLF
_cQuery += "	D1_LOCAL AS ARMAZEM, "+CRLF
_cQuery += "   CASE "+CRLF
_cQuery += "        WHEN D1_LOCAL = '01' THEN  'ARMAZEM 01'"+CRLF
_cQuery += "        WHEN D1_LOCAL = '02' THEN  'ARMAZEM 02'"+CRLF
_cQuery += "        WHEN D1_LOCAL = '03' THEN  'ARMAZEM 03'"+CRLF
_cQuery += "        WHEN D1_LOCAL = 'AN' THEN  'ARMAZEM AN'"+CRLF
_cQuery += "        WHEN D1_LOCAL = '90' THEN  'ARMAZEM 90'"+CRLF
_cQuery += "        ELSE ' ' END AMZOBS, "+CRLF
_cQuery += "   CASE WHEN D1_LOCAL NOT IN('03','AN','90') THEN  (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_BOM,"+CRLF
_cQuery += "   CASE D1_LOCAL WHEN '03' THEN (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_RUIM,"+CRLF
_cQuery += "   CASE D1_LOCAL WHEN '90' THEN (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_QUAREN,"+CRLF
_cQuery += "   CASE D1_LOCAL WHEN 'AN' THEN  (UD_QTD*UD_VLRUNT) ELSE 0 END TOT_FALTA,"+CRLF
_cQuery += "	D1_CHASSI AS MALMO, "+CRLF
_cQuery += "	D1_MOVEST, "+CRLF
_cQuery += "	X5.C5_NUM 'PVNFD', "+CRLF
_cQuery += "	X5.C5_NOTA 'E1_NUM', "+CRLF
_cQuery += "	CASE WHEN X5.C5_NOTA <>'' THEN "+CRLF
_cQuery += "	(SELECT DISTINCT E1_EMISSAO FROM SE1020 X0 WHERE E1_FILIAL = X5.C5_FILIAL AND E1_NUM = X5.C5_NOTA AND E1_CLIENTE = X5.C5_CLIENTE AND E1_LOJA = X5.C5_LOJACLI AND X0.D_E_L_E_T_ ='') ELSE '' END 'E1_EMISSAO', "+CRLF
_cQuery += "	CASE WHEN X5.C5_NOTA <>'' THEN "+CRLF
_cQuery += "	(SELECT SUM(E1_VALOR) FROM SE1020 X0 WHERE E1_FILIAL = X5.C5_FILIAL AND E1_NUM = X5.C5_NOTA AND E1_CLIENTE = X5.C5_CLIENTE AND E1_LOJA = X5.C5_LOJACLI AND X0.D_E_L_E_T_ ='') ELSE '' END 'E1_VALOR', "+CRLF
_cQuery += "	E4_DESCRI, "+CRLF
_cQuery += "	CASE WHEN X5.C5_NOTA <>'' THEN "+CRLF
_cQuery += "	(SELECT MAX(E1_VENCREA) FROM SE1020 X0 WHERE E1_FILIAL = X5.C5_FILIAL AND E1_NUM = X5.C5_NOTA AND E1_CLIENTE = X5.C5_CLIENTE AND E1_LOJA = X5.C5_LOJACLI AND X0.D_E_L_E_T_ ='') ELSE '' END 'E1_VENCREA', "+CRLF
_cQuery += "	CASE WHEN X5.C5_NOTA <>'' THEN "+CRLF
_cQuery += "	(SELECT SUM(E1_VALLIQ) FROM SE1020 X0 WHERE E1_FILIAL = X5.C5_FILIAL AND E1_NUM = X5.C5_NOTA AND E1_CLIENTE = X5.C5_CLIENTE AND E1_LOJA = X5.C5_LOJACLI AND X0.D_E_L_E_T_ ='') ELSE '' END 'E1_VALLIQ', "+CRLF
_cQuery += "	CASE WHEN X5.C5_NOTA <>'' THEN "+CRLF
_cQuery += "	(SELECT MAX(E1_BAIXA) FROM SE1020 X0 WHERE E1_FILIAL = X5.C5_FILIAL AND E1_NUM = X5.C5_NOTA AND E1_CLIENTE = X5.C5_CLIENTE AND E1_LOJA = X5.C5_LOJACLI AND X0.D_E_L_E_T_ ='') ELSE '' END 'E1_BAIXA' "+CRLF
_cQuery += "     ,SUD020.R_E_C_N_O_ AS 'SUD'"+CRLF
_cQuery += "     ,SUC020.R_E_C_N_O_ AS 'SUC'"+CRLF
_cQuery += "     ,SD1020.R_E_C_N_O_ AS 'SD1'"+CRLF
_cQuery += "     ,SD2020.R_E_C_N_O_ AS 'SD2'"+CRLF
_cQuery += "     ,SC5020.R_E_C_N_O_ AS 'SC5'"+CRLF
_cQuery += "     ,SZ1020.R_E_C_N_O_ AS 'SZ1'"+CRLF
_cQuery += "     ,SA4020.R_E_C_N_O_ AS 'SA4'"+CRLF
_cQuery += "     ,SF2020.R_E_C_N_O_ AS 'SF2'"+CRLF
_cQuery += "     ,SB1020.R_E_C_N_O_ AS 'SB1'"+CRLF
_cQuery += "     ,SU7020.R_E_C_N_O_ AS 'SU7'"+CRLF
_cQuery += "     ,SU9020.R_E_C_N_O_ AS 'SU9'"+CRLF
_cQuery += "     ,SA1020.R_E_C_N_O_ AS 'SA1'"+CRLF
_cQuery += "     ,SF1020.R_E_C_N_O_ AS 'SF1'"+CRLF
_cQuery += " FROM SUD020 "+CRLF
_cQuery += " LEFT  JOIN SUC020 ON UD_FILIAL =UC_FILIAL AND UD_CODIGO = UC_CODIGO"+CRLF
_cQuery += " LEFT  JOIN SD1020 ON UD_FILIAL =D1_FILIAL AND UD_PRODUTO= D1_COD AND D1_DOC = UC_X_NFD AND (D1_FORNECE+D1_LOJA) = UC_CHAVE"+CRLF
_cQuery += " LEFT  JOIN SD2020 ON D1_FILIAL =D2_FILIAL AND D1_COD=D2_COD AND D1_NFORI=D2_DOC AND SD2020.D_E_L_E_T_=' ' "+CRLF
_cQuery += " LEFT  JOIN SC5020 ON D2_FILIAL =C5_FILIAL AND D2_PEDIDO=C5_NUM"+CRLF
_cQuery += " LEFT  JOIN SZ1020 ON Z1_FILIAL =C5_FILIAL AND Z1_NRMA=C5_X_MANIF"+CRLF
_cQuery += " LEFT  JOIN SA4020 ON A4_COD=Z1_TRANSP"+CRLF
_cQuery += " LEFT  JOIN SF2020 ON D2_FILIAL =F2_FILIAL AND D2_DOC=F2_DOC"+CRLF
_cQuery += " LEFT  JOIN SB1020 ON UD_PRODUTO = B1_COD"+CRLF
_cQuery += " LEFT  JOIN SU7020 ON U7_COD    = UC_OPERADO"+CRLF
_cQuery += " LEFT  JOIN SU9020 ON U9_FILIAL = '' AND UD_OCORREN = U9_CODIGO  AND UD_ASSUNTO = U9_ASSUNTO"+CRLF
_cQuery += " LEFT  JOIN SA1020 ON A1_COD+A1_LOJA=UC_CHAVE"+CRLF
_cQuery += " LEFT  JOIN SF1020 ON F1_FILIAL = UD_FILIAL AND F1_DOC = UC_X_NFD AND (F1_FORNECE+F1_LOJA) = UC_CHAVE "+CRLF
_cQuery += " LEFT  JOIN SC5020 X5 ON X5.C5_FILIAL = UC_FILIAL AND X5.C5_XATEND = UC_CODIGO"+CRLF
_cQuery += " LEFT  JOIN SE4020 ON E4_CODIGO = X5.C5_CONDPAG"+CRLF
_cQuery += " WHERE "+CRLF
_cQuery += " UC_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'"+CRLF
_cQuery += "     AND UC_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+CRLF
_cQuery += "     AND UD_ASSUNTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CRLF
_cQuery += "     AND ("+CRLF
_cQuery += "        ('"+MV_PAR07+"' > '' AND UC_X_STMER = '"+MV_PAR07+"' ) OR"+CRLF
_cQuery += "        ('"+MV_PAR07+"' = '')"+CRLF
_cQuery += "         )"+CRLF
_cQuery += "     AND SUD020.D_E_L_E_T_ = ' '"+CRLF
_cQuery += "     AND SUC020.D_E_L_E_T_ = ' '"+CRLF
_cQuery += "     ORDER BY UC_CODIGO, UC_DATA"+CRLF

dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cAlias , .F., .T. )
DbSelectArea(_cAlias)
(_cAlias)->(DBGOTOP())

oSection1:Init()

While (_cAlias)->( ! Eof() ) 

    oSection1:Cell("UD_ASSUNTO"):SetValue((_cAlias)->UD_ASSUNTO)
    oSection1:Cell("NOMEMPRESA"):SetValue((_cAlias)->NOMEMPRESA)
    oSection1:Cell("UC_DATA"):SetValue(STOD((_cAlias)->UC_DATA))
    oSection1:Cell("CLIENTE"):SetValue((_cAlias)->CLIENTE)
    oSection1:Cell("LOJA"):SetValue((_cAlias)->LOJA)
    oSection1:Cell("NOME_CLI"):SetValue((_cAlias)->NOME_CLI)
    oSection1:Cell("TIPODECLI"):SetValue((_cAlias)->TIPODECLI)
    oSection1:Cell("ESTADO"):SetValue((_cAlias)->ESTADO)
    oSection1:Cell("NR_MANIF"):SetValue((_cAlias)->NR_MANIF)
    oSection1:Cell("TRANSPO"):SetValue((_cAlias)->TRANSPO)
    oSection1:Cell("NOTA_DEV"):SetValue((_cAlias)->NOTA_DEV)
    oSection1:Cell("UD_XDTNFD"):SetValue(STOD((_cAlias)->UD_XDTNFD))
    oSection1:Cell("NF_ORIGINAL"):SetValue((_cAlias)->NF_ORIGINAL)
    oSection1:Cell("UD_XDTNFO"):SetValue(STOD((_cAlias)->UD_XDTNFO))
    oSection1:Cell("TP_NFO"):SetValue((_cAlias)->TP_NFO)
    oSection1:Cell("NUM_OCOR"):SetValue((_cAlias)->NUM_OCOR)
    oSection1:Cell("COD_OCOR"):SetValue((_cAlias)->COD_OCOR)
    oSection1:Cell("MOT_OCOR"):SetValue((_cAlias)->MOT_OCOR)
    oSection1:Cell("PRODUTO"):SetValue((_cAlias)->PRODUTO)
    oSection1:Cell("DESC_PRD"):SetValue((_cAlias)->DESC_PRD)
    oSection1:Cell("QUANT"):SetValue((_cAlias)->QUANT)
    oSection1:Cell("UNI_E"):SetValue((_cAlias)->UNI_E)
    oSection1:Cell("VLRTOT"):SetValue((_cAlias)->VLRTOT)
    oSection1:Cell("QTDAJU"):SetValue((_cAlias)->QTDAJU)
    oSection1:Cell("VLRTOTA"):SetValue((_cAlias)->VLRTOTA)
    oSection1:Cell("COD_OPE"):SetValue((_cAlias)->COD_OPE)
    oSection1:Cell("NOME_OPE"):SetValue((_cAlias)->NOME_OPE)
    oSection1:Cell("SITMER_"):SetValue((_cAlias)->SITMER_)
    oSection1:Cell("ARMAZEM"):SetValue((_cAlias)->ARMAZEM)
    oSection1:Cell("AMZOBS"):SetValue((_cAlias)->AMZOBS)
    oSection1:Cell("TOT_BOM"):SetValue((_cAlias)->TOT_BOM)
    oSection1:Cell("TOT_RUIM"):SetValue((_cAlias)->TOT_RUIM)
    oSection1:Cell("TOT_QUAREN"):SetValue((_cAlias)->TOT_QUAREN)
    oSection1:Cell("TOT_FALTA"):SetValue((_cAlias)->TOT_FALTA)
    oSection1:Cell("D1_MOVEST"):SetValue((_cAlias)->D1_MOVEST)
    oSection1:Cell("X5_NUM"):SetValue((_cAlias)->PVNFD)
    oSection1:Cell("E1_NUM"):SetValue((_cAlias)->E1_NUM)
    oSection1:Cell("E1_EMISSAO"):SetValue(STOD((_cAlias)->E1_EMISSAO))
    oSection1:Cell("E1_VALOR"):SetValue((_cAlias)->E1_VALOR)
    oSection1:Cell("E4_DESCRI"):SetValue((_cAlias)->E4_DESCRI)
    oSection1:Cell("E1_VENCREA"):SetValue(STOD((_cAlias)->E1_VENCREA))
    oSection1:Cell("E1_VALLIQ"):SetValue((_cAlias)->E1_VALLIQ)
    oSection1:Cell("E1_BAIXA"):SetValue(STOD((_cAlias)->E1_BAIXA)) 

    oSection1:Printline()
    (_cAlias)->( dbskip() )

Enddo

oSection1:SetAutoSize(.F.)
oReport:Section(1):Finish()

return
