#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function MT410TOK()
Local lRet := .T.
Local nX := 0
Local cProd  := "AVARIA/EXTRAVIO/FALTA/INVERS�O" //colocar em MV

For nX := 1 To Len(ACOLS)
    If ALLTRIM(ACOLS[nX][2]) $ cProd
        If Empty( M->C5_XATEND) //criar campo para a solicita��o
            lRet := .F.
            MsgAlert("Para pedido de cobran�a � necess�rio preencher o campo Atendimento na aba Observa��es", "MT410TOK...")
            Exit
        EndIf
    EndIf
Next nX

Return lRet
