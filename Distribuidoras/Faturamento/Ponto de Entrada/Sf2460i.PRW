#Include "Protheus.Ch"
#Include "RwMake.Ch"
#Include "TopConn.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Sf2460i   ºAutor  ³Andre Salgado       º Data ³  21/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada CALCULA O PESO NO MOMENTO DO FATURAMENTO   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SALON LINE -  SOLICITAÇÃO - GENILSON LUCAS                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
Data = 05/06/2018   -    Sol.Genilson 		- Autor Andre Salgado
(1)Melhoria atualizar informacao correta contas a receber devido erro na
divisao da ST na Primeira parcela para Notas que nao tem ST no Total da NF
==> Foi criado o campo E4_X_NRPAR - Tipo N (5) - Informar Numero de Parcela em Numero

Data = 19/06/2018 -  Sol. Genilon - Autor Andre Salgado
Troquei a Regra de ==> AND F2_VALBRUT=F2_VALMERC"
Por esta pois em alguns casos não estava localizando o mesmo valor ==> AND (F2_VALBRUT-F2_VALMERC) BETWEEN -5 AND 5"

Data = 18/07/2018 -  Sol. Genilon - Autor Andre Salgado
Na Impressão da DANFE ainda esta sendo impresso errada as parcelas. Corrigir atualizado o campo E1_VLCRUZ, com a regra da divisão correta

Data = 28/09/2018 -  Sol. Genilon - Autor Genilson
Alterar regra do UPDATE para buscar F2_VALFAT  e incluir regra da Filial MG (0902)

Data = 11/03/2018 -  Sol. Adelma/Flavia MACO - Autor Andre Salgado
Força a regra de Calculo do FECP, pois a Totvs não retornou com uma solução aceitavel, pois informou que precisamos trabalhar com LOTE para ter
este controle de ST sobre FECP Antecipado.  Lembrando que é uma LEI que entra apartir 01/04/2019

Data = 12/06/2019 - Sol. Jacqueline - Configurar para automatizar o Desconto Contratual do Cliente
Será criado um Registro na tabela SE1 com E1_TIPO = AB- conforme o percentual do Desconto informado no Campo A1_

Data = 17/06/2019 - Sol. Jacqueline - Configurar para gerar automaticamente o valor ST , quando a Nota nao gera FINANCEIRO
Será criado um Registro na tabela SE1 com o valor da ST devida pelo Cliente, quando a TES não gerar Financeiro

Data = 30/06/2019 - Sol. Jacqueline - Desabilitar criação do titulo ST
Data = 30/06/2019 - Sol. Jacqueline - Alterar regra do calculo do DESCONTO, para considerar sobre o valor BRUTO da Nota e não mais sobre Valor Mercadoria

Data = 30/03/2020 - Sol. Fernando M.- Desabilitar rotina que altera valores da ST, vamos utilizar pelo padrão agora. - Autor André Salgado

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Sf2460i()

Local _nPesoLx:= 0
Local _nPesoBx:= 0
Local _nPedido:= ""
Private lMsErroAuto := .F.

aArea := GetArea()

dbSelectArea("SD2")
aAreaSD2 := GetArea()
dbSetOrder(3)
dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

While !Eof() .and. SD2->D2_FILIAL == xFilial("SD2") .and. SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_DOC+SD2->D2_SERIE
	
	//Busca Informação Cadastro Produto
	SB1->(DbSetOrder(1),DbSeek(xFilial("SB1") + SD2->D2_COD ))
	
	_nPedido := SD2->D2_PEDIDO
	_nPesoBx += (SB1->B1_PESBRU*SD2->D2_QUANT)
	_nPesoLx += (SB1->B1_PESO  *SD2->D2_QUANT)
	
	dbselectarea("SD2")
	dbSkip()
End
RestArea(aAreaSD2)


//Busca Informação Cadastro Produto
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+_nPedido)
RecLock("SC5",.F.)
SC5->C5_ESPECI1 := "VOLUME"	//Especie
SC5->C5_PESOL	:= _nPesoLx //Peso Líquido
SC5->C5_PBRUTO	:= _nPesoBx //Peso Bruto
If SC5->C5_X_STAPV	<> 'A'
	SC5->C5_X_STAPV	:= '6'
ElseIf SM0->M0_CODFIL="0901"
	SC5->C5_X_STAPV	:= '6'
EndIf
MsUnlock()

//Grava
DbSelectArea("SF2")
RecLock("SF2",.f.)
SF2->F2_ESPECI1:= "VOLUME"
SF2->F2_PLIQUI := _nPesoLx	//Peso Liquido
SF2->F2_PBRUTO := _nPesoBx	//Peso Bruto
SF2->F2_VOLUME1	:= SC5->C5_VOLUME1 + SC5->C5_VOLUME2
MsUnlock()

// Atualizar NF Na Logistica (25/11/2022)
U_enviarNF( SF2->F2_FILIAL, _nPedido, SF2->F2_DOC, DTOC(SF2->F2_EMISSAO) )

//Desabilitado em 30/03/2020 - Solic. Fernando Medeiro, vamos utilizar pelo padrão do sistema - Autor - Andre Salgado
/*
//REGAR PARA FILIAL DE MG
If xFilial("SF2") == "0902"
	//(1) ==> Atualiza Dados no Contas a Receber
	cQuerySE1 := " UPDATE "+RetSqlName("SE1")+" SET E1_VALOR=VLR_DIV, E1_SALDO=VLR_DIV, E1_VLCRUZ=VLR_DIV"
	cQuerySE1 += " FROM "+RetSqlName("SE1")+" "
	cQuerySE1 += " 	INNER JOIN "
	cQuerySE1 += " ("
	cQuerySE1 += " 		SELECT DISTINCT "
	cQuerySE1 += " 		F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_DOC, F2_SERIE, D2_TES, F2_COND, E4_DESCRI, E4_SOLID, F2_VALFAT,"
	cQuerySE1 += " 		ROUND(F2_VALFAT/E4_X_NRPAR,2) VLR_DIV"
	cQuerySE1 += " 		FROM 	   "+RetSqlName("SD2")+" D2"
	cQuerySE1 += " 		INNER JOIN "+RetSqlName("SF2")+" F2 ON F2_FILIAL=D2_FILIAL AND F2_SERIE=D2_SERIE AND D2_DOC=F2_DOC AND F2.D_E_L_E_T_=' '"
	cQuerySE1 += " 		INNER JOIN "+RetSqlName("SE4")+" E4 ON F2_COND=E4_CODIGO AND E4.D_E_L_E_T_=' ' AND E4_DESCRI LIKE '%/%'"
	cQuerySE1 += " 		WHERE "
	cQuerySE1 += " 		D2.D_E_L_E_T_=' ' "
	cQuerySE1 += " 		AND D2_TES IN ('502','530')"
	cQuerySE1 += " 		AND F2_TIPO='N'"
	cQuerySE1 += " 		AND F2_ICMSRET>0"	//Só Processar quando tiver saldo de ST
	cQuerySE1 += " 		AND (F2_VALBRUT-F2_VALMERC) BETWEEN -5 AND 5"	//Só processar para NF com ST e Total Nota = Vlr.Mercadoria
	cQuerySE1 += "  	AND F2_FILIAL= '"+xFilial("SF2")+"'"
	cQuerySE1 += "  	AND F2_DOC   = '"+SF2->F2_DOC+"'"
	cQuerySE1 += " )NOTA"
	cQuerySE1 += " 		ON E1_FILIAL=F2_FILIAL AND E1_NUM=F2_DOC AND E1_PREFIXO=F2_SERIE AND E1_EMISSAO=F2_EMISSAO AND E1_TIPO='NF'"
	cQuerySE1 += " WHERE"
	cQuerySE1 += " 	E1_FILIAL     = '"+xFilial("SF2")+"'"
	cQuerySE1 += " 	AND E1_NUM    = '"+SF2->F2_DOC+"'"
	cQuerySE1 += " 	AND E1_EMISSAO= '"+DTOS(SF2->F2_EMISSAO)+"'"
	cQuerySE1 += " 	AND E1_SALDO  = E1_VALOR"
	TcSqlExec(cQuerySE1)
Else
	//(1) ==> Atualiza Dados no Contas a Receber
	cQuerySE1 := " UPDATE "+RetSqlName("SE1")+" SET E1_VALOR=VLR_DIV, E1_SALDO=VLR_DIV, E1_VLCRUZ=VLR_DIV"
	cQuerySE1 += " FROM "+RetSqlName("SE1")+" "
	cQuerySE1 += " 	INNER JOIN "
	cQuerySE1 += " ("
	cQuerySE1 += " 		SELECT DISTINCT "
	cQuerySE1 += " 		F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_DOC, F2_SERIE, D2_TES, F2_COND, E4_DESCRI, E4_SOLID, F2_VALFAT,"
	cQuerySE1 += " 		ROUND(F2_VALFAT/E4_X_NRPAR,2) VLR_DIV"
	cQuerySE1 += " 		FROM 	   "+RetSqlName("SD2")+" D2"
	cQuerySE1 += " 		INNER JOIN "+RetSqlName("SF2")+" F2 ON F2_FILIAL=D2_FILIAL AND F2_SERIE=D2_SERIE AND D2_DOC=F2_DOC AND F2.D_E_L_E_T_=' '"
	cQuerySE1 += " 		INNER JOIN "+RetSqlName("SE4")+" E4 ON F2_COND=E4_CODIGO AND E4.D_E_L_E_T_=' ' AND E4_DESCRI LIKE '%/%'"
	cQuerySE1 += " 		WHERE "
	cQuerySE1 += " 		D2.D_E_L_E_T_=' ' "
	//cQuerySE1 += " 		AND D2_TES='511'"	//Só processar para TES com ST em Dados Adicionais
	cQuerySE1 += " 		AND D2_TES IN ('511','530','532')"	// Valmir (03/09/2018) Adicionado nova TES
	cQuerySE1 += " 		AND F2_TIPO='N'"
	cQuerySE1 += " 		AND F2_ICMSRET>0"	//Só Processar quando tiver saldo de ST
	//cQuerySE1 += " 		AND F2_VALBRUT=F2_VALMERC"	//Só processar para NF com ST e Total Nota = Vlr.Mercadoria
	cQuerySE1 += " 		AND (F2_VALBRUT-F2_VALMERC) BETWEEN -5 AND 5"	//Só processar para NF com ST e Total Nota = Vlr.Mercadoria
	cQuerySE1 += "  	AND F2_FILIAL= '"+xFilial("SF2")+"'"
	cQuerySE1 += "  	AND F2_DOC   = '"+SF2->F2_DOC+"'"
	cQuerySE1 += " )NOTA"
	cQuerySE1 += " 		ON E1_FILIAL=F2_FILIAL AND E1_NUM=F2_DOC AND E1_PREFIXO=F2_SERIE AND E1_EMISSAO=F2_EMISSAO AND E1_TIPO='NF'"
	cQuerySE1 += " WHERE"
	cQuerySE1 += " 	E1_FILIAL     = '"+xFilial("SF2")+"'"
	cQuerySE1 += " 	AND E1_NUM    = '"+SF2->F2_DOC+"'"
	cQuerySE1 += " 	AND E1_EMISSAO= '"+DTOS(SF2->F2_EMISSAO)+"'"
	cQuerySE1 += " 	AND E1_SALDO  = E1_VALOR"
	TcSqlExec(cQuerySE1)
EndIf
*/



//REGAR PARA MACO - CALCULO DO FECP - ANDRE SALGADO - 11/03/2019
If xFilial("SF2") == "0401"	//MACO
	
	cQueryCD2 := " UPDATE "+RetSqlName("CD2")+" SET "
	cQueryCD2 += " CD2_BFCP = CD2_BC,"				//FECP - Sistema Não esta fazendo o calculo FECP, esta sendo FORÇADO
	cQueryCD2 += " CD2_PFCP = 2,"					//FECP - Sistema Não esta fazendo o calculo FECP, esta sendo FORÇADO
	cQueryCD2 += " CD2_VFCP = ROUND(CD2_BC*0.02,2),"//FECP - Sistema Não esta fazendo o calculo FECP, esta sendo FORÇADO
	cQueryCD2 += " CD2_ALIQ = 27,"  //Regra solicitada pela Adelma (ST = 25 e FECP = 2) porem no sistema já esta correto, precisa forçar com este cenario
	cQueryCD2 += " CD2_VLTRIB= ROUND(CD2_BC * 0.27,2)"
	
	cQueryCD2 += " FROM "+RetSqlName("CD2")+" CD2"
	cQueryCD2 += " INNER JOIN "+RetSqlName("SA1")+" A1 ON CD2_CODCLI=A1_COD AND CD2_LOJCLI=A1_LOJA AND A1.D_E_L_E_T_=' ' AND A1_EST IN( 'MG' )" //so PARA MG
	cQueryCD2 += " INNER JOIN "+RetSqlName("SD2")+" D2 ON CD2_FILIAL=D2_FILIAL AND CD2_DOC=D2_DOC AND CD2_SERIE=D2_SERIE AND CD2_ITEM=D2_ITEM"
	cQueryCD2 += "  			AND D2.D_E_L_E_T_=' 'AND D2_TES in ('611','614','619') "	//TES que tem o Desconto do FECP MG
	
	cQueryCD2 += " WHERE CD2.D_E_L_E_T_=' ' AND CD2_IMP='SOL' AND CD2_CST='60'"	//Só aplicar a Regra para CST "60"
	cQueryCD2 += " AND CD2_FILIAL='0401'" 	//FIXO SÓ PARA (0401 - MACO)
	cQueryCD2 += " AND CD2_DOC = '"+SF2->F2_DOC+"' "
	
	TcSqlExec(cQueryCD2)
	
Endif





//PROJETO MELHORIA PARA CRIAR O REGISTRO com DESCONTO CONTRATUAL NO CONTAS A RECEBER - SOL.JACQUELINE 12/06/2019
cBasDesCon := SA1->A1_X_PDESC		//Campo Criado (SA1) - Para ser informando o Percentual do Desconto Contratual

IF cBasDesCon>0
	aAreaSE1 := SE1->(GetArea())
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
	cParcX:= "0"
	While SE1->E1_PREFIXO + SE1->E1_NUM = SF2->F2_SERIE+SF2->F2_DOC
		
		//Regra para não processar novamente o mesmo titulo + Parcela
		if SE1->E1_PARCELA $ cParcX
			dbSkip();Loop
		Endif
		
		//Só Processa para Nota Fiscal
		IF SE1->E1_TIPO<>"NF "
			dbSkip();Loop
		Endif
		cParcX += SE1->E1_PARCELA //Salva as Parcelas já processadas
		
		//Regra para retirar o ST do valor do Contas a Receber, pois o Desconto Contratual não é aplicado sobre ICMS ST

/* - data 30/07/2019 - Sol.Jacqueline, solicitou para não considerar retirada do valor da ST para aplicar o Descontro conforme email
		IF SF2->F2_ICMSRET>0 .AND. SF2->F2_VALBRUT<>SF2->F2_VALMERC .and. SE1->E1_PARCELA $ " ,A"
			nVlrSTSE1 := SF2->F2_ICMSRET
		Else
			nVlrSTSE1 := 0
		Endif
*/
		nVlrSTSE1 := 0		//regra do desconto da ST sobre o valor base de calculo do % Desconto do cliente Contratual

		
		if Empty(SE1->E1_PARCELA)
			cParcX:= SE1->E1_PARCELA
		Endif
		
		nAbContSL := ((SE1->E1_VALOR-nVlrSTSE1) * cBasDesCon)/100	//Regra do Desconto
		
		aVetor := {;
		{"E1_PREFIXO" ,SF2->F2_SERIE,Nil},;
		{"E1_NUM"     ,SF2->F2_DOC,Nil},;
		{"E1_PARCELA" ,SE1->E1_PARCELA,Nil},;
		{"E1_TIPO"    ,"AB-" ,Nil},;
		{"E1_FILIAL"  ,xFilial("SE1"),Nil},;
		{"E1_NATUREZ" ,SE1->E1_NATUREZ,Nil},;
		{"E1_CLIENTE" ,SF2->F2_CLIENTE,Nil},;
		{"E1_LOJA"    ,SF2->F2_LOJA ,Nil},;
		{"E1_EMISSAO" ,SF2->F2_EMISSAO,Nil},;
		{"E1_VENCTO"  ,SE1->E1_VENCTO,Nil},;
		{"E1_VENCREA" ,SE1->E1_VENCREA,Nil},;
		{"E1_HIST"    ,"DESC.CONTRATUAL "+Transform(SA1->A1_COMIS,"@E 99,99"),Nil},;
		{"E1_VALOR"   ,nAbContSL ,Nil }}
		
		MSExecAuto({|x, y| FINA040(x, y)}, aVetor, 3) // 3 – Inclusao, 4 – Alteração, 5 – Exclusão
		
		If lMsErroAuto
			//			Alert("Falha ao realizar a inclusão do item, entre em contato com o suporte.")
			MOSTRAERRO()
			DisarmTransaction()
			Return
		EndIf
		
		DbSelectArea("SE1")
		DbSkip()
	EndDo
	
	SE1->(RestArea(aAreaSE1))
	
Endif








//PROJETO MELHORIA PARA CRIAR O REGISTRO DA ST NO CONTAS A RECEBER - SOL.JACQUELINE 17/06/2019
/* - data 30/07/2019 - Sol.JAcqueline, solicitou para retirar esta melhoria conforme autorização - Fernando Medeiros
IF EMPTY(SF2->F2_DUPL) .AND. SF2->F2_ICMSRET>0 .AND. SF2->F2_VALBRUT<>SF2->F2_VALMERC	//Filtro Somente Nota SEM DUPLICATA e que tenha valor de ICMS
	
	aVetor := {;
	{"E1_PREFIXO" ,SF2->F2_SERIE  ,Nil},;
	{"E1_NUM"	  ,SF2->F2_DOC    ,Nil},;
	{"E1_PARCELA" ,"S"			  ,Nil},;
	{"E1_TIPO"	  ,"NF" 		  ,Nil},;
	{"E1_FILIAL"  ,xFilial("SE1") ,Nil},;
	{"E1_NATUREZ" ,"10"			  ,Nil},;
	{"E1_CLIENTE" ,SF2->F2_CLIENTE,Nil},;
	{"E1_LOJA"	  ,SF2->F2_LOJA	  ,Nil},;
	{"E1_EMISSAO" ,SF2->F2_EMISSAO,Nil},;
	{"E1_VENCTO"  ,SF2->F2_EMISSAO+30,Nil},;
	{"E1_VENCREA" ,SF2->F2_EMISSAO+30,Nil},;
	{"E1_HIST"	  ,"ST BONIFICACAO REF.NF."+SF2->F2_DOC,Nil},;
	{"E1_VALOR"	  ,SF2->F2_ICMSRET,Nil }}
	
	MSExecAuto({|x, y| FINA040(x, y)}, aVetor, 3) // 3 – Inclusao, 4 – Alteração, 5 – Exclusão
	
	If lMsErroAuto
		//		Alert("Falha ao realizar a inclusão do item, entre em contato com o suporte.")
		MOSTRAERRO()
		DisarmTransaction()
		Return
	EndIf
	
Endif
*/

RestArea(aArea)
Return
