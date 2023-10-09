#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

#Define DS_ModalFrame 128  
#DEFINE  ENTER CHR(13)+CHR(10)

 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ SLLINX   บ Autor ณ                          บ Data ณ 28/06/2023 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Descricao ณ Rotina das integracoes do Novo E-commerce com a Linx.			บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ REGRAS    ณ Esta rotina principal sera a responsavel pela tela de gerencia- บฑฑ
ฑฑบ           ณ mento das informacoes a serem integradas com a Linx.            บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ  																บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function SLLINX()

Local _aArea		:= GetArea()
Local _aParam		:= {}
Local _aRetPar		:= {}
Local _aParamExc	:= {}
Local _aRetParEx	:= {}
Local _cPrdIdExc	:= ""
Private _cFilSB5	:= xFilial( "SB5" ) 		// Para uso na Exclusao dos Produtos Integrados na Linx

AAdd( _aParam, { 2, "Tipo de Integra็ใo", "1", { "Produtos", "Precos" }, 80, "", .T. } )

If ParamBox( _aParam, "Integra็ใo - Protheus X Linx", @_aRetPar )
	If _aRetPar[1] == "Exclusใo no Linx"

		AAdd( _aParamExc, { 1, "Product ID De:  ", Space(6), "", "", "", "", 30, .T. } )
		AAdd( _aParamExc, { 1, "Product ID Ate: ", Space(6), "", "", "", "", 30, .T. } )

		If ParamBox( _aParamExc, "Exclusใo de Produtos no Linx", @_aRetParEx )
			_cPrdIdExc	:= _aRetParEx[1]

			If ApMsgYesNo( "Os produtos excluํdos neste processo deverใo ser integrados novamente." + CRLF + CRLF + "Confirma a Exclusใo de Produtos no Linx ?", "KSECOA10 - Aten็ใo..." )
				While AllTrim( _cPrdIdExc ) <= AllTrim( _aRetParEx[2] )
					Processa( { || KSECOA1030( AllTrim( _cPrdIdExc ) ) }, "Aguarde... Excluํndo o ProductID: [" + AllTrim( _cPrdIdExc ) + "]", , .F. )
					_cPrdIdExc := Soma1( AllTrim( _cPrdIdExc ) )
				EndDo
			EndIf
		EndIf
	Else
		Processa( { || SLLINX1000( _aRetPar[1] ) }, "Aguarde...", , .F. )
	EndIf
EndIf

RestArea( _aArea )

Return Nil

static Function SLLINX1000(_cOpcaoInt)
	
Local _aArea		:= GetArea()
Local _lRetorno		:= .T.
Local _cMsg			:= ""
Local _cNomeArq		:= "" 										// Nome do arquivo do log para registro
Local _lConfirma	:= .F.
Local _lContinua	:= .T.
Local _cTabPrc      := SuperGetMV( "SL_TABPRC", Nil, "012" 	)
Local _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "Oic_integration" 	)
Local _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "9Krr6rnESDeG@wT3" 	)
Local _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )
//https://salonline.layer.core.dcg.com.br/v1/Catalog/API.svc/web/SaveCategories
//https://salonline.layer.core.dcg.com.br/v1/Catalog/API.svc/web/SaveSupplier

Local _cUrlPai		:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCE_PRODU_ERP_B2B/1.0/product"
Local _cUrlFilho	:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCCESS_SKU/1.0/sku"
Local _cUrlPaFi		:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCE_VINC_SKU_PROD/1.0/AddSKUProduct"
Local _cUrlChEst	:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCESSA_ESTOQUE/1.0/inventory"
Local _cUrlEstq		:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCESSA_ESTOQUE/1.0/inventory"
Local _cUrlPrc		:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCE_PRECO_ERP_B2B/1.0/price"
// Definicao da posicao das informacoes utilizadas dentro do vetor para agilizar a utilizacao.
// Situacoes possiveis
	
Local _nTimeOut	 	:= 120
Local _aHeadOut		:= {}
Local _cHeadRet		:= ""
Local _cPostRet 	:= ""
Local cError  		:= ""
Local cWarning 		:= ""

Local _aJSonFilho	:= ""										// Monta JSon Produto Filho. 1o Elemento eh o JSon, o 2o eh se montou certo ou errado
Local _cJSonPai		:= ""										// JSon Produto Pai 								= SaveProduct
Local _cJSonFilho	:= ""										// JSon Produto Filho 								= Sku
Local _cJSonPaFi	:= ""										// JSon Relacionamento entre Produtos Pai e Filho 	= AddSKUToProduct
Local _cJSonEstq	:= ""										// JSon Grava Estoque do Produto					= SaveSKUInventory
Local _cJSonChEs	:= ""										// JSon Altera Estoque do Produto 					= ChangeSKUInventory

// Indica se deve integrar a Foto do produto pai. Somente deve integrar
Local _lIntPai		:= .F.

Local _nTamRetJs	:= 0
Local _aJsonFields	:= {}
Local _nRetParser	:= 0
Local _oJson		:= Nil
Local _oJHashMap	:= Nil
Local _xConteudo	:= Nil										// Var de retorno com o conteudo encontrado apos o Parse do JSon

// Variaveis para query da integracao dos produtos
Local _cQuery		:= ""
Local _cAliasQry	:= "TRBINT"
Local _CALIASTBC    := "_cAliasTBC"
Local _nPos			:= 0										// Definicao da categoria correspondente

Local _cChaveAnt	:= ""										// Controla a troca do produto Pai e efetiva a gravacao qdo o atual for diferente do anterior
Local _nTamPrdId	:= TamSX3( "B5_XPRDTID" )[1]
Local _nTamSkuId	:= TamSX3( "B5_XSKUID" 	)[1]
Local _cProdutId	:= Space( _nTamPrdId )
Local _cSkuIdFil	:= Space( _nTamSkuId )
Local _cProdPai		:= "" 										// Campo usado = B5_XPAI

Local _aRegLogOk		:= {}									// Carrega os dados dos produtos integrados com sucesso
Local _aRegLogNo		:= {}									// Carrega os dados dos produtos com falha na integracao

// Variaveis para montar o De / Para do Tamanho e das Categorias dos produtos a partir de um arq CSV para facilitar a criacao de novos
// tamanhos e categorias e nao necessitar alteracao e compilacao desta rotina toda a vez que se identificar a falta de alguma informacao.
Local _cLinha			:= ""
Local _aLinha			:= {}									// Vetor para desmembrar a linha antes de copiar para o vetor _aDados
Private _cPath		:= "\system\Linx\integracao"+DTOS(Date())+SubStr(time(),1,2)+SubStr(time(),4,2)+SubStr(time(),7,2)+'.TXT'
Private _aTamanho		:= {}									// De/Para dos Tamanhos dos Produtos e respectivo Metadados Tamanho existente no Linx
Private _aCategor		:= {}									// De/Para das Categorias dos Produtos e respectivas Categorias existente no Linx

Private _aRegIntBk	:= {}								// Var para Backup dos dados dos produtos a serem integrados para utilizacao no Filtro
Private _aRegInteg	:= {}								// Var para Carregar os dados dos produtos a serem integrados
Private _oRegInteg 										// Var para montagem da tela

Private _oDlg
Private _nX			  := 0
Private _oChkBoxTd
Private _lMarcaTudo	  := .F.      
Private _oBotInteg
Private _oBotEncer                  
Private lFilho        :=.F.

// Situacoes possiveis
Private _cSitAtual		:= "0"
Private _oNo			:= LoadBitmap( GetResources(), "UNCHECKED"		)	// 1o Elemento = "0" = Nao Marcado
Private _oOk			:= LoadBitmap( GetResources(), "CHECKED"		)	// 1o Elemento = "1" = Marcado
Private _oVermelho		:= LoadBitmap( GetResources(), "BR_VERMELHO"	)	// 1o Elemento = "2" = Registro Duplicado ou faltando Informacao nao integra

Private _oTotReg
Private _nTotReg		:= 0

Private _oSelecao
Private _nSelecao		:= 0

Private _oBuscaTxt
Private _cBuscaTxt		:= Space( 40 )

// Itens do Combo para Selecao / Filtro dos Produtos
Private _aFiltro		:= { "Todos", "Produto Pai", "Produto Filho", "Categoria", "Produtos Integrados", "Produtos Nใo Integrados" }

Private _oFiltro
Private _nFiltro		:= 1
Private _cFiltro		:= _aFiltro[_nFiltro]			// Var Caracter para mostrar a Selecao no combo

Private _oFiltro
Private _nFiltro		:= 1
Private _cFiltro		:= _aFiltro[_nFiltro]			// Var Caracter para mostrar a Selecao no combo						
Private _nPB5XPAI 		:= 01 							// Posicao do Campo B5_XPAI
Private _nPACVCODPRO 	:= 02 							// Posicao do Campo ACV_CODPRO
Private _nPB1COD	 	:= 03 							// Posicao do Campo B1_COD
Private _nPB1DESC	 	:= 04 							// Posicao do Campo B1_DESC
Private _nPB1PRV1	 	:= 05 							// Posicao do Campo B1_PRV1
Private _nPDA1PRCVEN 	:= 06 							// Posicao do Campo DA1_PRCVEN
Private _nPB1MSEXP	 	:= 07 							// Posicao do Campo B1_MSEXP
Private _nPB1_PROC	 	:= 08 							// Posicao do Campo B1_PROC
Private _nPB1LOJPROC 	:= 09 							// Posicao do Campo B1_LOJPROC
Private _nPB1ATIVO	 	:= 10 							// Posicao do Campo B1_ATIVO
Private _nPB1PESO	 	:= 11 							// Posicao do Campo B1_PESO
Private _nB5ECCARAC 	:= 12 							// Posicao do Campo B5_ECCARAC = DESC_ESPEC
Private _nB5ECAPRES 	:= 13 							// Posicao do Campo B5_ECAPRES = DESC_CURTA
Private _nB5XPRDTID 	:= 14 							// Posicao do Campo B5_XPRDTID = PRODUCT ID Linx = Produto Pai
Private _nB5XSKUID 		:= 15 							// Posicao do Campo B5_XSKUID  = SKU ID Linx 	 = Produto Filho
Private _nSB1RECNO 		:= 16 							// Posicao do Campo RECNO do SB1 para gravacao do B1_MSEXP apos a integracao realizada com sucesso
Private _nSB5RECNO 		:= 17 							// Posicao do Campo RECNO do SB5 para buscar os campos das descricoes
Private _nPB1TIPO	 	:= 18 							// Posicao do Campo B1_TIPO
Private _nACVRECNO	 	:= 19 							// Posicao do Campo RECNO do ACV para IDENTIFICAR POSSIVEIS DUPLICIDADES
Private _nACVCATEG	 	:= 20 							// Posicao do Campo ACV_CATEGO = Codigo Categoria do ACV
Private _nACUCOD	 	:= 21 							// Posicao do Campo ACU_COD    = Codigo Categoria do ACU
Private _nACUDESC	 	:= 22 							// Posicao do Campo ACU_DESC   = Descricao da Categoria do ACU
Private _nB5ECDESCR	 	:= 23 							// Posicao do Campo B5_ECDESCR = Descricao do produto
Private _nB5ECTITU	 	:= 24 							// Posicao do Campo B5_ECTITU  = Titulo da Pagina do produto = PageTitle
Private _nB5ECPCHAV 	:= 25 							// Posicao do Campo B5_ECPCHAV = Meta Description
Private _nB5ECINDIC 	:= 26 							// Posicao do Campo B5_ECINDIC = Meta KeyWords
Private _nB5ECIMGFI 	:= 27 							// Posicao do Campo B5_ECIMGFI = Foto do Produto
Private _nLKCODBAR	 	:= 28 							// Posicao do Campo LK_CODBAR  = Codigo de Barras - Ean do Produto	
Private _nIDCATEG	 	:= 29 							// Posicao do Campo acu_xidlin
Private _nIDMARCA	 	:= 30 							// Posicao do Campo B5_XMARCA
Private _nLargura		:= 31
Private _nAltura		:= 32	
Private _nProfundi		:= 33	
Private _nPosStat		:= 34	
Private aItems			:={}
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "0101" 
//B5_XPRDTID - CODIGO PAI - cadastra primeiro
//B5_XSKUID - CODIGO FILHO - envia logo em seguida o mesmo cadastro
//B5_XCODPAI - codigo pai
//ACU_XIDLINX - CRIAR
// B1_COD:= 32005          
IF upper(_cOpcaoInt) <> "PRODUTOS"
	
	cExpressao := ""
	
	If Select( "_cAliasTBC" ) > 0
		(_cAliasTBC)->( DbCloseArea() )
	EndIf
	cQuery:=" select DA0_CODTAB,DA0_DESCRI "
	cQuery+=" from " + RetSqlName( "DA0" ) + " DA0 "
 	cQuery+=" WHERE D_E_L_E_T_= '' "
 	cQuery+=" AND DA0_XGRUPO <> '' "
	dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), _cAliasTBC, .F., .T. )
	
	While (_cAliasTBC)->( ! Eof() )
		cExpressao += (_cAliasTBC)->DA0_CODTAB + ' - ' + alltrim((_cAliasTBC)->DA0_DESCRI)+";"	
		 (_cAliasTBC)->(DBSKIP())
	enddo

	aItems := StrTokArr(cExpressao, ';') 

	DEFINE DIALOG oDlg TITLE "Selecione a lista de pre็o" FROM 100,100 TO 200,300 PIXEL
	oDlg:lEscClose := .F. 
        cCombo1:= aItems[1]
        oCombo1 := TComboBox():New(010,020,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
        aItems,060,20,oDlg,,,,,,.T.,,,,,,,,,'cCombo1')
		_oBtnFi1   := TButton():Create(oDlg, 030,025,"Confirmar",{|| oDlg:END()},035,015,,,,.T.,,"",,,,,)
    ACTIVATE DIALOG oDlg CENTERED

	_cTabPrc:=  left(cCombo1,3)
ENDIF

// Monta query para integracao dos produtos.  
_cQuery := "SELECT ACV.ACV_CODPRO, ACV.ACV_CATEGO, ACU.ACU_COD, ACU.ACU_DESC,ACU.ACU_XIDLIN, SB1.B1_COD, SB5.B5_COD, SB5.B5_XMARCA, "	+ CRLF
_cQuery += "       SB1.B1_DESC, SB1.B1_PRV1, SB1.B1_TIPO, DA1.DA1_PRCVEN, SB1.B1_MSEXP, SB1.B1_PROC, SB1.B1_LOJPROC, "		    		+ CRLF
_cQuery += "       SB1.B1_ATIVO, SB1.B1_PESO, SB5.B5_XPRDTID,B5_XCODPAI,B5_XSKUID,ZY_IDLINX,B1_CODBAR,B5_LARG,B5_COMPR,B5_ESPESS,"		+ CRLF
_cQuery += "       ISNULL( CAST( CAST( SB5.B5_ECCARAC AS VARBINARY( 4096 ) ) AS VARCHAR( 4096 ) ), '' ) AS DESC_ESPEC, " 				+ CRLF
_cQuery += "       ISNULL( CAST( CAST( SB5.B5_ECAPRES AS VARBINARY( 4096 ) ) AS VARCHAR( 4096 ) ), '' ) AS DESC_CURTA, " 				+ CRLF
_cQuery += "       ISNULL( CAST( CAST( SB5.B5_ECDESCR AS VARBINARY( 4096 ) ) AS VARCHAR( 4096 ) ), '' ) AS DESCRICAO, " 				+ CRLF
_cQuery += "       ISNULL( CAST( CAST( SB5.B5_ECINDIC AS VARBINARY( 4096 ) ) AS VARCHAR( 4096 ) ), '' ) AS B5_ECINDIC, " 				+ CRLF
_cQuery += "       SB5.B5_ECTITU B5_ECTITU, SB5.B5_ECPCHAV B5_ECPCHAV, SB5.B5_ECIMGFI, " 												+ CRLF
_cQuery += "       SB1.R_E_C_N_O_ SB1RECNO, SB5.R_E_C_N_O_ SB5RECNO, ACV.R_E_C_N_O_ ACVRECNO " 											+ CRLF
_cQuery += "  FROM " + RetSqlName( "SB1" ) + " SB1 (NOLOCK) " 																			+ CRLF
_cQuery += "       INNER JOIN " + RetSqlName( "SB5" ) + " SB5 (NOLOCK) ON SB5.D_E_L_E_T_ = '' AND SB5.B5_FILIAL = SB1.B1_FILIAL " 		+ CRLF
_cQuery += "                                                          AND SB5.B5_COD = SB1.B1_COD " 									+ CRLF
_cQuery += "       INNER JOIN " + RetSqlName( "DA1" ) + " DA1 (NOLOCK) ON DA1.D_E_L_E_T_ = '' AND DA1.DA1_FILIAL = SB1.B1_FILIAL " 		+ CRLF
_cQuery += "                                                          AND DA1.DA1_CODPRO = SB1.B1_COD AND DA1.DA1_CODTAB ='"+_cTabPrc+"'"+ CRLF
//_cQuery += "															AND DA1.DA1_PRCVEN > 0											"+ CRLF
_cQuery += "       INNER JOIN " + RetSqlName( "ACV" ) + " ACV (NOLOCK) ON ACV.D_E_L_E_T_ = '' AND ACV.ACV_CODPRO = SB1.B1_COD " 		+ CRLF
_cQuery += "       INNER  JOIN " + RetSqlName( "ACU" ) + " ACU (NOLOCK) ON ACU.D_E_L_E_T_ = '' AND ACU.ACU_FILIAL = ACV.ACV_FILIAL " 	+ CRLF
_cQuery += "                                                          AND ACU.ACU_COD = ACV.ACV_CATEGO  AND ACU.ACU_XIDLIN<>'' " 		+ CRLF
_cQuery += "       LEFT  JOIN " + RetSqlName( "SA2" ) + " SA2 (NOLOCK) ON SA2.D_E_L_E_T_ = '' AND SA2.A2_FILIAL = '' " 					+ CRLF
_cQuery += "                                                          AND SA2.A2_COD = SB1.B1_PROC AND SA2.A2_LOJA = SB1.B1_LOJPROC " 	+ CRLF
_cQuery += "       INNER JOIN " + RetSqlName( "SZY" ) + " SZY (NOLOCK) ON SZY.D_E_L_E_T_ = '' AND SZY.ZY_COD = SB5.B5_XMARCA and ZY_IDLINX<>'' " + CRLF
_cQuery += " WHERE SB1.D_E_L_E_T_ = '' " 																								+ CRLF
_cQuery += "   AND SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' " 																		+ CRLF
_cQuery += "   AND SB1.B1_MSBLQL <> '1' " 																								+ CRLF
_cQuery += " ORDER BY SB5.B5_XCODPAI, SB1.B1_COD " 		
If Select( _cAliasQry ) # 0
	(_cAliasQry)->( DbCloseArea() )
EndIf
dbUseArea( .T., "TOPCONN", TCGenQry( ,, _cQuery ), _cAliasQry, .F., .T. )

dbSelectArea( _cAliasQry )
(_cAliasQry)->( DbGoTop() )

 _nTotReg := 0 						// Total de registros a processar

While (_cAliasQry)->( ! Eof() )
_nTotReg++ 	
_nPos	:= aScan( _aRegInteg, { |x| x[_nPB5XPAI] == (_cAliasQry)->B5_XCODPAI .and. x[_nPB1COD] == (_cAliasQry)->B1_COD } )

	If _nPos > 0										// Altera o Status do registro encontrado e do atual para VERMELHO para identificar Duplicidades
		_aRegInteg[_nPos][_nPosStat]	:= "2"
		_cSitAtual						:= "2"
	ElseIf Empty( AllTrim( (_cAliasQry)->B5_XCODPAI ) ) 	// Altera o Status do registro atual para VERMELHO para identificar falta de Informacao
		_cSitAtual						:= "2"
	Else
		_cSitAtual						:= "0" 			// Status padrao para o registro atual qdo nao encontra duplicidades
	EndIf

		Aadd( _aRegInteg, {	(_cAliasQry)->B5_XCODPAI            ,;
							AllTrim( (_cAliasQry)->ACV_CODPRO )	,;
							(_cAliasQry)->B1_COD				,;
							(_cAliasQry)->B1_DESC				,;
							(_cAliasQry)->B1_PRV1				,;
							(_cAliasQry)->DA1_PRCVEN			,;
							(_cAliasQry)->B1_MSEXP				,;
							(_cAliasQry)->B1_PROC				,;
							(_cAliasQry)->B1_LOJPROC			,;
							(_cAliasQry)->B1_ATIVO				,;
							(_cAliasQry)->B1_PESO				,;							
							(_cAliasQry)->DESC_ESPEC			,;
							(_cAliasQry)->DESC_CURTA			,;
							(_cAliasQry)->B5_XPRDTID 			,;
							(_cAliasQry)->B5_XSKUID 			,;
							(_cAliasQry)->SB1RECNO	 			,;
							(_cAliasQry)->SB5RECNO				,;							
							(_cAliasQry)->B1_TIPO 				,;
							(_cAliasQry)->ACVRECNO 				,;
							(_cAliasQry)->ACV_CATEGO			,;
							(_cAliasQry)->ACU_COD				,;
							(_cAliasQry)->ACU_DESC				,;
							(_cAliasQry)->DESCRICAO				,;
							(_cAliasQry)->B5_ECTITU				,;
							(_cAliasQry)->B5_ECPCHAV			,;
							(_cAliasQry)->B5_ECINDIC			,;
							(_cAliasQry)->B5_ECIMGFI			,;
							(_cAliasQry)->B1_CODBAR				,;
							(_cAliasQry)->ACU_XIDLIN			,;
							(_cAliasQry)->ZY_IDLINX				,;							
							(_cAliasQry)->B5_LARG				,;							
							(_cAliasQry)->B5_ESPESS				,;
							(_cAliasQry)->B5_COMPR				,;
							_cSitAtual} )


	(_cAliasQry)->( DbSkip() )
EndDo

_aRegIntBk := ACLONE( _aRegInteg )

If Select( _cAliasQry ) # 0
	(_cAliasQry)->( DbCloseArea() )
EndIf

DbSelectArea( "SB1" )		// Seleciona o Cad. de Produtos para trabalhar como area principal
DbSetOrder( 1 )				// B1_FILIAL + B1_COD 
// Verifica se trouxe registro para integracao
If Empty( _aRegInteg )
	ApMsgInfo( "Nใo foram encontrados registros para integra็ใo." + CRLF + "Favor Verificar.", " Aten็ใo..." )
Else
	While _lContinua
		DEFINE MSDIALOG _oDlg TITLE " Integra็ใo E-commerce - " + _cOpcaoInt From 0,0 To 550, 1200 Pixel Style DS_ModalFrame

			_oDlg:lEscClose	:= .F.			// Impede a saida pela tecla Esc

			@ 0.05, 0.1  LISTBOX _oRegInteg Fields HEADER 	""				, " Produto Pai", " C๓digo", " Descri็ใo" ,  " Product ID"	, " SKU ID" 	,;
															" C๓d. Categ."	, " Desc Categoria"	," EAN " , " Pre็o Venda",	 ;
						COLSIZES 020, 090, 090, 090, 090, 040, 090, 040, 035, 035 SIZE 602, 236 OF _oDlg ON DBLCLICK ( _fMarca( _oRegInteg:nAt ) )

			@ 238, 002 TO 273, 601 LABEL "" PIXEL COLOR CLR_RED OF _oDlg 

			@ 251, 025 CheckBox _oChkBoxTd Var _lMarcaTudo Size 130, 09 Pixel Of _oDlg Prompt "Marca/Desmarca Todos" On Change( _MarcaTudo( _lMarcaTudo ) )

			@ 245, 126 SAY "Total de Produtos:" 									SIZE 50, 010 					OF _oDlg PIXEL
			@ 242, 170 MSGET _oTotReg VAR _nTotReg 		Picture "@E 99,999,999" 	SIZE 40, 010 WHEN .F. 			OF _oDlg PIXEL

			@ 260, 135 SAY "Selecionados:" 											SIZE 50, 010 					OF _oDlg PIXEL
			@ 257, 170 MSGET _oSelecao VAR _nSelecao 	Picture "@E 99,999,999" 	SIZE 40, 010 WHEN .F. 			OF _oDlg PIXEL

			@ 245, 258 SAY "Buscar :" 					SIZE 080, 010 												OF _oDlg PIXEL
			@ 242, 280 MSGET _oBuscaTxt VAR _cBuscaTxt 	SIZE 135, 010 												OF _oDlg PIXEL

			@ 260, 252 SAY "Filtrar por :" OF _oDlg PIXEL SIZE 30, 20
	   		@ 258, 280 MSCOMBOBOX _oFiltro Var _cFiltro ITEMS _aFiltro SIZE 100, 010                             	OF _oDlg PIXEL

			_oRegInteg:SetArray( _aRegInteg )
			_oRegInteg:bLine := &( _fBLine() )
			_oBotInteg := TButton():New( 245, 460, "Pesquisar",_oDlg, { || _lContinua := .T., _lConfirma := .T., _fFiltroPr(_cFiltro,_aFiltro)}, 40, 20, , , .F., .T., .F., , .F., , , .F. )
			_oBotInteg := TButton():New( 245, 500, "Integrar", _oDlg, { || _lContinua := .T., _lConfirma := .T., _oDlg:End() }, 40, 20, , , .F., .T., .F., , .F., , , .F. )
			_oBotEncer := TButton():New( 245, 540, "Encerrar", _oDlg, { || _lContinua := .F., _lConfirma := .F., _oDlg:End() }, 40, 20, , , .F., .T., .F., , .F., , , .F. )

		ACTIVATE MSDIALOG _oDlg CENTERED

		If _lConfirma .and. _nSelecao > 0
			// Limpa variaveis para iniciar um novo processamento
			_lRetorno		:= .T.
			_cChaveAnt		:= ""
			_cProdutId		:= Space( _nTamPrdId )
			_cSkuIdFil		:= Space( _nTamSkuId )
			_aRegLogOk		:= {}			// Var para Carregar os dados dos produtos integrados com sucesso
			_aRegLogNo		:= {}			// Var para Carregar os dados dos produtos com falha na integracao
			_aHeadOut		:= {}
			_cHeadRet		:= ""
			_cPostRet		:= ""
			_aJsonFields	:= {}
			_nRetParser		:= 0
			_oJson			:= Nil
			_oJHashMap		:= Nil
			_xConteudo		:= Nil
			_cMsg			:= ""

			
		Aadd(_aHeadOut,"Content-Type: application/json")   
		Aadd(_aHeadOut,"Accept: application/json") 				
		Aadd(_aHeadOut,"Authorization: Basic " + _cAutentic)
			ProcRegua( _nTotReg )

			gravalog( _cPath, "Inํcio do processamento...")

			For _nX := 1 To Len( _aRegInteg )

				IncProc( "Integrando produto " + cValToChar( _nX ) + " de " + cValToChar( _nTotReg ) )

				// Pula registros Nao Selecionados, Duplicados ou Faltando informacao
				If _aRegInteg[_nX][_nPosStat] <> "1"
					Loop
				EndIf

				// Monta a Msg do log de processamento de todos os registros marcados para integracao
				_cMsg	:= "Linha: [" 			+ StrZero( _nX, 8 ) 			+ "] - "
				_cMsg	+= "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _aRegInteg[_nX][_nB5XPRDTID] 	+ "] "
				_cMsg	+= "Produto FILHO [" 	+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _aRegInteg[_nX][_nB5XSKUID] 	+ "]"
				
				gravalog( _cPath, _cMsg)

				// Processa Somente a Integracao do PAI se NAO for op็ใo PREวOS
				// Valida se eh outro produto Pai para gravacao E envia os dados do produto PAI. - Daqui...
				If _cOpcaoInt <> "Precos" .and. _cChaveAnt <> _aRegInteg[_nX][_nPB5XPAI]     
					lFilho:=.F. //INTEGRA PAPAI E FILHINHOS
					// Atualiza a Var para Controlar a troca do produto Pai e efetivar a gravacao qdo o atual for diferente do anterior
					_cChaveAnt	:= _aRegInteg[_nX][_nPB5XPAI]
					_cProdutId	:= PadR( _aRegInteg[_nX][_nB5XPRDTID], _nTamPrdId ) 							// Codigo Linx Produto PAI						
					_cJSonPai	:= MJsonPai( _nX )																// Monta JSon Produto Pai	= SaveProduct
					_cPostRet	:= HttpPost( _cUrlPai, "", _cJSonPai, _nTimeOut, _aHeadOut, @_cHeadRet ) 		// Chamada da integracao
					_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 									// Gera o tamanho da string do retorno
					_oJson		:= tJsonParser():New()															// Cria o objeto para fazer o parser do Json
					_lRetorno	:= .T.							// Ajusta o Retorno para os proximos produtos caso tenha gerado algum erro no produto anterior

					// Faz o Parser da mensagem JSon e extrai para Array (aJsonfields) e cria tambem um HashMap para os dados da mensagem (_oJHashMap)
					_lRetorno	:= _oJson:Json_Hash( _cPostRet, _nTamRetJs, @_aJsonFields, @_nRetParser, @_oJHashMap )

					If _lRetorno
						_lRetorno	:= HMGet( _oJHashMap, "ProductID", _xConteudo ) 							// Obtem o valor dos campos usando a chave

						// Tem que testar o _xConteudo diferente de ZERO, pois mesmo qdo o retorno do Post vem com ERRO a TAG "ProductID"
						// dentro do retorno do erro EH ZERO E O HMGet(...) DEVOLVE .T. devido a encontrar a TAG, mesmo que seja ZERO.
						_lRetorno := ( _xConteudo > 0 )
					EndIf

					// Testa novamente o retorno devido ao HMGet executado. 
					If _lRetorno
						_cProdutId	:= PadR( _xConteudo, _nTamPrdId ) 											// Guarda o codigo de retorno do Produto PAI

						// Monta a Msg do log para gravacao conforme os dados do produto
						_cMsg := "1-" 				+ StrZero( _nX, 8 ) 			+ " Produto Pai   - Integrado com Sucesso - "
						_cMsg += "Produto PAI [" 	+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
						_cMsg += "Produto FILHO [" 	+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"

						// Posiciona no Cad. Complemento de Produto para gravar o codigo gerado no Linx
						DbSelectArea( "SB5" )

						// Posiciona no registro
						DbGoTo( _aRegInteg[_nX][_nSB5RECNO] )

						// Valida se eh o mesmo produto integrado por garantia e se o codigo ainda nao foi gravado anteriormente
						If 	AllTrim( SB5->B5_COD ) == AllTrim( _aRegInteg[_nX][_nPB1COD] ) .and. ;
							( Empty( AllTrim( SB5->B5_XPRDTID ) ) .or. SB5->B5_XPRDTID == _cProdutId )
							If Empty( AllTrim( SB5->B5_XPRDTID ) )
								RecLock( "SB5", .F. )
									SB5->B5_XPRDTID	:= _cProdutId												// Grava o Produto Pai
								SB5->( MsUnLock() )

								_aRegInteg[_nX][_nB5XPRDTID] := _cProdutId 										// Atualiza o Codigo gerado no Vetor
							Else
								_cMsg += " - Altera็ใo de produto jแ integrado anteriormente."
							EndIf

							Aadd( _aRegLogOk, _cMsg )															// Registra o Log da Integracao com Sucesso
						Else
							_cMsg += " - Falha na gravacao do campo B5_XPRDTID: [" 	+ SB5->B5_XPRDTID 							+ "]"
							_cMsg += " - B5_COD: [" 								+ AllTrim( SB5->B5_COD ) 					+ "]"
							_cMsg += " - Produto em processamento (query): [" 		+ cValToChar( _aRegInteg[_nX][_nPB1COD] ) 	+ "]"
							_cMsg += " - ProductId gerado: [" 						+ _cProdutId 								+ "]"
							Aadd( _aRegLogNo, _cMsg )															// Registra o Log da Falha da Integracao
							_lRetorno := .F.
						EndIf
					Else
						// Monta a Msg do log para gravacao conforme os dados do produto
						_cMsg := "1-" 					+ StrZero( _nX, 8 ) 			+ " Produto Pai   - Falha na integra็ใo - "
						_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
						_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
						_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento

						Aadd( _aRegLogNo, _cMsg )																// Registra o Log da Falha da Integracao
					EndIf
				ElseIf _cOpcaoInt <> "Precos"
                    lFilho:=.T. //INTEGRA APENAS OS FILHINHOS DO PAPAI CINALLI
					// Posiciona no Cad. Complemento de Produto para gravar o codigo gerado no Linx
					DbSelectArea( "SB5" )
					// Posiciona no registro
					DbGoTo( _aRegInteg[_nX][_nSB5RECNO] )

					// Valida se eh o mesmo produto PAI integrado e grava o codigo LINX se ainda nao foi gravado anteriormente
					If 	AllTrim( SB5->B5_COD ) == AllTrim( _aRegInteg[_nX][_nPB1COD] ) .and. ;
						Empty( AllTrim( SB5->B5_XPRDTID ) ) .and. ! Empty( AllTrim( _cProdutId ) )
						
						RecLock( "SB5", .F. )
							SB5->B5_XPRDTID	:= _cProdutId														// Grava o Produto Pai
						SB5->( MsUnLock() )

						_aRegInteg[_nX][_nB5XPRDTID] := _cProdutId 												// Atualiza o Codigo gerado no Vetor
						_lRetorno := .T.					// Ajusta o Retorno para os proximos produtos caso tenha gerado algum erro no produto anterior

						// Monta a Msg do log para gravacao conforme os dados do produto
						_cMsg := "1-" 					+ StrZero( _nX, 8 ) 			+ " Produto Pai   - "
						_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
						_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
						_cMsg += " - Grava็ใo do C๓digo Linx no Produto Pai jแ integrado anteriormente."

						Aadd( _aRegLogOk, _cMsg )																// Registra o Log da Integracao com Sucesso
					Else
						// Monta a Msg do log para gravacao conforme os dados do produto
						_cMsg := "1-" 					+ StrZero( _nX, 8 ) 			+ " Produto Pai   - Falha na integra็ใo - "
						_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
						_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
						_cMsg += " - Falha na Grava็ใo do C๓digo Linx no Produto Pai jแ integrado anteriormente."
						Aadd( _aRegLogNo, _cMsg )																// Registra o Log da Falha da Integracao

						_lRetorno := .F.				// Ajusta o Retorno para os proximos produtos filho caso tenha gerado algum erro no produto Pai
					EndIf
				EndIf
				// Envia os dados do produto PAI. - ...Ate aqui

				// Limpa as variaveis para o envio do Produto FILHO
				_cHeadRet		:= ""
				_cPostRet		:= ""
				_aJsonFields	:= {}
				_nRetParser		:= 0
				_oJson			:= Nil
				_oJHashMap		:= Nil
				_xConteudo		:= Nil
				_cSkuIdFil		:= Space( _nTamSkuId )
				_cMsg			:= ""

				// Processa a Integracao do Filho se for op็ใo Produtos atraves da var de Retorno = .T. ou PREวOS
				// Envia os dados do produto FILHO. - Daqui...
				If _cOpcaoInt <>  "Precos"  .AND. (_lRetorno .or. lFilho)
					_cJSonFilho	:= MJsonFilho( _nX ) 										
					_cPostRet	:= HttpPost( _cUrlFilho, "", _cJSonFilho, _nTimeOut, _aHeadOut, @_cHeadRet ) 	// Chamada da integracao
					_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 
					_lRetorno 	:= IF(!EMPTY(_nTamRetJs),.T.,.F.)			
					_oJson		:= tJsonParser():New() 														// Cria o objeto para fazer parser do Json

					// Faz o Parser da mensagem JSon e extrai para Array (aJsonfields) e cria tambem um HashMap para os dados da mensagem (_oJHashMap)
					_lRetorno	:= _oJson:Json_Hash( _cPostRet, _nTamRetJs, @_aJsonFields, @_nRetParser, @_oJHashMap )

					If _lRetorno
						_lRetorno	:= HMGet( _oJHashMap, "ProductID", _xConteudo ) 						// Obtem o valor dos campos usando a chave

						// Tem que testar o _xConteudo diferente de ZERO, pois mesmo qdo o retorno do Post vem com ERRO a TAG "ProductID"
						// dentro do retorno do erro EH ZERO E O HMGet(...) DEVOLVE .T. devido a encontrar a TAG, mesmo que seja ZERO.
						_lRetorno := ( _xConteudo > 0 )
					Else
						// Monta a Msg do log de erro do _cPostRet
						_cMsg := "2-" 					+ StrZero( _nX, 8 ) 			+ " Produto Filho - " 	+ _cJSonFilho
						_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" 	+ _cProdutId + "] "
						_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" 	+ _cSkuIdFil + "]"
						_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
						Aadd( _aRegLogNo, _cMsg )															// Registra o Log da Falha da Integracao
					EndIf
					

					// Se for op็ใo PREวOS, pula para pr๓ximo item da integracao
					If _cOpcaoInt == "Precos"
						Loop
					EndIf

					If _lRetorno
						_cSkuIdFil	:= cvaltochar(_xConteudo)									// Guarda o codigo de retorno do Produto FILHO

						// Monta a Msg do log para gravacao conforme os dados do produto
						_cMsg := "2-" 				+ StrZero( _nX, 8 ) 			+ " Produto Filho - Integrado com Sucesso - "
						_cMsg += "Produto PAI [" 	+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
						_cMsg += "Produto FILHO [" 	+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"

						// Posiciona no Cad. Complemento de Produto para gravar o codigo gerado no Linx
						DbSelectArea( "SB5" )

						// Posiciona no registro
						DbGoTo( _aRegInteg[_nX][_nSB5RECNO] )

						// Valida se eh o mesmo produto integrado por garantia e se o codigo ainda nao foi gravado anteriormente
						If 	AllTrim( SB5->B5_COD ) == AllTrim( _aRegInteg[_nX][_nPB1COD] ) .and. ;
							( Empty( AllTrim( SB5->B5_XSKUID ) ) .or. SB5->B5_XSKUID == _cSkuIdFil )
							If Empty( AllTrim( SB5->B5_XSKUID ) )
								RecLock( "SB5", .F. )
									SB5->B5_XPRDTID	:= _cProdutId												// Tambem tem quer Gravar o Produto Pai
									SB5->B5_XSKUID	:= _cSkuIdFil												// Grava o Produto Filho
								SB5->( MsUnLock() )

								_aRegInteg[_nX][_nB5XPRDTID] 	:= _cProdutId 									// Atualiza o Codigo gerado no Vetor
								_aRegInteg[_nX][_nB5XSKUID] 	:= _cSkuIdFil 									// Atualiza o Codigo gerado no Vetor
							Else
								_cMsg += " - Altera็ใo de produto jแ integrado anteriormente."
							EndIf

							Aadd( _aRegLogOk, _cMsg )															// Registra o Log da Integracao com Sucesso

							// Grava o campo B1_MSEXP do Cad. de Produtos apos a integracao realizada com sucesso
							DbSelectArea( "SB1" )

							// Posiciona no registro
							DbGoTo( _aRegInteg[_nX][_nSB1RECNO] )

							// Valida se eh o mesmo produto integrado por garantia
							If AllTrim( SB1->B1_COD ) == AllTrim( _aRegInteg[_nX][_nPB1COD] )
								RecLock( "SB1", .F. )
									SB1->B1_MSEXP	:= DtoS( dDataBase )		// Grava a data atual
								SB1->( MsUnLock() )
							Else
								_cMsg += " - Falha na gravacao do campo B1_MSEXP - Produto: [" + cValToChar( _aRegInteg[_nX][_nPB1COD] ) + "]"
								Aadd( _aRegLogNo, _cMsg )														// Registra o Log da Falha da Integracao
							EndIf
						Else
							_cMsg += " - Falha na gravacao do campo B5_XSKUID: [" 	+ _cSkuIdFil 								+ "]"
							_cMsg += " - Produto: [" 								+ cValToChar( _aRegInteg[_nX][_nPB1COD] ) 	+ "]"
							Aadd( _aRegLogNo, _cMsg )															// Registra o Log da Falha da Integracao
						EndIf
					EndIf
					// Envia os dados do produto FILHO. - ...Ate aqui

					// Relacionamento entre Produtos Pai e Filho. - Daqui...
					// Somente depois de capturar os respectivos codigos retornados eh possivel montar o JSon para o relacionamento  
					If Empty( AllTrim( _cSkuIdFil ) ) .or. Empty( AllTrim( _cProdutId ) )
						// Monta a Msg do log para gravacao conforme os dados do produto com falha, Ambos, ou Pai, ou Filho. 
						If Empty( AllTrim( _cSkuIdFil ) ) .and. Empty( AllTrim( _cProdutId ) )
							_cMsg := "2-" + StrZero( _nX, 8 ) + " Produto Filho - Falha na integra็ใo - ID Produto 'Pai e Filho' nใo foram gerados - "
						Else
							_cMsg := Iif( Empty( AllTrim( _cProdutId ) ), "1", "2" ) + "-" + StrZero( _nX, 8 )
							_cMsg += " ID Produto '" 	+ Iif( Empty( AllTrim( _cProdutId ) ), "Pai", "Filho" ) + "' nใo foi gerado - "
						EndIf

						// Completa a Msg para gravacao do Log
						_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
						_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
						_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
						Aadd( _aRegLogNo, _cMsg )																// Registra o Log da Falha da Integracao
					Else
						_cJSonPaFi	:= MJsonPaFi( _cProdutId, _cSkuIdFil )
						_aHeadOut   :={}
						Aadd(_aHeadOut,"Content-Type: application/json")   
						Aadd(_aHeadOut,"Accept: application/json") 				
						Aadd(_aHeadOut,"Authorization: Basic " + _cAutentic)

						// Limpa as variaveis para o envio do Relacionamento entre o Produto Pai e Filho.
						_cHeadRet	:= ""

						// Envia os dados do Relacionamento entre o Produto Pai e Filho.
						_cPostRet := HttpPost( _cUrlPaFi, "", _cJSonPaFi, _nTimeOut, _aHeadOut, @_cHeadRet )

						// Faz uma validacao com tamanho da string de retorno para saber se houve falha
						_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 								// Gera o tamanho da string do retorno

						If _nTamRetJs > 0
							_cMsg := "3-" 					+ StrZero( _nX, 8 ) + " Relacionamento entre os produtos Pai e Filho efetivado com sucesso - "
							_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
							_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
							_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
							Aadd( _aRegLogOk, _cMsg )															// Registra o Log da Integracao com Sucesso
						Else
							_cMsg := "3-" 				+ StrZero( _nX, 8 ) + " Nใo foi possํvel efetivar o relacionamento entre os produtos Pai e Filho - "
							_cMsg += "Produto PAI [" 	+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
							_cMsg += "Produto FILHO [" 	+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
							_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
							Aadd( _aRegLogNo, _cMsg )															// Registra o Log da Falha da Integracao
						EndIf
					EndIf

					// Tem que gerar dados do Estoque somente para o Filho. - Daqui...
					If ! Empty( AllTrim( _cSkuIdFil ) )
						// Limpa as variaveis para o envio dos dados do Estoque Minimo.
						_cHeadRet	:= ""

						// Envia os dados do Estoque Minimo. - Daqui...
						_cJSonEstq	:= MJsonChEst( _cSkuIdFil ) 													// Monta JSon Grava Estoque do Produto
						_cPostRet	:= HttpPost( _cUrlEstq, "", _cJSonEstq, _nTimeOut, _aHeadOut, @_cHeadRet )

						// Faz uma validacao com tamanho da string de retorno para saber se houve falha
						_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 								// Gera o tamanho da string do retorno

						If _nTamRetJs > 0
							_cMsg := "4-" 					+ StrZero( _nX, 8 ) + " Estoque Minํmo para o produto Filho efetivado com sucesso - "
							_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
							_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
							_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
							Aadd( _aRegLogOk, _cMsg )															// Registra o Log da Integracao com Sucesso
						Else
							_cMsg := "4-" 					+ StrZero( _nX, 8 ) + " Nใo foi possํvel efetivar o Estoque Minํmo para o produto Filho - "
							_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
							_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
							_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
							Aadd( _aRegLogNo, _cMsg )															// Registra o Log da Falha da Integracao
						EndIf
						// Envia os dados do Estoque Minimo. - ...Ate aqui

						// Limpa as variaveis para o envio dos dados do Saldo Em Estoque.
						_cHeadRet	:= ""

						// Tem que gerar os dados do Saldo Em Estoque. - Daqui...
						_cJSonChEs	:= MJsonChEst( _cSkuIdFil )
						_cPostRet	:= HttpPost( _cUrlChEst, "", _cJSonChEs, _nTimeOut, _aHeadOut, @_cHeadRet )

						// Faz uma validacao com tamanho da string de retorno para saber se houve falha
						_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 								// Gera o tamanho da string do retorno

						If _nTamRetJs > 0
							_cMsg := "5-" 					+ StrZero( _nX, 8 ) + " Saldo Em Estoque para o produto Filho efetivado com sucesso - "
							_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
							_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
							_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
							Aadd( _aRegLogOk, _cMsg )															// Registra o Log da Integracao com Sucesso
						Else
							_cMsg := "5-" 					+ StrZero( _nX, 8 ) + " Nใo foi possํvel efetivar o Saldo Em Estoque para o produto Filho - "
							_cMsg += "Produto PAI [" 		+ _aRegInteg[_nX][_nPB5XPAI] 	+ "] C๓digo Linx [" + _cProdutId + "] "
							_cMsg += "Produto FILHO [" 		+ _aRegInteg[_nX][_nPB1COD] 	+ "] C๓digo Linx [" + _cSkuIdFil + "]"
							_cMsg += " - Retorno do Post: " + cValToChar( _cPostRet ) // Registra, tb, o retorno do HttpPost para tentar facilitar entendimento
							Aadd( _aRegLogNo, _cMsg )															// Registra o Log da Falha da Integracao
						EndIf
						// Tem que gerar os dados do Saldo Em Estoque. - ...Ate aqui
					EndIf
					// Tem que gerar dados do Estoque somente para o Filho. - ...Ate aqui
				ELSEIF _cOpcaoInt== "Precos"
					_cJSonPrc	:= MJsonPRC( _nX,_cTabPrc ) 
					_cPostRet	:= HttpPost( _cUrlPrc, "", _cJSonPrc, _nTimeOut, _aHeadOut, @_cHeadRet ) 	// Chamada da integracao
					_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 
					_lRetorno 	:= IF(!EMPTY(_nTamRetJs),.T.,.F.)			
					_oJson		:= tJsonParser():New() 														// Cria o objeto para fazer parser do Json

					// Faz o Parser da mensagem JSon e extrai para Array (aJsonfields) e cria tambem um HashMap para os dados da mensagem (_oJHashMap)
					_lRetorno	:= _oJson:Json_Hash( _cPostRet, _nTamRetJs, @_aJsonFields, @_nRetParser, @_oJHashMap )		
				ENDIF

			Next _nX

			// Registra o Final do Log do processamento dos Produtos
			// GRAVALOG( cPath, cRotina	, cTxtLog											 , _lInfConex, _lLstPilha, _lUsrConex )
			GRAVALOG( _cPath	, "Final  - Log do processamento dos Produtos" + CRLF)

		// Registra o Inicio do Log da Integracao com Sucesso
			// GRAVALOG( cPath, cRotina	, cTxtLog											, _lInfConex, _lLstPilha, _lUsrConex )
			GRAVALOG( _cPath, "Inicio - Log dos Produtos Integrados com Sucesso"	)

			If Len( _aRegLogOk ) == 0
				// Registra o Final do Log da Integracao com Sucesso
				// GRAVALOG( _cPath, cRotina	, cTxtLog												, _lInfConex, _lLstPilha, _lUsrConex )
				GRAVALOG( _cPath	, "       - Nao houve produtos integrados com sucesso."	)
			Else
				// Ordena os registros pela msg para melhorar a visualizacao do Log
				aSort( _aRegLogOk,,, { |x, y| x < y } )

				For _nX := 1 To Len( _aRegLogOk )
					// Registra o Log da Integracao, sem os 11 caracteres iniciais utilizados para a ordenacao
					// GRAVALOG( _cPath, cRotina	, cTxtLog														 , _lInfConex, _lLstPilha, _lUsrConex )
					GRAVALOG( _cPath 	, Substr( _aRegLogOk[_nX], 12, ( Len( _aRegLogOk[_nX] ) - 11 ) ))
				Next _nX
			EndIf

			// Registra o Final do Log da Integracao com Sucesso
			// GRAVALOG( _cPath, cRotina	, cTxtLog													, _lInfConex, _lLstPilha, _lUsrConex )
			GRAVALOG( _cPath	, "Final  - Log dos Produtos Integrados com Sucesso" + CRLF	)
	

			// Registra o Inicio do Log das Falhas de Integracao
			// GRAVALOG( _cPath, cRotina	, cTxtLog											 , _lInfConex, _lLstPilha, _lUsrConex )
			GRAVALOG( _cPath	, "Inicio - Log dos Produtos com Falha na Integracao")

			If Len( _aRegLogNo ) == 0
				// Registra o Final do Log das Falhas de Integracao
				// GRAVALOG( _cPath, cRotina	, cTxtLog												, _lInfConex, _lLstPilha, _lUsrConex )
				GRAVALOG( _cPath	, "       - Nao houve produtos com falha na integracao.")
			Else
				// Ordena os registros pela msg para melhorar a visualizacao do Log
				aSort( _aRegLogNo,,, { |x, y| x < y } )

				For _nX := 1 To Len( _aRegLogNo )
					// Registra o Log da Integracao, sem os 11 caracteres iniciais utilizados para a ordenacao
					// GRAVALOG( _cPath, cRotina	, cTxtLog														 , _lInfConex, _lLstPilha, _lUsrConex )
					GRAVALOG( _cPath	, Substr( _aRegLogNo[_nX], 08, ( Len( _aRegLogNo[_nX] ) - 07 ) ))
				Next _nX
			EndIf

			// Registra o Final do Log das Falhas de Integracao
			// GRAVALOG( _cPath, cRotina , cTxtLog												, _lInfConex, _lLstPilha, _lUsrConex )
			GRAVALOG( _cPath, "Final  - Log dos Produtos com Falha na Integracao"	)

			// Registra o Final do Processamento
			// GRAVALOG( _cPath, cRotina , cTxtLog					 , _lInfConex, _lLstPilha, _lUsrConex )
			GRAVALOG( _cPath, "Fim do Processamento...")

			ApMsgInfo( "Processamento finalizado." + CRLF + "Favor avaliar as inforna็๕es da integra็ใo.", "Aten็ใo..." )

		ElseIf _lConfirma .and. _nSelecao == 0
			ApMsgInfo( "Nใo hแ registros selecionados para integra็ใo." + CRLF + "Favor Verificar.", "Aten็ใo..." )
		EndIf
	EndDo
EndIf

RestArea( _aArea )

return

static function MJsonPRC(_nReg,cTabPrc)
Local _aArea		:= GetArea()
Local cjson			:= "" 
// Monta as variaveis que serao usadas para todos os produtos.
Local _nPreco		:= _aRegInteg[_nReg][_nPDA1PRCVEN] 	
Local _cSkuIdFil	:= _aRegInteg[_nReg][_nB5XSKUID] 		
Local cData  		:= '/Date('+LEFT(DTOS(dDatabase),4)+'-'+SUBSTRING(DTOS(dDatabase),5,2)+'-'+RIGHT(DTOS(dDatabase),2)+' '+left(Time(),2)+':'+substring(Time(),4,2)+':'+right(Time(),2)+')/'
Local cTabPrc 		:= Posicione('DA0',1,xFilial('DA0')+cTabPrc,'DA0_XGRUPO' )

cjson:='{'
cjson+='"PriceListID":'+cTabPrc+','
cjson+='"ProductID": '+_cSkuIdFil+','
cjson+='"IsNewPrice": true,'
cjson+='"Value": '+cvaltochar(_nPreco)+ ','
cjson+='"IsNewPromoPrice": false,'
cjson+='"PromoPrice": 0 ,'
cjson+='"PromoFrom": "\/Date(1682679600000-0300)\/",'
cjson+='"PromoTo": "\/Date(1685329140000-0300)\/",'
cjson+='"PriceListIntegrationID": "1"'
cjson+='}'

RETURN cjson

Static Function MJsonPai( _nReg )

Local _aArea		:= GetArea()
Local _cJSonPai		:= "" 

// Monta as variaveis que serao usadas para todos os produtos.
Local _cSkuProd		:= AllTrim( _aRegInteg[_nReg][_nPB5XPAI] ) 					// Campo usado = B5_XPAI
Local _cSkuFilho	:= AllTrim( _aRegInteg[_nReg][_nPB1COD] ) 					// Campo usado = B1_COD
Local _cNameProd	:= AllTrim( _aRegInteg[_nReg][_nPB1DESC] ) 				// Campo usado = B5_XNOMPAI
Local _cTitPage		:= AllTrim( _aRegInteg[_nReg][_nB5ECTITU] ) 				// Campo usado = B5_ECTITU  = PageTitle no Linx
Local _cDesCurta	:= AllTrim( _aRegInteg[_nReg][_nB5ECAPRES] ) 				// Campo usado = B5_ECAPRES = DESC_CURTA
Local _cDesLonga	:= AllTrim( _aRegInteg[_nReg][_nB5ECDESCR] ) 				// Campo usado = B5_ECDESCR = DESC_LONGA = Descricao Longa no Linx
Local _cEspCarac	:= AllTrim( _aRegInteg[_nReg][_nB5ECCARAC] ) 				// Campo usado = B5_ECCARAC = DESC_ESPEC = Especificacao no Linx
Local _cMetaDesc	:= AllTrim( _aRegInteg[_nReg][_nB5ECINDIC] ) 				// Campo usado = B5_ECINDIC = Meta Description no Linx
Local _cMetaKeyW	:= AllTrim( _aRegInteg[_nReg][_nB5ECPCHAV] ) 				// Campo usado =  B5_ECPCHAV = Meta KeyWords no Linx
Local _cCategor   	:= AllTrim( _aRegInteg[_nReg][_nIDCATEG] ) 					// Campo usado =  ACU_XIDLIN = ID DA CATEGORIA
Local _cMarca		:= AllTrim( _aRegInteg[_nReg][_nIDMARCA] ) 					// Campo usado =  B5_XMARCA = ID DA MARCA
Local _cProdutId	:= _aRegInteg[_nReg][_nB5XPRDTID] 							// Posicao do Campo B5_XPRDTID = PRODUCT ID Linx = Produto Pai
Local _nPos			:= 0														// Var para definicao da categoria correspondente
Local cData  := '/Date('+LEFT(DTOS(dDatabase),4)+'-'+SUBSTRING(DTOS(dDatabase),5,2)+'-'+RIGHT(DTOS(dDatabase),2)+' '+left(Time(),2)+':'+substring(Time(),4,2)+':'+right(Time(),2)+')/'

// Monta a URL Amigavel com os campos B5_XPAI + B5_XNOMPAI
// Originalmente, haviamos utilizado a regra: Campo B5_XNOMPAI SEM OS ESPACOS, Porem, identificamos que temos varios produtos com a mesma
// informacao no campo B5_XNOMPAI e ao efetuar a integracao retornava erro que a URL AMIGAVEL ja estava sendo usada por outro produto.
Local _cUrlAmig		:= StrTran( _cSkuProd , " ", "-" ) 				// Campo usado 	= B5_XPAI + B5_XNOMPAI COM OS ESPACOS ALTERADOS PARA hifen

// INICIO DO JSON
_cJSonPai := "" 	+ CRLF 						// ATENCAO: Para a integracao referente ao SaveProduct = Produto Pai, eh necessaria esta linha
_cJSonPai += '{' 	+ CRLF

If Empty( AllTrim( _cProdutId ) )
 	// Se for VAZIO, tem que enviar 0 para garantir a INCLUSAO no LINX
	_cJSonPai += '"ProductID": ' 				+ "0" 						+ ',' 					+ CRLF
Else
	// Se tiver o Codigo Linx (ProductId) indica que eh alteracao
	_cJSonPai += '"ProductID": ' 				+  _cProdutId  	+ ',' 								+ CRLF
	_cJSonPai += '"IntegrationID": "' 				+ _cSkuProd 	+ '",' 								+ CRLF
EndIf
_cJSonPai += '"ProductType": 1,' 																	+ CRLF
_cJSonPai += '"SKU": "' 						+ cValToChar( _cSkuProd ) 	+ '",' 					+ CRLF 		// Codigo do Produto Pai / Sku
_cJSonPai += '"ProductInventory": {' 																+ CRLF
_cJSonPai += '"InventoryDisplaying": {' 															+ CRLF
_cJSonPai += '"DisplayStockQty": false,' 															+ CRLF
_cJSonPai += '"DisplayAvailability": "N"' 															+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"Inventory": {' 																		+ CRLF
_cJSonPai += '"ForceOutOfStock": false' 															+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"ProductDetails": {' 																	+ CRLF
_cJSonPai += '"General": {' 																		+ CRLF
_cJSonPai += '"Name": "' 						+ _cNameProd 	+ '",' 								+ CRLF 		// Nome do Produto Pai
_cJSonPai += '"BrandID":"'						+ _cMarca 	+ '",' 									+ CRLF
_cJSonPai += '"Categories": [' 																		+ CRLF
_cJSonPai += '{' 																					+ CRLF
_cJSonPai += '"CategoryID": ' 					+ _cCategor 	+ ',' 								+ CRLF 		// Categoria
_cJSonPai += '"IsMain": true' 																		+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += ']' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"GeneralDisplaying": {' 																+ CRLF
_cJSonPai += '"IsVisible": true,' 																	+ CRLF
_cJSonPai += '"VisibleFrom": "'     +cData+		'",' 												+ CRLF
_cJSonPai += '"IsSearchable": true,' 																+ CRLF
_cJSonPai += '"IsUponRequest": false' 																+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"SkuDetails": {' 																		+ CRLF
_cJSonPai += '"IntegrationID": "' 				+ _cSkuProd 	+ '",' 								+ CRLF 		// REPETE: Codigo do Produto Pai / Sku
_cJSonPai += '"Name": "' 						+ _cNameProd 	+ '",' 								+ CRLF 		// REPETE: Nome do Produto Pai
_cJSonPai += '"ProductDefinitionID": 24 ' 															+ CRLF
_cJSonPai += '} ' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"ProductDescriptions": {' 															+ CRLF
_cJSonPai += '"SeoDescription": {' 																	+ CRLF

If ! Empty( AllTrim(  _cTitPage  ) )
	_cJSonPai += '"PageTitle": "' 				+ STRTRAN(EnCodeUtf8( AllTrim(  _cTitPage  ) ),ENTER,'') 		+ '",' 	+ CRLF 		// Campo usado = B5_ECTITU
Else
	_cJSonPai += '"PageTitle": "",' 																+ CRLF 		// Campo usado = B5_ECTITU
EndIf
_cJSonPai += '"UrlFriendly": "' 				+ _cUrlAmig 								+ '",' 	+ CRLF		// URL Amigavel
/*If ! Empty( AllTrim(  _cMetaDesc  ) )
_cMetaDesc:=PADR(STRTRAN(EnCodeUtf8( AllTrim(  _cMetaDesc  ) ),ENTER,''),197)+"..."
	_cJSonPai += '"MetaDescription": "' 		+ _cMetaDesc								+'",' 	+ CRLF		// Meta Description
Else*/
	_cJSonPai += '"MetaDescription": "",' 															+ CRLF		// Meta Description
//EndIf
If ! Empty( AllTrim(  _cMetaKeyW  ) )
	_cJSonPai += '"MetaKeywords": "' 			+  EnCodeUtf8( AllTrim( _cMetaKeyW ) ) 		+ '" ' 	+ CRLF		// Meta KeyWords
Else
	_cJSonPai += '"MetaKeywords": "" ' 																+ CRLF		// Meta KeyWords
EndIf
_cJSonPai += '},' 																			 		+ CRLF
_cJSonPai += '"Description": {' 																	+ CRLF
If ! Empty( AllTrim(  _cDesCurta  ) )
	_cDesCurta:=PADR(STRTRAN(EnCodeUtf8( AllTrim(  _cDesCurta  ) ),ENTER,''),197)+"..."
	_cJSonPai += '"ShortDescription": "' 		+ _cDesCurta   								+ '",' 	+ CRLF 		// Descricao Curta
Else
	_cJSonPai += '"ShortDescription": "",' 															+ CRLF 		// Descricao Curta
EndIf

If ! Empty( AllTrim(  _cDesLonga  ) )
	_cJSonPai += '"LongDescription": "' 		+  STRTRAN(EnCodeUtf8( AllTrim(  _cDesLonga  ) ),ENTER,'') 	+ '",' 	+ CRLF 		// Descricao Longa
Else
	_cJSonPai += '"LongDescription": "",' 															+ CRLF 		// Descricao Longa
EndIf

_cJSonPai += '"WarrantyDescription": "'+  STRTRAN(EnCodeUtf8( AllTrim(  _cEspCarac  ) ),ENTER,'') 	+ '"' 	+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"TagSearch": {' 																		+ CRLF
_cJSonPai += '"SearchKeywords": ""' 																+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"ProductMisc": {' 																	+ CRLF
_cJSonPai += '"AcceptanceTerm": {' 																	+ CRLF
_cJSonPai += '"UseAcceptanceTerm": false,' 															+ CRLF
_cJSonPai += '"AcceptanceTermID": 0' 																+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"Rating": {' 																			+ CRLF
_cJSonPai += '"RatingSetID": 1' 																	+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"ProductPrice": {' 																	+ CRLF
_cJSonPai += '"Pricing": {' 																		+ CRLF
_cJSonPai += '"DisplayPrice": "Y"' 																	+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"ProductShipping": {' 																+ CRLF
_cJSonPai += '"ShippingRegion": {' 																	+ CRLF
_cJSonPai += '"IsFreeShipping": false' 																+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '},' 																					+ CRLF
_cJSonPai += '"ProductExtended": {' 																+ CRLF
_cJSonPai += '"Extended": {' 																		+ CRLF
_cJSonPai += '"ExtendedExtensions": [' 																+ CRLF
_cJSonPai += '{' 																					+ CRLF
_cJSonPai += '"ID": 0,' 																			+ CRLF
_cJSonPai += '"Name": "string",' 																	+ CRLF		
_cJSonPai += '"Value": ""' 																			+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += ']' 																					+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '}' 																					+ CRLF
_cJSonPai += '}'

// Registra o JSON PAI PARA VALIDACAO DO JSON
GRAVALOG( _cPath, _cJSonPai)

RestArea( _aArea )

Return  _cJSonPai


//--------------------------------------------------------------------------------------------------------------
Static Function MJsonFilho( _nReg )

Local _lOk			:= .T.				// Indica se o JSon foi montado corretamente qdo .T. ou nao qdo .F.
Local _aRet			:= { "", .T. }		// Variavel de retorno, a primeira eh o JSon montado ou a msg de erro, a Segunda indica se houve erro ou nao 
Local _cJSonFilh	:= ""
Local _nPos			:= 0

// Monta as variaveis que serao usadas para todos os produtos.
Local _cProdPai		:= AllTrim( _aRegInteg[_nReg][_nPB5XPAI] ) 								// Campo usado 							= B5_XPAI
Local _cSkuFilho	:= AllTrim( _aRegInteg[_nReg][_nPB1COD] ) 								// Campo usado 							= B1_COD
Local _cDescProd	:= AllTrim( _aRegInteg[_nReg][_nPB1DESC] ) 								// Campo usado 							= B1_DESC
Local _nPreco		:= _aRegInteg[_nReg][_nPDA1PRCVEN] 										// Preco 								= DA1_PRCVEN
Local _nPeso		:= _aRegInteg[_nReg][_nPB1PESO] 										// PESO 	 							= B1_PESO
Local _nLarg		:= _aRegInteg[_nReg][_nLargura] 										// Largura 								= B5_LARG
Local _nAltu		:= _aRegInteg[_nReg][_nAltura] 											 // Altura 								= B5_ESPESS
Local _nProf		:= _aRegInteg[_nReg][_nProfundi] 										// Profundidade / Comprimento 			= B5_COMPR
Local _cSkuIdFil	:= _aRegInteg[_nReg][_nB5XSKUID] 										// Posicao do Campo B5_XSKUID = SKU ID Linx = Produto Filho
Local _cEanProd		:= AllTrim( _aRegInteg[_nReg][_nLKCODBAR] ) 							// Campo usado - EAN 					= LK_CODBAR
Local _nPrzMinim	:= 0																	// Prazo Minimo para Entrega com Saldo Em Estoque = 48hr
Local _nPrSemSld	:= 10

_cJSonFilh := '{' 																	+ CRLF
_cJSonFilh += '"StockKeepUnitDetails":{'											+ CRLF
_cJSonFilh += '"SkuDetails":{'														+ CRLF
_cJSonFilh += '"VariationProperties":{' 											+ CRLF
_cJSonFilh += '"PropertyMetadataID": 40,' 											+ CRLF
_cJSonFilh += '"PropertyMetadataValue": "String content",'							+ CRLF		
_cJSonFilh +=' "Value": { ' 														+ CRLF
_cJSonFilh +=' "anyType": {  '														+ CRLF
_cJSonFilh +=' "anyType": { '														+ CRLF
_cJSonFilh += ' "anyType": null  '													+ CRLF
_cJSonFilh += ' } ' 																+ CRLF
_cJSonFilh += ' } ' 																+ CRLF
_cJSonFilh += ' }, ' 																+ CRLF
_cJSonFilh += '"ID": 2147483647,' 													+ CRLF
_cJSonFilh += '"Name": "String content"' 											+ CRLF
_cJSonFilh += ' }, ' 																+ CRLF
_cJSonFilh += ' "ProductDefinitionID": 24, ' 										+ CRLF
_cJSonFilh += '   "Suppliers": [1], ' 												+ CRLF
//_cJSonFilh += ' "IntegrationID":"'+ _cProdPai+ '",' 								+ CRLF 	// Codigo do Produto Pai / Sku
_cJSonFilh += '  "SKU":"'+ _cSkuFilho+ '",' 										+ CRLF 	// Codigo do Produto FILHO
_cJSonFilh += '  "Name":"'+ _cDescProd+ '"' 										+ CRLF 	// Descricao do Produto FILHO
_cJSonFilh += ' }, ' 																+ CRLF
_cJSonFilh += '"GeneralDisplaying":{'												+ CRLF
_cJSonFilh += '"IsVisible":true,'													+ CRLF
_cJSonFilh += '"VisibleFrom":"/Date(1580353200)/",'									+ CRLF
_cJSonFilh += '"IsSearchable":true,'												+ CRLF
_cJSonFilh += '"IsUponRequest":true'												+ CRLF
_cJSonFilh += '}'																	+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"StockKeepUnitShipping":{'											+ CRLF
_cJSonFilh += '"Dimension":{'														+ CRLF
_cJSonFilh += '"Weight":' 						+ cValToChar( _nPeso 		) + ','	+ CRLF 	// Peso
_cJSonFilh += '"Width":' 						+ cValToChar( _nLarg 	) + ','	+ CRLF 	// Largura
_cJSonFilh += '"Height":' 						+ cValToChar( _nAltu 		) + ','	+ CRLF 	// Altura
_cJSonFilh += '"Depth":' 						+ cValToChar( _nProf 	) + ''	+ CRLF 	// Profundidade / Comprimento
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"Delivery":{'														+ CRLF
_cJSonFilh += '"ShipsIndividually":false,'											+ CRLF
_cJSonFilh += '"IsDeliverable":true'												+ CRLF
_cJSonFilh += '}'																	+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"StockKeepUnitExtended": null,'										+ CRLF
_cJSonFilh += '  "StockKeepUnitInventory": {'										+ CRLF
_cJSonFilh += '    "Backorder": {'													+ CRLF
_cJSonFilh += '"BackorderLimit": 0,'												+ CRLF
_cJSonFilh += '      "Backorderable": false'										+ CRLF
_cJSonFilh += '    },'																+ CRLF
_cJSonFilh += '"Purchase":{'														+ CRLF
_cJSonFilh += '"MinimumQtyAllowed":1,'												+ CRLF
_cJSonFilh += '"MaximumQtyAllowed":0'												+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"Preorder": {'														+ CRLF
_cJSonFilh += '      "Preorderable": false'											+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"SkuInventoryDisplaying":{'											+ CRLF
_cJSonFilh += '"EstimatedReorderDate": "/Date(1687829582-0300)/"'					+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"SkuInventory":{'													+ CRLF
_cJSonFilh += '"ManageStock":true,'													+ CRLF
_cJSonFilh += '"Replenishment":0,'													+ CRLF	// 0=Normal e 2=Descontinuado
_cJSonFilh += '"ForceOutOfStock":false,'											+ CRLF
_cJSonFilh += '"NotifyReorderPoint":true,'											+ CRLF
_cJSonFilh += '"ReorderPoint":1,'													+ CRLF
_cJSonFilh += '"DisableOnReorderPoint":false'										+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"Handling":{'														+ CRLF
_cJSonFilh += '"InStockHandlingDays":' 			+ cValToChar( _nPrzMinim ) + ','	+ CRLF	// Prazo Minimo para Entrega COM Saldo Em Estoque = 48hr
_cJSonFilh += '"OutStockHandlingDays":' 		+ cValToChar( _nPrSemSld ) + ''		+ CRLF 	// Prazo para Entrega SEM Saldo Em Estoque
_cJSonFilh += '}'																	+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"StockKeepUnitMisc":{'												+ CRLF
_cJSonFilh += '"SkuMisc":{'															+ CRLF
_cJSonFilh += '"DisplayCondition":false,'											+ CRLF
_cJSonFilh += '"WrappingQty":1,'													+ CRLF 	// Qtde por Embalagem. Sempre 1.
_cJSonFilh += '"UomID":6,'															+ CRLF
_cJSonFilh += '"UPC":"' 						+ cValToChar( _cEanProd ) 	+ '",'	+ CRLF 	// Codigo EAN do produto
_cJSonFilh += '"ProductConditionID":1'												+ CRLF
_cJSonFilh += '}'																	+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"StockKeepUnitPrice":{'												+ CRLF
_cJSonFilh += '"Promotion":{'														+ CRLF
_cJSonFilh += '"IsPromo":false,'													+ CRLF
_cJSonFilh += '"DisplayPromoOnlyCheckout": false,'									+ CRLF
_cJSonFilh += '"DenyPromo": false'													+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"SkuPricing":{'														+ CRLF
//_cJSonFilh += '"Price":' 						+ cValToChar( _nPreco ) 	+ ','	+ CRLF 	// Preco do Produto Filho
_cJSonFilh += '"Price":0, '	+ CRLF 	// Preco do Produto Filho
_cJSonFilh += '"Cost":0,'															+ CRLF
_cJSonFilh += '"Tax":0'																+ CRLF
_cJSonFilh += '}'																	+ CRLF
_cJSonFilh += '},'																	+ CRLF
_cJSonFilh += '"ProductType": 1,'													+ CRLF
If Empty( AllTrim( _cSkuIdFil ) )
 	// Se for VAZIO, tem que enviar 0 para garantir a INCLUSAO no LINX
	_cJSonFilh += '"ProductID": '+ "0" 						+ ',' 					+ CRLF
Else
	// Se tiver o Codigo Linx (ProductId) indica que eh alteracao
	_cJSonFilh += '"ProductID": '+  alltrim(_cSkuIdFil)+ ','						+ CRLF
EndIf
_cJSonFilh += '"SKU":"'+ _cSkuFilho+ '"'											+ CRLF
_cJSonFilh += '}'																	+ CRLF


// Registra o JSON FILHO PARA VALIDACAO DO JSON
// GRAVALOG( _cPath , cRotina, cTxtLog, _lInfConex, _lLstPilha, _lUsrConex )
GRAVALOG( _cPath,  _cJSonFilh )


Return _cJSonFilh


//--------------------------------------------------------------------------------------------------------------
Static Function MJsonPaFi( _cProdutId, _cSkuIdFil )

Local _cJSonPaFi := ""

DEFAULT _cProdutId	:= ""
DEFAULT _cSkuIdFil	:= ""

If Empty( AllTrim( _cProdutId ) ) .or. Empty( AllTrim( _cSkuIdFil ) )
	ApMsgInfo( Iif( Empty( AllTrim( _cSkuIdFil ) ), "SKU do Produto Filho nใo foi informado.", "ID Produto 'Pai' nใo foi informado." ), "KSECOA10 - MJsonPaFi - Aten็ใo..." )
Else
	_cJSonPaFi	:= '{"SkuID":'
	_cJSonPaFi	+=  _cSkuIdFil 
	_cJSonPaFi	+=  ',"ProductID":'
	_cJSonPaFi	+=  _cProdutId 
	_cJSonPaFi	+= ' }'
EndIf

Return _cJSonPaFi


//--------------------------------------------------------------------------------------------------------------
Static Function MJsonChEst( _cProdutId )

Local _cJSonChEst	:= ""

DEFAULT _cProdutId	:= ""

If Empty( AllTrim( _cProdutId ) )
	ApMsgInfo( "Id Produto nใo informado." , "KSECOA10 - MJsonChEst - Aten็ใo..." )
Else
	_cJSonChEst := '{'
	_cJSonChEst += '"ProductID":"' 		+  _cProdutId  + '",'
	_cJSonChEst += '"WarehouseID": 1,'
	_cJSonChEst += '"Quantity": 50,' 														// Qtde Em Estoque
	_cJSonChEst += '"ActionEnum": "2",'
	_cJSonChEst += '"InventoryMovementTypes": 1'
	_cJSonChEst += '}'
EndIf

Return _cJSonChEst


//--------------------------------------------------------------------------------------------------------------
Static Function MJsonEstq( _cProdutId )

Local _cJSonEstq	:= ""

// Variaveis referentes aos prazos de entrega dos produtos
// PRECISAMOS DEFINIR QUAL REGRA UTILIZAR. No ERP, tem o campo do prazo
// para cada fornecedor e regras definidas na funcao KSDtEntr.
Local _nPrzMinim	:= 0																	// Prazo Minimo para Entrega com Saldo Em Estoque = 48hr

DEFAULT _cProdutId	:= ""

If Empty( AllTrim( _cProdutId ) )
	ApMsgInfo( "Dados do Produto nใo foram informados." , "KSECOA10 - MJsonEstq - Aten็ใo..." )
Else
	_cJSonEstq := '{'
	_cJSonEstq += '"ActionEnum":0,'
	_cJSonEstq += '"InStockHandlingDays":' 				+ cValToChar( _nPrzMinim ) + ','	// Prazo Minimo para Entrega COM Saldo Em Estoque = 48hr
	_cJSonEstq += '"IntegrationID":"String content",'
	_cJSonEstq += '"InventoryMovementTypes":32767,'                  
	_cJSonEstq += '"ProductID":' 						+ cValToChar( _cProdutId ) 	+ ',' 	// ProductID
	_cJSonEstq += '"Quantity":100,'
	_cJSonEstq += '"ReorderPoint":2,' 														// Estoque Minimo
	_cJSonEstq += '"SKU":"",'
	_cJSonEstq += '"WarehouseID":1,'
	_cJSonEstq += '"WarehouseIntegrationID":"",'
	_cJSonEstq += '"QueueItemID":"1627aea5-8e0a-4371-9022-9b504344e724"'
	_cJSonEstq += '}'
EndIf

Return _cJSonEstq


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Empresa  ณ SalonLine			                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Funcao   ณ Gravalog  ณ Autor ณ                 ณ Data ณ               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  													      |ฑฑ
ฑฑณ			 | 										               		  |ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SALON LINE                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

static function Gravalog(cFile,cText)

local nHandle

cText += chr(13) + chr(10)

if !file(cFile)
    if (nHandle := fCreate(cFile, 1)) = -1
        Conout("Arquivo nao foi criado: ("+cFile+")")
    else
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif
else
    
    nHandle := fOpen(cFile, 2)
    nLength := fSeek(nHandle, 0, 2)
    
    if nLength+len(cText)>=1048580
        
        fClose(nHandle)
        
        IF fRename(cFile, cFile+"."+dtos(date())+"-"+alltrim(str(seconds()))) = -1
            Conout("Arquivo nao foi renomeado: ("+cFile+")")
        endif
        
        gravalog(cFile,cText)
        
    endif
    
    if fError() != 0
        Conout("Arquivo nao foi aberto: ("+cFile+")")
    else
        cText := fReadStr(nHandle,nLength) + cText
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif
endif

return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษอออออออออออัออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ _fBLine   บ Autor ณ                       บ Data ณ            บฑฑ
ฑฑฬอออออออออออุออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Descricao ณ Funcao para montagem da BLine do ListBox da te็a.             บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ 				                                             บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function _fBLine()

Local _cRet	:= "{ || { "
// 37=Status, 01=Produto Pai, 02=Descricao, 04=Sku Filho, 05=Descricao, 07=Preco Venda
_cRet += "_fStatus(), "
_cRet += "_aRegInteg[_oRegInteg:nAt][" 				+ AllTrim( Str( _nPB5XPAI 		) ) + "], "
_cRet += "_aRegInteg[_oRegInteg:nAt][" 				+ AllTrim( Str( _nPB1COD 		) ) + "], "
_cRet += "_aRegInteg[_oRegInteg:nAt][" 				+ AllTrim( Str( _nPB1DESC 		) ) + "], "
_cRet += "_aRegInteg[_oRegInteg:nAt][" 				+ AllTrim( Str( _nB5XPRDTID 	) ) + "], "  
_cRet += "_aRegInteg[_oRegInteg:nAt]["				+ AllTrim( Str( _nB5XSKUID 		) ) + "], "
_cRet += "_aRegInteg[_oRegInteg:nAt]["				+ AllTrim( Str( _nACUCOD 		) ) + "], "
_cRet += "_aRegInteg[_oRegInteg:nAt][" 				+ AllTrim( Str( _nACUDESC 		) ) + "], "
_cRet += "_aRegInteg[_oRegInteg:nAt][" 				+ AllTrim( Str( _nLKCODBAR 		) ) + "], "
_cRet += "Transform(_aRegInteg[_oRegInteg:nAt]["	+ AllTrim( Str( _nPDA1PRCVEN 	) ) + "],'@E 999,999.99') "
_cRet += " } } "

Return _cRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษอออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ _fStatus   บ Autor ณ                       บ Data ณ            บฑฑ
ฑฑฬอออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Descricao ณ Funcao para apresentar a Situacao.                             บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ 	 				                                           บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Opcao     ณ Posicao 1 do vetor = Situacao / Status:                        บฑฑ
ฑฑบ           ณ  0 = Nao Marcado	- UNCHECKED	  - _oNo                       บฑฑ
ฑฑบ           ณ  1 = Marcado		- CHECKED	  - _oOk                       บฑฑ
ฑฑบ           ณ  2 = Registro Duplicado ou faltando Informacao nao integra     บฑฑ
ฑฑบ           ณ                     - BR_VERMELHO - _oVermelho                 บฑฑ 
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function _fStatus()

Local _oRet := _oNo

If _aRegInteg[_oRegInteg:nAt][_nPosStat] == "0"
	_oRet := _oNo
ElseIf _aRegInteg[_oRegInteg:nAt][_nPosStat] == "1"
	_oRet := _oOk
ElseIf _aRegInteg[_oRegInteg:nAt][_nPosStat] == "2"
	_oRet := _oVermelho
EndIf

Return _oRet



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษอออออออออออัออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ _fMarca    บ Autor ณ					ณ 					  บฑฑ
ฑฑฬอออออออออออุออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Descricao ณ Funcao para marcar ou desmarcar a linha posicionada.          บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ  				                                             บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function _fMarca( _nPosVetor )

If ValType( _nPosVetor ) == Nil
	ApMsgInfo( "Linha invแlida." + CRLF + "Favor verificar.", "Aten็ใo..." )

ElseIf Empty( AllTrim( _aRegInteg[_nPosVetor][_nPB5XPAI] ) )
	_aRegInteg[_nPosVetor][_nPosStat] := "2"						// Nao permite marcar um produto que nao tenha o respectivo pai / Faltando Informacao
	ApMsgInfo( "Produto Pai nใo pode estar vazio." + CRLF + "Favor verificar.", "Aten็ใo..." )
ElseIf _aRegInteg[_nPosVetor][_nPosStat] == "2"
	_aRegInteg[_nPosVetor][_nPosStat] := "2"	 					// Nao permite marcar / desmarcar um produto DUPLICADO
	ApMsgInfo( "Produto Pai nใo pode estar vazio." + CRLF + "Favor verificar.", "Aten็ใo..." )
Else
	If _aRegInteg[_nPosVetor][_nPosStat] == "1"
		_aRegInteg[_nPosVetor][_nPosStat] := "0"
		_nSelecao--
	ElseIf _aRegInteg[_nPosVetor][_nPosStat] == "0"
		_aRegInteg[_nPosVetor][_nPosStat] := "1"
		_nSelecao++
	EndIf
EndIf

_oSelecao:Refresh()
_oRegInteg:Refresh()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษอออออออออออัออออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ _fFiltroPr บ Autor ณ 					  บ Data ณ 26/06/2023 บฑฑ
ฑฑฬอออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Descricao ณ Funcao para Filtrar os Produtos a serem apresentados na tela.  บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ  					                                           บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function _fFiltroPr(_cFiltro,_aFiltro)

Local _nX		:= 0
Local _nPos1	:= 0
Local _nPos2	:= 0

// Itens do Combo para Selecao / Filtro dos Produtos
//Private _aFiltro := { "Todos", "Produto Pai", "Produto Filho", "Linha Diamante", "Categoria", "Produtos Integrados", "Produtos Nใo Integrados" }

_nFiltro := aScan( _aFiltro, _cFiltro ) 	// Atualiza a opcao do Filtro selecionado

// Define os Campos para Filtro
If _nFiltro == 2
	_nPos1		:= _nPB5XPAI				// Codigo Pai	
	_nPos2		:= _nPB5XPAI
ElseIf _nFiltro == 3
	_nPos1		:= _nPB1COD					// Codigo Filho
	_nPos2		:= _nPB1DESC				// Descricao Filho

ElseIf _nFiltro == 4
	_nPos1		:= _nACUCOD 				// Codigo da Categoria
	_nPos2		:= _nACUDESC 				// Descricao da Categoria

ElseIf _nFiltro == 5 .or. _nFiltro == 6
	_nPos1		:= _nB5XPRDTID 				// Campo B5_XPRDTID (PRODUCT ID Linx) - PREENCHIDO = Filtro Prod. Integrados ou VAZIO = Prod. Nao Integrados
	_nPos2		:= _nB5XSKUID				// Campo B5_XSKUID (SKU ID Linx) 	  - PREENCHIDO = Filtro Prod. Integrados ou VAZIO = Prod. Nao Integrados
Else
	_nPos1		:= 0						// Todos
	_nPos2		:= 0
EndIf

_aRegInteg := {} 							// Limpa o vetor apresentado em tela

If _nFiltro > 1
	// Monta o vetor conforme o Filtro informado
	For _nX := 1 To Len( _aRegIntBk )
		If 	( _nFiltro == 5 .and. ( ! Empty( AllTrim( _aRegIntBk[_nX][_nB5XPRDTID] ) ) .or. ! Empty( AllTrim( _aRegIntBk[_nX][_nB5XSKUID] ) ) ) ) .or.;
			( _nFiltro == 6 .and. (   Empty( AllTrim( _aRegIntBk[_nX][_nB5XPRDTID] ) ) .or.   Empty( AllTrim( _aRegIntBk[_nX][_nB5XSKUID] ) ) ) ) .or.;
			( _nFiltro <= 4 .and. ( Upper( AllTrim( cValToChar( _cBuscaTxt ) ) ) $ AllTrim( _aRegIntBk[_nX][_nPos1] ) .or. ;
									Upper( AllTrim( cValToChar( _cBuscaTxt ) ) ) $ AllTrim( _aRegIntBk[_nX][_nPos2] ) ) )

			AAdd( _aRegInteg, _aRegIntBk[_nX] )
		EndIf
	Next _nX
EndIf

If Len( _aRegInteg ) == 0
	_aRegInteg := ACLONE( _aRegIntBk ) 		// Apresenta TODOS os produtos do Backup

	If _nFiltro > 1 .and. _nPos1 <> 0
		ApMsgInfo( "Sem registros para o filtro informado. Favor verificar.", "Aten็ใo..." )
	EndIf
EndIf

_oRegInteg:nAt := 1 						// Reposiciona Grade para a primeira linha

_oRegInteg:SetArray( _aRegInteg )
_oRegInteg:bLine := &( _fBLine() )

_nTotReg := Len( _aRegInteg ) 				// Recontagem do Total de registros a processar
_oTotReg:Refresh()

// Forca todos os registros para Desmarcado
_lMarcaTudo := .F.
_MarcaTudo( _lMarcaTudo )

// Limpa o Texto da Busca para os Filtros que nao o utilizam e para Linha Diamante que usa texto fixo = 1
If _nFiltro < 2 .or. _nFiltro > 3
	_cBuscaTxt := Space( 40 )
	_oBuscaTxt:Refresh()
EndIf

_oRegInteg:Refresh()
_oBotEncer:SetFocus()						// Posiciona no botao Encerrar

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษอออออออออออัออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Programa  ณ _MarcaTudo บ Autor ณ                      บ Data ณ 19/06/2023 บฑฑ
ฑฑฬอออออออออออุออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ Descricao ณ Funcao criada para Marcar ou Desmarcar Todos os registros.    บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso       ณ                                                               บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function _MarcaTudo( _lTudo )

Local _nX := 0

_nSelecao := 0 	// Limpa var para recontagem

For _nX := 1 To Len( _aRegInteg )
	// Nao permite marcar um produto que nao tenha o respectivo pai / faltando informacao ou Duplicado
	If _aRegInteg[_nX][_nPosStat] <> "2"
		If _lTudo
			_aRegInteg[_nX][_nPosStat] := "1"
			_nSelecao++
		Else
			_aRegInteg[_nX][_nPosStat] := "0"
		EndIf
	EndIf
Next _nX

_oSelecao:Refresh()
_oRegInteg:Refresh()

Return
