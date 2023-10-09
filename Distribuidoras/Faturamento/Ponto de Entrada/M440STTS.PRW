#include "rwmake.ch"

//+---------------------------------------------------------------------------+
//|  Funcao    | M440STTS                             	    | Data | 10/04/18 |
//+---------------------------------------------------------------------------+
//|  Autor     | Genilson M Lucas            			    | Empr |    	  |
//+---------------------------------------------------------------------------+
//|  Uso       | Liberação Pedido SALONLINE                                   |
//+---------------------------------------------------------------------------+
//|  Descricao | Ponto de Entrada na liberacao do pedido de venda             |
//|            |       						              					  |
//+---------------------------------------------------------------------------+

//*****************************************************************************
User Function M440STTS()
//*****************************************************************************

Local aArea	    := GetArea()

//******************************************************************
// EXECUTA PROGRAMA PARA ANALISE DE CRÉDITO
//******************************************************************
U_FATP0018(M->C5_NUM, M->C5_CLIENTE, M->C5_LOJACLI, M->C5_TIPO)


//******************************************************************
// REGRA PARA ALTERAR  STATUS PARA FATURAMENTO
//******************************************************************
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

//Segmento 000004 - Tipo Transportadora  //  Tipo 1 Refaturamento  //  Filial Devintex  // Tipo de Pedido Diferente de Normal
If SA1->A1_SATIV1 = '000004' .OR. SC5->C5_X_TIPO2 = '1' .OR. SC5->C5_FILIAL == '0901' .OR. SC5->C5_TIPO<>"N"
	dbSelectArea("SC5")
	RecLock( "SC5", .F. )
		SC5->C5_X_STAPV	:= '5'
	SC5->(MsUnLock())	

	//Libera Estoque - SC9 - Desenv. Andre Salgado/Introde - 14/05/2018 - Sol.Genilson
	cUpdateC9:= " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' WHERE C9_FILIAL='"+SC5->C5_FILIAL+"' AND C9_PEDIDO='"+SC5->C5_NUM+"' AND C9_NFISCAL=' '"
	TcSqlExec(cUpdateC9)

EndIf
                      
dbSelectArea("SC6")
dbSetOrder(1)
If dbSeek(xFilial("SC6")+SC5->C5_NUM) 

	If Alltrim(SC6->C6_PRODUTO) $ GETMV("ES_PALETE")
	
		dbSelectArea("SC5")
		RecLock( "SC5", .F. )
		SC5->C5_X_STAPV	:= '5'
		SC5->(MsUnLock())
			
	EndIf                                      
EndIf


RestArea(aArea)

Return()
