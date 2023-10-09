#INCLUDE "protheus.ch"    
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "shell.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#DEFINE ENTER Chr(13)+Chr(10) 

//Constantes
#Define STR_PULA	Chr(13)+ Chr(10)
#Define HDCODBAR 	15

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥FunáÖo    ≥ RHCOLINV ≥ Autor ≥ Genesis/Gustavo       ≥ Data ≥ 29/12/20 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Tela para gerenciamento do Invent·rio                      ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

*---------------------*
User Function SLECOCKOUT
*---------------------*

If Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("02","1501")
Endif

DbSelectArea('ZZZ')

U_SLSEPA81()
RETURN

*---------------------*
User Function SLSEPA81
*---------------------*
Local _cTabPAD  := ''
Local _cArmPAD  := '01'
Local _lFilter  := .F.
Local _cFCond   := ''
Local _cNameTela := OemToAnsi("SeparaÁ„o de Pedidos (CÛdigo de Barras) - "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+ AllTrim(Upper(SM0->M0_FILIAL)))

Private _lEdita    := .F.
Private _cCodTria  := Space(6)
Private _cBoreroCH := Space(6)
Private _lBordero  := .F.
Private _nMultiplo := GetMV('SL_SEPA81',.F.,10)
Private __lSEPFim  := .T.
Private _lPainel   := IsBlind() 

Public __cRetorno := Space(TamSX3('B1_COD')[1])

IF !gLoadCPO()
	Return
ENDIF

_cTabPAD   := ''
_cArmPAD   := ''
_lFilter   := .F.
_cFCond    := ""

_cF3CH := " SELECT	'' MARC, '' LEGEND,  "+ENTER
_cF3CH += "         ZZZ_PRODUT,ZZZ_DESCRI,ZZZ_UM,ZZZ_QUANT,ZZZ_CODBAR,ZZZ_USERID,ZZZ_DTLOG, ZZZ.R_E_C_N_O_ ZZZREC "+ENTER
_cF3CH += " FROM "+RetSqlName('ZZZ')+" ZZZ  "+ENTER
_cF3CH += "   WHERE ZZZ.D_E_L_E_T_='' "+ENTER
_cF3CH += "     AND ZZZ_FILIAL = '"+FwxFilial('ZZZ')+"' "+ENTER
_cF3CH += "     AND ZZZ_PEDIDO = '#SC5->C5_NUM#' "+ENTER

//ValidaÁ„o de retorno de registros
IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cF3CH),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())
IF _nMax == 0
	//MsgInfo('N„o foram localizados registros para este filtro.'+ENTER,'Invent·rio coletor')
	//Return
Endif

_lEdita    := .T.
_lBordero  := .F.

_lf3OK := zConsSQL(_cF3CH,"B1_COD","","9 DESC",_cNameTela,'0',{_cArmPAD})

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ zConsSQL ∫ Autor ≥ 	Genesis/Gustavo	 ∫ Data ≥  26/03/19     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Tela de consulta padr„o do produto - F3 (Lupa)               π±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Uso especifico Home Doctor                                   ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ∫±±
±±∫FunÁ„o para consulta genÈrica											∫±±
±±∫	@obs: O retorno da consulta È p˙blica (__cRetorno) para ser usada em 	∫±±
±±∫       consultas especÌficas												∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
*---------------------------------------------------------------------*
Static Function zConsSQL(cConsSQLM, cRetorM, cAgrupM, cOrderM,_cNomeTela, _xOpc,_xParam)
*---------------------------------------------------------------------*
Local aArea   := GetArea()
Local nTamBtn := 50	
	
	//Defaults
	Default cConsSQLM  := ""
	Default cRetorM    := ""
	Default cOrderM    := ""        
	Default _cNomeTela := "Consulta de Dados"
	Default _xOpc      := ''
	Default _xParam	   := {}

	Private oGrpPesqui
	Private oGrpDados
	Private oGrpAcoes
	Private oBtnConf
	Private oBtnLimp
	Private oBtnCanc
	Private oBtnFilt     

	Private _gOpc      := _xOpc
	Private _gParam    := _xParam
	
	//Privates
	Private zConsSQL  := cConsSQLM
	Private cConsSQL  := cConsSQLM
	Private cCampoRet := cRetorM
	Private cAgrup    := cAgrupM
	Private cOrder    := cOrderM
	Private nTamanRet := 0
	Private aStruAux  := {}
	Private _cFilter  := ''
	Private _lPrdSimil:= GetMV('MC_B1XSGI',.F.,.F.)
	Private _cTri_DIV := AllTrim(GetMV('KS_FN92DIV',.F.,'999999'))
	
	//MsNewGetDados
	Private oMsNew
	Private aHeadAux := {}
	Private aColsAux := {}

	//Tamanho da janela
	Private aSize := {0,0,0,0,1350,0600}
	Private nJanLarg := aSize[5]
	Private nJanAltu := aSize[6]

	//Gets e Dialog
	Private oDlgEspe                        
	
	Private oGetPesq,  cGetPesq  := Space(6)
	Private oGetPesq2, cGetPesq2 := Space(6)
	Private oGetPesq3, cGetPesq3 := Space(6)
	Private _lGetPesq  := .T.
	Private _lGetPesq2 := .T.
	Private _lGetPesq3 := .T.	
		
	Private _lUsoGrv   := .F.
	Private _oCkGrv, _lCkGrv := .F.
	
	Private _nVAL_TRI := 0
	Private _nQTD_TRI := 0
	Private _oSayQTD
	Private _oSayVAL
	Private _oSayTRI

	Private _nVAL_SEL := 0
	Private _oSayCHS
	Private _oSayCHX
	Private _oSayVLS	
	
	Private _nVAL_TER := 0
	Private _nQTD_TER := 0
	Private _oSayTER	
	Private _oSayTEX

	Private oBtnIt1
	Private oMenuA
	Private oTMnuA01
	Private oTMnuA02
	Private oTMnuA03
	Private oTMnuA04
	Private oTMnuA05
	Private oTMnuA06
	Private oTMnuA07
	Private oMenuA
	Private oTButn_A

	Private oBtnIt2
	Private oMenuB
	Private oTMnuB01
	Private oTMnuB02
	Private oTMnuB03
	Private oTMnuB04
	Private oMenuB
	Private oTButn_B

	Private _oGetCodB,  _cGetCodB  := Space(HDCODBAR)
	Private _lGetCodB  := .F.

    Private _oSayCl   
    Private _oSayClDDs
    Private _oSayTr   
    Private _oSayTrDDs

    Private _cChaveNF := ''
    Private _cDocSF2  := ''

	Private _cCSSBt1 := ''
	Private _oBtnFi1
	Private _cCSSBt2 := ''
	Private _oBtnFi2
	Private _cCSSBt3 := ''
	Private _oBtnFi3

	//Tamanho da janela
	IF !_lPainel
		aSize    := MsAdvSize(.F.)
		nJanLarg := aSize[5]
		nJanAltu := aSize[6]
	endif

	oFontSayRoda:= TFont():New("arial",,16,,.T.,,,,,.F.)
    oFontSayCB  := TFont():New("Courier New",,16,,.T.,,,,,.F.)
    oFontSayCBN := TFont():New("Courier New",,16,,.T.,,,,,.F.)
    oFontSayCBN:Bold := .T.
	oFontSay    := TFont():New('Courier new',,-22,.T.)
	oFontSayN   := TFont():New('Courier new',,-25,.T.)
	oFontSayN:Bold := .T.

	//Retorno
	Private lRetorn := .F.         
	
	Public  __cRetorno := ""

    //Declarando os objetos de cores para usar na coluna de status do grid
    Private oVerde	    := LoadBitmap( GetResources(), "BR_VERDE")
    Private oAmarelo    := LoadBitmap( GetResources(), "BR_AMARELO")
    Private oAzul  	    := LoadBitmap( GetResources(), "BR_AZUL")
    Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
    Private oRosa		:= LoadBitmap( GetResources(), "BR_PINK")
    Private oPreto	    := LoadBitmap( GetResources(), "BR_PRETO")
	Private oLaranja    := LoadBitmap( GetResources(), "BR_LARANJA")

    Private _oCheck     := LoadBitmap( GetResources(), "CHECKED")
    Private _oUnCheck   := LoadBitmap( GetResources(), "UNCHECKED") 

	//Se tiver o alias em branco ou n„o tiver campos
	If Empty(cConsSQLM) .Or. Empty(cRetorM)
		MsgStop("SQL e / ou retorno em branco!", "AtenÁ„o")
		Return lRetorn
	EndIf
	
	//IF !zControl(@_lEdita,_cCodTria)
	//	Return
	//ENDIF

	xLoadPesq(1)
	
	//Criando a estrutura para a MsNewGetDados
	fCriaMsNew()
	__cRetorno := Space(nTamanRet)

	//Criando a janela
	DEFINE MSDIALOG oDlgEspe TITLE _cNomeTela FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL Style 128
	oDlgEspe:lEscClose := .F. 

		//Pesquisar
		@ 003, 003 GROUP oGrpPesqui TO 042, (nJanLarg/2)-3 PROMPT "Pesquisar: "	OF oDlgEspe COLOR 0, 16777215 PIXEL

		_oSayPV := TSay():New(010, 006,{||'Pedido: '},oDlgEspe,,oFontSay,,,,.T.,CLR_HBLUE,CLR_WHITE,050,020)
        _oSayPV:NCLRTEXT := RGB(255,0,0)
		@ 010, 060 MSGET oGetPesq  VAR cGetPesq  SIZE 100, 010 OF oDlgEspe FONT oFontSayCB COLORS 0, 16777215 WHEN(_lGetPesq)  VALID(fVldPed())   PIXEL

		_oSayCl    := TSay():New(025, 006,{||'Cliente: '},oDlgEspe,,oFontSayCBN,,,,.T.,CLR_HBLUE,CLR_WHITE,050,020)
        _oSayClDDs := TSay():New(025, 060,{||''},oDlgEspe,,oFontSayCB,,,,.T.,CLR_BLACK,CLR_WHITE,200,020)

		_oSayTr    := TSay():New(033, 006,{||'Transportadora: '},oDlgEspe,,oFontSayCBN,,,,.T.,CLR_HBLUE,CLR_WHITE,050,020)
        _oSayTrDDs := TSay():New(033, 060,{||''},oDlgEspe,,oFontSayCB,,,,.T.,CLR_BLACK,CLR_WHITE,200,020)

		//Codigo de Barras //
		@ 026, (nJanLarg/2)-((nTamBtn*6)+11) MSGET _oGetCodB VAR _cGetCodB SIZE (nJanLarg/2)-((nTamBtn*8)+41), 013 FONT oFontSayN OF oDlgEspe COLORS 0, 16777215 WHEN(_lGetCodB) VALID(u_fVlCodBar())   PIXEL

		//Legenda
		_oSayTRI := TSay():New(008, (nJanLarg/2)-((nTamBtn*5)+200),{||'Checkout - SeparaÁ„o de Mercadoria'},oDlgEspe,,oFontSayN,,,,.T.,CLR_HBLUE,CLR_WHITE,300,20)
        _oSayTRI:NCLRTEXT := RGB(218,165,32)

		@ 020,(nJanLarg/2)-((nTamBtn*6)+11) Say OemToAnsi('Leitura cÛdigo de barras:') PIXEL OF oDlgEspe

        //@ 014,(nJanLarg/2)-((nTamBtn*1.5)+00) Say OemToAnsi('<F2>  - Finaliza SeparaÁ„o') 	PIXEL OF oDlgEspe
		//@ 020,(nJanLarg/2)-((nTamBtn*1.5)+00) Say OemToAnsi('<F4>  - Cancela SeparaÁ„o') 		PIXEL OF oDlgEspe
		//@ 026,(nJanLarg/2)-((nTamBtn*1.5)+00) Say OemToAnsi('<F6>  - Multipla SeparaÁ„o') 	PIXEL OF oDlgEspe
		//@ 032,(nJanLarg/2)-((nTamBtn*1.5)+00) Say OemToAnsi('<F12> - Sair') 					PIXEL OF oDlgEspe				

		//_cCSSBt1   := "QPushButton { background-color: #f4f4f4}"
		_cCSSBt1   := "QPushButton { background-color: #90EE90}"
		_oBtnFi1   := TButton():Create(oDlgEspe, 008,(nJanLarg/2)-((nTamBtn*1.5)+00),"<F2> Finaliza SeparaÁ„o",{|| xBTNMenuA(2)}, nTamBtn+15,010,,,,.T.,,"<F2> Finaliza SeparaÁ„o",,,,,)
		_oBtnFi1:SetCSS(_cCSSBt1)

		_cCSSBt2   := "QPushButton { background-color: #F0E68C}"
		_oBtnFi2   := TButton():Create(oDlgEspe, 020,(nJanLarg/2)-((nTamBtn*1.5)+00),"<F4> Multipla SeparaÁ„o",{|| xBTNMenuA(4)}, nTamBtn+15,010,,,,.T.,,"<F2> Finaliza SeparaÁ„o",,,,,)
		_oBtnFi2:SetCSS(_cCSSBt2)
		_oBtnFi2:lActive := .F.
	
		_cCSSBt3   := "QPushButton { background-color: #FF6347}"
		_oBtnFi3   := TButton():Create(oDlgEspe, 032,(nJanLarg/2)-((nTamBtn*1.5)+00),"<F6> Cancela SeparaÁ„o",{|| xBTNMenuA(3)}, nTamBtn+15,009,,,,.T.,,"<F2> Finaliza SeparaÁ„o",,,,,)
		_oBtnFi3:SetCSS(_cCSSBt3)
		_oBtnFi3:lActive := .F.

		//Dados
		@ 043, 003 GROUP oGrpDados TO (nJanAltu/2)-28, (nJanLarg/2)-3 PROMPT "Dados: "	OF oDlgEspe COLOR 0, 16777215 PIXEL
			oMsNew := MsNewGetDados():New( 		050,;										//nTop
    											006,;										//nLeft
    											(nJanAltu/2)-31,;							//nBottom
    											(nJanLarg/2)-6,;							//nRight
    											GD_INSERT+GD_DELETE+GD_UPDATE,;			//nStyle
    											"AllwaysTrue()",;							//cLinhaOk
    											,;											//cTudoOk
    											"",;										//cIniCpos
    											,;											//aAlter
    											,;											//nFreeze
    											999,;										//nMax
    											,;											//cFieldOK
    											,;											//cSuperDel
    											,;											//cDelOk
    											oDlgEspe,;									//oWnd
    											aHeadAux,;									//aHeader
    											aColsAux)									//aCols                                    
			oMsNew:lActive := .F.
			oMsNew:oBrowse:blDblClick   := {|| fConfirm()}
            oMsNew:oBrowse:bHeaderClick := {|oMsNew,nCol| fClickH(nCol)} 
		
			//Populando os dados da MsNewGetDados
			fPopula()
			IF _lCkGrv 
				fVldPesq()
			ENDIF		  
			
		//AÁıes
		@ (nJanAltu/2)-25, 003 GROUP oGrpAcoes TO (nJanAltu/2)-3, (nJanLarg/2)-3 PROMPT "AÁıes: "	OF oDlgEspe COLOR 0, 16777215 PIXEL

		_cQtde := IIF(!_lPainel,AllTrim(TransForm(_nQTD_TRI,"@e 9,999,999")), TransForm(_nQTD_TRI,"@e 9,999,999")) 
		_oSayQTD := TSay():New((nJanAltu/2)-19, 010,{||'Qtde.: '+_cQtde},oDlgEspe,,oFontSAY,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		_oSayCHS := TSay():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*4)+330)  ,{||'Nota Fiscal: '},oDlgEspe,,oFontSAY,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		_oSayCHX := TSay():New((nJanAltu/2)-16, (nJanLarg/2)-((nTamBtn*4)+240)  ,{||},oDlgEspe,,oFontSayRoda,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		_oSayNFC := TBitmap():New((nJanAltu/2)-16, (nJanLarg/2)-((nTamBtn*4)+340), 010, 010, "BR_VERMELHO", 	Nil, .T., oDlgEspe, {|| Alert("Clique em TBitmap")}, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
		_oSayNFC:LAUTOSIZE := .T.
        
		_oSayTER  := TSay():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*4)+170)  ,{||'Status Sefaz: '+_cChaveNF},oDlgEspe,,oFontSAY,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		_oSayTEX  := TSay():New((nJanAltu/2)-16, (nJanLarg/2)-((nTamBtn*4)+070)  ,{||''},oDlgEspe,,oFontSayRoda,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		_oSayTSSC := TBitmap():New((nJanAltu/2)-16, (nJanLarg/2)-((nTamBtn*4)+180), 010, 010, "BR_VERMELHO", 	Nil, .T., oDlgEspe, {|| Alert("Clique em TBitmap")}, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
		_oSayTSSC:LAUTOSIZE := .T.

		//@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Limpar" 	SIZE nTamBtn, 013 OF oDlgEspe ACTION(fLimpar())     PIXEL
		//@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*3)+12) BUTTON oBtnCanc PROMPT "Sair" 	SIZE nTamBtn, 013 OF oDlgEspe ACTION(fCancela())    PIXEL

		@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Sair" 	SIZE nTamBtn, 013 OF oDlgEspe ACTION(fCancela())     PIXEL

		// Cria Menu <><><><><><><><><><><><><><><><><><><><><><><><><><><><> TRIAGEM  <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
		oMenuA := TMenu():New( 0,0,0,0,.T.,'',oDlgEspe,CLR_WHITE,CLR_BLACK)

		// Adiciona itens no Menu    
		//oTMnuA02 := TMenuItem():New(oBtnIt1,"<F2> Finalizar"        ,,,,{|| FwMsgRun(,{|| xBTNMenuA(2) }, "Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)
		//oTMnuA03 := TMenuItem():New(oBtnIt1,"<F4> Excluir"	 	  ,,,,{|| FwMsgRun(,{|| xBTNMenuA(3) }, "Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)
        //oTMnuA04 := TMenuItem():New(oBtnIt1,"<F6> Mult.SeparaÁ„o"   ,,,,{|| FwMsgRun(,{|| xBTNMenuA(4) }, "Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)
		
		oTMnuA04 := TMenuItem():New(oBtnIt1,"Parametros"	  	,,,,{|| FwMsgRun(,{|| xBTNMenuA(7) }, 	"Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)
		oTMnuA05 := TMenuItem():New(oBtnIt1,"Atualiza Tela"  	,,,,{|| FwMsgRun(,{|| fLimpar() }, 		"Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)
		oTMnuA06 := TMenuItem():New(oBtnIt1,"Nova SeparaÁ„o" 	,,,,{|| FwMsgRun(,{|| xBTNMenuA(6) }, 	"Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)
		oTMnuA07 := TMenuItem():New(oBtnIt1,"RelatÛrio"	   		,,,,{|| FwMsgRun(,{|| xBTNMenuA(5) }, 	"Aguarde Processamento...","Parametros do sistems")  },,,,,,,,,.T.)

		//Adiciona lista de opÁıes
		//oMenuA:Add(oTMnuA02)
		//oMenuA:Add(oTMnuA03)
		oMenuA:Add(oTMnuA04)
		oMenuA:Add(oTMnuA05)
		oMenuA:Add(oTMnuA06)
		oMenuA:Add(oTMnuA07)

		// Cria bot„o que sera usado no Menu
		oTButn_A := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06), "Outras AÁıes",oDlgEspe,{|| Alert("Triagem")}, 50,13,,,.F.,.T.,.F.,,.F.,,,.F. )
		// Troca a Cor do Bot„o
		oTButn_A:SetColor(CLR_BLUE)
		// Define bot„o no Menu
		oTButn_A:SetPopupMenu(oMenuA)
		//Define se botao ficara ativo
		oTButn_A:lActive := .T.

		//Atualiza totalizadores
		zCountCH()

	//Ativando a janela
	ACTIVATE MSDIALOG oDlgEspe CENTERED
	
	RestArea(aArea)
Return lRetorn

*---------------------*
Static Function fButton
*---------------------*

//Se processo ja foi finalizado
IF __lSEPFim
	//Limpando Atalhos
	SetKey( VK_F4,  Nil )
	SetKey( VK_F6,  Nil )
	_oBtnFi2:lActive := .F.
	_oBtnFi3:lActive := .F.
	_lGetCodB := .F.
	_oGetCodB:lActive := .F.	
ELSE
    SetKey( VK_F6,  {|| xBTNMenuA(3) })
    SetKey( VK_F4,  {|| xBTNMenuA(4) })
	_oBtnFi2:lActive := .T.
	_oBtnFi3:lActive := .T.	
ENDIF

SetKey( VK_F2,  {|| xBTNMenuA(2) })
SetKey( VK_F12, {|| fCancela() })  

RETURN

*---------------------*
Static Function fVldPed
*---------------------*
Local _lPedOk  := .T.
Local _cPedido := &(READVAR())
Local _cPopUp  := ''

//DbSelectArea("PZU");PZU->(DbSetOrder(3))
//IF PZU->(DBSEEK(xFilial('PZU')+_cPedido)) .AND. !PZU->PZU_STATUS $ '45'
//	MSGALERT("N„o foi realizado a separaÁ„o ou pedido j· separado anteriormente!","Checkout")
//	RETURN
//endif

DbSelectArea('SC5');SC5->(DbSetOrder(1))
IF (_lPedOk := SC5->(DbSeek(xFilial('SC5')+_cPedido)))
	DbSelectArea('SA1');SA1->(DbSetOrder(1))
    DbSelectArea('SA1');SA1->(DbSetOrder(1))

	SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
    _lTransp  := SA4->(DbSeek(xFilial('SA4')+ SC5->C5_TRANSP ))
    __lSEPFim := !Empty(SC5->C5_NOTA)

    _cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">AtenÁ„o</font> '
    _cPopUp += ' <br> '
    _cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
    _cPopUp += ' <br><br>'
    _cPopUp += ' <font color="#000000" face="Arial" size="3">Pedido de Venda</font> '
    _cPopUp += ' <br><br> '
        		
    If SC5->C5_BLQ == '0'  
		_cPopUp += ' <font color="#000000" face="Arial" size="2">Status: Bloqueado!</font> '		
       _lPedOk  := .F.
	Else
        cConsSQL := StrTran(cConsSQL,'#SC5->C5_NUM#',SC5->C5_NUM)
	Endif

	IF !_lPedOk
		FWAlertWarning(_cPopUp,'NotificaÁ„o de Mercadoria')
	ENDIF

	//Valida SC9 do Pedido
	_lPedOk  := zLoadSC9(.T.,.T.)[1]
	
	IF _lPedOk
        _oSayClDDs:SetText(SA1->A1_COD+' / '+SA1->A1_LOJA+' - '+SA1->A1_NOME)
        _oSayClDDs:CtrlRefresh()

        _oSayTrDDs:SetText(IIF(_lTransp,SA4->A4_NOME,''))
        _oSayTrDDs:CtrlRefresh()        

        //FunÁ„o que limpa os dados da rotina 
        fLimpar()

        xBTNMenuA(1)      
	EndIF      

	U_zSttsEcom(.T.,_cPedido,'5',)
Else
	_lPedOk := Empty(_cPedido)
EndIF

IF !_lPedOk
	FWAlertWarning('Informe um pedido de venda V·lido'+ENTER+ENTER+'Pedido: '+_cPedido,'NotificaÁ„o de Mercadoria')
	//xClearTela()
	cGetPesq := Space(6)
	oGetPesq:Refresh()
EndIF

RETURN(_lPedOk)

 /*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ zConsSQL ∫ Autor ≥ 	Genesis/Gustavo	 ∫ Data ≥  26/03/19     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ FunÁ„o para criar a estrutura da MsNewGetDados               π±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Uso especifico Grupo Merc                                    ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ∫*/
*-------------------------*
Static Function fCriaMsNew
*-------------------------*
	Local aAreaX3 := SX3->(GetArea())
	Local cQuery  := ""
	Local nAtual  := 0
	Local _nE     := 0

	//Zerando o cabeÁalho e a estrutura
	aHeadAux := {}
	aColsAux := {}
	
	//Monta a consulta e pega a estrutura
	cQuery := cConsSQL
	
	//Group By
	If !Empty(cAgrup)
		cQuery += cAgrup + STR_PULA
	EndIf
	
	//Order By
	cQuery += " ORDER BY "	+ STR_PULA
	If !Empty(cOrder)
		cQuery += "   "+cOrder
	Else
		cQuery += "   "+cCampoRet
	EndIf
	TCQuery cQuery New Alias "QRY_DAD"
	aStruAux := QRY_DAD->(DbStruct())
	QRY_DAD->(DbCloseArea())
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2)) // Campo
	SX3->(DbGoTop())
	
	//Percorrendo os campos
	For nAtual := 1 To Len(aStruAux)
		cCampoAtu := aStruAux[nAtual][1]

        IF nAtual == 1
            Aadd(aHeadAux, {;
                                "",;//X3Titulo()
                                "MARC",;  //X3_CAMPO
                                "@BMP",;		//X3_PICTURE
                                3,;			//X3_TAMANHO
                                0,;			//X3_DECIMAL
                                ".F.",;		//X3_VALID
                                "",;			//X3_USADO
                                "C",;			//X3_TIPO
                                "",; 			//X3_F3
                                "V",;			//X3_CONTEXT
                                "",;			//X3_CBOX
                                "",;			//X3_RELACAO
                                "",;			//X3_WHEN
                                "V"})	
                        ElseIF nAtual == 2
            Aadd(aHeadAux, {;
                                "",;		//X3Titulo()
                                "LEGEND",;  //X3_CAMPO
                                "@BMP",;	//X3_PICTURE
                                3,;			//X3_TAMANHO
                                0,;			//X3_DECIMAL
                                ".F.",;		//X3_VALID
                                "",;		//X3_USADO
                                "C",;		//X3_TIPO
                                "",; 		//X3_F3
                                "V",;		//X3_CONTEXT
                                "",;		//X3_CBOX
                                "",;		//X3_RELACAO
                                "",;		//X3_WHEN
                                "V"})	

        ELSE
            //Se coneguir posicionar no campo
            If SX3->(DbSeek(cCampoAtu))
                //CabeÁalho ...	Titulo		Campo		Mask									Tamanho				Dec					Valid	Usado	Tip				F3	CBOX
                aAdd(aHeadAux,{	X3Titulo(),	cCampoAtu,	PesqPict(SX3->X3_ARQUIVO, cCampoAtu),	SX3->X3_TAMANHO,	SX3->X3_DECIMAL,	".F.",	".F.",	SX3->X3_TIPO,	"",	""})
                
                //Se o campo atual for retornar, aumenta o tamanho do retorno
                If cCampoAtu $ cCampoRet
                    nTamanRet += SX3->X3_TAMANHO
                EndIf
                
            Else
                //CabeÁalho ...	Titulo									Campo		Mask	Tamanho					Dec						Valid	Usado	Tip						F3	CBOX
                aAdd(aHeadAux,{	Capital(StrTran(cCampoAtu, '_', ' ')),	cCampoAtu,	"",		aStruAux[nAtual][3],	aStruAux[nAtual][4],	".F.",	".F.",	aStruAux[nAtual][2],	"",	""})
                
                //Se o campo atual for retornar, aumenta o tamanho do retorno
                If cCampoAtu $ cCampoRet
                    nTamanRet += aStruAux[nAtual][3]
                EndIf
            EndIf
        EndIf
	Next
	
	//FIXA TAMANHO DE ESTRUTURA
	For _nE:=1 To Len(aHeadAux)     
		IF aHeadAux[_nE][2] == 'PZA_PROD'
			aHeadAux[_nE][4] := 15
		ElseIF aHeadAux[_nE][2] == 'PZA_REDE'
			aHeadAux[_nE][4] := 15		
		ElseIF aHeadAux[_nE][2] == 'B1_DESC'
			aHeadAux[_nE][4] := 50
		ElseIF aHeadAux[_nE][2] == 'EF_VALOR'
			aHeadAux[_nE][3] := '@E 9,999,999.99'
			aHeadAux[_nE][4] := 12
			aHeadAux[_nE][5] := 2
		ElseIF aHeadAux[_nE][2] == 'ZZZ_QUANT'
			aHeadAux[_nE][3] := '@E 9,999,999.99'
			aHeadAux[_nE][4] := 12
			aHeadAux[_nE][5] := 2			
		ElseIF aHeadAux[_nE][2] == 'B2_QATU'
			aHeadAux[_nE][3] := '@E 99,999,999.99'
			aHeadAux[_nE][4] := 13
			aHeadAux[_nE][5] := 2
		ElseIF Upper(aHeadAux[_nE][2]) == Upper('SALDO_DISPONIVEL')
			aHeadAux[_nE][3] := '@E 99,999,999.99'
			aHeadAux[_nE][4] := 13
			aHeadAux[_nE][5] := 2						
		ENDIF
	Next _nE
	RestArea(aAreaX3)
Return
/*---------------------------------------------------------------------*
 | Desc:  FunÁ„o que popula a tabela auxiliar da MsNewGetDados         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
*-------------------------------*
Static Function fPopula(_cFilter)
*-------------------------------*
	Local _aAreaf 	:= GetArea()
	Local cQuery	:= ""
	Local nAtual 	:= 0  
	Local aColsNov 	:= oMsNew:aCols
	Local _aHeader 	:= oMsNew:aHeader
	Local nLinAtu  	:= oMsNew:nAt
	Local _nSEFREC 	:= aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="EF_NUMSEQ"}) 

	Default _cFilter := ''

	aColsAux :={}
	nCampAux := 1
	//Faz a consulta
	cQuery := cConsSQL + STR_PULA
	
	//FILTRO DE PESQUISA___________________________________________________________
	If !Empty(cGetPesq) .And. .F.
		If 'WHERE' $ cQuery
			cQuery += "   AND "
		Else
			cQuery += "   WHERE "
		EndIf
		cQuery += " ( "
		For nAtual := 1 To Len(aStruAux)
			cCampoAtu := aStruAux[nAtual][1]
			If aStruAux[nAtual][2] == 'C' .And. '_' $ cCampoAtu
				cQuery += " UPPER("+cCampoAtu+") LIKE '%"+Upper(Alltrim(cGetPesq))+"%' OR"
			EndIf
		Next
		cQuery := SubStr(cQuery, 1, Len(cQuery)-2)
		cQuery += ")"+STR_PULA
	EndIf              
	
	//Se tiver Filtro 2
	If !Empty(cGetPesq2) .And. !Empty(cGetPesq) .And. .F.
		//If 'WHERE' $ cQuery
			cQuery += "   AND "
		//Else
		//	cQuery += "   WHERE "
		//EndIf
		cQuery += " ( "
		For nAtual := 1 To Len(aStruAux)
			cCampoAtu := aStruAux[nAtual][1]
			If aStruAux[nAtual][2] == 'C' .And. '_' $ cCampoAtu
				cQuery += " UPPER("+cCampoAtu+") LIKE '%"+Upper(Alltrim(cGetPesq2))+"%' OR"
			EndIf
		Next
		cQuery := SubStr(cQuery, 1, Len(cQuery)-2)
		cQuery += ")"+STR_PULA
	EndIf

	//Se tiver Filtro 3
	If !Empty(cGetPesq2) .And. !Empty(cGetPesq) .And. !Empty(cGetPesq3) .And. .F.
		//If 'WHERE' $ cQuery
			cQuery += "   AND "
		//Else
		//	cQuery += "   WHERE "
		//EndIf
		cQuery += " ( "
		For nAtual := 1 To Len(aStruAux)
			cCampoAtu := aStruAux[nAtual][1]
			If aStruAux[nAtual][2] == 'C' .And. '_' $ cCampoAtu
				cQuery += " UPPER("+cCampoAtu+") LIKE '%"+Upper(Alltrim(cGetPesq3))+"%' OR"
			EndIf
		Next
		cQuery := SubStr(cQuery, 1, Len(cQuery)-2)
		cQuery += ")"+STR_PULA
	EndIf
			
	//Group By
	If !Empty(cAgrup)
		cQuery += cAgrup + STR_PULA
	EndIf	
	//Order By
	cQuery += " ORDER BY "	+ STR_PULA
	If !Empty(cOrder)
		cQuery += "   "+cOrder
	Else
		cQuery += "   "+cCampoRet
	EndIf
	TCQuery cQuery New Alias "QRY_DAD"
	
	//Percorrendo a estrutura, procurando campos de data
	For nAtual := 1 To Len(aHeadAux)
		//Se for data
		If aHeadAux[nAtual][8] == "D"
			TCSetField('QRY_DAD', aHeadAux[nAtual][2], 'D')
		//Se for data
		ElseIf aHeadAux[nAtual][8] == "N"
			TCSetField('QRY_DAD', aHeadAux[nAtual][2], 'N', aHeadAux[nAtual][4], aHeadAux[nAtual][5])
		EndIf
	Next
	
	//Enquanto tiver dados
	While ! QRY_DAD->(EoF())
	
		nCampAux := 1
		aAux     := {}
		//Percorrendo os campos e adicionando no acols e com o delet
		For nAtual := 1 To Len(aStruAux)
			cCampoAtu := aStruAux[nAtual][1]
			
			If aStruAux[nAtual][2] $ "N;D"
				aAdd(aAux,  &("QRY_DAD->"+cCampoAtu) )
			Else
				aAdd(aAux, cValToChar( &("QRY_DAD->"+cCampoAtu) ))
			EndIf

            IF cCampoAtu == 'LEGEND'
				aAux[Len(aAux)] := oVerDE
            ElseIF cCampoAtu == 'MARC'
                aAux[Len(aAux)] := _oUnCheck
            ENDIF

		Next
		aAdd(aAux, .F.)
	
		aAdd(aColsAux, aClone(aAux))
		QRY_DAD->(DbSkip())
	EndDo
	QRY_DAD->(DbCloseArea())
	
	//Se n„o tiver dados, adiciona linha em branco
	If Len(aColsAux) == 0
		aAux := {}
		
		//Percorrendo os campos e adicionando no acols e com o delet
		For nAtual := 1 To Len(aStruAux)
			aAdd(aAux, '')
		Next
		aAdd(aAux, .F.)
	
		aAdd(aColsAux, aClone(aAux))
	EndIf
	
	//Posiciona no topo e atualiza grid
	oMsNew:oBrowse:Refresh()
	oMsNew:SetArray(aColsAux)

	//Controla botoes de Uso
	fButton()

RestArea(_aAreaf)
Return
/*---------------------------------------------------------------------*
 | Desc:  FunÁ„o de confirmaÁ„o da rotina                              |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
*----------------------*
Static Function fConfirm(_lAuto)
*----------------------*
	Local aColsNov 		:= oMsNew:aCols
	Local _aHeader 		:= oMsNew:aHeader
	Local nLinAtu  		:= oMsNew:nAt
    Local _nLeg  		:= aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="LEGEND"}) 
	Local _cStatus 		:= aColsNov[nLinAtu][_nLeg]:CNAME
	Local _nMarc  		:= aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="MARC"}) 
	Local _cCkecked   	:= aColsNov[nLinAtu][_nMarc]:CNAME

    Default _lAuto := .F.

	//Desabilita o click
	IF __lSEPFim
		RETURN
	ENDIF

	IF 'VERDE' $ _cStatus 
		aColsNov[nLinAtu][1] 			:= IIF('UN' $ _cCkecked, _oCheck, _oUnCheck)
		_lEdit        					:= .T.
	Else   
		Return
	ENDIF

	//Atualiza browser
	oMsNew:oBrowse:Refresh()

	//Atualiza rodape
	//zCountCH()

	//Atualiza todos Obj
	GETDREFRESH()
Return


*---------------------------*
Static Function fClickH(nCol)
*---------------------------*
Local aColsNov 		:= oMsNew:aCols
Local _aHeader 		:= oMsNew:aHeader
Local nLinAtu  		:= oMsNew:nAt
Local _nCodRet		:= aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="MARC"}) 
Local _nLoop        := 0
Local nAtual		:= 0
Local _nE           := 0

//Desabilita o click
IF __lSEPFim
	RETURN
ENDIF

IF nCol == 1
	_lClickAll := !_lClickAll

	_oAuto := IIF(_lClickAll, _oCheck, _oUnCheck)
    For _nE:=1 To Len(aColsNov)
		_nLoop++
		IF AllTrim(aColsNov[_nE][_nCodRet]) == '-'
			Loop
		ENDIF
        _cCkecked := aColsNov[_nE][1]:CNAME
        _cStatus  := aColsNov[_nE][2]:CNAME

		oMsNew:nAt := _nE
		IF 'VERDE' $ _cStatus 
			fConfirm(.T.)
		ENDIF

		IF _nLoop == 1
			MsgRun('Selecionando TEF Conciliados',"Aguarde...",{||INKEY(1)})
		Endif
    Next _nE
ENDIF
oMsNew:nAt := nLinAtu

//Atualiza browser
oMsNew:oBrowse:Refresh()

//Atualiza rodape
//zCountCH()

//Atualiza todos Obj
GETDREFRESH()

Return

/*---------------------------------------------------------------------*
 | Desc:  FunÁ„o que limpa os dados da rotina                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 *----------------------*
Static Function fLimpar(_lTimer)
*----------------------*
Default _lTimer := .T.		
	//Atualiza grid
	fPopula()
	
	//Setando o foco na pesquisa
	//oGetPesq:SetFocus()

	IF _lTimer
		//MsgRun('Limpando consultas',"Aguarde...",{||INKEY(0.5)})
	Endif
	
	//Atualiza rodape
	zCountCH()
Return

/*---------------------------------------------------------------------*
 | Desc:  FunÁ„o de cancelamento da rotina                             |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 *----------------------*
Static Function fCancela
*----------------------*
	//Setando o retorno em branco e finalizando a tela
	lRetorn := .F.      
	__cRetorno := Space(nTamanRet)
	oDlgEspe:End()
Return

/*---------------------------------------------------------------------*
 | Desc:  FunÁ„o que valida o campo digitado                           |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
*----------------------------*
Static Function fVldPesq(_nOpA) 
*----------------------------*
	Local lRet := .T.
	
	//Se tiver apÛstrofo ou porcentagem, a pesquisa n„o pode prosseguir
	If "'" $ cGetPesq .Or. "%" $ cGetPesq .Or. "'" $ cGetPesq2 .Or. "%" $ cGetPesq2 .Or. "'" $ cGetPesq3 .Or. "%" $ cGetPesq3
		lRet := .F.
		MsgAlert("<b>Pesquisa inv·lida!</b><br>A pesquisa n„o pode ter <b>'</b> ou <b>%</b>.", "AtenÁ„o")
	EndIf
	
	//Se houver retorno, atualiza grid
	If lRet
		fPopula()
		Sleep(1000)
	EndIf
Return lRet

                                 
/*---------------------------------------------------------------------*
 | Desc: FUNCAO PARA |1-LEITURA;2-GRAVACAO|-DO FLAG DE "GRAVA PESQUISA"|
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
*---------------------------------*
Static Function xLoadPesq(_nOpLoad)
*---------------------------------*
Local _aLoad     := {}
Local _aCompleto := {}
Local _nPos      := 0
Local _cTemp     := ''
Local _lNewAdd   := .F.
Local _nT        := 0
Default _nOpLoad := 0

Private _cIniFile  := GetADV97() 
Private _cDirLoad  := GetPvProfString(GetEnvServer(),"StartPath","ERROR", _cIniFile ) 
Private _cDirArq   := 'MCF3_SB1\' 
Private _cNomArq   := 'MCF3_SB1_'+__cUserID+'.gen'
                           
cGetArq := _cDirLoad + _cDirArq + _cNomArq

IF _nOpLoad == 1 //LEITURA DO ARQUIVO - LOG DE PESQUISA
	IF !File(LOWER(cGetArq))
		Return
	ENDIF
	
	_aCompleto := xLoadArq(cGetArq)
	
	IF ( _nPos := aScan(_aCompleto,{|a| a[1] == __cUserID}) ) > 0 
		_aLoad := _aCompleto[_nPos]
	ENDIF
	
	IF Len(_aLoad) == 5
		cGetPesq  := Upper(PadR(_aLoad[3],100))
		cGetPesq2 := Upper(PadR(_aLoad[4],100))
		cGetPesq3 := Upper(PadR(_aLoad[5],100))
		_lCkGrv   := .T.
	ENDIF	
ELSEIF _nOpLoad == 2 //GRAVACAO DO ARQUIVO - LOG DE PESQUISA	

	_aCompleto := xLoadArq(cGetArq)
	              
	IF Len(_aCompleto) > 0 
		For _nT:=1 To Len(_aCompleto)
			IF _aCompleto[_nT][1] <> __cUserID
				_cTemp += _aCompleto[_nT][1] +'|'+ _aCompleto[_nT][2] +'|'+ AllTrim(Upper(_aCompleto[_nT][3])) +'|'+AllTrim(Upper(_aCompleto[_nT][4])) +'|'+AllTrim(Upper(_aCompleto[_nT][5])) +ENTER
			ENDIF
		Next _nT
		 
		IF _lCkGrv
			_cTemp += __cUserID +'|'+ CVALTOCHAR(_lCkGrv) +'|'+ AllTrim(Upper(cGetPesq)) +'|'+AllTrim(Upper(cGetPesq2)) +'|'+AllTrim(Upper(cGetPesq3)) +ENTER
		ENDIF
	ELSE 
		_cTemp += __cUserID +'|'+ CVALTOCHAR(_lCkGrv) +'|'+ AllTrim(Upper(cGetPesq)) +'|'+AllTrim(Upper(cGetPesq2)) +'|'+AllTrim(Upper(cGetPesq3)) +ENTER	
	ENDIF  
	
	IF !_lCkGrv   	
		fErase(cGetArq)		
	ELSE	
		MemoWrite(cGetArq,_cTemp)
	ENDIF
ENDIF

Return

*-------------------------------*
Static Function xLoadArq(cGetArq)
*-------------------------------*
Local _aArqFull := {}         

//Abrindo o arquivo
Ft_FUse(cGetArq)
nTotalReg := Ft_FLastRec()

IF nTotalReg == 0
	Return(_aArqFull)
ENDIF

//Percorrendo os registros
While !Ft_FEoF()
	_cLinAtu := Ft_FReadLn()
	aADD(_aArqFull,Separa(_cLinAtu, '|'))		
 	Ft_FSkip()		
EndDo

Ft_FUse()
Return(_aArqFull)


*----------------------*
Static Function gLoadCPO
*----------------------*
Local _lExistCpo := .T.

DbSelectArea('ZZZ')

//IF ZZZ->(FieldPos("ZZZ_XETIQU")) == 0 .Or. CBA->(FieldPos("CBA_XATIVO")) == 0 .Or. ZZZ->(FieldPos("ZZZ_XDTVLD")) == 0
//	_lExistCpo := .F.
//	MsgInfo('Campo nao localizados no dicionado de dados:'+ENTER+;
//			'ZZZ_XETIQU - Etique Inventario'+ENTER+;
//			'CBA_XATIVO - Ativa Inv.Home Doctor'+ENTER+;
//			'ZZZ_XDTVLD - Validade Lote'+ENTER,'Controle de Campos')
//ENDIF

Return(_lExistCpo)

*----------------------*
Static Function zCountCH
*----------------------*
Local aColsNov  := oMsNew:aCols
Local _aHeader  := oMsNew:aHeader
Local _nR       := 0
Local _nP_Quant := aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="ZZZ_QUANT"}) 
Local _nLeg  	:= aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="LEGEND"}) 
Local _cStatus 	:= ''

_nQTD_TRI := 0

For _nR:=1 To Len(aColsNov)
	IF valtype(aColsNov[_nR][_nLeg]) <> 'O'
		Exit
	Endif

	_cStatus  := aColsNov[_nR][_nLeg]:CNAME
	_nQTD_TRI += aColsNov[_nR][_nP_Quant]
Next _nR

_cQtde := IIF(!_lPainel,AllTrim(TransForm(_nQTD_TRI,"@e 9,999,999")), TransForm(_nQTD_TRI,"@e 9,999,999")) 
_oSayQTD:SetText('Qtde: '+_cQtde)
_oSayQTD:CtrlRefresh()
_oSayQTD:NCLRTEXT := CLR_GREEN

IF !EMPTY(cGetPesq)

	//Preenche dados do documento fiscal em tela
	_cNumPEd := SC5->C5_NOTA+' - '+SC5->C5_SERIE
	_oSayCHX:SetText(_cNumPEd)
	_oSayCHX:CtrlRefresh()
	IF !EMPTY(StrTran(AllTrim(_cNumPEd),'-',''))
		_oSayNFC:CRESNAME := 'BR_VERDE'
		_oSayNFC:Refresh()
	ENDIF

	//Preenche dados da Chave da NF em Tela
	DbSelectArea("SF2");SF2->(DbSetOrder(1));SF2->(DbGoTop())
	IF SF2->(DbSeek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE)) 
		_oSayTEX:SetText(AllTrim(SF2->F2_CHVNFE))
		_oSayTEX:CtrlRefresh()
		IF !Empty(SF2->F2_CHVNFE)
			_oSayTSSC:CRESNAME := 'BR_VERDE'
			_oSayTSSC:Refresh()
		ENDIF
	ENDIF	
ENDIF

Return
*-----------------------------------------*
Static Function zControl(_lEdita,_cCodTria)
*-----------------------------------------*
Local _cQry := " SELECT DISTINCT RIGHT(E1_XCH_STS,1) STATUS FROM "+RetSqlName('SE1')+" SE1 (NOLOCK) WHERE SE1.D_E_L_E_T_ = '' AND E1_FILIAL = '"+xFilial('SE1')+"' AND E1_XCH_TRI = '"+_cCodTria+"' AND E1_XCH_STS <> '' "

If Select("_CTR") > 0
	_CTR->(DbCloseArea())
EndIf
_cQry := ChangeQuery(_cQry)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_CTR",.F.,.T.) 				
DbSelectArea("_CTR");_CTR->(dbGoTop())                                         

IF _CTR->STATUS == 'L' //Triagem ja finalizada
	_lEdita := .F.     //Nao pode ser editada
ELSEIF Empty(_CTR->STATUS) .And. !Empty(_cCodTria)
	MsgInfo('Triagem '+_cCodTria+' invalida!','Controle de Triagem')
	Return(.F.)
ENDIF

Return(.T.)

*-------------------------------*
Static Function xBTNMenuA(_gMnuA)
*-------------------------------*
Local _lAtuTel := .F.

Private _oWizard

Default _gMnuA := 0

IF _gMnuA == 1
    _lAtuTel   := .T.
	_lGetPesq  := .F.
	oGetPesq:lActive := .F.

	_lGetCodB := .T.
	_oGetCodB:lActive := .T.
	_oGetCodB:SetFocus()

ElseIF _gMnuA == 2

	_lFimF2  := .F.
	_oWizard := MsNewProcess():New({|lEnd| zFimF2(@_lFimF2) },"Processando","Finalizando SeparaÁ„o...",.T.)
	_oWizard:Activate()	

	IF _lFimF2
		zClearTela()
	ENDIF

ElseIF _gMnuA == 3
	_oWizard := MsNewProcess():New({|lEnd| KS_BXCHEQ() },"Processando","Excluindo...",.T.)
	_oWizard:Activate()	
	_lAtuTel := .T.

ElseIF _gMnuA == 4
    _oWizard := MsNewProcess():New({|lEnd| zMultBip() },"Processando","Multipla SeparaÁ„o...",.T.)
	_oWizard:Activate()	
	_lAtuTel := .F.

ElseIF _gMnuA == 5
	_oWizard := MsNewProcess():New({|lEnd| KS_CSVCODBAR() },"Processando","Extraindo relatÛrio...",.T.)
	_oWizard:Activate()	
	_lAtuTel := .T.

ElseIF _gMnuA == 6
	zClearTela()
	_lAtuTel := .F.
	Return

ElseIF _gMnuA == 7
	zLoadPar()
	_lAtuTel := .F.
	Return
ENDIF

//Atualiza dados da Tela
IF _lAtuTel
	FwMsgRun(,{|| fLimpar() }, "Aguarde Processamento...","Filtrando contagens")
	
	//Atualiza browser
	oMsNew:oBrowse:Refresh()

	//Atualiza todos Obj
	GETDREFRESH()					
Endif

_cGetCodB  := Space(HDCODBAR)
_oGetCodB:Refresh()
_oGetCodB:SetFocus()

Return

*-----------------------*
Static Function KS_BXCHEQ
*-----------------------*
Local aColsNov     	:= oMsNew:aCols
Local _aHeader     	:= oMsNew:aHeader
Local _nR          	:= 0
Local _aRets        := {0,0}
Local _nRecZZZ     	:= aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="ZZZREC"})
Local _cPopUp       := ''

IF Len(aColsNov) == 0
	RETURN
ENDIF
IF ValType(aColsNov[1,1]) <> 'O'
	RETURN
ENDIF

_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">AtenÁ„o</font> '
_cPopUp += ' <br> '
_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
_cPopUp += ' <br><br>'
_cPopUp += ' <font color="#000000" face="Arial" size="3">Exclus„o de leiutra</font> '
_cPopUp += ' <br><br> '        

_oWizard:SetRegua1(Len(aColsNov))
_oWizard:SetRegua2(2)

For _nR:=1 To Len(aColsNov)
	_cCkecked 	:= aColsNov[_nR][1]:CNAME
	IF 'CHECKED' == _cCkecked
		_aRets[1] ++
	ENDIF
NExt _nR

IF _aRets[1] > 0
	_cPopUp += ' <font color="#000000" face="Arial" size="2">Deseja excluir o(s) '+Alltrim(Transform(_aRets[1],'@E 9,999,999'))+' iten(s) selecionado(s)?</font> '
Else 
	_cPopUp += ' <font color="#000000" face="Arial" size="2">Deseja <b>REINICIAR</b> o processo de separaÁ„o?</font> '
ENDIF

IF !FWAlertNoYes(_cPopUp,'NotificaÁ„o de Mercadoria') 
	RETURN
ENDIF
			        
For _nR:=1 To Len(aColsNov)

	/**********{ INCREMENTA REGUA }**********/
	_cMsg := AllTrim(Str(Int((_nR/Len(aColsNov))*100)))+" %"
	_oWizard:IncRegua1(_cMsg)

	_nRecnoZZ  	:= aColsNov[_nR][_nRecZZZ]
	_cCkecked 	:= aColsNov[_nR][1]:CNAME

	IF _aRets[1] > 0
		IF 'CHECKED' <> _cCkecked
			Loop
		ENDIF
	ENDIF
	
	//Posiciona nas tabelas relacioandas
	DbSelectArea('ZZZ'); ZZZ->(DbGoTop()); ZZZ->(DbGoTo(_nRecnoZZ))
	IF _nRecnoZZ == ZZZ->(Recno())
		IF 	Reclock("ZZZ", .F.)
				ZZZ->(dbDelete())
			ZZZ->(MsUnLock())
		ENDIF
	Endif
Next _nR

Return

*-------------------------*
Static Function zClearTela
*-------------------------*
	cGetPesq   := Space(6)
	_lGetPesq  := .T.
	oGetPesq:lActive  := .T.

	_lGetCodB := .F.
	_oGetCodB:lActive := .F.

	_oBtnFi2:lActive := .F.
	_oBtnFi3:lActive := .F.	

	//Carrega matriz em branco
    cConsSQL := zConsSQL
	
	//Cliente
    _oSayClDDs:SetText('')
    _oSayClDDs:CtrlRefresh()

	//Transportadora
    _oSayTrDDs:SetText('')
    _oSayTrDDs:CtrlRefresh()        

	//Nota Fiscal
    _oSayCHX:SetText('')
    _oSayCHX:CtrlRefresh()  
	//Legenda Nota Fiscal
	_oSayNFC:CRESNAME := 'BR_VERMELHO'
	_oSayNFC:Refresh()

	//Chave Sefaz
    _oSayTEX:SetText('')
    _oSayTEX:CtrlRefresh()  
	//Legenda Chave Sefaz
	_oSayTSSC:CRESNAME := 'BR_VERMELHO'
	_oSayTSSC:Refresh()

    //FunÁ„o que limpa os dados da rotina 
	FwMsgRun(,{|| fLimpar() }, "Aguarde Processamento...","Filtrando contagens")
	
	//Atualiza browser
	oMsNew:oBrowse:Refresh()

	//Atualiza todos Obj
	_cGetCodB  := Space(HDCODBAR)
	_oGetCodB:Refresh()

	oGetPesq:SetFocus()
RETURN

*----------------------*
Static Function zMultBip
*----------------------*
Local _aParamBox := {}
Local _aRet      := {}
Local bOk        := {|| .T. } 
Local _nQuant    := 0
Local _cPopUp    := ''

_cGetCodB  := Space(HDCODBAR)

aAdd(_aParamBox,{9,"Checkout - SeparaÁ„o de Mercadoria"        ,150,7,.T.})
aAdd(_aParamBox,{1,"CÛdigo de Barra",    _cGetCodB ,"@!",'.T.',''  ,'.T.',120,.T.})
aAdd(_aParamBox,{1,"Quantidade",        _nQuant,  "@E 9,999,999",     "Positivo()", "", ".T.", 80,  .T.})

If ParamBox(_aParamBox,"Multipla SeparaÁ„o",@_aRet,bOk,,,,,,,.F.,.F.)
    IF MV_PAR03 < _nMultiplo
        _cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">AtenÁ„o</font> '
        _cPopUp += ' <br> '
        _cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
        _cPopUp += ' <br><br>'
        _cPopUp += ' <font color="#000000" face="Arial" size="3">Multiplo nao habilitado</font> '
        _cPopUp += ' <br><br> '
        _cPopUp += ' <font color="#000000" face="Arial" size="2">Nesta quantidade leia todos os volumes</font> '			
        FWAlertWarning(_cPopUp,'NotificaÁ„o de Mercadoria') 
    ELSE
        _cGetCodB    := MV_PAR02
        u_fVlCodBar(MV_PAR03)
    ENDIF
ENDIF

RETURN

*--------------------------------*
User Function fVlCodBar(_nQtdAuto)
*--------------------------------*
Local _aAreaB1      := FwGetArea()
Local _nIOldSB1     := SB1->(IndexOrd())
Local _nIdx         := 0                             
Local _nIndexSB1    := 5 //CODIGO DE BARRAS
Local _cCodSB1      := Space(TamSX3('B1_COD')[1])
Local _cPopUp       := ''
Local _nInd_CodTer  := u_zRetOrder('SB1','B1_FILIAL+B1_XCODTER')

Default _nQtdAuto   := 1

Private _lProdOk    := .F.
Private _lVazio     := Empty(AllTrim(_cGetCodB))

IF Empty(AllTrim(_cGetCodB))
	RETURN(.T.)
ENDIF

IF _nInd_CodTer == 0
	_nInd_CodTer := 1
ENDIF

For _nIdx:=1 To 2 
	DbSelectArea('SB1')
	SB1->(DbSetOrder(_nIndexSB1))
	SB1->(DbGoTop())
	IF SB1->(DbSeek(xFilial('SB1')+_cGetCodB))	
        _cCodSB1 := SB1->B1_COD
		Exit
	ENDIF
	_nIndexSB1 := iIF(_nIndexSB1==5,_nInd_CodTer,5)
Next _nIdx                                                    
                  	
DbSelectArea('SB1');SB1->(DbSetOrder(1));SB1->(DbGoTop()) 
If !SB1->(DbSeek(xFilial('SB1')+_cCodSB1))
	_cPopUp += ' <font color="#A4A4A4" face="Arial" size="7">AtenÁ„o</font> '
	_cPopUp += ' <br> '
	_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
	_cPopUp += ' <br><br>'
	_cPopUp += ' <font color="#000000" face="Arial" size="3">CÛdigo de barras ['+_cGetCodB+'] n„o localizado ! </font> '
	_cPopUp += ' <br>'
	_cPopUp += ' <font color="#000000" face="Arial" size="2">Por gentileza, selecione outra mercadoria. </font> '	 
    FWAlertWarning(_cPopUp,'NotificaÁ„o de Mercadoria')                       
	xAtuTela(.F.)   
   Return(_lProdOk)
EndIf      

//Grava leitura - Tabela ZZZ
xGrav(_nQtdAuto)

//Atualiaza dados da tela (refresh de processo)                    
xAtuTela()

FwRestArea(_aAreaB1)
Return(_lProdOk)

*-------------------------------*
Static Function xAtuTela(_lRefre)
*-------------------------------*
Default _lRefre := .T.

IF _lRefre
    //FunÁ„o que limpa os dados da rotina 
    FwMsgRun(,{|| fLimpar(.F.) }, "Aguarde Processamento...","Registrando leitura")

    //Atualiza browser
    oMsNew:oBrowse:Refresh()

    //Atualiza todos Obj
    GETDREFRESH()	
ENDIF

_cGetCodB  := Space(HDCODBAR)
_oGetCodB:Refresh()
_oGetCodB:SetFocus()

RETURN

*---------------------------*
Static Function xGrav(_nSoma)
*---------------------------*
Default _nSoma := 1

IF SB1->B1_QE == 0 .And. AllTrim(SB1->B1_UM) $ 'KG/L/ML'
	MsgInfo(AllTrim(SB1->B1_COD)+' - '+AllTrim(SB1->B1_DESC)+ENTER+'Un.: '+SB1->B1_UM+' Qtd.Emp.: '+cValToChar(SB1->B1_QE)+ENTER+ENTER+'Revise o Cadastro!','Cadastro de Produto')
	Return
EndIF

DbSelectArea('ZZZ')
IF 	ZZZ->(RecLock('ZZZ',.T.))
		Replace ZZZ->ZZZ_FILIAL With FwxFilial('ZZZ')
		Replace ZZZ->ZZZ_PEDIDO With SC5->C5_NUM
		Replace ZZZ->ZZZ_PRODUT With SB1->B1_COD
		Replace ZZZ->ZZZ_DESCRI With SB1->B1_DESC
		Replace ZZZ->ZZZ_UM 	With SB1->B1_UM
		Replace ZZZ->ZZZ_QUANT 	With _nSoma
		Replace ZZZ->ZZZ_CODBAR With SB1->B1_CODBAR
		Replace ZZZ->ZZZ_USERID With __cUserID
		Replace ZZZ->ZZZ_DTLOG 	With DtoC(dDataBase)+'-'+Time()
	ZZZ->(MsUnLock())
ENDIF

Return

*----------------------------------*
User Function zRetOrder(cTab,cChave)
*----------------------------------*
	Local nRet 	:= 1
	Local aArea := GetArea()
	
	DbSelectArea("SIX")
	SIX->(DbSetOrder(1))
	If SIX->(DbSeek(cTab))
		While SIX->(!EoF()) .AND. SIX->INDICE == cTab
			If Alltrim(SIX->CHAVE) == cChave
				If SIX->ORDEM <= "9"
			   		nRet := Val(SIX->ORDEM)
				Else
					nRet := ASC(SIX->ORDEM)-55
				EndIf
				Exit
			EndIf
			SIX->(DbSkip())
		EndDo
	EndIf
	IF nRet == 0
		nRet := 1
	ENDIF
	RestArea(aArea)
Return (nRet)


*--------------------------*
Static Function KS_CSVCODBAR
*--------------------------*
u_MCFATR81(SC5->C5_NUM)
Return

*-----------------------------*
Static Function zFimF2(_lFimF2)
*-----------------------------*
Local _nProcs := 6
_oWizard:SetRegua1(_nProcs)
_oWizard:SetRegua2(2)

IF zLibFat()
	IF zFinaliza()
		_oWizard:IncRegua1('02 - ConfirmaÁ„o de Volume')
		IF u_PM410VOL()
			IF zFatura()
				IF zEtiqPV()
					IF zSefaz()
						IF zEtiqNF()
							zStatusC5()
							_lFimF2 := .T.
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF
RETURN(_lFimF2)

*-----------------------*
Static Function zStatusC5
*-----------------------*
//Ajusta Status para Manifesto							
DbSelectArea('SC5');SC5->(DbSetOrder(1))
IF SC5->(DBSeek(xFilial("SC5")+SD2->D2_PEDIDO))							
	IF SC5->C5_X_STAPV < '6'
		IF 	RecLock('SC5',.F.)
				Replace SC5->C5_X_STAPV With '6'
				//0=P Gerado;1=Liberado;2=Em Separacao;3=Sep Finaliz;4=Em Confer;5=Conf Finaliz;6=Faturado;7=Manif Imp;A=Antecip.;C=Cancel;D=Devol
			SC5->(MsUnLock())
		ENDIF
	ENDIF
ENDIF
RETURN

*-----------------------*
Static Function zLibFat
*-----------------------*
Local _lLibFat  := zLoadSC9(.T.)[1]

_oWizard:IncRegua1('00 - Validando liberaÁ„o para Faturamento')

RETURN(_lLibFat)

*------------------------------------------*
Static Function zLoadSC9(_lAvisa,_lPergunta)
*------------------------------------------*
Default _lAvisa    := .F.
Default _lPergunta := .F.

Local _cQryC9 := ''
Local _aRetC9 := {.T.,'',''}

_cQryC9 += " SELECT DISTINCT  "+ENTER
_cQryC9 += " 		CASE  "+ENTER
_cQryC9 += " 			WHEN C9_BLCRED = '01' THEN '01-Bloqueio de CrÈdito por Valor' "+ENTER
_cQryC9 += " 			WHEN C9_BLCRED = '04' THEN '04-Vencimento do Limite de CrÈdito' "+ENTER
_cQryC9 += " 			WHEN C9_BLCRED = '05' THEN '05-Bloqueio Manual/Estorno' "+ENTER
_cQryC9 += " 			WHEN C9_BLCRED = '09' THEN '09-LiberaÁ„o de CrÈdito Rejeitada' "+ENTER
_cQryC9 += " 			WHEN C9_BLCRED = '10' THEN '10-Faturado' "+ENTER
_cQryC9 += " 			ELSE 'OK' "+ENTER
_cQryC9 += " 		END CREDITO, "+ENTER
_cQryC9 += " 		CASE  "+ENTER
_cQryC9 += " 			WHEN C9_BLEST = '02' THEN '02-Bloqueio de Estoque  ' "+ENTER
_cQryC9 += " 			WHEN C9_BLEST = '03' THEN '03-Bloqueio Manual de Estoque' "+ENTER
_cQryC9 += " 			WHEN C9_BLEST = '10' THEN '10-Faturado' "+ENTER
_cQryC9 += " 			ELSE 'OK' "+ENTER
_cQryC9 += " 		END ESTOQUE "+ENTER
_cQryC9 += " From "+RetSqlName('SC9')+" SC9 (NOLOCK) WHERE D_E_L_E_T_='' AND C9_FILIAL='"+xFilial('SC9')+"' AND C9_PEDIDO = '"+SC5->C5_NUM+"' "+ENTER

//ValidaÁ„o de retorno de registros
IF Select('_LIB') > 0
	_LIB->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryC9),'_LIB',.F.,.T.)
DbSelectArea('_LIB');_LIB->(DbGoTop())
_nMax := Contar('_LIB',"!Eof()"); _LIB->(DbGoTop())
IF _nMax > 0
	IF !(LEFT(_LIB->CREDITO,2) $ 'OK|10') .Or. !(LEFT(_LIB->ESTOQUE,2) $ 'OK|10') 
		_aRetC9[1] := .F.
		_aRetC9[2] := _LIB->CREDITO
		_aRetC9[3] := _LIB->ESTOQUE

		IF _lAvisa
			_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">AtenÁ„o</font> '
			_cPopUp += ' <br> '
			_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
			_cPopUp += ' <br><br>'
			_cPopUp += ' <font color="#000000" face="Arial" size="3">Pedido com bloqueio!!</font> '
			_cPopUp += ' <br><br> '
			_cPopUp += ' <font color="#000000" face="Arial" size="2">Credito: '+_aRetC9[2]+'</font> '			
			_cPopUp += ' <br>'
			_cPopUp += ' <font color="#000000" face="Arial" size="2">Estoque: '+_aRetC9[3]+'</font> '

			IF _lPergunta
				_aRetC9[1] := FWAlertNoYes(_cPopUp,'NotificaÁ„o de Mercadoria')
			ELSE			
				FWAlertWarning(_cPopUp,'NotificaÁ„o de Mercadoria') 
			ENDIF
		ENDIF
	ENDIF
Endif

RETURN(_aRetC9)

*-----------------------*
Static Function zFinaliza
*-----------------------*
Local _lLiberOK := u_MCFATR81(SC5->C5_NUM,.T.)
Local _cPopUp   := ''

_oWizard:IncRegua1('01 - Processanado divergencias')

IF !_lLiberOK
	IF !Empty(SC5->C5_NOTA)
		_lLiberOK = .T.
	ELSE
		_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">AtenÁ„o</font> '
		_cPopUp += ' <br> '
		_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
		_cPopUp += ' <br><br>'
		_cPopUp += ' <font color="#000000" face="Arial" size="3">DivergÍncia de SeparaÁ„o</font> '
		_cPopUp += ' <br><br> '
		_cPopUp += ' <font color="#000000" face="Arial" size="2">Revise o processo ou adicone o supervisor</font> '			
		FWAlertWarning(_cPopUp,'NotificaÁ„o de Mercadoria') 
	ENDIF
ENDIF

RETURN(_lLiberOK)

*---------------------*
Static Function zFatura
*---------------------*
Local _lFatura := .F.
_oWizard:IncRegua1('03 - Faturando pedido de Venda')

IF Empty(SC5->C5_NOTA)
	_lFatura := u_zGeraNota()
Else
	_lFatura := .T.
ENDIF

//Atualiza Status Tracker do Ecommerce [6=NFe Emitida]
u_zSttsEcom(_lFatura,SC5->C5_NUM,'6',)
RETURN(_lFatura)

*---------------------*
Static Function zEtiqPV
*---------------------*
Local _lEtiqPV := .F.

_oWizard:IncRegua1('04 - Imprimindo Etiqueta de Embalagem')

IF !Empty(SC5->C5_NOTA)
	IF ExistBlock("zImpPvEtq")
		ExecBlock("zImpPvEtq",.F.,.F.,{})
		_lEtiqPV := .T.
	ENDIF
ENDIF

RETURN(_lEtiqPV)

*---------------------*
Static Function zSefaz
*---------------------*
Local _lSefaz := .F.

DbSelectArea("SF2");SF2->(DbSetOrder(1));SF2->(DbGoTop())
IF SF2->(DbSeek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE)) 
	_oWizard:IncRegua1('05 - Transmiss„o Sefaz '+SF2->F2_DOC+' - '+SF2->F2_SERIE)

	_aAutoSefaz := u_zAutoSefaz(SF2->F2_DOC,SF2->F2_SERIE,@_oWizard)
	IF _aAutoSefaz[1]
		_lSefaz := .T.
	ENDIF	
ENDIF

RETURN(_lSefaz)

*---------------------*
Static Function zEtiqNF
*---------------------*
Local _lEtiqNF  := .F.
Local lUsaColab := .F.
Local cIdEnt    := RetIdEnti()
Local cUrl      := Padr( GetNewPar("MV_SPEDURL",""), 250 )

_oWizard:IncRegua1('06 - Imprimindo Etiqueta Fiscal')

IF !Empty(SF2->F2_CHVNFE)
	IF ExistBlock("zImpDfEtq")
		_lEtiqNF := .T.

		ExecBlock("zImpDfEtq",.f.,.f.,{cUrl, cIdEnt, lUsaColab})
		//TSSExecRdm("zImpDfEtq", .T., {cUrl, cIdEnt, lUsaColab} )
	ENDIF
ENDIF

//Atualiza Status Tracker do Ecommerce [7=NFe Transmitida]
u_zSttsEcom(_lEtiqNF,SD2->D2_PEDIDO,'7',)

RETURN(_lEtiqNF)


//Atualiza Status Tracker do Ecommerce
*---------------------------------------------------------*
User Function zSttsEcom(_lProcOK,_cPedVnd,_cProximo,_cInfo)
*---------------------------------------------------------*
Local _lPZU 	 := .T. 
Local _aAreaPZU  := FwGetArea()
Local _nIOldPZU  := SB1->(IndexOrd())
Local cModalidade:= ""
Local cIdEnt	 :='000018'
Local aNotas	 :={}
Local aXml		 :={}

Default _lProcOK   := .F.
Default _cPedVnd  := ''
Default _cProximo := ''
Default _cInfo    := ''

IF !_lProcOK
	RETURN
ENDIF

DbSelectArea("PZU");PZU->(DbSetOrder(3))
IF PZU->(DBSEEK(xFilial('PZU')+_cPedVnd)) 

	//Validacao do Romaneio de SeparaÁ„o
	//IF _cProximo == '4'
		_lPZU := PZU->PZU_STATUS < _cProximo 
	//ENDIF

	IF _lPZU
		IF 	RECLOCK("PZU",.F.)
				Replace PZU->PZU_STATUS With _cProximo
			PZU->(MSUNLOCK())
		ENDIF
	ENDIF

	IF 	RecLock( "PZX", .T. ) .AND. _lPZU
		Replace PZX->PZX_FILIAL With xFilial("PZX")
		Replace PZX->PZX_PEDECO With PZU->PZU_PEDECO 
		Replace PZX->PZX_DATA   With dDatabase 
		Replace PZX->PZX_HORA   With Time() 
		Replace PZX->PZX_STATUS With _cProximo
		Replace PZX->PZX_ORIGEM With "1"  // e-commerce

		//Dados Nota Fiscal
		IF PZU->PZU_STATUS >='6' .AND. _lPZU
			Replace PZX->PZX_NUMDOC	With SF2->F2_DOC
			Replace PZX->PZX_SERIE	With SF2->F2_SERIE
			Replace PZX->PZX_TRANSP	With SF2->F2_TRANSP	
		ENDIF

		Replace PZX->PZX_OBSERV	With AllTrim(UsrFullName(__cUserID)) + IIF(!Empty(_cInfo),' - ','') + AllTrim(_cInfo)
		PZX->( MsUnlock() )
	ENDIF

	IF PZU->PZU_STATUS =='6' .AND. _lPZU                      		

		aadd(aNotas,{})
		aadd(Atail(aNotas),.F.)
		aadd(Atail(aNotas),"S")
		aadd(Atail(aNotas),SF2->F2_EMISSAO)
		aadd(Atail(aNotas),SF2->F2_SERIE)
		aadd(Atail(aNotas),SF2->F2_DOC)
		aadd(Atail(aNotas),SF2->F2_CLIENTE)
		aadd(Atail(aNotas),SF2->F2_LOJA)
		
		aXml := GetXML(cIdEnt,aNotas,@cModalidade)
		
		RECLOCK("PZU",.F.)
			Replace PZU->PZU_DOC	With SF2->F2_DOC
			Replace PZU->PZU_SERIE	With SF2->F2_SERIE
			Replace PZU->PZU_CHVNFE	With SF2->F2_CHVNFE
			Replace PZU->PZU_SERIE	With SF2->F2_SERIE
			Replace PZU->PZU_NFEMIS	With SF2->F2_EMISSAO
			Replace PZU->PZU_XML 	With aXml[1][2]
		PZU->(MSUNLOCK())
	endif

ENDIF	

FwRestArea(_aAreaPZU)
/*
{ 'PZU->PZU_STATUS == "0"', "BR_CINZA"		},; 	// "Aguardando pagamento"
{ 'PZU->PZU_STATUS == "1"', "BR_BRANCO"		},; 	// "Aguardando pagamento/Pedido Emitido"
{ 'PZU->PZU_STATUS == "2"', "BR_AZUL_CLARO"	},; 	// "Aprovado"
{ 'PZU->PZU_STATUS == "3"', "BR_VERMELHO"	},; 	// "EMITIDO"
{ 'PZU->PZU_STATUS == "4"', "BR_AZUL"		},; 	// "In Picking"
{ 'PZU->PZU_STATUS == "5"', "BR_AMARELO"	},; 	// "Aguardando NFE"
{ 'PZU->PZU_STATUS == "6"', "BR_LARANJA"	},; 	// "NFe Emitida"
{ 'PZU->PZU_STATUS == "7"', "BR_VERDE"		},; 	// "NFe impressa"
{ 'PZU->PZU_STATUS == "8"', "BR_PINK"		},; 	// "Aguardando coleta"
{ 'PZU->PZU_STATUS == "9"', "BR_VIOLETA"	},; 	// "Na Transportadora"
{ 'PZU->PZU_STATUS == "A"', "BR_BRANCO"		},; 	// "Em Rota"
{ 'PZU->PZU_STATUS == "B"', "BR_LARANJA"	},; 	// "Em Transferencia"
{ 'PZU->PZU_STATUS == "C"', "BR_PRETO"		},; 	// "Entregue"
{ 'PZU->PZU_STATUS == "D"', "BR_VERDE_ESCURO"},; 	// "Ausente"
{ 'PZU->PZU_STATUS == "E"', "BR_MARRON_OCEAN"},; 	// "Devolucao/Sinistro"
{ 'PZU->PZU_STATUS == "F"', "BR_CANCEL"		},; 	// "Cancelado"
{ 'PZU->PZU_STATUS == "G"', "BR_MARROM"		},; 	// "Esperando Mercadoria"
{ 'PZU->PZU_STATUS == "H"', "BR_PRETO_3"	} ; 	// "Congelado"
*/
RETURN


//*PEGA O XML DA NF//**
Static Function GetXML(cIdEnt,aIdNFe,cModalidade)  

Local aRetorno		:= {}
Local aDados		:= {}
Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local cModel		:= "55"
Local nZ			:= 0
Local nCount		:= 0
Local oWS

If Empty(cModalidade)    

	oWS := WsSpedCfgNFe():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt
	oWS:nModalidade:= 0
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	oWS:cModelo    := cModel 
	If oWS:CFGModalidade()
		cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
	Else
		cModalidade    := ""
	EndIf  
	
EndIf  
         
oWs := nil

For nZ := 1 To len(aIdNfe) 

    nCount++

	aDados := executeRetorna( aIdNfe[nZ], cIdEnt )
	
	if ( nCount == 10 )
		delClassIntF()
		nCount := 0
	endif
	
	aAdd(aRetorno,aDados)
	
Next nZ

Return(aRetorno)

static function executeRetorna( aNfe, cIdEnt, lUsacolab, lJob)

Local aRetorno		:= {}
Local aDados		:= {}
Local aIdNfe		:= {}
Local aWsErro		:= {}

Local cAviso		:= ""
Local cCodRetNFE	:= ""
Local cDHRecbto		:= ""
Local cDtHrRec		:= ""
Local cDtHrRec1		:= ""
Local cErro			:= ""
Local cModTrans		:= ""
Local cProtDPEC		:= ""
Local cProtocolo	:= ""
Local cMsgNFE		:= ""
local cMsgRet		:= ""
Local cRetDPEC		:= ""
Local cRetorno		:= ""
Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local cCodStat		:= ""
Local dDtRecib		:= CToD("")
Local nDtHrRec1		:= 0
Local nX			:= 0
Local nY			:= 0
Local nZ			:= 1
Local nPos			:= 0

Local oWS

Private oDHRecbto
Private oNFeRet
Private oDoc

default lUsacolab	:= .F.
default lJob		:= .F.

aAdd(aIdNfe,aNfe)

if !lUsacolab

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN        := "TOTVS"
	oWS:cID_ENT           := cIdEnt
	oWS:nDIASPARAEXCLUSAO := 0
	oWS:_URL 			  := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:oWSNFEID          := NFESBRA_NFES2():New()
	oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()

	aadd(aRetorno,{"","",aIdNfe[nZ][4]+aIdNfe[nZ][5],"","","",CToD(""),"","","",""})

	aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
	Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nZ][4]+aIdNfe[nZ][5]

	If oWS:RETORNANOTASNX()

		If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
			For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
				cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
				cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO
				cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT
				oNFeRet			:= XmlParser(cRetorno,"_",@cAviso,@cErro)
				cModTrans		:= IIf(ValAtrib("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT") <> "U",IIf (!Empty("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT"),oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT,1),1)
				cCodStat		:= ""
				If ValType(oWs:OWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:OWSDPEC)=="O"
					cRetDPEC        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CXML
					cProtDPEC       := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CPROTOCOLO
				EndIf
				
				//Tratamento para gravar a hora da transmissao da NFe
				If !Empty(cProtocolo)
					oDHRecbto		:= XmlParser(cDHRecbto,"","","")
					cDtHrRec		:= IIf(ValAtrib("oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT")<>"U",oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT,"")
					nDtHrRec1		:= RAT("T",cDtHrRec)
					cMsgRet 		:= IIf(ValAtrib("oDHRecbto:_ProtNFE:_INFPROT:_XMSG:TEXT")<>"U",oDHRecbto:_ProtNFE:_INFPROT:_XMSG:TEXT,"")
					cCodStat		:= IIf(ValAtrib("oDHRecbto:_ProtNFE:_INFPROT:_CSTAT:TEXT")<>"U",oDHRecbto:_ProtNFE:_INFPROT:_CSTAT:TEXT,"")
					If nDtHrRec1 <> 0
						cDtHrRec1   :=	SubStr(cDtHrRec,nDtHrRec1+1)
						dDtRecib	:=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
					EndIf

					AtuSF2Hora(cDtHrRec1,aIdNFe[nZ][5]+aIdNFe[nZ][4]+aIdNFe[nZ][6]+aIdNFe[nZ][7])

				EndIf

				nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[4]+x[5]))})

				oWS:cIdInicial    := aIdNfe[nZ][4]+aIdNfe[nZ][5]
				oWS:cIdFinal      := aIdNfe[nZ][4]+aIdNfe[nZ][5]
				If oWS:MONITORFAIXA()
					nPos    := 0
					aWsErro := {}
					If !Empty(cProtocolo) .AND. !Empty(cCodStat)
						aWsErro := oWS:OWSMONITORFAIXARESULT:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE
						For nPos := 1 To Len(aWsErro)
							If Alltrim(aWsErro[nPos]:CCODRETNFE) == Alltrim(cCodStat)
								Exit
							Endif
						Next
					Endif
					If nPos > 0 .And. nPos <= Len(aWsErro)
						cCodRetNFE := oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[nPos]:CCODRETNFE
						cMsgNFE	:= oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[nPos]:CMSGRETNFE
					Else
						cCodRetNFE := oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[len(oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE)]:CCODRETNFE
						cMsgNFE	:= oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[len(oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE)]:CMSGRETNFE
					EndIf
				endif

				If nY > 0
					aRetorno[nY][1] := cProtocolo
					aRetorno[nY][2] := cRetorno
					aRetorno[nY][4] := cRetDPEC
					aRetorno[nY][5] := cProtDPEC
					aRetorno[nY][6] := cDtHrRec1
					aRetorno[nY][7] := dDtRecib
					aRetorno[nY][8] := cModTrans
					aRetorno[nY][9] := cCodRetNFE
					aRetorno[nY][10]:= cMsgNFE
					aRetorno[nY][11]:= cMsgRet

				EndIf
				cRetDPEC := ""
				cProtDPEC:= ""
			Next nX
		EndIf
	Elseif !lJob
		Aviso("DANFE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	EndIf
else
	oDoc 			:= ColaboracaoDocumentos():new()
	oDoc:cModelo	:= "NFE"
	oDoc:cTipoMov	:= "1"
	oDoc:cIDERP	:= aIdNfe[nZ][4]+aIdNfe[nZ][5]+FwGrpCompany()+FwCodFil()

	aadd(aRetorno,{"","",aIdNfe[nZ][4]+aIdNfe[nZ][5],"","","",CToD(""),"","","",""})

	if odoc:consultar()
		aDados := ColDadosNf(1)

		if !Empty(oDoc:cXMLRet)
			cRetorno	:= oDoc:cXMLRet
		else
			cRetorno	:= oDoc:cXml
		endif

		aDadosXml := ColDadosXMl(cRetorno, aDados, @cErro, @cAviso)

		if '<obsCont xCampo="nRegDPEC">' $ cRetorno
			aDadosXml[9] := SubStr(cRetorno,At('<obsCont xCampo="nRegDPEC"><xTexto>',cRetorno)+35,15)
		endif

		cProtocolo		:= aDadosXml[3]
		cModTrans		:= IIF(Empty(aDadosXml[5]),aDadosXml[7],aDadosXml[5])
		cCodRetNFE 		:= aDadosXml[1]
		cMsgNFE 		:= iif (aDadosXml[2]<> nil ,aDadosXml[2],"")
		cMsgRet			:= aDadosXml[11]
		//Dados do DEPEC
		If !Empty( aDadosXml[9] )
			cRetDPEC        := cRetorno
			cProtDPEC       := aDadosXml[9]
		EndIf

		//Tratamento para gravar a hora da transmissao da NFe
		If !Empty(cProtocolo)
			cDtHrRec		:= aDadosXml[4]
			nDtHrRec1		:= RAT("T",cDtHrRec)

			If nDtHrRec1 <> 0
				cDtHrRec1   :=	SubStr(cDtHrRec,nDtHrRec1+1)
				dDtRecib	:=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
			EndIf

			AtuSF2Hora(cDtHrRec1,aIdNFe[nZ][5]+aIdNFe[nZ][4]+aIdNFe[nZ][6]+aIdNFe[nZ][7])

		EndIf

		aRetorno[1][1] := cProtocolo
		aRetorno[1][2] := cRetorno
		aRetorno[1][4] := cRetDPEC
		aRetorno[1][5] := cProtDPEC
		aRetorno[1][6] := cDtHrRec1
		aRetorno[1][7] := dDtRecib
		aRetorno[1][8] := cModTrans
		aRetorno[1][9] := cCodRetNFE
		aRetorno[1][10]:= cMsgNFE
		aRetorno[1][11]:= cMsgRet

		cRetDPEC := ""
		cProtDPEC:= ""

	endif
endif

oWS       := Nil
oDHRecbto := Nil
oNFeRet   := Nil

return aRetorno[len(aRetorno)]

static Function ValAtrib(atributo)
Return (type(atributo) )


static function atuSf2Hora( cDtHrRec,cSeek )

local aArea := GetArea()

dbSelectArea("SF2")
dbSetOrder(1)
If MsSeek(xFilial("SF2")+cSeek)
	If SF2->(FieldPos("F2_HORA"))<>0 .And. Empty(SF2->F2_HORA)
		RecLock("SF2")
		SF2->F2_HORA := cDtHrRec
		MsUnlock()
	EndIf
EndIf
dbSelectArea("SF1")
dbSetOrder(1)
If MsSeek(xFilial("SF1")+cSeek)
	If SF1->(FieldPos("F1_HORA"))<>0 .And. Empty(SF1->F1_HORA)
		RecLock("SF1")
		SF1->F1_HORA := cDtHrRec
		MsUnlock()
	EndIf
EndIf

RestArea(aArea)

return nil

*----------------------*
Static Function zLoadPar
*----------------------*
Local _aParamBox := {}
Local _aRet      := {}
Local bOk        := {|| .T. } 
Local _nModelo   := 1

Local _cPerg   := 'zImpPvEtq'

aAdd(_aParamBox,{9,"Etiquetas de checkout - Salonline"  ,150,7,.T.})
aAdd(_aParamBox,{2, "Modelo",_nModelo, {"1=Embalagem", "2=Danfe Simplificado"},120, ".T.", .F.})

If ParamBox(_aParamBox,"Parametros das etiquetas",@_aRet,bOk,,,,,,,.F.,.F.)
	IF cValToChar(MV_PAR02) == '1'
		Pergunte(_cPerg,.T.)
	Else
		Pergunte("NFDANFETIQ",.T.)
	ENDIF
ENDIF

Return
