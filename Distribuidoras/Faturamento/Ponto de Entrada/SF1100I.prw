#INCLUDE "RWMAKE.CH"

#define DS_MODALFRAME   128

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³SF1100I   ºAutor  ³Andre Salgado/Introde ºData³ 28/08/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³Envia informação do Motivo Devolução para E1_HIST           º±±
±±º          ³Solicitação Renato/Financeiro                               º±±
±±º          ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1100I()    

Private oMotDev
Private aDados	:= FWGetSX5( "Z1" )
Private	aMotDev	:= {} //{"FALTA","AVARIA","DESACORDO C/ PEDIDO","TROCA DE MERCADORIA","EXTRAVIO TOTAL DA MERCADORIA","ACORDO COMERCIAL"}
Private cMotDev	:= ""    
Private cMsg1	:= Space(90)
Private oGet  
Private lOpc	:= .T.


For nX	:= 1 To Len(aDados)
	Aadd(aMotDev, aDados[nX][4])
Next nX


If SF1->F1_TIPO == "D"
		
	DEFINE MSDIALOG oWindow FROM 000,000 TO 240,800 TITLE Alltrim(OemToAnsi("IMPORTANTE")) Pixel Style DS_MODALFRAME
	
	oSay1  		:= TSay():New(45,10,{|| "INFORME O MOTIVO DA DEVOLUÇÃO : " },oWindow,,,,,,.T.,)
	oCombo2		:= TComboBox():New(43,115,{|u| if(PCount()>0,cMotDev:=u,cMotDev)},aMotDev,95,12,oWindow,,,/*{||ValidCpo()}*/,,,.T.,,,,,,,,,"cMotDev")
	  
	//oSayLn3		:= tSay():New(65,10,{||"OBSERVAÇÃO "},oWindow,,,,,,.T.,,,60,20)
	//oGet			:= tGet():New(63,115,{|u| if(Pcount()>0,cMsg1:=u,cMsg1) },oWindow,240,12,"@!",{||!empty(cMsg1)},,,,,,.T.,,,,,,,,,,"cMsg1",,,,,.F.,,)
	//oGet:Disable()
	
	oWindow:lEscClose	:= .F.
               
	ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,{||lOk:=.T.,AtuMotDev(),oWindow:End()},{||Iif(!Empty(cMotDev),.F.,oWindow:End())},,)	     

Endif	

Static Function ValidCpo()
If cMotDev=="OUTROS"
	oGet:Enable()
Else
	oGet:Disable()
EndIf	

oGet:Refresh()

Return(.T.)     


Static Function AtuMotDev()
//Local cNfOri	:= POSICIONE("SD1",1,xFilial("SD1")+SF1->(F1_DOC+F1_SERIE),'D1_NFORI')

Local cTes		:= POSICIONE("SD1",1,xFilial("SD1")+SF1->(F1_DOC+F1_SERIE),'D1_TES')   
Local cFinan	:= POSICIONE("SF4",1,xFilial("SF4")+cTes,'F4_DUPLIC') 

Reclock("SF1",.F.)
SF1->F1_MENNOTA	:= cMotDev //+ " " +Alltrim(cMsg1)
MsUnlock()
	
If cFinan == 'S'
	Reclock("SE1",.F.)
	SE1->E1_HIST 	:= cMotDev //+ " " +Alltrim(cMsg1)
	MsUnlock()
EndIf

//dbSelectArea("SC5")
//dbSetOrder(11)
//If dbSeek(xFilial("SC5")+cNfOri)
//	Reclock("SC5")
//SC5->C5_X_STAPV := "D"
//	MsUnlock()
//EndIf

Return()