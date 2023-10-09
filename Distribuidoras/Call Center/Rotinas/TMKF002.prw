/*/{Protheus.doc} User Function TMKF002
    (long_description)
    @type  Function
    @author Claudio Gaspar
    @since 20/09/2022
    @version 1.0   
    /*/
User Function TMKF002(cFilSUD,;
                        prxItem,;
                        cCodAtu,;
                        cTitulo,;
                        cOpcao,;
                        cAssumBx,;
                        cOcorrBx,;
                        cSolucBx)
                    
    Local aArea     := GetArea()
      
    DbSelectArea('SUD')
    
    RecLock('SUD', .t.)
        UD_FILIAL   := cFilSUD //TRBSUC->UC_FILIAL
        UD_ITEM     := prxitem // 2 podicoes
        UD_CODIGO   := cCodAtu
        
        UD_ASSUNTO := cAssumBx
        UD_OCORREN := cOcorrBx
        UD_XSOLUCA := cSolucBx
        
        If  cOpcao      == '1' 
            UD_OBS      := 'TITULO BAIXADO : ' + cTitulo  + ' NCC' //+ ' NATUREZA : ' + cNaturez +  ' VENCIMENTO: ' + dToc(dVenc) + ' HIST: ' + cHist
        ElseIf  cOpcao  == '2'
            UD_OBS      := 'ESTORNO DE ABAT CONC: ' + ctitulo   
        ElseIf  cOpcao  == '3'
            UD_OBS      :='ESTORNO DO ABATIMENTO: ' + ctitulo
        ElseIf  cOpcao  == '4'
            
            UD_OBS      := 'ABAT CONC Nf: ' + ctitulo
        
        EndIf    
        
        UD_DATA     := DDATABASE
        UD_STATUS   := '1'
        UD_DTEXEC   := DDATABASE
        UD_RESPALT  := UsrFullName(__cUserID)+''+time()+''+dtoc(date())
        
    MsUnlock()

    DBCOMMIT()

    RecLock("SE1",.F.)
        SE1->E1_XCALL   := cCodAtu
    MsUnLock()    

    RestArea(aArea)

Return 
