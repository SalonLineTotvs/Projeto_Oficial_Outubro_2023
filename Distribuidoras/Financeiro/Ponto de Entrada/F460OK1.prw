#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function F460OK1
    O ponto de entrada F070BTOK será habilitado na confirmação da baixa a receber
    @type  Function
    @author Claudio Gaspar by Moove
    @since 13/09/2022
    @version 1.0
/*/

User Function F460OK1()
    Local cQueryUC  := ''
    Local lRet      := .t.
   
    Msgalert(se1->e1_cliente+' '+se1->e1_loja+' '+se1->e1_num+' '+se1->e1_parcela,'Atencao!!!')
   
    If SE1->E1_TIPO = 'NCC'
        If select('TRBSUC') >0
            TRBSUC->(DbCloseArea())
        Endif
        
        If select('TRBSUD') >0
            TRBSUD->(DbCloseArea())
        Endif

        cQueryUC := " SELECT UC_FILIAL,UC_CODIGO FROM SUC020 "
        cQueryUC += " WHERE UC_X_NFD = '"+SE1->E1_NUM +"'" 
        cQueryUC += " AND UC_CHAVE = '"  +SE1->(E1_CLIENTE+E1_LOJA)+"'" 
        cQueryUC += " AND UC_FILIAL = '" +SE1->E1_FILIAL+"'"
        TCQUERY cQueryUC NEW ALIAS "TRBSUC"

       
        If select("TRBSUC") > 0 
            
            MsgStop('O processo de liquidez nao pode ser aplicado, pois há um atendimento','Atencao!!!')
            
            lRet := .f.
                      
        Else
            MsgStop('atendimento nao localizado: '+SE1->(E1_CLIENTE+E1_LOJA),'Atencao!!!')
        EndIf        
       
    EndIf    
Return  lRet
