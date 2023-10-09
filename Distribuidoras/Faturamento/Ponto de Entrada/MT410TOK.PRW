#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function MT410TOK()
Local lRet := .T.
Local nX := 0
Local cProd  := "AVARIA/EXTRAVIO/FALTA/INVERSÃO" //colocar em MV

For nX := 1 To Len(ACOLS)
    If ALLTRIM(ACOLS[nX][2]) $ cProd
        If Empty( M->C5_XATEND) //criar campo para a solicitação
            lRet := .F.
            MsgAlert("Para pedido de cobrança é necessário preencher o campo Atendimento na aba Observações", "MT410TOK...")
            Exit
        EndIf
    EndIf
Next nX

Return lRet
