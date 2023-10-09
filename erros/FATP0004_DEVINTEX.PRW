#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±                          d
±±³ Funcao   ³ TELAMANIF ³ Autor ³ André Valmir 		³ Data ³05/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de Manifesto										  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DEVINTEX                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±    
 

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      			  																             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	                                 	                                ³±±
±±³ 02/07/19	ANDRÉ VALMIR		12:50 AJUSTE NA LINHA 544 DE CQUERY1 PARA CQUERY2														³±±
±±³																																			³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function FATP0004()

Private oWindow
Private oOK 	:= LoadBitmap(GetResources(),'br_verde')
Private oNO 	:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias	:= GetNextAlias()
Private oFont 	:= TFont():New('Courier new',,-14,.F.,.T.)
Private cGet1	:= Space(6)
Private dGet1	:= CTOD(" / / ")
Private dGet2	:= CTOD(" / / ")
Private aBrowse	:= {}
Private oGet
Private cNrManif := SPACE(6)

//Tela Inicial
TELAINIC()

Return()


//*************************************************
// TELA INICIAL DO MANIFESTO
//*************************************************
Static Function TELAINIC()

If Len(aBrowse) == 0
	aAdd(aBrowse,{.T.,SPACE(03),SPACE(08),CTOD(" / / "),SPACE(40),SPACE(08),SPACE(10),SPACE(40)})
Endif

DEFINE MSDIALOG oWindow FROM 38,16 TO 600,880 TITLE Alltrim(OemToAnsi("MANIFESTO 2.0")) Pixel

@ 002, 005 To 058, 425 Label Of oWindow Pixel

oSay1  	:= TSay():New(015,010,{|| "MANIFESTO: " },oWindow,,oFont,,,,.T.,)
//@ 014,075 Get cGet1 VALID cGet1:=STRZERO(val(cGet1),6) picture "@E 999999999" size 10,10 OF oWindow PIXEL
@ 014,080 Get cGet1 picture "@E 999999999" size 10,10 OF oWindow PIXEL
@ 014,140 Button "PESQUISAR"  size 44.4,12 action Processa( {|| PesqManif()}, "AGUARDE...", "PESQUISANDO...") OF oWindow PIXEL

oSay2  	:= TSay():New(036,010,{|| "DATA MANIFESTO: " },oWindow,,oFont,,,,.T.,)
@ 035,080 Get dGet1 picture "@D" size 44.5,10 OF oWindow PIXEL

oSay3  	:= TSay():New(036,130,{|| "A" },oWindow,,oFont,,,,.T.,)
@ 035,140 Get dGet2 picture "@D" size 44.5,10 OF oWindow PIXEL

@ 014,295 Button "INCLUIR" size 55,12 action Processa( {|| IncManif() }) OF oWindow PIXEL
//@ 034,295 Button "Alterar" size 55,12 action Processa( {|| AltManif() }) OF oWindow PIXEL
@ 034,295 Button "RELATORIO" size 55,12 action Processa( {|| ImpManif() }) OF oWindow PIXEL
@ 014,360 Button "EXCLUIR" size 55,12 action Processa( {|| ExcManif() }, "AGUARDE EXCLUINDO...") OF oWindow PIXEL
@ 034,360 Button "FECHAR"  size 55,12 action oWindow:End() OF oWindow PIXEL

oListBox	:= twBrowse():New(059,005,420,215,,{" ","LOCAL","MANIFESTO","DATA","MOTORISTA","PLACA","RG","OBS1"},,oWindow,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

oListBox:SetArray(aBrowse)
oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
aBrowse[oListBox:nAt,02],;
aBrowse[oListBox:nAt,03],;
aBrowse[oListBox:nAt,04],;
aBrowse[oListBox:nAt,05],;
aBrowse[oListBox:nAt,06],;
aBrowse[oListBox:nAt,07],;
aBrowse[oListBox:nAt,08] }}

oListBox:bLDblClick := {|| aBrowse[oListBox:nAt][1] := !aBrowse[oListBox:nAt][1],oListBox:DrawSelect()}

oWindow:Refresh()
oListBox:Refresh()

ACTIVATE MSDIALOG oWindow centered

Return()



//BOTÃO PESQUISAR
Static Function PesqManif()

Local cQuery := ""
aBrowse	:= {}

If Select("TRBSC5") > 0
	TRBSC5->( dbCloseArea() )
EndIf

//Busca Dados para Pesquisa - SZ9 Controle Manifesto
cQuery :=	" SELECT '001' LOCALT, Z9_NRMA, Z9_DTMA, Z9_MOTMA, Z9_PLACA, Z9_RGMA,"
cQuery +=	" RTRIM(Z9_OBSM1)+' '+RTRIM(Z9_OBSM2)+' '+RTRIM(Z9_OBSM3) Z9_OBS"
cQuery +=	" FROM "+RETSQLNAME("SZ9")+" Z9	"
cQuery +=	" WHERE D_E_L_E_T_ = ''	"

If !Empty(dGet1) .and. !Empty(dGet2)
	cQuery +=	" AND Z9_DTMA BETWEEN '"+dtos(dGet1)+"' AND '"+dtos(dGet2)+"' "
Endif

If !Empty(cGet1)
	cQuery +=	" AND Z9_NRMA = '"+cGet1+"' "
Endif

cQuery +=	" AND Z9_FILIAL= '"+xFilial("SZ9")+"'"

TCQUERY cQuery NEW ALIAS "TRBSC5"

dbSelectArea("TRBSC5")
TRBSC5->(dbGoTop())

While TRBSC5->(!EOF())
	aAdd(aBrowse,{	.T.,;
	TRBSC5->LOCALT,;
	TRBSC5->Z9_NRMA,;
	STOD(TRBSC5->Z9_DTMA),;
	TRBSC5->Z9_MOTMA,;
	TRBSC5->Z9_PLACA,;
	TRBSC5->Z9_RGMA,;
	TRBSC5->Z9_OBS	})
	
	TRBSC5->(dbSkip())
Enddo

oListBox:SetArray(aBrowse)
oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
aBrowse[oListBox:nAt,02],;
aBrowse[oListBox:nAt,03],;
aBrowse[oListBox:nAt,04],;
aBrowse[oListBox:nAt,05],;
aBrowse[oListBox:nAt,06],;
aBrowse[oListBox:nAt,07],;
aBrowse[oListBox:nAt,08] }}
oWindow:Refresh()          

Return()


//*************************************************
// TELA DE INCLUSÃO DO MANIFESTO
//*************************************************
Static Function IncManif()

Local _lRetorno := .F.	//Validacao da dialog criada oDlg
Local _nOpca 	:= 0 	//Opcao da confirmacao
Local bOk 		:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel 	:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local _cArqEmp 	:= "" 	//Arquivo temporario com as empresas a serem escolhidas
Local _aStruTrb := {}	//estrutura do temporario
Local _aBrowse 	:= {}	//array do browse para demonstracao das empresas

PUBLIC _aEmpMigr:= {}	//array de retorno com as empresas escolhidas
Private lInverte:= .F.	//Variaveis para o MsSelect
Private cMarca 	:= GetMark() //Variaveis para o MsSelect
Private oBrwTrb			//objeto do msselect
Private oDlg
Private _cEnter := CHR(13)+CHR(10)
Private _aStruTrb := {}	//estrutura do temporario
Private _aBrowse:= {}	//array do browse para demonstracao das empresas
Private cTxtNF	:= ""
Private oFont1 	:= TFont():New('Courier new',,-25,.F.,.T.)                                                               
Private oFont2	:= TFont():New('Courier new',,-20,.F.,.T.)               
Private oFont3	:= TFont():New('Courier new',,-16,.F.,.T.)


//TELA DE INCLUSÃO - MANIFESTO
cMotoris 	:= space(60)
cRGMot   	:= space(10)
cPlaca   	:= space(07)
cTpVeic	    := space(01)
nQtdPal		:= 0
cLotacaoM   := space(03)
cObs1	 	:= space(100)
cObs2	 	:= space(100)
cObs3	 	:= space(100)
cNomeTran 	:= ""  // Nome transportadora

//Filtrar Titulos no Faturamento
dData1	:= ddatabase	//Data Emissão da Fatura DE
dData2	:= ddatabase	//Data Emissão da Fatura Ate
cNota1	:= space(09)	//Nota  DE
cNota2	:= "ZZZZZZ"		//Nota Ate
cTransp1:= space(06)	//Cod.Transporte DE
cTransp2:= "ZZZZZZ"		//Cod.Transporte Ate
cPed1	:= space(06)	//Pedido de Venda DE
cPed2	:= "ZZZZZZ"		//Pedido de Venda Ate

cCol2 	:= 40
cCol3 	:= 130             
nRadio 	:= 1
nRadioL	:= 1

//Monta Tabela Temporaria - Manifesto
//ò€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€À
// Define campos do TRB
//Ë€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€ô
aadd(_aStruTrb,{"NUM" 		,"C",09,0})
aadd(_aStruTrb,{"CLIENTE"	,"C",06,0})
aadd(_aStruTrb,{"NOMCLI" 	,"C",20,0})
aadd(_aStruTrb,{"EMISSAO"	,"D",08,0})
aadd(_aStruTrb,{"VENCTO"	,"D",08,0})
aadd(_aStruTrb,{"VALOR" 	,"N",17,2})
aadd(_aStruTrb,{"LOJA" 		,"C",02,0})
aadd(_aStruTrb,{"BAIXA" 	,"D",08,0})
aadd(_aStruTrb,{"CTACONT" 	,"C",20,0})
aadd(_aStruTrb,{"TRANSP" 	,"C",06,0})
aadd(_aStruTrb,{"OK" 		,"C",02,0})

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

_cArqEmp := CriaTrab(_aStruTrb)
dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

DEFINE MSDIALOG oDlg1 FROM 10,10 TO 520,750 TITLE Alltrim(OemToAnsi("DADOS DO MANIFESTO ")) Pixel 
                                                         
//oSayLn		:= tSay():New(40.5,05,{||"NUMERO DO MANIFESTO"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
//oGet1		:= tGet():New(37.3,112,{|u| If(Pcount()>0,cNrManif:=u,cNrManif) },oDlg1,45,15,,,,,oFont3,,,.T.,,,{|u| u:=.F.},,,,,,,"cNrManif")

oSayLn7		:= tSay():New(40.5,05,{||"FORMA DE PESQUISA"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
aRadio 		:= {"PEDIDO","NOTA FISCAL"}
oRadio		:= TRadMenu():New (40.5,112,aRadio,,oDlg1,,,,,,,,130,22,,,,.T.)
oRadio:bSetGet := {|u| Iif(PCount()==0,nRadio,nRadio:=u)}

oSayLn2		:= tSay():New(62.5,05,{||"Nome do Motorista:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet2  		:= tGet():New(59.3,112,{|u| If(Pcount()>0,cMotoris:=u,cMotoris)},oDlg1,220,15,"@!",{ || !empty(cMotoris)},,,oFont3,,,.T.,,,,,,,,,,"cMotoris")

oSayLn3		:= tSay():New(84.5,05,{||"RG Motorista:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet3  		:= tGet():New(81.3,112,{|u| If(Pcount()>0,cRGMot:=u,cRGMot)},oDlg1,080,15,"@!",{ || !empty(cRGMot)},,,oFont3,,,.T.,,,,,,,,,,"cRGMot")

oSayLn4		:= tSay():New(84.5,214,{||"Placa:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet4  		:= tGet():New(81.3,251,{|u| If(Pcount()>0,cPlaca:=u,cPlaca)},oDlg1,080,15,"@!",{ || !empty(cPlaca)},,,oFont3,,,.T.,,,,,,,,,,"cPlaca")

oSayLn4		:= tSay():New(106.5,05,{||"Tipo Veiculo:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet4  		:= tGet():New(103.3,112,{|u| If(Pcount()>0,cTpVeic:=u,cTpVeic)},oDlg1,080,15,"@!",{ || !empty(cTpVeic)},,,oFont3,,,.T.,,,,,,,,,"ZV","cTpVeic")

oSayLn4		:= tSay():New(106.5,214,{||"Pallets:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet4  		:= tGet():New(103.3,251,{|u| If(Pcount()>0,nQtdPal:=u,nQtdPal)},oDlg1,080,15,"@E 9999",{ || !empty(nQtdPal)},,,oFont3,,,.T.,,,,,,,,,,"nQtdPal")

oSayLn5		:= tSay():New(128.5,05,{||"Observação:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet5  		:= tGet():New(125.3,112,{|u| If(Pcount()>0,cObs1:=u,cObs1)},oDlg1,220,15,"@!",,,,oFont3,,,.T.,,,,,,,,,,"cObs1") 
oGet6  		:= tGet():New(147.3,112,{|u| If(Pcount()>0,cObs2:=u,cObs2)},oDlg1,220,15,"@!",,,,oFont3,,,.T.,,,,,,,,,,"cObs2")
oGet7  		:= tGet():New(169.3,112,{|u| If(Pcount()>0,cObs3:=u,cObs3)},oDlg1,220,15,"@!",,,,oFont3,,,.T.,,,,,,,,,,"cObs3")
                                      
oSayLn6		:= tSay():New(194.5,05,{||"Transpotadora:"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
oGet8  		:= tGet():New(191.3,112,{|u| If(Pcount()>0,cTransp1:=u,cTransp1)},oDlg1,45,15,"@R 999999",{|| !empty(cTransp1) .AND. gatilhacpo(cTransp1) },,,oFont3,,,.T.,,,,,,,,,"SA4","cTransp1") 
oGet9		:= tGet():New(191.3,162,{|u| If(Pcount()>0,cNomeTran:=u,cNomeTran) },oDlg1,170,15,,,,,oFont3,,,.T.,,,{|u| u:=.F.},,,,,,,"cNomeTran")

oSayLn7		:= tSay():New(221,05,{||"LOTAÇÃO"},oDlg1,,oFont3,,,,.T.,CLR_BLACK,CLR_RED,270,40)
aRadioL		:= {"SIM","NAO"}
oRadio		:= TRadMenu():New (220.5,112,aRadioL,,oDlg1,,,,,,,,130,22,,,,.T.)
oRadio:bSetGet := {|u| Iif(PCount()==0,nRadioL,nRadioL:=u)}

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{||lOk:=.T.,If(Validacao(),{TelPesNF(),oDlg1:End()},.F. ) } ,{||oDlg1:End()},,)

Return()



//*********************************************************
// VALIDA SE TODOS OS CAMPOS FORAM PREENCHIDOS
//*********************************************************
Static Function Validacao()

Local lret := .T.

If Empty(cMotoris)		
	MsgInfo("Não foi informado o nome do motorista.","Atenção - Motorisa")
	lret := .F.
ElseIf Empty(cRGMot)
	MsgInfo("Não foi informado o RG do motorista.","Atenção - RG")
	lret := .F.
ElseIf Empty(cPlaca)
	MsgInfo("Não foi informado a Placa do caminhão.","Atenção - Placa")
	lret := .F.
ElseIf Empty(cTransp1)
	MsgInfo("Não foi informado a transportadora.","Atenção - Transportadora")
	lret := .F.
ElseIf Empty(cTpVeic)
	MsgInfo("Não foi informado o Tipo de Veiculo.","Atenção - Tipo de Veiculo")
	lret := .F.
ElseIf nQtdPal=0
	MsgInfo("Não foi informado a quantidade de Pallets.","Atenção - Qtd Pallets")
	lret := .F.
EndIf

Return(lret)


//*********************************************************
// RETORNA NOME DA TRANSPORTADORA
//*********************************************************
Static Function gatilhacpo(cTransp1)

cNomeTran := Posicione("SA4",1,xFilial("SA4")+cTransp1,"A4_NREDUZ")

Return()


//********************************************************
//Tela de Pesquisa da Nota
//MONTA GRID DE SELEÇÃO
//********************************************************
Static Function TelPesNF()

Private oWin
Private oOK1 	:= LoadBitmap(GetResources(),'br_verde')
Private oNO1 	:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias1	:= GetNextAlias()
Private cNumDig := '' // Numero pedido/NF digitado
	
Private aCols	:= {}

If Len(aCols) == 0
	aAdd(aCols,{.T.,SPACE(02),SPACE(02),SPACE(02),SPACE(40),CTOD(" / / "),SPACE(03),SPACE(25)})
Endif

DEFINE MSDIALOG oWin FROM 38,16 TO 600,880 TITLE Alltrim(OemToAnsi("SELECIONAR NOTAS FISCAIS")) Pixel

@ 032, 002 To 278, 428 Label Of oWin Pixel

If nRadio == 1
	
	cNumDig := Space(6) // Numero pedido/NF digitado
	
	oSay1  	:= TSay():New(037,010,{|| "PEDIDO: " },oWin,,oFont1,,,,.T.,)                                                     
	oGet	:= tGet():New(036.3,070,{|u| if(Pcount()>0,cNumDig:=u,cNumDig)},oWin,60,15,"@E 9999999",{||ValidDig(cNumDig)},,,oFont1,,,.T.,,,,,,,,,,"cNumDig",,,,,.F.)
Else                                                        

	cNumDig := Space(45) // Numero pedido/NF digitado

	oSay1  	:= TSay():New(037,010,{|| "NOTA FISCAL: " },oWin,,oFont2,,,,.T.,)
	oGet	:= tGet():New(036.3,095,{|u| if(Pcount()>0,cNumDig:=u,cNumDig)},,280,15,"@E 999999999999999999999999999999999999999999999",{||ValidDig(cNumDig)},,,oFont2,,,.T.,,,,,,,,,,"cNumDig",,,,,.F.)
Endif

oListBox1	:= twBrowse():New(059,005,420,215,,{" ","PEDIDO","NOTA FISCAL","CLIENTE","NOME CLIENTE","EMISSAO","TRANSP","NOME TRANSP."},,oWin,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

oListBox1:SetArray(aCols)
oListBox1:bLine := {||{If(aCols[oListBox1:nAt,01],oOK1,oNO1),;
aCols[oListBox1:nAt,02],; 
aCols[oListBox1:nAt,03],;
aCols[oListBox1:nAt,04],;
aCols[oListBox1:nAt,05],;
aCols[oListBox1:nAt,06],;
aCols[oListBox1:nAt,07],;
aCols[oListBox1:nAt,08]}}

oListBox1:bLDblClick := {|| aCols[oListBox1:nAt][1] := !aCols[oListBox1:nAt][1],oListBox1:DrawSelect()}

oWin:Refresh()

//ACTIVATE MSDIALOG oWin centered 
ACTIVATE MSDIALOG oWin CENTERED ON INIT EnchoiceBar(oWin,{||lOk:=.T.,AtuSF2(),AtuSZ9(),oWin:End()},{||oWin:End()},,)

Return()
        
        
          
Static Function ValidDig()

Local cQuery1	:= ''
Local cQuery2	:= ''
Local cNumPed	:= ''

If nRadio == 1	// Pedido

	If !Empty(cNumDig)
	
		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5")+cNumDig,.F.) .AND. !Eof()

			//Valida se o Pedido esta Habito 
			If Empty(SC5->C5_NOTA) .OR. SC5->C5_NOTA == 'XXXXXX'
				Msginfo("PEDIDO "+Alltrim(cNumDig)+" NÃO POSSUI NF EMITIDA, FAVOR SELECIONAR OUTRO PEDIDO","ATENÇÃO")
				oListBox1:Refresh()
				cNumDig := SPACE(06)
				oGet:CtrlRefresh()  			
				oGet:SetFocus()
				Return()
			Endif

			
			//Busca Informação do Manifesto		
			cDoc := Posicione("SD2",8,xFilial("SD2")+left(cNumDig,6),"D2_DOC")
			cNrManisf := Posicione("SF2",1,xFilial("SF2") + cDoc ,"F2_X_NRMA")
				
			If !Empty(cNrManisf)
				MsgAlert("PEDIDO "+Alltrim(cNumDig)+" JÁ SE ENCONTRA NO MANIFESTO NR. "+cNrManisf+", FAVOR SELECIONAR OUTRO PEDIDO","ATENÇÃO")
				oListBox1:Refresh()
				cNumDig := SPACE(07)
				oGet:CtrlRefresh()  
				oGet:SetFocus()
				Return()
			Endif

			    
			// Verificar se pedido ja foi informado no acols no manifesto
			For nY := 1 To Len(aCols)                               
				   	
				If cNumDig = aCols[nY][2] .and. !empty(aCols[1][2])
					MsgAlert("PEDIDO JÁ SELECIONADO") 
					oListBox1:Refresh() 
					cNumDig := SPACE(06)
					oGet:CtrlRefresh()  			
					oGet:SetFocus()
					Return()                      
				Endif
											
			Next x
				
			
			If Select("TRBC5") > 0
				TRBC5->( dbCloseArea() )
			EndIf 
				
			//Busca Dados para Pesquisa - SC5 Controle Manifesto
			cQuery1 :=	" SELECT C5_NUM, D2_DOC, C5_CLIENTE, A1_NOME, C5_EMISSAO, C5_TRANSP, A4_NREDUZ "
			cQuery1 +=	" FROM "+RETSQLNAME("SD2")+" D2
			cQuery1 +=	" INNER JOIN "+RETSQLNAME("SC5")+" C5 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = '' "
			cQuery1 +=	" INNER JOIN "+RETSQLNAME("SA1")+" A1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND A1.D_E_L_E_T_ ='' " 			
			cQuery1 +=	" LEFT JOIN "+RETSQLNAME("SA4")+" A4 ON C5_TRANSP = A4_COD AND A4.D_E_L_E_T_ ='' " 
			cQuery1 +=	" INNER JOIN "+RETSQLNAME("SF2")+" F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC  AND D2_SERIE=F2_SERIE AND F2.D_E_L_E_T_ = '' "			
			cQuery1 +=	" WHERE D2.D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cNumDig+"' AND D2_FILIAL = '"+xFilial("SD2")+"' AND F2_X_NRMA = '' AND C5_NOTA <> ''"
			cQuery1 +=	" GROUP BY C5_NUM, D2_DOC, C5_CLIENTE, A1_NOME, C5_EMISSAO, C5_TRANSP, A4_NREDUZ " 
				
			TCQUERY cQuery1 NEW ALIAS "TRBC5"
				
			DBSelectArea("TRBC5")
			TRBC5->(dbGoTop())
				
			If Alltrim(cTransp1) != TRBC5->C5_TRANSP
				If !MsgYesNo("TRANSPORTADORA "+Alltrim(Posicione("SA4",1,xFilial("SA4")+TRBC5->C5_TRANSP,"A4_NREDUZ"))+" ("+TRBC5->C5_TRANSP+") DIFERENTE DA TRANSPORTADORA SELECIONADA NOS DADOS DO MANIFESTO, DESEJA CONTINUAR?")
					oWin:Refresh() 
					cNumDig := SPACE(06)
					oGet:CtrlRefresh()  
					oGet:SetFocus()
					Return()
				Endif
			Endif
				
			While TRBC5->(!EOF())
				aAdd(aCols,{	.T.,;
				TRBC5->C5_NUM,;
				TRBC5->D2_DOC,;
				TRBC5->C5_CLIENTE,;
				TRBC5->A1_NOME,;
				STOD(TRBC5->C5_EMISSAO),;
				TRBC5->C5_TRANSP,;
				TRBC5->A4_NREDUZ })
					
				TRBC5->(dbSkip())
			Enddo             
						
			// Deleta primeira linha do array em branco
			If empty(aCols[1][2])   
				aDel(aCols,1)
				aSize(aCols,len(aCols)-1) 
				oListBox1:Refresh()
				cNumDig := SPACE(06)
				oWin:Refresh() 
				oGet:CtrlRefresh()                     
				oGet:SetFocus()		// Posiciona no Campo
				Return()
			Endif
			
			oListBox1:SetArray(aCols)
			oListBox1:bLine := {||{If(aCols[oListBox1:nAt,01],oOK1,oNO1),;
			aCols[oListBox1:nAt,02],; 
			aCols[oListBox1:nAt,03],;
			aCols[oListBox1:nAt,04],;
			aCols[oListBox1:nAt,05],;
			aCols[oListBox1:nAt,06],;
			aCols[oListBox1:nAt,07],; 
			aCols[oListBox1:nAt,08] }}
			
			cNumDig := SPACE(06)
			oWin:Refresh()
			oListBox1:Refresh()
			oGet:CtrlRefresh()
			oGet:SetFocus()     	// Posiciona no Campo
		
		Else
			MsgAlert("PEDIDO NÃO EXISTE NA BASE DE DADOS, FAVOR SELECIONAR OUTRO PEDIDO","ATENÇÃO")
			oListBox1:Refresh()
			cNumDig := SPACE(06)
			oGet:CtrlRefresh()  			
			oGet:SetFocus()
			Return()
		Endif         
	Endif

Else	// NF 

	If !Empty(cNumDig)	
	
		DbSelectArea("SF2")
		dbSetOrder(19)		//Filial + Numero Chave DANFE
		dbSeek(xFilial("SF2")+cNumDig)
	                		
		If Found()
			
		    If !Empty(SF2->F2_X_NRMA)
				MsgAlert("Nota Fiscal "+Alltrim(SF2->F2_DOC)+" já encontra-se manifestada com nr. "+F2_X_NRMA+", favor selecionar outra Nota Fiscal.","Atenção")
				oListBox1:Refresh()
				cNumDig := SPACE(45)
				oGet:CtrlRefresh()  
				oGet:SetFocus()
				Return()
			Endif 
		
		    DbSelectArea("SD2")
			dbSetOrder(3)		//Filial + Documento + Serie ...
			dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			
			cNumPed	:= SD2->D2_PEDIDO
			
			
			// Verificar se NF ja foi informado no acols no manifesto
			For nY := 1 To Len(aCols)                               
					   	
				If SF2->F2_DOC = aCols[nY][3] .and. !empty(aCols[1][3])
					MsgAlert("NOTA FISCAL JÁ SELECIONADA")
					oListBox1:Refresh()
					cNumDig := SPACE(45)
					oGet:CtrlRefresh() 
					oGet:SetFocus()
					Return()                      
				Endif
											
			Next x            
					
					
			If Select("TRBD2") > 0
				TRBD2->( dbCloseArea() )
			EndIf 
					
			//Busca Dados para Pesquisa - SF2 Controle Manifesto
			cQuery2 :=	" SELECT C5_NUM, D2_DOC, C5_CLIENTE, A1_NOME, C5_EMISSAO, C5_TRANSP, A4_NREDUZ "
			cQuery2 +=	" FROM "+RETSQLNAME("SD2")+" D2
			cQuery2 +=	" INNER JOIN "+RETSQLNAME("SC5")+" C5 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5.D_E_L_E_T_ = '' "
			cQuery2 +=	" INNER JOIN "+RETSQLNAME("SA1")+" A1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND A1.D_E_L_E_T_ ='' " 			
			cQuery2 +=	" INNER JOIN "+RETSQLNAME("SA4")+" A4 ON C5_TRANSP = A4_COD AND A4.D_E_L_E_T_ ='' " 
			cQuery2 +=	" INNER JOIN "+RETSQLNAME("SF2")+" F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND D2_SERIE=F2_SERIE AND F2.D_E_L_E_T_ = '' "			
			cQuery2 +=	" WHERE D2.D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cNumPed+"' AND D2_FILIAL = '"+xFilial("SD2")+"' AND F2_X_NRMA = '' AND C5_NOTA <> ''"
			cQuery2 +=	" GROUP BY C5_NUM, D2_DOC, C5_CLIENTE, A1_NOME, C5_EMISSAO, C5_TRANSP, A4_NREDUZ " 
											
			TCQUERY cQuery2 NEW ALIAS "TRBD2"
				
			DBSelectArea("TRBD2")
			TRBD2->(dbGoTop())
		    
			If Alltrim(cTransp1) != TRBD2->C5_TRANSP
				If !MsgYesNo("TRANSPORTADORA "+Alltrim(Posicione("SA4",1,xFilial("SA4")+TRBD2->C5_TRANSP,"A4_NREDUZ"))+" ("+TRBD2->C5_TRANSP+") DIFERENTE DA TRANSPORTADORA SELECIONADA NOS DADOS DO MANIFESTO, DESEJA CONTINUAR?")
					cNumDig := SPACE(45)
					oGet:CtrlRefresh() 
					oGet:SetFocus()
					Return()
				Endif
			Endif
			
			While TRBD2->(!EOF())
				aAdd(aCols,{	.T.,;
				TRBD2->C5_NUM,;
				TRBD2->D2_DOC,;
				TRBD2->C5_CLIENTE,;
				TRBD2->A1_NOME,;
				STOD(TRBD2->C5_EMISSAO),;
				TRBD2->C5_TRANSP,;
				TRBD2->A4_NREDUZ })
				
				TRBD2->(dbSkip())
			Enddo    
			
			// Deleta primeira linha do array em branco
			If empty(aCols[1][3])   
				aDel(aCols,1)
				aSize(aCols,len(aCols)-1) 
				oListBox1:Refresh()  
				cNumDig := SPACE(45)
				oGet:CtrlRefresh()                     
				oGet:SetFocus()		// Posiciona no Campo
				Return()
			Endif 
			
			oListBox1:SetArray(aCols)
			oListBox1:bLine := {||{If(aCols[oListBox1:nAt,01],oOK1,oNO1),;
			aCols[oListBox1:nAt,02],;
			aCols[oListBox1:nAt,03],;
			aCols[oListBox1:nAt,04],;
			aCols[oListBox1:nAt,05],;
			aCols[oListBox1:nAt,06],;
			aCols[oListBox1:nAt,07],; 
			aCols[oListBox1:nAt,08] }}
			
			cNumDig := SPACE(45)
			oWin:Refresh()
			oListBox1:Refresh()
			oGet:CtrlRefresh() 
			oGet:SetFocus()     	// Posiciona no Campo
			
			TRBD2->( dbCloseArea() )
		Else
			MsgAlert("NOTA FISCAL NÃO EXISTE NA BASE DE DADOS!!!","ATENÇÃO")
			oListBox1:Refresh()
			cNumDig := SPACE(45)
			oGet:CtrlRefresh() 
			oGet:SetFocus()		
		Endif
	Endif	
Endif   

Return()


//*********************************************
// GRAVA DADOS NA TABELA SF2 E BUSCA NUMERO DO
// MANIFESTO
//*********************************************
Static Function AtuSF2()

Local cQuery3 := ""                  
Private cNumPV 	:= ""  
Private cNumNF	:= ""

// BUSCA NUMERAÇÃO DO MANIFESTO
cNrManif := Soma1(GetMV("ES_NRMANIF"),6)	//Tipo (C) - Numero do Manifesto para Transportadora
cNrManif := Replicate("0",6-Len(Alltrim(cNrManif)))+Alltrim(cNrManif)

// ATUALIZA NUMERDO DO MANIFESTO
dbSelectArea("SX6")
PutMv("ES_NRMANIF",cNrManif)

If !Empty(aCols[1][2])    

	For x := 1 to Len(aCols)
	
		cNumPV := aCols[x][2]
		cNumNF := aCols[x][3]		

//Atualizadao Informação - (SF2)CABEÇALHO DA NOTA
		cQuery3 += " UPDATE "+RetSqlName("SF2")+" SET F2_X_NRMA='"+cNrManif+"'"
		cQuery3 += " WHERE F2_DOC IN ('"+cNumNF+"')  AND F2_SERIE='001' "
		cQuery3 += " AND F2_FILIAL='"+xFilial("SF2")+"' AND F2_X_NRMA = '' "

		TcSqlExec(cQuery3)

	Next x
	
Endif
	
Return()


//*********************************************
// CRIA REGISTRO NA TABELA SZ9
//*********************************************
Static Function AtuSZ9()                     

If !Empty(aCols[1][2])
	
	RecLock("SZ9",.T.)

		SZ9->Z9_FILIAL	:= xFilial("SZ9")	
		SZ9->Z9_NRMA	:= cNrManif		
		SZ9->Z9_MOTMA	:= cMotoris		
		SZ9->Z9_RGMA	:= cRGMot 		
		SZ9->Z9_PLACA	:= cPlaca
		SZ9->Z9_VEICULO	:= cTpVeic
		SZ9->Z9_PALLETS	:= nQtdPal
		SZ9->Z9_OBSM1   := cOBS1		
		SZ9->Z9_OBSM2   := cOBS2		
		SZ9->Z9_OBSM3   := cOBS3		
		SZ9->Z9_OBSM4   := " " 			
		SZ9->Z9_DTMA	:= date() //Sol.Genilson para gera a data do Windows e não mais do sistema -  //dDatabase	
		SZ9->Z9_HRMA	:= time()
		SZ9->Z9_TRANSP 	:= cTransp1		
		SZ9->Z9_LOCMA	:= IF(nRadioL==1,"SIM","NAO")
		//SZ9->Z9_USUARIO	:= 
	MsUnlock()
	
	If MsgYesNo("MANIFESTO GERADO COM SUCESSO - NR."+cNrManif+", DESEJA IMPRIMIR O RELATORIO AGORA ?")
		U_FATR0003(cNrManif)
	Endif

Else   
	If nRadio = 1
		MsgAlert("NENHUM PEDIDO FOI SELECIONADO","ATENÇÃO")		
	Else
		MsgAlert("NENHUMA NOTA FISCAL FOI SELECIONADA","ATENÇÃO")
	Endif
Endif
	
Return()



//FUNÇÃO PARA IMPRIMIR O MANIFESTO
Static Function ImpManif()

//Numero do Manifesto Seleciona no Grid
cNumManif := aBrowse[oListBox:nAt][3]  

If MsgYesNo("DESEJA RE-IMPRIMIR O MANIFESTO NR. "+cNumManif)
	U_FATR0003(cNumManif)
Endif

Return()


//FUNÇÃO PARA EXCLUI O MANIFESTO
Static Function ExcManif()

Local cQuery4 := ""

cGet1 := aBrowse[oListBox:nAt][3]	//Numero do Manifesto Seleciona no Grid

If Empty(cGet1)
	Msginfo("INFORME O NUMERO DO MANIFESTO, PARA SER DELETADO!!!")
Else
	
	If MsgYesNo("CONFIRMA A EXCLUSÃO DO MANIFESTO NR."+cGet1+" ?")
		
		DBSelectArea("SZ9")
		DBSetOrder(1)
		DBSeek(xFilial("SZ9")+cGet1)
		
		If Found()
			
			//Atualiza Tabela - (SF2) CABEÇALHO DA NF DE SAIDA
			cQuery4 += " UPDATE "+RetSqlName("SF2")+" SET F2_X_NRMA=' '"
			cQuery4 += " WHERE F2_X_NRMA='"+cGet1+"'  "
			cQuery4 += " AND F2_FILIAL='"+xFilial("SF2")+"' AND D_E_L_E_T_ = '' "
			
			//Atualiza Tabela - (SZ9) CONTROLE MANIFESTO
			cQuery4 += " UPDATE "+RetSqlName("SZ9")+" SET D_E_L_E_T_='*',"
			cQuery4 += " Z9_OBSM4='DELETADO:"+Substr(cUsuario,7,15)+" "+dtos(ddatabase)+" "+substr(time(),1,5)+"' "
			cQuery4 += " WHERE Z9_NRMA='"+cGet1+"' "
			cQuery4 += " AND Z9_FILIAL='"+xFilial("SZ9")+"'  AND D_E_L_E_T_ = '' "
			
			//Processa Update EXCLUIR
			TcSqlExec(cQuery4)
			
			Msginfo("EXCLUSÃO DO MANIFESTO NR. "+cGet1+" PROCESSADO COM SUCESSO","ATENÇÃO")
			
			oWindow:Refresh()
			oListBox:Refresh()		
		Else
			Msginfo("MANIFESTO INFORMADO NÃO EXISTE NA BASE DE DADOS","ATENÇÃO")

		Endif 

	Endif	

Endif                 

cGet1	:= SPACE(06)
oWindow:Refresh()

Return()

