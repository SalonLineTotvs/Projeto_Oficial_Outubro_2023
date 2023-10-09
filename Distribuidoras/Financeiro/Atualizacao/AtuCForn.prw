#include "Totvs.CH"

/*/{Protheus.doc} User Function AtuCont
    INclui as contas dos Fornecedores na Tabela FIL
    @type  Function
    @author Samuel de Vincenzo
    @since 08/11/2022
    @version 1.0
/*/
User Function AtuCont()
	

	FWMsgRun(, { |oSay| fprocessa()}, "Processando", "Realizando a Integração das constas dos fornecedores")


Return

static function fProcessa()
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaFIL  := FIL->(GetArea())
	Local bInsert   := .T.
    Local cQry      := ""
    
    Private cAlias  := "FIL"

	
    cQry    := "SELECT A2_COD, A2_LOJA, A2_BANCO, A2_AGENCIA, A2_DVAGE, "
    cQry    += "A2_NUMCON, A2_DVCTA, A2_TIPCTA " 
    cQry    += "FROM "+RetSqlName("SA2")  + CRLF
    cQry    += " WHERE A2_BANCO <> '' AND D_E_L_E_T_ = ''" +CRLF
    
    PLSQuery(cQry, 'QRYDADTMP')

    DbSelectArea('QRYDADTMP')
    QRYDADTMP->(DBGOTOP())

	while ! QRYDADTMP->(EOF())

		
        RecLock(cAlias, .T.)
            (cAlias)->FIL_FILIAL := xFilial("FIL")
            (cAlias)->FIL_FORNEC := QRYDADTMP->A2_COD
            (cAlias)->FIL_LOJA   := QRYDADTMP->A2_LOJA
            (cAlias)->FIL_TIPO   := '1'
            (cAlias)->FIL_BANCO  := QRYDADTMP->A2_BANCO
            (cAlias)->FIL_AGENCI := QRYDADTMP->A2_AGENCIA
            (cAlias)->FIL_DVAGE	 := QRYDADTMP->A2_DVAGE
            (cAlias)->FIL_CONTA  := QRYDADTMP->A2_NUMCON
            (cAlias)->FIL_DVCTA	 := QRYDADTMP->A2_DVCTA
            (cAlias)->FIL_MOEDA  := 1
            (cAlias)->FIL_TIPO   := '1'
            (cAlias)->FIL_DETRAC := '1'
            (cAlias)->FIL_TIPCTA := IIF(!Empty(QRYDADTMP->A2_TIPCTA), QRYDADTMP->A2_TIPCTA, "1")

            (cAlias)->(MsUnlock())

		QRYDADTMP->(DBSKIP())
	end
	RestArea(aAreaSA2)
	RestArea(aAreaFIL)
return
