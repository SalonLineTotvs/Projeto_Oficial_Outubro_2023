#Include "Protheus.Ch"
#Include "TopConn.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410PVNF  ºAutor  ³Andre Salgado       º Data ³  14/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada FILTRA e só Autorizar os Pedidos de Venda  º±±
±±º          ³ Campo C5_X_STAPV = '5' ou  C5_X_STAPV = 'F'                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SALON LINE -  SOLICITAÇÃO - GENILSON LUCAS                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 25/07/18 ³ Andre Salgado ³ Incluir query validar se todos os itens    ³±±
±±³          ³               ³ estão liberados para faturamento           ³±±
±±³          ³               ³                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410PVNF()

Local cStautsPV	:= SC5->C5_X_STAPV	//Campo Customizado - SALONLINE - Guarda o Status do Pedido no controle do Fluxo de Processo
Local lCont		:= .T.				//Flag de autorização de processamento
Local cTPCli	:= SC5->C5_TIPOCLI	//Tipo de Cliente
Local cNumSC5	:= SC5->C5_NUM		//Numero do Pedido de Venda
Local lRegBloq	:= .F.				//Flag de Pedido de venda liberado


IF SM0->M0_CODIGO="02" 	//Só Processar para Empresa DISTRIBUIDORA
	
	//Verifica se Pedido de Venda esta 100% liberado para Fatura (Estoque) e (Credito)
	cQuery := " SELECT DISTINCT C9_BLEST, C9_BLCRED"
	cQuery += " FROM "+RetSQLName("SC9")+" WITH (NOLOCK)"
	cQuery += " WHERE D_E_L_E_T_=' '"
	cQuery += " AND C9_PEDIDO='"+cNumSC5+"'"
	cQuery += " AND C9_FILIAL='"+xFilial("SC5")+"'"
	
	If Select("TRB1") > 0
		TRB1->( dbCloseArea() )
	EndIf
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)
	
	
	While !EOF()
		
		IF !EMPTY(TRB1->C9_BLEST) .or. !EMPTY(TRB1->C9_BLCRED) 
			lRegBloq := .T.		//Se tiver Produto liberado no SC9, NÃO AUTORIZA O FATURAMENTO
		Endif
		
		dbSelectArea("TRB1")
		dbSkip()
	Enddo
	
	
	
	//Valida, Informa o Usuario e não autoriza o processamento
	If !(cStautsPV $ "5,A") .or. cTPCli = 'X'
		APMSGINFO("Pedido de Venda com STATUS não autorizado para faturamento, selecionar registro validado !")
		lCont	:= .F.
	ElseIf  lRegBloq
		APMSGINFO("Pedido com bloqueio de ESTOQUE ou CRÉDITO! Liberar pela rotina: Pedido >> Liberação de Crédito e Estoque")
		lCont	:= .F.	
	EndIf
	
Endif

Return lCont
