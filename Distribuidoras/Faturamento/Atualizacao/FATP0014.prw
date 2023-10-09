#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATP0014 ³ Autor ³ André Valmir 		³ Data ³02/08/2018    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela Mota Onda Antecipado								  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      			  		   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	  ³±±

±±³ 																	  ³±±
±±³ 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function FATP0014()

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
Private aBrowse	:= {}
Private aAntec	:= {"SIM","NAO"}
Private cAntec	:= ""
Private oGet
Private lLibAnt
Private cUserLib := RetCodUsr()
Private cNomUser := USRRETNAME(RetCodUsr())

//Tela Inicial
//TELAINIC()
U_FATP0010()

Return()



Static Function TELAINIC() 

If Len(aBrowse) == 0
	aAdd(aBrowse,{.T.,CTOD(" / / "),SPACE(08),SPACE(08),SPACE(08),SPACE(10),SPACE(08),CTOD(" / / "),SPACE(08),SPACE(08)})
Endif

DEFINE MSDIALOG oWindow FROM 38,16 TO 600,880 TITLE Alltrim(OemToAnsi("MONTA ONDA POR FILIAL"+" - ULTIMA ATUALIZAÇÃO DO ESTOQUE "+ALLTRIM(GETMV("ES_FATP011")))) Pixel

cAmbos		:= aCombo[3]

@ 002, 005 To 058, 425 Label Of oWindow Pixel

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


If cUserLib $ GETMV("ES_USUANTC")
		                                                                           
	@ 043,220 Button "ATUAL. EST." size 45,12 action Processa( {|| FATP0014E() }) OF oWindow PIXEL
		
Endif                                 


@ 008,360 Button "INCLUIR" size 57,12 action Processa( {|| IncOnda() }) OF oWindow PIXEL
@ 025,360 Button "ORDEM SEPARACAO" size 57,12 action Processa( {|| ImpOnda() }) OF oWindow PIXEL
@ 043,360 Button "FECHAR"  size 57,12 action oWindow:End() OF oWindow PIXEL

//@ 014,360 Button "EXCLUIR" size 55,12 action Processa( {|| ExcOnda() }, "AGUARDE EXCLUINDO...") OF oWindow PIXEL

oListBox	:= twBrowse():New(059,005,420,215,,{" ","DATA","NUMERO","HORA","USUARIO","IMPRESSO","VALOR","DATA IMPR.","HORA IMPR.","USUARIO IMPR."},{10,25,30,20,20,40,40,35,35,20},oWindow,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

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
aBrowse[oListBox:nAt,10]}}  // Usuario Imprimiu

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
cQrySZ4 +=	" WHERE D_E_L_E_T_ = ''	AND Z4_TIPO = 'A' "

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
Private dDtDE		:= ctod("01/01/2018")	
Private dDtATE		:= ddatabase		
Private cCliGerDe	:= space(6)
Private cCliGerAt	:= "ZZZZZZ"
Private nValorOnda	:= 3000000

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

oSayLn1		:= tSay():New(0015,0005,{||"APRESENTAR POR?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oComboORD	:= TComboBox():New(0015,0080,{|u| if(PCount()>0,cOrdem:=u,cOrdem)},aOrdem,50,08,oFiltro,,,,,,.T.,,,,,,,,,"cOrdem")

oSayLn2		:= tSay():New(0030,0005,{||"CLIENTE DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet		:= tGet():New(0030,0080,{|u| if(Pcount()>0,cCliDe:=u,cCliDe) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliDe",,,,,.F.)

oSayLn3		:= tSay():New(0045,0005,{||"CLIENTE ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet2		:= tGet():New(0045,0080,{|u| if(Pcount()>0,cCliAte:=u,cCliAte) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliAte",,,,,.F.)

oSayLn4		:= tSay():New(0060,0005,{||"DATA DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet4		:= tGet():New(0060,0080,{|u| if(Pcount()>0,dDtDE:=u,dDtDE) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"dDtDE",,,,,.F.)

oSayLn5		:= tSay():New(0075,0005,{||"DATA ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet5		:= tGet():New(0075,0080,{|u| if(Pcount()>0,dDtATE:=u,dDtATE) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"dDtATE",,,,,.F.)  
                                                                                                                                 
oSayLn6		:= tSay():New(0090,0005,{||"GERENTE DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0090,0080,{|u| if(Pcount()>0,cCliGerDe:=u,cCliGerDe) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliGerDe",,,,,.F.)

oSayLn7		:= tSay():New(0105,0005,{||"GERENTE ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0105,0080,{|u| if(Pcount()>0,cCliGerAt:=u,cCliGerAt) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliGerAt",,,,,.F.)

oSayLn7		:= tSay():New(0120,0005,{||"GERENTE ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0120,0080,{|u| if(Pcount()>0,cCliGerAt:=u,cCliGerAt) },oFiltro,40,08,,,,,,,,.T.,,,,,,,,,,"cCliGerAt",,,,,.F.)

oSayLn8		:= tSay():New(0135,0005,{||"VALOR ONDA?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet6		:= tGet():New(0135,0080,{|u| if(Pcount()>0,nValorOnda:=u,nValorOnda) },oFiltro,30,08,,,,,,,,.T.,,,,,,,,,,"nValorOnda",,,,,.F.)


@ 0150, 0080 BmpButton Type 01 Action Close(oFiltro)
@ 0150, 0110 BmpButton Type 02 Action Close(oFiltro)


Activate Dialog oFiltro Centered
     
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
cQuery +=	" END EMPRESA, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A3_GEREN, A3_NREDUZ, MAX(GRANEL) GRANEL, ROUND(SUM(VALOR),2) VALOR, COUNT(*) SKU, SUM(ESTOQUE) ESTOQUE"
cQuery +=	" FROM (  "
cQuery +=	" SELECT  C5_FILIAL, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A31.A3_GEREN, A32.A3_NREDUZ, C6_PRODUTO, "
cQuery +=	"  IIF(CAST(C6_QTDVEN AS INT) % CAST(IIF(B1.B1_QE = 0,6,B1.B1_QE) AS INT) > 0,'SIM','') GRANEL, C6_VALOR VALOR, IIF(C6_X_ESTOQ = 'N', 1, 0) ESTOQUE "
cQuery +=	" FROM SC5020 C5 WITH (NOLOCK) "
cQuery +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM+C5_CLIENTE+C5_LOJACLI = C6_FILIAL+C6_NUM+C6_CLI+C6_LOJA AND C6.D_E_L_E_T_='' " 
cQuery +=	" INNER JOIN SA1020 A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_=''   "
cQuery +=	" INNER JOIN SB1020 B1 WITH (NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.B1_FILIAL = '    ' AND B1.D_E_L_E_T_ = ''  " 
cQuery +=	" LEFT JOIN SA3020 A31 WITH (NOLOCK) ON A31.A3_COD = C5_VEND1 AND A31.D_E_L_E_T_ = '' "
cQuery +=	" LEFT JOIN SA3020 A32 WITH (NOLOCK) ON A32.A3_COD = A31.A3_GEREN AND A32.D_E_L_E_T_ = '' "
 
cQuery +=	" WHERE C5.D_E_L_E_T_=''  "
cQuery +=	" AND C5_X_ONDLG = '' AND C5_TIPO = 'N' AND C5_X_STAPV = 'A' "
cQuery +=	" AND C5_CLIENTE BETWEEN '"+cCliDe+"' 		AND '"+cCliAte+"' "
cQuery +=	" AND C5_EMISSAO BETWEEN '"+DTOS(dDtDE)+"'	AND '"+DTOS(dDtATE)+"' "
cQuery +=	" AND A31.A3_GEREN BETWEEN '"+cCliGerDe+"'	AND '"+cCliGerAt+"' "
//If cAntec == "SIM"  
//cQuery +=	" AND C6_X_ESTOQ = 'S' " //FILTRA SÓ PRODUTOS COM ESTOQUE
//Endif
cQuery +=	" ) X  "
cQuery +=	" GROUP BY C5_FILIAL, C5_NUM, C5_EMISSAO, C5_X_SONLG, A1_NOME, A1_X_PRIOR, A3_GEREN, A3_NREDUZ    "
//cQuery +=	" HAVING SUM(CAST(C9_BLCRED AS INT)) = 0 "

//Ordem de Apresentação do RELATORIO
If cOrdem == "PRIORIDADE"
	cQuery +=	" ORDER BY ESTOQUE, VALOR DESC "
	//cQuery +=	" ORDER BY A1_X_PRIOR, IIF(C5_X_SONLG = '', 'ZZZZ', C5_X_SONLG), C5_EMISSAO "

ElseIf cOrdem == "VALOR"
	cQuery +=	" ORDER BY VALOR DESC " //ORDER BY 4 DESC, 1

Else
	cQuery +=	" ORDER BY 1, 2 "    
Endif


TCQUERY cQuery NEW ALIAS "TRBSC5"

//Processa o Resultado
dbSelectArea("TRBSC5")
TRBSC5->(dbGoTop())

	
	While TRBSC5->(!EOF())
		aAdd(aBrwPV,{	.T.,;
		TRBSC5->C5_FILIAL,;
		TRBSC5->C5_NUM,;
		substr(TRBSC5->A1_NOME,1,20),;
		TRBSC5->A3_GEREN+" "+TRBSC5->A3_NREDUZ,;
		TRBSC5->A1_X_PRIOR,;
		TRBSC5->C5_X_SONLG,;
		TRBSC5->VALOR,;
		TRBSC5->SKU,;
		TRBSC5->ESTOQUE})
		
		TRBSC5->(dbSkip())
	Enddo
	

If Len(aBrwPV) == 0
	aAdd(aBrwPV,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(06),SPACE(04),SPACE(04),0,0,"",SPACE(06),SPACE(06)})
Endif

DEFINE MSDIALOG oTelPV FROM 38,16 TO 700,1090 TITLE Alltrim(OemToAnsi("PEDIDOS EM CARTEIRA")) Pixel

@ 002, 005 To 073, 535 Label Of oTelPV Pixel

oSay5  	:= TSay():New(007,200,{|| "ONDA PARA PUXADO" },oTelPV,,oFont4,,,,.T.,CLR_HRED)


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


oSay2  	:= TSay():New(295,010,{|| "QTD PEDIDO" },oTelPV,,oFont3,,,,.T.,)
oGetP	:= tGet():New(295,060,{|u| if(Pcount()>0,nPedSel:=u,nPedSel) },,70,10,"@E 999,999",,,,oFont3,,,.T.,,,,,,,.T.,,,"nPedSel",,,,.F.,,,)

oSay2  	:= TSay():New(310,010,{|| "MEDIA SKU" },oTelPV,,oFont3,,,,.T.,)
oGetQ	:= tGet():New(310,060,{|u| if(Pcount()>0,nQtdSku:=u,nQtdSku) },,70,10,"@E 9,999",,,,oFont3,,,.T.,,,,,,,.T.,,,"nQtdSku",,,,.F.,,,)


oSay2  	:= TSay():New(295,190,{|| "VALOR TOTAL " },oTelPV,,oFont3,,,,.T.,)
oGetT	:= tGet():New(295,250,{|u| if(Pcount()>0,nValor:=u,nValor) },,70,10,"@E 99,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValor",,,,.F.,,,)

@ 300,400.4 Button "PROCESSAR" size 55,12 action Processa( {|| IncCarPV() }) OF oTelPV PIXEL
@ 300,473.4 Button "FECHAR"  size 55,12 action oTelPV:End() OF oTelPV PIXEL



oListBo2	:= twBrowse():New(075,005,530,215,,{" ","FILIAL","PEDIDO","CLIENTE","GERENTE","PRIOR","PR PEDIDO","VALOR","QTD SKU","FALTA ESTOQUE"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
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
aBrwPV[oListBo2:nAt,10]}}

oListBo2:bLDblClick := {|| Iif(oListBo2:nColPos <> 5,(aBrwPV[oListBo2:nAt,1] := !aBrwPV[oListBo2:nAt,1]),(aBrwPV[oListBo2:nAt,1] := .T.,)), oListBo2:Refresh(), AtuAcols() }
	
   
oGet1:Refresh()
oTelPV:Refresh()
oListBo2:Refresh() 


ACTIVATE MSDIALOG oTelPV centered

Return()



//*******************************************************************
//Função - Atualiza ACOLS - Grid em Tela
//*******************************************************************
Static Function AtuAcols()

//Sempre Zera para Calcular novamente
nValor 		:= 0	
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

For nx := 1 To Len(aBrwPV)
	
	If !aBrwPV[nx][1]				//Campo MARCADO (.F.)
		nValor 	+= aBrwPV[nx][8]		// Valor
		nQtdSku += aBrwPV[nx][9]
		
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

If nValor > 0
	
	If MsgYesNo("DESEJA PROCESSAR OS PEDIDOS SELECIONADOS?")
		
		cNRonda := Soma1(GetMV("ES_FATP014"),6)
		
		For nx := 1 To Len(aBrwPV)
						
			cTpPed := "1"
				
			If !aBrwPV[nx][1]
				
					DBSelectarea("SC5")
					DBSetOrder(1)
					DBSeek(aBrwPV[nx][2]+aBrwPV[nx][3],.F.)
					
					Reclock("SC5",.F.)
						SC5->C5_X_ONDLG	:= cNRonda
					msunlock() 

			Endif
				
		Next nx
		
		cNRonda := Replicate("0",6-Len(Alltrim(cNRonda)))+Alltrim(cNRonda)
		PutMv("ES_FATP014",cNRonda)
		
		IncSZ4()
			
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
// INCLUIR ONDA NA TABELA SZ4
//*********************************************************************
Static Function INCSZ4()

RecLock("SZ4",.T.)

SZ4->Z4_TIPO	:= 'A'
SZ4->Z4_NUMONDA	:= cNRonda
SZ4->Z4_DTEMISS	:= Date()
SZ4->Z4_HORA	:= Time()
SZ4->Z4_USUARIO	:= cNomUser
SZ4->Z4_IMPRESS	:= "2"
SZ4->Z4_VALOR   := nValor

MsUnlock()

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
cQryC5 += 	" ELSE C5_FILIAL END EMPRESA, "
cQryC5 += 	" C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A4_NREDUZ, A3_NREDUZ,  "
cQryC5 +=	" CASE WHEN C5_X_TLNGR > 0 THEN 'SIM' END C5_X_TLNGR,   "
cQryC5 +=	" CASE WHEN C5_X_ANTEC = '1' THEN 'SIM' ELSE 'NAO' END C5_X_ANTEC, C5_VOLUME2, SUM(C6_VALOR) C6_VALOR "
cQryC5 +=	" FROM " +RETSQLNAME("SC5")+ " C5 WITH (NOLOCK) "
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SC6")+ " C6 WITH (NOLOCK) ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C6.D_E_L_E_T_ = '' "
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SA1")+ " A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = ''	"
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SA4")+ " A4 WITH (NOLOCK) ON C5_TRANSP = A4_COD AND A4.D_E_L_E_T_ = '' 	"
cQryC5 +=	" INNER JOIN " +RETSQLNAME("SB1")+ " B1 WITH (NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.B1_FILIAL = '    ' AND B1.D_E_L_E_T_ = '' "  
cQryC5 +=	" LEFT JOIN  " +RETSQLNAME("SA3")+ " A3 WITH (NOLOCK) ON C5_VEND1 = A3_COD AND A3.D_E_L_E_T_ = ''  	"
cQryC5 += 	" WHERE C5_X_ONDLG = '"+cNroOnda+"' "
cQryC5 +=	" AND C5.D_E_L_E_T_ = '' "     
cQryC5 +=	" GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A4_NREDUZ, A3_NREDUZ, C5_X_ANTEC, C5_VOLUME2, C5_X_TLNGR "
cQryC5 +=	" ORDER BY 1,2 "

TCQUERY cQryC5 NEW ALIAS "TRBC5"

cPvAnt := TRBC5->C5_X_ANTEC

//Processa o Resultado
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
	Transform(TRBC5->C6_VALOR,"@E 999,999,999.99")})
	
	TRBC5->(dbSkip())
		
Enddo
	
If Len(aBrwC5) == 0
	aAdd(aBrwC5,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(02),SPACE(30),SPACE(15),SPACE(15),SPACE(02),0,0})
Endif

DEFINE MSDIALOG oTelVis FROM 38,16 TO 600,1200 TITLE Alltrim(OemToAnsi("PEDIDOS SELECIONADO NA ONDA")) Pixel

@ 002, 005 To 058, 590 Label Of oTelVis Pixel

oSay5  	:= TSay():New(010,010,{|| "PEDIDOS SELECIONADOS NA ONDA N° "+cNroOnda },oTelVis,,oFont4,,,,.T.,CLR_BLUE)
oSay6	:= TSay():New(024,010,{|| "ANTECIPADO "+cPvAnt },oTelVis,,oFont4,,,,.T.,CLR_HRED)

//@ 025,530 Button "PROCESSA ESTOQUE"   size 55,12 action Processa( {|| U_FATP0011(cNroOnda)}) OF oTelVis PIXEL
                                                                           
@ 010,530 Button "REL. ONDA"	size 55,12 action Processa( {|| RelOnda1()}) OF oTelVis PIXEL
@ 025,530 Button "REL. FALTA"   size 55,12 action Processa( {|| RelOnda2()}) OF oTelVis PIXEL
@ 040,530 Button "FECHAR"  		size 55,12 action oTelVis:End() OF oTelVis PIXEL
		
oListBox3	:= twBrowse():New(059,005,586,215,,{" ","FILIAL","PEDIDO","CLIENTE","LOJA","NOME CLIENTE","NOME TRANSP.","VENDEDOR","GRANEL","VOL.GRANEL","VALOR TOTAL"},,oTelVis,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
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
aBrwC5[oListBox3:nAt,11]}}	// VALOR TOTAL DO PEDIDO

oTelVis:Refresh()
oListBox3:Refresh()

ACTIVATE MSDIALOG oTelVis centered

Return()



//*****************************************************************
// IMPRESSÃO
//****************************************************************

//FUNÇÃO PARA IMPRIMIR A ONDA
Static Function ImpOnda()

//Numero do Manifesto Seleciona no Grid
cNRonda := aBrowse[oListBox:nAt][3]

If MsgYesNo("DESEJA IMPRIMIR A ONDA NR. "+cNRonda)
	U_FATR0001(cNRonda)
Endif

return()


Static Function RelOnda1()

If MsgYesNo("DESEJA IMPRIMIR A PROGRAMAÇÃO REF A ONDA NR. "+cNroOnda)
	U_FATR0005(cNroOnda,"A")
Endif     

Return()


Static Function RelOnda2()

If MsgYesNo("DESEJA IMPRIMIR OS ITENS FALTANTES DA ONDA "+cNroOnda)
	U_FATR0009(cNroOnda,"A")
Endif     

Return()




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATP0011	 ³ Autor ³ André Salgado 		³ Data ³30/08/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Analise do Estoque  x  Pedido de Venda Incluido			  ³±±
±±³          ³ 															  ³±±
				Estamos usando o campo C6_X_ESTOQ com a seguinte regra:
		- C6_X_ESTOQ = " " (registro novo e não processado)
		- C6_X_ESTOQ = "S" (registro com Estoque para atender)
		- C6_X_ESTOQ = "N" (não tem estoque para atender este item)
		- C6_X_ESTOQ = "X" (Item tem estoque, mais tem algum item no Pedido que não tem Estoque)
				
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FATP0014E()

Private nConsumo:= 0
Private cAtenc	:= ""


If MsgYesNo("DESEJA PROCESSAR OS PEDIDOS SELECIONADOS?")

	//Procedure para atualiza a tabela Temporaria do Estoque - Hoje o Controle é feito em outro Sistema (CS Vini)
	//Criado por Vinicius Messias/DBA
	cExecProc := "exec uspSaldoOnda"
	TcSqlExec(cExecProc)
	
	//MODIFICADA EM 03/01 - GENILSON
	cQuery := " SELECT A1_X_PRIOR, C5_EMISSAO, C5_X_HRINC, C6_PRODUTO, C5_FILIAL, C5_NUM, C6_ITEM, C6_QTDVEN "
	cQuery += " FROM SC6020 C6 WITH(NOLOCK)  "
	cQuery += " INNER JOIN SC5020 C5 WITH(NOLOCK) ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C5.D_E_L_E_T_=' '       "
	cQuery += " INNER JOIN SA1020 A1 WITH(NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND A1.D_E_L_E_T_=' '    "
	cQuery += " INNER JOIN SB1020 B1 WITH(NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.D_E_L_E_T_=' ' AND B1.B1_TIPO = 'PA' AND B1.B1_COD BETWEEN '00000' AND '99999' "
	cQuery += " WHERE   "
	cQuery += " C6.D_E_L_E_T_= ''  "
	cQuery += " AND C5_NOTA NOT IN ('XXXXXXXXX')  "
	cQuery += " AND C5_TIPO = 'N' "
	cQuery += " AND C5_X_TIPO2 = '2' AND C5_X_ONSUB = ''   "
	cQuery += " AND A1_SATIV1 NOT IN ('000003','000004') "
	cQuery += " AND C5_X_ONDLG = '' AND C5_X_STAPV = 'A' AND C6_X_ESTOQ NOT IN('S') AND C5_X_ANTEC='1'   "
	cQuery += " ORDER BY IIF(C5_X_ANTEC = '1' AND A1_X_PRIOR= '0',0,IIF(C5_X_ANTEC ='1' AND C5_X_SONLG !='',1, IIF(C5_X_ANTEC = '2' AND A1_X_PRIOR= '0',2,IIF(C5_X_ANTEC ='2' AND C5_X_SONLG !='',3,IIF(C5_X_ANTEC = '1' AND A1_X_PRIOR IN ('1','2'),4,IIF(C5_X_ANTEC = '1' ,5,6)))))) "
	cQuery += " ,IIF(C5_X_SONLG = '','9',C5_X_SONLG),A1_X_PRIOR, "
	cQuery += " C5_EMISSAO, C5_X_HRINC, C6_PRODUTO    "
	
	
	If Select("TRB1") > 0
		TRB1->(DbCloseArea())
	Endif
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)
	
	
	dbSelectArea("TRB1")
	dbGoTop()
	
	While !EOF()
		
		
		//Busca informação
		dbSelectArea("SZ2")		//Filial + Codigo de Produto
		dbSeek(xFilial("SZ2")+TRB1->C6_PRODUTO)
		
		//Se Existir na TABELA
		If Found()
			
			If SZ2->Z2_SALDO>0
				
				If SZ2->Z2_CONSUMO>0
					nConsumo := SZ2->Z2_CONSUMO - TRB1->C6_QTDVEN
				Else
					nConsumo := SZ2->Z2_SALDO   - TRB1->C6_QTDVEN
				Endif
				
				
				//Atualiza Tabela de Controle de Saldo em Estoque
				//TEM ESTOQUE
				IF nConsumo>=0
					DbSelectarea("SZ2")
					RECLOCK( "SZ2", .F. )
					SZ2->Z2_CONSUMO:= nConsumo
					MSUNLOCK()
					
					//grava sc6
					AtuSC6("S")
					
					
					//NAO TEM ESTOQUE
				Else
					//grava sc6
					AtuSC6("N")
				Endif
				
			Else
				
				//NAO TEM ESTOQUE
				//grava sc6
				AtuSC6("N")
			Endif
			
			
			//Senão existe não tem Estoque
		Else
			
			//NAO TEM ESTOQUE
			//grava sc6
			AtuSC6("N")
			
		Endif
		
		
		dbSelectArea("TRB1")
		dbSkip()
	EndDo
	
	
	//Solicitação Fernando Medeiros - Não travar Estoque para Pedido com item faltante
	cQueryX := " UPDATE "+RETSQLNAME("SC6")+" SET C6_X_ESTOQ ='X'"
	cQueryX += " FROM "+RETSQLNAME("SC6")+" C6"
	cQueryX += " 	INNER JOIN ("
	cQueryX += " 		SELECT DISTINCT C6_FILIAL FILIAL, C6_NUM NUM"
	cQueryX += " 		FROM "+RETSQLNAME("SC6")+" TRAVA_PV"
	cQueryX += " 		WHERE TRAVA_PV.D_E_L_E_T_=' '"
	cQueryX += " 		AND C6_X_ESTOQ ='N'"	//PEDIDOS SEM ESTOQUE NECESSARIO
	cQueryX += " 	)PED_SEM_ESTOQUE ON C6_FILIAL=FILIAL AND  C6_NUM=NUM
	cQueryX += " WHERE "
	cQueryX += " C6.D_E_L_E_T_=' ' AND C6_X_ESTOQ ='S'"	//LIBERA O ESTOQUE EMPENHADO
	TcSqlExec(cQueryX)
	
	PUTMV("ES_FATP011",Dtoc(ddatabase)+" "+substr(time(),1,5) )


	Aviso("ATENCAO","Foi atualizado a Analise de Estoque com os Pedidos ate o momento "+Dtoc(ddatabase)+" "+substr(time(),1,5),{"OK"})

Else
	ALERT("ATENCAO","Operação Cancelada!",{"OK"})
EndIf

Return()


//Atualiza Tabela SC6 
Static Function AtuSC6(cTPPed)

cExPrc := " exec uspSC6020C6_X_ESTOQ '"+TRB1->C5_FILIAL+"','"+TRB1->C5_NUM+"','"+TRB1->C6_PRODUTO+"','"+cTPPed+"' "
TcSqlExec(cExPrc)

Return()
