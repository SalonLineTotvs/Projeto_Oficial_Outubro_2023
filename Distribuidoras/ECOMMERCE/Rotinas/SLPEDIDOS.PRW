#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

User Function SLINTPED()

U_SLPEDIDOS(.F.)

RETURN

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ SLPEDIDOS º Autor ³                              º Data ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao ³ Faz o download dos pedidos da fila de integração do e-commerce da    º±±
±±º           ³ Linx para as tabelas PZU e PZV (cabecalho e itens pedidos e-commerce º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³                        										      	 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SLPEDIDOS( lSchedule )

    Local _cHeadRet     := ''
    Local oJson         := ''                               
    Local oJson2        := ''                               
    Local oJson4        := ''                               
    Local oJson5        := ''
    Local oJHM 		    := .F.
    Local oJHM2		    := .F.
    Local oJHM4		    := .F.
    Local oJHM5		    := .F.
    Local _cPostPed     := ''
    Local _cPostStatus  := ''
    Local nRetParser    := 0                          
    Local nRetParser2   := 0                          
    Local nRetParser4   := 0   
    Local nRetParser5   := 0                          
    Local _nTimeOut     := 120
    Local lRet 		    := .F.            
    Local aJsonPed      := {}    
    Local aHeadOut      := {}  
    Local _aHeadOut     := {}                    
    Local aJsonPInfo    := {}     
    Local aJsonOut      := {}
    Local aJsonStatus   := {}
    Local _cXML         := ""
    Local _nX           := 0
    Local _nY           := 0
    Local _nZ           := 0
    Local _nPos         := 0
    Local _nPosValid    := 0
    Local _nPosResult   := 0
    Local _nPosEntity   := 0
    Local _nPosEvType   := 0
    Local _nPosItemID   := 0
    Local _nPosEntNam   := 0
    Local _nPosOperId   := 0
    Local _aPedidos     := {}
    Local _aClientes    := {}
    Local _aAuxData     := {}
    Local _aSegPagto    := {}       // Var para tratamento da 2º forma de pagamento 
    Local _cAuxData     := ""
    Local _cAuxData2    := ""
    Local _cPedido      := ""
    Local _cTypeEvent   := ""
    Local _cStatus      := ""
    Local _cEntName     := ""
    Local _cItemID      := ""
    Local _cOperID      := ""
    Local _lxSA1        := .F.
    Local _lxPZX        := .F.
    Local _dDtEntreg    := CTOD("")
    Local _cHrIni	    := ""
    Local _cPatch	    := ""
    Local _cDtRef       := ""
    Local _cProduto     := ""
    Local _cCodKit      := ""
    Local _cEntrega		:= ""
    Local _cEncomen		:= ""
    Local _cTabPreco	:= ""
    Local _cFilPreco    := ""
    Local _nQtdVen	    := 0
    Local _nPrcVen	    := 0
    Local _nValIte	    := 0
    Local _aSaldoSB2	:= {}
    Local _nSaldoCD	    := 0
    Local _cXSugVen	    := ""
    Local _nValTab      := 0
    Local _nDescKT	    := 0
    Local _nDesFin      := 0
    Local _nDesProd     := 0 
    Local _nQtdCabec    := 0 
    Local _nValCupom    := 0
    Local _cStatusPed   := ""
    Local _aInfoCli     := {}
    Local _nValFrete    := 0
    Local _lMarketPlace := .T.
    Local _cNatEComm    := ""
    Local _cNatMarketP  := ""
    Local _nValTot      := 0
    Local _cUserEcom	:= ''
    Local _cPassEcom	:= ''
    Private cVendEco    := ""
    Private _cAutentic	:= ''
    DEFAULT _lSched       := .T.
    

    // Prepara o ambiente caso seja execução por Schedule
    If _lSched
        Prepare Environment Empresa "02" Filial "1501" Modulo "FAT"
    EndIf

    _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "Oic_integration" 	)
    _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "9Krr6rnESDeG@wT3" 	)
    _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )

    _cHrIni	 := StrTran( Time(), ":", "" )
    _cPatch	 := "\Ecommerce\Integra_Pedidos_eCommece_" + DTOS( dDatabase ) + "-" + _cHrIni + ".log"
    _cDtRef  := DTOC( dDatabase )   

    // inicializa variaveis dos parametros SX6
    _cEntrega	:= SuperGetMV( "FS_ENTREGA"	, Nil, ""       )   // Codigo do Tipo de Venda Entrega
    _cEncomen	:= SuperGetMV( "FS_ENCOMEN"	, .F., ""       )   // Codigo do Tipo de Venda Encomenda
    _cTabPreco	:= SuperGetMV( "SL_TABPRC", Nil, "012"   	)// tabela de preco e-commerce

    _cNatEComm	:= SuperGetMv( "SL_NATECOM" , Nil, "1001A")   // Natureza para pedidos E-Commerce
    _cNatMarketP:= SuperGetMv( "SL_NATMPLC" , Nil, "1001A")   // Natureza para pedidos E-Commerce MarketPlace

    _cFilPreco  := xFilial("DA1")

    Gravalog( _cPatch,  time()+" - Data: " + _cDtRef )
    Gravalog( _cPatch,  time()+"" )

    Gravalog( _cPatch,  time()+" - Início do processamento de integracao... " )
    Gravalog( _cPatch,  time()+"============================================" )
    Gravalog( _cPatch,  time()+"" )

    // Prepara a chamada do metodo de carga da fila de integração
    _cXML :='{'
    _cXML +='    "QueueID": null,'
    _cXML +='    "QueueAlias": "erp-queue",'
    _cXML +='    "LockItems": false,'
    _cXML +='    "LockSpan": null,'
    _cXML +='    "Attempts": 10,'
    _cXML +='    "Page": {'
    _cXML +='            "PageIndex": 0,'
    _cXML +='            "PageSize": 200'
    _cXML +='    },'
    _cXML +='    "Where": "",'
    _cXML +='    "WhereMetadata": "",'
    _cXML +='    "OrderBy": ""'
    _cXML +='}'

    _cUrl:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_SEARCH_QUEUE_ITEMS/1.0/SearchQueueItems"
    Aadd(aHeadOut,"Content-Type: application/json")   
    Aadd(aHeadOut,"Accept: application/json") 				
    Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)

    Aadd(_aHeadOut,"Accept: application/json") 				
    Aadd(_aHeadOut,"Authorization: Basic " + _cAutentic)

    Gravalog( _cPatch,  time()+" - >>> Chamada do metodo SearchQueueItems para leitura dos pedidos da fila de integração... " )
    Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
    Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
    Gravalog( _cPatch,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
    Gravalog( _cPatch,  time()+" -     aHeadOut : [3] - Authorization: Basic "  + _cAutentic)
    Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
    Gravalog( _cPatch,  time()+"" )

    _cPostPed := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) )

    Gravalog( _cPatch,  time()+" - <<< Retorno do metodo SearchQueueItems para leitura dos pedidos da fila de integração... " )
    Gravalog( _cPatch,  time()+" -     " + _cPostPed     )

    oJson    := tJsonParser():New()
    lRet     := oJson:Json_Hash(_cPostPed, LEN(_cPostPed), @aJsonPed, @nRetParser, @oJHM)
    // aJsonPed - Array contendo os pedidos e-commerce disponiveis na fila de integracao da Linx

    cVendEco := SuperGetMV( "SL_VNDECOM", Nil, "000223" )

    IF  lRet .AND. Len( aJsonPed ) > 0

        For _nX := 1 to Len( aJsonPed )

            _nPosValid := aScan( aJsonPed[ _nX ][2], {|x| x[1] == 'IsValid'} )    // Busca a tag 'IsValid' como true para continuar o processo

            IF  _nPosValid > 0 
                IF  aJsonPed[ _nX ][2][ _nPosValid ][2]   
                    _nPosResult := aScan( aJsonPed[ _nX ][2], {|x| x[1] == 'Result'} )

                    IF  _nPosResult > 0 
                        IF  Len( aJsonPed[ _nX ][2][ _nPosResult ][2] ) > 0 
                            For _nY := 1 to Len( aJsonPed[ _nX ][2][ _nPosResult ][2] )

                                _nPosEntity := aScan( aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2], {|x| x[1] == "EntityKeyValue"} )
                                _cPedido    := aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2][ _nPosEntity ][2]

                                _nPosEntNam := aScan( aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2], {|x| x[1] == "EntityKeyName"} )
                                _cEntName   := aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2][ _nPosEntNam ][2]

                                _nPosEvType := aScan( aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2], {|x| x[1] == "DomainEventTypeName"} )
                                _cTypeEvent := aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2][ _nPosEvType ][2]

                                _nPosItemID := aScan( aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2], {|x| x[1] == "QueueItemID"} )
                                _cItemID    := aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2][ _nPosItemID ][2]

                                _nPosOperId := aScan( aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2], {|x| x[1] == "Operation"} )
                                _cOperID    := aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2][ _nPosOperId ][2]

                                // Caso o e-commerce retorne conteudo Nil, trata como Empty() para não dar erro
                                _cTypeEvent := Iif( ValType( _cTypeEvent ) == "U", "", _cTypeEvent )
                                _cStatus    := ""

                                // Data e hora da aprovacao do pedido 
                                _cAuxData := aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2][aScan( aJsonPed[ _nX ][2][ _nPosResult ][2][ _nY ][2], {|x| x[1] == "CreatedDate"} )][2]
                                _cAuxData := Iif( ValType(_cAuxData) == "U", "", _cAuxData )
                                _cAuxData := Iif( Subst(_cAuxData,1,6) == "/Date(", Substr(_cAuxData, At("(", _cAuxData)+1, ( At("-", _cAuxData) - At("(", _cAuxData) ) -1  ) , _cAuxData  )

                                IF  ValType( _cAuxData ) <> "U" .And. !Empty(_cAuxData)
                                    _aAuxData := U_MsToDate( _cAuxData )           //FwDateTimeToLocal("1581537675377-0300", 0)
                                Else 
                                    _aAuxData := {}
                                EndIf 

                                Do  Case 
                                    Case "OrderPaid" $ _cTypeEvent
                                        _cStatus    := "Pago"
                                    
                                    OtherWise 
                                        _cStatus    := "Aguardando Pagto"
                                EndCase

                                // Item da fila de integracao corresponde a Pedido 
                                IF  _cEntName == "OrderNumber"  

                                    _nPos := aScan( _aPedidos, {|x| x[1] + x[6] == _cPedido + _cItemID } )

                                    If  _nPos == 0
                                        aAdd( _aPedidos, { _cPedido, {_cStatus}, {}, Iif( Len(_aAuxData) > 0, _aAuxData[1], CTOD("") ), Iif( Len(_aAuxData) > 0, _aAuxData[2], "00:00:00" ), _cItemID, _cOperID } )
                                    else
                                        aAdd( _aPedidos[_nPos][2], _cStatus )
                                    EndIf 
                                EndIf 

                                // Item da fila de integracao corresponde a cliente 
                                IF  _cEntName == "CustomerID"     
                                    _cStatus    := "Integração Cliente"
                                    _nPos       := aScan( _aClientes, {|x| x[1] + x[6] == _cPedido + _cItemID } )

                                    If  _nPos == 0
                                        aAdd( _aClientes, { _cPedido, {_cStatus}, {}, Iif( Len(_aAuxData) > 0, _aAuxData[1], CTOD("") ), Iif( Len(_aAuxData) > 0, _aAuxData[2], "00:00:00" ), _cItemID, _cOperID } )
                                    else
                                        aAdd( _aClientes[_nPos][2], _cStatus )
                                    EndIf 
                                EndIf 
                            Next _nY 
                        EndIf
                    EndIf
                EndIf
            EndIf 
        Next _nX
    Else 
        Gravalog( _cPatch,  time()+" - Metodo SearchQueueItems para leitura dos pedidos da fila de integração retornou erro e não foi concluído !!!" )
        Gravalog( _cPatch,  time()+" - " )
    EndIf

    // Se o array com os pedidos retornados pelo metodo SearchQueueItems estiver populado
    IF  Len( _aPedidos ) > 0

        // Ordena tabelas necessarias para este processo antes de entrar no laco
        DbSelectArea("SA1")
            SA1->( DbSetOrder(3) )  // A1_FILIAL  + A1_CGC

        DbSelectArea("CC2")
            CC2->( DbSetOrder(4) )  // CC2_FILIAL + CC2_EST + CC2_MUN

        DbSelectArea("SB1")
            SB1->( DbSetOrder(1) )  // B1_FILIAL  + B1_COD 

        DbSelectArea("MEU")
            MEU->( DbSetorder(1) )	//MEU_FILIAL + MEU_CODIGO

        DbSelectArea("MEV")
            SU1->( DbSetOrder(1) )  // MEV_FILIAL+MEV_CODKIT+ MEV_PRODUT 

        DbSelectArea("DA1")
            DA1->( DbSetOrder(1) )  // DA1_FILIAL + DA1_CODTAB + DA1_CODPRO

        DbSelectArea("PZU")
            PZU->( DbSetOrder(1) )  // PZU_FILIAL + PZU_PEDECO 
    
        DbSelectArea("PZV")
            PZV->( DbSetOrder(1) )  // PZV_FILIAL+PZV_PEDECO+PZV_PRODUT+PZV_ITEM                                                                                                                       

        DbSelectArea("PZX")
            PZX->( DbSetOrder(1) )  // PZX_FILIAL + PZX_PEDECO + DTOS( PZX_DATA ) + PZX_HORA  

        Gravalog( _cPatch,  time()+" - Qtd. de pedidos a serem integrados: " + Alltrim( Str( Len( _aPedidos ) ) ) )
        Gravalog( _cPatch,  time()+" " )

        // Processa os pedidos e-commerce identificados
        For _nX := 1 to Len( _aPedidos )
            
            // Inicializa a variavel para cada pedido
            _lMarketPlace := .T.
            _nValTot      := 0

            Gravalog( _cPatch,  time()+" -     >>> Integração do Pedido : [" + _aPedidos[_nX][1] + "]"     )
            Gravalog( _cPatch,  time()+"" )

            // Limpa array com as informacoes do web service para a nova chamada
            aJsonPInfo  := {}

            // Numero do pedido a ser consultado
            _cXML       :='ordernumber='+_aPedidos[_nX][1] 

            // URL do servico de consulta de pedidos pelo numero
            _cUrl       := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_PROCE_PEDID_B2B_ERP/1.0/order"

            Gravalog( _cPatch,  time()+" - >>> Chamada do metodo GetOrderByNumber para leitura dos detalhes de cada pedido integrado... " )
            Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
            Gravalog( _cPatch,  time()+" -     _aHeadOut : [1] - Accept: application/json"       )
            Gravalog( _cPatch,  time()+" -     _aHeadOut : [2] - Authorization: Basic " + _cAutentic )
            Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
            Gravalog( _cPatch,  time()+"" )

            // Retorno do JSON do servico 
            
            _cPostPed   := NoAcento( DeCodeUtf8(HttpsPost( _cUrl,"","","",_cXML, "", _nTimeOut, _aHeadOut, @_cHeadRet )))
            //HTTPSPost(  _cUrl, '', '', '', '[ cGETParms ]', [ cPOSTParms ], [ nTimeOut ], [ aHeadStr ], [ @cHeaderRet ], [ lClient ] )

            Gravalog( _cPatch,  time()+" - <<< Retorno do metodo GetOrderByNumber leitura dos detalhes de cada pedido integrado... " )
            Gravalog( _cPatch,  time()+" -     " + _cPostPed     )

            // Criacao do objeto JSON para manipulacao das informacoes atraves do array aJsonPInfo
            oJson2      := tJsonParser():New()
            lRet        := oJson2:Json_Hash(_cPostPed, LEN(_cPostPed), @aJsonPInfo, @nRetParser2, @oJHM2)

            If ! lRet
                Loop
            EndIf

            // Inicio da leitura e gravação das informacoes na PZU e PZV

            aAdd( _aPedidos[_nX][3], {"PZU", {}}  )
            aAdd( _aPedidos[_nX][3], {"PZV", {}}  )

            // PZU_PEDECO
            aAdd( _aPedidos[_nX][3][1][2], {"PZU_PEDECO","C", _aPedidos[_nX][1]} )

            // PZU_DATA
            _cAuxData := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "CreatedDate"})][2]
            _cAuxData := Iif( ValType(_cAuxData) == "U", "", _cAuxData )
            _cAuxData := Iif( Subst(_cAuxData,1,6) == "/Date(", Substr(_cAuxData, At("(", _cAuxData)+1, ( At("-", _cAuxData) - At("(", _cAuxData) ) -1  ) , _cAuxData  )

            IF  ValType( _cAuxData ) <> "U" .And. !Empty( _cAuxData )
                _aAuxData := U_MsToDate( _cAuxData )           //FwDateTimeToLocal("1581537675377-0300", 0)
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_DATA"  ,"D", _aAuxData[1] } )
            Else 
                _aAuxData := {}
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_DATA"  ,"D", "" } )
            EndIf 

            // Verifica se o pedido é 'Store' (Linx) ou MarketPlace
            _cAuxData := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "MarketPlaceBrand"})][2]
            _cAuxData := Iif( ValType(_cAuxData) == "U", "", _cAuxData )

            If  Alltrim( _cAuxData ) == "Store" .Or. Alltrim( _cAuxData ) == "0" .Or. Alltrim( _cAuxData ) == ""
                _lMarketPlace := .F.
            EndIf 

            If  _lMarketPlace

                // Tratamento do nome do canal a ser gravado 
                Do  Case 
                    Case Upper( Alltrim( _cAuxData ) ) == "MERCADOLIVRE"
                        _cAuxData := "MERCADO LIVRE"

                    Case Upper( Alltrim( _cAuxData ) ) == "MAGAZINELUIZA"
                        _cAuxData := "MAGAZINE LUIZA"

                    Case Upper( Alltrim( _cAuxData ) ) == "LOJASAMERICANAS"
                        _cAuxData := "LOJAS AMERICANAS"
                EndCase

                // PZU_ORIGEM
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_ORIGEM"    ,"C", Upper( Alltrim( _cAuxData ) ) } )

                // PZU_PEDMKP
                _aAuxData := {}
                _cAuxData := ""

                _aAuxData := aClone( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == 'ExternalInfo'})+1][2] )
                _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData ) 

                _cAuxData := Iif( Len(_aAuxData) > 0, _aAuxData[ aScan( _aAuxData, {|x| x[1] == 'IntegrationOrderID'}) ][2], "" )

                aAdd( _aPedidos[_nX][3][1][2], {"PZU_PEDMKP"    ,"C", Alltrim( Substr( _cAuxData, At("-",_cAuxData)+1, Len(_cAuxData) ) ) } )
            Else 
                // PZU_ORIGEM
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_ORIGEM"    ,"C", "LINX E-COMMERCE" } )

                // PZU_PEDMKP
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_PEDMKP"    ,"C", "" } )
            EndIf

            // PZU_STATUS
            _aAuxData   := {}
            _cAuxData   := ""
            _cStatusPed := ""

            _cAuxData   := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "OrderStatusID"})][2]
            _cAuxData   := Iif( ValType(_cAuxData) == "U", 0, _cAuxData )
            _cAuxData   := Iif( _cAuxData == 0, "", Alltrim( Str(_cAuxData) ) )
            aJsonStatus := {}

            IF ! Empty( _cAuxData )

                // Prepara a chamada do metodo de carga da fila de integração
                ////_cXML := 'status='+_cAuxData
                _cXML := _cAuxData

                _cUrl:= "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_GET_ORDE_STAT_ERP_B2B/1.0/GetOrderStatus"
                //1_cUrl:= "https://salonline.layer.core.dcg.com.br/v1/Sales/API.svc/web/GetOrderStatus"
                
                Gravalog( _cPatch,  time()+"" )
                Gravalog( _cPatch,  time()+" - >>> Chamada do metodo GetOrderStatus para a identificacao do status do pedido... " )
                Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
                Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
                Gravalog( _cPatch,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
                Gravalog( _cPatch,  time()+" -     aHeadOut : [3] - Authorization: Basic " + _cAutentic  )
                Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
                Gravalog( _cPatch,  time()+"" )
                _cPostStatus := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","",_cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) )
                
                Gravalog( _cPatch,  time()+" - <<< Retorno do metodo GetOrderStatus para identificacao do status dos pedidos da fila de integração... " )
                Gravalog( _cPatch,  time()+" -     " + _cPostStatus     )
                Gravalog( _cPatch,  time()+"" )

                oJson5 := tJsonParser():New()
                lRet   := oJson5:Json_Hash(_cPostStatus, LEN(_cPostStatus), @aJsonStatus, @nRetParser5, @oJHM5)

                IF  lRet .AND. Len( aJsonStatus ) > 0
                    _cStatusPed := aJsonStatus[1][2][ aScan( aJsonStatus[1][2], {|x| x[1] == 'Status'} ) ][2]
                EndIf 
            EndIf 
        //   _cStatusPed:= "Aguardando pagamento"  
            Do  Case
                
                Case _cStatusPed == ""  
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_STATUS"  ,"C", "0" } )        

                    // Aguardando pagamento, data e hora de aprovacao ainda nao disponiveis
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_DATAAP"    ,"D", CTOD("") } ) 
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_HRAPRV"    ,"C", ""       } ) 

                    Gravalog( _cPatch,  time()+" -          PZU_STATUS >> '0' - [" + _cStatusPed + "]" )
                    Gravalog( _cPatch,  time()+" - " )

                Case upper(_cStatusPed) == UPPER("Aguardando pagamento")
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_STATUS"  ,"C", "0" } )

                    // Aguardando pagamento, data e hora de aprovacao ainda nao disponiveis
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_DATAAP"    ,"D", CTOD("") } ) 
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_HRAPRV"    ,"C", ""       } ) 

                    Gravalog( _cPatch,  time()+" -          PZU_STATUS >> '0' - [" + _cStatusPed + "]" )
                    Gravalog( _cPatch,  time()+" - " )

                Case upper(_cStatusPed) == UPPER("Pagamento Aprovado")
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_STATUS"  ,"C", "2" } )                

                    // PZU_DATAAP // PZU_HRAPRV
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_DATAAP"    ,"D", _aPedidos[_nX][4]} ) 
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_HRAPRV"    ,"C", _aPedidos[_nX][5]} ) 

                    Gravalog( _cPatch,  time()+" -          PZU_STATUS >> '2' - [" + _cStatusPed + "]" )
                    Gravalog( _cPatch,  time()+" - " )

                Case upper(_cStatusPed) == UPPER("Cancelado")
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_STATUS"  ,"C", "F" } )

                    // pedido cancelado, data e hora de aprovacao indefinidas
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_DATAAP"    ,"D", CTOD("") } ) 
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_HRAPRV"    ,"C", ""       } ) 

                    Gravalog( _cPatch,  time()+" -          PZU_STATUS >> 'F' - [" + _cStatusPed + "]" )
                    Gravalog( _cPatch,  time()+" - " )
            EndCase 

            _cStatusPed := ""

            // PZU_PRAZO
            _cAuxData := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "DeliveryMethods"})][2][1][2][aScan( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "DeliveryMethods"})][2][1][2], {|x| x[1] == "ETA"})][2] // Identifica a quantidade de dias para a entrega
            _cAuxData := Iif( ValType(_cAuxData) == "U", "", _cAuxData )
            _cAuxData := Val( Substr( _cAuxData, 1, At("|",_cAuxData)-1) )

            IF  !Empty( _aPedidos[_nX][3][1][2][ aScan( _aPedidos[_nX][3][1][2], { |x| x[1] == "PZU_DATAAP"} ) ][3] )

                // Iguala a data do prazo a data da aprovacao...
                _dDtEntreg  := _aPedidos[_nX][3][1][2][ aScan( _aPedidos[_nX][3][1][2], { |x| x[1] == "PZU_DATAAP"} ) ][3]

                // ... e inicia o incremento da data de entrega conforme a quantidade de dias uteis obtido da plataforma
                For _nY := 1 to _cAuxData

                    _dDtEntreg := _dDtEntreg + 1    // avanca 1 dia

                    IF  DOW(_dDtEntreg) == 1 .Or. DOW(_dDtEntreg) == 7  // se o proximo dia cair no sabado ou domingo...
                        _dDtEntreg := DataValida(_dDtEntreg)            // ...avanca a data ate segunda-feira
                    EndIf 
                Next _nY 

                aAdd( _aPedidos[_nX][3][1][2], {"PZU_PRAZO"  ,"D", _dDtEntreg } )
            Else 
                _aAuxData   := {}
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_PRAZO"  ,"D", CTOD("") } )
                _dDtEntreg  := CTOD("")
            EndIf 

            // PZU_CONDPG
            aAdd( _aPedidos[_nX][3][1][2], {"PZU_CONDPG"  ,"C", "352" } )

            // PZU_NATURE
        //  If  _lMarketPlace
                //aAdd( _aPedidos[_nX][3][1][2], {"PZU_NATURE"  ,"C", _cNatMarketP} )
            //Else 
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_NATURE"  ,"C", _cNatEComm  } )
            //EndIf 

            // PZU_CGC
            // Verifica se o cliente eh pessoa fisica (P=Pessoa) ou pessoa juridica 
            _cAuxData := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "CustomerType"})][2]
            _cAuxData := Iif( ValType( _cAuxData ) == "U", "", _cAuxData )

            _cXML     := Alltrim( Str( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "CustomerID"})][2]  ) )

            // Funcao de integracao de cliente
            _aInfoCli := IntegCli( _cAuxData, _cXML, _cPatch )

            _cAuxData := _aInfoCli[1]  // CPF/CNPJ Cliente
            _lxSA1    := _aInfoCli[2]  // _lxSA1

            // PZU_CLIENT / PZU_LOJA
            If _lxSA1
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_CLIENT"    ,"C", SA1->A1_COD       } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_LOJA"      ,"C", SA1->A1_LOJA      } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_CGC"       ,"C", SA1->A1_CGC       } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_CEP"       ,"C", SA1->A1_CEP       } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_ENDERE"    ,"C", SA1->A1_END       } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_BAIRRO"    ,"C", SA1->A1_BAIRRO    } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_MUN"       ,"C", SA1->A1_MUN       } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_COMPLE"    ,"C", SA1->A1_COMPLEM   } )    
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_UF"        ,"C", SA1->A1_EST       } )    
            EndIf 

            // PZU_TRANSP
            _cTrans  :=  aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "DeliveryMethods"})][2][1][2][aScan( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "DeliveryMethods"})][2][1][2], {|x| x[1] == "DeliveryMethodAlias"})][2]

            If   _cTrans $ 'SEDEX | PAC'
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_TRANSP"        ,"C", "000050" } )    
            Else 
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_TRANSP"        ,"C", " "       } )    
            EndIf 

            // PZU_FRETPG
            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FRETPG"        ,"C", "1"       } )    

            // PZU_FRETE
            _cAuxData  := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "DeliveryAmount"})][2]
            _nValFrete := _cAuxData

            _cAuxData  := aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == "PaymentTaxAmount"})][2]
            _nValFrete += _cAuxData // Adiciona taxas diversas se houver alguma - adiciona como frete

            IF  _nValFrete > 0 
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_FRETE"     ,"N", _nValFrete } )    
            Else 
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_FRETE"     ,"N", 0         } )    
            EndIf 

            // PZU_FRETEP
            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FRETEP"        ,"N", 0         } )    

            // PZU_CEPENT / PZU_ENDENT / PZU_BAENTR / PZU_MUNENT / PZU_COMENT / PZU_UFENTR 

            _aAuxData := {}
            _cAuxData := ""

            _aAuxData := aClone( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == 'Addresses'})][2] )
            _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData )        

            // Carga dos dados do endereço cadastral e de entrega contidos no pedido
            IF  Len( _aAuxData ) > 0

                For _nY := 1 to Len( _aAuxData )

                    _cAuxData := Alltrim(  _aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'AddressType'} ) ][2] ) 

                    IF  ( "68" $ _cAuxData )    // 68 - Delivery - Endereço de entrega
                        aAdd( _aPedidos[_nX][3][1][2], {"PZU_ENDENT"    ,"C", Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'AddressLine'    } ) ][2] ) + ", " + Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'Number'} ) ][2] )  } )            
                        aAdd( _aPedidos[_nX][3][1][2], {"PZU_BAENTR"    ,"C", Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'Neighbourhood'  } ) ][2] )   } )  
                        aAdd( _aPedidos[_nX][3][1][2], {"PZU_MUNENT"    ,"C", Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'City'           } ) ][2] )   } )  
                        aAdd( _aPedidos[_nX][3][1][2], {"PZU_CEPENT"    ,"C", Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'PostalCode'     } ) ][2] )   } )  
                        aAdd( _aPedidos[_nX][3][1][2], {"PZU_UFENTR"    ,"C", Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'State'          } ) ][2] )   } ) 
                        aAdd( _aPedidos[_nX][3][1][2], {"PZU_COMENT"    ,"C", Alltrim(_aAuxData[_nY][2][ aScan(_aAuxData[_nY][2], {|x| x[1] == 'AddressNotes'   } ) ][2] )   } ) 
                        Exit
                    Else 
                        _cAuxData := ""
                    EndIf 
                Next _nY 

                // caso o endereço de entrega não esteja especificado no pedido, replica o denreço cadastral no endereço de entrega
                IF  Empty( _cAuxData ) 
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_ENDENT"    ,"C", SA1->A1_END       } )            
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_BAENTR"    ,"C", SA1->A1_BAIRRO    } )  
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_MUNENT"    ,"C", SA1->A1_BAIRRO    } )  
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_CEPENT"    ,"C", SA1->A1_CEP       } )  
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_UFENTR"    ,"C", SA1->A1_EST       } )  
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_COMENT"    ,"C", SA1->A1_COMPLEM   } )  
                EndIf 
            EndIf 

            // PZU_CUPOM , PZU_VLRCUP
            _aAuxData := {}
            _cAuxData := ""

            _aAuxData := aClone( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == 'Properties'})][2] )
            _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData )        

            // Carga das informacoes do CUPOM DE DESCONTO
            IF  Len( _aAuxData ) > 0

                // Varre as propriedades do pedido a procura do cupom
                For _nY := 1 to Len( _aAuxData )    

                    // Se a propriedade do pedido for 'Coupon', corresponde ao código do cupom de desconto
                    If  _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2],{ |x| x[1] == "Type" } )][2] == "Coupon"

                        _cAuxData := Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2],{ |x| x[1] == "Reference" } )][2] )

                        IF  !Empty(_cAuxData)
                            aAdd( _aPedidos[_nX][3][1][2], {"PZU_CUPOM"    ,"C", _cAuxData } )    
                            Exit          
                        EndIf 
                    EndIf 
                Next _nY

                // Se o codigo do cupom foi identificado, busca entao o valor deste cupom
                IF  !Empty( _cAuxData ) 

                    // Varre as propriedades do pedido a procura do cupom
                    For _nY := 1 to Len( _aAuxData )    

                        // Se a propriedade do pedido for 'Coupon', corresponde ao código do cupom de desconto
                        If  _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2],{ |x| x[1] == "Type" } )][2] == "Discount"

                            _cAuxData := _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2],{ |x| x[1] == "Amount" } )][2]

                            IF  !Empty(_cAuxData)
                                aAdd( _aPedidos[_nX][3][1][2], {"PZU_VLRCUP"    ,"N", _cAuxData } )      
                                _nValCupom := _cAuxData
                                Exit       
                            EndIf 
                        EndIf 
                    Next _nY 
                Else 
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_CUPOM"    ,"C", "" } )    
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_VLRCUP"   ,"N", 0  } )      
                EndIf 
            EndIf 

            // PZU_DEVICE
            If  _lMarketPlace
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_DEVICE"    ,"C", _aPedidos[_nX][3][1][2][ aScan( _aPedidos[_nX][3][1][2], { |x| x[1] == "PZU_ORIGEM"} ) ][3] } ) 
            Else 
                _aAuxData := {}
                _cAuxData := ""

                _aAuxData := aClone( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == 'MultiSiteTenant'})+1][2] )
                _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData )        

                IF Len( _aAuxData ) > 0
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_DEVICE"    ,"C", Alltrim(_aAuxData[ aScan(_aAuxData, {|x| x[1] == 'DeviceType' } ) ][2]) } ) 
                EndIf 
            EndIf

            _aAuxData := {}
            _cAuxData := ""

            _aAuxData := aClone( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == 'PaymentMethods'})][2] )
            _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData )        

            // Verifica se tem o 2o pagto em cartao e carrega a Var para tratamento do pagamento com o 2o cartão
            If Len( _aAuxData ) > 1
                _aSegPagto := aClone( _aAuxData )
            Else
                _aSegPagto := {}
            EndIf

            // Tratamento de Desconto financeiro - 
            //_nDesFin  := _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'TaxAmount'} )][2]  
            //_nDesFin  := Iif( _nDesFin < 0, (_nDesFin * (-1)) , 0 )

            // PZU_NSU 
            aAdd( _aPedidos[_nX][3][1][2], {"PZU_NSU"       ,"C", Alltrim( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2][aScan( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2], {|x| x[1] == 'ReconciliationNumber'  })][2] )   } ) 

            // PZU_AUTCAR
            aAdd( _aPedidos[_nX][3][1][2], {"PZU_AUTCAR"    ,"C", Alltrim( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2][aScan( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2], {|x| x[1] == 'AuthorizationCode'     })][2] )   } ) 

            // PZU_NRPARC
            If  _lMarketPlace
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_NRPARC"    ,"N",  1  } ) 
            Else
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_NRPARC"    ,"N",  _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'Installments'} )][2]   } ) 
            EndIf 

            // PZU_VLRPG - Grava o valor do 1o pagto
            aAdd( _aPedidos[_nX][3][1][2], { "PZU_VLRPG", "N", _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'Amount'} )][2] } )

            // Carrega o 1o pagto no valor total da compra
            _nValTot := _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'Amount'} )][2]

            // PZU_FORMPG
        //   If  _lMarketPlace
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"     ,"C", "PD" } ) 
          /*  Else 
                _cAuxData := Alltrim( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2][aScan( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2], {|x| x[1] == 'NumberHint' })][2] ) // Numero do cartao

                IF  !Empty( _cAuxData )
                    aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"    ,"C", "DC" } ) 
                    _cAuxData2 := Alltrim( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2][aScan( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2], {|x| x[1] == 'Alias' })][2] )

                Else
                    _cAuxData  := Alltrim( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2][aScan( _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentInfo'} )+1][2], {|x| x[1] == 'Alias' })][2] )
                    _cAuxData2 := _cAuxData

                    Do Case //TRATATIVA DE CONDIÇÃO DE PAGAMENTO
                        // Boleto
                        Case _cAuxData == "LINXPAY"     
                            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"     ,"C", "BOL" } ) 

                        // Boleto PAGARME
                        Case _cAuxData == "CITIBANK"     
                            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"     ,"C", "BOL" } ) 

                        // Deposito em conta
                        Case Alltrim(_cAuxData) $ "ITAU|BRADESCO|SANTANDER|PIX"  
                            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"     ,"C", "DC" } ) 
                       
                         //MERCADO PAGO   
                        Case _cAuxData == "MERCADO PAGO"     
                            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"     ,"C", "DC" } ) 
                        
                        //DESCONHECIDO
                        OtherWise
                            aAdd( _aPedidos[_nX][3][1][2], {"PZU_FORMPG"     ,"C", ""   }  ) 
                    EndCase 
                EndIf 
            EndIf */
                _aAuxData := {}
                _cAuxData := 0  

        //       aAdd( _aAuxData, PADR( _cAuxData2, TamSX3("PEC_IDEZ")[1]) )
                aAdd( _aAuxData, _aPedidos[_nX][3][1][2][ aScan( _aPedidos[_nX][3][1][2], { |x| x[1] == "PZU_NRPARC"} ) ][3] )
                aAdd( _aAuxData, _aPedidos[_nX][3][1][2][ aScan( _aPedidos[_nX][3][1][2], { |x| x[1] == "PZU_FORMPG"} ) ][3] )
                aAdd( _aPedidos[_nX][3][1][2], {"PZU_ADMFIN"    ,"C", ""    } ) 
            

            // PZU_VEND
            aAdd( _aPedidos[_nX][3][1][2], { "PZU_VEND", "C", cVendEco } )

            _aAuxData := {}
            _aAuxData := aClone( aJSonPInfo[1][2][aScan( aJSonPInfo[1][2], {|x| x[1] == 'PaymentMethods'})][2] )
            _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData )        

            // PZU_DTPAG
            _cAuxData  := ""
            _cAuxData2 := ""
            _cAuxData  := _aAuxData[1][2][aScan( _aAuxData[1][2], {|x| x[1] == 'PaymentDate'} )][2] 
            _cAuxData  := Iif( ValType(_cAuxData) == "U", "", _cAuxData )
            _cAuxData  := StrTran( _cAuxData, "/Date(" , "" )
            _cAuxData  := StrTran( _cAuxData, "-0300)/", "" )
            _cAuxData  := U_MsToDate( _cAuxData )[1]

            If  _lMarketPlace
                IF	Day(_cAuxData) >= 1 .And. Day(_cAuxData) <= 15
                    _cAuxData   :=  CTOD("01/" + ;
                                        Iif ( Month(_cAuxData) == 12, "01", Alltrim( Str( Month(_cAuxData) + 1 ) ) ) + "/" + ;
                                        Iif ( Month(_cAuxData) == 12, Alltrim( Str( Year(_cAuxData) + 1 ) ), Alltrim( Str( Year(_cAuxData) ) ) )  ;
                                        )

                ElseIf Day(_cAuxData) >= 16

                    _cAuxData   :=  CTOD("15/" + ;
                                        Iif ( Month(_cAuxData) == 12, "01", Alltrim( Str( Month(_cAuxData) + 1 ) ) ) + "/" + ;
                                        Iif ( Month(_cAuxData) == 12, Alltrim( Str( Year(_cAuxData) + 1 ) ), Alltrim( Str( Year(_cAuxData) ) ) )  ;
                                        )
                EndIf 
            EndIf 

            aAdd( _aPedidos[_nX][3][1][2], { "PZU_DTPAG", "D", _cAuxData } )

            // PZU_VALOR - É a soma do 1o e do 2o pagto
            aAdd( _aPedidos[_nX][3][1][2], { "PZU_VALOR", "N", _nValTot - _nValFrete } ) 

            // Gravacao da tabela PZV
            // =======================
            _cAuxData := ""
            _aAuxData := {}
            _aAuxData := aClone( aJsonPInfo[1][2][ aScan(aJsonPInfo[1][2],{|x| x[1] == 'Items'}) ][2] )

            _nDesFin  := Iif( _nDesFin > 0, _nDesFin, 0 )

            IF  Len( _aAuxData ) > 0
                _nItemPZV := 0
                _nDesProd := 0

                For _nY := 1 to Len( _aAuxData )

                    // Identifica SKU do item do pedido do e-commerce
                    _cProduto := _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'SKU' } ) ][2]

                    // Verifica se o produto tem desconto - De/Por
                    _nDesProd += ( _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'DiscountAmount' } ) ][2] * _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'Qty'      } ) ][2] )
                    // Posiciona na SB1 - Cadastro de Produtos - para identificacao
                    SB1->( DbSeek( xFilial("SB1") + _cProduto ) )
                    // Verifica se o SKU corresponde a um KIT para o desmenbramento dos componentes no pedido (PZV)
                    IF  SB1->B1_TIPO == "KT"
                        //Precos e Quantidades
                        _nQtdVen	:= _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'Qty'      } ) ][2]
                        _nPrcVen	:= _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'Price'    } ) ][2]
                        _nValIte	:= _nPrcVen
                        _nSaldoCD	:= 0
                        _cCodKit := SB1->B1_COD

                        // Desmebra o KIT - posiciona no KIT
                        IF  MEU->( DbSeek( xFilial("MEU") + SB1->B1_COD) )
                            // Posiciona no primeiro item do KIT para desmembramento
                            IF  MEV->( DbSeek( xFilial("MEV") +  SB1->B1_COD ) )

                                While !MEV->( Eof() ) .And. MEV->MEV_FILIAL == xFilial("MEV") .And. MEU->MEU_CODIGO == MEV->MEV_CODKIT

                                    SB1->( DbSeek( xFilial( "SB1" ) + MEV->MEV_PRODUT ) )

                                    // Le o preço de tabela do ITEM do KIT
                                    _nValTab := GetAdvFVal( "DA1", "DA1_PRCVEN", _cFilPreco + _cTabPreco + MEV->MEV_PRODUT, 1, 0 )

                                    _nDescKT := (_nValTab * MEV->MEV_DESCNT/100) * MEV->MEV_QTD * _nQtdVen // Valor de abatimento do item do kit para a composicao do valor do produto vendido
                                 
                                    _nValIte := _nValTab			                        // Valor do item recebe o valor CHEIO de tabela de preço 

                                    _nItemPZV++

                                    aAdd(_aPedidos[_nX][3][2][2] , { StrZero(_nItemPZV,2),{} } )

                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PEDECO"  ,"C", _aPedidos[_nX][1]                     } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_ITEM"    ,"C", StrZero(_nItemPZV,2)                  } )

                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PRODUT"  ,"C", SB1->B1_COD                           } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_KIT"     ,"C", _cCodKit                              } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_QTDVEN"  ,"N", ( MEV->MEV_QTD * _nQtdVen )           } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PRCVEN"  ,"N", _nValIte *(MEV->MEV_QTD * _nQtdVen )  } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_DESC"    ,"N", _nDescKT                              } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_VLUNIT"  ,"N", _nValIte                              } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PRCTAB"  ,"N", _nValTab                              } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PESO"    ,"N", SB1->B1_PESO                          } )
                                    aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_ESTOQU"  ,"N", _nSaldoCD                             } )
                                    //aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_SUGVEN"  ,"C", _cXSugVen                             } )
                                //  aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_DTENTR"  ,"D", _dDtEntreg                            } )

                                    MEV->( DbSkip() )
                                EndDo 
                            EndIf 
                        EndIf                 
                    Else 
                        If  SB1->( DbSeek( xFilial("SB1") + _cProduto ) )

                            //Precos e Quantidades
                            _nQtdVen	:= _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'Qty'      } ) ][2]
                            _nPrcVen	:= _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'Price'    } ) ][2]
                            _nValIte	:= _nPrcVen

                            _nValIte := POSICIONE('DA1',1,xfilial('DA1')+ _cTabPreco + _cProduto,'DA1_PRCVEN')   
                            _nValTab := _nValIte

                            // Analisa Saldo em Estoque do CD para definir se Sugestao 
                            // da Venda (LR_XSUGVEN) sera 003-ENTREGA OU 004-ENCOMENDA 
                        //  _aSaldoSB2	:= U_KSSldSB2( AllTrim( _cProduto ) )				
                            _nSaldoCD	:= 0 ///_aSaldoSB2[2]

                            // Adiciona o item da PZV no array
                            _nItemPZV++

                            aAdd(_aPedidos[_nX][3][2][2] , { StrZero(_nItemPZV,2),{} } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PEDECO"  ,"C", _aPedidos[_nX][1]                     } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_ITEM"    ,"C", StrZero(_nItemPZV,2)                  } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PRODUT"  ,"C", SB1->B1_COD                           } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_KIT"     ,"C"," "                                    } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_QTDVEN"  ,"N", _nQtdVen                              } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PRCVEN"  ,"N", _nValIte *  _nQtdVen                  } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_DESC"    ,"N", 0                                     } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_VLUNIT"  ,"N", _nValIte                              } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PRCTAB"  ,"N", _nValTab                              } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_PESO"    ,"N", SB1->B1_PESO                          } )
                            aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_ESTOQU"  ,"N", _nSaldoCD                             } )
                            //aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_SUGVEN"  ,"C", _cXSugVen                             } )
    //                        aAdd(_aPedidos[_nX][3][2][2][ Len(_aPedidos[_nX][3][2][2]) ][2], {"PZV_DTENTR"  ,"D", _dDtEntreg                            } )
                        EndIf 
                    EndIf 
                Next _nY 

                // Rateia o valor do cupom de desconto se houver
                If  _nValCupom > 0
                    _cDataAux := ( _nValCupom / Len(_aPedidos[_nX][3][2][2]) )

                    For _nY := 1 to Len( _aPedidos[_nX][3][2][2] )    
                        _aPedidos[_nX][3][2][2][_nY][2][ aScan( _aPedidos[_nX][3][2][2][_nY][2], {|x| x[1] == "PZV_DESC"} ) ][3] += _cDataAux
                    Next _nY 

                    _cDataAux  := ""
                    _nValCupom := 0
                EndIf 

                // Rateia o valor do desconto financeiro se houver
                If  _nDesFin > 0

                    _cDataAux := ( _nDesFin / Len(_aPedidos[_nX][3][2][2]) )

                    For _nY := 1 to Len( _aPedidos[_nX][3][2][2] )    
                        _aPedidos[_nX][3][2][2][_nY][2][ aScan( _aPedidos[_nX][3][2][2][_nY][2], {|x| x[1] == "PZV_DESC"} ) ][3] += _cDataAux
                    Next _nY 

                    _cDataAux  := ""
                    _nDesFin := 0
                EndIf 

                If  _nDesProd > 0 
                    _cDataAux := ( _nDesProd / Len(_aPedidos[_nX][3][2][2]) )

                    For _nY := 1 to Len( _aPedidos[_nX][3][2][2] )    
                        _aPedidos[_nX][3][2][2][_nY][2][ aScan( _aPedidos[_nX][3][2][2][_nY][2], {|x| x[1] == "PZV_DESC"} ) ][3] += _cDataAux
                    Next _nY 

                    _cDataAux  := ""
                    _nDesProd  := 0
                EndIf 
            
            EndIf 

            // Zera vetor e reinicia variável de controle
            aJsonPInfo  := {}
            nRetParser2 := 0

            Gravalog( _cPatch,  time()+" -     <<< Pedido : [" + _aPedidos[_nX][1] + "] concluído."     )
            Gravalog( _cPatch,  time()+"" )
        Next _nX
    EndIf 

    // Gravacao das vetores nas tabelas PZU e PZV
    //============================================

    For _nX := 1 to Len(_aPedidos)

        // Gravacao da PZU - Cabecalho Pedido e-commerce
        IF  Len( _aPedidos[_nX][3][1][2] ) > 0

            Gravalog( _cPatch,  time()+" -     >>> Gravação do Pedido : [" + _aPedidos[_nX][1] + "] na tabela PZU do Protheus - Cabecalho Download"     )
            Gravalog( _cPatch,  time()+"" )

            IF  PZU->( DbSeek( xFilial("PZU") + padr(_aPedidos[_nX][1],TamSx3('PZU_PEDECO')[1])) ) .AND. PZU->PZU_STATUS <> "0" .AND. PZU->PZU_STATUS <> "1" .AND. PZU->PZU_STATUS <> "2"

                Gravalog( _cPatch,  time()+" -       Pedido : [" + _aPedidos[_nX][1] + "] já existente na tabela PZU do Protheus - Prossegue..."     )
                Gravalog( _cPatch,  time()+"" )
            Else 
                IF  PZU->( Eof() )

                    RecLock("PZU",.T.)

                        PZU->PZU_FILIAL := xFilial("PZU")
                        Gravalog( _cPatch,  time()+" -         > Filial [PZU->PZU_FILIAL] = '01'" )

                        For _nY := 1 to Len( _aPedidos[_nX][3][1][2] )
                            &( 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] ) := _aPedidos[_nX][3][1][2][_nY][3]

                            Do  Case
                                Case    _aPedidos[_nX][3][1][2][_nY][2] == "C"
                                        Gravalog( _cPatch,  time()+" -         > Status [" + 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] + Space( 10 - Len(_aPedidos[_nX][3][1][2][_nY][1]) ) + "] = '" + Alltrim(_aPedidos[_nX][3][1][2][_nY][3]) + "'"  )

                                Case    _aPedidos[_nX][3][1][2][_nY][2] == "D"
                                        Gravalog( _cPatch,  time()+" -         > Status [" + 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] + Space( 10 - Len(_aPedidos[_nX][3][1][2][_nY][1]) ) + "] = '" + DTOC(_aPedidos[_nX][3][1][2][_nY][3]) + "'"  )

                                Case    _aPedidos[_nX][3][1][2][_nY][2] == "N"
                                        Gravalog( _cPatch,  time()+" -         > Status [" + 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] + Space( 10 - Len(_aPedidos[_nX][3][1][2][_nY][1]) ) + "] = '" + Alltrim(Str(_aPedidos[_nX][3][1][2][_nY][3])) + "'"  )
                            EndCase 
                        Next _nY

                    PZU->( MsUnlock() )
                Else 
                    IF  PZU->PZU_STATUS $ "02"   // Se o pedido posicionado na PZU esta com status = "0" (Aguardando pagamento) ou "1" (Aguardando pagamento com pedido) ou "2" (Pagamento Confirmado)

                        RecLock("PZU",.F.)

                        For _nY := 1 to Len( _aPedidos[_nX][3][1][2] )
                            &( 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] ) := _aPedidos[_nX][3][1][2][_nY][3]

                            Do  Case
                                Case    _aPedidos[_nX][3][1][2][_nY][2] == "C"
                                        Gravalog( _cPatch,  time()+" -         > Status [" + 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] + Space( 10 - Len(_aPedidos[_nX][3][1][2][_nY][1]) ) + "] = '" + Alltrim(_aPedidos[_nX][3][1][2][_nY][3]) + "'"  )

                                Case    _aPedidos[_nX][3][1][2][_nY][2] == "D"
                                        Gravalog( _cPatch,  time()+" -         > Status [" + 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] + Space( 10 - Len(_aPedidos[_nX][3][1][2][_nY][1]) ) + "] = '" + DTOC(_aPedidos[_nX][3][1][2][_nY][3]) + "'"  )

                                Case    _aPedidos[_nX][3][1][2][_nY][2] == "N"
                                        Gravalog( _cPatch,  time()+" -         > Status [" + 'PZU->' + _aPedidos[_nX][3][1][2][_nY][1] + Space( 10 - Len(_aPedidos[_nX][3][1][2][_nY][1]) ) + "] = '" + Alltrim(Str(_aPedidos[_nX][3][1][2][_nY][3])) + "'"  )
                            EndCase 
                        Next _nY

                        PZU->( MsUnlock() )
                    Else 
                        Gravalog( _cPatch,  time()+" -       Pedido : [" + _aPedidos[_nX][1] + "] já existente na tabela PZU do Protheus - Prossegue..."     )
                        Gravalog( _cPatch,  time()+"" )
                    EndIf 
                EndIf 
            EndIf 

            Gravalog( _cPatch,  time()+" -     <<< ...concluído." )
            Gravalog( _cPatch,  time()+"" )
        EndIf

        // Grava os itens dos pedidos e-commerce na tabela ZPV
        IF  PZV->( DbSeek( xFilial("PZV") + padr(_aPedidos[_nX][1],TamSx3('PZV_PEDECO')[1])) )
            Gravalog( _cPatch,  time()+" -       Pedido : [" + _aPedidos[_nX][1] + "] já existente na tabela PZV do Protheus - Prossegue..."     )
            Gravalog( _cPatch,  time()+"" )
        Else 
            // Gravacao da PZV - Itens Pedido e-commerce
            If  Len( _aPedidos[_nX][3][2][2] ) > 0

                For _nY := 1 to Len( _aPedidos[_nX][3][2][2] )

                    IF  Len( _aPedidos[_nX][3][2][2][_nY][2] ) > 0 

                        Gravalog( _cPatch,  time()+" -     >>> Gravação do Pedido : [" + _aPedidos[_nX][1] + "], item "+ Alltrim( Str(_nY) ) + " na tabela PZV do Protheus - Itens Download"     )
                        Gravalog( _cPatch,  time()+"" )

                        Reclock("PZV",.T.)

                            PZV->PZV_FILIAL := xFilial("PZV")
                            Gravalog( _cPatch,  time()+" -         > Filial [PZV->PZV_FILIAL] = '01'" )

                            For _nZ := 1 to Len( _aPedidos[_nX][3][2][2][_nY][2] ) 
                                &('PZV->' + _aPedidos[_nX][3][2][2][_nY][2][_nZ][1] ) := _aPedidos[_nX][3][2][2][_nY][2][_nZ][3]

                                Do  Case
                                    Case    _aPedidos[_nX][3][2][2][_nY][2][_nZ][2] == "C"
                                            Gravalog( _cPatch,  time()+" -         > Status [" + 'PZV->' + _aPedidos[_nX][3][2][2][_nY][2][_nZ][1] + Space( 10 - Len(_aPedidos[_nX][3][2][2][_nY][2][_nZ][1]) ) + "] = '" + Alltrim(_aPedidos[_nX][3][2][2][_nY][2][_nZ][3]) + "'"  )

                                    Case    _aPedidos[_nX][3][2][2][_nY][2][_nZ][2] == "D"
                                            Gravalog( _cPatch,  time()+" -         > Status [" + 'PZV->' + _aPedidos[_nX][3][2][2][_nY][2][_nZ][1] + Space( 10 - Len(_aPedidos[_nX][3][2][2][_nY][2][_nZ][1]) ) + "] = '" + DTOC(_aPedidos[_nX][3][2][2][_nY][2][_nZ][3]) + "'"  )

                                    Case    _aPedidos[_nX][3][2][2][_nY][2][_nZ][2] == "N"
                                            Gravalog( _cPatch,  time()+" -         > Status [" + 'PZV->' + _aPedidos[_nX][3][2][2][_nY][2][_nZ][1] + Space( 10 - Len(_aPedidos[_nX][3][2][2][_nY][2][_nZ][1]) ) + "] = '" + Alltrim(Str(_aPedidos[_nX][3][2][2][_nY][2][_nZ][3])) + "'"  )
                                EndCase 
                            Next _nZ 

                        PZV->( MsUnlock() )

                        Gravalog( _cPatch,  time()+" -     <<< ...concluído." )
                        Gravalog( _cPatch,  time()+"" )
                    EndIf 
                Next _nY
            EndIf
        EndIf 

        // Caso a PZU não esteja posicionada
        If  PZU->(EOF() ) .OR. ( Alltrim(PZU->PZU_PEDECO) <> Alltrim(_aPedidos[_nX][1]) )
            PZU->( DbSeek( xFilial("PZU") + _aPedidos[_nX][1] ) )
        Endif 

        // Gravação da tabela de Tracking do pedido e-commerce - PZX

        Gravalog( _cPatch,  time()+" -     >>> Gravação do Tracking do Pedido : [" + _aPedidos[_nX][1] + "] na tabela PZX do Protheus - Tracking Pedido e-commerce"     )
        Gravalog( _cPatch,  time()+"" )

        If  PZX->( DbSeek( xFilial("PZX") + PZU->PZU_PEDECO ))

            While !PZX->( Eof() ) .And. PZX->PZX_FILIAL == xFilial("PZX") .And. PZX->PZX_PEDECO == PZU->PZU_PEDECO
                If  PZX->PZX_STATUS == PZU->PZU_STATUS 
                    _lxPZX := .T.
                    Exit 
                EndIf 

                PZX->( DbSkip() )
            EndDo 

            If !_lxPZX

                RecLock( "PZX", .T. )
                    PZX->PZX_FILIAL := xFilial("PZX")
                    PZX->PZX_PEDECO := PZU->PZU_PEDECO 
                    PZX->PZX_DATA   := dDatabase 
                    PZX->PZX_HORA   := Time() 
                    PZX->PZX_STATUS := PZU->PZU_STATUS 
                    PZX->PZX_ORIGEM := "1"  // e-commerce
                PZX->( MsUnlock() )

                 If  (PZU->PZU_STATUS == "2" .OR. PZU->PZU_STATUS == "3") .AND. EMPTY(PZU->PZU_INTELI)
                    u_SLSHIPPING(PZU->PZU_PEDECO)
                 ENDIF
            EndIf 

            _lxPZX := .F. 
        Else 
            If  PZU->PZU_STATUS == "2"  // Status não encontrado, deve sempre iniciar com o status "0" e gravar status "2" em seguida

                RecLock( "PZX", .T. )
                    PZX->PZX_FILIAL := xFilial("PZX")
                    PZX->PZX_PEDECO := PZU->PZU_PEDECO 
                    PZX->PZX_DATA   := dDatabase 
                    PZX->PZX_HORA   := Time() 
                    PZX->PZX_STATUS := "0"  // Aguardando Pagamento
                    PZX->PZX_ORIGEM := "1"  // e-commerce
                PZX->( MsUnlock() )

                RecLock( "PZX", .T. )
                    PZX->PZX_FILIAL := xFilial("PZX")
                    PZX->PZX_PEDECO := PZU->PZU_PEDECO 
                    PZX->PZX_DATA   := dDatabase 
                    PZX->PZX_HORA   := Time() 
                    PZX->PZX_STATUS := PZU->PZU_STATUS 
                    PZX->PZX_ORIGEM := "1"  // e-commerce
                PZX->( MsUnlock() )

                //ENVIO INTELIPOST DOS DADOS DO PEDIDO APROVADO
                u_SLSHIPPING(PZU->PZU_PEDECO)
            Else 

                RecLock( "PZX", .T. )
                    PZX->PZX_FILIAL := xFilial("PZX")
                    PZX->PZX_PEDECO := PZU->PZU_PEDECO 
                    PZX->PZX_DATA   := dDatabase 
                    PZX->PZX_HORA   := Time() 
                    PZX->PZX_STATUS := PZU->PZU_STATUS 
                    PZX->PZX_ORIGEM := "1"  // e-commerce
                PZX->( MsUnlock() )
            EndIf 
        EndIf 

        // Protocolo e retirada do pedido da fila de integração
        IF  PZU->PZU_FILIAL == xFilial("PZU") .AND. Alltrim(PZU->PZU_PEDECO) == Alltrim(_aPedidos[_nX][1]) //.AND. ( PZU->PZU_STATUS $ "01E" )

            // Limpa array cin as informacoes do web service para uma nova chamada
            aJsonOut    := {}

            // Id do cliente a ser consultado - convertido para string
            _cXML := '{ "QueueItems":["'+ Alltrim( _aPedidos[_nX][6] ) + '"] }'

            // URL do servico de consulta de clientes tipo pessoa fisica
            _cUrl := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_DEQUEU_QUEUE_ITEMS/1.0/DequeueQueueItems"

            Gravalog( _cPatch,  time()+" - >>> Chamada do metodo DequeueQueueItems para protocolo e retirada do pedido da fila de integração... " )
            Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
            Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
            Gravalog( _cPatch,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
            Gravalog( _cPatch,  time()+" -     aHeadOut : [3] - Authorization: Basic " + Encode64('integracao:231#$625') )
            Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
            Gravalog( _cPatch,  time()+"" )

            // Retorno do JSON do servico 
            _cPostPed   := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) )

            Gravalog( _cPatch,  time()+" - <<< Retorno do metodo DequeueQueueItems para protocolo e retirada do pedido da fila de integração... " )
            Gravalog( _cPatch,  time()+" -     " + _cPostPed     )
            Gravalog( _cPatch,  time()+"" )

            // Criacao do objeto JSON para manipulacao das informacoes atraves do array aJsonPInfo
            oJson4      := tJsonParser():New()
            lRet        := oJson4:Json_Hash(_cPostPed, LEN(_cPostPed), @aJsonOut, @nRetParser4, @oJHM4)

            _cAuxData   := .F.

            IF  lRet .AND. ValType( aJsonOut ) <> "U" .AND. Len( aJsonOut ) > 0 
                _cAuxData := aJsonOut[1][2][ aScan( aJsonOut[1][2], {|x| x[1] == 'IsValid'} ) ][2] // IsValid
                Gravalog( _cPatch,  time()+" - Pedido e-commerce nro. "+ Alltrim( _aPedidos[_nX][1] ) + ", Id. " + Alltrim( _aPedidos[_nX][6] ) + ", protocolado em "+ DTOC(dDatabase) + " às " + Time() + " e retirado da fila de integração com sucesso !!!")
                Gravalog( _cPatch,  time()+"" )    
            EndIf 

            If  !_cAuxData
                Gravalog( _cPatch,  time()+" - [ERRO] Pedido e-commerce nro. "+ Alltrim( _aPedidos[_nX][1] ) + ", Id. " + Alltrim( _aPedidos[_nX][6] ) + ", NÃO pode ser protocolado e AINDA permanece na fila de integração. Por favor verifique.")
                Gravalog( _cPatch,  time()+"" )    
            EndIf   
        EndIf 
    Next _nX 

    // Integração de clientes
    For _nX := 1 to Len(_aClientes)

        _cXML := _aClientes[_nX][1] 

        // Funcao de integracao de cliente
    // _aInfoCli := IntegCli( "P", _cXML, _cPatch )

        _//cAuxData := _aInfoCli[1]  // CPF/CNPJ Cliente
        //_lxSA1    := _aInfoCli[2]  // _lxSA1

        // Caso a funcao IntegCli nao retorne valores válidos como "P" (Person - Pessoa fisica), tenta recuperar os valores como "C" (Company - Pessoa Juridica)
        //If  Empty(_cAuxData) .And. !_lxSA1
            _aInfoCli := IntegCli( "C", _cXML, _cPatch )

            _cAuxData := _aInfoCli[1]  // CPF/CNPJ Cliente
            _lxSA1    := _aInfoCli[2]  // _lxSA1
        //EndIf 

        IF  _lxSA1

            // Limpa array cin as informacoes do web service para uma nova chamada
            aJsonOut    := {}

            // Id do cliente a ser consultado - convertido para string
            _cXML := '{ "QueueItems":["'+ Alltrim( _aClientes[_nX][6] ) + '"] }'

            // URL do servico de consulta de clientes tipo pessoa fisica
            _cUrl := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_DEQUEU_QUEUE_ITEMS/1.0/DequeueQueueItems"

            Gravalog( _cPatch,  time()+" - >>> Chamada do metodo DequeueQueueItems para protocolo e retirada do cliente da fila de integração... " )
            Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
            Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
            Gravalog( _cPatch,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
            Gravalog( _cPatch,  time()+" -     aHeadOut : [3] - Authorization: Basic " + Encode64('integracao:231#$625') )
            Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
            Gravalog( _cPatch,  time()+"" )

            // Retorno do JSON do servico 
            _cPostPed   := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) )

            Gravalog( _cPatch,  time()+" - <<< Retorno do metodo DequeueQueueItems para protocolo e retirada do cliente da fila de integração... " )
            Gravalog( _cPatch,  time()+" -     " + _cPostPed     )
            Gravalog( _cPatch,  time()+"" )

            // Criacao do objeto JSON para manipulacao das informacoes atraves do array aJsonPInfo
            oJson4      := tJsonParser():New()
            lRet        := oJson4:Json_Hash(_cPostPed, LEN(_cPostPed), @aJsonOut, @nRetParser4, @oJHM4)

            _cAuxData   := .F.

            IF  lRet .AND. ValType( aJsonOut ) <> "U" .AND. Len( aJsonOut ) > 0 
                _cAuxData := aJsonOut[1][2][ aScan( aJsonOut[1][2], {|x| x[1] == 'IsValid'} ) ][2] // IsValid
                Gravalog( _cPatch,  time()+" - Cliente codigo "+ Alltrim( _aClientes[_nX][1] ) + ", Id. " + Alltrim( _aClientes[_nX][6] ) + ", protocolado em "+ DTOC(dDatabase) + " às " + Time() + " e retirado da fila de integração com sucesso !!!")
                Gravalog( _cPatch,  time()+"" )    
            EndIf 

            If  !_cAuxData
                Gravalog( _cPatch,  time()+" - [ERRO] Cliente codigo "+ Alltrim( _aClientes[_nX][1] ) + ", Id. " + Alltrim( _aClientes[_nX][6] ) + ", NÃO pode ser protocolado e AINDA permanece na fila de integração. Por favor verifique.")
                Gravalog( _cPatch,  time()+"" )    
            EndIf   
        EndIf 
    Next _nX 

    Gravalog( _cPatch,  time() + " - Fim do processamento de integracao...    " )
    Gravalog( _cPatch,  time() + "============================================" )
    Gravalog( _cPatch,  time() + " - " + DTOC(dDatabase) )
    
    ///>>> INTEGRA FINANCEIRO E PEDIDO <<<
    u_SLINTPZU(_lSched)
    // Somente limpa o ambiente caso seja execução por Schedule
    If _lSched
        RESET Environment
    EndIf

Return .T.


// Integracao do Cliente
// Recebe o tipo do cliente (P-Person / C-Company), identificação do clinte e path do arquivo

Static Function IntegCli( _xCustomType, _xCustomID, _cPatch )

    Local aJsonCli      := {}
    Local _cXML         := ""
    Local _cUrl         := ""
    Local _cPostPed     := ""
    Local aHeadOut      := {}
    Local _nTimeOut     := 120
    Local _cHeadRet     := ''
    Local oJson3        
    Local oJHM3
    Local nRetParser3   := 0
    Local _cFilSA1      := ""
    Local _cCodSA1      := ""
    Local _lxSA1        := .F.
    Local _nX           := 0
    Local _nY           := 0
    Local _nZ           := 0
    Local _cAuxData     := ""
    Local _aAuxData     := {}
    Local _xCGC         := ""
    Local _aCmposSA1    := {}
    Local _cMsgInfo     := ""
    Local _cTipoRes     := ""
    Local _aMsgInfo     := {}
    Local _aSpecialChar := {}

    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .F.
    Private lAutoErrNoFile := .T. 

    If  _xCustomType == "P" .And. Len(_xCustomID) == 14   // 03057702000108 - (14) CNPJ   38523633812 - (11) CPF
        _xCustomType := "C" //JURIDICO
    EndIf 

    DbSelectArea("SA1")
    SA1->( DbSetOrder(3) )  // A1_FILIAL  + A1_CGC
    _cFilSA1 := xFilial("SA1")

    Gravalog( _cPatch,  time()+" -        Tipo de Cliente : Pessoa " + Iif( _xCustomType == "P", "Física", "Jurídica" ) )
    Gravalog( _cPatch,  time()+"" )

    //  Aadd(aHeadOut,"Content-Type: application/json")   
    // Aadd(aHeadOut,"Accept: application/json") 				
    Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)
 
 
    // "P" - Person - Cliente pessoa fisica   // >>>>>>>>>NÃO USADO NO MOMENTO<<<<<<<<<
    IF  _xCustomType == "P"    

        // Limpa array cin as informacoes do web service para uma nova chamada
        aJsonCli := {}

        // Id do cliente a ser consultado - convertido para string
        _cXML    := _xCustomID

        // URL do servico de consulta de clientes tipo pessoa fisica
        _cUrl    := "/v1/Profile/API.svc/web/GetPerson"
        
        Gravalog( _cPatch,  time()+" - >>> Chamada do metodo GetPerson para leitura dos detalhes do cliente pessoa fisica... " )
        Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
        Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
        Gravalog( _cPatch,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
        Gravalog( _cPatch,  time()+" -     aHeadOut : [3] - Authorization: Basic " + _cAutentic)
        Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
        Gravalog( _cPatch,  time()+"" )

        // Retorno do JSON do servico 
        _cPostPed   := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) ) //_cPostPed   := HttpsPost( _cUrl,"","","","", _cXML, _nTimeOut, aHeadOut, @_cHeadRet )

        Gravalog( _cPatch,  time()+" - <<< Retorno do metodo GetPerson para leitura dos detalhes do cliente pessoa fisica... " )
        Gravalog( _cPatch,  time()+" -     " + _cPostPed     )
        Gravalog( _cPatch,  time()+"" )

        // Criacao do objeto JSON para manipulacao das informacoes atraves do array aJsonPInfo
        oJson3      := tJsonParser():New()
        lRet        := oJson3:Json_Hash(_cPostPed, LEN(_cPostPed), @aJsonCli, @nRetParser3, @oJHM3)

        IF  lRet .AND. ValType( aJsonCli ) <> "U" .AND. Len( aJsonCli ) > 0
            _cAuxData := aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Cpf'}) ][2]
            _cAuxData := Iif( ValType( _cAuxData ) == "U", "", _cAuxData )
        else
            _cAuxData := ""
        EndIf 

    // "C" - Company - Cliente pessoa juridica
    ElseIf _xCustomType == "C" 

        // Limpa array cin as informacoes do web service para uma nova chamada
        aJsonCli    := {}

        // Id do cliente a ser consultado - convertido para string
        _cXML       := 'customerId='+_xCustomID
        //  _cXML       := _xCustomID

        // URL do servico de consulta de clientes tipo pessoa fisica    
        _cUrl       := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_GET_CUSTO_B2B_ERP/1.0/getCustomer"
    //  _cUrl       := "https://salonline.layer.core.dcg.com.br/v1/Profile/API.svc/web/GetCompany"
        
        Gravalog( _cPatch,  time()+" - >>> Chamada do metodo GetCompany para leitura dos detalhes do cliente pessoa juridica... " )
        Gravalog( _cPatch,  time()+" -        _cURL : " + _cUrl     )
        //  Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
        //  Gravalog( _cPatch,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
        Gravalog( _cPatch,  time()+" -     aHeadOut : [1] - Authorization: Basic " + _cAutentic )
        Gravalog( _cPatch,  time()+" -        _cXML : " + _cXML     )
        Gravalog( _cPatch,  time()+"" )
        // Retorno do JSON do servico 
        
        _cPostPed  := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","",_cXML, '', _nTimeOut, aHeadOut, @_cHeadRet ) ) )        
        //   _cPostPed  := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","",'', _cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) )        
        
        Gravalog( _cPatch,  time()+" - <<< Retorno do metodo GetCompany para leitura dos detalhes do cliente pessoa juridica... " )
        Gravalog( _cPatch,  time()+" -     " + _cPostPed     )
        Gravalog( _cPatch,  time()+"" )

        // Criacao do objeto JSON para manipulacao das informacoes atraves do array aJsonPInfo
        oJson3      := tJsonParser():New()
        lRet        := oJson3:Json_Hash(_cPostPed, LEN(_cPostPed), @aJsonCli, @nRetParser3, @oJHM3)

        IF  lRet .AND. ValType( aJsonCli ) <> "U" .AND. Len( aJsonCli ) > 0
            _cAuxData := aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Cnpj'}) ][2]
            _cAuxData := Iif( ValType( _cAuxData ) == "U", "", _cAuxData )
        else
            _cAuxData := ""
        EndIf 
    Else 
        _cAuxData := ""
    EndIf

    // Com o resultado da busca do Cpf ou Cnpj, localiza o SA1 - Cliente
    IF  !Empty( _cAuxData )

        _lxSA1 := SA1->( DbSeek( xFilial("SA1") + _cAuxData ) )  // A1_FILIAL + A1_CGC

        _aAuxData := {}
        _xCGC     := _cAuxData

        _aAuxData := aClone( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Address'}) ][2] )
        _aAuxData := Iif( ValType( _aAuxData ) == "U", {}, _aAuxData )        

        // Verifica se existem informacoes a serem processaas no array 'Address' do Web Service
        IF  Len( _aAuxData ) > 0

            // TRata cada endereço individualmente
            For _nY := 1 to Len( _aAuxData )

                // Armazena o CEP do endereco processado 'PostalCode'
                _cAuxData := _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'PostalCode'}) ][2]
            
                // Verifica se este eh o endereco principal a ser comparado com o cadatro do cliente na SA1
                IF  _aAuxData[_nY][2][ aScan( _aAuxData[_nY][2], {|x| x[1] == 'MainAddress'}) ][2]

                    // Caso exista o cliente cadastrado...
                    IF  _lxSA1 
                        Gravalog( _cPatch,  time()+" -        > Cliente CPF/CNPJ " + Alltrim( SA1->A1_CGC) + " encontrado na tabela SA1 !!!" )

                        IF  Alltrim( _cAuxData ) <> Alltrim( SA1->A1_CEP )  // ...verifica se o CEP do cliente cadastrado no SA1 eh diferente do CEP do web service...

                            Gravalog( _cPatch,  time()+" -           >> CEP " + Alltrim(_cAuxData) + " é diferente do CEP informado no cadastro do cliente [A1_CEP = " + Alltrim( SA1->A1_CEP ) + "] Atualizando..." )
                        
                            DbSelectArea('CC2')
                            DbSetOrder(2)
                            CC2->(DBSEEK(xFilial('CC2')+Padr(UPPER( Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'City' }) ][2] ) ), TamSx3("CC2_MUN")[1])))
                            
                            Reclock("SA1",.F.)
                                SA1->A1_END     :=  Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'AddressLine'  }) ][2] )  + ;
                                                    Iif( !Empty(Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Number'       }) ][2] ) ) ,;
                                                        ', ' +  Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Number'       }) ][2] )   , "" )
                                SA1->A1_CEP     := Alltrim(Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'PostalCode'    }) ][2] )	)
                                SA1->A1_COMPLEM := Alltrim( Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'AddressNotes'  }) ][2] )   )                                
                                SA1->A1_EST     := Alltrim(CC2->CC2_EST)
                                SA1->A1_MUN     := Alltrim(CC2->CC2_MUN)
                                SA1->A1_COD_MUN := Alltrim(CC2->CC2_CODMUN)
                                SA1->A1_BAIRRO  := Alltrim( Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Neighbourhood' }) ][2] )   )
                            SA1->( MsUnlock() )

                            Gravalog( _cPatch,  time()+" -           >> ... concluído!" )
                            Gravalog( _cPatch,  time()+"" )
                        EndIf

                    //... caso o cliente não exista no cadastro...
                    Else
                        Gravalog( _cPatch,  time()+" -        > Cliente CPF/CNPJ " + Iif( 'GetPerson' $ _cURL, aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Cpf'}) ][2], aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Cnpj'}) ][2] ) + " NÃO encontrado na tabela SA1 !!! Incluindo..." ) 

                        // Define o código do cliente conforme rotina utilizada pela KingStar para definir o código conforme a LOJA e CPJ/CNPJ
                        _cCodSA1  := GetSxeNum("SA1","A1_COD")

                        _cTipoRes := Upper( Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Name'   }) ][2] ) )

                        If  !Empty(_cTipoRes)
                            Do  Case 
                                Case _cTipoRes == "CASA"    
                                    _cTipoRes := "1"

                                Case _cTipoRes $ "PREDIO|APARTAMENTO"
                                    _cTipoRes := "2"

                                OtherWise
                                    _cTipoRes := "5"
                            EndCase 
                        Else 
                            _cTipoRes := "5"    // 1=Casa; 2=Predio; 3=Condominio de Casas; 4=Viela; 5=Indefinido
                        EndIf 
                
                        aMata030	:= {}
                        
                        cCGC:= Iif( 'GetPerson' $ _cURL, aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Cpf'}) ][2], aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Cnpj'}) ][2] )    
                        
                        DbSelectArea('CC2')
                        DbSetOrder(2)
                        if CC2->(DBSEEK(xFilial('CC2')+Padr(UPPER( Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'City' }) ][2] ) ), TamSx3("CC2_MUN")[1])))
                            lDeuCerto := .F.	
                            //Pegando o modelo de dados, setando a operação de inclusão
                            oModel := FWLoadModel("MATA030")
                            oModel:SetOperation(3)
                            oModel:Activate() 
                            //Pegando o model dos campos da SA1                        
                            oSA1Mod:= oModel:getModel("MATA030_SA1")
                            oSA1Mod:setValue("A1_LOJA"	    ,'01'                                               	)
                            oSA1Mod:setValue("A1_PESSOA"	,Iif( 'GetPerson' $ _cURL, "F", "J")    				)
                            oSA1Mod:setValue("A1_TIPO"    	,"F"					                                )
                            oSA1Mod:setValue("A1_NOME"      ,Upper(Alltrim(aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Name'}) ][2])) + Iif( 'GetPerson' $ _cURL, " " + Upper(Alltrim(aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Surname'}) ][2])), " ")  )
                            oSA1Mod:setValue("A1_NREDUZ"	,PADR(Upper(Alltrim(aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Name'}) ][2])) + Iif( 'GetPerson' $ _cURL, " " + Upper(Alltrim(aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Surname'}) ][2])), " "),TAMSX3('A1_NREDUZ')[1]))
                            oSA1Mod:setValue("A1_END"       ,  Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'AddressLine'  }) ][2] )  + ;
                                                            Iif( !Empty(Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Number'       }) ][2] ) ) ,;
                                                            ', ' +  Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Number'       }) ][2] )   , "" ) ) 
                            oSA1Mod:setValue("A1_EMAIL"     ,aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Email'  }) ][2] ) 
                            oSA1Mod:setValue("A1_EST"		,Padr(CC2->CC2_EST,       TamSx3("A1_EST")[1])	  )
                            oSA1Mod:setValue("A1_MUN"		,Padr(CC2->CC2_MUN,       TamSx3("A1_MUN")[1])	  ) 
                            oSA1Mod:setValue("A1_COD_MUN"	,Padr(CC2->CC2_CODMUN,    TamSx3("A1_COD_MUN")[1])) 				 
                            oSA1Mod:setValue("A1_BAIRRO"	,Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'Neighbourhood' }) ][2] )     )	
                            oSA1Mod:setValue("A1_CEP"		,Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'PostalCode'    }) ][2] )		)
                            oSA1Mod:setValue("A1_COMPLEM"	, Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'AddressNotes'  }) ][2] )    )                               
                            oSA1Mod:setValue("A1_PAIS"	    ,"105"    )                         
                            oSA1Mod:setValue("A1_CGC"       , cCGC    )
                            oSA1Mod:setValue("A1_TEL"		,aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'Phone'})][2])
                            oSA1Mod:setValue("A1_TELEX"		,Iif(  !Empty(aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'CellPhone'   })][2] ) ,;  
                                                                        aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'CellPhone'   })][2]   ,; 
                                                                        aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'Phone'       })][2] ) )
                            oSA1Mod:setValue("A1_FAX"		, Iif(  !Empty(aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'CellPhone'   })][2] ) ,;  
                                                                        aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'CellPhone'   })][2]   ,; 
                                                                        aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2][aScan( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Contact'})+1 ][2], {|x| x[1] == 'Phone'       })][2] ) )
                            oSA1Mod:setValue("A1_CODPAIS"	,"01058"  )
                            oSA1Mod:setValue("A1_VEND"	    ,cVendEco )		
                            oSA1Mod:setValue("A1_X_FORMP"	,'CC'     )		
                            oSA1Mod:setValue("A1_TRANSP"	,'000005' )		
                            oSA1Mod:setValue("A1_NATUREZ"	,'1001A'  )		
                            oSA1Mod:setValue("A1_X_PRIOR"	,'3'      )		                        		
                            oSA1Mod:setValue("A1_DTCAD"	    ,dDatabase)		
                            oSA1Mod:setValue("A1_COND"	    ,'000'    )	
                            oSA1Mod:setValue("A1_DTNASC"	,Iif( 'GetPerson' $ _cURL, U_MSToDate( StrTran( StrTran( aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'BirthDate'}) ][2],"/Date(",""  ),"-0300)/","" ) )[1], dDatabase ) )
                            oSA1Mod:setValue("A1_INSCR"	    ,'ISENTO')
                            oSA1Mod:setValue("A1_INSCRM"	,'ISENTO')	
                            oSA1Mod:setValue("A1_TPFRET"	,'C'     )
                            oSA1Mod:setValue("A1_TIPCLI"	,'1'     )
                            oSA1Mod:setValue("A1_EMAIL"	    ,aJsonCli[1][2][ aScan( aJSonCli[1][2], {|x| x[1] == 'Email'  }) ][2])                        
                            oSA1Mod:setValue("A1_HRCAD"	    ,Substr( Time(), 1, 5)  )		
                            oSA1Mod:setValue("A1_SATIV1"	,'000001')		
                            //Se conseguir validar as informações
                            If oModel:VldData()		
                                //Tenta realizar o Commit
                                If oModel:CommitData()
                                    lDeuCerto := .T.			
                                //Se não deu certo, altera a variável para false
                                Else
                                    lDeuCerto := .F.
                                EndIf		
                            //Se não conseguir validar as informações, altera a variável para false
                            Else
                                lDeuCerto := .F.
                            EndIf  
                        //Se não deu certo a inclusão, mostra a mensagem de erro
                            If ! lDeuCerto
                                //Busca o Erro do Modelo de Dados
                                aErro := oModel:GetErrorMessage()		
                                //Monta o Texto que será mostrado na tela
                                Gravalog( _cPatch,"Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
                                Gravalog( _cPatch,"Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
                                Gravalog( _cPatch,"Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
                                Gravalog( _cPatch,"Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
                                Gravalog( _cPatch,"Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
                                Gravalog( _cPatch,"Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
                                Gravalog( _cPatch,"Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
                                Gravalog( _cPatch,"Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
                                Gravalog( _cPatch,"Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')		
                            else
                                SA1->(DbSetOrder(3))
                                SA1->(DbSeek(cCGC))
                                cCodCli:= SA1->A1_COD
                                cLojCli:= SA1->A1_LOJA			
                            endif
                                //Desativa o modelo de dados
                            oModel:DeActivate()
                        ELSE
                            Gravalog( _cPatch,"Municipio não encontrado: "+UPPER( Alltrim( _aAuxData[_nY][2][ aScan( _aAuxData[1][2], {|x| x[1] == 'City' }) ][2] ) ))
                        ENDIF                        
                    EndIf 
                EndIf 
            Next
        EndIf 
    EndIf 

Return( {_xCGC, _lxSA1} )


// Retorna a data e hora da timestamp em milisegundos desde 01/01/1970
// Recebe o valor de milisegundo em formato caracter e retorna array [1] Data e [2] hora

User Function MsToDate( _cMS )

    Local _aRet     := {}
    Local _dDate    := CTOD("")
    Local _cTime    := ""
    Local _nMS      := 0
    Local _nX       := 0
    Local _aAux     := {}
    Local _lSummer  := SuperGetMV( "MV_HVERAO", Nil, .F. )  // Parametro padrao que indica se considera ou nao horario de verao

    // Converte a string de milisengundos em valor numerico
    _nMS    := Val( _cMS )

    // Monta array com quantidade padrao de milisegundo pos unidade (dia, horas, etc)
    //           Unidade  qtd de ms  qtd  saldo ms
    _aAux   := {{"dia"  , 86400000  , 0 , 0 }   ,;
                {"hrs"  , 3600000   , 0 , 0 }   ,;
                {"min"  , 60000     , 0 , 0 }   ,;
                {"seg"  , 1000      , 0 , 0 }   ,;
                {"mseg" , 1         , 0 , 0 }    }

    // Se a data eh superior a 01/01/1970
    If  _nMS > 0

        For _nX := 1 to Len( _aAux )
            If  _nX == 1    // Dias - definicao da data
                _aAux[_nX][3] := Int( _nMs /   _aAux[_nX][2] )                              // Valor inteiro da quantidade em milisegundos
                _aAux[_nX][4] :=      _nMs - ( _aAux[_nX][3] * _aAux[_nX][2] )              // Saldo de milisegundos a serem computados

                _dDate := CTOD("01/01/1970") + _aAux[_nX][3]                                // Uma vez identificado a quantidade de dias, somam-se os dias apartir de 01/01/1970 e define a data
            Else
                _aAux[_nX][3] := Int( _aAux[_nX-1][4] /   _aAux[_nX][2] )                   // Valor inteiro da quantidade em milisegundos
                _aAux[_nX][4] :=      _aAux[_nX-1][4] - ( _aAux[_nX][3] * _aAux[_nX][2] )   // Saldo de milisegundos a serem computados
            EndIf 
        Next _nX

        // Atualiza a hora de acordo com o parametro padrao MV_HVERAO (true/false)
        _aAux[2][3] -= Iif( _lSummer, 2, 3 )

        // Ajusta data e hora - Se a hora for inferior a zero (conseiderando o horário de verao), subtrai de 24 e volta 1 dia na data.
        If  _aAux[2][3] < 0
            _aAux[2][3] := 24 - ( _aAux[2][3] * (-1) )
            _dDate -= 1
        EndIf 

        // Define a hora concatenando os valores de cada unidade definida - hora : minuto : segundo
        _cTime := StrZero( _aAux[2][3] ,2) + ":" + StrZero( _aAux[3][3] ,2) + ":" + StrZero( _aAux[4][3] ,2)
    Else 
        // Se a quantidade de milisegundos for igual ou menos do que ZERO, retorna array com data e hora vazias
        IF  _nMS = 0
            _dDate := CTOD("01/01/1970")
            _cTime := "00:00:00"
        Else 
            _nMS := _nMS * (-1) // Troca p sinal para abater da data 01/01/1970

            _aAux[1][3] := Int( _nMs /   _aAux[1][2] )                              // Valor inteiro da quantidade em milisegundos
            _aAux[1][4] :=      _nMs - ( _aAux[1][3] * _aAux[1][2] )              // Saldo de milisegundos a serem computados

            _dDate := CTOD("01/01/1970") - _aAux[1][3]                                // Uma vez identificado a quantidade de dias, somam-se os dias apartir de 01/01/1970 e define a data

            If  _aAux[1][4] > 0
                _dDate := _dDate - 1
            EndIf 

            _cTime := "00:00:00"
        EndIf 
    EndIf 

    // Monta o array para retorno
    aAdd( _aRet, _dDate )   // Data
    aAdd( _aRet, _cTime )   // Hora

Return _aRet


// Function    : Gravalog
// Description : Funcao estatica que realiza a gravacao do arquivo de log

static function Gravalog(cFile,cText)

    local nHandle

    cText += chr(13) + chr(10)

    if !file(cFile)
        if (nHandle := fCreate(cFile, 1)) = -1
            Conout("Arquivo nao foi criado: ("+cFile+")")
        else
            fWrite(nHandle, cText)
            fClose(nHandle)
        endif
    else
        nHandle := fOpen(cFile, 2)
        nLength := fSeek(nHandle, 0, 2)

        if nLength+len(cText)>=1048580

            fClose(nHandle)

            IF fRename(cFile, cFile+"."+dtos(date())+"-"+alltrim(str(seconds()))) = -1
                Conout("Arquivo nao foi renomeado: ("+cFile+")")
            endif

            gravalog(cFile,cText)
        endif

        if fError() != 0
            Conout("Arquivo nao foi aberto: ("+cFile+")")
        else
            cText := fReadStr(nHandle,nLength) + cText
            fWrite(nHandle, cText)
            fClose(nHandle)
        endif
    endif

return

// +--------------------------------------------------------------------------------------------------+
// ³ Funcao para Gravar o Contato com os dados do Cliente.											  ³
// +--------------------------------------------------------------------------------------------------+

Static Function _oGravaSU5()

	Local _aArea		:= GetArea()
	Local _cCodContt	:= CriaVar( "U5_CODCONT", .F. )
	Local _cCodAGA		:= CriaVar( "AGA_CODIGO", .F. )
	Local _cCodAGB		:= CriaVar( "AGB_CODIGO", .F. )
	Local _cEndeCli	    := CriaVar( "A1_END"	, .F. )
	Local _cEndEntr	    := CriaVar( "A1_XEND"	, .F. )
	Local _cTelRes		:= _cCodAGB
	Local _cTelCel		:= _cCodAGB
	Local _cTelCom      := ""
	Local _cFilSA1      := xFilial("SA1")

	_cEndeCli	:= SA1->A1_END
	_cEndEntr	:= SA1->A1_XEND

	DbSelectArea( "SU5" )
	DbSetOrder( 1 )			// U5_FILIAL+U5_CODCONT+U5_IDEXC

	_cCodContt	:= GetSXENum( "SU5", "U5_CODCONT" )

	RecLock( "SU5", .T. )
	SU5->U5_FILIAL	:= _cFilSA1
	SU5->U5_CODCONT	:= _cCodContt
	SU5->U5_XPF_PJ	:= SA1->A1_PESSOA
	SU5->U5_CPF		:= SA1->A1_CGC
	SU5->U5_CONTAT	:= SA1->A1_NOME
	SU5->U5_EMAIL	:= Iif( Empty( SA1->A1_EMAIL ), "@", Lower( SA1->A1_EMAIL ) )
	SU5->U5_END		:= AllTrim( Upper( SA1->A1_END    ) )
	SU5->U5_BAIRRO	:= AllTrim( Upper( SA1->A1_BAIRRO ) )
	SU5->U5_MUN		:= AllTrim( Upper( SA1->A1_MUN    ) )
	SU5->U5_EST		:= SA1->A1_EST
	SU5->U5_CEP		:= SA1->A1_CEP
	SU5->U5_DDD		:= SA1->A1_DDD
	SU5->U5_ATIVO	:= "1"                              // Precisa criar o contato como Ativo = '1' para o contato aparecer nas telas do atendimento
	SU5->U5_CLIENTE	:= SA1->A1_COD
	SU5->U5_LOJA	:= SA1->A1_LOJA
	SU5->U5_DDD		:= Iif( ! Empty( SA1->A1_DDD   ), SA1->A1_DDD,   "" )
	SU5->U5_FONE	:= Iif( ! Empty( SA1->A1_TEL   ), SA1->A1_TEL,   "" )
	SU5->U5_CELULAR	:= Iif( ! Empty( SA1->A1_TELEX ), AllTrim( Right( SA1->A1_TELEX, 13 ) ), "" )
	SU5->U5_FCOM1	:= Iif( ! Empty( SA1->A1_FAX   ), SA1->A1_FAX,   "" )
	SU5->( MsUnLock() )

	ConfirmSX8()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cadastro de Enderecos de Contatos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "AGA" )

	_cCodAGA := GetSXENum( "AGA", "AGA_CODIGO" )

	RecLock( "AGA", .T. )
	AGA->AGA_FILIAL	:= _cFilSA1
	AGA->AGA_CODIGO	:= _cCodAGA
	AGA->AGA_ENTIDA	:= "SU5"
	AGA->AGA_CODENT	:= _cCodContt
	AGA->AGA_TIPO	:= "2"
	AGA->AGA_PADRAO	:= "1"
	AGA->AGA_END	:= AllTrim( Upper( SA1->A1_END ) )
	AGA->AGA_CEP	:= SA1->A1_CEP
	AGA->AGA_BAIRRO	:= Upper( SA1->A1_BAIRRO )
	AGA->AGA_MUNDES	:= Upper( SA1->A1_MUN )
	AGA->AGA_EST	:= SA1->A1_EST
	AGA->AGA_MUN	:= SA1->A1_COD_MUN
	AGA->AGA_PAIS	:= SA1->A1_PAIS
	AGA->AGA_COMP	:= SA1->A1_COMPLEM
	AGA->AGA_XINCPE	:= "S"
	AGA->( MsUnLock() )

	ConfirmSX8()

	DbSelectArea( "AGB" )
	DbSetOrder( 1 )			// AGA_FILIAL+AGA_ENTIDA+AGA_CODENT+AGA_TIPO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao de Telefone Fixo (residencial) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! Empty( SA1->A1_TEL )
		_cCodAGB := GetSXENum( "AGB", "AGB_CODIGO" )

		RecLock( "AGB", .T. )
		AGB->AGB_FILIAL	:= _cFilSA1
		AGB->AGB_CODIGO	:= _cCodAGB
		AGB->AGB_ENTIDA	:= "SU5"
		AGB->AGB_CODENT	:= _cCodContt
		AGB->AGB_TIPO	:= "2"			// 2=Residencial
		AGB->AGB_PADRAO	:= "1"			// 1=Sim (padrao)
		AGB->AGB_DDD	:= SA1->A1_DDD
		AGB->AGB_TELEFO	:= SA1->A1_TEL
		AGB->AGB_XINCPE	:= "S"
		AGB->( MsUnLock() )

		ConfirmSX8()

		_cTelRes := AGB->AGB_CODIGO
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao de Telefone Celular ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! Empty( SA1->A1_TELEX )

		_cCodAGB := GetSXENum( "AGB", "AGB_CODIGO" )

		RecLock( "AGB", .T. )
		AGB->AGB_FILIAL	:= _cFilSA1
		AGB->AGB_CODIGO	:= _cCodAGB
		AGB->AGB_ENTIDA	:= "SU5"
		AGB->AGB_CODENT	:= _cCodContt
		AGB->AGB_TIPO	:= "5"  // 5=Celular
		AGB->AGB_PADRAO	:= "2"  // 2=Nao (nao padrao)
		AGB->AGB_DDD	:= StrZero( Val( Left( SA1->A1_TELEX, 2 ) ), 3 )
		AGB->AGB_TELEFO	:= AllTrim( Right( SA1->A1_TELEX, 13 ) )
		AGB->AGB_XINCPE	:= "S"
		AGB->( MsUnLock() )

		ConfirmSX8()

		_cTelCel := AGB->AGB_CODIGO
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao de Telefone Comercial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! Empty( SA1->A1_FAX )

		_cCodAGB := GetSXENum( "AGB", "AGB_CODIGO" )

		RecLock( "AGB", .T. )
		AGB->AGB_FILIAL	:= _cFilSA1
		AGB->AGB_CODIGO	:= _cCodAGB
		AGB->AGB_ENTIDA	:= "SU5"
		AGB->AGB_CODENT	:= _cCodContt
		AGB->AGB_TIPO	:= "1"			// 1=Comercial
		AGB->AGB_PADRAO	:= "2"			// 2=Nao (nao padrao)
		AGB->AGB_DDD	:= SA1->A1_DDD
		AGB->AGB_TELEFO	:= SA1->A1_FAX
		AGB->AGB_XINCPE	:= "S"
		AGB->( MsUnLock() )

		ConfirmSX8()

		_cTelCom  :=  AGB->AGB_CODIGO
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o campo U5_CODAGA no SU5 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "SU5" )

	RecLock( "SU5", .F. )
	SU5->U5_CODAGA	:= AGA->AGA_CODIGO
	SU5->U5_AGBRES	:= _cTelRes
	SU5->U5_AGBCEL	:= _cTelCel
	SU5->U5_AGBCOM	:= _cTelCom
	SU5->( MSUnlock() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cadastro de Relacao de Contatos x Entidades ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "AC8" )
	DbSetOrder( 1 )			// AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT

	RecLock( "AC8", .T. )
	AC8->AC8_FILIAL	:= xFilial( "AC8" )
	AC8->AC8_FILENT	:= _cFilSA1
	AC8->AC8_ENTIDA	:= "SA1"
	AC8->AC8_CODENT	:= ( SA1->A1_COD + SA1->A1_LOJA )
	AC8->AC8_CODCON	:= _cCodContt
	AC8->( MsUnLock() )

// Verifica o Endereco de entrega para gerar novo contato se necessario
	If _cEndeCli # _cEndEntr

		DbSelectArea( "SU5" )
		DbSetOrder( 1 )			// U5_FILIAL+U5_CODCONT+U5_IDEXC

		_cCodContt	:= GetSXENum( "SU5", "U5_CODCONT" )

		RecLock( "SU5", .T. )
		SU5->U5_FILIAL	:= _cFilSA1
		SU5->U5_CODCONT	:= _cCodContt
		SU5->U5_XPF_PJ	:= SA1->A1_PESSOA
		SU5->U5_CPF		:= SA1->A1_CGC
		SU5->U5_CONTAT	:= SA1->A1_NOME
		SU5->U5_EMAIL	:= Iif( Empty( SA1->A1_EMAIL ), "@", Lower( SA1->A1_EMAIL ) )
		SU5->U5_END		:= SA1->A1_XEND     //+ ", " + _cNumEntr
		SU5->U5_BAIRRO	:= SA1->A1_BAIRRO
		SU5->U5_MUN		:= SA1->A1_MUN
		SU5->U5_EST		:= SA1->A1_EST
		SU5->U5_CEP		:= SA1->A1_CEP
		SU5->U5_DDD		:= SA1->A1_DDD
		SU5->U5_ATIVO	:= "1"                              // Precisa criar o contato como Ativo = '1' para o contato aparecer nas telas do atendimento
		SU5->U5_CLIENTE	:= SA1->A1_COD
		SU5->U5_LOJA	:= SA1->A1_LOJA
		SU5->U5_DDD		:= Iif( ! Empty( SA1->A1_DDD   ), SA1->A1_DDD,   "" )
		SU5->U5_FONE	:= Iif( ! Empty( SA1->A1_TEL   ), SA1->A1_TEL,   "" )
		SU5->U5_CELULAR	:= Iif( ! Empty( SA1->A1_TELEX ), AllTrim( Right( SA1->A1_TELEX, 13 ) ), "" )
		SU5->U5_FCOM1	:= Iif( ! Empty( SA1->A1_FAX   ), SA1->A1_FAX,   "" )
		SU5->( MsUnLock() )

		ConfirmSX8()
	EndIf

	RestArea( _aArea )		// Retorna para area principal do processamento

Return



User Function SLECMANUAL( lSched, _oSay )

Local _lRet := .F.

Default lSched 	:= .F.

_oSay:SetText("Integrando Pedido e-Commerce - Data" + DTOC(dDatabase) + " - Hora: " + Time() )

_lRet := StartJob( "U_SLPEDIDOS", GetEnvServer(), .T., "Data" + DTOC(dDatabase) + " - Hora: " + Time() )

IF _lRet 
    Alert( "Processo realizado com sucesso!!! - Consulte arquivo de log em \Ecommerce\integra_pedidos_ecommerce_DATA_HORA.log" )
    _lRet := StartJob( "U_SLINTPZU", GetEnvServer(), .T., "Data" + DTOC(dDatabase) + " - Hora: " + Time() )
    IF _lRet
        Alert( "Processo realizado com sucesso!!!" )
    else
        Alert( "Processo Financeiro/Pedido retornou erro!!! - Verifique" )  
    endif
Else
    Alert( "Processo retornou erro!!! - Verifique" )
EndIf 

Return 


/*
Function    : SLINTLNX
Description : Execução manual da rotina SLPEDIDOS de download dos pedidos e-commerce da Linx para PZU e PZV e SLINTPZU geração de PV e financeiro
*/
User Function SLINTLNX()
	Local _oSay

	FwMsgRun( NIL, { |_oSay| U_SLPEDIDOS( .F. ) }, , "Processando pedidos e-Commerce Linx..." )
    FwMsgRun( NIL, { |_oSay| U_SLINTPZU( .F. ) }, , "Processando Pedido de vendas e Financeiro..." )

Return Nil
