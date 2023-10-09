#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.ch'
#include "topconn.ch"
#INCLUDE 'colors.ch'
#Include "Avprint.ch"
#Include "Font.ch"
#INCLUDE "TBICONN.CH"

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

User Function FATP0011(lOpcao)

Local 	lOpc		:= lOpcao 
//Local 	lOpc	:= .T.		//OPÇÃO PARA COMPILAR VIA SCHEDULE
Private nConsumo:= 0
Private cAtenc	:= ""

If lOpc
	PREPARE ENVIRONMENT EMPRESA '02' FILIAL '0101' MODULO "FAT" 
Else
	Set Device To Screen
	@ 001,200 To 200,500 Dialog oNota Title OemToAnsi("Atualiza do Estoque dos Pedidos")
	@ 0.5,001 To 5.7, 018 Label OemToAnsi('Atualiza Analise do Estoque PVs')
	@ 025,015 Say OemToAnsi("Será atualiza os Pedidos com Saldo de Estoque")
	@ 087,070 BmpButton Type 1 Action close(onota)
	Activate Dialog oNota Centered
	Set Device To Print
EndIf

//Procedure para atualiza a tabela Temporaria do Estoque - Hoje o Controle é feito em outro Sistema (CS Vini)
//Criado por Vinicius Messias/DBA
msgAlert("Executa Procedure")

cExecProc := "exec uspSaldoOnda"
TcSqlExec(cExecProc)

msgAlert("Procedure executada")

/*  // Valmir/Vinicius (03/12/2018) 
cQuery := " SELECT "
cQuery += " A1_X_PRIOR, C5_EMISSAO, C5_X_HRINC, C6_PRODUTO, C5_FILIAL, C5_NUM, C6_ITEM, C6_QTDVEN"
cQuery += " FROM "+RETSQLNAME("SC6")+" C6 WITH(NOLOCK) "
cQuery += " INNER JOIN "+RETSQLNAME("SC5")+" C5 WITH(NOLOCK) ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C5.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RETSQLNAME("SA1")+" A1 WITH(NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE "
cQuery += " C6.D_E_L_E_T_=' ' "
cQuery += " AND C5_X_NONDA = '' AND C5_X_ONDLG = '' "
cQuery += " AND C5_TIPO = 'N' "
cQuery += " AND A1_SATIV1 NOT IN ('000003','000004') " //"AND A1_EST IN ('RJ','SP','MG')  "
cQuery += " AND C5_X_STAPV = '0' AND C5_NOTA NOT IN ('XXXXXXXXX') " 
cQuery += " AND C5_X_TIPO2 = '2' "
cQuery += " AND C6_X_ESTOQ NOT IN('S') "	//Valida Estoque (PV Novos e PV sem estoque
cQuery += " AND C5_EMISSAO >= '20180801' "
cQuery += " ORDER BY IIF(C5_X_SONLG = '','9',C5_X_SONLG), A1_X_PRIOR , "	//Conforme informação do Fernando M. não precisa considerar Prioridade
cQuery += " C5_EMISSAO, C5_X_HRINC, C6_PRODUTO"   
*/

// Valmir/Vinicius (03/12/2018) 
/*
cQuery := " SELECT A1_X_PRIOR, C5_EMISSAO, C5_X_HRINC, C6_PRODUTO, C5_FILIAL, C5_NUM, C6_ITEM, C6_QTDVEN "
cQuery += " FROM SC6020 C6 WITH(NOLOCK)  "
cQuery += " INNER JOIN SC5020 C5 WITH(NOLOCK) ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C5.D_E_L_E_T_=' '       "
cQuery += " INNER JOIN SA1020 A1 WITH(NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND A1.D_E_L_E_T_=' '    "
cQuery += " INNER JOIN SB1020 B1 WITH(NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.D_E_L_E_T_=' ' AND B1.B1_TIPO = 'PA' AND B1.B1_COD BETWEEN '00000' AND '99999' "
cQuery += " WHERE   "
cQuery += " C6.D_E_L_E_T_=' '   "
cQuery += " AND C5_EMISSAO >= '20180801'  "
cQuery += " AND C5_NOTA NOT IN ('XXXXXXXXX')  "
cQuery += " AND C5_TIPO = 'N' "
cQuery += " AND C5_X_TIPO2 = '2'  "
cQuery += " AND A1_SATIV1 NOT IN ('000003','000004') "
cQuery += " AND C5_X_DTOLO = '' AND C5_X_STAPV = '0' "
cQuery += " ORDER BY IIF(C5_X_ANTEC = '1' AND A1_X_PRIOR= '0',0,IIF(C5_X_ANTEC ='1' AND C5_X_SONLG !='',1, IIF(C5_X_ANTEC = '2' AND A1_X_PRIOR= '0',2,IIF(C5_X_ANTEC ='2' AND C5_X_SONLG !='',3,IIF(C5_X_ANTEC = '1' AND A1_X_PRIOR IN ('1','2'),4,IIF(C5_X_ANTEC = '1' ,5,6)))))) "
cQuery += " ,IIF(C5_X_SONLG = '','9',C5_X_SONLG),A1_X_PRIOR, "
cQuery += " C5_EMISSAO, C5_X_HRINC, C6_PRODUTO    "
*/

//GENILSON - FECHAMENTO 30/03 ANTECIPADO
cQuery := " SELECT A1_X_PRIOR, C5_EMISSAO, C5_X_HRINC, C6_PRODUTO, C5_FILIAL, C5_NUM, C6_ITEM, C6_QTDVEN "
cQuery += " FROM SC6020 C6 WITH(NOLOCK)  "
cQuery += " INNER JOIN SC5020 C5 WITH(NOLOCK) ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C5.D_E_L_E_T_=' '       "
cQuery += " INNER JOIN SA1020 A1 WITH(NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND A1.D_E_L_E_T_=' '    "
cQuery += " INNER JOIN SB1020 B1 WITH(NOLOCK) ON C6_PRODUTO = B1.B1_COD AND B1.D_E_L_E_T_=' ' AND B1.B1_TIPO = 'PA' AND B1.B1_COD BETWEEN '00000' AND '99999' "
cQuery += " WHERE   "
cQuery += " C6.D_E_L_E_T_=' '   "
cQuery += " AND C5_NOTA NOT IN ('XXXXXXXXX')  "
cQuery += " AND C5_TIPO = 'N' AND C5_X_TIPO2 = '2' AND C5_EMISSAO >= '20190401' "
cQuery += " AND A1_SATIV1 NOT IN ('000003','000004') "
cQuery += " AND C5_X_STAPV = 'A' " // AND C5_FILIAL = '0201'
cQuery += " ORDER BY C5_EMISSAO, C5_X_HRINC   "

msgAlert("Query executada")

If Select("TRB1") > 0
	TRB1->(DbCloseArea())
Endif
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)


dbSelectArea("TRB1")
dbGoTop()

msgAlert("Antes do While")
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

msgAlert("Query executada")

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

If lOpc
	RESET ENVIRONMENT
Else
	Aviso("ATENCAO","Foi atualizado a Analise de Estoque com os Pedidos ate o momento "+Dtoc(ddatabase)+" "+substr(time(),1,5),{"OK"})
EndIf

dbSelectArea("TRB1")
DbCloseArea()

Return()



//Atualiza Tabela SC6 
Static Function AtuSC6(cTPPed)

cExPrc := " exec uspSC6020C6_X_ESTOQ '"+TRB1->C5_FILIAL+"','"+TRB1->C5_NUM+"','"+TRB1->C6_PRODUTO+"','"+cTPPed+"' "
TcSqlExec(cExPrc)

/*
DbSelectarea("SC6")
dbSeek(TRB1->C5_FILIAL+TRB1->C5_NUM+TRB1->C6_ITEM)
If FOUND()
	RECLOCK( "SC6", .F. )
	SC6->C6_X_ESTOQ := cTPPed
	MSUNLOCK()
Endif
*/

Return()