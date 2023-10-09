#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function F070BTOK
    O ponto de entrada F070BTOK será habilitado na confirmação da baixa conta a receber
    @type  Function
    @author Claudio Gaspar by Moove
    @since 13/09/2022
    @version 1.0
/*/

User Function F070BTOK()
    Local cQueryUC  := ''
    Local cQueryUD   := ''
    Local cQueryUDI := ''
    Local cTitulo   := ''
    Local sequencia := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    Local prxitem   := ''
    Local lRet      := .t.
    
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
    Local cAssumBx      := SuperGetMV('FS_ASSBX' ,.f.,'000009')
    Local cOcorrBx      := SuperGetMV('FS_OCOBX' ,.f.,'000093')
    Local cSolucBxN     := SuperGetMV('FS_SOLBXN',.f.,'000380')
    Local cSolucBxD     := SuperGetMV('FS_SOLBXD',.f.,'000381')
    Local cSolucBx      := ''
    
    Local aDados    := {}
     
    cFilSE1     :=  SE1->E1_FILIAL
    cTitulo     :=  SE1->E1_NUM 
    cPrefixo    :=  SE1->E1_PREFIXO
    cParcela    :=  SE1->E1_PARCELA
    cNaturez    :=  SE1->E1_NATUREZ
    dVenc       :=  SE1->E1_VENCTO
    cHist       :=  SE1->E1_HIST
    
    If SE1->E1_TIPO = 'NCC'
        //DbSelecArea(xFilial('SUD'))
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
        
        
        cQueryUD := " SELECT MAX(UD_FILIAL+UD_CODIGO+ UD_ITEM) AS ATENDIMENTO FROM " + RetSqlName("SUD") + " SUD"
        cQueryUD += " WHERE SUD.D_E_L_E_T_  = ' ' "
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
             
        If ("TRBSUC")->(!EOF()) 
            MsgAlert('atendimento localizado: '+TRBSUC->UC_FILIAL+TRBSUC->UC_CODIGO,'Atencao!!!')
                
            If Alltrim(cMOTBX)       == 'NORMAL'
                cSolucBx := cSolucBxN
            ElseIf Alltrim(cMOTBX)   == 'DACAO'
                cSolucBx := cSolucBxD
            EndIf
        
            If TRBSUC->UC_STATUS <> '3'
                If substr(trbsud->atendimento,12,1) <> "Z"
                    prxitem := substr(trbsud->atendimento,11,1) + substr(sequencia,AT(substr(trbsud->atendimento,12,1),sequencia)+1,1)
                Else 
                    prxitem := substr(sequencia,AT(substr(trbsud->atendimento,11,1),sequencia)+1,1) + Substr(sequencia,1,1)
                EndIf
                
                
                U_TMKF002(TRBSUC->UC_FILIAL,;
                            prxItem,;
                            TRBSUC->UC_CODIGO,;
                            cTitulo,;
                            '1',;
                            cAssumBx,;
                            cOcorrBx,;
                            cSolucBx)
      
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
                                '1',;
                                cAssumBx,;
                                cOcorrBx,;
                                cSolucBx)                
                    else
                        lRet := .f.            
                    EndIf
                    
                    ConfirmSx8()

                End Transaction
             
            EndIf
       
        Else
            lRet := MsgYesNo('atendimento nao localizado: '+SE1->(E1_CLIENTE+E1_LOJA),'Atencao!!!')
        EndIf        
       
    EndIf    
Return lRet

