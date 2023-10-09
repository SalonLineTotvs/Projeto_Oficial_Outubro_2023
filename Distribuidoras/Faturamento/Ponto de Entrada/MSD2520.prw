#INCLUDE "RWMAKE.CH"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
// Execblock p/ alterar STATUS do pedido de venda		    켸
// Cancelamento de NF de Vendas                             켸
// Desenvolvido por Genilson M Lucas - 05/03/18             켸
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

User Function MSD2520()

Local _aArea := GetArea()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� ALTERA STATUS DO PEDIDO PARA STATUS ANTERIOR
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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