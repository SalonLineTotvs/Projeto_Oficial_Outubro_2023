#INCLUDE "TOTVS.CH"
#INCLUDE "MSOBJECT.CH"

User Function ClsPedido()
Return Nil

/*/{Protheus.doc} PedVdaFb
@description	Classe Responsavel pela gravacao do Pedido de Venda via
				MsExecAuto
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/

Class PedVdaFb From ClsExAuto
	Data cPedido
	Data dEmissao
	Data cPedWeb
	Data cFormaPG
	Data cNomPagto
	Data cAdmFin
	
	Method New()
	Method AddCabec( cCampo, xValor )
	Method Gravacao( nOpcao, cFilPed, dDtEntreg, cNumOrc )
	Method GetNumero()
	Method CriaAgenda()
	
EndClass

/*/{Protheus.doc} New
@description	Construtor
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method New() Class PedVdaFb

	_Super:New()

	::aTabelas	:= {"SC5","SC6","SA1","SA2","SB1","SB2","SF4"}
	::cPedido	:= ""
	::dEmissao	:= CtoD("")
	::cFileLog	:= "MATA410.LOG"
	::cPedWeb	:= ""
	::cFormaPG	:= ""
	::cNomPagto	:= ""
	::cAdmFin	:= ""
	
Return Self

/*/{Protheus.doc} AddCabec
@description	Armazena os Valores do Cabecalho do Pedido para gravacao.
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method AddCabec(cCampo, xValor) Class PedVdaFb
	
	If AllTrim(cCampo) == "C5_NUM"
		::cPedido    := xValor
	
	ElseIf AllTrim(cCampo) == "C5_EMISSAO"
		::dEmissao	:= xValor
	
	ElseIf Alltrim(cCampo) == "C5_XPEDECO"
		::cPedWeb	:= Alltrim(xValor)
	
	ElseIf Alltrim(cCampo) == "FORMAPAGTO"
		::cFormaPG	:= Alltrim(xValor)
	
	ElseIf Alltrim(cCampo) == "NOMEPAGTO"
		::cNomPagto	:= Alltrim(xValor)
	
	ElseIf Alltrim(cCampo) == "ADMFINA"
		::cAdmFin	:= Alltrim(xValor)

	EndIf

	If Alltrim(cCampo) <> "FORMAPAGTO" .And. Alltrim(cCampo) <> "NOMEPAGTO" .And. Alltrim(cCampo) <> "ADMFINA"
		_Super:AddCabec( cCampo, xValor )
	EndIf

Return Nil

/*/{Protheus.doc} Gravacao
@description	Gravacao do Pedido de Venda.
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method Gravacao(nOpcao, cFilPed, dDtEntreg, cNumOrc ) Class PedVdaFb
	Local dDataBackup	:= dDataBase
	Local lReserva		:= .F.
	Local lRetorno		:= .T.
	
	Private lMsErroAuto	:= .F.
	
	Default cFilPed	:= ""
	Default dDtEntreg	:= ""
	Default cNumOrc		:= ""
	
	::SetEnv(1, "FAT", .T.)
	
	//Inicia Transacao
	Begin Transaction
	
	If !Empty(::dEmissao)
		dDataBase := ::dEmissao
	EndIf
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	
	If Type("INCLUI") == "U" .Or. Type("ALTERA") == "U"
		If nOpcao == 3
			INCLUI	:= .T.
			ALTERA	:= .F.
		ElseIf nOpcao == 4
			INCLUI	:= .F.
			ALTERA	:= .T.
		ElseIf nOpcao == 5
			INCLUI	:= .F.
			ALTERA	:= .F.
		EndIf
	EndIf
	
	//Se for inclusao, reserva um numero para o Pedido
	If nOpcao <> 3
		If Empty(::cPedido)
			lRetorno	:= .F.
			::cMensagem	:= "Numero do Pedido não informado."
		Else
			If !SC5->( DbSeek( xFilial("SC5") + ::cPedido ) )
				lRetorno 	:= .F.
				::cMensagem	:= "Pedido " + ::cPedido + " não cadastrado."
			EndIf
		EndIf
	Else
		If !Empty(::cPedido)
			If SC5->(DbSeek(xFilial("SC5") + ::cPedido))
				lReserva	:= .T.

				While SC5->( DbSeek( xFilial("SC5") + ::cPedido ) )
					ConfirmSx8()
					::cPedido := GetSx8Num( "SC5", "C5_NUM" )
				Enddo

				::AddCabec( "C5_NUM", ::cPedido )
			EndIf
		EndIf
	EndIf
	
	If lRetorno
		::AddCabec( "C5_FILIAL",	xFilial("SC5") )
		
		//Inicia Variavel como .F. caso o Execauto caia, o retorno sera .F.
		lRetorno := .F.

		//Chama Ponto de entrada especifico (Carregamento de variaveis especificas)
		//U_MT410BRW()
		
		ConOut( VarInfo( "", ::aCabec ) )
		ConOut( VarInfo( "", ::aItens ) )
		//MATA410(::aCabec ,::aItens,3)
		//Gravacao do Pedido de Venda
		MSExecAuto( { |a, b, c| MATA410(a, b, c) }, ::aCabec, ::aItens, nOpcao, , Nil )
			
		If lMsErroAuto
			
			lRetorno := .F.
				
			If ::lExibeTela
				MostraErro()
			EndIf
				
			If ::lGravaLog
				::cMensagem := MostraErro(::cPathLog, ::cFileLog)
			EndIf

			If lReserva
				RollBackSx8()
			EndIf

		Else
			
			lRetorno	:= .T.
			::cPedido 	:= SC5->C5_NUM
			
			If lReserva
				ConfirmSx8()
			EndIf
			
		EndIf

	EndIf

	If !lRetorno
		DisarmTransaction()
	EndIf

	//Finaliza Transacao
	End Transaction

	dDataBase 	:= dDataBackup
	
	::SetEnv( 2, "FAT", .T. )

Return lRetorno

/*/{Protheus.doc} GetNumero
@description	Retorna o Numero do Pedido de Venda
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method GetNumero() Class PedVdaFb
Return ::cPedido
