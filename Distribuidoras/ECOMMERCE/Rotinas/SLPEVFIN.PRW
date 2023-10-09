#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

USER FUNCTION ADFG()

Prepare Environment Empresa "02" Filial "1501" Modulo "FAT"   

U_SLINTPZU(.T.)
RESET Environment

RETURN 


User Function SLINTPZU(lSched)
	Default lSched:=.T.
	Local _oSay 
	Local _c_EmpAnt := cEmpAnt
	Local _c_FilAnt := cFilAnt
	Local _cModulo  := cModulo
	Local _nModulo  := nModulo

	FwMsgRun( NIL, { |_oSay| U_SLFINECO( lSched , _oSay ) }, , "Processando pedidos e-Commerce... Ped. E-commerce : " )

	cEmpAnt	:= _c_EmpAnt 
	cFilAnt := _c_FilAnt 
	cModulo := _cModulo 
	nModulo := _nModulo 

Return Nil

User Function SLFINECO( lSched, _oSay )

Local cMenErro	:= ""
Local oDlg		:= Nil
Local oMemo		:= Nil
Local SButton	:= Nil
Local cFile   	:= ""
Local cFileLog	:= ""
Local cMask    	:= "Arquivos Texto" + "(*.TXT)|*.txt|"

	DbSelectArea("PZU")
	PZU->( DbSetOrder(1) )
	DbSelectArea("PZV")
	PZV->( DbSetOrder(1) )

	ProcTit( @cMenErro, lSched, _oSay )

If ! Empty( cMenErro )	
	Define Font oFont Name "Mono AS" Size 5, 12

	cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cMenErro )

	//Tela com LOG de Erro
	Define MsDialog oDlg Title "Erro Integração de Titulos a Receber" From 3, 0 to 340, 417 Pixel

		@ 5, 5 Get oMemo Var cMenErro Memo Size 200, 145 Of oDlg Pixel

	oMemo:bRClicked := { || AllwaysTrue() }
	oMemo:oFont     := oFont

	Define SButton From 153, 175 Type 01 Action oDlg:End() Enable Of oDlg Pixel
	Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T.,	MemoWrite( cFile, cMenErro ) ) ) Enable Of oDlg Pixel

	Activate MsDialog oDlg Center
EndIf


Return 

/*/{Protheus.doc} ProcTit
@description 	Processa ID do Pedido e Gera os titulos financeiros
/*/
Static Function ProcTit( cMenErro, lSched, _oSay )

Local _cFilPZU		:= xFilial("PZU")
Local _cFilPZV		:= xFilial("PZV")
Local _aArea		:= GetArea()
Local _cAliasPZU	:= GetNextAlias()
Local _cRetSE1		:= ""
Local _cRetSE12		:= ""
Local _Ret			:= .F.
Local _cRetE1Aux	:= ""
Local _cEmpSafe		:= ""
Local _cFilSafe		:= ""
Local cMenErr		:= ""
Local lExist		:= .F.
Local cNumOrc		:= ""
Local cForNome		:= "" 
Local nValTot	    := 0
Local nVariavel		:= 0
Local _aPZUTemp		:= {}
Local _nX 			:= 0
Local _lErro		:= .F.
Local _lxPZX 		:= .F. 

// Query que busca os registros da PZU com status '1' a serem processados
BeginSQL Alias _cAliasPZU
	SELECT PZU_FILIAL, PZU_PEDECO, PZU_STATUS, R_E_C_N_O_ AS RECPZU
	  FROM %Table:PZU%
	 WHERE %NotDel%
	   AND PZU_FILIAL = %Exp:_cFilPZU%
	   AND PZU_STATUS IN('0','2')
	   AND PZU_CHVSE1 = ''
EndSQL

ConOut("Data: " + DtoC( dDatabase ) + " - Hora: " + Time() )
ConOut("Iniciando a geração dos títulos a receber (SE1) dos pedidos pendentes...")
ConOut("========================================================================")
ConOut("")

_cEmpSafe	:= cEmpAnt
_cFilSafe	:= cFilAnt

While  ( _cAliasPZU )->( ! Eof() )

	aAdd( _aPZUTemp, { 	( _cAliasPZU )->PZU_FILIAL	,; 
						( _cAliasPZU )->PZU_PEDECO	,; 
						( _cAliasPZU )->PZU_STATUS	,; 
						( _cAliasPZU )->RECPZU  	})

	( _cAliasPZU )->( DbSkip() ) 
EndDo

( _cAliasPZU )->( DbCloseArea() )

RestArea( _aArea )

For	_nX := 1 to Len( _aPZUTemp )

	ConOut("     Integrando pedido e-commerce " + Alltrim( _aPZUTemp[ _nX , 2 ] ) + " | PZU Recno [" + Alltrim(Str( _aPZUTemp[ _nX , 4 ] )) + "]..." )
	ConOut("     -------------------------------------------------------------------------")

	// Posiciona na PZU no registro correspondente
	PZU->( DbGoTo( _aPZUTemp[ _nX , 4 ] ) )	// ( _cAliasPZU )->RECPZU

	// Caso o registro não seja encontrado na PZU ou caso não esteja posicionado no registro correto...
	IF	PZU->(EOF()) .OR. (Alltrim(PZU->PZU_FILIAL + PZU->PZU_PEDECO) <> Alltrim( _aPZUTemp[ _nX , 1 ] + _aPZUTemp[ _nX , 2 ] ))	// ( _cAliasPZU )->PZU_FILIAL + ( _cAliasPZU )->PZU_PEDECO
		PZU->( DbSeek(  _aPZUTemp[ _nX , 1 ] + _aPZUTemp[ _nX , 2 ] ) )	//... busca na PZU pela filial e nro do pedido...
	EndIf 

	// ...e processa o registro correto da PZU
	IF PZU->( ! EOF() )
		
		nValTot 	:= 0
		ConOut("        ...registro encontrado Ok!")

		IF	!lSched 
			_oSay:SetText("Integrando Pedido e-Commerce " + Alltrim(PZU->PZU_PEDECO) )
		EndIf
	
		PZV->( DbSeek( _cFilPZV + PZU->PZU_PEDECO ))

		While !PZV->(EOF()) .And. PZV->PZV_FILIAL == _cFilPZV .And. PZV->PZV_PEDECO == PZU->PZU_PEDECO

			nValTot += ( ( PZV->PZV_QTDVEN * PZV->PZV_VLUNIT ) - PZV->PZV_DESC )
			PZV->( DbSkip() )
		EndDo

		// Tolerancia de 0.05 de diferenca 
		nVariavel := PZU->PZU_VALOR - nValTot

		IF 	nVariavel < -0.05 .OR. nVariavel > 0.05
			MSGINFO("Pedido: "+ALLTRIM(PZU->PZU_PEDECO)+". Valor total dos produtos divergente do valor total do pedido. Favor corrigir os valores dos produtos!")
			LOOP
		endif

		nValTot	+= PZU->PZU_FRETE	// Finaliza o total do titulo com o valor do frete...

		ConOut("        Valor total do pedido " + Alltrim(PZU->PZU_PEDECO) + ": R$ " + Transform( nValTot, "@E 999,999,999.99" ) + "  >>>  Data: " + DTOC(dDatabase) + " as " + Time() )

		cMenErr := ""

		If 	ExistCR( PZU->PZU_PEDECO, @cMenErr, @_cRetE1Aux )
			// "Título a receber de chave 141000056064A CC já associado ao pedido e-commerce 13076. Verifique "
			_cRetSE1 := _cRetE1Aux	//"  " + Substr( cMenErr, 27, (TamSX3("PZU_CHVSE1")[1])-2  )
		Else 

			If	PZU->PZU_VLRPG > 0 
				nValTot := PZU->PZU_VLRPG
			EndIf

			//Gera Financeiro / Finaliza processamento
			_cRetSE1 := GeraFin( 	cNumOrc			, @cMenErr			, PZU->PZU_ADMFIN	, PZU->PZU_FORMPG	, cForNome 			,;
									PZU->PZU_NSU	, PZU->PZU_AUTCAR	, PZU->PZU_NRPARC	, PZU->PZU_CLIENT	, PZU->PZU_LOJA		,;
									PZU->PZU_DATA	, nValTot			, PZU->PZU_VEND		, PZU->PZU_DTPAG	, PZU->PZU_NATURE 	,;
									PZU->PZU_PEDECO	, PZU->PZU_ORIGEM 	)
		EndIf 

		IF ! Empty( cMenErr )
			ConOut( cMenErr )
		EndIf 

		// Geracao do titulo da segunda forma de pagamento
		If ! Empty( PZU->PZU_FORPG2 ) .AND. PZU->PZU_VLRPG2 > 0
			_cRetSE12  := GeraFin( 	cNumOrc			, @cMenErr			, PZU->PZU_ADMFN2	, PZU->PZU_FORPG2	, cForNome			,;
									PZU->PZU_NSU2	, PZU->PZU_AUTCR2	, PZU->PZU_NPARC2	, PZU->PZU_CLIENT	, PZU->PZU_LOJA		,;
									PZU->PZU_DATA	, PZU->PZU_VLRPG2 	, PZU->PZU_VEND		, PZU->PZU_DTPAG	, PZU->PZU_NATURE 	,;
									PZU->PZU_PEDECO	, PZU->PZU_ORIGEM )
		EndIf 

		IF ! Empty( cMenErr )
			ConOut( cMenErr )
		EndIf 

		// Se o título foi gravado corretamente ma SE1, retorna a chave do titulo ==> E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO...
		IF ! Empty( _cRetSE1 ) 
			IF ! lSched 
				_oSay:SetText("Integrando Pedido e-Commerce " + Alltrim(PZU->PZU_PEDECO) + " | Título a Receber : " + Alltrim(_cRetSE1) )
			EndIf

			SE1->( DbSetOrder(1) )
			SE1->( DbSeek( _cRetSE1 ) ) 

			// Posiciona na PZU no registro correspondente
			PZU->( DbGoTo( _aPZUTemp[ _nX , 4 ] ) )	// ( _cAliasPZU )->RECPZU

			Reclock("PZU", .F.)
				PZU->PZU_CHVSE1	:= _cRetSE1	// ... e grava esta chave na PZU

				PZU->PZU_DTPAG	:= Iif( !SE1->(EOF()), SE1->E1_VENCREA, PZU->PZU_DTPAG )

				If ! Empty(_cRetSE12)
					PZU->PZU_CHVE12 := _cRetSE12
				EndIf 
			PZU->( MsUnlock() )
				// Uma vez criado e registrado o título financeiro, dispara a geração dos PVs
			_cRetOrc := U_SLGeraPV( lSched, PZU->PZU_PEDECO )
			

			IF ! Empty( _cRetOrc )
				IF ! lSched 
					_oSay:SetText("Integrando Pedido e-Commerce " + Alltrim(PZU->PZU_PEDECO) + " | Título a Receber : " + Alltrim(_cRetSE1) + " | Pedido de Venda : " + Alltrim(_cRetOrc) )
				EndIf

				// Posiciona na PZU no registro correspondente
				PZU->( DbGoTo( _aPZUTemp[ _nX , 4 ] ) )	// ( _cAliasPZU )->RECPZU
				
				_cStatAtual:=PZU->PZU_STATUS	

				Reclock("PZU", .F.)
					PZU->PZU_NUM	:= _cRetOrc	// ...] e grava esta chave na PZU
					PZU->PZU_STATUS := if(_cStatAtual=="0","1","3")		// Pedido Emitido bloqueado por credito ou Pedido Emitido...
				PZU->( MsUnlock() )

				// Atualiza a tabela PZX - Tracking do pedido e-commerce
				If  PZU->PZU_STATUS == "1" .OR. PZU->PZU_STATUS == "3"  // Caso o status do pedido e-commerce tenha sido alterado com sucesso para 3-Pedido Emitido

					If  PZX->( DbSeek( xFilial("PZX") + PZU->PZU_PEDECO ))

						While !PZX->( Eof() ) .And. PZX->PZX_FILIAL == xFilial("PZX") .And. PZX->PZX_PEDECO == PZU->PZU_PEDECO
							If  PZX->PZX_STATUS == PZU->PZU_STATUS 
								_lxPZX := .T.
								Exit 
							EndIf 

							PZX->( DbSkip() )
						EndDo 

						If  !_lxPZX
							RecLock( "PZX", .T. )
								PZX->PZX_FILIAL := xFilial("PZX")
								PZX->PZX_PEDECO := PZU->PZU_PEDECO 
								PZX->PZX_DATA   := dDatabase 
								PZX->PZX_HORA   := Time() 
								PZX->PZX_STATUS := PZU->PZU_STATUS 
								PZX->PZX_ORIGEM := "1"  // e-commerce
							PZX->( MsUnlock() )
						EndIf 

						_lxPZX := .F. 
					Else 
						RecLock( "PZX", .T. )
							PZX->PZX_FILIAL := xFilial("PZX")
							PZX->PZX_PEDECO := PZU->PZU_PEDECO 
							PZX->PZX_DATA   := dDatabase 
							PZX->PZX_HORA   := Time() 
							PZX->PZX_STATUS := PZU->PZU_STATUS 
							PZX->PZX_ORIGEM := "1"  // e-commerce
						PZX->( MsUnlock() )
					EndIf 
					IF PZU->PZU_STATUS == "3" 
						DBSELECTAREA('SC9')
						DBSETORDER(1)
						if SC9->(DBSEEK(XFILIAL("SC9")+PZU->PZU_NUM))
							WHILE SC9->C9_FILIAL==xFILIAL("SC9") .AND. SC9->C9_PEDIDO==PZU->PZU_NUM
								RecLock('SC9', .F.)
								SC9->C9_BLCRED := ""
								MSUNLOCK()
								SC9->(DBSKIP())
							ENDDO
						ENDIF
					ENDIF
				EndIf 
				// Gravacao do tracking concluida
			EndIf
		EndIf 
	EndIf 
Next _nX

cEmpAnt := _cEmpSafe
cFilAnt := _cFilSafe 

RestArea( _aArea )

Return 

/*/{Protheus.doc} GeraFin
@description 	Gera Financeiro conforme Pedido / Pagamento
/*/

Static Function GeraFin( 	cNumOrc , cMenErr, cAdmFin	, cFormaPG, cForNome, cNsuVen, cAutCar	, nQtdParc	, cCliente, cLojaCli,;
							dDtEmiss, nValTot, cVendedor, dDataPag, cNaturez, cPedWeb, cOrigEco)
	
	Local cFilEcco	:= cFilAnt
	
	Local cPrefixo	:= SuperGetMv( "ES_RECPREF", Nil, "REC" )
	Local cParcela	:= PadR( SuperGetMV( "MV_1DUP" ), TamSX3( "E1_PARCELA" )[1] )
	Local cParcRA	:= CriaVar( "E1_PARCELA" )
	Local cParcTit	:= "0"
	Local cNatur	:= GetMv( "MV_NATRECE" )
	Local cMenExec	:= ""
	Local cHistor	:= ""	
	Local _lMkPlace	:= .F.
	Local lRetorno	:= .T.
	Local nTaxaAdm	:= 0
	Local nDiasVen	:= 0
	Local nValSTx	:= 0
	Local nValPST	:= 0
	Local nValPCT	:= 0
	Local cNumTit	:= ""
	Local nTit		:= 0
	Local cNumTitPG	:= ""	
	Local aAreaAT	:= GetArea()
	Local aAreaE1	:= SE1->( GetArea() )
	Local aAreaE5	:= SE5->( GetArea() )
	Local _nX 		:= 0
	Local oContaRec		:= Nil
	Local oBaixaRec		:= Nil

	Local cNsuGrv		:= Alltrim( cNsuVen )

	// Var's para tentar melhorar performance
	Local _nTamTipo		:= TamSx3( "E1_TIPO" 		)[1]
	Local _nTamCli		:= TamSx3( "E1_CLIENTE" 	)[1]
	Local _nTamLoja		:= TamSx3( "A1_LOJA" 		)[1]
	Local _nTamNatur	:= TamSx3( "E1_NATUREZ" 	)[1]
	Local _nTamPref		:= TamSx3( "E1_PREFIXO" 	)[1]
	Local _nTamNumTit	:= TamSx3( "E1_NUM" 		)[1]
	Local _nTamParc		:= TamSx3( "E1_PARCELA" 	)[1]

	Local _cRetSE1 		:= ""
	
	//Variaveis criadas para compatibilidade com rotinas padroes (KingStar)
	Private _dDataPgto	:= dDtEmiss
	Private _cNumOrc	:= cNumOrc
	Private _cCodClie	:= cCliente
	Private _cLojaCli	:= cLojaCli
	Private _cNomeCli	:= Posicione( "SA1", 1, xFilial( "SA1" ) + cCliente + cLojaCli, "A1_NOME" )

	Private aArraySE2	:= {}
	Private aAutoCab 	:= {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	cNatOu:='1001A'     

	//Tratamento para natureza (Limpa Aspas que vem do parametro)
	If  AT( '"', cNatOu ) > 0
		cNatOu	:= StrTran( cNatOu, '"', '' )
	EndIf

	cNumTit		:= GetNumSE1( '1501' )

	//Gera Titulo para Recebimento
	//Instancia Classe
	oContaRec	:= FinCRFb():New()

	oContaRec:AddValues( "E1_FILIAL"	, xFilial( "SE1" ) 								)
	oContaRec:AddValues( "E1_PREFIXO"	, cFilAnt 										)
	oContaRec:AddValues( "E1_NUM"		, cNumTit										)
	oContaRec:AddValues( "E1_PARCELA"	, cParcela										)
	oContaRec:AddValues( "E1_TIPO"		, PadR( cFormaPG	, _nTamTipo )				)
	oContaRec:AddValues( "E1_CLIENTE"	, cCliente 			 							)
	oContaRec:AddValues( "E1_LOJA"		, cLojaCli			 							)
	oContaRec:AddValues( "E1_NATUREZ"	, PadR( cNatOu, _nTamNatur )					)
	oContaRec:AddValues( "E1_EMISSAO"	, dDtEmiss										)
	oContaRec:AddValues( "E1_EMIS1" 	, dDtEmiss										)
	oContaRec:AddValues( "E1_VENCTO"	, dDataPag										)
	oContaRec:AddValues( "E1_VENCREA"	, DataValida(dDataPag)							)
	oContaRec:AddValues( "E1_VALOR"		, nValTot										)
	oContaRec:AddValues( "E1_VLRREAL"	, nValTot										)
	oContaRec:AddValues( "E1_VEND1"		, cVendedor										)
	oContaRec:AddValues( "E1_ORIGEM"	, "ECOMMERCE"									)
	oContaRec:AddValues( "E1_FLUXO"		, "S"											)				
	oContaRec:AddValues( "E1_MULTNAT"	, "2"											)
	oContaRec:AddValues( "E1_STATUS"	, "A"											)
	oContaRec:AddValues( "E1_SERIE"		, cFilAnt  										)
	oContaRec:AddValues( "E1_NUMNOTA"	, cNumOrc										)
	oContaRec:AddValues( "E1_DOCTEF"	, cNsuGrv										)
	oContaRec:AddValues( "E1_NSUTEF"	, cNsuGrv										)	
	oContaRec:AddValues( "E1_XPEDECO"	, cPedWeb										)		
	
	If  oContaRec:Gravacao( 3 )
		lRetorno 	:= .T.
		_cRetSE1	:= SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO						
	Else 
		lRetorno	:= .F.
		_cRetSE1	:= ""
		cMenExec	:= oContaRec:GetMensagem()
	EndIf
 
			
	If ! lRetorno
		DisarmTransaction()
	EndIf

	If ! lRetorno
		cMenErr	:= cMenExec
	EndIf

	RestArea( aAreaE5 )
	RestArea( aAreaE1 )
	RestArea( aAreaAT )

Return _cRetSE1


/*/{Protheus.doc} SLGeraPV
@description 	Gera Pedido de Venda 
/*/
User Function SLGeraPV( lSched, CPEDWEB )

Local _cFilPZU		:= xFilial("PZU")
Local _cFilPZV		:= xFilial("PZV")
Local _cFilSB1		:= xFilial("SB1")
Local cFilBack		:= ""
Local cPedido	 	:= ""
Local _cSC5Ret		:= ""
Local cTabPreco		:= SuperGetMV( "SL_TABPRC", Nil, "012")
Local _cTEs         := SuperGetMV( "SL_TESB2B2"	, Nil,'518') 
Local cTESEntre		:= SuperGetMV( "FS_TESENTR"	, Nil, "" )
Local cTESIntEst	:= SuperGetMV( "FS_TESINTE"	, Nil, "" )	
Local cEstAtu		:= SuperGetMV( "MV_ESTADO"	, Nil, "" )	
Local cTurnoEn		:= SuperGetMv( "MV_LJTURNO", Nil, "M" )
Local cCpoNew
Local xConteu		:= ""
Local nAddEco		:= 0
Local cNumOrc		:= ""
Local cMenErr		:= ""
Local cTpFrete		:= "C"
Local cForNome		:= ""
Local cNumOCD		:= ""
Local lRetorno		:= .T.
Local nW 			:= 0
Local nY			:= 0
Local _aArea		:= GetArea()
Local _cRetC5Aux	:= ""
Local _cMensagemSC5	:= ""
Local _nVolume		:=0 
Local _nPesBruto	:=0
Local _PesLiq		:=0
DbSelectArea("SA1")
SA1->( DbSetOrder(1) )	// A1_FILIAL + A1_COD + A1_LOJA
SA1->( DbSeek( xFilial("SA1") + PZU->PZU_CLIENT + PZU->PZU_LOJA ) )                           

// Indice PZV (1) - PZV_FILIAL + PZV_PEDECO + PZV_PRODUT + PZV_ITEM
PZV->( DbSeek( _cFilPZV + PZU->PZU_PEDECO ) )
 

cMenErr := ""

IF	ExistPV( Alltrim(cPedWeb), @cMenErr, @_cRetC5Aux ) 

	cPedido := _cRetC5Aux

	IF	!Empty( cMenErr )
		ConOut( cMenErr )
	EndIf 

	lRetorno := .F.
EndIf 

If  lRetorno // Caso NÃO exista um pedido de e-commerce associado a este pedido de venda

	//===================================================================================
	// Gera Pedido de Venda 
	//===================================================================================
	//Instancia Classe de Pedido de Venda
	oPedido	:= PedVdaFb():New()

	//Adiciona Cabecalho
/*	oPedido:AddCabec( "EMPRESA"			, cEmpAnt 												)
	oPedido:AddCabec( "C5_FILIAL"		, cFilAnt 												)
	oPedido:AddCabec( "C5_TIPO"			, "N"													)
	oPedido:AddCabec( "C5_CLIENTE"		, PZU->PZU_CLIENT										)
	oPedido:AddCabec( "C5_LOJACLI"		, PZU->PZU_LOJA											)
	oPedido:AddCabec( "C5_CLIENT"		, PZU->PZU_CLIENT										)
	oPedido:AddCabec( "C5_LOJAENT"		, PZU->PZU_LOJA											)
	oPedido:AddCabec( "C5_CONDPAG"		, PZU->PZU_CONDPG										) 
	//oPedido:AddCabec( "C5_TABELA"	    , cTabPreco												)	 
	oPedido:AddCabec( "C5_EMISSAO"		, dDatabase												)
	oPedido:AddCabec( "C5_VEND1"		, PZU->PZU_VEND											)
	oPedido:AddCabec( "C5_TPFRETE"		, "C"												 	)						
	oPedido:AddCabec( "C5_TRANSP"		, PZU->PZU_TRANSP										)
	oPedido:AddCabec( "C5_LIBEROK"		, "S"													)
	oPedido:AddCabec( "C5_NATUREZ"		, PZU->PZU_NATURE										)	// cNatPed
	oPedido:AddCabec( "C5_XPEDECO"		, cPedWeb												)	
*/
	//Adiciona Itens
	PZV->( DbSeek( _cFilPZV + PZU->PZU_PEDECO ) )

	nAddEco := 0	// Sera contador de itens para iniciar a gravacao dos itens do pedido de venda

	While 	!PZV->(Eof()) .And. PZV->PZV_FILIAL == _cFilPZV .And. PZV->PZV_PEDECO == PZU->PZU_PEDECO
		//	cCodAce := if(!EMPTY(PZV->PZV_KIT),POSICIONE('SUG',2,xfilial('SUG')+ PZV->PZV_KIT,'UG_CODACE'),'')
		//	nDescKit:= PZV->PZV_QTDVEN*(if(!EMPTY(cCodAce),POSICIONE('SU1',1,xfilial('SU1')+ cCodAce+PZV->PZV_PRODUT,'U1_DESCVAL'),0))
		_nVolume	+= PZV->PZV_QTDVEN
		_nPesBruto	+= POSICIONE('SB1',1,xFilial('SB1')+PZV->PZV_PRODUT,'B1_PESBRU')* PZV->PZV_QTDVEN
		_PesLiq		+= POSICIONE('SB1',1,xFilial('SB1')+PZV->PZV_PRODUT,'B1_PESO')* PZV->PZV_QTDVEN
		nAddEco	++
		oPedido:AddItem( "C6_FILIAL"	, cFilAnt														)
		oPedido:AddItem( "C6_ITEM"		, StrZero( nAddEco, TamSX3("C6_ITEM")[1] )				 		)
		oPedido:AddItem( "C6_PRODUTO"	, PZV->PZV_PRODUT									  			)
		oPedido:AddItem( "C6_QTDVEN"	, PZV->PZV_QTDVEN									  			)
		oPedido:AddItem( "C6_PRCVEN"	, PZV->PZV_VLUNIT									  			)
		oPedido:AddItem( "C6_VALOR"		, PZV->PZV_PRCVEN						            	   		)
		oPedido:AddItem( "C6_PRCTAB"	, PZV->PZV_PRCTAB												)	// PZV->PZV_PRCTAB
		oPedido:AddItem( "C6_UM"		, Posicione("SB1",1, _cFilSB1 + PZV->PZV_PRODUT, "B1_UM") 		)
		oPedido:AddItem( "C6_VALDESC"	, PZV->PZV_DESC  											    )			
		oPedido:AddItem( "C6_TES"		, _cTes 														)
		oPedido:AddItem( "C6_LOCAL"		, '01'                                               	        ) //Posicione("SB1",1, _cFilSB1 + PZV->PZV_PRODUT, "B1_LOCPAD")	
		oPedido:AddItem( 'C6_PRUNIT'	, PZV->PZV_VLUNIT-PZV->PZV_DESC									)	//xConteu	:= oOrcament:aItens[ nW ][ 6 ][ 02 ]

		oPedido:SetItem()
	
		PZV->( DbSkip() )
	EndDo 

	//Adiciona Cabecalho
	oPedido:AddCabec( "EMPRESA"			, cEmpAnt 												)
	oPedido:AddCabec( "C5_FILIAL"		, cFilAnt 												)
	oPedido:AddCabec( "C5_TIPO"			, "N"													)
	oPedido:AddCabec( "C5_CLIENTE"		, PZU->PZU_CLIENT										)
	oPedido:AddCabec( "C5_LOJACLI"		, PZU->PZU_LOJA											)
	oPedido:AddCabec( "C5_CLIENT"		, PZU->PZU_CLIENT										)
	oPedido:AddCabec( "C5_LOJAENT"		, PZU->PZU_LOJA											)
	oPedido:AddCabec( "C5_CONDPAG"		, PZU->PZU_CONDPG										) 
	oPedido:AddCabec( "C5_PESOL"	    , _PesLiq												)	 
	oPedido:AddCabec( "C5_PBRUTO"	    , _nPesBruto											)	 
	oPedido:AddCabec( "C5_VOLUME1"	    , _nVolume												)	 
	oPedido:AddCabec( "C5_EMISSAO"		, dDatabase												)
	oPedido:AddCabec( "C5_VEND1"		, PZU->PZU_VEND											)
	oPedido:AddCabec( "C5_TPFRETE"		, "C"												 	)						
	oPedido:AddCabec( "C5_TRANSP"		, PZU->PZU_TRANSP										)
	oPedido:AddCabec( "C5_LIBEROK"		, "S"													)
	oPedido:AddCabec( "C5_NATUREZ"		, PZU->PZU_NATURE										)	// cNatPed
	oPedido:AddCabec( "C5_XPEDECO"		, cPedWeb												)	

	// Grava pedido de Venda
	If oPedido:Gravacao( 3, lRetorno, PZU->PZU_PRAZO, cNumOrc ) 	// dDtPrazoEn

		//Resgata pedido gerado
		cPedido	 := oPedido:GetNumero()  
	Else
		lRetorno	:= .F.
		cMenErr		:= oPedido:GetMensagem()
		cPedido		:=''
	EndIf
EndIf


RestArea(_aArea)

Return cPedido



/*/{Protheus.doc} ExistCR
@description 	Verifica se existe titulos a receber associado ao pedido Web Ja gerado
/*/
Static Function ExistCR( cPedWeb, cMenErr, _cRetE1Aux )

	Local _aArea	:= GetArea()
	Local cAliW		:= GetNextAlias()
	Local lExist	:= .F.
	
	BeginSQL Alias cAliW
		SELECT MAX(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) E1PEDECO 
		  FROM %Table:SE1%
		 WHERE %NotDel%
		   AND E1_XPEDECO = %Exp:cPedWeb%
    EndSQL

	If ( cAliW )->( ! Eof() )

		IF	!Empty( ( cAliW )->E1PEDECO )
			lExist 	:= .T.
			cMenErr := "Título a receber de chave " + Alltrim( ( cAliW )->E1PEDECO ) + " já associado ao pedido e-commerce " + Alltrim(cPedWeb) + ". Verifique "
			_cRetE1Aux := ( cAliW )->E1PEDECO
		EndIf

	EndIf

	( cAliW )->( DbCloseArea() )

	RestArea( _aArea )

Return lExist

Static Function ExistPV( cPedWeb, cMenErr, _cRetC5Aux )

	Local _aArea	:= GetArea()
	Local cAliW		:= GetNextAlias()
	Local lExist	:= .F.
	
	BeginSQL Alias cAliW
		SELECT C5_NUM
		  FROM %Table:SC5%
		 WHERE %NotDel%
		   AND C5_XPEDECO = %Exp:cPedWeb%
	EndSQL

	If ( cAliW )->( ! Eof() )

		If !Empty( ( cAliW )->C5_NUM )
			lExist 	:= .T.
			cMenErr := "Pedido de Venda nro. " + Alltrim( ( cAliW )->C5_NUM ) + " já associado ao pedido e-commerce " + Alltrim(cPedWeb) + ". Verifique "
			_cRetC5Aux := ( cAliW )->C5_NUM
		EndIf 

	EndIf

	( cAliW )->( DbCloseArea() )

	RestArea( _aArea )

Return lExist
