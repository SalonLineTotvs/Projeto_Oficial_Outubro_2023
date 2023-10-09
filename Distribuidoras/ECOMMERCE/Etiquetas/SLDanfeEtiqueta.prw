#Include 'protheus.ch'
#Include 'fwprintsetup.ch'
#Include 'rptdef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} ImpDfEtq
Impressão de danfe simplificada - Etiqueta

@param		cUrl			Endereço do Web Wervice no TSS
            cIdEnt			Entidade do TSS para processamento
			lUsaColab		Totvs Colaboração ou não
/*/
//-------------------------------------------------------------------
*----------------------------------*
User function zAutoNFEtq(_cDocSirie)
*----------------------------------*
Default _cDocSirie := '000062385'

If Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("02","1501")
Endif

Private lUsaColab := .F.
Private cIdEnt    := RetIdEnti()
Private cUrl      := Padr( GetNewPar("MV_SPEDURL",""), 250 )

DbSelectArea('SF2');SF2->(DbSetOrder(1))
IF !SF2->(DbSeek(xFilial('SF2')+_cDocSirie))
    RETURN
ENDIF

IF ExistBlock("zImpPvEtq")
	ExecBlock("zImpDfEtq",.F.,.F.,{cUrl, cIdEnt, lUsaColab})
ENDIF
RETURN

*----------------------------------------------*
USer function zImpDfEtq(cUrl, cIdEnt, lUsaColab)
*----------------------------------------------*
    Local lOk        := .F.
    Local aArea      := {}
    Local cNotaIni   := ""
    Local cNotaFim   := ""
    Local cSerie     := ""
    Local dDtIni     := ctod("")
    Local dDtFim     := ctod("")
    Local nTipoDoc   := 0
    Local nTipImp    := 0
    Local cLocImp    := ""
    Local nTamSerie  := 0
    Local lSdoc      := .F.
    Local cAliasQry  := ""
    Local cWhere     := ""
    Local lMv_Logod  := .F.
	Local cLogo      := ""
	Local cLogoD	 := ""
    Local oPrinter   := nil
    Local oSetup     := nil
    Local nLinha     := 0
    Local nColuna    := 0
    Local cGrpCompany:= ""
    Local cCodEmpGrp := ""
    Local cUnitGrp	 := ""
    Local cFilGrp	 := ""
    Local cDescLogo  := ""
    Local oFontTit   := nil
    Local oFontInf   := nil
    Local aParam     := {}
	Local aNotas     := {}
    Local cAviso     := ""
	Local cErro      := ""
    Local nNotas     := 0
    Local cProtocolo := ""
    Local cDpecProt  := ""
    Local cNota      := ""
	Local cXml       := ""
    Local oTotal     := nil
    Local cTotNota   := ""
    Local cHautNfe   := ""
    Local dDautNfe   := ctod("")
    Local aNFe       := {}
    Local aEmit      := {}
    Local aDest      := {}
    Local cCgc       := ""
    Local cNome      := ""
    Local cInscr     := ""
    Local cUF        := ""
    Local nContDanfe := 0
    Local lSeek      := .F.
    Local cCodCliFor := ""
    Local cLoja      := ""

    Local lAdjustToLegacy := .F. 
    Local lDisableSetup  := .T.

    Default cUrl      := PARAMIXB[1]
    Default cIdEnt    := PARAMIXB[2]
    Default lUsaColab := PARAMIXB[3]

    Private oRetNF   := nil
    Private oNFe     := nil

    //Impressão automatica NORMAL_______________________
    Private _cImpt_Nor  := ''//'ZDesigner ZM400 200 dpi (ZPL)'
    //Impressão automatica TERMICA
    Private _cImpt_Ter  := '000001'

    Private _cSpool  := _cImpt_Nor
    Private _cCB5Def := _cImpt_Ter

    Private _lSemValor := .F.

    //Local de Impressao
    Private cPathEst    := Alltrim(GetMv("MV_DIREST"))
    Private _lAutoPrd   := .T.

    //begin sequence

    aArea := getArea()

    dbSelectArea("CB5"); CB5->(DbSetOrder(1))

    Pergunte("NFDANFETIQ",.F.)

    cNotaIni    := SF2->F2_DOC      // Nota Inicial
    cNotaFim    := SF2->F2_DOC      // Nota Final
    cSerie      := SF2->F2_SERIE    // Serie
    dDtIni      := SF2->F2_EMISSAO  // Data de emissão Inicial
    dDtFim      := SF2->F2_EMISSAO  // Data de emissão Final
    nTipoDoc    := 2                // Tipo de Operação (1 - Entrada / 2 - Saída)
    nTipImp     := IIF(!Empty(_cCB5Def),1,2)// Tipo de Impressora (1 - Térmica / 2 - Normal)
    cLocImp     := _cCB5Def         // Impressora 

    //Ajusta parametros padrÃ£o (default)	
    SetMVValue("NFDANFETIQ","MV_PAR01", cNotaIni)				 
    SetMVValue("NFDANFETIQ","MV_PAR02", cNotaFim)
    SetMVValue("NFDANFETIQ","MV_PAR03", SF2->F2_SERIE)
    SetMVValue("NFDANFETIQ","MV_PAR04", SF2->F2_EMISSAO)
    SetMVValue("NFDANFETIQ","MV_PAR05", SF2->F2_EMISSAO)
    SetMVValue("NFDANFETIQ","MV_PAR06", nTipoDoc)
    //SetMVValue("NFDANFETIQ","MV_PAR07", nTipImp)
    //SetMVValue("NFDANFETIQ","MV_PAR08", cLocImp)

    IF !_lAutoPrd
        IF !Pergunte("NFDANFETIQ",.T.)
            break
        ENDIF
    ENDIF

    Pergunte("NFDANFETIQ",.F.)
    cNotaIni    := MV_PAR01 // Nota Inicial
    cNotaFim    := MV_PAR02 // Nota Final
    cSerie      := MV_PAR03 // Serie
    dDtIni      := MV_PAR04 // Data de emissão Inicial
    dDtFim      := MV_PAR05 // Data de emissão Final
    nTipoDoc    := MV_PAR06 // Tipo de Operação (1 - Entrada / 2 - Saída)
    nTipImp     := MV_PAR07 // Tipo de Impressora (1 - Térmica / 2 - Normal)
    cLocImp     := MV_PAR08 // Impressora 
    //ENDIF

    // Validações para impressoras termicas
    if nTipImp == 1
        if Empty(cLocImp)
     		Help(NIL, NIL, "Local de impressão não informado.", NIL, "Informe um Local de impressão cadastrado., Acesse a rotina 'Locais de Impressão'.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"}) //, 
            break
        ELSE
            CB5->(dbSetOrder(1))
            if !CB5->(DbSeek( xFilial("CB5") + padR(cLocImp, GetSX3Cache("CB5_CODIGO", "X3_TAMANHO")) )) .or. !CB5SetImp(cLocImp)
                Help(NIL, NIL, "Local de impressão não encontrado," + " - " + Alltrim(cLocImp) + ".", NIL, "Informe um Local de impressão cadastrado., Acesse a rotina 'Locais de Impressão'.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"}) //Local de impressão não encontrado, Informe um Local de impressão cadastrado., Acesse a rotina 'Locais de Impressão'.
                break
            ENDIF
        ENDIF
    ENDIF

    if val(cNotaIni) > val(cNotaFim)
        Help(NIL, NIL, "Valores de numeração de documentos inválidos", NIL, "Informe um intervalo válido de notas., Informe um intervalo válido de notas.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"}) //Valores de numeração de documentos inválidos., Informe um intervalo válido de notas., Verifique as informações do intervalo de notas.
        break
    ENDIF

    nTamSerie   := GetSX3Cache("F3_SERIE", "X3_TAMANHO")
    lSdoc       := nTamSerie == 14
    cSerie      := Padr(cSerie, nTamSerie )
    cWhere      := "% SF3.F3_SERIE = '"+ cSerie + "' AND SF3.F3_ESPECIE IN ('SPED','NFCE') "

    if lSdoc
        cSerie := Padr(cSerie, GetSX3Cache("F3_SDOC", "X3_TAMANHO") )
        cWhere := "% SF3.F3_SDOC = '"+ cSerie + "' AND SF3.F3_ESPECIE IN ('SPED','NFCE') "
    ENDIF

    if nTipoDoc == 1
        cWhere += " AND SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_FORMUL = 'S' "
	ELSEif nTipoDoc == 2
        cWhere += " AND SubString(SF3.F3_CFO,1,1) >= '5' "
    ENDIF
		
	if !Empty(dDtIni) .or. !Empty(dDtFim)
		cWhere += " AND (SF3.F3_EMISSAO >= '"+ SubStr(DTOS(dDtIni),1,4) + SubStr(DTOS(dDtIni),5,2) + SubStr(DTOS(dDtIni),7,2) + "' AND SF3.F3_EMISSAO <= '"+ SubStr(DTOS(dDtFim),1,4) + SubStr(DTOS(dDtFim),5,2) + SubStr(DTOS(dDtFim),7,2) + "')"
	ENDIF

	cWhere += " %"
    cAliasQry := getNEXTAlias()

    BeginSql Alias cAliasQry
        SELECT MIN(SF3.F3_NFISCAL) NOTAINI, MAX(SF3.F3_NFISCAL) NOTAFIM
        FROM
            %Table:SF3% SF3
        WHERE
            SF3.F3_FILIAL = %xFilial:SF3% AND
            SF3.F3_NFISCAL >= %Exp:cNotaIni% AND
            SF3.F3_NFISCAL <= %Exp:cNotaFim% AND
            SF3.F3_DTCANC = %Exp:Space(8)% AND
            %Exp:cWhere% AND
            SF3.D_E_L_E_T_ = ' '
    EndSql

    (cAliasQry)->(dbGoTop())
    cNotaIni := (cAliasQry)->NOTAINI
    cNotaFim := (cAliasQry)->NOTAFIM
    (cAliasQry)->(dbCloseArea())

    if val(cNotaIni) == 0 .or. val(cNotaFim) == 0
        Help(NIL, NIL, "Documentos não encontrados para impressão do DANFE.", NIL, "Informe um intervalo válido de notas., Informe um intervalo válido de notas.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"}) //, 
        break
    ENDIF

    IF nTipImp == 2
        _lAutoPrd   := .T.
        _lView      := .T.
        IF _lAutoPrd //___________________________________________________________________________________
            _cNomePDF := "DANFE_ETIQUETA_" + cIdEnt + "_" + Dtos(MSDate())+StrTran(Time(),":","")
            
            fErase(cPathEst+_cNomePDF+'.pdf')
            IF oPrinter == Nil
                lPreview 		:= .T.
                //oPrinter      	:= FWMSPrinter():New(_cNomePDF,6,/*.T.*/.F.,,.T.,,,,,,,_lView)
                //oPrinter:SetResolution(78) //Tamanho estipulado para a Danfe
                //oPrinter:SetLandscape()		//Define a orientacao como paisagem
                //oPrinter:setPaperSize(9) 	//Define tipo papel A4
                //oPrinter:SetMargin(60,60,60,60)

                oPrinter := FWMSPrinter():New(_cNomePDF, IMP_PDF, lAdjustToLegacy, , lDisableSetup)// Ordem obrigátoria de configuração do relatório
                oPrinter:SetResolution(78) //Tamanho estipulado para a Danfe
                oPrinter:SetLandscape() //SetPortrait()           
                oPrinter:SetPaperSize(0,130,090)
                oPrinter:SetMargin(00,00,00,00)

                oPrinter:nDevice  := IMP_PDF
                oPrinter:cPathPDF := cPathEst
            ENDIF
            //oPrinter:StartPage()
            //___________________________________________________________________________________

        ELSE
            oPrinter := FWMSPrinter():New("DANFE_ETIQUETA_" + cIdEnt + "_" + Dtos(MSDate())+StrTran(Time(),":",""),,.F.,,.T.,,,,,.F.)
            oSetup := FWPrintSetup():New(PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN,"DANFE SIMPLIFICADA")
            oSetup:SetPropert(PD_PRINTTYPE , 2) //Spool
            oSetup:SetPropert(PD_ORIENTATION , 2)
            oSetup:SetPropert(PD_DESTINATION , 1)
            oSetup:SetPropert(PD_MARGIN , {0,0,0,0})
            oSetup:SetPropert(PD_PAPERSIZE , 2)

            //##Salonline [INICIO]___________________________
            IF FWIsInCallStack("SLSEPA81")
                DbSelectArea('SC5');SC5->(DbSetOrder(1))
                IF SC5->(DbSeek(xFilial('SC5')+SD2->D2_PEDIDO))
                    oSetup:cQtdCopia := StrZero(SC5->C5_VOLUME1,2)
                ENDIF
            ENDIF
            //##Salonline [FIM]______________________________

            if !oSetup:Activate() == PD_OK
                break
            ENDIF

            //oSetup:GetOrientation() // Retorna a orientação (Retrato ou Paisagem) do objeto.
            oPrinter:SetLandscape()		//Define a orientacao como paisagem
            oPrinter:setPaperSize(9) 	//Define tipo papel A4
            oPrinter:setCopies(val(oSetup:cQtdCopia))
            If oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
                oPrinter:nDevice := IMP_PDF
                oPrinter:cPathPDF := if( Empty(oSetup:aOptions[PD_VALUETYPE]), SuperGetMV('MV_RELT',,"\SPOOL\") , oSetup:aOptions[PD_VALUETYPE] )
            ELSEIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
                oPrinter:nDevice := IMP_SPOOL
                fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
                oPrinter:cPrinter := oSetup:aOptions[PD_VALUETYPE]
            ENDIF
        ENDIF
    ENDIF

    IF !Empty(_cSpool) .And. nTipImp == 2
        aRet := GetImpWindows(.F.) // Indica se, verdadeiro (.T.), retorna as impressoras do Application Server; caso contrário, falso (.F.), do Smart Client.
        IF (_nImpter := aScan(aRet, AllTrim(_cSpool))) > 0
            oPrinter:SetDevice(IMP_SPOOL) //2-Impressora
            //oPrinter:nDevice  := IMP_PDF
            //oPrinter:cPrinter 	:= "SEC8425191CDAF3 (redirected 7)"
            oPrinter:cPrinter 	:= aRet[_nImpter]
            //oPrinter:cSession 	:= "PRINTER_SRV-TOTVS"
            oPrinter:cPathPrint 	:= "\SPOOL\"
            //oPrinter:cSpoolLocal 	:= "\system\\SC050740"
            oPrinter:cPathPDF 	:= ''
            _lSpool := .T.	 
            
        Else	
            _lSpool := .F.	 
            _cPopUp += ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
            _cPopUp += ' <br> '
            _cPopUp += ' <font color="#FF0000" face="Arial" size="2">Romaneio de Separação</font> '
            _cPopUp += ' <br>'
            _cPopUp += ' <font color="#000000" face="Arial" size="3">Impressora: '+_cSpool+', não configurada </font> '
            _cPopUp += ' <br> '
            _cPopUp += ' <font color="#000000" face="Arial" size="2">Por gentileza, entre em contato com o administrador! </font> '
            Alert(_cPopUp,'Romaneio de Separação')
            oPrint := Nil
            MsgInfo('ATENÇÃO ! Não esqueça de imprimir o romaneio antes de transmitir a Nota Fiscal.')
            Return	
        ENDIF
    ENDIF 

    lMv_Logod  := If(GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F.   )
    if lMv_Logod 
        cGrpCompany	:= Alltrim(FWGrpCompany())
        cCodEmpGrp	:= Alltrim(FWCodEmp())
        cUnitGrp	:= Alltrim(FWUnitBusiness())
        cFilGrp		:= Alltrim(FWFilial())

        if !Empty(cUnitGrp)
            cDescLogo := cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
        ELSE
            cDescLogo := cEmpAnt + cFilAnt
        ENDIF

        cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cDescLogo + ".BMP"
        if !file(cLogoD)
            cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
            if !file(cLogoD)
                lMv_Logod := .F.
            ENDIF
        ENDIF
    ENDIF
    IF lMv_Logod
        cLogo := cLogoD
    ELSE
        cLogo := FisxLogo("1")
    ENDIF
    oFontTit := TFont():New( "Arial", , -8, .T.) //Fonte para os titulos
    oFontTit:Bold := .T.						 //Setado negrito
    oFontInf := TFont():New( "Arial", , -8, .T.) //Fonte para as informações
    oFontInf:Bold := .F.						 //Setado negrito := .F.

    aParam := {cSerie, cNotaIni, cNotaFim}
	if lUsaColab
		aNotas := colNfeMonProc( aParam, 1,,, @cAviso)
	ELSE
		aNotas := procMonitorDoc(cIdEnt, cUrl, aParam, 1,,, @cAviso)
	ENDIF
	
    If Empty(aNotas)
        Help(NIL, NIL, "Não foram Localizados os XMLs para geração do DANFE etiqueta.", NIL, "Verifique se o(s) documento(s) consta(m) como autorizado(s) através da rotina Monitor.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"})// "Não foram Localizados os XMLs para geração do DANFE etiqueta." - Não foram Localizados os XMLs para geração do DANFE etiqueta. 
        break                                                                         // "Verifique se o(s) documento(s) consta(m) como autorizado(s) através da rotina Monitor." - 
	ENDIF

    aEmit := array(4)
    aEmit[1] := Alltrim(SM0->M0_NOMECOM)
    aEmit[2] := Alltrim(SM0->M0_CGC)
    aEmit[3] := Alltrim(SM0->M0_INSC)
    aEmit[4] := if(!GetNewPar("MV_SPEDEND",.F.),Alltrim(SM0->M0_ESTCOB),Alltrim(SM0->M0_ESTENT))

    SA1->(dbSetOrder(1))
    SA2->(dbSetOrder(1))
    SF3->(dbSetOrder(5)) // F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT
    SF2->(dbSetOrder(1)) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
    SF1->(dbSetOrder(1)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

    for nNotas := 1 to len(aNotas)

        cXml := aTail(aNotas[nNotas])[2]
        if Empty(cXml)
            loop
        ENDIF

        cProtocolo  := aNotas[nNotas][4]
        cDpecProt   := aTail(aNotas[nNotas])[3]
        cSerie      := aNotas[nNotas][2]
		cNota       := aNotas[nNotas][3]
        fwFreeObj(oRetNF)
        fwFreeObj(oNfe)
        fwFreeObj(oTotal)

        oRetNF := XmlParser(cXml,"_",@cAviso,@cErro)
        if ValAtrib("oRetNF:_NFEPROC") <> "U"
            oNfe := WSAdvValue( oRetNF,"_NFEPROC","string",NIL,NIL,NIL,NIL,NIL)
        ELSE
            oNfe := oRetNF
        ENDIF

        if ValAtrib("oNFe:_NFe:_InfNfe:_Total") == "U"
            loop
        ELSE
            oTotal := oNFe:_NFe:_InfNfe:_Total
        ENDIF

        if (!Empty(cProtocolo) .or. !Empty(cDpecProt))
            cCodCliFor := ""
            cLoja := ""
            lSeek := .F.
            if nTipoDoc == 2
                lSeek := SF2->(dbSeek(xFilial("SF2") + cNota + cSerie))
                if lSeek .and. !Alltrim(SF2->F2_ESPECIE) $ ('SPED||NFCE')
                    lSeek := .F.
                    while SF2->(!eof()) .and. SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_DOC == cNota .and. SF2->F2_SERIE == cSerie
                        if Alltrim(SF2->F2_ESPECIE) $ ('SPED||NFCE')
                            lSeek := .T.
                            exit
                        ENDIF
                        SF2->(dbSkip())
                    end
                ENDIF

                if lSeek 
                    cCodCliFor := SF2->F2_CLIENTE
                    cLoja := SF2->F2_LOJA
                ENDIF
            ELSE

                lSeek := SF1->(dbSeek(xFilial("SF1") + cNota + cSerie))
                if lSeek .and. Alltrim(SF1->F1_ESPECIE) $ ('SPED||NFCE')
                   lSeek := .F.
                    while SF1->(!eof()) .and. SF1->F1_FILIAL == xFilial("SF1") .and. SF1->F1_DOC == cNota .and. SF1->F1_SERIE == cSerie
                        if Alltrim(SF1->F1_ESPECIE) $ ('SPED||NFCE')
                            lSeek := .T.
                            exit
                        ENDIF
                        SF1->(dbSkip())
                    end
                ENDIF

                if lSeek 
                    cCodCliFor := SF1->F1_FORNECE
                    cLoja := SF1->F1_LOJA
                ENDIF
            ENDIF
          
            if !lSeek .or. !SF3->(dbSeek(xFilial("SF3") + aNotas[nNotas][2] + aNotas[nNotas][3] + cCodCliFor + cLoja))
                loop
            ENDIF

            cTotNota := Alltrim(Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),"@e 9,999,999,999,999.99"))

		    cHautNfe := aTail(aNotas[nNotas])[5]
		    dDautNfe := if( !Empty(aTail(aNotas[nNotas])[6]), aTail(aNotas[nNotas])[6], SToD("  /  /  ") )

            aSize(aNFe, 0)
            aSize(aDest, 0)

            aNFe := array(10)
            aNfe[1] := SF3->F3_CHVNFE
            aNfe[2] := cProtocolo
            aNfe[3] := cDpecProt
            aNfe[4] := cLogo
            aNfe[5] := if( SubStr(SF3->F3_CFO,1,1) >= '5', "1", "0" ) // 0 - Entrada / 1 - Saída
            aNfe[6] := SF3->F3_NFISCAL
            aNfe[7] := SF3->F3_SERIE
            aNfe[8] := SF3->F3_EMISSAO
            aNfe[9] := cTotNota
            aNfe[10]:= Transform(SF2->F2_VOLUME1,"@e 9,999")

            aDest := array(4)
            if ( SubStr(SF3->F3_CFO,1,1) < '5' .and. SF3->F3_TIPO $ "DB") .or. (SubStr(SF3->F3_CFO,1,1) >= '5' .and. !SF3->F3_TIPO $ "DB")
                if SA1->(dbSeek(xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA))
                    cCgc := SA1->A1_CGC
                    cNome := SA1->A1_NOME
                    cInscr := SA1->A1_INSCR
                    cUF := SA1->A1_EST
                ENDIF
            ELSE // if ( SubStr(SF3->F3_CFO,1,1) < '5' .and. !SF3->F3_TIPO $ "DB") .or. (SubStr(SF3->F3_CFO,1,1) >= '5' .and. SF3->F3_TIPO $ "DB")
                if SA2->(dbSeek(xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA))
                    cCgc := SA2->A2_CGC
                    cNome := SA2->A2_NOME
                    cInscr := SA2->A2_INSCR
                    cUF := SA2->A2_EST
                ENDIF
            ENDIF
            aDest[1] := Alltrim(cNome)
            aDest[2] := Alltrim(cCgc)
            aDest[3] := Alltrim(cInscr)
            aDest[4] := Alltrim(cUF)

            nContDanfe += 1
            if nTipImp == 1 // 1 - Térmica 

                impZebra(aNfe, aEmit, aDest)

            ELSEif nTipImp == 2 // 2 - Normal

                if nContDanfe == 1
                    oPrinter:StartPage() 		//Define inicio da pagina
                    nLinha := 0
                    nColuna := 0
                ELSEif nContDanfe == 2 
                    nLinha := 0
                    nColuna := 250
                ELSEif nContDanfe == 3
                    nLinha := 0
                    nColuna := 500
                ELSEif nContDanfe == 4
                    nLinha := 250
                    nColuna := 0
                ELSEif nContDanfe == 5
                    nLinha := 250
                    nColuna := 250
                ELSEif nContDanfe == 6
                    nLinha := 250
                    nColuna := 500
                    oPrinter:EndPage()
                    nContDanfe := 0
                ENDIF

                DanfeSimp(oPrinter, nLinha, nColuna, oFontTit, oFontInf, aEmit, aNfe, aDest)

            ENDIF    
            lOk := .T.
        ENDIF
    NEXT

    if lOk
        if nTipImp == 1 // 1 - Térmica 
            MSCBCLOSEPRINTER()
        ELSEif nTipImp == 2 // 2 - Normal
            if nContDanfe <> 6
                oPrinter:EndPage()
            ENDIF
            oPrinter:Print()
        ENDIF
    ENDIF

    //end sequence

    fwFreeObj(oPrinter)
    //fwFreeObj(oSetup)
    fwFreeObj(oFontTit)
    fwFreeObj(oFontInf)
    restArea(aArea)
return

Static Function ValAtrib(atributo)
Return (type(atributo) )

//-------------------------------------------------------------------
//{Protheus.doc} DanfeSimp
//Impressão normal de danfe simplificada - Etiqueta 
//-------------------------------------------------------------------
*---------------------------------------------------------------------------------------*
Static Function DanfeSimp(oPrinter, nPosY, nPosX, oFontTit, oFontInf, aEmit, aNfe, aDest)
*---------------------------------------------------------------------------------------*
	Local cTitDanfe		:= "DANFE SIMPLIFICADO - ETIQUETA"
	Local cChAces		:= "CHAVE DE ACESSO: "
    Local cTitProt		:= "PROTOCOLO DE AUTORIZACAO: "
    Local cTitPrtEPEC	:= "PROTOCOLO DE AUTORIZACAO EPEC: "
	Local cTitNome		:= "NOME/RAZAO SOCIAL: "
	Local cCpf			:= "CPF: "
	Local cCnpj 		:= "CNPJ: "
	Local cIETxt		:= "IE: "
	Local cUFTxt		:= "UF: "
    Local cSerieTxt		:= "SÉRIE: "
	Local cNumTxt		:= "N°: "
    Local cDtEmi		:= "DATA EMISSÃO:"
	Local cTipOp		:= "TIPO DE OPERAÇÃO: "
	Local cEntTxt		:= "0 - Entrada "
	Local cSaiTxt		:= "1 - Saida"
    Local cDestTxt		:= "DESTINATARIO: "
	Local cValTotTxt	:= "VALOR TOTAL DA NOTA FISCAL: "
    Local cValor 		:= "R$: "

    // Box Principal
    // box (eixo Y inicio, eixo X inicio, eixo y fim, eixo x fim)
    oPrinter:Box( 30 + nPosY, 30 + nPosX, 270 + nPosY, 270 + nPosX, "-6") // box (eixo Y inicio, eixo X inicio, eixo y fim, eixo x fim)

    // Box Título
    oPrinter:Box( 30 + nPosY, 30 + nPosX, 50 + nPosY, 270 + nPosX, "-4")
    oPrinter:Say( 45 + nPosY, 80 + nPosX, cTitDanfe, oFontTit) //say (y,x)

    // Box Chave de acesso
    oPrinter:Box( 50 + nPosY, 30 + nPosX, 120 + nPosY, 270 + nPosX, "-4")
    oPrinter:Say( 65 + nPosY, 35 + nPosX, cChAces, oFontTit)
    oPrinter:Say( 110 + nPosY, 50 + nPosX, Transform(aNfe[1],"@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), oFontInf)
    oPrinter:Code128c( 100 + nPosY, 40 + nPosX, aNfe[1], 30)

    // Box Protocolo de Autorizacao
    oPrinter:Box( 120 + nPosY, 30 + nPosX, 135 + nPosY, 270 + nPosX, "-4")
    if !Empty(aNfe[2])
        oPrinter:Say( 130 + nPosY, 50 + nPosX, cTitProt, oFontTit)
        oPrinter:Say( 130 + nPosY, 180 + nPosX, aNfe[2], oFontInf)
    ELSE
        oPrinter:Say( 130 + nPosY, 50 + nPosX, cTitPrtEPEC, oFontTit)
        oPrinter:Say( 130 + nPosY, 180 + nPosX, aNfe[3], oFontInf)
    ENDIF

    //Remetente
    oPrinter:SayBitmap( 140 + nPosY, 35 + nPosX, aNfe[4], 25, 25)
    oPrinter:Say( 145 + nPosY, 80 + nPosX, cTitNome, oFontTit)
    if len(aEmit[1]) > 21
        oPrinter:Say( 145 + nPosY, 175 + nPosX, SubStr(aEmit[1],1,20), oFontInf)
        oPrinter:Say( 153 + nPosY, 80 + nPosX, SubStr(aEmit[1],21,59), oFontInf)
    ELSE
        oPrinter:Say( 145 + nPosY, 175 + nPosX, aEmit[1], oFontInf)
    ENDIF
    oPrinter:Say( 161 + nPosY, 80 + nPosX, cIETxt, oFontTit)
    oPrinter:Say( 161 + nPosY, 90 + nPosX, aEmit[3], oFontInf)
    if len(aEmit[2]) == 11
        oPrinter:Say( 161 + nPosY, 175 + nPosX, cCpf, oFontTit)
        oPrinter:Say( 161 + nPosY, 200 + nPosX, Transform(aEmit[2],"@R 999.999.999-99"), oFontInf)
    ELSE
        oPrinter:Say( 161 + nPosY, 175 + nPosX, cCnpj, oFontTit)
        oPrinter:Say( 161 + nPosY, 200 + nPosX, Transform(aEmit[2],"@R 99.999.999/9999-99"), oFontInf)
    ENDIF
    oPrinter:Say( 169 + nPosY, 80 + nPosX, cUFTxt, oFontTit)
    oPrinter:Say( 169 + nPosY, 100 + nPosX, aEmit[4], oFontInf)

    // Box serie
    oPrinter:Box( 175 + nPosY, 30 + nPosX, 210 + nPosY, 100 + nPosX, "-4")
    oPrinter:Say( 185 + nPosY, 38 + nPosX, cSerieTxt, oFontTit)
    oPrinter:Say( 185 + nPosY, 65 + nPosX, aNfe[7], oFontInf)
    oPrinter:Say( 193 + nPosY, 38 + nPosX, cNumTxt, oFontTit)
    oPrinter:Say( 193 + nPosY, 53 + nPosX, aNfe[6], oFontInf)
    oPrinter:Say( 205 + nPosY, 38 + nPosX, 'Volume:', oFontTit)
    oPrinter:Say( 205 + nPosY, 70 + nPosX, aNfe[10], oFontInf)

    // Box Data Emissao
    oPrinter:Box( 175 + nPosY, 100 + nPosX, 210 + nPosY, 180 + nPosX, "-4")
    oPrinter:Say( 185 + nPosY, 110 + nPosX, cDtEmi, oFontTit)
    oPrinter:Say( 193 + nPosY, 120 + nPosX, dtoc(aNfe[8]), oFontInf)

    // Box Tipo da operacao
    oPrinter:Box( 175 + nPosY, 175 + nPosX, 210 + nPosY, 270 + nPosX, "-4")
    oPrinter:Say( 185 + nPosY, 180 + nPosX, cTipOp, oFontTit)
    oPrinter:Say( 185 + nPosY, 262 + nPosX, aNfe[5], oFontInf)
    oPrinter:Say( 193 + nPosY, 200 + nPosX, cEntTxt, oFontInf)
    oPrinter:Say( 201 + nPosY, 200 + nPosX, cSaiTxt, oFontInf)

    // Destinatario
    oPrinter:Box( 210 + nPosY, 30 + nPosX, 220 + nPosY, 270 + nPosX, "-4")
    oPrinter:Say( 218 + nPosY, 120 + nPosX, cDestTxt, oFontTit)
    oPrinter:Say( 228 + nPosY, 35 + nPosX, cTitNome, oFontTit)
    if len(aDest[1]) > 21
        oPrinter:Say( 228 + nPosY, 130 + nPosX, SubStr(aDest[1], 1, 30), oFontInf)
        oPrinter:Say( 236 + nPosY, 35 + nPosX, SubStr(aDest[1], 31, 49), oFontInf)
    ELSE
        oPrinter:Say( 228 + nPosY, 130 + nPosX, aDest[1], oFontInf)
    ENDIF
    oPrinter:Say( 244 + nPosY, 35 + nPosX, cIETxt, oFontTit)
    oPrinter:Say( 244 + nPosY, 45 + nPosX, aDest[3], oFontInf)
    if len(aDest[2]) == 11
        oPrinter:Say( 244 + nPosY, 175 + nPosX, cCpf, oFontTit)
        oPrinter:Say( 244 + nPosY, 200 + nPosX, Transform(aDest[2], "@R 999.999.999-99"), oFontInf)
    ELSE
        oPrinter:Say( 244 + nPosY, 175 + nPosX, cCnpj, oFontTit)
        oPrinter:Say( 244 + nPosY, 200 + nPosX, Transform(aDest[2], "@R 99.999.999/9999-99"), oFontInf)
    ENDIF
    oPrinter:Say( 252 + nPosY, 35 + nPosX, cUFTxt, oFontTit)
    oPrinter:Say( 252 + nPosY, 55 + nPosX, aDest[4], oFontInf)

    // Box Valor Total
    //oPrinter:Box( 255 + nPosY, 30 + nPosX, 270 + nPosY, 270 + nPosX, "-4") // box (inicio, Margem esquerda, fim, largura)
    
    IF !_lSemValor    
        oPrinter:Say( 260 + nPosY, 35 + nPosX, cValTotTxt , oFontTit)
        oPrinter:Say( 260 + nPosY, 190 + nPosX, cValor + aNfe[9], oFontInf)
    ELSE
        oPrinter:Say( 260 + nPosY, 120 + nPosX, 'www.salonline.com.br', oFontInf)
    ENDIF

return

//{Protheus.doc} impZebra
//Impressão de danfe simplificada - Etiqueta para impressora Zebra
*------------------------------------------*
Static Function impZebra(aNFe, aEmit, aDest)
*------------------------------------------*
    Local cFontMaior := "016,013" //Fonte maior - títulos dos campos obrigatórios do DANFE ("altura da fonte, largura da fonte")
    Local cFontMenor := "015,008" //Fonte menor - campos variáveis do DANFE ("altura da fonte, largura da fonte")

    Local lProtEPEC  := .F.
    Local lNomeEmit  := .F.
    Local lNomeDest  := .F.

    Local nNome      := 1
    Local nCNPJ      := 2
    Local nIE        := 3
    Local nUF        := 4
    Local nChave     := 1
    Local nProtocolo := 2
    Local nProt_EPEC := 3
    Local nOperacao  := 5
    Local nNumero    := 6
    Local nSerie     := 7
    Local nData      := 8
    Local nValor     := 9
    Local nVolume    := 10
    Local nTamEmit   := len( Alltrim( aEmit[nNome] ) ) //Quantidade de caracteres da razão social do emitente
    Local nTamDest   := len( Alltrim( aDest[nNome] ) ) //Quantidade de caracteres da razão social do destinatário
    Local nMaxNome   := 34 //Quantidade de caracteres máxima da primeira linha da razão social

    Default aNFe     := {}
    Default aEmit    := {}
    Default aDest    := {}

    //Inicializa a impressão
    MSCBBegin(1,6,150)

    //Criação do Box
    MSCBBox(02,02,98,148)

    //Criação das linhas Horizontais - sentido: de cima para baixo
    MSCBLineH(02, 012, 98)
    MSCBLineH(02, 047, 98)
    MSCBLineH(02, 057, 98)
    MSCBLineH(02, 084, 98)
    MSCBLineH(40, 101, 98)
    MSCBLineH(02, 101, 98)
    MSCBLineH(02, 111, 98)
    MSCBLineH(02, 138, 98)

    //Criação das linhas verticais - sentido: da direita para esquerda
    MSCBLineV(32, 84, 101)
    MSCBLineV(64, 84, 101)

    //Imprime o código de barras
    MSCBSayBar(14, 24, aNFe[nChave], "N", "C", 10, .F., .F., .F., "C", 2, 1, .F., .F., "1", .T.)

    lProtEPEC  := !Empty( aNFe[nProt_EPEC] ) //Se utilizado evento EPEC para emissão da Nota lProtEPEC = .T.
    lEmitJurid := len( aEmit[nCNPJ] ) == 14 //Se emitente pessoa jurídica lEmitJurid = .T.
    lDestJurid := len( aDest[nCNPJ] ) == 14 //Se destinatário pessoa jurídica lDestJurid = .T.

    //Criação dos campos de textos fixos da etiqueta
    MSCBSay(17.5, 06.25, "DANFE SIMPLIFICADO - ETIQUETA", "N", "A", cFontMaior)
    MSCBSay(04  , 15   , "CHAVE DE ACESSO:"             , "N", "A", cFontMaior)

    if !lProtEPEC
        MSCBSay(22.5, 48.75, "PROTOCOLO DE AUTORIZACAO:"     , "N", "A", cFontMaior)
    ELSE
        MSCBSay(16.5, 48.75, "PROTOCOLO DE AUTORIZACAO EPEC:", "N", "A", cFontMaior)
    ENDIF

    MSCBSay(04, 60, "NOME/RAZAO SOCIAL:", "N", "A", cFontMaior)

    if lEmitJurid
        MSCBSay(04, 66.25 , "CNPJ:", "N", "A", cFontMaior)
    ELSE
        MSCBSay(04, 66.25 , "CPF:", "N", "A", cFontMaior)
    ENDIF

    MSCBSay(04  , 70    , "IE:"               , "N", "A", cFontMaior)
    MSCBSay(04  , 73.75 , "UF:"               , "N", "A", cFontMaior)
    MSCBSay(04  , 88.75 , "SERIE:"            , "N", "A", cFontMaior)
    MSCBSay(04  , 93.75 , "N_A7:"             , "N", "A", cFontMaior)
    MSCBSay(04  , 97.75 , "Volume:"           , "N", "A", cFontMaior)
    MSCBSay(34  , 88.75 , "DATA EMISSAO:"     , "N", "A", cFontMaior)
    MSCBSay(65.5, 88.75 , "TIPO OPER.:"       , "N", "A", cFontMaior)
    MSCBSay(65.5, 92.5  , "0 - ENTRADA"       , "N", "A", cFontMenor)
    MSCBSay(65.5, 96.25 , "1 - SAIDA"         , "N", "A", cFontMenor)
    MSCBSay(35  , 105.5 , "DESTINATARIO"      , "N", "A", cFontMaior)
    MSCBSay(04  , 113.75, "NOME/RAZAO SOCIAL:", "N", "A", cFontMaior)

    if lDestJurid
        MSCBSay(04, 120, "CNPJ:", "N", "A", cFontMaior)
    ELSE
        MSCBSay(04, 120, "CPF:" , "N", "A", cFontMaior)
    ENDIF

    MSCBSay(04  , 123.75, "IE:"         , "N", "A", cFontMaior)
    MSCBSay(04  , 127.5 , "UF:"         , "N", "A", cFontMaior)
    MSCBSay(04  , 131.5 , "VALOR TOTAL (R$):", "N", "A", cFontMaior)
    //MSCBSay(62.5, 142.5 , "R$"          , "N", "A", cFontMaior)

    lNomeEmit := nTamEmit > nMaxNome //Se quantidade de caracteres da razão social do emitente for maior que o permitido para a primeira linha lNomeEmit := T
    lNomeDest := nTamDest > nMaxNome //Se quantidade de caracteres da razão social do destinatário for maior que o permitido para a primeira linha lNomeDest := T

    //Criação dos campos de textos variáveis da etiqueta
    MSCBSay(09, 39, transform( aNFe[nChave], "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), "N", "A", cFontMenor)

    IF !lProtEPEC
        MSCBSay(38.75, 53.75, aNFe[nProtocolo], "N", "A", cFontMenor)
    ELSE
        MSCBSay(38.75, 53.75, aNFe[nProt_EPEC], "N", "A", cFontMenor)
    ENDIF

    IF lNomeEmit
        MSCBSay(44, 60, Alltrim( subStr( aEmit[nNome], 1, nMaxNome ) ), "N", "A", cFontMenor)
        MSCBSay(04, 62.5, Alltrim( subStr( aEmit[nNome], nMaxNome + 1, nTamEmit ) ), "N", "A", cFontMenor)
    ELSE
        MSCBSay(44, 60, Alltrim( aEmit[nNome] ), "N", "A", cFontMenor)
    ENDIF

    IF lEmitJurid
        MSCBSay(15, 66.25, transform( aEmit[nCNPJ], "@R 99.999.999/9999-99" ), "N", "A", cFontMenor) //Emitente pessoa jurídica
    ELSE
        MSCBSay(15, 66.25, transform( aEmit[nCNPJ], "@R 999.999.999-99" ), "N", "A", cFontMenor) //Emitente pessoa física
    ENDIF

    MSCBSay(11, 70,    aEmit[nIE], "N", "A", cFontMenor)
    MSCBSay(11, 73.75, aEmit[nUF], "N", "A", cFontMenor)
    MSCBSay(18, 88.75, aNFe[nSerie], "N", "A", cFontMenor)
    MSCBSay(11, 93.75, aNFe[nNumero], "N", "A", cFontMenor)
    MSCBSay(25, 97.75, aNFe[nVolume], "N", "A", cFontMenor)
    MSCBSay(40, 93.75, ajustaData( aNFe[nData] ) , "N", "A", cFontMenor)
    MSCBSay(93, 88.75, aNFe[nOperacao], "N", "A", cFontMenor)

    if lNomeDest
        MSCBSay(44, 113.75, Alltrim( subStr( aDest[nNome], 1, nMaxNome ) ), "N", "A", cFontMenor)
        MSCBSay(04, 116.25, Alltrim( subStr( aDest[nNome], nMaxNome + 1, nTamDest ) ), "N", "A", cFontMenor)
    ELSE
        MSCBSay(44, 113.75, Alltrim( aDest[nNome] ), "N", "A", cFontMenor)
    ENDIF

    if lDestJurid
        MSCBSay(15, 120, transform( aDest[nCNPJ], "@R 99.999.999/9999-99" ), "N", "A", cFontMenor) //Destinatário pessoa jurídica
    ELSE
        MSCBSay(15, 120, transform( aDest[nCNPJ], "@R 999.999.999-99" ), "N", "A", cFontMenor) //Destinatário pessoa física
    ENDIF

    MSCBSay(11, 123.75, aDest[nIE]  , "N", "A", cFontMenor)
    MSCBSay(11, 127.5 , aDest[nUF]  , "N", "A", cFontMenor)
    MSCBSay(50, 131.5 , aNFe[nValor], "N", "A", cFontMenor)

    //Finaliza a impressão
    MSCBEND()

return

//{Protheus.doc} ajustaData
//Recebe um dado do tipo data (AAAAMMDD) e devolve uma string no
//formato (DD/MM/AAAA)
//@param		dData		Dado do tipo data(AAAAMMDD)
//@return     cDataForm	String formatada com a data (DD/MM/AAAA)
*-------------------------------*
Static Function ajustaData(dData)
*-------------------------------*
Local cDia      := ""
Local cMes      := ""
Local cAno      := ""
Local cDataForm := ""

default dData   := Date()

cDia := strZero( day( dData ), 2 )
cMes := strZero( month( dData ), 2 )
cAno := Alltrim( str( year( dData ) ) )

cDataForm = cDia + "/" + cMes + "/" + cAno
Return cDataForm
