#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATP0015  �Autor  � Bruno             � Data �  14/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Voltar Status do Pedido de Venda para 0 - P. Gerado        ���
���          � 							                                  ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - GENILSON LUCAS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FATP0015()

If SC5->C5_X_STAPV == '1'

	If MsgYesNo("Deseja realmente voltar o Status do Pedido "+SC5->C5_NUM+" para PV Gerado?","Aten��o!")
		TCSPExec("uspVoltaPedido",SC5->C5_FILIAL+SC5->C5_NUM)
	EndIf

Else

	MsgAlert("N�o � possivel alterar Status desse pedido, favor verificar!","Aten��o")

EndIF

Return()
