#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"
#INCLUDE "FWPrintSetup.ch"

#Define STR_ENTER	Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Funcao   ³ TelaSC5 ³ Autor ³  Andre Salgado /  Introde        ³ Data 05/05/2022 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Selecionar Pedidos de Vendas Em aberto				                ³±±
±±³ Solicitado ³                              	            			            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/

User Function TelaSC5()

Private oTelPV      := Nil
Private oFont1		:= TFont():New('Courier new',,-18,.F.,.T.)
Private oFont4		:= TFont():New('Courier new',,-24,.F.,.T.)
Private aBrowse     :=  {}
Private cDataDe     :=  "20220101" 
Private cDataAte    :=  "20221231"
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

Msginfo("Sera feito a busca dos Pedidos de venda em Aberto "+STR_ENTER+;
"(Status PV-Gerado) da Regiao Norte = AC, AP, AM, PA, TO, RR, RO")

cQrySC5A :=	" SELECT * FROM (SELECT C5_FILIAL, C5_EMISSAO, C5_NUM, C5_CLIENTE, C5_LOJACLI, SUM(C6_VALOR)'TOTAL',	"
cQrySC5A +=	" CASE WHEN floor(SUM(C6_VALOR) / 399000)>0 THEN  floor(SUM(C6_VALOR) / 399000) ELSE 0 END DIF400,"
cQrySC5A +=	" CASE WHEN floor((SUM(C6_VALOR)-(399000*floor(SUM(C6_VALOR)/399000)))/99000) >0       "
cQrySC5A +=	" THEN  floor((SUM(C6_VALOR)-(399000*floor(SUM(C6_VALOR)/399000)))/99000) END DIF100   "
cQrySC5A +=	" ,1 SALDO                                                                            "

cQrySC5A +=	" FROM SC5020 C5 (NOLOCK)                           						            "
cQrySC5A +=	" INNER JOIN SC6020 C6 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM	        "
cQrySC5A +=	" AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI                                      "
cQrySC5A +=	" INNER JOIN SA1020 A1 (NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA             "
cQrySC5A +=	" AND A1.D_E_L_E_T_=' ' AND A1_EST IN ('AC','AM','AP','PA','TO','RO','RR')              "

cQrySC5A +=	" WHERE C5.D_E_L_E_T_ = ' '                                                             "
cQrySC5A +=	" AND C5_FILIAL = '"+xFilial("SC5")+"'	                                                "
cQrySC5A +=	" AND C5_NOTA = ''                                                                      "
cQrySC5A +=	" AND C5_EMISSAO BETWEEN '"+cDataDe+"' AND '"+cDataAte+"'                               "
cQrySC5A +=	" AND C5_X_STAPV = '0'                                                                  "
cQrySC5A +=	" GROUP BY C5_FILIAL, C5_EMISSAO, C5_NUM, C5_CLIENTE, C5_LOJACLI                        "
cQrySC5A +=	" )A WHERE DIF400>0 OR DIF100>0"
TCQUERY cQrySC5A NEW ALIAS "TRBSC5A"

dbSelectArea("TRBSC5A")
TRBSC5A->(dbGoTop())

While TRBSC5A->(!EOF()) 
 
	aAdd(aBrowse,{.F.,;
	TRBSC5A->C5_FILIAL,;
	STOD(TRBSC5A->C5_EMISSAO),;
	TRBSC5A->C5_NUM,;
	TRBSC5A->C5_CLIENTE,;
	TRBSC5A->C5_LOJACLI,;
	Transform(TRBSC5A->TOTAL,"@E 9,999,999.99"),;
	Transform(TRBSC5A->DIF400,"@E 9"),;
	Transform(TRBSC5A->DIF100,"@E 9"),;
	Transform(TRBSC5A->SALDO,"@E 9")})

	TRBSC5A->(dbSkip())

Enddo

TRBSC5A->(DbCloseArea())

If Len(aBrowse) == 0
	aAdd(aBrowse,{.F., SPACE(10), CTOD(" / / "), SPACE(10), SPACE(10), SPACE(10), 0.00, 0, 0, 0 })
Endif

aSize 		:= {}
aObjects	:= {}

aSize	:= MsAdvSize( .F. )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 100, 060, .T., .T. } )

aPosObj	:= MsObjSize(aInfo,aObjects)
aPosGet	:= MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

DEFINE MSDIALOG oTelPV FROM aSize[7],aSize[1] TO aSize[6],aSize[5] TITLE Alltrim(OemToAnsi("Pedido(s) Em Aberto Região NORTE")) Pixel

@ 002, 005 To aPosObj[1][3]-35, aPosObj[1][4]+4 Label Of oTelPV Pixel

@ 010,aPosGet[1][3]+40 Button "PROCESSAR" size 55,15 action Processa( {|| TelSC5A() }) OF oTelPV PIXEL
@ 035,aPosGet[1][3]+40 Button "FECHAR"  size 55,15 action oTelPV:End() OF oTelPV PIXEL

oListBo2	:= twBrowse():New(0070,0005,aPosObj[1][4]-1,aPosObj[2][3]-075,,{" ","Filial","Emissao","Numero","Cliente","Loja","Total","PV $400","PV $100","PV $Saldo"},,oTelPV,,,,,,,oFont1,,,,,.F.,,.T.,,.F.,,,)

oListBo2:SetArray(aBrowse)
oListBo2:bLine := {||{ IIf(aBrowse[oListBo2:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),; //flag
aBrowse[oListBo2:nAt,02],;
aBrowse[oListBo2:nAt,03],;
aBrowse[oListBo2:nAt,04],;
aBrowse[oListBo2:nAt,05],;
aBrowse[oListBo2:nAt,06],;
aBrowse[oListBo2:nAt,07],;
aBrowse[oListBo2:nAt,08],;
aBrowse[oListBo2:nAt,09],;
aBrowse[oListBo2:nAt,10]}}

oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrowse[oListBo2:nAt,1] := !aBrowse[oListBo2:nAt,1]),(aBrowse[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(), TelSC5B()  } 
   
oTelPV:Refresh()
oListBo2:Refresh() 

ACTIVATE MSDIALOG oTelPV centered

Return()

//======================================================//
//                      PROCESSAR                       //
//======================================================//
Static Function TelSC5A()

Local nX    := 0
private cPv   := ""

For nX := 1 To Len(aBrowse) 

    If aBrowse[nX][1]

		//Pedido Valor R$ 400.000
		IF val(aBrowse[nX][8])>0  .OR. val(aBrowse[nX][9])>0
        	cPv := aBrowse[nX][4] + STR_ENTER
			GravaPV(aBrowse[nX][8], aBrowse[nX][9])
		Endif
		
    Endif

Next nX

//Msginfo("Foi processado os Pedidos " + STR_ENTER + cPv ,"Atenção")

Return()

//======================================================//
// Tela no momento da Marcação                          //
//======================================================//
Static Function TelSC5B()
//MsgAlert("Marcado","Atenção")
Return()


//Cria o Pedido de Venda
Static Function GravaPV(P400,P100)
Private P400 := val(P400)
Private P100 := val(P100)
Private cPVCriado := ""

If MsgYesNo("Confirma o processamento do Pedido " + STR_ENTER + cPv +" para atender Regra do Frete da Regiao Norte ?","Atencao","YESNO")

//Busca a informaçao 
cQuery := " SELECT "
cQuery += " C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_TIPOCLI, C5_TPFRETE, C5_TRANSP, "
cQuery += " C5_X_STAPV, C5_CONDPAG, C5_X_TIPO2, C5_VEND1, C5_MENNOTA,"
cQuery += " C5_X_DIGIT, C5_X_DTIMP, C5_X_HRIMP, C5_X_USIMP, C5_X_TLNCX, C5_X_TABLE, C5_EMISSAO, "
cQuery += " C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_UM, C6_QTDVEN, C6_PRCVEN, C6_VALOR,  C6_PRUNIT,"
cQuery += " C6_ENTREG, C6_DESCONT, C6_VALDESC, C6_NUMPCOM,C6_TES, C6_LOCAL"
cQuery += " FROM SC5020 C5 (NOLOCK)"
cQuery += " INNER JOIN SC6020 C6 (NOLOCK) ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C6.D_E_L_E_T_=' ' "
cQuery += " WHERE C5.D_E_L_E_T_=' '" 
cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"
cQuery += " AND C5_NUM = '"+substr(cPv,1,6)+"'"
cQuery += " ORDER BY C5_FILIAL, C5_NUM, C6_VALOR"


MemoWrit("C:\Temp\a.TXT",cQuery)

TCQUERY cQuery NEW ALIAS "TRBSC5B"

dbSelectArea("TRBSC5B")
TRBSC5B->(dbGoTop())

aCabec := {}
aItens := {}
lCabec := .T.
nSomaPV:= 0

While TRBSC5B->(!EOF()) 

	//Soma Saldo do Pedido
	nSomaPV += TRBSC5B->C6_VALOR

	//Pedido de 100.000
	IF P400>0 .AND. nSomaPV <= 399000
//		nSomaPV += TRBSC5B->C6_VALOR
		
	ELSEIF P400>0 
		P400 := P400-1
		nSomaPV := tRBSC5B->C6_VALOR
		P400 := P400 - 1
		GeraPedido()
		lCabec := .T.

	elseIF P100>0 .AND. nSomaPV <= 99000
//		nSomaPV += TRBSC5B->C6_VALOR

	else
		nSomaPV := tRBSC5B->C6_VALOR
		P100 := P100 - 1
		GeraPedido()
		lCabec := .T.
	Endif


	//Cabecalho
	IF lCabec 
		cNumPV 	 := GetSxeNum("SC5","C5_NUM")
		cPVCriado+= cNumPV+STR_ENTER
		RollBAckSx8()
		aadd(aCabec,{"C5_NUM"    ,cNumPV           		,Nil})
		aadd(aCabec,{"C5_TIPO"   ,"N"					,Nil})
		aadd(aCabec,{"C5_CLIENTE",TRBSC5B->C5_CLIENTE	,Nil})
		aadd(aCabec,{"C5_LOJACLI",TRBSC5B->C5_LOJACLI	,Nil})
		aadd(aCabec,{"C5_LOJAENT",TRBSC5B->C5_LOJACLI	,Nil})
		aadd(aCabec,{"C5_CONDPAG",TRBSC5B->C5_CONDPAG	,Nil})
		aadd(aCabec,{"C5_TRANSP" ,TRBSC5B->C5_TRANSP	,Nil})
		aadd(aCabec,{"C5_VEND1"  ,TRBSC5B->C5_VEND1		,Nil})
		aadd(aCabec,{"C5_MENNOTA",TRBSC5B->C5_MENNOTA	,Nil})
//		aadd(aCabec,{"C5_EMISSAO",stod(TRBSC5B->C5_EMISSAO)   ,Nil})
		aadd(aCabec,{"C5_X_STAPV",TRBSC5B->C5_X_STAPV	,Nil})
		aadd(aCabec,{"C5_X_TIPO2",TRBSC5B->C5_X_TIPO2	,Nil})
//		aadd(aCabec,{"C5_X_DIGIT",stod(TRBSC5B->C5_X_DIGIT)   ,Nil})
//		aadd(aCabec,{"C5_X_DTIMP",stod(TRBSC5B->C5_X_DTIMP)	,Nil})
		aadd(aCabec,{"C5_X_HRIMP",TRBSC5B->C5_X_HRIMP	,Nil})
		aadd(aCabec,{"C5_X_USIMP",TRBSC5B->C5_X_USIMP   ,Nil})
		aadd(aCabec,{"C5_X_TLNCX",TRBSC5B->C5_X_TLNCX	,Nil})
		aadd(aCabec,{"C5_X_TABLE",TRBSC5B->C5_X_TABLE   ,Nil})
		aadd(aCabec,{"C5_VOLUME1",1                 	,Nil})
		aadd(aCabec,{"C5_ESPECI1","CAIXA"           	,Nil})
		lCabec := .F. 
	Endif

	//Item
	aLinha := {}
	aadd(aLinha,{"C6_ITEM"	 ,TRBSC5B->C6_ITEM		,Nil})
	aadd(aLinha,{"C6_PRODUTO",TRBSC5B->C6_PRODUTO	,Nil})
	aadd(aLinha,{"C6_UM"     ,TRBSC5B->C6_UM        ,Nil})
	aadd(aLinha,{"C6_LOCAL"  ,TRBSC5B->C6_LOCAL     ,Nil})
	aadd(aLinha,{"C6_DESCRI" ,TRBSC5B->C6_DESCRI	,Nil})
	aadd(aLinha,{"C6_QTDVEN" ,TRBSC5B->C6_QTDVEN   ,Nil})
	aadd(aLinha,{"C6_PRCVEN" ,TRBSC5B->C6_PRCVEN    ,Nil})
	aadd(aLinha,{"C6_PRUNIT" ,TRBSC5B->C6_PRUNIT	,Nil})
	aadd(aLinha,{"C6_VALOR"	 ,TRBSC5B->C6_VALOR		,Nil})
	aadd(aLinha,{"C6_TES"	 ,TRBSC5B->C6_TES		,Nil})
//	aadd(aLinha,{"C6_ENTREG" ,stod(TRBSC5B->C6_ENTREG)    ,Nil})
	aadd(aLinha,{"C6_DESCONT",TRBSC5B->C6_DESCONT	,Nil})
	aadd(aLinha,{"C6_VALDESC",TRBSC5B->C6_VALDESC	,Nil})
	aadd(aLinha,{"C6_NUMPCOM",TRBSC5B->C6_NUMPCOM	,Nil})
	aadd(aItens,aLinha)

	DbSelectArea("TRBSC5B")
	TRBSC5B->(dbSkip())

Enddo
TRBSC5B->(DbCloseArea())

if nSomaPV > 0
	GeraPedido()
Endif

if !Empty(cPVCriado)
	MSGINFO("Foram criados o(s) Pedido(s)"+STR_ENTER+cPVCriado)
Endif


Endif



Return()

//******************************************
//Processa Geração do PEDIDO DE VENDA
//******************************************
Static Function GeraPedido()

//Executa ExecAuto PV

MATA410(aCabec,aitens,3)

If !lMsErroAuto
    //Deleta o Pedido Original
     cQueryC5 := " UPDATE "+RetSqlName("SC5")+" SET D_E_L_E_T_='*', C5_ESPECI2='REG.NORTE' WHERE C5_FILIAL='"+xFilial("SC5")+"' AND C5_NUM='"+substr(cPv,1,6)+"'"
    //TcSqlExec(cQueryC5)

    cQueryC6 := " UPDATE "+RetSqlName("SC6")+" SET D_E_L_E_T_='*', C6_NUMPCOM='REG.NORTE' WHERE C6_FILIAL='"+xFilial("SC5")+"' AND C6_NUM='"+substr(cPv,1,6)+"'"
    //TcSqlExec(cQueryC6)

Else
	//mostraerro()
EndIf

//Zera Variaveis
cNumPV	:= ""
aCabec	:= {}
aitens	:= {}
cFlacCab:= .T.	//Liberado Cabeçalho
nTotQueb:= 0
cSeq	:= '01'

Return
