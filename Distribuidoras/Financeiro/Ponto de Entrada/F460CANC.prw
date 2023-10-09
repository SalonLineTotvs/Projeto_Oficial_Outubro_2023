#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
/*/{Protheus.doc} User Function F460CANC
    (O ponto de entrada F460CANC sera executado antes da entrada na rotina cancelamento de baixa do contas 
     a receber, para verificar se esta pode ou nao ser cancelada.)
    @type  Function
    @author Claudio Gaspar
    @since 13/09/2022
    @version 1.0
  
/*/
User Function F460CANC()
    Local lRet      := .f.
    Local cQueryUC  := ''
    Local nOpcx     := ParamIxb
    
    
    Msgalert(se1->e1_cliente+' '+se1->e1_loja+' '+se1->e1_num+' '+se1->e1_parcela,'Atencao!!!')
   
    If SE1->E1_TIPO = 'NCC'
         If select('TRBSUC') >0
            TRBSUC->(DbCloseArea())
        Endif
                
        cQueryUC := " SELECT UC_FILIAL,UC_CODIGO FROM SUC020 "
        cQueryUC += " WHERE UC_X_NFD = '"+SE1->E1_NUM +"'" 
        cQueryUC += " AND UC_CHAVE = '"  +SE1->(E1_CLIENTE+E1_LOJA)+"'" 
        cQueryUC += " AND UC_FILIAL = '" +SE1->E1_FILIAL+"'"
        TCQUERY cQueryUC NEW ALIAS "TRBSUC"
        
        If select("TRBSUC") > 0 
            If nOpcx == 5 //Estornado
                MsgAlert('atendimento localizado: '+TRBSUC->UC_FILIAL+TRBSUC->UC_CODIGO,'Atencao!!!')

                MsgStop('O Titulo nao pode ser estornado!!!', 'Atencao')
                lRet := .f.  
                
            ElseIf nOpcx == 6  //Excluir]

                MsgStop('O Titulo nao pode ser excluido!!!', 'Atencao')
                lRet := .f. 
           
            EndIf            
        
        Else
            
             MsgStop('atendimento NAO localizado: '+SE1->(E1_CLIENTE+E1_LOJA),'Atencao!!!')

        EndIf

    EndIf    
Return 
