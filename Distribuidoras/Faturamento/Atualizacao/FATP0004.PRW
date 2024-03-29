#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"             

/*

/*���������������������������������������������������������������������������
������������������������������������������������������������������a������Ĵ��
��� Funcao   � UPDTES	 � Autor � Andr� Valmir 		� Data �28/04/2017���
�������������������������������������������������������������������������Ĵ��
���Descricao � Tela para atualiza��o da TES no pedido de vendas			  ���
���          � 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SALON LINE                                                 ���
��������������������������������������������������������������������������ٱ�


������������������������������������������������������������������a������Ĵ��
��� 						ULTIMAS ATUALIZA��ES                           ��
�������������������������������������������������������������������������Ĵ��
��� DATA       � NOME               � HORA                                ���
��� 29/04/18     ANDRE VALMIR		  15:30				  				  ���
���									                                      ���
���									                                      ���
��������������������������������������������������������������������������ٱ�
*/
                       
User Function FATP0004()

Private	oWindow
Private cGetTes		:= space(03)
Private cGetCFOP	:= space(04)                          
Private cNumPed		:= space(06)
     
DEFINE MSDIALOG oWindow FROM 000,000 TO 260,500 TITLE Alltrim(OemToAnsi("ATUALIZA��O DA TES")) Pixel

oSayLn1		:= tSay():New(35,05,{||"ATUALIZA��O DA TES"},oWindow,,,,,,.T.,CLR_RED,CLR_RED,270,40)
oSayLn3		:= tSay():New(55,05,{||"NUMERO DO PEDIDO "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(53,68,{|u| if(Pcount()>0,cNumPed:=u,cNumPed) },oWindow,40,10,"@!",{|| !empty(cNumPed)},,,,,,.T.,,,,,,,,,"SC5","cNumPed",,,,,.F.,,)
oSayLn3		:= tSay():New(75,05,{||"TES DE SAIDA "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(73,68,{|u| if(Pcount()>0,cGetTes:=u,cGetTes) },oWindow,40,10,"@!",{|| !empty(cGetTes) .AND. gatilhacpo(cGetTes) },,,,,,.T.,,,,,,,,,"SF4","cGetTes",,,,,.F.,,)
oSayLn4		:= tSay():New(95,05,{||"CFOP "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet2		:= tGet():New(93,68,{|u| if(Pcount()>0,cGetCFOP:=u,cGetCFOP) },oWindow,40,10,,,,,,,,.T.,,,{|u| u:=.F.},,,,,,,"cGetCFOP",,,,,.F.)

oWindow:Refresh()

ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,{||lOk:=.T.,AtuQry(),oWindow:End()},{||oWindow:End()},,)
                                         
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
           

Static Function AtuQry()
                                         
DBSelectArea("SC5")
DBSetOrder(1)
DBSeek(xFilial("SC5")+cNumPed)

If Found()

	cAtuSC6 := " UPDATE "+RetSqlName("SC6")+" SET C6_TES = '"+cGetTes+"', C6_CF = '"+cGetCFOP+"' , C6_CLASFIS = B1_ORIGEM + F4_SITTRIB    "
	cAtuSC6 += " FROM "+RetSqlName("SC6")	"
	cAtuSC6 += "	INNER JOIN " +RetSqlName("SB1")+" B1 ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ''	"
	cAtuSC6 += "	INNER JOIN " +RetSqlName("SF4")+" F4 ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = '"+cGetTes+"' AND F4.D_E_L_E_T_ = '' "
	cAtuSC6 += " WHERE  C6_NOTA = '' AND C6_FILIAL = '"+xFilial("SC6")+"'  AND C6_NUM = '"+cNumPed+"' "
	
	TcSqlExec(cAtuSC6)
	
	
	MSGINFO("TES ATULIZADA COM SUCESSO","ATEN��O")

Else
    MSGALERT("PEDIDO DE VENDAS N�O LOCALIZADO","ATEN��O")
Endif

Return()