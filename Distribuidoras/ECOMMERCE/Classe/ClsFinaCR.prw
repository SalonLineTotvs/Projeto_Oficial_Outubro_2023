#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"

User Function ClsFinaCR()
Return Nil

/*/{Protheus.doc} PedVdaFb
@description	Classe Responsavel pela gravacao do Titulo financeiro via
				MsExecAuto
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/

Class FinCRFb From ClsExAuto
	Data nRecSE1
	
	Method New()
	Method SetEmissa()
	Method Gravacao()
	Method GetRecno()
	
EndClass

/*/{Protheus.doc} New
@description	Construtor
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method New() Class FinCRFb

	_Super:New()
	::nRecSE1	:= 0
	::aTabelas	:= {"SE1","SE5","SED","SA6"}
	::cFileLog	:= "FINA040.LOG"

Return Self

/*/{Protheus.doc} Gravacao
@description	Gravacao do Titulo financeiro
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method Gravacao( nOpcao ) Class FinCRFb
	Local lRetorno		:= .T.

	Private lMsErroAuto	:= .F.

	::SetEnv(1, "FIN", .T.)

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

	//Ordena Array
	::aValues	:= FWVetByDic( ::aValues, "SE1" )

	//Inicia Variavel como .F. caso o Execauto caia, o retorno sera .F.
	lRetorno 	:= .F.
	
	//Faz a Gravacao via Execauto
	MsExecAuto( { |a, b| FINA040( a, b ) }, ::aValues, nOpcao )

	If lMsErroAuto
		
		lRetorno := .F.

		If ::lExibeTela
			MostraErro()
		EndIf

		If ::lGravaLog
			::cMensagem := MostraErro( ::cPathLog, ::cFileLog )
		EndIf

	Else
		lRetorno	:= .T.
		::nRecSE1	:= SE1->( ReCno() )
	EndIf

	::SetEnv( 2, "FIN", .T. )

Return lRetorno

/*/{Protheus.doc} GetRecno
@param			Nil
@return			Nil
@version 		1.0
@Type			Class
/*/
Method GetRecno() Class FinCRFb
Return ::nRecSE1
