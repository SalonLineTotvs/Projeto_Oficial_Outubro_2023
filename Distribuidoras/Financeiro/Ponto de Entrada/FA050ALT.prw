//Biblioteca
#Include 'Totvs.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} FA050ALT
 SPRINT 2_Contas a Pagar - Alteração de Contas de Fornecedor - No título mudar a conta e atualizar o cadastro
@author  Claudio Gaspar
@since   04/10/2022
@version 1.0
/*/
//-------------------------------------------------------------------
User Function FA050ALT()
	Local lRet      := .t.
	LOCAL aAreaAnt  := GETAREA()

	dbSelectArea("FIL")
	DbSetOrder(1)

	If !dbSeek(FwxFilial("FIL") + M->E2_FORNECE + M->E2_LOJA + '2' + M->E2_FORBCO + M->E2_FORAGE + M->E2_FORCTA )

		Reclock('FIL',.t.)
		FIL->FIL_FILIAL := fwxFilial()
		FIL->FIL_FORNEC := M->E2_FORNECE
		FIL->FIL_LOJA   := M->E2_LOJA
		FIL->FIL_TIPO   := '2'
		FIL->FIL_BANCO  := M->E2_FORBCO
		FIL->FIL_AGENCI := M->E2_FORAGE
		FIL->FIL_DVAGE	:= M->E2_FAGEDV
		FIL->FIL_CONTA  := M->E2_FORCTA
		FIL->FIL_DVCTA	:= M->E2_FCTADV
		FIL->FIL_MOEDA  := M->E2_MOEDA
		FIL->(MsUnlock())

	EndIf

    FIL->(DBCLOSEAREA())

	RESTAREA(aAreaAnt)

Return lRet

