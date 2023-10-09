#include 'protheus.ch'
#include 'parmtype.ch'
User Function XMLCTE10()
	Local	aAreaOld	:= GetArea()
	Local	lRet		:= .T. 
	Local	nOpcFil		:= ParamIxb
	if Empty(MV_PAR25)
		lRet	:= .T.
		RestArea(aAreaOld)
		Return (lRet)
	else
		If nOpcFil == 2	// Posicionado no cadastro de fornecedor
				If SA2->A2_EST + '/' $ MV_PAR25
					lRet	:= .T.
				Else
					lRet	:= .F. 
				Endif
		ElseIf nOpcFil == 3 // Posicionado no cadastro de Clientes 
				If SA1->A1_EST + '/' $ MV_PAR25
					lRet	:= .T.
				Else
					lRet	:= .F. 
				Endif
		Endif
	Endif
	RestArea(aAreaOld)
Return	lRet
