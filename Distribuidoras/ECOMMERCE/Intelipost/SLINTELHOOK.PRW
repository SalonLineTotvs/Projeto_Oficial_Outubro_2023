#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"

#DEFINE  ENTER CHR(13)+CHR(10)
 

User Function SLINTELHOOK()

Return

WSRESTFUL SLINTELHOOK DESCRIPTION "INTEGRAÇÃO INTELIPOST" FORMAT APPLICATION_JSON
WSDATA receiveJson AS String
  
WSMETHOD POST SLINTELHOOK  DESCRIPTION "INTEGRAÇÃO INTELIPOST" WSSYNTAX "/SLINTELHOOK || /SLINTELHOOK/{NIL}"  PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD POST SLINTELHOOK WSRECEIVE WSRESTFUL SLINTELHOOK 
    Local cApiKey       := ::GetHeader( "APIKEY" )
    Local cJson 	    := Self:GetContent()
	Local oJson 		:= JsonObject():New()
    Local  cChave       := GETNEWPAR('SL_INTEKEY','e03342507e849eef7131cd6b531cc212bdcb2175')
    Local cError        := oJson:FromJson(cJson)
    Local _cPedido      := ""

    If Select("SX6") == 0
		RpcSetType(3)
		RpcSetEnv("02","1501")
	Endif

    cFilAnt:='1501'

    DBSELECTAREA('SZB')
    DBSETORDER(1)
    DBSELECTAREA('PZU')
    DBSETORDER(1)
    DBSELECTAREA('PZX') //PZX_FILIAL, PZX_PEDECO, PZX_STATUS, R_E_C_N_O_, D_E_L_E_T_
    DBSETORDER(2) 

    IF cApiKey == cChave
        _cCodeMicro:= oJson:GetJsonObject('history'):GetJsonObject('shipment_volume_micro_state'):GetJsonObject('code')
        _cPedido   := oJson:GetJsonObject('order_number')        
        _cTrackcode:= oJson:GetJsonObject('tracking_code')
        _cDataRet  := oJson:GetJsonObject('history'):GetJsonObject('created_iso')
        _cObs      := oJson:GetJsonObject('history'):GetJsonObject('shipment_volume_micro_state'):GetJsonObject('description')
        _cLink     := oJson:GetJsonObject('tracking_url')
        _dData     := STOD(strtran(left(_cDataRet,10),'-',''))
        _cHora     := SUBSTR(_cDataRet,12,8)
        IF SZB->(DBSEEK(xFilial('SZB')+PADR(_cCodeMicro,TAMSX3('ZB_MICROID')[1]))) 
            _cStatus:= SZB->ZB_CODERP
            IF PZU->(DBSEEK(xFilial('PZU')+PADR(_cPedido,TAMSX3('PZU_PEDECO')[1]))) 
                Reclock('PZU',.F.)
                    PZU->PZU_STATUS:= _cStatus
                MSUNLOCK()
            ENDIF
            
            IF !PZX->(DBSEEK(xFilial('PZX')+PADR(_cPedido,TAMSX3('PZX_PEDECO')[1])+PADR(_cStatus,TAMSX3('PZX_STATUS')[1])))
                Reclock('PZX',.T.)
                    PZX->PZX_FILIAL:= xFilial('PZX')
                    PZX->PZX_PEDECO:= _cPedido
                    PZX->PZX_DATA  := _dData
                    PZX->PZX_HORA  := _cHora
                    PZX->PZX_STATUS:= _cStatus
                    PZX->PZX_OBSERV:=  DeCodeUtf8(ALLTRIM(_cObs))
                    PZX->PZX_LINK  := _cLink    
                MSUNLOCK()
                _cMsgRet:='{"Resposta":"Tracking Code gravado com sucesso: "'+_cTrackcode+'}' 
                Self:SetResponse(_cMsgRet)
            ENDIF
        ENDIF
    ENDIF

    return
