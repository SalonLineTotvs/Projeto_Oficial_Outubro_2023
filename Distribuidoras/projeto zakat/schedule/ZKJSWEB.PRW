#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"

#DEFINE  ENTER CHR(13)+CHR(10)

User Function JSZAKAT()
    Local _cUrl         :="http://10.50.2.10:8002/ZKJSWEB"
    Local aHeadOut      := {}
    Local _nTimeOut     := 120
    Local _cHeadRet     := ''
    Local _cPostProd    := ''
    Local aJson         := {}
    Local oJHM 	        := .F.
    Local nRetParser    := 0
    aAdd( aHeadOut, "Content-Type: text/plain" )
    
    PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" 
cText:='{"chavelayout":"vi_int_or_lote_i","list":[{"or":"9152","codigoproduto":"26625","qtde":"1344","estado":"N","codproduto":"26625","lote":"008983","f":"*","barra":"27898009430907","vencimento":"25042026","codintegracaosetor":"MASTER","vlrunit":"000000006,28","codreferencia":"43090","qtde2":"1344","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26366","qtde":"696","estado":"N","codproduto":"26366","lote":"324485","f":"*","barra":"27898524349272","vencimento":"15052026","codintegracaosetor":"MASTER","vlrunit":"000000003,86","codreferencia":"34927","qtde2":"696","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26325","qtde":"1980","estado":"N","codproduto":"26325","lote":"325421","f":"*","barra":"17908458317094","vencimento":"31052026","codintegracaosetor":"MASTER","vlrunit":"000000001,99","codreferencia":"31709","qtde2":"1980","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26377","qtde":"2880","estado":"N","codproduto":"26377","lote":"326809","f":"*","barra":"17898623951195","vencimento":"21062026","codintegracaosetor":"MASTER","vlrunit":"000000004,43","codreferencia":"95119","qtde2":"2880","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26247","qtde":"1860","estado":"N","codproduto":"26247","lote":"325667","f":"*","barra":"27898524345090","vencimento":"05062026","codintegracaosetor":"MASTER","vlrunit":"000000003,71","codreferencia":"34509","qtde2":"1860","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26378","qtde":"480","estado":"N","codproduto":"26378","lote":"325503","f":"*","barra":"17898623956794","vencimento":"02062026","codintegracaosetor":"MASTER","vlrunit":"000000007,39","codreferencia":"95679","qtde2":"480","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26213","qtde":"960","estado":"N","codproduto":"26213","lote":"325636","f":"*","barra":"17898623950761","vencimento":"05062026","codintegracaosetor":"MASTER","vlrunit":"000000007,81","codreferencia":"95076","qtde2":"960","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26376","qtde":"960","estado":"N","codproduto":"26376","lote":"326707","f":"*","barra":"17898623950044","vencimento":"19062026","codintegracaosetor":"MASTER","vlrunit":"000000005,55","codreferencia":"95004","qtde2":"960","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26626","qtde":"1344","estado":"N","codproduto":"26626","lote":"009162","f":"*","barra":"27898009433175","vencimento":"27042026","codintegracaosetor":"MASTER","vlrunit":"000000002,99","codreferencia":"43317","qtde2":"1344","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26282","qtde":"480","estado":"N","codproduto":"26282","lote":"318587","f":"*","barra":"17898623957067","vencimento":"11022026","codintegracaosetor":"MASTER","vlrunit":"000000005,20","codreferencia":"95706","qtde2":"480","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"},{"or":"9152","codigoproduto":"26327","qtde":"756","estado":"N","codproduto":"26327","lote":"324413","f":"*","barra":"17898009431259","vencimento":"15052026","codintegracaosetor":"MASTER","vlrunit":"000000002,72","codreferencia":"43125","qtde2":"756","cnpjemitente":"01.773.518/0006-35","notafiscal":"21144","serie":"1"}]}'
texte(cText)

//_cPostProd	:= HttpPost( _cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )
//oJson := tJsonParser():New()
//lRet  := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJson, @nRetParser, @oJHM)
Return

User Function SLWS0001()

Return

WSRESTFUL ZKJSWEB DESCRIPTION "INTEGRAÇÃO ZAKAT" FORMAT APPLICATION_JSON
WSDATA receiveJson AS String
  
WSMETHOD POST ZKJSWEB  DESCRIPTION "INTEGRAÇÃO ZAKAT" WSSYNTAX "/ZKJSWEB || /ZKJSWEB/{NIL}"  PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD POST ZKJSWEB WSRECEIVE WSRESTFUL ZKJSWEB 
//RETURN
//static function texte(cJsons)
	//Local _cFile        :="\system\JSON_ATIVA\JSON.TXT"
    Local nX            := 0   
    Local _cLocal       :='' 
    Local cApiKey       := ::GetHeader( "APIKEY" )
    Private cJson 	    := Self:GetContent()
 //  Private cJson 	    := cJsons
    Private _oJsonA     := Nil
	Private oSA1Mod 	:= Nil
	Private oJson 		:= NIL
	Private oModel 		:= NIL
    Private cPedido     := ""
	Private _cCodCli 	:= ""
    Private aCabec 	    := {}
	Private aItens 	    := {}
	Private aTransf     := {}
	Private aErro 		:= {}
    Private aPvlNfs 	:= {}
    Private aSKU        := {} 
    Private aDevol      := {}                      
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.
    Private lDeuCerto 	:= .F.
    Private _cFornece	:= '002196'//PADR('002196',TAMSX3('F1_FORNECE')[1])
    Private _cLoja  	:= '01'//PADR('01',TAMSX3('F1_LOJA')[1])
    Private _cProcess   := 'N'
    Private _cErros     := ''
    Private _cNF        := ''
    Private cSerie      := ''
    //Gravalog(_cFile,cJson)

    oJson   := JsonObject():New()
    cError  := oJson:FromJson(cJson)

    If Select("SX6") == 0
		RpcSetType(3)
		RpcSetEnv("02","1201")
	Endif

    cFilAnt:='1201'
    cChave := GETNEWPAR('SL_APIKEY','40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6')

    DBSELECTAREA('SB1')
    DBSETORDER(1)
    DBSELECTAREA('SF1')
    DBSETORDER(1)
    DBSELECTAREA('SD1')
    DBSETORDER(1)
    DBSELECTAREA('SD3')
    DBSETORDER(7)
    DBSELECTAREA('SZZ')
    DBSETORDER(1)

IF cApiKey == cChave
    IF oJson:HasProperty('chavelayout') .AND. oJson:HasProperty('list') 
        IF Upper(oJson:GetJsonObject('chavelayout'))=="VI_INT_OR_LOTE_H"    
            oItems:= oJson:GetJsonObject('list')            
            cOrdem:= Padr(oItems[1]:GetJsonObject('or'),TAMSX3('ZZ_ORDEM')[1])
            cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])
            
            IF !SZZ->(DBSEEK(xFilial('SZZ')+cOrdem+cChave))
                Reclock('SZZ',.T.)
                    SZZ->ZZ_FILIAL  :=xFilial('SZZ')
                    SZZ->ZZ_LAYOUT  :=oJson:GetJsonObject('chavelayout')
                    SZZ->ZZ_JSON    :=cJson
                    SZZ->ZZ_ORDEM   :=cOrdem
                    SZZ->ZZ_PROCESS :='S'
                    SZZ->ZZ_DATA    :=dDataBase
                SZZ->(MSUNLOCK())
                _cMsgRet:='{"Resposta":"Header Gravado"}' 
            ELSE
                _cMsgRet:='{"Resposta":"Header já processado"}' 
            ENDIF
        ELSEIF Upper(oJson:GetJsonObject('chavelayout'))=="VI_INT_OR_LOTE_I"  
            
            oItems:= oJson:GetJsonObject('list')        
            cOrdem:= Padr(oItems[1]:GetJsonObject('or'),TAMSX3('ZZ_ORDEM')[1])
            cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])
            lSeek := SZZ->(DBSEEK(xFilial('SZZ')+cOrdem+cChave))
            IF !lSeek .OR. SZZ->ZZ_PROCESS=='N'
                Reclock('SZZ',!lSeek)
                    SZZ->ZZ_FILIAL  :=xFilial('SZZ')
                    SZZ->ZZ_LAYOUT  :=cChave
                    SZZ->ZZ_JSON    :=cJson
                    SZZ->ZZ_ORDEM   :=cOrdem
                    SZZ->ZZ_NFSERIE :=STRZERO(VAL(oItems[1]:GetJsonObject('notafiscal')),9)+alltrim(oItems[1]:GetJsonObject('serie'))
                    SZZ->ZZ_PROCESS :='N'
                    SZZ->ZZ_DATA    :=dDataBase
                SZZ->(MSUNLOCK())
                SZZ->(DBCLOSEAREA()) 

                _cNF     := PADR(STRZERO(VAL(oItems[1]:GetJsonObject('notafiscal')),9),TAMSX3('D1_DOC')[1])
                _cSerie  := PADR(alltrim(oItems[1]:GetJsonObject('serie')),TAMSX3('D1_SERIE')[1])
                _cMennota:= Posicione('SF1',1,xFilial('SF1')+_cNF+_cSerie+_cFornece+_cLoja,'F1_MENNOTA') //F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA
                _cLocal  := IF(xCross(_cMennota),'96','95')
                aLinha   := {}  
                cDocumen := GetSxeNum("SD3","D3_DOC")
                aadd(aLinha,{cDocumen,dDataBase}) //Cabecalho                 

                For nX := 1 to Len(oItems)
                    _cSku:= alltrim(oItems[nX]:GetJsonObject('codreferencia'))               
                    _nQtd:= val(oItems[nX]:GetJsonObject('qtde2'))
                    _nPos:= aScan(aSKU, {|x| AllTrim(x[1])==alltrim(_cSku)})                
                    IF _nPos>0
                        aSKU[_nPos][2]+=_nQtd
                    else
                        AADD(aSKU,{_cSku,_nQtd})
                    endif
                next     

                For nX := 1 to Len(aSKU)
                    _cSku:= PADR(aSKU[nX][1],TAMSX3('D1_COD')[1])     
                    _nQtd:= aSKU[nX][2]

                    IF SD1->(DBSEEK(xFilial('SD1')+_cNF+_cSerie+_cFornece+_cLoja+_cSku)) 
                        SB1->(DBSEEK(xFilial('SB1')+_cSku))
                      
                        _nRest:=SD1->D1_QUANT-_nQtd
                        IF _nRest>0
                            AADD(aDevol,{_cSku,_nRest})
                        endif
                      
                        aTransf := {}                            
                        aadd(aTransf,{"ITEM"      ,'00'+cvaltochar(nX)            ,Nil})                                                                             
                        Aadd(aTransf,{"D3_COD"	  , SB1->B1_COD			          ,Nil})
                        aAdd(aTransf,{"D3_DESCRI" , SB1->B1_DESC                  ,NIL}) 
                        Aadd(aTransf,{"D3_UM"	  , SB1->B1_UM				      ,Nil})
                        Aadd(aTransf,{"D3_LOCAL"  ,'97'					          ,Nil})  
                        aadd(aTransf,{"D3_LOCALIZ", PadR("ENDER01", tamsx3('D3_LOCALIZ') [1]),Nil})                   
                        aAdd(aTransf,{"D3_COD"    , SB1->B1_COD            	      ,NIL})
                        aAdd(aTransf,{"D3_DESCRI" , SB1->B1_DESC                  ,NIL}) 
                        aAdd(aTransf,{"D3_UM"     , SB1->B1_UM             	      ,NIL})
                        Aadd(aTransf,{"D3_LOCAL"  ,_cLocal  			          ,Nil}) 
                        aadd(aTransf,{"D3_LOCALIZ", PadR("ENDER02", tamsx3('D3_LOCALIZ') [1]),Nil})
                        Aadd(aTransf,{"D3_QUANT"  ,_nQtd                          ,Nil})                                                                                                        
                        Aadd(aTransf,{"D3_OBSERVA", alltrim(cOrdem)+' - '+_cNF    ,Nil})             
                        aadd(aTransf,{"D3_NUMSERI", "", Nil}) //Numero serie
                        aadd(aTransf,{"D3_LOTECTL", "", Nil}) //Lote Origem
                        aadd(aTransf,{"D3_NUMLOTE", "", Nil}) //sublote origem
                        aadd(aTransf,{"D3_DTVALID", "", Nil}) //data validade
                        aadd(aTransf,{"D3_POTENCI", 0, Nil}) // Potencia                        
                        aadd(aTransf,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
                        aadd(aTransf,{"D3_ESTORNO", "", Nil}) //Estorno
                        aadd(aTransf,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
                        
                        aadd(aTransf,{"D3_LOTECTL", "", Nil}) //Lote destino
                        aadd(aTransf,{"D3_NUMLOTE", "", Nil}) //sublote destino
                        aadd(aTransf,{"D3_DTVALID", "", Nil}) //validade lote destino
                        aadd(aTransf,{"D3_ITEMGRD", "", Nil}) //Item Grade
                        
                        aadd(aTransf,{"D3_CODLAN", "", Nil}) //cat83 prod origem
                        aadd(aTransf,{"D3_CODLAN", "", Nil}) //cat83 prod destino               
                        aAdd(aLinha,aTransf)                                            
                    ENDIF
                NEXT

               //Begin Transaction
                
                lMsErroAuto := .F.

                _cFunBkp:=FUNNAME()                
                SETFUNNAME("MATA261")     
                           
                MSExecAuto({|x,y| MATA261(x,y)},aLinha,3)   
           //     End Transaction  
                If lMsErroAuto
                    DisarmTransaction()
                    RollBackSX8()
                    cFileMsAuto	:= NomeAutoLog()
                    cError 		:= MEMOREAD( cFileMsAuto )
                    Ferase( cFileMsAuto) 
                    nLinhas := MLCount(cError)
                    cBuffer := ""
                    cCampo  := ""
                    nErrLin := 1
                    cBuffer := RTrim(MemoLine(cError,,nErrLin))
                    //Carrega o nome do campo
                    While (nErrLin <= nLinhas)
                        nErrLin++
                        cBuffer := RTrim(MemoLine(cError,,nErrLin))
                        If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
                            cCampo := cBuffer
                            Exit
                        EndIf
                    EndDo
                    //Adiciona ao array o nome do campo
                    _lPV    := .F.
                    //cError  := cCampo
                    _cErros := '[ERRO-SD3] Movimentacao'+ENTER
                    _cErros += IIF(!Empty(cCampo),cCampo,cError)                                     
                    _cMsgRet:='{"Resposta":" Erro: '+_cErros+'"}'  
                     
                Else
                    ConfirmSX8()                   
                    _cProcess:='S'
                    _cMsgRet :='{"Resposta":"Itens Gravados"}'        
                    IF LEN(aDevol)>0
                        DEVOLZK(_cNF,_cSerie,aDevol)
                    ENDIF
                endif   

               
               
               SETFUNNAME(_cFunBkp)

                DBSELECTAREA('SZZ')
                DBSETORDER(1)
                IF SZZ->(DBSEEK(xFilial('SZZ')+cOrdem+cChave))    
                    Reclock('SZZ',.F.)                    
                        SZZ->ZZ_ERRO    :=_cErros  
                        SZZ->ZZ_PROCESS := _cProcess
                    SZZ->(MSUNLOCK())      
                    SZZ->(DBCLOSEAREA())  
                ENDIF
            else
                _cMsgRet:='{"Resposta":"Itens já processados"}' 
            endif

        ELSEIF Upper(oJson:GetJsonObject('chavelayout'))=="VI_INT_OR_LOTE_N"  
            oItems:= oJson:GetJsonObject('list')            
            cOrdem:=Padr(oItems[1]:GetJsonObject('or'),TAMSX3('ZZ_ORDEM')[1])
            cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])
            
            IF !SZZ->(DBSEEK(xFilial('SZZ')+cOrdem+cChave))
                Reclock('SZZ',.T.)
                    SZZ->ZZ_FILIAL  :=xFilial('SZZ')
                    SZZ->ZZ_LAYOUT  :=oJson:GetJsonObject('chavelayout')
                    SZZ->ZZ_JSON    :=cJson
                    SZZ->ZZ_ORDEM   :=cOrdem
                    SZZ->ZZ_PROCESS :='S'
                    SZZ->ZZ_NFSERIE :=STRZERO(VAL(oItems[1]:GetJsonObject('notafiscal')),9)+alltrim(oItems[1]:GetJsonObject('serie'))
                    SZZ->ZZ_DATA    :=dDataBase
                SZZ->(MSUNLOCK())
                SZZ->(DBCLOSEAREA())  
                _cMsgRet:='{"Resposta":"Footer Gravado"}' 
            else
                _cMsgRet:='{"Resposta":"Footer já processado"}' 
            ENDIF
        ENDIF
    ENDIF
 else
    _cMsgRet:='{"Resposta":"APIKEY Inválido."}' 
ENDIF
    Self:SetResponse(_cMsgRet)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±  REALIZA DEVOLUCAO DOS ITENS ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
*/

STATIC function DEVOLZK(_cNF,_cSerie,aDevol)

Local nX        := 1
Local _cFornece := '002196'
Local _cLoja    := '01'
Local _cTes     := '614'	
Local lRetorno	:= .T.
Local aPvlNfs   := {}
Local _cEmbExp  := ""

	oPedido	:= PedVdaFb():New()
    //Adiciona Cabecalho
	oPedido:AddCabec( "EMPRESA"			, cEmpAnt 									)
	oPedido:AddCabec( "C5_FILIAL"		, cFilAnt 									)
	oPedido:AddCabec( "C5_TIPO"			, "D"										)
	oPedido:AddCabec( "C5_CLIENTE"		, _cFornece	    							)
	oPedido:AddCabec( "C5_LOJACLI"		, _cLoja									)
	oPedido:AddCabec( "C5_CLIENT"		, _cFornece									)
	oPedido:AddCabec( "C5_LOJAENT"		, _cLoja 									)
	oPedido:AddCabec( "C5_CONDPAG"		,'003'										) 
	oPedido:AddCabec( "C5_EMISSAO"		, dDatabase									)
	oPedido:AddCabec( "C5_TPFRETE"		, "C"									 	)						
	oPedido:AddCabec( "C5_LIBEROK"		, "S"										)

    For nX := 1 To LEN(aDevol)  //Quantidade de Itens

        _cSku:= PADR(aDevol[nX][1],TAMSX3('D1_COD')[1])   
        IF SD1->(DBSEEK(xFilial('SD1')+_cNF+_cSerie+_cFornece+_cLoja+_cSku)) 

            oPedido:AddItem( "C6_FILIAL"	, cFilAnt									)
            oPedido:AddItem( "C6_ITEM"		, StrZero( nX, TamSX3("C6_ITEM")[1] )	    )
            oPedido:AddItem( "C6_PRODUTO"	, _cSku								  		)
            oPedido:AddItem( "C6_QTDVEN"	, aDevol[nX][2]								)
            oPedido:AddItem( 'C6_PRUNIT'	, SD1->D1_VUNIT								)
            oPedido:AddItem( "C6_PRCVEN"	, SD1->D1_VUNIT					  			)
            oPedido:AddItem( "C6_VALOR"		, aDevol[nX][2]*SD1->D1_VUNIT      	   		)
            oPedido:AddItem( "C6_TES"		, _cTes 					                )
            oPedido:AddItem( "C6_LOCAL"		, '97'                          	        )                       
            oPedido:AddItem( "C6_NFORI"		, SD1->D1_DOC                     	        )     
            oPedido:AddItem( "C6_SERIORI"	, SD1->D1_SERIE                    	        )     
            oPedido:AddItem( "C6_ITEMORI"	, SD1->D1_ITEM                     	        )     
            oPedido:SetItem()
	    ENDIF
    NEXT
     
    If oPedido:Gravacao( 3, lRetorno)  
		//Resgata pedido gerado
		cPedido	 := oPedido:GetNumero()  
        
        DBSELECTAREA("SC5")
        DbSetOrder(1)
        DbSeek(xFilial('SC5')+cPedido)
        
        DBSELECTAREA("SC6")
        DbSetOrder(1)
        DbSeek(xFilial('SC6')+cPedido)
        
        DBSELECTAREA("SC9")
        DbSetOrder(1)
        DbSeek(xFilial('SC9')+cPedido)
        
        While SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial('SC9')+cPedido
            SC5->(DbSetOrder(1))
            SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO) )                  //FILIAL+NUMERO
            // Cad. item do pedido de venda
            SC6->(DbSetOrder(1))
            SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM) )     //FILIAL+NUMERO+ITEM
            // Cad. Condicao de Pgto
            SE4->(DbSetOrder(1))
            SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )               //FILIAL+NUMERO+ITEM+PRODUTO
            // Cad. Produtos
            SB1->(DbSetOrder(1))
            SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO) )                //FILIAL+PRODUTO
            // Cadastro Saldos Estoque
            SB2->(DbSetOrder(1))
            SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL) )  //FILIAL+PRODUTO+LOCAL
            // Cadastro TES
            SF4->(DbSetOrder(1))
            SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )                   //FILIAL+CODIGO
           
            AAdd(aPvlNfs,{ SC9->C9_PEDIDO,;
                        SC9->C9_ITEM,;
                        SC9->C9_SEQUEN,;
                        SC9->C9_QTDLIB,;
                        SC9->C9_PRCVEN,;
                        SC9->C9_PRODUTO,;
                        .F.,;
                        SC9->(RecNo()),;
                        SC5->(RecNo()),;
                        SC6->(RecNo()),;
                        SE4->(RecNo()),;
                        SB1->(RecNo()),;
                        SB2->(RecNo()),;
                        SF4->(RecNo())})                
            SC9->(dbskip())
        enddo
        
        If Len(aPvlNfs) > 0
            cNota :=""
            _cSerie:='2'
             _cDocNF := MaPvlNfs(  /*aPvlNfs*/aPvlNfs,; // 01 - Array com os itens a serem gerados
                       /*_cSerieNFS*/      _cSerie,;   // 02 - Serie da Nota Fiscal
                       /*lMostraCtb*/      .F.,;       // 03 - Mostra Lançamento Contábil
                       /*lAglutCtb*/       .F.,;       // 04 - Aglutina Lançamento Contábil
                       /*lCtbOnLine*/      .F.,;       // 05 - Contabiliza On-Line
                       /*lCtbCusto*/       .T.,;       // 06 - Contabiliza Custo On-Line
                       /*lReajuste*/       .F.,;       // 07 - Reajuste de preço na Nota Fiscal
                       /*nCalAcrs*/        0,;         // 08 - Tipo de Acréscimo Financeiro
                       /*nArredPrcLis*/    0,;         // 09 - Tipo de Arredondamento
                       /*lAtuSA7*/         .T.,;       // 10 - Atualiza Amarração Cliente x Produto
                       /*lECF*/            .F.,;       // 11 - Cupom Fiscal
                       /*_cEmbExp*/        _cEmbExp,;   // 12 - Número do Embarque de Exportação
                       /*bAtuFin*/         {||},;      // 13 - Bloco de Código para complemento de atualização dos títulos financeiros
                       /*bAtuPGerNF*/      {||},;      // 14 - Bloco de Código para complemento de atualização dos dados após a geração da Nota Fiscal
                       /*bAtuPvl*/         {||},;      // 15 - Bloco de Código de atualização do Pedido de Venda antes da geração da Nota Fiscal
                       /*bFatSE1*/         {|| .T. },; // 16 - Bloco de Código para indicar se o valor do Titulo a Receber será gravado no campo F2_VALFAT quando o parâmetro MV_TMSMFAT estiver com o valor igual a "2".
                       /*dDataMoe*/        dDatabase,; // 17 - Data da cotação para conversão dos valores da Moeda do Pedido de Venda para a Moeda Forte
                       /*lJunta*/          .F.)        // 18 - Aglutina Pedido Iguais
        //    cNota := MAPVLNFS(aPVlNFs,_cSerie,.F.,.F.,.F.,.F.,.F.,1,1,.F.,.F.,,,) 
        endif
	Else
		lRetorno	:= .F.
		cMenErr		:= oPedido:GetMensagem()
		cPedido		:=''
	ENDIF

RETURN



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±  VERIFICA SE É NF CROSS   ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
*/
STATIC FUNCTION xCross(_cMennota)
Local aCross := split( _cMennota, '-' )
Local nPos   := aScan(aCross, {|x| AllTrim(x)=="MONTA CARGA"})
Local _lRet  :=.F.

IF nPos>0
    nPos   := aScan(aCross, {|x| "PEDIDO" $ AllTrim(x)})
    aCross := split( aCross[nPos], ':' )
    nPos   := aScan(aCross, {|x| AllTrim(x)=="PEDIDO"})
    _cPedido:= aCross[nPos+1]
    _lRet:=.T.
ENDIF

RETURN _lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³   split  ³ Autor ³ FERNANDO              ³ Data ³ 09/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Separar string conforme string de separacao enviado no     ³±±
±±³          ³ paramento cDIV, colocar as separacoes em um array          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³  				                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ---ÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ SalonLine			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ Gravalog  ³ Autor ³                 ³ Data ³               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  													      |±±
±±³			 | 										               		  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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
