#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.ch'
#include "topconn.ch"
#INCLUDE 'colors.ch'
#Include "Avprint.ch"
#Include "Font.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ESTP0002	 ³ Autor ³ André Valmir 		³ Data ³16/02/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de Separação de Produto           					  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±


±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	  ³±±
±±³ 27/02/18	ANDRE VALMIR		11:20								  ³±±
±±³	05/03/18	GENILSON LUCAS		13:06								  ³±±
±±³																		  ³±±
±±³																		  ³±±
±±³																		  ³±±
±±³																		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

** Criar os campos **
- CONTROLE DE SEPARACAO PRODUTO
C5_X_DTISP D 08 - Data Inicio Separacao
C5_X_HRISP C 05 - Hora Inicio Separacao
C5_X_DTFSP D 08 - Data Fim Separacao
C5_X_HRFSP C 05 - Hora Fim Separacao
C5_X_SEPAR C 06 - Cod.Separador

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTP0002()

Private cEOL 	 := CHR(13)+CHR(10)	//Enter
Private cPedido  := space(07)		//Numero do Pedido de Venda
Private cSepad   := space(06)		//Codigo do Separador
Private cNomeSep := ""


//Tela Inicial
nOpc := Aviso( 'CONTROLE - ORDEM DE SEPARAÇÃO: '+ALLTRIM(SM0->M0_FILIAL)+cEOL, ;
'INICIO - utilizar para começar separação e informar o codigo do separador'+cEOL+cEOL+;
'FINALIZAÇÃO - FIM utilizar para informar conclusão separacao.'+cEOL+cEOL+;
'CONSULTA - utilizar lista em tela Pedidos em aberto no Setor.'+cEOL+cEOL+;
'', {"Consultar","Finalização","Inicio","Sair"}, 3 )


//BOTÃO RECEBER
/*
if nOpc = 3
	Set Device To Screen
	@ 001,200 To 200,500 Dialog oNota Title OemToAnsi("Parametro - Separacao")
	@ 0.5,001 To 5.7, 018 Label OemToAnsi('Recebimento do Pedido')
	@ 025,015 Say OemToAnsi("Numero Pedido")
	@ 025,070 Get cPedido SIZE 50,50
	@ 087,070 BmpButton Type 1 Action close(onota)
	Activate Dialog oNota Centered
	Set Device To Print
	
	//Valida Numero informado
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPedido)
	
	If Found()
		
		//Valida o Status do Pedido
		IF SC5->C5_X_STAPV="0"
			Aviso("ATENCAO","Numero do Pedido com STATUS não autorizado para setor SEPARACAO !",{"OK"})
			RETURN
		ENDIF
		
		IF EMPTY(SC5->C5_X_DTRSP)
			RecLock("SC5",.F.)
			SC5->C5_X_DTRSP := Date()
			SC5->C5_X_HRRSP := time()
			SC5->C5_X_OPSP  := RetCodUsr()
			MsUnlock()
		Endif
	Else
		Aviso("ATENCAO","Numero Não localizado no Sistema, informar codigo validado.",{"OK"})
	Endif
	
	U_ESTP0002()
*/

//BOTÃO INICIO
if nOpc = 3
	
	cPedido := space(07)
	Set Device To Screen
	@ 001,200 To 200,500 Dialog oNota Title OemToAnsi("Parâmetros")
	@ 0.5,001 To 5.7, 018 Label OemToAnsi('Inicio Separacao '+Dtoc(Date())+" "+substr(time(),1,5))
	@ 025,015 Say OemToAnsi("Numero Pedido")
	@ 025,070 Get cPedido VALID !EMPTY(cPedido) SIZE 50,50
	@ 040,015 Say OemToAnsi("Cod. Separador")
	@ 040,070 Get cSepad VALID !EMPTY(RetSepad(cSepad)) SIZE 50,50
	@ 087,070 BmpButton Type 1 Action (AtuPedido(1),oNota:End()) // (nOpc:=1,oDlg:End())
	Activate Dialog oNota Centered
	Set Device To Print

	//ABRE TELA INICIAL
	U_ESTP0002()
	
	//BOTÃO FIM
Elseif nOpc = 2
	
	cPedido := space(06)
	Set Device To Screen
	@ 001,200 To 200,500 Dialog oNota Title OemToAnsi("Parâmetros")
	@ 0.5,001 To 5.7, 018 Label OemToAnsi('Fim Separacao '+Dtoc(Date())+" "+substr(time(),1,5))
	@ 025,015 Say OemToAnsi("Número Pedido")
	@ 025,070 Get cPedido VALID !EMPTY(cPedido) SIZE 50,50
	@ 087,070 BmpButton Type 1 Action (AtuPedido(2),oNota:End()) 
	Activate Dialog oNota Centered
	Set Device To Print
	
	//ABRE TELA INICIAL
	U_ESTP0002()
	
	
	
	//BOTÃO CONSULTA
Elseif nOpc = 1
	
	//Montar Arquivo Temp
	aTrab      := {}
	AADD(aTrab,{ "PEDIDO"	,"C", 06, 0 })
	AADD(aTrab,{ "DTRECE"	,"C", 16, 0 })
	AADD(aTrab,{ "DTINIC"  	,"C", 16, 0 })
	AADD(aTrab,{ "SEPARA"  	,"C", 06, 0 })
	
	If Select("TRBA") > 0
		TRBA->(DbCloseArea())
	Endif
	
	cArqDBF0 := CriaTrab( aTrab, .T. )
	//	cArqNTX0 := CriaTrab( NIL, .F. )
	Use &cArqDBF0 Alias "TRBA" Exclusive New
	
	
	//Busca Pedidos Em Aberto no Setor de SEPARACAO
	cQuery := " SELECT"
	cQuery += " C5_NUM, C5_X_SEPAR,"
	cQuery += " RIGHT(C5_X_DTISP,2)+'/'+SUBSTRING(C5_X_DTISP,5,2)+'/'+LEFT(C5_X_DTISP,4)+' '+C5_X_HRISP ENTRADA,"
	cQuery += " CASE WHEN C5_X_DTISP<>' ' THEN RIGHT(C5_X_DTISP,2)+'/'+SUBSTRING(C5_X_DTISP,5,2)+'/'+LEFT(C5_X_DTISP,4)+' '+C5_X_HRISP ELSE ' ' END INICIO"
	cQuery += " FROM "+RetSQLName("SC5")+" C5"
	cQuery += " WHERE C5.D_E_L_E_T_=' '"
	cQuery += " AND C5_X_DTISP <>' '"
	cQuery += " AND C5_X_DTFSP=' '"
	cQuery += " AND C5_FILIAL='"+xFilial("SC5")+"' "
	cQuery += " ORDER BY 1"
	
	If Select("TRB1") > 0
		TRB1->(DbCloseArea())
	Endif
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)
	
	//SetRegua(nRecCount)
	dbSelectArea("TRB1")
	dbGoTop()
	While !EOF()
		
		_PEDIDO	:= TRB1->C5_NUM
		_DTRECEB:= TRB1->ENTRADA
		_DTINIC	:= TRB1->INICIO
		_SEPARA	:= TRB1->C5_X_SEPAR
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava arquivo temporario                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectarea("TRBA")
		RECLOCK( "TRBA", .T. )
		TRBA->PEDIDO:= _PEDIDO
		TRBA->DTRECE:= _DTRECEB
		TRBA->DTINIC:= _DTINIC
		TRBA->SEPARA:= _SEPARA
		MSUNLOCK()
		
		dbSelectArea("TRB1")
		dbSkip()
	EndDo
	
	dbselectarea("TRBA")
	DbGoTop()
	
	aCampos := {}
	AADD(aCampos,{"PEDIDO"	,"PEDIDO" })
	AADD(aCampos,{"DTRECE"	,"ENTRADA" })
	AADD(aCampos,{"DTINIC"	,"INICIO SEPARACAO"})
	AADD(aCampos,{"SEPARA"	,"SEPARADOR"  })
	
	@ 100,1 TO 500,640 DIALOG oDlg2 TITLE "PEDIDO EM ABERTO NO SETOR - SEPARACAO"
	@ 10,7 TO 170,320 BROWSE "TRBA" FIELDS aCampos
	@ 170,010 Say "Total Pedido em Aberto :"+transform(RECCOUNT(),"@E 999999")
	//	@ 180,202 Say RECCOUNT()
	@ 180,180 BUTTON "_OK" SIZE 40,15 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTERED
	
	
	U_ESTP0002()
	
	//SAIR
//Else
	
Endif 

Return()


//******************************************
// ROTINA PARA ATUALIZAÇÃO DO STATUS
//******************************************
Static Function AtuPedido(nOpc2)
	
	//BUSCA PEDIDO
	DbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+alltrim(cPedido)) 
	
	If Found() 
		
		//PEDIDO PODE INICIAR SEPARAÇÃO
		If nOpc2 = 1 .and. ( SC5->C5_X_STAPV="1" .OR. SC5->C5_X_STAPV="A") 		
			RecLock("SC5",.F.)
			SC5->C5_X_DTISP	:= Date()
			SC5->C5_X_HRISP	:= time()
			SC5->C5_X_SEPAR	:= cSepad //cNomeSep
			SC5->C5_X_STAPV := "2"
			MsUnlock()
			
		//PEDIDO COM SEPARAÇÃO INICIADA
		ElseIf  nOpc2 = 2  .AND. SC5->C5_X_STAPV $ "2/4" .and. Empty(SC5->C5_X_DTFSP)
		
			RecLock("SC5",.F.)
			SC5->C5_X_DTFSP	:= Date()
			SC5->C5_X_HRFSP := time()
			If SC5->C5_X_STAPV = '2'
				SC5->C5_X_STAPV := "3"
			EndIf
			MsUnlock()
		Else
			Aviso("Status","Favor consultar se Status do pedido está validado para função solicitada",{"OK"})
		EndIf
	Else
		Aviso("ATENCAO","Numero Não localizado no Sistema, informar codigo validado.",{"OK"})
			
		Aviso("Atenção","Pedido não localizado.",{"OK"})
	Endif
	
Return()	
	
	
//******************************************
// CONSULTA OPERADO
//******************************************	
Static Function RetSepad(cSepad)
	
	DBSelectArea("CB1")
	DBSetOrder(1)
	DBSeek(xFilial("CB1")+cSepad)   
	
	If Found()
		cNomeSep	:= CB1->CB1_NOME
	Else 
	    Aviso("ATENÇÃO","Código do Separador Invalido, favor digitar código valido.",{"OK"})
		Return
	Endif
	
Return(cSepad)
