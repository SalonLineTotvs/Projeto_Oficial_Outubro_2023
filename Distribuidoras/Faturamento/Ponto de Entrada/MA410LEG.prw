#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA410LEG �Autor  � Genilson Lucas     � Data �  18/11/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para altera��o da Legenda do Pedido de    ���
���          � Vendas.										              ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - ELSER / JACQUELINE             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function MA410LEG()

Local aLeg := PARAMIXB


aLeg := { {'ENABLE' ,"Pedido de Venda em aberto"},;
		  {'DISABLE' ,"Pedido de Venda encerrado"},;
		  {'BR_AMARELO',"Pedido de Venda liberado" },;
		  {'BR_PRETO',"Pedido Bloqueado (Cr�dito Cliente)" },;
		  {'BR_AZUL', "Pedido Rejeitado (Financeiro)" }  }//Customiza��o
		

//{'BR_AZUL' ,"Pedido de Venda com Bloqueio de Regra"},;
//{'BR_LARANJA',"Pedido de Venda com Bloqueio de Verba" },;



Return aLeg