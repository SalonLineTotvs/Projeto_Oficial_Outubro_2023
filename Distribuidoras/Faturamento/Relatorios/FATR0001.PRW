#INCLUDE "PROTHEUS.CH"
#INCLUDE 'rwmake.ch'
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"

#INCLUDE "FWPrintSetup.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATR0001X ³ Autor ³ André Valmir 	³ Data ³16/08/2018    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Ordem de Separação								  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
*------------------------------*
User Function FATR0001(cNumOnda)
*------------------------------*

If Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("02","1401")
Endif

Private oArial08  	:=	TFont():New("Arial",,08,,.F.,,,,,.F.,.F.)
Private oArial11D  	:=	TFont():New("Arial",,11,,.F.,,,,,.F.,.F.)
Private oArial11  	:=	TFont():New("Arial",,14,,.F.,,,,,.F.,.F.)
Private oArial15  	:=	TFont():New("Arial",,15,,.F.,,,,,.F.,.F.)
Private oArial15N	:=	TFont():New("Arial",,15,,.T.,,,,,.F.,.F.)
Private oArial18	:=	TFont():New("Arial",,18,,.F.,,,,,.F.,.F.)
Private oArial18N	:=	TFont():New("Arial",,18,,.T.,,,,,.F.,.F.)
Private oArial20N	:=	TFont():New("Arial",,20,,.T.,,,,,.F.,.F.)
Private oArial21N	:=	TFont():New("Arial",,21,,.T.,,,,,.F.,.F.)
Private oArial25N	:=	TFont():New("Arial",,25,,.T.,,,,,.F.,.F.)

Private oPrint  	:=	Nil //tAvPrinter():New("Ordem de Separação")
Private lImpCabec	:= .T.
Private nLinCab		:= 720
Private nLinPrd 	:= 805
Private nContPg		:= 1
Private nValorPV	:= 0

Private lTPImpCX	:= .F.
Private lTPImpGR	:= .F.
Private cTpfrete 	:= ""	// Tipo de Frete
Private nLinRod		:= 0

Private	lImpCX		:= .T.	// Imprimir Peso e Volume Caixa / Granel
Private nContPrd	:= 0	// Contador de produtos 
Private nPesoCX		:= 0
Private nPesoGR		:= 0
Private cNumPV		:= ""
Private cAtuOnda	:= cNumOnda
Private lImpress	:= .F.		// Informa se é Impressão (.T.) / Re-Impressão (.F.)
Private	cPerg		:= "FATR0001"
Private lHabPal		:= SuperGetMv("ES_FATR001",.F.,.T.) // .T. Habilitado 

Private cPathEst    := Alltrim(GetMv("MV_DIREST"))
MontaDir(cPathEst)

If !Empty(cNumOnda)

	cQuery := " SELECT *, " 
	cQuery += " CASE PARIMPAR WHEN 'PAR' THEN RIGHT(LEFT(B1_X_LOCAL,3),2) * -1 ELSE RIGHT(LEFT(B1_X_LOCAL,3),2) END ORDEM "
	cQuery += " FROM (  "
	
	//GRANEL
	cQuery += " SELECT B1_X_LOCAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) C5_EMISSAO, "
	cQuery += " C5_TPFRETE, C5_X_ANTEC, C5_VOLUME2, C5_X_TLNCX, C5_X_TLNGR, C5_X_TVLCX, C5_X_TVLGR, C5_TRANSP, A1_X_PRIOR, A1_NREDUZ, A1_EST, C6_TES, F4_TEXTO, A4_NREDUZ,"
	cQuery += " B1_PESO, C6_PRODUTO, 0 'CX', C6_X_VGRIM 'GR', B1_DESC, B1_QE, 'GR' TIPOIMP, C5_X_OBSLO, C5_X_TPFRE, C5_FILIAL,"
	cQuery += " CASE 	WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK'"
	cQuery += " 		WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA'"
	cQuery += " 		WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX'"
	cQuery += " 		WHEN C5_FILIAL='0902' THEN 'DEV-MG' WHEN C5_FILIAL='1001' THEN 'GLAZY' 	WHEN C5_FILIAL='1101' THEN 'BIZEZ' "
	cQuery += " 		WHEN C5_FILIAL='1201' THEN 'ZAKAT'  WHEN C5_FILIAL='1301' THEN 'HEXIL' 	"
	cQuery += " 		ELSE C5_FILIAL END EMPRESA, "
	cQuery += " 	LEFT(B1_X_LOCAL,1) LETRA, "
	cQuery += " 	CASE RIGHT(LEFT(B1_X_LOCAL,3),2)  % 2 WHEN 0  THEN 'PAR' ELSE 'IMPAR' END PARIMPAR, "
	cQuery += "     (C6_X_VGRIM * C6_PRCVEN) V_PEDIDO "
	cQuery += "    ,0 PFECHADO,C6_X_VGRIM  PQUEBRA"

	cQuery += " FROM "+RETSQLNAME("SC5")+" C5 (NOLOCK) "
	cQuery += " INNER JOIN " +RETSQLNAME("SA4")+" A4 (NOLOCK) ON C5_TRANSP = A4_COD AND A4_FILIAL = '"+xFilial("SA4")+"' AND A4.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN " +RETSQLNAME("SC6")+" C6 (NOLOCK) ON C5_FILIAL=C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = '' 	  "
	cQuery += " INNER JOIN " +RETSQLNAME("SB1")+" B1 (NOLOCK) ON C6_PRODUTO = B1_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN " +RETSQLNAME("SA1")+" A1 (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''             "
	cQuery += " INNER JOIN " +RETSQLNAME("SF4")+" F4 (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES = F4_CODIGO AND F4.D_E_L_E_T_ = ''     "

	cQuery += " WHERE C5.D_E_L_E_T_ = ''  "
	cQuery += " AND C5_X_NONDA='"+cAtuOnda+"' "
	cQuery += " AND SUBSTRING(B1_X_LOCAL,2,1) IN (' ','0','1','2','3','4','5','6','7','8','9')"
	cQuery += " AND C6_X_VGRIM > 0 "
	
	//CAIXA
	cQuery += " UNION ALL   "
	cQuery += " SELECT B1_X_LOCAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) C5_EMISSAO, "
	cQuery += " C5_TPFRETE, C5_X_ANTEC, C5_VOLUME2, C5_X_TLNCX, C5_X_TLNGR, C5_X_TVLCX, C5_X_TVLGR, C5_TRANSP, A1_X_PRIOR, A1_NREDUZ, A1_EST, C6_TES, F4_TEXTO, A4_NREDUZ,  "
	cQuery += " B1_PESO, C6_PRODUTO, C6_X_VCXIM 'CX', 0 'GR', B1_DESC, B1_QE, 'CX' TIPOIMP, C5_X_OBSLO, C5_X_TPFRE, C5_FILIAL,"
	cQuery += " CASE 	WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
	cQuery += " 		WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA' "
	cQuery += " 		WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
	cQuery += " 		WHEN C5_FILIAL='0902' THEN 'DEV-MG' WHEN C5_FILIAL='1001' THEN 'GLAZY' 	WHEN C5_FILIAL='1101' THEN 'BIZEZ' "
	cQuery += " 		WHEN C5_FILIAL='1201' THEN 'ZAKAT'  WHEN C5_FILIAL='1301' THEN 'HEXIL' 	"
	cQuery += " 		ELSE C5_FILIAL END EMPRESA, "
	cQuery += " 	LEFT(B1_X_LOCAL,1) LETRA, "
	cQuery += " 	CASE RIGHT(LEFT(B1_X_LOCAL,3),2)  % 2 WHEN 0  THEN 'PAR' ELSE 'IMPAR' END PARIMPAR, "
	cQuery += "    (C6_QTDVEN-C6_X_VGRIM ) * C6_PRCVEN V_PEDIDO, "
	cQuery += "    CASE WHEN B1_XQTDPAL>0 THEN FLOOR((C6_QTDVEN-C6_X_VGRIM )/B1_XQTDPAL) ELSE 0 END PFECHADO,"
	cQuery += "    ((C6_QTDVEN-C6_X_VGRIM ) - CASE WHEN B1_XQTDPAL>0 THEN FLOOR((C6_QTDVEN-C6_X_VGRIM )/B1_XQTDPAL)*B1_XQTDPAL ELSE 0 END)/B1_QE PQUEBRA"

	cQuery += " FROM "+RETSQLNAME("SC5")+" C5 (NOLOCK) "
	cQuery += " INNER JOIN " +RETSQLNAME("SA4")+" A4 (NOLOCK) ON C5_TRANSP = A4_COD AND A4_FILIAL = '"+xFilial("SA4")+"' AND A4.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN " +RETSQLNAME("SC6")+" C6 (NOLOCK) ON C5_FILIAL=C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = ''     "
	cQuery += " INNER JOIN " +RETSQLNAME("SB1")+" B1 (NOLOCK) ON C6_PRODUTO = B1_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN " +RETSQLNAME("SA1")+" A1 (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''  			  "
	cQuery += " INNER JOIN " +RETSQLNAME("SF4")+" F4 (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES = F4_CODIGO AND F4.D_E_L_E_T_ = '' 	  "
/*	
	cQuery += " INNER JOIN ("
	cQuery += " SELECT C6_FILIAL FIL, C6_NUM NUM, C6_PRODUTO PRODUTO, SUM(PFECHADO) PFECHADO FROM("
	
	cQuery += " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, "
	cQuery += " CASE WHEN B1_XQTDPAL>0 THEN FLOOR((C6_QTDVEN-C6_X_VGRIM )/B1_XQTDPAL) ELSE 0 END PFECHADO"
	cQuery += " FROM SC6020 C6 (NOLOCK)"
	cQuery += " INNER JOIN SB1020 B1 ON C6_PRODUTO = B1_COD AND B1_FILIAL = '' AND B1.D_E_L_E_T_ = ''"
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C6_NOTA<>' '"
	cQuery += " )TOTSC6 GROUP BY C6_FILIAL, C6_NUM, C6_PRODUTO" 
	cQuery += " )PEDIDO ON C6_FILIAL=FIL AND C6_NUM=NUM AND C6_PRODUTO=PRODUTO"
*/	
	cQuery += " WHERE C5.D_E_L_E_T_ = '' "
	cQuery += " AND C5_X_NONDA='"+cAtuOnda+"' "
	cQuery += " AND SUBSTRING(B1_X_LOCAL,2,1) IN (' ','0','1','2','3','4','5','6','7','8','9')"
	cQuery += " AND C6_X_VCXIM > 0) Imp "
	cQuery += " ORDER BY C5_FILIAL, C5_NUM, TIPOIMP, LETRA, PARIMPAR, ORDEM "
	
	//cQuery += " ORDER BY C5_FILIAL, 2, TIPOIMP,1 "
	MemoWrit("C:\temp\BUSCAC6cheio.TXT",cQuery)
	
	//CARREGA VARIÁVEL SE É IMPRESSÃO OU RE-IMPRESSÃO
	DBSelectArea("SZ4")
	DBSetOrder(1)
	DBSeek(SPACE(04)+cAtuOnda)       
	If SZ4->Z4_IMPRESS == "2"
		lImpress	:= .T.
	Endif
	
Else
//aBrowse[oListBox:nAt][3]

	If !Pergunte(cPerg,.T.)
		Return
	EndIf

	cAtuOnda := MV_PAR01

	cQuery := " SELECT *, " 
	cQuery += " CASE PARIMPAR WHEN 'PAR' THEN RIGHT(LEFT(B1_X_LOCAL,3),2) * -1 ELSE RIGHT(LEFT(B1_X_LOCAL,3),2) END ORDEM "
	cQuery += " FROM (  "
	
	//GRANEL
	cQuery += " SELECT B1_X_LOCAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) C5_EMISSAO, "
	cQuery += " C5_TPFRETE, C5_X_ANTEC, C5_VOLUME2, C5_X_TLNCX, C5_X_TLNGR, C5_X_TVLCX, C5_X_TVLGR, C5_TRANSP, A1_X_PRIOR, A1_NREDUZ, A1_EST, C6_TES, F4_TEXTO, A4_NREDUZ,  "
	cQuery += " B1_PESO, C6_PRODUTO, 0 'CX', C6_X_VGRIM 'GR', B1_DESC, B1_QE, 'GR' TIPOIMP, C5_X_OBSLO, C5_X_TPFRE, C5_FILIAL,"
	cQuery += " CASE 	WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
	cQuery += " 		WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA' "
	cQuery += " 		WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
	cQuery += " 		WHEN C5_FILIAL='0902' THEN 'DEV-MG' WHEN C5_FILIAL='1001' THEN 'GLAZY' 	WHEN C5_FILIAL='1101' THEN 'BIZEZ' "
	cQuery += " 		WHEN C5_FILIAL='1201' THEN 'ZAKAT'  WHEN C5_FILIAL='1301' THEN 'HEXIL' 	"
	cQuery += " 		ELSE C5_FILIAL END EMPRESA, "
	cQuery += " 	LEFT(B1_X_LOCAL,1) LETRA, "
	cQuery += " 	CASE RIGHT(LEFT(B1_X_LOCAL,3),2)  % 2 WHEN 0  THEN 'PAR' ELSE 'IMPAR' END PARIMPAR, "
	cQuery += "     (C6_X_VGRIM * C6_PRCVEN) V_PEDIDO "
	cQuery += "    ,0 PFECHADO,(C6_X_VGRIM ) PQUEBRA "

	cQuery += " FROM "+RETSQLNAME("SC5")+" C5 WITH (NOLOCK) "
	cQuery += " INNER JOIN " +RETSQLNAME("SA4")+" A4 WITH (NOLOCK) ON C5_TRANSP = A4_COD AND A4_FILIAL = '"+xFilial("SA4")+"' AND A4.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN " +RETSQLNAME("SC6")+" C6 WITH (NOLOCK) ON C5_FILIAL=C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = '' 	  "
	cQuery += " INNER JOIN " +RETSQLNAME("SB1")+" B1 WITH (NOLOCK) ON C6_PRODUTO = B1_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN " +RETSQLNAME("SA1")+" A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''             "
	cQuery += " INNER JOIN " +RETSQLNAME("SF4")+" F4 WITH (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES = F4_CODIGO AND F4.D_E_L_E_T_ = ''     "
	cQuery += " WHERE C5.D_E_L_E_T_ = ''  "
	cQuery += " AND C5_NUM = '"+MV_PAR01+"' AND C5_FILIAL = '"+xFilial("SC5")+"' "
	cQuery += " AND C6_X_VGRIM > 0 "
	
	//CAIXA
	cQuery += " UNION ALL   "
	cQuery += " SELECT B1_X_LOCAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) C5_EMISSAO, "
	cQuery += " C5_TPFRETE, C5_X_ANTEC, C5_VOLUME2, C5_X_TLNCX, C5_X_TLNGR, C5_X_TVLCX, C5_X_TVLGR, C5_TRANSP, A1_X_PRIOR, A1_NREDUZ, A1_EST, C6_TES, F4_TEXTO, A4_NREDUZ,  "
	cQuery += " B1_PESO, C6_PRODUTO, C6_X_VCXIM 'CX', 0 'GR', B1_DESC, B1_QE, 'CX' TIPOIMP, C5_X_OBSLO, C5_X_TPFRE, C5_FILIAL,"
	cQuery += " CASE 	WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
	cQuery += " 		WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA' "
	cQuery += " 		WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
	cQuery += " 		WHEN C5_FILIAL='0902' THEN 'DEV-MG' WHEN C5_FILIAL='1001' THEN 'GLAZY' 	WHEN C5_FILIAL='1101' THEN 'BIZEZ' "
	cQuery += " 		WHEN C5_FILIAL='1201' THEN 'ZAKAT'  WHEN C5_FILIAL='1301' THEN 'HEXIL' 	"
	cQuery += " 		ELSE C5_FILIAL END EMPRESA, "
	cQuery += " 	LEFT(B1_X_LOCAL,1) LETRA, "
	cQuery += " 	CASE RIGHT(LEFT(B1_X_LOCAL,3),2)  % 2 WHEN 0  THEN 'PAR' ELSE 'IMPAR' END PARIMPAR, "
	cQuery += "    (C6_QTDVEN-C6_X_VGRIM ) * C6_PRCVEN V_PEDIDO,"
	cQuery += "    CASE WHEN B1_XQTDPAL>0 THEN FLOOR((C6_QTDVEN-C6_X_VGRIM )/B1_XQTDPAL) ELSE 0 END PFECHADO,"
	cQuery += "    ((C6_QTDVEN-C6_X_VGRIM ) - CASE WHEN B1_XQTDPAL>0 THEN FLOOR((C6_QTDVEN-C6_X_VGRIM )/B1_XQTDPAL)*B1_XQTDPAL ELSE 0 END) /B1_QE PQUEBRA"
	
	cQuery += " FROM "+RETSQLNAME("SC5")+" C5 WITH (NOLOCK) "
	cQuery += " INNER JOIN " +RETSQLNAME("SA4")+" A4 WITH (NOLOCK) ON C5_TRANSP = A4_COD AND A4_FILIAL = '"+xFilial("SA4")+"' AND A4.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN " +RETSQLNAME("SC6")+" C6 WITH (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = ''     "
	cQuery += " INNER JOIN " +RETSQLNAME("SB1")+" B1 WITH (NOLOCK) ON C6_PRODUTO = B1_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN " +RETSQLNAME("SA1")+" A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''  			  "
	cQuery += " INNER JOIN " +RETSQLNAME("SF4")+" F4 WITH (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES = F4_CODIGO AND F4.D_E_L_E_T_ = '' 	  "
	cQuery += " WHERE C5.D_E_L_E_T_ = '' "
	cQuery += " AND C5_NUM = '"+MV_PAR01+"' AND C5_FILIAL = '"+xFilial("SC5")+"' "
	cQuery += " AND C6_X_VCXIM > 0) Imp "
	
	cQuery += " ORDER BY C5_FILIAL, C5_NUM, TIPOIMP, LETRA, PARIMPAR, ORDEM "
	
	//cQuery += " ORDER BY C5_FILIAL, 2, GR,1 "
	MemoWrit("C:\temp\BUSCAC6vazio.TXT",cQuery)
EndIf

If Select("TRBSC5") > 0
	TRBSC5->(DbCloseArea())
EndIf                                                        
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBSC5",.F.,.T.) 	
DbSelectArea("TRBSC5");TRBSC5->(dbGoTop()) 
_nMax := Contar('TRBSC5',"!Eof()"); TRBSC5->(DbGoTop())

IF _nMax == 0
	_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
	_cPopUp += ' <br> '
	_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Numero da Onda:</font> '
	_cPopUp += ' <br>'
	_cPopUp += ' <font color="#000000" face="Arial" size="3">'+cAtuOnda+'</font> '
	_cPopUp += ' <br> '
	_cPopUp += ' <font color="#000000" face="Arial" size="2">Dados nao localizados para Onda</font> '
	Alert(_cPopUp,'Salonline')	
	RETURN
ENDIF

Private _lView := .T.
Private _lOk   := .T. 
IF _lOk		
	_cNomePDF := 'REL_ONDA_'+cAtuOnda+'-'+DtoS(dDataBase)+StrTran(Time(),':','')
	fErase(cPathEst+_cNomePDF+'.pdf')
	IF oPrint == Nil
		lPreview 		:= .T.
	    oPrint      	:= FWMSPrinter():New(_cNomePDF,6,.T.,,.T.,,,,,,,_lView)
		oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
		oPrint:SetPortrait() //SetLandscape() //SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(60,60,60,60)
		oPrint:nDevice  := IMP_PDF
		oPrint:cPathPDF := cPathEst

		_cArq := cPathEst+_cNomePDF+'.pdf'
	ENDIF                                
	Private PixelX := oPrint:nLogPixelX()
	Private PixelY := oPrint:nLogPixelY()
	//oPrint:StartPage() 
Else
	oPrint:=TMSPrinter():New('Numero da Onda')
	oPrint:Setup()
	oPrint:SetPortrait() //SetLandscape() //SetPortrait()
	//oPrint:StartPage()    //Inicia uma nova página
EndIF

//oPrint:Setup()
//oPrint:SetPortrait()

// MONTA RELATÓRIO
dbSelectArea("TRBSC5")
TRBSC5->(dbGoTop())

cPedImp := TRBSC5->C5_NUM
While !eof() .AND. !EMPTY(cPedImp)
	
	If cPedImp != TRBSC5->C5_NUM .AND. !Empty(TRBSC5->C5_NUM)
		oPrint:EndPage()
	Endif		   
		
	cPedImp   := TRBSC5->C5_NUM	
	MV_PAR01  := cPedImp
	lImpCabec := .T.				// Imprimir Cabeçalho?
	nValorPV  := 0
	cOrdemImp := TRBSC5->TIPOIMP
	nContPg	  := 1	 				//Numeração das Paginas
	nLinPrd   := 805
	nLinCab	  := 720
	nPesoCX	  := 0
	nPesoGR	  := 0
	
	IF TRBSC5->C5_TPFRETE == "C"
		cTpfrete := "Emitente"
	ElseIf TRBSC5->C5_TPFRETE == "F"
		cTpfrete := "Destinatario"
	Else
		cTpfrete := ""
	Endif
		
	While TRBSC5->(!eof()) .and. cPedImp == TRBSC5->C5_NUM .AND. !EMPTY(cPedImp)		
		// SOMA VALOR DO PEDIDO
		nValorPV	+= TRBSC5->V_PEDIDO
		
		//validacao un medida - granel
		IF cOrdemImp != TRBSC5->TIPOIMP			
			lImpCabec := .T.
			cOrdemImp := TRBSC5->TIPOIMP
			oPrint:EndPage()
			oPrint:StartPage()
			nLinCab   := 720
			CabProd(nLinCab)
			nLinPrd   := 805
		Endif
				
		If nLinPrd <= 2555// 1 Pagina 25 Itens (Ajustar)			
			If lImpCabec
				oPrint:EndPage()
				oPrint:StartPage()
				nLinCab   := 720	

				PrintCabec()
				CabProd(nLinCab)
				PrintRodape()
				lImpCabec := .F.
			Endif
			DetProd()	//++			
		Else
			oPrint:EndPage()
			oPrint:StartPage()
			nLinCab := 020
			CabProd(nLinCab)
			nLinPrd := 105
			DetProd(nLinPrd)	//++
			PrintRodape()			
		Endif		
		TRBSC5->(dbSkip())	
	Enddo	
Enddo

If !Empty(cNumOnda)
	AtuImpSZ4()
EndIf

//oPrint:Preview()
IF oPrint <> Nil
	oPrint:Preview()
	FreeObj(oPrint)
	MS_FLUSH()    
	oPrint := Nil 
EndIF

Return

*-------------------------*
Static Function PrintCabec
*-------------------------*
oPrint:Say(0050,0060,	TRBSC5->C5_FILIAL+" - "+TRBSC5->EMPRESA,	oArial18N,,0)
oPrint:Say(0130,0060,	"ORDEM DE SEPARACAO "+" - "+TRBSC5->C5_NUM,	oArial18N,,0)

oPrint:Code128c(0050, 0500, Alltrim(TRBSC5->C5_FILIAL), 30)
oPrint:Code128c(0150, 1900, Alltrim(TRBSC5->C5_NUM), 35)

//MSBAR3("CODE128",0.1,4.5,Alltrim(TRBSC5->C5_FILIAL),oPrint,.F.,,.T.,0.043,0.40,.F.,,"CODE128",.F.)
//MSBAR3("CODE128",0.1,15.6,Alltrim(TRBSC5->C5_NUM),oPrint,.F.,,.T.,0.039,1.0,.F.,,"CODE128",.F.)

oPrint:Line(0200,0060,0200,2470)

If TRBSC5->TIPOIMP == "CX"
	oPrint:Say(0290,0290,"CAIXA",oArial25N,,0)
Else	
	If TRBSC5->C5_X_ANTEC == "1"
		oPrint:Say(0290,0090,"GRANEL - VOL: "+ Transform(TRBSC5->C5_VOLUME2,"9999"),oArial20N,,0) 
	Else	
		oPrint:Say(0290,0300,"GRANEL",oArial25N,,0)
	Endif
Endif               

If TRBSC5->C5_X_ANTEC == "1"
	oPrint:Say(0328,0060,"[ NÃO TIRAR FALTA ]",oArial25N,,0)
Endif	

If TRBSC5->A1_X_PRIOR = "0"
	oPrint:Say(0290,1090,"VIP 0",oArial21N,,0)	
ElseIf TRBSC5->A1_X_PRIOR = "1"
	oPrint:Say(0290,1090,"VIP 1",oArial21N,,0)
ElseIf TRBSC5->A1_X_PRIOR = "2"
	oPrint:Say(0290,1090,"VIP 2",oArial21N,,0)
EndIf

//IMPRIME TIPO DE FRETE
If !Empty(TRBSC5->C5_X_TPFRE)
	If TRBSC5->C5_X_TPFRE == 'E'
		oPrint:Say(0328,1060,"TRUCK ",oArial21N,,0)
	ElseIf TRBSC5->C5_X_TPFRE == 'F'
		oPrint:Say(0328,1060,"CARRETA",oArial21N,,0)
	EndIf
EndIf

If TRBSC5->C5_X_TLNCX > 0 .AND. TRBSC5->C5_X_TLNGR > 0
	oPrint:Say(0290,1870,"CONTEM",oArial21N,,0)
	oPrint:Say(0328,1760,"CAIXA / GRANEL",oArial21N,,0)	
Endif

//oPrint:Say(0440,0060,"Emissão PV: "+TRBSC5->C5_EMISSAO,oArial15,,0)
oPrint:Say(0440,0060,"Emissão PV:",			oArial18N,,0)
oPrint:Say(0440,0400,TRBSC5->C5_EMISSAO,	oArial18 ,,0)

oPrint:Say(0500,0060,alltrim(TRBSC5->A1_NREDUZ)+" - "+TRBSC5->A1_EST,oArial18,,0)
//oPrint:Say(0500,0060,"Digitador: "+TRBSC5->C5_X_DIGIT,oArial15,,0)

DBSelectArea("SC5")
DBSetOrder(3)                    
SC5->(dbGoTop())
//DBSeek(TRBSC5->C5_FILIAL+cPedImp)
DBSeek(TRBSC5->C5_FILIAL+TRBSC5->C5_CLIENTE + TRBSC5->C5_LOJACLI)

While SC5->(!eof()) .AND. SC5->C5_CLIENTE+SC5->C5_LOJACLI = TRBSC5->C5_CLIENTE + TRBSC5->C5_LOJACLI
    If cPedImp != SC5->C5_NUM .and. Empty(SC5->C5_NOTA)
		cNumPV += SC5->C5_NUM + " | "  	
   	Endif 	
	SC5->(DbSkip())
Enddo

cPv 	:= cNumPV
cNumPV 	:= ""

//oPrint:Say(0560,0060,"PV's Cliente: "+Substr(cPv,1,34),oArial15,,0)
oPrint:Say(0560,0060,"PV's Cliente: ",oArial15N,,0)
oPrint:Say(0560,0360,Substr(cPv,1,34),oArial15 ,,0)

//oPrint:Say(0440,1355,"Tipo do Pedido: "+TRBSC5->C6_TES+" "+SubStr(TRBSC5->F4_TEXTO,1,15),oArial15,,0)
oPrint:Say(0440,1255,"Tipo do Pedido: ",								oArial18N ,,0)
oPrint:Say(0440,1700,TRBSC5->C6_TES+" "+SubStr(TRBSC5->F4_TEXTO,1,15),	oArial18,,0)

//oPrint:Say(0500,1355,"Transportadora: "+TRBSC5->A4_NREDUZ,oArial15,,0)
oPrint:Say(0500,1255,"Transportadora: ",oArial18N,,0)
oPrint:Say(0500,1700,TRBSC5->A4_NREDUZ,	oArial18 ,,0)

oPrint:Say(0620,0060,substr(TRBSC5->C5_X_OBSLO,1,100),oArial11,,0)
oPrint:Say(0670,0060,substr(TRBSC5->C5_X_OBSLO,101,180),oArial11,,0)

Return

*---------------------*
Static Function CabProd
*---------------------*
oPrint:Say(nLinCab,0060,"Local",	oArial15N,,0)
oPrint:Say(nLinCab,0220,"Qtde.",	oArial15N,,0)
oPrint:Say(nLinCab,0350,"Codigo",	oArial15N,,0)
oPrint:Say(nLinCab,0550,"Descricao",oArial15N,,0)

If TRBSC5->TIPOIMP == "CX"
	oPrint:Say(nLinCab,1970,"Qt Emb.",oArial15N,,0)
Endif

If lHabPal //Sol.Luana/Claudio Chamado TK2201009 - Autor Rogerio 23/03/2022
	if nLinCab=720
		oPrint:Say(680,2200,"Pallets",oArial15N,,0)
	endif
	oPrint:Say(nLinCab,2160,"Fech",oArial15N,,0)
	oPrint:Say(nLinCab,2280,"Frac.",oArial15N,,0)
Endif

oPrint:Line(nLinCab+55,0060,nLinCab+55,2470)

Return

*----------------------*
Static Function DetProd
*----------------------*
oPrint:Say(nLinPrd,0060,substr(TRBSC5->B1_X_LOCAL,1,3)+"-"+substr(TRBSC5->B1_X_LOCAL,4,2),oArial11,,0)
If TRBSC5->TIPOIMP == "CX"
	oPrint:Say(nLinPrd,0230,Transform(TRBSC5->CX,"99999"),oArial11,,0)
	nPesoCX += (TRBSC5->CX * TRBSC5->B1_QE) * TRBSC5->B1_PESO
Else
	oPrint:Say(nLinPrd,0230,Transform(TRBSC5->GR,"99999"),oArial11,,0)
	nPesoGR += TRBSC5->GR * TRBSC5->B1_PESO
Endif

oPrint:Say(nLinPrd,0380,TRBSC5->C6_PRODUTO,			oArial11,,0)
oPrint:Say(nLinPrd,0550,Alltrim(TRBSC5->B1_DESC),	oArial11D,,0)

If TRBSC5->TIPOIMP == "CX"
	oPrint:Say(nLinPrd,2000,Transform(TRBSC5->B1_QE,"9999"),oArial11,,0)
Endif

If lHabPal	//Sol.Luana/Claudio Chamado TK2201009 - Autor Rogerio 23/03/2022
	oPrint:Say(nLinPrd,2170,Transform(TRBSC5->PFECHADO,"999"),oArial11,,0)
	oPrint:Say(nLinPrd,2280,Transform(TRBSC5->PQUEBRA,"9999"),oArial11,,0)
Endif

nLinPrd += 70
nContPrd++

If TRBSC5->TIPOIMP == "CX"
	If nContPrd >= TRBSC5->C5_X_TLNCX
		
		nLinRod	:= nLinPrd
		If nLinRod <= 2940 .and. nLinRod >= 2625
			nLinRod -= 25
			ImpTotal()
		Elseif nLinRod < 2625
			nLinRod := 2625
			ImpTotal()
		Endif
	Endif
Else
	If nContPrd >= TRBSC5->C5_X_TLNGR
		
		nLinRod	:= nLinPrd
		If nLinRod <= 2940 .and. nLinRod >= 2625
			nLinRod -= 25
			ImpTotal()
		Elseif nLinRod < 2625
			nLinRod := 2625
			ImpTotal()
		Endif
	Endif
Endif

Return

*----------------------*
Static Function ImpTotal
*----------------------*
If TRBSC5->TIPOIMP == "CX"  // Olhar a Query (Quantidade)
	oPrint:Say(nLinRod+040,0060,"CX: "+ Transform(nValorPV,"@E 999,999.99"),oArial15N,,0)
	oPrint:Say(nLinRod+100,0060,"Total de Locais: "+ Transform(TRBSC5->C5_X_TLNCX,"99999"),oArial15N,,0)
	oPrint:Say(nLinRod+100,0900,"Total de Itens: " + Transform(TRBSC5->C5_X_TVLCX,"@E 999,999"),oArial15N,,0)
	oPrint:Say(nLinRod+100,1750-200,"Peso Líquido: " + Transform(nPesoCX,"@E 999,999.999"),oArial15N,,0)
	
	nValorPV	:= 0
Else	
	oPrint:Say(nLinRod+040,0060,"GR: "+ Transform(nValorPV,"@E 999,999.99"),oArial15N,,0)
	oPrint:Say(nLinRod+100,0060,"Total de Locais: " + Transform(TRBSC5->C5_X_TLNGR,"99999"),oArial15N,,0)
	oPrint:Say(nLinRod+100,0900,"Total de Itens: " + Transform(TRBSC5->C5_X_TVLGR,"@E 999,999"),oArial15N,,0)
	oPrint:Say(nLinRod+100,1750-200,"Peso Líquido: " + Transform(nPesoGR,"@E 999,999.999"),oArial15N,,0)
Endif    

oPrint:Say(nLinRod+270,0060,"Separador: ",oArial15N,,0)
oPrint:Line(nLinRod+315,0350,nLinRod+315,1000)
	
oPrint:Say(nLinRod+270,1100,"Conferente: ",oArial15N,,0)
oPrint:Line(nLinRod+315,1420,nLinRod+315,2100)

nContPrd := 0

Return

*-------------------------*
Static Function PrintRodape
*-------------------------*
oPrint:Line(3120,0060,3120,2470)
If lImpress
	oPrint:Say(3150,0060,"Impressão: "+Transform(DDATABASE,"99/99/9999")+" "+SUBSTR(TIME(),1,5)+ "  Ordem: "+TRBSC5->C5_NUM+" / "+TRBSC5->EMPRESA,oArial11,,0)
Else
	oPrint:Say(3150,0060,"Re-Impressão: "+Transform(DDATABASE,"99/99/9999")+" "+SUBSTR(TIME(),1,5)+ "  Ordem: "+TRBSC5->C5_NUM+" / "+TRBSC5->EMPRESA,oArial11,,0)
Endif
If !Empty(cAtuOnda)	
	oPrint:Say(3150,1120,"Numero da Onda: "+cAtuOnda,oArial11,,0)
EndIf
oPrint:Say(3150,2072,"Pagina "+Transform(nContPg,"99"),oArial11,,0)
nContPg++

Return

*-----------------------*
Static Function AtuImpSZ4
*-----------------------*
// Atualizar Flag de Impressão
cUpdSZ4 := " UPDATE "+RetSqlName("SZ4")+" SET Z4_IMPRESS = '1',  "
cUpdSZ4 += " Z4_DTIMPRE = '"+dtos(ddatabase)+"', "
cUpdSZ4 += " Z4_HRIMPRE = '"+substr(time(),1,5)+"',    "
cUpdSZ4 += " Z4_USUIMPR = '"+Substr(cUsuario,7,15)+"'  "
cUpdSZ4 += " WHERE D_E_L_E_T_ = '' AND "
cUpdSZ4 += " Z4_NUMONDA = '"+Alltrim(cAtuOnda)+"' "
cUpdSZ4 += " AND Z4_DTIMPRE = '' "
TcSqlExec(cUpdSZ4)

Return
