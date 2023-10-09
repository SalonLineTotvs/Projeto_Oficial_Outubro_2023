#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"


User Function zSLnotaSF2()

Local cQrysf2 := ""
local lchv:=.F.
private cNF :=""
private cSerieNF :=""
private cCli :=""
private cArquivo:=""
private cpasta:=""
//local cChave :=""

// If Select("SX6") == 0
// 	RpcSetType(3)
// 	RpcSetEnv("01","1201")
// Endif
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" TABLES "SA1", "SD2", "SB1","SF2" ,"SA4"

                    // cNF :="000007524"
                    // cSerieNF :="2  "
                    // cCli :="015640"
					// 	DBSELECTAREA('SF2')////
					// 	DBSETORDER(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	
                    //     IF SF2->(DBSEEK(xFilial('SF2')+cNF+cSerieNF+cCli)) //.and. TRBSF2->F2_X_ATIVA <>'1'
                    //         u_Spedxxx(cSerieNF,cNF,cNF, , , "55",, ,,,,)
					// 		//IF SF2->(DBSEEK(xFilial('SF2')+cNF+cSerieNF+cCli)) 
					// 		cArquivo := POSICIONE('SF2',1,xFilial('SF2')+cNF+cSerieNF+cCli,'F2_CHVNFE')
					// 		if !EMPTY(cArquivo)
					// 			if len(cArquivo) ==44 .and. substr(cArquivo,1,4)=='3223'
					// 			lchv:=.T.
					// 			endif	
					// 		endif
					// 						//endif 3223//
					// 		if lchv==.T.
					// 			//u_SLnotaSF2(cNF,cSerieNF,cCli) 
					// 			// RecLock('SF2',.F.)
					// 			// 	SF2->F2_X_ATIVA :='1'
					// 			// MsUnLock()
					// 			zGerDanfe(cNF, cSerieNF) //
					// 			cArquivo := cNF + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")//
					// 			cArquivo := POSICIONE('SF2',1,xFilial('SF2')+cNF+cSerieNF+cCli,'F2_CHVNFE')+'.pdf'
					// 			u_zFTPEnv('ftp1.ativalog.com.br', 21, 'zakat', '81BUTP21B*O2',cArquivo ) //32230738429600000142550020000072821214788684
					// 			u_emailnf2()
					// 		endif
                    //      ENDIF	


cQrysf2 :=	" select distinct F2_DOC, F2_SERIE , F2_CLIENT, F2_CLIENTE , F2_CHVNFE, len(F2_CHVNFE) as chave, F2_EMISSAO,F2_X_ATIVA from "+RETSQLNAME("SF2")+" f2 WITH (NOLOCK) "
cQrysf2 +=	" INNER JOIN "+RETSQLNAME("SD2")+" D2 WITH (NOLOCK) ON D2_TIPO='N' and D2_DOC = F2_DOC and D2_CLIENTE=F2_CLIENTE and D2_LOJA=F2_LOJA and D2_LOCAL= '95' and D2.D_E_L_E_T_='' "
cQrysf2 +=	" where f2.D_E_L_E_T_='' "
cQrysf2 +=	" and len(F2_CHVNFE)='44'  "
cQrysf2 +=	" and F2_EMISSAO>='20230705' "
cQrysf2 +=	" and F2_X_ATIVA<>'1' "
cQrysf2 +=	" and F2_FILIAL='1201' "

TCQUERY cQrysf2 NEW ALIAS "TRBSF2"

dbSelectArea("TRBSF2")
TRBSF2->(dbGoTop()) //

        While TRBSF2->(!EOF())   

                IF Empty(TRBSF2->F2_X_ATIVA) .and. substr(TRBSF2->F2_CHVNFE,1,4)=='3223'
                    cNF :=TRBSF2->F2_DOC
                    cSerieNF :=TRBSF2->F2_SERIE
                    cCli :=TRBSF2->F2_CLIENTE
						DBSELECTAREA('SF2')//
						DBSETORDER(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	
                        IF SF2->(DBSEEK(xFilial('SF2')+cNF+cSerieNF+cCli)) .and. TRBSF2->F2_X_ATIVA <>'1'
                            u_Spedxxx(cSerieNF,cNF,cNF, , , "55",, ,,,,)
							//IF SF2->(DBSEEK(xFilial('SF2')+cNF+cSerieNF+cCli)) 
							cArquivo := POSICIONE('SF2',1,xFilial('SF2')+cNF+cSerieNF+cCli,'F2_CHVNFE')
							if !EMPTY(cArquivo)
								if len(cArquivo) ==44 .and. substr(cArquivo,1,4)=='3223'
								lchv:=.T.
								endif	
							endif
											//endif 3223//
							if lchv==.T.
								u_SLnotaSF2(cNF,cSerieNF,cCli) 
								RecLock('SF2',.F.)
									SF2->F2_X_ATIVA :='1'
								MsUnLock()
								zGerDanfe(cNF, cSerieNF) //
								cArquivo := cNF + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")//
								cArquivo := POSICIONE('SF2',1,xFilial('SF2')+cNF+cSerieNF+cCli,'F2_CHVNFE')+'.pdf'
								u_zFTPEnv('ftp1.ativalog.com.br', 21, 'zakat', '81BUTP21B*O2',cArquivo ) //32230738429600000142550020000072821214788684
								u_emailnf2()
							endif
                         ENDIF	
                
                ENDIF
            TRBSF2->(dbSkip())
        EndDo
RESET ENVIRONMENT        
Return



static Function zGerDanfe(cNota, cSerie)
    Local aArea     := GetArea()
    Local cIdent    := ""
    Local cArquivo  := ""
    Local oDanfe    := Nil
    Local lEnd      := .F.
    Local nTamNota  := TamSX3('F2_DOC')[1]
    Local nTamSerie := TamSX3('F2_SERIE')[1]
    Local dDataDe   := sToD("20190101")
    Local dDataAt   := Date()
    local cPasta    := "\SPOOL\"//GetTempPath()//'\x_ftp_temp\'
    Private PixelX
    Private PixelY
    Private nConsNeg
    Private nConsTex
    Private oRetNF
    Private nColAux
    Private _cIniFile  := GetADV97()
    Private _cDirLoad  := GetPvProfString(GetEnvServer(),"StartPath","ERROR", _cIniFile )
    //Default cNota   := ""
    //Default cSerie  := ""
    //local cPasta  := GetTempPath()
       
    //Se existir nota
    If ! Empty(cNota)
        //Pega o IDENT da empresa
        cIdent := RetIdEnti()
           
        //Se o último caracter da pasta não for barra, será barra para integridade
        If SubStr(cPasta, Len(cPasta), 1) != "\"
            cPasta += "\"
        EndIf
           
        //Gera o XML da Nota
        SF2->(DBSEEK(xFilial('SF2')+cNota+cSerie+cCli)) 
        cArquivo := cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
        cArquivo :=POSICIONE('SF2',1,xFilial('SF2')+cNota+cSerie+cCli,'F2_CHVNFE')
        //u_zSpedXML(cNota, cSerie, cPasta + cArquivo  + ".xml", .F.)
        //SF2->(DBSEEK(xFilial('SF2')+cDoc+cSerie+cFornece)) 
           
        //Define as perguntas da DANFE
        Pergunte("NFSIGW",.F.)
        MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
        MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
        MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
        MV_PAR04 := 2                          //NF de Saida
        MV_PAR05 := 1                          //Frente e Verso = Sim
        MV_PAR06 := 2                          //DANFE simplificado = Nao
        MV_PAR07 := dDataDe                    //Data De
        MV_PAR08 := dDataAt                    //Data Até
           
        //Cria a Danfe
        oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., , .T.)
           
        //Propriedades da DANFE
        oDanfe:SetResolution(78)
        oDanfe:SetPortrait()
        oDanfe:SetPaperSize(DMPAPER_A4)
        oDanfe:SetMargin(60, 60, 60, 60)
           
        //Força a impressão em PDF
        oDanfe:nDevice  := 6
        oDanfe:cPathPDF := cPasta                
        oDanfe:lServer  := .T. //.F.
        oDanfe:lViewPDF := .F.
           
        //Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
        PixelX    := oDanfe:nLogPixelX()
        PixelY    := oDanfe:nLogPixelY()
        nConsNeg  := 0.4
        nConsTex  := 0.5
        oRetNF    := Nil
        nColAux   := 0
           
        //Chamando a impressão da danfe no RDMAKE
        //RptStatus({|lEnd| u_DanfeProc(@oDanfe, @lEnd, cIdent, , , .F.)},)
		u_DanfeProc(@oDanfe, @lEnd, cIdent, , , .F.)
        oDanfe:Print()
    EndIf
       
    RestArea(aArea)
Return


user function zFTPEnv(cServer, nPort, cUser, cPass, cFileOrig)
    //Local aArea   := GetArea()
    // Local lRet    := .T.
    // Local cDirAbs := GetTempPath() //GetSrvProfString("STARTPATH","")  
    // Private lConnected := .F.
    // cDirAbs       += + cArq+'.pdf' //"\" + cArq

    //Local cServer  := "server.site.com.br"
    //Local nPort    := 21
    //Local cUser    := "user"
    //Local cPass    := "senha@123"
    //Local lClose   := .F.
    //Local cFTPDest := " " //"/ZAKAT/"
	Local lClose   := .F.
    Local cTemp    := "\x_ftp_temp\"
    local cTemp2   := "\SPOOL\"//GetTempPath()
    Private _cIniFile  := GetADV97()
    Private _cDirLoad  := GetPvProfString(GetEnvServer(),"StartPath","ERROR", _cIniFile )
     
     //lConnected := FTPConnect('ftp1.ativalog.com.br', 21, 'integra', 'integra') //FTPConnect(cEndereco ,nPorta ,cUsr , cPass ) //FTPConnect( AllTrim(cServer), nPorta, cMyUser, cMyPass)
    //Se conseguir conectar
    //If FTPConnect('ftp1.ativalog.com.br', 21, 'integra', 'integra') //FTPConnect(cEndereco ,nPorta ,cUsr , cPass )
         
        //Desativa o firewall

    //Se tiver o arquivo e o destino//
    If ! Empty(cFileOrig) //.And. !Empty(cFTPDest)
         
        //Tenta estabelecer a conexão
        If FTPConnect(cServer, nPort, cUser, cPass)
             
            //Pega apenas o nome do arquivo com a extensão
            cNameFile := SubStr(cFileOrig, RAt("\", cFileOrig) + 1, Len(cFileOrig))
             
            //Se não existir a pasta temporária dentro da Protheus Data, cria ela
            If ! ExistDir(cTemp)
                MakeDir(cTemp)
            EndIf
            __CopyFile(cTemp2+cFileOrig, "\x_ftp_temp\"+cFileOrig,,,.F.) //
           // CpyT2S(cFileOrig, cTemp+cFileOrig)
             
           // If FTPDirChange(cFTPDest)
                If FTPUpload("\x_ftp_temp\"+cNameFile, cNameFile)
					//If FTPUpload("\x_ftp_temp\"+cNameFile, cFTPDest + cNameFile)
                    MsgInfo("Arquivo copiado para o FTP com sucesso!", "Atenção")
                Else
                    MsgStop("Falha ao copiar o arquivo para o FTP!", "Atenção")
                EndIf
                 
           // Else
             //   MsgStop("Não foi possível mudar o diretório de Upload!", "Atenção")
           // EndIf
             
            //Fecha a conexão
            lClose := FTPDisconnect()
            If ! lClose
                MsgStop("Falha ao fechar a conexão!", "Atenção")
            EndIf
        Else
            MsgStop("Erro de conexão!", "Atenção")//
        EndIf
    EndIf
Return



//////////////////// consulta monitor/faixa

user Function Spedxxx(cSerie,cNotaIni,cNotaFim, lCTe, lMDFe, cModel,lTMS, lAutoColab,lExibTela,lUsaColab,lNFCE,lICC)

Local cIdEnt   := ""
local cUrl			:= Padr( GetNewPar("MV_SPEDURL",""), 250 )
Local aPerg    := {}
Local aParam   := {Space(Len(SerieNfId("SF2",2,"F2_SERIE"))),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),CtoD(""),CtoD("")}
Local aSize    := {}
Local aObjects := {}
Local aListBox := {}
Local aInfo    := {}
Local aPosObj  := {}
Local oWS
Local oDlg
Local oListBox
Local oBtn1
Local oBtn2
Local oBtn3
Local oBtn4
Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local lOK        := .F.
Local dDataDe		:= CtoD("")
Local dDataAte	:= CtoD("")
Local lSdoc     := TamSx3("F2_SERIE")[1] == 14
Local cSerie   := cSerie
Local cNotaIni := cNotaIni
Local cNotaFim := cNotaFim
Local cModel	 := "55"
local lchv :=.F.

// Default cSerie   := ''
// Default cNotaIni := ''
// Default cNotaFim := ''
Default lCTe     := .F.
Default lMDFe    := .F.
Default cModel	 := ""
default lTMS     := .F.
Default lAutoColab := .F.
Default lExibTela := .F. // Não exibe se Falso
Default lUsaColab := .F.
Default lNFCE	:= IIf (FunName()$"LOJA701",.T.,.F.)
Default lICC    := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento da NFCe para o Loja                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


// If !lAutoColab
// aadd(aPerg,{1,Iif(lMDFe,"STR0249","STR0010"),aParam[01],"",".T.","",".T.",30,.F.}) //"Serie da Nota Fiscal"
// aadd(aPerg,{1,Iif(lMDFe,"STR0459","STR0011"),aParam[02],"",".T.","",".T.",30,.T.}) //"Nota fiscal inicial"
// aadd(aPerg,{1,Iif(lMDFe,"STR0460","STR0012"),aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

// aParam[01] := ParamLoad(cParNfeRem,aPerg,1,aParam[01])
// aParam[02] := ParamLoad(cParNfeRem,aPerg,2,aParam[02])
// aParam[03] := ParamLoad(cParNfeRem,aPerg,3,aParam[03])
// EndIF

// If lSdoc
// 	aadd(aPerg,{1,"Dt. Emissão De"	,aParam[04],"@R 99/99/9999",".T.","",".T.",50,.F.}) 			//"Data de Emissão"
// 	aadd(aPerg,{1,"Dt. Emissão Até"	,aParam[05],"@R 99/99/9999",".T.","",".T.",50,.F.}) 			//"Data de Emissão"

// 	dDataDe := aParam[04] := ParamLoad(cParNfeRem,aPerg,4,aParam[04])
// 	dDataAte := aParam[05] := ParamLoad(cParNfeRem,aPerg,5,aParam[05])
// EndIf

If IsReady( ,,,lUsaColab )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIdEnt := GetIdEnt( lUsaColab )
	If !Empty(cIdEnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Instancia a classe                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// If !Empty(cIdEnt)
		// 	// If lAutoColab
		// 	// 	aParam[01] := cSerie
		// 	// 	aParam[02] := cNotaIni
		// 	// 	aParam[03] := cNotaFim
		// 	// 	lOK        := .T.
		// 	// Else
		// 	// If (lCTe) .And. !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim)
		// 	// 	aParam[01] := cSerie
		// 	// 	aParam[02] := cNotaIni
		// 	// 	aParam[03] := cNotaFim
		// 	// 	lOK        := .T.
		// 	// ElseIf (lMDFe) .And. !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim)
		// 	// 	aParam[01] := cSerie
		// 	// 	aParam[02] := cNotaIni
		// 	// 	aParam[03] := cNotaFim
		// 	// 	lOK        := .T.
		// 	// Else
		// 	// 		IF (lExibTela)
		// 	// 			aParam[01] := cSerie
		// 	// 			aParam[02] := cNotaIni
		// 	// 			aParam[03] := cNotaFim
		// 	// 			lOK        := .T.
		// 	// 		Else
		// 	// 			lOK        := ParamBox(aPerg,"SPED - NFe",@aParam,,,,,,,cParNfeRem,.T.,.T.)
		// 	// 			cSerie   := aParam[01]
		// 	// 			cNotaIni := aParam[02]
		// 	// 			cNotaFim := aParam[03]
		// 	// 		EndIF
		// 	// EndIf //

		// 	// If lSdoc
		// 	// 	dDataDe  := aParam[04]
		// 	// 	dDataAte := aParam[05]
		// 	// 	GetFiltroF3(@aParam,,dDataDe,dDataAte)
		// 	// EndIF
		// 	// EndIF
		// 	If (lOK)
		// 		If lMDFe .And. !lUsaColab
		// 			aListBox := WsMDFeMnt(cIdEnt,cSerie,cNotaIni,cNotaFim,.T.)
		// 		Else
		// 			aListBox := getListBox(cIdEnt, cUrl, aParam, 1, cModel, lCte, .T., lMDFe, lTMS,lUsaColab,lICC)
		// 		EndIf
		// 		If !Empty(aListBox) .And. !lAutoColab
		// 			aSize := MsAdvSize()
		// 			aObjects := {}
		// 			AAdd( aObjects, { 100, 100, .t., .t. } )
		// 			AAdd( aObjects, { 100, 015, .t., .f. } )

		// 			aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		// 			aPosObj := MsObjSize( aInfo, aObjects )

		// 			DEFINE MSDIALOG oDlg TITLE "SPED - NFe" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

		// 			If Len(aListBox[1]) >= 10
		// 				// @ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "",STR0049,STR0035,STR0036,STR0050,STR0051,STR0052,STR0053, "Tentativas", "Observacao"; //"NF"###"Ambiente"###"Modalidade"###"Protocolo"###"Recomendação"###"Tempo decorrido"###"Tempo SEF"
		// 				// 	SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
		// 			Else
		// 				// @ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "",STR0049,STR0035,STR0036,STR0050,STR0051,STR0052,STR0053; //"NF"###"Ambiente"###"Modalidade"###"Protocolo"###"Recomendação"###"Tempo decorrido"###"Tempo SEF"
		// 				// 	SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
		// 			EndIf		
		// 			oListBox:SetArray( aListBox )//
		// 			If Len(aListBox[1]) >= 10
		// 				oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ],aListBox[ oListBox:nAT,8 ],aListBox[ oListBox:nAT,10 ],aListBox[ oListBox:nAT,11 ] } }
		// 			Else
		// 				oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ],aListBox[ oListBox:nAT,8 ] } }
		// 			EndIf	

		// 			// @ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn1 PROMPT STR0114   		ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011 //"OK"
		// 			// @ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn2 PROMPT STR0054   		ACTION (Bt2NFeMnt(aListBox[oListBox:nAT][09])) OF oDlg PIXEL SIZE 035,011 //"Mensagens"
		// 			// @ aPosObj[2,1],aPosObj[2,4]-120 BUTTON oBtn3 PROMPT STR0055   		ACTION (Bt3NFeMnt(cIdEnt,aListBox[ oListBox:nAT,2 ],,lUsaColab,cModel)) OF oDlg PIXEL SIZE 035,011 //"Rec.XML"
		// 			// If lMDFe .And. !lUsaColab
		// 			// 	@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT STR0118 	ACTION (aListBox := WsMDFeMnt(cIdEnt,cSerie,cNotaIni,cNotaFim,.T.),oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //"Refresh"
		// 			// Else
		// 			// 	@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT STR0118 	ACTION (aListBox := getListBox(cIdEnt, cUrl, aParam, 1, cModel, lCte, .T., lMDfe, lTMS,lUsaColab),oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //"Refresh"
		// 			// EndIf
		// 			// @ aPosObj[2,1],aPosObj[2,4]-200 BUTTON oBtn4 PROMPT STR0115  		ACTION (Bt3NFeMnt(cIdEnt,aListBox[ oListBox:nAT,2 ],2,lUsaColab,cModel)) OF oDlg PIXEL SIZE 035,011 //"Schema"
		// 			ACTIVATE MSDIALOG oDlg
		// 		EndIf
		// 	EndIf
		// EndIf
	Else
		Aviso("SPED","STR0021",{"STR0114"},3)	//"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
	EndIf
Else
	Aviso("SPED","STR0021",{"STR0114"},3) //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
EndIf
			// DBSELECTAREA('SF2')//
			// DBSETORDER(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		
			// IF SF2->(DBSEEK(xFilial('SF2')+cNF+cSerieNF+cCli)) 
			// 	cArquivo := POSICIONE('SF2',1,xFilial('SF2')+cNF+cSerieNF+cCli,'F2_CHVNFE')
			// 	if !EMPTY(cArquivo)
			// 		if len(cArquivo) =='44' 
			// 			lchv:=.T.
			// 		endif	
			// 	endif
			// endif
Return()





/////////////////////

Static Function IsReady(cURL,nTipo,lHelp,lUsaColab)

Local nX       := 0
Local cHelp    := ""
local cError	:= ""
Local oWS
Local lRetorno := .F.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.
DEFAULT lUsaColab := .F.
if !lUsaColab
   If FunName() <> "LOJA701"
   		If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial( "SX6" )
			SX6->X6_VAR     := "MV_SPEDURL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "URL SPED NFe"
			MsUnLock()
			PutMV("MV_SPEDURL",cURL)
		EndIf
		SuperGetMv() //Limpa o cache de parametros - nao retirar
		DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Else
		If !Empty(cURL) .And. !PutMV("MV_NFCEURL",cURL)
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial( "SX6" )
			SX6->X6_VAR     := "MV_NFCEURL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "URL de comunicação com TSS"
			MsUnLock()
			PutMV("MV_NFCEURL",cURL)
		EndIf
		SuperGetMv() //Limpa o cache de parametros - nao retirar
		DEFAULT cURL      := PadR(GetNewPar("MV_NFCEURL","http://"),250)
	EndIf
	//Verifica se o servidor da Totvs esta no ar
	if(isConnTSS(@cError))
		lRetorno := .T.
	Else
		If lHelp
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"STR0114"},3)
		EndIf
		lRetorno := .F.
	EndIf


	//Verifica se Há Certificado configurado
	If nTipo <> 1 .And. lRetorno

		if( isCfgReady(, @cError) )
			lRetorno := .T.
		else
			If nTipo == 3
				cHelp := cError

				If lHelp .And. !"003" $ cHelp
					Aviso("SPED",cHelp,{"STR0114"},3)
					lRetorno := .F.

				EndIf

			Else
				lRetorno := .F.

			EndIf
		endif

	EndIf

	//Verifica Validade do Certificado
	If nTipo == 2 .And. lRetorno
		isValidCert(, @cError)
	EndIf
else
	lRetorno := ColCheckUpd()
	if lHelp .And. !lRetorno .And. !lAuto
		MsgInfo("UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0")
	endif
endif

Return(lRetorno)



Static Function GetIDEnt( cType, nRegType, cRegNumber, cIE, cUF, cCompanyName, cBranchName, cCountyCode, cGrantNumber, cURL, cMsgReturn )

Local oWs		:=	Nil
Local cIDEnt	:=	""

Default cMsgReturn	:=	""

oWS := WSSpedAdm():New()
oWS:cUserToken				:=	"TOTVS"
oWS:_URL					:=	AllTrim( cURL ) + "/SPEDADM.apw"
oWS:oWSEmpresa:cCNPJ		:=	Iif( nRegType == 1, AllTrim( cRegNumber ), "" )
oWS:oWSEmpresa:cCPF			:=	Iif( nRegType == 2, AllTrim( cRegNumber ), "" )
oWS:oWSEmpresa:cIE			:=	cIE
oWS:oWSEmpresa:cIM			:=	""
oWS:oWSEmpresa:cNome		:=	cCompanyName
oWS:oWSEmpresa:cFantasia	:=	cBranchName
oWS:oWSEmpresa:cEndereco	:=	""
oWS:oWSEmpresa:cNum			:=	""
oWS:oWSEmpresa:cCompl		:=	""
oWS:oWSEmpresa:cUF			:=	cUF
oWS:oWSEmpresa:cCEP			:=	""
oWS:oWSEmpresa:cCod_Mun		:=	cCountyCode
oWS:oWSEmpresa:cCod_Pais	:=	"1058"
oWS:oWSEmpresa:cBairro		:=	""
oWS:oWSEmpresa:cMun			:=	""
oWS:oWSEmpresa:cCEP_CP		:=	Nil
oWS:oWSEmpresa:cCP			:=	Nil
oWS:oWSEmpresa:cDDD			:=	""
oWS:oWSEmpresa:cFone		:=	""
oWS:oWSEmpresa:cFax			:=	""
oWS:oWSEmpresa:cEmail		:=	""
oWS:oWSEmpresa:cNIRE		:=	""
oWS:oWSEmpresa:dDTRE		:=	SToD( "" )
oWS:oWSEmpresa:cNIT			:=	""
oWS:oWSEmpresa:cIndSiteSP	:=	""
oWS:oWSEmpresa:cID_Matriz	:=	""

If ValType( cGrantNumber ) <> "U"
	If cType == "POST"
		oWS:oWSEmpresa:cUPDINSCRTR	:=	"S"
		oWS:oWSEmpresa:cINSCRTRA	:=	AllTrim( cGrantNumber )
	ElseIf cType == "GET"
		oWS:oWSEmpresa:cUPDINSCRTR	:=	"N"
		oWS:oWSEmpresa:cINSCRTRA	:=	AllTrim( cGrantNumber )
	EndIf
EndIf

If oWs:AdmEmpresas()
	cIDEnt := AllTrim( oWs:cAdmEmpresasResult )
Else
	cMsgReturn := Iif( Empty( GetWscError( 3 ) ), GetWscError( 1 ), GetWscError( 3 ) )

	If "WSCERR044" $ cMsgReturn
		cMsgReturn := "Falha ao tentar se conectar ao TSS." + CRLF + CRLF
		cMsgReturn += "Configurações usadas: " + CRLF
		cMsgReturn += "Url Totvs Service SOA: " + AllTrim( cURL ) + CRLF + CRLF
		cMsgReturn += "Verifique as configurações do servidor e se o mesmo está ativo."
	EndIf
EndIf

oWS := Nil

FreeObj( oWS )

Return( cIDEnt )



user function emailnf2()

	Local cQuery :=""
	Local cTRB0  := CriaTrab(NIL, .F.)
	Local cTRB  := CriaTrab(NIL, .F.)	
	Local cQuery2 :=""
	Local cTRB2  := CriaTrab(NIL, .F.)	
	Local cTitulo := ""
	Local cTitulo2 := ""
	Local dData1
	Local dData5 := DtoC(Date())
	Local cDestinatarios := ""
	Local cAssunto := ""
	Local cNum :=""
	local nw

//PREPARE ENVIRONMENT EMPRESA ( "05" ) FILIAL ( "1201" ) MODULO "FAT"
	
	//Definição dos valores específicos
	
	//cDestinatarios := "suporte@coferly.com.br;" // UsrRetMail(cUserID)
	cAssunto 		 := " |PEDIDO 7821 FATURADO (OPERADOR LOGÍSTICO ATIVA)| Email Automático, Favor Não Responder."
	cTitulo        := " PEDIDOS FATURADOS "
	cTitulo2       := " PEDIDOS FATURADOS "
	
	// cQry 		 :=""
	// // cQry 		 += " select * from SAK120 "
	// // cQry          += " where D_E_L_E_T_ ='' "
	// // cQry         += " ORDER BY  AK_COD  "

	// 	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cTRB0, .T., .F.)	
	
 	
//While ((cTRB0)->(!Eof()))  // cNF+cSerieNF+cCli
 
	cDestinatarios := "luiz.vasconcelos@salonline.com.br;faturamento@salonline.com.br;elayne.goldner@salonline.com.br;distribuidora.zakat@gmail.com;frederico.mattos@salonline.com.br;"//+ IIF( alltrim((cTRB0)->AK_COD) <>'' ,alltrim(UsrRetMail((cTRB0)->AK_USER)) ,"suporte@coferly.com.br") //000043 +alltrim(UsrRetMail((cTRB0)->AK_USER)) //pega email do aprovador 
	cQuery 		 :=""
	cQuery 		 += " select distinct F2_FILIAL,F2_DOC, F2_SERIE , F2_CLIENT, F2_CLIENTE,F2_LOJA , F2_CHVNFE ,D2_PEDIDO,D2_EST from  "+RETSQLNAME("SF2")+" F2 "
	 cQuery 		 += " INNER JOIN "+RETSQLNAME("SD2")+" D2  ON D2_TIPO='N' and D2_DOC = F2_DOC and D2_CLIENTE=F2_CLIENTE and D2_LOJA=F2_LOJA and D2_LOCAL= '95' and D2.D_E_L_E_T_=''  "
	cQuery         += " where F2.D_E_L_E_T_=''  " 
	cQuery         += " and  F2_DOC IN ('"+cNF+"') "
	cQuery         += " and F2_SERIE in ('"+cSerieNF+"') "
	cQuery         += " and F2_CLIENTE in ('"+cCli+"') "
		cQuery         += " and F2_FILIAL in ('1201') "
	//cQuery         += " ORDER BY CR_APROV ("+cNumNF+") "//

	TCQUERY cQuery NEW ALIAS "cTRB11"

dbSelectArea("cTRB11")

	cAssunto 		 := " |PEDIDO "+cTRB11->D2_PEDIDO+" FATURADO (OPERADOR LOGÍSTICO ATIVA)|
if 	!Empty(cDestinatarios)//(cTRB)->CR_APROV)  //((cTRB)->(!Eof())))
 	
	_cHTML:='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	_cHTML+='<html xmlns="http://www.w3.org/1999/xhtml">'
	_cHTML+='<head>'
	_cHTML+='<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
	_cHTML+='<title>ZAKAT- PEDIDOS FATURADOS</title>'
	_cHTML+='<style type="text/css"> '
	_cHTML+='table.bordasimples {border-collapse: collapse;} '
	_cHTML+='table.bordasimples tr td {border:1px solid #ccc; padding:0 0 0 10px;font:16px "Calibri"} '
	_cHTML+='.slogan{width: 400px;height:50px;font:16px "Calibri", Times, serif;color:#999;}'
	_cHTML+='</style>'
	_cHTML+='</head>'
	// _cHTML+='<body>'
	// _cHTML+='<H3 class="slogan">E-mail automático enviado pelo sistema Totvs Protheus</H3>'
	// _cHTML+='<H3 class="slogan">'+cTitulo+'</H3>'
	// _cHTML+='<table style="width: 1800px;" class="bordasimples" border="1" bordercolor="#cccccc" >'
	// _cHTML+='		<TR>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Filial</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Nº Pedido</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Tipo</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Total</td>'	
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Moeda</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Taxa</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Valor Conversao Real</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Dt. Emissao</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Grupo</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Aprovador</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Nivel</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Status</td>'
	// _cHTML+='		</TR>'
	
	//cAprov := (cTRB)->CR_APROV
		//While ((cTRB)->(!Eof())) //.AND. cr_ujser =
		
		// dData1 := StoD((cTRB)->CR_EMISSAO)
		// cNum += ","+"'"+alltrim((cTRB)->CR_NUM )+"'"
		// //cMoeda := (cTRB)->CR_MOEDA
		// 	_cHTML+='		<TR>	'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_FILIAL+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_NUM+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_TIPO+'</TD>'
		// 	//_cHTML+='			<TD style="font-size:14px;">'+cValToChar((cTRB)->CR_TOTAL)+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB)->CR_TOTAL,6),"@E 999,999.99 ")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+IIF ( (cTRB)->CR_MOEDA ==1 ,"REAL" ,"DOLAR")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB)->CR_TXMOEDA,6),"@E 999,999.9999 ")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+"R$ "+Transform(round((cTRB)->VALOR_CONVERSAO_REAL,6),"@E 999,999.99 ")+'</TD>
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->(DtoC(dData1))+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_GRUPO+"-"+ alltrim(POSICIONE("SAL",1,XFILIAL("SAL")+alltrim((cTRB)->CR_GRUPO),"AL_DESC"))+		'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_APROV+" - "+ alltrim(POSICIONE("SAK",1,XFILIAL("SAK")+alltrim((cTRB)->CR_APROV),"AK_LOGIN"))+	'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_NIVEL+'</TD>'
		// 	_cHTML+='			<TD style="font-size:14px;">'+(cTRB)->CR_STATUS +" - AGUARDANDO LIBERACAO DE USUARIO" +'</TD>'
		// 	_cHTML+='		</TR>'
		// 	(cTRB)->(DbSkip())
		// 	if Empty((cTRB)->CR_APROV)
		// 	cNum:= Alltrim (substr(cNum, 2, 400))  
		// 	//(cTRB)->(dbclosearea())
		// 	endif
		// 	//cAprov := (cTRB)->CR_APROV
		// //EndDo		
		//cNum
		//cNum:= Alltrim (substr(cNum, 2, 400)) 
	// 	cQuery2 :=""
	// 	cQuery2        += " SELECT C7_ITEM,C7_OBS, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_TOTAL,C7_MOEDA, C7_TXMOEDA,(C7_TOTAL * C7_TXMOEDA) as VALOR_CONVERSAO_REAL, C7_CC,C7_CONTA, C7_FORNECE, * FROM SC7020  "
	// 	cQuery2        += " WHERE D_E_L_E_T_='' AND C7_ORIGEM ='MATA170' AND C7_ENCER <>'E' AND C7_QUJE ='0'    " //arrumar regra pra mandar penas em aberto pendente que seja do ponto por pedido

	// 	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery2), cTRB2, .T., .F.)
	// cnum:=""
	// _cHTML+='	</TBODY>'
	// _cHTML+='</TABLE>'
	_cHTML+='<H3 class="slogan">'+cTitulo2+'</H3>'
	_cHTML+='<H3 class="slogan">Prezados,</H3>'
	_cHTML+='<H4 class="slogan">Seguem o pedido faturado da filial Zakat e que serão expedidos pelo Operador Logístico Ativa.</H4>'
	_cHTML+='<H4 class="slogan">Verifique se o cliente precise de guia de recolhimento, caso seja necessário, solicitar o pagamento e enviar a guia/comprovante</H4>'
	_cHTML+='<H4 class="slogan">para os e-mails :  a.almeida@ativalog.com.br ; Admvix2@ativalog.com.br; elayne.goldner@salonline.com.br;distribuidora.zakat@gmail.com; frederico.mattos@salonline.com.br</H4>'
	_cHTML+='<table style="width: 1800px;" class="bordasimples" border="1" bordercolor="#cccccc" >'
	_cHTML+='		<TR>'
		_cHTML+='		<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Filial</td>'
			_cHTML+='		<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Nome</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Pedido</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Nota</td>'
		_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Cod.Cliente</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Cliente</td>'
	_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">UF</td>'
	//_cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Quant disponivel </td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Total</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Moeda</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Taxa</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Valor Conversao Real</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Centro Custo</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Conta</td>'
	// _cHTML+='			<td style="background-color: rgb(238, 238, 238); font-weight: bold;">Fornecedor</td>'
	_cHTML+='		</TR>'
		//For nw := 1 To Len(aPedmail)
		//While ((cTRB2)->(!Eof()))
		
		//dData2 := StoD((cTRB2)->XI2_DTVENC)
			
			_cHTML+='		<TR>	'
			_cHTML+='			<TD style="font-size:14px;">'+cTRB11->F2_FILIAL+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+"ZAKAT"+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+cTRB11->D2_PEDIDO+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+cTRB11->F2_DOC+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+cTRB11->F2_CLIENTE+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+cTRB11->F2_CLIENTE+cTRB11->F2_LOJA,"A1_NOME"))+'</TD>'
			_cHTML+='			<TD style="font-size:14px;">'+cTRB11->D2_EST+'</TD>'
		//	_cHTML+='			<TD style="font-size:14px;">'+cValToChar( aPedmail[nw][6])+'</TD>'
		//	_cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB2)->C7_PRECO,6),"@E 999,999.99 ")+'</TD>'   
		//	_cHTML+='			<TD style="font-size:14px;">'+cValToChar( (cTRB2)->C7_PRECO )+'</TD>' 
			// _cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB2)->C7_TOTAL,6),"@E 999,999.99 ")+'</TD>' 
			// _cHTML+='			<TD style="font-size:14px;">'+IIF ( (cTRB2)->C7_MOEDA ==1 ,"REAL" ,"DOLAR")+'</TD>
			// _cHTML+='			<TD style="font-size:14px;">'+Transform(round((cTRB2)->C7_TXMOEDA,6),"@E 999,999.9999 ")+'</TD>
			// _cHTML+='			<TD style="font-size:14px;">'+"R$ "+Transform(round((cTRB2)->VALOR_CONVERSAO_REAL,6),"@E 999,999.99 ")+'</TD>
			
		//	_cHTML+='			<TD style="font-size:14px;">'+cValToChar( (cTRB2)->C7_TOTAL)+'</TD>' 
			//_cHTML+='			<TD style="font-size:14px;">'+DtoC(dData2)+'</TD>'
			// _cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->C7_CC+" - "+IIF( Empty(alltrim((cTRB2)->C7_CC)) ,"",alltrim(POSICIONE("CTT",1,XFILIAL("CTT")+alltrim((cTRB2)->C7_CC),"CTT_DESC01")))  +'</TD>'
			// _cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->C7_CONTA+" - "+alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+alltrim((cTRB2)->C7_CONTA),"CT1_DESC01"))+'</TD>'
			// _cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->C7_FORNECE +" - "+alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+alltrim((cTRB2)->C7_FORNECE),"A2_NOME"))+'</TD>'
			// //_cHTML+='			<TD style="font-size:14px;">'+(cTRB2)->XI2_STATUS+'</TD>'
			_cHTML+='		</TR>'
			//(cTRB2)->(DbSkip())
		//EndDo	
		//next nw

		dData5 := DtoC(Date())
		
	_cHTML+='	</TBODY>'
	_cHTML+='</TABLE>'
	_cHTML+='<div class="slogan" style="margin-top:30px;"> Lista atualizada em: '+ dData5 +' às '+Time()+'.</div>'
	_cHTML+='</BODY>'
	_cHTML+='</HTML>'
//u_g2EnvMail(cDestinatarios,,, cAssunto, _cHTML, NIL,'', .F., ,.F.)
	U_ENVMAIL3(,cDestinatarios,cAssunto,_cHTML,NIL,.F.)	
//	U_SendMail( cMail,_cTo,, cAssunto, cBody, )
	//(cTRB2)->(dbclosearea())
ENDIF	
//(cTRB0)->(DbSkip())
//(cTRB)->(dbclosearea())
//(cTRB2)->(dbclosearea())
cNum :=""
//EndDo		


//RESET ENVIRONMENT
Return


User Function ENVMAIL3(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Variaveis da função

Private _nTentativas := 0
Private _cSMTPServer := GetMV("MV_RELSERV")
Private _cAccount    := GetMV("MV_RELACNT")
Private _cPassword   := GetMV("MV_RELPSW")
Private _lEnviado    := .F.
Private _cUsuario    := Upper(AllTrim(cUserName))

// Validação dos campos do email

If _pcBcc == NIL
	_pcBcc := ""
EndIf

_pcBcc := StrTran(_pcBcc," ","")

If _pcOrigem == NIL
	_pcOrigem := GetMV("MV_RELACNT")
EndIf

_pcOrigem := StrTran(_pcOrigem," ","")

If _pcDestino == NIL
	_pcDestino := "seuemail@dominio.com.br"
EndIf

_pcDestino := StrTran(_pcDestino," ","")

If _pcSubject == NIL
	_pcSubject := "Sem Subject (ENVMAIL)"
EndIf

If _pcBody == NIL
	_pcBody := "Sem Body (ENVMAIL)"
EndIf

If _pcArquivo == NIL
	_pcArquivo := ""
EndIf

For _nAux := 1 To 10
	_pcOrigem := StrTran(_pcOrigem," ;","")
	_pcOrigem := StrTran(_pcOrigem,"; ","")
Next

If _plAutomatico == NIL
	_plAutomatico := .F.
EndIf

// Executa a função, mostrando a tela de envio (.T.) ou não (.F.)

If !_plAutomatico
	Processa({||EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)},"Enviando Email(s)...")
Else
	EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
EndIf

If !_plAutomatico
	If !_lEnviado
		MsgStop("Atenção: Erro no envio de Email!!!")
	EndIf
Else
	ConOut("Atenção: Erro no envio de Email!")
Endif

Return _lEnviado

/*
***********************************************
* Progrma: EnviaEmail   Autor: Luiz Henrique  *
* Descrição: Subrotina para envio de email.   *
* Data: 23/12/2020                           *
* Parametros: EMail Origem, EMail Destino,    *
*             Subject, Body, Anexo, .T., Bcc  *
***********************************************
*/ 
Static Function EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Veriaveis da função
//**************************************************************
Local _nTentMax := 50  // Tentativas máximas
Local _nSecMax  := 30  // Segundos máximos  
Local _cTime    := (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
Local _nAuxTime := 0
Local lAutentica    := GetMV("MV_RELAUTH") 

// O que ocorrer primeiro (segundos ou tentativas), ele para.
//**************************************************************
_cTime += _nSecMax

If !_plAutomatico
	ProcRegua(_nTentMax)
EndIf

// Exibe mensagem no console/Log
//**************************************************************
ConOut("ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

For _nTentativas := 1 To _nTentMax
	
	If !_plAutomatico
		IncProc("Tentativa "+AllTrim(Str(_nTentativas)))
	EndIf
	ConOut("ENVMAIL=> ***** Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
	
	CONNECT SMTP SERVER _cSMTPServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lEnviado
	
	
	If _lEnviado
	
		// Verifica se o E-mail necessita de Autenticacao
     	If lAutentica     
        	_lEnviado := MailAuth(_cAccount,_cPassword) 
    	Else
       	_lEnviado := .T.
    	Endif
    	
		If Empty(_pcBcc)
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		Else
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		EndIf
		DISCONNECT SMTP SERVER
	EndIf
	
	If _lEnviado .Or. _cTime <= (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
		_nTentativas := _nTentMax
	EndIf
	
Next

ConOut("ENVMAIL=> ***** Resultado de Envio "+IIf(_lEnviado,"T","F")+" / "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

Return


