*---------------------------------------------------------------*
#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"

//********************************************************
// Programa - Retira os Produtos dos Pedido de Venda
// Solicitação - Claudia 
// Autor - Rogerio/Andre Salgado  / Introde - 30/08/2021
//********************************************************

/*----------------------*/
User Function CanCarg2()
/*----------------------*/
// FUNCAO PRINCIPAL DO SISTEMA
Private cProduto := space(6)
DEFINE DIALOG   oDlg TITLE "Apagar Item vindo da LOGISTICA !!!" FROM 000,000 TO 200,230 PIXEL
@ 25,10 say "Produto:" of oDlg Pixel
@ 25,50 MsGet oGet Var cProduto F3 'SB1'   of oDlg Picture "@!" Pixel //
@ 50,50 BUTTON 'Confirmar' SIZE 30,11 PIXEL OF oDlg ACTION (mv_par01:=cProduto, oDlg:End())
ACTIVATE DIALOG oDlg CENTERED

if substr(cProduto,1,6) = SPACE(6)
    alert('Produto nao informado')
    return
endif

if !sb1->(dbseek(xfilial('SB1')+substr(cProduto,1,6))) 
    alert('Produto nao encontrado')
    return
endif

MsgRun("Selecionando registros, Aguarde...","",{|| CursorWait(), libcarga() ,CursorArrow()})
Return

/*********************/
static function libcarga()
/*********************/
If ApMsgYesNo("Confirma Eliminacao do Item LOGISTICA:"+ cProduto +" nos pedidos a partir de: "+dtoc(firstday(ddatabase)) +" ?") 
        cQuery1 := " UPDATE SC6020 SET D_E_L_E_T_='*', C6_UM='' "
        cQuery1 += " FROM SC6020 C5 "
        cQuery1 += " INNER JOIN SC5020 C6 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_X_STAPV='1' AND C5_NOTA=' ' AND C6.D_E_L_E_T_=' ' "
        cQuery1 += " AND C6_PRODUTO = '"+ cProduto + "'" 
        cQuery1 += " WHERE "
        cQuery1 += " C5.D_E_L_E_T_=' ' "
        cQuery1 += " AND C5_NOTA  =' ' "
        cQuery1 += " AND C5_EMISSAO BETWEEN '"+ dtos(firstday(ddatabase))+"' AND '"+  dtos(lastday(ddatabase)) +"' "
        cQuery1 += " AND C6_PRODUTO = '"+ cProduto +"'" 
        cQuery1 += " AND C6_NOTA    = ' ' "

        cQuery1 += " UPDATE SC9020 SET D_E_L_E_T_='*' "
        cQuery1 += " FROM SC9020 C9 "
        cQuery1 += " INNER JOIN SC5020 C5 ON C5_FILIAL=C9_FILIAL AND C5_NUM=C9_PEDIDO AND C5_X_STAPV='1' AND C5_NOTA=' ' AND C5.D_E_L_E_T_=' ' "
        cQuery1 += " AND C9_PRODUTO = '"+ cProduto + "'" 
        cQuery1 += " WHERE "
        cQuery1 += " C9.D_E_L_E_T_=' ' "
        cQuery1 += " AND C9_NFISCAL =' ' "
        cQuery1 += " AND C5_EMISSAO BETWEEN '"+ dtos(firstday(ddatabase))+"' AND '"+  dtos(lastday(ddatabase)) +"' "
        cQuery1 += " AND C9_PRODUTO = '"+ cProduto +"'" 
        cQuery1 += " AND C9_NFISCAL = ' ' "

        cTime 	:= SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)
        MemoWrit("C:\Temp\Log_"+cTime+".TXT",cQuery1)
        
        nStatus1 := TCSqlExec(cQuery1)
        if (nStatus1 < 0)
            conout("TCSQLError() " + TCSQLError())
        endif
        MsgInfo('Processo concluido para o item: '+cProduto)
Endif      
Return
