#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"             

/*
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATP0017	 ³ Autor ³ André Valmir 		³ Data ³22/10/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela para atualização da TES no pedido de vendas			  ³±±
±±³          ³ por produto												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE - Chamado Valdir (TK1909035)                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±


±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES                           ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA       ³ NOME               ³ HORA                                ³±±
±±³																	      ³±±
±±³																	      ³±±
±±³									                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/
                       
User Function FATP0017()

Private aAreaSC5	:= SC5->(getArea())
Private aAreaSC6	:= SC6->(getArea())
Private aAreaSA1	:= SA1->(getArea())
Private aAreaSF4	:= SF4->(getArea())
Private aAreaSB1	:= SB1->(getArea())

Private	oWindow
Private cGetTes		:= space(03)
Private cGetCFOP	:= space(04)                          
Private cNumPed		:= space(06)
Private cCodPrd		:= space(15)
     
DEFINE MSDIALOG oWindow FROM 000,000 TO 280,500 TITLE Alltrim(OemToAnsi("ATUALIZAÇÃO DA TES POR PRODUTO")) Pixel

oSayLn1		:= tSay():New(35,05,{||"ATUALIZAÇÃO DA TES POR PRODUTO"},oWindow,,,,,,.T.,CLR_RED,CLR_RED,270,40)
oSayLn3		:= tSay():New(55,05,{||"NUMERO DO PEDIDO "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(53,68,{|u| if(Pcount()>0,cNumPed:=u,cNumPed) },oWindow,40,10,"@!",{|| !empty(cNumPed)},,,,,,.T.,,,,,,,,,"SC5","cNumPed",,,,,.F.,,)

oSayLn5		:= tSay():New(75,05,{||"CODIGO PRODUTO "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(73,68,{|u| if(Pcount()>0,cCodPrd:=u,cCodPrd) },oWindow,40,10,"@!",{|| !empty(cNumPed)},,,,,,.T.,,,,,,,,,,"cCodPrd",,,,,.F.,,)
	
oSayLn3		:= tSay():New(95,05,{||"TES DE SAIDA "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(93,68,{|u| if(Pcount()>0,cGetTes:=u,cGetTes) },oWindow,40,10,"@!",{|| !empty(cGetTes) .AND. gatilhacpo(cGetTes) },,,,,,.T.,,,,,,,,,"SF4","cGetTes",,,,,.F.,,)

oSayLn4		:= tSay():New(115,05,{||"CFOP "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet2		:= tGet():New(113,68,{|u| if(Pcount()>0,cGetCFOP:=u,cGetCFOP) },oWindow,40,10,,,,,,,,.T.,,,{|u| u:=.F.},,,,,,,"cGetCFOP",,,,,.F.)

oWindow:Refresh()

ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,{||lOk:=.T.,AtuQryPrd(),oWindow:End()},{||oWindow:End()},,)
                                         
Static Function gatilhacpo(cGetTes)

cCFOP 		:= Posicione("SF4",1,xFilial("SF4")+cGetTes,"F4_CF")

DBSelectArea("SC5")
DBSetOrder(1)
DBSeek(xFilial("SC5")+cNumPed)  

cEst		:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") 
cFil 		:= FWCodFil()

If alltrim(SM0->M0_CODFIL)+SM0->M0_ESTCOB == cFil+cEst
    cSigla := "5"
Else
	cSigla := "6"
Endif

cGetCFOP := cSigla+SubStr(cCFOP,2,4)

Return()
           

Static Function AtuQryPrd() 

cSB1Or		:= Posicione("SB1",1,xFilial("SB1")+cCodPrd,"B1_ORIGEM")   
cSF4Or		:= Posicione("SF4",1,xFilial("SF4")+cGetTes,"F4_SITTRIB")  

cNewOri		:= cSB1Or + cSF4Or 
                                         
DBSelectArea("SC6")
DBSetOrder(2)
DBSeek(xFilial("SC6")+Padr(cCodPrd,15)+cNumPed)

If Found()
      
	cAtuPrd := " UPDATE "+RetSqlName("SC6")+" SET C6_TES = '"+cGetTes+"', C6_CF = '"+cGetCFOP+"' , C6_CLASFIS = '"+cNewOri+"'				  "
	cAtuPrd += " FROM "+RetSqlName("SC6")+" C6         																				          "
	cAtuPrd += "	INNER JOIN " +RetSqlName("SB1")+" B1 WITH (NOLOCK) ON C6_PRODUTO = B1_COD AND B1.D_E_L_E_T_ = ''	                      "
	cAtuPrd += "	INNER JOIN " +RetSqlName("SF4")+" F4 WITH (NOLOCK) ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES AND F4.D_E_L_E_T_ = '' "
	cAtuPrd += "	INNER JOIN " +RetSqlName("SA1")+" A1 WITH (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ''        "
	cAtuPrd += " WHERE C6.D_E_L_E_T_ = '' AND C6_NOTA = '' AND C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = '"+cNumPed+"' AND C6_PRODUTO = '"+cCodPrd+"' 		  "                  

	TcSqlExec(cAtuPrd)
	                                                        	
	MSGINFO("TES ATULIZADA COM SUCESSO","ATENÇÃO")

Else
    MSGALERT("PEDIDO DE VENDAS OU PRODUTO NÃO LOCALIZADO","ATENÇÃO")
Endif   
                  
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aAreaSF4)
RestArea(aAreaSB1)

Return()