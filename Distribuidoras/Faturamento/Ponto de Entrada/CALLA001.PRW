#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function CALLA001()

Local lRet      := .T.
//Local cCliente  := M->C5_CLIENTE
//Local cLojaCli  := M->C5_LOJACLI
Local cAtendi   := M->C5_XATEND

DbSelectArea("SUC")
("SUC")->(DbSetOrder(1))

If ! ("SUC")->(Dbseek(cFilAnt+cAtendi))

lRet := .F.
MsgAlert("Não foi possível localizar o número de atendimento informado na empresa logada.", "CALLA001 - Atenção!")

EndIf

Return lRet
