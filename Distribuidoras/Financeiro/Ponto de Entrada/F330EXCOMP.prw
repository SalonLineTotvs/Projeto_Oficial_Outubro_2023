#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} F330EXCOMP
Valida exclusão/estorno da compensação
@author  Claudio Gaspar by Moove
@since   13/09/2022
@version 1.0
/*/
//-------------------------------------------------------------------
User Function F330EXCOMP()
    Local cQueryUC      := ''
    Local cQueryUD      := ''
    Local cQueryUDI     := ''
   
    Local ctitulos      := ''
    Local sequencia     := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    Local prxitem       := ''
    Local nOpcao        := ParamIxb[3]  
    Local lRet          := .t.  
    Local titulos       :=''
    Local ultit         := ''
    Local nTit          := 0 
    Local nX            := 0
   
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
   

    Msgalert(se1->e1_cliente+' '+se1->e1_loja+' '+se1->e1_num+' '+se1->e1_parcela,'Atencao!!!')
   
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


        cQueryUDI := " SELECT UD_FILIAL, UD_CODIGO, UD_ITEM, "
        cQueryUDI += " UD_ASSUNTO, UD_NNF, UD_PRODUTO, "
        cQueryUDI += " UD_QTD, UD_VLRUNT, UD_VLRTOT, "
        cQueryUDI += " UD_QTDAJU, UD_VLRTOTA, UD_OCORREN, "
        cQueryUDI += " UD_XSOLUCA, UD_DATA,UD_STATUS, "
        cQueryUDI += " UD_OBS,UD_DTEXEC, UD_X_NNF, "
        cQueryUDI += " UD_X_SERIE,UD_X_QTD, UD_X_VUNIT, "
        cQueryUDI += " UD_X_VTOT,UD_X_QTAJU, UD_X_VTOTD, "
        cQueryUDI += " UD_X_TRANS,UD_X_TES, UD_X_DESCR, "
        cQueryUDI += " UD_X_NOMTR,UD_XCAMPO1, UD_XCAMPO2, "
        cQueryUDI += " UD_XCAMPO3,UD_XNRMAN, UD_XDTNFO, "
        cQueryUDI += " UD_XDTNFD,UD_RESPALT, UD_DTFATTR, "
        cQueryUDI += " UD_VLRFTTR,UD_VLRPGTR, UD_DTPGTR, "
        cQueryUDI += " UD_DTPGTR,UD_XVENCRE, UD_XCANCFI, "
        cQueryUDI += " UD_XTRCONT,UD_PDFATTR "

        cQueryUDI += " FROM " + RetSqlName("SUD") + " SUD"
        cQueryUDI += " WHERE SUD.D_E_L_E_T_  = ' ' "
        cQueryUDI += " AND UD_FILIAL+UD_CODIGO ='"+ TRBSUC->(UC_FILIAL+UC_CODIGO) +"'"
        cQueryUDI += " AND D_E_L_E_T_ = ' '"
        TCQUERY cQueryUDI NEW ALIAS "TRBSUDITEM"
        
        TRBSUDITEM->(DBGoTop())
        
        Do While TRBSUDITEM->(!Eof())
            aAdd(aDados, {TRBSUDITEM->UD_FILIAL         , TRBSUDITEM->UD_CODIGO , TRBSUDITEM->UD_ITEM,;
                            TRBSUDITEM->UD_ASSUNTO      , TRBSUDITEM->UD_NNF    , TRBSUDITEM->UD_PRODUTO,;
                            TRBSUDITEM->UD_QTD          , TRBSUDITEM->UD_VLRUNT , TRBSUDITEM->UD_VLRTOT,;
                            TRBSUDITEM->UD_QTDAJU       , TRBSUDITEM->UD_VLRTOTA, TRBSUDITEM->UD_OCORREN,;
                            TRBSUDITEM->UD_XSOLUCA      , TRBSUDITEM->UD_DATA   , TRBSUDITEM->UD_STATUS,;
                            TRBSUDITEM->UD_OBS          , TRBSUDITEM->UD_DTEXEC , TRBSUDITEM->UD_X_NNF,;
                            TRBSUDITEM->UD_X_SERIE      , TRBSUDITEM->UD_X_QTD  , TRBSUDITEM->UD_X_VUNIT,;
                            TRBSUDITEM->UD_X_VTOT       , TRBSUDITEM->UD_X_QTAJU, TRBSUDITEM->UD_X_VTOTD,;
                            TRBSUDITEM->UD_X_TRANS      , TRBSUDITEM->UD_X_TES  , TRBSUDITEM->UD_X_DESCR,;
                            TRBSUDITEM->UD_X_NOMTR      , TRBSUDITEM->UD_XCAMPO1, TRBSUDITEM->UD_XCAMPO2,;
                            TRBSUDITEM->UD_XCAMPO3      , TRBSUDITEM->UD_XNRMAN , TRBSUDITEM->UD_XDTNFO,;
                            TRBSUDITEM->UD_XDTNFD       , TRBSUDITEM->UD_RESPALT, TRBSUDITEM->UD_DTFATTR,;
                            TRBSUDITEM->UD_VLRFTTR      , TRBSUDITEM->UD_VLRPGTR, TRBSUDITEM->UD_DTPGTR,; 
                            TRBSUDITEM->UD_DTPGTR       , TRBSUDITEM->UD_XVENCRE, TRBSUDITEM->UD_XCANCFI,;
                            TRBSUDITEM->UD_XTRCONT      , TRBSUDITEM->UD_PDFATTR})
     
            TRBSUDITEM->(dbSkip())
     
        EndDo
        
         
        If select("TRBSUC") > 0 
            MsgAlert('atendimento localizado: '+TRBSUC->UC_FILIAL+TRBSUC->UC_CODIGO,'Atencao!!!')
            If nOpcao == 5 //Estorno		    
           
                If TRBSUC->UC_STATUS <> '3'
                    
                    For nX := 1 to len(aTitulos)
                           cTitulos +=  aTitulos[nx][07] + '/' 
                    Next nx
            
                    If substr(trbsud->atendimento,12,1) <> "Z"
                        prxitem := substr(trbsud->atendimento,11,1) + substr(sequencia,AT(substr(trbsud->atendimento,12,1),sequencia)+1,1)
                    Else 
                        prxitem := substr(sequencia,AT(substr(trbsud->atendimento,11,1),sequencia)+1,1) + Substr(sequencia,1,1)
                    EndIf
                    /*
                    DBSELECTAREA('SUD')
                    RECLOCK('SUD',.T.)
                        UD_FILIAL := TRBSUC->UC_FILIAL
                        UD_ITEM := prxitem // 2 podicoes
                        UD_CODIGO := TRBSUC->UC_CODIGO
                        
                        If TRBSUC->UC_FILIAL $ '0101/1101/0301/0801/0501/0701/0901/0401/'
                            UD_ASSUNTO := '000009'
                            UD_OCORREN := '000093'
                            UD_XSOLUCA := '000008'
                        EndIf
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

                        UD_OBS      := 'COMPENSACAO ESTORNADA Nf: '+ ctitulos
                        UD_DATA     := DDATABASE
                        UD_STATUS   := '1'
                        UD_DTEXEC   :=DDATABASE
                        UD_RESPALT  := UsrFullName(__cUserID)+''+time()+''+dtoc(date())
                        
                    MSUNLOCK()
                    
                    DBCOMMIT()

                    RecLock("SE1",.F.)
                        SE1->E1_XCALL   := TRBSUC->UC_CODIGO
                    MsUnLock()
                    */
                    U_TMKF002(TRBSUC->UC_FILIAL,;
                            prxItem,;
                            TRBSUC->UC_CODIGO,;
                            cTitulos,;
                            '2',;
                            cAssumEs,;
                            cOcorrEs,;
                            cSolucEs)
      
                else
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
                            
                            
                            titulos:=''
                            ultit := ''
                            
                            For nTit := 1 to Len(aTitulos)
                                                            
                                 
                                 U_TMKF002(aTitulos[nTit][12],;
                                        Substr(aTitulos[nTit][08],2,1) + 'C',;
                                        cCodAtu,;
                                        ' NF : ' + aTitulos[nTit][07] + ' VALOR : ' + aTitulos[nTit][10] + ' Venc: ' + aTitulos[nTit][06],;
                                        '2',;
                                        cAssumEs,;
                                        cOcorrEs,;
                                        cSolucEs)
                            
                            next nTit                           
                    
                        else
                            lRet := .f.            
                        EndIf
                        
                        ConfirmSx8()

                    End Transaction
                
                EndIf

            ElseIf nOpcao == 4 //Exclusao	 
                MsgStop("O titulo nao pode ser excluido!!!", "Atencao!!!")
                lRet := .f.        
            EndIf            
        Else        
            MsgStop('atendimento NAO localizado: '+SE1->(E1_CLIENTE+E1_LOJA),'Atencao!!!')           
                  
        EndIf        
       
    EndIf

Return lRet
