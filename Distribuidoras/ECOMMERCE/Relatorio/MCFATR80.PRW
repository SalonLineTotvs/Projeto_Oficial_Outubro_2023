 /*

//Seleciona o dispositivo de impressao

oPrint:SetDevice(IMP_SPOOL) //2

//Impressora destino "forçada" pelo usuário. Default é ""
cPrinter

//Envia o relatório para impressora.
oPrinter:Preview()

//Envia o relatório para impressora.
oPrinter:Print()


//Retorna o nome da impressora.
oPrinter:PrinterName()

//oReport:SetPreview(.F.)

//Retorna se a impressora está ativa.	

oPrinter:IsPrinterActive()

*/
#INCLUDE "RWMAKE.CH"
#INCLUDE "Ap5mail.CH"
#include "Protheus.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.CH"
#INCLUDE "Rwmake.CH"
#INCLUDE "Topconn.CH"
#include "TbiConn.CH"
#include "TbiCode.CH"
#INCLUDE "Ap5mail.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-----------------------------------------------*
User Function MCFATR80(_cSpool,_lLiberOK,_cInSC5)
*-----------------------------------------------*
Default _lLiberOK   := .F.
Default _cSpool 	:= ''
Default _cInSC5 	:= ''

/*** FONTES ***/
Private oFont18T  	:= TFont():New("Courier New",,18,,.T.,,,,,.F.)
Private oFont16T  	:= TFont():New("Courier New",,16,,.T.,,,,,.F.)
Private oFont14TC 	:= TFont():New("Courier New",,14,,.T.,,,,,.F.)
Private oFont14T  	:= TFont():New("Arial"      ,,14,,.T.,,,,,.F.)
Private oFont18TA 	:= TFont():New("Arial"      ,,18,,.T.,,,,,.F.)
Private oFont14TI  	:= TFont():New("Arial"      ,,13,,.T.,,,,.T.,.F.)
Private oFont11F  	:= TFont():New("Arial"      ,,11,,.F.,,,,,.F.)
Private oFont13T  	:= TFont():New("Arial"      ,,12,,.T.,,,,,.F.)
Private oFont13F  	:= TFont():New("Arial"      ,,12,,.F.,,,,,.F.)
Private oFont10FA 	:= TFont():New("Arial"      ,,12,,.F.,,,,,.F.)
Private oFont10F 	:= TFont():New("Courier New",,12,,.F.,,,,,.F.)
Private oFont10FN 	:= TFont():New("Courier New",,14,,.T.,,,,,.F.)
Private oFont11FA 	:= TFont():New("Arial"      ,,11,,.F.,,,,,.F.)

//Private oFont09T  := TFont():New("Courier New",,09,,.T.,,,,,.F.)
Private oFont07F  	:= TFont():New("Courier New",,07,,.F.,,,,,.F.)
//Private oFont09F  := TFont():New("Courier New",,09,,.F.,,,,,.F.)
Private oFont09FA  	:= TFont():New("Arial",,09,,.F.,,,,,.F.)

Private oFont7TA  	:= TFont():New("Courier New",,07,,.T.,,,,,.F.)
Private oFont12F  	:= TFont():New("Courier New",,12,,.F.,,,,,.F.)
Private oFont14FN 	:= TFont():New("Courier New",,14,,.T.,,,,,.F.)
Private oFont09F  	:= TFont():New("Courier New",,09,,.F.,,,,,.F.)
Private oFont09T  	:= TFont():New("Courier New",,09,,.T.,,,,,.F.)
Private oFont14N  	:= TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)

Private oFont10AT  	:= TFont():New("Arial"      ,,10,,.T.,,,,,.F.)
Private oFont10AF  	:= TFont():New("Arial"      ,,10,,.F.,,,,,.F.)

Private oBlack := TBrush():New( , CLR_BLACK)
Private oHGRAY := TBrush():New( , CLR_HGRAY)
Private oLRed  := TBrush():New( , RGB(255,228,225))

Private cIniFile  := GetADV97()
Private _cRaiz    := GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
Private _cMdagua  := _cRaiz+"Mdagua.BMP"

/*** ABRE FOLHA ***/
Private oPrint     	:= Nil//TMSPrinter():New()

/*** IMAGENS ***/
Private _cLogo      := _cRaiz+"Logo"+xFilial('SC5')+".png" //FisxLogo("1") //"\system\_RLgr01.bmp"
_cMdagua  := _cRaiz+"R41lgrl01.bmp"

Private _lGravaLog  := .F.

Private Titulo    	:= 'Romaneio de Separação'
Private _NQrbPagPad := 3150
Private _NQrbPagImp := 3000//3150

Private _aFicha     := {}
Private cPathEst    := Alltrim(GetMv("MV_DIREST"))
Private _aDirDoc    := {'',{},'','',{},{}}
Private _aTmpDir    := {}
//Dir, Pdf, codigo, Tipo, {'','codigo','loja','nome',email}
MontaDir(cPathEst)

Private _nFator := 0
Private _nPag   := 0
Private _cMail2 := Space(200)

Private _cPVDe  := SC5->C5_NUM
Private _cPVAte := SC5->C5_NUM

Private _nTotProd  := 0
Private _nTotValor := 0
Private _nTotNF    := 0

Private _lAmarelo := !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)
Private _lRomPV   := .F.

Private _lSpool  := .F.
Private _lCredOK := .T.

//TRATAMENTO PARA BLOQUEIO DE ESTOQUE
_lLiberOK := .T.
DbSelectArea('SC9');SC9->(DbSetOrder(1))
IF SC9->(DbSeek(xFilial('SC9')+SC5->C5_NUM))
	Do While !SC9->(Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial('SC9')+SC5->C5_NUM 
		IF Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)
			_lLiberOK := .T.
			Exit
		Else
			IF SC9->C9_BLEST == '02'
				_lLiberOK := .F.
			ENDIF
		ENDIF
		SC9->(DbSkip())
	EndDo	
ENDIF

IF !_lLiberOK
   	_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
	_cPopUp += ' <br> '
	_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Romaneio de Separação - '+SC5->C5_NUM+'</font> '
	_cPopUp += ' <br><br>'
	_cPopUp += ' <font color="#000000" face="Arial" size="3">Bloqueio de estoque! Não existe produto liberado para separação </font> '
	_cPopUp += ' <br><br> '
	_cPopUp += ' <font color="#000000" face="Arial" size="2"> Por gentileza, informe ao departamento financeiro e ao Vendedor. </font> '			
	Alert(_cPopUp,'Notificação de Mercadorias')
	Return
ENDIF

//Varredura se existe item com bloqueio de credito e ou bloqueio de estoque
IF Empty(_cSpool)// valida se a chamada está vindo da impressão automatica
	DbSelectArea('SC9');SC9->(DbSetOrder(1))
	IF SC9->(DbSeek(xFilial('SC9')+SC5->C5_NUM))
		Do While !SC9->(Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial('SC9')+SC5->C5_NUM 
			//01 - Bloqueio de Crédito por Valor  | 04 - Vencimento do Limite de Crédito | 05 - Bloqueio Manual/Estorno.  | 10 - Significa FATURADO
			IF _lCredOK
				IF !Empty(SC9->C9_BLCRED) .AND. !SC9->C9_BLCRED =='10' 		
					_lCredOK := .F.
				ENDIF
			ENDIF
			SC9->(DbSkip())
		EndDo	
	ENDIF
	
	IF !_lCredOK
	   	_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
		_cPopUp += ' <br> '
		_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Romaneio de Separação</font> '
		_cPopUp += ' <br><br>'
		_cPopUp += ' <font color="#000000" face="Arial" size="3">Bloqueio de Credito! Não existe produto liberado para separação </font> '
		_cPopUp += ' <br><br> '
		_cPopUp += ' <font color="#000000" face="Arial" size="2"> Por gentileza, informe ao departamento financeiro e ao Vendedor. </font> '			
		Alert(_cPopUp,'Notificação de Credito')
		Return
	ENDIF
ENDIF


//IF  !(ALLTRIM(SC5->C5_XLEGEND) $ 'BR_PINK/BR_AMARELO/BPMSEDT4/BPMSEDT3/BPMSEDT2')
//	IF cFilAnt <> '0301'
//		MsgInfo('Relatório de Romaneio'+ENTER+ENTER+'Impressão não liberada para os Status (Em aberto ou Encerrado).' ,'Atencao')
//		Return
//	Endif
//ElseIF !(__cUserID $ GetMV('CM_LIBPSEP',.F.,'000000'))
//	IF Empty(_cSpool)
//		MsgInfo('Relatório de Romaneio'+ENTER+ENTER+'Usuário sem acesso à impressão.' ,'Atencao - #CM_LIBPSEP')
//		Return
//	endif
//ENDIF

_cQry := " SELECT DISTINCT C9_PEDIDO PROP "+ENTER
_cQry += "  FROM "+RetSqlName('SC9')+" SC9  "+ENTER
_cQry += "    WHERE SC9.D_E_L_E_T_=''  "+ENTER
_cQry += "      AND C9_FILIAL = '"+xFilial('SC9')+"'  "+ENTER
IF !Empty(_cInSC5)
	_cQry += " 		AND C9_PEDIDO IN "+FormatIn(_cInSC5,"|")+ENTER
ELSE
	_cQry += "      AND C9_PEDIDO BETWEEN '"+_cPVDe+"' AND '"+_cPVAte+"' "+ENTER
ENDIF
_cQry += "      AND C9_BLEST <> '10' "+ENTER
_cQry += " ORDER BY 1 "+ENTER

If Select("_TAB") > 0
	_TAB->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TAB",.F.,.T.)
DbSelectArea("_TAB")
_TAB->(dbGoTop())
Do While _TAB->(!Eof())
	aADD(_aFicha, _TAB->PROP)
	_TAB->(DbSkip())
EndDo

//15/12/2020 - Genesis/Gustavo = Ajuste para impressão basedo no pedido de venda
IF Len(_aFicha) == 0 .And. Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) //Pedido de aberto VERDE
	aADD(_aFicha, SC5->C5_NUM)
	//_lRomPV := .T.	//Comentado par anao imprimir o romaneio
	Titulo := 'Romaneio de Pedido'
Endif

IF Len(_aFicha) > 0
	lEnd := .F.
	Processa({|lEnd| MXR902A(_aFicha, _cSpool) },"Aguarde imprimindo ["+ Titulo +"]...")
EndIF

IF oPrint <> Nil
	oPrint:Preview()
	FreeObj(oPrint)
	MS_FLUSH()
	oPrint := Nil
EndIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*---------------------------------------*
Static Function MXR902A(_aFicha, _cSpool)
*---------------------------------------**
Local _nPV, _nF
Local _cPopUp := ''
Local _cTemp  := ''
Local _nD     := 0
Local _nRm    := 0

/*** VARIAVEIS DO SISTEMA ***/
Private _NPULALIN   := 2900 //2850
Private _nLin     	:= 0050
Private _NSpace10   := 10
Private _NSpace20   := 20
Private _NSpace30   := 30
Private _NSpace40   := 40
Private _NSpace50   := 50

Private _lVend1   := .F.
Private _lTransp  := .F.
Private _lCndPag  := .F.
Private _cTpFrete := ''
Private _nValTotal:= 0
Private _nValServ := 0
Private _nValIPI  := 0
Private _nValFre  := 0
Private _cxTpOpr  := ''
Private _nBoxFol  := 0

Private _nNFTotal  := 0
Private _nNFTotIPI := 0
Private _nNFTotICM := 0
Private _nNFTotST  := 0

Private _nAliqPIS := 0
Private _nAliqCOF := 0

Private _aLocPad   := {}
Private _aSB1Print := {}

Private aNfOri := {}

Private _nTotProd  := 0
Private _nTotValor :=0
Private _nTotNF    := 0

Private nNritem := 0
// Alterado para tratar Impressão de romaneio mesmo quando DEVOLUÇÃO/ BENEFICIAMENTO
//IF SC5->C5_TIPO $ 'D|B'
//	MsgInfo('Relatório de Romaneio'+ENTER+ENTER+'Não configurado para a modalidade de Fornecedor.' ,'Atencao')
//	Return
//ENDIF

//____________________________________________________________________________________________________________________
_lOk   := .T.
_lView := .T. //!_lSendMail
IF _lOk
	_cNomePDF := 'RD_SALON_'+DtoS(dDataBase)+'_'+StrTran(Time(),":","")+SC5->C5_NUM
	
	fErase(cPathEst+_cNomePDF+'.pdf')
	IF oPrint == Nil
		lPreview 		:= .T.
		oPrint      	:= FWMSPrinter():New(_cNomePDF,6,.T.,,.T.,,,,,,,_lView)
		oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetMargin(60,60,60,60)
		oPrint:nDevice  := IMP_PDF
		oPrint:cPathPDF := cPathEst
		_cArq := cPathEst+_cNomePDF+'.pdf'
	ENDIF
	Private PixelX := oPrint:nLogPixelX()
	Private PixelY := oPrint:nLogPixelY()
	oPrint:StartPage()
	//Grava dados para retorno e envio por e-mail
	_aDirDoc[1] := cPathEst
	_aDirDoc[2] := {_cNomePDF+'.pdf'}
	_aDirDoc[3] := _aFicha[1]
	_aDirDoc[4] := Titulo
Else
	oPrint:= TMSPrinter():New("RomaneioRomaneio" )
	oPrint:Setup()
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:StartPage()   // Inicia uma nova página
EndIF

IF !Empty(_cSpool)
	aRet := GetImpWindows(.F.) // Indica se, verdadeiro (.T.), retorna as impressoras do Application Server; caso contrário, falso (.F.), do Smart Client.
	IF (_nImpter := aScan(aRet, AllTrim(_cSpool))) > 0
		oPrint:SetDevice(IMP_SPOOL) //2-Impressora
		//oPrint:nDevice  := IMP_PDF
		//oPrint:cPrinter 	:= "SEC8425191CDAF3 (redirected 7)"
		oPrint:cPrinter 	:= aRet[_nImpter]
		//oPrint:cSession 	:= "PRINTER_SRV-TOTVS"
		oPrint:cPathPrint 	:= "\SPOOL\"
		//oPrint:cSpoolLocal 	:= "\system\\SC050740"
		oPrint:cPathPDF 	:= ''
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

//Seleciona o dispositivo de impressao
//oPrint:SetDevice(IMP_SPOOL) //2

//Impressora destino "forçada" pelo usuário. Default é ""
//cPrinter

//Envia o relatório para impressora.
//oPrinter:Preview()

//Envia o relatório para impressora.
//oPrinter:Print()

//Retorna o nome da impressora.
//oPrinter:PrinterName()
//oReport:SetPreview(.F.)

//Retorna se a impressora está ativa.	
//oPrinter:IsPrinterActive()
ENDIF

_cPedIni := _aFicha[1]

For _nPV:=1 To Len(_aFicha)
	
	//Quebra pagina por pedido
	IF _cPedIni <> _aFicha[_nPV]
		_nPag := 0
		_nTotProd  := 0
		_nTotValor := 0
		_nTotNF    := 0
		oPrint:EndPage()
		oPrint:StartPage()
	EndIF
	
	DbSelectArea('SC5');SC5->(DbSetOrder(1))
	DbSelectArea('SC6');SC6->(DbSetOrder(1))
	DbSelectArea('SC9');SC9->(DbSetOrder(1))
	DbSelectArea('SA1');SA1->(DbSetOrder(1))
	DbSelectArea('SA2');SA2->(DbSetOrder(1))
	DbSelectArea('SA4');SA4->(DbSetOrder(1))
	
	
	SC9->(DbSetOrder(1));SC9->(DbSeek(xFilial('SC9')+_aFicha[_nPV]))
	SC5->(DbSetOrder(1));SC5->(DbSeek(xFilial('SC5')+_aFicha[_nPV]))
	SC6->(DbSetOrder(1));SC6->(DbSeek(xFilial('SC6')+_aFicha[_nPV]))
	SA1->(DbSetOrder(1));SA1->(DbSeek(xFilial('SA1')+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
	SA2->(DbSetOrder(1));SA2->(DbSeek(xFilial('SA1')+ SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
	
	_lCndPag := SE4->(DbSeek(xFilial('SE4')+ SC5->C5_CONDPAG ))
	_cxTpOpr := OemToAnsi(aLLTRIM(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_TEXTO")))

	//Atualiza Status Tracker do Ecommerce [4=In Picking]
	u_zSttsEcom(.T.,SC5->C5_NUM,'4','Impresão do Romaneio')	
		
	//_______________________________________________________[ QUANDRO CABEC ]_______________________________________________________
	xImpCb(@_nLin,.F.)

	//15/12/2020 - Genesis/Gustavo = Ajuste para impressão basedo no pedido de venda
	IF _lRomPV
		IF MsgYesNo('Atenção a impressão deste romaneio é baseado no pedido de venda, deseja imprimir?'+ENTER+ENTER+;
					'>> Romaneio de Pedido - Listagem dos itens do pedido de venda'+ENTER+ENTER+;
					'   Romaneio de Separação - Itens liberados para faturamento'+ENTER;
					,'Romaneio de Pedido')
			zRomPed()
		ENDIF
	ELSE

		_nLinBx2 	:= _nLin
		_cItem      := '000'
		//________________________[ Impressao dos impostos ]________________________
		MaFisSave()
		MaFisEnd()
		nNritem := 0
		MaFisIni(	SC5->C5_CLIENTE,;							// 1-Codigo Cliente/Fornecedor
					SC5->C5_LOJACLI,;			        		// 2-Loja do Cliente/Fornecedor
					If(SC5->C5_TIPO$'DB',"F","C"),;       	    // 3-C:Cliente , F:Fornecedor
					SC5->C5_TIPO,;			                    // 4-Tipo da NF
					SC5->C5_TIPOCLI,;           				// 5-Tipo do Cliente/Fornecedor
					MaFisRelImp("MT100",{"SF2","SD2"}),;		// 6-Relacao de Impostos que suportados no arquivo
					,;						   					// 7-Tipo de complemento
					,;											// 8-Permite Incluir Impostos no Rodape .T./.F.
					"SB1",;					    				// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA461")									// 10-Nome da rotina que esta utilizando a funcao
			
		_aQryC9 := {}
		_aQryLJ := {}

		_cQryC9 := " SELECT B1_XLOCPAD, (C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO) SEQUEN, SC9.C9_LOCAL,SC9.C9_PEDIDO PEDIDO, SC9.R_E_C_N_O_ RECSC9, C9_QTDLIB QTDLIB "+ENTER
		_cQryC9 += "  FROM "+RetSqlName('SC9')+" SC9 (NOLOCK) "+ENTER
		_cQryC9 += "   INNER JOIN "+RetSqlName('SB1')+" SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = C9_PRODUTO "+ENTER
		_cQryC9 += "    WHERE SC9.D_E_L_E_T_=''  "+ENTER
		_cQryC9 += "      AND C9_FILIAL = '"+xFilial('SC9')+"'  "+ENTER
		_cQryC9 += "      AND C9_PEDIDO = '"+SC5->C5_NUM+"'  "+ENTER
		_cQryC9 += "      AND C9_NFISCAL = ' '  "+ENTER
		_cQryC9 += "      AND C9_BLEST  = ' '  "+ENTER
		_cQryC9 += " ORDER BY 3, 1, 2 "+ENTER

		If Select("_ROM") > 0
			_ROM->(DbCloseArea())
		EndIf
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryC9),"_ROM",.F.,.T.)
		DbSelectArea("_ROM"); _ROM->(dbGoTop())
		While _ROM->(!Eof())
			//Pega o total de itens
			nNritem++
			_nTotProd  += _ROM->QTDLIB
			aADD(_aQryC9,{_ROM->RECSC9,_ROM->C9_LOCAL})
			_ROM->(DbSkip())
		EndDo

		IF _nTotProd > 0
			oPrint:Say(0505,1800,OemToAnsi('Quantidade Produtos:') 			   						,oFont13T)
			oPrint:Say(0505,2150,OemToAnsi(Transform(_nTotProd,PesqPict('SD2','D2_TOTAL'))) 		,oFont13F)
		ENDIF

		_nContIT  := 0
		_nContLin := 0
		_cLocal   := ''
		_nImp     := 0

		For _nRm:=1 to Len(_aQryC9)
			//________________________[ BLOCO DE IMPRESSÃO   ****** ESTOQUE LOJA ******  ]________________________
			DbSelectArea('SC9'); SC9->(DbSetOrder(1)); SC9->(DbGoTo(_aQryC9[_nRm][1]))

			IF _cLocal <> _aQryC9[_nRm][2]
				_cLocal := _aQryC9[_nRm][2]
				_nImp   := 0
			ENDIF

			//IMPRIME BLOCO DE CABEÇALHO
			IF _nImp == 0
				xImpCbTar(@_nLin,IIF(SC9->C9_LOCAL ==AllTrim(GetMV('MC_NNRLJ01',.F.,'L1')),'LOJA','ARMAZEM'))
				xImpCbTit(@_nLin,.T.)
				_nLin+=_NSpace30 
			ENDIF


			//[19/03/19 - Genesis/Thiago] - Desconsidera itens bloqueados por estoque
			IF !Empty(SC9->C9_BLEST)
				SC9->(DbSkip())
				Loop
			EndIF

			//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
			DbSelectArea('SC6');SC6->(DbSetOrder(1));SC6->(DbSeek(xFilial('SC6')+ SC9->C9_PEDIDO +SC9->C9_ITEM + SC9->C9_PRODUTO  ))
			DbSelectArea('SB1');SB1->(DbSetOrder(1));SB1->(DbSeek(xFilial('SB1')+ SC9->C9_PRODUTO ))
			DbSelectArea('SB2');SB2->(DbSetOrder(1));SB2->(DbSeek(xFilial('SB2')+SB1->B1_COD + SC9->C9_LOCAL ))
			_nSaldo  := SaldoSB2()//(SaldoSB2()-SB2->B2_QPEDVEN)

			aDadosCfo := {}; cTipoCF:='C'
			AAdd(aDadosCfo,{"OPERNF"  ,"S"})
			AAdd(aDadosCfo,{"TPCLIFOR",If(cTipoCF == "C", SA1->A1_TIPO , SA2->A2_TIPO )})
			AAdd(aDadosCfo,{"UFDEST"  ,If(cTipoCF == "C", SA1->A1_EST  , SA2->A2_EST  )})
			AAdd(aDadosCfo,{"INSCR"   ,If(cTipoCF == "C", SA1->A1_INSCR, SA2->A2_INSCR)})
			AAdd(aDadosCfo,{"CONTR"   ,If(cTipoCF == "C", SA1->A1_CONTRIB, "")})
			_cCF := MaFisCfo(,SF4->F4_CF,aDadosCfo )

			//________________________[ Impressao dos impostos ]________________________ 
			MaFisAdd(	SC6->C6_PRODUTO,;                 	// 1-Codigo do Produto 				( Obrigatorio )
						SC6->C6_TES,;                     	// 2-Codigo do TES 					( Opcional )
						SC9->C9_QTDLIB,;		          	// 3-Quantidade 					( Obrigatorio )
						SC9->C9_PRCVEN,;	              	// 4-Preco Unitario 				( Obrigatorio )
						0,;									// 5 desconto
						SC6->C6_NFORI,;                     // 6-Numero da NF Original 			( Devolucao/Benef )
						SC6->C6_SERIORI,;		            // 7-Serie da NF Original 			( Devolucao/Benef )
						0,;			                        // 8-RecNo da NF Original no arq SD1/SD2
						SC5->C5_FRETE/nNritem,;            	// 9-Valor do Frete do Item 		( Opcional )
						SC5->C5_DESPESA/nNritem,;	        // 10-Valor da Despesa do item	 	( Opcional )
						SC5->C5_SEGURO/nNritem,;	        // 11-Valor do Seguro do item 		( Opcional )
						0,;							        // 12-Valor do Frete Autonomo 		( Opcional )
						(SC9->C9_QTDLIB * SC9->C9_PRCVEN),; // 13-Valor da Mercadoria 			( Obrigatorio )
						0,;							        // 14-Valor da Embalagem 			( Opcional )
						0,;		     				        // 15-RecNo do SB1
						0) 

			_lNoSaldo := .F.
			//CASO ESTEJA SEM SALDO, MARCARÁ A LINHA COLORIDA
			IF /*!Empty(SC9->C9_BLEST) .Or.*/ (SC9->C9_QTDLIB > _nSaldo) .And. !Empty(SC9->C9_BLEST)
				_lNoSaldo := .T.
				_nTmCol := 50
				_nLin+=_NSpace10
				_nLin-=_nTmCol
				oPrint:FillRect({_nLin+14, 050, _nLin+_nTmCol, 2400}, oLRed)
				_nLin-=_NSpace10
				_nLin+=_nTmCol
			ENDIF

			_cDescri   := AllTrim(SB1->B1_DESC)
			_nMaxDecr  := 43
			_nLinDesc  := MlCount(_cDescri,_nMaxDecr)
			_lGravaLog := .T.
			_cBloqEst  := IIF(Empty(SC9->C9_BLEST),'','*')

			//_______________________________________________________________________________________________________________________
			_nImp++
			_cItem := Soma1(_cItem)
			oPrint:Say(_nLin,0050,OemToAnsi(_cBloqEst)		   										,oFont16T)

			oPrint:Say(_nLin,0080,OemToAnsi(SC9->C9_ITEM)		   									,oFont10FA)
			oPrint:Say(_nLin,0150,OemToAnsi(PadR(SB1->B1_X_LOCAL,50))								,oFont10FA)
			oPrint:Say(_nLin,0480,OemToAnsi(PadR(SB1->B1_XCODTER,15))  								,oFont10FA)
			oPrint:Say(_nLin,0810,OemToAnsi(MemoLine(_cDescri,_nMaxDecr,1))							,oFont10FA)
			oPrint:Say(_nLin,2020,OemToAnsi(SB1->B1_UM) 											,oFont10FA)			
			oPrint:Say(_nLin,2100,OemToAnsi(Transform(SC9->C9_QTDLIB ,'@e 9,999,999.99'))			,oFont10FN)

			For _nD := 2 To _nLinDesc
				_nContIT++; _nContLin++
				ExcItem(@_nLin,_nContIT,.F.,_lNoSaldo)
				_nLin+=_NSpace30

				IF _lNoSaldo
					_nTmCol := 50
					_nLin+=_NSpace10
					_nLin-=_nTmCol
					oPrint:FillRect({_nLin+14, 050, _nLin+_nTmCol, 2400}, oLRed)
					_nLin-=_NSpace10
					_nLin+=_nTmCol
				ENDIF
				oPrint:Say(_nLin,0810,OemToAnsi(MemoLine(_cDescri,_nMaxDecr,_nD))	,oFont10FA)
			Next _nD

			//_nTotProd  += SC9->C9_QTDLIB
			_nTotValor += (SC9->C9_QTDLIB * SC9->C9_PRCVEN)

			//Imprimi linhas
			ExcItem(@_nLin,_nContIT,.T.,_lNoSaldo)

			_nLin+=_NSpace30

			IF _nLin > _NQrbPagImp
				oPrint:EndPage()
				oPrint:StartPage()
				_nLin := 50
				_lImpCapa := .F.
				xImpCb(@_nLin,.T.)
			EndIF
		Next _nRm

		//________________________[ BLOCO DE IMPRESSÃO   ****** ESTOQUE ARMAZEM ******  ]________________________

	ENDIF
	
	//Pegando Totais dos impostos
	nTotIPI   := MaFisRet(,'NF_VALIPI')
	nTotICM   := MaFisRet(,'NF_VALICM')
	nTotNF    := MaFisRet(,'NF_TOTAL')
	nTotFrete := MaFisRet(,'NF_FRETE')
	nTotISS   := MaFisRet(,'NF_VALISS')
	MaFisEnd()
	//Valor da nota fiscal
	_nTotNF   := nTotNF
			
	//EndDo
	//ENDIF// thiago
	//Alert(_cItem +' Linha: '+cValToChar(_nLin))
	_NQrbPagImp := 2900 //
	//RodaPe()
Next _nPV

//15/12/2020 - Genesis/Gustavo = Ajuste para impressão basedo no pedido de venda
IF _lRomPV
	Return
Endif
//Os de serviço e os de devolu~ção passem apenas na lib comercial
_cTes := Posicione("SC6", 1, xFilial("SC6") +SC5->C5_NUM, "C6_TES")
_cEst := Posicione("SF4", 1, xFilial("SF4") + _cTes, "F4_ESTOQUE")

IF (__cUserID $ GetMV('CM_LIBPSEP',.F.,'000000') .And. _lGravaLog) .Or. (!Empty(_cSpool) .And. _lSpool)
	IF Empty(SC5->C5_XLIBFAT) .And. _cEst == 'S'
		_cNewMsg := ENTER+' |> @ ROMANEIO: '+ __cUserId+" - " +AllTrim(cUserName)+ " /  "+DtoC(Date())+'-'+Time()+ENTER
		IF 	RecLock('SC5',.F.)
				Replace SC5->C5_XLIBFAT With DtoC(Date())+'-'+Time()
				//Replace SC5->C5_XTPSEP  With ''
				Replace SC5->C5_XLOGSEP With AllTrim(SC5->C5_XLOGSEP) + _cNewMsg
				Replace SC5->C5_XULTLFA With DtoC(Date())+'-'+Time()					
			SC5->(MsUnLock())
		ENDIF
	ElseIf !Empty(SC5->C5_XLIBFAT) .And. _cEst == 'S'
		_cNewMsg := ENTER+' |> @ REIMPRESSÃO MANUAL DE ROMANEIO: '+ __cUserId+" - " +AllTrim(cUserName)+ " /  "+DtoC(Date())+'-'+Time()+ENTER
		IF 	RecLock('SC5',.F.)
				Replace SC5->C5_XLOGSEP With AllTrim(SC5->C5_XLOGSEP) + _cNewMsg
			SC5->(MsUnLock())
		ENDIF
		//u_xTracker2PV('SC9','SIGAFAT', SC5->C5_NUM,,'Reimpressão do Romaneio de Separação para expedição','BR_AMARELO','Em Separação','',.T.,'BR_PINK')	
	ENDIF
ENDIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*--------------------------------------------*
Static Function _xEndFol(_nLinBx2,_nLin)
*--------------------------------------------*
//RodaPe(_cTp)
//oPrint:Box(_nBoxFol,0050,2800,_nLin)
IF _nLin > _NQrbPagImp
	oPrint:EndPage()
	oPrint:StartPage()
	xImpCb(@_nLin)
EndIF
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*--------------------------*
Static Function xEmpFil(_cFil)
*--------------------------*
Local _aRet := {}
aADD(_aRet, AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_NOMECOM')))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_ENDENT'))))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_BAIRENT'))))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_CIDENT'))))
aADD(_aRet, AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_ESTENT')))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_CEPENT'),'@r 99999-999'))
//aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'),'@r 99 9999-9999'))
aADD(_aRet, RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_INSC'),'@r 999.999.999.999'))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_CGC'),"@r 99.999.999/9999-99"))

//CapitalAce()
//Capital()
Return(_aRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*------------------------------------*
Static Function xImpCb(_nLin,_lCbDes)
*------------------------------------*
Local _nX := 0

Default _lCbDes := .T.
Private _aEmp    := xEmpFil(cFilAnt)

SC6->(DbSetOrder(1));SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))

_nLin := 50

oPrint:Say(_nLin,1900,OemToAnsi('Data/Hora: '+DtoC(dDataBase)+Space(03)+Time()) 	,oFont09T)
_nLin+=_NSpace30
oPrint:Say(_nLin,2200,OemToAnsi('Página: '+TransForm(_nPag+=1,'@e 999')) 		,oFont09T)
_nLin+=_NSpace30

_cMoeda := SC5->C5_MOEDA
DbSelectArea('SM2');SM2->(DbSetOrder(1));SM2->(DbSeek(DtoS(dDataBase)))
oPrint:Say(_nLin,iIF(_cMoeda==1,2200,2000),OemToAnsi('Moeda: '+GetMV("MV_SIMB"+cValToChar(_cMoeda),.F.,'') + iIF(_cMoeda==1,'',' - Taxa: '+TransForm(&("SM2->M2_MOEDA"+cValToChar(_cMoeda)),'@e 99.9999')) ),oFont09T)

_nLin-=(_NSpace30+_NSpace30)
oPrint:SayBitmap(_nLin,0060,_cLogo,440,150)
_nLin+=_NSpace30

//_nLin+=_NSpace30+_NSpace30+_NSpace10
_nLin+=_NSpace30
oPrint:Say(_nLin,0900,OemToAnsi( AllTrim(_aEmp[2])+' - '+AllTrim(_aEmp[3])+' - '+AllTrim(_aEmp[4])+' - '+AllTrim(_aEmp[5])  ) 		,oFont13F)
_nLin+=_NSpace30

//[Meliora/Gustavo] 25/04/2017 Jessica solicitou fixar o mesmo numero telefonico no cabecalho
cFone := _aEmp[7]//SubStr(StrTran(StrTran(_aEmp[7], " ", ""), "-", ""), 1, 4) + "-" + SubStr(StrTran(StrTran(_aEmp[7], " ", ""), "-", ""), 5, 4)

oPrint:Say(_nLin,0800,OemToAnsi( 'CNPJ: '+AllTrim(_aEmp[9])+' - I.E: '+AllTrim(_aEmp[8])  ) 	,oFont13F)

_nLin+=_NSpace30

oPrint:Say(_nLin,1000,OemToAnsi('www.salonline.com.br')	,oFont13F)

_nLin+=_NSpace30+_NSpace30+_NSpace30

nFontSize := 35
oPrint:Code128C(_nLin, 2000, AllTrim(SC5->C5_NUM), nFontSize )

IF _lSpool
	oPrint:Say(_nLin,0500,OemToAnsi(Titulo+" Nº.: "+SC5->C5_NUM) 		,oFont18T)
Else
	oPrint:Say(_nLin,0800,OemToAnsi(Titulo+" Nº.: "+SC5->C5_NUM) 		,oFont18T)
Endif

_nLin+=_NSpace30

_nLin+=_NSpace30
oPrint:Box(_nLin,0050,_nLin+140,2400)
oPrint:Line(_nLin,1890,_nLin+139.5,1890)
oPrint:Line(_nLin,2140,_nLin+139.5,2140)

_nLin+=_NSpace30

oPrint:Say(_nLin,0100,OemToAnsi('Cliente:'),oFont13T)
oPrint:Say(_nLin,1900,OemToAnsi('Emissão:')					 		,oFont13T)
oPrint:Say(_nLin,2150,OemToAnsi('Dt Processo:')		 				,oFont13T)

_nLin+=_NSpace30
// Tratativa para Impressaõ de romaneio pedido tipo "B" e "D"// Thiago vanucci // 20/08/2019
IF !SC5->C5_TIPO $ 'D|B'
	oPrint:Say(_nLin,0100,OemToAnsi(SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+SubStr(SA1->A1_NOME,1,30)),oFont13F)
Else
	oPrint:Say(_nLin,0100,OemToAnsi(SA2->A2_COD+'/'+SA2->A2_LOJA+' - '+SubStr(SA2->A2_NOME,1,30)),oFont13F)
Endif

oPrint:Say(_nLin,1900,OemToAnsi(DtoC( SC5->C5_EMISSAO ))			 	,oFont13F)

//15/12/2020 - Genesis/Gustavo = Ajuste para impressão basedo no pedido de venda
IF _lRomPV
	oPrint:Say(_nLin,2150,OemToAnsi(DtoC(SC5->C5_EMISSAO ))				,oFont13F)
Else
	oPrint:Say(_nLin,2150,OemToAnsi(DtoC(SC9->C9_DATALIB ))				,oFont13F)
Endif

//_nLin+=_NSpace30+(_NSpace10/2)

_nLin+=_NSpace30

//BOX TRANSPORTADORA
_lTransp := SA4->(DbSeek(xFilial('SA4')+ SC5->C5_TRANSP ))
oPrint:Box(_nLin,0050,_nLin+140,2400)
oPrint:Line(_nLin,1780,_nLin+139.5,1780)
_nLin+=_NSpace30+(_NSpace10/2)
oPrint:Say(_nLin,0100,OemToAnsi('Transportadora:')							 							,oFont13T)
IF _lTransp
	//_cEnd := OemToAnsi ( Alltrim(SA4->A4_END)+' - '+Alltrim(SA4->A4_BAIRRO)+' - '+Alltrim(SA4->A4_MUN)+' - '+Alltrim(SA4->A4_EST)+' - Cep:'+Alltrim(SA4->A4_CEP)  )
	_cEnd := OemToAnsi ( Alltrim(SA4->A4_END)+' - '+Alltrim(SA4->A4_BAIRRO)+' - '+Alltrim(SA4->A4_EST))
	_cTel := 'Tel: '+OemToAnsi ('('+SA4->A4_DDD+') '+TransForm(SA4->A4_TEL,'@r 9999-9999'))
	oPrint:Say(_nLin,0390,OemToAnsi(Alltrim(SA4->A4_NOME)+' - '+_cTel)	,oFont13F)
	_nLin+=_NSpace30
	IF !Empty(SA4->A4_END)
		oPrint:Say(_nLin,0390,OemToAnsi('Endereço: '+_cEnd)	,oFont13F)
		_nLin+=_NSpace30
	ENDIF
Else 
	_nLin+=_NSpace30 + _NSpace30
ENDIF
oPrint:Say(_nLin,0100,OemToAnsi('Cond.Pagto: ')						 							,oFont13T)
IF _lCndPag
	oPrint:Say(_nLin,0390,OemToAnsi(SE4->E4_DESCRI)										 		,oFont13F)
ENDIF
oPrint:Say(_nLin,1000,OemToAnsi('Modalidade de Entrega: ')			 							,oFont13T)
oPrint:Say(_nLin,1500,OemToAnsi(MdEntrega( Iif(SC5->(FieldPos('C5_XMODENT'))>0, SC5->C5_XMODENT, '')  )) 		,oFont13F)

//oPrint:Say(_nLin,1800,OemToAnsi('Quantidade Produtos') 			   								,oFont13T)
//oPrint:Say(_nLin,1900,OemToAnsi(AllTrim(Transform(_nTotProd,PesqPict('SD2','D2_TOTAL')))) 		,oFont13F)

//oPrint:Say(_nLin,1800,OemToAnsi('Rota: ')			 											,oFont13T)
//IF SC5->(FieldPos('C5_XENDEXP'))>0
//	oPrint:Say(_nLin,1900,OemToAnsi(SC5->C5_XENDEXP)   											,oFont13F)
//ENDIF

_nLin+= -_NSpace30-_NSpace30
oPrint:Say(_nLin,1800,OemToAnsi('Envio P/ Separação:')	 										,oFont13T)
oPrint:Say(_nLin,2100,OemToAnsi(SC5->C5_XULTLFA)   												,oFont13F)
_nLin+=_NSpace30
//oPrint:Say(_nLin,1800,OemToAnsi('Entrega Estimada  : ')	 									,oFont13T)
//IF SC5->(FieldPos('C5_XENDEXP'))>0
//	oPrint:Say(_nLin,2100,OemToAnsi(SC5->C5_XPREVEN)   											,oFont13F)
//ENDIF

_nLin+=_NSpace30
//oPrint:Say(_nLin,2000,OemToAnsi('Horas Ent. : ')	 											,oFont13T)
//IF SC5->(FieldPos('C5_XENDEXP'))>0
//	oPrint:Say(_nLin,2200,OemToAnsi(SC5->C5_XPRZENT)   											,oFont13F)
//ENDIF
_nLin+=_NSpace30

_cPedCli := SC5->C5_PEDECOM

//BOX OBSERVACAO
_nLnObs := _nLin

/*
_nLin+=_NSpace30+(_NSpace30/2) //+(_NSpace30/2)+_NSpace10

oPrint:Say(_nLin,0100,OemToAnsi('Observação Interna:') 										,oFont13T)
IF SC5->(FieldPos('C5_XOBSINT'))>0
	IF !EMPTY(SC5->C5_XOBSINT)
		oPrint:Say(_nLin,0430,OemToAnsi(SC5->C5_XOBSINT) 		 				        	,oFont13F)
	ENDIF
ENDIF
_nLin+=_NSpace30

_aCF := FwGetSX5("13",SC6->C6_CF)
IF Len(_aCF) > 0	
	oPrint:Say(_nLin,0100,OemToAnsi('Oper.: '+_aCF[1][4]) 		 				        	,oFont13T)
ENDIF

_nLin+=_NSpace30
oPrint:Box(_nLin,0050,_nLin,2400)
_nLin+=_NSpace30

oPrint:Say(_nLin,0100,OemToAnsi('Observação Nota:')			   							,oFont13T)
_nLin+=_NSpace30+(_NSpace30/2)

_cMsg      := Alltrim(OemToAnsi(SC5->C5_MENNOTA))

_nQtdLMemo := 110
_nLinhas   := MlCount(_cMsg,_nQtdLMemo)
For _nX:=1 To _nLinhas
	oPrint:Say(_nLin,0100, OemToAnsi(MemoLine(_cMsg,_nQtdLMemo,_nX)) ,oFont13F)
	_nLin+=_NSpace30+(_NSpace10/2)
Next _nX
oPrint:Line(_nLnObs,0050,_nLin, 0050)
oPrint:Line(_nLnObs,2400,_nLin, 2400)
oPrint:Line(_nLin  ,050 ,_nLin, 2400)

//_nLin+=_NSpace30+(_NSpace10/2)

//ENDEREÇO DE ENTREGA_______________________________________________________________________________________________
_nLnObs := _nLin
*/

//_nLin+=_NSpace30
oPrint:Box(_nLin,0050,_nLin+150,2400)
_nLin+=_NSpace30

oPrint:Say(_nLin,0100,OemToAnsi('Endereço de Entrega:') 								,oFont13T)

_nLin+=_NSpace30 //_________Pula Linha
oPrint:Say(_nLin,0100,OemToAnsi('Cliente:'),oFont13T)
oPrint:Say(_nLin,0300,OemToAnsi(SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+AllTrim(SA1->A1_NOME)),oFont13T)

_nLin+=_NSpace30 //_________Pula Linha
oPrint:Say(_nLin,0100,OemToAnsi('Endereço:'),oFont13T)
_cEndFull := OemToAnsi ( Alltrim(SA1->A1_ENDENT)+' - CEP: '+Alltrim(SA1->A1_CEPE)  ) 
_cBaiCida :=OemToAnsi (Alltrim(SA1->A1_MUNE)+' - '+Alltrim(SA1->A1_ESTE)+' - Bairro: '+Alltrim(SA1->A1_BAIRROE)  )	
IF !Empty(SA1->A1_ENDENT)
	oPrint:Say(_nLin,0300,	OemToAnsi(_cEndFull) ,oFont13F)
EndIF 
_nLin+=_NSpace30 //_________Pula Linha
oPrint:Say(_nLin,0100,OemToAnsi('Cid./Est.:'),oFont13T)
IF !Empty(SA1->A1_ENDENT)
	oPrint:Say(_nLin,0300,	OemToAnsi(_cBaiCida) ,oFont13F)
EndIF 	

_nLin+=_NSpace30
//___________________________________________________________________________________________________________________


//BOX PERFIL ENTREGA
_nLin+=_NSpace30+_NSpace10

//_nLin+=_NSpace30
IF _lCbDes
	xImpCbTit(@_nLin,_lCbDes)
ENDIF

_nLin+=_NSpace30
//Imprimi marca d'agua
//oPrint:SayBitmap(1000,600,_cMdagua,1300,1000)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*----------------------------------------*
Static Function xImpCbTit(_nLin,_lCbDes)
*----------------------------------------*
Default _lCbDes := .T.

oPrint:FillRect({_nLin, 050, _nLin+050, 2400}, oHGRAY)
oPrint:Line(_nLin   ,050 ,_nLin   , 2400)
oPrint:Line(_nLin   ,050 ,_nLin+50, 0050)
oPrint:Line(_nLin   ,2400,_nLin+50, 2400)
oPrint:Line(_nLin+50,050 ,_nLin+50, 2400)

_nTmCol := 50
oPrint:Line(_nLin,0140,_nLin+_nTmCol, 0140)
oPrint:Line(_nLin,0470,_nLin+_nTmCol, 0470)
oPrint:Line(_nLin,0800,_nLin+_nTmCol, 0800)
oPrint:Line(_nLin,1990,_nLin+_nTmCol, 1990)
oPrint:Line(_nLin,2120,_nLin+_nTmCol, 2120)

_nLin+=_NSpace30

oPrint:Say(_nLin,0065,OemToAnsi('Item') 				,oFont13T)
oPrint:Say(_nLin,0150,OemToAnsi('Endereço')		   		,oFont13T)
oPrint:Say(_nLin,0480,OemToAnsi('Produto') 				,oFont13T)
oPrint:Say(_nLin,0810,OemToAnsi('Descrição') 			,oFont13T)
oPrint:Say(_nLin,2020,OemToAnsi('UM') 					,oFont13T)
oPrint:Say(_nLin,2160,OemToAnsi('Quantidade') 			,oFont13T)

_nLin+=_NSpace30

_nBoxFol := _nLin

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*----------------------------------------*
Static Function xImpCbTar(_nLin,_cTipo)
*----------------------------------------*
Local _cMsgTar := '**** ESTOQUE - '+_cTipo+' ****'

oPrint:FillRect({_nLin, 050, _nLin+050, 2400}, oBlack)         
oPrint:Line(_nLin   ,050 ,_nLin   , 2400)
oPrint:Line(_nLin   ,050 ,_nLin+50, 0050)
oPrint:Line(_nLin   ,2400,_nLin+50, 2400)
oPrint:Line(_nLin+50,050 ,_nLin+50, 2400)

_nLin+=_NSpace30+_NSpace10

IF _cTipo == 'ARMAZEM'
	oPrint:Say(_nLin,0800,OemToAnsi(_cMsgTar) ,oFont18T,,CLR_WHITE)
ELSE
	oPrint:Say(_nLin,0850,OemToAnsi(_cMsgTar) ,oFont18T,,CLR_WHITE)
ENDIF

_nLin+=_NSpace30-_NSpace10
  
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*---------------------------------*
Static Function TpFrete(_cTpFrete)
*---------------------------------*
Default _cTpFrete := ''
IF !Empty(_cTpFrete)
	_aTpFrete := CTBCBOX(SC5->C5_TPFRETE)
	
	IF (_nPos := aScan(_aTpFrete,{|X| Left(x,1)==SC5->C5_TPFRETE}))>0
		_cTpFrete := UppER(SubStr(_aTpFrete[_nPos],At('=',_aTpFrete[_nPos])+1,Len(_aTpFrete[_nPos])))
	EndIF
ENDIF
Return(_cTpFrete)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-----------------------------*
Static Function RodaPe(_cAlias)
*-----------------------------*
Local _nV

//Impressao do RODAPE
_nLin+=_NSpace20

//_________________Box Rodape 001_________________
oPrint:Box(_nLin,0050,_nLin+380,2400)
oPrint:Line(_nLin,0800,_nLin+380, 0800)
oPrint:Line(_nLin,1600,_nLin+380, 1600)

_nLin+=_NSpace30
//RASTREA TODOS OS VENDEDORES PARA ENVIO DE NOTIFICACAO
FOR _nV:=1 To 5
	IF SC5->(FieldPos('C5_VEND'+cValToChar(_nV)))>0
		DbSelectArea('SA3');SA3->(DbSetOrder(1))
		IF SA3->(DbSeek(xFIlial('SA3')+&('SC5->C5_VEND'+cValToChar(_nV)) ))
			aaDD(_aTmpDir,{'',SA3->A3_COD, '', AllTrim(SA3->A3_NOME), Upper(SA3->A3_EMAIL) })
		ENDIF
	EndIF
NExt _nV

//caso tenha vendedor 2
IF !Empty(SC5->C5_VEND2)
	_nLin-=_NSpace10+(_NSpace30/2)
ENDIF

_nLin+=_NSpace30+(_NSpace30/2)+(_NSpace30/2)
oPrint:Say(_nLin,0100,OemToAnsi('Vendedor')							 				,oFont13T)

IF !Empty(SC5->C5_VEND1)
	oPrint:Say(_nLin,0300,OemToAnsi(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1 ,"A3_NOME")) 	,oFont13F)
	
	DbSelectArea('SA3');SA3->(DbSetOrder(1))
	IF SA3->(DbSeek(xFilial('SA3')+SC5->C5_VEND1))
		_cVndNome := AllTrim(SA3->A3_NOME)
		_cVndMail := AllTrim(SA3->A3_EMAIL)
		_cNumTels := '(+55) 11 - 3048-0147'
		
		IF !Empty(SA3->A3_TEL)
			_cNumTels := '(+55) '+SA3->A3_DDDTEL+' - '+SA3->A3_TEL
		ENDIF
		IF !Empty(SA3->A3_CEL)
			_cNumTels += iIF(!Empty(_cNumTels),' | ','')+'(+55) '+SA3->A3_DDDTEL+' - '+SA3->A3_CEL
		ENDIF
		_nLin+=_NSpace30
		oPrint:Say(_nLin,0100,OemToAnsi('Contato:')		,oFont13T)
		oPrint:Say(_nLin,0300,OemToAnsi(_cNumTels) 		,oFont13F)
	ENDIF
ENDIF
IF !Empty(SC5->C5_VEND2)
	_nLin+=_NSpace30+_NSpace10+(_NSpace30/2)
	oPrint:Say(_nLin,0100,OemToAnsi('Vendedor 2')							 						,oFont13T)		
	oPrint:Say(_nLin,0300,OemToAnsi(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2 ,"A3_NOME")) 	,oFont13F)
	
	DbSelectArea('SA3');SA3->(DbSetOrder(1))
	IF SA3->(DbSeek(xFilial('SA3')+SC5->C5_VEND2))
		_cVndNome := AllTrim(SA3->A3_NOME)
		_cVndMail := AllTrim(SA3->A3_EMAIL)
		_cNumTels := '(+55) 11 - 3048-0147'
		
		IF !Empty(SA3->A3_TEL)
			_cNumTels := '(+55) '+SA3->A3_DDDTEL+' - '+SA3->A3_TEL
		ENDIF
		IF !Empty(SA3->A3_CEL)
			_cNumTels += iIF(!Empty(_cNumTels),' | ','')+'(+55) '+SA3->A3_DDDTEL+' - '+SA3->A3_CEL
		ENDIF
		_nLin+=_NSpace30
		oPrint:Say(_nLin,0100,OemToAnsi('Contato:')		,oFont13T)
		oPrint:Say(_nLin,0300,OemToAnsi(_cNumTels) 		,oFont13F)
		_nLin-=_NSpace30+_NSpace30
	ENDIF
ENDIF
//ENDIF
_nLin+=_NSpace30
_nLin+=_NSpace30+(_NSpace30/2)

_nLin-= ( (_NSpace30+(_NSpace30/2))*3 )

oPrint:Say(_nLin,0900,OemToAnsi('Quantidade Produtos') 			   						,oFont13T)
oPrint:Say(_nLin,1300,OemToAnsi(AllTrim(Transform(_nTotProd,PesqPict('SD2','D2_TOTAL')))) 	,oFont13F)

oPrint:Say(_nLin,1720,OemToAnsi('Data Separação: _____/_____/______') 	   						,oFont13T)

_nLin+=_NSpace30+_NSpace30+_NSpace10
oPrint:Say(_nLin,0900,OemToAnsi('Espécie:') 								,oFont13T)
oPrint:Say(_nLin,1050,OemToAnsi('______________________________')			,oFont13T)
//oPrint:Say(_nLin,1500,OemToAnsi(SC5->C5_ESPECI1) 		 					,oFont13F)
_nLin+=_NSpace30+_NSpace30+_NSpace10
oPrint:Say(_nLin,0900,OemToAnsi('Volume:') 									,oFont13T)
oPrint:Say(_nLin,1050,OemToAnsi('______________________________')			,oFont13T)
_nLin-=(_NSpace30+_NSpace30+_NSpace20)
_nLin+=_NSpace30

_nLin+=_NSpace30
oPrint:Say(_nLin,1750,OemToAnsi('______________________________') 					,oFont13T)
_nLin+=_NSpace30+_NSpace10
oPrint:Say(_nLin,1850,OemToAnsi('  Visto do Separador') 			   				,oFont13F)
_nLin+=_NSpace30+_NSpace30+_NSpace30
oPrint:Say(_nLin,1750,OemToAnsi('______________________________') 					,oFont13T)
_nLin+=_NSpace30+_NSpace10
oPrint:Say(_nLin,1850,OemToAnsi('  Visto do Conferente') 			   				,oFont13F)
_nLin-=(_NSpace50*2)+_NSpace30

_nLin+=_NSpace30

//FRETE / PESO
//oPrint:Box(_nLin,0050,_nLin+100,2400)
//oPrint:Line(_nLin,1190,_nLin+100, 1190)
oPrint:Line(_nLin,0050,_nLin,1600)	

_nLin+=_NSpace30+(_NSpace10/2)
oPrint:Say(_nLin,0100,OemToAnsi('VALOR MERCADORIA: ' ) 	 										  	,oFont10FA)
oPrint:Say(_nLin,0500,OemToAnsi(Transform(_nTotValor,PesqPict('SD2','D2_TOTAL')) ) 	   				,oFont10FA)
oPrint:Say(_nLin,0900,OemToAnsi('Liquido: '+Transform(SC5->C5_PESOL,PesqPict('SC5','C5_PESOL')) ) 	   			,oFont13T)
_nLin+=_NSpace30+_NSpace10
oPrint:Say(_nLin,0900,OemToAnsi('Bruto....: '+Transform(SC5->C5_PBRUTO,PesqPict('SC5','C5_PBRUTO')) ) 	   			,oFont13T)
_nLin-=_NSpace30+_NSpace10

//_nLin+=_NSpace30
_nLin+=_NSpace30+_NSpace10
//oPrint:Say(_nLin,0100,OemToAnsi('** Atenção o valor impressao NÃO contém impostos' ) 	   	,oFont13T)
oPrint:Say(_nLin,0100,OemToAnsi('VALOR NOTA FISCAL: ' ) 	   										,oFont13T)
oPrint:Say(_nLin,0500,OemToAnsi(Transform(_nTotNF,PesqPict('SD2','D2_TOTAL')) ) 					,oFont13T)

_nLin+=_NSpace30+_NSpace10
_nSaldoPB0 := 0
If _nSaldoPB0>0
	oPrint:Say(_nLin,0100,OemToAnsi('** Verificar analise do financeiro.' ) 												,oFont13T)
EndIF
//oPrint:Say(_nLin,0500,OemToAnsi(Transform(IIF(_nSaldoPB0 > _nTotNF, 0 ,_nTotNF),PesqPict('SD2','D2_TOTAL')) ) 	,oFont13T)

_nLin-=_NSpace30+_NSpace10
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MCFAT90 º Autor ³ 	Genesis/Gustavo	 º Data ³  24/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Romaneio de Separacao                                        ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-------------------------------------*
Static Function ExcItem(_nLin,_nContIT,_lImpLinha,_lNoSaldo)
*-------------------------------------*
Local _nTmCol := (_NSpace30+_NSpace10+(_NSpace10/2))
Default _lNoSaldo := .F.

/*
IF _lNoSaldo .And. _lImpLinha
_nTmCol := 50
_nLin+=_NSpace10
_nLin-=_nTmCol
oPrint:FillRect({_nLin+14, 050, _nLin+_nTmCol, 2400}, oLRed)
_nLin-=_NSpace10
_nLin+=_nTmCol
ENDIF
*/

_nLin+=_NSpace10
_nLin-=_nTmCol

oPrint:Line(_nLin,0050,_nLin+_nTmCol, 0050)

oPrint:Line(_nLin,0140,_nLin+_nTmCol, 0140)
oPrint:Line(_nLin,0470,_nLin+_nTmCol, 0470)
oPrint:Line(_nLin,0800,_nLin+_nTmCol, 0800)
oPrint:Line(_nLin,1990,_nLin+_nTmCol, 1990)
oPrint:Line(_nLin,2120,_nLin+_nTmCol, 2120)

oPrint:Line(_nLin,2400,_nLin+_nTmCol, 2400)

_nLin+=_nTmCol                                                        

//oPrint:Line(_nLin   ,050 ,_nLin   , 2400)                                                

IF _lImpLinha
	oPrint:Line(_nLin   ,050 ,_nLin   , 2400)
EndIf

Return

*---------------------------------*
Static Function MdEntrega(_cTpFrete)
*---------------------------------*
Local _nD := 0
Default _cTpFrete := ''
IF !Empty(_cTpFrete)
	IF SC5->(FieldPos('C5_XMODENT')) > 0
		_aTpFrete := CTBCBOX('C5_XMODENT')
		
		IF (_nPos := aScan(_aTpFrete,{|X| Left(x,1)==SC5->C5_XMODENT}))>0
			_cTpFrete := UppER(SubStr(_aTpFrete[_nPos],At('=',_aTpFrete[_nPos])+1,Len(_aTpFrete[_nPos])))
		EndIF
	ENDIF
ENDIF
Return(_cTpFrete)


//15/12/2020 - Genesis/Gustavo = Ajuste para impressão basedo no pedido de venda
*----------------------*
Static Function zRomPed
*----------------------*
Local _nD  := 0
Local _nRm := 0
	
_nLinBx2 	:= _nLin
_cItem      := '000'
//________________________[ Impressao dos impostos ]________________________
MaFisSave()
MaFisEnd()
nNritem := 0
MaFisIni(	SC5->C5_CLIENTE,;							// 1-Codigo Cliente/Fornecedor
				SC5->C5_LOJACLI,;			        		// 2-Loja do Cliente/Fornecedor
				If(SC5->C5_TIPO$'DB',"F","C"),;       	    // 3-C:Cliente , F:Fornecedor
				SC5->C5_TIPO,;			                    // 4-Tipo da NF
				SC5->C5_TIPOCLI,;           				// 5-Tipo do Cliente/Fornecedor
				MaFisRelImp("MT100",{"SF2","SD2"}),;		// 6-Relacao de Impostos que suportados no arquivo
				,;						   					// 7-Tipo de complemento
				,;											// 8-Permite Incluir Impostos no Rodape .T./.F.
				"SB1",;					    				// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
				"MATA461")									// 10-Nome da rotina que esta utilizando a funcao
		
_aQryC9 := {}

_cQryC9 := "  SELECT ,C6_ITEM ,SC6.R_E_C_N_O_ RECSC6 "+ENTER
_cQryC9 += "    FROM "+RetSqlName('SC6')+" SC6 (NOLOCK)  "+ENTER
_cQryC9 += "     INNER JOIN "+RetSqlName('SB1')+" SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = C6_PRODUTO "+ENTER
_cQryC9 += "      WHERE SC6.D_E_L_E_T_=''   "+ENTER
_cQryC9 += "        AND C6_FILIAL = '"+xFilial('SC9')+"'  "+ENTER
_cQryC9 += "        AND C6_NUM = '"+SC5->C5_NUM+"'  "+ENTER
_cQryC9 += "        AND C6_NOTA = ' '   "+ENTER
_cQryC9 += "   ORDER BY 1 "+ENTER

If Select("_ROM") > 0
	_ROM->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryC9),"_ROM",.F.,.T.)
DbSelectArea("_ROM"); _ROM->(dbGoTop())
While _ROM->(!Eof())
	//Pega o total de itens
	nNritem++
	aADD(_aQryC9,_ROM->RECSC6)
	_ROM->(DbSkip())
EndDo
	
_nContIT  := 0
_nContLin := 0
For _nRm:=1 to Len(_aQryC9)
	
	DbSelectArea('SC6'); SC6->(DbSetOrder(1)); SC6->(DbGoTo(_aQryC9[_nRm]))
	IF SC6->(Recno()) <> _aQryC9[_nRm]
		Loop
	ENDIF
	
	IF SC6->C6_QTDENT == SC6->C6_QTDVEN
		SC9->(DbSkip())
		Loop
	EndIF
	
	//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
	DbSelectArea('SB1');SB1->(DbSetOrder(1));SB1->(DbSeek(xFilial('SB1')+ SC6->C6_PRODUTO ))
	DbSelectArea('SB2');SB2->(DbSetOrder(1));SB2->(DbSeek(xFilial('SB2')+SB1->B1_COD + SC6->C6_LOCAL ))
	_nSaldo  := SaldoSB2()//(SaldoSB2()-SB2->B2_QPEDVEN)
	
	aDadosCfo := {}; cTipoCF:='C'
	AAdd(aDadosCfo,{"OPERNF"  ,"S"})
	AAdd(aDadosCfo,{"TPCLIFOR",If(cTipoCF == "C", SA1->A1_TIPO , SA2->A2_TIPO )})
	AAdd(aDadosCfo,{"UFDEST"  ,If(cTipoCF == "C", SA1->A1_EST  , SA2->A2_EST  )})
	AAdd(aDadosCfo,{"INSCR"   ,If(cTipoCF == "C", SA1->A1_INSCR, SA2->A2_INSCR)})
	AAdd(aDadosCfo,{"CONTR"   ,If(cTipoCF == "C", SA1->A1_CONTRIB, "")})
	_cCF := MaFisCfo(,SF4->F4_CF,aDadosCfo )
			
	//________________________[ Impressao dos impostos ]________________________ 
	MaFisAdd(	SC6->C6_PRODUTO,;                 	// 1-Codigo do Produto 				( Obrigatorio )
				SC6->C6_TES,;                     	// 2-Codigo do TES 					( Opcional )
				SC6->C6_QTDVEN,;		          	// 3-Quantidade 					( Obrigatorio )
				SC6->C6_PRCVEN,;	              	// 4-Preco Unitario 				( Obrigatorio )
				0,;									// 5 desconto
				SC6->C6_NFORI,;                     // 6-Numero da NF Original 			( Devolucao/Benef )
				SC6->C6_SERIORI,;		            // 7-Serie da NF Original 			( Devolucao/Benef )
				0,;			                        // 8-RecNo da NF Original no arq SD1/SD2
				SC5->C5_FRETE/nNritem,;            	// 9-Valor do Frete do Item 		( Opcional )
				SC5->C5_DESPESA/nNritem,;	        // 10-Valor da Despesa do item	 	( Opcional )
				SC5->C5_SEGURO/nNritem,;	        // 11-Valor do Seguro do item 		( Opcional )
				0,;							        // 12-Valor do Frete Autonomo 		( Opcional )
				(SC6->C6_QTDVEN * SC6->C6_PRCVEN),; // 13-Valor da Mercadoria 			( Obrigatorio )
				0,;							        // 14-Valor da Embalagem 			( Opcional )
				0,;		     				        // 15-RecNo do SB1
				0) 
							
	_lNoSaldo := .F.
	//CASO ESTEJA SEM SALDO, MARCARÁ A LINHA COLORIDA
	IF (SC6->C6_QTDVEN > _nSaldo)
		_lNoSaldo := .T.
		_nTmCol := 50
		_nLin+=_NSpace10
		_nLin-=_nTmCol
		oPrint:FillRect({_nLin+14, 050, _nLin+_nTmCol, 2400}, oLRed)
		_nLin-=_NSpace10
		_nLin+=_nTmCol
	ENDIF
	
	_cDescri  := AllTrim(SB1->B1_DESC) +' - '+ AllTrim(SB1->B1_XFABDES)
	_nMaxDecr := 43
	_nLinDesc := MlCount(_cDescri,_nMaxDecr)
	
	_lGravaLog := .T.
	
	_cBloqEst := '' //IIF(Empty(SC9->C9_BLEST),'','*')
	
	//_______________________________________________________________________________________________________________________
	_cItem := Soma1(_cItem)
	oPrint:Say(_nLin,0050,OemToAnsi(_cBloqEst)		   															,oFont16T)
	oPrint:Say(_nLin,0080,OemToAnsi(SC6->C6_ITEM)		   														,oFont10FA)
	oPrint:Say(_nLin,0150,OemToAnsi(PadR(SB1->B1_COD,15))  														,oFont10FA)
	//oPrint:Say(_nLin,0480,OemToAnsi(PadR(AllTrim(SB1->B1_DESC)+ iif(!Empty(_cFabric),' - '+_cFabric,'') ,40))	,oFont10FA)
	oPrint:Say(_nLin,0480,OemToAnsi(MemoLine(_cDescri,_nMaxDecr,1))												,oFont10FA)
	oPrint:Say(_nLin,1350,OemToAnsi(SB1->B1_UM) 																,oFont10FA)
	oPrint:Say(_nLin,1440,OemToAnsi(SC6->C6_LOCAL) 																,oFont10FA)
	oPrint:Say(_nLin,1520,OemToAnsi(PadR(SB1->B1_XLOCPAD,20))								   					,oFont10FA)
	oPrint:Say(_nLin,2150,OemToAnsi(Transform(SC6->C6_QTDVEN ,'@e 99,999.99'))					 				,oFont14FN)
	//oPrint:Say(_nLin,1840,OemToAnsi(Transform(_nSaldo        ,'@e 9,999,999.99'))					 			,oFont10F)
	oPrint:Say(_nLin,2080,OemToAnsi(SB1->B1_XCODIND)  															,oFont10FA)
	oPrint:Say(_nLin,2320,OemToAnsi(SC6->C6_CF) 	 															,oFont10FA)
	
	For _nD := 2 To _nLinDesc
		_nContIT++; _nContLin++
		ExcItem(@_nLin,_nContIT,.F.,_lNoSaldo)
		_nLin+=_NSpace30
		
		IF _lNoSaldo
			_nTmCol := 50
			_nLin+=_NSpace10
			_nLin-=_nTmCol
			oPrint:FillRect({_nLin+14, 050, _nLin+_nTmCol, 2400}, oLRed)
			_nLin-=_NSpace10
			_nLin+=_nTmCol
		ENDIF
		oPrint:Say(_nLin,0480,OemToAnsi(MemoLine(_cDescri,_nMaxDecr,_nD))	,oFont10FA)
	Next _nD
	
	_nTotProd  += SC6->C6_QTDVEN
	_nTotValor += (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
					
	//Imprimi linhas
	//ExcItem(@_nLin)
	ExcItem(@_nLin,_nContIT,.T.,_lNoSaldo)
	
	_nLin+=_NSpace30
	
	//_xEndFol(@_nLinBx2, @_nLin,_cAlias)
	IF _nLin > _NQrbPagImp
		oPrint:EndPage()
		oPrint:StartPage()
		_nLin := 50
		_lImpCapa := .F.
		xImpCb(@_nLin)
	EndIF
		
Next _nRm

Return

*---------------------*
User Function zMCFATR80
*---------------------*
Local _cInSC5 := '000011|000012'

If Select("SX6") == 0
	RpcSetType(3)
	RpcSetEnv("02","1501")
Endif

DbSelectArea('SC5');SC5->(DbSetOrder(1));SC5->(DbGoTop())
IF SC5->(DbSeek(xFilial('SC5')+'000011'))
	FwMsgRun(,{|| u_MCFATR80(,,_cInSC5) }, "Aguarde Processamento...","Imprimindo romaneio de Separação")	
ENDIF

RETURN
