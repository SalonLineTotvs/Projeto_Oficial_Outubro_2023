#INCLUDE "PROTHEUS.CH"

// http://tdn.totvs.com/display/public/PROT/MT103PBLQ+-+Produtos+Bloqueados

/* O ponto de entrada MT103PBLQ está localizado na função: A103TudOk() 
dentro do MATA103 e permite validar se os produtos que estão bloqueados 
podem ou não ser utilizados no Documento de Entrada.Esta situação pode ocorrer, 
por exemplo, quando um Pedido de Compras for vinculado ao Documento de Entrada 
e possuir itens que foram bloqueados, após a inclusão do Pedido de Compras.
O ponto de entrada também pode ser utilizado no Retorno de Documentos de Saída 
após clicar no botão "Retornar", permitindo validar se os produtos que estão bloqueados 
podem ou não ser utilizados no Documento de Entrada.
*/

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					                                       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	 									  ³±±
±±³ 02/05/18	ANDRÉ VALMIR		12:00 																	  ³±±
±±³										 																	  ³±±
±±³ 									 																	  ³±±
±±³ 									 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function MT103PBLQ

Local aProd:=PARAMIXB[1]
Local lRet                                    

lret := .T.	// Permite a entrada da NF de produtos bloqueados.

Return lRet