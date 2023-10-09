#INCLUDE "PROTHEUS.CH"

// http://tdn.totvs.com/display/public/PROT/MT103PBLQ+-+Produtos+Bloqueados

/* O ponto de entrada MT103PBLQ est� localizado na fun��o: A103TudOk() 
dentro do MATA103 e permite validar se os produtos que est�o bloqueados 
podem ou n�o ser utilizados no Documento de Entrada.Esta situa��o pode ocorrer, 
por exemplo, quando um Pedido de Compras for vinculado ao Documento de Entrada 
e possuir itens que foram bloqueados, ap�s a inclus�o do Pedido de Compras.
O ponto de entrada tamb�m pode ser utilizado no Retorno de Documentos de Sa�da 
ap�s clicar no bot�o "Retornar", permitindo validar se os produtos que est�o bloqueados 
podem ou n�o ser utilizados no Documento de Entrada.
*/

/*
������������������������������������������������������������������a���a���a���a���a���a���a���a���a���a������Ĵ��
��� 						ULTIMAS ATUALIZA��ES      					                                       ��
�������������������������������������������������������������������������������������������������������������Ĵ��
��� DATA     � 	NOME             � 	HORA                               	 									  ���
��� 02/05/18	ANDR� VALMIR		12:00 																	  ���
���										 																	  ���
��� 									 																	  ���
��� 									 																	  ���
��������������������������������������������������������������������������������������������������������������ٱ�
*/

User Function MT103PBLQ

Local aProd:=PARAMIXB[1]
Local lRet                                    

lret := .T.	// Permite a entrada da NF de produtos bloqueados.

Return lRet