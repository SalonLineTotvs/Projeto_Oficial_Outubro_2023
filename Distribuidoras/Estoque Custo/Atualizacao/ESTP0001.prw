#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.ch'
#INCLUDE 'colors.ch'
#Include "Avprint.ch"
#Include "Font.ch"
#define MB_ICONASTERISK  64
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ESTP0001	 ³ Autor ³ André Valmir 		³ Data ³07/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de conferência de pedido de vendas					  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
Link Tabela de CORES:
http://www.helpfacil.com.br/forum/display_topic_threads.asp?ForumID=1&TopicID=27176    

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					                                       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	 									  ³±±
±±³ 26/02/18	ANDRE SALGADO		18:00								 									  ³±±
±±³ 27/02/18	ANDRE VALMIR		19:45								  									  ³±±
±±³	01/03/18	GENILSON LUCAS		10:00								 									  ³±±
±±³ 06/03/18	ANDRE VALMIR		19:00							 										  ³±±
±±³ 07/03/18	ANDRE VALMIR		10:00																	  ³±±
±±³ 07/03/18	ANDRE Salgado		13:00 - Regra 02 item iguais 											  ³±±
±±³ 07/03/18	ANDRE Salgado		17:20 - Incluir Etiqueta DISTRIBUIDORA									  ³±±
±±³ 08/03/18	ANDRE VALMIR		19:45							 										  ³±±        
±±³ 09/03/18	ANDRE VALMIR		19:30																	  ³±±
±±³ 13/03/18	ANDRE VALMIR		20:10																	  ³±±
±±³ 15/03		GENILSON			29:30 REGRA PARA LIMPAR CONF 											  ³±±
±±³ 16/03/18	ANDRE VALMIR		11:30 REGRA PARA ATUALIZAR STATUS/GERAR PV ANTES DE IMPRIMIR ETIQUETA	  ³±±
±±³ 19/03/18	ANDRE VALMIR		19:30 																	  ³±±
±±³ 21/03/18	ANDRE VALMIR		21:30 																	  ³±±
±±³ 22/03/18	ANDRE VALMIR		15:20 																	  ³±±
±±³ 23/03/18	ANDRE VALMIR		16:00 																	  ³±±
±±³ 25/04/18	GENILSON LUCAS		18:00																	  ³±±
±±³ 29/10/18	ANDRE VALMIR		16:00 ADICIONADO NA IMPRESSÃO DA ETIQUETA (CONTEM CAIXA E GRANEL)         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

** Criar os campos **                         
C5_XCCDSEP - Tipo C - 8 - CX COD Separador
C5_XCNMSEP - Tipo C -20 - CX Nome Separador
C5_XCDTSEP - Tipo D - 8 - CX Dt Separador
C5_XCHRSEP - Tipo C - 8 - CX Hr Separador

C5_XGCDSEP - Tipo C - 8 - GR COD Separador
C5_XGNMSEP - Tipo C -20 - GR Nome Separador
C5_XGDTSEP - Tipo D - 8 - GR Dt Separador
C5_XGHRSEP - Tipo C - 8 - GR Hr Separador

C5_XCCDCNF - Tipo C - 8 - CX COD Conferente
C5_XCNMCNF - Tipo C -20 - CX Nome Conferente
C5_XCDTCNF - Tipo D - 8 - CX Dt Conferente
C5_XCHRCNF - Tipo C - 8 - CX Hr Conferente

C5_XGCDCNF - Tipo C - 8 - GR COD Conferente
C5_XGNMCNF - Tipo C -20 - GR Nome Conferente
C5_XGDTCNF - Tipo D - 8 - GR Dt Conferente
C5_XGHRCNF - Tipo C - 8 - GR Hr Conferente

B1_X_EAN13 - Tipo C - 13- EAN 13
Criado Indice (13) - SB1- B1_FILIAL + B1_X_EAN13


==> Atualizar Campo PadrÃ£o nesta REGRA
C5_VOLUME1 - Atualizar Quantidade de Volumes de CAIXA
C5_VOLUME2 - Atualizar Quantidade de Volumes de GRANEL

C6_XQTCXCX - Tipo N (12,2)	- Qtd Conferida CAIXA  (grava durante o processo)
C6_XQTCXGR - Tipo N (12,2)	- Qtd Conferida GRANEL (grava durante o processo)

Criado o C6_XQTDCON - Tipo N (12,2)	- Qtd Conferida  (grava durante o processo)
Criado o C6_XQTDSAL - Tipo N (12,2)	- Qtd Conf.Salva (grava EFETIVAÃ‡ÃƒO do processo)


C5_X_TLPCC	- Tipo - Caracter C (1) - Lib.T/P.CX (Lib.Total/Parcial Caixa) Lista OpÃ§Ãµes P=Parcial;T=Total
C5_X_TLPCG	- Tipo - Caracter C (1) - Lib.T/P.GR (Lib.Total/Parcial Granel) Lista OpÃ§Ãµes P=Parcial;T=Total

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTP0001()

// Declaracao das variaveis
Local 	aAreaAtu	:= GetArea()
Local 	aRet		:= {Space(06),space(1)}

Private oGetDad
Private	aHeader		:= {}
Private	aCols		:= {}
Private	aCols2		:= {}
Private cOp  		:= ""
Private cTPConfCG	:= ""
Private cPI  		:= ""
Private lMsErroAuto	:= .F.
//Private lEtiqGer	:= .F.

Private oBrowse
Private oFont1 		:= TFont():New("ARIAL",,-15,,.F.)
Private oFont2 		:= TFont():New("ARIAL",,-18,,.T.)

Private lgravaCAB 	:= .T.	//Flag para confirmar Gravacao
Private aCabec		:= {}	//Cabeçalho
Private aLinha		:= {}	//Item - temporario
Private aItens		:= {}	//Item - Final

Private nSeqIPV		:= 0	//Sequencia
Private cTxtUpdate	:= ""
Private lGerPed 	:= .F.	// *** Valmir (Flag para gerar pedido de vendas caso a senha seja validada. 
Private lVazio		:= .F.	// Caso for tentar conferir com falta e a quantidade de todos itens for igual a zero, o sistema nao deve gerar a conferencia  
Private nQtd		:= 0	// Caso tenha dado .F. uma vez incrementa   *** Valmir (22/12/17)
Private lValidaGrd	:= .F.
Private lValConfer	:= .F.  // Validar conferencia Total
Private lGerEtiq	:= .F.
Private cItem		:= ""
Private nQtdVolCX	:= 0

Private cEmail		:= SuperGetMV("SL_EMAILTI",.F.,"protheus.logs@salonline.com.br")

If !ParamBox( {;
	{1,"Codigo do Pedido",aRet[1],"@!","ExistCPO('SC5',Left(MV_PAR01,6))","SC5","",70,.F.},;
	{2,"Caixa/Granel",aRet[2],{"Caixa","Granel"},50,,.F.};
	},"Conferencia de Separação de Estoque", @aRet,,,,,,,,.T.,.T. )
	
	Return
End If


cOp 	 	:= aRet[1]	//Numero do Pedido de Venda
cTPConfCG	:= IIF(aRet[2] == "Caixa","C","G")	//Tipo de Conferencia Caixa/Granel

SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp ))
cPI := SC6->C6_NUM 	//PRODUTO                     


//Muda Status - Pedido de Venda
SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cOp ))

If cTPConfCG = "C"
	If SC5->C5_X_STAPV $ "2/3" //EM SEPARCAO OU SEPARACAO FINALIZADA
		reclock("SC5",.F.)
			SC5->C5_X_STAPV	:= "4"	// INICIOU CONFERENCIA
		    SC5->C5_X_DTICF	:= Date()
			SC5->C5_X_HRICF	:= TIME()	                     	
		msunlock()
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SC5->C5_X_TLPCC)
			U_SLPCPA21(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Endif
	
	ElseIf SC5->C5_X_STAPV $ "4" //.AND. !Empty(SC5->C5_X_DTISP) //"4/5/6/7"
	
		reclock("SC5",.F.)
			If Empty(SC5->C5_X_HRICF) 
			    SC5->C5_X_DTICF	:= Date()
				SC5->C5_X_HRICF	:= TIME()
			Endif	                     	
		msunlock()
		//Apresenta Tela da Conferencia de Produto
		If Empty(SC5->C5_X_TLPCC)
			U_SLPCPA21(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")				
		Endif	      
		
		
	ElseIf SC5->C5_X_STAPV $ "0/1" //.OR. Empty(SC5->C5_X_DTISP) Verificar com Genilson (19/03/2018)
		MSGALERT("FAVOR SOLICITAR LIBERAÇÃO DO PEDIDO PARA INICIAR CONFERÊNCIA.","PEDIDO NÃO LIBERADO")
		Return()
	Else
		MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Return()	
	Endif             
Else 
	If SC5->C5_X_STAPV $ "1/2/3/A" //LIBERADO, EM SEPARACAO, SEPARACAO FINALIZADA OU ANTECIPADO
		If SC5->C5_X_TLNCX = 0 
		
			reclock("SC5",.F.)
				SC5->C5_X_STAPV	:= "4"	// INICIOU CONFERENCIA		                     	
			msunlock()
		EndIf
			
		If Empty(SC5->C5_X_HRIGR) // Valmir (16/03/2018)
			reclock("SC5",.F.)
			    SC5->C5_X_DTIGR	:= Date()
				SC5->C5_X_HRIGR	:= TIME() 
			msunlock()
		EndIf         
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SC5->C5_X_TLPCG)
			U_SLPCPA21(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Endif
	
	ElseIf SC5->C5_X_STAPV $ "4" //"4/5/6/7"
		If Empty(SC5->C5_X_HRIGR) // Valmir (16/03/2018)
			reclock("SC5",.F.)
			    SC5->C5_X_DTIGR	:= Date()
				SC5->C5_X_HRIGR	:= TIME() 
			msunlock()
		EndIf
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SC5->C5_X_TLPCG)
			U_SLPCPA21(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")		
		Endif	
	
	ElseIf SC5->C5_X_STAPV $ "0"
		MSGALERT("FAVOR SOLICITAR LIBERAÇÃO DO PEDIDO PARA INICIAR CONFERÊNCIA.","PEDIDO NÃO LIBERADO")
		Return()
	Else
		MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Return()	
	Endif  
EndIf


RestArea( aAreaAtu )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA21  | Autor ³ Andre Valmir         ³ Data ³07/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta grid para atualizar lotes de acordo com a leitura    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SLPCPA21(aAreaAtu)

// Definicao das variaveis
Local 	oDlg
Local	oCodBar
Local 	oFontLin	:= TFont():New("ARIAL",,20,,.T.)
Local 	cQuery		:= ""
Local 	cAlias		:= GetNextAlias()
Local	cCodBar		:= Space(20)
Local	cNomePrd	:= Space(70)
Local 	cTipo		:= Space(1)
Local	cLote		:= Space(15)

Local	cLocaliza	:= Space(15)
Local   nTamB1		:= TamSX3('B1_COD')[01]

Local 	cNomeCli 	:= Space(100)
Local	nLinha		:= 0  
Local 	nLinIni		:= 065
Local 	nLinFim		:= 300
Local	nColIni		:= 1
Local 	nColFim		:= 350
Local 	nFator		:= 1
Local 	aSize 		:= MsAdvSize()
Local 	aVetDados	:= {}
Local 	nVez		:= 0

Private lRetornoPlt := .F.
Private	cProduto	:= Space(15)
Private cQtdVolDig	:= 0


//Busca o Pedido Selecionado
cQuery	:= " SELECT C6_NUM D4_OP, C6_PRODUTO D4_COD, C6_LOCAL D4_LOCAL, C6_LOTECTL D4_LOTECTL,"
cQuery	+= " SUM("+IF(cTPConfCG="C","C6_X_VCXIM","C6_X_VGRIM") +") C6_QTDVEN,"
cQuery	+= " SUM("+IF(cTPConfCG="C","C6_X_VCXCO","C6_X_VGRCO") +") B2_QATU,"
cQuery	+= IF(cTPConfCG="C","C5_VOLUME1","C5_VOLUME2") +" C5_VOLUME1"
cQuery	+= " FROM "+RetSqlName("SC6")+" C6 "
cQuery  += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C5.D_E_L_E_T_=' ' AND C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery	+= " WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery	+= " AND C6_NUM = '"+cOp+"' "
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
	
	//nQtdVolPL:= 0	// Quantidade de Pallets digitado pelo operador, para sair quantiade de etiquetas conforme definido pelo operador
	
	
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
	cQuery	+= " AND C6_NUM = '"+cOp+"'
	cQuery	+= " AND C6.D_E_L_E_T_ = '' "
	cQuery	+= " ORDER BY 2,3"
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)
	
	// Alimenta o Grid.	-> Deixar (Valmir)
	SX3->(DBSetOrder(1))
	
	(cAlias)->(DBGoTop())
	
	cNomeCli := (cAlias)->A1_NOME	//NOME DO CLIENTE
	
	While (cAlias)->(!EOF())
		
		SB1->(DbSetOrder(1),DbSeek(xFilial("SB1") + (cAlias)->D4_COD ))
		
		(cAlias)->(aAdd(aCols2, {D4_COD,SB1->B1_DESC,D4_LOCAL,D4_LOTECTL,DC_LOCALIZ,C6_QTDVEN,D4_TRT,IIF(TIPO=="D4","OK",""),0.00,.F.}))
		
		(cAlias)->(DbSkip())
	Enddo
	(cAlias)->(DbCloseArea())
	
	
	// Ajustes em aSize, permitindo que opere bem em diversas resolucoes, supondo que seja utilizado
	// para dimensionar o dialog principal e um getdados na parte de baixo

	aSize[4] += 5
	aSize[5] := aSize[5]/2+270 // Ajustar o tamanho da Tela (300) alterado para 270.
	
	cStatusPV 	:= Posicione("SC5",1,xFilial("SC5")+Alltrim(cOp),"C5_X_STAPV")
	
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
	Define MsDialog oDlg Title "Separação de Pedido " + Alltrim(cOp) + " - "+cStatus + Space(5)+ "Conferência " + IF(cTPConfCG="C","CAIXA","GRANEL") From 450,0 to 1050,800 /**nFator*/ PIXEL
	
	@ 003,005 Say "PEDIDO" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 015,005 Say oOp Var cOp FONT oFont2 COLOR CLR_BLACK,CLR_RED size 40,10 OF oDlg PIXEL
	
	@ 003,090 Say "CLIENTE" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 015,090 Say oNomeCli Var cNomeCli size 188,10 FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	
	If cTPConfCG = "C" .AND. SC5->C5_X_STAPV == "4" .AND. SC5->C5_X_TLPCC == "P" 
		@ 035,005 Say "CÓD. DE BARRAS" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Else
		@ 035,005 Say "CÓD. DE BARRAS" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,005 Get oCodBar Var cCodBar picture "@!" size 100,11 Valid(aVetDados := SLPCPA22(cCodBar,cProduto,cLote,cLocaliza), cProduto:= PADR(aVetDados[1],nTamB1),cLote:="",cLocaliza:="",POSGETD(cProduto,cLote,cLocaliza), SLPCPA25(cCodBar,cProduto,cLote,oCodBar,cLocaliza),cCodBar:=Space(50),cProduto:=Space(15),cLote:=Space(15),nQtd:=0,cLocaliza:=Space(15) ) FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Endif		

	IF cTPConfCG="G" 
		@ 035,150 Say "QTD. VOLUME PEDIDO" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,150 Get cQtdVol picture "@E 9999" size 10,11 FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Else
		@ 035,130 Say "QTD. VOLUME PALLET" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,130 Get cQtdVolDig picture "@E 9999" size 40,11 Valid(Iif(cQtdVolDig > 0.and.lRetornoPlt==.F.,U_LoginPlt(),.T.)) FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL	
	Endif	
	
	
	//@ 010,300 Button "Etiquetas"	size 55,18 action (IIF(MsgYesNo("Confirma?"),Processa( {|| SLPCPA27(cOp) }, "Aguarde...", "Gerando...",.F.),.F.),oDlg:End()) OF oDlg PIXEL
	
	@ 010,280 Button "Conferir"		size 55,18 action (IIF(MsgYesNo("Confirma a conferência?"),Processa( {|| SLPCPA24(),oDlg:End() }, "Aguarde...", "Liberando Pedido..",.F.),.F.),) OF oDlg PIXEL
	@ 010,340 Button "Conferencia c/ Falta"	size 55,18 action (IIF(MsgYesNo("Confirma a Conferência c/ Falta ?"),Processa( {|| SLPCPA26() }, "Aguarde...", "Gerando Pedido com Saldo...",.F.),.F.),oDlg:End()) OF oDlg PIXEL
	@ 035,280 Button "Limpa Conferencia" 	size 55,18 action (IIF(MsgYesNo("Confirma Limpeza na conferência feita até o momento ?"),Processa( {|| SLPCPA30(),oDlg:End() }, "Aguarde...", "Efetuando Limpeza..",.F.),.F.),) OF oDlg PIXEL
	@ 035,340 Button "Fechar" size 55,18 action oDlg:End() // Fecha a Tela
	
	oGetDad:=MsNewGetDados():New(nLinIni,nColIni,nLinFim,nColFim,Nil, _cLinOk:='Allwaystrue()',,,,,_nLimite:=9999,,,lApagaOk:=.f.,oDlg,aHeader,aCols)
	
	nLarg	:= 800//int(aSize[5]*nFator)
	oGetDad:oBrowse:nWidth:=nLarg
	cursorarrow()
	
	//Muda de COR o GRID
	oGetDad:oBrowse:SetBlkBackColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][2] <> oGetDad:aCols[oGetDad:nAt][3], " + Str(CLR_WHITE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] ," + Str(CLR_LIGHTGRAY) + "," + Str(CLR_WHITE) + "))}"))
	oGetDad:oBrowse:SetBlkColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][3]=0, " + Str(CLR_HBLUE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] .or. oGetDad:aCols[oGetDad:nAt][3] > 0," + Str(CLR_GREEN) + "," + Str(CLR_WHITE) + "))}"))
	oGetDad:oBrowse:Refresh()
			
	ACTIVATE MSDIALOG oDlg centered
	
Else
	
	MsgStop("NAO EXISTEM ITENS A SEREM CONFERINDOS NESTE PEDIDO!!!")
	
End If

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ SLPCPA24  | Autor ³ Andre Valmir         ³ Data ³18/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava e gera ETIQUETA                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA24()	// Conferencia

Local cCodUser 		:= RetCodUsr()

SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + Alltrim(cOp) ))

If SC5->C5_X_STAPV == "5"     // Antigo SC5->C5_X_STAPV == "3"
	Tone()
	Alert("ESTE PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, FAVOR SELECIONAR OUTRO PARA CONFERÊNCIA")
	Tone()
	Return
Endif     

If cTPConfCG = "C" .AND. SC5->C5_X_STAPV == "4" .AND. !Empty(SC5->C5_X_TLPCC)
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA DO PEDIDO, "+Alltrim(cOp)+" FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")	
	Tone()          
	Return
Endif
     
If cTPConfCG = "G" .AND. SC5->C5_X_STAPV == "4" .AND. !Empty(SC5->C5_X_TLPCG)
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA DO PEDIDO "+Alltrim(cOp)+",FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")
	Tone()          
	Return
Endif


If cTPConfCG="G"                                   

	Reclock("SC5",.F.)
		SC5->C5_VOLUME2 := cQtdVol	//Gravar VOLUME EM GRANEL
	msunlock()
	
	If cQtdVol <= 0       
		Tone()
		Aviso("ATENCAO","INFORMAR A QUANTIDADE DE VOLUMES PARA EFETIVAR A GRAVAÇÃO",{"OK"})
		Tone()
		Return         
	Else

		ValidarQtd()
		
		If !lValConfer
			Return
		Endif

		If lValConfer .and. Empty(SC5->C5_X_CONGR)
			Reclock("SC5",.F.)
				SC5->C5_VOLUME2 := cQtdVol	//Gravar VOLUME EM GRANEL
				SC5->C5_X_CONGR := UsrFullName( cCodUser )
				SC5->C5_X_DTCGR := Date()
				SC5->C5_X_HRCGR := TIME()
				SC5->C5_X_TLPCG := "T"
			msunlock()
		Endif
	Endif	            

Else	// Caixa          
	
	If Empty(SC5->C5_X_DTFSP)
	    Tone()
	    MSGALERT("ATENÇÃO, FAVOR FINALIZAR A SEPARAÇÃO PARA CONSEGUIR FINALIZAR A CONFERÊNCIA!!!")
	    Tone()
		Return
	Endif
	
	
	ValidarQtd()
	
	If !lValConfer
		Return
	Endif

	If lValConfer .and. Empty(SC5->C5_X_CONCX)
		CalcVolCX(cOp)
		Reclock("SC5",.F.)        
			SC5->C5_VOLUME1 := nQtdVolCX
			SC5->C5_X_CONCX := UsrFullName( cCodUser )
			SC5->C5_X_DTCCX := Date()
			SC5->C5_X_HRCCX := TIME()
			SC5->C5_X_TLPCC	:= "T"
		msunlock()
    Endif
Endif
	
// Gerar Pedido das Faltas (Valmir 27/02/2018)
If SC5->C5_X_TLPCG == "P" .AND. SC5->C5_X_TLPCC == "P" 
	//lEtiqGer := .T.
	GeraPV()

Elseif SC5->C5_X_TLPCG == "P" .AND. SC5->C5_X_TLPCC == "T"
	//lEtiqGer := .T.
	GeraPV()

Elseif SC5->C5_X_TLPCG == "T" .AND. SC5->C5_X_TLPCC == "P"
	//lEtiqGer := .T.
	GeraPV()
Endif

SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cOp ))

// Valida Caixa e Granel
If !Empty(SC5->C5_X_TLPCG) .and. !Empty(SC5->C5_X_TLPCC)
	Reclock("SC5",.F.)  	
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	msunlock()

	//!!!Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9
	cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
	cTxtSC9 += " WHERE "
	cTxtSC9 += " C9_PEDIDO='"+cOp+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
	TcSqlExec(cTxtSC9)

Endif

// Validar se e somente Granel
IF SC5->C5_X_TLNCX = 0 .AND. SC5->C5_X_TLNGR > 0
	Reclock("SC5",.F.)  	
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	msunlock()


	//!!!Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9
	cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
	cTxtSC9 += " WHERE "
	cTxtSC9 += " C9_PEDIDO='"+cOp+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
	TcSqlExec(cTxtSC9)

Endif

// Validar se e somente Caixa
IF SC5->C5_X_TLNCX > 0 .AND. SC5->C5_X_TLNGR = 0
	Reclock("SC5",.F.)  	
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	msunlock()

	//!!!Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9
	cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
	cTxtSC9 += " WHERE "
	cTxtSC9 += " C9_PEDIDO='"+cOp+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
	TcSqlExec(cTxtSC9)


Endif

//Imprimir ETIQUETA
				
nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )
			                 
//lValConfer := .T.
if nOpc = 1 .AND. !lGerEtiq
	SLPCPA27(cOp)
Endif


/*
//Atualiza Dados do Pedido de Venda
*/


Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ SLPCPA22  | Autor ³ Andre Valmir         ³ Data ³18/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tratamento do array com os lotes X array da separacao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SLPCPA22(cCodBar,cProduto,cLote,cLocaliza)

Local aVetDados := {}

aVetDados := Separa(UPPER(Alltrim(cCodBar)),"}",.T.)

If Empty(cCodBar) .OR. Len(Alltrim(cCodBar)) < 6   // Valmir (22/03/2018)
	
	aVetDados := {"","",""}

ElseIf LEFT(cCodBar,3) $ ('PR-/AC-') .and. cTPConfCG = "G" 

	If SB1->(DbSetOrder(1), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)),.F. ))
		aVetDados := {}
		AADD(aVetDados, SB1->B1_COD)
		AADD(aVetDados, substr(cCodBar,8,15))
		AADD(aVetDados, "")
	EndIf
		
Else 
	
	IF cTPConfCG="C" //?"CAIXA"	- Tipo de Codigo de Barras DUM14 - Controlado no sistema -> B1_CODBAR
		If SB1->(DbSetOrder(5), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)),.F. ))
			aVetDados := {}
			AADD(aVetDados, SB1->B1_COD)
			AADD(aVetDados, substr(cCodBar,8,15))
			AADD(aVetDados, "")
		EndIf

	Else	//?"GRANEL"	- Tipo de Codigo de Barras EAN13 - Controlado no sistema -> B1_X_EAN13 , foi criado indice (SB1 - Order 13)
		If SB1->(DbSetOrder(13), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)),.F. ))
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
±±³ Funcao   ³ SLPCPA26   | Autor ³ Andre Valmir        ³ Data ³17/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar Pedido de Venda Sobre o SALDO de Produto nao Entregue³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA26 // Conferencia com falta

//Variaveis - ExecAuto PEDIDO DE VENDA

//Local _cENTER   := "CHR(13)+CHR(10)"
Local ContX			:= 0
Local ContX1		:= 0
Local ContG			:= 0
Local ContG1		:= 0
Local cCodUser 		:= RetCodUsr()
Local i 			:= 0

SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + Alltrim(cOp) ))

If SC5->C5_X_STAPV == "5"     // Antigo SC5->C5_X_STAPV == "3"
	Tone()
	Alert("ESTE PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, FAVOR SELECIONAR OUTRO PARA CONFERÊNCIA")
	Tone()
	Return
Endif
                                                    
If cTPConfCG = "C" .AND. Empty(SC5->C5_X_DTFSP)
    Tone()
    Alert("ATENÇÃO, FAVOR FINALIZAR A SEPARAÇÃO PARA CONSEGUIR FINALIZAR A CONFERÊNCIA!!!")
    Tone()
	Return
Endif

If cTPConfCG = "C" .AND. SC5->C5_X_STAPV == "4" .AND. SC5->C5_X_TLPCC == "P"
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA COM FALTA DO PEDIDO, "+Alltrim(cOp)+" FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")	
	Tone()          
	Return
Endif
     
If cTPConfCG = "G" .AND. SC5->C5_X_STAPV == "4" .AND. SC5->C5_X_TLPCG == "P"
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA COM FALTA DO PEDIDO "+Alltrim(cOp)+",FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")	
	Tone()          
	Return
Endif


For i = 1 to Len(aCols)
	If oGetDad:ACOLS[i][2] = 0
		lVazio := .T.
	Else
		lVazio := .F.	
		nQtd++
	Endif
Next i  

If nQtd > 0
	lVazio := .F.
Endif 

                                                          //"01"
//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + Alltrim(cOp)+cItem ))

DBSelectarea("SC6")
DBSetOrder(1)                        
DbgoTop()
DBSeek(xFilial("SC6")+Alltrim(cOp))
	
While SC6->(!eof()) .AND. SC6->C6_NUM = Alltrim(cOp) 
		
	// Validar Caixa
	If SC6->C6_X_VCXCO > 0
		ContX++	
	Else
		ContX1++
	Endif 
	
	// Validar Granel
	If SC6->C6_X_VGRCO > 0
	  	ContG++
	Else
		ContG1++
	Endif
	
	SC6->(dbskip())

Enddo

 											// ContG != 0 Para poder gerar pedido com caixa ok, e granel 100% com falta.
If cQtdVol<=0 .and. cTPConfCG = "G" .AND. ContG != 0
	Tone()
	Aviso("ATENCAO","INFORMAR A QUANTIDADE DE VOLUMES PARA EFETIVAR A GRAVAÇÃO",{"OK"})
	Tone()
	Return
Endif	     
     

//Solicitar TROCA SENHA PARA PROCESSAR
If !lVazio
	If ContX > 0 .or. ContG >0
		U_zLogin() //cUsrLog, cPswLog)
    Else     
	    Tone()
    	Alert("NÃO É POSSIVEL EFETIVAR A CONFERÊNCIA COM FALTA DEVIDO CAIXA/GRANEL ESTAREM TODOS ZERADOS!!!")
		Tone()
		Return
    Endif
Else
	Tone()
	Alert("PEDIDO NÃO LIBERADO PARA CONFERÊNCIA, FAVOR FAZER A IMPRESSÃO DA ORDEM DE SEPARAÇÃO!!!")
	Tone()
	Return
Endif	

If lGerPed 
      
	reclock("SC5",.F.)

	If cTPConfCG = "G"	
		SC5->C5_VOLUME2 := cQtdVol	//Gravar VOLUME EM GRANEL
	Endif

		IF cTPConfCG = "C"                  
			CalcVolCX(cOp)
			If Empty(SC5->C5_X_TLPCC)
				SC5->C5_VOLUME1 := nQtdVolCX
				SC5->C5_X_TLPCC	:= "P"
				SC5->C5_X_CONCX := UsrFullName( cCodUser )
				SC5->C5_X_DTCCX := Date()
				SC5->C5_X_HRCCX := TIME()
			Endif
		Else 
			If Empty(SC5->C5_X_TLPCG)
				SC5->C5_X_TLPCG	:= "P"
				SC5->C5_X_CONGR := UsrFullName( cCodUser )
				SC5->C5_X_DTCGR := Date()
				SC5->C5_X_HRCGR := TIME()
			Endif	
		Endif

	msunlock()   
		
Else
	Return
Endif                                                  

If !Empty(SC5->C5_X_TLPCC) .and. !Empty(SC5->C5_X_TLPCG)
	reclock("SC5",.F.)
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	msunlock()	
	GeraPV()	// Valmir (06/02/2018)
Endif
    

SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cOp ))

// Gerar Pedido das Faltas Caixa
If Empty(SC5->C5_X_TLPCG) .AND. SC5->C5_X_TLPCC == "P" .AND. SC5->C5_X_TLNCX > 0 .AND. SC5->C5_X_TLNGR = 0
	reclock("SC5",.F.)
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	msunlock()
	GeraPV()	
// Gerar Pedido das Faltas Granel
Elseif Empty(SC5->C5_X_TLPCC) .AND. SC5->C5_X_TLPCG == "P" .AND. SC5->C5_X_TLNCX = 0 .AND. SC5->C5_X_TLNGR > 0
	reclock("SC5",.F.)
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	msunlock()	
	GeraPV()
Endif                   

nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )
			                 
//lValConfer := .T.
if nOpc = 1 .AND. !lGerEtiq
	SLPCPA27(cOp)
Endif

Return()



Static Function GeraPV()

//Busca o SALDO do PEDIDO
cQuerySaldo := " SELECT"
cQuerySaldo += " C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_LOJAENT, C5_CONDPAG,"
cQuerySaldo += " C6_PRODUTO, C6_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * C6_X_VCXCO)+C6_X_VGRCO) SALDO_C6, C6_PRCVEN, C6_PRUNIT, C6_TES, C6_NUM"
cQuerySaldo += " FROM "+RetSqlName("SC5")+" C5"
cQuerySaldo += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_=' '"
cQuerySaldo += " INNER JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO= B1_COD AND B1.D_E_L_E_T_=' ' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuerySaldo += " WHERE C5.D_E_L_E_T_=' '"
cQuerySaldo += " AND C6_FILIAL = '"+xFilial("SC6")+"' "
cQuerySaldo += " AND C5_NUM = '"+cOp+"'"
cQuerySaldo += " AND C6_BLQ = ' '"
cQuerySaldo += " AND C6_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * C6_X_VCXCO)+C6_X_VGRCO) > 0 "
//cQuerySaldo += " AND (C6_X_VCXIM+C6_X_VGRIM) <> (C6_X_VCXCO+C6_X_VGRCO) " // ADICIONADO GENILSON LUCAS
cQuerySaldo += " ORDER BY C6_PRODUTO"

If Select("TRB1") > 0
	TRB1->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuerySaldo),"TRB1", .F., .T.)
TCSETFIELD("TRB1","SALDO_C6"	,"N",16,2)  //Quantidade
TCSETFIELD("TRB1","C6_PRCVEN"	,"N",16,4)  //Valor Unitario


dbSelectArea("TRB1")
While !EOF() .AND.  TRB1->C5_NUM = cOp
	
	//Prepara o Cabecalho do Pedido de Venda  (SC5)
	If 	lgravaCAB
		cDoc	:= GetSxeNum("SC5","C5_NUM")
		RollBAckSx8()
		
		aadd(aCabec,{"C5_NUM"		,cDoc		,Nil})
		aadd(aCabec,{"C5_TIPO"		,"N"		,Nil})
		aadd(aCabec,{"C5_CLIENTE"	,TRB1->C5_CLIENTE,Nil})
		aadd(aCabec,{"C5_LOJACLI"	,TRB1->C5_LOJACLI,Nil})
		aadd(aCabec,{"C5_LOJAENT"	,TRB1->C5_LOJAENT,Nil})
		aadd(aCabec,{"C5_CONDPAG"	,TRB1->C5_CONDPAG,Nil})
		aadd(aCabec,{"C5_MENNOTA"	,"SALDO PEDIDO VENDA "+LEFT(cOp,6)	,Nil})
		aadd(aCabec,{"C5_PESOL"		,1 			,Nil})
		lgravaCAB := .F.
	Endif
	
	
	//Prepara o ITEM do Pedido de Venda  (SC6)
	Dbselectarea("SB1")
	DbSetOrder(1)
	Dbseek(xFilial("SB1")+TRB1->C6_PRODUTO)
	IF SB1->B1_X_MSBLQ <> '1'
		nSeqIPV ++					 //Sequencial do Item
		
		aLinha := {}
		aadd(aLinha,{"C6_ITEM"		,StrZero(nSeqIPV,2)			,Nil})
		aadd(aLinha,{"C6_PRODUTO"	,TRB1->C6_PRODUTO			,Nil})
		aadd(aLinha,{"C6_QTDVEN"	,TRB1->SALDO_C6				,Nil})
		aadd(aLinha,{"C6_PRCVEN"	,Round(TRB1->C6_PRCVEN,4)	,Nil})
		aadd(aLinha,{"C6_PRUNIT"	,Round(TRB1->C6_PRUNIT,4)	,Nil})
		aadd(aLinha,{"C6_TES"		,TRB1->C6_TES				,Nil})
		aadd(aLinha,{"C6_NUM"		,cDoc						,Nil})
		aadd(aItens,aLinha)
			
	Endif
	
	dbSelectArea("TRB1")
	dbSkip()
	
Enddo    

//****************************************************************
//* Inclusao - PEDIDO DE VENDA (EXECAUTO)
//****************************************************************
if !lgravaCAB
		
	// Atualiza pedido de vendas Original
	SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + Padr(cOp,6)))

	While SC6->(!eof()) .and. SC6->C6_NUM=Padr(cOp,6)
		
		//If SC6->(C6_X_VCXIM+C6_X_VGRIM) <> SC6->(C6_X_VCXCO+C6_X_VGRCO)
			cProduto := SC6->C6_PRODUTO
			
			cTxtUpdate += " UPDATE "+RetSqlName("SC6")+" SET C6_OP=' ', C6_QTDEMP=0, C6_QTDEMP2=0,"
	
			cTxtUpdate += " C6_OK  = CASE WHEN (C6_X_VCXIM+C6_X_VGRIM)>0 AND (C6_X_VCXCO+C6_X_VGRCO)<= 0 THEN '1O'"
			cTxtUpdate += "              WHEN (C6_X_VCXIM+C6_X_VGRIM)=(C6_X_VCXCO+C6_X_VGRCO) THEN ' ' ELSE '1O' END,"
	
			cTxtUpdate += " C6_BLQ = CASE WHEN (C6_X_VCXIM+C6_X_VGRIM)>0 AND (C6_X_VCXCO+C6_X_VGRCO)<= 0 THEN 'R'"
			cTxtUpdate += "               WHEN (C6_X_VCXIM+C6_X_VGRIM)=(C6_X_VCXCO+C6_X_VGRCO) THEN ' ' ELSE 'R' END,"
				
			cTxtUpdate += " C6_QTDLIB = C6_X_VGRCO+(C6_X_VCXCO*B1_QE), C6_QTDLIB2 = C6_X_VGRCO+(C6_X_VCXCO*B1_QE)  "
	
			cTxtUpdate += " FROM "+RetSqlName("SC6")+ " C6 LEFT JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO = B1_COD AND B1.D_E_L_E_T_ = ''
			cTxtUpdate += " WHERE "
			cTxtUpdate += " C6_NUM='"+cOp+"' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_PRODUTO='"+cProduto+"'" 
		//EndIf
				
		SC6->(dbskip())
		
	Enddo
		
	TcSqlExec(cTxtUpdate)
		
	/*** Valmir***/
		                                                         // "01"
	//SC9->(DbSetOrder(1),DbSeek(xFilial("SC9") + Padr(cOp,6) + "01" ))		
	DBSelectArea("SC9")
	DBSetOrder(1) 
	DBGotop()
	DBSeek(xFilial("SC9")+Alltrim(cOp))
		
	While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cOp) 
		
		SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp+SC9->(C9_ITEM+C9_PRODUTO)))
			
		If SC6->C6_QTDLIB > 0
			RecLock("SC6",.F.)
				SC6->C6_QTDEMP 	:= SC6->C6_QTDLIB
				SC6->C6_QTDEMP2	:= SC6->C6_QTDLIB2
			SC6->( MsUnLock() )
		Endif 
			
			
		If SC6->C6_QTDLIB = 0			
			RecLock("SC9",.F.)
				SC9->(dbDelete())
			SC9->( MsUnLock() )
		Else
			RecLock("SC9",.F.)
				SC9->C9_QTDLIB 	:= SC6->C6_QTDLIB
				SC9->C9_QTDLIB2 := SC6->C6_QTDLIB
				SC9->C9_BLEST	:= ""
				//SC9->C9_BLCRED 	:= ""
			SC9->( MsUnLock() )
		Endif
		   
		SC9->(dbskip())
		
	Enddo	                             
		
	SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cOp ))	
	Reclock("SC5",.F.)  	
	If Empty(SC5->C5_NOTA) //SE NÃO FOR ANTECIPADO
		SC5->C5_X_STAPV := "5"
	Else
		SC5->C5_X_STAPV := "6"
	EndIf
	msunlock()
	
					
	//GERA PEDIDO DE VENDA COM SALDO - NECESSÁRIO 1 PRODUTO
	If Len(aItens) > 0
		MATA410(aCabec,aItens,3)	//FUNCAO PADRAO TOTVS PARA CRIACAO PEDIDO DE VENDA
		
		If !lMsErroAuto
			MsgInfo("PEDIDO COM SALDO "+Alltrim(cDoc)+" GERADO COM SUCESSO!","ATENCAO!")
		Else
			lMostraErro	:= .T.
			Mostraerro()
			
			cPara	 := cEmail
			cAssunto := 'PEDIDO COM FALTA NÃO GERADO'
			cBody	 := 'Pedido '+ xFilial("SC5") + ' - ' + Alltrim(cOp) + ' não gerou saldo, favor verificar!'
			U_SendMail( cPara, '', '', cAssunto, cBody,'' )
		EndIf
	EndIf
	
	//Funcao para Gravar e gerar Etiqueta
		
	SLPCPA27(cOp)
	lGerEtiq := .T.
	
Endif
   
Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA27   | Autor ³ Andre Valmir        ³ Data ³18/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza Impressão da Etiqueta                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA27(cOp)

Private cTipoimp	:= cTPConfCG //"C","G")	//Tipo de Conferencia Caixa/Granel     //"CX"	// Tipo de Impressao (Caixa / Granel )

Processa({|X| lEnd := X, ImpEtiq()})
		
RETURN(.T.)


//*****************************************************************************
Static Function ImpEtiq()
//*****************************************************************************

Private nDes	:= 0  // Deslocamento
//Private cQuery	:= ""            
Private cContem		:= ""
Private	cCXGR		:= ""

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
oFont16 := oSend(TFont(),"New","Arial" ,0,24,,.T.,,,,,,,,,,,oPrn )
oFont17 := oSend(TFont(),"New","Arial" ,0,40,,.T.,,,,,,,,,,,oPrn )
oFont18 := oSend(TFont(),"New","Arial" ,0,60,,.T.,,,,,,,,,,,oPrn )

aFontes := {oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8,;
oFont9, oFont10, oFont11, oFont12, oFont13, oFont14, oFont15, oFont16, oFont17, oFont18  }

oBrush	:= TBrush():New(,4)

oPrn:SetPortrait()  // SetLandscape()

	
DBSelectArea("SC5")
DBSetOrder(1)
DBSeek(xFilial("SC5")+Alltrim(cOp))

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
Local nCx := 0
Local nGr := 0

	nQtdEtiCX := SC5->C5_VOLUME1	
	nQtdEtiGR := SC5->C5_VOLUME2
	
	
	If cTipoimp == "C"	//CAIXA
		For nCx:=1 to nQtdEtiCX	
			ImpDet(nCx)          
		Next                   
	Endif               
	
//	cTipoimp := "GR"	

	If cTipoimp == "G"	//GRANEL
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
                      
		
AVPAGE

cTexto := SM0->M0_FILIAL
oPrn:Say(nLin(0.3), nCol(0.4),cTexto,oFont16)

If cTipoimp == "C"
	cTexto	:= cOp+";"+cTipoimp+";"+ alltrim(Transform(nCx,"@E 9999"))	
	MSBAR("EAN128", 0.3, 5.20, cTexto, oPrn, .F.,,.T., 0.025,0.80 ,.F.,,, .F. )
Else
	cTexto	:= cOp+";"+cTipoimp+";"+ alltrim(Transform(nGr,"@E 9999"))	
	MSBAR("EAN128", 0.3, 5.20, cTexto, oPrn, .F.,,.T., 0.025,0.80 ,.F.,,, .F. )
EndIf

cTexto := "PV: " + cOp
oPrn:Say(nLin(1.3), nCol(0.4),cTexto,oFont15)

If cTipoimp == "C"
	
	If nQtdEtiCX > 9999	// Valmir (23/11/2018)
		cTexto := "CX: " +Padl(nCx,5,"0")+"/"+Padl(nQtdEtiCX,5,"0")      
		oPrn:Say(nLin(1.3), nCol(3.3),cTexto,oFont15)
	Else
		cTexto := "CX: " +Padl(nCx,4,"0")+"/"+Padl(nQtdEtiCX,4,"0")      
		oPrn:Say(nLin(1.3), nCol(3.3),cTexto,oFont15)
	Endif
		
Else
    If nQtdEtiGR > 9999	// Valmir (23/11/2018) 
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



//cTexto := "TRANSP.: " + cNomTransp
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

//cTexto := "CLIENTE: " + Substr(cNomCli,1,25)
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


RestArea(_aArea)
                            
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//User Function	ImpEtqP()

//Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA30   | Autor ³ Andre Valmir        ³ Data ³21/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpa Conferencia							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SLPCPA30()

Local nY := 0

//Local lRet := .T.
//Preparar para gravar no SC6 *** - Gravar em Tempo REAL

DBSelectArea("SC5")
DBSetOrder(1)
DBSeek(xFilial("SC5")+Alltrim(cOp))	

If SC5->C5_X_STAPV <> "4" 

	Tone()
	MsgAlert("PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, NÃO SENDO POSSÍVEL LIMPAR A CONFERÊNCIA","ATENÇÃO")
	Tone()
	Return()

ElseIf (cTPConfCG="C" .and.!Empty(SC5->C5_X_TLPCC)) .or. ;
	   (cTPConfCG="G" .and.!Empty(SC5->C5_X_TLPCG) )
	
	Tone()
	MsgAlert("PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, NÃO SENDO POSSÍVEL LIMPAR A CONFERÊNCIA","ATENÇÃO")
	Tone()
	Return()

Endif

If cTPConfCG="C"	
	
	reclock("SC5",.F.)
		SC5->C5_VOLUME1	:= 0
		SC5->C5_X_TLPCC	:= ""
		
		// Valmir(16/03/2018)
		SC5->C5_X_CONCX := ""
		SC5->C5_X_DTCCX	:= CTOD(" / / ") 
		SC5->C5_X_HRCCX	:= "" 

	msunlock()
Else	        
	reclock("SC5",.F.)
		SC5->C5_VOLUME2	:= 0
		SC5->C5_X_TLPCG	:= ""            
		
		// Valmir(16/03/2018)
		SC5->C5_X_CONGR := ""
		SC5->C5_X_DTCGR := CTOD(" / / ")
		SC5->C5_X_HRCGR := ""
		
	msunlock()  
Endif	      
                

DBSelectarea("SC6")
DBSetOrder(1)                        // "01"
DbgoTop()
DBSeek(xFilial("SC6")+Alltrim(cOp))

IF cTPConfCG="C"	//SEPARACAO =>  C=CAIXA
	
	For nY := 1 To Len(aCols)
		While SC6->(!eof()) .and. Alltrim(SC6->C6_NUM) == Alltrim(cOp)
			reclock("SC6",.F.)
			SC6->C6_X_VCXCO := 0
			msunlock()
			SC6->(dbskip())
		Enddo
	Next nY
	
ELSE				//SEPARACAO =>  G=GRANEL
	For nY := 1 To Len(aCols)
		While SC6->(!eof()) .and. Alltrim(SC6->C6_NUM) == Alltrim(cOp)
			reclock("SC6",.F.)
			SC6->C6_X_VGRCO := 0
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
	
End If

Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ SLPCPA25  | Autor ³ Andre Valmir         ³ Data ³21/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a validacao e baixa virtual no Grid                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA25(cCodBar,cProduto,cLote,oCodBar,cLocaliza)

Local _nLinPrd 		:= 0
Local _nLinGrid 	:= 0
Local nSeq			:= 0
Local nRow			:= 0
Local nSaldoLt		:= 0
Local nQtdAcols2	:= 0
Local nCopias		:= 2
Local nPeso 		:= 0
Local lOk		:= .F.

Private oTelGR
Private nQtdPrd := 0
Private oFont 	:= TFont():New('Courier new',,-15,.T.,.T.)

_nLinGrid:= aScan(oGetDad:aCols,{|_vPdo| _vPdo[1]==cProduto })

If _nLinGrid==0 .And. !Empty(cProduto)                   
	Tone()
	alert("Produto não encontrado no Pedido de Venda.","Verifique!")
	Tone()
	
	oGetDad:oBrowse:Refresh() 		// Atualiza Grid
	oGetDad:GoTo(1)
	oCodBar:SetFocus()				// Posiciona no Campo
	
	Return()
End If


If Empty(cProduto)
	Return()
End If

If LEFT(cProduto,3) $ ('PR-/AC-')
	DEFINE MSDIALOG oTelGR FROM 000,000 TO 130,300 TITLE Alltrim(OemToAnsi("QUANTIDADE DE VOLUMES - GRANEL")) Pixel
	
	oSayLn2 := tSay():New(41,05,{||"INFORMAR QTD: "},oTelGR,,oFont,,,,.T.,CLR_BLACK,CLR_RED,60,20)
	oGet := tGet():New(38,80,{|u| if(Pcount()>0,nQtdPrd:=u,nQtdPrd) },oTelGR,40,12,"@E 999999",{|| IIF(nQtdPrd > 0,.T.,.F.) },,,oFont,,,.T.,,,,,,,,,,"nQtdPrd",,,,,.F.,,)
	
	ACTIVATE MSDIALOG oTelGR CENTERED ON INIT EnchoiceBar(oTelGR,{||lOk:= .T.,oTelGR:End()},{||oTelGR:End()},,)
	
	If lOk
		cQtdVolDig	:= nQtdPrd
	Else
		Return()
	EndIf
EndIf

//oGetDad:oBrowse:Refresh() 		// Atualiza Grid

IF oGetDad:aCols[oGetDad:nAt][2] <= oGetDad:aCols[oGetDad:nAt][3]
	     
	Tone()	
	MsgAlert("QUANTIDADE ULTRAPASSOU CONTAGEM.","ATENÇÃO!")
	Tone()	
Else 
	AtuAcols(cProduto)				// Soma a quantidade do Grid
Endif

oGetDad:oBrowse:SetBlkBackColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][2] <> oGetDad:aCols[oGetDad:nAt][3], " + Str(CLR_WHITE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] ," + Str(CLR_LIGHTGRAY) + "," + Str(CLR_WHITE) + "))}"))
oGetDad:oBrowse:SetBlkColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][3]=0, " + Str(CLR_HBLUE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] .or. oGetDad:aCols[oGetDad:nAt][3] > 0," + Str(CLR_GREEN) + "," + Str(CLR_WHITE) + "))}"))

oGetDad:oBrowse:Refresh() 		// Atualiza Grid
oGetDad:GoTo(1)
oCodBar:SetFocus()

Return



//*************************** Atualiza o ACOLS ***************************
//Leitura do Codigo de Barras Validado na Conferencia (CAIXA / GRANEL)
//************************************************************************
Static Function AtuAcols(cProduto)

Local nX := 0
                                                  
cItem := Posicione("SC6",2,xFilial("SC6")+cProduto+Alltrim(cOp),"C6_ITEM")

SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp + cItem + cProduto)) 

If cTPConfCG="C" .AND. cQtdVolDig>0 .AND. SC6->C6_X_VCXCO > 0
	Alert("ATENÇÃO, QUANTIDADE DIGITADA INVALIDA, FAVOR REVER QUANTIDADE!!!")
	Return     	
Endif


//Contador de leitura - Criado para atender a Demanda do Lancamento da Quantidade do Pallet
IF cQtdVolDig > 0			//Se FOR INFORMADO A QUANTIDADE DE VOLUME
	cContQtd := cQtdVolDig	//Calculo com informacao de VOLUME INFORMADO
else
	cContQtd := 1			//Calculo da Leitura Codigo de Barras
Endif


//Preparar para gravar no SC6 *** - Gravar em Tempo REAL
DBSelectarea("SC6")
DBSetOrder(1)
DBSeek(xFilial("SC6")+Alltrim(cOp) + cItem) 

IF cTPConfCG="C"	//SEPARACAO =>  C=CAIXA
	
	//busca faturamento para processar
	If SC6->C6_X_VCXCO < SC6->C6_X_VCXIM .and. alltrim(cProduto) == Alltrim(SC6->C6_PRODUTO)
				
		If (SC6->C6_X_VCXCO + cQtdVolDig) > SC6->C6_X_VCXIM
			Tone()
			Alert("ATENÇÃO QUANTIDADE DE CAIXAS DIGITADAS NO PALLET É MAIOR QUE A QUANTIDADE SOLICITADA!!!")
			Tone()
			Return()
		Endif
				
				
		Reclock("SC6",.F.)
			SC6->C6_X_VCXCO += cContQtd
		msunlock()
						
	Endif


ELSE		//SEPARACAO =>  G=GRANEL
                                              
	//busca faturamento para processar
	If SC6->C6_X_VGRCO < SC6->C6_X_VGRIM .and. alltrim(cProduto) == Alltrim(SC6->C6_PRODUTO)
		
		If (SC6->C6_X_VGRCO + cContQtd) > SC6->C6_X_VGRIM
			Tone()
			Alert("ATENÇÃO QUANTIDADE DE VOLUME DIGITADA É MAIOR QUE A QUANTIDADE SOLICITADA!!!")
			Tone()
			Return()
		Endif
			
		reclock("SC6",.F.)
			SC6->C6_X_VGRCO += cContQtd
		msunlock()

	Endif
			

ENDIF

//ATUALIZA GRID COM NOVA QUANTIDADE
For nX := 1 To Len(aCols)
	If alltrim(cProduto) =	alltrim(oGetDad:aCols[nx][1])
		oGetDad:aCols[nx][3] 	+= cContQtd
	Endif
Next nX

//Zera variavel
cQtdVolDig := 0

Return()



//Tela de Validacao para Usuario informara "CONTRA-SENHA" para liberar processo interno
User Function zLogin(cUsrLog, cPswLog)

Local oGrpLog
Local oBtnConf
Private lRetorno := .F.
Private oDlgPvt
Private oSayUsr
Private oGetUsr, cGetUsr := Space(25)
Private oSayPsw
Private oGetPsw, cGetPsw := Space(20)
Private oGetErr, cGetErr := ""
//DimensÃµes da janela
Private nJanLarg := 200
Private nJanAltu := 200

//Criando a janela
DEFINE MSDIALOG oDlgPvt TITLE "Login" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
//Grupo de Login
@ 003, 001     GROUP oGrpLog TO (nJanAltu/2)-1, (nJanLarg/2)-3         PROMPT "Login: "     OF oDlgPvt COLOR 0, 16777215 PIXEL
//Label e Get de Usuario
@ 013, 006   SAY   oSayUsr PROMPT "Cod.Usuário:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
@ 020, 006   MSGET oGetUsr VAR    cGetUsr           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL

//Label e Get da Senha
@ 033, 006   SAY   oSayPsw PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
@ 040, 006   MSGET oGetPsw VAR    cGetPsw           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL PASSWORD

//Get de Log, pois se for Say, nao da para definir a cor
@ 060, 006   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
oGetErr:lActive := .F.
oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")

//Botoes
@ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar"             SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ACTION (fVldUsr()) PIXEL
oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
ACTIVATE MSDIALOG oDlgPvt CENTERED

//Se a rotina foi confirmada e deu certo, atualiza o usuario e a senha
If lRetorno
	//alert("Usuario Validado")
	lGerPed := .T.
EndIf

//    RestArea(aArea)
Return lRetorno

/*---------------------------------------------------------------------*
| Func:  fVldUsr                                                      |
| Autor: Daniel Atilio                                                |
| Data:  17/09/2015                                                   |
| Desc:  FunÃ§Ã£o para validar se o usuÃ¡rio existe                      |
*---------------------------------------------------------------------*/

Static Function fVldUsr()

Local cUsrAux	:= Alltrim(cGetUsr)
Local cPswAux	:= Alltrim(cGetPsw)
Local cCodAux	:= ""
Local cUsrDig 

If Empty(cUsrAux)
	Return
Endif 
	
                          
PswOrder(2)                 	
If PswSeek( Alltrim(cGetUsr), .T. ) 
	cUsrDig := PswRet()[1][1]
Endif


DBSelectArea("CB1")
DBSetOrder(2)
DBSeek(xFilial("CB1")+cUsrDig)

If Found() .AND. CB1->CB1_X_ATCF == "1" 

	//Pega o codigo do usuario
	PswOrder(2)
	
	If  PswSeek(cUsrAux,.T.)	
	
		//Agora verifica se a senha bate com o usuario
		If !PswName(cPswAux)
			cGetErr := "SENHA INVÁLIDA!"
			oGetErr:Refresh()
		  	Return
		  	
			
			//Senao, atualiza o retorno como verdadeiro
		Else
			lRetorno := .T.
		endif
		
		//Senao atualiza o erro e retorna para a rotina
	Else
		cGetErr := "USUÁRIO NÃO ENCONTRADO!!!"
		oGetErr:Refresh()
		Return
	EndIf
	
	//Se o retorno for valido, fecha a janela
	If lRetorno
		oDlgPvt:End()
	EndIf    

Else
	Alert("USUÁRIO NÃO AUTORIZADO A FAZER CONFERÊNCIA COM FALTA!!!")
	Return

Endif

Return


// Validar Liberacao do Pallet
User Function LoginPlt(cUsrLogPlt, cPswLogPlt)

Local oGrpLogPlt
Local oBtnConfPlt
Private oDlgPvtPlt
Private oSayUsrPlt
Private oGetUsrPlt, cGetUsrPlt := Space(25)
Private oSayPswPlt
Private oGetPswPlt, cGetPswPlt := Space(20)
Private oGetErrPlt, cGetErrPlt := ""
//Dimensoes da janela
Private nJanLargPl := 200
Private nJanAltuPl := 200

//Criando a janela
DEFINE MSDIALOG oDlgPvtPlt TITLE "Login" FROM 000, 000  TO nJanAltuPl, nJanLargPl COLORS 0, 16777215 PIXEL
//Grupo de Login
@ 003, 001     GROUP oGrpLogPlt TO (nJanAltuPl/2)-1, (nJanLargPl/2)-3         PROMPT "Login: "     OF oDlgPvtPlt COLOR 0, 16777215 PIXEL
//Label e Get de Usuario
@ 013, 006   SAY   oSayUsrPlt PROMPT "Cod.Usuário:"        SIZE 030, 007 OF oDlgPvtPlt                    PIXEL
@ 020, 006   MSGET oGetUsrPlt VAR    cGetUsrPlt           SIZE (nJanLargPl/2)-12, 007 OF oDlgPvtPlt COLORS 0, 16777215 PIXEL

//Label e Get da Senha
@ 033, 006   SAY   oSayPswPlt PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvtPlt                    PIXEL
@ 040, 006   MSGET oGetPswPlt VAR    cGetPswPlt           SIZE (nJanLargPl/2)-12, 007 OF oDlgPvtPlt COLORS 0, 16777215 PIXEL PASSWORD

//Get de Log, pois se for Say, nao da para definir a cor
@ 060, 006   MSGET oGetErrPlt VAR    cGetErrPlt        SIZE (nJanLargPl/2)-12, 007 OF oDlgPvtPlt COLORS 0, 16777215 NO BORDER PIXEL
oGetErrPlt:lActive := .F.
oGetErrPlt:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")

//Botoes
@ (nJanAltuPl/2)-18, 006 BUTTON oBtnConfPlt PROMPT "Confirmar"             SIZE (nJanLargPl/2)-12, 015 OF oDlgPvtPlt ACTION (fVldUsrPlt()) PIXEL
oBtnConfPlt:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
ACTIVATE MSDIALOG oDlgPvtPlt CENTERED

Return(lRetornoPlt)


/*---------------------------------------------------------------------*
| Func:  fVldUsrPlt                                                      |
| Autor: Daniel Atilio                                                |
| Data:  17/09/2015                                                   |
| Desc:  FunÃ§Ã£o para validar se o usuÃ¡rio existe                      |
*---------------------------------------------------------------------*/

Static Function fVldUsrPlt()

Local cUsrAuxPlt	:= Alltrim(cGetUsrPlt)
Local cPswAuxPlt	:= Alltrim(cGetPswPlt)
Local cCodAuxPlt	:= ""
Local cUsrDigPlt	:= ""

If Empty(cUsrAuxPlt)
	Return
Endif	
                          
PswOrder(2)                 	
If PswSeek( Alltrim(cGetUsrPlt), .T. ) 
	cUsrDigPlt := PswRet()[1][1]
Endif


DBSelectArea("CB1")
DBSetOrder(2)
DBSeek(xFilial("CB1")+cUsrDigPlt)

If Found() .AND. CB1->CB1_X_LBPL == "1" 

	//Pega o codigo do usuario
	PswOrder(2)
	
	If  PswSeek(cUsrAuxPlt,.T.)	
	
		//Agora verifica se a senha bate com o usuario
		If !PswName(cPswAuxPlt)
			cGetErrPlt := "SENHA INVÁLIDA!"
			oGetErrPlt:Refresh()
		  	Return
		  	
			
			//Senao, atualiza o retorno como verdadeiro
		Else
			lRetornoPlt := .T.
		endif
		
		//Senao atualiza o erro e retorna para a rotina
	Else
		cGetErrPlt := "USUÁRIO NÃO ENCONTRADO!!!"
		oGetErrPlt:Refresh()
		Return
	EndIf
	
	//Se o retorno for valido, fecha a janela
	If lRetornoPlt
		oDlgPvtPlt:End()
	EndIf    

Else
	Alert("USUÁRIO NÃO AUTORIZADO A FAZER CONFERÊNCIA DE PALLET!!!")
	Return

Endif

Return

// Função para somar a quantidade de volumes
//*******************************************************************************************************
Static Function CalcVolCX(cOp)

Private cQryVol		:= GetNextAlias()         
Private	cQueryVol	:= ""

cQueryVol	:= "  SELECT SUM(C6_X_VCXCO) C6_X_VCXCO "
cQueryVol	+= "  FROM "+RetSqlName("SC6")+" C6 "
cQueryVol	+= "  WHERE C6.D_E_L_E_T_ = '' "
cQueryVol	+= "  AND C6_NUM = '"+cOp+"' "
cQueryVol	+= "  AND C6_FILIAL = '"+xFilial("SC6")+"' "

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryVol),cQryVol,.F.,.T.)

nQtdVolCX := (cQryVol)->C6_X_VCXCO
       
(cQryVol)->(DbCloseArea())

Return(nQtdVolCX)

//*******************************************************************************************************


// Validar as Quantidades

Static Function ValidarQtd()

Local ContCX		:= 0	// Contador Linha Caixa
Local ContCX1		:= 0	// Contador Linha Caixa1
Local ContGR		:= 0 	// Contador Linha Granel
Local ContGR1		:= 0 	// Contador Linha Granel
Local lValidGrid	:= .F.	// Validar se o grid esta preenchido
Local nCont			:= 0    
Local i				:= 0

	        	
If cTPConfCG="G"	
	
	For i = 1 to Len(aCols)
		If oGetDad:ACOLS[i][2] = 0
			lValidGrid := .T.
		Else
			lValidGrid := .F.	
			nCont++
		Endif
	Next i  	
		
	If !lValidGrid
	                                                      // "01"
		//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp + cItem ))
   		DBSelectarea("SC6")
		DBSetOrder(1)                        
		DbgoTop()
		DBSeek(xFilial("SC6")+Alltrim(cOp)) 
		
		While SC6->(!eof()) .AND. SC6->C6_NUM = Alltrim(cOp) 
			
			// Validar Granel
			If  SC6->C6_X_VGRIM == SC6->C6_X_VGRCO
			  	ContGR++
			Else
				ContGR1++
			Endif
			
			SC6->(dbskip())
		
		Enddo
		
		
		If ContGR1 > 0 
			
			lValConfer := .F.
			Tone()
			Alert("NÃO É POSSIVEL FINALIZAR A CONFERÊNCIA, AINDA EXISTEM SALDOS PARA CONFERÊNCIA!!!")
			Tone()
			Return
			
		Else
			//Imprimir ETIQUETA
				
			//nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )
			                 
			lValConfer := .T.
			//if nOpc = 1
			//	SLPCPA27(cOp)
			//Endif	         
	
		Endif		
	    
	Else    
		Tone()
		Alert("PEDIDO NÃO LIBERADO PARA CONFERÊNCIA, FAVOR FAZER A IMPRESSÃO DA ORDEM DE SEPARAÇÃO!!!")
		Tone()
		Return
	Endif
	
Else	//CONFERENCIA - CAIXA

	
	If nCont > 0
		lValidGrid := .F.
	Endif 
	
	If !lValidGrid                                        // "01"
		
		//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp + cItem ))
		DBSelectarea("SC6")
		DBSetOrder(1)                        
		DbgoTop()
		DBSeek(xFilial("SC6")+Alltrim(cOp))
		
		While SC6->(!eof()) .AND. SC6->C6_NUM = Alltrim(cOp) 
			
			// Validar Caixa
			If SC6->C6_X_VCXIM == SC6->C6_X_VCXCO
				ContCX++	
			Else
				ContCX1++
			Endif 
						
			SC6->(dbskip())
		
		Enddo
		      
		If ContCX1 > 0
			      
			lValConfer := .F.
			Tone()	
			Alert("NÃO É POSSIVEL FINALIZAR A CONFERÊNCIA, AINDA EXISTEM SALDOS PARA CONFERÊNCIA CAIXA/GRANEL!!!")
			Tone()
			Return
			
		Else
			//Imprimir ETIQUETA
							
			                                                          // "01"
			SC9->(DbSetOrder(1),DbSeek(xFilial("SC9") + Padr(cOp,6) + "01" ))
			
			While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cOp)

				RecLock("SC9",.F.)			
					SC9->C9_BLEST	:= ""
				SC9->( MsUnLock() )

 			SC9->(dbskip())
			
			Enddo
			
			
			// Valmir (07/03/2018) Adicionar regra caso nao exista Granel para conferir o sistema atualizar o STATUS				
			If SC5->C5_X_TLNGR = 0
			
				Reclock("SC5",.F.)
					If Empty(SC5->C5_NOTA)
						SC5->C5_X_STAPV := "5"
					Else
						SC5->C5_X_STAPV := "6"
					EndIf
				msunlock()
			
			Endif
							
//			nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )
			
			lValConfer := .T.
			
//			if nOpc = 1
//				SLPCPA27(cOp)                               
//			Endif	         
	
		Endif
		
	Else
		Alert("PEDIDO NÃO LIBERADO PARA CONFERÊNCIA, FAVOR FAZER A IMPRESSÃO DA ORDEM DE SEPARAÇÃO!!!")
		Return
	Endif
	                                                        
Endif                                                       
         
/*                                                          // "01"
SC9->(DbSetOrder(1),DbSeek(xFilial("SC9") + Padr(cOp,6) + "01" ))
			
	While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cOp)

		RecLock("SC9",.F.)			
			SC9->C9_BLEST	:= ""
		SC9->( MsUnLock() )

 		SC9->(dbskip())
			
	Enddo   
*/

//!!!Andre Salgado (22/03/18) - Melhoria para garantir que vai liberar 100% o SC9
cTxtSC9f := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
cTxtSC9f += " WHERE "
cTxtSC9f += " C9_PEDIDO='"+Alltrim(cOp)+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
TcSqlExec(cTxtSC9f)

	 
Return
