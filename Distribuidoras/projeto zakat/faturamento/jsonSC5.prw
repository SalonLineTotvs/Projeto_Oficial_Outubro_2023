#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"


user function jsonsc5()
//local cpedido :="007710"
//Local cSerieNF :="1"
//local cCli :="002196"

// PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "FAT" TABLES "SA1", "SC6", "SB1","SC5" ,"SA4"

// u_SLJsonSC5(cpedido)
// RESET ENVIRONMENT
 return

user Function SLJsonSC5(cpedido)
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
	// Local cDoc			:= PADR(cNF,TAMSX3('F1_DOC')[1])
	// Local cSerie		:= PADR(cSerieNF,TAMSX3('F1_SERIE')[1])
	// Local cFornece		:= PADR(cForn,TAMSX3('F1_FORNECE')[1])
	//Local _cUrl         := "http://wmshml.ativalog.com.br:8080/siltwms/webresources/rest/importacao/integrar"  //homolog
	Local _cUrl         := "http://wms.ativalog.com.br:8080/siltwms/webresources/rest/importacao/integrar" // producao ativa
	
	Local nqnt :=0
	Local ntotal :=0
	local nseq:=0
	aAdd( aHeadOut, "Content-Type: text/plain" )
	aAdd( aHeadOut, "Accept: text/plain" )
	//aAdd( aHeadOut, "apiKey: 3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B") // homolog
	aAdd( aHeadOut, "apiKey: 40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6") //producao ativa

	DBSELECTAREA('SC5')
	DBSETORDER(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	DBSELECTAREA('SC6')
	DBSETORDER(1) //D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
	
	clocal:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_LOCAL')

	IF SC5->(DBSEEK(xFilial('SC5')+cpedido)) .and. cLocal=="96" .and. cFilAnt=="1201" //armazem CROSS
		IF SC6->(DBSEEK(xFilial('SC6')+cpedido))
				DBSETORDER(1) 
				DBSELECTAREA('SA4')
				SA4->(DBSEEK(xFilial('SA4')+SC5->C5_TRANSP))
				DBSETORDER(1) 
				DBSELECTAREA('SB1')
				SB1->(DBSEEK(xFilial('SB1')+SC6->C6_PRODUTO))
				cCfop:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_CF')
			
			// Prepara a chamada do metodo de carga da fila de integração
			while SC6->C6_NUM == cpedido .and. SC6->C6_FILIAL==cFilAnt
					ntotal +=SC6->C6_VALOR
					nqnt +=SC6->C6_QTDVEN
				SC6->(DBSKIP())
			ENDDO
			_cStrjson:=' { '
			_cStrjson+='"chavelayout" : "int_pedido", '
			_cStrjson+='"list" : [ { '
			_cStrjson+='  "codigointerno" : "'+SC5->C5_NUM+'", '
			_cStrjson+='  "numpedido" : "'+SC5->C5_NUM+'", '
			_cStrjson+='  "cnpj_depositante" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "cnpj_emitente" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "sequencia" : "", '
			_cStrjson+='  "tipo" :"S",  
			_cStrjson+='  "descroper" : "'+POSICIONE('SX5',1,xFilial('SX5')+"13"+cCfop,'X5_DESCRI')+'",'
			_cStrjson+='  "cfop" : "'+cCfop+'",'
			_cStrjson+='  "data_emissao" : "'+DTOC(SC5->C5_EMISSAO)+'", '
			_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_PESSOA')+'", ' //_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "codigo_dest" :  "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_COD')+'", '
			_cStrjson+='  "nome_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')+'", '  //_cStrjson+='  "nome_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ')+'", '//_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NREDUZ')+'", '
			_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CGC')+'", '  //_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			 _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_END')+'", ' // _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			 _cStrjson+='  "numend_dest" : "", '// _cStrjson+='  "numend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '//PRECISA MONTAR REGRA
			_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_COMPLEM')+'", '//_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_COMPLEM')+'", '
			_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_BAIRRO')+'", ' //_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cep_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CEP')+'", '//_cStrjson+='  "cep_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_MUN')+'", '//_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "telefone_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_TEL')+'",' //_cStrjson+='  "telefone_dest" : "",'
			_cStrjson+='  "estado_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_EST')+'", '//_cStrjson+='  "estado_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "inscrestadual_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_INSCR')+'",' //_cStrjson+='  "inscrestadual_dest" : "",'
			_cStrjson+='  "inscrmunicipal_dest" : "",'
			_cStrjson+='  "endereco_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_END')+'", '//_cStrjson+='  "endereco_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_MUN')+'", ' //_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "bairro_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_BAIRRO')+'", '//_cStrjson+='  "bairro_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_MUN')+'", '//_cStrjson+='  "estado_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CEP')+'", '//_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CGC')+'", '//_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			_cStrjson+='  "inscrestadual_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_INSCR')+'",'
			_cStrjson+='  "baseicms" : "", '
			_cStrjson+='  "valoricms" : "",'
			_cStrjson+='  "basesubstituicao" : "",'
			_cStrjson+='  "valorsubstituicao" : "",'
			_cStrjson+='  "frete" : "",'
			_cStrjson+='  "seguro" : "",'
			_cStrjson+='  "despesasacessorias" : "",'   ////
			_cStrjson+='  "ipi" : "",'
			_cStrjson+='  "vlrprodutos" : "'+cvaltochar(alltrim(TRANSFORM((ntotal), "@E 999999999.99")))+'",'    ///d2_total
			_cStrjson+='  "vlrtotal" : "'+cvaltochar(alltrim(TRANSFORM((ntotal), "@E 999999999.99")))+'",'    ////d2_valbruto
			_cStrjson+='  "nome_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_NREDUZ')+'",'
			_cStrjson+='  "cnpj_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_CGC')+'",'
			_cStrjson+='  "endereco_transp" : "",'
			_cStrjson+='  "numend_transp" : "",'
			_cStrjson+='  "bairro_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_BAIRRO')+'",'
			_cStrjson+='  "cidade_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_MUN')+'",'
			_cStrjson+='  "estado_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_EST')+'",'
			_cStrjson+='  "cep_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_CEP')+'",'
			_cStrjson+='  "inscrestadual_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_INSEST')+'",'
			_cStrjson+='  "ciffob" : "'+iif(SC5->C5_TPFRETE=="F","2","1")+'",'
			_cStrjson+='  "veiculo" : "",'
			_cStrjson+='  "estado_veiculo" : "",'
			_cStrjson+='  "qtde" : "'+cvaltochar(SC5->C5_VOLUME1)+'",'
			_cStrjson+='  "especie" : "",'
			_cStrjson+='  "marca" : "",'
			_cStrjson+='  "numero" : "",'
			_cStrjson+='  "pesoliquido" :  "'+cvaltochar(alltrim(TRANSFORM((SC5->C5_PESOL), "@E 999999999.99")))+'",'
			_cStrjson+='  "pis" : "",'
			_cStrjson+='  "cofins" : "",'
			_cStrjson+='  "cs" : "",'
			_cStrjson+='  "ir" : "",'
			_cStrjson+='  "valoriss" : "",'
			_cStrjson+='  "valorservicos" : "",'
			_cStrjson+='  "idmovimento" : "",'
			_cStrjson+='  "idnotafiscal" : "",'
			_cStrjson+='  "gerafinceiro" : "",'
			_cStrjson+='  "tipodocumento" : "",'
			_cStrjson+='  "tipocarga" : "",'
			_cStrjson+='  "limitecorte" : "",'
			_cStrjson+='  "paginageomapa" : "",'
			_cStrjson+='  "num_itens" : "1",'
			_cStrjson+='  "tiponf" : "P",'
			_cStrjson+='  "estado" : "N",'
			_cStrjson+='  "data_coleta" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "hora_coleta" : "'+TIME()+'",'
			_cStrjson+='  "pessoa_entrega" : "'+iif(SC5->C5_TPFRETE=="F","2","1")+' ",'
			_cStrjson+='  "codigo_entrega" : "",'
			_cStrjson+='  "nome_entrega" : "",'
			_cStrjson+='  "fantasia_entrega" : "",'
			_cStrjson+='  "numend_entrega" : "",'
			_cStrjson+='  "complementoend_entrega" : "",'
			_cStrjson+='  "nomerepresentante" : "",'
			_cStrjson+='  "telefone_representante" : "",'
			_cStrjson+='  "cnpj_unidade" : "01125797001198",'
			_cStrjson+='  "fatura" : "",'
			_cStrjson+='  "observacao" : "",'
			_cStrjson+='  "estoqueverificado" : "",'
			_cStrjson+='  "chaveidentificacaoext" : "",'
			_cStrjson+='  "classificacaocliente" : "",'
			_cStrjson+='  "prioridade" : "",'
			_cStrjson+='  "porcentagemcxfechada" : "",'
			_cStrjson+='  "chaveacessonfe" : "",'
			_cStrjson+='  "sequenciaped" : "",'
			_cStrjson+='  "cnpj_transpredespacho" : "",'
			_cStrjson+='  "inscrestadual_emitente" : "'+SM0->M0_INSC+'",'
			_cStrjson+='  "codigo_servicotransp" : "",'
			_cStrjson+='  "codigotipopedido" : "PED_CROSS",'
			_cStrjson+='  "embarqueprioritario" : "",'
			_cStrjson+='  "complemento_dest" : "",'
			_cStrjson+='  "roteiro" : "",'
			_cStrjson+='  "seq_entrega" : "",'
			_cStrjson+='  "nome_emit" : "'+SM0->M0_NOMECOM+'",'
			_cStrjson+='  "fantasia_emit" : "'+SM0->M0_NOMECOM+'",'
			_cStrjson+='  "codretencao" : "",'
			_cStrjson+='  "valoricmsdesonerado" : "",'
			_cStrjson+='  "presencacomprador" : "",'
			_cStrjson+='  "formapagamento" : "",'
			_cStrjson+='  "tipoentrada" : "",'
			_cStrjson+='  "utilizazpl" : "",'
			_cStrjson+='  "codigorastreio" : "",'
			_cStrjson+='  "codpais_dest" : "",'
			_cStrjson+='  "codservetiqext" : "",'
			_cStrjson+='  "dataplanejamento" :"'+dtoc(dDataBase)+'",'
			_cStrjson+='  "faturamentodoismomentos" : "",'
			_cStrjson+='  "intcubometro" : "",'
			_cStrjson+='  "telefone2" : "",'
			_cStrjson+='  "inscrestadual_dep" : "",'
			_cStrjson+='  "numeroordemproducao" : "",'
			_cStrjson+='  "data_pagto" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "codigotiporecebimento" : "",'
			_cStrjson+='  "agrupadorped" : "",'
			_cStrjson+='  "anodisponibilizacao" : "",'
			_cStrjson+='  "anorecebimento" : "",'
			_cStrjson+='  "bairro_consig" : "",'
			_cStrjson+='  "barraseparacao" : "",'
			_cStrjson+='  "cep_consig" : "",'
			_cStrjson+='  "cidade_consig" : "",'
			_cStrjson+='  "cnpj_consig" : "",'
			_cStrjson+='  "codigo_consig" : "",'
			_cStrjson+='  "complementoend_consig" : "",'
			_cStrjson+='  "data_agendamento" : "",'
			_cStrjson+='  "data_faturamento" : "",'
			_cStrjson+='  "endereco_consig" : "",'
			_cStrjson+='  "estado_consig" : "",'
			_cStrjson+='  "fantasia_consig" : "",'
			_cStrjson+='  "idintegracaoerp" : "",'
			_cStrjson+='  "inscrestadual_consig" : "",'
			_cStrjson+='  "nome_consig" : "",'
			_cStrjson+='  "numend_consig" : "",'
			_cStrjson+='  "obsseparacao" : "",'
			_cStrjson+='  "pessoa_consig" : "",'
			_cStrjson+='  "picktolight" : "",'
			_cStrjson+='  "semanadisponibilizacao" : "",'
			_cStrjson+='  "semanarecebimento" : "",'
			_cStrjson+='  "tiporegimetributacao" : "",'
			_cStrjson+='  "canal_venda" : "",'
			_cStrjson+='  "janela_fim" : "",'
			_cStrjson+='  "janela_inicio" : ""'
			_cStrjson+='} ] }'

			_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
			oJson     := tJsonParser():New()
			lRet      := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
			
			DBSELECTAREA('SC6')
			SC6->(DBSEEK(xFilial('SC6')+cpedido))
			DBSETORDER(1) 
		
			IF lRet
			 nseq :=1
			 _cStrjson :=''
			_cStrjson+=' { '
					_cStrjson+='  "chavelayout" : "int_pedidodet",'
					_cStrjson+='  "list" : [ '
				WHILE SC6->C6_NUM == cpedido .and. SC6->C6_FILIAL==cFilAnt
				// DBSETORDER(1) 
				// DBSELECTAREA('SB1')
				// SB1->(DBSEEK(xFilial('SB1')+SD1->D1_COD))
				
					//_cStrjson :=' { '
					// _cStrjson+=' { '
					// _cStrjson+='  "chavelayout" : "int_pedidodet",'
					// _cStrjson+='  "list" : [ { '
					_cStrjson +=' { '
					_cStrjson+='  "codigointerno" : "'+SC5->C5_NUM+'", '
					_cStrjson+='  "numpedido" : "'+SC5->C5_NUM+'", '
					_cStrjson+='  "cnpj_depositante" :  "'+SM0->M0_CGC+'", '
					_cStrjson+='  "cnpj_emitente" :  "'+SM0->M0_CGC+'", '
					_cStrjson+='  "serie" : "", '
					_cStrjson+='  "tipo" : "S",  
					_cStrjson+='  "idseq" : "'+cvaltochar(nseq)+'",'
					_cStrjson+='  "codigoindustria" : "'+SC6->C6_PRODUTO+'", '
					_cStrjson+='  "descr_prod" :  "'+POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_DESC')+'", '
					_cStrjson+='  "barra" : "'+POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_X_EAN13')+'",'
					_cStrjson+='  "numserie" :  "", '
					_cStrjson+='  "qtde" : "'+cvaltochar(SC6->C6_QTDVEN)+'", '
					_cStrjson+='  "vlrunit" : "'+cvaltochar(alltrim(TRANSFORM((SC6->C6_PRCVEN), "@E 999999999.99")))+'", '
					_cStrjson+='  "vlrtotal" :"'+cvaltochar(alltrim(TRANSFORM((SC6->C6_VALOR), "@E 999999999.99")))+'", '
					_cStrjson+='  "totalliquido" : "'+cvaltochar(alltrim(TRANSFORM((SC6->C6_VALOR), "@E 999999999.99")))+'", '
					_cStrjson+='  "tipoproduto" : "'+SUBSTR(POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_TIPO'),1,1)+'",'
					_cStrjson+='  "codindustria" : "",'
					_cStrjson+='  "descrprod" : "'+POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_DESC')+'",'
					_cStrjson+='  "inscrestadual_emit" : "'+SM0->M0_INSC+'",'
					_cStrjson+='  "notafiscal" : "",'
					_cStrjson+='  "remessa" : "",'
					_cStrjson+='  "serienf" : "",'
					_cStrjson+='  "volumecaixa" : ""'
					_cStrjson+='} ,' //] }'
								
					// _cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					// oJson      := tJsonParser():New()
					// lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					nseq++
					SC6->(DBSKIP())
				ENDDO
				_cStrjson+=' ] }'
					_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					oJson      := tJsonParser():New()
					lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					
			endif
		ENDIF
	endif

	IF SC5->(DBSEEK(xFilial('SC5')+cpedido)) .and. cLocal=="95" .and. cFilAnt=="1201" //armazem NORMAL de VENDA
		IF SC6->(DBSEEK(xFilial('SC6')+cpedido))
				DBSETORDER(1) 
				DBSELECTAREA('SA4')
				SA4->(DBSEEK(xFilial('SA4')+SC5->C5_TRANSP))
				DBSETORDER(1) 
				DBSELECTAREA('SB1')
				SB1->(DBSEEK(xFilial('SB1')+SC6->C6_PRODUTO))
				cCfop:=POSICIONE('SC6',1,xFilial('SC6')+cpedido,'C6_CF')
			
			// Prepara a chamada do metodo de carga da fila de integração
			while SC6->C6_NUM == cpedido .and. SC6->C6_FILIAL==cFilAnt
					ntotal +=SC6->C6_VALOR
					nqnt +=SC6->C6_QTDVEN
				SC6->(DBSKIP())
			ENDDO
			_cStrjson:=' { '
			_cStrjson+='"chavelayout" : "int_pedido", '
			_cStrjson+='"list" : [ { '
			_cStrjson+='  "codigointerno" : "'+SC5->C5_NUM+'", '
			_cStrjson+='  "numpedido" : "'+SC5->C5_NUM+'", '
			_cStrjson+='  "cnpj_depositante" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "cnpj_emitente" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "sequencia" : "", '
			_cStrjson+='  "tipo" :"S",  
			_cStrjson+='  "descroper" : "'+POSICIONE('SX5',1,xFilial('SX5')+"13"+cCfop,'X5_DESCRI')+'",'
			_cStrjson+='  "cfop" : "'+cCfop+'",'
			_cStrjson+='  "data_emissao" : "'+DTOC(SC5->C5_EMISSAO)+'", '
			_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_PESSOA')+'", ' //_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "codigo_dest" :  "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_COD')+'", '
			_cStrjson+='  "nome_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')+'", '  //_cStrjson+='  "nome_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ')+'", '//_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NREDUZ')+'", '
			_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CGC')+'", '  //_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			 _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_END')+'", ' // _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			 _cStrjson+='  "numend_dest" : "", '// _cStrjson+='  "numend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '//PRECISA MONTAR REGRA
			_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_COMPLEM')+'", '//_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_COMPLEM')+'", '
			_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_BAIRRO')+'", ' //_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cep_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CEP')+'", '//_cStrjson+='  "cep_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_MUN')+'", '//_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "telefone_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_TEL')+'",' //_cStrjson+='  "telefone_dest" : "",'
			_cStrjson+='  "estado_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_EST')+'", '//_cStrjson+='  "estado_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "inscrestadual_dest" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_INSCR')+'",' //_cStrjson+='  "inscrestadual_dest" : "",'
			_cStrjson+='  "inscrmunicipal_dest" : "",'
			_cStrjson+='  "endereco_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_END')+'", '//_cStrjson+='  "endereco_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_MUN')+'", ' //_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "bairro_entrega" :"'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_BAIRRO')+'", '//_cStrjson+='  "bairro_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_MUN')+'", '//_cStrjson+='  "estado_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CEP')+'", '//_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_CGC')+'", '//_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			_cStrjson+='  "inscrestadual_entrega" : "'+POSICIONE('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_INSCR')+'",'
			_cStrjson+='  "baseicms" : "", '
			_cStrjson+='  "valoricms" : "",'
			_cStrjson+='  "basesubstituicao" : "",'
			_cStrjson+='  "valorsubstituicao" : "",'
			_cStrjson+='  "frete" : "",'
			_cStrjson+='  "seguro" : "",'
			_cStrjson+='  "despesasacessorias" : "",'   ////
			_cStrjson+='  "ipi" : "",'
			_cStrjson+='  "vlrprodutos" : "'+cvaltochar(alltrim(TRANSFORM((ntotal), "@E 999999999.99")))+'",'
			_cStrjson+='  "vlrtotal" : "'+cvaltochar(alltrim(TRANSFORM((ntotal), "@E 999999999.99")))+'",'
			_cStrjson+='  "nome_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_NREDUZ')+'",'
			_cStrjson+='  "cnpj_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_CGC')+'",'
			_cStrjson+='  "endereco_transp" : "",'
			_cStrjson+='  "numend_transp" : "",'
			_cStrjson+='  "bairro_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_BAIRRO')+'",'
			_cStrjson+='  "cidade_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_MUN')+'",'
			_cStrjson+='  "estado_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_EST')+'",'
			_cStrjson+='  "cep_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_CEP')+'",'
			_cStrjson+='  "inscrestadual_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SC5->C5_TRANSP,'A4_INSEST')+'",'
			_cStrjson+='  "ciffob" : "'+iif(SC5->C5_TPFRETE=="F","2","1")+'",'
			_cStrjson+='  "veiculo" : "",'
			_cStrjson+='  "estado_veiculo" : "",'
			_cStrjson+='  "qtde" : "'+cvaltochar(SC5->C5_VOLUME1)+'",'
			_cStrjson+='  "especie" : "",'
			_cStrjson+='  "marca" : "",'
			_cStrjson+='  "numero" : "",'
			_cStrjson+='  "pesoliquido" :  "'+cvaltochar(alltrim(TRANSFORM((SC5->C5_PESOL), "@E 999999999.99")))+'",'
			_cStrjson+='  "pis" : "",'
			_cStrjson+='  "cofins" : "",'
			_cStrjson+='  "cs" : "",'
			_cStrjson+='  "ir" : "",'
			_cStrjson+='  "valoriss" : "",'
			_cStrjson+='  "valorservicos" : "",'
			_cStrjson+='  "idmovimento" : "",'
			_cStrjson+='  "idnotafiscal" : "",'
			_cStrjson+='  "gerafinceiro" : "",'
			_cStrjson+='  "tipodocumento" : "",'
			_cStrjson+='  "tipocarga" : "",'
			_cStrjson+='  "limitecorte" : "",'
			_cStrjson+='  "paginageomapa" : "",'
			_cStrjson+='  "num_itens" : "1",'
			_cStrjson+='  "tiponf" : "P",'
			_cStrjson+='  "estado" : "N",'
			_cStrjson+='  "data_coleta" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "hora_coleta" : "'+TIME()+'",'
			_cStrjson+='  "pessoa_entrega" : "'+iif(SC5->C5_TPFRETE=="F","2","1")+' ",'
			_cStrjson+='  "codigo_entrega" : "",'
			_cStrjson+='  "nome_entrega" : "",'
			_cStrjson+='  "fantasia_entrega" : "",'
			_cStrjson+='  "numend_entrega" : "",'
			_cStrjson+='  "complementoend_entrega" : "",'
			_cStrjson+='  "nomerepresentante" : "",'
			_cStrjson+='  "telefone_representante" : "",'
			_cStrjson+='  "cnpj_unidade" : "01125797001198",'
			_cStrjson+='  "fatura" : "",'
			_cStrjson+='  "observacao" : "",'
			_cStrjson+='  "estoqueverificado" : "",'
			_cStrjson+='  "chaveidentificacaoext" : "",'
			_cStrjson+='  "classificacaocliente" : "",'
			_cStrjson+='  "prioridade" : "",'
			_cStrjson+='  "porcentagemcxfechada" : "",'
			_cStrjson+='  "chaveacessonfe" : "",'
			_cStrjson+='  "sequenciaped" : "",'
			_cStrjson+='  "cnpj_transpredespacho" : "",'
			_cStrjson+='  "inscrestadual_emitente" : "'+SM0->M0_INSC+'",'
			_cStrjson+='  "codigo_servicotransp" : "",'
			_cStrjson+='  "codigotipopedido" : "PED_VEN",'
			_cStrjson+='  "embarqueprioritario" : "",'
			_cStrjson+='  "complemento_dest" : "",'
			_cStrjson+='  "roteiro" : "",'
			_cStrjson+='  "seq_entrega" : "",'
			_cStrjson+='  "nome_emit" : "'+SM0->M0_NOMECOM+'",'
			_cStrjson+='  "fantasia_emit" : "'+SM0->M0_NOMECOM+'",'
			_cStrjson+='  "codretencao" : "",'
			_cStrjson+='  "valoricmsdesonerado" : "",'
			_cStrjson+='  "presencacomprador" : "",'
			_cStrjson+='  "formapagamento" : "",'
			_cStrjson+='  "tipoentrada" : "",'
			_cStrjson+='  "utilizazpl" : "",'
			_cStrjson+='  "codigorastreio" : "",'
			_cStrjson+='  "codpais_dest" : "",'
			_cStrjson+='  "codservetiqext" : "",'
			_cStrjson+='  "dataplanejamento" :"'+dtoc(dDataBase)+'",'
			_cStrjson+='  "faturamentodoismomentos" : "",'
			_cStrjson+='  "intcubometro" : "",'
			_cStrjson+='  "telefone2" : "",'
			_cStrjson+='  "inscrestadual_dep" : "",'
			_cStrjson+='  "numeroordemproducao" : "",'
			_cStrjson+='  "data_pagto" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "codigotiporecebimento" : "",'
			_cStrjson+='  "agrupadorped" : "",'
			_cStrjson+='  "anodisponibilizacao" : "",'
			_cStrjson+='  "anorecebimento" : "",'
			_cStrjson+='  "bairro_consig" : "",'
			_cStrjson+='  "barraseparacao" : "",'
			_cStrjson+='  "cep_consig" : "",'
			_cStrjson+='  "cidade_consig" : "",'
			_cStrjson+='  "cnpj_consig" : "",'
			_cStrjson+='  "codigo_consig" : "",'
			_cStrjson+='  "complementoend_consig" : "",'
			_cStrjson+='  "data_agendamento" : "",'
			_cStrjson+='  "data_faturamento" : "",'
			_cStrjson+='  "endereco_consig" : "",'
			_cStrjson+='  "estado_consig" : "",'
			_cStrjson+='  "fantasia_consig" : "",'
			_cStrjson+='  "idintegracaoerp" : "",'
			_cStrjson+='  "inscrestadual_consig" : "",'
			_cStrjson+='  "nome_consig" : "",'
			_cStrjson+='  "numend_consig" : "",'
			_cStrjson+='  "obsseparacao" : "",'
			_cStrjson+='  "pessoa_consig" : "",'
			_cStrjson+='  "picktolight" : "",'
			_cStrjson+='  "semanadisponibilizacao" : "",'
			_cStrjson+='  "semanarecebimento" : "",'
			_cStrjson+='  "tiporegimetributacao" : "",'
			_cStrjson+='  "canal_venda" : "",'
			_cStrjson+='  "janela_fim" : "",'
			_cStrjson+='  "janela_inicio" : ""'
			_cStrjson+='} ] }'

			_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
			oJson     := tJsonParser():New()
			lRet      := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
			
			DBSELECTAREA('SC6')
			SC6->(DBSEEK(xFilial('SC6')+cpedido))
			DBSETORDER(1) 
		
			IF lRet
			 nseq :=1
			 _cStrjson :=''
			_cStrjson+=' { '
					_cStrjson+='  "chavelayout" : "int_pedidodet",'
					_cStrjson+='  "list" : [ '
				WHILE SC6->C6_NUM == cpedido .and. SC6->C6_FILIAL==cFilAnt
				// DBSETORDER(1) 
				// DBSELECTAREA('SB1')
				// SB1->(DBSEEK(xFilial('SB1')+SD1->D1_COD))
				
					//_cStrjson :=' { '
					// _cStrjson+=' { '
					// _cStrjson+='  "chavelayout" : "int_pedidodet",'
					// _cStrjson+='  "list" : [ { '
					_cStrjson +=' { '
					_cStrjson+='  "codigointerno" : "'+SC5->C5_NUM+'", '
					_cStrjson+='  "numpedido" : "'+SC5->C5_NUM+'", '
					_cStrjson+='  "cnpj_depositante" :  "'+SM0->M0_CGC+'", '
					_cStrjson+='  "cnpj_emitente" :  "'+SM0->M0_CGC+'", '
					_cStrjson+='  "serie" : "", '
					_cStrjson+='  "tipo" : "S",  
					_cStrjson+='  "idseq" : "'+cvaltochar(nseq)+'",'
					_cStrjson+='  "codigoindustria" : "'+SC6->C6_PRODUTO+'", '
					_cStrjson+='  "descr_prod" :  "'+POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_DESC')+'", '
					_cStrjson+='  "barra" : "'+POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_X_EAN13')+'",'
					_cStrjson+='  "numserie" :  "", '
					_cStrjson+='  "qtde" : "'+cvaltochar(SC6->C6_QTDVEN)+'", '
					_cStrjson+='  "vlrunit" : "'+cvaltochar(alltrim(TRANSFORM((SC6->C6_PRCVEN), "@E 999999999.99")))+'", '
					_cStrjson+='  "vlrtotal" :"'+cvaltochar(alltrim(TRANSFORM((SC6->C6_VALOR), "@E 999999999.99")))+'", '
					_cStrjson+='  "totalliquido" : "'+cvaltochar(alltrim(TRANSFORM((SC6->C6_VALOR), "@E 999999999.99")))+'", '
					_cStrjson+='  "tipoproduto" : "'+SUBSTR(POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_TIPO'),1,1)+'",'
					_cStrjson+='  "codindustria" : "",'
					_cStrjson+='  "descrprod" : "'+POSICIONE('SB1',1,xFilial('SB1')+SC6->C6_PRODUTO,'B1_DESC')+'",'
					_cStrjson+='  "inscrestadual_emit" : "'+SM0->M0_INSC+'",'
					_cStrjson+='  "notafiscal" : "",'
					_cStrjson+='  "remessa" : "",'
					_cStrjson+='  "serienf" : "",'
					_cStrjson+='  "volumecaixa" : ""'
					_cStrjson+='} ,' //] }'
								
					// _cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					// oJson      := tJsonParser():New()
					// lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					nseq++
					SC6->(DBSKIP())
				ENDDO
				_cStrjson+=' ] }'
					_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					oJson      := tJsonParser():New()
					lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					
			endif
		ENDIF
	endif

return
