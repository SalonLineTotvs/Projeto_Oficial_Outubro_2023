#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
USER FUNCTION ADR()

Prepare Environment Empresa "02" Filial "1501" Modulo "FAT"   

//U_SLSHIPPING('00106')
u_SLINTELINF('00106')
u_SLINTELCOL('00106')
RESET Environment

RETURN 
        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SLSHIPPING Autor ³ 					   ³ Data ³17/08/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  INTELIPOST - ENVIA DADOS FIRMADOS DO PEDIDO               ³±±
±±³		     ³  NO MOMENTO DA APROVAÇÃO DO PAGAMENTO					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  	                                       		          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SLSHIPPING(_cPedido)
    Local lNumero		:= .F.
	Local lContinua		:= .T.
	Local _cPedido      :=_cPedido
	Local _cUrl 		:='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROC_SHIP_ORDE_ERP_TMS_1/1.0/shipment_order'
	Local _nTimeOut		:=120 
	Local aHeadOut		:={}
	Local _cHeadRet		:=''
	Local _cTabPrc      := SuperGetMV( "SL_TABPRC", Nil, "012" 	)
	Local _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "Oic_integration" 	)
	Local _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "9Krr6rnESDeG@wT3" 	)
	Local _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )
	Local _cNumCotacao  :=_cPedido
	Local _cnumsoma     :=_cPedido

Aadd(aHeadOut,"Content-Type: application/json")   
Aadd(aHeadOut,"Accept: application/json") 				
Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)

DBSELECTAREA('PZU')
DBSETORDER(1)
DBSEEK(xFilial('PZU')+PADR(_cPedido,TAMSX3('PZU_PEDECO')[1]))

DBSELECTAREA('PZV')
DBSETORDER(1)
DBSEEK(xFilial('PZV')+PADR(_cPedido,TAMSX3('PZV_PEDECO')[1]))

DBSELECTAREA('SA1')
DBSETORDER(3)
DBSEEK(xFilial('SA1')+PZU->PZU_CGC)

DBSELECTAREA('SB1')
DBSETORDER(1)
DBSELECTAREA('ACV')
DBSETORDER(5)
DBSELECTAREA('ACU')
DBSETORDER(1)

_aEnder := {}
_aEnder := split(alltrim(SA1->A1_END), ' ' )
_nPosV  := ASCAN(_aEnder,{|x| "," $ alltrim(x)})	
_nPos	:= _nPosV

While lContinua .and. _nPos>0
	_nPos++
	IF _nPos<=len(_aEnder)
		for nCont:=1 to Len(_aEnder[_nPos])
			lNumero:= IF(substring(_aEnder[_nPos],nCont,1) $ '0123456789.',.T.,.F.) 	
		next
		lContinua:= IF(lNumero,.F.,.T.)
	ELSE
		lContinua:=.F.
	ENDIF
ENDDO

_cNumero  := IF(lNumero,_aEnder[_nPos],'S/N')
_cNumeroE := _cNumero

//>>> ENDERECO DE ENTREGA <<<
IF !EMPTY(SA1->A1_ENDENT)
	
	lContinua:= .T.
	lNumero  := .F.
	_aEnder  := {}
	_aEnder  := split(alltrim(SA1->A1_ENDENT), ' ' )
	_nPosV   := ASCAN(_aEnder,{|x| "," $ alltrim(x)})	
	_nPos	 := _nPosV

	While lContinua .and. _nPos>0
		_nPos++
		IF _nPos<=len(_aEnder)
			for nCont:=1 to Len(_aEnder[_nPos])
				lNumero:=IF(substring(_aEnder[_nPos],nCont,1) $ '0123456789.',.T.,.F.) 	
			next
			lContinua:=IF(lNumero,.F.,.T.)
		ELSE
			lContinua:=.F.
		ENDIF
	ENDDO
	_cNumeroE  := IF(lNumero,_aEnder[_nPos],'S/N')
ENDIF

 cText:=' {'
 cText+='   "seller": {'
 cText+='       "country": "Brasil",'
 cText+='       "address": "'+SA1->A1_END+'",'
 cText+='       "city": "'+SA1->A1_MUN+'",'
 cText+='       "additional": "'+SA1->A1_COMPLEM+'",'
 cText+='       "last_name": "'+SA3->A3_NOME+'",'
 cText+='       "state_tax_payer_id": "0",'
 cText+='       "federal_tax_payer_id": "0",'
 cText+='       "zip_code": "'+SA1->A1_CEP+'",'
 cText+='       "notify": {'
 cText+='           "whatsapp": true'
 cText+='       },'
 cText+='       "reference": "",'
 cText+='       "number": "'+_cNumero+'",'
 cText+='       "phone": "'+SA1->A1_TEL+'",'
 cText+='       "cellphone": "'+SA1->A1_TELEX+'",'
 cText+='       "state":  "'+SA1->A1_EST+'",'
 cText+='       "opt_in": true,'
 cText+='       "is_company": false,'
 cText+='       "first_name": "'+SA1->A1_NOME+'",'
 cText+='       "email": "'+SA1->A1_EMAIL+'",'
 cText+='       "quarter": "'+SA1->A1_BAIRRO+'"'
 cText+='   },'
 cText+='   "origin_zip_code": " ",'
 cText+='   "external_order_numbers": {'
 cText+='       "erp": "'+PZU->PZU_NUM+'",'
 cText+='       "marketplace": "",'
 cText+='       "plataforma": "'+_cPedido+'",'
 cText+='       "sales":  "'+_cPedido+'"'
 cText+='   },'
 cText+='   "created": "'+LEFT(dtos(dDataBase),4)+'-'+substring(dtos(dDataBase),5,2)+'-'+right(dtos(dDataBase),2)+'T'+TIME()+'",'
 cText+='   "scheduled": false,'
 cText+='   "order_number": "'+_cnumsoma+'",'
 cText+='   "quote_id": "'+_cNumCotacao+ '",'
 cText+='   "shipment_order_type": "NORMAL",'
 cText+='   "sales_channel": "Linx",'
 cText+='   "customer_shipping_costs": 0,'
 cText+='   "estimated_delivery_date": " ",'
 cText+='   "origin_warehouse_code": "",'
 cText+='   "content_declaration": {'
 cText+='       "content_declaration_total_value": "'+CVALTOCHAR(PZU->PZU_VALOR)+'",'
 cText+='       "content_declaration_number": "",'
 cText+='       "content_declaration_date": "'+LEFT(dtos(dDataBase),4)+'-'+substring(dtos(dDataBase),5,2)+'-'+right(dtos(dDataBase),2)+'"'
 cText+='   },'
 cText+='   "additional_information": {'
 cText+='       "key2": "",'
 cText+='       "key": ""'
 cText+='   },'
 cText+='   "carrier": {'
 cText+='       "driver": {'
 cText+='           "federal_tax_id": "78847892387"'
 cText+='       },'
 cText+='       "vehicle": {'

 cText+='           "licence_plate": "BRT-8982"'

 cText+='       }'

 cText+='   },'

 cText+='   "sales_order_number": "'+_cPedido+'",'
 cText+='   "provider_shipping_costs": "'+CVALTOCHAR(PZU->PZU_FRETE)+'",'
 cText+='   "end_customer": {'
 cText+='       "shipping_reference": "O prédio azul com porta verde",'
 cText+='       "shipping_state": "'+SA1->A1_ESTE+'",'
 cText+='       "shipping_city": "'+SA1->A1_MUNE+'",'
 cText+='       "last_name": "'+SA1->A1_NOME+'",'
 cText+='       "shipping_number":"'+_cNumeroE+'",'
 cText+='       "federal_tax_payer_id": "",'
 cText+='       "notify": {'
 cText+='           "whatsapp": true'
 cText+='       },'
 cText+='       "shipping_quarter": "'+SA1->A1_BAIRROE+'",'
 cText+='       "phone":"'+SA1->A1_TEL+'",'
 cText+='       "cellphone":"'+SA1->A1_TELEX+'",'
 cText+='       "shipping_address": "'+SA1->A1_ENDENT+'",'
 cText+='       "opt_in": true,'
 cText+='       "is_company": false,'
 cText+='       "first_name":  "'+SA1->A1_NOME+'",'
 cText+='       "shipping_country": "Brasil",'
 cText+='       "email":  "'+SA1->A1_EMAIL+'",'
 cText+='       "shipping_additional": "'+SA1->A1_COMPLEM+'",'
 cText+='       "shipping_zip_code":"'+SA1->A1_CEPE+'"'
 cText+='   },'
 cText+='   "delivery_method_id": 2,'
 cText+='   "delivery_method_external_id": "2",'
 cText+='   "shipped_date": " ",'
 cText+='   "shipment_order_volume_array": ['
 cText+='       {'
 cText+='           "length": 0,'
 cText+='           "weight": 0,'
 cText+='           "shipment_order_volume_invoice": {'
 cText+='               "invoice_total_value": "'+CVALTOCHAR(PZU->PZU_VLRPG)+'",'
 cText+='               "invoice_series":  "'+PZU->PZU_SERIE+'",'
 cText+='               "invoice_products_value": "'+CVALTOCHAR(PZU->PZU_VALOR)+'",'
 cText+='               "invoice_cfop": "CFOP da NF",'
 cText+='               "invoice_number": "'+PZU->PZU_DOC+'",'
 cText+='               "invoice_key": "'+PZU->PZU_CHVNFE+'",'
 cText+='               "invoice_date": "'+LEFT(dtos(PZU->PZU_NFEMIS),4)+'-'+substring(dtos(PZU->PZU_NFEMIS),5,2)+'-'+right(dtos(PZU->PZU_NFEMIS),2)+'T'+TIME()+'"'
 cText+='           },' 

 nCont := 0
 _nQtd := 0
 cText1:= ''

 WHILE ALLTRIM(PZV->PZV_PEDECO) == ALLTRIM(_cPedido)
	
	_nQtd+=PZV->PZV_QTDVEN

	DBSEEK(xFilial('SB1')+PZV->PZV_PRODUT)
	DBSEEK(xFilial('ACV')+PZV->PZV_PRODUT)
	DBSEEK(xFilial('ACU')+ACV->ACV_CATEGO)	
	
	IF nCont>0
		cText1+='},'
	ENDIF

	cText1+='               {'
	cText1+='                   "quantity": "'+CVALTOCHAR(PZV->PZV_QTDVEN)+'",'
	//cText+='                   "image_url": "http://foo.bar/fooImg.jpg",'
	cText1+='                   "price": "'+CVALTOCHAR(PZV->PZV_PRCVEN)+'",'
	cText1+='                   "width": "'+CVALTOCHAR(SB5->B5_ECPROFU)+'",'
	cText1+='                   "length": "'+CVALTOCHAR(SB5->B5_ECCOMP)+'",'
	cText1+='                   "weight":"'+CVALTOCHAR(SB1->B1_PESO)+'",'
	cText1+='                   "description": "'+SB5->B5_CEME+'",'
	cText1+='                   "sku": "'+SB5->B5_COD+'",'
	cText1+='                   "category": "'+ACU->ACU_DESC+'",'
	cText1+='                   "height":"'+CVALTOCHAR(SB5->B5_ECLARGU)+'"'
	
	nCont++
	
	PZV->(DBSKIP())
 enddo
 cText+='           "products_quantity":'+CVALTOCHAR(_nQtd)+','
 cText+='           "products": ['
 cText+= cText1

 cText+='               }'
 cText+='           ],'
 cText+='           "volume_type_code": "BOX",'
 cText+='           "name": "volume",'
 cText+='           "width": 0,'
 cText+='           "shipment_order_volume_number": 2,'
 cText+='           "products_nature": "products",'
 cText+='           "height": 0'
 cText+='       }'
 cText+='   ],'
 cText+='   "parent_shipment_order_number": ""'
 cText+=' } '
 
_cPostProd:= HttpPost( _cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
oJson := JsonObject():New()
cError:= oJson:FromJson(_cPostProd)

IF oJson:GetJsonObject('status') == "OK" 
	oJson:= oJson:GetJsonObject('content')    
	cID := cValToChar(oJson:GetJsonObject('quote_id'))
	RECLOCK('PZU')
		PZU->PZU_INTELI := cID
	MSUNLOCK()
	U_SLINTELINF(_cPedido)
endif

Return    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SLINTELINF Autor ³ 					   ³ Data ³17/08/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  ENVIO ITELIPOST - DADOS DA NF				              ³±±
±±³		     ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  	                                       		          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SLINTELINF(_cPedido)
    Local lNumero		:= .F.
	Local lContinua		:= .T.
	Local _cPedido      := _cPedido
	Local _cUrl 		:='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_SHIP_ORDER_SET_INVOICE/1.0/shipment_order/set_invoice'
	Local _nTimeOut		:=120 
	Local aHeadOut		:={}
	Local _cHeadRet		:=''
	Local _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "Oic_integration" 	)
	Local _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "9Krr6rnESDeG@wT3" 	)
	Local _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1501" MODULO "COM" 

Aadd(aHeadOut,"Content-Type: application/json")   
Aadd(aHeadOut,"Accept: application/json") 				
Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)

DBSELECTAREA('SF2')
DBSETORDER(1) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, R_E_C_D_E_L_

DBSELECTAREA('SD2')
DBSETORDER(3) 

DBSELECTAREA('PZU')
DBSETORDER(1)

IF PZU->(DBSEEK(xFilial('PZU')+PADR(_cPedido,TAMSX3('PZU_PEDECO')[1])))
	IF SF2->(DBSEEK(xFilial('SF2')+PADR(PZU->PZU_DOC,TAMSX3('F2_DOC')[1])+PADR(PZU->PZU_SERIE,TAMSX3('F2_SERIE')[1]))) .and. SD2->(DBSEEK(xFilial('SD2')+PADR(PZU->PZU_DOC,TAMSX3('D2_DOC')[1])+PADR(PZU->PZU_SERIE,TAMSX3('D2_SERIE')[1])))
		cText:='{'
		cText+='"order_number": "'+alltrim(PZU->PZU_PEDECO)+'",'
		cText+='"shipment_order_volume_invoice_array": [{'
		cText+='"invoice_total_value": "'+CVALTOCHAR(SF2->F2_VALBRUT)+'",'
		cText+='"invoice_series": "'+SF2->F2_SERIE+'",'
		cText+='"invoice_products_value":"'+CVALTOCHAR(SF2->F2_VALMERC)+'",'
		cText+='"invoice_cfop":"'+SD2->D2_CF+'",'
		cText+='"shipment_order_volume_number":"'+alltrim(PZU->PZU_INTELI)+'",'
		cText+='"invoice_number":"'+SF2->F2_DOC+'",'
		cText+='"invoice_key":"'+SF2->F2_CHVNFE+'",'
		cText+='"invoice_date": "'+LEFT(dtos(dDataBase),4)+'-'+substring(dtos(dDataBase),5,2)+'-'+right(dtos(dDataBase),2)+'T'+TIME()+'"'
		cText+='}]'
		cText+='}'

		_cPostProd:= HttpPost( _cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
		oJson := JsonObject():	New()
		cError:= oJson:FromJson(_cPostProd)

		IF oJson:GetJsonObject('status') == "OK" 
			U_SLINTELCOL(_cPedido)						
		ENDIF
	endif
ENDIF

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SLINTELCOL Autor ³ 					   ³ Data ³17/08/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  ENVIO ITELIPOST - SOLICITA COLETA			              ³±±
±±³		     ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  	                                       		          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SLINTELCOL(_cPedido)
    Local lNumero		:= .F.
	Local lContinua		:= .T.
	Local _cPedido      := _cPedido
	Local _cUrl 		:='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCCE_MULT_SHIPPE/1.0/shipment_order/multi/shipped/with_date'
	Local _nTimeOut		:=120 
	Local aHeadOut		:={}
	Local _cHeadRet		:=''
	Local _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "Oic_integration" 	)
	Local _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "9Krr6rnESDeG@wT3" 	)
	Local _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1501" MODULO "COM" 

		Aadd(aHeadOut,"Content-Type: application/json")   
		Aadd(aHeadOut,"Accept: application/json") 				
		Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)

		DBSELECTAREA('PZU')
		DBSETORDER(1)

		IF PZU->(DBSEEK(xFilial('PZU')+PADR(_cPedido,TAMSX3('PZU_PEDECO')[1])))

			cText:='[ { '
			cText+='"order_number": "'+PZU->PZU_PEDECO+'", '
			cText+='"event_date": "'+LEFT(dtos(dDataBase),4)+'-'+substring(dtos(dDataBase),5,2)+'-'+right(dtos(dDataBase),2)+'T'+TIME()+'"'
			cText+='}]'

			_cPostProd:= HttpPost( _cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
			oJson := JsonObject():	New()
			cError:= oJson:FromJson(_cPostProd)

			IF oJson:GetJsonObject('status') == "OK" 
				RECLOCK('PZU',.F.)
					PZU->PZU_STATUS := '8'
				MSUNLOCK()

				RECLOCK('PZX',.T.)
					PZX->PZX_FILIAL:= xFilial('PZX')
					PZX->PZX_PEDECO:= _cPedido
					PZX->PZX_DATA  := dDatabase
					PZX->PZX_HORA  := time()
					PZX->PZX_STATUS:= '8'
					PZX->PZX_NUMDOC:= PZU->PZU_DOC
					PZX->PZX_SERIE := PZU->PZU_SERIE
					PZX->PZX_TRANSP:= PZU->PZU_TRANSP
				MSUNLOCK()
			ENDIF
		endif

return
	
	
//>>>> SPLIT PARA PEGAR ENDERECO E NUMERO <<<<

static Function split( cString, cDiv )
	Local aRet := {}
	Local nPos := 1
	Local nDiv := len( cDiv )

	While nPos != 0
		nPos := AT( cDiv, cString )
		If nPos > 0
			aadd( aRet, substr( cString, 1, nPos-1 ))
			cString := Substr( cString, nPos+nDiv )
		Else
			aadd( aRet, cString )
		Endif
	EndDo

Return aRet
