#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA450MNU ºAutor  ³ Genilson M Lucas   º Data ³  26/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada INCLUIR BOTÃO (Outras Ações) no           º±±
±±º          ³ na liberação do pedido por crédito.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SALON LINE -  SOLICITAÇÃO - GENILSON LUCAS                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA450MNU()
/*
Local aArea      := GetArea()
Local aAreaSM0   := SM0->(GetArea())
//Local aAreaSC9   := SC9->(GetArea())


//If !Empty(SC9->C9_CLIENTE)
	AADD( aRotina,{"An. Crédito CNPJ SC9"	,"U_FINP0003(SC9->C9_FILIAL, SC9->C9_CLIENTE, SC9->C9_LOJA)",0,4,20,NIL})
//	ALERT("ENTROU NA SC9")
	
//Else
//	AADD( aRotina,{"An. Crédito CNPJ SA1"	,"U_FINP0003(SA1->A1_FILIAL, (cAliasTRB)->C9_CLIENTE, (cAliasTRB)->C9_LOJA)",0,4,20,NIL})
//	ALERT("ENTROU NA SA1")
//	ALERT(SA1->A1_COD)
//EndIf		

RestArea(aArea)
RestArea(aAreaSM0)
//RestArea(aAreaSC9)
*/
Return()

