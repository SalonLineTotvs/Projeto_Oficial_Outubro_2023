#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function FA070CA3
    (O ponto de entrada FA070CA3 sera executado antes da entrada na rotina cancelamento de baixa do contas 
     a receber, para verificar se esta pode ou nao ser cancelada.)
    @type  Function
    @author Claudio Gaspar
    @since 13/09/2022
    @version 1.0
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FA070CA3()
    Local lRet      := .t.
    Local cQueryUC  := ''
    Local ctitulo   := ''
    Local sequencia := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    Local nOpcx     := ParamIxb

     
    Local cContato  := ''    //Contato
    Local cEntidad  := ''    //Entidade
    Local cChaveUC  := ''    //Codigo e Loja da Entidade
    Local cOperador := ''
    Local cLigacao  := ''
    Local cCodObs   := ''    
    Local lProspect := .f.    
    Local cUCXNFD   := ''    
    Local cUCNFO    := ''    
    Local cUCASS    := ''    
    Local dUCDta    := cTod("")  
    Local cUCACAO   := ''
    Local cUCDOCOR  := ''
    Local cUCREPR   := ''
    Local dUDTEVE   := ''
    Local nUCXNFDVL := 0
    Local cSTMER    := ''
    Local cCodAtu   := ''
  
    Local aDados    := {}

    Local cAssumEs      := SuperGetMV('FS_ASSEST'   ,.f.,'000003')
    Local cOcorrEs      := SuperGetMV('FS_OCOEST'   ,.f.,'198')
    Local cSolucEs      := SuperGetMV('FS_SOLEST'   ,.f.,'000382')
   

    
    //Msgalert(se1->e1_cliente+' '+se1->e1_loja+' '+se1->e1_num+' '+se1->e1_parcela,'Atencao!!!')
    
    ctitulo := se1->e1_num+' '+se1->e1_parcela

    If SE1->E1_TIPO = 'NCC'
         If select('TRBSUC') >0
            TRBSUC->(DbCloseArea())
        Endif
        
        If select('TRBSUD') >0
            TRBSUD->(DbCloseArea())
        Endif

        If select('TRBSUDITEM') >0
            TRBSUDITEM->(DbCloseArea())
        Endif

        cQueryUC    := " SELECT UC_FILIAL,UC_CODIGO, UC_CODCONT, "       
        cQueryUC    += " UC_STATUS, UC_ENTIDAD, UC_OPERADO, UC_OPERACA,  "
        cQueryUC    += " UC_CHAVE,UC_CODOBS, UC_PROSPEC, UC_X_NFD, " 
        cQueryUC    += " UC_X_NFO , UC_X_ASS, UC_X_DTA, " 
        cQueryUC    += " UC_X_ACAO ,UC_X_DOCOR, UC_X_REPR, " 
        cQueryUC    += " UC_X_NRMA ,UC_X_DTEVE, UC_X_FINAN, " 
        cQueryUC    += " UC_X_CVEND ,UC_X_NRPS, UC_X_ERPS, " 
        cQueryUC    += " UC_X_CRPS ,UC_XMAN, UC_XDTNFO, " 
        cQueryUC    += " UC_XDTNFD ,UC_X_NFDVL, UC_X_STMER " 
        cQueryUC    += " FROM " + RetSqlName("SUC") + " SUC"
        cQueryUC    += " WHERE UC_X_NFD = '"+SE1->E1_NUM +"'" 
        cQueryUC    += " AND UC_CHAVE = '"  +SE1->(E1_CLIENTE+E1_LOJA)+"'" 
        cQueryUC    += " AND UC_FILIAL = '" +SE1->E1_FILIAL+"'"
        cQueryUC    += " AND UC_XPAI = ' '"
        cQueryUC    += " AND SUC.D_E_L_E_T_ = ' '"
        TCQUERY cQueryUC NEW ALIAS "TRBSUC"

        cContato    := TRBSUC->UC_CODCONT    
        cEntidad    := TRBSUC->UC_ENTIDAD    //Entidade
        cChaveUC    := TRBSUC->UC_CHAVE    //Codigo e Loja da Entidade
        cOperador   := TRBSUC->UC_OPERADO
        cLigacao    := TRBSUC->UC_OPERACA    
        cCodObs     := TRBSUC->UC_CODOBS    
        lProspect   := TRBSUC->UC_PROSPEC    
        cUCXNFD     := TRBSUC->UC_X_NFD    
        cUCNFO      := TRBSUC->UC_X_NFO    
        cUCASS      := TRBSUC->UC_X_ASS    
        dUCDta      := TRBSUC->UC_X_DTA
        cUCACAO     := TRBSUC->UC_X_ACAO
        cUCDOCOR    := TRBSUC->UC_X_DOCOR
        cUCREPR     := TRBSUC->UC_X_REPR
        dUDTEVE     := TRBSUC->UC_X_DTEVE
        nUCXNFDVL   := TRBSUC->UC_X_NFDVL
        cSTMER      := TRBSUC->UC_X_STMER
        cCodAnt     := TRBSUC->UC_CODIGO
        
       
        cQueryUD := " SELECT MAX(UD_FILIAL+UD_CODIGO+ UD_ITEM) AS ATENDIMENTO FROM SUD020 "
        cQueryUD += " WHERE SUD020.D_E_L_E_T_  = ' ' "
        cQueryUD += " AND UD_FILIAL+UD_CODIGO ='"+ TRBSUC->(UC_FILIAL+UC_CODIGO) +"'"
        TCQUERY cQueryUD NEW ALIAS "TRBSUD"
        
        If select("TRBSUC") > 0 
            If nOpcx == 5 //Cancelamento Baixa
                If TRBSUC->UC_STATUS <> '3'
                MsgAlert('atendimento localizado: '+TRBSUC->UC_FILIAL+TRBSUC->UC_CODIGO,'Atencao!!!')
           
                If substr(trbsud->atendimento,12,1) <> "Z"
                    prxitem := substr(trbsud->atendimento,11,1) + substr(sequencia,AT(substr(trbsud->atendimento,12,1),sequencia)+1,1)
                Else 
                    prxitem := substr(sequencia,AT(substr(trbsud->atendimento,11,1),sequencia)+1,1) + Substr(sequencia,1,1)
                EndIf
                /*
                DBSELECTAREA('SUD')
                RECLOCK('SUD',.T.)
                    UD_FILIAL   := TRBSUC->UC_FILIAL
                    UD_ITEM     := prxitem // 2 podicoes
                    UD_CODIGO   := TRBSUC->UC_CODIGO
                    //
//                    If TRBSUC->UC_FILIAL $ '0101/1101/0301/0801/0501/0701/0901/0401/'
                        UD_ASSUNTO := SuperGetMV('FS_ASS01',.f.,'000009')
                        UD_OCORREN := SuperGetMV('FS_OCO01',.f.,'000093')
                        UD_XSOLUCA := SuperGetMV('FS_SOL01',.f.,'000008')
/*                    EndIf
                    If TRBSUC->UC_FILIAL $ '0201/'
                        UD_ASSUNTO := '000022'
                        UD_OCORREN := '000130'
                        UD_XSOLUCA := '000197'
                    ENDIF
                    If TRBSUC->UC_FILIAL $ '0601'
                        UD_ASSUNTO := '000017'
                        UD_OCORREN := '000107'
                        UD_XSOLUCA := '000167'
                    EndIf
                    
                    If TRBSUC->UC_FILIAL $ '1201/1301/'
                        UD_ASSUNTO := '000026'
                        UD_OCORREN := '000158'
                        UD_XSOLUCA := '000285'
                    EndIf
                    UD_OBS      := 'ESTORNO DO ABATIMENTO: '+ ctitulo
                    UD_DATA     := DDATABASE
                    UD_STATUS   := '1'
                    UD_DTEXEC   :=DDATABASE
                    UD_RESPALT  := UsrFullName(__cUserID)+''+time()+''+dtoc(date())
                    
                
                    DBCOMMIT()

                    RecLock("SE1",.F.)
                        SE1->E1_XCALL   := TRBSUC->UC_CODIGO
                    MsUnLock()
                  */
                  
                  U_TMKF002(TRBSUC->UC_FILIAL,;
                            prxItem,;
                            TRBSUC->UC_CODIGO,;
                            ctitulo,;
                            '3',;
                            cAssumEs,;
                            cOcorrEs,;
                            cSolucEs)
                Else
                    Begin Transaction
        
                        cCodigo     :=  GetSxeNum("SUC","UC_CODIGO")
                        cFilSUC     :=  FwxFilial("SUC")
                        cFilSUD     :=  FwxFilial("SUD")

                        //Executa função do Milton    
                        cCodAtu := U_TMKF001(cCodigo,;
                                                cFilSUC,;
                                                cFilSUD,;                                   
                                                cContato,;    //Contato
                                                cEntidad,;    //Entidade
                                                cChaveUC,;    //Codigo e Loja da Entidade
                                                cUCXNFD,;
                                                cUCASS,;
                                                dUCDta,;
                                                cUCACAO,;
                                                cUCDOCOR,;                      
                                                cUCREPR,;
                                                dUDTEVE,;
                                                cSTMER,;
                                                nUCXNFDVL,;
                                                lProspect,;
                                                COPERADOR,;
                                                cCodAnt,;
                                                aDados)       


                        
                        If !Empty(cCodAtu)
                            If substr(trbsud->atendimento,12,1) <> "Z"
                                prxitem := substr(trbsud->atendimento,11,1) + substr(sequencia,AT(substr(trbsud->atendimento,12,1),sequencia)+1,1)
                            Else 
                                prxitem := substr(sequencia,AT(substr(trbsud->atendimento,11,1),sequencia)+1,1) + Substr(sequencia,1,1)
                            EndIf
                                                      
                           U_TMKF002(cFilSUD,;
                                prxItem,;
                                cCodAtu,;
                                cTitulo,;
                                '3',;
                                cAssumEs,;
                                cOcorrEs,;
                                cSolucEs)
                    
                        else
                            lRet := .f.            
                        EndIf
                        
                        ConfirmSx8()

                    End Transaction
                   
                EndIf
            ElseIf nOpcx == 6  //Excluir]

                MsgStop('O Titulo nao pode ser excluido, pois há um atendimento vinculado!!!', 'Atencao')
                lRet := .f. 
           
            EndIf            
        
        Else
            
             MsgStop('atendimento nao localizado: '+SE1->(E1_CLIENTE+E1_LOJA),'Atencao!!!')

        EndIf

    EndIf
    
Return lRet
