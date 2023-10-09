#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ESTP0005	 ³ Autor ³ Genilson M Lucas	  ³ Data ³ 30/07/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela para inclusão de multi usuário    					  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/


User Function ESTP0005()

Local cCol1	:= 40		//Coluna da Tela Parametros
Local cCol2	:= 150

Private oTela	:= NIL
Private cPedido	 := space(06)	//Pedido de Venda De
Private cNomEmp	 := ''
Private cEmpresa := SPACE(04)
Private cOper1	 := space(06)
Private cOper2	 := space(06)
Private cOper3	 := space(06)
Private cOper4	 := space(06)
Private cOper5	 := space(06)
Private cNomOper1	 := 'TESTE'//space(15)
Private cNomOper2	 := space(15)
Private cNomOper3	 := space(15)
Private cNomOper4	 := space(15)
Private cNomOper5	 := space(15)
Private oNomOper1
Private nQtdOpe	 := 2


Set Device To Screen
//Tela de Parametros
@ 247,182	To 530,815 Dialog oTela Title OemToAnsi("ACD - Divisão de Pedidos por Operadores")

@ 005,010	Say OemToAnsi("Rotina com objetivo de realizar a divisão do pedidos por operadores.")

@ 1.5 , 001 To 5.7, 017 Label OemToAnsi('Informações')
@ 035,015	Say OemToAnsi("Filial:")
@ 035,cCol1	Get cEmpresa	size 30,50 F3 'SM0'// VALID ExistCpo("SM0")
@ 035,cCol1+35	Say cNomEmp

@ 050,015	Say OemToAnsi("Pedido:")
@ 050,cCol1	Get cPedido	size 50,30 Picture "@!" F3 'SC5' VALID !Empty(cPedido)
@ 065,015	Say OemToAnsi("Quant.:")
@ 065,cCol1	Get nQtdOpe	Picture "@E 99" size 50,30 valid nQtdOpe >= 2


@ 1.5, 17.5 To 9, 038 Label OemToAnsi('Operadores')
@ 035,cCol2		Say OemToAnsi("Operador 1:")
@ 035,cCol2+045 Get cOper1 size 40,50 Picture "@!"  F3 "CB1" VALID ExistCpo("CB1").and. NomeOper('1')
@ 035,cCol2+100	MSGET oNomOper1 VAR cNomOper1

@ 050,cCol2		Say OemToAnsi("Operador 2:")
@ 050,cCol2+045 Get cOper2 size 40,50 Picture "@!"  F3 "CB1" VALID ExistCpo("CB1")
@ 050,cCol2+100	Say cNomOper2

@ 065,cCol2		Say OemToAnsi("Operador 3:")
@ 065,cCol2+045 Get cOper3 size 40,50 Picture "@!"  F3 "CB1" VALID ExistCpo("CB1") WHEN If(nQtdOpe>2,.T.,.F.)
@ 065,cCol2+100	Say cNomOper3

@ 080,cCol2		Say OemToAnsi("Operador 4:")
@ 080,cCol2+045 Get cOper4 size 40,50 Picture "@!"  F3 "CB1" VALID ExistCpo("CB1") WHEN If(nQtdOpe>3,.T.,.F.)
@ 080,cCol2+100	Say cNomOper4

@ 095,cCol2		Say OemToAnsi("Operador 5:")
@ 095,cCol2+045 Get cOper5 size 40,50 Picture "@!"  F3 "CB1" VALID ExistCpo("CB1") WHEN If(nQtdOpe>4,.T.,.F.)
@ 095,cCol2+100	Say cNomOper5

//Botoes
@ 006, 001 To 9, 017 Label OemToAnsi('Confirma processamento')
//@ 100,030 BmpButton Type 1 Action (RptStatus({|| If(Valida(),RptDetail(),.F. ) }),Close(oTela))
@ 100,030 BmpButton Type 1 Action( Close(oTela), Processa( {|| cMsg := ProcSC6()}, "Gerando registros..." ) )

@ 100,080 BmpButton Type 2 Action Close(oTela)

Activate Dialog oTela Centered
Set Device To Print

Return()


//Processa Pesquisa do Banco de dados
Static Function ProcSC6()

Local cQuery	:= ''
Local n			:= 1 // quantide de itens separador pelo operador
Local nOper		:= 1
Local nSKU		:= 0 // numero de SKU por operador 
Local cControle	:= ''

//VALIDA SE FOI INFORMADO TODOS OS OPERADORES
If Empty(cOper1) .or. Empty(cOper2)
	MsgAlert("Não foi informado os operadores!","OPERAÇÃO CANCELADA")
	Return .F.
ElseIf nQtdOpe > 2 .and. Empty(cOper3)
	MsgAlert("Operador 3 não informado!","OPERAÇÃO CANCELADA")
	Return .F.
ElseIf nQtdOpe > 3 .and. Empty(cOper4) 
	MsgAlert("Operador 4 não informado!","OPERAÇÃO CANCELADA")
	Return .F.
ElseIf nQtdOpe > 4 .and. Empty(cOper5) 
	MsgAlert("Operador 5 não informado!","OPERAÇÃO CANCELADA")
	Return .F.
EndIf

If MsgBox("Deseja continuar o processamento?", "CONFIRMAÇÃO","YESNO" )
	DBSelectArea("SC5")
	DBSetOrder(1)
	If DBSeek(cEmpresa+cPedido)
	
		//PEDIDO NÃO PODE TER INICIADO SEPARAÇÃO
		If SC5->C5_X_STAPV <> '1' .AND. SC5->C5_X_STAPV <> 'A' 
			MsgAlert("Pedido já separado ou pendente de liberação.","OPERAÇÃO CANCELADA")
			Return .F.
		EndIf
		
		RecLock("SC5",.F.)
			SC5->C5_X_SEPAR	:= 'ACDP01'
		MsUnlock()
		
		cQuery := " SELECT COUNT(*) SKU " // qtd total de SKU no pedido
		cQuery += " FROM "+RetSqlName("SC6")+" WITH(NOLOCK) "
		cQuery += " WHERE C6_FILIAL = '"+cEmpresa+"' AND C6_NUM = '"+cPedido+"' AND D_E_L_E_T_ ='' " 
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPCOUNT",.T.,.T.)
		
		nSKU	  := TMPCOUNT->SKU / nQtdOpe 	 //qtd de SKU por operador
		cControle := TRANSFORM(nOper,"@E 9") //registra o primeiro operador
		
		TMPCOUNT->(DbCloseArea())
		
		
		//SELECIONA OS REGISTRO POR ORDEM DE ENDEREÇO
		cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM"
		cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
		cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
		cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
		cQuery	+= " WHERE C6_FILIAL = '"+cEmpresa+"' AND C6_NUM = '"+cPedido+"' AND C6_X_VCXIM > 0 AND C6.D_E_L_E_T_ = '' "
		//cQuery	+= " AND C6_X_SEPAR <> C6_X_VCXIM AND C6_X_RESID = '' "
		cQuery	+= " ORDER BY B1_X_LOCAL "
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC6",.T.,.T.)

		// Posiciona no topo
		TMPSC6->(DbGoTop())
		While !Eof() .AND. TMPSC6->(C6_FILIAL+C6_NUM) = cEmpresa+cPedido
		
			DBSelectArea("SC6")
			DBSetOrder(1)
			DBSeek(TMPSC6->C6_FILIAL+TMPSC6->C6_NUM+TMPSC6->C6_ITEM)
			
			RecLock("SC6",.F.)
				SC6->C6_X_OPERA	:= cOper&cControle
			MsUnlock()
				
			If n >= nSKU
				n	:= 0
				nOper ++
				cControle	:= TRANSFORM(nOper,"@E 9")
			EndIf
				
			n++
			TMPSC6->(DbSkip())
		EndDo

		TMPSC6->(DbCloseArea())
	Else
		MsgAlert("Pedido não localizado!","Atenção")
		
	EndIf
EndIf

MsgInfo("Processamento finalizado com Sucesso!","CONFIRMAÇÃO")
Return()


//**********************************************************
// ROTINA PARA BUSCAR NOME DO OPERADO
//**********************************************************
Static Function NomeOper(cTipo)

DBSelectArea("CB1")
DBSetOrder(1)
DbSeek(xFilial("CB1"+cOper&cTipo))

cNomOper1	:= 'GENILSON'
//cNomOper&cTipo := 'GENILSON'

oTela:Refresh()

Return .T.
