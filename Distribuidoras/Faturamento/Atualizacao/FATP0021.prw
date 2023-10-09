//Ultima revisão - 25/01/2022
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

#Define STR_ENTER			Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATP0010 ³ Autor ³ André Valmir 		³ Data ³02/08/2018    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela Mota Onda   										  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      			  		   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	  ³±±
±±³	26/09/18	ANDRE VALMIR			 								  ³±±
±±³	13/11/18	ANDRE VALMIR		11:45 ADICIONADO ONDA LOGISTICA   	  ³±±
±±³ 																	  ³±±
±±³ 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function FATP0021()

Private oWindow
Private oOK 	:= LoadBitmap(GetResources(),'br_verde')
Private oNO 	:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias	:= GetNextAlias()
Private oFont 	:= TFont():New('Courier new',,-14,.F.,.T.)
Private oFont1	:= TFont():New('Courier new',,-20,.F.,.T.)
Private oFont2	:= TFont():New('Courier new',,-18,.F.,.T.)
Private oFont3	:= TFont():New('Courier new',,-15,.F.,.T.)
Private oFont4	:= TFont():New('Courier new',,-24,.F.,.T.)
Private cGet1	:= Space(6)
Private dGet1	:= DDATABASE
Private dGet2	:= DDATABASE
Private aCombo	:= {"SIM","NAO","AMBOS"}
Private aCombo1	:= {"1-Acao de Venda","2-Direito por conta de grandes compras","3-Trade","4-Mkt","5-Relacionamento","6-Troca de Mercadoria","7-Troca de Nota"}
Private aBrowse	:= {}
Private aAntec	:= {"SIM","NAO"}
Private cAntec	:= ""
Private oGet
Private lLibAnt
Private lupdarmz :=.F. // variavel logica para atualizar armazens
Private lupdativa:=.F. // variavel logica para integrar a separação na ATIVA
Private lLibera :=.T.  // variavel logica para liberar pedido/itens  para armazem 95 caso tenha saldo
Private cUserLib := RetCodUsr()
Private cNomUser := USRRETNAME(RetCodUsr())
Private cDescMot:= Space(200)
Private cCliSel	 := ""
Private cPedido	 := ""
Private cProduto := ""
Private cLocal	 := ""
Private nQuant	 := ""	
Private nvalc6  :=0 
Private nvalc62  :=0
Private nvalc63 :=0
Private nreserva  :=0
Private aPedSel	 := {}
Private aPV	     := {}
Private aPvSel   := {}
Private aSaldos  := {}
Private aPedmail := {}

//Tela Inicial
TELAINIC()

Return()



Static Function TELAINIC() 

If Len(aBrowse) == 0
	aAdd(aBrowse,{.T.,CTOD(" / / "),SPACE(08),SPACE(08),SPACE(08),SPACE(10),SPACE(08),CTOD(" / / "),SPACE(08),SPACE(08)})
Endif

DEFINE MSDIALOG oWindow FROM 38,16 TO 600,1000 TITLE Alltrim(OemToAnsi("..MONTA ONDA ZAKAT"+" - ULTIMA ATUALIZAÇÃO DO ESTOQUE "+ALLTRIM(GETMV("ES_FATP011")))) Pixel

cAmbos		:= aCombo[3]

@ 002, 005 To 058, 485 Label Of oWindow Pixel

lLibAnt 	:= GETMV("ES_FATR001")

If lLibAnt
	cAntec		:= aAntec[1]
Else
	cAntec		:= aAntec[2]
Endif

oSay1  	:= TSay():New(009,010,{|| "DATA DA ONDA: " },oWindow,,oFont,,,,.T.,)
@ 008,080 Get dGet1 picture "@D" size 44.5,10 OF oWindow PIXEL

oSay2  	:= TSay():New(009,130,{|| "A" },oWindow,,oFont,,,,.T.,)
@ 008,140 Get dGet2 picture "@D" size 44.5,10 OF oWindow PIXEL

oSay3  	:= TSay():New(029,010,{|| "N° DA ONDA: " },oWindow,,oFont,,,,.T.,)
@ 028,080 Get cGet1 picture "@E 999999999" size 44.5,10 OF oWindow PIXEL

oSay4  	:= TSay():New(046,010,{|| "IMPRESSO:" },oWindow,,oFont,,,,.T.,)
oCombo1	:= TComboBox():New(45,080,{|u| if(PCount()>0,cAmbos:=u,cAmbos)},aCombo,44.5,12,oWindow,,,,,,.T.,,,,,,,,,"cAmbos")

@ 028,140 Button "PESQUISAR"  size 44.4,27 action Processa( {|| PesqOnda()}, "AGUARDE...", "PESQUISANDO...") OF oWindow PIXEL

oSay5  	:= TSay():New(010,220,{|| "ANTECIPADO?" },oWindow,,oFont,,,,.T.,)
oCombo2	:= TComboBox():New(009,270,{|u| if(PCount()>0,cAntec:=u,cAntec)},aAntec,44.5,12,oWindow,,,,,,.T.,,,,{|u| u := Iif(lLibAnt,.T.,.F.) },,,,,"cAntec")

If cUserLib $ GETMV("ES_USUANTC")
	If lLibAnt
		@ 028,220 Button "BLOQUEAR" size 45,12 action Processa( {|| AtuESFATR() }) OF oWindow PIXEL
	Else
		@ 028,220 Button "DESBLOQUEAR" size 45,12 action Processa( {|| AtuESFATR() }) OF oWindow PIXEL
	Endif
		                                                                           
	@ 043,220 Button "ATUAL. EST." size 45,12 action Processa( {|| U_FATP0011(.F.) }) OF oWindow PIXEL
		
Endif                                 

// ||| COLOCAR EM PRODUÇÃO - MELHORIA (VALMIR - 17/09/2018)
//========================================================================================================================//
// 	Tela para visualizar Pedidos não liberado saldo Estoque																  //
//========================================================================================================================//
@ 028,270 Button "PV'S PENDENTES" size 45,12 action Processa( {|| VisPend() }) OF oWindow PIXEL
//========================================================================================================================//
// 	Tela para visualizar Pedidos não liberado saldo Estoque																  //
//========================================================================================================================//

@ 008,360 Button "INCLUIR" size 57,12 action Processa( {|| IncOnda() }) OF oWindow PIXEL
@ 008,420 Button "PROGRAMAR" size 57,12 action Processa( {|| PgrOnda() }) OF oWindow PIXEL
@ 025,360 Button "ORDEM SEPARACAO" size 57,12 action Processa( {|| ImpOnda() }) OF oWindow PIXEL
//@ 025,420 Button "ENVIA LOGISTICA"  size 57,12 action Processa( {|| U_WB_LOG001() }) OF oWindow PIXEL
@ 042,360 Button "REL. PRODUÇÃO" size 57,12 action Processa( {|| RelOnda3() }) OF oWindow PIXEL
@ 042,420 Button "FECHAR"  size 57,12 action oWindow:End() OF oWindow PIXEL

// rogerio silva 23052022
//@ 042,270 Button "ORDEM SEPARACAO(2)" size 57,12 action Processa( {|| u_FATR0001(cGet1) }) OF oWindow PIXEL

//@ 014,360 Button "EXCLUIR" size 55,12 action Processa( {|| ExcOnda() }, "AGUARDE EXCLUINDO...") OF oWindow PIXEL

oListBox	:= twBrowse():New(059,005,480,215,,{" ","DATA","NUMERO","HORA","USUARIO","IMPRESSO","VALOR","DATA IMPR.","HORA IMPR.","USUARIO IMPR."},{10,25,30,20,20,40,40,35,35,20},oWindow,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

oListBox:SetArray(aBrowse)
oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;    //Flag
aBrowse[oListBox:nAt,02],;	// Data
aBrowse[oListBox:nAt,03],;	// Numero
aBrowse[oListBox:nAt,04],;	// Hora
aBrowse[oListBox:nAt,05],;	// Usuario
aBrowse[oListBox:nAt,06],;	// Impressao
aBrowse[oListBox:nAt,07],;  // Valor
aBrowse[oListBox:nAt,08],;	// Data Impressao
aBrowse[oListBox:nAt,09],;	// Hora Impressao
aBrowse[oListBox:nAt,10]}} // Usuario Imprimiu
//aBrowse[oListBox:nAt,11]}}  //observacao
//}}  // Usuario Imprimiu

//========================================================================================================================//
// 	Tela para visualizar Pedidos da Onda																				  //
//========================================================================================================================//
oListBox:bLDblClick := {|| VisualPV() }  


oWindow:Refresh()
oListBox:Refresh()

ACTIVATE MSDIALOG oWindow centered

Return()



//BOTÃO PESQUISAR
Static Function PesqOnda()

Local cQrySZ4 := ""
aBrowse	:= {}

If Select("TRBSZ4") > 0
	TRBSZ4->( dbCloseArea() )
EndIf

//Busca Dados para Pesquisa - SZ4 Pedidos em Carteira
cQrySZ4 :=	" SELECT Z4_DTEMISS, Z4_NUMONDA, Z4_HORA, Z4_USUARIO, "
cQrySZ4 +=	" CASE WHEN Z4_IMPRESS = '1' THEN 'SIM' ELSE 'NAO' END Z4_IMPRESS,
cQrySZ4 +=	" Z4_VALOR, Z4_DTIMPRE, Z4_HRIMPRE, Z4_USUIMPR"
cQrySZ4 +=	" FROM "+RETSQLNAME("SZ4")+" WITH (NOLOCK) "
cQrySZ4 +=	" WHERE D_E_L_E_T_ = ''	AND Z4_TIPO = 'N' "

If !Empty(dGet1) .and. !Empty(dGet2)
	cQrySZ4 +=	" AND Z4_DTEMISS BETWEEN '"+dtos(dGet1)+"' AND '"+dtos(dGet2)+"' "
Endif

If !Empty(cGet1)
	cQrySZ4 +=	" AND Z4_NUMONDA = '"+cGet1+"' "
Endif

If cAmbos == 'SIM'
	cQrySZ4 +=	" AND Z4_IMPRESS = '1' "
ElseIf cAmbos == 'NAO'
	cQrySZ4 +=	" AND Z4_IMPRESS = '2' "
Else
	cQrySZ4 +=	" AND Z4_IMPRESS IN ('1','2') "
Endif

TCQUERY cQrySZ4 NEW ALIAS "TRBSZ4"

dbSelectArea("TRBSZ4")
TRBSZ4->(dbGoTop())

While TRBSZ4->(!EOF())   
    
	If TRBSZ4->Z4_IMPRESS == 'NAO'	
		lImp := .F.
	Else
		lImp := .T.
	Endif
	 
	aAdd(aBrowse,{lImp,;
	STOD(TRBSZ4->Z4_DTEMISS),;
	TRBSZ4->Z4_NUMONDA,;
	TRBSZ4->Z4_HORA,;
	TRBSZ4->Z4_USUARIO,;
	TRBSZ4->Z4_IMPRESS,;
	Transform(TRBSZ4->Z4_VALOR,"@E 999,999,999.99"),;
	STOD(TRBSZ4->Z4_DTIMPRE),;
	TRBSZ4->Z4_HRIMPRE,;
	TRBSZ4->Z4_USUIMPR })
	
	TRBSZ4->(dbSkip())
Enddo

oListBox:SetArray(aBrowse)
oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
aBrowse[oListBox:nAt,02],;
aBrowse[oListBox:nAt,03],;
aBrowse[oListBox:nAt,04],;
aBrowse[oListBox:nAt,05],;
aBrowse[oListBox:nAt,06],;
aBrowse[oListBox:nAt,07],;
aBrowse[oListBox:nAt,08],;
aBrowse[oListBox:nAt,09],;
aBrowse[oListBox:nAt,10] }}
oWindow:Refresh()

Return()



//****************************************************
//BOTÃO INCLUR
//****************************************************
Static Function IncOnda()


Local cQuery 		:= ""
Local nCnt
Local nSomaPar := 0
Local oButton2   //

Private oOK 		:= LoadBitmap(GetResources(),'br_verde')
Private oNO 		:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias		:= GetNextAlias()
Private oFont 		:= TFont():New('Courier new',,-14,.F.,.T.)
Private cFilial		:= Space(4)
Private cNumPV		:= Space(6)
Private cClie		:= Space(6)
Private cVend		:= Space(6)
Private aRetDados 	:= {}
Private aBrwPV		:= {}
Private cNRonda 	:= ""
Private oGet1

Private oGet
Private oFiltro
Private oTelPV
Private aOrdem		:= {"PRIORIDADE","PEDIDO","VALOR"}
Private cVip
Private cOrdem    
Private cCliDe		:= space(6)
Private cCliAte		:= "ZZZZZZ"
Private dDtDE		:= ctod("  /  /  ")	
Private dDtATE		:= ddatabase		
Private cCliGerDe	:= space(6)
Private cCliGerAt	:= "ZZZZZZ"
Private nValorOnda	:= 3000000
Private dProgram	:= ctod("  /  /  ")	
Private xFilial	:="ZZZZZZZZZZZZZZZZZZZZ" //space(20)
Private cUf	:= "ZZZZZZZZZZZZZZZZZZZZ"   //space(20)	
Private xFilial2:=""
Private cUf2 := ""
//Private afiliais	:= {"CIMEX","CROZE","KOPEK","MACO","QUBIT","ROJA","VIXEN","MAIZE","DEVINTEX FILIAL","DEVINTEX FILIAL-MG","GLAZY","BIZEZ","ZAKAT","HEXIL","TROLL"}
Private afiliais	:= {"ZAKAT"}

// cQuery +=	" WHEN '0101' THEN 'CIMEX'       "
// cQuery +=	" WHEN '0201' THEN 'CROZE'       "
// cQuery +=	" WHEN '0301' THEN 'KOPEK'       "
// cQuery +=	" WHEN '0401' THEN 'MACO '       "
// cQuery +=	" WHEN '0501' THEN 'QUBIT'       "
// cQuery +=	" WHEN '0601' THEN 'ROJA '       "
// cQuery +=	" WHEN '0701' THEN 'VIXEN'       "
// cQuery +=	" WHEN '0801' THEN 'MAIZE'       "
// cQuery +=	" WHEN '0901' THEN 'DEVINTEX FILIAL'  "
// cQuery +=	" WHEN '0902' THEN 'DEVINTEX FILIAL - MG' " 
// cQuery +=	" WHEN '1001' THEN 'GLAZY' "
// cQuery +=	" WHEN '1101' THEN 'BIZEZ' "
cQuery +=	" WHEN '1201' THEN 'ZAKAT' "
// cQuery +=	" WHEN '1301' THEN 'HEXIL' "
// cQuery +=	" WHEN '1401' THEN 'TROLL' "

Private nQtdVOL	:= 0
Private nSomaB		:= 0
Private nQtdSku		:= 0
Private nValor		:= 0
Private nPedSel		:= 0
Private nValVend1	:= 0
Private nValVend2	:= 0
Private nValVend3	:= 0
Private nValVend4	:= 0
Private nValVend5	:= 0
Private nValVend6	:= 0
Private nValVend7	:= 0
Private nValVend8	:= 0
Private nValVendO	:= 0

Private nValPerc1	:= 0
Private nValPerc2	:= 0
Private nValPerc3	:= 0
Private nValPerc4	:= 0
Private nValPerc5	:= 0
Private nValPerc6	:= 0
Private nValPerc7	:= 0
Private nValPerc8	:= 0
Private nValPercO	:= 0

Private cPvAnt	:= "" // Verifica se o pedido é antecipado

If Select("TRBSC5") > 0
	TRBSC5->( dbCloseArea() )
EndIf

DEFINE MSDIALOG oFiltro FROM 000,000 TO 380,400 TITLE Alltrim(OemToAnsi("FILTRO MONTA ONDA")) Pixel

cOrdem		:= aOrdem[1]
xfilial     :=afiliais[1]
oSayLn1		:= tSay():New(0006,0005,{||"APRESENTAR POR?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oComboORD	:= TComboBox():New(0005,0080,{|u| if(PCount()>0,cOrdem:=u,cOrdem)},aOrdem,50,08,oFiltro,,,,,,.T.,,,,,,,,,"cOrdem")

oSayLn2		:= tSay():New(0018,0005,{||"CLIENTE DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(0018,0080,{|u| if(Pcount()>0,cCliDe:=u,cCliDe) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliDe",,,,,.F.)

oSayLn3		:= tSay():New(0031,0005,{||"CLIENTE ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet2		:= tGet():New(0031,0080,{|u| if(Pcount()>0,cCliAte:=u,cCliAte) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliAte",,,,,.F.)

oSayLn4		:= tSay():New(0044,0005,{||"DATA DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet4		:= tGet():New(0044,0080,{|u| if(Pcount()>0,dDtDE:=u,dDtDE) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"dDtDE",,,,,.F.)

oSayLn5		:= tSay():New(0057,0005,{||"DATA ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet5		:= tGet():New(0057,0080,{|u| if(Pcount()>0,dDtATE:=u,dDtATE) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"dDtATE",,,,,.F.)  
                                                                                                                                 
oSayLn6		:= tSay():New(0070,0005,{||"GERENTE DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0070,0080,{|u| if(Pcount()>0,cCliGerDe:=u,cCliGerDe) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliGerDe",,,,,.F.)

oSayLn7		:= tSay():New(0083,0005,{||"GERENTE ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0083,0080,{|u| if(Pcount()>0,cCliGerAt:=u,cCliGerAt) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliGerAt",,,,,.F.)

oSayLn8		:= tSay():New(0096,0005,{||"VALOR ONDA?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0096,0080,{|u| if(Pcount()>0,nValorOnda:=u,nValorOnda) },oFiltro,30,08,,,,,,,,.T.,,,,,,,,,,"nValorOnda",,,,,.F.)

oSayLn9		:= tSay():New(0109,0005,{||"PROGRAMAÇÃO?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet9		:= tGet():New(0109,0080,{|u| if(Pcount()>0,dProgram:=u,dProgram) },oFiltro,30,08,,,,,,,,.T.,,,,,,,,,,"dProgram",,,,,.F.)

oSayLn13		:= tSay():New(0122,0005,{||"FILIAL?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oComboORD2	:= TComboBox():New(0122,0080,{|u| if(Pcount()>0,xfilial:=u,xfilial) },afiliais,60,12,oFiltro,,,,,,.T.,,,,,,,,,"xfilial")

oSayLn9		:= tSay():New(0135,0005,{||"UF?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet9		:= tGet():New(0135,0080,{|u| if(Pcount()>0,cUf:=u,Cuf) },oFiltro,60,08,,,,,,,,.T.,,,,,,,,,,"cUf",,,,,.F.)

//oSayLn8		:= tSay():New(0135,0005,{||"VALOR ONDA?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)//
//oGet6		:= tGet():New(0135,0080,{|u| if(Pcount()>0,nValorOnda:=u,nValorOnda) },oFiltro,30,08,,,,,,,,.T.,,,,,,,,,,"nValorOnda",,,,,.F.)

@ 0160, 0080 BmpButton Type 01 Action Close(oFiltro)
@ 0160, 0110 BmpButton Type 02 Action oFiltro:END()

Activate Dialog oFiltro Centered

// if xfilial== "CIMEX"
// xfilial:="0101"
// elseif xfilial== "CROZE"
// xfilial:="0201"
// elseif xfilial== "KOPEK"
// xfilial:="0301"
// elseif xfilial== "MACO"
// xfilial:="0401"
// elseif xfilial== "QUBIT"
// xfilial:="0501"
// elseif xfilial== "ROJA"
// xfilial:="0601"
// elseif xfilial== "VIXEN"
// xfilial:="0701"
// elseif xfilial== "MAIZE"
// xfilial:="0801"
// elseif xfilial== "DEVINTEX FILIAL"
// xfilial:="0901"
// elseif xfilial== "DEVINTEX FILIAL-MG"
// xfilial:="0902"
// elseif xfilial== "GLAZY"
// xfilial:="1001"
// elseif xfilial== "BIZEZ"
// xfilial:="1101"
if xfilial== "ZAKAT"
xfilial:="1201"
endif
// elseif xfilial== "HEXIL"
// xfilial:="1301"
// elseif xfilial== "TROLL"
// xfilial:="1401"
//endif

     
cQuery :=	" SELECT C5_FILIAL, CASE C5_FILIAL "
cQuery +=	" WHEN '0101' THEN 'CIMEX'       "
cQuery +=	" WHEN '0201' THEN 'CROZE'       "
cQuery +=	" WHEN '0301' THEN 'KOPEK'       "
cQuery +=	" WHEN '0401' THEN 'MACO '       "
cQuery +=	" WHEN '0501' THEN 'QUBIT'       "
cQuery +=	" WHEN '0601' THEN 'ROJA '       "
cQuery +=	" WHEN '0701' THEN 'VIXEN'       "
cQuery +=	" WHEN '0801' THEN 'MAIZE'       "
cQuery +=	" WHEN '0901' THEN 'DEVINTEX FILIAL'  "
cQuery +=	" WHEN '0902' THEN 'DEVINTEX FILIAL - MG' " 
cQuery +=	" WHEN '1001' THEN 'GLAZY' "
cQuery +=	" WHEN '1101' THEN 'BIZEZ' "
cQuery +=	" WHEN '1201' THEN 'ZAKAT' "
cQuery +=	" WHEN '1301' THEN 'HEXIL' "
cQuery +=	" WHEN '1401' THEN 'TROLL' "
cQuery +=	" END EMPRESA, 
cQuery +=	" C5_X_FLAG, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A3_GEREN, A3_NREDUZ,
cQuery +=	" MAX(GRANEL) GRANEL, ROUND(SUM(VALOR),2) VALOR, COUNT(*) SKU, TPPV, "
cQuery +=	" C5_CLIENTE, C5_LOJACLI, TRAVAPV, "
cQuery +=	" A1_EST, "
cQuery +=	" ROUND(SUM(VOLUME),2) VOLUME, "
cQuery +=	" ROUND(SUM(PESO_BRU),2) PESO_BRU, "
cQuery +=	" ROUND(SUM(PESO_LIQ),2) PESO_LIQ, "
cQuery +=	" A4_NREDUZ "
cQuery +=	" FROM (  "
cQuery +=	" SELECT  C5_FILIAL, C5_X_FLAG, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A31.A3_GEREN, A32.A3_NREDUZ, C6_PRODUTO,C9_BLCRED, "
cQuery +=	"  IIF(CAST(C6_QTDVEN AS INT) % CAST(IIF(B1.B1_QE = 0,6,B1.B1_QE) AS INT) > 0,'SIM','') GRANEL, C6_VALOR VALOR "
cQuery +=	"  ,CASE WHEN F4_DUPLIC='S' THEN 'VENDA' WHEN F4_TEXTO LIKE '%TROCA%' THEN 'TROCA' ELSE 'BONIF' END TPPV, C5_CLIENTE, C5_LOJACLI"
cQuery +=	"  ,CASE WHEN BON>0 AND VEN=0 THEN 'B' WHEN BON>0 AND VEN>0 THEN 'L' ELSE ' ' END TRAVAPV, "
cQuery +=	" A1_EST,  (C6_QTDVEN / IIF(B1_QE = 0,1,B1_QE))  VOLUME,C6_QTDVEN * B1_PESBRU PESO_BRU, C6_QTDVEN * B1_PESO PESO_LIQ, A4_NREDUZ "
cQuery +=	" FROM SC5020 C5 WITH (NOLOCK) "
//cQuery +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_='' " 
cQuery +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_='' AND C6_LOCAL ='95' " //apenas armazem 95
cQuery +=	" INNER JOIN SC9020 C9 WITH (NOLOCK) ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_=''  "
cQuery +=	" INNER JOIN SA1020 A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI 
		IF alltrim(cUF)<>"ZZZZZZZZZZZZZZZZZZZZ"
			cuf2:=""
			For nCnt := 0 To Len(alltrim(cUF)) Step 2
				if nCnt<>0 .and. (nCnt< Len(alltrim(cUF)))
				nx:=ncnt-1
				cuf2 += substr(cUf,nx,2)+"','" 
				endif

				if nCnt<>0 .and. (nCnt== Len(alltrim(cUF)))
				nx:=ncnt-1
				cuf2 += substr(cUf,nx,2)
				endif

				//nSomaPar += nCnt

			Next

		cQuery +=	" and A1_EST in ('"+cUF2+"') "
		endif
cQuery +=	" AND A1.D_E_L_E_T_=''   "
cQuery +=	" INNER JOIN SB1020 B1 WITH (NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.B1_FILIAL = '    ' AND B1.D_E_L_E_T_ = ''  " 
cQuery +=	" INNER JOIN SF4020 F4 WITH (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES=F4_CODIGO AND F4.D_E_L_E_T_ = '' " 
cQuery +=	" INNER JOIN SA4020 A4 WITH (NOLOCK) ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''  "
cQuery +=	" LEFT JOIN SA3020 A31 WITH (NOLOCK) ON A31.A3_COD = C5_VEND1 AND A31.D_E_L_E_T_ = '' "
cQuery +=	" LEFT JOIN SA3020 A32 WITH (NOLOCK) ON A32.A3_COD = A31.A3_GEREN AND A32.D_E_L_E_T_ = '' "

//Valida Bonificação 
cQuery +=	" INNER JOIN ("
cQuery +=	" SELECT XFIL, XCLI, SUM(BON) BON, SUM(VEN) VEN FROM("
cQuery +=	" SELECT C5_FILIAL XFIL, C5_CLIENTE+C5_LOJACLI XCLI, "
cQuery +=	" CASE WHEN  C5_CONDPAG IN('057','177') THEN 1 ELSE 0 END BON,"
cQuery +=	" CASE WHEN  C5_CONDPAG NOT IN('057','177') THEN 1 ELSE 0 END VEN"
cQuery +=	" FROM SC5020 C5"
cQuery +=	" WHERE C5.D_E_L_E_T_=''"
cQuery +=	" AND C5_EMISSAO>='20211101'"
cQuery +=	" AND C5_X_NONDA = ''"
cQuery +=	" AND C5_LIBEROK = 'S'"
cQuery +=	" AND C5_TIPO = 'N'"
cQuery +=	" AND C5_X_STAPV = '0'"
cQuery +=	" AND C5_NOTA = ''"
cQuery +=	" AND C5_CLIENTE BETWEEN '"+cCliDe+"' 		AND '"+cCliAte+"' "
cQuery +=	" AND C5_EMISSAO BETWEEN '"+DTOS(dDtDE)+"'	AND '"+DTOS(dDtATE)+"' "
	// if alltrim(Xfilial) <>"ZZZZZZZZZZZZZZZZZZZZ"
	// 			For nCnt := 0 To Len(alltrim(xfilial)) Step 4
	// 				if nCnt<>0 .and. (nCnt< Len(alltrim(xfilial)))
	// 				nx:=ncnt-3
	// 				xfilial2 += substr(xfilial,nx,4)+"','" 
	// 				endif

	// 				if nCnt<>0 .and. (nCnt== Len(alltrim(xfilial)))
	// 				nx:=ncnt-3
	// 				xfilial2 += substr(xfilial,nx,4)
	// 				endif

	// 				//nSomaPar += nCnt////////

	// 			Next
				//xfilial:=substr(xfilial,1,4)+"','"+substr(xfilial,6,4)+"','"+substr(xfilial,11,4) //
cQuery +=	" AND C5_FILIAL in ('"+xfilial+"') "
//	endif
cQuery +=	" AND C5_X_DTOLO = '"+DTOS(dProgram)+"' ) TOTALPV"
cQuery +=	" GROUP BY XFIL, XCLI"
cQuery +=	" )TOTPV ON C5_FILIAL=XFIL AND C5_CLIENTE+C5_LOJACLI=XCLI"
//end
cQuery +=	" WHERE C5.D_E_L_E_T_=''  "
cQuery +=	" AND C5_EMISSAO>='20211101'"
cQuery +=	" AND C5_X_NONDA = '' AND C5_LIBEROK = 'S' "
cQuery +=	" AND C5_TIPO = 'N' AND C5_X_STAPV = '0' AND C5_NOTA = ''  "
cQuery +=	" AND C5_CLIENTE BETWEEN '"+cCliDe+"' 		AND '"+cCliAte+"' "
cQuery +=	" AND C5_EMISSAO BETWEEN '"+DTOS(dDtDE)+"'	AND '"+DTOS(dDtATE)+"' "
cQuery +=	" AND A31.A3_GEREN BETWEEN '"+cCliGerDe+"'	AND '"+cCliGerAt+"' "
//if alltrim(Xfilial) <>"ZZZZZZZZZZZZZZZZZZZZ"
cQuery +=	" AND C5_FILIAL in ('"+xfilial+"') "
//endif
cQuery +=	" AND C5_X_DTOLO = '"+DTOS(dProgram)+"'	

IF alltrim(__cUserId)='000859' // WINTER $ GETMV("ES_FATP12R")
	cQuery +=	" AND A1_SATIV1 = '000010' "	
endif

//If cAntec == "SIM"  
//cQuery +=	" AND C6_X_ESTOQ = 'S' " //FILTRA SÓ PRODUTOS COM ESTOQUE
//Endif
cQuery +=	" ) X  "
cQuery +=	" GROUP BY C5_FILIAL, C5_X_FLAG, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A3_GEREN,"
cQuery +=	" TRAVAPV,A3_NREDUZ, TPPV,A4_NREDUZ, C5_CLIENTE, C5_LOJACLI,A1_EST "
cQuery +=	" HAVING SUM(CAST(C9_BLCRED AS INT)) = 0 "

//Ordem de Apresentação do RELATORIO
If cOrdem == "PRIORIDADE"
	cQuery +=	" ORDER BY A1_X_PRIOR, IIF(C5_X_SONLG = '', 'ZZZZ', C5_X_SONLG), A1_NOME, C5_EMISSAO, TPPV,A1_EST "

ElseIf cOrdem == "VALOR"
	cQuery +=	" ORDER BY VALOR DESC "

Else
	cQuery +=	" ORDER BY C5_FILIAL, C5_NUM"    
Endif

MemoWrit("C:\Temp\Log_PROC_INV_.TXT",cQuery)


TCQUERY cQuery NEW ALIAS "TRBSC5"

//Processa o Resultado
dbSelectArea("TRBSC5")
TRBSC5->(dbGoTop())


//regra do Pedido Antecipado
If cAntec == "SIM"
	
	While TRBSC5->(!EOF())
		aAdd(aBrwPV,{IF(ALLTRIM(TRBSC5->C5_X_FLAG) = 'F', .T., .F.)	,;
		TRBSC5->C5_FILIAL,;
		TRBSC5->C5_NUM,;
		TRBSC5->A1_NOME,;
		TRBSC5->A3_GEREN+" "+TRBSC5->A3_NREDUZ,;
		TRBSC5->A1_X_PRIOR,;
		TRBSC5->C5_X_SONLG,;
		TRBSC5->VALOR,;
		TRBSC5->SKU,;
		TRBSC5->GRANEL,;
		0,;
		"SIM",;
		TRBSC5->TPPV,;
		TRBSC5->C5_CLIENTE,;
		TRBSC5->C5_LOJACLI,;
			TRBSC5->TRAVAPV,;
			TRBSC5->EMPRESA,;
		TRBSC5->A1_EST,;
		TRBSC5->VOLUME,;
		TRBSC5->PESO_BRU,;
		TRBSC5->PESO_LIQ,;
		TRBSC5->A4_NREDUZ		})
		
		TRBSC5->(dbSkip())
		
		
		
	Enddo


//Quando estiver preenchido o parametro PROGRAMAÇÃO, trazer marcado
Elseif !Empty(dProgram)
	While TRBSC5->(!EOF())
		aAdd(aBrwPV,{IF(ALLTRIM(TRBSC5->C5_X_FLAG) = 'F', .T., .F.)	,;
		TRBSC5->C5_FILIAL,;
		TRBSC5->C5_NUM,;
		TRBSC5->A1_NOME,;
		TRBSC5->A3_GEREN+" "+TRBSC5->A3_NREDUZ,;
		TRBSC5->A1_X_PRIOR,;
		TRBSC5->C5_X_SONLG,;
		TRBSC5->VALOR,;
		TRBSC5->SKU,;
		TRBSC5->TPPV,;
		TRBSC5->C5_CLIENTE,;
		TRBSC5->C5_LOJACLI,;
		TRBSC5->TRAVAPV,;
		TRBSC5->EMPRESA,;
		TRBSC5->A1_EST,;
		TRBSC5->VOLUME,;
		TRBSC5->PESO_BRU,;
		TRBSC5->PESO_LIQ,;
		TRBSC5->A4_NREDUZ		})
		
		TRBSC5->(dbSkip())
	Enddo


//Demais situações não trazer marcado	
Else
	
	While TRBSC5->(!EOF())
		aAdd(aBrwPV,{IF(ALLTRIM(TRBSC5->C5_X_FLAG) = 'F', .T., .F.) ,;
		TRBSC5->C5_FILIAL,;
		TRBSC5->C5_NUM,;
		TRBSC5->A1_NOME,;
		TRBSC5->A3_GEREN+" "+TRBSC5->A3_NREDUZ,;
		TRBSC5->A1_X_PRIOR,;
		TRBSC5->C5_X_SONLG,;
		TRBSC5->VALOR,;
		TRBSC5->SKU,;
		TRBSC5->TPPV,;
		TRBSC5->C5_CLIENTE,;
		TRBSC5->C5_LOJACLI,;
		TRBSC5->TRAVAPV,;
		TRBSC5->EMPRESA,;
		TRBSC5->A1_EST,;
		TRBSC5->VOLUME,;
		TRBSC5->PESO_BRU,;
		TRBSC5->PESO_LIQ,;
		TRBSC5->A4_NREDUZ		})
		
		TRBSC5->(dbSkip())
	Enddo
	
Endif

If Len(aBrwPV) == 0
	//aAdd(aBrwPV,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(06),SPACE(04),SPACE(04),0,0,"",SPACE(06),SPACE(06)})
	aAdd(aBrwPV,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(06),SPACE(04),SPACE(04),0,0,"",SPACE(06),SPACE(06),SPACE(06),SPACE(06),SPACE(06)})
Endif

DEFINE MSDIALOG oTelPV FROM 38,16 TO 700,1090 TITLE Alltrim(OemToAnsi("PEDIDOS EM CARTEIRA")) Pixel

@ 002, 005 To 073, 535 Label Of oTelPV Pixel

If cAntec == "SIM"
	oSay5  	:= TSay():New(007,200,{|| "ONDA PARA ANTECIPADO" },oTelPV,,oFont4,,,,.T.,CLR_HRED)
Else
	oSay5  	:= TSay():New(007,200,{|| "ONDA PARA LIBERAÇÃO" },oTelPV,,oFont4,,,,.T.,CLR_GREEN)
Endif

oSay  	:= TSay():New(025,010,{|| "CARLOS" },oTelPV,,oFont3,,,,.T.,)
oGet1	:= tGet():New(025,065,{|u| if(Pcount()>0,nValVend1:=u,nValVend1) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend1",,,,.F.,,,)
oSay1  	:= TSay():New(025,130,{|| TRANSFORM(nValPerc1,"@E 99.99") },oTelPV,,oFont3,,,,.T.,If(nValPerc1<18,CLR_GREEN,CLR_HRED))

oSay  	:= TSay():New(040,010,{|| "MARCELO SEF" },oTelPV,,oFont3,,,,.T.,)
oGet2	:= tGet():New(040,065,{|u| if(Pcount()>0,nValVend2:=u,nValVend2) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend2",,,,.F.,,,)
oSay2  	:= TSay():New(040,130,{|| TRANSFORM(nValPerc2,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(055,010,{|| "SERGIO" },oTelPV,,oFont3,,,,.T.,)
oGet3	:= tGet():New(055,065,{|u| if(Pcount()>0,nValVend3:=u,nValVend3) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend3",,,,.F.,,,)
oSay3  	:= TSay():New(055,130,{|| TRANSFORM(nValPerc3,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(025,180,{|| "JUNIOR" },oTelPV,,oFont3,,,,.T.,)
oGet4	:= tGet():New(025,235,{|u| if(Pcount()>0,nValVend4:=u,nValVend4) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend4",,,,.F.,,,)
oSay4  	:= TSay():New(025,300,{|| TRANSFORM(nValPerc4,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(040,190,{|| "JUAREZ" },oTelPV,,oFont3,,,,.T.,)
oGet5	:= tGet():New(040,235,{|u| if(Pcount()>0,nValVend5:=u,nValVend5) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend5",,,,.F.,,,)
oSay5  	:= TSay():New(040,300,{||TRANSFORM(nValPerc5,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(055,190,{|| "MAURO" },oTelPV,,oFont3,,,,.T.,)
oGet6	:= tGet():New(055,235,{|u| if(Pcount()>0,nValVend6:=u,nValVend6) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend6",,,,.F.,,,)
oSay6  	:= TSay():New(055,300,{|| TRANSFORM(nValPerc6,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(025,350,{|| "DOUGLAS" },oTelPV,,oFont3,,,,.T.,)
oGet7	:= tGet():New(025,405,{|u| if(Pcount()>0,nValVend7:=u,nValVend7) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend7",,,,.F.,,,)
oSay7  	:= TSay():New(025,470,{|| TRANSFORM(nValPerc7,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(040,350,{|| "MARCELO SUL" },oTelPV,,oFont3,,,,.T.,)
oGet8	:= tGet():New(040,405,{|u| if(Pcount()>0,nValVend8:=u,nValVend8) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVend8",,,,.F.,,,)
oSay8  	:= TSay():New(040,470,{|| TRANSFORM(nValPerc8,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSay  	:= TSay():New(055,350,{|| "OUTROS" },oTelPV,,oFont3,,,,.T.,)
oGetO	:= tGet():New(055,405,{|u| if(Pcount()>0,nValVendO:=u,nValVendO) },,60,8,"@E 9,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValVendO",,,,.F.,,,)
oSayO  	:= TSay():New(055,470,{|| TRANSFORM(nValPercO,"@E 99.99") },oTelPV,,oFont3,,,,.T.,CLR_GREEN)

oSayP  	:= TSay():New(290,010,{|| "QTD PEDIDO" },oTelPV,,oFont3,,,,.T.,)
oGetP	:= tGet():New(290,060,{|u| if(Pcount()>0,nPedSel:=u,nPedSel) },,70,10,"@E 999,999",,,,oFont3,,,.T.,,,,,,,.T.,,,"nPedSel",,,,.F.,,,)

oSayQ  	:= TSay():New(305,010,{|| "MEDIA SKU" },oTelPV,,oFont3,,,,.T.,)
oGetQ	:= tGet():New(305,060,{|u| if(Pcount()>0,nQtdSku:=u,nQtdSku) },,70,10,"@E 9,999",,,,oFont3,,,.T.,,,,,,,.T.,,,"nQtdSku",,,,.F.,,,)

oSayT  	:= TSay():New(290,200,{|| "VALOR TOTAL " },oTelPV,,oFont3,,,,.T.,)
oGetT	:= tGet():New(290,250,{|u| if(Pcount()>0,nValor:=u,nValor) },,70,12,"@E 99,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValor",,,,.F.,,,)

oSayT  	:= TSay():New(318,010,{|| "QTD VOL " },oTelPV,,oFont3,,,,.T.,)
oGetT	:= tGet():New(318,060,{|u| if(Pcount()>0,nQtdVOL:=u,nQtdVOL) },,70,10,"@E 999,999",,,,oFont3,,,.T.,,,,,,,.T.,,,"nQtdVOL",,,,.F.,,,)

oSayT  	:= TSay():New(305,200,{|| "SOMA PESO B " },oTelPV,,oFont3,,,,.T.,)
oGetT	:= tGet():New(305,250,{|u| if(Pcount()>0,nSomaB:=u,nSomaB) },,70,12,"@E 999,999",,,,oFont3,,,.T.,,,,,,,.T.,,,"nSomaB",,,,.F.,,,)

//@ 300,320.4 Button "FILTRAR UF" size 55,12 action oTelPV:End(oGet1:Refresh(oTelPV:Refresh(oListBo2:Refresh(Processa( {|| IncOnda() }))))) OF oTelPV PIXEL
@ 300,415.4 Button "PROCESSAR" size 55,12 action Processa( {|| IncCarPV() }) OF oTelPV PIXEL
//@ 300,473.4 Button "FECHAR"  size 55,12 action oTelPV:End(oGet1:Refresh(oTelPV:Refresh(oListBo2:Refresh(Processa( {|| IncOnda() }))))) OF oTelPV PIXEL

//oSayT  	:= TSay():New(300,300,{|| "FILTRAR UF" },oTelPV,,oFont,,,,.T.,) //
@ 300,320 Get cUF picture "@!" size 35,10 OF oTelPV PIXEL

@ 300,360 Button "FILTRAR UF"  size 40,12 action Processa( {|| PesqUF()}, "AGUARDE...", "PESQUISANDO...") OF oTelPV PIXEL

@ 318,320 Button "Marcar Todos" Size 061,010 Action MsgRun("Marcando os pedidos..... Aguarde...", "Selecionando os Pedidos",;
                         { || Marcar()}) PIXEL OF oTelPV
@ 318,380 Button "Desmarcar Todos" Size 061,010 Action MsgRun("Desmarcando os pedidos..... Aguarde...", "Selecionando os Pedidos",;
                         { || Desmarcar()}) PIXEL OF oTelPV

@ 318,440 Button "TRANSF ARZM 01"  size 061,010 action Processa( {|| Transf01()}, "AGUARDE...", "Transferindo Armazem...") OF oTelPV PIXEL						 

@ 300,473.4 Button "FECHAR"  size 55,12 action oTelPV:End() OF oTelPV PIXEL
//@ 300,300  BUTTON oButton2 PROMPT "Sair" SIZE 039, 013 OF oTelPV ACTION oTelPV:END() PIXEL
//ACTIVATE MSDIALOG oTelVol CENTERED ON INIT EnchoiceBar(oTelVol,{||lOk:=.T., GetArray(nGetVol),oTelVol:End()},{||aRetDados := {},oTelVol:End(GetEnd())},,@aButtons1)
//oGet1:Refresh(oTelPV:Refresh(oListBo2:Refresh()))

If cAntec == "SIM"
	
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE"},{5,20,20,60,30,20,20,40,20,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED"},{5,20,20,60,30,20,20,40,20,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED"},{5,20,20,60,30,20,20,40,20,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED","","","","EMPRESA","ESTADO","VOLUME","PESO B","PESO L","TRANSP",},{5,15,20,20,60,30,20,20,40,20,15,15,15,15,3,15,15,15,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED","CLIENTE","LOJA","STATUS","EMPRESA","ESTADO","VOLUME","PESO B","PESO L","TRANSP"},{5,15,20,20,60,30,20,20,40,20,15,15,15,15,3,15,15,15,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		
		
	oListBo2:SetArray(aBrwPV)
	oListBo2:bLine := {||{ IIf(aBrwPV[oListBo2:nAt][1],LoadBitmap( GetResources(), "UNCHECKED" ),LoadBitmap( GetResources(), "CHECKED" )),; //flag
	aBrwPV[oListBo2:nAt,02],;	//filial
	aBrwPV[oListBo2:nAt,03],;	//pedido
	aBrwPV[oListBo2:nAt,04],;	//cliente
	aBrwPV[oListBo2:nAt,05],;	//GERENTE
	aBrwPV[oListBo2:nAt,06],;	//PRIORIDA
	aBrwPV[oListBo2:nAt,07],;	//PRIORIDADE PEDIDO//
	aBrwPV[oListBo2:nAt,08],;	//VALOR
	aBrwPV[oListBo2:nAt,09],;	//QTD SKU
	aBrwPV[oListBo2:nAt,10],; 	//GRANEL
	aBrwPV[oListBo2:nAt,11],; 	//VOLUME
	aBrwPV[oListBo2:nAt,12],;
	aBrwPV[oListBo2:nAt,13],;	 
	aBrwPV[oListBo2:nAt,14],;	// CODIGO
	aBrwPV[oListBo2:nAt,15],;  	// LOJA
	aBrwPV[oListBo2:nAt,16],;   	// Trava de Pedido 
	aBrwPV[oListBo2:nAt,17],;  	// EMPRESA
	aBrwPV[oListBo2:nAt,18],;  	// estado
	aBrwPV[oListBo2:nAt,19],;  	// VOLUME
	aBrwPV[oListBo2:nAt,20],;  	// PESO BRU
	aBrwPV[oListBo2:nAt,21],;  	// PESOLIQUI
	aBrwPV[oListBo2:nAt,22]}}	// Transportadora
	
	// AO Desmarcar o sistema não esta zerando a quantidade de volumes. (09/08/2018)
	 //oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(), IIf(!aBrwPV[oListBo2:nAt,1],IIf(aBrwPV[oListBo2:nAt,7]="SIM",TelaSLPV(),AtuAcols()),AtuAcols()), aBrwPV[oListBo2:nAt,8] := IIF(Len(aRetDados)>0, aRetDados[1],0),oListBo2:Refresh() } 

   	oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),;
   	(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(),;
   	IIf(!aBrwPV[oListBo2:nAt,1],IIf(aBrwPV[oListBo2:nAt,10]="SIM",TelaSLPV(),AtuAcols()),AtuAcols()),; 
   	aBrwPV[oListBo2:nAt,11] := IIF(aBrwPV[oListBo2:nAt,10]="SIM",IIF(Len(aRetDados)>0,aRetDados[1],0),0),oListBo2:Refresh(),;
    IIf(aBrwPV[oListBo2:nAt,16]="B",/*ValiBlq()*/,),oListBo2:Refresh(),;
	aBrwPV[oListBo2:nAt,11] := IIF(aBrwPV[oListBo2:nAt,1],0,aBrwPV[oListBo2:nAt,11]), oListBo2:Refresh() }
	
	
//
Else
	
	oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","TP PED","CLIENTE","LOJA","STATUS","EMPRESA","ESTADO","VOLUME","PESO B","PESO L","TRANSP"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	oListBo2:SetArray(aBrwPV)
	oListBo2:bLine := {||{ IIf(aBrwPV[oListBo2:nAt][1],LoadBitmap( GetResources(), "UNCHECKED" ),LoadBitmap( GetResources(), "CHECKED" )),; //flag
	aBrwPV[oListBo2:nAt,02],;
	aBrwPV[oListBo2:nAt,03],;
	aBrwPV[oListBo2:nAt,04],;
	aBrwPV[oListBo2:nAt,05],;
	aBrwPV[oListBo2:nAt,06],;
	aBrwPV[oListBo2:nAt,07],;
	aBrwPV[oListBo2:nAt,08],;
	aBrwPV[oListBo2:nAt,09],;
	aBrwPV[oListBo2:nAt,10],;
	aBrwPV[oListBo2:nAt,11],; // Cliente
	aBrwPV[oListBo2:nAt,12],; // Loja
	aBrwPV[oListBo2:nAt,13],; // Trava de Pedido 
	aBrwPV[oListBo2:nAt,14],;  	// EMPRESA
	aBrwPV[oListBo2:nAt,15],;  	// estado
	aBrwPV[oListBo2:nAt,16],;  	// VOLUME
	aBrwPV[oListBo2:nAt,17],;  	// PESO BRU
	aBrwPV[oListBo2:nAt,18],;  	// PESOLIQUI
	aBrwPV[oListBo2:nAt,19],;	// Transportadora
	}}

	oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(), AtuAcols()  } 

Endif
           
oGet1:Refresh()
oTelPV:Refresh()
oListBo2:Refresh() 


ACTIVATE MSDIALOG oTelPV centered

Return()               

                                                      
//****************************************************
// Valmir (25/02/2019)                                
//****************************************************


//****************************************************
// BOTÃO PROGRAMA ONDA
//****************************************************

Static Function PgrOnda()


Local cQryPgr 		:= ""

Private oFont 		:= TFont():New('Courier new',,-14,.F.,.T.)
Private aRetDados 	:= {}
Private aBrwPGR		:= {}
Private nValPRG		:= 0
Private oTelPGR             
Private oGetVal
              

If Select("TRBSC5A") > 0
	TRBSC5A->( dbCloseArea() )
EndIf


cQryPgr :=	" SELECT C5_FILIAL, CASE C5_FILIAL "
cQryPgr +=	" WHEN '0101' THEN 'CIMEX'       "
cQryPgr +=	" WHEN '0201' THEN 'CROZE'       "
cQryPgr +=	" WHEN '0301' THEN 'KOPEK'       "
cQryPgr +=	" WHEN '0401' THEN 'MACO '       "
cQryPgr +=	" WHEN '0501' THEN 'QUBIT'       "
cQryPgr +=	" WHEN '0601' THEN 'ROJA '       "
cQryPgr +=	" WHEN '0701' THEN 'VIXEN'       "
cQryPgr +=	" WHEN '0801' THEN 'MAIZE'       "
cQryPgr +=	" WHEN '0901' THEN 'DEVINTEX FILIAL'  "
cQryPgr +=	" WHEN '0902' THEN 'DEVINTEX FILIAL - MG' " 
cQryPgr +=	" END EMPRESA, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, ROUND(SUM(VALOR),2) VALOR, C5_X_STAPV "
cQryPgr +=	" FROM (  "
cQryPgr +=	" SELECT  C5_FILIAL, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, C6_PRODUTO, C9_BLCRED, "
cQryPgr +=	" C6_VALOR VALOR, C5_X_STAPV "
cQryPgr +=	" FROM SC5020 C5 WITH (NOLOCK) "
cQryPgr +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_='' AND C6_LOCAL ='95' " //apenas armazem 95
cQryPgr +=	" LEFT JOIN SC9020 C9 WITH (NOLOCK) ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_=''  "
cQryPgr +=	" INNER JOIN SA1020 A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_=''   "
cQryPgr +=	" WHERE C5.D_E_L_E_T_=''  "

cQryPgr +=	" AND ((C5_X_NONDA = '' AND C5_NOTA = '' AND C5_X_ANTEC ='2') OR (C5_X_ANTEC ='1'))    "

cQryPgr +=	" AND C5_X_DTOLO = '' "
cQryPgr +=	" AND C5_X_STAPV IN ('0','A') "
cQryPgr +=	" AND C5_TIPO = 'N'  "




cQryPgr +=	" ) X  "
cQryPgr +=	" GROUP BY C5_FILIAL, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, C5_X_STAPV   "
//cQryPgr +=	" HAVING SUM(CAST(C9_BLCRED AS INT)) = 0 "

cQryPgr +=	" ORDER BY C5_FILIAL, C5_NUM"    

TCQUERY cQryPgr NEW ALIAS "TRBSC5A"

//Processa o Resultado
dbSelectArea("TRBSC5A")
TRBSC5A->(dbGoTop())

lmr := .T.

While TRBSC5A->(!EOF())

	aAdd(aBrwPGR,{lmr,;
	TRBSC5A->EMPRESA,;
	TRBSC5A->C5_EMISSAO,;
	TRBSC5A->C5_NUM,;
	TRBSC5A->A1_NOME,;
	TRBSC5A->A1_X_PRIOR,;
	TRBSC5A->C5_X_SONLG,;
	TRBSC5A->VALOR,;
	IIF(TRBSC5A->C5_X_STAPV="0","PV GERADO",IIF(TRBSC5A->C5_X_STAPV="A","ANTECIPADO",""))})
	
	TRBSC5A->(dbSkip())
	
Enddo
	
	
If Len(aBrwPGR) == 0
	aAdd(aBrwPGR,{lmr,SPACE(10),SPACE(08),SPACE(06),SPACE(60),SPACE(06),SPACE(04),0,SPACE(05)})
Endif

DEFINE MSDIALOG oTelPGR FROM 38,16 TO 620,1090 TITLE Alltrim(OemToAnsi("PROGRAMAÇÃO DE PEDIDOS")) Pixel

Private dGetPGR	:= DDATABASE

oSay  	:= TSay():New(007,200,{|| "PROGRAMAÇÃO ONDA" },oTelPGR,,oFont4,,,,.T.,CLR_GREEN)
oSay  	:= TSay():New(009,010,{|| "DATA DA ONDA: " },oTelPGR,,oFont,,,,.T.,)

@ 008,080 Get dGetPGR picture "@D" size 44.5,10 OF oTelPGR PIXEL	
@ 010,400.4 Button "PROCESSAR" size 55,12 action Processa( {|| CriarPGR() }) OF oTelPGR PIXEL
@ 010,473.4 Button "FECHAR"  size 55,12 action oTelPGR:End() OF oTelPGR PIXEL  


oSay1  	:= TSay():New(042.4,405,{|| "VALOR TOTAL " },oTelPGR,,oFont3,,,,.T.,)
oGetVal	:= tGet():New(040,459,{|u| if(Pcount()>0,nValPRG:=u,nValPRG) },,70,12,"@E 999,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValPRG",,,,.F.,,,)

                                                                           
oListBox3	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","EMISSAO","PEDIDO","CLIENTE","VIP","PR PEDIDO","VALOR","STATUS PV"},{5,40,35,35,100,25,35,15,20},oTelPGR,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
oListBox3:SetArray(aBrwPGR)
oListBox3:bLine := {||{ IIf(aBrwPGR[oListBox3:nAt][1],LoadBitmap( GetResources(), "UNCHECKED" ),LoadBitmap( GetResources(), "CHECKED" )),; //flag
aBrwPGR[oListBox3:nAt,02],;				//FILIAL
STOD(aBrwPGR[oListBox3:nAt,03]),;		//EMISSAO
aBrwPGR[oListBox3:nAt,04],;				//PEDIDO
Alltrim(aBrwPGR[oListBox3:nAt,05]),;	//CLIENTE
aBrwPGR[oListBox3:nAt,06],;				//VIP
aBrwPGR[oListBox3:nAt,07],;				//PRIORIDADE PEDIDO
aBrwPGR[oListBox3:nAt,08],;				//VALOR
aBrwPGR[oListBox3:nAt,09]}}				//STATUS PV

oListBox3:bLDblClick := {|| Iif(oListBox3:nColPos <> 5,(aBrwPGR[oListBox3:nAt,1] := !aBrwPGR[oListBox3:nAt,1]),(aBrwPGR[oListBox3:nAt,1] := .T.,)), oListBox3:Refresh(), AcolsPGR() }
       
oGetVal:Refresh()
oTelPGR:Refresh()
oListBox3:Refresh()

ACTIVATE MSDIALOG oTelPGR centered
                                  

Return()
                                     

Static Function AcolsPGR()


nValPRG := 0	//Sempre Zera para Calcular novamente

For nx := 1 To Len(aBrwPGR)
	
		If !aBrwPGR[nx][1]				//Campo MARCADO (.F.)
			nValPRG += aBrwPGR[nx][8]		// Valor
		Endif
			
Next nx

oGetVal:Refresh()
oTelPGR:Refresh()
oListBox3:Refresh()

Return()
                                                      

Static Function CriarPGR()
                        
If nValPRG > 0
	
	If MsgYesNo("DESEJA PROCESSAR OS PEDIDOS SELECIONADOS?")
				
		For nx := 1 To Len(aBrwPGR)
			
			If !aBrwPGR[nx][1]                                // Filial + Pedido + Data
				cExecProc := " exec uspPedidoOnda '"+aBrwPGR[nx][2]+"','"+aBrwPGR[nx][4]+"','"+dtos(dGetPGR)+"'  "
				TcSqlExec(cExecProc)
			Endif
							
		Next nx
				
		MSGINFO("PROGRAMAÇÃO PROCESSADA COM SUCESSO")
		
	Else
		
		MSGINFO("PROGRAMAÇÃO CANCELADA PELO USUARIO")
		
	Endif
	
Else
	MSGINFO("NENHUM VALOR SELECIONADO, A PROGRAMAÇÃO DA ONDA NÃO SERÁ PROCESSADA")
Endif

oTelPGR:End()

Return()                
                
//****************************************************
// Valmir (25/02/2019)                                
//****************************************************


//*******************************************************
// BLOQUEIO DO ANTECIPADO
//*******************************************************
Static Function AtuESFATR()

If lLibAnt
	If MsgYesNo("DESEJA BLOQUEAR O ACESSO DAS GERAÇÕES DOS PEDIDOS ANTECIPADOS?")
		PUTMV("ES_FATR001", .F.)
		oWindow:End()
	Endif
Else
	If MsgYesNo("DESEJA LIBERAR ACESSO PARA GERAÇÃO DE PEDIDOS ANTECIPADOS?")
		PUTMV("ES_FATR001", .T.)
		oWindow:End()
	Endif
Endif

Return()


//*******************************************************************
//Função - Atualiza ACOLS - Grid em Tela
//*******************************************************************
Static Function AtuAcols(_lFlag, _cFilial, _cPedido )

//Sempre Zera para Calcular novamente
nValor 		:= 0	
nQtdVOL  :=0
nSomaB :=0	
nQtdSku		:= 0
nPedSel		:= 0

nValVend1	:= 0
nValVend2	:= 0
nValVend3	:= 0
nValVend4	:= 0
nValVend5	:= 0
nValVend6	:= 0
nValVend7	:= 0
nValVend8	:= 0
nValVendO	:= 0

nValPerc1	:= 0
nValPerc2	:= 0
nValPerc3	:= 0
nValPerc4	:= 0
nValPerc5	:= 0
nValPerc6	:= 0
nValPerc7	:= 0
nValPerc8	:= 0

DBSelectarea("SC5")
DBSetOrder(1)
DBSeek(aBrwPV[oListBo2:nAt,2]+aBrwPV[oListBo2:nAt,3],.F.)
If !aBrwPV[oListBo2:nAt,1]
	Reclock("SC5",.F.)
		SC5->C5_X_FLAG	:= .T.
	msunlock()
Else
	Reclock("SC5",.F.)
		SC5->C5_X_FLAG	:= .F.
	msunlock()
EndIf 

For nx := 1 To Len(aBrwPV)
	
	If !aBrwPV[nx][1]				//Campo MARCADO (.F.)
		nValor 	+= aBrwPV[nx][8]		// Valor
		nQtdSku += aBrwPV[nx][9]
		if cAntec == "SIM"
		nQtdVOL +=aBrwPV[nx][19]
		nSomaB +=aBrwPV[nx][20]
		else 
		nQtdVOL +=aBrwPV[nx][16]
		nSomaB +=aBrwPV[nx][17]
		endif
		
		If LEFT(aBrwPV[nx][5],6) == '000002' //CALOS
			nValVend1 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000007' //MARCELO
			nValVend2 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000010' //MARCELO
			nValVend3 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000004' //MARCELO
			nValVend4 += aBrwPV[nx][8]	
		ElseIf LEFT(aBrwPV[nx][5],6) == '000005' //MARCELO
			nValVend5 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000008' //MARCELO
			nValVend6 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000003' //MARCELO
			nValVend7 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000006' //MARCELO
			nValVend8 += aBrwPV[nx][8]
		Else
			nValVendO += aBrwPV[nx][8]
		EndIf
		
		nPedSel++
	
	Endif 
		
Next nx

nQtdSku 	:= nQtdSku / nPedSel
nValPerc1	:= (nValVend1 / nValorOnda) * 100
nValPerc2	:= (nValVend2 / nValorOnda) * 100
nValPerc3	:= (nValVend3 / nValorOnda) * 100
nValPerc4	:= (nValVend4 / nValorOnda) * 100
nValPerc5	:= (nValVend5 / nValorOnda) * 100
nValPerc6	:= (nValVend6 / nValorOnda) * 100
nValPerc7	:= (nValVend7 / nValorOnda) * 100
nValPerc8	:= (nValVend8 / nValorOnda) * 100
nValPercO	:= (nValVendO / nValorOnda) * 100

//Refresh em Tela
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()
oGet4:Refresh()
oGet5:Refresh()
oGet6:Refresh()
oGet7:Refresh()
oGet8:Refresh()
oGetO:Refresh()
oGetT:Refresh()
oGetQ:Refresh()
oGetP:Refresh()

oSay1:Refresh()
oSay2:Refresh()
oSay3:Refresh()
oSay4:Refresh()
oSay5:Refresh()
oSay6:Refresh()
oSay7:Refresh()
oSay8:Refresh()
oSayO:Refresh()

oTelPV:Refresh()
oListBo2:Refresh()

Return()


//*******************************************************
//
//*******************************************************
Static Function IncCarPV()

Local nZ		:= 0
Local nPed		:= 0
Local nCont		:= 0
Local n1		:= 0

Private oDlg1	:= Nil
Private cPedSel	:= ""
Private cTpVen	:= ""

cPedido	:= ""


//Valida no Browser Pedido Antecipado
If cAntec == "SIM"	// Antecipado

	For nPed := 1 To Len(aBrwPV)
		
		If !aBrwPV[nPed][1]		// Pedido Marcado

			cPedSel	:= Alltrim(aBrwPV[nPed][14]+aBrwPV[nPed][15])
			cTpVen	:= Alltrim(Alltrim(aBrwPV[nPed][13]))

			If Alltrim(aBrwPV[nPed][16]) = "B"	// Bloqueado 	

				cPedido += STR_ENTER + alltrim(aBrwPV[nPed][3])
				aadd(aPvSel, { Alltrim(aBrwPV[nPed][2]), Alltrim(aBrwPV[nPed][3])  })	// 2=Filial 3=Pedido
				nCont++
			
			ElseIf !aBrwPV[nPed][1] .And. Alltrim(aBrwPV[nPed][16]) = "L" .And. cTpVen $ "BONIF,TROCA"

				For n1 := 1 To Len(aBrwPV)
					
					// Olhar apenas os não marcados de Vendas caso o Bonificação tenha sido selecionado
					If aBrwPV[n1][1] .And. Alltrim(aBrwPV[n1][14]+aBrwPV[n1][15]) = cPedSel .And. aBrwPV[n1][13] = "VENDA"
						
						cPedido += STR_ENTER + alltrim(aBrwPV[n1][3])
						aadd(aPvSel, { Alltrim(aBrwPV[n1][2]), Alltrim(aBrwPV[n1][3])  })	// 2=Filial 3=Pedido
						nCont++

					Endif
				Next n1
			Endif	
		Endif
	Next nPed

Else	// Normal (03/02/2022)
	
	For nPed := 1 To Len(aBrwPV)
		
		If !aBrwPV[nPed][1]		// Pedido Marcado

			cPedSel	:= Alltrim(aBrwPV[nPed][11]+aBrwPV[nPed][12])
			cTpVen	:= Alltrim(Alltrim(aBrwPV[nPed][10]))

			If Alltrim(aBrwPV[nPed][13]) = "B"	// Bloqueado 	

				cPedido += STR_ENTER + alltrim(aBrwPV[nPed][3])
				aadd(aPvSel, { Alltrim(aBrwPV[nPed][2]), Alltrim(aBrwPV[nPed][3])  })	// 2=Filial 3=Pedido
				nCont++
			
			ElseIf !aBrwPV[nPed][1] .And. Alltrim(aBrwPV[nPed][13]) = "L" .And. cTpVen $ "BONIF,TROCA"

				For n1 := 1 To Len(aBrwPV)
					
					// Olhar apenas os não marcados de Vendas caso o Bonificação tenha sido selecionado
					If aBrwPV[n1][1] .And. Alltrim(aBrwPV[n1][11]+aBrwPV[n1][12]) = cPedSel .And. aBrwPV[n1][10] = "VENDA"
						
						cPedido += STR_ENTER + alltrim(aBrwPV[n1][3])
						aadd(aPvSel, { Alltrim(aBrwPV[n1][2]), Alltrim(aBrwPV[n1][3])  })	// 2=Filial 3=Pedido
						nCont++

					Endif
				Next n1
			Endif	
		Endif
	Next nPed

Endif

If nCont > 0
	If !MsgYesNo("Pedido Bonificado/Troca sem Pedido de Venda, confirma esta ação para este Pedidos ? "+cPedido,"Atenção")
		Return()
	Else

		DEFINE MSDIALOG oDlg1 FROM 10,10 TO 0190,0700 TITLE Alltrim(OemToAnsi("MOTIVO DA LIBERAÇÃO")) Pixel 

		oSayLn12:= tSay():New(042.7,0010,{||"Selecionar Motivo:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
		oGet13	:= TComboBox():New(040,110,{|u| if(PCount()>0,cDescMot:=u,cDescMot)},aCombo1,100,20,oDlg1,,,,,,.T.,,,,,,,,,"cDescMot") //size 60,10

		//ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{||lOk:=.T., /*MOTLIB(),*/ oDlg1:End() },{||oDlg1:End()},,)
		ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{||lOk:=.T., MOTLIB(), oDlg1:End() },{||oDlg1:End()},,)

	Endif

	If Empty(cDescMot)
		Return()
	Endif

Endif



If nValor > 0 .and. cFilAnt=="1201"
	If MsgYesNo("DESEJA PROCESSAR OS PEDIDOS SELECIONADOS?")
			cNRonda := Soma1(GetMV("ES_NRONDA"),6)
		
								For nx := 1 To Len(aBrwPV)
									
									If cAntec == "SIM"
										
										cTpPed := "2"
									
										lupdativa:=.T. // varial logica para integrar com ATIVA ...pedidos nao antecipados... normais
										If !aBrwPV[nx][1]
												cPedido:=alltrim(aBrwPV[nx][3])
												nvalc6:=0
												// nOpcx     := 1
												// lAutomato	 := .F.
												// nReg := SC6->(recno()) //12358022   // 58074
												
													DBSELECTAREA('SC6')
												DBSETORDER(1)
													DBSELECTAREA('SC9')
												DBSETORDER(1)
												SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
												SC9->(DBSEEK(XFILIAL("SC9")+cPedido))
												// clocal:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_LOCAL')
												// cProduto:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_PRODUTO')
												// cqtd:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_QTDVEN')
																// aSaldos:=CalcEst(cProduto,cLocal, dDataBase+1)
																// nQuant:=aSaldos[1]
														// faço a varredura no pedido para verificar se existe itens sem saldo, saldo faltando
														while SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL==cFilAnt								
															clocal:= SC9->C9_LOCAL  //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_LOCAL')//
															cProduto:= SC9->C9_PRODUTO    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_PRODUTO')
															cqtd:= SC9->C9_QTDLIB    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_QTDLIB')
															nvalc6:=  SC6->C6_VALOR//POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_VALOR')
															aSaldos:=CalcEst(cProduto,cLocal, dDataBase+1)
															nreserva := POSICIONE('SB2',1,xFilial('SB2')+cProduto+clocal,'B2_RESERVA')
															nReg := SC9->(recno())
															nQuant:=aSaldos[1]
															nvalc62+=nvalc6
															   if (nQuant - nreserva) < cqtd   /// verifico se existe saldo disponivel Alltrim(Transform(nQuant,"999999"))
															   lLibera:=.F.
															    ndisp :=nQuant - nreserva
																MsgAlert("Saldo insuficiente para o Pedido "+cpedido+" e Produto "+Alltrim(cProduto)+"."+ Chr(13) + Chr(10) +" Saldo Solicitado ="+Alltrim(Transform(cqtd,"999999"))+"."+ Chr(13) + Chr(10) +"  Saldo Disponivel ="+Alltrim(Transform((ndisp),"999999"))+"." ,"Atenção")
															 	aadd(aPedmail, {SC9->C9_FILIAL,cpedido,SC9->C9_ITEM,cProduto ,cqtd,ndisp  })	// 2=Filial 3=Pedido
						
															  endif

															//    if lLibera==.F.		
															//  	 MsgAlert("Saldo insuficiente para o produto "+Alltrim(cProduto)+". Saldo ="+Alltrim(Transform(nQuant,"999999"))+". Pedido "+cpedido+"." ,"Atenção")
															//    	//SC9->(DBSKIP()) //A455LibMan("SC9",nReg,1,.T.)
															// 	//SC6->(DBSKIP())
															//    endif

															//    if lLibera==.T.	
															//    A455LibMan("SC9",nReg,1,.T.)//
															//    endif
															SC9->(DBSKIP())
															SC6->(DBSKIP())
														ENDDO

														if lLibera==.F.
														nvalc63 += nvalc62
														nvalc62 :=0
														u_emailped(aPedmail)
														endif
														//fim da varredura do saldo dos itens

														//caso nao tenha problemas de saldos
														// faço mais uma varredura no pedido , liberando os itens
														if lLibera==.T.
																nvalc62 :=0
																DBSELECTAREA('SC6')
																DBSETORDER(1)
																	DBSELECTAREA('SC9')
																DBSETORDER(1)
																SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
																SC9->(DBSEEK(XFILIAL("SC9")+cPedido))

																while SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL==cFilAnt
																	clocal:= SC9->C9_LOCAL  //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_LOCAL')//
																	cProduto:= SC9->C9_PRODUTO    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_PRODUTO')
																	cqtd:= SC9->C9_QTDLIB    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_QTDLIB')
																	aSaldos:=CalcEst(cProduto,cLocal, dDataBase+1)
																	nReg := SC9->(recno())

																	if SC9->C9_BLEST=='02' .or. SC9->C9_BLEST=='03'
																	A455LibMan("SC9",nReg,1,.T.)
																	endif
																	SC9->(DBSKIP())
														    	ENDDO
																//apos varrer todos os itens e liberar o SC9 do pedido ... faço a procedure que ja existia e a integrção com ATIVA
																cExecProc := " exec uspSC6020CaixaGranel '"+aBrwPV[nx][2]+"','"+aBrwPV[nx][3]+"','"+cTpPed+"','"+cNomUser+"',0,'"+cNRonda+"'  "
																TcSqlExec(cExecProc)
																																
																if lupdativa==.T. // integração com ATIVA?
																	u_SLJsonSC5(cPedido)
																	DBSELECTAREA('SC5')
																	DBSETORDER(1)
																	SC5->(DBSEEK(XFILIAL("SC5")+cPedido))
																	Reclock("SC5",.F.)
																		SC5->C5_X_ATIVA := "1"
																	Msunlock()
																endif
														endif

														
										Endif
										
									Else
										
										cTpPed := "1"
										lupdativa:=.T. // varial logica para integrar com ATIVA ...pedidos nao antecipados... normais
										If !aBrwPV[nx][1]
											cPedido:=alltrim(aBrwPV[nx][3])
											nvalc6:=0
											// nOpcx     := 1
											// lAutomato	 := .F.
											// nReg := SC6->(recno()) //12358022   // 58074
											
												DBSELECTAREA('SC6')
											DBSETORDER(1)
												DBSELECTAREA('SC9')
											DBSETORDER(1)
											SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
											SC9->(DBSEEK(XFILIAL("SC9")+cPedido))
											// clocal:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_LOCAL')
											// cProduto:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_PRODUTO')
											// cqtd:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_QTDVEN')
															// aSaldos:=CalcEst(cProduto,cLocal, dDataBase+1)
															// nQuant:=aSaldos[1]
														// faço a varredura no pedido para verificar se existe itens sem saldo, saldo faltando
														while SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL==cFilAnt								
															clocal:= SC9->C9_LOCAL  //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_LOCAL')//
															cProduto:= SC9->C9_PRODUTO    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_PRODUTO')
															cqtd:= SC9->C9_QTDLIB    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_QTDLIB')
															nvalc6:=  SC6->C6_VALOR//POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_VALOR')
															aSaldos:=CalcEst(cProduto,cLocal, dDataBase+1)
															nreserva := POSICIONE('SB2',1,xFilial('SB2')+cProduto+clocal,'B2_RESERVA')
															nReg := SC9->(recno())
															nQuant:=aSaldos[1]
															nvalc62+=nvalc6															
															   if (nQuant - nreserva) < cqtd   /// verifico se existe saldo disponivel Alltrim(Transform(nQuant,"999999"))
															   	lLibera:=.F. //aBrwPV[nx][1] array que ira receber todos produtos dos pedidos insulficientes
															    ndisp :=nQuant - nreserva
																MsgAlert("Saldo insuficiente para o Pedido "+cpedido+" e Produto "+Alltrim(cProduto)+"."+ Chr(13) + Chr(10) +" Saldo Solicitado ="+Alltrim(Transform(cqtd,"999999"))+"."+ Chr(13) + Chr(10) +"  Saldo Disponivel ="+Alltrim(Transform((ndisp),"999999"))+"." ,"Atenção")
															 	aadd(aPedmail, {SC9->C9_FILIAL,cpedido,SC9->C9_ITEM,cProduto ,cqtd,ndisp  })	// 2=Filial 3=Pedido
						
															  endif

															//    if lLibera==.F.		
															//  	 MsgAlert("Saldo insuficiente para o produto "+Alltrim(cProduto)+". Saldo ="+Alltrim(Transform(nQuant,"999999"))+". Pedido "+cpedido+"." ,"Atenção")
															//    	//SC9->(DBSKIP()) //A455LibMan("SC9",nReg,1,.T.)
															// 	//SC6->(DBSKIP())
															//    endif

															//    if lLibera==.T.	
															//    A455LibMan("SC9",nReg,1,.T.)//
															//    endif
															SC9->(DBSKIP())
															SC6->(DBSKIP())
														ENDDO

														if lLibera==.F.
														nvalc63 += nvalc62
														nvalc62 :=0
														u_emailped(aPedmail)
														endif
														//fim da varredura do saldo dos itens

														//caso nao tenha problemas de saldos
														// faço mais uma varredura no pedido , liberando os itens
														if lLibera==.T.
														nvalc62 :=0
															DBSELECTAREA('SC6')
															DBSETORDER(1)
																DBSELECTAREA('SC9')
															DBSETORDER(1)
															SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
															SC9->(DBSEEK(XFILIAL("SC9")+cPedido))

															while SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL==cFilAnt
																clocal:= SC9->C9_LOCAL  //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_LOCAL')//
																cProduto:= SC9->C9_PRODUTO    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_PRODUTO')
																cqtd:= SC9->C9_QTDLIB    //POSICIONE('SC9',1,xFilial('SC9')+cpedido,'C9_QTDLIB')
																aSaldos:=CalcEst(cProduto,cLocal, dDataBase+1)
																nReg := SC9->(recno())

																if SC9->C9_BLEST=='02' .or. SC9->C9_BLEST=='03'
																A455LibMan("SC9",nReg,1,.T.)
																endif

																SC9->(DBSKIP())
														    ENDDO
																//apos varrer todos os itens e liberar o SC9 do pedido ... faço a procedure que ja existia e a integrção com ATIVA
																cExecProc := " exec uspSC6020CaixaGranel '"+aBrwPV[nx][2]+"','"+aBrwPV[nx][3]+"','"+cTpPed+"','"+cNomUser+"',0,'"+cNRonda+"'  "
																TcSqlExec(cExecProc)
																																
																if lupdativa==.T. // integração com ATIVA?
																	u_SLJsonSC5(cPedido)
																	DBSELECTAREA('SC5')
																	DBSETORDER(1)
																	SC5->(DBSEEK(XFILIAL("SC5")+cPedido))
																	Reclock("SC5",.F.)
																		SC5->C5_X_ATIVA := "1"
																	Msunlock()
																endif
														endif

														
										Endif
										
									Endif

								Next nx
			//	endif
		   // tratativa para nvalor descontar os totais de pedidos que nao foram liberados //
			nvalor :=nvalor - nvalc63
			if nValor > 0						
			cNRonda := Replicate("0",6-Len(Alltrim(cNRonda)))+Alltrim(cNRonda)
			
			PutMv("ES_NRONDA",cNRonda)
			
			IncSZ4()
			else
				MSGINFO("ONDA NAO GERADA, VERIFICAR")
			endif
		
		    //Processa({|| U_WB_LOG001() },"Aguarde, integrando pedidos para logística...") //....comentado pois nao ira integrar com a logistica LH SALONLINE 07062023

			//=============================================================================================================================//
			//*** Valmir (01/11/2021) Verificar se possui Mais Pedidos dos (Clientes/Pedidos) Selecionados
			For nZ := 1 To Len(aBrwPV)

				If !aBrwPV[nZ][1] 
					
						SC5->(DbSetOrder(1),DbSeek( aBrwPV[nZ][2] + aBrwPV[nZ][3] ))

						cCliSel	+= "'"+SC5->C5_CLIENTE+"'"
						
						If Empty(SC5->C5_ESPECI4)
							Reclock("SC5",.F.)
								SC5->C5_ESPECI4 := "S"
							Msunlock()
						Endif

						If nZ <= Len(aBrwPV)
							cCliSel += ','
						Endif

				Endif

			Next nZ

		nTot	:= Len(Alltrim(cCliSel))
		cCliSel := SubStr(Alltrim(cCliSel),1,nTot-1)


		MSGINFO("ONDA PROCESSADA COM SUCESSO N° "+cNRonda)
		
	Else
		
		MSGINFO("PROCESSO CANCELADO PELO USUARIO")

	Endif
	
Else
	MSGINFO("NENHUM VALOR SELECIONADO, A ONDA NÃO SERÁ PROCESSADA")
Endif

oTelPV:End()

Return()


//*********************************************************************
// MOTIVO DA LIBERAÇÃO
//*********************************************************************
Static Function MOTLIB()

Local nConPv	:= 0	

For nConPv = 1 To Len(aPvSel)

	cUpdP41A	:= " UPDATE SC5020 SET C5_XMOTB = '"+Left(cDescMot,20)+"'   "
	cUpdP41A	+= " FROM SC5020 C5											"
	cUpdP41A	+= " WHERE C5.D_E_L_E_T_ = ''								"		
	cUpdP41A	+= " AND C5_FILIAL = '"+aPvSel[nConPv][1]+"'				"
	cUpdP41A	+= " AND C5_NUM = '"+aPvSel[nConPv][2]+"'					"
	
	TcSqlExec(cUpdP41A) 

Next nConPv


Return()


//*********************************************************************
// INCLUIR ONDA NA TABELA SZ4
//*********************************************************************
Static Function INCSZ4()

RecLock("SZ4",.T.)

SZ4->Z4_TIPO	:= 'N'
SZ4->Z4_NUMONDA	:= cNRonda
SZ4->Z4_DTEMISS	:= Date()
SZ4->Z4_HORA	:= Time()
SZ4->Z4_USUARIO	:= cNomUser
SZ4->Z4_IMPRESS	:= "2"
SZ4->Z4_VALOR   := nValor

MsUnlock()

Return()


//FUNÇÃO PARA IMPRIMIR A ONDA
Static Function ImpOnda()

//Numero do Manifesto Seleciona no Grid
cNRonda := aBrowse[oListBox:nAt][3]

If MsgYesNo("DESEJA IMPRIMIR A ONDA NR. "+cNRonda)
	U_FATR0001(cNRonda)
Endif

return()


//***********************************************
//
//
Static Function TelaSLPV()

Local aButtons1
Local oTelVol
Local nGetVol := 0

AtuAcols()	//Soma valor TOTAL
 																					// STYLE DS_MODALFRAME -> Remove o botão X da tela
DEFINE DIALOG oTelVol TITLE "QUANTIDADE VOLUMES GRANEL" FROM 02,02 TO 180,320 PIXEL STYLE DS_MODALFRAME

oSayV  	:= TSay():New(40,10,{|| "Volume: " },oTelVol,,oFont2,,,,.T.,)
oGetV  	:= TGet():New(38,60,{|u| if( Pcount()>0, nGetVol:=u, nGetVol )},oTelVol,40,15,"@R 999999",{|u| If(nGetVol>0,u:=.T.,u:=.F.)},,,oFont,,,.T.,,,,,,,,,,"nGetVol")

oTelVol:lEscClose := .F. // Desabilita o botao Esc

ACTIVATE MSDIALOG oTelVol CENTERED ON INIT EnchoiceBar(oTelVol,{||lOk:=.T., GetArray(nGetVol),oTelVol:End()},{||aRetDados := {},oTelVol:End(GetEnd())},,@aButtons1)

Return()


//***********************************************
//
//
Static Function GetArray(nGetVol)

aRetDados := {}
aAdd(aRetDados,nGetVol)

Return()


Static Function GetEnd()

aBrwPV[oListBo2:nAt,1] := .T.		// Caso o usuario cancelar, tira o flag.
aBrwPV[oListBo2:nAt,11] := 0
AtuAcols()

oGet1:Refresh()
oTelPV:Refresh()
oListBo2:Refresh()

Return()



//========================================================================================================================//
// 	Tela para visualizar Pedidos da Onda																				  //
//========================================================================================================================//
Static Function VisualPv()

Private cNroOnda := aBrowse[oListBox:nAt,03]
Private cQryC5 		:= ""
Private oOK 		:= LoadBitmap(GetResources(),'br_verde')
Private oNO 		:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias		:= GetNextAlias()
Private oFont 		:= TFont():New('Courier new',,-14,.F.,.T.)

Private aBrwC5		:= {}
Private cNRonda 	:= ""
Private nValor		:= 0
Private oGet
Private oTelVis

If Select("TRBC5") > 0
	TRBC5->( dbCloseArea() )
EndIf

cQryC5 :=	" SELECT CASE "
cQryC5 +=	" WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
cQryC5 += 	" WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA'   "
cQryC5 += 	" WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
cQryC5 += 	" WHEN C5_FILIAL='0902' THEN 'DEVINTEX-MG' "
cQryC5 += " WHEN C5_FILIAL='1101' THEN 'BIZEZ' 	WHEN C5_FILIAL='1201' THEN 'ZAKAT' 	WHEN C5_FILIAL='1301' THEN 'HEXIL' "
cQryC5 += 	" ELSE C5_FILIAL END EMPRESA, "
cQryC5 += 	" C5_NUM, C5_CLIENTE, C5_LOJACLI,C5_X_OBSVD,C5_X_OBSLO,ISNULL(CAST(CAST(C5_X_OBSIN AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS, A1_NOME, A4_NREDUZ, A3_NREDUZ,  "
cQryC5 +=	" CASE WHEN C5_X_TLNGR > 0 THEN 'SIM' END C5_X_TLNGR,   "
cQryC5 +=	" CASE WHEN C5_X_ANTEC = '1' THEN 'SIM' ELSE 'NAO' END C5_X_ANTEC, C5_VOLUME2, SUM(C6_VALOR) C6_VALOR "
cQryC5 +=	" ,CASE WHEN F4_DUPLIC='S' THEN 'VENDA' ELSE 'BONIFICACAO' END TPPEDIDO"
cQryC5 +=	" FROM " +RETSQLNAME("SC5")+ " C5 WITH (NOLOCK) "
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SC6")+ " C6 WITH (NOLOCK) ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C6.D_E_L_E_T_ = '' "
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SF4")+ " F4 WITH (NOLOCK) ON F4_FILIAL=C6_FILIAL AND F4_CODIGO=C6_TES AND F4.D_E_L_E_T_ = ''	"
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SA1")+ " A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''	"
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SA4")+ " A4 WITH (NOLOCK) ON C5_TRANSP = A4_COD AND A4.D_E_L_E_T_ = '' 	"
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SB1")+ " B1 WITH (NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.B1_FILIAL = '    ' AND B1.D_E_L_E_T_ = '' "  
cQryC5 +=	" LEFT JOIN  " +RETSQLNAME("SA3")+ " A3 WITH (NOLOCK) ON C5_VEND1 = A3_COD AND A3.D_E_L_E_T_ = ''  	"
cQryC5 += 	" WHERE C5_X_NONDA = '"+cNroOnda+"' "
cQryC5 +=	" AND C5.D_E_L_E_T_ = '' "     
cQryC5 +=	" GROUP BY F4_DUPLIC,C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI,C5_X_OBSVD,C5_X_OBSLO,ISNULL(CAST(CAST(C5_X_OBSIN AS VARBINARY(8000)) AS VARCHAR(8000)),''), A1_NOME, A4_NREDUZ, A3_NREDUZ, C5_X_ANTEC, C5_VOLUME2, C5_X_TLNGR "
cQryC5 +=	" ORDER BY 1,2 "

TCQUERY cQryC5 NEW ALIAS "TRBC5"

cPvAnt := TRBC5->C5_X_ANTEC

//Processa o Resultado //
dbSelectArea("TRBC5")
TRBC5->(dbGoTop())

While TRBC5->(!EOF())
	aAdd(aBrwC5,{	.T.,;
	TRBC5->EMPRESA,;
	TRBC5->C5_NUM,;
	TRBC5->C5_CLIENTE,;
	TRBC5->C5_LOJACLI,;
	TRBC5->A1_NOME,;
	TRBC5->A4_NREDUZ,; 
	SUBSTR(TRBC5->A3_NREDUZ,1,20),;
	ALLTRIM(TRBC5->C5_X_TLNGR),;
	Alltrim(Transform(TRBC5->C5_VOLUME2,"999999")),;
	Transform(TRBC5->C6_VALOR,"@E 999,999,999.99"),;
	TRBC5->TPPEDIDO,;
	TRBC5->C5_X_OBSVD,;
	TRBC5->C5_X_OBSLO,;
	TRBC5->OBS})
	
	TRBC5->(dbSkip())
		
Enddo
	
If Len(aBrwC5) == 0
	aAdd(aBrwC5,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(02),SPACE(30),SPACE(15),SPACE(15),SPACE(02),SPACE(15),0,0})
Endif

DEFINE MSDIALOG oTelVis FROM 38,16 TO 600,1200 TITLE Alltrim(OemToAnsi("PEDIDOS SELECIONADO NA ONDA")) Pixel

@ 002, 005 To 058, 590 Label Of oTelVis Pixel

oSay5  	:= TSay():New(010,010,{|| "PEDIDOS SELECIONADOS NA ONDA N° "+cNroOnda },oTelVis,,oFont4,,,,.T.,CLR_BLUE)
oSay6	:= TSay():New(024,010,{|| "ANTECIPADO "+cPvAnt },oTelVis,,oFont4,,,,.T.,CLR_HRED)

//@ 025,530 Button "PROCESSA ESTOQUE"   size 55,12 action Processa( {|| U_FATP0011(cNroOnda)}) OF oTelVis PIXEL
                                                                           
@ 010,530 Button "REL. ONDA"	size 55,12 action Processa( {|| RelOnda1()}) OF oTelVis PIXEL
@ 025,530 Button "REL. FALTA"   size 55,12 action Processa( {|| RelOnda2()}) OF oTelVis PIXEL
@ 040,530 Button "FECHAR"  		size 55,12 action oTelVis:End() OF oTelVis PIXEL
		
oListBox3	:= twBrowse():New(059,005,586,215,,{" ","FILIAL","PEDIDO","CLIENTE","LOJA","NOME CLIENTE","NOME TRANSP.","VENDEDOR","GRANEL","VOL.GRANEL","VALOR TOTAL","TIPO PEDIDO","OBS VENDEDOR","OBS LOGISTICA","OBS INTERNA"},,oTelVis,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
oListBox3:SetArray(aBrwC5)
oListBox3:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
aBrwC5[oListBox3:nAt,02],;	// FILIAL
aBrwC5[oListBox3:nAt,03],;	// PEDIDO
aBrwC5[oListBox3:nAt,04],;	// CLIENTE
aBrwC5[oListBox3:nAt,05],;	// LOJA
aBrwC5[oListBox3:nAt,06],;	// NOME CLIENTE
aBrwC5[oListBox3:nAt,07],;	// NOME TRANSPORTADORA
aBrwC5[oListBox3:nAt,08],;	// VENDEDOR
aBrwC5[oListBox3:nAt,09],;  // GRANEL
aBrwC5[oListBox3:nAt,10],;  // VOLUME GRANEL
aBrwC5[oListBox3:nAt,11],;	// VALOR TOTAL DO PEDIDO
aBrwC5[oListBox3:nAt,12],;	// TIPO PEDIDO
aBrwC5[oListBox3:nAt,13],;	// obs vend
aBrwC5[oListBox3:nAt,14],;	// obs log
aBrwC5[oListBox3:nAt,15]}}	// obs intern

oTelVis:Refresh()
oListBox3:Refresh()

ACTIVATE MSDIALOG oTelVis centered

Return()



//========================================================================================================================//
// 	Tela para visualizar Pedidos não liberado saldo Estoque																  //
//========================================================================================================================//
Static Function VisPend()

Private cNroOnda := aBrowse[oListBox:nAt,03]
Private cQryC6 		:= ""
Private oOK 		:= LoadBitmap(GetResources(),'br_verde')
Private oNO 		:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias		:= GetNextAlias()
Private oFont 		:= TFont():New('Courier new',,-14,.F.,.T.)

Private aBrwC6		:= {}
Private cNRonda 	:= ""
Private nValor		:= 0
Private oGet
Private oTelVisPen

If Select("TRBC6") > 0
	TRBC6->( dbCloseArea() )
EndIf

cQryC6 := 	" SELECT CASE  "
cQryC6 += 	" WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
cQryC6 += 	" WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA'   "
cQryC6 += 	" WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
cQryC6 += 	" WHEN C5_FILIAL='0902' THEN 'DEVINTEX-MG' "
cQryC6 += 	" ELSE C5_FILIAL END EMPRESA, "
cQryC6 +=	" C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A3_NREDUZ, 
cQryC6 +=	" SUM(C6_VALOR) C6_VALOR, "
	
If cAntec == "SIM"
	cQryC6 +=	" CASE WHEN C6_X_ESTOQ = 'N' THEN 'SEM ESTOQUE' "
	cQryC6 +=	" WHEN C6_X_ESTOQ IN ('X','S') THEN 'COM ESTOQUE' "	
	cQryC6 +=	" WHEN C6_X_ESTOQ = ' ' THEN 'SALDO NÃO PROCESSADO' "
	cQryC6 +=	" ELSE C6_X_ESTOQ END C6_X_ESTOQ, "
Endif

cQryC6 +=	" CASE WHEN C9_BLCRED != '' THEN 'BLOQ. CRÉDITO' END C9_BLCRED "
	
cQryC6 +=	" FROM " +RETSQLNAME("SC5")+ " C5 WITH (NOLOCK) "
cQryC6 +=	" INNER JOIN " +RETSQLNAME("SC6")+ " C6 WITH (NOLOCK) ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C6.D_E_L_E_T_ = '' "
cQryC6 +=	" INNER JOIN " +RETSQLNAME("SA1")+ " A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''	"
cQryC6 +=	" INNER JOIN " +RETSQLNAME("SA4")+ " A4 WITH (NOLOCK) ON C5_TRANSP = A4_COD AND A4.D_E_L_E_T_ = '' 	"
cQryC6 +=	" LEFT JOIN  " +RETSQLNAME("SA3")+ " A3 WITH (NOLOCK) ON C5_VEND1 = A3_COD AND A3.D_E_L_E_T_ = ''  	"                      
cQryC6 +=	" LEFT JOIN SC9020 C9 WITH (NOLOCK) ON C9_PEDIDO = C6_NUM AND C9_FILIAL = C6_FILIAL AND C9_ITEM = C6_ITEM AND C9_PRODUTO = C6_PRODUTO AND C9.D_E_L_E_T_ = '' "
cQryC6 += 	" WHERE C5_X_NONDA = ' ' "
cQryC6 +=	" AND C5.D_E_L_E_T_ = '' "
cQryC6 +=	" AND C5_TIPO = 'N' "
cQryC6 +=	" AND C5_X_STAPV = '0' AND C5_NOTA = '' "      

If cAntec == "SIM"
	cQryC6 +=	" AND ( C6_X_ESTOQ != 'S' OR C9_BLCRED != '') "	// FILTRA SÓ PRODUTOS SEM ESTOQUE / SEM PROCESSADOS
	cQryC6 +=	" GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A3_NREDUZ, C6_X_ESTOQ, C9_BLCRED "
Else
	cQryC6 +=	" AND C9_BLCRED != ''  "
    cQryC6 +=	" GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A3_NREDUZ, C9_BLCRED "	
Endif

cQryC6 +=	" ORDER BY C5_FILIAL,2 "

TCQUERY cQryC6 NEW ALIAS "TRBC6"

//Processa o Resultado
dbSelectArea("TRBC6")
TRBC6->(dbGoTop())

If cAntec == "SIM"

	While TRBC6->(!EOF())
		aAdd(aBrwC6,{	.T.,;
		TRBC6->EMPRESA,;
		TRBC6->C5_NUM,;
		TRBC6->C5_CLIENTE,;
		TRBC6->C5_LOJACLI,;
		TRBC6->A1_NOME,;
		SUBSTR(TRBC6->A3_NREDUZ,1,20),;
		Transform(TRBC6->C6_VALOR,"@E 999,999,999.99"),;
		TRBC6->C6_X_ESTOQ,;
		TRBC6->C9_BLCRED})
		
		TRBC6->(dbSkip())
			
	Enddo

Else

	While TRBC6->(!EOF())
		aAdd(aBrwC6,{	.T.,;
		TRBC6->EMPRESA,;
		TRBC6->C5_NUM,;
		TRBC6->C5_CLIENTE,;
		TRBC6->C5_LOJACLI,;
		TRBC6->A1_NOME,;
		TRBC6->A3_NREDUZ,;
		Transform(TRBC6->C6_VALOR,"@E 999,999,999.99"),;
		TRBC6->C9_BLCRED})
		
		TRBC6->(dbSkip())
			
	Enddo

Endif
	
If Len(aBrwC6) == 0
	If cAntec == "SIM"
		aAdd(aBrwC6,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(02),SPACE(15),SPACE(06),0,SPACE(30),SPACE(30)})
	Else
		aAdd(aBrwC6,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(02),SPACE(50),SPACE(06),0,SPACE(30)})
	Endif
Endif

If cAntec == "SIM"
	DEFINE MSDIALOG oTelVisPen FROM 38,16 TO 600,1200 TITLE Alltrim(OemToAnsi("PEDIDOS PENDENTES SEM ESTOQUE / SALDO NÃO PROCESSADO / BLOQ. CRÉDITO")) Pixel
Else
	DEFINE MSDIALOG oTelVisPen FROM 38,16 TO 600,1200 TITLE Alltrim(OemToAnsi("PEDIDOS COM BLOQUEIO DE CRÉDITO")) Pixel
Endif

@ 002, 005 To 058, 590 Label Of oTelVisPen Pixel

If cAntec == "SIM"
	oSay5  	:= TSay():New(010,010,{|| "PEDIDOS PENDENTES SEM ESTOQUE / SALDO NÃO PROCESSADO / BLOQ. CRÉDITO" },oTelVisPen,,oFont4,,,,.T.,CLR_BLUE)
Else
	oSay5  	:= TSay():New(010,010,{|| "PEDIDOS COM BLOQUEIO DE CRÉDITO" },oTelVisPen,,oFont4,,,,.T.,CLR_BLUE)
Endif
                                                                           
@ 010,530 Button "FECHAR"  size 55,12 action oTelVisPen:End() OF oTelVisPen PIXEL
//@ 024,470 Button "REL. ONDA"  size 55,12 action Processa( {|| RelOnda()}) OF oTelVisPen PIXEL
		
If cAntec == "SIM"
	oListBox4	:= twBrowse():New(059,005,586,215,,{" ","FILIAL","PEDIDO","CLIENTE","LOJA","NOME CLIENTE","VENDEDOR","VALOR TOTAL","STATUS ESTOQUE","STATUS CREDITO"},,oTelVisPen,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	oListBox4:SetArray(aBrwC6)
	oListBox4:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
	aBrwC6[oListBox4:nAt,02],;	// FILIAL
	aBrwC6[oListBox4:nAt,03],;	// PEDIDO
	aBrwC6[oListBox4:nAt,04],;	// CLIENTE
	aBrwC6[oListBox4:nAt,05],;	// LOJA
	aBrwC6[oListBox4:nAt,06],;	// NOME CLIENTE
	aBrwC6[oListBox4:nAt,07],;	// VENDEDOR
	aBrwC6[oListBox4:nAt,08],;	// VALOR TOTAL DO PEDIDO
	aBrwC6[oListBox4:nAt,09],;	// STATUS DO ESTOQUE
	aBrwC6[oListBox4:nAt,10]}}	// STATUS DO CREDITO

Else
	oListBox4	:= twBrowse():New(059,005,586,215,,{" ","FILIAL","PEDIDO","CLIENTE","LOJA","NOME CLIENTE","VENDEDOR","VALOR TOTAL","STATUS CREDITO"},,oTelVisPen,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	oListBox4:SetArray(aBrwC6)
	oListBox4:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
	aBrwC6[oListBox4:nAt,02],;	// FILIAL
	aBrwC6[oListBox4:nAt,03],;	// PEDIDO
	aBrwC6[oListBox4:nAt,04],;	// CLIENTE
	aBrwC6[oListBox4:nAt,05],;	// LOJA
	aBrwC6[oListBox4:nAt,06],;	// NOME CLIENTE
	aBrwC6[oListBox4:nAt,07],;	// VENDEDOR
	aBrwC6[oListBox4:nAt,08],;	// VALOR TOTAL DO PEDIDO
	aBrwC6[oListBox4:nAt,09]}}	// STATUS DO CREDITO

Endif

	
oTelVisPen:Refresh()
oListBox4:Refresh()

ACTIVATE MSDIALOG oTelVisPen centered


Static Function RelOnda1()

If MsgYesNo("DESEJA IMPRIMIR A PROGRAMAÇÃO REF A ONDA NR. "+cNroOnda)
	U_FATR0005(cNroOnda,"N")
Endif     

Return()


Static Function RelOnda2()

If MsgYesNo("DESEJA IMPRIMIR OS ITENS FALTANTES DA ONDA "+cNroOnda)
	U_FATR0009(cNroOnda,"N")
Endif     

Return()
                         

Static Function RelOnda3()      
        
Private dDtProg		:= ctod("  /  /  ")

DEFINE MSDIALOG oFilPGR FROM 000,000 TO 180,300 TITLE Alltrim(OemToAnsi("PARAMETROS REL. PRODUÇÃO")) Pixel

oSayLn		:= tSay():New(0015,0005,{||"DATA PROGRAMAÇÃO"},oFilPGR,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(0015,0080,{|u| if(Pcount()>0,dDtProg:=u,dDtProg) },oFilPGR,40,08,,,,,,,,.T.,,,,,,,,,,"dDtProg",,,,,.F.)

@ 0050, 0050 BmpButton Type 01 Action Close(oFilPGR)
@ 0050, 0080 BmpButton Type 02 Action Close(oFilPGR)

Activate Dialog oFilPGR Centered

If MsgYesNo("DESEJA IMPRIMIR O RELATORIO DA PRODUÇÃO?")
	U_FATR0011(dtos(dDtProg))
Endif

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³ImportArq    ºAutor  ³ Genilson Lucas       ?Data ? 12/01/21º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Importacao de arquivo CSV.		                          º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?ImpLerArq								  				  º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function ImportArq()                                                  
                              //tipo de arquivo 1 para CSV , 2 para TXT
Local nOpc			:= 0

Private cFileArq	:= ""
Private aDadosArq	:= {}


Private cCadastro	:= "Importacao de Arquivo para o Protheus"
Private aSay 		:= {}
Private aButton		:= {}     
//Private OMAINWND	

aAdd( aSay, "Esta rotina ira importar as informacoes contidas em um arquivo")
aAdd( aSay, "INFORMACOES IMPORTANTES" )

//aAdd( aSay, " 1-O nome do arquivo deve ser igual ao nome da tabela a ser importada. Ex: SE1.TXT")

//aAdd( aSay, " 2-O nome das colunas dever?ser igual ao nome dos campos PROTHEUS. Ex: E1_NUM")


AAdd( aButton, { 5, .T., { || cFileArq := cGetFile( "Arquivo Excel | *.XLSX|", "Selecione o arquivo Excel",1, cFileArq, .T. ) } } )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch() } } )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	If !File(cFileArq)
		Alert( "Arquivo nao localizado!!!" )
		Return( Nil )
	Endif
	
	
	
	Processa({|| aDadosArq := ImpLerArq(cFileArq)},"Aguarde Processando a leitura do arquivo...") 
   	If Len(aDadosArq) == 0                                                                                                     
   		Alert( "Nenhum registro sera importado!" )
		Return( Nil )
	Endif
	
Endif

Return aDadosArq


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³ImpLerArq ºAutor  ³Fernando Amorim     ?Data ? 19/03/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Ler o arquivo CSV ou Txt                                    º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?Importação                                                 º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/    

static Function ImpLerArq(cArquivo)

Local cLinha 		:= ""
Local cTrecho 		:= ""
Local nHdl 			:= 0
Local nX 			:= 0
Local nQtde			:= 0
Local nTotReg		:= 0
Local lLinha1 		:= .F.  			// Define se eh a fim de arquivo  
Local nY  			:= 0
Local nI   			:= 0 
Local nLinha        := 0

Private aCpoCabec 	:= {}	
Private aCpoSX3		:= {}
Private aExecAuto		:= {}    
Private aRetExecAu	:= {}
Private nTamCpoX3	:= 10 

nHdl := FT_FUSE(cArquivo)
nTotReg := FT_FLASTREC()
FT_FGOTOP()
ProcRegua(nTotReg)
nY  := 0
nI	:= 0  
nX := 0   

 
  
//	leitura do arquivo txt para montagem dos itens de importação
lLinha0 := .F.
While !FT_FEOF()  .and. !lLinha0
   	

	nI	:= 0
	cLinha := FT_FREADLN()
	cLinha := Alltrim(cLinha)
	nX++
	aDad	:= {} 
	if !Empty(alltrim(cLinha)) .AND. Substr(cLinha,1,2) $ ('10|20')
		While !Empty(alltrim(cLinha))
	  	
			
			aAdd( aDad,   cLinha  )                                             
			cLinha := ' '
		End
		aAdd( aRetExecAu, aDad )
	Else
		lLinha0 := .T.
	
	Endif                                     

	IncProc()

	FT_FSKIP()
End

	

FT_FUSE()



Return  aRetExecAu    

//---------------------------------------------------------//
//  Gerar Log dos Pedidos			                       //
//---------------------------------------------------------//
Static Function LogPV()

Local n	:= 0
Local nHandle   := FCreate("C:\TEMP\Pedidos_Pendentes.txt")

If nHandle >= 0
    FWrite(nHandle, "Pedidos Nao selecionados na Onda:"+ CRLF)

    For n := 1 To Len(aPV)
        FWrite(nHandle, "Filial: " +Alltrim(aPV[n,1])+ " Pedido: "+Alltrim(aPV[n,2])+" Cliente: "+Alltrim(aPV[n,3]) + CRLF)    
    Next

    FClose(nHandle)
EndIf

Return()


Static Function ValiBlq()

If !MsgYesNo("Pedido Bonificado sem Pedido de Venda, confirma esta ação para este Pedidos","Atenção")
		Return()
	Else

		DEFINE MSDIALOG oDlg2 FROM 10,10 TO 0190,0700 TITLE Alltrim(OemToAnsi("MOTIVO DA LIBERAÇÃO")) Pixel 

		oSayLn12:= tSay():New(042.7,0010,{||"Selecionar Motivo:"},oDlg2,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
		oGet13	:= TComboBox():New(040,110,{|u| if(PCount()>0,cDescMot:=u,cDescMot)},aCombo1,100,20,oDlg2,,,,,,.T.,,,,,,,,,"cDescMot") //size 60,10

		ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT EnchoiceBar(oDlg2,{||lOk:=.T., /*MOTLIB(),*/ oDlg2:End() },{||oDlg2:End()},,)

Endif

	If Empty(cDescMot)
		Return()
	Endif

Return()


//BOTÃO PESQUISAR//
Static Function PesqUF()

Local cQuery := ""
aBrwPV	:= {}

If Select("TRBSC6") > 0
	TRBSC6->( dbCloseArea() )
EndIf
  
cQuery :=	" SELECT C5_FILIAL, CASE C5_FILIAL "
cQuery +=	" WHEN '0101' THEN 'CIMEX'       "
cQuery +=	" WHEN '0201' THEN 'CROZE'       "
cQuery +=	" WHEN '0301' THEN 'KOPEK'       "
cQuery +=	" WHEN '0401' THEN 'MACO '       "
cQuery +=	" WHEN '0501' THEN 'QUBIT'       "
cQuery +=	" WHEN '0601' THEN 'ROJA '       "
cQuery +=	" WHEN '0701' THEN 'VIXEN'       "
cQuery +=	" WHEN '0801' THEN 'MAIZE'       "
cQuery +=	" WHEN '0901' THEN 'DEVINTEX FILIAL'  "
cQuery +=	" WHEN '0902' THEN 'DEVINTEX FILIAL - MG' " 
cQuery +=	" WHEN '1001' THEN 'GLAZY' "
cQuery +=	" WHEN '1101' THEN 'BIZEZ' "
cQuery +=	" WHEN '1201' THEN 'ZAKAT' "
cQuery +=	" WHEN '1301' THEN 'HEXIL' "
cQuery +=	" WHEN '1401' THEN 'TROLL' "
cQuery +=	" END EMPRESA, 
cQuery +=	" C5_X_FLAG, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A3_GEREN, A3_NREDUZ,
cQuery +=	" MAX(GRANEL) GRANEL, ROUND(SUM(VALOR),2) VALOR, COUNT(*) SKU, TPPV, "
cQuery +=	" C5_CLIENTE, C5_LOJACLI, TRAVAPV, "
cQuery +=	" A1_EST, "
cQuery +=	" ROUND(SUM(VOLUME),2) VOLUME, "
cQuery +=	" ROUND(SUM(PESO_BRU),2) PESO_BRU, "
cQuery +=	" ROUND(SUM(PESO_LIQ),2) PESO_LIQ, "
cQuery +=	" A4_NREDUZ "
cQuery +=	" FROM (  "
cQuery +=	" SELECT  C5_FILIAL, C5_X_FLAG, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A31.A3_GEREN, A32.A3_NREDUZ, C6_PRODUTO,C9_BLCRED, "
cQuery +=	"  IIF(CAST(C6_QTDVEN AS INT) % CAST(IIF(B1.B1_QE = 0,6,B1.B1_QE) AS INT) > 0,'SIM','') GRANEL, C6_VALOR VALOR "
cQuery +=	"  ,CASE WHEN F4_DUPLIC='S' THEN 'VENDA' WHEN F4_TEXTO LIKE '%TROCA%' THEN 'TROCA' ELSE 'BONIF' END TPPV, C5_CLIENTE, C5_LOJACLI"
cQuery +=	"  ,CASE WHEN BON>0 AND VEN=0 THEN 'B' WHEN BON>0 AND VEN>0 THEN 'L' ELSE ' ' END TRAVAPV, "
cQuery +=	" A1_EST,  (C6_QTDVEN / IIF(B1_QE = 0,1,B1_QE))  VOLUME,C6_QTDVEN * B1_PESBRU PESO_BRU, C6_QTDVEN * B1_PESO PESO_LIQ, A4_NREDUZ "
cQuery +=	" FROM SC5020 C5 WITH (NOLOCK) "
cQuery +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_='' AND C6_LOCAL ='95' " //apenas armazem 95
cQuery +=	" INNER JOIN SC9020 C9 WITH (NOLOCK) ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_=''  "
cQuery +=	" INNER JOIN SA1020 A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI 
		IF alltrim(cUF)<>"ZZZZZZZZZZZZZZZZZZZZ"
			cuf2:=""
			For nCnt := 0 To Len(alltrim(cUF)) Step 2
				if nCnt<>0 .and. (nCnt< Len(alltrim(cUF)))
				nx:=ncnt-1
				cuf2 += substr(cUf,nx,2)+"','" 
				endif

				if nCnt<>0 .and. (nCnt== Len(alltrim(cUF)))
				nx:=ncnt-1
				cuf2 += substr(cUf,nx,2)
				endif

				//nSomaPar += nCnt

			Next

		cQuery +=	" and A1_EST in ('"+cUF2+"') "
		endif
cQuery +=	" AND A1.D_E_L_E_T_=''   "
cQuery +=	" INNER JOIN SB1020 B1 WITH (NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.B1_FILIAL = '    ' AND B1.D_E_L_E_T_ = ''  " 
cQuery +=	" INNER JOIN SF4020 F4 WITH (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES=F4_CODIGO AND F4.D_E_L_E_T_ = '' " 
cQuery +=	" INNER JOIN SA4020 A4 WITH (NOLOCK) ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''  "
cQuery +=	" LEFT JOIN SA3020 A31 WITH (NOLOCK) ON A31.A3_COD = C5_VEND1 AND A31.D_E_L_E_T_ = '' "
cQuery +=	" LEFT JOIN SA3020 A32 WITH (NOLOCK) ON A32.A3_COD = A31.A3_GEREN AND A32.D_E_L_E_T_ = '' "

//Valida Bonificação 
cQuery +=	" INNER JOIN ("
cQuery +=	" SELECT XFIL, XCLI, SUM(BON) BON, SUM(VEN) VEN FROM("
cQuery +=	" SELECT C5_FILIAL XFIL, C5_CLIENTE+C5_LOJACLI XCLI, "
cQuery +=	" CASE WHEN  C5_CONDPAG IN('057','177') THEN 1 ELSE 0 END BON,"
cQuery +=	" CASE WHEN  C5_CONDPAG NOT IN('057','177') THEN 1 ELSE 0 END VEN"
cQuery +=	" FROM SC5020 C5"
cQuery +=	" WHERE C5.D_E_L_E_T_=''"
cQuery +=	" AND C5_EMISSAO>='20211101'"
cQuery +=	" AND C5_X_NONDA = ''"
cQuery +=	" AND C5_LIBEROK = 'S'"
cQuery +=	" AND C5_TIPO = 'N'"
cQuery +=	" AND C5_X_STAPV = '0'"
cQuery +=	" AND C5_NOTA = ''"
cQuery +=	" AND C5_CLIENTE BETWEEN '"+cCliDe+"' 		AND '"+cCliAte+"' "
cQuery +=	" AND C5_EMISSAO BETWEEN '"+DTOS(dDtDE)+"'	AND '"+DTOS(dDtATE)+"' "
	// if alltrim(Xfilial) <>"ZZZZZZZZZZZZZZZZZZZZ"
	// 			For nCnt := 0 To Len(alltrim(xfilial)) Step 4
	// 				if nCnt<>0 .and. (nCnt< Len(alltrim(xfilial)))
	// 				nx:=ncnt-3
	// 				xfilial2 += substr(xfilial,nx,4)+"','" 
	// 				endif

	// 				if nCnt<>0 .and. (nCnt== Len(alltrim(xfilial)))
	// 				nx:=ncnt-3
	// 				xfilial2 += substr(xfilial,nx,4)
	// 				endif

	// 				//nSomaPar += nCnt////////

	// 			Next
				//xfilial:=substr(xfilial,1,4)+"','"+substr(xfilial,6,4)+"','"+substr(xfilial,11,4) //
cQuery +=	" AND C5_FILIAL in ('"+xfilial+"') "
//	endif
cQuery +=	" AND C5_X_DTOLO = '"+DTOS(dProgram)+"' ) TOTALPV"
cQuery +=	" GROUP BY XFIL, XCLI"
cQuery +=	" )TOTPV ON C5_FILIAL=XFIL AND C5_CLIENTE+C5_LOJACLI=XCLI"
//end
cQuery +=	" WHERE C5.D_E_L_E_T_=''  "
cQuery +=	" AND C5_EMISSAO>='20211101'"
cQuery +=	" AND C5_X_NONDA = '' AND C5_LIBEROK = 'S' "
cQuery +=	" AND C5_TIPO = 'N' AND C5_X_STAPV = '0' AND C5_NOTA = ''  "
cQuery +=	" AND C5_CLIENTE BETWEEN '"+cCliDe+"' 		AND '"+cCliAte+"' "
cQuery +=	" AND C5_EMISSAO BETWEEN '"+DTOS(dDtDE)+"'	AND '"+DTOS(dDtATE)+"' "
cQuery +=	" AND A31.A3_GEREN BETWEEN '"+cCliGerDe+"'	AND '"+cCliGerAt+"' "
//if alltrim(Xfilial) <>"ZZZZZZZZZZZZZZZZZZZZ"
cQuery +=	" AND C5_FILIAL in ('"+xfilial+"') "
//endif
cQuery +=	" AND C5_X_DTOLO = '"+DTOS(dProgram)+"'	

IF alltrim(__cUserId)='000859' // WINTER $ GETMV("ES_FATP12R")
	cQuery +=	" AND A1_SATIV1 = '000010' "	
endif

//If cAntec == "SIM"  
//cQuery +=	" AND C6_X_ESTOQ = 'S' " //FILTRA SÓ PRODUTOS COM ESTOQUE
//Endif
cQuery +=	" ) X  "
cQuery +=	" GROUP BY C5_FILIAL, C5_X_FLAG, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A3_GEREN,"
cQuery +=	" TRAVAPV,A3_NREDUZ, TPPV,A4_NREDUZ, C5_CLIENTE, C5_LOJACLI,A1_EST "
cQuery +=	" HAVING SUM(CAST(C9_BLCRED AS INT)) = 0 "

//Ordem de Apresentação do RELATORIO
If cOrdem == "PRIORIDADE"
	cQuery +=	" ORDER BY A1_X_PRIOR, IIF(C5_X_SONLG = '', 'ZZZZ', C5_X_SONLG), A1_NOME, C5_EMISSAO, TPPV,A1_EST "

ElseIf cOrdem == "VALOR"
	cQuery +=	" ORDER BY VALOR DESC "

Else
	cQuery +=	" ORDER BY C5_FILIAL, C5_NUM"    
Endif

MemoWrit("C:\Temp\Log_PROC_INV2_.TXT",cQuery)


TCQUERY cQuery NEW ALIAS "TRBSC6"

//Processa o Resultado
dbSelectArea("TRBSC6")
TRBSC6->(dbGoTop())



// While TRBSZ4->(!EOF())   
    
// 	If TRBSZ4->Z4_IMPRESS == 'NAO'	
// 		lImp := .F.
// 	Else
// 		lImp := .T.
// 	Endif
	 
// 	aAdd(aBrowse,{lImp,;
// 	STOD(TRBSZ4->Z4_DTEMISS),;
// 	TRBSZ4->Z4_NUMONDA,;
// 	TRBSZ4->Z4_HORA,;
// 	TRBSZ4->Z4_USUARIO,;
// 	TRBSZ4->Z4_IMPRESS,;
// 	Transform(TRBSZ4->Z4_VALOR,"@E 999,999,999.99"),;
// 	STOD(TRBSZ4->Z4_DTIMPRE),;
// 	TRBSZ4->Z4_HRIMPRE,;
// 	TRBSZ4->Z4_USUIMPR })
	
// 	TRBSZ4->(dbSkip())
// Enddo

// oListBox:SetArray(aBrowse)
// oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
// aBrowse[oListBox:nAt,02],;
// aBrowse[oListBox:nAt,03],;
// aBrowse[oListBox:nAt,04],;
// aBrowse[oListBox:nAt,05],;
// aBrowse[oListBox:nAt,06],;
// aBrowse[oListBox:nAt,07],;
// aBrowse[oListBox:nAt,08],;
// aBrowse[oListBox:nAt,09],;
// aBrowse[oListBox:nAt,10] }}
// oWindow:Refresh()

// Return()


//regra do Pedido Antecipado
If cAntec == "SIM"
	
	While TRBSC6->(!EOF())
		aAdd(aBrwPV,{IF(ALLTRIM(TRBSC6->C5_X_FLAG) = 'F', .T., .F.)	,;
		TRBSC6->C5_FILIAL,;
		TRBSC6->C5_NUM,;
		TRBSC6->A1_NOME,;
		TRBSC6->A3_GEREN+" "+TRBSC6->A3_NREDUZ,;
		TRBSC6->A1_X_PRIOR,;
		TRBSC6->C5_X_SONLG,;
		TRBSC6->VALOR,;
		TRBSC6->SKU,;
		TRBSC6->GRANEL,;
		0,;
		"SIM",;
		TRBSC6->TPPV,;
		TRBSC6->C5_CLIENTE,;
		TRBSC6->C5_LOJACLI,;
			TRBSC6->TRAVAPV,;
			TRBSC6->EMPRESA,;
		TRBSC6->A1_EST,;
		TRBSC6->VOLUME,;
		TRBSC6->PESO_BRU,;
		TRBSC6->PESO_LIQ,;
		TRBSC6->A4_NREDUZ		})
		
		TRBSC6->(dbSkip())
		
		
		
	Enddo


//Quando estiver preenchido o parametro PROGRAMAÇÃO, trazer marcado
Elseif !Empty(dProgram)
	While TRBSC6->(!EOF())
		aAdd(aBrwPV,{IF(ALLTRIM(TRBSC6->C5_X_FLAG) = 'F', .T., .F.)	,;
		TRBSC6->C5_FILIAL,;
		TRBSC6->C5_NUM,;
		TRBSC6->A1_NOME,;
		TRBSC6->A3_GEREN+" "+TRBSC6->A3_NREDUZ,;
		TRBSC6->A1_X_PRIOR,;
		TRBSC6->C5_X_SONLG,;
		TRBSC6->VALOR,;
		TRBSC6->SKU,;
		TRBSC6->TPPV,;
		TRBSC6->C5_CLIENTE,;
		TRBSC6->C5_LOJACLI,;
		TRBSC6->TRAVAPV,;
		TRBSC6->EMPRESA,;
		TRBSC6->A1_EST,;
		TRBSC6->VOLUME,;
		TRBSC6->PESO_BRU,;
		TRBSC6->PESO_LIQ,;
		TRBSC6->A4_NREDUZ		})
		
		TRBSC6->(dbSkip())
	Enddo


//Demais situações não trazer marcado	
Else
	
	While TRBSC6->(!EOF())
		aAdd(aBrwPV,{IF(ALLTRIM(TRBSC6->C5_X_FLAG) = 'F', .T., .F.) ,;
		TRBSC6->C5_FILIAL,;
		TRBSC6->C5_NUM,;
		TRBSC6->A1_NOME,;
		TRBSC6->A3_GEREN+" "+TRBSC6->A3_NREDUZ,;
		TRBSC6->A1_X_PRIOR,;
		TRBSC6->C5_X_SONLG,;
		TRBSC6->VALOR,;
		TRBSC6->SKU,;
		TRBSC6->TPPV,;
		TRBSC6->C5_CLIENTE,;
		TRBSC6->C5_LOJACLI,;
		TRBSC6->TRAVAPV,;
		TRBSC6->EMPRESA,;
		TRBSC6->A1_EST,;
		TRBSC6->VOLUME,;
		TRBSC6->PESO_BRU,;
		TRBSC6->PESO_LIQ,;
		TRBSC6->A4_NREDUZ		})
		
		TRBSC6->(dbSkip())
	Enddo
	
Endif

If cAntec == "SIM"//
	
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE"},{5,20,20,60,30,20,20,40,20,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED"},{5,20,20,60,30,20,20,40,20,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED"},{5,20,20,60,30,20,20,40,20,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		
	//oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED","","","","EMPRESA","ESTADO","VOLUME","PESO B","PESO L","TRANSP",},{5,15,20,20,60,30,20,20,40,20,15,15,15,15,3,15,15,15,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","GRANEL","VOL. GRANEL","ESTOQUE","TP PED","","","","EMPRESA","ESTADO","VOLUME","PESO B","PESO L","TRANSP",},{5,15,20,20,60,30,20,20,40,20,15,15,15,15,3,15,15,15,15,15,15,15},oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		
		
	oListBo2:SetArray(aBrwPV)
	oListBo2:bLine := {||{ IIf(aBrwPV[oListBo2:nAt][1],LoadBitmap( GetResources(), "UNCHECKED" ),LoadBitmap( GetResources(), "CHECKED" )),; //flag
	aBrwPV[oListBo2:nAt,02],;	//filial
	aBrwPV[oListBo2:nAt,03],;	//pedido
	aBrwPV[oListBo2:nAt,04],;	//cliente
	aBrwPV[oListBo2:nAt,05],;	//GERENTE
	aBrwPV[oListBo2:nAt,06],;	//PRIORIDA
	aBrwPV[oListBo2:nAt,07],;	//PRIORIDADE PEDIDO//
	aBrwPV[oListBo2:nAt,08],;	//VALOR
	aBrwPV[oListBo2:nAt,09],;	//QTD SKU
	aBrwPV[oListBo2:nAt,10],; 	//GRANEL
	aBrwPV[oListBo2:nAt,11],; 	//VOLUME
	aBrwPV[oListBo2:nAt,12],;
	aBrwPV[oListBo2:nAt,13],;	 
	aBrwPV[oListBo2:nAt,14],;	// CODIGO
	aBrwPV[oListBo2:nAt,15],;  	// LOJA
	aBrwPV[oListBo2:nAt,16],;   	// Trava de Pedido 
	aBrwPV[oListBo2:nAt,17],;  	// EMPRESA
	aBrwPV[oListBo2:nAt,18],;  	// estado
	aBrwPV[oListBo2:nAt,19],;  	// VOLUME
	aBrwPV[oListBo2:nAt,20],;  	// PESO BRU
	aBrwPV[oListBo2:nAt,21],;  	// PESOLIQUI
	aBrwPV[oListBo2:nAt,22]}}	// Transportadora
	
	// AO Desmarcar o sistema não esta zerando a quantidade de volumes. (09/08/2018)
	 //oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(), IIf(!aBrwPV[oListBo2:nAt,1],IIf(aBrwPV[oListBo2:nAt,7]="SIM",TelaSLPV(),AtuAcols()),AtuAcols()), aBrwPV[oListBo2:nAt,8] := IIF(Len(aRetDados)>0, aRetDados[1],0),oListBo2:Refresh() } 

   	oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),;
   	(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(),;
   	IIf(!aBrwPV[oListBo2:nAt,1],IIf(aBrwPV[oListBo2:nAt,10]="SIM",TelaSLPV(),AtuAcols()),AtuAcols()),; 
   	aBrwPV[oListBo2:nAt,11] := IIF(aBrwPV[oListBo2:nAt,10]="SIM",IIF(Len(aRetDados)>0,aRetDados[1],0),0),oListBo2:Refresh(),;
    IIf(aBrwPV[oListBo2:nAt,16]="B",/*ValiBlq()*/,),oListBo2:Refresh(),;
	aBrwPV[oListBo2:nAt,11] := IIF(aBrwPV[oListBo2:nAt,1],0,aBrwPV[oListBo2:nAt,11]), oListBo2:Refresh() }
	
	
//
Else
	
	oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","TP PED"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	oListBo2:SetArray(aBrwPV)
	oListBo2:bLine := {||{ IIf(aBrwPV[oListBo2:nAt][1],LoadBitmap( GetResources(), "UNCHECKED" ),LoadBitmap( GetResources(), "CHECKED" )),; //flag
	aBrwPV[oListBo2:nAt,02],;
	aBrwPV[oListBo2:nAt,03],;
	aBrwPV[oListBo2:nAt,04],;
	aBrwPV[oListBo2:nAt,05],;
	aBrwPV[oListBo2:nAt,06],;
	aBrwPV[oListBo2:nAt,07],;
	aBrwPV[oListBo2:nAt,08],;
	aBrwPV[oListBo2:nAt,09],;
	aBrwPV[oListBo2:nAt,10],;
	aBrwPV[oListBo2:nAt,11],; // Cliente
	aBrwPV[oListBo2:nAt,12],; // Loja
	aBrwPV[oListBo2:nAt,13],; // Trava de Pedido 
	}}

	oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(), AtuAcols()  } 

Endif
           
oGet1:Refresh()
oTelPV:Refresh()
oListBo2:Refresh() 


//ACTIVATE MSDIALOG oTelPV centered

Return()             


Static Function Marcar()
 	
//Sempre Zera para Calcular novamente
nValor 		:= 0	
nQtdVOL  :=0
nSomaB :=0	
nQtdSku		:= 0
nPedSel		:= 0

nValVend1	:= 0
nValVend2	:= 0
nValVend3	:= 0
nValVend4	:= 0
nValVend5	:= 0
nValVend6	:= 0
nValVend7	:= 0
nValVend8	:= 0
nValVendO	:= 0

nValPerc1	:= 0
nValPerc2	:= 0
nValPerc3	:= 0
nValPerc4	:= 0
nValPerc5	:= 0
nValPerc6	:= 0
nValPerc7	:= 0
nValPerc8	:= 0

DBSelectarea("SC5")
DBSetOrder(1)
DBSeek(aBrwPV[oListBo2:nAt,2]+aBrwPV[oListBo2:nAt,3],.F.)
If !aBrwPV[oListBo2:nAt,1]
	Reclock("SC5",.F.)
		SC5->C5_X_FLAG	:= .T. //  marcar
	msunlock()
endif	
// Else
// 	Reclock("SC5",.F.)
// 		SC5->C5_X_FLAG	:= .F.
// 	msunlock()
// EndIf 

For nx := 1 To Len(aBrwPV)
	if cAntec == "SIM" .and. aBrwPV[nx][10]=="SIM" //granel
	aBrwPV[nx][1]:=.T.
	else 
	aBrwPV[nx][1]:=.F.
	endif
	If !aBrwPV[nx][1]				//Campo MARCADO (.F.)
		nValor 	+= aBrwPV[nx][8]		// Valor
		nQtdSku += aBrwPV[nx][9]
		if cAntec == "SIM"
		nQtdVOL +=aBrwPV[nx][19]
		nSomaB +=aBrwPV[nx][20]
		else 
		nQtdVOL +=aBrwPV[nx][16]
		nSomaB +=aBrwPV[nx][17]
		endif
		
		If LEFT(aBrwPV[nx][5],6) == '000002' //CALOS
			nValVend1 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000007' //MARCELO
			nValVend2 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000010' //MARCELO
			nValVend3 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000004' //MARCELO
			nValVend4 += aBrwPV[nx][8]	
		ElseIf LEFT(aBrwPV[nx][5],6) == '000005' //MARCELO
			nValVend5 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000008' //MARCELO
			nValVend6 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000003' //MARCELO
			nValVend7 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000006' //MARCELO
			nValVend8 += aBrwPV[nx][8]
		Else
			nValVendO += aBrwPV[nx][8]
		EndIf
		
		nPedSel++
	
	Endif 
		
Next nx

nQtdSku 	:= nQtdSku / nPedSel
nValPerc1	:= (nValVend1 / nValorOnda) * 100
nValPerc2	:= (nValVend2 / nValorOnda) * 100
nValPerc3	:= (nValVend3 / nValorOnda) * 100
nValPerc4	:= (nValVend4 / nValorOnda) * 100
nValPerc5	:= (nValVend5 / nValorOnda) * 100
nValPerc6	:= (nValVend6 / nValorOnda) * 100
nValPerc7	:= (nValVend7 / nValorOnda) * 100
nValPerc8	:= (nValVend8 / nValorOnda) * 100
nValPercO	:= (nValVendO / nValorOnda) * 100

//Refresh em Tela
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()
oGet4:Refresh()
oGet5:Refresh()
oGet6:Refresh()
oGet7:Refresh()
oGet8:Refresh()
oGetO:Refresh()
oGetT:Refresh()
oGetQ:Refresh()
oGetP:Refresh()

oSay1:Refresh()
oSay2:Refresh()
oSay3:Refresh()
oSay4:Refresh()
oSay5:Refresh()
oSay6:Refresh()
oSay7:Refresh()
oSay8:Refresh()
oSayO:Refresh()

oTelPV:Refresh()
oListBo2:Refresh()

Return()
//Return

Static Function Desmarcar()
  //Sempre Zera para Calcular novamente
nValor 		:= 0	
nQtdVOL  :=0
nSomaB :=0	
nQtdSku		:= 0
nPedSel		:= 0

nValVend1	:= 0
nValVend2	:= 0
nValVend3	:= 0
nValVend4	:= 0
nValVend5	:= 0
nValVend6	:= 0
nValVend7	:= 0
nValVend8	:= 0
nValVendO	:= 0

nValPerc1	:= 0
nValPerc2	:= 0
nValPerc3	:= 0
nValPerc4	:= 0
nValPerc5	:= 0
nValPerc6	:= 0
nValPerc7	:= 0
nValPerc8	:= 0

DBSelectarea("SC5")
DBSetOrder(1)
DBSeek(aBrwPV[oListBo2:nAt,2]+aBrwPV[oListBo2:nAt,3],.F.)
If aBrwPV[oListBo2:nAt,1]
	Reclock("SC5",.F.)
		SC5->C5_X_FLAG	:= .F. // desmarcar
	msunlock()
endif	
// Else
// 	Reclock("SC5",.F.)
// 		SC5->C5_X_FLAG	:= .F.
// 	msunlock()
// EndIf 

For nx := 1 To Len(aBrwPV)
	aBrwPV[nx][1]:=.T.
	If !aBrwPV[nx][1]				//Campo MARCADO (.F.)
		nValor 	+= aBrwPV[nx][8]		// Valor
		nQtdSku += aBrwPV[nx][9]
		if cAntec == "SIM"
		nQtdVOL +=aBrwPV[nx][19]
		nSomaB +=aBrwPV[nx][20]
		else 
		nQtdVOL +=aBrwPV[nx][16]
		nSomaB +=aBrwPV[nx][17]
		endif
		
		If LEFT(aBrwPV[nx][5],6) == '000002' //CALOS
			nValVend1 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000007' //MARCELO
			nValVend2 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000010' //MARCELO
			nValVend3 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000004' //MARCELO
			nValVend4 += aBrwPV[nx][8]	
		ElseIf LEFT(aBrwPV[nx][5],6) == '000005' //MARCELO
			nValVend5 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000008' //MARCELO
			nValVend6 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000003' //MARCELO
			nValVend7 += aBrwPV[nx][8]
		ElseIf LEFT(aBrwPV[nx][5],6) == '000006' //MARCELO
			nValVend8 += aBrwPV[nx][8]
		Else
			nValVendO += aBrwPV[nx][8]
		EndIf
		
		nPedSel++
	
	Endif 
		
Next nx

nQtdSku 	:= nQtdSku / nPedSel
nValPerc1	:= (nValVend1 / nValorOnda) * 100
nValPerc2	:= (nValVend2 / nValorOnda) * 100
nValPerc3	:= (nValVend3 / nValorOnda) * 100
nValPerc4	:= (nValVend4 / nValorOnda) * 100
nValPerc5	:= (nValVend5 / nValorOnda) * 100
nValPerc6	:= (nValVend6 / nValorOnda) * 100
nValPerc7	:= (nValVend7 / nValorOnda) * 100
nValPerc8	:= (nValVend8 / nValorOnda) * 100
nValPercO	:= (nValVendO / nValorOnda) * 100

//Refresh em Tela
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()
oGet4:Refresh()
oGet5:Refresh()
oGet6:Refresh()
oGet7:Refresh()
oGet8:Refresh()
oGetO:Refresh()
oGetT:Refresh()
oGetQ:Refresh()
oGetP:Refresh()

oSay1:Refresh()
oSay2:Refresh()
oSay3:Refresh()
oSay4:Refresh()
oSay5:Refresh()
oSay6:Refresh()
oSay7:Refresh()
oSay8:Refresh()
oSayO:Refresh()

oTelPV:Refresh()
oListBo2:Refresh()

Return()


Static Function Transf01()
Local nx		:= 0
Local nPed		:= 0
Local nCont		:= 0
Local n1		:= 0

local aCabec         := {}
local     aItens         := {}
local  aLinha         := {}
local lMsErroAuto    := .F.
local   lAutoErrNoFile := .F.  
local nOpcX := 4 //Alteracao

Private oDlg1	:= Nil
Private cPedSel	:= ""
Private cTpVen	:= ""

cPedido	:= ""


//Valida no Browser Pedido Antecipado
//If cAntec == "SIM"	// Antecipado
	
	For nx := 1 To Len(aBrwPV)
		
		If !aBrwPV[nx][1]		// Pedido Marcado///
					cPedido:=alltrim(aBrwPV[nx][3])
					aCabec         := {}
					aItens         := {}
					aLinha         := {}
					DBSELECTAREA('SC6')
					DBSETORDER(1)
					DBSELECTAREA('SC9')
					DBSETORDER(1)
					DBSELECTAREA('SC5')
					DBSETORDER(1)
					SC6->(DBSEEK(XFILIAL("SC6")+cPedido))
					SC9->(DBSEEK(XFILIAL("SC9")+cPedido))
			if SC5->(DBSEEK(XFILIAL("SC5")+cPedido))	
					//MSGINFO("passou pedido  "+cPedido+" Cliente "+SC5->C5_CLIENTE+" LOJA "+SC5->C5_LOJACLI)
					aadd(aCabec,{"C5_NUM"    , cPedido     , Nil})
					aadd(aCabec,{"C5_TIPO"   ,SC5->C5_TIPO      , Nil})
					aadd(aCabec,{"C5_CLIENTE", SC5->C5_CLIENTE   , Nil})
					aadd(aCabec,{"C5_LOJACLI", SC5->C5_LOJACLI  , Nil})
					aadd(aCabec,{"C5_LOJAENT", SC5->C5_LOJAENT  , Nil})
					aadd(aCabec,{"C5_CONDPAG", SC5->C5_CONDPAG, Nil})   
													
													//verifico se o usuario solicitou a troca dos armazens de 95 para 01 para tabelas sc6 e sc9
												//if SC6->(DBSEEK(xFilial('SC6')+cPedido )) .and. SC9->(DBSEEK(xFilial('SC9')+cPedido )) // se a variavel para 
												  		//aLinha := {}
														while SC6->C6_NUM == cPedido .and. SC6->C6_FILIAL==cFilAnt
														//  Reclock("SC6",.F.)
														// 	SC6->C6_LOCAL := "01"
														//  Msunlock()
														aLinha := {}
															AADD(aLinha,{"C6_FILIAL",SC6->C6_FILIAL,nil })
															AADD(aLinha,{"C6_ITEM",SC6->C6_ITEM,nil })
															AADD(aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO,nil })
															AADD(aLinha,{"C6_DESCRI",SC6->C6_DESCRI,nil })
															AADD(aLinha,{"C6_UM",SC6->C6_UM,nil })
															AADD(aLinha,{"C6_QTDVEN",SC6->C6_QTDVEN,nil })
															AADD(aLinha,{"C6_PRCVEN",SC6->C6_PRCVEN,nil })
															AADD(aLinha,{"C6_VALOR",SC6->C6_VALOR,nil })
															AADD(aLinha,{"C6_TES",SC6->C6_TES,nil })
															AADD(aLinha,{"C6_CF",SC6->C6_CF,nil })
															AADD(aLinha,{"C6_UNSVEN",SC6->C6_UNSVEN,nil })
															AADD(aLinha,{"C6_QTDENT",SC6->C6_QTDENT,nil })
															AADD(aLinha,{"C6_QTDENT2",SC6->C6_QTDENT2,nil })
															AADD(aLinha,{"C6_LOCAL",'01',nil })
															AADD(aLinha,{"C6_CLI",SC6->C6_CLI,nil })
															AADD(aLinha,{"C6_ENTREG",SC6->C6_ENTREG,nil })
															AADD(aLinha,{"C6_LOJA",SC6->C6_LOJA,nil })
															AADD(aLinha,{"C6_DATFAT",SC6->C6_DATFAT,nil })
															AADD(aLinha,{"C6_NOTA",SC6->C6_NOTA,nil })
															AADD(aLinha,{"C6_SERIE",SC6->C6_SERIE,nil })
															AADD(aLinha,{"C6_NUM",SC6->C6_NUM,nil })
															AADD(aLinha,{"C6_PRUNIT",SC6->C6_PRUNIT,nil })
															AADD(aLinha,{"C6_TPOP",SC6->C6_TPOP,nil })
															AADD(aLinha,{"C6_SUGENTR",SC6->C6_SUGENTR,nil })
															AADD(aLinha,{"C6_DTFIMNT",SC6->C6_DTFIMNT,nil })
															AADD(aLinha,{"C6_VDOBS",SC6->C6_VDOBS,nil })
															AADD(aLinha,{"C6_ITEMPC",SC6->C6_ITEMPC,nil })
															AADD(aLinha,{"C6_NUMPCOM",SC6->C6_NUMPCOM,nil })
															AADD(aLinha,{"C6_RATEIO",SC6->C6_RATEIO,nil })
															AADD(aLinha,{"C6_TPPROD",SC6->C6_TPPROD,nil })
															AADD(aLinha,{"C6_CONTA",SC6->C6_CONTA,nil })
															AADD(aLinha,{"C6_DATCPL",SC6->C6_DATCPL,nil })
															AADD(aLinha,{"C6_INTROT",SC6->C6_INTROT,nil })
															AADD(aLinha,{"C6_X_VCXIM",SC6->C6_X_VCXIM,nil })
															AADD(aLinha,{"C6_DATAEMB",SC6->C6_DATAEMB,nil })
														aadd(aItens, aLinha)
														SC6->(DBSKIP())
														ENDDO
														//MSGINFO("TRANSFERENCIA REALIZADA  "+cPedido+" Cliente "+SC5->C5_CLIENTE+" LOJA "+SC5->C5_LOJACLI)
														MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.) 

														If !lMsErroAuto
															ConOut("Alterado com sucesso! Pedido: " + cPedido)
														Else
															ConOut("Erro na alteracao!")
															MOSTRAERRO()
														EndIf

														// while SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL==cFilAnt
														//  Reclock("SC9",.F.)
														// 	SC9->C9_LOCAL := "01"
														//  Msunlock()
														// SC9->(DBSKIP())
														// ENDDO
			endif									//endif		
													
		endif
	Next nx	

	MSGINFO("TRANSFERENCIA REALIZADA")

oTelPV:End()

Return()



user function emailped(aPedmail)

	Local cQuery :=""
	Local cTRB0  := CriaTrab(NIL, .F.)
	Local cTRB  := CriaTrab(NIL, .F.)	
	Local cQuery2 :=""
	Local cTRB2  := CriaTrab(NIL, .F.)	
	Local cTitulo := ""
	Local cTitulo2 := ""
	Local dData1
	Local dData5 := DtoC(Date())
	Local cDestinatarios := ""
	Local cAssunto := ""
	Local cNum :=""
	local nw

//PREPARE ENVIRONMENT EMPRESA ( "05" ) FILIAL ( "1201" ) MODULO "FAT"
	
	//Definição dos valores específicos
	
	//cDestinatarios := "suporte@coferly.com.br;" // UsrRetMail(cUserID)
	cAssunto 		 := " |PEDIDO NAO LIBERADOS, SALDO DISPONIVEL INSUFICIENTE| Email Automático, Favor Não Responder."
	cTitulo        := " PEDIDOS NAO LIBERADOS "
	cTitulo2       := " ITENS DO PEDIDO COM SALDO INSUFICIENTE "
	
	// cQry 		 :=""
	// // cQry 		 += " select * from SAK120 "
	// // cQry          += " where D_E_L_E_T_ ='' "
	// // cQry         += " ORDER BY  AK_COD  "

	// 	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cTRB0, .T., .F.)	
	
 	
//While ((cTRB0)->(!Eof()))
 
	cDestinatarios := "luiz.vasconcelos@salonline.com.br;demanda@salonline.com.br;"//+ IIF( alltrim((cTRB0)->AK_COD) <>'' ,alltrim(UsrRetMail((cTRB0)->AK_USER)) ,"suporte@coferly.com.br") //000043 +alltrim(UsrRetMail((cTRB0)->AK_USER)) //pega email do aprovador 
	//cQuery 		 :=""
	//cQuery 		 += " select CR_FILIAL, CR_NUM, CR_TIPO, CR_TOTAL,CR_MOEDA,CR_TXMOEDA,(CR_TOTAL * CR_TXMOEDA) as VALOR_CONVERSAO_REAL, CR_EMISSAO, CR_GRUPO, CR_APROV, CR_NIVEL, CR_STATUS, * from SCR120 "
	//cQuery         += " WHERE  D_E_L_E_T_='' AND CR_STATUS='02' AND CR_EMISSAO >='20200101' AND CR_APROV ="+"'"+(cTRB0)->AK_COD+"'"+ " 
	//cQuery         += " ORDER BY CR_APROV "

	//	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cTRB, .T., .F.)	
if 	!Empty(cDestinatarios)//(cTRB)->CR_APROV)  //((cTRB)->(!Eof())))
 	
	_cHTML:='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	_cHTML+='<html xmlns="http://www.w3.org/1999/xhtml">'
	_cHTML+='<head>'
	_cHTML+='<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
	_cHTML+='<title>ZAKAT- Pedidos nao Liberados - saldo disponivel insuficiente</title>'
	_cHTML+='<style type="text/css"> '
	_cHTML+='table.bordasimples {border-collapse: collapse;} '
	_cHTML+='table.bordasimples tr td {border:1px solid #ccc; padding:0 0 0 10px;font:16px "Calibri"} '
	_cHTML+='.slogan{width: 400px;height:50px;font:16px "Calibri", Times, serif;color:#999;}'
	_cHTML+='</style>'
	_cHTML+='</head>'
	// _cHTML+='<body>'
	// _cHTML+='<H3 class="slogan">E-mail automático enviado pelo sistema Totvs Protheus</H3>'
	// _cHTML+='<H3 class="slogan">'+cTitulo+'</H3>'
	// _cHTML+='<table style="width: 1800px;" class="bordasimples" border="1" bordercolor="#cccccc" >'
	// _cHTML+='		<TR>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Filial</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Nº Pedido</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Tipo</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Total</td>'	
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Moeda</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Taxa</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Valor Conversao Real</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Dt. Emissao</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Grupo</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Aprovador</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Nivel</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Status</td>'
	// _cHTML+='		</TR>'
	
	//cAprov := (cTRB)->CR_APROV
		//While ((cTRB)->(!Eof())) //.AND. cr_ujser =
		
		// dData1 := StoD((cTRB)->CR_EMISSAO)
		// cNum += ","+"'"+alltrim((cTRB)->CR_NUM )+"'"
		// //cMoeda := (cTRB)->CR_MOEDA
		// 	_cHTML+='		<TR>	'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_FILIAL+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_NUM+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_TIPO+'</TD>'
		// 	//_cHTML+='			<TD style="font-size:14px;">'+cValToChar((cTRB)->CR_TOTAL)+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB)->CR_TOTAL,6),"@E 999,999.99 ")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+IIF ( (cTRB)->CR_MOEDA ==1 ,"REAL" ,"DOLAR")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB)->CR_TXMOEDA,6),"@E 999,999.9999 ")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+"R$ "+Transform(round((cTRB)->VALOR_CONVERSAO_REAL,6),"@E 999,999.99 ")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->(DtoC(dData1))+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_GRUPO+"-"+ alltrim(POSICIONE("SAL",1,XFILIAL("SAL")+alltrim((cTRB)->CR_GRUPO),"AL_DESC"))+		'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_APROV+" - "+ alltrim(POSICIONE("SAK",1,XFILIAL("SAK")+alltrim((cTRB)->CR_APROV),"AK_LOGIN"))+	'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_NIVEL+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_STATUS +" - AGUARDANDO LIBERACAO DE USUARIO" +'</TD>'
		// 	_cHTML+='		</TR>'
		// 	(cTRB)->(DbSkip())
		// 	if Empty((cTRB)->CR_APROV)
		// 	cNum:= Alltrim (substr(cNum, 2, 400))  
		// 	//(cTRB)->(dbclosearea())
		// 	endif
		// 	//cAprov := (cTRB)->CR_APROV
		// //EndDo		
		//cNum
		//cNum:= Alltrim (substr(cNum, 2, 400)) 
	// 	cQuery2 :=""
	// 	cQuery2        += " SELECT C7_ITEM,C7_OBS, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_TOTAL,C7_MOEDA, C7_TXMOEDA,(C7_TOTAL * C7_TXMOEDA) as VALOR_CONVERSAO_REAL, C7_CC,C7_CONTA, C7_FORNECE, * FROM SC7020  "
	// 	cQuery2        += " WHERE D_E_L_E_T_='' AND C7_ORIGEM ='MATA170' AND C7_ENCER <>'E' AND C7_QUJE ='0'    " //arrumar regra pra mandar penas em aberto pendente que seja do ponto por pedido

	// 	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery2), cTRB2, .T., .F.)
	// cnum:=""
	// _cHTML+='	</TBODY>'
	// _cHTML+='</TABLE>'
	_cHTML+='<H3 class="slogan">'+cTitulo2+'</H3>'
	_cHTML+='<table style="width: 1800px;" class="bordasimples" border="1" bordercolor="#cccccc" >'
	_cHTML+='		<TR>'
		_cHTML+='		<td style="background-color: rgb(238, 238, 238); font-weight: bold;">N° Pedido</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Item</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Produto</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Descricao</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Quant Pedido</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Quant disponivel </td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Total</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Moeda</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Taxa</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Valor Conversao Real</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Centro Custo</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Conta</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Fornecedor</td>'
	_cHTML+='		</TR>'
		For nw := 1 To Len(aPedmail)
		//While ((cTRB2)->(!Eof()))
		
		//dData2 := StoD((cTRB2)->XI2_DTVENC)
			
			_cHTML+='		<TR>	'
			_cHTML+='			<TD style="font-size:14px;">'+aPedmail[nw][2]+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+aPedmail[nw][3]+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+alltrim(aPedmail[nw][4])+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+alltrim(aPedmail[nw][4]),"B1_DESC"))+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+cValToChar( aPedmail[nw][5])+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+cValToChar( aPedmail[nw][6])+'</TD>'
		//	_cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB2)->C7_PRECO,6),"@E 999,999.99 ")+'</TD>'   
		//	_cHTML+='			<TD style="font-size:14px;">'+cValToChar( (cTRB2)->C7_PRECO )+'</TD>' 
			// _cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB2)->C7_TOTAL,6),"@E 999,999.99 ")+'</TD>' 
			// _cHTML+='			<TD style="font-size:14px;">'+IIF ( (cTRB2)->C7_MOEDA ==1 ,"REAL" ,"DOLAR")+'</TD>
			// _cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB2)->C7_TXMOEDA,6),"@E 999,999.9999 ")+'</TD>
			// _cHTML+='			<TD style="font-size:14px;">'+"R$ "+Transform(round((cTRB2)->VALOR_CONVERSAO_REAL,6),"@E 999,999.99 ")+'</TD>
			
		//	_cHTML+='			<TD style="font-size:14px;">'+cValToChar( (cTRB2)->C7_TOTAL)+'</TD>' 
			//_cHTML+='			<TD style="font-size:14px;">'+DtoC(dData2)+'</TD>'
			// _cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->C7_CC+" - "+IIF( Empty(alltrim((cTRB2)->C7_CC)) ,"",alltrim(POSICIONE("CTT",1,XFILIAL("CTT")+alltrim((cTRB2)->C7_CC),"CTT_DESC01")))  +'</TD>'
			// _cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->C7_CONTA+" - "+alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+alltrim((cTRB2)->C7_CONTA),"CT1_DESC01"))+'</TD>'
			// _cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->C7_FORNECE +" - "+alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+alltrim((cTRB2)->C7_FORNECE),"A2_NOME"))+'</TD>'
			// //_cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->XI2_STATUS+'</TD>'
			_cHTML+='		</TR>'
			//(cTRB2)->(DbSkip())
		//EndDo	
		next nw

		dData5 := DtoC(Date())
		
	_cHTML+='	</TBODY>'
	_cHTML+='</TABLE>'
	_cHTML+='<div class="slogan" style="margin-top:30px;"> Lista atualizada em: '+ dData5 +' às '+Time()+'.</div>'
	_cHTML+='</BODY>'
	_cHTML+='</HTML>'
//u_g2EnvMail(cDestinatarios,,, cAssunto, _cHTML, NIL,'', .F., ,.F.)
	U_ENVMAIL2(,cDestinatarios,cAssunto,_cHTML,NIL,.F.)	
//	U_SendMail( cMail,_cTo,, cAssunto, cBody, )
	//(cTRB2)->(dbclosearea())
ENDIF	
//(cTRB0)->(DbSkip())
//(cTRB)->(dbclosearea())
//(cTRB2)->(dbclosearea())
cNum :=""
//EndDo		


//RESET ENVIRONMENT
Return

/*
-----------------------------------------------
* Progrma: EnvMail      Autor: luiz henrique *
* Descrição: Rotina para envio de emails.     *
* Data: 23/12/2020	                           *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
-----------------------------------------------
*/

User Function ENVMAIL2(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Variaveis da função

Private _nTentativas := 0
Private _cSMTPServer := GetMV("MV_RELSERV")
Private _cAccount    := GetMV("MV_RELACNT")
Private _cPassword   := GetMV("MV_RELPSW")
Private _lEnviado    := .F.
Private _cUsuario    := Upper(AllTrim(cUserName))

// Validação dos campos do email

If _pcBcc == NIL
	_pcBcc := ""
EndIf

_pcBcc := StrTran(_pcBcc," ","")

If _pcOrigem == NIL
	_pcOrigem := GetMV("MV_RELACNT")
EndIf

_pcOrigem := StrTran(_pcOrigem," ","")

If _pcDestino == NIL
	_pcDestino := "seuemail@dominio.com.br"
EndIf

_pcDestino := StrTran(_pcDestino," ","")

If _pcSubject == NIL
	_pcSubject := "Sem Subject (ENVMAIL)"
EndIf

If _pcBody == NIL
	_pcBody := "Sem Body (ENVMAIL)"
EndIf

If _pcArquivo == NIL
	_pcArquivo := ""
EndIf

For _nAux := 1 To 10
	_pcOrigem := StrTran(_pcOrigem," ;","")
	_pcOrigem := StrTran(_pcOrigem,"; ","")
Next

If _plAutomatico == NIL
	_plAutomatico := .F.
EndIf

// Executa a função, mostrando a tela de envio (.T.) ou não (.F.)

If !_plAutomatico
	Processa({||EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)},"Enviando Email(s)...")
Else
	EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
EndIf

If !_plAutomatico
	If !_lEnviado
		MsgStop("Atenção: Erro no envio de Email!!!")
	EndIf
Else
	ConOut("Atenção: Erro no envio de Email!")
Endif

Return _lEnviado

/*
***********************************************
* Progrma: EnviaEmail   Autor: Luiz Henrique  *
* Descrição: Subrotina para envio de email.   *
* Data: 23/12/2020                           *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 
Static Function EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Veriaveis da função
//**************************************************************
Local _nTentMax := 50  // Tentativas máximas
Local _nSecMax  := 30  // Segundos máximos  
Local _cTime    := (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
Local _nAuxTime := 0
Local lAutentica    := GetMV("MV_RELAUTH") 

// O que ocorrer primeiro (segundos ou tentativas), ele para.
//**************************************************************
_cTime += _nSecMax

If !_plAutomatico
	ProcRegua(_nTentMax)
EndIf

// Exibe mensagem no console/Log
//**************************************************************
ConOut("ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

For _nTentativas := 1 To _nTentMax
	
	If !_plAutomatico
		IncProc("Tentativa "+AllTrim(Str(_nTentativas)))
	EndIf
	ConOut("ENVMAIL=> ***** Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
	
	CONNECT SMTP SERVER _cSMTPServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lEnviado
	
	
	If _lEnviado
	
		// Verifica se o E-mail necessita de Autenticacao
     	If lAutentica     
        	_lEnviado := MailAuth(_cAccount,_cPassword) 
    	Else
       	_lEnviado := .T.
    	Endif
    	
		If Empty(_pcBcc)
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		Else
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		EndIf
		DISCONNECT SMTP SERVER
	EndIf
	
	If _lEnviado .Or. _cTime <= (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
		_nTentativas := _nTentMax
	EndIf
	
Next

ConOut("ENVMAIL=> ***** Resultado de Envio "+IIf(_lEnviado,"T","F")+" / "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

Return
