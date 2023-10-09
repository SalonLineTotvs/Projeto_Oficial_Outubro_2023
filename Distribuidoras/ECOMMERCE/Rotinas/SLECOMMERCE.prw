#INCLUDE "TOTVS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ SLECOMMERCE º Autor ³                      º Data ³ 12/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao ³ Rotina de cadastro dos pedidos ecommerce                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³                                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SLECOMM(_cOpc, _aRastro, _cOrigem )
Local _cPopUp       := ''
Local _cAcessVD     := AllTrim(GetMV('SL_FIL_VD',.F.,'1501|0101'))

Local _aCores		:= {	{ 'PZU->PZU_STATUS == "0"', "BR_CINZA"		},; 	// "Aguardando pagamento"
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
							{ 'PZU->PZU_STATUS == "G"', "BR_MARROM"		},; 	// "Falha na Entrega"
							{ 'PZU->PZU_STATUS == "H"', "BR_PRETO_3"		} ; 	// "Congelado"
						}

Local _cMsg			:= "" 
PRIVATE oDlg:=NIL
Private cCadastro	:= "Pedidos E-Commerce"

Private _aEtiq		:= {	{ "Volume"	, 'u_zEti2Vol()'			, 0, 7 },;
							{ "Danfe"	, 'u_zEti2Nfe()'	, 0, 7 } }

Private aRotina		:= {	{ "Pesquisar"	, 'AxPesqui'			, 0, 1 },; 	// Pesquisar
							{ "Visualizar"	, 'U_SLECOMM( "V" )'	, 0, 2 },; 	// Visualizar
							{ "Tracking"	, 'U_SLECOMM( "T" )'	, 0, 2 },; 	// Tracking / Rastreamento
							{ "Legenda"		, 'U_SLECOMM( "L" )'	, 0, 5 },; 	// Legenda
							{ "Integrar"	, 'U_SLINTPZU(.F.)'		, 0, 5 },;	// Integracao da PZU e PZV
							{ "Alterar"	    , 'U_SLECOMM( "A" )'	, 0, 4 },; 	// Alterar*/                  
							{ "Picking"	    , 'U_SLECOPICK()'		, 0, 7 },; 	// Alterar*/  
							{ "Checkout"	, 'U_SLECOCKOUT()'		, 0, 7 },; 	// Alterar*/  
							{ "Reimpressão"	, _aEtiq				, 0, 7 } } 	// Alterar*/  
						//	{ "Pedido Venda", 'U_zMata410()'		, 0, 7 }} 	// Alterar*/             
						//	{ "Nota Fiscal" , 'U_SLECOMNFE()'		, 0, 8 }} 	// Alterar*/              							
						//	{ "Intelipost"  , 'U_SLCONGELA()'		, 0, 9 }}
							//{ "Congelar"    , 'U_SLCONGELA()'		, 0, 9 }}

//							{ "Auto Sefaz"  , 'U_zTSSSefaz()'		, 0, 7 },; 	// Alterar*/ 

Private _aStatus	:= {}

// -------------------------------------------------------------------------------------------------------------------------------
// Grava a Situacao / Rastro / Origem. A chamada da funcao para gravacao devera conter 3 parametros para envio:
//   1o - Determina o tipo da transacao - "R" = Gravacao do Rastreamento
//   2o - Vetor _aRastro deve conter as informacoes:
// 			{ Num.Pedido E-commerce, Num.Pedido Market Place, Data, Hora, Situacao, Num.Docto, Serie, Transportadora, Observacao }
//   3o - A Origem das informacoes para gravacao, podendo ser:
// 			"1" = E-COMMERCE ou "2" = VAREJO
// -------------------------------------------------------------------------------------------------------------------------------
DEFAULT _aRastro	:= {}
DEFAULT _cOrigem	:= "1" 		// Caso nao seja enviada a Origem, utiliza o padrao "1" = E-COMMERCE

AAdd( _aStatus, { "0", LoadBitmap( GetResources(), "BR_CINZA"		) } )	// "Aguardando pagamento"
AAdd( _aStatus, { "1", LoadBitmap( GetResources(), "BR_BRANCO"		) } )	// "Aguardando pagamento/Pedido Emitido"
AAdd( _aStatus, { "2", LoadBitmap( GetResources(), "BR_AZUL_CLARO"	) } )	// "Aprovado"
AAdd( _aStatus, { "3", LoadBitmap( GetResources(), "BR_VERMELHO"	) } )	// "EMITIDO"
AAdd( _aStatus, { "4", LoadBitmap( GetResources(), "BR_AZUL"		) } )	// "In Picking"
AAdd( _aStatus, { "5", LoadBitmap( GetResources(), "BR_AMARELO"		) } )	// "Aguardando NFE"
AAdd( _aStatus, { "6", LoadBitmap( GetResources(), "BR_LARANJA"		) } )	// "NFe Emitida"
AAdd( _aStatus, { "7", LoadBitmap( GetResources(), "BR_VERDE"		) } )	// "NFe impressa"
AAdd( _aStatus, { "8", LoadBitmap( GetResources(), "BR_PINK"		) } )	// "Aguardando coleta"
AAdd( _aStatus, { "9", LoadBitmap( GetResources(), "BR_VIOLETA"		) } )	// "Na Transportadora"
AAdd( _aStatus, { "A", LoadBitmap( GetResources(), "BR_BRANCO"		) } )	// "Em Rota"
AAdd( _aStatus, { "B", LoadBitmap( GetResources(), "BR_LARANJA"		) } )	// "Em Transferencia"
AAdd( _aStatus, { "C", LoadBitmap( GetResources(), "BR_PRETO"		) } )	// "Entregue"
AAdd( _aStatus, { "D", LoadBitmap( GetResources(), "BR_VERDE_ESCURO") } )	// "Ausente"
AAdd( _aStatus, { "E", LoadBitmap( GetResources(), "BR_MARRON_OCEAN") } )	// "Devolucao/Sinistro"
AAdd( _aStatus, { "F", LoadBitmap( GetResources(), "BR_CANCEL"		) } )	// "Cancelado"
AAdd( _aStatus, { "G", LoadBitmap( GetResources(), "BR_MARROM"		) } )	// "Falha na Entrega"
AAdd( _aStatus, { "H", LoadBitmap( GetResources(), "BR_PRETO_3"		) } )	// "Congelado"

If 	_cOpc == "L" 				// Legenda
	_Legenda()

//ElseIf _cOpc == "I"				
//	_Integra()

ElseIf _cOpc == "V" 			// Visualizacao
	_SLINC( _cOpc )

ElseIf _cOpc == "R"	 		// Grava o Rastreamento
	If ! Empty( _aRastro )
		_SLECA02R( _aRastro, _cOrigem )
	Else
		_cMsg := "Tentativa de gravação de Tracking / Rastreamento sem as informações necessárias." + CRLF + ". Favor verificar."

		// Registra Log
		U_KSGeraLog( , "SLECOMM", _cMsg, .F., .F. )
	EndIf

ElseIf _cOpc == "T"	 		// Tela do Tracking / Rastreamento
	_SLECA02T()

Else
	DbSelectArea("SA4")	
	SA4->(DbSetOrder(1))
	
	dbSelectArea("PZU")
	PZU->(dbSetOrder(1))				// PZU_FILIAL+PZU_PEDECO+PZU_CLIENT+PZU_LOJA

	IF !(cFilAnt $ _cAcessVD)
		_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
		_cPopUp += ' <br> '
		_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
		_cPopUp += ' <br><br>'
		_cPopUp += ' <font color="#000000" face="Arial" size="3">Filial nao configurada para operação</font> '
		_cPopUp += ' <br><br> '
		_cPopUp += ' <font color="#000000" face="Arial" size="2"> Por gentileza, acessa a filial correta</font> '			
		Alert(_cPopUp,'VD')
		RETURN
	ENDIF

	// Permite a Importacao dos pedidos ja existentes no C5 e C6 qdo a tabela estiver vazia
	//If PZU->( Eof() ) .and. ApMsgNoYes( "Deseja importar os pedidos de E-Commerce já existentes no Protheus ?", "KSECOA02 - Atenção..." )
	//	Processa( { || _KSECA2xxx() }, "Importando Pedidos E-Commerce", "Aguarde..." )
	//EndIf

	// Carrega a Tela do MBrowse
	mBrowse( 6, 1, 22, 75, "PZU",,,,,, _aCores ,,,,,,,, )
EndIf 

RETURN

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ SLCONGELA  º Autor ³  		     		  º Data ³ 07/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao ³ Funcao para Congelar o pedido                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ 				                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function SLCONGELA()   

nOpc:=2   
RegToMemory( "PZU", ( nOpc == 3 ), .F. )  
IF PZU->PZU_STATUS $ '1G'  
	Reclock('PZU',.F.)
		PZU->PZU_STATUS := IF(PZU->PZU_STATUS == "G",'1',"G")
	MSUNLOCK()
	
	RecLock( "PZX", .T. )
		PZX->PZX_FILIAL		:= xFilial( "PZX" )
		PZX->PZX_PEDECO		:= PZU->PZU_PEDECO 
		PZX->PZX_PEDMKP		:= PZU->PZU_PEDMKP 
		PZX->PZX_DATA		:= dDataBase
		PZX->PZX_HORA		:= TIME()
		PZX->PZX_STATUS		:= PZU->PZU_STATUS 
		PZX->PZX_OBSERV		:= UsrFullName(__cUserID)
		PZX->PZX_ORIGEM		:= '1'
	PZX->( MsUnlock() )     
ELSE 
	MSGALERT('Pedido não pode ser congelado.')
endif

Return     
RETURN

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³       º Autor ³                           º Data ³ 12/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao ³ Funcao para atender as opcoes Incluir, Alterar e Visualizar.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³                                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _SLINC( _cOpc ) 

Local nX			:= 0
Local _nPos			:= 0
Local nUsado		:= 0
Local aButtons		:= {}
Local aCpoEnch		:= {}
Local cAliasE		:= "PZU"
Local aAlterEnch	:= {}
Local cAliasGD		:= "PZV"
Local aAlterGDa		:= {}
Local nModelo		:= 3
Local lF3			:= .F.
Local lMemoria		:= .T.
Local lColumn		:= .F.
Local caTela		:= ""
Local lNoFolder		:= .F.
Local lProperty		:= .F.

Local cLinOk		:= "AllwaysTrue()"
Local cTudoOk		:= "AllwaysTrue()"
Local cFieldOk		:= "AllwaysTrue()"
Local cDelOk		:= "AllwaysTrue()"

Local cIniCpos		:= "+PZV_ITEM"
Local nFreeze		:= 000
Local nMax			:= 999
Local cSuperDel		:= ""
Local nGDUID		:= 0 					//GD_UPDATE+GD_INSERT+GD_DELETE

Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {} 

Private oDlg
Private oGetD
Private oEnch

Private nOpc		:= 2					// Somente eh possivel a opcao de Visualizacao
Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.

Private aCols		:= {}
Private aHeader		:= {}

Private _aHeadVirt	:= {}					// Vetor para facilitar a carga das informacoes de campos virtuais da tabela

// Definindo campos para a Enchoice
DbSelectArea( "SX3" )
DbSetOrder( 1 )

DbSeek( cAliasE )

AADD( aCpoEnch, "NOUSER" )

While SX3->( ! Eof() ) .And. SX3->X3_ARQUIVO == cAliasE
	If ! ( AllTrim( SX3->X3_CAMPO ) $ "|PZU_FILIAL|PZU_STATUS|" ) .And. cNivel >= SX3->X3_NIVEL .And. X3Uso( SX3->X3_USADO )
		aAdd( aCpoEnch		, SX3->X3_CAMPO )
		aAdd( aAlterEnch	, SX3->X3_CAMPO )

		// Carrega vetor para facilitar a carga das informacoes de campos virtuais da tabela
		If AllTrim( SX3->X3_CONTEXT ) == "V"
			aAdd( _aHeadVirt, { UPPER( AllTrim( SX3->X3_CAMPO ) ), SX3->X3_INIBRW } )
		EndIf
	EndIf
	SX3->( DbSkip() )
EndDo

// Definindo campos da aHeader e GetDados
aHeader		:= {}
nUsado		:= 0

DbSelectArea( "SX3" )
DbSetOrder( 1 )

DbSeek( cAliasGD )

While SX3->( ! Eof() ) .And. SX3->X3_ARQUIVO == cAliasGD
	If ! ( AllTrim( SX3->X3_CAMPO ) $ "|PZV_FILIAL|PZV_PEDECO|" ) .And. cNivel >= SX3->X3_NIVEL .And. X3Uso( SX3->X3_USADO )
		AADD( aAlterGDa, SX3->X3_CAMPO )

		nUsado++

		aAdd( aHeader, { 	AllTrim( SX3->X3_DESCRIC )			,;
							UPPER( AllTrim( SX3->X3_CAMPO ) )	,;
							SX3->X3_PICTURE						,;
							SX3->X3_TAMANHO						,;
							SX3->X3_DECIMAL						,;
							"AllwaysTrue()"						,;
							SX3->X3_USADO						,;
							SX3->X3_TIPO						,;
							SX3->X3_F3							,;
							SX3->X3_CONTEXT 					} )

		// Carrega vetor para facilitar a carga das informacoes de campos virtuais da tabela
		If AllTrim( SX3->X3_CONTEXT ) == "V"
			aAdd( _aHeadVirt, { UPPER( AllTrim( SX3->X3_CAMPO ) ), SX3->X3_INIBRW } )
		EndIf
	EndIf
	SX3->( DbSkip() )
EndDo

// Atualiza as Vars baseadas nas do padrao e que podem ser utilizadas em gatilhos e outras tabelas do dicionario de dados.
VISUAL	:= ( nOpc == 2 ) 		// Somente a Visualizacao eh permitida
INCLUI	:= ( nOpc == 3 ) 		// Inclusao nao eh permitida nesta rotina
ALTERA	:= ( nOpc == 4 ) 		// Alteracao nao eh permitida nesta rotina
DELETA	:= ( nOpc == 5 ) 		// Exclusao nao eh permitida nesta rotina

If VISUAL
    aCols	:= {}

	DbSelectArea( "PZU" )
	DbSetOrder( 1 )				// PZU_FILIAL+PZU_PEDECO+PZU_CLIENT+PZU_LOJA

	// Carrega Registro do Cabecalho
	RegToMemory( "PZU", ( nOpc == 3 ), .F. )

	// Carrega os Campos Virtuais do Cabecalho do PV
	For nX := 1 to Len( _aHeadVirt )
		If Substr( _aHeadVirt[nX][1], 1, 3 ) == "PZU"
			&(M->(_aHeadVirt[nX][1])) := &(_aHeadVirt[nX][2]) 	// Carrega os Campos Virtuais
		EndIf
	Next nX

	DbSelectArea( "PZV" )
	DbSetOrder( 1 )			// PZV_FILIAL+PZV_PEDECO+PZV_PRODUT+PZV_ITEM

	PZV->( DbSeek( PZU->PZU_FILIAL + AllTrim( PZU->PZU_PEDECO ) ) )

	While PZV->( ! Eof() ) .And. PZV->PZV_FILIAL == PZU->PZU_FILIAL .and. AllTrim( PZV->PZV_PEDECO ) == AllTrim( PZU->PZU_PEDECO )

		aAdd( aCols, Array( nUsado + 1 ) )

		For nX := 1 to nUsado
			If aHeader[nX,10] == "R"
				// Carrega os Campos Reais - Existem Fisicamente na tabela
		   		aCols[ Len( aCols ), nX ] := FieldGet( FieldPos( aHeader[nX,2] ) )
		   	ElseIf aHeader[nX,10] == "V"
		   		_nPos := aScan( _aHeadVirt, { |x| x[1] == aHeader[nX,2] } )

		   		// Carrega os Campos Virtuais
		   		If _nPos > 0
		   			aCols[ Len( aCols ), nX ] := Iif( _nPos > 0, &(_aHeadVirt[_nPos][2]), "" )
		   		EndIf
		   	EndIf
		Next nX

		aCols[ Len( aCols ), nUsado + 1 ] := .F.

		PZV->( DbSkip() )
	EndDo
EndIf

// Obtem a Area de trabalho e tamanho da dialog
aSize := MsAdvSize()

AAdd( aObjects, { 100, 430, .T., .T. } )

// Dados da Enchoice 
AAdd( aObjects, { 200, 200, .T., .T. } )

// Dados da Area de trabalho e separacao
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

// Chama MsObjSize e recebe array e tamanhos
aPosObj := MsObjSize( aInfo, aObjects, .T. ) 

// Montando a Tela
oDlg := MSDialog():New( aSize[7], 001, aSize[6], aSize[5], cCadastro,,,,,,,, oMainWnd, .T. )

// Montando Enchoice
oEnch :=  MsMGet():New( cAliasE	, (cAliasE)->( Recno() ), nOpc,,,, aCpoEnch, aPosObj[1], aAlterEnch, nModelo,,, cTudoOk, oDlg, lF3, lMemoria, lColumn, caTela, lNoFolder, lProperty,,,, .T., )

// Montando GetDados
oGetD := MsNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nGDUID, cLinOk, cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oDLG, @aHeader, @aCols )

// Carregando a Tela
oDlg:bInit		:= { || EnchoiceBar( oDlg, { || oDlg:End() }, { || oDlg:End() }, , aButtons ) }
oDlg:lCentered	:= .T.
oDlg:Activate()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³             º Autor ³                    º Data ³ 12/07/2023  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao ³ Funcao para Legendas.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ KingStar Colchoes                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _Legenda()

Local _aLegenda := {	{ "BR_CINZA"		, "Aguardando Pagamento"	},; 				// PZU_STATUS 0 = Aguardando pagamento
						{ "BR_BRANCO"		, "Aguardando Pagamento/Pedido Emitido"	},; 	// PZU_STATUS 1 = Aguardando pagamento/Pedido Emitido
						{ "BR_AZUL_CLARO"	, "Aprovado"				},; 				// PZU_STATUS 2 = Aprovado
						{ "BR_VERMELHO"		, "Pedido Emitido"			},; 				// PZU_STATUS 3 = Pedido Emitido
						{ "BR_AZUL"			, "In Picking"				},; 				// PZU_STATUS 4 = In Picking
						{ "BR_AMARELO"		, "Aguardando NFE"			},; 				// PZU_STATUS 5 = Aguardando NFE
						{ "BR_LARANJA"		, "NFe Emitida"				},; 				// PZU_STATUS 6 = Emitido
						{ "BR_VERDE"		, "NFe Transmitida"			},; 				// PZU_STATUS 7 = NFe Transmitida
						{ "BR_PINK"			, "Aguardando Coleta"		},; 				// PZU_STATUS 8 = Aguardando coleta
						{ "BR_VIOLETA"		, "Na Transportadora"		},; 				// PZU_STATUS 9 = Na Transportadora
						{ "BR_BRANCO"		, "Em Rota"					},; 				// PZU_STATUS A = Em Rota
						{ "BR_LARANJA"		, "Em Transferência"		},; 				// PZU_STATUS B = Em Transferencia
						{ "BR_PRETO"		, "Entregue"				},; 				// PZU_STATUS C = Entregue
						{ "BR_VERDE_ESCURO"	, "Ausente"					},; 				// PZU_STATUS D = Ausente
						{ "BR_MARRON_OCEAN"	, "Devolução/Sinistro"		},; 				// PZU_STATUS E = Devolucao/Sinistro
						{ "BR_CANCEL"		, "Cancelado"				},; 				// PZU_STATUS F = Cancelado
						{ "BR_MARROM"		, "Falha na Entrega"		},; 				// PZU_STATUS G = Falha na Entrega
						{ "BR_PRETO_3"		, "Congelado"				} ;  				// PZU_STATUS H = Congelado
					}

BrwLegenda( cCadastro, "Legenda", _aLegenda ) 

Return

/*
Function 	: _Integra
Description	: Chama a funcao de Integração dos pedidos e-commerce para ao ERP
*/

Static Function _Integra()

Local a_Alias := GetArea()

	U_SLINTPZU(.F.)	// Executa integração dos pedidos e-commerce

RestArea( a_Alias )

Return
 
User Function _SLECA2Sit( _cStatus )

Local _cRetorno := ""

If 	_cStatus == "0"
	_cRetorno := "Aguardando pagamento"

ElseIf 	_cStatus == "1"
	_cRetorno := "Aguardando pagamento/Pedido Emitido "

ElseIf _cStatus == "2"
	_cRetorno := "Aprovado"

ElseIf _cStatus == "3"
	_cRetorno := "Pedido Emitido"

ElseIf _cStatus == "4"
	_cRetorno := "In Picking"

ElseIf _cStatus == "5"
	_cRetorno := "Aguardando NFE"

ElseIf _cStatus == "6"
	_cRetorno := "NFe Emitida"

ElseIf _cStatus == "7"
	_cRetorno := "NFe Transmitida"

ElseIf _cStatus == "8"
	_cRetorno := "Aguardando coleta"

ElseIf _cStatus == "9"
	_cRetorno := "Na Transportadora"

ElseIf _cStatus == "A"
	_cRetorno := "Em Rota"

ElseIf _cStatus == "B"
	_cRetorno := "Em Transferência"

ElseIf _cStatus == "C"
	_cRetorno := "Entregue"

ElseIf _cStatus == "D"
	_cRetorno := "Ausente"

ElseIf _cStatus == "E"
	_cRetorno := "Devolução/Sinistro"

ElseIf _cStatus == "F"
	_cRetorno := "Cancelado"

ElseIf _cStatus == "G"
	_cRetorno := "Falha na Entrega"

ElseIf _cStatus == "H"
	_cRetorno := "Congelado"

Else
	_cRetorno := "NÃO IDENTIFICADO"
EndIF

Return _cRetorno


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ _SLECA2xxx   º Autor ³ Luís Ricardo Cinalli º Data ³ 12/09/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao ³ Funcao para Legendas.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ KingStar Colchoes                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _SLECA2xxx()

Local _aArea		:= GetArea()
Local _cQuery		:= ""
Local _cAlias		:= "TRB_EZ"
Local _cPedEcomm	:= ""
Local _cNumPed		:= ""
Local _nTotReg		:= 0						// Total de Registros a processar
Local _nPos			:= 0
Local _cFilPZU		:= xFilial( "PZU" )
Local _cFilPZV		:= xFilial( "PZV" )
Local _nTamPedEc	:= TamSx3( "PZU_PEDECO" )[1]
Local _cMsg			:= "" 

ProcRegua( 2 )

IncProc( "Carregando Tabela de Pedidos E-Commerce..." )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o arquivo de Trabalho caso exista em alguma area ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	Select( _cAlias ) # 0
   	(_cAlias)->( DbCloseArea() )
EndIf

// Busca Dados dos Produtos e precos 
_cQuery := "SELECT SC5.C5_FILIAL, SC5.C5_EMISSAO, SC5.C5_XPEDECO, SC5.C5_NUM, SC6.C6_NUM, SC5.C5_FECENT, SC5.C5_TRANSP, " 				+ CRLF
_cQuery += "       SC5.C5_CONDPAG, SC5.C5_NATUREZ, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, " 				+ CRLF
_cQuery += "       SA1.A1_CGC, SC5.C5_XEND, SC5.C5_XBAIRRO, SC5.C5_XEST, SC5.C5_XMUNDES, SC5.C5_XCOMPL, SC5.C5_XCEP, " 					+ CRLF
_cQuery += "       SC5.C5_FRETE, SC6.C6_FILIAL, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SA1.A1_CGC, " 				+ CRLF
_cQuery += "       SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_EST, SA1.A1_MUN, SA1.A1_COMPLEM, SA1.A1_CEP, DAK.DAK_CAMINH, "						+ CRLF
_cQuery += "       DAK.DAK_MOTORI, DA4.DA4_FORNEC, DA4.DA4_LOJA "																		+ CRLF
_cQuery += "  FROM " + RetSqlName( "SC5" ) + " SC5 (NOLOCK) "																			+ CRLF
_cQuery += "       LEFT JOIN " + RetSqlName( "SC6" ) + " SC6 (NOLOCK) ON SC6.D_E_L_E_T_ = '' AND SC6.C6_FILIAL = SC5.C5_FILIAL " 		+ CRLF
_cQuery += "                 AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI " 			+ CRLF
_cQuery += "       LEFT JOIN " + RetSqlName( "SA1" ) + " SA1 (NOLOCK) ON SA1.D_E_L_E_T_ = '' AND SA1.A1_COD = SC5.C5_CLIENTE "			+ CRLF
_cQuery += "                  AND SA1.A1_LOJA = SC5.C5_LOJACLI "																		+ CRLF
_cQuery += "       LEFT JOIN " + RetSqlName( "DAI" ) + " DAI (NOLOCK) ON DAI.D_E_L_E_T_ = '' AND DAI.DAI_FILIAL = SC5.C5_FILIAL " 		+ CRLF
_cQuery += "                  AND DAI.DAI_PEDIDO = SC5.C5_NUM AND DAI.DAI_CLIENT = SC5.C5_CLIENTE AND DAI.DAI_LOJA = SC5.C5_LOJACLI " 	+ CRLF
_cQuery += "       LEFT JOIN " + RetSqlName( "DAK" ) + " DAK (NOLOCK) ON DAK.D_E_L_E_T_ = '' AND DAK.DAK_FILIAL = DAI.DAI_FILIAL " 		+ CRLF
_cQuery += "                  AND DAK.DAK_COD = DAI.DAI_COD AND DAK.DAK_SEQCAR = DAI.DAI_SEQCAR AND SC5.C5_LOJACLI = SC6.C6_LOJA " 		+ CRLF
_cQuery += "       LEFT JOIN " + RetSqlName( "DA4" ) + " DA4 (NOLOCK) ON DA4.D_E_L_E_T_ = '' AND DA4.DA4_FILIAL = DAK.DAK_FILIAL " 		+ CRLF
_cQuery += "                  AND DA4.DA4_COD = DAK.DAK_MOTORI "																		+ CRLF
_cQuery += " WHERE SC5.D_E_L_E_T_ = '' " 																								+ CRLF
_cQuery += "   AND SC5.C5_XPEDECO <> '' " 																								+ CRLF
_cQuery += "   AND SC5.C5_EMISSAO >= '20171104' " 																						+ CRLF
_cQuery += " ORDER BY SC6.C6_FILIAL, SC5.C5_EMISSAO, SC5.C5_XPEDECO, SC5.C5_NUM, SC6.C6_NUM, SC6.C6_ITEM " 								+ CRLF

dbUseArea( .T., "TOPCONN", TCGenQry( , , _cQuery ), _cAlias, .F., .T. )

TcSetField( _cAlias, "C5_EMISSAO"	, "D", 08, 0 )
TcSetField( _cAlias, "C5_FECENT"	, "D", 08, 0 )
TcSetField( _cAlias, "C5_FRETE"		, "N", 12, 2 )
TcSetField( _cAlias, "C6_QTDVEN"	, "N", 12, 2 )
TcSetField( _cAlias, "C6_PRCVEN"	, "N", 12, 2 )


// Posiciona na Tabela principal de processamento
DbSelectArea( _cAlias )
(_cAlias)->( DbGoTop() )

IncProc( "Calculando total de pedidos para importação..." )

_nTotReg := 0

// Carrega o vetor dos Produtos, Precos e Calcula o total de registros para regua de processamento 
While (_cAlias)->( ! Eof() )
	_nTotReg++
	(_cAlias)->( DbSkip() )
EndDo

// Posiciona na Tabela principal de processamento
DbSelectArea( _cAlias )
(_cAlias)->( DbGoTop() )

ProcRegua( _nTotReg )

Begin Transaction

// Carrega o vetor dos Produtos, Precos e Calcula o total de registros para regua de processamento 
While (_cAlias)->( ! Eof() )

	IncProc( "Carregando Pedido " + AllTrim( (_cAlias)->C5_XPEDECO ) )

	_cPedEComm	:= AllTrim( (_cAlias)->C5_XPEDECO )  	// Carrega o Numero do Pedido ECommerce
	_cNumPed	:= AllTrim( cValToChar( (_cAlias)->C5_NUM ) )

	DbSelectArea( "PZU" )
	DbSetOrder( 1 )				// PZU_FILIAL+PZU_PEDECO

	If 	PZU->( ! DbSeek( _cFilPZU + _cPedEcomm ) )
		RecLock( "PZU", .T. )
			PZU->PZU_FILIAL		:= _cFilPZU
			PZU->PZU_PEDECO		:= _cPedEcomm
			PZU->PZU_PEDMKP		:= ""
			PZU->PZU_NUM		:= _cNumPed
			PZU->PZU_ORIGEM		:= "E-COMMERCE"
			PZU->PZU_DATA		:= (_cAlias)->C5_EMISSAO
			PZU->PZU_DATAAP		:= (_cAlias)->C5_EMISSAO
			PZU->PZU_PRAZO		:= (_cAlias)->C5_FECENT
			PZU->PZU_STATUS		:= "B"
			PZU->PZU_TRANSP		:= (_cAlias)->DA4_FORNEC
			PZU->PZU_CONDPG		:= (_cAlias)->C5_CONDPAG
			PZU->PZU_NATURE		:= (_cAlias)->C5_NATUREZ
			PZU->PZU_CLIENT		:= (_cAlias)->C5_CLIENTE
			PZU->PZU_LOJA		:= (_cAlias)->C5_LOJACLI
			PZU->PZU_CGC		:= (_cAlias)->A1_CGC

			If ! Empty( AllTrim( (_cAlias)->C5_XEND ) )
				PZU->PZU_ENDERE		:= (_cAlias)->C5_XEND
				PZU->PZU_BAIRRO		:= (_cAlias)->C5_XBAIRRO
				PZU->PZU_UF			:= (_cAlias)->C5_XEST
				PZU->PZU_MUN		:= (_cAlias)->C5_XMUNDES
				PZU->PZU_COMPLE		:= (_cAlias)->C5_XCOMPL
				PZU->PZU_CEP		:= (_cAlias)->C5_XCEP
			Else
				PZU->PZU_ENDERE		:= (_cAlias)->A1_END
				PZU->PZU_BAIRRO		:= (_cAlias)->A1_BAIRRO
				PZU->PZU_UF			:= (_cAlias)->A1_EST
				PZU->PZU_MUN		:= (_cAlias)->A1_MUN
				PZU->PZU_COMPLE		:= (_cAlias)->A1_COMPLEM
				PZU->PZU_CEP		:= (_cAlias)->A1_CEP
			EndIf

			PZU->PZU_FRETE		:= (_cAlias)->C5_FRETE
			PZU->PZU_FRETPG		:= "2"
		PZU->( MsUnLock() )

		// Grava os Itens dos PV
		While (_cAlias)->( ! Eof() ) .and. 	AllTrim( (_cAlias)->C5_XPEDECO ) == AllTrim( _cPedEcomm ) .and. ;
											AllTrim( (_cAlias)->C5_NUM     ) == _cNumPed

			IncProc( "Carregando itens do Pedido " + cValToChar( _cPedEcomm ) )

			RecLock( "PZV", .T. )
				PZV->PZV_FILIAL		:= _cFilPZV
				PZV->PZV_PEDECO		:= _cPedEcomm
				PZV->PZV_ITEM		:= (_cAlias)->C6_ITEM
				PZV->PZV_PRODUT		:= (_cAlias)->C6_PRODUTO
				PZV->PZV_KIT		:= ""
				PZV->PZV_QTDVEN		:= (_cAlias)->C6_QTDVEN
				PZV->PZV_PRCVEN		:= (_cAlias)->C6_PRCVEN
				PZV->PZV_PESO		:= 0
				PZV->PZV_ESTOQU		:= 0
			PZU->( MsUnLock() )

			(_cAlias)->( DbSkip() )
		EndDo
	Else
		_cMsg := "PV E-Commerce número " + AllTrim( _cPedEComm ) 	+ " Cód. Cliente " + (_cAlias)->C5_CLIENTE + "/" + (_cAlias)->C5_LOJACLI
		_cMsg += " já existe. Número do Ped. Venda Protheus " 		+ _cNumPed + ". Favor verificar."

		// Registra Log
		U_KSGeraLog( , "KSECOA02", _cMsg, .F., .F. )

		(_cAlias)->( DbSkip() )
	EndIf
EndDo

End Transaction

RestArea( _aArea )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa   ³ _SLECA02R  º Autor ³                      º Data ³ 11/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao  ³ Funcao para Gravar a Situacao, Rastro e Origem do Tracking.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso        ³ KingStar Colchoes                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parametros ³ A chamada da funcao para gravacao devera conter 3 parametros  º±±
±±º Recebidos: ³ para envio:                                                   º±±
±±º            ³      1o - Determina o tipo da transacao - "R" = Gravacao do   º±±
±±º            ³           Rastreamento:                                       º±±
±±º            ³           OBS.: ESTE 1o, SOMENTE EH USADO NA ROTINA PRINCIPAL.º±±
±±º            ³      2o - Vetor _aRastro deve conter as informacoes:          º±±
±±º            ³           { Num.Pedido E-commerce, Num.Pedido Market Place,   º±±
±±º            ³             Data, Hora, Situacao, Num.Docto, Serie,           º±±
±±º            ³             Transportadora, Observacao }                      º±±
±±º            ³      3o - A Origem das informacoes para gravacao, podendo     º±±
±±º            ³           ser: "1" = E-COMMERCE ou "2" = VAREJO               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _SLECA02R( _aRastro, _cOrigem )

Local _aArea	:= GetArea()

// Seleciona a tabela PZX - Tracking / Rastreamento
dbSelectArea( "PZX" )
dbSetOrder( 1 )				// PZX_FILIAL+PZX_PEDECO+PZX_DATA+PZX_HORA

RecLock( "PZX", .T. )
	PZX->PZX_FILIAL		:= xFilial( "PZX" )
	PZX->PZX_PEDECO		:= _aRastro[1]
	PZX->PZX_PEDMKP		:= _aRastro[2]
	PZX->PZX_DATA		:= _aRastro[3]
	PZX->PZX_HORA		:= _aRastro[4]
	PZX->PZX_STATUS		:= _aRastro[5]
	PZX->PZX_NUMDOC		:= _aRastro[6]
	PZX->PZX_SERIE		:= _aRastro[7]
	PZX->PZX_TRANSP		:= _aRastro[8]
	PZX->PZX_OBSERV		:= _aRastro[9]
	PZX->PZX_ORIGEM		:= _cOrigem
PZX->( MsUnlock() )

RestArea( _aArea )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ _SLECA02T  º Autor ³ Luís Ricardo Cinalli º Data ³ 11/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±      
±±º Descricao ³ Funcao para visualizar o Tracking / Rastreamento do PV.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ KingStar Colchoes                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _SLECA02T()

Local _aArea		:= GetArea()
Local _lContinua	:= .T.
Local _cFilPZX		:= xFilial( "PZX" )

Local _oDlg
Local _cTitTela		:= ""

Local _oDtEmis
Local _dDtEmis		:=  PZU->PZU_DATA
Local _oDtAprov
Local _dDtAprov		:=  PZU->PZU_DATAAP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cString		:= "PZX" 											// Cad. Tracking / Rastreamento PV E-Commerce
Private cTitulo		:= Posicione( "SX2", 1, cString, "X2_NOME" )		// Carrega o titulo da tabela conforme Dicionario de Dados

Private _oRegPZX
Private _aRegPZX		:= {}

dbSelectArea( cString )
dbSetOrder( 1 )				// PZX_FILIAL+PZX_PEDECO+PZX_DATA+PZX_HORA

(cString)->( DbSeek( _cFilPZX + PZU->PZU_PEDECO ) )

While (cString)->( ! Eof() ) .and. (cString)->( PZX_FILIAL + PZX_PEDECO ) == _cFilPZX + PZU->PZU_PEDECO
	// Carrega o vetor com os registros
	// 01=Status / Legenda, 02=Ped. E-Commerce	, 03=Ped. Market Place, 04=Data			, 05=Hora	 , 06=Situacao	,
	// 07=Docto Saida		 , 08=Serie			, 09=Transportadora	 , 10=Observacao	, 11=Origem
	Aadd( _aRegPZX, { 	(cString)->PZX_STATUS											,;
						U__SLECA2Sit( (cString)->PZX_STATUS )							,;
						(cString)->PZX_PEDECO											,;
						(cString)->PZX_PEDMKP											,;
						(cString)->PZX_DATA												,;
						(cString)->PZX_HORA												,;
						(cString)->PZX_NUMDOC											,;
						(cString)->PZX_SERIE											,;
						(cString)->PZX_TRANSP											,;
						(cString)->PZX_OBSERV											,;
						Iif( (cString)->PZX_ORIGEM == "2", "VAREJO", "E-COMMERCE" )		} )

	(cString)->( DbSkip() ) 
EndDo

If Len( _aRegPZX ) > 0
	While _lContinua
		Define MsDialog _oDlg Title cTitulo Style DS_MODALFRAME FROM 001, 001 TO 400, 800 PIXEL

			_oDlg:lEscClose	:= .F.			// Impede a saida pela tecla Esc

			_cTitTela := " Ped. E-Commerce: " + AllTrim( cValToChar( PZU->PZU_PEDECO ) ) + " "

			If ! Empty( AllTrim( cValToChar( PZU->PZU_PEDMKP ) ) )
				_cTitTela += " / Ped. Market Place: " + AllTrim( cValToChar( PZU->PZU_PEDMKP ) ) + " "
			EndIf

			@ 003, 1.5 TO 175, 401 LABEL _cTitTela PIXEL COLOR CLR_RED OF _oDlg

			@ 016, 016 SAY "Data Pedido: " 			 SIZE 080, 010 			OF _oDlg PIXEL
			@ 014, 048 MSGET _oDtEmis VAR _dDtEmis 	 SIZE 050, 010 WHEN .F. 	OF _oDlg PIXEL

			@ 016, 122 SAY "Data Aprovação: " 		 SIZE 080, 010 			OF _oDlg PIXEL
			@ 014, 164 MSGET _oDtAprov VAR _dDtAprov SIZE 050, 010 WHEN .F. 	OF _oDlg PIXEL

			@ 2.50, 0.40 LISTBOX _oRegPZX Fields ;
						  HEADER ""	, " Situação "	, " Data "	, " Hora "	, " Núm. Doc.Saída "	, " Série ", " Transportadora "	, " Observação ", " Origem "	;
						COLSIZES 05	, 70			, 35		, 30		, 50					, 20		, 50					, 60			  , 20			;
						    SIZE 396, 138 OF _oDlg

			@ 180, 165 BUTTON "Retornar" 	SIZE 60, 15 ACTION ( _lContinua := .F., _oDlg:End() ) PIXEL

			_oRegPZX:SetArray( _aRegPZX )
			_oRegPZX:bLine := &( _fBLineNew() )

		Activate MsDialog _oDlg Center
	EndDo
Else
	ApMsgInfo( "Não foram encontrados registros de Tracking / Rastreamento para o pedido selecionado.", "KSECOA02 - Atenção!!!" )
EndIf

RestArea( _aArea )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ _fBLinePZX º Autor ³                      º Data ³ 11/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao ³ Funcao para montagem da BLine do ListBox do Tracking.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ Kingstar Colchoes                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _fBLineNew()

Local _cRet := ""

_cRet := "{ || { "
_cRet += "_fStatus(), "
_cRet += "_aRegPZX[_oRegPZX:nAt][02], "
_cRet += "_aRegPZX[_oRegPZX:nAt][05], "
_cRet += "_aRegPZX[_oRegPZX:nAt][06], "
_cRet += "_aRegPZX[_oRegPZX:nAt][07], "
_cRet += "_aRegPZX[_oRegPZX:nAt][08], "
_cRet += "_aRegPZX[_oRegPZX:nAt][09], "
_cRet += "_aRegPZX[_oRegPZX:nAt][10], "
_cRet += "_aRegPZX[_oRegPZX:nAt][11]  "
_cRet += " } } "

Return _cRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ _fStatus   º Autor ³                      º Data ³ 11/07/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao ³ Funcao para apresentar a Situacao do Tracking.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ Kingstar Colchoes                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _fStatus()

Local _oRet
Local _nPos	:= 0 

_nPos	:= aScan( _aStatus, { |x| x[1] == _aRegPZX[_oRegPZX:nAt][1] } )

If _nPos > 0
	_oRet := _aStatus[_nPos][2]		// Carrega o correspondente encontrado
Else
	_oRet := _aStatus[2][2]			// Carrega Vermelho
EndIf

Return _oRet

*--------------------*
User Function zEti2Vol
*--------------------*
u_zAutoPvEtq(PZU->PZU_NUM)
RETURN

*--------------------*
User Function zEti2Nfe
*--------------------*
u_zAutoNFEtq(PZU->PZU_DOC+PZU->PZU_SERIE)
RETURN
