#Include "Avprint.ch"
#Include "Font.ch"
#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"


//*****************************************************************************
USER FUNCTION ESTR0001()
//*****************************************************************************

Private cPerg		:= "ESTR01"
Private cNumPed		
Private cTipoimp
Private cContem		:= ""
Private	cCXGR		:= ""

//AjustaSX1(cPerg)

If !Pergunte(cPerg, .T.)
   Return (.T.)
Endif                          



Processa({|X| lEnd := X, ImpEtiq()})
		
RETURN(.T.)


//*****************************************************************************
Static Function ImpEtiq()
//*****************************************************************************

Private nDes	:= 0  // Deslocamento
Private cQuery	:= ""

cNumPed		:= Alltrim(MV_PAR01)
cTipoimp	:= MV_PAR02				// Tipo de Impressão (1=Caixa / 2=Granel )
cImpCG		:= ""

If cTipoimp == 1
	cImpCG := "C"
Else
    cImpCG := "G"	
Endif

#xtranslate :HAETTENSCHWEILER_16           => \[1\]
#xtranslate :ARIAL_NARROW_14_NEGRITO        => \[2\]
#xtranslate :ARIAL_BLACK_54_NEGRITO        => \[3\]
#xtranslate :CENTURY_GOTHIC_10_NEGRITO     => \[4\]
#xtranslate :CENTURY_GOTHIC_11_NEGRITO     => \[5\]
#xtranslate :CENTURY_GOTHIC_12_NEGRITO     => \[6\]
#xtranslate :CENTURY_GOTHIC_14_NEGRITO     => \[7\]
#xtranslate :ARIAL_09             => \[8\]
#xtranslate :ARIAL_10             => \[9\]
#xtranslate :ARIAL_12             => \[10\]
#xtranslate :ARIAL_18             => \[11\]
#xtranslate :ARIAL_10_NEGRITO     => \[12\]
#xtranslate :ARIAL_12_NEGRITO     => \[13\]
#xtranslate :ARIAL_14_NEGRITO     => \[14\]
#xtranslate :ARIAL_14_NEGRITO     => \[15\]
#xtranslate :ARIAL_14_NEGRITO     => \[16\]
#xtranslate :ARIAL_40_NEGRITO     => \[17\]
#xtranslate :ARIAL_60_NEGRITO     => \[18\]

AVPRINT oPrn NAME "Etiqueta"

oFont1 := oSend(TFont(),"New","HAETTENSCHWEILER" ,0,16,,.F.,,,,,,,,,,,oPrn )
oFont2 := oSend(TFont(),"New","Arial NARROW" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont3 := oSend(TFont(),"New","Arial BLACK" ,0,54,,.T.,,,,,,,,,,,oPrn )

oFont4 := oSend(TFont(),"New","Century Gothic" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont5 := oSend(TFont(),"New","Century Gothic" ,0,11,,.T.,,,,,,,,,,,oPrn )
oFont6 := oSend(TFont(),"New","Century Gothic" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont7 := oSend(TFont(),"New","Century Gothic" ,0,14,,.T.,,,,,,,,,,,oPrn )

oFont8  := oSend(TFont(),"New","Arial" ,0,09,,.F.,,,,,,,,,,,oPrn )
oFont9  := oSend(TFont(),"New","Arial" ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont10 := oSend(TFont(),"New","Arial" ,0,12,,.F.,,,,,,,,,,,oPrn )
oFont11 := oSend(TFont(),"New","Arial" ,0,18,,.F.,,,,,,,,,,,oPrn )

oFont12 := oSend(TFont(),"New","Arial" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont13 := oSend(TFont(),"New","Arial" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont14 := oSend(TFont(),"New","Arial" ,0,13,,.T.,,,,,,,,,,,oPrn )
oFont15 := oSend(TFont(),"New","Arial" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont16 := oSend(TFont(),"New","Arial" ,0,20,,.T.,,,,,,,,,,,oPrn )
oFont17 := oSend(TFont(),"New","Arial" ,0,24,,.T.,,,,,,,,,,,oPrn )
oFont18 := oSend(TFont(),"New","Arial" ,0,60,,.T.,,,,,,,,,,,oPrn )

aFontes := {oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8,;
oFont9, oFont10, oFont11, oFont12, oFont13, oFont14, oFont15, oFont16, oFont17, oFont18  }

oBrush	:= TBrush():New(,4)

oPrn:SetPortrait()  // SetLandscape()
	
DBSelectArea("SC5")
DBSetOrder(1)
DBSeek(xFilial("SC5")+Alltrim(MV_PAR01))

If Found()
	cNomCli		:=	Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME"))
	cTabTransp	:=	Alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_ECSERVI"))
	cNomTransp	:=	Alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NREDUZ"))
	cMun		:=	Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_MUN"))
	cUF 		:=	Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_EST"))
	cCEP		:= 	Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_CEP"))
	If SC5->C5_X_TLNCX > 0 .AND. SC5->C5_X_TLNGR > 0
		cContem	:= "CONTEM"
		cCXGR	:= "CX/GR"				
	Endif
	Imprime()
Endif

oSend(oFont1,"End")
oSend(oFont2,"End")
oSend(oFont3,"End")
oSend(oFont4,"End")
oSend(oFont5,"End")
oSend(oFont6,"End")
oSend(oFont7,"End")
oSend(oFont8,"End")
oSend(oFont9,"End")
oSend(oFont10,"End")
oSend(oFont11,"End")
oSend(oFont12,"End")
oSend(oFont13,"End")
oSend(oFont14,"End")
oSend(oFont15,"End")
oSend(oFont16,"End")
oSend(oFont17,"End")
oSend(oFont18,"End")

AVENDPRINT

Return() // ImpEtiq()


//*****************************************************************************
Static Function Imprime()
//*****************************************************************************

	nQtdEtiCX := SC5->C5_VOLUME1	
	nQtdEtiGR := SC5->C5_VOLUME2
	
	
	If cTipoimp = 1	// Caixa
		For nCx:=1 to nQtdEtiCX	
			ImpDet(nCx)          
		Next                   
	Endif               
	
	cTipoimp := 2	

	If cTipoimp == 2	// Granel	
		For nGr:=1 to nQtdEtiGR
			ImpDet(nGr)	
		Next           
	Endif


Return() // Imprime()


//*****************************************************************************
Static Function ImpDet(nNumEtiq)
//*****************************************************************************

Private cTexto	:= ""
Private	cStartPath	:= GetSrvProfString('Startpath','')//,;
//		cFileLogo	:= cStartPath + 'LGRL0101' + '.bmp'
		
AVPAGE
  
cTexto := SM0->M0_FILIAL
oPrn:Say(nLin(0.3), nCol(0.4),cTexto,oFont17)

If cTipoimp == 1	// 1 = Caixa
	cTexto	:= cNumPed+";"+cImpCG+";"+ alltrim(Transform(nCx,"@E 9999"))	
	MSBAR("EAN128", 0.3, 5.20, cTexto, oPrn, .F.,,.T., 0.025,0.80 ,.F.,,, .F. )
Else
	cTexto	:= cNumPed+";"+cImpCG+";"+ alltrim(Transform(nGr,"@E 9999"))	
	MSBAR("EAN128", 0.3, 5.20, cTexto, oPrn, .F.,,.T., 0.025,0.80 ,.F.,,, .F. )
EndIf

cTexto := "PV: " + cNumPed
oPrn:Say(nLin(1.3), nCol(0.4),cTexto,oFont15)

If cTipoimp == 1 // 1 = Caixa
	
	If nQtdEtiCX > 9999 // Valmir (23/11/2018)	
		cTexto := "CX: " +Padl(nCx,5,"0")+"/"+Padl(nQtdEtiCX,5,"0")
		oPrn:Say(nLin(1.3), nCol(3.3),cTexto,oFont15)
	Else
		cTexto := "CX: " +Padl(nCx,4,"0")+"/"+Padl(nQtdEtiCX,4,"0")
		oPrn:Say(nLin(1.3), nCol(3.3),cTexto,oFont15)
	Endif

Else
	If nQtdEtiGR > 9999 // Valmir (23/11/2018)
		cTexto := "GR: " +Padl(nGr,5,"0")+"/"+Padl(nQtdEtiGR,5,"0")
		oPrn:Say(nLin(1.3), nCol(3.3),cTexto,oFont15)
	Else
		cTexto := "GR: " +Padl(nGr,4,"0")+"/"+Padl(nQtdEtiGR,4,"0")
		oPrn:Say(nLin(1.3), nCol(3.3),cTexto,oFont15)
	Endif
		
Endif

cTexto := cContem
oPrn:Say(nLin(1.0), nCol(7.0),cTexto,oFont14)

cTexto := cCXGR
oPrn:Say(nLin(1.4), nCol(7.2),cTexto,oFont14)
/*
If cTipoimp == 1 // 1 = Caixa "C"
	cTexto := "CAIXA"
	oPrn:Say(nLin(1.3), nCol(7.7),cTexto,oFont15)
Else
	cTexto := "GRANEL"
	oPrn:Say(nLin(1.3), nCol(7.7),cTexto,oFont15)
Endif
*/

//TRANSPORTADORA
cTexto := cNomTransp
oPrn:Say(nLin(2.0), nCol(0.4),cTexto,oFont15)

If !Empty(cTabTransp) //Codigo da tabela da transportadora
	
	cQuery	:= " SELECT * FROM " + RetSqlName("SZ3") + " WITH(NOLOCK)  " 
	cQuery	+= " WHERE Z3_EMPRESA = '"+cTabTransp+"' AND "
	cQuery	+= " Z3_CEP_INI <= '"+cCEP+"' AND Z3_CEP_FIN >= '"+cCEP+"' "
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSZ3",.T.,.T.)
						
	cTexto 	:= " ( "+ alltrim(TMPSZ3->Z3_SIGLA)
	If !Empty(TMPSZ3->Z3_SETOR)
		cTexto	+=" - "+ alltrim(TMPSZ3->Z3_SETOR) + " )"
	Else
		cTexto	+= " )"
	EndIf 
	oPrn:Say(nLin(1.8), nCol(5.5),cTexto,oFont16)
	
	TMPSZ3->(DbCloseArea())
EndIf

cTexto := Substr(cNomCli,1,25)
oPrn:Say(nLin(2.7), nCol(0.4),cTexto,oFont15)

cTexto := cMun + Space(5) + cUF
oPrn:Say(nLin(3.4), nCol(0.4),cTexto,oFont15) 
                           
AVENDPAGE

Return() // ImpDet()


//*****************************************************************************
Static Function nLin(nVal)
//*****************************************************************************

Local nRet

nRet := (300/2.54) * (nVal + nDes)

Return(nRet)  // nLin()


//*****************************************************************************
Static Function nCol(nVal)
//*****************************************************************************

Local nRet

nRet := (300/2.54) * (nVal)

Return(nRet)  // nCol()


//*****************************************************************************
Static Function AjustaSX1(cPerg)
//*****************************************************************************

_aArea := GetArea()

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs:={}
//          Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]
		MsUnlock()
		DbCommit()
	Endif
Next

RestArea(_aArea)

Return() // AjustaSX1()