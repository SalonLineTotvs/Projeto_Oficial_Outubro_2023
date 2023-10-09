#Include "Totvs.ch"

/*/{Protheus.doc} User Function nomeFunction
    (Função para gravação de Atendimento)
    @type  Function
    @author Claudio Gaspar
    @since 16/09/2022
    @version 1.0
    @param param_name, param_type, param_descr
   
    /*/
User Function TMKF001(ccCodigo,;
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
                        aIten) 

        Local aArea     := GetArea()
        Local nX        := 0
      
        DBSelectArea("SUC")
        dbSetOrder(1)

        DBSelectArea("SUD")
        dbSetOrder(1)
                
        
        RecLock("SUC", .t.)
            SUC->UC_FILIAL      := cFilSUC           
            SUC->UC_CODIGO      := cCodigo
            SUC->UC_DATA        := dDatabase                  
            SUC->UC_CODCONT     := cContato   
            SUC->UC_ENTIDAD     := cEntidad                   
            SUC->UC_CHAVE       := cChaveUC                   
            SUC->UC_OPERADO     := cOperador
            SUC->UC_OPERACA     :=  '1'  
            SUC->UC_STATUS      :=  '2'                        
            SUC->UC_INICIO      :=  TIME()                     
            SUC->UC_FIM         :=  TIME()                     
            SUC->UC_PROSPEC     :=  Iif(ValType(lProspect) == 'L',lProspect,Iif(lProspect == 'F',.f.,.t.))                    
            SUC->UC_X_NFD       :=  cUCXNFD         
            SUC->UC_X_ASS       :=  cUCASS                     
            SUC->UC_X_DTA       :=  stod(dUCDta)                     
            SUC->UC_X_ACAO      :=  cUCACAO                    
            SUC->UC_X_DOCOR     :=  cUCDOCOR                   
            SUC->UC_X_REPR      :=  cUCREPR                           
            SUC->UC_X_DTEVE     :=  stod(dUDTEVE)                    
            SUC->UC_X_STMER     :=  cSTMER                     
            SUC->UC_X_NFDVL     :=  nUCXNFDVL          
            SUC->UC_XPAI        :=  cCodAnt        
        SUC->(MsUnlock())  
        
        
        For nX := 1 to len(aIten)
            RecLock("SUD", .t.)
                SUD->UD_FILIAL      :=  cFilSUD                           
                SUD->UD_CODIGO      :=  cCodigo                          
                SUD->UD_ITEM        :=  aIten[nX][03]                          
                SUD->UD_ASSUNTO     :=  aIten[nX][04]                          
                SUD->UD_NNF         :=  aIten[nX][05]                          
                SUD->UD_PRODUTO     :=  aIten[nX][06]                          
                SUD->UD_QTD         :=  aIten[nX][07]                          
                SUD->UD_VLRUNT      :=  aIten[nX][08]                          
                SUD->UD_VLRTOT      :=  aIten[nX][09]                          
                SUD->UD_QTDAJU      :=  aIten[nX][10]                          
                SUD->UD_VLRTOTA     :=  aIten[nX][11]                          
                SUD->UD_OCORREN     :=  aIten[nX][12]                          
                SUD->UD_XSOLUCA     :=  aIten[nX][13]                          
                SUD->UD_DATA        :=  sTod(aIten[nX][14])                          
                SUD->UD_STATUS      :=  aIten[nX][15]                           
                SUD->UD_OBS         := "Atendimento Pai : " + aIten[nX][02]    
                SUD->UD_DTEXEC      :=  sTod(aIten[nX][17]) 
                SUD->UD_X_NNF       :=  aIten[nX][18]                            
                SUD->UD_X_SERIE     :=  aIten[nX][19]                            
                SUD->UD_X_QTD       :=  aIten[nX][20]                            
                SUD->UD_X_VUNIT     :=  aIten[nX][21]                          
                SUD->UD_X_VTOT      :=  aIten[nX][22]                          
                SUD->UD_X_QTAJU     :=  aIten[nX][23]                          
                SUD->UD_X_VTOTD     :=  aIten[nX][24]                          
                SUD->UD_X_TRANS     :=  aIten[nX][25]                          
                SUD->UD_X_TES       :=  aIten[nX][26]                          
                SUD->UD_X_DESCR     :=  aIten[nX][27]                          
                SUD->UD_X_NOMTR     :=  aIten[nX][28]                          
                SUD->UD_XCAMPO1     :=  aIten[nX][29]                          
                SUD->UD_XCAMPO2     :=  aIten[nX][30]                          
                SUD->UD_XCAMPO3     :=  aIten[nX][31]                          
                SUD->UD_XNRMAN      :=  aIten[nX][32]                          
                SUD->UD_XDTNFO      :=  sTod(aIten[nX][33])                          
                SUD->UD_XDTNFD      :=  sTod(aIten[nX][34])                          
                SUD->UD_RESPALT     :=  aIten[nX][35]                          
                SUD->UD_DTFATTR     :=  sTod(aIten[nX][36])                          
                SUD->UD_VLRFTTR     :=  aIten[nX][37]                          
                SUD->UD_VLRPGTR     :=  aIten[nX][38]                          
                SUD->UD_DTPGTR      :=  sTod(aIten[nX][39])                          
                SUD->UD_DTPGTR      :=  sTod(aIten[nX][40])                          
                SUD->UD_XVENCRE     :=  sTod(aIten[nX][41])                          
                SUD->UD_XCANCFI     :=  sTod(aIten[nX][42])                          
                SUD->UD_XTRCONT     :=  aIten[nX][43]                          
                SUD->UD_PDFATTR     :=  aIten[nX][44]                          
                
            SUD->(MsUnlock())
       
        Next nX
        
      
    RestArea(aArea)

Return cCodigo
