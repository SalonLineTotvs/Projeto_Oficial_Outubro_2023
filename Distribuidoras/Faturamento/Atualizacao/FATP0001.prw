#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//CLIENTE		- SALON LINE  (Revisado G)
//FUNÇÃO		- FATP0001 - GERAR EXECAUTO - Com base no dados informados pelo Usuario - PROJETO DISTRIBUIÇÃO
//FUNÇÃO		- ALTERAÇÃO- Foi solicitado mudança no escopo do Projeto para gerar arquivo texto e enviar por email. Sol.Genilson Lucas!
//MODULO		- FATURAMENTO
//AUTORIZAÇÃO	- GENILSON LUCAS/GERENTE TI
//AUTOR 		- GENILSON LUCAS
//*****************************************************************************************************************************************
// Melhoria             - Data 11/01/2021 - Configurar para Transmitir automaticamente via webservice - Dados do Monta Carga c/ Logistica
//                                        - Solicitação: Consultor Fiscal Rogerio Sasso  // Autor: Andre Salgado / Introde 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

User Function FATP0001()

Private oWindow
Private oOK 	:= LoadBitmap(GetResources(),'br_verde')
Private oNO 	:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias	:= GetNextAlias()
Private cGet1	:= Space(6)
Private dGet1	:= DATE()
Private dGet2	:= DATE()
Private aBrowse	:= {}
Private oGet
Private _EOL	:= Chr(13)+Chr(10)

Private oFont 	:= TFont():New('Courier new',,-14,.F.,.T.)
Private oFont1 	:= TFont():New('Courier new',,-25,.F.,.T.)   
Private oFont4	:= TFont():New('Courier new',,-24,.F.,.T.)

//*************************************************
// TELA INICIAL
//*************************************************
If Len(aBrowse) == 0
	aAdd(aBrowse,{.T.,SPACE(08),CTOD(" / / "),SPACE(10),SPACE(20),CTOD(" / / "),SPACE(10) })
Endif

DEFINE MSDIALOG oWindow FROM 38,16 TO 600,880 TITLE Alltrim(OemToAnsi("MONTA CARGA 2.0")) Pixel

@ 002, 005 To 058, 425 Label Of oWindow Pixel

oSay  	:= TSay():New(015,010,{|| "MONTA CARGA: " },oWindow,,oFont,,,,.T.,)
@ 014,080 Get cGet1 picture "@E 999999999" size 10,10 OF oWindow PIXEL
@ 014,140 Button "PESQUISAR"  size 44.4,12 action Processa( {|| PesqMC()}, "AGUARDE...", "PESQUISANDO...") OF oWindow PIXEL

oSay  	:= TSay():New(036,010,{|| "DATA MONTA CARGA: " },oWindow,,oFont,,,,.T.,)
@ 035,080 Get dGet1 picture "@D" size 44.5,10 OF oWindow PIXEL

oSay  	:= TSay():New(036,130,{|| "A" },oWindow,,oFont,,,,.T.,)
@ 035,140 Get dGet2 picture "@D" size 44.5,10 OF oWindow PIXEL

@ 014,295 Button "INCLUIR" 		size 55,12 action Processa( {|| IncMc() }) OF oWindow PIXEL
@ 034,295 Button "GERAR TXT" 	size 55,12 action Processa( {|| GerarArq() }) OF oWindow PIXEL
@ 014,360 Button "EXCLUIR" 		size 55,12 action Processa( {|| ExcMc() }, "AGUARDE EXCLUINDO...") OF oWindow PIXEL
@ 034,360 Button "FECHAR"  		size 55,12 action oWindow:End() OF oWindow PIXEL

oListBox	:= twBrowse():New(059,005,420,215,,{" ","NUMERO","DATA","HORA","USUARIO","DT ENVIO TXT","HR ENVIO TXT"},,oWindow,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

oListBox:SetArray(aBrowse)
oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
						aBrowse[oListBox:nAt,02],;
						aBrowse[oListBox:nAt,03],;
						aBrowse[oListBox:nAt,04],;
						aBrowse[oListBox:nAt,05],;
						aBrowse[oListBox:nAt,06],;
						aBrowse[oListBox:nAt,07]}}

// 	Tela para visualizar Pedidos da Onda																				  //
oListBox:bLDblClick := {|| VisualPV() }  

oWindow:Refresh()
oListBox:Refresh()

ACTIVATE MSDIALOG oWindow centered

Return()                    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//BOTÃO PESQUISAR
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function PesqMC()

Local cQuery := ""
aBrowse	:= {}

If Select("TRBSZ5") > 0
	TRBSZ5->( dbCloseArea() )
EndIf

//Busca Dados para Pesquisa - SZ5 Monta Carga
cQuery :=	" SELECT Z5_NRMC, Z5_DTMC, Z5_HRMC, Z5_USERMC, Z5_DTTXT, Z5_HRTXT "
cQuery +=	" FROM "+RETSQLNAME("SZ5")+" Z5	"
cQuery +=	" WHERE D_E_L_E_T_ = ''	"

If !Empty(dGet1) .and. !Empty(dGet2)
	cQuery +=	" AND Z5_DTMC BETWEEN '"+dtos(dGet1)+"' AND '"+dtos(dGet2)+"' "
Endif

If !Empty(cGet1)
	cQuery +=	" AND Z5_NRMC = '"+cGet1+"' "
Endif

cQuery +=	" AND Z5_FILIAL= '"+xFilial("SZ5")+"'"

TCQUERY cQuery NEW ALIAS "TRBSZ5"

dbSelectArea("TRBSZ5")
TRBSZ5->(dbGoTop())

While TRBSZ5->(!EOF())
	aAdd(aBrowse,{IIF(EMPTY(TRBSZ5->Z5_DTTXT),.F.,.T.),;
					TRBSZ5->Z5_NRMC,;
					STOD(TRBSZ5->Z5_DTMC),;
					TRBSZ5->Z5_HRMC,;
					TRBSZ5->Z5_USERMC,;
					STOD(TRBSZ5->Z5_DTTXT),;
					TRBSZ5->Z5_HRTXT})
					TRBSZ5->(dbSkip())
Enddo
                     
oListBox:SetArray(aBrowse)
oListBox:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
						aBrowse[oListBox:nAt,02],;
						aBrowse[oListBox:nAt,03],;
						aBrowse[oListBox:nAt,04],;
						aBrowse[oListBox:nAt,05],;
						aBrowse[oListBox:nAt,06],;
						aBrowse[oListBox:nAt,07] }}

oWindow:Refresh()          

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//  INCLUIR MONTA CARGA  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function IncMc()

Local oNota
//Local oMemo

Private oWin
Private oOK1 	:= LoadBitmap(GetResources(),'br_verde')
Private oNO1 	:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias1	:= GetNextAlias()
Private cNumDig := '' // Numero pedido/NF digitado
Private aCols	:= {}
Private cdtEm1	:= ddatabase	//Ctod("  /  /  ")
Private cdtEm2	:= ddatabase	//Ctod("  /  /  ")
Private nVolum	:= 0
Private nPeso	:= 0
Private nValor	:= 0
Private nSelec	:= 0

If SM0->M0_ESTENT == "SP"

	//Variaveis
	Set Device To Screen
	oNota := NIL
	cCol2	:= 75		//Coluna da Tela Parametros
	
	//Tela de Parametros
	@ 247,182	To 570,520 Dialog oNota Title OemToAnsi("Parâmetros - Monta Carga 2.0")
	
	@ 005,010	Say OemToAnsi("Informar a data da Emissão das Notas Fiscais para ")
	@ 015,010	Say OemToAnsi("geração do Monta Carga.")
	
	@ 2.5 , 001 To 8.7, 019 Label OemToAnsi('Filtrar por')
	@ 060,020	Say OemToAnsi("Emissão De ?")
	@ 050,cCol2	Get cdtEm1 size 50,50
	@ 083,020	Say OemToAnsi("Emissão Até?")
	@ 083,cCol2	Get cdtEm2	size 50,50
	
	//Botoes
	@ 130,055 BmpButton Type 1 Action (RptStatus({|| AtuTabela() }),Close(oNota))
	@ 130,085 BmpButton Type 2 Action Close(oNota)
		
	Activate Dialog oNota Centered
	Set Device To Print

Else
	If Len(aCols) == 0
		aAdd(aCols,{.T.,SPACE(02),SPACE(02),SPACE(02),SPACE(30),CTOD(" / / "),SPACE(10),SPACE(10),SPACE(10)}) 
	Endif

	DEFINE MSDIALOG oWin FROM 38,16 TO 600,1100 TITLE Alltrim(OemToAnsi("MONTA CARGA 2.0 - SELECIONAR NOTAS FISCAIS")) Pixel

	@ 032, 002 To 278, 538 Label Of oWin Pixel

	cNumDig := Space(7) // Numero pedido/NF digitado

	oSay  	:= TSay():New(037,007,{|| "PEDIDO: " },oWin,,oFont1,,,,.T.,)                                                     
	oGet	:= tGet():New(036.3,060,{|u| if(Pcount()>0,cNumDig:=u,cNumDig)},oWin,60,15,"@E 9999999",{||ValidDig(cNumDig)},,,oFont1,,,.T.,,,,,,,,,,"cNumDig",,,,,.F.)

	oSay  	:= TSay():New(040,140,{|| "VOLUME: " },oWin,,oFont,,,,.T.,)                                                     
	oSay1  	:= TSay():New(040,175,{||TRANSFORM(nVolum,"@E 999,999") },oWin,,oFont,,,,.T.,CLR_GREEN)
	
	oSay  	:= TSay():New(040,230,{|| "P BRUTO: " },oWin,,oFont,,,,.T.,)                                                     
	oSay2  	:= TSay():New(040,265,{||TRANSFORM(nPeso,"@E 99,999.999") },oWin,,oFont,,,,.T.,CLR_GREEN)
	
	oSay  	:= TSay():New(040,330,{|| "VALOR: " },oWin,,oFont,,,,.T.,)                                                     
	oSay3  	:= TSay():New(040,365,{||TRANSFORM(nValor,"@E 999,999.999") },oWin,,oFont,,,,.T.,CLR_GREEN)
	
	oSay  	:= TSay():New(040,430,{|| "SELECIONADOS: " },oWin,,oFont,,,,.T.,)                                                     
	oSay4  	:= TSay():New(040,480,{||TRANSFORM(nSelec,"@E 999,999") },oWin,,oFont,,,,.T.,CLR_GREEN)

	oListBox1	:= twBrowse():New(059,005,530,215,,{" ","PEDIDO","NOTA FISCAL","CLIENTE","NOME CLIENTE","EMISSAO NF","VOLUME","PESO","VALOR"},,oWin,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

	oListBox1:SetArray(aCols)
	oListBox1:bLine := {||{If(aCols[oListBox1:nAt,01],oOK1,oNO1),;
							aCols[oListBox1:nAt,02],; 
							aCols[oListBox1:nAt,03],;
							aCols[oListBox1:nAt,04],;
							aCols[oListBox1:nAt,05],;
							aCols[oListBox1:nAt,06],;
							aCols[oListBox1:nAt,07],;
							aCols[oListBox1:nAt,08],;
							aCols[oListBox1:nAt,09]}}

	oListBox1:bLDblClick := {|| aCols[oListBox1:nAt][1] := !aCols[oListBox1:nAt][1],oListBox1:DrawSelect()}

	oWin:Refresh()

	//ACTIVATE MSDIALOG oWin centered 
	ACTIVATE MSDIALOG oWin CENTERED ON INIT EnchoiceBar(oWin,{||lOk:=.T.,AtuTabela(),oWin:End()},{||oWin:End()},,)
EndIf

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// VALIDA DIGITAÇÃO DO PEDIDO INFORMADO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function ValidDig()

DbSelectArea('SA1')

Local cQuery1	:= ''
Local nY		:= 0

	If !Empty(cNumDig)
		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5")+cNumDig,.F.) .AND. !Eof()
			
			If Empty(SC5->C5_NOTA) .OR. SC5->C5_NOTA == 'XXXXXX'
				Msginfo("Pedido "+Alltrim(cNumDig)+" não possui NF emitida, favor selecionar outro pedido.","Atenção")
				oListBox1:Refresh()
				cNumDig := SPACE(07)
				oGet:CtrlRefresh()  			
				oGet:SetFocus()
				Return()
			Endif
			
			
			If !(SC5->C5_X_STAPV $ "6/7")
				MsgAlert("Pedido "+Alltrim(cNumDig)+" não está apto para ser incluido no Monta Carta, favor verificar Status do Pedido","Atenção")
				oListBox1:Refresh()
				cNumDig := SPACE(07)
				oGet:CtrlRefresh()  
				oGet:SetFocus()
				Return()				
			EndIf
			
			
			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(xFilial("SF2")+SC5->C5_NOTA,.F.)	
			If !Empty(F2_X_NRMC)
				MsgAlert("Pedido "+Alltrim(cNumDig)+" já foi incluido no Monta Carga "+F2_X_NRMC+", favor selecionar outro Pedido.","Atenção")
				oListBox1:Refresh()
				cNumDig := SPACE(07)
				oGet:CtrlRefresh()  
				oGet:SetFocus()
				Return()
			Endif
			
			// Verificar se pedido ja foi informado no acols no manifesto
			For nY := 1 To Len(aCols)                               
				If cNumDig = aCols[nY][2] .and. !empty(aCols[1][2])
					MsgAlert("Pedido já adicionado na lista.","Atenção") 
					oListBox1:Refresh() 
					cNumDig := SPACE(07)
					oGet:CtrlRefresh()  			
					oGet:SetFocus()
					Return()                      
				Endif
			Next nY

			If Select("TRBC5") > 0
				TRBC5->( dbCloseArea() )
			EndIf 
			
			//Busca Dados para Pesquisa - SC5 Controle Manifesto
			cQuery1 :=	" SELECT D2_PEDIDO, D2_DOC, D2_CLIENTE, A1_NOME, F2_EMISSAO, F2_VOLUME1, F2_PBRUTO, F2_VALMERC "
			cQuery1 +=	" FROM SD2020 D2 (NOLOCK) "
			cQuery1 += 	" INNER JOIN "+RetSQLName("SF2")+" F2 (NOLOCK) ON F2_FILIAL = D2_FILIAL AND  F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND "
			cQuery1 += 	" 								   		F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO AND F2.D_E_L_E_T_= '' "
			cQuery1 +=	" INNER JOIN "+RETSQLNAME("SA1")+" A1 (NOLOCK) ON D2_CLIENTE+D2_LOJA = A1_COD+A1_LOJA AND A1.D_E_L_E_T_ ='' " 	

			//Genesis/Gustavo - Troca de conceito
			//Filtro para o processo de embarque será tratado no campo A1_XGCARGA (1=Sim;2=Nao) 
			//If Alltrim(SM0->M0_CODFIL) <> "0201"  //CROZE
			//	cQuery1	+= 	" INNER JOIN "+RetSQLName("SF4")+" F4 (NOLOCK) ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_= '' "
			//EndIf		
			cQuery1 +=	" WHERE D2.D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cNumDig+"' AND D2_FILIAL = '"+xFilial("SD2")+"'  "  
			cQuery1 +=	" GROUP BY D2_PEDIDO, D2_DOC, D2_CLIENTE, A1_NOME, F2_EMISSAO, F2_VOLUME1, F2_PBRUTO, F2_VALMERC " 

			TCQUERY cQuery1 NEW ALIAS "TRBC5"

			DBSelectArea("TRBC5")
			TRBC5->(dbGoTop())
			
			//Filtro para o processo de embarque será tratado no campo A1_XGCARGA (1=Sim;2=Nao) 
			DBSelectArea('SA1');SA1->(DbSetOrder(1)); SA1->(DbGoTop())
			IF SA1->(DbSeek(xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA))
				IF SA1->(FieldPos("A1_XGCARGA")) > 0
					IF SA1->A1_XGCARGA <> '1'
						_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
						_cPopUp += ' <br> '
						_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Carga de Mercadoria</font> '
						_cPopUp += ' <br>'
						_cPopUp += ' <font color="#000000" face="Arial" size="3">'+SA1->A1_NOME+'</font> '
						_cPopUp += ' <br> '
						_cPopUp += ' <font color="#000000" face="Arial" size="2">Cliente não configurado para processo de Carga! </font> '
						Alert(_cPopUp,'Salonline')	
										
						oListBox1:Refresh() 
						cNumDig := SPACE(07)
						oGet:CtrlRefresh()  			
						oGet:SetFocus()
						Return()  		
					ENDIF	
				ENDIF
			ENDIF

			While TRBC5->(!EOF())				
				nSelec++
				aAdd(aCols,{	.T.,;
								TRBC5->D2_PEDIDO,;
								TRBC5->D2_DOC,;
								TRBC5->D2_CLIENTE,;
								TRBC5->A1_NOME,;
								STOD(TRBC5->F2_EMISSAO),;
								TRBC5->F2_VOLUME1,;
								TRBC5->F2_PBRUTO,;
								TRBC5->F2_VALMERC })
				
				nVolum	+= TRBC5->F2_VOLUME1
				nPeso	+= TRBC5->F2_PBRUTO
				nValor	+= TRBC5->F2_VALMERC				
				TRBC5->(dbSkip())
			Enddo             
			
			// Deleta primeira linha do array em branco
			//##Genesis/Gustavo - ajustado para verificar se existe dados antes da remoção da linha em branco
			IF Len(aCols) > 0
				If empty(aCols[1][2])   
					aDel(aCols,1)
					aSize(aCols,len(aCols)-1) 
					oListBox1:Refresh()
					cNumDig := SPACE(07)
					oWin:Refresh() 
					oGet:CtrlRefresh()                     
					oGet:SetFocus()		// Posiciona no Campo
					Return()
				Endif
			Endif

			oListBox1:SetArray(aCols)
			oListBox1:bLine := {||{	If(aCols[oListBox1:nAt,01],oOK1,oNO1),;
									aCols[oListBox1:nAt,02],; 
									aCols[oListBox1:nAt,03],;
									aCols[oListBox1:nAt,04],;
									aCols[oListBox1:nAt,05],;
									aCols[oListBox1:nAt,06],;
									aCols[oListBox1:nAt,07],; 
									aCols[oListBox1:nAt,08],; 
									aCols[oListBox1:nAt,09] }}

			cNumDig := SPACE(07)
			oWin:Refresh()
			oListBox1:Refresh()
			oGet:CtrlRefresh()
			oGet:SetFocus()     	// Posiciona no Campo
			
			oSay1:Refresh()
			oSay2:Refresh()
			oSay3:Refresh()
			oSay4:Refresh()

		Else
			MsgAlert("Pedido informado não existe na Base de Dados, favor selecionar outro pedido.","Atenção")
			oListBox1:Refresh()
			cNumDig := SPACE(07)
			oGet:CtrlRefresh()  			
			oGet:SetFocus()
			Return()
		Endif         
	Endif
Return()
              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// CRIA REGISTRO NA TABELA SZ5 e ATUALIZA TABELA SF2 COM NÚMERO DO MONTA CARGA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function AtuTabela()                     

Local x 		:= 0

Private cNrMtCg := ""
Private cNumPV 	:= "'"
Private cNumNF 	:= "'"
Private cQry	:= ""
Private cUpd	:= ""


If Len(aCols) > 0  
	For x := 1 to Len(aCols)		
		cNumPV += aCols[x][2]+"','"		
	Next		
	//ELIMINAR ÚLTIMO (,')
	cNumPV	:= Substr(cNumPV,1,Len(cNumPV)-2)	
EndIf
    
cQry	+=	" SELECT D2_PEDIDO, D2_DOC "
cQry 	+= 	" FROM SD2020 D2 WITH(NOLOCK) "
cQry 	+= 	" INNER JOIN "+RetSQLName("SF2")+" F2 WITH(NOLOCK) ON F2_FILIAL = D2_FILIAL AND  F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND "
cQry 	+= 	" 								   		F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO AND F2.D_E_L_E_T_= '' "
cQry 	+= 	" INNER JOIN "+RetSQLName("SC5")+" C5 WITH(NOLOCK) ON C5_FILIAL = D2_FILIAL AND D2_PEDIDO = C5_NUM AND C5.D_E_L_E_T_= '' "

If Alltrim(SM0->M0_CODFIL) <> '0201' //CROZE
	cQry 	+= 	" INNER JOIN "+RetSQLName("SF4")+" F4 WITH(NOLOCK) ON F4_FILIAL = D2_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_= '' "
EndIf

cQry	+=	" WHERE  D2.D_E_L_E_T_= ''  AND D2_FILIAL = '"+xFilial("SD2")+"' AND D2_QUANT > 0	AND D2_TIPO = 'N' AND F2_X_NRMC = '' " 
	        
If Len(aCols) > 0 	//Usuario Selecionou a Opção FILTRO
	cQry += " AND C5_NUM IN ("+cNumPV+")"
	
Else	//Selecinou Opção por Data
	cQry +=	" AND D2_EMISSAO BETWEEN '"+dtos(cdtEm1)+"' AND '"+dtos(cdtEm2)+"' "
Endif                   
	
cQry +=	" GROUP BY D2_PEDIDO, D2_DOC "
	
	
If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf
		
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),"TRB", .F., .T.)
		
dbSelectArea("TRB")
dbGoTop()
		
While TRB->( !EOF() )
	//cNumPV	+= TRB->D2_PEDIDO	+"','"
	cNumNF	+= TRB->D2_DOC		+"','"
		
	dbSelectArea("TRB")
	dbSkip()
EndDo     
TRB->( dbCloseArea() )
	
//ELIMINAR ÚLTIMO (,')
//cNumPV	:= Substr(cNumPV,1,Len(cNumPV)-2)
cNumNF	:= Substr(cNumNF,1,Len(cNumNF)-2)

If !Empty(cNumPV) .And. !Empty(cNumNF)     
	
	// BUSCA NUMERAÇÃO DO MONTA CARGA
	cNrMtCg := Soma1(GetMV("ES_FATP001"),6)	//Tipo (C) - Numero do Monta Carga
	cNrMtCg := Replicate("0",6-Len(Alltrim(cNrMtCg)))+Alltrim(cNrMtCg)

	RecLock("SZ5",.T.)
		SZ5->Z5_FILIAL	:= xFilial("SZ5")
		SZ5->Z5_NRMC	:= cNrMtCg		
		SZ5->Z5_DTMC	:= Date()
		SZ5->Z5_HRMC	:= Time()
		SZ5->Z5_USERMC	:= Upper(TRIM(SUBSTR(CUSUARIO,7,15)))
	MsUnlock()
    
    // ATUALIZA NUMERDO DO MONTA CARGA
    dbSelectArea("SX6")
    PutMv("ES_FATP001",cNrMtCg)
      
	//Atualizadao Informação - (SF2)CABEÇALHO DA NOTA
	cUpd += " UPDATE "+RetSqlName("SF2")+" SET F2_X_NRMC ='"+cNrMtCg+"'"
	cUpd += " WHERE F2_DOC IN ("+cNumNF+")"
	cUpd += " AND F2_FILIAL='"+xFilial("SF2")+"' AND F2_X_NRMC ='' AND D_E_L_E_T_ = '' "
        
	TcSqlExec(cUpd)
	
	//GERAR TXT E ENVIAR EMAIL
	//GerarTxt(cNrMtCg)
	
	MsgInfo("Monta Carga gerado com sucesso, favor processar o envio do documento.","Atenção")
	PesqMC()	
Else
	MsgAlert("Não existem dados para a seleção informada.","Operação Cancelada")
EndIf
          
oWindow:Refresh()
	
Return()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// GERA ARQUIVO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function GerarArq()

If Len(aBrowse) > 0
	//Registro selecionado                     
	cNumMC := aBrowse[oListBox:nAt][2]	//Numero do Manifesto Seleciona no Grid
	
	If !Empty(cNumMc)
		GerarTxt(cNumMC)
	Else
		MsgAlert("Favor selecionar um número do Monta Carga para envio do arquivo.","Atenção")
	EndIf

	oWindow:Refresh()
	oListBox:Refresh()		
Else
	MsgAlert("Favor selecionar um número do Monta Carga para envio do arquivo.","Atenção")
EndIf

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//GERAR ARQUIVO TXT 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function GerarTxt(cNrMtCg)

Private _cEnter := CHR(13)+CHR(10)
Private	cSeqPVEn:= " " //TRB1->B1_PROC
Private	cNomArqE01:= cNomArqE02:= cNomArqE03 := ""	//Arquivo texto a gerar

Private EmailTI 	:= "protheus.logs@salonline.com.br"+SPACE(80)
Private cAssunto 	:=  ALLTRIM(SM0->M0_FILIAL) + " - MONTA CARGA # "+ cNrMtCg
Private cEmailCom1  := ""
Private cEmailCom2  := ""  
Private cMensagem	:= SPACE(80) 

Private nQtdVolDev  := 0    // Quantidade de Volume Devintex
Private nQPalleDev  := 0    // Quantidade de Pallets Devintex

Private nQtdVolAlf  := 0    // Quantidade de Volume Alfalog
Private nQPalleAlf  := 0    // Quantidade de Pallets Alfalog

Private nVolTot		:= 0
Private nPalTot		:= 0


//*** CRIADO PARAMETRO ES_FAT010... PARA INFORMAR O EMAIL DO RESPONSAVEM EM RECEBER DADOS DA DISTRIBUIDORA  ->  ENCOMENTANTE
cEmailCom1	:= SuperGetMv("ES_FATP01A",.F.,emailTI,)+space(40)
cEmailCom2	:= SuperGetMv("ES_FATP01B",.F.,emailTI,)+space(40)

cGeArq	:= "S"

//Variaveis - ExecAuto PEDIDO DE VENDA
aCabec	:= {}	//Cabeçalho
aLinha	:= {}	//Item - temporario
aItens	:= {}	//Item - Final
nSeqIPV	:= 0	//Sequencia

//Variveis de Controle do arquivo Webservice - Sol.Rogerio Sasso
cPostPar := '{"API_MC":{"ITENS": ['

If cGeArq="S"
	cArqTxt1:= "\SPOOL\"	//Deixar Fixo, assim tera menos cliques para usuario final
Else
	cArqTxt1:= ""
Endif

//APRESENTA TELA COM E-MAIL PARA ENVIO
TelaMail(cNrMtCg) 

//Usuario confirma o processamento realmente antes do sistema iniciar!
If MsgYesNo("Confirma geração do arquivo do Monta Carga "+cNrMtCg+" para envio?","Confirmação")   //" - Confirma a geração de Pedido de Compra nas Encomentantes neste momento ?")
	
	//Query - Buscar os dados
	cQuery := " SELECT "
	cQuery += " 'X' TIPO,"
	cQuery += " '"+DTOS(dDATABASE)+"' C5_NUM,"
	cQuery += " '"+SM0->M0_NOMECOM+"' A1_NOME, '"+SM0->M0_ENDENT+"' A1_END, '"+SM0->M0_COMPENT+"' A1_COMPLEM, '"+SM0->M0_BAIRENT+"' A1_BAIRRO, '"+SM0->M0_ESTENT+"' A1_EST,"
	cQuery += " '"+SM0->M0_CIDENT+"' A1_MUN, '"+SM0->M0_CEPENT+"' A1_CEP, '"+SM0->M0_CGC+"' A1_CGC, '"+SM0->M0_INSC+"' A1_INSCR, '"+SM0->M0_TEL+"' A1_TEL,"
	cQuery += " D2_COD, B1_DESC, B1_POSIPI, B1_PROC,"
	cQuery += " '"+DTOS(dDATABASE)+"' C5_EMISSAO,"
	cQuery += " ' ' D2_ITEM, ROUND(SUM(D2_QUANT),2) D2_QUANT, ROUND(SUM(D2_TOTAL),2) D2_TOTAL" //, ROUND(SUM(D2_TOTAL)/SUM(D2_QUANT),4) C6_PRCVEN"
	
	cQuery += " FROM SD2020 D2"
	cQuery += " INNER JOIN "+RetSQLName("SF2")+" F2 WITH(NOLOCK) ON F2_FILIAL = D2_FILIAL AND  F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND "
	cQuery += " 								   		F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO AND F2.D_E_L_E_T_= '' "
	cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON D2_PEDIDO = C5_NUM AND C5.D_E_L_E_T_= '' AND C5_FILIAL='"+xFilial("SC5")+"' "
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON D2_COD    = B1_COD AND B1.D_E_L_E_T_= '' AND B1_FILIAL='"+xFilial("SB1")+"'"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON D2_CLIENTE= A1_COD AND D2_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' AND A1_FILIAL='"+xFilial("SA1")+"'"
	
	cQuery += " WHERE D2.D_E_L_E_T_=' ' "
	cQuery += " AND D2_FILIAL='"+xFilial("SD2")+"'"		//Filtra Filial Logado
	cQuery += " AND D2_QUANT > 0 "						//Filtra para Quantidade de Produto
	
	cQuery += " AND F2_X_NRMC = '"+cNrMtCg+"' "	
	
	cQuery += " GROUP BY D2_COD, B1_DESC, B1_POSIPI, B1_PROC"
	cQuery += " ORDER BY B1_PROC, D2_COD"
	
	If Select("TRB1") > 0
		TRB1->( dbCloseArea() )
	EndIf
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)
	TCSETFIELD("TRB1","C5_EMISSAO"	,"D",10,0)  //Data Emissao PEDIDO
	TCSETFIELD("TRB1","D2_QUANT"	,"N",16,2)  //Quantidade
	TCSETFIELD("TRB1","D2_TOTAL"	,"N",16,2)  //Valor TOTAL
	
	//**** Processo os dados da QUERY - PRE NOTA e DOCUMENTO DE ENTRADA ****
	dbSelectArea("TRB1")
	dbGoTop()
	
	While !EOF()
		
		//Regra Arquivo TEXTO - Das Encomentando
		If cSeqPVEn <> TRB1->B1_PROC
			IF TRB1->B1_PROC = "002196" 		// DEVINTEX
				cNomArqE01:= Alltrim(cArqTxt1)+"DEVINTEX_"+dtos(dDatabase)+"_"+Substr(time(),1,2)+Substr(time(),4,2)+".txt"
				nHdl1     := fCreate(cNomArqE01)
				cArqTxt   := "10"+Padr(SM0->M0_FILIAL,20)+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")+SPACE(05)+cNrMtCg+_cEnter
				fWrite(nHdl1,cArqTxt,Len(cArqTxt))
				nHdl	  := nHdl1

				// Valmir (15/01/21)
				nVolTot := nQtdVolDev
				nPalTot := nQPalleDev


			ElseIF TRB1->B1_PROC = "000005" 	//ALFALOG
				cNomArqE02:= Alltrim(cArqTxt1)+"ALFALOG_"+dtos(dDatabase)+"_"+Substr(time(),1,2)+Substr(time(),4,2)+".txt"
				nHdl2      := fCreate(cNomArqE02)
				cArqTxt   := "10"+Padr(SM0->M0_FILIAL,20)+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")+_cEnter
				fWrite(nHdl2,cArqTxt,Len(cArqTxt))
				nHdl	  := nHdl2

				// Valmir (15/01/21)
				nVolTot := nQtdVolAlf
				nPalTot := nQPalleAlf


			ElseIF Empty(TRB1->B1_PROC) 	//SEM CADSSTRO
				cNomArqE03 := Alltrim(cArqTxt1)+"CADASTRAR_ENCOMEN_"+dtos(dDatabase)+"_"+Substr(time(),1,2)+Substr(time(),4,2)+".txt"
				nHdl3      := fCreate(cNomArqE03)
				cArqTxt   := "10"+Padr(SM0->M0_FILIAL,20)+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")+_cEnter
				fWrite(nHdl3,cArqTxt,Len(cArqTxt))
				nHdl	  := nHdl3			

				nVolTot := nQtdVolDev
				nPalTot := nQPalleDev
			Endif
		Endif
		
		//Cria o arquivo TEXTO
		cArqTxt := "20"+PADR(TRB1->D2_COD,13)+PADR(TRB1->B1_DESC,50)+"UN"+STRZERO(TRB1->D2_QUANT,9)+"000000"+_cEnter
		If fWrite(nHdl,cArqTxt,Len(cArqTxt)) != Len(cArqTxt)
		Endif
		
		cSeqPVEn := TRB1->B1_PROC //Marcação da ENCOMENTANTE
		nSeqIPV ++					 //Sequencial do Item
		
		cCNPJ := STRTRAN(STRTRAN(STRTRAN(TRB1->A1_CGC,".",""),"/",""),"-","")
		cSerie:= "444" //PADR(TRB1->ZR_SERIE,3)

		//Variavel Webservice - Sol.Rogerio Sasso
		nRecExpX := 1
		cPostPar += '{ '+_EOL
		cPostPar += '"ZN_CNPJ"   : "'+SM0->M0_CGC+'",'+_EOL
		cPostPar += '"ZN_CODRENT": "'+cNrMtCg+'",'+_EOL
		cPostPar += '"ZN_FABRIC" : "'+STRZERO(nPalTot,5)+SUBSTR(TRB1->B1_PROC,6,1)+'",'+_EOL
		cPostPar += '"ZN_PRODUTO": "'+TRB1->D2_COD+'",'+_EOL
		cPostPar += '"ZN_QTD"	 : '+str(TRB1->D2_QUANT)+","+_EOL
		cPostPar += '"ZN_VOLUME" : '+str(nVolTot)+_EOL	
		cPostPar += '}'
		cPostPar += ','
		//Fim

		dbSelectArea("TRB1")
		dbSkip()
	EndDo	
Endif

//Data 11/01/2021 - Processo para Enviar Dados da NF de Suporte para Logistica - Autor Andre Salgado/Introde
//Sol.Rogerio Sasso / Auditor de processos
//Variavel Webservice
cPostPar := SUBSTR(cPostPar,1,LEN(cPostPar)-1)
cPostPar += ']  }}'

//Envia para REST
If nRecExpX > 0
	//Atualiza os Dados na LOGISTICA
	U_EnvWBMC()	
Endif
//Fim


//Processa ExecAuto - Pedido de Venda
If nSeqIPV > 0

	//Geração do Arquivo
	IF cGeArq="S"
		//		Aviso("Solicitação Atendida", "O ARQUIVO FOI GERADO COM SUCESSO:"+_cEnter+_cEnter+cNomArqE01+_cEnter+cNomArqE02+_cEnter+cNomArqE03,{"OK"})
		cAttFile :=""
		
		IF !Empty(cNomArqE01)
			fClose(nHdl1)
		Endif
		
		IF !Empty(cNomArqE02)
			fClose(nHdl2)
		Endif
		
		IF !Empty(cNomArqE03)
			fClose(nHdl3)
		Endif
		
		//Envia Email quando estiver tudo correto !!!
		if !Empty(cNomArqE01) .or. !Empty(cNomArqE02) .or. !Empty(cNomArqE03)
			                                                                        
			WfArquivoMc(AllTrim(cEmailCom1), AllTrim(cEmailCom2), AllTrim(cAssunto), cNrMtCg )
	
		EndIf
	Endif
Endif
       
Return


Static Function TelaMail(cNrMtCg)

//Tela de Parametros
Local oTela

/* 
15/01/2021 - Valmir

DEFINE MSDIALOG oTela FROM 010,010 TO 320,800 TITLE Alltrim(OemToAnsi("MONTA CARGA 2.0 - ENVIAR ARQUIVO PARA...")) Pixel 
	
oSay3  		:= TSay():New(45,10,{|| "ASSUNTO: " },oTela,,,,,,.T.,)
oGet3		:= tGet():New(43,50,{|u| if(Pcount()>0,cAssunto:=u,cAssunto) },oTela,240,12,"@!",{ || !empty(cAssunto)},,,,,,.T.,,,,,,,.T.,,,"cAssunto",,,,,.F.,,)

oSay4  		:= TSay():New(65,10,{|| "PARA: " },oTela,,,,,,.T.,)
oGeT4		:= tGet():New(63,50,{|u| if(Pcount()>0,cEmailCom1:=u,cEmailCom1) },oTela,320,12,,{ || !empty(cEmailCom1)},,,,,,.T.,,,,,,,,,,"cEmailCom1",,,,,.F.,,)

oSay5  		:= TSay():New(85,10,{|| "CÓPIA: " },oTela,,,,,,.T.,)
oGet5		:= tGet():New(83,50,{|u| if(Pcount()>0,cEmailCom2:=u,cEmailCom2) },oTela,320,12,,,,,,,,.T.,,,,,,,,,,"cEmailCom2",,,,,.F.,,)

oSay6  		:= TSay():New(115,10,{|| "MENSAGEM: " },oTela,,,,,,.T.,)
oGet6		:= tGet():New(113,50,{|u| if(Pcount()>0,cMensagem:=u,cMensagem) },oTela,320,12,,,,,,,,.T.,,,,,,,,,,"cMensagem",,,,,.F.,,)

oTela:lEscClose	:= .F.
             
ACTIVATE MSDIALOG oTela CENTERED ON INIT EnchoiceBar(oTela,{||lOk:=.T.,oTela:End()},{||oTela:End()},,)	     
*/

DEFINE MSDIALOG oTela FROM 010,010 TO 400,800 TITLE Alltrim(OemToAnsi("MONTA CARGA 2.0 - ENVIAR ARQUIVO PARA...")) Pixel
	
oSay3  		:= TSay():New(45,10,{|| "ASSUNTO: " },oTela,,,,,,.T.,)
oGet3		:= tGet():New(43,60,{|u| if(Pcount()>0,cAssunto:=u,cAssunto) },oTela,240,12,"@!",{ || !empty(cAssunto)},,,,,,.T.,,,,,,,.T.,,,"cAssunto",,,,,.F.,,)

oSay4  		:= TSay():New(65,10,{|| "PARA: " },oTela,,,,,,.T.,)
oGeT4		:= tGet():New(63,60,{|u| if(Pcount()>0,cEmailCom1:=u,cEmailCom1) },oTela,320,12,,{ || !empty(cEmailCom1)},,,,,,.T.,,,,,,,,,,"cEmailCom1",,,,,.F.,,)

oSay5  		:= TSay():New(85,10,{|| "CÓPIA: " },oTela,,,,,,.T.,)
oGet5		:= tGet():New(83,60,{|u| if(Pcount()>0,cEmailCom2:=u,cEmailCom2) },oTela,320,12,,,,,,,,.T.,,,,,,,,,,"cEmailCom2",,,,,.F.,,)

oSay6  		:= TSay():New(105,10,{|| "VOL.DEVINTEX: " },oTela,,,,,,.T.,)
oGet6		:= tGet():New(103,60,{|u| if(Pcount()>0,nQtdVolDev:=u,nQtdVolDev) },oTela,50,12,"@E 999,999",,,,,,,.T.,,,,,,,,,,"nQtdVolDev",,,,,.F.,,)

oSay7  		:= TSay():New(105,140,{|| "PALETES DEVINTEX: " },oTela,,,,,,.T.,)
oGet7		:= tGet():New(103,200,{|u| if(Pcount()>0,nQPalleDev:=u,nQPalleDev) },oTela,50,12,"@E 999,999",,,,,,,.T.,,,,,,,,,,"nQPalleDev",,,,,.F.,,)

oSay8  		:= TSay():New(125,10,{|| "VOL.ALFALOG: " },oTela,,,,,,.T.,)
oGet8		:= tGet():New(123,60,{|u| if(Pcount()>0,nQtdVolAlf:=u,nQtdVolAlf) },oTela,50,12,"@E 999,999",,,,,,,.T.,,,,,,,,,,"nQtdVolAlf",,,,,.F.,,)

oSay9  		:= TSay():New(125,140,{|| "PALETES ALFALOG: " },oTela,,,,,,.T.,)
oGet9		:= tGet():New(123,200,{|u| if(Pcount()>0,nQPalleAlf:=u,nQPalleAlf) },oTela,50,12,"@E 999,999",,,,,,,.T.,,,,,,,,,,"nQPalleAlf",,,,,.F.,,)

oSay10  	:= TSay():New(155,10,{|| "MENSAGEM: " },oTela,,,,,,.T.,)
oGet10		:= tGet():New(153,60,{|u| if(Pcount()>0,cMensagem:=u,cMensagem) },oTela,320,12,,,,,,,,.T.,,,,,,,,,,"cMensagem",,,,,.F.,,)

oTela:lEscClose	:= .F.
             
ACTIVATE MSDIALOG oTela CENTERED ON INIT EnchoiceBar(oTela,{||lOk:=.T.,oTela:End()},{||oTela:End()},,)

Return()

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} WfArquivo(_cTo_)
Desc........: Função para Transmissão de EMAIL
@sample.....: ""
@return.....: Nil
@author.....: Genilson M Lucas
@since......: 22/02/2018
@version....: P12
/*/
//------------------------------------------------------------------------------------------

Static Function WfArquivoMc( cTo, cCC, cAssunto, cNrMtCg )

#define CHR_LINE				'<hr>'
#define CHR_CENTER_OPEN			'<div align="center" >'
#define CHR_CENTER_CLOSE   		'</div>'
#define CHR_FONT_DET_OPEN		'<font face="Courier New" size="2">'
#define CHR_FONT_DET_CLOSE		'</font>'
#define CHR_ENTER				'<br>'
#define CHR_NEGRITO				'<b>'
#define CHR_NOTNEGRITO			'</b>'

Local cCodUser 		:= RetCodUsr()
Local _i			:= 0
Local _cCrozeCC 	:= AllTrim(SuperGetMv( "SL_MAILCAR",,.F. ))


Local _cSmtpSrv := SuperGetMV( "MV_RELSERV", Nil, "smtp.gmail.com:587" )

_cSmtpSrv += ":587"

Local _cAccount 	:= AllTrim(SuperGetMv( "MV_RELACNT")),;
_cPassSmtp	:= AllTrim(SuperGetMv( "MV_RELPSW" )),;
lAuth		:= SuperGetMV("MV_RELAUTH",,.F.),;
_cSmtpError	:= '',;
_lOk		:= .f.,;
_cTitulo 	:= cAssunto ,;
_cTo		:= cTo,;
_cCC		:= alltrim(UsrRetMail(cCodUser))+";"+cCC,;
_cCo		:= '' ,;  //CÓPIA OCULTA
_cFrom		:= alltrim(UsrRetMail(cCodUser)),;
_cMensagem	:= '',;
_lReturn	:= .f.,;
_aAnexo		:= {},;
_cAnexo 	:= ""	

If cFilAnt == "0201"
	If Right(_cCrozeCC, 1) == ";"
		_cCC := _cCrozeCC + _cCC
	Else 
		_cCC := _cCrozeCC + ";" + _cCC
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a lista de anexos                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cNomArqE01)
	aadd(_aAnexo, cNomArqE01 )
EndIf
If !Empty(cNomArqE02)
	aadd(_aAnexo, cNomArqE02 )
EndIf
If !Empty(cNomArqE03)
	aadd(_aAnexo, cNomArqE03 )
EndIf

//Zera Variavel do arquivo para Anexo, assim para proximo envio vai processar novamente
cNomArqE01 := cNomArqE02 := cNomArqE03 := ""

For _i := 1 To Len( _aAnexo )
	_cAnexo += _aAnexo[_i] + Iif( _i==Len(_aAnexo), "" , ";" )
Next _i


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a mensagem no corpo do e-mail..³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cMensagem	+= CHR_CENTER_OPEN + CHR_CENTER_CLOSE
_cMensagem	+= CHR_FONT_DET_OPEN

_cMensagem	+= OemToAnsi('Prezado,') + CHR_ENTER
_cMensagem	+= OemToAnsi('Segue o arquivo dos Produtos Vendidos na Distribuidora ')+SM0->M0_NOMECOM+ CHR_ENTER + CHR_ENTER 

_cMensagem	+= OemToAnsi('Pedidos selecionados: ')+CHR_ENTER
	
cQryF2 :=	" SELECT D2_PEDIDO, D2_DOC, F2_EMISSAO "
cQryF2 += 	" FROM SD2020 D2 WITH(NOLOCK) "
cQryF2 += 	" INNER JOIN "+RetSQLName("SF2")+" F2 WITH(NOLOCK) ON F2_FILIAL = D2_FILIAL AND  F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND "
cQryF2 += 	" 								   		F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO AND F2.D_E_L_E_T_= '' "
cQryF2 +=	" WHERE  D2.D_E_L_E_T_= ''  AND D2_FILIAL = '"+xFilial("SD2")+"' AND F2_X_NRMC ='"+cNrMtCg+"' "         	
cQryF2 +=	" GROUP BY D2_PEDIDO, D2_DOC, F2_EMISSAO "
	  
If Select("TRBSF2") > 0
	TRBSF2->( dbCloseArea() )
EndIf
		
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQryF2),"TRBSF2", .F., .T.)
TCSETFIELD("TRBSF2","F2_EMISSAO"	,"D",10,0)  //Data Emissao PEDIDO
		
dbSelectArea("TRBSF2")
dbGoTop()
	
While !EOF()
	_cMensagem	+= TRBSF2->D2_PEDIDO+" - "+TRBSF2->D2_DOC +" "+ DTOC(TRBSF2->F2_EMISSAO) + CHR_ENTER	
	TRBSF2->(dbSkip())
End
	
TRBSF2->( dbCloseArea() )

//Mensagem informado pelo usuário
If !Empty(cMensagem)
	_cMensagem	+= CHR_ENTER
	_cMensagem	+= OemToAnsi(cMensagem)+CHR_ENTER+CHR_ENTER
Else
	_cMensagem	+= CHR_ENTER+CHR_ENTER
EndIf

_cMensagem	+= OemToAnsi('Por favor providenciar a nota fiscal destes arquivos em anexo.') +CHR_ENTER
_cMensagem	+= OemToAnsi('Qualquer dúvida, favor entrar em contato com Departamento de Faturamento')+CHR_ENTER+CHR_ENTER+CHR_ENTER

_cMensagem	+= OemToAnsi('Atenciosamente')+CHR_ENTER+CHR_ENTER
_cMensagem	+= UsrFullName(cCodUser) +CHR_ENTER
_cMensagem	+= OemToAnsi('-----------------------------------------------------------------------------------------') + CHR_ENTER + CHR_ENTER
_cMensagem	+= CHR_NEGRITO + OemToAnsi('Desconsiderar o monta carga da ALFALOG.') + CHR_ENTER + CHR_NOTNEGRITO
_cMensagem	+= CHR_ENTER
_cMensagem	+= CHR_FONT_DET_CLOSE
                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Conectando com o Servidor. !!³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CONNECT SMTP SERVER _cSmtpSrv ACCOUNT _cAccount PASSWORD _cPassSmtp RESULT _lOk
MAILAUTH(_cAccount,_cPassSmtp)

ConOut('Conectando com o Servidor SMTP')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a conexao for esbelecida com sucesso, inicia o processo de envio do e-mail..³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	( _lOk )
	ConOut('Enviando o e-mail')
	SEND MAIL FROM _cFrom TO _cTo Cc _cCC BCC _cCo SUBJECT _cTitulo BODY _cMensagem Attachment _cAnexo RESULT _lOk
	ConOut('De........: ' + _cFrom)
	ConOut('Para......: ' + _cTo)
	ConOut('Assunto...: ' + _cTitulo)
	ConOut('Status....: Enviado com Sucesso')
	
	If	( ! _lOk )
		GET MAIL ERROR _cSmtpError
		ConOut(_cSmtpError)
		_lReturn := .f.
		Alert("FALHA NO ENVIO DO E-MAIL !!!")
	Else
		//Atualizadao Informação - (SZ5) DT DO ENVIO DO TXT
		DbSelectArea("SZ5")
		DbSetOrder(1)
		DbSeek(xFilial("SZ5")+cNrMtCg,.F.)
		If Empty(SZ5->Z5_DTTXT)
			RecLock("SZ5",.F.)
				SZ5->Z5_DTTXT	:= Date()
				SZ5->Z5_HRTXT	:= Time()
			MsUnlock()
		EndIf
			
		MsgInfo("E-mail enviado com Sucesso!","E-mail")
		
		//PARA ATUALIZAR TELA
		PesqMC()
				
	EndIf
	
	DISCONNECT SMTP SERVER
	ConOut('Desconectando do Servidor')
	_lReturn := .t.
Else
	GET MAIL ERROR _cSmtpError
	ConOut(_cSmtpError)
	_lReturn := .f.
EndIf

Return _lReturn


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNÇÃO PARA EXCLUIR MONTA CARGA													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ExcMc()

Local cQuery4 := ""

If Len(aBrowse) > 0
	cGet1 := aBrowse[oListBox:nAt][2]	//Numero do Manifesto Seleciona no Grid

	If Empty(cGet1)
		MsgAlert("Por favor, selecionar o registro para exclusão.","Operação Cancelada")
	Else
		
		If MsgYesNo("Confirma exclusão do Monta Carga Nr. "+cGet1+" ?")
			
			DBSelectArea("SZ5")
			DBSetOrder(1)
			DBSeek(xFilial("SZ5")+cGet1)
			
			If Found()
				
				//Atualiza Tabela - (SF2) CABEÇALHO DA NF DE SAIDA
				cQuery4 += " UPDATE "+RetSqlName("SF2")+" SET F2_X_NRMC=' '"
				cQuery4 += " WHERE F2_X_NRMC='"+cGet1+"'  "
				cQuery4 += " AND F2_FILIAL='"+xFilial("SF2")+"' AND D_E_L_E_T_ = '' "
				
				//Atualiza Tabela - (SZ5) CONTROLE MONTA CARGA
				cQuery4 += " UPDATE "+RetSqlName("SZ5")+" SET D_E_L_E_T_='*', "
				cQuery4 += " Z5_OBS='DELETADO:"+Substr(cUsuario,7,15)+" "+dtos(ddatabase)+" "+substr(time(),1,5)+"' "
				cQuery4 += " WHERE Z5_NRMC = '"+cGet1+"' "
				cQuery4 += " AND Z5_FILIAL = '"+xFilial("SZ5")+"'  AND D_E_L_E_T_ = '' "
				
				//Processa Update EXCLUIR
				TcSqlExec(cQuery4)
				
				Msginfo("O Monta Carga Nro. "+cGet1+" foi excluido com Sucesso.","Processado")	
				
			Else
				MsgAlert("Monta Carga informado não existe na Base de Dados.","Operação Cancelada")
	
			Endif 
	
		Endif	
	
	Endif                 
Else
	MsgAlert("Por favor, selecionar o registro para exclusão.","Operação Cancelada")
EndIf

cGet1	:= SPACE(06)
PesqMC()

Return()


//========================================================================================================================//
// 	Tela para visualizar Pedidos da Onda																				  //
//========================================================================================================================//
Static Function VisualPv()

Private cNroMC		:= aBrowse[oListBox:nAt,02]
Private cQryC5 		:= ""
Private oOK 		:= LoadBitmap(GetResources(),'br_verde')
Private oNO 		:= LoadBitmap(GetResources(),'br_vermelho')
Private cAlias		:= GetNextAlias()
Private oFont 		:= TFont():New('Courier new',,-14,.F.,.T.)

Private aBrwC5		:= {}
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
cQryC5 += 	" C5_NUM, F2_EMISSAO, F2_DOC, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_VOLUME1, C5_VOLUME2 "
cQryC5 += 	" FROM SD2020 D2 WITH(NOLOCK) "
cQryC5 += 	" INNER JOIN "+RetSQLName("SF2")+" F2 WITH(NOLOCK) ON F2_FILIAL = D2_FILIAL AND  F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND "
cQryC5 += 	" 								   		F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO AND F2.D_E_L_E_T_= '' "
cQryC5 += 	" INNER JOIN "+RetSQLName("SC5")+" C5 WITH(NOLOCK) ON C5_FILIAL = D2_FILIAL AND D2_PEDIDO = C5_NUM AND C5.D_E_L_E_T_= '' "
cQryC5 +=	" INNER JOIN "+RETSQLNAME("SA1")+" A1 WITH(NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = '' "
cQryC5 +=	" WHERE D2.D_E_L_E_T_= ''  AND D2_FILIAL = '" +xFilial("SD2")+ "' AND F2_X_NRMC = '"+cNroMC+"' "
cQryC5 +=	" GROUP BY C5_FILIAL, C5_NUM, F2_EMISSAO, F2_DOC, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_VOLUME1, C5_VOLUME2  "
cQryC5 +=	" ORDER BY 1,2 "

TCQUERY cQryC5 NEW ALIAS "TRBC5"

//Processa o Resultado
dbSelectArea("TRBC5")
TRBC5->(dbGoTop())

While TRBC5->(!EOF())
	aAdd(aBrwC5,{	.T.,;
					TRBC5->EMPRESA,;
					TRBC5->C5_NUM,;
					TRBC5->F2_DOC,;
					STOD(TRBC5->F2_EMISSAO),;
					TRBC5->C5_CLIENTE,;
					TRBC5->C5_LOJACLI,;
					TRBC5->A1_NOME,;
					Alltrim(Transform(TRBC5->C5_VOLUME1,"999999")),;
					Alltrim(Transform(TRBC5->C5_VOLUME2,"999999"))})
	
	TRBC5->(dbSkip())	
Enddo
	
If Len(aBrwC5) == 0
	aAdd(aBrwC5,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(06),SPACE(02),SPACE(30),SPACE(02),0,0})
Endif

DEFINE MSDIALOG oTelVis FROM 38,16 TO 600,1200 TITLE Alltrim(OemToAnsi("PEDIDOS SELECIONADOS")) Pixel

@ 002, 005 To 058, 590 Label Of oTelVis Pixel

oSay5  	:= TSay():New(010,010,{|| "PEDIDOS SELECIONADOS NO MONTA CARGA N° "+cNroMC },oTelVis,,oFont4,,,,.T.,CLR_BLUE)
                                                                         
//@ 010,530 Button "REL. ONDA"	size 55,12 action Processa( {|| RelOnda1()}) OF oTelVis PIXEL
//@ 025,530 Button "REL. FALTA"   size 55,12 action Processa( {|| RelOnda2()}) OF oTelVis PIXEL
@ 025,530 Button "FECHAR"  		size 55,12 action oTelVis:End() OF oTelVis PIXEL
		
oListBox3	:= twBrowse():New(059,005,586,215,,{" ","FILIAL","PEDIDO","NOTA FISCAL","DATA NF","CLIENTE","LOJA","NOME CLIENTE","VOL.CAIXA","VOL.GRANEL"},,oTelVis,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
oListBox3:SetArray(aBrwC5)
oListBox3:bLine := {||{If(aBrowse[oListBox:nAt,01],oOK,oNO),;
aBrwC5[oListBox3:nAt,02],;	// FILIAL
aBrwC5[oListBox3:nAt,03],;	// PEDIDO
aBrwC5[oListBox3:nAt,04],;	// NOTA FISCAL
aBrwC5[oListBox3:nAt,05],;	// DATA
aBrwC5[oListBox3:nAt,06],;	// CLIENTE
aBrwC5[oListBox3:nAt,07],;	// LOJA
aBrwC5[oListBox3:nAt,08],;	// NOME CLIENTE
aBrwC5[oListBox3:nAt,09],;  // VOLUME CAIXA
aBrwC5[oListBox3:nAt,10]}}  // VOLUME GRANEL

oTelVis:Refresh()
oListBox3:Refresh()

ACTIVATE MSDIALOG oTelVis centered

Return()



//========================================================================================================================//
// 	Integração com REST - Processo de Transmissao dos Dados ao WebService da Logistica - (11/01/21) / André Salgado
//========================================================================================================================//
User Function EnvWBMC()

Local cUrl      := alltrim(GETMV("ES_URLMC")) //"http://slgroup-jqcdqkghcn.dynamic-m.com:9003/API_MC" 
Local nTimeOut  := 30 //Segundos
Local aHeaderStr:= {}
Local cHeaderRet:= ""
Local cResponse := ""
Local cErro     := ""
Local Enter	:= CHR(13)+CHR(10)

aAdd(aHeaderStr,"Content-Type| application/x-www-form-urlencoded")
aAdd(aHeaderStr,"Content-Length| " + Alltrim(Str(Len(cPostPar))) )

//HttpGetStatus()
cComunic := HttpCGet( cUrl , cPostPar , nTimeOut , aHeaderStr , @cHeaderRet )
cResponse := HttpCPost( cUrl , cPostPar , nTimeOut , aHeaderStr , @cHeaderRet )

VarInfo("Header:", cHeaderRet )
VarInfo("Retorno:", cResponse )
VarInfo("Erro:", HTTPGetStatus(cErro) )
VarInfo("Erro:", cErro )

Return
