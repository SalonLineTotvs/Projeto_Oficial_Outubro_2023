#Include "Protheus.Ch"
#Include "RwMake.Ch"
#Include "TopConn.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATP0018 ºAutor  ³ Genilson M Lucas   º Data ³  28/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA ANALISE DE CRÉDITO COM BASE NA RAIZ DO CNPJ    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SALON LINE -  SOLICITAÇÃO - GENILSON LUCAS                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FATP0018(cPedido, cCliente, cLoja, cTipo)

Local cCGC		:= LEFT(alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente+ cLoja,"A1_CGC")),8)
Local cQuery	:= ''
Local cQryLim	:= ''
Local cQry 		:= ''
Local lLibera	:= .F.
Local lTitVenc	:= .F.
Local _dData	:= Date()
Local _cQuery   := ""
Local _cTMP     := GetNextAlias()
////0=Liberado;1=Rejeitado;2=Blq Risco;3=Blq Data;4=Blq Limite
Local cStaBlq	:= '4'
Local _lPVvend	:= .F.

Local cRisco    := ""
Local nSaldo	:= 0
Local nCred		:= 0
Local nPedido	:= 0
Local nTitulo	:= 0
Local nRA		:= 0
Local nNCC 		:= 0
Local dLimCred	:= ""
//*******************************************************
// BUSCA INFORMAÇÃO DO CRÉDITO DO CLIENTE NA TABELA SA1
//*******************************************************

cQryLim := " SELECT A1_RISCO, A1_VENCLC, SUM(A1_LC) 'CRED' "
cQryLim += " FROM SA1020  A1 "
cQryLim += " WHERE A1_CGC LIKE '"+cCGC+"%' AND A1.D_E_L_E_T_ = '' "
cQryLim += " GROUP BY A1_RISCO, A1_VENCLC "

cQryLim :=	ChangeQuery(cQryLim)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryLim),"LIM",.T.,.T.)
	
LIM->(DbGoTop())

cRisco  := LIM->A1_RISCO
dLimCred:= STOD(LIM->A1_VENCLC)
nCred 	:= LIM->CRED

Do Case
    Case cRisco == "B"
        _dData := DaySub(_dData, 3)
        _dData := DataValida(_dData, .F.)
    Case cRisco == "C"
        _dData := DaySub(_dData, 1)
        _dData := DataValida(_dData, .F.)
EndCase

LIM->( dbCloseArea())
		
//*******************************************************
// INICI ANALISE DE CRÉDITO
//*******************************************************	
If cTipo	== 'N'

	//Verifica se no pedido tem itens de venda
	_cTMP   := GetNextAlias()
	_cQuery := " SELECT C6_NUM FROM SC6020 C6 " + CRLF
	_cQuery += " INNER JOIN SF4020 F4 ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES AND F4_DUPLIC='S' " + CRLF
	_cQuery += " AND (F4_TEXTO LIKE 'VENDA%' OR F4_TEXTO LIKE 'VD%') AND F4.D_E_L_E_T_=' ' " + CRLF
	_cQuery += " WHERE C6_FILIAL ='"+xFilial("SC9")+"' AND  C6_NUM ='"+cPedido+"' AND C6.D_E_L_E_T_ ='' " + CRLF

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cTMP , .T., .T. )

	DbSelectArea( _cTMP )
	(_cTMP)->( DbGoTop() )
	If(_cTMP)->( ! EOF() )
		_lPVvend := .T.
	EndIf
	(_cTMP)->( DbCloseArea() )

	If cRisco ==  'A'
		lLibera	:= .T.
		cStaBlq	:= '0'
	
	ElseIf !_lPVvend //se não tiver itens de venda(bonificacao)
		lLibera	:= .T.
		cStaBlq	:= '0'
	
	ElseIf dLimCred < dDataBase
		cStaBlq	:= '3'

	ElseIf cRisco $ 'B/C/D/E'
		
		//*******************************************************
		//BUSCA INFORMAÇÕES PARA ANALISE DO CRÉDITO
		//*******************************************************
		If Select("CRED") > 0
			CRED->(dbclosearea())
		Endif
		
		cQry := " SELECT TIPO, SUM(TOTAL) SALDO "
		
		cQry += " FROM ( "
		
		cQry += " SELECT '1 - PEDIDO' TIPO, C6_CLI CLIENTE, ROUND((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN,2) TOTAL  "
		cQry += " FROM SC6020 C6  "
		cQry += " INNER JOIN SC5020 C5 ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C5.D_E_L_E_T_=' ' AND C5_TIPO NOT IN('D','B') "
		cQry += " INNER JOIN SF4020 F4 ON C6_FILIAL+C6_TES = F4_FILIAL+F4_CODIGO AND F4_DUPLIC='S' AND F4.D_E_L_E_T_=' ' "
		cQry += " INNER JOIN SA1020 A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_CGC BETWEEN '"+cCGC+"' AND '"+cCGC+"999999' AND A1.D_E_L_E_T_ = '' " 
		cQry += " WHERE C6.D_E_L_E_T_=' ' AND C6_NOTA = '' AND C6_BLQ = '' AND (C6_QTDVEN-C6_QTDENT)>0 "
		
		cQry += " UNION ALL "
		
		cQry += " SELECT "
		cQry += " CASE WHEN E1_TIPO='NF' THEN '2 - TITULO' WHEN E1_TIPO='RA' THEN '3 - RA' WHEN E1_TIPO='NCC' THEN '4 - NCC' ELSE '5 - '+E1_TIPO END TIPO, "
		cQry += " E1_CLIENTE CLIENTE, E1_SALDO AS TOTAL "
		cQry += " FROM SE1020 E1  "
		cQry += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_CGC BETWEEN '"+cCGC+"' AND '"+cCGC+"999999' AND A1.D_E_L_E_T_ = ''  "
		cQry += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 AND E1_TIPO NOT IN('CF-','CS-','IR-','PI-') "
		
		cQry += " )A   " 
		
		cQry += " GROUP BY TIPO "
		cQry += " ORDER BY 1 "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"CRED",.T.,.T.)
		
		//Trabalha a Informação
		dbSelectArea("CRED")
		CRED->(dbGoTop())
		While CRED->(!Eof())
			
			If CRED->TIPO = "1 - PEDIDO"
				nPedido += CRED->SALDO		//Saldo dos Pedidos em Aberto (SC6)
			ElseIf CRED->TIPO = "2 - TITULO"
				nTitulo += CRED->SALDO		//Saldo do Contas a Receber em Aberto ate DdataBase (SE1) - tipo NF
			ElseIf CRED->TIPO = "3 - RA"
				nRA     += CRED->SALDO		//Saldo do 'RA' em Aberto ate DdataBase (SE1) - tipo RA
			ElseIf CRED->TIPO = "4 - NCC"
				nNCC    += CRED->SALDO		//Saldo do 'NCC' em Aberto ate DdataBase (SE1) - tipo NCC
			Endif
			
			CRED->(dbskip())
		EndDo
		CRED->( dbCloseArea() )
	
		nSaldo	:= nCred + nRA + nNCC - nPedido - nTitulo

		_cTMP   := GetNextAlias()
		_cQuery := " SELECT TIPO, SUM(TOTAL) SALDO " + CRLF
		_cQuery += " FROM( " + CRLF
		_cQuery += " SELECT  " + CRLF
		_cQuery += " CASE WHEN E1_TIPO='NF' THEN '2 - TITULO' WHEN E1_TIPO='RA' THEN '3 - RA' WHEN E1_TIPO='NCC' THEN '4 - NCC' ELSE '5 - '+E1_TIPO END TIPO, " + CRLF
		_cQuery += " E1_CLIENTE CLIENTE, E1_SALDO AS TOTAL " + CRLF
		_cQuery += " FROM SE1020 E1 " + CRLF
		_cQuery += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_ = '' AND A1_CGC LIKE '"+cCGC+"%' " + CRLF
		_cQuery += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 " + CRLF
		_cQuery += " AND E1_TIPO='NF' AND E1_VENCREA < '"+Dtos(_dData)+"' ) A " + CRLF
		_cQuery += " GROUP BY TIPO " + CRLF

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cTMP , .T., .T. )

		DbSelectArea( _cTMP )
		(_cTMP)->( DbGoTop() )
		If (_cTMP)->( ! EOF() )
			lTitVenc := .T.
		EndIf
		(_cTMP)->( DbCloseArea() )

		If nSaldo > 0 .and. !lTitVenc
			lLibera	:= .T.
			cStaBlq	:= '0'
		Else
			cStaBlq	:= '4'
		EndIf
	
	Else
		cStaBlq	:= '2'
	EndIf
	
	If lLibera
		//alert("Entrou no PE para Liberar " + cPedido )
		
		cQuery := " UPDATE "+RetSqlName("SC9")+" SET C9_BLCRED='', C9_BLEST = '' "
		cQuery += " WHERE "
		cQuery += " C9_FILIAL ='"+xFilial("SC9")+"' AND C9_PEDIDO='"+cPedido+"' AND D_E_L_E_T_ = '' "
		TcSqlExec(cQuery)
		
	Else
		//alert("Entrou no PE para Bloquear" + cPedido )
		cQuery := " UPDATE "+RetSqlName("SC9")+" SET C9_BLCRED='01', C9_BLEST = '' "
		cQuery += " WHERE "
		cQuery += " C9_FILIAL='"+xFilial("SC9")+"' AND C9_PEDIDO='"+cPedido+"' AND D_E_L_E_T_ = '' "
		TcSqlExec(cQuery)

	EndIf
	//alert(cRisco)
	//ALERT(cStaBlq)
	
	//ATUALIZA STATUS DO BLOQUEIO	
	cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='"+cStaBlq+"' "
	cQuery += " WHERE "
	cQuery += " C5_FILIAL = '"+xFilial("SC9")+"' AND C5_NUM ='"+cPedido+"'  AND D_E_L_E_T_ = '' "
	TcSqlExec(cQuery)
	
Else

	//C5_X_STACR := '0'

EndIf


Return()
