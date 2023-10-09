#include "Protheus.ch"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TBICONN.CH"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410CPY º Autor ³ Genilson Lucas	º Data ³  26/04/18    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ponto de Entrada para cópia do Pedido de Venda			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºMelhoria  #                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT410CPY() 

Local aArea		:= GetArea() 
Local lRet		:= .T. 
Local lDev		:= .F. 
Local nPos1		:= GdFieldPos("C6_X_VCXIM") 
Local nPos2		:= GdFieldPos("C6_X_VGRIM") 
Local nPos3		:= GdFieldPos("C6_X_VCXCO") 
Local nPos4		:= GdFieldPos("C6_X_VGRCO") 
Local nPos5		:= GdFieldPos("C6_X_VCXC2") 
Local nPos6		:= GdFieldPos("C6_X_SEPAR") 
Local nPos7		:= GdFieldPos("C6_X_RESID") 
Local nPos8		:= GdFieldPos("C6_X_OPERA") 
Local nPos9		:= GdFieldPos("C6_X_ESTOQ")
Local cTes		:= ""							// Valmir(11/06/2019)
Local cNfOrig	:= ""							// Valmir(11/06/2019)
Local cFilOr	:= ""

Local nLinAtu		:= 0 
Local cTipo     	:= "1"
Private cPvOrig		:= ""                      
Private nPos10		:= GdFieldPos("C6_TES")			// Valmir(11/06/2019)
Private nPos11		:= GdFieldPos("C6_CF")			// Valmir(11/06/2019)
Private nPos12		:= GdFieldPos("C6_CLASFIS")		// Valmir(11/06/2019)
Private cClie		:= ""
Private cLoj		:= "" 
Private cSigla		:= ""
Private cCfopNac 	:= ""
Private cCfopImp	:= ""
Private cCfopN		:= ""
Private cCfopI		:= ""
Private cSitN		:= ""
Private cSitI		:= ""
/*
If !Empty(SC5->C5_X_PEDOR)
	MsgInfo("Esse Pedido não pode ser copiado por já ser uma Cópia.","Atenção")
	lRet	:= .F.
EndIf
*/

If Empty(SC5->C5_NOTA)
	cTipo	:= "2" //Não é Refaturamento
Else
	dbSelectArea("SD1")
	dbSetOrder(19)
	If dbSeek(xFilial("SD1")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI))
		lDev := .T.
	EndIf

	If SC5->C5_NOTA == 'XXXXXXXXX' .Or. lDev
		cTipo	:= "1"
	Else
		cTipo	:= "2" //Não é Refaturamento
	EndIf
EndIf

//*******************************************************************
// QUANDO FOR CÓPIA DO PEDIDO, LIMPA OS CAMPOS CUSTOMIZADOS
//*******************************************************************
	M->C5_MENNOTA := 'REF PEDIDO ORIGINAL: ' + SC5->C5_NUM
	M->C5_X_PEDOR := SC5->C5_NUM
	M->C5_X_STAPV := '0'
	M->C5_X_ANTEC := '2'
	M->C5_X_DIGIT := USRFULLNAME(RETCODUSR())
	M->C5_X_TLNCX := 0
	M->C5_X_TLNGR := 0
	M->C5_X_TVLCX := 0
	M->C5_X_TVLGR := 0
	M->C5_X_DTIMP := CTOD("  /  /  ")
	M->C5_X_HRIMP := ''
	M->C5_X_USIMP := ''
	M->C5_X_TLPCC := ''
	M->C5_X_TLPCG := ''
	M->C5_X_CONCX := ''
	M->C5_X_DTCCX := CTOD("  /  /  ")
	M->C5_X_HRCCX := ''
	M->C5_X_CONGR := ''
	M->C5_X_DTCGR := CTOD("  /  /  ")
	M->C5_X_HRCGR := ''
	M->C5_X_TABLE := ''
	M->C5_X_OBSVD := ''
	M->C5_X_OBSIN := ''
	M->C5_X_OBSLO := ''
	M->C5_X_DTISP := CTOD("  /  /  ")
	M->C5_X_HRISP := ''
	M->C5_X_DTFSP := CTOD("  /  /  ")
	M->C5_X_HRFSP := ''
	M->C5_X_SEPAR := ''
	M->C5_X_MANIF := ''
	M->C5_X_DTICF := CTOD("  /  /  ")
	M->C5_X_HRICF := ''
	M->C5_X_DTIGR := CTOD("  /  /  ")
	M->C5_X_HRIGR := ''	
	M->C5_X_TIPO2 := cTipo  //'1'
	M->C5_X_CFVOL := ''
	M->C5_X_CFSEP := ''
	M->C5_X_NONDA := ''
	M->C5_X_HRINC := TIME()
	
	M->C5_X_STAFT := ''		
	M->C5_X_STAMN := ''
	M->C5_X_STACM := ''
	M->C5_X_STALG := ''
	M->C5_X_ONDLG := ''
	M->C5_X_SONLG := ''
	M->C5_X_HROLG := ''
	M->C5_X_ONSUB := ''
	M->C5_X_DTOLO := CTOD("  /  /  ")
	M->C5_X_FLAG  := .F.
	M->C5_X_STACR := ""
	M->C5_X_DTAGE := CTOD("  /  /  ")
	
	M->C5_ESPECI3	:= '' // CRIAR NOVO CAMPO


//Percorrendo linhas da grid 
For nLinAtu := 1 To Len(aCols) 
	//Se encontrar o campo na grid, sobrepõe o valor 
    If nPos1 > 0 
    	aCols[nLinAtu][nPos1] := 0
        aCols[nLinAtu][nPos2] := 0
        aCols[nLinAtu][nPos3] := 0
        aCols[nLinAtu][nPos4] := 0
        aCols[nLinAtu][nPos5] := 0
        aCols[nLinAtu][nPos6] := 0
        aCols[nLinAtu][nPos7] := ''
        aCols[nLinAtu][nPos8] := ''
        aCols[nLinAtu][nPos9] := ''
		
		cTes := aCols[nLinAtu][nPos10] 	// Valmir(11/06/2019)
		
    EndIf 
Next nLinAtu 

// Valmir(11/06/2019)
cFilOr	:= FWxFilial()
cNfOrig	:= SC5->C5_NOTA   
cPvOrig := SC5->C5_NUM 
cClie	:= SC5->C5_CLIENTE
cLoj	:= SC5->C5_LOJACLI

If cFilOr = "0201" .AND. cTes $ "612/617" 

	Private	oWindow
	Private cTesNac		:= space(03)
	Private cTesImp		:= space(03)
	     
	dbSelectArea("SC5")
	RecLock( "SC5", .F. )
		M->C5_X_STAPV	:= '5'
		M->C5_MENNOTA	+= ' - NF ORIGINAL '+cNfOrig+ ' DE SIMPLES FATURAMENTO '
	SC5->(MsUnLock()) 
	
	dbSelectArea("SC5")
	DbsetOrder(1)
	Dbseek(xFilial("SC5")+cPvOrig)
	RecLock( "SC5", .F. )
		SC5->C5_ESPECI4	:= M->C5_NUM	
	SC5->(MsUnLock())
	
	DEFINE MSDIALOG oWindow FROM 000,000 TO 260,500 TITLE Alltrim(OemToAnsi("INFORMAR TES")) Pixel
	
	oSayLn3		:= tSay():New(35,05,{||"TES DE SAIDA NACIONAL "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,100,20)
	oGet		:= tGet():New(33,100,{|u| if(Pcount()>0,cTesNac:=u,cTesNac) },oWindow,40,10,"@!",{|| !empty(cTesNac)},,,,,,.T.,,,,,,,,,"SF4","cTesNac",,,,,.F.,,)
	
	oSayLn3		:= tSay():New(55,05,{||"TES DE SAIDA IMPORTADO (ELETRICOS)"},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,100,20)
	oGet		:= tGet():New(53,100,{|u| if(Pcount()>0,cTesImp:=u,cTesImp) },oWindow,40,10,"@!",{|| !empty(cTesImp)},,,,,,.T.,,,,,,,,,"SF4","cTesImp",,,,,.F.,,)
	
	oWindow:Refresh()
	
	ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,{||lOk:=.T.,AtuQry(),oWindow:End()},{||oWindow:End()},,)
	
Endif   

RestArea(aArea) 
    
Return(lRet)


//****************************************************************
// ATUZLIAZA INFORMAÇÕES DA CROZ
//****************************************************************
Static Function AtuQry()
                                         
cQry := " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_TES, C6_CLASFIS, B1_ORIGEM       "
cQry += " FROM SC6020 C6                                                            "
cQry += " 	INNER JOIN SB1020 B1 ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ''      "
cQry += " WHERE C6.D_E_L_E_T_ = ''                                                  "
cQry += " AND C6_NUM = '"+cPvOrig+"'                                              "
cQry += " AND C6_FILIAL = '0201'                                                    "

If Select("TMPC6A") <> 0
	DbSelectArea("TMPC6A")
	DbCloseArea()
Endif

TCQUERY cQry NEW ALIAS "TMPC6A"

dbSelectArea("TMPC6A")
TMPC6A->(dbGoTop()) 

nCont := 1                         

cCfopN 	:= Posicione("SF4",1,xFilial("SF4")+cTesNac,"F4_CF")
cCfopI 	:= Posicione("SF4",1,xFilial("SF4")+cTesImp,"F4_CF")

cSitN	:= Posicione("SF4",1,xFilial("SF4")+cTesNac,"F4_SITTRIB")
cSitI 	:= Posicione("SF4",1,xFilial("SF4")+cTesImp,"F4_SITTRIB")

cEst		:= Posicione("SA1",1,xFilial("SA1")+cClie+cLoj,"A1_EST") 
cFil 		:= FWCodFil()

If alltrim(SM0->M0_CODFIL)+SM0->M0_ESTCOB == cFil+cEst
    cSigla := "5"
Else
	cSigla := "6"
Endif

cCfopNac 	:= cSigla+SubStr(cCfopN,2,4)
cCfopImp	:= cSigla+SubStr(cCfopI,2,4)
                         
While TMPC6A->(!EOF()) .AND. Alltrim(TMPC6A->C6_NUM) == Alltrim(cPvOrig)
        	
 	If TMPC6A->B1_ORIGEM = "0" 	
		aCols[nCont][nPos10]	:= cTesNac	       
		aCols[nCont][nPos11]	:= cCfopNac
		aCols[nCont][nPos12]	:= TMPC6A->B1_ORIGEM+cSitN
	Else	  					// Elétricos
		aCols[nCont][nPos10]	:= cTesImp
		aCols[nCont][nPos11]	:= cCfopImp
		aCols[nCont][nPos12]	:= TMPC6A->B1_ORIGEM+cSitI
	Endif                       
	
	nCont++		
	TMPC6A->(DbSkip())
 
Enddo

Return()