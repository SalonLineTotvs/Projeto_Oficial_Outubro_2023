#INCLUDE "TOTVS.ch"

/*/{Protheus.doc} User Function DContra
    Gatilho para pegar ovalor do desconto de contrato
    @type  Function
    @author Samuel de Vincenzo
    @since 12/09/2022
    @version 1.0
/*/
User Function DContra()
	//Local lRet      := .T.
	//Local aAreaSC5  := SC5->(GetArea())
	//Local aAreaSA1  := SA1->(GetArea())

	Default VDesconto := 0

	//Faço as validações conforme regras informadas no documento de Desconto Financeiro

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSelectArea("SE4")
	DbSetOrder(1)

	if (SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ) ) )

		//----------------------------------------
		//1.	DESCONTO CONTRATUAL
		//----------------------------------------
		if ( SA1->A1_X_DCONT > 0 .And. M->C5_TIPO == "N" )

			VDesconto += SA1->A1_X_DCONT
			M->C5_X_DCONT := SA1->A1_X_DCONT
			GetDRefresh()
		else
			vDesconto := 0
			M->C5_X_DCONT := 0
			GetDRefresh()
		endif
	endif

	//SA1->( DbCloseArea() )

	//RestArea(aAreaSC5)
	//RestArea(aAreaSA1)

Return VDesconto

/*/{Protheus.doc} User Function DExpora
    Gatilho para pegar o valor do desconto Exporadico
    @type  Function
    @author Samuel de Vincenzo
    @since 12/09/2022
    @version 1.0
/*/
User Function DExpora()
	//Local lRet      := .T.
	//Local aAreaSC5  := SC5->(GetArea())
	//Local aAreaSA1  := SA1->(GetArea())
	Local cCondPgtoA := AllTrim( SuperGetMV( "ES_CondPgA",,"  " ) )
	Local cTranspor := AllTrim( SuperGetMV( "ES_Transpo",,"  " ) )

	Default VDesconto := 0

	//Faço as validações conforme regras informadas no documento de Desconto Financeiro

	DbSelectArea("SA1")
	DbSetOrder(1)
	
	if (SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ) ) )

		//--------------------------------
		//2.	DESCONTO ESPORÁDICO
		//--------------------------------
		if ( SA1->A1_X_FORMP ==  'BOL')

			//Valido se a condição de Pagamento for igual à Vista
			if (M->C5_CONDPAG $ cCondPgtoA)

				VDesconto += SA1->A1_X_DEXPO
				M->C5_X_DEXPO := SA1->A1_X_DEXPO
				GetDRefresh()

			//verifico se o meio de Entrega é "Retira" ou qualquer outro que venha se cadastrado
			elseif (M->C5_TRANSP $ cTranspor)
				VDesconto += SA1->A1_X_DEXPO
				M->C5_X_DEXPO := SA1->A1_X_DEXPO
				GetDRefresh()
			else
				vDesconto := 0
				M->C5_X_DEXPO := 0
				GetDRefresh()
			endif

		endif


	endif

	//SA1->( DbCloseArea() )
	//RestArea(aAreaSC5)
	//RestArea(aAreaSA1)

Return VDesconto

/*/{Protheus.doc} User Function DCondpg
    Gatilho para pegar o valor do desconto Condição de Pagamento
    @type  Function
    @author Samuel de Vincenzo
    @since 12/09/2022
    @version 1.0
/*/            
User Function DCondpg()
	//Local lRet     := .T.
	//Local aAreaSC5 := SC5->(GetArea())
	//Local aAreaSA1 := SA1->(GetArea())
	//Local aAreaSE4 := SE4->(GetArea())
	Local cCondPgtoP := AllTrim( SuperGetMV( "ES_CondPgP",,"  " ) )
	
	Default VDesconto := 0

	//Faço as validações conforme regras informadas no documento de Desconto Financeiro

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSelectArea("SE4")
	DbSetOrder(1)

	if (SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ) ) )

		//-------------------------------------------------
		//3.	DESCONTO DE BOLETO X CONDIÇÃO DE PAGAMENTO
		//-------------------------------------------------
		if (SA1->A1_X_FORMP == 'BOL')

			//Verifico se a condição de pagamento informada é umas das condições incluídas no Parâmetro
			if (M->C5_CONDPAG $ cCondPgtoP)

				//Se for uma das condições verifico se o campos E4_X_ODESC está como sim
				if ( SE4->( DbSeek(xFilial("SE4")+M->C5_CONDPAG ) ) )
						VDesconto += SA1->A1_X_DPRAZ
						M->C5_X_DPRAZ := SA1->A1_X_DPRAZ
						GetDRefresh()
				endif
			else
				vDesconto := 0
				M->C5_X_DPRAZ := 0	
				GetDRefresh()
			endif
		endif

	endif
	
	//SA1->( DbCloseArea() )
	//SE4->( DbCloseArea() )

	//RestArea(aAreaSC5)
	//	RestArea(aAreaSA1)
	//	RestArea(aAreaSE4)

Return VDesconto

/*/{Protheus.doc} User Function DAcorLg
    Gatilho para pegar o valor do desconto Acordo Logistico
    @type  Function
    @author Samuel de Vincenzo
    @since 12/09/2022
    @version 1.0
/*/
User Function DAcorLg()
	//Local lRet      := .T.
	//Local aAreaSC5   := SC5->(GetArea())
	//Local aAreaSA1   := SA1->(GetArea())

	Default VDesconto := 0

	//Faço as validações conforme regras informadas no documento de Desconto Financeiro

	DbSelectArea("SA1")
	DbSetOrder(1)
	
	if (SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ) ) )

		//-------------------------------------------------
		//4.	DESCONTO DE ACORDO LOGÍSTICO
		//-------------------------------------------------
		//Verifico se o campo de desconto está preenchido, caso contrário
		//emito Alerta e não deixo ir para frente
		if ( SA1->A1_X_DACOR > 0 )
			VDesconto += SA1->A1_X_DACOR
			M->C5_X_DACOR := SA1->A1_X_DACOR
			GetDRefresh()
		else
			vDesconto := 0	
			M->C5_X_DACOR := 0	
			GetDRefresh()
		endif
	endif

	//("SA1")->( DbCloseArea() )
	//RestArea(aAreaSC5)
	//RestArea(aAreaSA1)

Return VDesconto

/*/{Protheus.doc} User Function DFreteF
    Gatilho para pegar o valor do desconto Acordo Frete FOB
    @type  Function
    @author Samuel de Vincenzo
    @since 12/09/2022
    @version 1.0
/*/
User Function DFreteF()
	//Local lRet      := .T.
	//Local aAreaSC5   := SC5->(GetArea())
	//Local aAreaSA1   := SA1->(GetArea())

	Default VDesconto := 0

	//Faço as validações conforme regras informadas no documento de Desconto Financeiro

	DbSelectArea("SA1")
	DbSetOrder(1)

	if (SA1->( DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ) ) )

		//-------------------------------------------------
		//5.	DESCONTO FRETE FOB
		//-------------------------------------------------
		if (M->C5_TPFRETE == "F")

			//Verifico se o campo de desconto está preenchido, caso contrário
			//emito Alerta e não deixo ir para frente
			if ( SA1->A1_X_DFREF > 0 )
				VDesconto += SA1->A1_X_DFREF
				M->C5_X_DFRET := SA1->A1_X_DFREF
				GetDRefresh()
			else
				vDesconto := 0	
				M->C5_X_DFRET := 0	
				GetDRefresh()
			endif	

		else
			vDesconto := 0	
			M->C5_X_DFRET := 0	
			GetDRefresh()	
		endif
	endif
	
//SA1->( DbCloseArea() )
//RestArea(aAreaSC5)
//RestArea(aAreaSA1)

Return VDesconto
