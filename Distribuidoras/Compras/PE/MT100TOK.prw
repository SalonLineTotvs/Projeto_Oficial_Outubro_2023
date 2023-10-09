#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.ch'
#INCLUDE "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ SalonLine			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ MT100TOK  ³ Autor ³ Genilson M Lucas    ³ Data ³ 20/02/2020³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida entrada da Nota de Devolução, obrigando ter uma     |±±
±±³			 | 										               		  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT100TOK()

Local _lRet 	:= .T.
Local _cQuery	:= ""
Local _Ativado	:= GETMV("ES_MT100TO")
Local _cNumNF	:= cNFiscal
Local nPosNfOri	:= aScan(aHeader, {|x| Upper(AllTrim(X[2])) == "D1_NFORI" })

/*
If cTipo == "D" .and. _Ativado

	If cFormul == 'S'
		
		_cNumNF := aCols[1][nPosNfOri]
		
		_cQuery :=	" SELECT UC_FILIAL, UC_CODIGO, UC_DATA, UC_X_NFD, A1_CGC, A1_COD, A1_LOJA "
		_cQuery +=	" FROM "+RetSqlName("SUC")+" UC WITH(NOLOCK) "
		_cQuery +=	"	INNER JOIN "+RetSqlName("SUD")+" UD WITH(NOLOCK) ON UD_CODIGO = UC_CODIGO AND UD_FILIAL = UC_FILIAL AND UD_SOLUCAO = '000009' AND UD.D_E_L_E_T_ = '' "
		_cQuery +=	"	INNER JOIN "+RetSqlName("SU5")+" U5 WITH(NOLOCK) ON UC_CODCONT = U5_CODCONT AND U5.D_E_L_E_T_ = '' "
		_cQuery +=	"	INNER JOIN "+RetSqlName("SA1")+" A1 WITH(NOLOCK) ON U5_CGC = A1_CGC AND A1.D_E_L_E_T_ = '' "
		
		_cQuery +=	" WHERE UC.D_E_L_E_T_ = '' AND UC_FILIAL = '"+xFilial("SUC")+"'  AND UC_X_NFO = '"+_cNumNF+"' "
		_cQuery +=	" AND A1_COD = '"+cA100For+"' AND A1_LOJA = '"+cLoja+"' "
		
		TCQUERY _cQuery NEW ALIAS "TRBSUC"
		
		dbSelectArea("TRBSUC")
		TRBSUC->(dbGoTop())
	
	Else
	
		alert("Passou pelo Else")
		
		_cQuery :=	" SELECT UC_FILIAL, UC_CODIGO, UC_DATA, UC_X_NFD, A1_CGC, A1_COD, A1_LOJA "
		_cQuery +=	" FROM "+RetSqlName("SUC")+" UC WITH(NOLOCK) "
		_cQuery +=	"	INNER JOIN "+RetSqlName("SUD")+" UD WITH(NOLOCK) ON UD_CODIGO = UC_CODIGO AND UD_FILIAL = UC_FILIAL AND UD_SOLUCAO = '000009' AND UD.D_E_L_E_T_ = '' "
		_cQuery +=	"	INNER JOIN "+RetSqlName("SU5")+" U5 WITH(NOLOCK) ON UC_CODCONT = U5_CODCONT AND U5.D_E_L_E_T_ = '' "
		_cQuery +=	"	INNER JOIN "+RetSqlName("SA1")+" A1 WITH(NOLOCK) ON U5_CGC = A1_CGC AND A1.D_E_L_E_T_ = '' "
		
		_cQuery +=	" WHERE UC.D_E_L_E_T_ = '' AND UC_FILIAL = '"+xFilial("SUC")+"'  AND UC_X_NFD = '"+_cNumNF+"' "
		_cQuery +=	" AND A1_COD = '"+cA100For+"' AND A1_LOJA = '"+cLoja+"' "
		
		TCQUERY _cQuery NEW ALIAS "TRBSUC"
		
		dbSelectArea("TRBSUC")
		TRBSUC->(dbGoTop())
	
	EndIf
	
	
	If TRBSUC->(!EOF())   
		_lRet := .T.
	Else
		_lRet := .F.
		MsgAlert("Processo de autorização ainda não realizado pelo Depto. do Customer, favor entrar em contato com os mesmos.","Falta de Autorização")	
	EndIf

	TRBSUC->(DbCloseArea())

Endif
*/
Return(_lRet)

