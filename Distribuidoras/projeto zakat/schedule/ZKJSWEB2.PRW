#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"

#DEFINE  ENTER CHR(13)+CHR(10)

User Function JSZAKAT2()
    // Local _cUrl:="http://10.50.2.10:8002/ZKJSWEB2"
    // Local aHeadOut      := {}
    // Local _nTimeOut     := 120
    // Local _cHeadRet     := ''
    // Local _cPostProd    := ''
    // Local aJson         := {}
    // Local oJHM 	        := .F.
    // Local nRetParser    := 0
    // aAdd( aHeadOut, "Content-Type: text/plain" )
    
 //   PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" 
// cText:='{"chavelayout": "vi_int_envio_fatur_lote","list": [{"i": "6","codigointerno": "6530","numpedido": "006530","cnpj_depositante": "38.429.600/0001-42","cnpj_emitente": "38.429.600/0001-42","sequencia": "","tipo": "S","status": "A","o": "W","motivocancelamento": "","c": "N",	"idmovimento": "2206","idnotafiscal": "","npalet": "1",	"seq_entrega": "00000000000000000001","paginageomapa": "","descrromaneio": "TESTE PEDIDO ZAKAT - 6530",	"placa": "","motorista": "","cnpj_motorista": "","dataemissao": "21/06/2023","qtdevolume": "1",	"totalpesovolume": "24000",	"cnpj_dest": "10.984.107/0001-75","identificadorpedido": "","totalcubagemvolume": "0.039765","f": "*","codigotipopedido": "PED_VEN","tipoenvio": "0","especievolume": "","datafaturamento": "04/07/2023 16:08:56","datafaturamentosegmomento": ""}]}'
// //texte(cText)

//_cPostProd	:= HttpPost( _cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )
//oJson := tJsonParser():New()
//lRet  := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJson, @nRetParser, @oJHM)
Return

 User Function SLWS0002()

 Return

WSRESTFUL ZKJSWEB2 DESCRIPTION "SEPARACAO DE PEDIDO ZAKAT" FORMAT APPLICATION_JSON
WSDATA receiveJson AS String
  
WSMETHOD POST ZKJSWEB2  DESCRIPTION "SEPARACAO DE PEDIDO ZAKAT" WSSYNTAX "/ZKJSWEB2 || /ZKJSWEB2/{NIL}"  PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD POST ZKJSWEB2 WSRECEIVE WSRESTFUL ZKJSWEB2 
//RETURN
//static function texte(cJsons)
	Local _cFile        :="\system\JSON_ATIVA\JSON2.TXT"
    Local nX            := 0    
    Local cApiKey    := ::GetHeader( "APIKEY" )
    Private cJson 	    := Self:GetContent()
  // Private cJson 	    := cJsons
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
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.
    Private lDeuCerto 	:= .F.
    Private _cFornece	:= PADR('002196',TAMSX3('F1_FORNECE')[1])
    Private _cLoja  	:= PADR('01',TAMSX3('F1_LOJA')[1])
    Private _cMsgRet :=""
  //  Gravalog(_cFile,cJson)

	Conout( '*************** ENTROUUUUUUUUUUUU SZKJWEB2 ***************' )
    
    oJson   := JsonObject():New()
    cError  := oJson:FromJson(cJson)

    If Select("SX6") == 0
		RpcSetType(3)
		RpcSetEnv("01","1201")
	Endif

    cFilAnt:='1201'
    cChave := GETNEWPAR('SL_APIKEY','40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6') //chave producao ativa
    //cChave := GETNEWPAR('SL_APIKEY','3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B')
    //aAdd( aHeadOut, "apiKey: 3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B") // homolog

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
    DBSELECTAREA('SC5')
    DBSETORDER(1)
    DBSELECTAREA('SC6')
    DBSETORDER(1)

IF cApiKey == cChave
        
            IF oJson:HasProperty('chavelayout') .AND. oJson:HasProperty('list') 
                IF Upper(oJson:GetJsonObject('chavelayout'))==upper("vi_int_envio_fatur_lote")    
                    oItems:= oJson:GetJsonObject('list')            
                    cnumped:= Padr(oItems[1]:GetJsonObject('numpedido'),TAMSX3('C5_NUM')[1])
                    cVolume:= Padr(oItems[1]:GetJsonObject('qtdevolume'),TAMSX3('C5_VOLUME1')[1])
                    //cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])
                    
                    IF SC5->(DBSEEK(xFilial('SC5')+cnumped)) .and. cFilAnt=='1201'
                        Reclock('SC5',.F.)
                            SC5->C5_X_STAPV:='5' //0=P Gerado;1=Liberado;2=Em Separacao;3=Sep Finaliz;4=Em Confer;5=Conf Finaliz;6=Faturado;7=Manif Imp;A=Antecip.;C=Cancel;D=Devol
                            SC5->C5_VOLUME1:=val(cVolume)
                        MSUNLOCK()
                        _cMsgRet:='{"Resposta":"Status do Pedido Alterado"}' 
                    ELSE
                        _cMsgRet:='{"Resposta":"Status nao alterado"}' 
                    ENDIF
                endif
                 IF Upper(oJson:GetJsonObject('chavelayout'))==upper("vi_int_envio_fatur_det_lote")    //passa itens
                    oItems:= oJson:GetJsonObject('list')            
                    cnumped:= Padr(oItems[1]:GetJsonObject('numpedido'),TAMSX3('C5_NUM')[1])
                    //cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])
                    
                    IF SC5->(DBSEEK(xFilial('SC5')+cnumped)) .and. cFilAnt=='1201'
                        Reclock('SC5',.F.)
                            SC5->C5_X_STAPV:='5' //0=P Gerado;1=Liberado;2=Em Separacao;3=Sep Finaliz;4=Em Confer;5=Conf Finaliz;6=Faturado;7=Manif Imp;A=Antecip.;C=Cancel;D=Devol
                 
                        MSUNLOCK()
                        _cMsgRet:='{"Resposta":"Status do Pedido Alterado"}' 
                    ELSE
                        _cMsgRet:='{"Resposta":"Status nao alterado"}' 
                    ENDIF
                endif
            ENDIF
         
else
    _cMsgRet:='{"Resposta":"APIKEY Inválido."}' 
    
ENDIF
    Self:SetResponse(_cMsgRet)
   
Return

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
