#include "rwmake.ch"

User Function FING0001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIAS,NVALOR,CMONTA1,CMONTA2,CMONTA3,CMONTA4")
SetPrvt("CMONTA5,CMONTA6,CCODBAR,")

/*/
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*****************************************************************************
***-----------------------------------------------------------------------***
*** Programa:  Gat064    Autor: Fabio Rogerio da Silva    Data: 29/03/01  ***
***-----------------------------------------------------------------------***
*** Descricao: Gatilho para montar codigo de barras em arquivos de        ***
***            remessa de CNAB a pagar                                    ***
***-----------------------------------------------------------------------***
*** Uso:       CNABs a Pagar em Geral                                     ***
***-----------------------------------------------------------------------***
*****************************************************************************
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

// Variáveis utilizadas no programa

SetPrvt("LRET,CSTR,I,NMULT,NMODULO,CCHAR")
SetPrvt("CDIGITO,CDV1,CDV2,CDV3,CCAMPO1,CCAMPO2")
SetPrvt("CCAMPO3,NVAL,NCALC_DV1,NCALC_DV2,NCALC_DV3,NREST")

_cMonta1:= 0
_cMonta2:= 0
_cMonta3:= 0
_cMonta4:= 0
_cMonta5:= 0
_cCodbar:= 0
LRET := .F.

IF M->E2_MODELO <> "13"		// Codigo de Barras de Boletos Bancarios
	
	
	If len(Alltrim(M->E2_CODBAR)) == 47
		
		
		// Monta o Codigo de Barras
		
		_cMonta1:= Substr(Trim(M->E2_CODBAR),1,4)
		_cMonta2:= Substr(Trim(M->E2_CODBAR),33,15)
		_cMonta3:= Substr(Trim(M->E2_CODBAR),5,5)
		_cMonta4:= Substr(Trim(M->E2_CODBAR),11,10)
		_cMonta5:= Substr(Trim(M->E2_CODBAR),22,10)
		
		_cCodBar := _cMonta1 + _cMonta2 + _cMonta3 + _cMonta4 + _cMonta5
		
	Elseif Len(Alltrim(M->E2_CODBAR)) == 44
		
		_cCodBar := M->E2_CODBAR
		
	Else
	     
	    _cValor := Substr(Trim(M->E2_CODBAR),34,14) 
	    
	    _cMonta1:= Substr(Trim(M->E2_CODBAR),1,4)
		_cMonta2:= Substr(Trim(M->E2_CODBAR),33,1)
		_cMonta3:= Strzero(Val(_cValor),14)                    
		_cMonta4:= Substr(Trim(M->E2_CODBAR),5,5)
		_cMonta5:= Substr(Trim(M->E2_CODBAR),11,10)
		_cMonta6:= Substr(Trim(M->E2_CODBAR),22,10)
		
		_cCodBar := _cMonta1 + _cMonta2 + _cMonta3 + _cMonta4 + _cMonta5 + _cMonta6		
	
	Endif
	
	if ValType(M->E2_CODBAR) == NIL
		// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>   __Return(.t.)
		Return()        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
	Endif
	
	cStr := _cCodBar
	
	i := 0
	nMult := 2
	nModulo := 0
	cChar := SPACE(1)
	cDigito := SPACE(1)
	
	If len(AllTrim(cStr)) < 44
		
		cDV1    := SUBSTR(cStr,10, 1)
		cDV2    := SUBSTR(cStr,21, 1)
		cDV3    := SUBSTR(cStr,32, 1)
		
		cCampo1 := SUBSTR(cStr, 1, 9)
		cCampo2 := SUBSTR(cStr,11,10)
		cCampo3 := SUBSTR(cStr,22,10)
		
		/*/
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Descri‡…o ³ Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       ³±±
		±±³          ³ somente e utilizada como validacao do campo E2_CODBAR.     ³±±
		±±³          ³ Verifica a digitacao do codigo de barras                   ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		/*/
		//
		// Calcula DV1
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo1) to 1 Step -1
			cChar := Substr(cCampo1,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				_cCodBar := SPACE(1)
				// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
				Return(_cCodBar)        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := NVAL + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV1 := 10 - (nVal % 10)
		
		//
		// Calcula DV2
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo2) to 1 Step -1
			cChar := Substr(cCampo2,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				_cCodBar := SPACE(1)
				// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
				Return(_cCodBar)        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
				
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV2 := 10 - (nVal % 10)
		
		//
		// Calcula DV3
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo3) to 1 Step -1
			cChar := Substr(cCampo3,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				_cCodBar := SPACE(1)
				// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
				Return(_cCodBar)        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV3 := 10 - (nVal % 10)
		
		if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
			Help(" ",1,"INVALCODBAR")
			lRet := .f.
		else
			lRet := .t.
		endif
		
	Else
		cDigito := SUBSTR(cStr,5, 1)
		cStr    := SUBSTR(cStr,1, 4)+ ;
		SUBSTR(cStr,6,39)
		
		/*/
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Descri‡…o ³ Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       ³±±
		±±³          ³ somente e utilizada como validacao do campo E2_CODBAR.     ³±±
		±±³          ³ Verifica o codigo de barras grafico (Atraves de leitor)    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		/*/
		
		cStr := AllTrim(cStr)
		
		if Len(cStr) < 43
			Help(" ", 1, "FALTADG")
			_cCodBar := SPACE(1)
			// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
			Return(_cCodBar)        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
		Endif
		
		For i := Len(cStr) to 1 Step -1
			cChar := Substr(cStr,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				_cCodBar := SPACE(1)
				// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
				Return(_cCodBar)        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
			endif
			nModulo := nModulo + Val(cChar)*nMult
			nMult:= if(nMult==9,2,nMult+1)
		Next
		nRest := 11 - (nModulo % 11)
		nRest := if(nRest==10 .or. nRest==11,1,nRest)
		if nRest <> Val(cDigito)
			Help(" ",1,"DgSISPAG")
			_cCodBar := SPACE(1)
			// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>          __Return(.f.)
			Return(_cCodBar)        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
		endif
	Endif
	
ELSE		// Codigo de Barras de Concessionarias
	
	If len(Alltrim(M->E2_CODBAR)) == 48
		
		
		// Monta o Codigo de Barras de Concessionarias
		
		_cMonta1:= Substr(Trim(M->E2_CODBAR),1,11)
		_cMonta2:= Substr(Trim(M->E2_CODBAR),13,11)
		_cMonta3:= Substr(Trim(M->E2_CODBAR),25,11)
		_cMonta4:= Substr(Trim(M->E2_CODBAR),37,11)
		
		
		_cCodBar := _cMonta1 + _cMonta2 + _cMonta3 + _cMonta4
		
	Elseif len(Alltrim(M->E2_CODBAR)) == 44
		
		_cCodBar := M->E2_CODBAR
		
	Endif
	
	if ValType(M->E2_CODBAR) == NIL
		// Substituido pelo assistente de conversao do AP5 IDE em 03/04/02 ==>   __Return(.t.)
		Return()        // incluido pelo assistente de conversao do AP5 IDE em 03/04/02
	Endif
	
ENDIF


Return(_cCodBar)
