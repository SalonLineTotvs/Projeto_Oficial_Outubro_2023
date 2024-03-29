#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"             

/*
/*���������������������������������������������������������������������������
������������������������������������������������������������������a������Ĵ��
��� Funcao   � FATP0009	 � Autor � Andr� Valmir 		� Data �28/04/2017���
�������������������������������������������������������������������������Ĵ��
���Descricao � Tela para atualiza��o da TES no pedido de vendas			  ���
���          � Com combate de Fundo de Pobreza.							  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SALON LINE                                                 ���
��������������������������������������������������������������������������ٱ�


������������������������������������������������������������������a������Ĵ��
��� 						ULTIMAS ATUALIZA��ES                           ��
�������������������������������������������������������������������������Ĵ��
��� DATA       � NOME               � HORA                                ���
���	12/09/18	 Andre Salgado 		  16:00   - Solicita��o Adelma        ���
���	21/09/18 	 Andre Salgado		  14:00   - Solicitacao Adelma        ���
���									                                      ���
��������������������������������������������������������������������������ٱ�
*/
                       
User Function FATP0009()

Private aAreaSC5	:= SC5->(getArea())
Private aAreaSC6	:= SC6->(getArea())
Private aAreaSA1	:= SA1->(getArea())
Private aAreaSF4	:= SF4->(getArea())
Private aAreaSB1	:= SB1->(getArea())

Private	oWindow
Private cGetTes		:= space(03)
Private cGetCFOP	:= space(04)                          
Private cNumPed		:= space(06)
     
DEFINE MSDIALOG oWindow FROM 000,000 TO 260,500 TITLE Alltrim(OemToAnsi("ATUALIZA��O DA TES FECP")) Pixel

oSayLn1		:= tSay():New(35,05,{||"ATUALIZA��O DA TES DE FECP"},oWindow,,,,,,.T.,CLR_RED,CLR_RED,270,40)
oSayLn3		:= tSay():New(55,05,{||"NUMERO DO PEDIDO "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(53,68,{|u| if(Pcount()>0,cNumPed:=u,cNumPed) },oWindow,40,10,"@!",{|| !empty(cNumPed)},,,,,,.T.,,,,,,,,,"SC5","cNumPed",,,,,.F.,,)
oSayLn3		:= tSay():New(75,05,{||"TES DE SAIDA "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(73,68,{|u| if(Pcount()>0,cGetTes:=u,cGetTes) },oWindow,40,10,"@!",{|| !empty(cGetTes) .AND. gatilhacpo(cGetTes) },,,,,,.T.,,,,,,,,,"SF4","cGetTes",,,,,.F.,,)
oSayLn4		:= tSay():New(95,05,{||"CFOP "},oWindow,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet2		:= tGet():New(93,68,{|u| if(Pcount()>0,cGetCFOP:=u,cGetCFOP) },oWindow,40,10,,,,,,,,.T.,,,{|u| u:=.F.},,,,,,,"cGetCFOP",,,,,.F.)

oWindow:Refresh()

ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,{||lOk:=.T.,AtuQryFEC(),oWindow:End()},{||oWindow:End()},,)

Return()
                                         
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
           

Static Function AtuQryFEC()
                                         
DBSelectArea("SC5")
DBSetOrder(1)
DBSeek(xFilial("SC5")+cNumPed)

If Found()
    

	cAtuFEC := " UPDATE "+RetSqlName("SC6")+" SET C6_TES = '"+cGetTes+"', C6_CF = '"+cGetCFOP+"' , C6_CLASFIS = B1_ORIGEM + F4_SITTRIB    	  "
	cAtuFEC += " FROM "+RetSqlName("SC6")+" C6         																				          "
	cAtuFEC += "	INNER JOIN " +RetSqlName("SB1")+" B1 WITH (NOLOCK) ON C6_PRODUTO = B1_COD AND B1.D_E_L_E_T_ = ''	                      "
	cAtuFEC += "	INNER JOIN " +RetSqlName("SF4")+" F4 WITH (NOLOCK) ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES AND F4.D_E_L_E_T_ = '' "
	cAtuFEC += "	INNER JOIN " +RetSqlName("SA1")+" A1 WITH (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ''        "
	cAtuFEC += " WHERE C6_NOTA = '' AND C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = '"+cNumPed+"'  										  "                  

//  Solicita��o Adelma para trocar a regra em 12/09/2018 - Alterado por Andre Salgado - 12/09/2018
//	cAtuFEC += " AND A1_EST IN ('PR','MG') 																									  " 
//	cAtuFEC += " AND B1_GRTRIB IN ('001','003') 																							  "
	cAtuFEC += " AND ("
	cAtuFEC += " 	(A1_EST ='PR' AND B1_GRTRIB IN ('001'))"
	cAtuFEC += " 	OR"

// CHAAMDO TK2006149 - VALDIR
	cAtuFEC += " 	(A1_EST ='MT' AND B1_GRTRIB IN ('001'))"
	cAtuFEC += " 	OR"
	
//  Solicita��o Adelma para trocar a regra em 21/09/2018 - Alterado por Andre Salgado - 21/09/2018	- regra para Devintex MG
	cAtuFEC += " 	(C6_FILIAL= '0902' AND A1_EST ='MG' AND B1_GRTRIB IN ('001'))"
	cAtuFEC += " 	OR"

	//cAtuFEC += " 	(C6_FILIAL<>'0902' AND A1_EST ='MG' AND B1_GRTRIB IN ('001','003'))" // Valmir (16/06) Conforme Chamado Valdir (TK2006088) Somente para Shampoo, NCM 3305.10.00
	cAtuFEC += " 	(C6_FILIAL<>'0902' AND A1_EST ='MG' AND B1_GRTRIB IN ('001'))"
	cAtuFEC += " 	)"	

	TcSqlExec(cAtuFEC)
	
	                                                        	
	MSGINFO("TES ATULIZADA COM SUCESSO","ATEN��O")

Else
    MSGALERT("PEDIDO DE VENDAS N�O LOCALIZADO","ATEN��O")
Endif   
                  
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aAreaSF4)
RestArea(aAreaSB1)

Return()