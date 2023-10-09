#INCLUDE "PROTHEUS.CH"
#Include "TOPCONN.CH"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M460FIM                                                                                       |
 | Desc:  Gravação dos dados após gerar NF de Saída                                                     |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784180                                  |
 | Ajustado: Samuel de Vincenzo                                                                         |
 *------------------------------------------------------------------------------------------------------*/
 
User Function M460Fim()
    Local cPedido  := ''
    Local nDContrato   := 0
    Local nDExporadico := 0
    Local nDPrazo      := 0
    Local nDAcordoLog  := 0
    Local nDFreteFob   := 0
    Local vContrato    := 0
    Local vExporadico  := 0
    Local vPrazo       := 0
    Local vAcordoLog   := 0
    Local vFreteFob    := 0
    Local vValorTotal  := 0
    Local vValor       := 0 
    Local QTotTit      := 0
    Local cFormPag	   := " "
    Local nboleto      :="1"

    Local lMsErroAuto  := .F.
    Local aVetor       := {}
    Local aAreaSF2     := SF2->(GetArea())
    Local aAreaSD2     := sd2->(GetArea())
    Local aAreaSC5     := sc5->(GetArea())
    Local aAreaSE1     := sE1->(GetArea())
    Local aAreaSA1     := sA1->(GetArea())
     
    DbSelectArea("SA1")
    DbSetOrder(1)
    If	DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
        //
        cFormPag	:= SA1->A1_X_FORMP
        //
    Endif 
    
    //Pega o pedido
    DbSelectArea("SD2")
    SD2->(DbSetorder(3))
    If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
        cPedido := SD2->D2_PEDIDO
    Endif

    //Se tiver pedido
    If !Empty(cPedido)
        DbSelectArea("SC5")
        SC5->(DbSetorder(1))

        //Se posiciona pega o tipo de pagamento
        If SC5->(DbSeek(FWxFilial('SC5')+cPedido))
           nDContrato   := SC5->C5_X_DCONT
           nDExporadico := SC5->C5_X_DEXPO
           nDPrazo      := SC5->C5_X_DPRAZ
           nDAcordoLog  := SC5->C5_X_DACOR
           nDFreteFob   := SC5->C5_X_DFRET 
        Endif
    Endif

    //Filtra títulos dessa nota
    cSql := "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SE1")
    cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND D_E_L_E_T_<>'*' "
    cSql += " AND E1_PREFIXO = '"+SF2->F2_SERIE+"' AND E1_NUM = '"+SF2->F2_DOC+"' "
    cSql += " AND E1_TIPO = 'NF' "
    TcQuery ChangeQuery(cSql) New Alias "_QRY"

    count TO QTotTit
    _QRY->(DbGoTop())
    //Enquanto tiver dados na query
    While !_QRY->(eof())
        DbSelectArea("SE1")
        SE1->(DbGoTo(_QRY->REC))

        vContrato   := (( SE1->E1_VALOR * nDContrato ) / 100) 
        vExporadico := (( SE1->E1_VALOR * nDExporadico ) / 100) 
        vPrazo      := (( SE1->E1_VALOR * nDPrazo ) / 100) 
        vAcordoLog  := (( SE1->E1_VALOR * nDAcordoLog ) / 100) 
        vFreteFob   := (( SE1->E1_VALOR * nDFreteFob ) / 100) 
        vValor := vContrato + vExporadico + vPrazo + vAcordoLog
        vValorTotal := vContrato + vExporadico + vPrazo + vAcordoLog + vFreteFob
        //Se tiver dado, altera o tipo de pagamento
        If !SE1->(EoF())
            RecLock("SE1",.F.)
                Replace E1_X_FORMP WITH cFormPag
                //lh inicio teste boleto
                if alltrim(cFormPag) == "BOL"
                Replace E1_XBOLETO WITH nBoleto
                Replace E1_BOLETO WITH nBoleto
                endif
                //lh fim teste boleto
                Replace E1_X_DCONT WITH nDContrato
                Replace E1_X_VCONT WITH vContrato
                Replace E1_X_DEXPO WITH nDExporadico
                Replace E1_X_VEXPO WITH vExporadico
                Replace E1_X_DPRAZ WITH nDPrazo
                Replace E1_X_VPRAZ WITH vPrazo
                Replace E1_X_DACOR WITH nDAcordoLog
                Replace E1_X_VACOR WITH vAcordoLog
                Replace E1_X_FRETF WITH nDFreteFob
                Replace E1_X_VFRET WITH vFreteFob
                Replace E1_X_VTOTD WITH vValorTotal
            MsUnlock()
        EndIf

        if (vValor > 0)
            //Efetuo o ExecAuto do Fina070 para dar baixa parcial do valor do Desconto
            aVetor := {{ "E1_PREFIXO"	 ,SE1->E1_PREFIXO             ,Nil},;
                        {"E1_NUM"		 ,SE1->E1_NUM                 ,Nil},;
                        {"E1_PARCELA"	 ,SE1->E1_PARCELA             ,Nil},;
                        {"E1_TIPO"	     ,SE1->E1_TIPO                ,Nil},;
                        {"AUTMOTBX"	     ,"Z01"                       ,Nil},;
                        {"AUTDTBAIXA"	 ,dDataBase                   ,Nil},;
                        {"AUTDTCREDITO"  ,dDataBase                   ,Nil},;
                        {"AUTHIST"	     ,'DESCONTO FINANCEIRO'       ,Nil},;
                        {"AUTVALREC"	 ,0                           ,Nil},;
                        {"AUTDESCONT"	 ,vValor                      ,Nil}}
                        //{"AUTVALREC"	 ,vValor                      ,Nil}}
                        //{"AUTDESCONT"	 ,vValorTotal                 ,Nil},;
                        
            MSExecAuto({|x,y| fina070(x,y)},aVetor,3) //Inclusao
            If lMsErroAuto
	            MOSTRAERRO()
            endif
        Endif            

        if (vFreteFob > 0)
            //Efetuo o ExecAuto do Fina070 para dar baixa parcial do valor do Desconto
            aVetor := {{ "E1_PREFIXO"	 ,SE1->E1_PREFIXO             ,Nil},;
                        {"E1_NUM"		 ,SE1->E1_NUM                 ,Nil},;
                        {"E1_PARCELA"	 ,SE1->E1_PARCELA             ,Nil},;
                        {"E1_TIPO"	     ,SE1->E1_TIPO                ,Nil},;
                        {"AUTMOTBX"	     ,"Z05"                       ,Nil},;
                        {"AUTDTBAIXA"	 ,dDataBase                   ,Nil},;
                        {"AUTDTCREDITO"  ,dDataBase                   ,Nil},;
                        {"AUTHIST"	     ,'DESCONTO FINANCEIRO FRETE' ,Nil},;
                        {"AUTVALREC"	 ,0                           ,Nil},;
                        {"AUTDESCONT"	 ,vFreteFob                   ,Nil}}
                        //{"AUTVALREC"	 ,vFreteFob                   ,Nil}}
                        //{"AUTDESCONT"	 ,vValorTotal                   ,Nil},;

            MSExecAuto({|x,y| fina070(x,y)},aVetor,3) //Inclusao

            If lMsErroAuto
	            MOSTRAERRO()
            endif

        endif

        _QRY->(DbSkip())
    Enddo
    _QRY->(DbCloseArea())

    RestArea(aAreaSF2)
    RestArea(aAreaSD2)
    RestArea(aAreaSC5)
    RestArea(aAreaSE1)
    RestArea(aAreaSA1)
Return
