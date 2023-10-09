#INCLUDE "Protheus.ch"                   
//Programa AxCadastro - ALTERAR GNRE
//Autor - Valmir / Introde

//Importante foi criado para alterar a data de pagamento e vencimento da GNRE

USER FUNCTION FATP0013()

cCadastro := "GNRE"
//aRotina    := {}
AxCadastro("SF6", OemToAnsi(cCadastro))

Return Nil