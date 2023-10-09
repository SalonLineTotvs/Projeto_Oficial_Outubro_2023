#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FWMVCDEF.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ AxSZY   บ Autor ณ 	          		 บ Data ณ  20/06/23     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  CADASTRO DE MARCAS			                                นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/         
*-----------------*
User Function AxSZY()
*-----------------* 
	Private _aCores := {	{ 'ZY_MSBLQL == "1"'				, 'BR_VERMELHO' },;
							{ 'ZY_MSBLQL <> "1"'				, 'BR_VERDE'    } }
						
	PRIVATE aRotina := { 	{OemToAnsi("Pesquisar") 	,"AxPesqui"  	,00,01	},;
							{OemToAnsi("Visual")		,"AxVisual"		,00,02	},;
							{OemToAnsi("Incluir")		,"AxInclui"		,00,03	},;
							{OemToAnsi("Alterar")		,"AxAltera"		,00,04	},;
							{OemToAnsi("Integrar")  	,"u_XECOMARCAS" ,00,05	},;
							{OemToAnsi("Excluir")  		,"AXDELETA"		,00,06	},;
							{OemToAnsi("Legenda")   	,"u_xSZYLegen" 	,00,01	} }                                              
											
	//Define o cabecalho da tela de atualizacoes 
	PRIVATE cCadastro := OemToAnsi("Cadastro de Marcas")	

	dbSelectArea("SZY")
	SZY->(dbSetOrder(1))
	mBrowse(06,01,22,75,"SZY",,,,,,_aCores)

Return           


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ SLSTATSIN   บ Autor ณ 	 		 		 บ Data ณ  20/06/23     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  DE PARA STATUS						                      นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/         
USER FUNCTION SLSTATSIN()
						
	PRIVATE aRotina := { 	{OemToAnsi("Pesquisar") 	,"AxPesqui"  	,00,01	},;
							{OemToAnsi("Visual")		,"AxVisual"		,00,02	},;
							{OemToAnsi("Incluir")		,"AxInclui"		,00,03	},;
							{OemToAnsi("Alterar")		,"AxAltera"		,00,04	},;			
							{OemToAnsi("Excluir")  		,"AXDELETA"		,00,06	}}
			
											
	//Define o cabecalho da tela de atualizacoes 
	PRIVATE cCadastro := OemToAnsi("Status ERP X Intelipost")	

	dbSelectArea("SZB")
	SZB->(dbSetOrder(1))
	mBrowse(06,01,22,75,"SZB",,,,,,)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xSZYLegen บ Autor ณ 	           		 บ Data ณ  20/06/23     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  							                                นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/         
*----------------------*
User Function xSZYLegen
*----------------------*        
	BrwLegenda(OemToAnsi("Cadastro de Marcas")  ,;
							"LEGENDA", { {"ENABLE"  ,"Habiliado"},;
										{"DISABLE" ,"Bloqueado" }})
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XSZYCOD   บ Autor ณ 	 		 		 บ Data ณ  20/06/23     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  CODIFICACAO AUTOMATICA DE MARCAS                            นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/         
USER FUNCTION XSZYCOD()
	Local cQuery := ''
	Local _cAlias:= '_cAlias'
	Local cCodigo:= '000001'

	IF Select('_cAlias') > 0
		_cAlias->(DbCloseArea())
	ENDIF
	cQuery:= " SELECT MAX(ZY_COD) as Codigo "
	cQuery+= "  FROM "+RetSqlName('SZY')+" SZY " 
	cQuery+= "  WHERE SZY.D_E_L_E_T_ ='' " 
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "_cAlias", .F., .T.)    
	IF _cAlias->(!EOF()) 
		cCodigo:=STRZERO(val(_cAlias->Codigo)+1,6)
	ENDIF

RETURN cCodigo 



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XECOMARCAS บ Autor ณ 	       		 บ Data ณ  20/06/23     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ INTEGRA MARCAS				                                นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/   
User function XECOMARCAS()
	Local cUserId   	:= UsrFullName(RetCodUsr())
	Local aHeadOut      := {}
    Local _nTimeOut     := 120
	Local nAtual        := 0
    Local _cHeadRet     := ''
    Local _cPostProd    := ''
	Local cUrl			:='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCE_MARCA_ERP_B2B/1.0/brands'
	 
	 _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "samuel.nascimento@salonline.com.br" 	)
    _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "SalonLine@30042023" 	)
	_cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )

	Aadd(aHeadOut,"Content-Type: application/json")   
	Aadd(aHeadOut,"Accept: application/json") 				
	Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)
	
	cCodigo:= IF(EMPTY(SZY->ZY_IDLINX),'0',alltrim(SZY->ZY_IDLINX))
	cData  := '/Date('+LEFT(DTOS(dDatabase),4)+'-'+SUBSTRING(DTOS(dDatabase),5,2)+'-'+RIGHT(DTOS(dDatabase),2)+' '+left(Time(),2)+':'+substring(Time(),4,2)+':'+right(Time(),2)+')/'
	cText:='{'
	cText+='"BrandID":"'+cCodigo+'",'
	cText+='"Name": "'+alltrim(SZY->ZY_DESC) +'",'
	cText+='"UrlFriendly": "'+alltrim(SZY->ZY_URLFRIE) +'",'
	cText+='"PageTitle": "'+alltrim(SZY->ZY_PAGETIT) +'",'
	cText+='"MetaDescription": "'+alltrim(SZY->ZY_METADES) +'",'
	cText+='"KeyWords": "'+alltrim(SZY->ZY_KEYWORD) +'",'
	cText+='"IsEnabled": true,'
	cText+='"CreatedDate": "'+cData+'",'
	cText+='"CreatedBy": "'+cUserId+'"'
	cText+='}'
	
	_cPostProd:= HttpPost( cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )	
	oJson := JsonObject():New()
	cError:= oJson:FromJson(SUBSTRING(_cPostProd,2,LEN(_cPostProd)-2))

 	IF oJson:GetJsonObject('IsValid')
		cID   := cValToChar(oJson:GetJsonObject('BrandID'))
		Reclock('SZY',.F.)
			SZY->ZY_IDLINX:=cID
		MSUNLOCK()
		FWAlertSuccess('Integra็ใo realizada com sucesso. ID= "'+cID+'"',"Sucesso")
	else
		oErro := oJson:GetJsonObject('Errors')
		cTexto:= oErro[1]:GetJsonObject('ErrorMessage')
		Alert('Erro na integra็ใo. '+cTexto)
	endif

return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XECOCATEG บ Autor ณ 	       		 บ Data ณ  20/06/23        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  INTEGRA CATEGORIAS    		                                นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User function XECOCATEG()	   	
	Local _lUnico:=.F.

	_lUnico:=if(MsgYesNo("Deseja Integrar a categoria posicionado (SIM)? - Todos (Nใo)?","Integra็ใo Linx"),.T.,.F.)
	
	RptStatus({|| IntCateg(_lUnico)}, "Aguarde...", "Integrando com o Linx...")

Return

STATIC FUNCTION IntCateg(_lUnico)
	Local aHeadOut      := {}
    Local _nTimeOut     := 120
    Local _cHeadRet     := ''
    Local _cPostProd    := ''
	Local cUrl          :='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCESSA_CATEGORI/1.0/categories'
	Local _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "samuel.nascimento@salonline.com.br" 	)
    Local _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "SalonLine@30042023" 	)
	Local _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )
	Local _cAlias		:='_cAlias'

	Aadd(aHeadOut,"Content-Type: application/json")   
	Aadd(aHeadOut,"Accept: application/json") 				
	Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)
	
	DBSELECTAREA('ACU')

	IF Select('_cAlias') > 0
		_cAlias->(DbCloseArea())
	ENDIF
	cQuery:=" SELECT ACU_COD, ACU_XIDLIN,ACU_DESC,ACU_XURL ,ACU_XKEYW ,ACU_XMETA, ACU_XKPAGE ,R_E_C_N_O_ AS RECNOS " 
	cQuery+=" FROM "+ RetSqlName( "ACU" ) + " ACU "
	cQuery+=" WHERE ACU.D_E_L_E_T_=' ' "
	IF _lUnico
		cQuery+=" AND ACU_COD='"+ACU->ACU_COD+"'"
	ENDIF	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "_cAlias", .F., .T.) 
	DBSELECTAREA('_cAlias')
	Count To nTotal
    SetRegua(nTotal)
	
	_cAlias->(Dbgotop())
	
	WHILE _cAlias->(!EOF()) 		
		IncRegua()
		cCodigo:= IF(EMPTY(ACU->ACU_XIDLIN),'0',ACU->ACU_XIDLIN)

		cText:='{'
        cText+='"CatalogStoreID": 0,'
        cText+='"CategoryID":"'+cCodigo+'",'
        cText+='"Name": "'+alltrim(_cAlias->ACU_DESC) +'",'
        cText+='"Description":"'+alltrim(_cAlias->ACU_DESC) +'",'
        cText+='"Url": "'+alltrim(_cAlias->ACU_XURL) +'",'
        cText+='"KeyWords": "'+alltrim(_cAlias->ACU_XKEYW) +'",'
        cText+='"PageTitle":"'+alltrim(_cAlias->ACU_XKPAGE) +'",'
        cText+='"MetaDescription":"'+alltrim(_cAlias->ACU_XMETA) +'",'
        cText+='"IsEnabled": true,'
        cText+='"ParentCategoryID": 0,'
        cText+='"CategoryGroups": [ 0 '
        cText+='],'
        cText+='"IntegrationID": "'+alltrim(_cAlias->ACU_COD) +'"'
    	cText+='}' 

		_cPostProd:= HttpPost( cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
		oJson := JsonObject():New()
		cError:= oJson:FromJson(SUBSTRING(_cPostProd,2,LEN(_cPostProd)-2))

		IF oJson:GetJsonObject('IsValid')
			cID   := cValToChar(oJson:GetJsonObject('CategoryID'))
			ACU->(DBGOTO(_cAlias->RECNOS))					
			Reclock('ACU',.F.)
				ACU->ACU_XIDLIN:=cID
			MSUNLOCK()
			if _lUnico						
				FWAlertSuccess('Integra็ใo realizada com sucesso. ID= "'+cID+'"',"Sucesso")
			endif
		else
			oErro := oJson:GetJsonObject('Errors')
			cTexto:= oErro[1]:GetJsonObject('ErrorMessage')
			if _lUnico
				Alert('Erro na integra็ใo. '+cTexto)
			endif
		endif
	_cAlias->(dbskip())
enddo

return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ FT140BRW บ Autor ณ 	       		 บ Data ณ  20/06/23        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ PONTO DE ENTRADA PARA ADICIONAR ROTINAS NA CATEGORIA         นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
user Function FT140BRW(param_name)
	Local aRotina:={}

	AADD(aRotina, { "Integrar Linx", "u_XECOCATEG"  , 0, 2 })
	
Return aRotina


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XECCLIENTE บ Autor ณ 	       		 บ Data ณ  10/07/23     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  INTEGRA CLIENTES     		                                นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                               บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/   
User function XECCLIENTE()
	Local _lUnico:=.F.

	_lUnico:=if(MsgYesNo("Deseja Integrar o cliente posicionado (SIM)? - Todos (Nใo)?","Integra็ใo Linx"),.T.,.F.)
	
	RptStatus({|| IntCliente(_lUnico)}, "Aguarde...", "Integrando com o Linx...")

Return

Static Function IntCliente(_lUnico)
	Local aHeadOut      := {}
    Local _nTimeOut     := 120
	lOCAL nCont			:= 0
    Local _cHeadRet     := ''
    Local _cPostProd    := ''
	Local _cEndereco    := ''
    Local lNumero		:= .F.
	Local lContinua		:= .T.
	Local lEnd			:= .T.	
	Local _cAlias		:= '_cAlias'
	Local cUrl			:='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCC_CUSTO_ERP_B2B/1.0/customer/company'
	Local cUrlE			:='https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROC_CUST_ADDR_ERP_B2B/1.0/customer/address'
	
	_cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "samuel.nascimento@salonline.com.br" 	)
    _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "SalonLine@30042023" 	)
	_cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )

	Aadd(aHeadOut,"Content-Type: application/json")   
	Aadd(aHeadOut,"Accept: application/json") 				
	Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)

	DBSELECTAREA('SA1')

	IF Select('_cAlias') > 0
		_cAlias->(DbCloseArea())
	ENDIF
	cQuery:=" SELECT A1_COD+A1_LOJA as CODIGO,A1_INSCR,A1_NOME,A1_CGC,A1_END,A1_COMPLEM,A1_BAIRRO,A1_CEP, "
	cQuery+=" A1_MUN,A1_EST,A1_TEL,A1_TELEX,A1_FAX,A1_EMAIL,R_E_C_N_O_ AS RECNOS, " 
	cQuery+=" A1_ENDCOB,A1_BAIRROC,A1_CEPC,A1_MUNC,A1_ESTC,A1_ENDENT,A1_BAIRROE,A1_CEPE,A1_MUNE,A1_ESTE, "
	cQuery+=" A1_XIDLINX,A1_XSENHA,A1_XB2B,A1_XIDEND,A1_XIDENDC,A1_XIDENDE,DA0_XGRUPO "
	cQuery+=" 	FROM "+ RetSqlName( "SA1" ) + " SA1, "+ RetSqlName( "DA0" ) + " DA0 "
	cQuery+=" 	WHERE SA1.A1_XB2B ='2' "
	IF _lUnico
		cQuery+=" AND SA1.A1_COD='"+SA1->A1_COD+"'"
	ENDIF
	cQuery+=" AND SA1.A1_TABELA=DA0.DA0_CODTAB "
	cQuery+=" AND DA0.DA0_XGRUPO<> '' "
	cQuery+=" AND SA1.D_E_L_E_T_=' ' "
	cQuery+=" AND DA0.D_E_L_E_T_=' ' "
	cQuery+=" AND SA1.SA1_FILIAL = '"+xFilial('SA1')+"'" 
	cQuery+=" AND DA0.DA0_FILIAL = '"+xFilial('DA0')+"'" 

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "_cAlias", .F., .T.) 
	DBSELECTAREA('_cAlias')	
	Count To nTotal
    SetRegua(nTotal)
	
	_cAlias->(Dbgotop())
	
	WHILE _cAlias->(!EOF()) 		
		IncRegua()
		
		lContinua  := .T.
		lNumero    := .F.
		_cEndereco := ''
 		_cTab	   := if(alltrim(_cAlias->DA0_XGRUPO)=='36','2','1')
		//36 - PREวO B2B
		//37 - PREวO VD
		//"customerGroupIDs":[1] para VD
 		//"customerGroupIDs":[2] para B2B
		cText:='{'		
		cText+='"CustomerGroupIDs": ['+alltrim(_cTab)+'],'
		cText+='  "Email": "'+alltrim(_cAlias->A1_EMAIL)+'",'
		cText+='  "Password_Check": "'+alltrim(_cAlias->A1_XSENHA)+'",'
		cText+='  "Cnpj": "'+_cAlias->A1_CGC+'",'
		cText+='  "IntegrationID": "'+_cAlias->CODIGO+'",'
		cText+='  "CustomerID":'+IF(EMPTY(_cAlias->A1_XIDLINX),'0',+alltrim(_cAlias->A1_XIDLINX))+','
		cText+='  "WebSiteID": 4,'
		cText+='  "ExtendedProperties": [{'
		cText+='    "Value": "'+_cAlias->A1_INSCR+'",'
		cText+='    "Name": "SiteTaxPayer"'
		cText+='  }],'
		cText+='  "Name": "'+alltrim(_cAlias->A1_NOME)+'",'
		cText+='  "Contact": {'
		cText+='    "Phone2": "'+alltrim(_cAlias->A1_TELEX)+'",'
		cText+='    "Phone": "'+alltrim(_cAlias->A1_TEL)+'",'
		cText+='    "CellPhone": "'+alltrim(_cAlias->A1_TELEX)+'",'
		cText+='    "Fax": "'+alltrim(_cAlias->A1_FAX)+'"'
		cText+='  },'
		cText+='  "TradingName": "'+alltrim(_cAlias->A1_NOME)+'",'
		cText+='  "Password": "'+alltrim(_cAlias->A1_XSENHA)+'"'
		cText+='}'
		
		_cPostProd:= HttpPost( cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
		oJson := JsonObject():New()
		cError:= oJson:FromJson(_cPostProd)

		IF oJson:GetJsonObject('IsValid')
			cIDCli := cValToChar(oJson:GetJsonObject('CustomerID'))
			SA1->(DBGOTO(_cAlias->RECNOS))
			Reclock('SA1',.F.)
				SA1->A1_XIDLINX := cIDCli
			MSUNLOCK()
			lEnd:=.T.		
			if _lUnico
				FWAlertSuccess('Integra็ใo cliente realizada com sucesso. ID= '+cIDCli,"Sucesso")				
			endif
		else
			oErro := oJson:GetJsonObject('Errors')
			cTexto:= oErro[1]:GetJsonObject('ErrorMessage')
			lEnd:=.F.		
		endif

		if lEnd:=.T.	//>>> ENVIA O ENDERECO PRINCIPAL <<<	

			_aEnder := split(alltrim(_cAlias->A1_END), ' ' )
			_nPosV  := ASCAN(_aEnder,{|x| "," $ alltrim(x)})	
			_nPos	:=_nPosV

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
			
			_cNumero  := IF(lNumero,_aEnder[_nPos],'S/N')

			for nCont:=1 to Len(_aEnder)	
				IF nCont<>_nPos .AND. lNumero				
					_cEndereco+=IF(nCont<>_nPosV,_aEnder[nCont],substring(_aEnder[nCont],1,len(_aEnder[nCont])-1))+space(1)
				ELSEIF !lNumero 
					_cEndereco+=_aEnder[nCont]+space(1)
				ENDIF
			NEXT	
			cText:='  {'
			cText+='    "IsDeleted": false,'
			cText+='    "AddressLine": "'+_cEndereco+'",'
			cText+='    "Landmark": "",'
			cText+='    "PostalCode": "'+_cAlias->A1_CEP+'",'
			cText+='    "CustomerID": '+cIDCli+','
			cText+='    "City": "'+alltrim(_cAlias->A1_MUN)+'",'
			cText+='    "Name": "END.PRINCIPAL",'
			cText+='    "Number": "'+_cNumero+'",'
			cText+='    "State": "'+alltrim(_cAlias->A1_EST)+'",'
			cText+='    "Neighbourhood": "'+alltrim(_cAlias->A1_BAIRRO)+'",'
			cText+='    "AddressNotes": " ",'
			cText+='    "ID":'+IF(EMPTY(_cAlias->A1_XIDEND),'0',+alltrim(_cAlias->A1_XIDEND))+','			
			cText+='    "IsMainAddress": true,'
			cText+='    "ContactName": "'+alltrim(_cAlias->A1_NOME)+'"'
			cText+='  }'
			_cPostProd:= HttpPost( cUrlE, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
			oJson := JsonObject():New()
			cError:= oJson:FromJson(_cPostProd)

			IF oJson:GetJsonObject('IsValid')
				cID := cValToChar(oJson:GetJsonObject('AddressID'))
				SA1->(DBGOTO(_cAlias->RECNOS))
				Reclock('SA1',.F.)
					SA1->A1_XIDEND := cID
				MSUNLOCK()
				if _lUnico
					FWAlertSuccess('Integra็ใo Endere็o Principal realizada com sucesso. ID= '+cID,"Sucesso")				
				endif
			else
				oErro := oJson:GetJsonObject('Errors')
				cTexto:= oErro[1]:GetJsonObject('ErrorMessage')
			endif
			
			//>>> ENDERECO DE ENTREGA <<<
			IF !EMPTY(_cAlias->A1_ENDENT)
				
				lContinua := .T.
				lNumero   := .F.
				_cEndereco:= ''

				_aEnder:={}
				_aEnder := split(alltrim(_cAlias->A1_ENDENT), ' ' )
				_nPosV  := ASCAN(_aEnder,{|x| "," $ alltrim(x)})	
				_nPos	:=_nPosV

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
				
				_cNumero  := IF(lNumero,_aEnder[_nPos],'S/N')

				for nCont:=1 to Len(_aEnder)	
					IF nCont<>_nPos .AND. lNumero				
						_cEndereco+=IF(nCont<>_nPosV,_aEnder[nCont],substring(_aEnder[nCont],1,len(_aEnder[nCont])-1))+space(1)
					ELSEIF !lNumero 
						_cEndereco+=_aEnder[nCont]+space(1)
					ENDIF
				NEXT

				cText:='  {'
				cText+='    "IsDeleted": false,'
				cText+='    "AddressLine": "'+_cEndereco+'",'
				cText+='    "Landmark": "",'
				cText+='    "PostalCode": "'+_cAlias->A1_CEPE+'",'
				cText+='    "CustomerID": '+cIDCli+','
				cText+='    "City": "'+alltrim(_cAlias->A1_MUNE)+'",'
				cText+='    "Name": "END.ENTREGA",'
				cText+='    "Number": "'+_cNumero+'",'
				cText+='    "State": "'+alltrim(_cAlias->A1_ESTE)+'",'
				cText+='    "Neighbourhood": "'+alltrim(_cAlias->A1_BAIRROE)+'",'
				cText+='    "AddressNotes": " ",'
				cText+='    "ID":'+IF(EMPTY(_cAlias->A1_XIDENDE),'0',+alltrim(_cAlias->A1_XIDENDE))+','
				cText+='    "IsMainAddress": false,'
				cText+='    "ContactName": "'+alltrim(_cAlias->A1_NOME)+'"'
				cText+='  }'
				_cPostProd:= HttpPost( cUrlE, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
				oJson := JsonObject():New()
				cError:= oJson:FromJson(_cPostProd)

				IF oJson:GetJsonObject('IsValid')
					cID := cValToChar(oJson:GetJsonObject('AddressID'))
					SA1->(DBGOTO(_cAlias->RECNOS))
					Reclock('SA1',.F.)
						SA1->A1_XIDENDE := cID
					MSUNLOCK()
					if _lUnico
						FWAlertSuccess('Integra็ใo Endere็o de Entrega realizada com sucesso. ID= '+cID,"Sucesso")				
					endif
				else
					oErro := oJson:GetJsonObject('Errors')
					cTexto:= oErro[1]:GetJsonObject('ErrorMessage')
				endif
			ENDIF
			
			//>>> ENDERECO DE COBRANวA <<<
			IF !EMPTY(_cAlias->A1_ENDCOB)

				lContinua := .T.
				lNumero   := .F.
				_cEndereco:= ''
				
				_aEnder:={}
				_aEnder := split(alltrim(_cAlias->A1_ENDCOB), ' ' )
				_nPosV  := ASCAN(_aEnder,{|x| "," $ alltrim(x)})	
				_nPos	:=_nPosV
				
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
				
				_cNumero  := IF(lNumero,_aEnder[_nPos],'S/N')

				for nCont:=1 to Len(_aEnder)	
					IF nCont<>_nPos .AND. lNumero				
						_cEndereco+=IF(nCont<>_nPosV,_aEnder[nCont],substring(_aEnder[nCont],1,len(_aEnder[nCont])-1))+space(1)
					ELSEIF !lNumero 
						_cEndereco+=_aEnder[nCont]+space(1)
					ENDIF
				NEXT
				cText:='  {'
				cText+='    "IsDeleted": false,'
				cText+='    "AddressLine": "'+_cEndereco+'",'
				cText+='    "Landmark": "",'
				cText+='    "PostalCode": "'+_cAlias->A1_CEPC+'",'
				cText+='    "CustomerID": '+cIDCli+','
				cText+='    "City": "'+alltrim(_cAlias->A1_MUNC)+'",'
				cText+='    "Name": "END.COBRANCA",'
				cText+='    "Number": "'+_cNumero+'",'
				cText+='    "State": "'+alltrim(_cAlias->A1_ESTC)+'",'
				cText+='    "Neighbourhood": "'+alltrim(_cAlias->A1_BAIRROC)+'",'
				cText+='    "AddressNotes": " ",'
				cText+='    "ID":'+IF(EMPTY(_cAlias->A1_XIDENDC),'0',+alltrim(_cAlias->A1_XIDENDC))+','
				cText+='    "IsMainAddress": false,'
				cText+='    "ContactName": "'+alltrim(_cAlias->A1_NOME)+'"'
				cText+='  }'
				_cPostProd:= HttpPost( cUrlE, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )		
				oJson := JsonObject():New()
				cError:= oJson:FromJson(_cPostProd)

				IF oJson:GetJsonObject('IsValid')
					cID := cValToChar(oJson:GetJsonObject('AddressID'))
					SA1->(DBGOTO(_cAlias->RECNOS))
					Reclock('SA1',.F.)
						SA1->A1_XIDENDC := cID
					MSUNLOCK()	
					if _lUnico
						FWAlertSuccess('Integra็ใo Endere็o de Cobran็a realizada com sucesso. ID= '+cID,"Sucesso")				
					endif				
				else
					oErro := oJson:GetJsonObject('Errors')
					cTexto:= oErro[1]:GetJsonObject('ErrorMessage')		
				endif

			ENDIF
		ENDIF		
		_cAlias->(DBSKIP()) 
	ENDDO

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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ CRM980MDEFบ Autor ณ 	       		 บ Data ณ  20/06/23         บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ PONTO DE ENTRADA PARA INCLUIR BOTAO DE INTEGRACAO CLIENTES	นฑฑ
																			นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                               บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
user function CRM980MDEF()
Local aRotina := {}
//----------------------------------------------------------------------------------------------------------
// [n][1] - Nome da Funcionalidade
// [n][2] - Fun็ใo de Usuแrio
// [n][3] - Opera็ใo (1-Pesquisa; 2-Visualiza็ใo; 3-Inclusใo; 4-Altera็ใo; 5-Exclusใo)
// [n][4] - Acesso relacionado a rotina, se esta posi็ใo nใo for informada nenhum acesso serแ validado
//----------------------------------------------------------------------------------------------------------
aAdd(aRotina,{"Integra็ใo Linx","u_XECCLIENTE()",MODEL_OPERATION_VIEW,7})
Return( aRotina )


return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ SLVALPAI บ Autor ณ 	       		 บ Data ณ  20/06/23         บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ VERIFICA CODIGO X B1_COD E A EXISTENCIA DE DUPLICIDADE 	 	นฑฑ
				FUNCAO DEVE SER COLOCADA NO VALID USER SX3  				นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                               บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

USER FUNCTION SLVALPAI()
	Local lRet		:=.T.
	Local _cAliasQry:= "_cAliasQry"

	//>>>VERIFICA SE ษ O MESMO CODIGO DE PRODUTO<<<
	If Select( _cAliasQry ) # 0
		(_cAliasQry)->( DbCloseArea() )
	EndIf
	cQuery:=" select B1_COD FROM  " + RetSqlName( "SB1" ) + " SB1 "
	cQuery+=" WHERE B1_COD ='"+M->B5_XCODPAI+"' "
	cQuery+=" AND D_E_L_E_T_=' ' "
	dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), _cAliasQry, .F., .T. )

	dbSelectArea( _cAliasQry )
	(_cAliasQry)->( DbGoTop() )

	IF (_cAliasQry)->(!Eof())
		lRet:=.F.
		M->B5_XCODPAI:=' '
		Alert('C๓digo Pai jแ cadastrado no SKU '+_cAliasQry->B1_COD+'. Selecionar outro nome!')
	ENDIF
	
	//>>>VERIFICA SE Jม EXISTE O CODIGO PAI CADASTRADO EM OUTRO PRODUTO<<<
	If Select( _cAliasQry ) # 0
		(_cAliasQry)->( DbCloseArea() )
	EndIf
	cQuery:=" select B5_COD,B5_XCODPAI FROM  " + RetSqlName( "SB5" ) + " SB5 "
	cQuery+=" WHERE B5_XCODPAI='"+M->B5_XCODPAI+"'"
	cQuery+=" AND D_E_L_E_T_=' ' "
	
	dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), _cAliasQry, .F., .T. )
	dbSelectArea( _cAliasQry )

	(_cAliasQry)->( DbGoTop() )
	IF (_cAliasQry)->(!Eof())
		lRet:=.F.
		M->B5_XCODPAI:=' '
		Alert('C๓digo Pai jแ cadastrado no c๓digo pai do SKU '+_cAliasQry->B5_COD+'. Selecionar outro nome!')
	ENDIF

	//>>>VERIFICA SE O PRODUTO Jม TEM CODIGO PAI CADASTRADO E NรO PERMITE A MUDANวA<<<
	if !EMPTY(SB5->B5_XCODPAI) .and. M->B5_XCODPAI<>SB5->B5_XCODPAI
		M->B5_XCODPAI:=SB5->B5_XCODPAI
		lRet:=.F.
	ENDIF

RETURN  lRet
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ EspNome บ Autor ณ 	       		 บ Data ณ  20/06/23     	บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ MODULO ECOMMERCE				                                นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                               บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function Esp1Nome()

Return( OemToAnsi( "E-Commerce" ) ) //Neste caso Retornei uma Descri็ใo para o M๓dulo.
 