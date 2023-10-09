#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.ch'
#INCLUDE 'colors.ch'
#Include "Avprint.ch"
#Include "Font.ch"
#define MB_ICONASTERISK  64
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ESTP0003	 ³ Autor ³ André Valmir 		³ Data ³11/06/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de re-conferência de pedido de vendas				  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
Link Tabela de CORES:
http://www.helpfacil.com.br/forum/display_topic_threads.asp?ForumID=1&TopicID=27176    

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄÄÄÄÄ³±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	 									  ³±±
±±³ 11/06/18	ANDRE VALMIR		13:30 	      															  ³±±
±±³ 																										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±    

Campos Criados

C6_X_VCXC2 - Conf Caixa 2
C6_X_VGRC2 - Conf Granel 2                             


*/

User Function ESTP0003()

// Declaracao das variaveis
Local 	aAreaAtu	:= GetArea()
Local 	aRet		:= {Space(06),space(1)}

Private oGetDad
Private	aHeader		:= {}
Private	aCols		:= {}
Private	aCols2		:= {}
Private cNumPV  	:= ""
Private cTPConfCG	:= ""

Private oBrowse
Private oFont1 		:= TFont():New("ARIAL",,-15,,.F.)
Private oFont2 		:= TFont():New("ARIAL",,-18,,.T.)

Private nQtd		:= 0	// Caso tenha dado .F. uma vez incrementa   *** Valmir (22/12/17)
Private lValConfer	:= .F.  // Validar conferencia Total
Private cItem		:= ""
Private nQtdVolCX	:= 0
//Private lErroConf	:= .F.	// Quando apresentar a mensagem de erro, produto ja conferido gravar um Log.

If !ParamBox( {;
		{1,"Codigo do Pedido",aRet[1],"@!","ExistCPO('SC5',Left(MV_PAR01,6))","SC5","",70,.F.},;
		{2,"Caixa/Granel",aRet[2],{"Caixa","Granel"},50,,.F.};
		},"Conferencia de Separação de Estoque", @aRet,,,,,,,,.T.,.T. )
	
	Return
EndIf


cNumPV 	 	:= aRet[1]	//Numero do Pedido de Venda
cTPConfCG	:= IIF(aRet[2] == "Caixa","C","G")	//Tipo de Conferencia Caixa/Granel

SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cNumPV ))

If cTPConfCG = "C"
	U_TELCONFE(aAreaAtu)
Else
	U_TELCONFE(aAreaAtu)
Endif

RestArea( aAreaAtu )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ TELCONFE  | Autor ³ Andre Valmir         ³ Data ³11/06/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta grid para atualizar lotes de acordo com a leitura    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TELCONFE(aAreaAtu)

// Definicao das variaveis
Local 	oDlg
Local	oCodBar
Local 	cQuery		:= ""
Local 	cAlias		:= GetNextAlias()
Local	cCodBar		:= Space(20)
Local	cLote		:= Space(15)

Local	cLocaliza	:= Space(15)
Local   nTamB1		:= TamSX3('B1_COD')[01]

Local 	cNomeCli 	:= Space(100)
Local 	nLinIni		:= 065
Local 	nLinFim		:= 300
Local	nColIni		:= 1
Local 	nColFim		:= 350
Local 	aSize 		:= MsAdvSize()
Local 	aVetDados	:= {}

Private lRetornoPlt := .F.
Private	cProduto	:= Space(15)

//Busca o Pedido Selecionado
cQuery	:= " SELECT C6_NUM D4_OP, C6_PRODUTO D4_COD, C6_LOCAL D4_LOCAL, C6_LOTECTL D4_LOTECTL,"
cQuery	+= " SUM("+IF(cTPConfCG="C","C6_X_VCXIM","C6_X_VGRIM") +") C6_QTDVEN,"
cQuery	+= " SUM("+IF(cTPConfCG="C","C6_X_VCXC2","C6_X_VGRC2") +") B2_QATU,"
cQuery	+= IF(cTPConfCG="C","C5_VOLUME1","C5_VOLUME2") +" C5_VOLUME1"
cQuery	+= " FROM "+RetSqlName("SC6")+" C6 "
cQuery  += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C5.D_E_L_E_T_=' ' AND C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery	+= " WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery	+= " AND C6_NUM = '"+cNumPV+"' "
cQuery	+= " AND C6.D_E_L_E_T_ = '' "
cQuery	+= " AND C6_BLQ = '' "

If cTPConfCG="C"
	cQuery	+= " AND C6_X_VCXIM > 0 "	 
Else 
	cQuery	+= " AND C6_X_VGRIM > 0 "	
Endif

cQuery	+= " GROUP BY C6_NUM, C6_PRODUTO, C6_LOCAL, C6_LOTECTL,"
cQuery	+= IF(cTPConfCG="C","C5_VOLUME1","C5_VOLUME2")
cQuery	+= " ORDER BY 1,2"
//MemoWrit("C:\AA\BUSCAC6.TXT",cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

If (cAlias)->(!EOF())
	
	// Montagem de aHeader
	vCampos	:= {"D4_COD","C6_QTDVEN","B2_QATU"}
	cQtdVol	:= (cAlias)->C5_VOLUME1
	cQtdVolCX:= 0
	
	DbSelectArea("SX3")
	SX3->(DBSetOrder(2))
	
	For nVez:=1 To Len(vCampos)
		cCampo:=vCampos[nVez]
		SX3->(DBSeek(cCampo,.F.))
		SX3->(aAdd( aHeader,{	IIF(alltrim(X3_CAMPO)=="B2_QATU","Qtde Conferida",IIF(alltrim(X3_CAMPO)=="C6_QTDVEN","Qtde Volume",X3_TITULO)),X3_CAMPO,X3_PICTURE,IIF(alltrim(X3_CAMPO)=="B1_DESC",50,X3_TAMANHO),X3_DECIMAL,;
		"", X3_USADO,X3_TIPO,,"","",;
		"","",IIF(alltrim(X3_CAMPO)=="D4_LOTECTL",_cVisual:='A',_cVisual:='V'),"",""}))
	Next nVez
	
	(cAlias)->(DBGoTop())
	
	// Compatibiliza numeros e datas
	SX3->(DBSetOrder(2))
	For nVez:=1 to (cAlias)->(FCount())
		cCampo:=(cAlias)->(FieldName(nVez))
		If SX3->(DBSeek(cCampo))
			If Alltrim(upper(SX3->X3_TIPO))$"DN"
				SX3->(TcSetField(cAlias,cCampo,X3_TIPO,X3_TAMANHO,X3_DECIMAL))
			EndIf
			
		EndIf
	next nVez                                 
	
	// Alimenta o Grid.
	SX3->(DBSetOrder(1))
	(cAlias)->(DBGoTop())
	
	While (cAlias)->(!EOF())
		
		SB1->(DbSetOrder(1),DbSeek(xFilial("SB1") + (cAlias)->D4_COD ))
		(cAlias)->(aAdd(aCols, {D4_COD,C6_QTDVEN,B2_QATU,.F.}))
		(cAlias)->(DbSkip())
	Enddo
	
	(cAlias)->(DbCloseArea())
	
	cQuery	:= " SELECT 'D4' TIPO, C6_NUM D4_OP, C6_PRODUTO D4_COD, C6_LOCAL D4_LOCAL, C6_X_VCXIM C6_QTDVEN, C6_LOTECTL D4_LOTECTL,' ' D4_TRT, C6_LOCAL DC_LOCALIZ "
	cQuery	+= " ,A1_NOME"
	cQuery	+= " FROM "+RetSqlName("SC6")+" C6"
	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" A1 ON C6_CLI=A1_COD AND C6_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' '
	cQuery	+= " WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
	cQuery	+= " AND C6_NUM = '"+cNumPV+"'
	cQuery	+= " AND C6.D_E_L_E_T_ = '' "
	cQuery	+= " ORDER BY 2,3"
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)
	

	SX3->(DBSetOrder(1))
	
	(cAlias)->(DBGoTop())
	
	cNomeCli := (cAlias)->A1_NOME
	
	While (cAlias)->(!EOF())
		
		SB1->(DbSetOrder(1),DbSeek(xFilial("SB1") + (cAlias)->D4_COD ))
		
		(cAlias)->(aAdd(aCols2, {D4_COD,SB1->B1_DESC,D4_LOCAL,D4_LOTECTL,DC_LOCALIZ,C6_QTDVEN,D4_TRT,IIF(TIPO=="D4","OK",""),0.00,.F.}))
		
		(cAlias)->(DbSkip())
	Enddo
	(cAlias)->(DbCloseArea())
	
	
	aSize[4] += 5
	aSize[5] := aSize[5]/2+270 // Ajustar o tamanho da Tela (300) alterado para 270.
	
	cStatusPV 	:= Posicione("SC5",1,xFilial("SC5")+Alltrim(cNumPV),"C5_X_STAPV")
	
	Do Case
		Case cStatusPV == "0"
			cStatus 	:= "PV Gerado"
		
		Case cStatusPV == "1"
			cStatus 	:= "Liberado"
		
		Case cStatusPV == "2"
			cStatus 	:= "Em Separação"
		
		Case cStatusPV == "3"
			cStatus		:= "Sep Finalizada"
		
		Case cStatusPV == "4"
			cStatus		:= "Em Conferência"
			
		Case cStatusPV == "5"
			cStatus		:= "Confer Finalizada"

		Case cStatusPV == "6"
			cStatus		:= "Faturado"		

		Case cStatusPV == "7"
			cStatus		:= "Manif Imp"		
			
		Case cStatusPV	== "A"
			cStatus		:= "Antecipado"
	
		Otherwise
			cStatus		:= " "			
	EndCase
			
	// Definicao da janela de dialogo para alteracao dos lotes
	Define MsDialog oDlg Title "RE-CONFERÊNCIA DO PEDIDO " + Alltrim(cNumPV) + " - "+cStatus + IF(cTPConfCG="C"," CAIXA"," GRANEL") From 450,0 to 1050,800 PIXEL
	
	@ 003,005 Say "PEDIDO" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 015,005 Say oOp Var cNumPV FONT oFont2 COLOR CLR_BLACK,CLR_RED size 40,10 OF oDlg PIXEL
	
	@ 003,090 Say "CLIENTE" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 015,090 Say oNomeCli Var cNomeCli size 188,10 FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	
	If cTPConfCG = "C" .AND. SC5->C5_X_STAPV == "4" .AND. SC5->C5_X_TLPCC == "P" 
		@ 035,005 Say "CÓD. DE BARRAS" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Else
		@ 035,005 Say "CÓD. DE BARRAS" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,005 Get oCodBar Var cCodBar picture "@!" size 100,11 Valid(aVetDados := DADOSPRD(cCodBar,cProduto,cLote,cLocaliza), cProduto:= PADR(aVetDados[1],nTamB1),cLote:="",cLocaliza:="",POSGETD(cProduto,cLote,cLocaliza), VALIDBAI(cCodBar,cProduto,cLote,oCodBar,cLocaliza),cCodBar:=Space(50),cProduto:=Space(15),cLote:=Space(15),nQtd:=0,cLocaliza:=Space(15) ) FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Endif		

	IF cTPConfCG="G" 
		@ 035,150 Say "QTD. VOLUME" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,150 Get cQtdVol picture "@E 9999" size 10,11 FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Else
		@ 035,130 Say "QTD. VOLUME PALLET" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,130 Get cQtdVolCX picture "@E 9999" size 40,11 Valid(Iif(cQtdVolCX > 0.and.lRetornoPlt==.F.,U_LoginPlt(),.T.)) FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Endif	
		
	@ 010,270 Button "Re-Conferir" size 65,18 action (IIF(MsgYesNo("CONFIRMA A RE-CONFERÊNCIA?"),Processa( {|| RECONFER(),oDlg:End() }, "AGUARDE...", "RE-CONFERINDO PEDIDO..",.F.),.F.),) OF oDlg PIXEL
	@ 035,270 Button "Limpar Re-Conferencia" size 65,18 action (IIF(MsgYesNo("CONFIRMA LIMPEZA DA RE-CONFERÊNCIA FEITA ATÉ O MOMENTO ?"),Processa( {|| LIMPRECF(),oDlg:End() }, "Aguarde...", "Efetuando Limpeza..",.F.),.F.),) OF oDlg PIXEL
	@ 010,350 Button "Fechar" size 45,18 action oDlg:End() // Fecha a Tela
	
	oGetDad:=MsNewGetDados():New(nLinIni,nColIni,nLinFim,nColFim,Nil, _cLinOk:='Allwaystrue()',,,,,_nLimite:=9999,,,lApagaOk:=.f.,oDlg,aHeader,aCols)
	
	nLarg	:= 800
	oGetDad:oBrowse:nWidth:=nLarg
	cursorarrow()
	
	//Muda de COR o GRID
	oGetDad:oBrowse:SetBlkBackColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][2] <> oGetDad:aCols[oGetDad:nAt][3], " + Str(CLR_WHITE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] ," + Str(CLR_LIGHTGRAY) + "," + Str(CLR_WHITE) + "))}"))
	oGetDad:oBrowse:SetBlkColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][3]=0, " + Str(CLR_HBLUE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] .or. oGetDad:aCols[oGetDad:nAt][3] > 0," + Str(CLR_GREEN) + "," + Str(CLR_WHITE) + "))}"))
	oGetDad:oBrowse:Refresh()
			
	ACTIVATE MSDIALOG oDlg centered
	
Else
	
	MsgStop("NAO EXISTEM ITENS A SEREM RE-CONFERINDOS NESTE PEDIDO!!!")
	
EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ RECONFER  | Autor ³ Andre Valmir         ³ Data ³11/06/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava Re-Conferência                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RECONFER()

Local cCodUser 		:= RetCodUsr()

SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + Alltrim(cNumPV) ))

MSGINFO("PEDIDO " +cNumPV+" RE-CONFERIDO")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ DADOSPRD  | Autor ³ Andre Valmir         ³ Data ³11/06/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tratamento do array com os lotes X array da separacao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DADOSPRD(cCodBar,cProduto,cLote,cLocaliza)

Local aVetDados := {}

aVetDados := Separa(UPPER(Alltrim(cCodBar)),"}",.T.)

If Empty(cCodBar) .OR. Len(Alltrim(cCodBar)) < 6   // Valmir (22/03/2018)
	
	//	MsgStop("Codigo de Barras Invalido!11")
	aVetDados := {"","",""}
		
Else 
	
	IF cTPConfCG="C" //?"CAIXA"	- Tipo de Codigo de Barras DUM14 - Controlado no sistema -> B1_CODBAR
		If SB1->(DbSetOrder(5), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)) ))
			aVetDados := {}
			AADD(aVetDados, SB1->B1_COD)
			AADD(aVetDados, substr(cCodBar,8,15))
			AADD(aVetDados, "")
		EndIf

	Else	//?"GRANEL"	- Tipo de Codigo de Barras EAN13 - Controlado no sistema -> B1_X_EAN13 , foi criado indice (SB1 - Order 13)
		If SB1->(DbSetOrder(13), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)) ))
			aVetDados := {}
			AADD(aVetDados, SB1->B1_COD)
			AADD(aVetDados, substr(cCodBar,8,15))
			AADD(aVetDados, "")
		EndIf
	Endif
	
End If

Return aVetDados


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ LIMPRECF   | Autor ³ Andre Valmir        ³ Data ³11/06/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpar Re-Conferencia							           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LIMPRECF()

//Preparar para gravar no SC6 *** - Gravar em Tempo REAL

DBSelectarea("SC6")
DBSetOrder(1)                        
DbgoTop()
DBSeek(xFilial("SC6")+Alltrim(cNumPV))

IF cTPConfCG="C"	// C=CAIXA
	
	For nY := 1 To Len(aCols)
		While SC6->(!eof()) .and. Alltrim(SC6->C6_NUM) == Alltrim(cNumPV)
			Reclock("SC6",.F.)
			SC6->C6_X_VCXC2 := 0
			msunlock()
			SC6->(dbskip())
		Enddo
	Next nY
	
ELSE				// G=GRANEL
	For nY := 1 To Len(aCols)
		While SC6->(!eof()) .and. Alltrim(SC6->C6_NUM) == Alltrim(cNumPV)
			Reclock("SC6",.F.)
			SC6->C6_X_VGRC2 := 0
			msunlock()
			SC6->(dbskip())
		Enddo
	Next nY
	
ENDIF

Return                                          

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ POSGETD   | Autor ³ Andre Valmir         ³ Data ³26/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Posiciona na linha correspondente a leitura                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function POSGETD(cProduto,cLote,cLocaliza)

Local nPos := 0

nPos := aScan(aCols,{|_vPdo| _vPdo[1]==cProduto })

If nPos > 0
	
	oGetDad:GoTo(nPos)
	oGetDad:oBrowse:Refresh()
	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ VALIDBAI  | Autor ³ Andre Valmir         ³ Data ³11/06/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a validacao e baixa virtual no Grid                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VALIDBAI(cCodBar,cProduto,cLote,oCodBar,cLocaliza)

Local _nLinGrid 	:= 0

_nLinGrid:= aScan(oGetDad:aCols,{|_vPdo| _vPdo[1]==cProduto })

If _nLinGrid==0 .And. !Empty(cProduto)                   
	Tone()
	alert("PRODUTO NÃO ENCONTRADO NO PEDIDO DE VENDAS","ATENÇÃO")
	Tone()
	
	oGetDad:oBrowse:Refresh() 		// Atualiza Grid
	oGetDad:GoTo(1)
	oCodBar:SetFocus()				// Posiciona no Campo
	
	Return
End If

If Empty(cProduto)
	Return
End If


_nLinGrid:= aScan(oGetDad:aCols,{|_vPdo| _vPdo[1]==cProduto})

IF oGetDad:aCols[oGetDad:nAt][2] <= oGetDad:aCols[oGetDad:nAt][3]
	     
	Tone()	
	MsgAlert("QUANTIDADE ULTRAPASSOU CONTAGEM","ATENÇÃO!")
	Tone()	
	
	//MontaRel()
	
Else 
	AtuAcols(cProduto)			// Soma a quantidade do Grid
Endif

oGetDad:oBrowse:SetBlkBackColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][2] <> oGetDad:aCols[oGetDad:nAt][3], " + Str(CLR_WHITE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] ," + Str(CLR_LIGHTGRAY) + "," + Str(CLR_WHITE) + "))}"))
oGetDad:oBrowse:SetBlkColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][3]=0, " + Str(CLR_HBLUE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] .or. oGetDad:aCols[oGetDad:nAt][3] > 0," + Str(CLR_GREEN) + "," + Str(CLR_WHITE) + "))}"))

oGetDad:oBrowse:Refresh() 		// Atualiza Grid
oGetDad:GoTo(1)
oCodBar:SetFocus()

Return

//Leitura do Codigo de Barras Validado na Conferencia (CAIXA / GRANEL)
//************************
//*** Atualiza o ACOLS ***
//************************
Static Function AtuAcols(cProduto)
                                                  
cItem := Posicione("SC6",2,xFilial("SC6")+cProduto+Alltrim(cNumPV),"C6_ITEM")

SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cNumPV + cItem + cProduto)) 

If cTPConfCG="C" .AND. cQtdVolCX>0 .AND. SC6->C6_X_VCXCO > 0
	Alert("ATENÇÃO, QUANTIDADE DIGITADA INVALIDA, FAVOR REVER QUANTIDADE!!!")
	Return     	
Endif

//Contador de leitura - Criado para atender a Demanda do Lancamento da Quantidade do Pallet
IF cTPConfCG="C" .AND. cQtdVolCX>0	//Se FOR CAIXA e FOR INFORMADO A QUANTIDADE DE VOLUME
	cContQtd := cQtdVolCX			//Calculo com informacao de PALLET
else
	cContQtd := 1					//Calculo da Leitura Codigo de Barras
Endif


For nX := 1 To Len(aCols)
	If alltrim(cProduto) =	alltrim(oGetDad:aCols[nx][1])
		oGetDad:aCols[nx][3] 	+= cContQtd
	Endif
Next nX

//Preparar para gravar no SC6 *** - Gravar em Tempo REAL
DBSelectarea("SC6")
DBSetOrder(1)
DBSeek(xFilial("SC6")+Alltrim(cNumPV) + cItem) 


IF cTPConfCG="C"	//SEPARACAO =>  C=CAIXA
	
	//*******************************************
	// PARA TRATAR PEDIDO COM 2 TES
	//*****************************************

	//busca faturamento para processar
	If SC6->C6_X_VCXC2 < SC6->C6_X_VCXIM .and. alltrim(cProduto) == Alltrim(SC6->C6_PRODUTO)

		If cQtdVolCX > SC6->C6_X_VCXIM
			Tone()
			Alert("ATENÇÃO QUANTIDADE DE CAIXAS DIGITADAS NO PALLET É MAIOR QUE A QUANTIDADE SOLICITADA!!!")
			Tone()
			Return
		Endif
		
		
		Reclock("SC6",.F.)
			SC6->C6_X_VCXC2 += cContQtd
		msunlock()
	
	Endif

Else

	//*******************************************
	// PARA TRATAR PEDIDO COM 2 TES
	//*****************************************	
	//busca faturamento para processar
	If SC6->C6_X_VGRC2 < SC6->C6_X_VGRIM .and. alltrim(cProduto) == Alltrim(SC6->C6_PRODUTO)
	
		reclock("SC6",.F.)
			SC6->C6_X_VGRC2 += cContQtd
		msunlock()

	Endif
ENDIF

//Zera variavel
cQtdVolCX := 0

Return()

// Gerar relatorio no final para demonstrar os Itens com Problema

/*
Static Function MontaRel()


Local aItens	:={}
Local cProdConf	:=  Alltrim(cProduto)

AADD(aItens,{"LOCPICK"  ,"C",06,0})
AADD(aItens,{"PRODUTO"  ,"C",15,0})
AADD(aItens,{"QTDSOLIC" ,"N",7,0})
AADD(aItens,{"QTDCONFE" ,"N",7,0})
AADD(aItens,{"DIVERGEN" ,"C",1,0})

_cArqTrb := CriaTrab(aItens,.T.)
dbUseArea(.T.,,_cArqTrb,"TRB",.T.)
dbSelectArea("TRB")

While ! EOF()

	DBSelectArea("SC6")
	DBSetOrder(1)
	DBGoTop()
	DBSeek(xFilial("SC6")+cNumPV)
	
	DBSelectArea("SB1")
	DBSetOrder(1)
	DBSeek(xFilial("SB1")+cProdConf)
	
	
	DBSelectArea("TRB")
	RecLock("TRB",.T.)
		TRB->LOCPICK 	:= SB1->B1_X_LOCAL
		TRB->PRODUTO 	:= cProdConf
//		TRB->QTDSOLIC 	:=
//		TRB->QTDCONFE	:=
//		TRB->DIVERGEN	:=
	MsUnLock()


Enddo
*/
	 
Return()