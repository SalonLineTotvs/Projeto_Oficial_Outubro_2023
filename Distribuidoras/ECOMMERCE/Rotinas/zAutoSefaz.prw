#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE TAMMAXXML  GetNewPar("MV_XMLSIZE",400000) 
#DEFINE VBOX       080
#DEFINE HMARGEM    030

/*/{Protheus.doc} zAutoSefaz
Fun��o para transmiss�o de consulta no SEFAZ
@author Gustavo Oliveira	
@since 28/07/2023
@type function
/*/

*--------------------------------------------------*
User Function zAutoSefaz(_cDocNF,_cSerieNF,_oWizard)
*--------------------------------------------------*
Local _aRetSefaz := {.F.,'',''}

Default _cDocNF   := Space(TamSX3('F2_DOC')[1])
Default _cSerieNF := Space(TamSX3('F2_SERIE')[1])
Default _oWizard  := Nil

If Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("02","0101")
Endif

DBSelectArea('SF2');SF2->(DbSetOrder(1))
IF SF2->(DbSeek(xFilial("SF2")+_cDocNF+_cSerieNF)) 
    //FwMsgRun(,{|| xAutoNfeCmd(@_aRetSefaz,_cDocNF,_cSerieNF,@_oWizard) }, "Aguarde Processamento...",'Verificando Transmissao Sefaz')
	xAutoNfeCmd(@_aRetSefaz,_cDocNF,_cSerieNF,@_oWizard)
ENDIF

RETURN(_aRetSefaz)

//-----------------------------------------------------------------------------------------------------------------------   
*----------------------------------------------------------------*
Static Function xAutoNfeCmd(_aRetSefaz,_cDocNF,_cSerieNF,_oWizard)
*----------------------------------------------------------------*
Local aParams  :=  {'02','01','5','2',_cSerieNF,_cDocNF,_cDocNF}//xReadInfo() 
Local _aArea 	 := FwGetArea()
Local cFunBkp	 := FunName()
Local nModBkp    := nModulo
Local _nLoop     := 0

Default  _aRetSefaz := {.F.,'',''}

Private _lAutoNfe  := .T.
Private _oWizard   := _oWizard

Private	__lPyme	:=	.F.	// EXISTBLOCK E EXECBLOCK

Private lCTe     := .F.
Private lRetorno := .F.
Private aNotas   := {}
Private bFiltraBrw
Private _lMsgTela  := ValType(_oWizard) <> 'U'

nModulo    := 5
SetFunName("SPEDNFE")

If _lAutoNfe .And. Len(aParams)>0
	While !KillApp()
		_nLoop++
        IF _lMsgTela
            _oWizard:IncRegua1('05.1 - Transmiss�o Sefaz '+SF2->F2_DOC+' - '+SF2->F2_SERIE)
        ENDIF
		_aRetSefaz := u_zSpedNFeRe2(_cSerieNF,_cDocNF,_cDocNF,lCTe,lRetorno,aNotas)

        IF _lMsgTela
            _oWizard:IncRegua1('05.1 - Validando Chave Sefaz')
        ENDIF

		//Caso n�o tenha sido transmitido far� 'x' tentativa
		IF !_aRetSefaz[1]
			IF _nLoop > VAL(aParams[4])
				_oWizard:IncRegua1('05.1 - Transmiss�o Sefaz '+SF2->F2_DOC+' - '+SF2->F2_SERIE+' [TENTATIVA: '+StrZero(_nLoop,2)+']')
				Loop
			ENDIF
		ENDIF

		Sleep(1000 * Val(aParams[3]))
		xSpedNFe6Mnt(Padr(aParams[5],3),aParams[6],aParams[7],,,'55')
		Exit
	EndDo
Else
	ConOut("AUTONFE --> OFF")
EndIf

nModulo := nModBkp
SetFunName(cFunBkp)
  
FwRestArea(_aArea)
Return(_aRetSefaz)

*------------------------------------------------------------------------*
Static Function xSpedNFe6Mnt(cSerie,cNotaIni,cNotaFim, lCTe, lMDFe,cModel)
*------------------------------------------------------------------------*
Local cIdEnt        := ""
local cUrl	        := Padr( GetNewPar("MV_SPEDURL",""), 250 )
Local aPerg         := {}
Local aParam        := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
Local aListBox      := {}
Local cParNfeRem    := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local lOK           := .F.
Local _nWt          := 0

Default cSerie      := ''
Default cNotaIni    := ''
Default cNotaFim    := ''
Default lCTe        := .F.
Default lMDFe       := .F.
Default cModel	    := ""

aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.}) //"Serie da Nota Fiscal"
aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,.T.}) //"Nota fiscal inicial"
aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

aParam[01] := ParamLoad(cParNfeRem,aPerg,1,aParam[01])
aParam[02] := ParamLoad(cParNfeRem,aPerg,2,aParam[02])
aParam[03] := ParamLoad(cParNfeRem,aPerg,3,aParam[03])

//�Obtem o codigo da entidade                                              
cIdEnt := RetIdEnti()
If !Empty(cIdEnt)
	lOK        := .T.//ParamBox(aPerg,"SPED - NFe",@aParam,,,,,,,cParNfeRem,.T.,.T.) aParam[1]:=; acessou esse 
	cSerie   := aParam[01] :=  cSerie
	cNotaIni := aParam[02] := cNotaIni
	cNotaFim :=	aParam[03] := cNotaFim				
	For _nWt:=1 to 10                               
		aListBox := xGetListBox(cIdEnt, cUrl, aParam, 1, cModel, lCte)

        IF _lMsgTela
            _oWizard:IncRegua1('05.2 - Validando Chave Sefaz '+' - Consulta n�.: '+StrZero(_nWt,2))
        ENDIF

        IF Len(aListBox) > 0
            ConOut('Status Sefaz: '+aListBox[1][2]+' - '+aListBox[1][3]+' - '+AllTrim(aListBox[1][6]))

            IF LEN(aListBox[1][9]) <> 0
                IF aListBox[1][9][1][9] == '103'
                    IF _nWt==10
                        ConOut('Status Sefaz: EM PROCESSO > PROTOCOLO: '+aListBox[1][2]+' - '+CVALTOCHAR(aListBox[1][9][1][4])+' - '+aListBox[1][9][1][10]) 			
                        FWAlertErro('Erro transmissao NFE-Sefaz:'+ENTER+'EM PROCESSO > PROTOCOLO: '+aListBox[1][2]+' - '+CVALTOCHAR(aListBox[1][9][1][4])+' - '+aListBox[1][9][1][10],'Atencao')
                        //WfControl(5,.F.,'Erro transmissao NFE-Sefaz:'+ENTER+'EM PROCESSO > PROTOCOLO: '+aListBox[1][2]+' - '+CVALTOCHAR(aListBox[1][9][1][4])+' - '+aListBox[1][9][1][10] )
                    EndIF
                ELSEIF aListBox[1][9][1][9] <> '100'
                    ConOut('Status Sefaz: PROCESSO SERA PARADO POR ERRO NO DANFE')
                    //FWAlertErro('Status Sefaz: PROCESSO SERA PARADO POR ERRO NO DANFE','Atencao')
                    //WfControl(5,.F.,'Erro transmissao NFE-Sefaz:'+ENTER+'EM PROCESSO > PROTOCOLO: '+aListBox[1][2]+' - '+CVALTOCHAR(aListBox[1][9][1][4])+' - '+aListBox[1][9][1][10] )
                    IF (Upper(AllTrim(GetEnvServer())) $ 'TESTE/TESTE_1/TESTE01/TESTE02')	
                        Exit
                    ENDIF
                    //RETURN(.F.)
                ELSE 
                    ConOut('Status Sefaz: NFE TRANSMITIDA COM SUCESSO, PROTOCOLO: '+aListBox[1][2]+' - '+CVALTOCHAR(aListBox[1][9][1][4])+' - '+aListBox[1][9][1][10]) 		
                    FWAlertSuccess('Status Sefaz: NFE TRANSMITIDA COM SUCESSO, PROTOCOLO: '+aListBox[1][2]+' - '+CVALTOCHAR(aListBox[1][9][1][4])+' - '+aListBox[1][9][1][10],'Atencao')
                    //WfControl(5,.T.,'',aListBox)
                    Exit
                ENDIF
            Else
                IF _nWt==10
                    ConOut('Status Sefaz: ERRO PROCESSO NFE SEFAZ - SEM COMUNICACAO '+aListBox[1][6]) 		
                    FWAlertErro('Status Sefaz: ERRO PROCESSO NFE SEFAZ - SEM COMUNICACAO '+aListBox[1][6],'Atencao')
                    //WfControl(5,.F.,'Erro transmissao NFE-Sefaz: ERRO PROCESSO NFE SEFAZ - SEM COMUNICACAO '+aListBox[1][6])
                    //RETURN(.F.)
                EndIF		
            ENDIF
        ENDIF
	  	ConOut("??????????? PAUSA DE "+cValToChar(GetMV('CM_EEWAITF',.F.,1))+' Segundos...')
		Sleep(1000 * GetMV('CM_EEWAITF',.F.,3))
  	Next _nWt			
Else
	FWAlertErro('Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!','Atencao') //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
EndIf

Return
*---------------------------------------------------------------------------------*
Static Function xGetListBox(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, lMsg)
*---------------------------------------------------------------------------------*	
local aLote			    := {}
local aListBox			:= {}
local cId				:= ""
local cProtocolo		:= ""	
local cRetCodNfe		:= ""
local cAviso			:= ""
	
local nAmbiente			:= ""
local nModalidade		:= ""
local cRecomendacao		:= ""
local cTempoDeEspera	:= ""
local nTempomedioSef	:= ""
local nX				:= 0

local oOk				:= LoadBitMap(GetResources(), "ENABLE")
local oNo				:= LoadBitMap(GetResources(), "DISABLE")
		
default lMsg			:= .T.
default lCte			:= .F.
	
//processa monitoramento
aRetorno := ProcMonitorDoc(cIdEnt, cUrl, aParam, nTpMonitor, cModelo, lCte, @cAviso)

if empty(cAviso)
	for nX := 1 to len(aRetorno)				
		cId				:= aRetorno[nX][1]
		cProtocolo		:= aRetorno[nX][4]	
		cRetCodNfe		:= aRetorno[nX][5]
		nAmbiente		:= aRetorno[nX][7]
		nModalidade	    := aRetorno[nX][8]
		cRecomendacao	:= aRetorno[nX][9]
		cTempoDeEspera  := aRetorno[nX][10]
		nTempomedioSef  := aRetorno[nX][11]
		aLote			:= aRetorno[nX][12]
								
		aadd(aListBox,{	iif(empty(cProtocolo) .Or.  cRetCodNfe $ RetCodDene(),oNo,oOk),;
							cId,;
							if(nAmbiente == 1,"Produ��o","Homologa��o"),; //"Produ��o"###"Homologa��o"
							if(nModalidade ==1 .Or. nModalidade == 4 .Or. nModalidade == 6, "Normal","Conting�ncia"),; //"Normal"###"Conting�ncia"
							cProtocolo,;
							cRecomendacao,;
							cTempoDeEspera,;
							nTempoMedioSef,;
							aLote;
							})
	Next	
EndIF
    
Return(aListBox)

*----------------------------------------------------------------------*
User Function zSpedNFeRe2(cSerie,cNotaIni,cNotaFim,lCTe,lRetorno,aNotas)
*----------------------------------------------------------------------*
Local aArea       	:= GetArea()
Local aPerg       	:= {}
Local aParam      	:= {Space(If(TamSx3("F2_SERIE")[1] == 14,TamSx3("F2_SDOC")[1],TamSx3("F2_SERIE")[1])),Space(TamSx3("F2_DOC")[1]),Space(TamSx3("F2_DOC")[1]),CtoD(""),CtoD("")}
Local aTexto      	:= {'',''}
Local aXML        	:= {}
local aAutoCfg      := {}
local bCaution      := {|| }
local cMsgCont		:= ""
local cError	  	:= ""
Local cRetorno    	:= ""
Local cIdEnt      	:= ""
Local cModalidade 	:= ""
Local cAmbiente   	:= ""
Local cVersao     	:= ""
Local cVersaoCTe  	:= ""
Local cVersaoMDFe	:= ""
Local cVersaoDpec 	:= ""
Local cMonitorSEF 	:= ""
Local cSugestao   	:= ""
Local cParNfeRem  	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local cURL        	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cVersTSS    	:= ""
local cCaution    	:= ""
Local nX          	:= 0
Local lOk         	:= .T.
Local lUsaColab   	:= .F.
Local lSdoc       	:= TamSx3("F2_SERIE")[1] == 14
Local lVoltar		:= .F.
Local cModel      	:= "55"
local oTBitmap1

Private oWS       := Nil

Default lCTe      := .F.
Default lRetorno  := .F.
Default aNotas	  := {}

If lCTE
	cModel:= "57"
EndIf

If cSerie == Nil
	MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfeRem,aPerg,1,aParam[01]),If(lSdoc,TamSx3("F2_SDOC")[1],TamSx3("F2_SERIE")[1]))
	MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfeRem,aPerg,2,aParam[02]),TamSx3("F2_DOC")[1])
	MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfeRem,aPerg,3,aParam[03]),TamSx3("F2_DOC")[1])
Else
	MV_PAR01 := aParam[01] := cSerie
	MV_PAR02 := aParam[02] := cNotaIni
	MV_PAR03 := aParam[03] := cNotaFim
EndIf

aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,.T.})	//"Nota fiscal final"

If .T. //IsReady(,,,lUsaColab)
	//�Obtem o codigo da entidade                                              
	//cIdEnt := GetIdEnt(lUsaColab)
    //cIdEnt := RetIdEnti(.F.)
	cIdEnt := GetCfgEntidade(@cError)

	if empty(cIdEnt)
		Aviso("SPED", cError, {'sair'}, 3) // STR0647 = 
	endif    

	If !Empty(cIdEnt)
		If .T.

			//Ambiente
			cAmbiente := getCfgAmbiente(@cError, cIdEnt, cModel)
			lOk := empty(cError)

			//Versao de Release do TSS
			If lOk
				cVersaoTSS := getVersaoTSS(@cError)
				lOk := empty(cError)
			EndIf

			//Cofigura��o de  par�metros(SEFAZ TSS ou TOTVS Colaboracao)
			If lOk .And. cVersaoTSS >= "1.35"
				setCfgParamSped(/*cError*/, /*cIdEnt*/, /*nAMBIENTE*/,/*nMODALIDADE*/, /*cVERSAONFE*/,/*cVERSAONSE*/,;
								 /*cVERSAODPEC*/,/*cVERSAOCTE*/, /*cNFEDISTRDANFE*/,/*cNFEENVEPEC*/,cModel, " ")
			EndIf

			// obtem a Modalidade
			If lOk
				cModalidade    := getCfgModalidade(@cError, cIdEnt, cModel)
				lOk := empty(cError)
			EndIf

			//Obtem a Versao de trabalho da NFe
			If lOk
				cVersao        := getCfgVersao(@cError, cIdEnt, cModel )
				lOk := empty(cError)
			EndIf

			// Obtem a Versao de trabalho da CTe
			If lOk
				cVersaoCTe     := getCfgVersao(@cError, cIdEnt, "57" )
				lOk := empty(cError)
			EndIf

			// Obtem a Versao de trabalho da MDFe
			If lOk .And. findfunction ("getCfgMdfe") .And. nModulo <> 43
				cVersaoMDFe     :=  getCfgMdfe(@cError)[5]
				lOk := empty(cError)
			EndIf

			//Obtem a Versao de trabalho do Dpec NFe
			If lOk
				cVersaoDpec	   := getCfgVerDpec(@cError, cIdEnt)
				lOk := empty(cError)
			EndIf

			//Configura a Versao de trabalho do Epec CTe
			If lOk
				If cModel == "57"
					getCfgEpecCte()
				EndIf
			EndIf

			//Verifica o status na SEFAZ
			If lOk .And. !lUsaColab
				oWS := WSNFeSBRA():New()
				oWS:cUSERTOKEN	:= "TOTVS"
				oWS:cID_ENT		:= cIdEnt
				oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
				if Type("oWS:oWSMODELOS") <> "U" //status da sefaz por modelo
					oWS:oWSMODELOS:OWSMODDOCS := NFESBRA_ARRAYOFMODDOC():NEW()
					aadd(oWS:oWSMODELOS:OWSMODDOCS:OWSMODDOC, NFESBRA_MODDOC():New())
					Atail(oWS:oWSMODELOS:OWSMODDOCS:OWSMODDOC):CMODELO := iif(lCTe,"57","55")
				endIf

				lOk := oWS:MONITORSEFAZMODELO()
				If lOk
					aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
					For nX := 1 To Len(aXML)
						// NFC-e tem um metodo de remessa especifico REMESSA3
						If aXML[nX]:cModelo == "65"		//NFC-e
							Loop
						Endif

						Do Case
							Case aXML[nX]:cModelo == "55"
								cMonitorSEF += "- NFe"+CRLF
								cMonitorSEF += "Versao do layout: "+cVersao+CRLF	//"Versao do layout: "
								If !Empty(aXML[nX]:cSugestao)
									cSugestao += "Sugest�o"+"(NFe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugest�o"
								EndIf

							    //Consulta configura��o de conting�ncia autom�tica no TSS
							    if( getCfgAutoCont( "0", cIdEnt, cModel, , , @aAutoCfg ) )

							        if( aAutoCfg[1] == "1")
							            cModalidade :=  getCfgModalidade(cError, cIdEnt, cModel, , .T.)

							            cMsgCont := CRLF + CRLF + space(20) + "Habilitada conting�ncia autom�tica para Modalidade " + getDescMod(aAutoCfg[2]) // "Habilitada conting�ncia autom�tica para Modalidade " = "Habilitada conting�ncia autom�tica para Modalidade "
							            cCaution := CRLF + space(21) + 'STR0019'

		                                bCaution := {|oObj| if(oTBitmap1 == nil, oTBitmap1 := TBitmap():New(02,29,260,184,,"UpdWarning.png",.T.,oObj, {||},,.F.,.F.,,,.F.,,.T.,,.F.), oTBitmap1:refresh()) , .T.}

							        else
							            cCaution := 'STR0019 '
							            cMsgCont := 'STR0020   '
							            bCaution := {||}
							        endif

							    endif

							Case aXML[nX]:cModelo == "57"
								cMonitorSEF += "- CTe"+CRLF
								cMonitorSEF += "Versao do layout: "+cVersaoCTe+CRLF	//"Versao do layout: "
								If !Empty(aXML[nX]:cSugestao)
									cSugestao += "Sugest�o"+"(CTe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugest�o"
								EndIf
							Case aXML[nX]:cModelo == "58"
								cMonitorSEF += "- MDFe"+CRLF
								cMonitorSEF += "Versao do layout: "+cVersaoMDFe+CRLF	//"Versao do layout: "
								If !Empty(aXML[nX]:cSugestao)
									cSugestao += "Sugest�o"+"(MDFe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugest�o"
								EndIf
						EndCase
						cMonitorSEF += Space(6)+"Vers�o da mensagem"+": "+aXML[nX]:cVersaoMensagem+CRLF //"Vers�o da mensagem"
						cMonitorSEF += Space(6)+"C�digo do Status"+": "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //"C�digo do Status"
		                cMonitorSEF += Space(6)+"UF Origem"+": "+aXML[nX]:cUFOrigem //"UF Origem"

		                If !Empty(aXML[nX]:cUFResposta)
			                cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
			   			Else
			   				cMonitorSEF += CRLF
			   			EndIf
		                If aXML[nX]:nTempoMedioSEF <> Nil
							cMonitorSEF += Space(6)+"Tempo de espera"+": "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //"Tempo de espera"
						EndIf
						If !Empty(aXML[nX]:cMotivo)
							cMonitorSEF += Space(6)+"Motivo"+": "+aXML[nX]:cMotivo+CRLF //"Motivo"
						EndIf
						If !Empty(aXML[nX]:cObservacao)
							cMonitorSEF += Space(6)+"Observa��o"+": "+aXML[nX]:cObservacao+CRLF //"Observa��o"
						EndIf
					Next nX
				EndIf
			EndIf
		EndIf

		//� Montagem da Interface                                                  
		If ((lOk .or. (empty(cError) .and. substr(cModalidade, 1,1) == "2") ) .And. (!lCTe))
			aTexto[1] := ''
			If lUsaColab
				aTexto[1] := "Esta rotina tem como objetivo auxilia-lo na gera��o do arquivo da Nota Fiscal eletr�nica para transmiss�o via TOTVS Colabora��o."+" " //"Esta rotina tem como objetivo auxilia-lo na gera��o do arquivo da Nota Fiscal eletr�nica para transmiss�o via TOTVS Colabora��o."
				aTexto[1] += "Neste momento o sistema, est� operando com a seguinte configura��o: "+CRLF+CRLF //"Neste momento o sistema, est� operando com a seguinte configura��o: "
				cVersTSS 	:= " TC2.0 "//"Ves�o - TSS ou TC2.0"
			Else
				aTexto[1] := "Neste momento o Totvs Services SPED, est� operando com a seguinte configura��o: "+" " 		//"Esta rotina tem como objetivo auxilia-lo na transmiss�o da Nota Fiscal eletr�nica para o servi�o Totvs Services SPED. "
				aTexto[1] += "Neste momento o Totvs Services SPED, est� operando com a seguinte configura��o: "+CRLF+CRLF //"Neste momento o Totvs Services SPED, est� operando com a seguinte configura��o: "
				cModalidade    := getCfgModalidade(@cError, cIdEnt, cModel,cModalidade)
				cVersTSS		:= " TSS: " + getVersaoTSS()
			EndIf

			aTexto[1] += "Ambiente: "+cAmbiente+CRLF //"Ambiente: "
			aTexto[1] += "Modalidade de emiss�o: "+cModalidade+CRLF	//"Modalidade de emiss�o: "
			aTexto[1] += "Ves�o - TSS ou TC2.0"+cVersTSS+CRLF	//"Ves�o - TSS ou TC2.0"
			If !Empty(cSugestao)
				aTexto[1] += CRLF
				aTexto[1] += cSugestao
				aTexto[1] += CRLF
			EndIf
			aTexto[1] += cMonitorSEF

            cRetorno := SpedNFeTrf(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,,,aParam[04],aParam[05], ,aNotas,@lVoltar)

		ElseIf (lCTe) .And. (lOk)
			SpedNFeTrf(aArea[1], aParam[1], aParam[2], aParam[3], cIdEnt, cAmbiente, cModalidade, cVersaoCTe, .T., lCTe, ,aParam[04],aParam[05], , aNotas)
		else
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)) + CRLF + cError,{"SAIR"},3) //"SPED" = "SPED"
		EndIf
		lRetorno := lOk
	Else
		lRetorno := .F.
	EndIf
Else
	lRetorno := .F.
EndIf

RestArea(aArea)
Return({lRetorno,aTexto[1],cRetorno})
