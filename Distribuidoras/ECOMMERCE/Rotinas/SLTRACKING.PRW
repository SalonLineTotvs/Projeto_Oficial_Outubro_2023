#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch" 

/*
Function    :   KSECOJ01
Date        :   2023, JUL 07th - 
Author      :   GUSTAVO
Description :   Job de leitura das informações do Nota Fiscal da venda e-commerce e envio à plataforma Linx

Metodo: SetOrderInvoice


*/

User Function SLTRACKING()

Local _cQuery       := ""
Local _cAlias       := "TRB"
Local _cHrIni	    := ""
Local _cPath	    := ""
Local _cDtRef       := ""
Local _cHeadRet     := ''
Local _cHeadRet2    := ''
Local _cHeadRet3    := ''
Local oJson         := ''                               
Local oJson2        := ''                               
Local oJson3        := ''
Local oJHM 		    := .F.
Local oJHM2		    := .F.
Local oJHM3		    := .F.
Local _cPostNfe     := ''
Local _cPostCnf     := ''
Local nRetParser    := 0                          
Local nRetParser2   := 0                          
Local nRetParser3   := 0 
Local _nTimeOut     := 120
Local lRet 		    := .F.            
Local aJsonNFe      := {}    
Local aJsonCnf      := {}    
Local aHeadOut      := {}                           
Local _cUrl         := ""
Local _cUrl2        := ""
Local _cUrl3        := ""
Local _cXML         := ""
Local _cXML2        := ""
Local _cXML3        := ""
Local _nX           := 0
Local cVendEco		:= ""
Local _lxPZX        := .F. 


Prepare Environment Empresa "02" Filial "1501" Modulo "FAT"   

_cHrIni	 := StrTran( Time(), ":", "" )
_cPath	 := "\'Ecommerce\Integra_DANFE_eCommerce_"+DTOS(dDatabase)+"-"+_cHrIni+".log"
_cDtRef  := DTOC( dDatabase )


Gravalog( _cPath,  time()+" - Data: " + _cDtRef )
Gravalog( _cPath,  time()+"" )

Gravalog( _cPath,  time()+" - Início do processamento de integracao DANFE... " )
Gravalog( _cPath,  time()+"============================================" )
Gravalog( _cPath,  time()+"" )

 _cUserEcom	:= SuperGetMV( "SL_USRECOM", Nil, "samuel.nascimento@salonline.com.br" 	)
 _cPassEcom	:= SuperGetMV( "SL_PASECOM", Nil, "SalonLine@30042023" 	)
 _cAutentic	:= Encode64( Alltrim( _cUserEcom ) + ':' + Alltrim( _cPassEcom ) )

Aadd(aHeadOut,"Content-Type: application/json")   
Aadd(aHeadOut,"Accept: application/json") 				
Aadd(aHeadOut,"Authorization: Basic " + _cAutentic)


Gravalog( _cPath,  time()+" - Query de selecao dos pedidos e-commerce ")
Gravalog( _cPath,  time()+" - Pedidos e-commerce com status 7 - NFe Transmitida...")
Gravalog( _cPath,  time()+" ")

_cQuery := "select distinct "                                                       + CHR(13)+CHR(10)
_cQuery += "    PZU.PZU_ORIGEM, "                                                   + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_PEDECO, PZU.PZU_STATUS , PZU.PZU_NUM   , "                  + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_SERIE , PZU.PZU_DOC    , PZU.PZU_CHVNFE, PZU.PZU_CHVSF2, "  + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_CLIENT, PZU.PZU_LOJA   , PZU.R_E_C_N_O_ as RECPZU, "        + CHR(13)+CHR(10)
_cQuery += "	SF2.F2_FILIAL , SF2.F2_XPEDECO , "                                  + CHR(13)+CHR(10)
_cQuery += "	SF2.F2_SERIE  , SF2.F2_DOC     , SF2.F2_CHVNFE , "                  + CHR(13)+CHR(10)
_cQuery += "	SF2.F2_CLIENTE, SF2.F2_LOJA    , "                                  + CHR(13)+CHR(10)
_cQuery += "	SF2.R_E_C_N_O_ as RECSF2       , "                                  + CHR(13)+CHR(10)
_cQuery += "    SF3.F3_CFO "                                                        + CHR(13)+CHR(10)

_cQuery += "from "                                                                  + CHR(13)+CHR(10)
_cQuery += "	" + RetSQLName("PZU") + " PZU, "                                    + CHR(13)+CHR(10)
_cQuery += "	" + RetSQLName("SF2") + " SF2, "                                    + CHR(13)+CHR(10)
_cQuery += "	" + RetSQLName("SF3") + " SF3  "                                    + CHR(13)+CHR(10)

_cQuery += "where "                                                                 + CHR(13)+CHR(10)
_cQuery += "    PZU.PZU_STATUS = '7' "                                              + CHR(13)+CHR(10)            
_cQuery += "and	PZU.D_E_L_E_T_ = ''  "                                              + CHR(13)+CHR(10)
_cQuery += "and SF2.F2_XPEDECO = PZU.PZU_PEDECO "                                   + CHR(13)+CHR(10)
_cQuery += "and SF2.F2_CLIENTE = PZU.PZU_CLIENT "                                   + CHR(13)+CHR(10)
_cQuery += "and SF2.F2_LOJA    = PZU.PZU_LOJA   "                                   + CHR(13)+CHR(10)
_cQuery += "and SF2.D_E_L_E_T_ = '' "                                               + CHR(13)+CHR(10)
_cQuery += "and SF3.F3_CHVNFE  = PZU.PZU_CHVNFE "                                   + CHR(13)+CHR(10) 
_cQuery += "and SF3.D_E_L_E_T_ = '' "                                               + CHR(13)+CHR(10)

_cQuery += "order by "                                                              + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_PEDECO "                                                    + CHR(13)+CHR(10)

Gravalog( _cPath,  _cQuery   )
Gravalog( _cPath,  time()+" ")


DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cAlias,.T.,.T.)
DbSelectArea( _cAlias )
(_cAlias)->( DbGoTop() )


While	!(_cAlias)->(EOF())

        // Posiciona no documento de saida - SF2
        SF2->( DbGoTo( (_cAlias)->RECSF2 ) )

        // Posiciona no Pedido e-commerce - PZU
        PZU->( DbGoTo( (_cAlias)->RECPZU ) ) 


        IF  !PZU->( Eof() )

            // Monta o XML para a chamada do metodo de envio das informações da DANFE para a plataforma do e-comm. >>>>>>> SET ORDER INVOICE <<<<<<<<<<
            _cXML :='{'
            _cXML +='    "OrderID": null,'
            _cXML +='    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
            _cXML +='    "IsIssued": true,'
            _cXML +='    "Code": "'         + Alltrim(PZU->PZU_CHVNFE)      + '",'
            _cXML +='    "Url": null,'
            _cXML +='    "Series": "'       + Alltrim(PZU->PZU_SERIE)       + '",'
            _cXML +='    "CFOP": "'         + Alltrim((_cAlias)->F3_CFO)    + '",'
            _cXML +='    "Number": "'       + Alltrim(PZU->PZU_DOC)         + '",'
            _cXML +='    "XML": "'          + StrTran(Alltrim(PZU->PZU_XML),'"',"'")      + '"'
            _cXML +='}'
            
            //>>>>>>> SET ORDER INVOICE <<<<<<<<<<
            _cUrl := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_SET_ORDER_INVOI_TST/1.0/order/invoce/update"
                     

            Gravalog( _cPath,  time()+" - >>> Chamada do metodo SearchQueueItems para leitura dos pedidos da fila de integração... " )
            Gravalog( _cPath,  time()+" -        _cURL : " + _cUrl     )
            Gravalog( _cPath,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
            Gravalog( _cPath,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
            Gravalog( _cPath,  time()+" -     aHeadOut : [3] - Authorization: Basic  " + _cAutentic )
            Gravalog( _cPath,  time()+" -        _cXML : " + _cXML     )
            Gravalog( _cPath,  time()+"" )

                                                
            _cPostNfe := NoAcento( DeCodeUtf8( HttpsPost( _cUrl,"","","","", _cXML, _nTimeOut, aHeadOut, @_cHeadRet ) ) )


            Gravalog( _cPath,  time()+" - <<< Retorno do metodo SetOrderInvoice para leitura dos pedidos da fila de integração para gravacao da DANFE... " )
            Gravalog( _cPath,  time()+" -     " + _cPostNfe     )
            Gravalog( _cPath,  time()+" -     "                 )


            oJson    := tJsonParser():New()
            lRet     := oJson:Json_Hash(_cPostNfe, LEN(_cPostNfe), @aJsonNFe, @nRetParser, @oJHM)
            // aJsonPed - Array contendo os pedidos e-commerce disponiveis na fila de integracao da Linx

            cVendEco := SuperGetMV( "SL_VNDECOM", Nil, "000223" )

            //fim >>>>>>>>>>>>>UpdateRemarks<<<<<<<<<<<<<

            aJsonCnf := {}

            // Monta o XML para a chamada do metodo de classificacao do pedido para "faturado" >>>>>RunOrderWorkflow<<<<<
            _cXML2 := '{'
            _cXML2 += '    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
            _cXML2 += '    "WorkFlowID": 49,'
            _cXML2 += '    "Params": [] '
            _cXML2 += '}'
            
            //>>>>>RunOrderWorkflow<<<<<

            _cUrl2 := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_UPDA_ORDE_STAT_ERP_B2B/1.0/order/status/update"
                     
            Gravalog( _cPath,  time()+" - >>> Chamada do metodo RunOrderWorkflow para o faturamento dos pedidos da fila de integração... " )
            Gravalog( _cPath,  time()+" -        _cURL : " + _cUrl2     )
            Gravalog( _cPath,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
            Gravalog( _cPath,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
            Gravalog( _cPath,  time()+" -     aHeadOut : [3] - Authorization: Basic " + _cAutentic)
            Gravalog( _cPath,  time()+" -        _cXML : " + _cXML2     )
            Gravalog( _cPath,  time()+"" )

                                                
            _cPostCnf := NoAcento( DeCodeUtf8( HttpsPost( _cUrl2,"","","","", _cXML2, _nTimeOut, aHeadOut, @_cHeadRet2 ) ) )


            Gravalog( _cPath,  time()+" - <<< Retorno do metodo RunOrderWorkflow para o faturamento dos pedidos da fila de integração... " )
            Gravalog( _cPath,  time()+" -     " + _cPostCnf     )
            Gravalog( _cPath,  time()+" -     "                 )


            oJson2   := tJsonParser():New()
            lRet     := oJson2:Json_Hash(_cPostCnf, LEN(_cPostCnf), @aJsonCnf, @nRetParser2, @oJHM2)
            // aJsonCnf - Array contendo os pedidos e-commerce para o ajuste do status - Pedido faturado

            IF  lRet .AND. Len( aJsonCnf ) > 0

                For _nX := 1 to Len( aJsonCnf )

                    IF  aJsonCnf[_nx][2][2][2]
                        Gravalog( _cPath,  time()+" -     Pedido " + Alltrim(PZU->PZU_PEDECO) + " faturado com sucesso !!!" )
                        Gravalog( _cPath,  time()+" -     " )

                    Else 
                        Gravalog( _cPath,  time()+" -     Pedido " + Alltrim(PZU->PZU_PEDECO) + " não foi faturado, por favor verifique." )
                        Gravalog( _cPath,  time()+" -     " )

                    EndIf 

                Next 

            EndIf 
            //ENVIO INTELIPOST DADOS DA NF            
            u_SLINTELINF(PZU->PZU_PEDECO)
            //ENVIO INTELIPOST SOLICITANDO COLETA            
            u_SLINTELCOL(PZU->PZU_PEDECO)

        EndIf 

        (_cAlias)->( DbSkip() )

EndDo 

Gravalog( _cPath,  time()+" -  Fim do processamento de integracao DANFE... " )
Gravalog( _cPath,  time()+"=============================================== " )
Gravalog( _cPath,  time()+"" )


(_cAlias)->( DbCloseArea() )


Gravalog( _cPath,  time()+" - Início do processamento das entregas e retornos... " )
Gravalog( _cPath,  time()+"===================================================== " )
Gravalog( _cPath,  time()+"" )


Gravalog( _cPath,  time()+" - Query de selecao dos pedidos e-commerce ")
Gravalog( _cPath,  time()+" - Pedidos e-commerce com status C - Entregue /D  - Ausente /E  - Devolucao ou Sinistro...")
Gravalog( _cPath,  time()+" ")



_cQuery := "select "                                                                + CHR(13)+CHR(10)
_cQuery += "    PZU.PZU_ORIGEM, "                                                   + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_PEDECO, PZU.PZU_STATUS , PZU.PZU_NUM   , "                  + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_SERIE , PZU.PZU_DOC    , PZU.PZU_CHVNFE, PZU.PZU_CHVSF2, "  + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_CLIENT, PZU.PZU_LOJA   , PZU.R_E_C_N_O_ as RECPZU, "        + CHR(13)+CHR(10)
_cQuery += "	SF2.F2_FILIAL , SF2.F2_XPEDECO , "                                  + CHR(13)+CHR(10)
_cQuery += "	SF2.F2_SERIE  , SF2.F2_DOC     , SF2.F2_CHVNFE , "                  + CHR(13)+CHR(10)
_cQuery += "	SF2.F2_CLIENTE, SF2.F2_LOJA    , "                                  + CHR(13)+CHR(10)
_cQuery += "	SF2.R_E_C_N_O_ as RECSF2         "                                  + CHR(13)+CHR(10)

_cQuery += "from "                                                                  + CHR(13)+CHR(10)
_cQuery += "	" + RetSQLName("PZU") + " PZU, "                                    + CHR(13)+CHR(10)
_cQuery += "	" + RetSQLName("SF2") + " SF2  "                                    + CHR(13)+CHR(10)

_cQuery += "where "                                                                 + CHR(13)+CHR(10)
_cQuery += "    PZU.PZU_STATUS = 'C' "                                              + CHR(13)+CHR(10)            
_cQuery += "and PZU.PZU_DTENTR = ''  "                                              + CHR(13)+CHR(10)
_cQuery += "and	PZU.D_E_L_E_T_ = ''  "                                              + CHR(13)+CHR(10)
_cQuery += "and SF2.F2_XPEDECO = PZU.PZU_PEDECO "                                   + CHR(13)+CHR(10)
_cQuery += "and SF2.F2_CLIENTE = PZU.PZU_CLIENT "                                   + CHR(13)+CHR(10)
_cQuery += "and SF2.F2_LOJA    = PZU.PZU_LOJA   "                                   + CHR(13)+CHR(10)
_cQuery += "and SF2.D_E_L_E_T_ = '' "                                               + CHR(13)+CHR(10)

_cQuery += "order by "                                                              + CHR(13)+CHR(10)
_cQuery += "	PZU.PZU_PEDECO "                                                    + CHR(13)+CHR(10)

Gravalog( _cPath,  _cQuery   )
Gravalog( _cPath,  time()+" ")


DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cAlias,.T.,.T.)
DbSelectArea( _cAlias )
(_cAlias)->( DbGoTop() )


While   !(_cAlias)->(EOF())

        // Posiciona no Pedido e-commerce - PZU
        PZU->( DbGoTo( (_cAlias)->RECPZU ) ) 


        IF  !PZU->( Eof() )
                
            // Executa o metodo de classificação do pedido como "faturado"
            aJsonCnf := {}

            // Monta o XML para a chamada do metodo de classificacao do pedido para "faturado"

            Do  Case
                Case PZU->PZU_STATUS == "C" // Emtregue

                    If  Empty( PZU->PZU_PEDMKP )   

                        _cXML2 := '{'
                        _cXML2 += '    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
                        _cXML2 += '    "WorkFlowID": 51,'
                        _cXML2 += '    "Params": [] '
                        _cXML2 += '}'

                    Else     

                        // Se for Marketplace, executa antes o Workflow 50 para executar o 51 posteriormente...
                        _cXML2 := '{'
                        _cXML2 += '    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
                        _cXML2 += '    "WorkFlowID": 50,'
                        _cXML2 += '    "Params": ['
                        _cXML2 += '                {'
                        _cXML2 += '                   "Key": "TrackingNumber",'
                        _cXML2 += '                   "Value": "' + Alltrim(PZU->PZU_PEDMKP) + '"'
                        _cXML2 += '                }'
                        _cXML2 += '              ]'
                        _cXML2 += '}'


                        _cUrl2 := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_UPDA_ORDE_STAT_ERP_B2B/1.0/order/status/update"
                                
                        Gravalog( _cPath,  time()+" - >>> Chamada do metodo RunOrderWorkflow para o entrega dos pedidos da fila de integração... " )
                        Gravalog( _cPath,  time()+" -        _cURL : " + _cUrl2     )
                        Gravalog( _cPath,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
                        Gravalog( _cPath,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
                        Gravalog( _cPath,  time()+" -     aHeadOut : [3] - Authorization: Basic " + _cAutentic)
                        Gravalog( _cPath,  time()+" -        _cXML : " + _cXML2     )
                        Gravalog( _cPath,  time()+"" )

                                                            
                        _cPostCnf := NoAcento( DeCodeUtf8( HttpsPost( _cUrl2,"","","","", _cXML2, _nTimeOut, aHeadOut, @_cHeadRet2 ) ) )


                        Gravalog( _cPath,  time()+" - <<< Retorno do metodo RunOrderWorkflow para o entrega dos pedidos da fila de integração... " )
                        Gravalog( _cPath,  time()+" -     " + _cPostCnf     )
                        Gravalog( _cPath,  time()+" -     "                 )


                        oJson2   := tJsonParser():New()
                        lRet     := oJson2:Json_Hash(_cPostCnf, LEN(_cPostCnf), @aJsonCnf, @nRetParser2, @oJHM2)
                        // aJsonCnf - Array contendo os pedidos e-commerce para o ajuste do status - Pedido faturado

                        IF  lRet .AND. Len( aJsonCnf ) > 0

                            For _nX := 1 to Len( aJsonCnf )

                                IF  aJsonCnf[_nx][2][2][2]
                                    Gravalog( _cPath,  time()+" -     Pedido " + Alltrim(PZU->PZU_PEDECO) + " enviado com sucesso !!!" )
                                    Gravalog( _cPath,  time()+" -     " ) 

                                Else 
                                    Gravalog( _cPath,  time()+" -     Pedido " + Alltrim(PZU->PZU_PEDECO) + " não foi enviado, por favor verifique." )
                                    Gravalog( _cPath,  time()+" -     Erro > " + Alltrim(aJsonCnf[_nX][2][1][2][1][2][2][2]) )
                                    Gravalog( _cPath,  time()+" -     " )

                                EndIf 

                            Next 

                        EndIf 

                        aJsonCnf := {}
                        lRet     := .F.



                        _cXML2 := '{'
                        _cXML2 += '    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
                        _cXML2 += '    "WorkFlowID": 51,'
                        _cXML2 += '    "Params": ['
                        _cXML2 += '                {'
                        _cXML2 += '                   "Key": "TrackingNumber",'
                        _cXML2 += '                   "Value": "' + Alltrim(PZU->PZU_PEDMKP) + '"'
                        _cXML2 += '                }'
                        _cXML2 += '              ]'
                        _cXML2 += '}'


                    EndIf 

                Case PZU->PZU_STATUS == "D" // Ausente
                    _cXML2 := '{'
                    _cXML2 += '    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
                    _cXML2 += '    "WorkFlowID": 51,'
                    _cXML2 += '    "Params": [] '
                    _cXML2 += '}'

                Case PZU->PZU_STATUS == "E" // Devolucao / Sinistro
                    _cXML2 := '{'
                    _cXML2 += '    "OrderNumber": "'  + Alltrim(PZU->PZU_PEDECO)      + '",'
                    _cXML2 += '    "WorkFlowID": 51,'
                    _cXML2 += '    "Params": [] '
                    _cXML2 += '}'
            EndCase 


            _cUrl2 := "https://salonline-oic-homol-grroocqn4hzv-gr.integration.sa-saopaulo-1.ocp.oraclecloud.com/ic/api/integration/v1/flows/rest/EVT_TST_UPDA_ORDE_STAT_ERP_B2B/1.0/order/status/update"
                    
            Gravalog( _cPath,  time()+" - >>> Chamada do metodo RunOrderWorkflow para o entrega dos pedidos da fila de integração... " )
            Gravalog( _cPath,  time()+" -        _cURL : " + _cUrl2     )
            Gravalog( _cPath,  time()+" -     aHeadOut : [1] - Content-Type: application/json" )
            Gravalog( _cPath,  time()+" -     aHeadOut : [2] - Accept: application/json"       )
            Gravalog( _cPath,  time()+" -     aHeadOut : [3] - Authorization: Basic " + _cAutentic)
            Gravalog( _cPath,  time()+" -        _cXML : " + _cXML2     )
            Gravalog( _cPath,  time()+"" )

                                                
            _cPostCnf := NoAcento( DeCodeUtf8( HttpsPost( _cUrl2,"","","","", _cXML2, _nTimeOut, aHeadOut, @_cHeadRet2 ) ) )


            Gravalog( _cPath,  time()+" - <<< Retorno do metodo RunOrderWorkflow para o entrega dos pedidos da fila de integração... " )
            Gravalog( _cPath,  time()+" -     " + _cPostCnf     )
            Gravalog( _cPath,  time()+" -     "                 )


            oJson2   := tJsonParser():New()
            lRet     := oJson2:Json_Hash(_cPostCnf, LEN(_cPostCnf), @aJsonCnf, @nRetParser2, @oJHM2)
            // aJsonCnf - Array contendo os pedidos e-commerce para o ajuste do status - Pedido faturado

            IF  lRet .AND. Len( aJsonCnf ) > 0

                For _nX := 1 to Len( aJsonCnf )

                    IF  aJsonCnf[_nx][2][2][2]
                        Gravalog( _cPath,  time()+" -     Pedido " + Alltrim(PZU->PZU_PEDECO) + " entregue com sucesso !!!" )
                        Gravalog( _cPath,  time()+" -     " ) 

                        Reclock("PZU", .F. )
                            PZU->PZU_DTENTR := dDatabase 
                        PZU->( MsUnlock() )

                    Else 
                        Gravalog( _cPath,  time()+" -     Pedido " + Alltrim(PZU->PZU_PEDECO) + " não foi entregue, por favor verifique." )
                        Gravalog( _cPath,  time()+" -     Erro > " + Alltrim(aJsonCnf[_nX][2][1][2][1][2][2][2]) )
                        Gravalog( _cPath,  time()+" -     " )

                    EndIf 

                Next 

            EndIf 

        EndIf 

        (_cAlias)->( DbSkip() )
EndDo 
    // fim >>>>>RunOrderWorkflow<<<<<

Gravalog( _cPath,  time()+" -  Fim do processamento das entregas e retornos... " )
Gravalog( _cPath,  time()+"=================================================== " )
Gravalog( _cPath,  time()+"" )

RESET Environment

Return 

// Function    : Gravalog
// Description : Funcao estatica que realiza a gravacao do arquivo de log

static function Gravalog(cFile,cText)

local nHandle

cText += chr(13) + chr(10)

if !file(cFile)
    if (nHandle := fCreate(cFile, 1)) = -1
        Conout("Arquivo nao foi criado: ("+cFile+")")
        //msgAlert(fError())
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
            //msgAlert(fError())
        endif
        
        gravalog(cFile,cText)
        
    endif
    
    if fError() != 0
        Conout("Arquivo nao foi aberto: ("+cFile+")")
        //msgAlert(fError())
    else
        cText := fReadStr(nHandle,nLength) + cText
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif
endif

return

