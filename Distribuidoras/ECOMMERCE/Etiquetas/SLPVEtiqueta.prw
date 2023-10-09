#include 'protheus.ch'
#include 'fwprintsetup.ch'
#include 'rptdef.ch'   
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "shell.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#DEFINE ENTER Chr(13)+Chr(10) 

//Constantes
#Define ENTER	Chr(13)+ Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ zImpPvEtq   º Autor ³ Genesis/Gustavo   Data ³  28/10/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Etiqueta Pedido de Venda                                   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/   
*----------------------------------*
User function zAutoPvEtq(_cPedAuto)
*----------------------------------*
Default _cPedAuto := '000056'
If Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("02","1501")
Endif

DbSelectArea('SC5');SC5->(DbSetOrder(1))
IF !SC5->(DbSeek(xFilial('SC5')+_cPedAuto))
    RETURN
ENDIF

IF ExistBlock("zImpPvEtq")
	ExecBlock("zImpPvEtq",.F.,.F.,{})
ENDIF
RETURN

*----------------------*
USer function zImpPvEtq
*----------------------*
Local _cPerg   := 'zImpPvEtq'
Local _aArea   := fWGetArea()
Local _cNumPed := ''
Local _cCB5Def := ''
Local lOk        := .F.
Local aArea      := {}
Local aAreaCB5   := {}
Local aAreaSF3   := {}
Local aAreaSF2   := {}
Local aAreaSF1   := {}
Local aAreaSA1   := {}
Local aAreaSA2   := {}
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
Local _aPVend       := {}
Local aEmit      := {}
Local _aDest      := {}
Local cCgc       := ""
Local cNome      := ""
Local cInscr     := ""
Local cUF        := ""
Local nContD_aPVend := 0
Local lSeek      := .F.
Local cCodCliFor := ""
Local cLoja      := ""

Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local _nVol     := 0 

Private oRetNF   := nil
Private oNFe     := nil

Private _lTrans   := .F.
Private _cCodRota := ''
Private _cCodReg  := ''

//Impressão automatica NORMAL_______________________
Private _cImpt_Nor  := '' //'ZDesigner ZM400 200 dpi (ZPL)'
//Impressão automatica TERMICA
Private _cImpt_Ter  := '000001'

Private _cSpool   := _cImpt_Nor
Private _cCB5Def  := _cImpt_Ter

//Local de Impressao
Private cPathEst    := Alltrim(GetMv("MV_DIREST"))
Private _lAutoPrd   := .T.
Private _nVolume := 0
Private _nVolume1 := 0
Private _Count:=0

MontaDir(cPathEst)
//__________________________________________________

dbSelectArea("CB5");CB5->(dbSetOrder(1))
DBSELECTAREA('SA1');SA1->(dbSetOrder(1))
DBSELECTAREA('SC5');SC5->(dbSetOrder(1))

u_xPutSx1(_cPerg,"01","Pedido Venda De:"   ,"Pedido Venda De:"   ,"Pedido Venda De:"   ,"mv_ch01","C",06,00,00,"G","","SC5","","","mv_par03","","","","","","","","","","","","","","","","")
u_xPutSx1(_cPerg,"02","Tipo de Impressora?","Tipo de Impressora?","Tipo de Impressora?","mv_ch02","N",01,00,02,"C","",""   ,"","","mv_par11","TÃ©rmica","TÃ©rmica","TÃ©rmica","","Normal","Normal","Normal","","","","","","","","","","",)
u_xPutSx1(_cPerg,"03","Impressora:"        ,"Impressora:"        ,"Impressora:"        ,"mv_ch03","C",06,00,00,"G","","CB5","","","mv_par04","","","","","","","","","","","","","","","","")

//Pergunte Falase para abrir os parametros de buffer
Pergunte(_cPerg,.F.)
	
//Ajusta parametros padrÃ£o (default)	
SetMVValue(_cPerg,"MV_PAR01", SC5->C5_NUM)				    // Nota Inicial
//SetMVValue(_cPerg,"MV_PAR02", IIF(!Empty(_cCB5Def),1,2))	// Tipo de Impressora (1 - TÃ©rmica / 2 - Normal)
//SetMVValue(_cPerg,"MV_PAR03", _cCB5Def)					// Impressora 

IF !_lAutoPrd
    IF !Pergunte(_cPerg,.T.)
        Return
    Endif
Endif
Pergunte(_cPerg,.F.)
_cNumPed    := MV_PAR01 // Pedido Inicial
nTipImp     := MV_PAR02 // Tipo de Impressora (1 - TÃ©rmica / 2 - Normal)
cLocImp     := MV_PAR03 // Impressora   
//ELSE
//    _cNumPed    := SC5->C5_NUM                  // Pedido Inicial
//    nTipImp     := IIF(!Empty(_cCB5Def),1,2)    // Tipo de Impressora (1 - TÃ©rmica / 2 - Normal)
//    cLocImp     := _cCB5Def                     // Impressora 
//Endif 

IF !SC5->(DbSeek(xFilial('SC5')+_cNumPed))
    Help(NIL, NIL, "NÃ£o foram Localizados Pedido para impressÃ£o da etiqueta.", NIL, "Verifique se o documento esta correto", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"})
    RETURN(.F.)
ENDIF

// ValidaÃ§Ãµes para impressoras termicas
if nTipImp == 1
    if Empty(cLocImp)
        Help(NIL, NIL, "Local de impressÃ£o nÃ£o informado.", NIL, "Informe um Local de impressÃ£o cadastrado., Acesse a rotina 'Locais de ImpressÃ£o'.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"}) //, 
        break
    else
        CB5->(dbSetOrder(1))
        if !CB5->(DbSeek( xFilial("CB5") + padR(cLocImp, GetSX3Cache("CB5_CODIGO", "X3_TAMANHO")) )) .or. !CB5SetImp(cLocImp)
            Help(NIL, NIL, "Local de impressÃ£o nÃ£o encontrado," + " - " + Alltrim(cLocImp) + ".", NIL, "Informe um Local de impressÃ£o cadastrado., Acesse a rotina 'Locais de ImpressÃ£o'.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Sair"}) //Local de impressÃ£o nÃ£o encontrado, Informe um Local de impressÃ£o cadastrado., Acesse a rotina 'Locais de ImpressÃ£o'.
            break
        endif
    endif
endif

IF nTipImp == 2

    _lAutoPrd   := .T.
    _lView := .T.
    IF _lAutoPrd //___________________________________________________________________________________
        _cNomePDF := "PVENDA_ETIQUETA_" + _cNumPed + "_" + Dtos(MSDate())+StrTran(Time(),":","")
        
        fErase(cPathEst+_cNomePDF+'.pdf')
        IF oPrinter == Nil
            lPreview 		:= .T.
            //https://tdn.totvs.com/display/public/framework/FWMsPrinter

            //oPrinter      := FWMSPrinter():New(_cNomePDF,6,/*.T.*/.F.,,.T.,,,,,,,_lView)
            //oPrinter      := FWMSPrinter():New(_cNomePDF,6,.T.,,.T.,,,,,,,_lView) 

            oPrinter := FWMSPrinter():New(_cNomePDF, IMP_PDF, lAdjustToLegacy, , lDisableSetup)// Ordem obrigátoria de configuração do relatório

            //oPrinter:SetResolution(78) //Tamanho estipulado para a Danfe
            //oPrinter:SetLandscape()		//Define a orientacao como paisagem
            //oPrinter:setPaperSize(9) 	//Define tipo papel A4
            //oPrinter:SetMargin(60,60,60,60)

            oPrinter:SetResolution(78) //Tamanho estipulado para a Danfe
            //oPrinter:SetLandscape() //SetPortrait()   
            oPrinter:GetOrientation(1)  //1 - Portrait(retrato);//2 - Landscape(paisagem)
            oPrinter:SetPaperSize(0,130,090)
            oPrinter:SetMargin(05,05,05,05)

            oPrinter:nDevice  := IMP_PDF
            oPrinter:cPathPDF := cPathEst
        ENDIF
        Private PixelX := oPrinter:nLogPixelX()

        Private PixelY := oPrinter:nLogPixelY()
        //oPrinter:StartPage()

        //___________________________________________________________________________________

    ELSE
        oPrinter := FWMSPrinter():New("PVENDA_ETIQUETA_" + _cNumPed + "_" + Dtos(MSDate())+StrTran(Time(),":",""),,.F.,,.T.,,,,,.F.)
        oSetup   := FWPrintSetup():New(PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN,"PVENDA SIMPLIFICADA")
        oSetup:SetPropert(PD_PRINTTYPE , 2) //Spool
        oSetup:SetPropert(PD_ORIENTATION , 2)
        oSetup:SetPropert(PD_DESTINATION , 1)
        oSetup:SetPropert(PD_MARGIN , {0,0,0,0})
        oSetup:SetPropert(PD_PAPERSIZE , 2)
        oSetup:cQtdCopia := '01'
    
        if !oSetup:Activate() == PD_OK
            break
        endif

        //oSetup:GetOrientation() // Retorna a orientaÃ§Ã£o (Retrato ou Paisagem) do objeto.        
        oPrinter:SetLandscape()		//Define a orientacao como paisagem
        oPrinter:setPaperSize(9) 	//Define tipo papel A4
        oPrinter:setCopies(val(oSetup:cQtdCopia))
        If oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
            oPrinter:nDevice := IMP_PDF
            oPrinter:cPathPDF := if( Empty(oSetup:aOptions[PD_VALUETYPE]), SuperGetMV('MV_RELT',,"\SPOOL\") , oSetup:aOptions[PD_VALUETYPE] )
        Elseif oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
            oPrinter:nDevice := IMP_SPOOL
            fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
            oPrinter:cPrinter := oSetup:aOptions[PD_VALUETYPE]
        Endif
    endif
endif

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
    else
        cDescLogo := cEmpAnt + cFilAnt
    endif

    cLogoD := GetSrvProfString("Startpath","") + "D_aPVend" + cDescLogo + ".BMP"
    if !file(cLogoD)
        cLogoD	:= GetSrvProfString("Startpath","") + "D_aPVend" + cEmpAnt + ".BMP"
        if !file(cLogoD)
            lMv_Logod := .F.
        endif
    endif
endif

if lMv_Logod
    cLogo := cLogoD
else
    cLogo := FisxLogo("1")
endif

Private _oFontCn_16N := TFont():New("Courier New",,16,,.T.,,,,,.F.)
_oFontCn_16N:Bold := .T.

Private _oFontCn_11N := TFont():New("Courier New",,13,,.T.,,,,,.F.)
_oFontCn_11N:Bold := .T.	

Private _oFontAr_11N := TFont():New("Arial",,11,,.T.,,,,,.F.)
_oFontAr_11N:Bold := .T.	


oFontTit := TFont():New( "Arial", , -8, .T.) //Fonte para os titulos
oFontTit:Bold := .T.						 //Setado negrito
oFontInf := TFont():New( "Arial", , -8, .T.) //Fonte para as informaÃ§Ãµes
oFontInf:Bold := .F.						 //Setado negrito := .F.

aNotas := {SC5->C5_NUM}

aEmit := Array(4)
aEmit[1] := StrTran(Alltrim(SM0->M0_NOMECOM),'sala','sl')
aEmit[2] := Alltrim(SM0->M0_CGC)
aEmit[3] := Alltrim(SM0->M0_INSC)
aEmit[4] := If(!GetNewPar("MV_SPEDEND",.F.),Alltrim(SM0->M0_ESTCOB),Alltrim(SM0->M0_ESTENT))

FOR nNotas := 1 to len(aNotas)

    DBSELECTAREA('SA1');SA1->(dbSetOrder(1))
    SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

    DbSelectArea('SA4');SA4->(DbSetOrder(1))
    _lTrans := SA4->(DbSeek(xFilial('SA4')+ SC5->C5_TRANSP ))

    _aDest := array(5)
    _aDest[1] := Alltrim(SA1->A1_NOME)
    _aDest[2] := Alltrim(SA1->A1_CGC)
    _aDest[3] := Alltrim(SA1->A1_INSCR)
    _aDest[4] := Alltrim(SA1->A1_EST)

    _aPVend := array(9)
    _aPVend[1] := SC5->C5_NUM
    _aPVend[2] := 'cProtocolo'
    _aPVend[3] := 'cDpecProt'
    _aPVend[4] := cLogo
    _aPVend[5] := '1'
    _aPVend[6] := SC5->C5_NOTA
    _aPVend[7] := SC5->C5_SERIE
    _aPVend[8] := SC5->C5_EMISSAO
    _aPVend[9] := 'cTotNota'

    _nVolume := IIF(SC5->C5_VOLUME1==0,1,SC5->C5_VOLUME1)

    nContD_aPVend += 1
    _Count:=0

    For _nVol:=1 To _nVolume
    _Count++
        IF nTipImp == 1 // 1 - TÃ©rmica 
            impZebra(_aPVend, aEmit, _aDest,_nVol)
            MSCBCLOSEPRINTER()

        Elseif nTipImp == 2 // 2 - Normal
            oPrinter:StartPage() 		//Define inicio da pagina
            nLinha := 0
            nColuna := 0
            D_aPVendSimp(oPrinter, nLinha, nColuna, oFontTit, oFontInf, aEmit, _aPVend, _aDest,_nVol)
            oPrinter:EndPage()
        endif    
        lOk := .T.
    Next _nVol
next

if lOk
    if nTipImp == 1 // 1 - TÃ©rmica 
        //MSCBCLOSEPRINTER()
    Elseif nTipImp == 2 // 2 - Normal
        //if nContD_aPVend <> 6
        //oPrinter:EndPage()
        //endif
        oPrinter:Print()
    endif
endif

fwFreeObj(oPrinter)

FwrestArea(_aArea)

Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} D_aPVendSimp
ImpressÃ£o normal de d_aPVend simplificada - Etiqueta 
/*/
//-------------------------------------------------------------------
*----------------------------------------------------------------------------------------------*
static function D_aPVendSimp(oPrinter, nPosY, nPosX, oFontTit, oFontInf, aEmit, _aPVend, _aDest,_nVol)
*----------------------------------------------------------------------------------------------*
Local _cLogoSL := GetSrvProfString("Startpath","") + "SL_Etiq_PV.png"

Private _nLin     	:= 0
Private _nCol     	:= 55
Private _NSpace05   := 05
Private _NSpace10   := 10
Private _NSpace20   := 20
Private _NSpace30   := 30
Private _NSpace40   := 40
Private _NSpace50   := 50

Private oBlack := TBrush():New( , CLR_BLACK)

//[ BOX PRINCIPAL  ]_________________________________________________________________________________________
// box (eixo Y inicio, eixo X inicio, eixo y fim, eixo x fim)
_nLin += _NSpace30
//[##]oPrinter:Box( _nLin + nPosY, 30 + nPosX, 270 + nPosY, 270 + nPosX, "-6") // box (eixo Y inicio, eixo X inicio, eixo y fim, eixo x fim)

//[ LOGO DO TITULO ]_________________________________________________________________________________________
oPrinter:SayBitmap( 100 + nPosY, 033 + nPosX, _cLogoSL, 020, 110)
oPrinter:Line(_nLin,055,_nLin+240, 055)

//[ DESTINATARIO   ]_________________________________________________________________________________________
oPrinter:FillRect({_nLin, 055, _nLin+015, 270}, oBlack)         
_nLin += _NSpace10
oPrinter:Say(_nLin + nPosY,_nCol+070 + nPosX,OemToAnsi('DESTINATARIO') ,_oFontCn_11N,,CLR_WHITE)
_nLin += _NSpace05
oPrinter:Line(_nLin,_nCol + nPosX,_nLin,270 + nPosX)
_nLin += _NSpace10

oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, _aDest[1], oFontTit)
_nLin += _NSpace10

_cEndFull := OemToAnsi ( Alltrim(SA1->A1_ENDENT)  ) 
_cMunic   := OemToAnsi(Alltrim(SA1->A1_MUNE)+' - '+Alltrim(SA1->A1_ESTE))
_cBaiCida := OemToAnsi(Alltrim(PadR(SA1->A1_BAIRROE,15)) +' -CEP: '+Alltrim(SA1->A1_CEPE) )	

oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('Endereço:'), oFontTit)  
oPrinter:Say( _nLin + nPosY, 170 + nPosX, IIF(len(_aDest[2]) == 11,"CPF:","CNPJ:"), oFontTit)
oPrinter:Say( _nLin + nPosY, 195 + nPosX, Transform(_aDest[2], IIF(len(_aDest[2]) == 11,"@R 999.999.999-99","@R 99.999.999/9999-99")), oFontInf)

_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, _cEndFull, oFontInf)  

_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('Bairro:'), oFontTit) 
oPrinter:Say( _nLin + nPosY, _nCol+42 + nPosX, _cBaiCida, oFontInf)

_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('Municipio:'), oFontTit) 
oPrinter:Say( _nLin + nPosY, _nCol+52 + nPosX, _cMunic, oFontInf)

//[ REMETENTE   ]_________________________________________________________________________________________
_nLin += _NSpace10
oPrinter:FillRect({_nLin, 055, _nLin+015, 270}, oBlack)         
_nLin += _NSpace10
oPrinter:Say(_nLin + nPosY,_nCol+080 + nPosX,OemToAnsi('REMETENTE') ,_oFontCn_11N,,CLR_WHITE)
_nLin += _NSpace05
oPrinter:Line(_nLin,_nCol + nPosX,_nLin,270 + nPosX)
_nLin += _NSpace10

oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, aEmit[1], oFontTit)
_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('IE:'), oFontTit)
oPrinter:Say( _nLin + nPosY, _nCol+40 + nPosX, aEmit[3], oFontInf)     

oPrinter:Say( _nLin + nPosY, 170 + nPosX, "CNPJ:", oFontTit)
oPrinter:Say( _nLin + nPosY, 195 + nPosX, Transform(aEmit[2],"@R 99.999.999/9999-99"), oFontInf)

//[ DADOS DO PEDIDO ]_____________________________________________________________________________________
_nLin += _NSpace10    
oPrinter:FillRect({_nLin, 055, _nLin+015, 270}, oBlack)         
_nLin += _NSpace10
oPrinter:Say(_nLin + nPosY,_nCol+060 + nPosX,OemToAnsi('PEDIDO: '+_aPVend[1]) ,_oFontCn_11N,,CLR_WHITE)
_nLin += _NSpace05
oPrinter:Line(_nLin,_nCol + nPosX,_nLin,270 + nPosX)
_nLin += _NSpace20+_NSpace05+(_NSpace05/2)
oPrinter:Code128c( _nLin + nPosY, 200 + nPosX, _aPVend[1], 25)
_nLin -= _NSpace10+_NSpace05+(_NSpace05/2)

oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('Emissão:'), oFontTit) 
oPrinter:Say( _nLin + nPosY, _nCol+50 + nPosX, DtoC(SC5->C5_EMISSAO), oFontInf)
_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('Volume:'), oFontTit)
//_cVolume := AllTrim(TransForm(_nVol,"@E 999,999")) +' / '+AllTrim(TransForm(SC5->C5_VOLUME1,"@E 999,999"))
_cVolume := StrZero(_nVol,3) +' / '+StrZero(SC5->C5_VOLUME1,3)

oPrinter:Say( _nLin + nPosY, _nCol+50 + nPosX, _cVolume, oFontInf)
_nLin += _NSpace10
oPrinter:Line(_nLin,_nCol + nPosX,_nLin,270 + nPosX)
_nLin += _NSpace10

//[ TRANSPORTADORA ]_____________________________________________________________________________________
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('Transportadora:'), oFontTit) 
IF _lTrans        
    _nLin += _NSpace10
    oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, SA4->A4_NOME, oFontInf)
ENDIF
_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+10 + nPosX, OemToAnsi('CNPJ:'), oFontTit) 
IF _lTrans        
    oPrinter:Say( _nLin + nPosY, _nCol+45 + nPosX, Transform(SA4->A4_CGC,"@R 99.999.999/9999-99"), oFontInf)
ENDIF

_nLin += _NSpace10
oPrinter:Line(_nLin,_nCol + nPosX,_nLin,270 + nPosX)
_nLin += _NSpace10

//_cCodRota := 'BRA'
//_cCodReg  := '51'

oPrinter:Say( _nLin + nPosY, _nCol+010 + nPosX, OemToAnsi('MEGA ROTA:'), oFontTit) 
oPrinter:Say( _nLin + nPosY, _nCol+150 + nPosX, OemToAnsi('REGIÃO:'), oFontTit) 

_nLin += _NSpace10
oPrinter:Say( _nLin + nPosY, _nCol+010 + nPosX, _cCodRota, _oFontAr_11N)
oPrinter:Say( _nLin + nPosY, _nCol+150 + nPosX, _cCodReg, _oFontAr_11N)

//[ RODAPE ]_____________________________________________________________________________________
_nLin += _NSpace05
oPrinter:Line(_nLin,_nCol + nPosX,_nLin,270 + nPosX)
_nLin += _NSpace05+(_NSpace05/2)
oPrinter:Say( _nLin + nPosY, _nCol+070 + nPosX, 'www.salonline.com.br', oFontInf)

return

//-------------------------------------------------------------------
/*/{Protheus.doc} impZebra
ImpressÃ£o de d_aPVend simplificada - Etiqueta para impressora Zebra
@param		_aPVend		Dados da Nota
            aEmit		Dados do Emitente da Nota
			_aDest		Dados do DestinatÃ¡rio da Nota
/*/ 
*------------------------------------------*
static function impZebra(_aPVend, aEmit, _aDest,_nVol)
*------------------------------------------*
    Local cFontSL    := "032,026"
    Local cFontDest  := "030,023"
    Local cFontRem   := "025,011"
    Local cFontSite  := "020,013" 
    Local cFontMaior := "025,013" //Fonte maior - tÃ­tulos dos campos obrigatÃ³rios do D_aPVend ("altura da fonte, largura da fonte")
    Local cFontMenor := "025,008" //Fonte menor - campos variÃ¡veis do D_aPVend ("altura da fonte, largura da fonte")
    Local _nLin      := 000
    
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
    //Local nValor     := 9
    Local nTamEmit   := len( Alltrim( aEmit[nNome] ) ) //Quantidade de caracteres da razÃ£o social do emitente
    Local nTamDest   := len( Alltrim( _aDest[nNome] ) ) //Quantidade de caracteres da razÃ£o social do destinatÃ¡rio
    Local nMaxNome   := 34 //Quantidade de caracteres mÃ¡xima da primeira linha da razÃ£o social

    Default _aPVend     := {}
    Default aEmit    := {}
    Default _aDest    := {}

    _cVolume := AllTrim(TransForm(_nVol,"@E 999,999")) +' / '+AllTrim(TransForm(SC5->C5_VOLUME1,"@E 999,999"))
    _cVolume := StrZero(_nVol,3) +' / '+StrZero(SC5->C5_VOLUME1,3)

    MSCBLOADGRF("SL_Etiq_H.BMP") //Logo

    //Inicializa a impressÃ£o
    MSCBBegin(1,6,150)

    //CriaÃ§Ã£o do Box
    MSCBBox(02,02,98,138)

    //CriaÃ§Ã£o das linhas Horizontais - sentido: de cima para baixo

    //MSCBLineH(02, 084, 98)
    //MSCBLineH(40, 101, 98)
    //MSCBLineH(02, 101, 98)
    //MSCBLineH(02, 111, 98)
    //MSCBLineH(02, 128, 98)

    //CriaÃ§Ã£o das linhas verticais - sentido: da direita para esquerda
    //MSCBLineV(32, 84, 101)
    //MSCBLineV(64, 84, 101)

    //Logo
    MSCBGRAFIC(10,20,"SL_Etiq_H")

    //Imprime o codigo de barras
    MSCBSayBar(70, 15, SC5->C5_NUM, "N", "C", 13, .F., .F., .F., "C", 2, 1, .F., .F., "1", .T.)

    //Criacao dos campos de textos fixos da etiqueta
    //Coluna / Linha

    //_______________________________________[ BOX 1 - SALONLINE ]_______________________________________
    _nLin += 02
    MSCBBOX(02,_nLin,098,12,49,"B")

    _nLin += 3
    MSCBSay(030, _nLin, "SALON LINE"          , "N", "B", cFontSL,.T.)

    _nLin += 10
    MSCBSay(004, _nLin, "Pedido: "            , "N", "B", cFontMaior)
    MSCBSay(035, _nLin, SC5->C5_NUM           , "N", "A", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, "Emissão: "           , "N", "B", cFontMaior)
    MSCBSay(035, _nLin, DtoC(SC5->C5_EMISSAO) , "N", "A", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, "Volume: "            , "N", "B", cFontMaior)
    MSCBSay(035, _nLin, _cVolume              , "N", "A", cFontMaior)

    //_______________________________________[ BOX 2 - DESTINATARIO ]_______________________________________
    _nLin += 5
    MSCBBOX(02,_nLin,098,_nLin+08,35,"B")    
    _nLin += 2
    MSCBSay(030, _nLin, "Destinatario"        , "N", "B", cFontDest,.T.)

    _cEndFull := OemToAnsi ( Alltrim(SA1->A1_ENDENT)  ) 
    _cMunic   := OemToAnsi(Alltrim(SA1->A1_MUNE)+' - '+Alltrim(SA1->A1_ESTE))
    _cBaiCida := OemToAnsi(Alltrim(PadR(SA1->A1_BAIRROE,15)) +' -CEP:'+Alltrim(SA1->A1_CEPE) )	

    _nLin += 10
    MSCBSay(004, _nLin, _aDest[1]            , "N", "B", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, IIF(len(_aDest[2]) == 11,"CPF:","CNPJ:")                                , "N", "B", cFontMaior)
    MSCBSay(030, _nLin, Transform(_aDest[2], IIF(len(_aDest[2]) == 11,"@R 999.999.999-99","@R 99.999.999/9999-99"))   , "N", "A", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, "Endereço: " , "N", "B", cFontMaior)
    _nLin += 5
    MSCBSay(004, _nLin,    _cEndFull , "N", "A", cFontMaior)


    _nLin += 5
    MSCBSay(004, _nLin, "Bairro:"      , "N", "B", cFontMaior)
    MSCBSay(025, _nLin,    _cBaiCida    , "N", "A", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, "Municipio: "   , "N", "B", cFontMaior)
    MSCBSay(030, _nLin,    _cMunic      , "N", "A", cFontMaior)

    //_______________________________________[ BOX 3 - REMETENTE ]_______________________________________
    _nLin += 5
    MSCBBOX(02,_nLin,098,_nLin+08,35,"B")    
    _nLin += 2
    MSCBSay(036, _nLin, "Remetente"        , "N", "B", cFontDest,.T.)
    
    _nLin += 10
    MSCBSay(004, _nLin, aEmit[1]            , "N", "B", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, "IE:"                                           , "N", "B", cFontMaior)
    MSCBSay(011, _nLin, Transform(aEmit[3],"@R 999.999.999.999")        , "N", "A", cFontRem)

    MSCBSay(045, _nLin, "CNPJ:"                                         , "N", "B", cFontMaior)
    MSCBSay(057, _nLin, Transform(aEmit[2],"@R 99.999.999/9999-99")     , "N", "A", cFontRem)

    //_______________________________________[ BOX 3 - TRANSPORTADORA ]_______________________________________
    _nLin += 5
    MSCBBOX(02,_nLin,098,_nLin+08,35,"B")    
    _nLin += 2
    MSCBSay(025, _nLin, "Transportadora"        , "N", "B", cFontDest,.T.)
    _nLin += 10
    MSCBSay(004, _nLin, AllTrim(SA4->A4_NOME)   , "N", "B", cFontMaior)

    _nLin += 5
    MSCBSay(004, _nLin, "CNPJ:"                                           , "N", "B", cFontMaior)
    MSCBSay(020, _nLin, Transform(SA4->A4_CGC,"@R 99.999.999/9999-99")       , "N", "A", cFontRem)

    _nLin += 5
    MSCBLineH(02, _nLin, 98)
    _nLin += 5

    MSCBSay(004, _nLin, "MEGA ROTA:"    , "N", "B", cFontMaior)
    MSCBSay(055, _nLin, "REGIÃO:"       , "N", "B", cFontMaior)

    //_cCodRota := 'BRA'
    //_cCodReg  := '51'

    _nLin += 5
    MSCBSay(004, _nLin, _cCodRota       , "N", "B", cFontDest)
    MSCBSay(055, _nLin, _cCodReg        , "N", "B", cFontDest)

    //_______________________________________[ BOX 3 - FIM ]_______________________________________
    _nLin += 7
    MSCBLineH(02, _nLin, 98)
    _nLin += 1
    MSCBSay(028, _nLin, 'WWW.SALONLINE.COM.BR' , "N", "F", cFontSite)


    //Finaliza a impressÃ£o
    MSCBEND()
return
