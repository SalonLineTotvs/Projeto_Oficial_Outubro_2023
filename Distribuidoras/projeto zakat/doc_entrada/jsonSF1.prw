#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

// user function jsonsf1()
// local cNF :="000020956"   //"000020370"
// Local cSerieNF :="1"
// local cForn :="002196"
// local cloj :="01"

// PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" TABLES "SA2", "SD1", "SB1","SF1" ,"SA4"

// u_SLJsonSF1(cNF,cSerieNF,cForn,cloj)
// RESET ENVIRONMENT
// return

user Function SLJsonSF1(cNF,cSerieNF,cForn,cloj)
//user Function SLJsonSF1(cNF,cSerieNF,cForn)
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
	Local cCfop         := GETNEWPAR('SL_CFOPE',"2102")
	Local cDoc			:= PADR(cNF,TAMSX3('F1_DOC')[1])
	Local cSerie		:= PADR(cSerieNF,TAMSX3('F1_SERIE')[1])
	Local cFornece		:= PADR(cForn,TAMSX3('F1_FORNECE')[1])
	Local cloja			:= PADR(cloj,TAMSX3('F1_LOJA')[1])
	Local _cUrl         := "http://wms.ativalog.com.br:8080/siltwms/webresources/rest/importacao/integrar" // producao ativa
	//Local _cUrl         := "http://wmshml.ativalog.com.br:8080/siltwms/webresources/rest/importacao/integrar"   //homolog


	aAdd( aHeadOut, "Content-Type: text/plain" )
	aAdd( aHeadOut, "Accept: text/plain" )
	//aAdd( aHeadOut, "apiKey: 3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B") // homolog 
	aAdd( aHeadOut, "apiKey: 40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6") //producao ativa

	///PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" TABLES "SA2", "SD1", "SB1","SF1" ,"SA4"




	DBSELECTAREA('SF1')
	DBSETORDER(1) //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	DBSELECTAREA('SD1')
	DBSETORDER(1) //D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
	//verifico o armazem para diferente tratativa
	clocal:=POSICIONE('SD1',1,xFilial('SD1')+cDoc+cSerie+cFornece+cloja,'D1_LOCAL')
	_cMennota:= Posicione('SF1',1,xFilial('SF1')+cDoc+cSerie+cFornece+cloja,'F1_MENNOTA')
	IF SF1->(DBSEEK(xFilial('SF1')+cDoc+cSerie+cFornece+cloja)) .and. cLocal=="97" .and. cFilAnt=="1201" .and. substr(_cMennota,1,11)=="MONTA CARGA" // .and. cLocal=="96" armazem CROSS
		IF SD1->(DBSEEK(xFilial('SD1')+cDoc+cSerie+cFornece+cloja))
				DBSETORDER(1) 
				DBSELECTAREA('SA4')
				SA4->(DBSEEK(xFilial('SA4')+SF1->F1_TRANSP))
				DBSETORDER(1) 
				DBSELECTAREA('SB1')
				SB1->(DBSEEK(xFilial('SB1')+SD1->D1_COD))
			// Prepara a chamada do metodo de carga da fila de integração
			cCfop:=POSICIONE('SD1',1,xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,'D1_CF')
			_cStrjson:=' { '
			_cStrjson+='"chavelayout" : "int_pedido", '
			_cStrjson+='"list" : [ { '
			_cStrjson+='  "codigointerno" : "'+SF1->F1_DOC+'", '
			_cStrjson+='  "numpedido" : "'+SF1->F1_DOC+"C"+'", '
			_cStrjson+='  "cnpj_depositante" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "cnpj_emitente" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_CGC')+'", '
			_cStrjson+='  "sequencia" : "'+SF1->F1_SERIE+'", '
			_cStrjson+='  "tipo" :"E",  
			_cStrjson+='  "descroper" : "'+POSICIONE('SX5',1,xFilial('SX5')+"13"+cCfop,'X5_DESCRI')+'",' ///pegar descricao da CFOP 
			_cStrjson+='  "cfop" : "'+cCfop+'",'// '+POSICIONE('SD1',1,xFilial('SD1')+SF1->F1_DOCS+SF1->F1_SERIE+F1->F1_FORNECE+SF1->F1_LOJA,'D1_CF')+' /// posicione na CFOP de descricao
			_cStrjson+='  "data_emissao" : "'+DTOC(SF1->F1_EMISSAO)+'", ' 
			_cStrjson+='  "pessoa_dest" : "'+SM0->M0_NOMECOM+'", ' //_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "codigo_dest" :  "'+SM0->M0_CODFIL+'", '
			_cStrjson+='  "nome_dest" :"'+SM0->M0_NOMECOM+'", '  //_cStrjson+='  "nome_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "fantasia_dest" : "'+SM0->M0_NOMECOM+'", '//_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NREDUZ')+'", '
			_cStrjson+='  "cnpj_dest" : "'+SM0->M0_CGC+'", '  //_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			 _cStrjson+='  "endereco_dest" :"'+SM0->M0_ENDENT+'", ' // _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			 _cStrjson+='  "numend_dest" : "", '// _cStrjson+='  "numend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '//PRECISA MONTAR REGRA
			_cStrjson+='  "complementoend_dest" : "'+SM0->M0_COMPENT+'", '//_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_COMPLEM')+'", '
			_cStrjson+='  "bairro_dest" :"'+SM0->M0_BAIRENT+'", ' //_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cep_dest" : "'+SM0->M0_CEPENT+'", '//_cStrjson+='  "cep_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cidade_dest" : "'+SM0->M0_CIDENT+'", '//_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "telefone_dest" : "'+SM0->M0_TEL+'",' //_cStrjson+='  "telefone_dest" : "",'
			_cStrjson+='  "estado_dest" : "'+SM0->M0_ESTENT+'", '//_cStrjson+='  "estado_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "inscrestadual_dest" : "'+SM0->M0_INSC+'",' //_cStrjson+='  "inscrestadual_dest" : "",'
			_cStrjson+='  "inscrmunicipal_dest" : "",'
			_cStrjson+='  "endereco_entrega" :"'+SM0->M0_ENDENT+'", '//_cStrjson+='  "endereco_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			_cStrjson+='  "cidade_entrega" : "'+SM0->M0_CIDENT+'", ' //_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "bairro_entrega" :"'+SM0->M0_BAIRENT+'", '//_cStrjson+='  "bairro_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cidade_entrega" : "'+SM0->M0_CIDENT+'", '//_cStrjson+='  "estado_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "cep_entrega" : "'+SM0->M0_CEPENT+'", '//_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cnpj_entrega" : "'+SM0->M0_CGC+'", '//_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			_cStrjson+='  "inscrestadual_entrega" : "'+SM0->M0_INSC+'",'
			_cStrjson+='  "baseicms" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALICM), "@E 999999999.99")))+'", '
			_cStrjson+='  "valoricms" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALIPI), "@E 999999999.99")))+'",'
			_cStrjson+='  "basesubstituicao" : "",'
			_cStrjson+='  "valorsubstituicao" : "",'
			_cStrjson+='  "frete" : "",'
			_cStrjson+='  "seguro" : "",'
			_cStrjson+='  "despesasacessorias" : "",'   //
			_cStrjson+='  "ipi" : "",'
			_cStrjson+='  "vlrprodutos" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALBRUT), "@E 999999999.99")))+'",'
			_cStrjson+='  "vlrtotal" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALBRUT), "@E 999999999.99")))+'",'
			_cStrjson+='  "nome_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_NREDUZ')+'",'
			_cStrjson+='  "cnpj_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_CGC')+'",'
			_cStrjson+='  "endereco_transp" : "",'
			_cStrjson+='  "numend_transp" : "",'
			_cStrjson+='  "bairro_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_BAIRRO')+'",'
			_cStrjson+='  "cidade_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_MUN')+'",'
			_cStrjson+='  "estado_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_EST')+'",'
			_cStrjson+='  "cep_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_CEP')+'",'
			_cStrjson+='  "inscrestadual_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_INSEST')+'",'
			_cStrjson+='  "ciffob" : "'+iif(SF1->F1_TPFRETE=="F","2","1")+'",'
			_cStrjson+='  "veiculo" : "",'
			_cStrjson+='  "estado_veiculo" : "",'
			_cStrjson+='  "qtde" : "'+cvaltochar(SF1->F1_VOLUME1)+'",'
			_cStrjson+='  "especie" : "",'
			_cStrjson+='  "marca" : "",'
			_cStrjson+='  "numero" : "",'
			_cStrjson+='  "pesoliquido" :  "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_PLIQUI), "@E 999999999.99")))+'",'
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
			_cStrjson+='  "tiponf" : "Notafiscal",'
			_cStrjson+='  "estado" : "N",'
			_cStrjson+='  "data_coleta" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "hora_coleta" : "'+TIME()+'",'
			_cStrjson+='  "pessoa_entrega" : "'+iif(SF1->F1_TPFRETE=="F","2","1")+' ",'
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
			_cStrjson+='  "chaveacessonfe" : "'+SF1->F1_CHVNFE+'",'
			_cStrjson+='  "sequenciaped" : "",'
			_cStrjson+='  "cnpj_transpredespacho" : "",'
			_cStrjson+='  "inscrestadual_emitente" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_INSCR')+'",'
			_cStrjson+='  "codigo_servicotransp" : "",'
			_cStrjson+='  "codigotipopedido" : "",'
			_cStrjson+='  "embarqueprioritario" : "",'
			_cStrjson+='  "complemento_dest" : "",'
			_cStrjson+='  "roteiro" : "",'
			_cStrjson+='  "seq_entrega" : "",'
			_cStrjson+='  "nome_emit" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_NOME')+'",'
			_cStrjson+='  "fantasia_emit" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_NREDUZ')+'",'
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

			_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, "", aHeadOut, @_cHeadRet ) ) )
			oJson     := tJsonParser():New()
			lRet      := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
			
		
			IF lRet
			_cStrjson :=''
			_cStrjson+=' { '
					_cStrjson+='  "chavelayout" : "int_pedidodet",'
					_cStrjson+='  "list" : [ '
				WHILE SD1->D1_FILIAL==cFilAnt .AND. SD1->D1_DOC==cNF .AND. SD1->D1_SERIE==cSerie .AND. SD1->D1_FORNECE==cFornece .AND. SD1->D1_LOJA==cloja
				// DBSETORDER(1) 
				// DBSELECTAREA('SB1')
				// SB1->(DBSEEK(xFilial('SB1')+SD1->D1_COD))
				
					//_cStrjson :=' { '
					// _cStrjson+=' { '
					// _cStrjson+='  "chavelayout" : "int_pedidodet",'
					// _cStrjson+='  "list" : [ { '
					_cStrjson +=' { '
					_cStrjson+='  "codigointerno" : "'+SD1->D1_DOC+'", '
					_cStrjson+='  "numpedido" : "'+SD1->D1_DOC+"C"+'", '
					_cStrjson+='  "cnpj_depositante" :  "'+SM0->M0_CGC+'", '
					_cStrjson+='  "cnpj_emitente" :  "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_CGC')+'", '
					_cStrjson+='  "serie" : "'+SD1->D1_SERIE+'", '
					_cStrjson+='  "tipo" : "E",  
					_cStrjson+='  "idseq" : "'+SD1->D1_ITEM+'",'
					_cStrjson+='  "codigoindustria" : "'+SD1->D1_COD+'", '
					_cStrjson+='  "descr_prod" :  "'+POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_DESC')+'", '
					_cStrjson+='  "barra" : "'+POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_X_EAN13')+'",'
					_cStrjson+='  "classificacaofiscal" : "",'
					_cStrjson+='  "st" : "",'
					_cStrjson+='  "qtde" : "'+cvaltochar(SD1->D1_QUANT)+'", '
					_cStrjson+='  "vlrunit" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VUNIT), "@E 999999999.99")))+'", '
					_cStrjson+='  "vlrtotal" :"'+cvaltochar(alltrim(TRANSFORM((SD1->D1_TOTAL), "@E 999999999.99")))+'", '
					_cStrjson+='  "aliqicms" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_PICM), "@E 999999999.99")))+'", '
					_cStrjson+='  "aliqipi" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_IPI), "@E 999999999.99")))+'", '
					_cStrjson+='  "ipi" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VALIPI), "@E 999999999.99")))+'", '
					_cStrjson+='  "vlrdesc" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VALDESC), "@E 999999999.99")))+'", '
					_cStrjson+='  "porcdesconto" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_DESC), "@E 999999999.99")))+'", '
					_cStrjson+='  "desconto" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VALDESC), "@E 999999999.99")))+'", '
					_cStrjson+='  "totalliquido" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_TOTAL), "@E 999999999.99")))+'", '
					_cStrjson+='  "tipoproduto" : "'+SUBSTR(POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_TIPO'),1,1)+'",'
					_cStrjson+='  "qtdeatendida" :"'+cvaltochar(SD1->D1_QUANT)+'", '
					_cStrjson+='  "idnotafiscal" :"'+SD1->D1_DOC+'", '
					_cStrjson+='  "numserie" :  "", '
					_cStrjson+='  "tipomaterial" : "", '
					_cStrjson+='  "st_2" : "",'
					_cStrjson+='  "chaveidentificacaoext" : "",'
					_cStrjson+='  "sequenciaped" : "",'
					_cStrjson+='  "codindustria" : "",'
					_cStrjson+='  "descrprod" : "'+POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_DESC')+'",'
					_cStrjson+='  "inscrestadual_emit" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_INSCR')+'",'
					_cStrjson+='  "descrreduzido" : "",'
					_cStrjson+='  "valoricmsdesonerado" : "",'
					_cStrjson+='  "codigoprodanvisa" : "",'
					_cStrjson+='  "precomaximoconsumidor" : "",'
					_cStrjson+='  "motivoisencao" : "",'
					_cStrjson+='  "codigokit" : "",'
					_cStrjson+='  "iditemerp" : "",'
					_cStrjson+='  "obsitemseparacao" : "",'
					_cStrjson+='  "codsetor" : "",'
					_cStrjson+='  "brinde" : "",'
					_cStrjson+='  "mensagem_caixa" : "",'
					_cStrjson+='  "notafiscal" : "'+SD1->D1_DOC+'",'
					_cStrjson+='  "remessa" : "",'
					_cStrjson+='  "serienf" : "'+SD1->D1_SERIE+'",'
					_cStrjson+='  "tipocaixasep" : "",'
					_cStrjson+='  "tipoptl" : "",'
					_cStrjson+='  "volumecaixa" : ""'
					_cStrjson+='} ,' //] }'
								
					// _cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					// oJson      := tJsonParser():New()
					// lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)//
					SD1->(DBSKIP())
				ENDDO
				_cStrjson+=' ] }'
					_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					oJson      := tJsonParser():New()
					lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					
			endif
		ENDIF
	endif

	IF SF1->(DBSEEK(xFilial('SF1')+cDoc+cSerie+cFornece+cloja)) .and. cLocal=="97" .and. cFilAnt=="1201" .and. substr(_cMennota,1,11)<>"MONTA CARGA" //armazem Normal .... alterado de 95 para 97
		IF SD1->(DBSEEK(xFilial('SD1')+cDoc+cSerie+cFornece+cloja))
				DBSETORDER(1) 
				DBSELECTAREA('SA4')
				SA4->(DBSEEK(xFilial('SA4')+SF1->F1_TRANSP))
				DBSETORDER(1) 
				DBSELECTAREA('SB1')
				SB1->(DBSEEK(xFilial('SB1')+SD1->D1_COD))
			// Prepara a chamada do metodo de carga da fila de integração
			cCfop:=POSICIONE('SD1',1,xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,'D1_CF')
			_cStrjson:=' { '
			_cStrjson+='"chavelayout" : "int_pedido", '
			_cStrjson+='"list" : [ { '
			_cStrjson+='  "codigointerno" : "'+SF1->F1_DOC+'", '
			_cStrjson+='  "numpedido" : "'+SF1->F1_DOC+"N"+'", '
			_cStrjson+='  "cnpj_depositante" : "'+SM0->M0_CGC+'", '
			_cStrjson+='  "cnpj_emitente" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_CGC')+'", '
			_cStrjson+='  "sequencia" : "'+SF1->F1_SERIE+'", '
			_cStrjson+='  "tipo" :"E",  
			_cStrjson+='  "descroper" : "'+POSICIONE('SX5',1,xFilial('SX5')+"13"+cCfop,'X5_DESCRI')+'",' ///pegar descricao da CFOP 
			_cStrjson+='  "cfop" : "'+cCfop+'",'// '+POSICIONE('SD1',1,xFilial('SD1')+SF1->F1_DOCS+SF1->F1_SERIE+F1->F1_FORNECE+SF1->F1_LOJA,'D1_CF')+' /// posicione na CFOP de descricao
			_cStrjson+='  "data_emissao" : "'+DTOC(SF1->F1_EMISSAO)+'", ' 
			_cStrjson+='  "pessoa_dest" : "'+SM0->M0_NOMECOM+'", ' //_cStrjson+='  "pessoa_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "codigo_dest" :  "'+SM0->M0_CODFIL+'", '
			_cStrjson+='  "nome_dest" :"'+SM0->M0_NOMECOM+'", '  //_cStrjson+='  "nome_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NOME')+'", '
			_cStrjson+='  "fantasia_dest" : "'+SM0->M0_NOMECOM+'", '//_cStrjson+='  "fantasia_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_NREDUZ')+'", '
			_cStrjson+='  "cnpj_dest" : "'+SM0->M0_CGC+'", '  //_cStrjson+='  "cnpj_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			 _cStrjson+='  "endereco_dest" :"'+SM0->M0_ENDENT+'", ' // _cStrjson+='  "endereco_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			 _cStrjson+='  "numend_dest" : "", '// _cStrjson+='  "numend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '//PRECISA MONTAR REGRA
			_cStrjson+='  "complementoend_dest" : "'+SM0->M0_COMPENT+'", '//_cStrjson+='  "complementoend_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_COMPLEM')+'", '
			_cStrjson+='  "bairro_dest" :"'+SM0->M0_BAIRENT+'", ' //_cStrjson+='  "bairro_dest" :"'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cep_dest" : "'+SM0->M0_CEPENT+'", '//_cStrjson+='  "cep_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cidade_dest" : "'+SM0->M0_CIDENT+'", '//_cStrjson+='  "cidade_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "telefone_dest" : "'+SM0->M0_TEL+'",' //_cStrjson+='  "telefone_dest" : "",'
			_cStrjson+='  "estado_dest" : "'+SM0->M0_ESTENT+'", '//_cStrjson+='  "estado_dest" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "inscrestadual_dest" : "'+SM0->M0_INSC+'",' //_cStrjson+='  "inscrestadual_dest" : "",'
			_cStrjson+='  "inscrmunicipal_dest" : "",'
			_cStrjson+='  "endereco_entrega" :"'+SM0->M0_ENDENT+'", '//_cStrjson+='  "endereco_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_END')+'", '
			_cStrjson+='  "cidade_entrega" : "'+SM0->M0_CIDENT+'", ' //_cStrjson+='  "cidade_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_MUN')+'", '
			_cStrjson+='  "bairro_entrega" :"'+SM0->M0_BAIRENT+'", '//_cStrjson+='  "bairro_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_BAIRRO')+'", '
			_cStrjson+='  "cidade_entrega" : "'+SM0->M0_CIDENT+'", '//_cStrjson+='  "estado_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_EST')+'", '
			_cStrjson+='  "cep_entrega" : "'+SM0->M0_CEPENT+'", '//_cStrjson+='  "cep_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CEP')+'", '
			_cStrjson+='  "cnpj_entrega" : "'+SM0->M0_CGC+'", '//_cStrjson+='  "cnpj_entrega" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE,'A2_CGC')+'", '
			_cStrjson+='  "inscrestadual_entrega" : "'+SM0->M0_INSC+'",'
			_cStrjson+='  "baseicms" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALICM), "@E 999999999.99")))+'", '
			_cStrjson+='  "valoricms" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALIPI), "@E 999999999.99")))+'",'
			_cStrjson+='  "basesubstituicao" : "",'
			_cStrjson+='  "valorsubstituicao" : "",'
			_cStrjson+='  "frete" : "",'
			_cStrjson+='  "seguro" : "",'
			_cStrjson+='  "despesasacessorias" : "",'   //
			_cStrjson+='  "ipi" : "",'
			_cStrjson+='  "vlrprodutos" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALBRUT), "@E 999999999.99")))+'",'
			_cStrjson+='  "vlrtotal" : "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_VALBRUT), "@E 999999999.99")))+'",'
			_cStrjson+='  "nome_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_NREDUZ')+'",'
			_cStrjson+='  "cnpj_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_CGC')+'",'
			_cStrjson+='  "endereco_transp" : "",'
			_cStrjson+='  "numend_transp" : "",'
			_cStrjson+='  "bairro_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_BAIRRO')+'",'
			_cStrjson+='  "cidade_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_MUN')+'",'
			_cStrjson+='  "estado_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_EST')+'",'
			_cStrjson+='  "cep_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_CEP')+'",'
			_cStrjson+='  "inscrestadual_transp" : "'+POSICIONE('SA4',1,xFilial('SA4')+SF1->F1_TRANSP,'A4_INSEST')+'",'
			_cStrjson+='  "ciffob" : "'+iif(SF1->F1_TPFRETE=="F","2","1")+'",'
			_cStrjson+='  "veiculo" : "",'
			_cStrjson+='  "estado_veiculo" : "",'
			_cStrjson+='  "qtde" : "'+cvaltochar(SF1->F1_VOLUME1)+'",'
			_cStrjson+='  "especie" : "",'
			_cStrjson+='  "marca" : "",'
			_cStrjson+='  "numero" : "",'
			_cStrjson+='  "pesoliquido" :  "'+cvaltochar(alltrim(TRANSFORM((SF1->F1_PLIQUI), "@E 999999999.99")))+'",'
			_cStrjson+='  "paginageomapa" : "",'
			_cStrjson+='  "num_itens" : "1",'
			_cStrjson+='  "tiponf" : "Notafiscal",'
			_cStrjson+='  "estado" : "N",'
			_cStrjson+='  "data_coleta" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "hora_coleta" : "'+TIME()+'",'
			_cStrjson+='  "pessoa_entrega" : "'+iif(SF1->F1_TPFRETE=="F","2","1")+' ",'
			_cStrjson+='  "codigo_entrega" : "",'
			_cStrjson+='  "nome_entrega" : "",'
			_cStrjson+='  "fantasia_entrega" : "",'
			_cStrjson+='  "numend_entrega" : "",'
			_cStrjson+='  "complementoend_entrega" : "",'
			_cStrjson+='  "nomerepresentante" : "",'
			_cStrjson+='  "telefone_representante" : "",'
			_cStrjson+='  "cnpj_unidade" : "01125797001198",'
			_cStrjson+='  "fatura" : "",'
			_cStrjson+='  "prioridade" : "",'
			_cStrjson+='  "porcentagemcxfechada" : "",'
			_cStrjson+='  "chaveacessonfe" : "'+SF1->F1_CHVNFE+'",'
			_cStrjson+='  "sequenciaped" : "",'
			_cStrjson+='  "cnpj_transpredespacho" : "",'
			_cStrjson+='  "inscrestadual_emitente" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_INSCR')+'",'
			_cStrjson+='  "codigo_servicotransp" : "",'
			_cStrjson+='  "roteiro" : "",'
			_cStrjson+='  "seq_entrega" : "",'
			_cStrjson+='  "nome_emit" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_NOME')+'",'
			_cStrjson+='  "fantasia_emit" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_NREDUZ')+'",'
			_cStrjson+='  "codservetiqext" : "",'
			_cStrjson+='  "dataplanejamento" :"'+dtoc(dDataBase)+'",'
			_cStrjson+='  "faturamentodoismomentos" : "",'
			_cStrjson+='  "intcubometro" : "",'
			_cStrjson+='  "telefone2" : "",'
			_cStrjson+='  "inscrestadual_dep" : "",'
			_cStrjson+='  "numeroordemproducao" : "",'
			_cStrjson+='  "data_pagto" : "'+dtoc(dDataBase)+'",'
			_cStrjson+='  "codigotiporecebimento" : "",'
			_cStrjson+='  "canal_venda" : "",'
			_cStrjson+='  "janela_fim" : "",'
			_cStrjson+='  "janela_inicio" : ""'
			_cStrjson+='} ] }'

					_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					oJson      := tJsonParser():New()
					lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					
		
			IF lRet
			_cStrjson :=''
			_cStrjson+=' { '
					_cStrjson+='  "chavelayout" : "int_pedidodet",'
					_cStrjson+='  "list" : [ '
				WHILE SD1->D1_FILIAL==cFilAnt .AND. SD1->D1_DOC==cNF .AND. SD1->D1_SERIE==cSerie .AND. SD1->D1_FORNECE==cFornece .AND. SD1->D1_LOJA==cloja
				// DBSETORDER(1) 
				// DBSELECTAREA('SB1')
				// SB1->(DBSEEK(xFilial('SB1')+SD1->D1_COD))
				
					//_cStrjson :=' { '
					// _cStrjson+=' { '
					// _cStrjson+='  "chavelayout" : "int_pedidodet",'
					// _cStrjson+='  "list" : [ { '
					_cStrjson +=' { '
					_cStrjson+='  "codigointerno" : "'+SD1->D1_DOC+'", '
					_cStrjson+='  "numpedido" : "'+SD1->D1_DOC+"N"+'", '
					_cStrjson+='  "cnpj_depositante" :  "'+SM0->M0_CGC+'", '
					_cStrjson+='  "cnpj_emitente" :  "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_CGC')+'", '
					_cStrjson+='  "serie" : "'+SD1->D1_SERIE+'", '
					_cStrjson+='  "tipo" : "E",  
					_cStrjson+='  "idseq" : "'+SD1->D1_ITEM+'",'
					_cStrjson+='  "codigoindustria" : "'+SD1->D1_COD+'", '
					_cStrjson+='  "descr_prod" :  "'+POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_DESC')+'", '
					_cStrjson+='  "barra" : "'+POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_X_EAN13')+'",'
					_cStrjson+='  "classificacaofiscal" : "",'
					_cStrjson+='  "st" : "",'
					_cStrjson+='  "qtde" : "'+cvaltochar(SD1->D1_QUANT)+'", '
					_cStrjson+='  "vlrunit" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VUNIT), "@E 999999999.99")))+'", '
					_cStrjson+='  "vlrtotal" :"'+cvaltochar(alltrim(TRANSFORM((SD1->D1_TOTAL), "@E 999999999.99")))+'", '
					_cStrjson+='  "aliqicms" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_PICM), "@E 999999999.99")))+'", '
					_cStrjson+='  "aliqipi" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_IPI), "@E 999999999.99")))+'", '
					_cStrjson+='  "ipi" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VALIPI), "@E 999999999.99")))+'", '
					_cStrjson+='  "vlrdesc" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VALDESC), "@E 999999999.99")))+'", '
					_cStrjson+='  "porcdesconto" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_DESC), "@E 999999999.99")))+'", '
					_cStrjson+='  "desconto" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_VALDESC), "@E 999999999.99")))+'", '
					_cStrjson+='  "totalliquido" : "'+cvaltochar(alltrim(TRANSFORM((SD1->D1_TOTAL), "@E 999999999.99")))+'", '
					_cStrjson+='  "tipoproduto" : "'+SUBSTR(POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_TIPO'),1,1)+'",'
					_cStrjson+='  "qtdeatendida" :"'+cvaltochar(SD1->D1_QUANT)+'", '
					_cStrjson+='  "idnotafiscal" :"'+SD1->D1_DOC+'", '
					_cStrjson+='  "numserie" :  "", '
					_cStrjson+='  "tipomaterial" : "", '
					_cStrjson+='  "st_2" : "",'
					_cStrjson+='  "chaveidentificacaoext" : "",'
					_cStrjson+='  "sequenciaped" : "",'
					_cStrjson+='  "codindustria" : "",'
					_cStrjson+='  "descrprod" : "'+POSICIONE('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_DESC')+'",'
					_cStrjson+='  "inscrestadual_emit" : "'+POSICIONE('SA2',1,xFilial('SA2')+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_INSCR')+'",'
					_cStrjson+='  "descrreduzido" : "",'
					_cStrjson+='  "valoricmsdesonerado" : "",'
					_cStrjson+='  "codigoprodanvisa" : "",'
					_cStrjson+='  "precomaximoconsumidor" : "",'
					_cStrjson+='  "motivoisencao" : "",'
					_cStrjson+='  "codigokit" : "",'
					_cStrjson+='  "iditemerp" : "",'
					_cStrjson+='  "obsitemseparacao" : "",'
					_cStrjson+='  "codsetor" : "",'
					_cStrjson+='  "brinde" : "",'
					_cStrjson+='  "mensagem_caixa" : "",'
					_cStrjson+='  "notafiscal" : "'+SD1->D1_DOC+'",'
					_cStrjson+='  "remessa" : "",'
					_cStrjson+='  "serienf" : "'+SD1->D1_SERIE+'",'
					_cStrjson+='  "tipocaixasep" : "",'
					_cStrjson+='  "tipoptl" : "",'
					_cStrjson+='  "volumecaixa" : ""'
					_cStrjson+='} ,' //] }'
								
					// _cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					// oJson      := tJsonParser():New()
					// lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					SD1->(DBSKIP())
				ENDDO
				_cStrjson+=' ] }'
					_cPostProd := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cStrjson, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
					oJson      := tJsonParser():New()
					lRet       := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJsonProd, @nRetParser, @oJHM)
					
			endif
		ENDIF
	endif
//RESET ENVIRONMENT
return
