#include "TBICONN.CH"
#INCLUDE 'rwmake.ch'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ GERPV   | Autor ³ ANDRE SALGADO/INTRODE ³Data³19/02/2020   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar Pedido de Venda Sobre o SALDO de Produto nao Entregue³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GeraPVWB(cRefPesq)

Local nSEQIPV	 	:= 0
Local nValCorte		:= 0
Local cEstado		:= ''
Local lGeraPV		:= .F.

Private cRefPesq 	:= cRefPesq
Private lgravaCAB	:= .T.	//Flag para confirmar Gravacao
Private aCabec	 	:= {}	//Cabeçalho
Private aLinha	 	:= {}	//Item - temporario
Private aItens	 	:= {}	//Item - Final
Private cTxtUpdate	:= ""
Private lMsErroAuto	:= .F.

_xEmpWS	:= SUBSTR(cRefPesq,1,4)	//Empresa
cNumPv	:= SUBSTR(cRefPesq,5,6)	//Pedido do Corte

//Busca o SALDO do PEDIDO
cQuerySaldo := " SELECT"
cQuerySaldo += " C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_CLIENT, C5_LOJAENT, C5_CONDPAG,"
cQuerySaldo += " C6_PRODUTO, C6_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * C6_X_VCXCO)+C6_X_VGRCO) SALDO_C6, "
cQuerySaldo += " C6_PRCVEN, C6_PRUNIT, C6_TES, C6_NUM, C5_X_DIGIT, A1_EST "
cQuerySaldo += " FROM       "+RetSqlName("SC5")+" C5 WITH(NOLOCK)"
cQuerySaldo += " INNER JOIN "+RetSqlName("SC6")+" C6 WITH(NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_=' '"
cQuerySaldo += " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON C6_PRODUTO= B1_COD AND B1.D_E_L_E_T_=' ' "
cQuerySaldo += " INNER JOIN "+RetSqlName("SA1")+" A1 WITH(NOLOCK) ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_=' ' "

cQuerySaldo += " WHERE C5.D_E_L_E_T_=' '"
cQuerySaldo += " AND C6_FILIAL = '"+_xEmpWS+"' AND C5_NUM = '"+cNumPv+"'"
cQuerySaldo += " AND C6_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * C6_X_VCXCO)+C6_X_VGRCO) > 0 "
//cQuerySaldo += " AND (C6_X_VCXIM+C6_X_VGRIM) <> (C6_X_VCXCO+C6_X_VGRCO) " // ADICIONADO GENILSON LUCAS
cQuerySaldo += " AND C5_ESPECI2=' ' "		//FLAG INFORMAR QUE O PEDIDO JÁ TEVE CORTE!
cQuerySaldo += " ORDER BY C6_PRODUTO "

//MemoWrit("C:\AA\cQuerySaldo2.TXT",cQuerySaldo)

If Select("TRB1") > 0
	TRB1->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuerySaldo),"TRB1", .F., .T.)
TCSETFIELD("TRB1","SALDO_C6"	,"N",16,2)  //Quantidade
TCSETFIELD("TRB1","C6_PRCVEN"	,"N",16,4)  //Valor Unitario

//Varivel do Controle da Filial
cAteFil := cFilAnt	//Filial Original
cFilAnt := _xEmpWS	//Filial DESEJADA

dbSelectArea("TRB1")

If !Eof()
	
	While !EOF() .AND.  TRB1->C5_NUM = cNumPv
		
		//Prepara o Cabecalho do Pedido de Venda  (SC5)
		If 	lgravaCAB
	
			_cNewNumPV	:= GetSxeNum("SC5", "C5_NUM")
			RollBAckSx8()
			
			aadd(aCabec,{"C5_NUM"		,_cNewNumPV	,Nil})
			aadd(aCabec,{"C5_TIPO"		,"N"		,Nil})
			aadd(aCabec,{"C5_CLIENTE"	,TRB1->C5_CLIENTE,Nil})
			aadd(aCabec,{"C5_LOJACLI"	,TRB1->C5_LOJACLI,Nil})
			aadd(aCabec,{"C5_CLIENT"	,TRB1->C5_CLIENT ,Nil})
			aadd(aCabec,{"C5_LOJAENT"	,TRB1->C5_LOJAENT,Nil})
			aadd(aCabec,{"C5_CONDPAG"	,TRB1->C5_CONDPAG,Nil})
			aadd(aCabec,{"C5_X_PEDOR"	,cNumPv		,Nil})		
			aadd(aCabec,{"C5_MENNOTA"	,"SALDO PEDIDO VENDA "+cNumPv,Nil})
			aadd(aCabec,{"C5_X_DIGIT"	,TRB1->C5_X_DIGIT,Nil})		
	
			cEstado		:= TRB1->A1_EST
			lgravaCAB 	:= .F.
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
			aadd(aLinha,{"C6_NUM"		,_cNewNumPV					,Nil})
			aadd(aItens,aLinha)
			
			nValCorte += TRB1->C6_PRCVEN * TRB1->SALDO_C6	
			
		Endif
		
		dbSelectArea("TRB1")
		dbSkip()
		
	Enddo    
	
	//****************************************************************
	//* Inclusao - PEDIDO DE VENDA (EXECAUTO)
	//****************************************************************
	if !lgravaCAB
			
		// Atualiza pedido de vendas Original
		SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cNumPv ))
	
		While SC6->(!eof()) .and. SC6->C6_NUM = cNumPv
			
			If SC6->(C6_X_VCXIM+C6_X_VGRIM) <> SC6->(C6_X_VCXCO+C6_X_VGRCO)
				cProduto := SC6->C6_PRODUTO
				
				cTxtUpdate += " UPDATE "+RetSqlName("SC6")+" SET C6_OP=' ', C6_QTDEMP=0, C6_QTDEMP2=0,"
		
				cTxtUpdate += " C6_OK  = CASE WHEN (C6_X_VCXIM+C6_X_VGRIM)>0 AND (C6_X_VCXCO+C6_X_VGRCO)<= 0 THEN '1O'"
				cTxtUpdate += "              WHEN (C6_X_VCXIM+C6_X_VGRIM)=(C6_X_VCXCO+C6_X_VGRCO) THEN ' ' ELSE '1O' END,"
		
				cTxtUpdate += " C6_BLQ = CASE WHEN (C6_X_VCXIM+C6_X_VGRIM)>0 AND (C6_X_VCXCO+C6_X_VGRCO)<= 0 THEN 'R'"
				cTxtUpdate += "               WHEN (C6_X_VCXIM+C6_X_VGRIM)=(C6_X_VCXCO+C6_X_VGRCO) THEN ' ' ELSE 'R' END,"
					
				cTxtUpdate += " C6_QTDLIB = C6_X_VGRCO+(C6_X_VCXCO*B1_QE), C6_QTDLIB2 = C6_X_VGRCO+(C6_X_VCXCO*B1_QE)  "
		
				cTxtUpdate += " FROM "+RetSqlName("SC6")+ " C6  INNER JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO = B1_COD AND B1.D_E_L_E_T_ = ''
				cTxtUpdate += " WHERE "
				cTxtUpdate += " C6_NUM='"+cNumPv+"' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_PRODUTO='"+cProduto+"'" 
			EndIf
					
			SC6->(dbskip())
			
		Enddo
			
		TcSqlExec(cTxtUpdate)
			
	
		DBSelectArea("SC9")
		DBSetOrder(1) 
		DBGotop()
		DBSeek(xFilial("SC9")+Alltrim(cNumPv))
			
		While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cNumPv) 
			
			SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cNumPv+SC9->(C9_ITEM+C9_PRODUTO)))
				
			If SC6->C6_QTDLIB > 0
				RecLock("SC6",.F.)
					SC6->C6_QTDEMP 	:= SC6->C6_QTDLIB
					SC6->C6_QTDEMP2	:= SC6->C6_QTDLIB2
				SC6->( MsUnLock() )
			Endif 
				
				
			If SC6->C6_BLQ="R" 
				IF SC6->C6_QTDLIB = 0
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
			Endif
			   
			SC9->(dbskip())
			
		Enddo	                             
	
		//***********************************************************
		// VALIDA VALOR E ESTADO
		//***********************************************************
		IF cEstado $ "PR/RJ/RS/SC/SP" .and. nValCorte >= 3500
			lGeraPV	:= .T.
		ElseIf nValCorte >= 5000
			lGeraPV := .T.
		EndIf
	
	
		
	
		//************************************************************				
		//	GERA PEDIDO DE VENDA COM SALDO - NECESSÁRIO 1 PRODUTO	//
		//************************************************************
		If Len(aItens) > 0 .and. lGeraPV
			MATA410(aCabec,aItens,3)	//FUNCAO PADRAO TOTVS PARA CRIACAO PEDIDO DE VENDA
	
			//Grava Flag que Pedido foi processado
			cUpdtSC5 := " UPDATE SC5020 SET C5_ESPECI2 = '"+_cNewNumPV+"' WHERE C5_NUM='"+cNumPv+"' AND C5_FILIAL='"+_xEmpWS+"' "
			TcSqlExec(cUpdtSC5)
			
			If !lMsErroAuto
			// MsgInfo("PEDIDO COM SALDO "+Alltrim(_cNewNumPV)+" GERADO COM SUCESSO!","ATENCAO!")

			Else
			// lMostraErro	:= .T.
			// Mostraerro()		
			EndIf
		EndIf


		//**********************************************************
		// 		ENVIA E-MAIL			
		//**********************************************************
		cPara	 := 'genilson.lucas@salonline.com.br'
		cAssunto := 'ROTINA DE CORTE'
		cBody := Chr(13)+Chr(10);
		+ 'Pedido: '+ _xEmpWS + ' - ' + cNumPv + Chr(13)+Chr(10);
		+ 'Valor: R$ ' +  Transform(nValCorte,"@E 99,999.99") + Chr(13)+Chr(10);
		+ 'Estado: ' + cEstado + Chr(13)+Chr(10);
		+ 'Gera PV: ' + Iif(lGeraPV,'SIM','NÃO')
		
		U_SendMail( cPara, '', '', cAssunto, cBody,'' )
		
	Endif
Else
	//CRIAR VALIDAÇÃO
	// SC5->C5_X_CORTE	:= '2' //SEM CORTE
	// 1 - Não Validado
	// 2 - Sem Corte
	// 3 - Corte Efetuado
EndIf
       
cFilAnt := cAteFil

Return (NIL)