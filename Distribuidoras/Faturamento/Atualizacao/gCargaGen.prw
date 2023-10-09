
#Include "Protheus.ch"
 
 //Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 
//Vari·veis est·ticas
Static cDirTmp := GetTempPath()
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o GenÈrica para Carga de Dados no Protheus           ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

//Exemplo para chamar a rotina com tipo especifico.
*---------------------*
User Function gCarga17
*---------------------*
u_gCargaGen(.T.,.T.,'','17')
Return

//Exemplo para chamar a rotina com tipo especifico.
*---------------------*
User Function gCarga19
*---------------------*
u_gCargaGen(.T.,.T.,'','19')
Return

*--------------------------------------------------------* 
User Function gCargaGen(_lzAuto,_lzTela,_zAutoArq,_zAutTip)
*--------------------------------------------------------* 
    Local aArea := GetArea()
    //Dimensıes da janela
    Local nJanAltu := 180
    Local nJanLarg := 650
    //Objetos da tela
    Local oGrpPar
    Local oGrpAco
    Local oBtnSair
    Local oBtnImp
    Local oBtnObri
    Local oBtnArq
    Local cAviso  := ""
    //Local _lAcess :=  !(__cUserID $ '000000/000027/000120/000065')
    Local _lAcess  := AllTrim(GetMV('MC_ACPROS',.F.,'000000/000092/000027/000910/000911/000913/000920'))

    Default _zAutoArq := ''
    Default _zAutTip  := ''
    Default _lzAuto   := .F.
    Default _lzTela   := .F.

    Private aIteTip := {}
    Private oSayArq, oGetArq, cGetArq := Space(99)
    Private oSayTip, oCmbTip, cCmbTip := ""
    Private oSayCar, oGetCar, cGetCar := ';'
    Private oDlgPvt
     
    Private _lAuto    := _lzAuto
    Private _lTela    := _lzTela
    Private _aTipAuto := {}
    Private _lProcOK  := .F.
 
    IF !(__cUserID $ _lAcess)
        MsgInfo("Usuario sem acesso a rotina! MC_ACPROS", "AtenÁ„o")
        RETURN
    ENDIF

    //Inserindo as opÁıes disponÌveis no Carga Dados GenÈrico
    aIteTip := {;
			        "01=Bancos",;
			        "02=Clientes",;
			        "03=CondiÁ„o de Pagamento",;
			        "04=Contas a Receber",;
			        "05=Contas a Pagar",;
			        "06=Fornecedores",;
			        "07=Naturezas",;
			        "08=Produtos",;
			        "09=Saldo Inicial",;
			        "10=TES (Tipo de Entrada e SaÌda)",;
			        "11=TM (Tipo de MovimentaÁ„o)",;
			        "12=Transportadoras",;
			        "13=VeÌculos",;
			        "14=Vendedores",;
			        "15=Saldo Inicial (lote)",;
                    "16=TES Inteligente",;
			        "17=SolicitaÁ„o de Compras",;
			        "18=Pedido de Compras",;                    
                    "19=Prospect",;                    
                    "20=EndereÁo Estoque",;
                    "21=Grupo de Produtos",;     
                    "22=Complemento de Produto",;
                    "23=Categorias",;
                    "24=Categorias x Produtos";
			    }
    cCmbTip := aIteTip[1]

    IF _lAuto      
        cGetArq := _zAutoArq
        cCmbTip := _zAutTip

        IF !_lTela
            fConfirm(1) 
            Return(_lProcOK)
        ENDIF
        
        IF Empty(cGetArq)
            cGetArq := Space(99)
        ENDIF
    Endif    

    IF !_lAuto
        //Mostrando um aviso sobre a importaÁ„o
        cAviso := "zCargaGen: Carga Dados - GenÈrico v1.0"+STR_PULA
        cAviso += "--"+STR_PULA
        cAviso += "Para campos NumÈricos com separaÁ„o de decimal, utilize o caracter '.'. Por exemplo: 5.20;"+STR_PULA
        cAviso += "Para campos do tipo Data, utilize ou o padr„o YYYYMMDD ou o DD/MM/YYYY. Por exemplo: 20151025 ou 25/10/2015;"+STR_PULA
        cAviso += "--"+STR_PULA
        cAviso += "A rotina est· preparada para importar os seguintes cadastros:"+STR_PULA
        cAviso += " Seq- Rotina  - Tab - DescriÁ„o"+STR_PULA
        cAviso += " 01 - MATA070 - SA6 - Bancos"+STR_PULA
        cAviso += " 02 - MATA030 - SA1 - Clientes"+STR_PULA
        cAviso += " 03 - MATA360 - SE4 - CondiÁ„o de Pagamento"+STR_PULA
        cAviso += " 04 - FINA040 - SE1 - Contas a Receber"+STR_PULA
        cAviso += " 05 - FINA050 - SE2 - Contas a Pagar"+STR_PULA
        cAviso += " 06 - MATA020 - SA2 - Fornecedores"+STR_PULA
        cAviso += " 07 - FINA010 - SED - Naturezas"+STR_PULA
        cAviso += " 08 - MATA010 - SB1 - Produtos"+STR_PULA
        cAviso += " 09 - MATA220 - SB9 - Saldo Inicial"+STR_PULA
        cAviso += " 10 - MATA080 - SF4 - TES (Tipo de Entrada e SaÌda)"+STR_PULA
        cAviso += " 11 - MATA230 - SF5 - Tipo MovimentaÁ„o"+STR_PULA
        cAviso += " 12 - MATA050 - SA4 - Transportadoras"+STR_PULA
        cAviso += " 13 - OMSA060 - DA3 - VeÌculos"+STR_PULA
        cAviso += " 14 - MATA040 - SA3 - Vendedores"+STR_PULA
        cAviso += " 15 - MATA390 - SD5 - Saldo Inicial (Lote)"+STR_PULA
        cAviso += " 16 - MATA089 - SFM - TES Inteligente"+STR_PULA
        cAviso += " 17 - MATA110 - SC1 - SolicitaÁ„o de Compras"+STR_PULA
        cAviso += " 18 - MATA121 - SC7 - Pedido de Compras"+STR_PULA    
        cAviso += " 19 - TMKA260 - SUS - Prospect"+STR_PULA   
        cAviso += " 20 - MATA015 - SBE - Endereco de Estoque"+STR_PULA   
        cAviso += " 21 - MATA035 - SBM - Grupo de Produto"+STR_PULA  
        cAviso += " 22 - MATA180 - SB5 - Complemento de Produto"+STR_PULA  
        cAviso += " 23 - FATA140 - ACU - Categorias"+STR_PULA  
        cAviso += " 24 - FATA150 - ACV - Categorias x Produtos"+STR_PULA  
        cAviso += "--"+STR_PULA
        cAviso += " O caracter ';' (ponto e vÌrgula), nunca pode estar no fim da linha!"+STR_PULA
        Aviso('AtenÁ„o', cAviso, {'Ok'}, 03)
    ENDIF

    //Criando a janela
    DEFINE MSDIALOG oDlgPvt TITLE "Carga Dados - GenÈrico" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Grupo Par‚metros
        @ 003, 003     GROUP oGrpPar TO 060, (nJanLarg/2)     PROMPT "Par‚metros: "         OF oDlgPvt COLOR 0, 16777215 PIXEL
            //Caminho do arquivo
            @ 013, 006 SAY        oSayArq PROMPT "Arquivo:"                         SIZE 060, 007 OF oDlgPvt PIXEL
            @ 010, 070 MSGET      oGetArq VAR    cGetArq                            SIZE 240, 010 OF oDlgPvt PIXEL
            oGetArq:bHelp := {||    ShowHelpCpo(    "cGetArq",;
                                    {"Arquivo CSV ou TXT que ser· importado."+STR_PULA+"Exemplo: C:\teste.CSV"},2,;
                                    {},2)}
            @ 010, 311 BUTTON oBtnArq PROMPT "..."      SIZE 008, 011 OF oDlgPvt ACTION (fPegaArq()) PIXEL
             
            //Tipo de ImportaÁ„o
            @ 028, 006 SAY        oSayTip PROMPT "Tipo ImportaÁ„o:"                             SIZE 060, 007 OF oDlgPvt PIXEL
            @ 025, 070 MSCOMBOBOX oCmbTip VAR    cCmbTip ITEMS aIteTip       When(!_lAuto)      SIZE 100, 010 OF oDlgPvt PIXEL
            oCmbTip:bHelp := {||    ShowHelpCpo(    "cCmpTip",;
                                    {"Tipo de ImportaÁ„o que ser· processada."+STR_PULA+"Exemplo: 1 = Bancos"},2,;
                                    {},2)}
             
            //Caracter de SeparaÁ„o do CSV
            @ 043, 006 SAY        oSayCar PROMPT "Carac.Sep.:"               SIZE 060, 007 OF oDlgPvt PIXEL
            @ 040, 070 MSGET      oGetCar VAR    cGetCar                     SIZE 030, 010 OF oDlgPvt PIXEL VALID fVldCarac()
            oGetArq:bHelp := {||    ShowHelpCpo(    "cGetCar",;
                                    {"Caracter de separaÁ„o no arquivo."+STR_PULA+"Exemplo: ';'"},2,;
                                    {},2)}
             
        //Grupo AÁıes
        @ 063, 003     GROUP oGrpAco TO (nJanAltu/2)-3, (nJanLarg/2)     PROMPT "AÁıes: "         OF oDlgPvt COLOR 0, 16777215 PIXEL
         
            //Botıes
            @ 070, (nJanLarg/2)-(63*1)  BUTTON oBtnSair PROMPT "Sair"          SIZE 60, 014 OF oDlgPvt ACTION (oDlgPvt:End()) PIXEL
            @ 070, (nJanLarg/2)-(63*2)  BUTTON oBtnImp  PROMPT "Importar"      SIZE 60, 014 OF oDlgPvt ACTION (Processa({|| fConfirm(1) }, "Aguarde...")) PIXEL
            @ 070, (nJanLarg/2)-(63*3)  BUTTON oBtnObri PROMPT "Camp.Obrig."   SIZE 60, 014 OF oDlgPvt ACTION (Processa({|| fConfirm(2) }, "Aguarde...")) PIXEL
    ACTIVATE MSDIALOG oDlgPvt CENTERED
     
    RestArea(aArea)
Return
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o que valida o caracter de separaÁ„o digitado        ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*------------------------* 
Static Function fVldCarac
*------------------------* 
    Local lRet := .T.
    Local cInvalid := "'./\"+'"'
     
    //Se o caracter estiver contido nos que n„o podem, retorna erro
    If cGetCar $ cInvalid
        lRet := .F.
        MsgAlert("Caracter inv·lido, ele n„o estar contido em <b>"+cInvalid+"</b>!", "AtenÁ„o")
    EndIf
Return lRet
 

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o respons·vel por pegar o arquivo de importaÁ„o      ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*-----------------------*  
Static Function fPegaArq
*-----------------------*  
    Local cArqAux := ""
 
    cArqAux := cGetFile( "Arquivo Texto | *.*",;                //M·scara
                            "Arquivo...",;                        //TÌtulo
                            ,;                                        //N˙mero da m·scara
                            ,;                                        //DiretÛrio Inicial
                            .F.,;                                    //.F. == Abrir; .T. == Salvar
                            GETF_LOCALHARD,;                        //DiretÛrio full. Ex.: 'C:\TOTVS\arquivo.xlsx'
                            .F.)                                    //N„o exibe diretÛrio do servidor
                                 
    //Caso o arquivo n„o exista ou estiver em branco ou n„o for a extens„o txt
    If Empty(cArqAux) .Or. !File(cArqAux) .Or. (SubStr(cArqAux, RAt('.', cArqAux)+1, 3) != "txt" .And. SubStr(cArqAux, RAt('.', cArqAux)+1, 3) != "csv")
        MsgStop("Arquivo <b>inv·lido</b>!", "AtenÁ„o")
         
    //Sen„o, define o get
    Else
        cGetArq := PadR(cArqAux, 99)
        oGetArq:Refresh()
    EndIf
Return
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o de confirmaÁ„o da tela principal                   ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*-----------------------------*   
Static Function fConfirm(nTipo)
*-----------------------------*   
    Local nModBkp            := nModulo
    Local aAux                := {}
    Local nAux                := 0
    Local cAux                := ""
    Local cFunBkp            := FunName()
    Default nTipo            := 2
    
    Private _aCpoCB         := ''
    Private cModelo        := "C"
    Private cRotina         := ""
    Private cTabela         := ""
    Private cCampoChv       := ""
    Private cFilialTab      := ""
    Private nTotalReg       := 0
    Private cAliasTmp       := "TMP_"+RetCodUsr()
    Private oBrowChk
    Private cFiles
    Private cMark           := "OK"
    Private aCampos         := {}
    Private aStruTmp        := {}
    Private aHeadImp        := {}
    Private cCampTipo       := ""
    Private lChvProt        := .F.
    Private lFilProt        := .F.
    Private cLinhaCab       := ""
    Private _lTelOK         := .F.
     
    //Bancos
    If cCmbTip == "01"
        cRotina    := "MSExecAuto({|x, y| MATA070(x, y)}, aDados, 3) "
        cTabela    := "SA6"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 6
        SetFunName("MATA070")
     
    //Clientes
    ElseIf cCmbTip == "02"
        cRotina    := "MSExecAuto({|x, y| MATA030(x, y)}, aDados, 3) "
        cTabela    := "SA1"
        cCampoChv    := "A1_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA030")
     
    //CondiÁ„o de Pagamento
    ElseIf cCmbTip == "03"
        cRotina    := "MSExecAuto({|x, y, z| MATA360(x, y, z)}, aDados, , 3) "
        cTabela    := "SE4"
        cCampoChv    := "E4_CODIGO"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA360")
         
    //Contas a Receber
    ElseIf cCmbTip == "04"
        cRotina    := "MSExecAuto({|x, y| FINA040(x, y)}, aDados, 3) "
        cTabela    := "SE1"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 6
        SetFunName("MATA040")
         
    //Contas a Pagar
    ElseIf cCmbTip == "05"
        cRotina    := "MSExecAuto({|x, y, z| FINA050(x, y, z)}, aDados, , 3) "
        cTabela    := "SE2"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 6
        SetFunName("FINA050")
         
    //Fornecedores
    ElseIf cCmbTip == "06"
        cRotina    := "MSExecAuto({|x, y| MATA020(x, y)}, aDados, 3) "
        cTabela    := "SA2"
        cCampoChv    := "A2_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 2
        SetFunName("MATA020")
     
    //Naturezas
    ElseIf cCmbTip == "07"
        cRotina    := "MSExecAuto({|x, y| FINA010A(x, y)}, aDados, 3) "
        cTabela    := "SED"
        cCampoChv    := "ED_CODIGO"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 6
        SetFunName("FINA010")
         
    //Produtos
    ElseIf cCmbTip == "08"
        cRotina    := "MSExecAuto({|x, y| MATA010(x, y)}, aDados, 3) "
        cTabela    := "SB1"
        cCampoChv    := "B1_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 4
        SetFunName("MATA010")
         
    //Saldo Inicial
    ElseIf cCmbTip == "09"        
        cRotina    := "MSExecAuto({|x, y| MATA220(x, y)}, aDados, 3) "
        cTabela    := "SB9"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 4
        SetFunName("MATA220")
         
    //TES (Tipo de Entrada e SaÌda)
    ElseIf cCmbTip == "10"
        cRotina    := "MSExecAuto({|x, y| MATA080(x, y)}, aDados, 3) "
        cTabela    := "SF4"
        cCampoChv    := "F4_CODIGO"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA080")
         
    //TM (Tipo de MovimentaÁ„o)
    ElseIf cCmbTip == "11"
        cRotina    := "MSExecAuto({|x, y| MATA230(x, y)}, aDados, 3) "
        cTabela    := "SF5"
        cCampoChv    := "F5_CODIGO"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 4
        SetFunName("MATA230")
         
    //Transportadoras
    ElseIf cCmbTip == "12"
        cRotina    := "MSExecAuto({|x, y| MATA050(x, y)}, aDados, 3) "
        cTabela    := "SA4"
        cCampoChv    := "A4_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA050")
         
    //VeÌculos
    ElseIf cCmbTip == "13"
        cRotina    := "MSExecAuto({|x, y| OMSA060(x, y)}, aDados, 3) "
        cTabela    := "DA3"
        cCampoChv    := "DA3_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 39
        SetFunName("OMSA060")
         
    //Vendedores
    ElseIf cCmbTip == "14"
        cRotina    := "MSExecAuto({|x, y| MATA040(x, y)}, aDados, 3) "
        cTabela    := "SA3"
        cCampoChv    := "A3_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA040")
        
     //Saldo Inicial por Lote
    ElseIf cCmbTip == "15"
        cRotina    := "MSExecAuto({|x, y| Mata390(x, y)}, aDados, 3) "
        cTabela    := "SA3"
        cCampoChv    := "A3_COD"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA040")

     //TES Inteligente
    ElseIf cCmbTip == "16"
        cRotina     := "MSExecAuto({|x, y| MATA089(x, y)}, aDados, 3) "
        cTabela     := "SFM"
        cCampoChv   := ''
        cFilialTab  := FWxFilial(cTabela)
        nModulo     := 2
        SetFunName("MATA089")

     //SolicitaÁ„o de Compras
    ElseIf cCmbTip == "17"
        cRotina     := 'MSExecAuto({|x,y| mata110(x,y)},aCabec,aItens)'
        cModelo     := "I"
        _aCpoCB     := "C1_NUM|C1_SOLICIT"
        cTabela    	:= "SC1"
        cCampoChv   := "C1_NUM"
        cFilialTab  := FWxFilial(cTabela)
        nModulo    	:= 2
        SetFunName("MATA110")
                        
     //Pedido de Compras
    ElseIf cCmbTip == "18"
        //cRotina   := "MSExecAuto({|x, y| MATA121(x, y)}, aDados, 3) "
        //cRotina   := "MATA120(1,aCabec,aItens,3,,aRatCC)"
        //cRotina   := "MATA120(1,aCabec,aItens,3)"
        cRotina   	:= "MsExecAuto({|v,x,y,z| MATA120(v, x, y, z)}, 1, aCabec, aItens, 3)"
        cModelo     := "I"
        _aCpoCB     := "C7_NUM|C7_EMISSAO|C7_FORNECE|C7_LOJA|C7_COND|C7_CONTATO|C7_FILENT"
        cTabela    	:= "SC7"
        cCampoChv   := "C7_NUM"
        cFilialTab  := FWxFilial(cTabela)
        nModulo    	:= 2
        SetFunName("MATA121")

    //Prospect
    ElseIf cCmbTip == "19"
        cRotina     := "MSExecAuto({|x, y| TMKA260(x, y)}, aDados, 3) "
        cTabela     := "SUS"
        cCampoChv   := "US_COD"
        cFilialTab  := FWxFilial(cTabela)
        nModulo     := 5
        SetFunName("TMKA260")

    //EndereÁo de Estoque
    ElseIf cCmbTip == "20"
        cRotina    := "MSExecAuto({|x, y| MATA015(x, y)}, aDados, 3) "
        cTabela    := "SBE"
        cCampoChv    := "BE_LOCALIZ"
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA015")

    //Grupo de Produtos
    ElseIf cCmbTip == "21"
        cRotina    := "MSExecAuto({|x, y| MATA035(x, y)}, aDados, 3) "
        cTabela    := "SBM"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA035")

    //Complemento de Produto
    ElseIf cCmbTip == "22"
        cRotina    := "MSExecAuto({|x, y| MATA180(x, y)}, aDados, 3) "
        cTabela    := "SB5"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("MATA180")

    //Categorias
    ElseIf cCmbTip == "23"
        cRotina    := "MSExecAuto({|x, y| FATA140(x, y)}, aDados, 3) "
        cTabela    := "ACU"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("FATA140")

    //Categorias x Produtos
    ElseIf cCmbTip == "24"
        cRotina    := "MSExecAuto({|x, y| FATA150(x, y)}, aDados, 3) "
        cTabela    := "ACV"
        cCampoChv    := ""
        cFilialTab    := FWxFilial(cTabela)
        nModulo    := 5
        SetFunName("FATA150")

    //OpÁ„o inv·lida
    Else
        nModulo    := nModBkp
        MsgStop("OpÁ„o <b>Inv·lida</b>!", "AtenÁ„o")
        Return(.F.)
    EndIf
     
    //ImportaÁ„o dos dados
    If nTipo == 1
        //Se o arquivo existir
        If File(cGetArq)
            //Abrindo o arquivo
            Ft_FUse(cGetArq)
            nTotalReg := Ft_FLastRec()
             
            //Se o total de registros for menor que 2, arquivo inv·lido
            If nTotalReg < 2
                MsgAlert("Arquivo inv·lido, possui menos que <b>2</b> linhas!", "AtenÁ„o")
                 
            //Sen„o, chama a tela de observaÁ„o e depois a importaÁ„o
            Else
                //Monta tabela tempor·ria
                fMontaTmp()
                 
                //Pegando o cabeÁalho
                cLinhaCab := Ft_FReadLn()
                cLinhaCab := Iif(SubStr(cLinhaCab, Len(cLinhaCab)-1, 1) == ";", SubStr(cLinhaCab, 1, Len(cLinhaCab)-1), cLinhaCab)
                aAux := Separa(cLinhaCab, cGetCar)
                Ft_FSkip()
                 
                //Percorrendo o aAux e adicionando no array
                For nAux := 1 To Len(aAux)
                    cAux := GetSX3Cache(aAux[nAux], 'X3_TIPO')
                 
                    //Se o tÌtulo estiver em branco, quer dizer que o campo n„o existe, ent„o È um campo reservado do execauto (como o LINPOS)
                    If Empty(GetSX3Cache(aAux[nAux], 'X3_TITULO'))
                        cCampTipo += aAux[nAux]+";"
                    EndIf
                     
                    //Adiciona na grid
                    aAdd(aHeadImp, {    aAux[nAux],;                                //Campo
                                        Iif(Empty(cAux), ' ', cAux),;            //Tipo
                                        .F.})                                        //ExcluÌdo
                Next
                
                IF !_lTelOK
                    //cModelo  := 'I'
                    _lTelOK := .T.
                Else
                    //Chama a tela de observaÁ„o para preenchimento das informaÁıes auxiliares
                    _lTelOK :=  fTelaObs(!Empty(cCampoChv))
                Endif

                If _lTelOK
                 
                  	IF cModelo == 'C'	                    
	                    fImport()	//Chama a rotina de importaÁ„o - Modelo Cabecalho
	                ElseIF cModelo == 'I'
	                    iImport()	//Chama a rotina de importaÁ„o - Modelo Item
	                ENDIF

                     
                    //Se houve erros na rotina
                    (cAliasTmp)->(DbGoTop())
                    If ! (cAliasTmp)->(EoF())
                        _lProcOK := .F.
                        IF !_lAuto .Or. _lTela
                            fTelaErro()
                        Endif                        
                    //Sen„o, mostra mensagem de sucesso
                    Else
                        _lProcOK  := .T.
                        IF !_lAuto .Or. _lTela                           
                            MsgInfo("ImportaÁ„o finalizada com Sucesso!", "AtenÁ„o")
                        endif
                    EndIf

                EndIf
                 
                //Fechando a tabela e excluindo o arquivo tempor·rio
                (cAliasTmp)->(DbCloseArea())
                fErase(cAliasTmp + GetDBExtension())
            EndIf
            Ft_FUse()
         
        //Sen„o, mostra erro
        Else   
            _lProcOK := .F. 
            IF !_lAuto .Or. _lTela     
                MsgAlert("Arquivo inv·lido / n„o encontrado!", "AtenÁ„o")
            EndIf    
        EndIf
         
    //GeraÁ„o de arquivo com cabeÁalho dos campos obrigatÛrios
    ElseIf nTipo == 2
        fObrigat()
    EndIf
     
    nModulo := nModBkp
    SetFunName(cFunBkp)
Return(_lProcOK)
 

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o que gera os campos obrigatÛrios em CSV / TXT       ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*----------------------* 
Static Function fObrigat
*----------------------*
    Local aAreaX3        := SX3->(GetArea())
    Local cConteud    := ""
    Local cCaminho    := cDirTmp
    Local cArquivo    := "obrigatorio."
    Local cExtensao    := ""
     
    //Selecionando a SX3 e posicionando na tabela
    DbSelectArea("SX3")
    SX3->(DbSetOrder(1)) //TABELA
    SX3->(DbGoTop())
    SX3->(DbSeek(cTabela))
     
    //Enquanto houver registros na SX3 e for a mesma tabela
    While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cTabela
        //Se o campo for obrigatÛrio
        If X3Obrigat(SX3->X3_CAMPO) .Or. SX3->X3_CAMPO $ "B1_PICM;B1_IPI;B1_CONTRAT;B1_LOCALIZ"
            cConteud += Alltrim(SX3->X3_CAMPO)+cGetCar
        EndIf
         
        SX3->(DbSkip())
    EndDo
    cConteud := Iif(!Empty(cConteud), SubStr(cConteud, 1, Len(cConteud)-1), "")
     
    //Se escolher txt
    If MsgYesNo("Deseja gerar com a extens„o <b>txt</b>?", "AtenÁ„o")
        cExtensao := "txt"
         
    //Sen„o, ser· csv
    Else
        cExtensao := "csv"
    EndIf
     
    //Gera o arquivo
    MemoWrite(cCaminho+cArquivo+cExtensao, cConteud)
     
    //Tentando abrir o arquivo
    nRet := ShellExecute("open", cArquivo+cExtensao, "", cCaminho, 1)
     
    //Se houver algum erro
    If nRet <= 32
        MsgStop("N„o foi possÌvel abrir o arquivo <b>"+cCaminho+cArquivo+cExtensao+"</b>!", "AtenÁ„o")
    EndIf 
     
    RestArea(aAreaX3)
Return
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o que monta a estrutura tempor·ria com os erros      ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*-----------------------*  
Static Function fMontaTmp
*-----------------------*  
    Local aArea := GetArea()
     
    //Se tiver aberto a tempor·ria, fecha e exclui o arquivo
    If Select(cAliasTmp) > 0
        (cAliasTmp)->(DbCloseArea())
    EndIf
    fErase(cAliasTmp + GetDBExtension())
     
    //Adicionando a Estrutura (Campo, Tipo, Tamanho, Decimal)
    aStruTmp:={}
    aAdd(aStruTmp,{    "TMP_SEQ",       "C",    010,                        0})
    aAdd(aStruTmp,{    "TMP_LINHA",    	"N",    018,                        0})
    aAdd(aStruTmp,{    "TMP_ARQ",       "C",    250,                        0})
     
    //Criando tabela tempor·ria
    cFiles := CriaTrab( aStruTmp, .T. )             
    dbUseArea( .T., "DBFCDX", cFiles, cAliasTmp, .T., .F. )
     
    //Setando os campos que ser„o mostrados no MsSelect
    aCampos := {}
    aAdd(aCampos,{    "TMP_SEQ",        ,    "Sequencia",        "@!"})
    aAdd(aCampos,{    "TMP_LINHA",    ,    "Linha Erro",        ""})
    aAdd(aCampos,{    "TMP_ARQ",        ,    "Arquivo Log.",    ""})
     
    RestArea(aArea)
Return
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o de observaÁıes antes da importaÁ„o                 ±±
//±±∫          ≥ u_gCargaGen(                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*---------------------------------*   
Static Function fTelaObs(lAtivChav)
*---------------------------------*   
    Local lRet := .F.
    //Dimensıes da janela
    Local nJanAltu := 500
    Local nJanLarg := 700
    //Objetos da tela
    Local oGrpDad
    Local oGrpCam
    Local oGrpOpc
    Local oGrpAco
    Local oBtnConf
    Local oBtnCanc
    //Janela
    Local oDlgObs
    //Radios - Chave
    Local oSayChave, oRadChave, nRadChave := 1
    //Radios - Filial
    Local oSayFilial, oRadFilial, nRadFilial := 2
    //Campos no grupo de Dados              	
    Local oSayTab, oGetTab, cGetTab := cTabela
    Local oSayCam, oGetCam, cGetCam := cCampoChv
    Local oSayFil, oGetFil, cGetFil := cFilialTab
    Local oSayRot, oGetRot, cGetRot := cRotina
    //Grid
    Private oMsNew
    Private aHeadNew := {}
    Private aColsNew := aClone(aHeadImp)
    Default lAtivChav := .T.
     
    //Setando o cabeÁalho
    //CabeÁalho ...    Titulo                Campo            Mask        Tamanho    Dec        Valid                Usado    Tip        F3    CBOX
    aAdd(aHeadNew,{    "Campo",            "XX_CAMP",        "@!",        10,            0,        ".F.",                ".F.",    "C",    "",    ""})
    aAdd(aHeadNew,{    "Tipo",            "XX_TIPO",        "@!",        1,            0,        "u_yCargaTp()",    ".T.",    "C",     "",    "C;N;L;D;M",    "C=Caracter;N=NumÈrico;L=LÛgico;D=Data;M=Memo"})
     
    //Criando a janela
    DEFINE MSDIALOG oDlgObs TITLE "ObservaÁıes" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
        //Grupo Dados
        @ 003, 003     GROUP oGrpDad TO 055, (nJanLarg/2)     PROMPT "Dados: "         OF oDlgObs COLOR 0, 16777215 PIXEL
            //Tabela
            @ 010, 005 SAY   oSayTab PROMPT "Tabela:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
            @ 017, 005 MSGET oGetTab VAR    cGetTab    SIZE 040, 010 OF oDlgObs PIXEL
            oGetTab:lActive := .F.
             
            //Campo Chave
            @ 010, 121 SAY   oSayCam PROMPT "Campo Chave:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
            @ 017, 121 MSGET oGetCam VAR    cGetCam    SIZE 040, 010 OF oDlgObs PIXEL
            oGetCam:lActive := .F.
              
            //Filial
            @ 010, 237 SAY   oSayFil PROMPT "Filial Atual:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
            @ 017, 237 MSGET oGetFil VAR    cGetFil    SIZE 040, 010 OF oDlgObs PIXEL
            oGetFil:lActive := .F.
             
            //Rotina
            @ 031, 005 SAY   oSayRot PROMPT "Rotina:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
            @ 038, 005 MSGET oGetRot VAR    cGetRot    SIZE 272, 010 OF oDlgObs PIXEL
            oGetRot:lActive := .F.
             
        //Grupo Campos
        @ 058, 003     GROUP oGrpCam TO 180, (nJanLarg/2)     PROMPT "Campos: "     OF oDlgObs COLOR 0, 16777215 PIXEL
            oMsNew := MsNewGetDados():New(    058+12,;                                    //nTop
                                                006,;                                        //nLeft
                                                177,;                                        //nBottom
                                                (nJanLarg/2)-6,;                            //nRight
                                                GD_INSERT+GD_DELETE+GD_UPDATE,;            //nStyle
                                                "AllwaysTrue()",;                            //cLinhaOk
                                                ,;                                            //cTudoOk
                                                "",;                                        //cIniCpos
                                                {"XX_TIPO"},;                                //aAlter
                                                ,;                                            //nFreeze
                                                999,;                                        //nMax
                                                ,;                                            //cFieldOK
                                                ,;                                            //cSuperDel
                                                ,;                                            //cDelOk
                                                oDlgObs,;                                    //oWnd
                                                aHeadNew,;                                    //aHeader
                                                aColsNew)                                    //aCols
            oMsNew:lInsert := .F.
             
        //Grupo OpÁıes
        @ 183, 003     GROUP oGrpOpc TO 220, (nJanLarg/2)     PROMPT "OpÁıes: "     OF oDlgObs COLOR 0, 16777215 PIXEL
            //Chave
            @ 190, 005 SAY   oSayChave PROMPT "Campo Chave importado?"  SIZE 100, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
            @ 200, 005 RADIO oRadChave VAR    nRadChave ITEMS "Conforme Arquivo","Conforme Sequencia do Protheus (SXE/SXF)" SIZE 120, 019 OF oDlgObs COLOR 0, 16777215 PIXEL
            oRadChave:lActive := lAtivChav
             
            //Filial
            @ 190, 180 SAY   oSayFilial PROMPT "Campo Filial importado?"  SIZE 100, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
            @ 200, 180 RADIO oRadFilial VAR nRadFilial ITEMS "Conforme Arquivo","Conforme Filial do Protheus (xFilial)" SIZE 120, 019 OF oDlgObs COLOR 0, 16777215 PIXEL
            oRadFilial:lActive := .F.
             
        //Grupo AÁıes
        @ 223, 003     GROUP oGrpAco TO 247, (nJanLarg/2)     PROMPT "AÁıes: "         OF oDlgObs COLOR 0, 16777215 PIXEL
            @ 229, (nJanLarg/2)-(63*1)  BUTTON oBtnCanc PROMPT "Cancelar"      SIZE 60, 014 OF oDlgObs ACTION (lRet := .F., oDlgObs:End()) PIXEL
            @ 229, (nJanLarg/2)-(63*2)  BUTTON oBtnConf PROMPT "Confirmar"     SIZE 60, 014 OF oDlgObs ACTION (aHeadImp := aClone(oMsNew:aCols), lRet := .T., oDlgObs:End()) PIXEL
    ACTIVATE MSDIALOG oDlgObs CENTERED
     
    //Se a tela for confirmada, atualiza as vari·veis
    If lRet
        lChvProt := nRadChave  == 2
        lFilProt := nRadFilial == 2
    EndIf
Return lRet
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ Vali. campo Tipo na tela de observaÁ„o da carga genÈrica  ±±
//±±∫          ≥ u_zCargaTp()                                              ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*---------------------*    
User Function yCargaTp
*---------------------*    
    Local lRetorn := .F.
    Local aColsAux := oMsNew:aCols
    Local nLinAtu := oMsNew:nAt
     
    //Se o campo atual estiver contido nos campos prÛprios do execauto (como LINPOS)
    If aColsAux[nLinAtu][01] $ cCampTipo
        lRetorn := .T.
     
    //Sen„o, campo n„o pode ser alterado
    Else
        lRetorn := .F.
        MsgAlert("Campo n„o pode ser alterado!", "AtenÁ„o")
    EndIf
     
Return lRetorn
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o respons·vel por fazer a importaÁ„o dos dados       ±±
//±±∫          ≥ u_gCargaGen()                                             ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*----------------------*  
Static Function fImport
*----------------------*  
    Local nLinAtu    := 2
    Local cLinAtu    := ""
    Local aAuxAtu    := {}
    Local cArqLog    := ""
    Local cConLog    := ""
    Local cSequen    := StrZero(1, 10)
    Local nPosAux    := 1
    Local lFalhou    := .F.
    Local xConteud:= ""
    Local nAuxLog    := 0
    Local aLogAuto:= {}
    Private aDados    := {}
    ProcRegua(nTotalReg)
     
    //Percorrendo os registros
    While !Ft_FEoF() .And. nLinAtu <= FT_FLastRec()
        IncProc("Analisando linha "+cValToChar(nLinAtu)+" de "+cValToChar(nTotalReg)+"...")
        cArqLog := "log_"+cCmbTip+"_lin_"+cValToChar(nLinAtu)+"_"+dToS(dDataBase)+"_"+StrTran(Time(), ":", "-")+".txt"
        cConLog := "Tipo:     "+cCmbTip+STR_PULA
        cConLog += "Usu·rio:  "+UsrRetName(RetCodUsr())+STR_PULA
        cConLog += "Ambiente: "+GetEnvServer()+STR_PULA
        cConLog += "Data:     "+dToC(dDataBase)+STR_PULA
        cConLog += "Hora:     "+Time()+STR_PULA
        cConLog += "Filial ['"+cTabela+"'] "+xFilial(cTabela)
        cConLog += "----"+STR_PULA+STR_PULA
         
        //Pegando a linha atual e transformando em array
        cLinAtu := Ft_FReadLn()
        cLinAtu := IIF(SubStr(cLinAtu, Len(cLinAtu), 1) == ";", SubStr(cLinAtu, 1, Len(cLinAtu)-1), cLinAtu)
        aAuxAtu := Separa(cLinAtu, cGetCar)
         
        //Se tiver dados
        If !Empty(cLinAtu)
            //Se o tamanho for diferente, registra erro
            If Len(aAuxAtu) != Len(aHeadImp)
                cConLog += "O tamanho de campos da linha, difere do tamanho de campos do cabeÁalho!"+STR_PULA
                cConLog += "Linha:     "+cValToChar(Len(aAuxAtu))+STR_PULA
                cConLog += "CabeÁalho: "+cValToChar(Len(aHeadImp))+STR_PULA
             
                //Gerando o arquivo
                MemoWrite(cDirTmp+cArqLog, cConLog)
             
                //Gravando o registro
                RecLock(cAliasTmp, .T.)
                    TMP_SEQ    := cSequen
                    TMP_LINHA    := nLinAtu
                    TMP_ARQ    := cArqLog
                (cAliasTmp)->(MsUnlock())
                 
                //Incrementa a sequencia
                cSequen := Soma1(cSequen)
                 
            //Sen„o, carrega as informaÁıes no array
            Else
                aDados    := {}
                lFalhou:= .F.
                 
                //Iniciando a transaÁ„o
                //Begin Transaction
                    //Percorre o cabeÁalho
                    For nPosAux := 1 To Len(aHeadImp)
                        xConteud := aAuxAtu[nPosAux]
                         
                        //Se o tipo do campo for NumÈrico
                        If aHeadImp[nPosAux][2] == 'N' 
                        	aAuxAtu[nPosAux] := StrTran(aAuxAtu[nPosAux],',','.')
                            xConteud := Val(aAuxAtu[nPosAux])
                         
                        //Se o tipo for LÛgico
                        ElseIf aHeadImp[nPosAux][2] == 'L'
                            xConteud := Iif(aAuxAtu[nPosAux] == '.T.', .T., .F.)
                             
                        //Se o tipo for Data
                        ElseIf aHeadImp[nPosAux][2] == 'D'
                            //Se tiver '/' na data, È padr„o DD/MM/YYYY
                            If '/' $ aAuxAtu[nPosAux]
                                xConteud := cToD(aAuxAtu[nPosAux])
                                 
                            //Sen„o, È padr„o YYYYMMDD
                            Else
                                xConteud := sToD(aAuxAtu[nPosAux])
                            EndIf
                        EndIf
                         
                        //Se for o campo filial
                        If '_FILIAL' $ aHeadImp[nPosAux][1]
                            //Se a filial for conforme o protheus
                            If lFilProt
                                xConteud := FWxFilial(cTabela)
                            EndIf
                        EndIf
                         
                        //Se for o campo chave
                        If Alltrim(cCampoChv) == Alltrim(aHeadImp[nPosAux][1])
                            //Se a chave for conforme o protheus
                            If lChvProt
                                xConteud := GetSXENum(cTabela, cCampoChv)
                            EndIf
                        EndIf
                         
                        //Adicionando no vetor que ser· importado
                        aAdd(aDados,{    aHeadImp[nPosAux][1],;            //Campo
                                        xConteud,;                            //Conte˙do
                                        Nil})                                //Compatibilidade
                    Next
                     
                    //Seta as vari·veis de log do protheus
                    lAutoErrNoFile    := .T.
                    lMsErroAuto        := .F.
                     
                    //Executa o execauto
                    &(cRotina)
                     
                    //Se tiver alguma falha
                    If lMsErroAuto
                        lFalhou := .T.
                         
                        //Pegando log do ExecAuto
                        aLogAuto := GetAutoGRLog()
     
                        //Gerando log
                        For nAuxLog :=1 To Len(aLogAuto)
                            cConLog += aLogAuto[nAuxLog] + STR_PULA
                        Next
                         
                        //DisarmTransaction()
                    EndIf
                //End Transaction
                 
                //Se houve falha na importaÁ„o, grava na tabela tempor·ria
                If lFalhou
                    _lProcOK := .F.

                    //Gerando o arquivo
                    MemoWrite(cDirTmp+cArqLog, cConLog)
                 
                    //Gravando o registro
                    RecLock(cAliasTmp, .T.)
                        TMP_SEQ    := cSequen
                        TMP_LINHA    := nLinAtu
                        TMP_ARQ    := cArqLog
                    (cAliasTmp)->(MsUnlock())
                     
                    //Incrementa a sequencia
                    cSequen := Soma1(cSequen)
                EndIf
            EndIf
        EndIf
         
        nLinAtu++
        Ft_FSkip()
    EndDo
Return

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o que mostra os erros gerados na tela                ±±
//±±∫          ≥ u_gCargaGen()                                             ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*------------------------* 
Static Function fTelaErro
*------------------------* 
    Local aArea        := GetArea()
    Local oDlgErro
    Local oGrpErr
    Local oGrpAco
    Local oBtnFech
    Local oBtnVisu
    Local nJanLarErr    := 600
    Local nJanAltErr    := 400
 
    //Criando a Janela
    DEFINE MSDIALOG oDlgErro TITLE "Erros na ImportaÁ„o" FROM 000, 000  TO nJanAltErr, nJanLarErr COLORS 0, 16777215 PIXEL
        //Grupo Erros
        @ 003, 003     GROUP oGrpErr TO (nJanAltErr/2)-28, (nJanLarErr/2)     PROMPT "Erros: "         OF oDlgErro COLOR 0, 16777215 PIXEL
            //Criando o MsSelect
            oBrowChk := MsSelect():New(    cAliasTmp,;                                                //cAlias
                                            "",;                                                        //cCampo
                                            ,;                                                            //cCpo
                                            aCampos,;                                                    //aCampos
                                            ,;                                                            //lInv
                                            ,;                                                            //cMar
                                            {010, 006, (nJanAltErr/2)-31, (nJanLarErr/2)-3},;    //aCord
                                            ,;                                                            //cTopFun
                                            ,;                                                            //cBotFun
                                            oDlgErro,;                                                    //oWnd
                                            ,;                                                            //uPar11
                                            )                                                            //aColors
            oBrowChk:oBrowse:lHasMark    := .F.
            oBrowChk:oBrowse:lCanAllmark := .F.
         
        //Grupo AÁıes
        @ (nJanAltErr/2)-25, 003     GROUP oGrpAco TO (nJanAltErr/2)-3, (nJanLarErr/2)     PROMPT "AÁıes: "         OF oDlgErro COLOR 0, 16777215 PIXEL
         
            //Botıes
            @ (nJanAltErr/2)-18, (nJanLarErr/2)-(63*1)  BUTTON oBtnFech PROMPT "Fechar"        SIZE 60, 014 OF oDlgErro ACTION (oDlgErro:End()) PIXEL
            @ (nJanAltErr/2)-18, (nJanLarErr/2)-(63*2)  BUTTON oBtnVisu PROMPT "Vis.Erro"      SIZE 60, 014 OF oDlgErro ACTION (fVisErro()) PIXEL
    ACTIVATE MSDIALOG oDlgErro CENTERED
     
    RestArea(aArea)
Return
 
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o que visualiza o erro conforme registro posicionado ±±
//±±∫          ≥ u_gCargaGen()                                             ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*-----------------------*  
Static Function fVisErro
*-----------------------*  
    Local nRet := 0
    Local cNomeArq := Alltrim((cAliasTmp)->TMP_ARQ)
 
    //Tentando abrir o objeto
    nRet := ShellExecute("open", cNomeArq, "", cDirTmp, 1)
     
    //Se houver algum erro
    If nRet <= 32
        MsgStop("N„o foi possÌvel abrir o arquivo " +cDirTmp+cNomeArq+ "!", "AtenÁ„o")
    EndIf
Return

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±∫Programa  ≥ gCargaGen ∫ Autor ≥ Gustavo Markx     ∫ Data ≥  11/03/2015±±
//±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕ±±
//±±∫Descricao ≥ FunÁ„o respons·vel por fazer a importaÁ„o dos dados       ±±
//±±∫          ≥ u_gCargaGen()                                             ±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*----------------------*  
Static Function iImport
*----------------------*  
    Local nLinAtu    := 2
    Local cLinAtu    := ""
    Local aAuxAtu    := {}
    Local cArqLog    := ""
    Local cConLog    := ""
    Local cSequen    := StrZero(1, 10)
    Local nPosAux    := 1
    Local lFalhou    := .F.
    Local xConteud	 := ""
    Local nAuxLog    := 0
    Local aLogAuto	 := {}
    Local _nZ           := 0
    
    Private aDados  := {}
    Private aTemp   := {}
    Private aCabec 	:= {}
    Private aItens 	:= {}
    Private aRatCC 	:= {}
    
    Private _nRegs := 0
    ProcRegua(nTotalReg)

    //Percorrendo TODOS os registros
    While !Ft_FEoF() .And. nLinAtu <= FT_FLastRec()
        IncProc("Analisando linha "+cValToChar(nLinAtu)+" de "+cValToChar(nTotalReg)+"...")
         
        //Pegando a linha atual e transformando em array
        cLinAtu := Ft_FReadLn()
        cLinAtu := IIF(SubStr(cLinAtu, Len(cLinAtu), 1) == ";", SubStr(cLinAtu, 1, Len(cLinAtu)-1), cLinAtu)
        aAuxAtu := Separa(cLinAtu, cGetCar)
         
        //Se tiver dados
        If !Empty(cLinAtu)
            lFalhou := .F.
            aDados  := {}    

            //Percorre o cabeÁalho
            For nPosAux := 1 To Len(aHeadImp)
                xConteud := aAuxAtu[nPosAux]
                 
                //Se o tipo do campo for NumÈrico
                If aHeadImp[nPosAux][2] == 'N' 
                	aAuxAtu[nPosAux] := StrTran(aAuxAtu[nPosAux],',','.')
                    xConteud := Val(aAuxAtu[nPosAux])
                 
                //Se o tipo for LÛgico
                ElseIf aHeadImp[nPosAux][2] == 'L'
                    xConteud := Iif(aAuxAtu[nPosAux] == '.T.', .T., .F.)
                     
                //Se o tipo for Data
                ElseIf aHeadImp[nPosAux][2] == 'D'
                    //Se tiver '/' na data, È padr„o DD/MM/YYYY
                    If '/' $ aAuxAtu[nPosAux]
                        xConteud := cToD(aAuxAtu[nPosAux])
                         
                    //Sen„o, È padr„o YYYYMMDD
                    Else
                        xConteud := sToD(aAuxAtu[nPosAux])
                    EndIf
                EndIf
                 
                //Se for o campo filial
                If '_FILIAL' $ aHeadImp[nPosAux][1]
                    //Se a filial for conforme o protheus
                    If lFilProt
                        xConteud := FWxFilial(cTabela)
                    EndIf
                EndIf
                 
                //Se for o campo chave
                If Alltrim(cCampoChv) == Alltrim(aHeadImp[nPosAux][1])
                    //Se a chave for conforme o protheus
                    If lChvProt
                        xConteud := GetSXENum(cTabela, cCampoChv)
                    EndIf
                EndIf
                 
                //Adicionando no vetor que ser· importado
                aAdd(aDados,{    aHeadImp[nPosAux][1],;     //Campo
                                xConteud,;                  //Conte˙do
                                Nil})                       //Compatibilidade
            Next

            aADD(aTemp, aDados)
        EndIf

        _nRegs++
        Ft_FSkip()
    EndDo
    
    zReload()

    IF !MsgYesNo('Foram identificados '+cValToChar(Len(aDados))+', pedidos, deseja importa-los?') 
        Return
    ENDIF
    
    //Percorrendo os registros
    nTotalReg := Len(aDados)
    For _nZ:=1 to Len(aDados)
        IncProc("Analisando linha "+cValToChar(nLinAtu)+" de "+cValToChar(nTotalReg)+"...")

        cArqLog := "log_"+cCmbTip+"_lin_"+cValToChar(nLinAtu)+"_"+dToS(dDataBase)+"_"+StrTran(Time(), ":", "-")+".txt"
        cConLog := "Tipo:     "+cCmbTip+STR_PULA
        cConLog += "Usu·rio:  "+UsrRetName(RetCodUsr())+STR_PULA
        cConLog += "Ambiente: "+GetEnvServer()+STR_PULA
        cConLog += "Data:     "+dToC(dDataBase)+STR_PULA
        cConLog += "Hora:     "+Time()+STR_PULA
        cConLog += "Filial ['"+cTabela+"'] "+xFilial(cTabela)
        cConLog += "----"+STR_PULA+STR_PULA

        lFalhou:= .F.

        //Seta as vari·veis de log do protheus
        lAutoErrNoFile    := .T.
        lMsErroAuto        := .F.

        aCabec := aClone(aDados[_nZ][1])
        aItens := aClone(aDados[_nZ][2])

        //Executa o execauto
        &(cRotina)

        /*
        aCabec2 := aCabec
        aItens2 := aItens

        lMsErroAuto := .F.
		lMSHelpAuto := .T.
		aCabec 		:= {}
		aItens 		:= {}
        
		aAdd( aCabec, { "C7_EMISSAO"	, dDataBase	, Nil } )
		aAdd( aCabec, { "C7_FORNECE"	, '003470'	, Nil } )
		aAdd( aCabec, { "C7_LOJA"		, '01' 	    , Nil } )
		aAdd( aCabec, { "C7_CONTATO"	, "teste"	, Nil } )
		aAdd( aCabec, { "C7_COND"		, '001'		, Nil } )

            For nY := 1 To 2
				aItem := {}
				aAdd( aItem, { "C7_PRODUTO"		, '175600021'		, Nil } )
				aAdd( aItem, { "C7_QUANT"		, 1		, Nil } )
				aAdd( aItem, { "C7_PRECO"		, 1		, Nil } )
				aAdd( aItem, { "C7_TOTAL" 		, 1  	    , Nil } )

				aadd(aItens,aItem)
			Next nY

            MsExecAuto({|v,x,y,z| MATA120(v, x, y, z)}, 1, aCabec, aItens, 3)
        */
        //Se tiver alguma falha
        If lMsErroAuto
            lFalhou := .T.

            //Pegando log do ExecAuto
            aLogAuto := GetAutoGRLog()
     
            //Gerando log
            For nAuxLog :=1 To Len(aLogAuto)
                cConLog += aLogAuto[nAuxLog] + STR_PULA
            Next             
        EndIf
                 
        //Se houve falha na importaÁ„o, grava na tabela tempor·ria
        If lFalhou
            //Gerando o arquivo
            MemoWrite(cDirTmp+cArqLog, cConLog)
         
            //Gravando o registro
            RecLock(cAliasTmp, .T.)
                TMP_SEQ    := cSequen
                TMP_LINHA  := nLinAtu
                TMP_ARQ    := cArqLog
            (cAliasTmp)->(MsUnlock())
             
            //Incrementa a sequencia
            cSequen := Soma1(cSequen)
        EndIf

        nLinAtu++
    Next _nZ
Return

*---------------------*
Static Function zReload
*---------------------*
Local _nE := 0
Local _nF := 0
Local _cChaveG := ''
Local _aQuebra := {}
Local _lNew     := .T.
//aCabec,aItens

aDados := {}

IF cCmbTip == "17"
    //Guarda chave 1
    For _nE := 1 To Len(aTemp)
        _c7NUM      := zScanArray(aTemp[_nE],'C1_NUM')

        _cChaveG := _c7NUM
        Exit
    Next _nE

    //Processa todos os arquivos
    For _nE := 1 To Len(aTemp)

        _aQuebra := aClone(aTemp[_nE])

        _c7NUM  := zScanArray(aTemp[_nE],'C1_NUM')

        IF _cChaveG <> _c7NUM
            _cChaveG := _c7NUM
            aADD(aDados, {aCabec, aItens})
            aCabec := {}; aItens := {}; _lNew := .T.
        ENDIF
        
        _TMP_IT := {}
        For _nF := 1 To Len(_aQuebra)

            IF AllTrim(_aQuebra[_nF][1]) $  _aCpoCB
                IF _lNew
                    aADD(aCabec, _aQuebra[_nF])
                ENDIF
            Else
                aADD(_TMP_IT, _aQuebra[_nF])
            ENDIF
        Next _nF
        _TMP_IT := FWVetByDic(_TMP_IT,cTabela)
        aADD(aItens, _TMP_IT)

        _lNew := .F.
    Next _nE

ElseIF cCmbTip == "18"

    //Guarda chave 1
    For _nE := 1 To Len(aTemp)
        _c7FORNECE  := zScanArray(aTemp[_nE],'C7_FORNECE')
        _c7LOJA     := zScanArray(aTemp[_nE],'C7_LOJA')
        _c7COND     := zScanArray(aTemp[_nE],'C7_COND')
        _c7CONTATO  := zScanArray(aTemp[_nE],'C7_CONTATO')

        _cChaveG := _c7FORNECE + _c7LOJA + _c7COND +_c7CONTATO
        Exit
    Next _nE

    //Processa todos os arquivos
    For _nE := 1 To Len(aTemp)

        _aQuebra := aClone(aTemp[_nE])

        _c7FORNECE  := zScanArray(aTemp[_nE],'C7_FORNECE')
        _c7LOJA     := zScanArray(aTemp[_nE],'C7_LOJA')
        _c7COND     := zScanArray(aTemp[_nE],'C7_COND')
        _c7CONTATO  := zScanArray(aTemp[_nE],'C7_CONTATO')
        //_lNew := _cChaveG <> _c7FORNECE + _c7LOJA + _c7COND +_c7CONTATO

        IF _cChaveG <> _c7FORNECE + _c7LOJA + _c7COND +_c7CONTATO
            _cChaveG := _c7FORNECE + _c7LOJA + _c7COND +_c7CONTATO
            aADD(aDados, {aCabec, aItens})
            aCabec := {}; aItens := {}; _lNew := .T.
        ENDIF
        
        _TMP_IT := {}
        For _nF := 1 To Len(_aQuebra)

            IF AllTrim(_aQuebra[_nF][1]) $  _aCpoCB
                IF _lNew
                    aADD(aCabec, _aQuebra[_nF])
                ENDIF
            Else
                aADD(_TMP_IT, _aQuebra[_nF])
            ENDIF
        Next _nF
        aADD(aItens, _TMP_IT)

        _lNew := .F.
    Next _nE
Endif

aADD(aDados, {aCabec, aItens})

Return
*-----------------------------------------*
Static Function zScanArray(_gArray,_cBusca)
*-----------------------------------------*
Local _cScanArray := ''

IF (_nPos := aScan(_gArray, {|a| a[1] == _cBusca})) > 0
    _cScanArray := _gArray[_nPos][2]
ENDIF

Return(_cScanArray)


*----------------------*
User Function gCargaAut
*----------------------*
Local _aFiles  := {} // O array receber· os nomes dos arquivos e do diretÛrio
//Local aSizes   := {} // O array receber· os tamanhos dos arquivos e do diretorio
//Local nX        := 0
Local cPathEst
Local _nR       := 0

Private _oWizard
Private nret
//Private cPathEst  := 'CARGAAUTO' 
Private _aTipAuto := {}

IF Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("01","0101")

ElseIf (IsBlind())
	/*Array padr√£o do sistema passado por parametro quando a rotina √© chamada via schedule*/
	cEmp_schedule := aSchedule[01]
	cFil_schedule := aSchedule[02]
		
    RPCSetEnv(cEmp_schedule, cFil_schedule)
EndIf

Private cIniFile	:= GetADV97()
Private cStartPath 	:= GetPvProfString(GetEnvServer(),	"StartPath","ERROR", cIniFile )+cPathEst+'\'

//CRIA DIRETORIOS
MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+cPathEst+'\')

//Diretorio Base dos arquivos
_cDirPad := Alltrim(GetMV('MC_LOJM05',.F.,'C:\temp\AutoCarga\'))

/*
//Preenche uma sÈrie de arrays com informaÁıes de arquivos e diretÛrios (nomes de arquivos, tamanhos, datas, horas e atributos).
aArquivos := u_zRecurDir(_cDirPad, "*.zip", dDataBase-1)

For _nR:=1 To Len(aArquivos)
	//Copiando o arquivo via CpyT2S
	CpyT2S(aArquivos[_nR][1], cStartPath)

	//Quebra caminho do arquivo 
	_aSepDir := Separa(aArquivos[_nR][1],'\',.T.)

	cDirArqs := cStartPath+'\'+_aSepDir[Len(_aSepDir)]
	cArqNov  := cStartPath
Next _nR
*/

    Aadd(_aTipAuto,{'01','SA6'}) //Bancos
    Aadd(_aTipAuto,{'02','SA1'}) //Clientes
    Aadd(_aTipAuto,{'03','SE4'}) //CondiÁ„o de Pagamento
    Aadd(_aTipAuto,{'04','SE1'}) //Contas a Receber
    Aadd(_aTipAuto,{'05','SE2'}) //Contas a Pagar
    Aadd(_aTipAuto,{'06','SA2'}) //Fornecedores
    Aadd(_aTipAuto,{'07','SED'}) //Naturezas
    Aadd(_aTipAuto,{'08','SB1'}) //Produtos
    Aadd(_aTipAuto,{'09','SB9'}) //Saldo Inicial
    Aadd(_aTipAuto,{'10','SF4'}) //TES (Tipo de Entrada e SaÌda)
    Aadd(_aTipAuto,{'11','SF5'}) //TM (Tipo de MovimentaÁ„o)
    Aadd(_aTipAuto,{'12','SA4'}) //Transportadoras
    Aadd(_aTipAuto,{'13','DA3'})//VeÌculos
    Aadd(_aTipAuto,{'14','SA3'}) //Vendedores
    Aadd(_aTipAuto,{'15','SA3'}) //Saldo Inicial por Lote
    Aadd(_aTipAuto,{'16','SFM'}) //TES Inteligente
    Aadd(_aTipAuto,{'17','SC1'}) //SolicitaÁ„o de Compras
    Aadd(_aTipAuto,{'18','SC7'}) //Pedido de Compras

//Lista dos XML dos fornecedores										
_aFiles:={}
ADir( cStartPath+"*.csv",_aFiles )

IF LEn(_aFiles) > 0
	For _nR:=1 To Len(_aFiles)
        _cDirDoc := cStartPath+_aFiles[_nR]
		_cDirPad := _aFiles[_nR]    
        _cDirAls := UPPER(LEFT(_aFiles[_nR],3))

        IF (_nPos := aScan(_aTipAuto, {|a| a[2] == _cDirAls}) ) > 0         
            cCmbTip   := _aTipAuto[_nPos][_nR]
            _lRetAuto := U_zCargaGen(_cDirDoc,cCmbTip)
            
            IF _lRetAuto
                FRename(cStartPath+Lower(ALLTRIM(_aFiles[_nR])), cStartPath+Lower(ALLTRIM(_aFiles[_nR]))+".imp")
            Else
                FRename(cStartPath+Lower(ALLTRIM(_aFiles[_nR])), cStartPath+Lower(ALLTRIM(_aFiles[_nR]))+".div")
            Endif
        Else
            FRename(cStartPath+Lower(ALLTRIM(_aFiles[_nR])), cStartPath+Lower(ALLTRIM(_aFiles[_nR]))+".err")
        EndIF
	Next _nR
Endif   

Return
