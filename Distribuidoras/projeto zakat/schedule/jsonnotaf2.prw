#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"


user function jsonnotaf2()
local cNF :="000003590"
Local cSerieNF :="2"
local cForn :="005163"
//LOCAL cloj :="01"

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" TABLES "SA1", "SD2", "SB1","SF2" ,"SA4"

u_SLnotaSF2(cNF,cSerieNF,cForn)
RESET ENVIRONMENT
return

user Function SLnotaSF2(cNF,cSerieNF,cForn)
	//Local _cUrl         := ''
	Local aHeadOut      := {}
	Local _nTimeOut     := 120
	Local _cHeadRet     := ''
	Local oJson         := ''
	Local _cPostProd    := ''
	Local nRetParser    := 0
	Local oJHM 		    := .F.
	Local lRet 		    := .F.
	Local aJsonProd     := {}
	Local cCfop         := GETNEWPAR('SL_CFOPE',"6102")
	Local cDoc			:= PADR(cNF,TAMSX3('F2_DOC')[1])
	Local cSerie		:= PADR(cSerieNF,TAMSX3('F2_SERIE')[1])
	Local cFornece		:= PADR(cForn,TAMSX3('F2_CLIENTE')[1])
	//Local cloja		:= PADR(cloj,TAMSX3('F2_LOJA')[1])
	//Local _cUrl         := "http://wmshml.ativalog.com.br:8080/siltwms/webresources/rest/importacao/integrar" //homolog
	Local _cUrl         := "http://wms.ativalog.com.br:8080/siltwms/webresources/rest/importacao/integrar" // producao ativa
//	local nseq:=0
	aAdd( aHeadOut, "Content-Type: text/plain" )
	aAdd( aHeadOut, "Accept: text/plain" )
	//aAdd( aHeadOut, "apiKey: 3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B")//homolog
	aAdd( aHeadOut, "apiKey: 40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6") //producao ativa

	DBSELECTAREA('SF2')
	DBSETORDER(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	DBSELECTAREA('SD2')

	DBSETORDER(3) //D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
	clocal:=POSICIONE('SD2',3,xFilial('SD2')+cDoc+cSerie+cFornece,'D2_LOCAL')

	IF SF2->(DBSEEK(xFilial('SF2')+cDoc+cSerie+cFornece)) .and. cLocal=="96" .and. cFilAnt=="1201" //armazem CROSS
		IF SD2->(DBSEEK(xFilial('SD2')+cDoc+cSerie+cFornece))
				DBSETORDER(1) 
				DBSELECTAREA('SA4')
				SA4->(DBSEEK(xFilial('SA4')+SF2->F2_TRANSP))
				DBSETORDER(1) 
				DBSELECTAREA('SB1')
				SB1->(DBSEEK(xFilial('SB1')+SD2->D2_COD))
				cCfop:=POSICIONE('SD2',3,xFilial('SD2')+cDoc+cSerie+cFornece,'D2_CF')
			// Prepara a chamada do metodo de carga da fila de integração
			_cStrjson:=' { '
			_cStrjson+='"chavelayout" : "int_faturamento", '
			_cStrjson+='"list" : [ { '
			_cStrjson+='  "codigointerno" : "'+SF2->F2_DOC+'", '
			_cStrjson+='  "numpedido" : "'+SD2->D2_PEDIDO+'", '
			_cStrjson+='  "chaveacessonfe" : "'+SF2->F2_CHVNFE+'",'
			_cStrjson+='  "sequencia" : "'+SF2->F2_SERIE+'", '
			_cStrjson+='  "cnpj_depositante" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "cnpj_emitente" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "tipo" :"S",  
			_cStrjson+='  "descroper" : "'+POSICIONE('SX5',1,xFilial('SX5')+"13"+cCfop,'X5_DESCRI')+'",'
			_cStrjson+='  "cfop" : "'+cCfop+'",'
			_cStrjson+='  "dataemissao" : "'+DTOC(SF2->F2_EMISSAO)+'", '
			_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_PESSOA')+'", ' //_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "codigo_dest" :  "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_COD')+'", '
			_cStrjson+='  "nome_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NOME')+'", '  //_cStrjson+='  "nome_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CGC')+'", '  //_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
		//	_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_NREDUZ')+'", '//_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NREDUZ')+'", '
			 _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_END')+'", ' // _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			 _cStrjson+='  "numend_dest" : "", '// _cStrjson+='  "numend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '//PRECISA MONTAR REGRA
		//	_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_COMPLEM')+'", '//_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_COMPLEM')+'", '
			_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_BAIRRO')+'", ' //_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cep_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CEP')+'", '//_cStrjson+='  "cep_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_MUN')+'", '//_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
		///_cStrjson+='  "telefone_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_TEL')+'",' //_cStrjson+='  "telefone_dest" : "",'
			_cStrjson+='  "estado_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_EST')+'", '//_cStrjson+='  "estado_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "inscrestadual_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_INSCR')+'",' //_cStrjson+='  "inscrestadual_dest" : "",'
		//	_cStrjson+='  "inscrmunicipal_dest" : "",'
			_cStrjson+='  "endereco_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_END')+'", '//_cStrjson+='  "endereco_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_MUN')+'", ' //_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "bairro_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_BAIRRO')+'", '//_cStrjson+='  "bairro_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
		//	_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_MUNE')+'", '//_cStrjson+='  "estado_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CEP')+'", '//_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
		//	_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_CGC')+'", '//_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			_cStrjson+='  "inscrestadual_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_INSCR')+'",'
		//	_cStrjson+='  "baseicms" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALICM), "@E 999999999.99")))+'", '
		//	_cStrjson+='  "valoricms" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALIPI), "@E 999999999.99")))+'",'
			// _cStrjson+='  "basesubstituicao" : "",'
			// _cStrjson+='  "valorsubstituicao" : "",'
			// _cStrjson+='  "frete" : "",'
			// _cStrjson+='  "seguro" : "",'
			// _cStrjson+='  "despesasacessorias" : "",'   //
			// _cStrjson+='  "ipi" : "",'
			_cStrjson+='  "vlrprodutos" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALMERC), "@E 999999999.99")))+'",'
			_cStrjson+='  "vlrtotal" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALBRUT), "@E 999999999.99")))+'",'
			_cStrjson+='  "nome_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_NREDUZ')+'",'
			_cStrjson+='  "cnpj_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_CGC')+'",'
			// _cStrjson+='  "endereco_transp" : "",'
			// _cStrjson+='  "numend_transp" : "",'
			// _cStrjson+='  "bairro_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_BAIRRO')+'",'
			// _cStrjson+='  "cidade_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_MUN')+'",'
			// _cStrjson+='  "estado_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_EST')+'",'
			// _cStrjson+='  "cep_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_CEP')+'",'
			 _cStrjson+='  "inscrestadual_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_INSEST')+'",'
			 _cStrjson+='  "ciffob" : "'+iif(SF2->F2_TPFRETE=="F","2","1")+'",'
			// _cStrjson+='  "veiculo" : "",'
			// _cStrjson+='  "estado_veiculo" : "",'
			// _cStrjson+='  "qtde" : "'+cvaltochar(SF2->F2_VOLUME1)+'",'
			// _cStrjson+='  "especie" : "",'
			// _cStrjson+='  "marca" : "",'
			// _cStrjson+='  "numero" : "",'
			_cStrjson+='  "pesoliquido" :  "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_PLIQUI), "@E 999999999.99")))+'",'
			// _cStrjson+='  "pis" : "",'
			// _cStrjson+='  "cofins" : "",'
			// _cStrjson+='  "cs" : "",'
			// _cStrjson+='  "ir" : "",'
			// _cStrjson+='  "valoriss" : "",'
			// _cStrjson+='  "valorservicos" : "",'
			// _cStrjson+='  "idmovimento" : "",'
			// _cStrjson+='  "idnotafiscal" : "",'
			// _cStrjson+='  "gerafinceiro" : "",'
			// _cStrjson+='  "tipodocumento" : "",'
			// _cStrjson+='  "tipocarga" : "",'
			// _cStrjson+='  "limitecorte" : "",'
			// _cStrjson+='  "paginageomapa" : "",'
			_cStrjson+='  "num_itens" : "1",'
			_cStrjson+='  "tiponf" : "N",'
			_cStrjson+='  "estado" : "N",'
			//_cStrjson+='  "data_coleta" : "'+dtoc(dDataBase)+'",'
			//_cStrjson+='  "hora_coleta" : "'+TIME()+'",'
			_cStrjson+='  "pessoa_entrega" : "'+iif(SF2->F2_TPFRETE=="F","2","1")+' ",'
			// _cStrjson+='  "codigo_entrega" : "",'
			// _cStrjson+='  "nome_entrega" : "",'
			// _cStrjson+='  "fantasia_entrega" : "",'
			// _cStrjson+='  "numend_entrega" : "",'
			// _cStrjson+='  "complementoend_entrega" : "",'
			// _cStrjson+='  "nomerepresentante" : "",'
			// _cStrjson+='  "telefone_representante" : "",'
			_cStrjson+='  "cnpj_unidade" : "01125797001198",'
			// _cStrjson+='  "fatura" : "",'
			_cStrjson+='  "observacao" : "",'
			// _cStrjson+='  "estoqueverificado" : "",'
			// _cStrjson+='  "chaveidentificacaoext" : "",'
			// _cStrjson+='  "classificacaocliente" : "",'
			// _cStrjson+='  "prioridade" : "",'
			// _cStrjson+='  "porcentagemcxfechada" : "",'
			// _cStrjson+='  "chaveacessonfe" : "'+SF2->F2_CHVNFE+'",'
			// _cStrjson+='  "sequenciaped" : "",'
			// _cStrjson+='  "cnpj_transpredespacho" : "",'
			_cStrjson+='  "inscrestadual_emitente" : "'+SM0->M0_INSC+'",'
			_cStrjson+='  "codigo_servicotransp" : "",'
			// _cStrjson+='  "codigotipopedido" : "VENDA",'
			// _cStrjson+='  "embarqueprioritario" : "",'
			// _cStrjson+='  "complemento_dest" : "",'
			// _cStrjson+='  "roteiro" : "",'
			// _cStrjson+='  "seq_entrega" : "",'
			_cStrjson+='  "nome_emit" : "'+SM0->M0_NOMECOM+'",'
			_cStrjson+='  "fantasia_emit" : "'+SM0->M0_NOMECOM+'",'
			// _cStrjson+='  "codretencao" : "",'
			// _cStrjson+='  "valoricmsdesonerado" : "",'
			// _cStrjson+='  "presencacomprador" : "",'
			// _cStrjson+='  "formapagamento" : "",'
			// _cStrjson+='  "tipoentrada" : "",'
			// _cStrjson+='  "utilizazpl" : "",'
			// _cStrjson+='  "codigorastreio" : "",'
			// _cStrjson+='  "codpais_dest" : "",'
			// _cStrjson+='  "codservetiqext" : "",'
			// _cStrjson+='  "dataplanejamento" :"'+dtoc(dDataBase)+'",'
			// _cStrjson+='  "faturamentodoismomentos" : "",'
			// _cStrjson+='  "intcubometro" : "",'
			// _cStrjson+='  "telefone2" : "",'
			// _cStrjson+='  "inscrestadual_dep" : "",'
			// _cStrjson+='  "numeroordemproducao" : "",'
			// _cStrjson+='  "data_pagto" : "'+dtoc(dDataBase)+'",'
			// _cStrjson+='  "codigotiporecebimento" : "",'
			// _cStrjson+='  "agrupadorped" : "",'
			// _cStrjson+='  "anodisponibilizacao" : "",'
			// _cStrjson+='  "anorecebimento" : "",'
			// _cStrjson+='  "bairro_consig" : "",'
			// _cStrjson+='  "barraseparacao" : "",'
			// _cStrjson+='  "cep_consig" : "",'
			// _cStrjson+='  "cidade_consig" : "",'
			// _cStrjson+='  "cnpj_consig" : "",'
			// _cStrjson+='  "codigo_consig" : "",'
			// _cStrjson+='  "complementoend_consig" : "",'
			// _cStrjson+='  "data_agendamento" : "",'
			// _cStrjson+='  "data_faturamento" : "",'
			// _cStrjson+='  "endereco_consig" : "",'
			// _cStrjson+='  "estado_consig" : "",'
			// _cStrjson+='  "fantasia_consig" : "",'
			// _cStrjson+='  "idintegracaoerp" : "",'
			// _cStrjson+='  "inscrestadual_consig" : "",'
			// _cStrjson+='  "nome_consig" : "",'
			// _cStrjson+='  "numend_consig" : "",'
			// _cStrjson+='  "obsseparacao" : "",'
			// _cStrjson+='  "pessoa_consig" : "",'
			// _cStrjson+='  "picktolight" : "",'
			// _cStrjson+='  "semanadisponibilizacao" : "",'
			// _cStrjson+='  "semanarecebimento" : "",'
			// _cStrjson+='  "tiporegimetributacao" : "",'
			// _cStrjson+='  "canal_venda" : "",'
			_cStrjson+='  "janela_fim" : "",'
			_cStrjson+='  "janela_inicio" : ""'
			_cStrjson+='} ] }'

			_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
			oJson     := tJsonParser():New()
			lRet      := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
			
		
		ENDIF
	endif

	IF SF2->(DBSEEK(xFilial('SF2')+cDoc+cSerie+cFornece)) .and. cLocal=="95" .and. cFilAnt=="1201" //armazem NORMAL
		IF SD2->(DBSEEK(xFilial('SD2')+cDoc+cSerie+cFornece))
				DBSETORDER(1) 
				DBSELECTAREA('SA4')
				SA4->(DBSEEK(xFilial('SA4')+SF2->F2_TRANSP))
				DBSETORDER(1) 
				DBSELECTAREA('SB1')
				SB1->(DBSEEK(xFilial('SB1')+SD2->D2_COD))
				cCfop:=POSICIONE('SD2',3,xFilial('SD2')+cDoc+cSerie+cFornece,'D2_CF')
			// Prepara a chamada do metodo de carga da fila de integração //
			_cStrjson:=' { '
			_cStrjson+='"chavelayout" : "int_faturamento", '
			_cStrjson+='"list" : [ { '
			_cStrjson+='  "codigointerno" : "'+SF2->F2_DOC+'", '
			_cStrjson+='  "numpedido" : "'+SD2->D2_PEDIDO+'", '
			_cStrjson+='  "chaveacessonfe" : "'+SF2->F2_CHVNFE+'",'
			_cStrjson+='  "sequencia" : "'+SF2->F2_SERIE+'", '
			_cStrjson+='  "cnpj_depositante" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "cnpj_emitente" : "'+SM0->M0_CGC+'", '  //'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_CGC')+'
			_cStrjson+='  "tipo" :"S",  
			_cStrjson+='  "descroper" : "'+POSICIONE('SX5',1,xFilial('SX5')+"13"+cCfop,'X5_DESCRI')+'",'
			_cStrjson+='  "cfop" : "'+cCfop+'",'
			_cStrjson+='  "dataemissao" : "'+DTOC(SF2->F2_EMISSAO)+'", '
			_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_PESSOA')+'", ' //_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "codigo_dest" :  "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_COD')+'", '
			_cStrjson+='  "nome_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NOME')+'", '  //_cStrjson+='  "nome_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CGC')+'", '  //_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
		//	_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_NREDUZ')+'", '//_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NREDUZ')+'", '
			 _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_END')+'", ' // _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			 _cStrjson+='  "numend_dest" : "", '// _cStrjson+='  "numend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '//PRECISA MONTAR REGRA
		//	_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_COMPLEM')+'", '//_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_COMPLEM')+'", '
			_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_BAIRRO')+'", ' //_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cep_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CEP')+'", '//_cStrjson+='  "cep_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_MUN')+'", '//_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
		///_cStrjson+='  "telefone_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_TEL')+'",' //_cStrjson+='  "telefone_dest" : "",'
			_cStrjson+='  "estado_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_EST')+'", '//_cStrjson+='  "estado_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "inscrestadual_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_INSCR')+'",' //_cStrjson+='  "inscrestadual_dest" : "",'
		//	_cStrjson+='  "inscrmunicipal_dest" : "",'
			_cStrjson+='  "endereco_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_END')+'", '//_cStrjson+='  "endereco_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_MUN')+'", ' //_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "bairro_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_BAIRRO')+'", '//_cStrjson+='  "bairro_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
		//	_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_MUNE')+'", '//_cStrjson+='  "estado_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CEP')+'", '//_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
		//	_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE,'A1_CGC')+'", '//_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			_cStrjson+='  "inscrestadual_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_INSCR')+'",'
		//	_cStrjson+='  "baseicms" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALICM), "@E 999999999.99")))+'", '
		//	_cStrjson+='  "valoricms" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALIPI), "@E 999999999.99")))+'",'
			// _cStrjson+='  "basesubstituicao" : "",'
			// _cStrjson+='  "valorsubstituicao" : "",'
			// _cStrjson+='  "frete" : "",'
			// _cStrjson+='  "seguro" : "",'
			// _cStrjson+='  "despesasacessorias" : "",'   //
			// _cStrjson+='  "ipi" : "",'
			_cStrjson+='  "vlrprodutos" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALMERC), "@E 999999999.99")))+'",'
			_cStrjson+='  "vlrtotal" : "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_VALBRUT), "@E 999999999.99")))+'",'
			_cStrjson+='  "nome_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_NREDUZ')+'",'
			_cStrjson+='  "cnpj_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_CGC')+'",'
			// _cStrjson+='  "endereco_transp" : "",'
			// _cStrjson+='  "numend_transp" : "",'
			// _cStrjson+='  "bairro_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_BAIRRO')+'",'
			// _cStrjson+='  "cidade_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_MUN')+'",'
			// _cStrjson+='  "estado_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_EST')+'",'
			// _cStrjson+='  "cep_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_CEP')+'",'
			 _cStrjson+='  "inscrestadual_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF2->F2_TRANSP,'A4_INSEST')+'",'
			 _cStrjson+='  "ciffob" : "'+iif(SF2->F2_TPFRETE=="F","2","1")+'",'
			// _cStrjson+='  "veiculo" : "",'
			// _cStrjson+='  "estado_veiculo" : "",'
			// _cStrjson+='  "qtde" : "'+cvaltochar(SF2->F2_VOLUME1)+'",'
			// _cStrjson+='  "especie" : "",'
			// _cStrjson+='  "marca" : "",'
			// _cStrjson+='  "numero" : "",'
			_cStrjson+='  "pesoliquido" :  "'+cvaltochar(alltrim(TRANSFORM((SF2->F2_PLIQUI), "@E 999999999.99")))+'",'
			// _cStrjson+='  "pis" : "",'
			// _cStrjson+='  "cofins" : "",'
			// _cStrjson+='  "cs" : "",'
			// _cStrjson+='  "ir" : "",'
			// _cStrjson+='  "valoriss" : "",'
			// _cStrjson+='  "valorservicos" : "",'
			// _cStrjson+='  "idmovimento" : "",'
			// _cStrjson+='  "idnotafiscal" : "",'
			// _cStrjson+='  "gerafinceiro" : "",'
			// _cStrjson+='  "tipodocumento" : "",'
			// _cStrjson+='  "tipocarga" : "",'
			// _cStrjson+='  "limitecorte" : "",'
			// _cStrjson+='  "paginageomapa" : "",'
			_cStrjson+='  "num_itens" : "1",'
			_cStrjson+='  "tiponf" : "N",'
			_cStrjson+='  "estado" : "N",'
			//_cStrjson+='  "data_coleta" : "'+dtoc(dDataBase)+'",'
			//_cStrjson+='  "hora_coleta" : "'+TIME()+'",'
			_cStrjson+='  "pessoa_entrega" : "'+iif(SF2->F2_TPFRETE=="F","2","1")+' ",'
			// _cStrjson+='  "codigo_entrega" : "",'
			// _cStrjson+='  "nome_entrega" : "",'
			// _cStrjson+='  "fantasia_entrega" : "",'
			// _cStrjson+='  "numend_entrega" : "",'
			// _cStrjson+='  "complementoend_entrega" : "",'
			// _cStrjson+='  "nomerepresentante" : "",'
			// _cStrjson+='  "telefone_representante" : "",'
			_cStrjson+='  "cnpj_unidade" : "01125797001198",'
			// _cStrjson+='  "fatura" : "",'
			_cStrjson+='  "observacao" : "",'
			// _cStrjson+='  "estoqueverificado" : "",'
			// _cStrjson+='  "chaveidentificacaoext" : "",'
			// _cStrjson+='  "classificacaocliente" : "",'
			// _cStrjson+='  "prioridade" : "",'
			// _cStrjson+='  "porcentagemcxfechada" : "",'
			// _cStrjson+='  "chaveacessonfe" : "'+SF2->F2_CHVNFE+'",'
			// _cStrjson+='  "sequenciaped" : "",'
			// _cStrjson+='  "cnpj_transpredespacho" : "",'
			_cStrjson+='  "inscrestadual_emitente" : "'+SM0->M0_INSC+'",'
			_cStrjson+='  "codigo_servicotransp" : "",'
			// _cStrjson+='  "codigotipopedido" : "VENDA",'
			// _cStrjson+='  "embarqueprioritario" : "",'
			// _cStrjson+='  "complemento_dest" : "",'
			// _cStrjson+='  "roteiro" : "",'
			// _cStrjson+='  "seq_entrega" : "",'
			_cStrjson+='  "nome_emit" : "'+SM0->M0_NOMECOM+'",'
			_cStrjson+='  "fantasia_emit" : "'+SM0->M0_NOMECOM+'",'
			// _cStrjson+='  "codretencao" : "",'
			// _cStrjson+='  "valoricmsdesonerado" : "",'
			// _cStrjson+='  "presencacomprador" : "",'
			// _cStrjson+='  "formapagamento" : "",'
			// _cStrjson+='  "tipoentrada" : "",'
			// _cStrjson+='  "utilizazpl" : "",'
			// _cStrjson+='  "codigorastreio" : "",'
			// _cStrjson+='  "codpais_dest" : "",'
			// _cStrjson+='  "codservetiqext" : "",'
			// _cStrjson+='  "dataplanejamento" :"'+dtoc(dDataBase)+'",'
			// _cStrjson+='  "faturamentodoismomentos" : "",'
			// _cStrjson+='  "intcubometro" : "",'
			// _cStrjson+='  "telefone2" : "",'
			// _cStrjson+='  "inscrestadual_dep" : "",'
			// _cStrjson+='  "numeroordemproducao" : "",'
			// _cStrjson+='  "data_pagto" : "'+dtoc(dDataBase)+'",'
			// _cStrjson+='  "codigotiporecebimento" : "",'
			// _cStrjson+='  "agrupadorped" : "",'
			// _cStrjson+='  "anodisponibilizacao" : "",'
			// _cStrjson+='  "anorecebimento" : "",'
			// _cStrjson+='  "bairro_consig" : "",'
			// _cStrjson+='  "barraseparacao" : "",'
			// _cStrjson+='  "cep_consig" : "",'
			// _cStrjson+='  "cidade_consig" : "",'
			// _cStrjson+='  "cnpj_consig" : "",'
			// _cStrjson+='  "codigo_consig" : "",'
			// _cStrjson+='  "complementoend_consig" : "",'
			// _cStrjson+='  "data_agendamento" : "",'
			// _cStrjson+='  "data_faturamento" : "",'
			// _cStrjson+='  "endereco_consig" : "",'
			// _cStrjson+='  "estado_consig" : "",'
			// _cStrjson+='  "fantasia_consig" : "",'
			// _cStrjson+='  "idintegracaoerp" : "",'
			// _cStrjson+='  "inscrestadual_consig" : "",'
			// _cStrjson+='  "nome_consig" : "",'
			// _cStrjson+='  "numend_consig" : "",'
			// _cStrjson+='  "obsseparacao" : "",'
			// _cStrjson+='  "pessoa_consig" : "",'
			// _cStrjson+='  "picktolight" : "",'
			// _cStrjson+='  "semanadisponibilizacao" : "",'
			// _cStrjson+='  "semanarecebimento" : "",'
			// _cStrjson+='  "tiporegimetributacao" : "",'
			// _cStrjson+='  "canal_venda" : "",'
			_cStrjson+='  "janela_fim" : "",'
			_cStrjson+='  "janela_inicio" : ""'
			_cStrjson+='} ] }'

			_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
			oJson     := tJsonParser():New()
			lRet      := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
			
		
		ENDIF
	endif


return
