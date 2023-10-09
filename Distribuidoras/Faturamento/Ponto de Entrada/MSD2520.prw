#INCLUDE "RWMAKE.CH"

//����������������������������������������������������������Ŀ
// Execblock p/ alterar STATUS do pedido de venda		    ��
// Cancelamento de NF de Vendas                             ��
// Desenvolvido por Genilson M Lucas - 05/03/18             ��
//������������������������������������������������������������

User Function MSD2520()

Local _aArea := GetArea()

//����������������������������������������������������������Ŀ
//� ALTERA STATUS DO PEDIDO PARA STATUS ANTERIOR
//������������������������������������������������������������
DBSelectArea("SC5")
DBSetOrder(1)
If DBSeek(xFilial("SC5")+SD2->D2_PEDIDO)

	If SC5->C5_X_STAPV	<> "A"
		RecLock("SC5",.F.)
		SC5->C5_X_STAPV	:= '5'
		SC5->C5_X_MANIF	:= ''
		SC5->(MsUnlock()) 
	Else
		RecLock("SC5",.F.)
		SC5->C5_X_MANIF	:= ''
		SC5->(MsUnlock()) 
	EndIf
EndIf

RestArea(_aArea)

Return()