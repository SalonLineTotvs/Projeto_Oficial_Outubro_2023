#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "tbiconn.ch"

#DEFINE  ENTER CHR(13)+CHR(10)

User Function JSZAKAT3()
    Local _cUrl:="http://10.50.2.10:8002/ZKJSWEB3"
    Local aHeadOut      := {}
    Local _nTimeOut     := 120
    Local _cHeadRet     := ''
    Local _cPostProd    := ''
    Local aJson         := {}
    Local oJHM 	        := .F.
    Local nRetParser    := 0
    aAdd( aHeadOut, "Content-Type: text/plain" )
    
 //   PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" 
//cText:='{"chavelayout": "vi_int_envio_confirEmbarque","list": [{"cnpj_armazem": "01.125.797/0011-98","cnpj_depositante": "38.429.600/0001-42","cnpj_remetente": "38.429.600/0001-42","cnpj_destinatario": "","cnpj_transportadora": "07.020.236/0001-39","numeronf": "7207","serienf": "2","numpedido": "007428","dataliberacao": "2023-07-06 17:32:40.0","idcarga": "23461","numcoleta": "23461","qtdevolume": "163","pesovolume": "400740","rgmotorista": "0511074573","motorista": "VANDILSON SOUZA","placa": "GGC7C61","dataembarque": "2023-07-06 17:33:39.0","embarqueliberado": "S","finalizado": "S","f": "*"},	{"cnpj_armazem": "01.125.797/0011-98","cnpj_depositante": "38.429.600/0001-42",	"cnpj_remetente": "38.429.600/0001-42",	"cnpj_destinatario": "","cnpj_transportadora": "07.020.236/0001-39","numeronf": "7208","serienf": "2","numpedido": "007438","dataliberacao": "2023-07-06 17:32:40.0","idcarga": "23461","numcoleta": "23461","qtdevolume": "3","pesovolume": "10800","rgmotorista": "0511074573","motorista": "VANDILSON SOUZA","placa": "GGC7C61","dataembarque": "2023-07-06 17:33:39.0","embarqueliberado": "S","finalizado": "S","f": "*"}]}'
//texte(cText)

//_cPostProd	:= HttpPost( _cUrl, "", cText, _nTimeOut, aHeadOut, @_cHeadRet )
//oJson := tJsonParser():New()
//lRet  := oJson:Json_Hash(_cPostProd, LEN(_cPostProd), @aJson, @nRetParser, @oJHM)
//Return

User Function SLWS0003()

Return

WSRESTFUL ZKJSWEB3 DESCRIPTION "RETORNO MANIFESTO ZAKAT" FORMAT APPLICATION_JSON
WSDATA receiveJson AS String
  
WSMETHOD POST ZKJSWEB3  DESCRIPTION "RETORNO MANIFESTO ZAKAT" WSSYNTAX "/ZKJSWEB3 || /ZKJSWEB3/{NIL}"  PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD POST ZKJSWEB3 WSRECEIVE WSRESTFUL ZKJSWEB3
//RETURN
//static function texte(cJsons)
	//Local _cFile        :="\system\JSON_ATIVA\JSON3.TXT"
    Local nX            := 0   
    Local cQuery3 	:= ""   
    Local cApiKey    :='40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6'// ::GetHeader( "APIKEY" )
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
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.
    Private lDeuCerto 	:= .F.
    Private _cFornece	:= PADR('002196',TAMSX3('F1_FORNECE')[1])
    Private _cLoja  	:= PADR('01',TAMSX3('F1_LOJA')[1])
    Private _cMsgRet :=""
    //Gravalog(_cFile,cJson)

	Conout( '*************** ENTROUUUUUUUUUUUU SZKJWEB3 ***************' )
    
    oJson   := JsonObject():New()
    cError  := oJson:FromJson(cJson)

    // If Select("SX6") == 0
	// 	RpcSetType(3)
	// 	RpcSetEnv("01","1201")
	// Endif

    cFilAnt:='1201'
    cChave := GETNEWPAR('SL_APIKEY','40FCBB8CDCA0F4E39B82262B18472CE0A34A9C266F514581CBDFC256819C51B6') //chave producao ativa
    //cChave := GETNEWPAR('SL_APIKEY','3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B')
    //aAdd( aHeadOut, "apiKey: 3444890472BD24E6D8E0F86BA8E0B6A17F62CB74AAD89F4146FC8D039A14C62B") // homolog

    DBSELECTAREA('SB1')
    DBSETORDER(1)
    DBSELECTAREA('SF2')
    DBSETORDER(1)
    DBSELECTAREA('SD2')
    DBSETORDER(1)
    DBSELECTAREA('SC5')
    DBSETORDER(1)
    DBSELECTAREA('SC6')
    DBSETORDER(1)
    DBSELECTAREA('SA1')
    DBSETORDER(1)
    DBSELECTAREA('SE1')
    DBSETORDER(1)

IF cApiKey == cChave
        
            IF oJson:HasProperty('chavelayout') .AND. oJson:HasProperty('list') 
                IF Upper(oJson:GetJsonObject('chavelayout'))==upper("vi_int_envio_confirEmbarque")    
                        
                    //For nX := 1 to Len(oItems)
                            oItems:= oJson:GetJsonObject('list')   
                            // BUSCA NUMERAÇÃO DO MANIFESTO  
                            cNrManif := Soma1(GetMV("ES_NRMANIF"),6)
                            // ATUALIZA NUMERDO DO MANIFESTO
                            dbSelectArea("SX6")
                            PutMv("ES_NRMANIF",cNrManif)
                     For nX := 1 to Len(oItems)        
                            cnColeta:= PADR(oItems[nx]:GetJsonObject('numcoleta'),TAMSX3('Z1_NRMA')[1])
                            cnumNF:= PADR(STRZERO(VAL(oItems[nx]:GetJsonObject('numeronf')),9),TAMSX3('F2_DOC')[1])
                            cSerieNF:= Padr(oItems[nx]:GetJsonObject('serienf'),TAMSX3('F2_SERIE')[1])
                            cnumped:= Padr(oItems[nx]:GetJsonObject('numpedido'),TAMSX3('C5_NUM')[1])
                            cMotoris:= Alltrim(Padr(oItems[nx]:GetJsonObject('motorista'),TAMSX3('Z1_MOTMA')[1]))
                            cRGMot:= Padr(oItems[nx]:GetJsonObject('rgmotorista'),TAMSX3('Z1_RGMA')[1])
                            cPlaca:= Padr(oItems[nx]:GetJsonObject('placa'),TAMSX3('Z1_PLACA')[1])
                            cnpjtrans:= REPLACE(REPLACE(REPLACE(alltrim(oItems[nx]:GetJsonObject('cnpj_transportadora')),'.', ''),'-', ''),'/', '')
                            //cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])

                                // BUSCA NUMERAÇÃO DO MANIFESTO
                            //cNrManif := Soma1(GetMV("ES_NRMANIF"),6)	//Tipo (C) - Numero do Manifesto para Transportadora
                            cNrManif := Replicate("0",6-Len(Alltrim(cNrManif)))+Alltrim(cNrManif)

                                IF SC5->(DBSEEK(xFilial('SC5')+cnumped)) .and. cFilAnt=='1201' .and.  NX==1	
                                        RecLock("SZ1",.T.)

                                        SZ1->Z1_FILIAL	:= xFilial("SZ1")	
                                        SZ1->Z1_NRMA	:= cNrManif		
                                        SZ1->Z1_MOTMA	:= cMotoris		
                                        SZ1->Z1_RGMA	:= cRGMot 		
                                        SZ1->Z1_PLACA	:= cPlaca
                                        SZ1->Z1_VEICULO	:= "F"
                                        SZ1->Z1_OBSM1   := "N COLETA "+cnColeta		
                                        SZ1->Z1_DTMA	:= date() //Sol.Genilson para gera a data do Windows e não mais do sistema -  //dDatabase	
                                        SZ1->Z1_HRMA	:= time()
                                        SZ1->Z1_TRANSP 	:= Alltrim(Posicione("SA4",3,xFilial("SA4")+cnpjtrans,"A4_COD"))	
                                        SZ1->Z1_LOTACAO	:= "NAO"
                                        
                                        MsUnlock()
                                ENDIF

                                IF SC5->(DBSEEK(xFilial('SC5')+cnumped)) .and. cFilAnt=='1201'
                                    Reclock('SC5',.F.)
                                        SC5->C5_X_STAPV:='7' //0=P Gerado;1=Liberado;2=Em Separacao;3=Sep Finaliz;4=Em Confer;5=Conf Finaliz;6=Faturado;7=Manif Imp;A=Antecip.;C=Cancel;D=Devol
                                        SC5->C5_X_MANIF:=cNrManif
                                    MSUNLOCK()
                                ENDIF

                                IF SF2->(DBSEEK(xFilial('SF2')+cnumNF+cSerieNF+SC5->C5_CLIENTE+SC5->C5_LOJACLI)) .and. cFilAnt=='1201'
                                    Reclock('SF2',.F.)
                                        F2_X_NRMA:=cNrManif //0=P Gerado;1=Liberado;2=Em Separacao;3=Sep Finaliz;4=Em Confer;5=Conf Finaliz;6=Faturado;7=Manif Imp;A=Antecip.;C=Cancel;D=Devol
                                    
                                    MSUNLOCK()
                                ENDIF
                                            ///atualiza informações do titulos apos receber retorno do manifesto
                                			cQuery3 := " UPDATE "+RetSqlName("SE1")+" SET E1_VENCREA = "
                                            cQuery3 += " 	CONVERT(VARCHAR(10)," //Converte informação da função SQL para YYYYMMDD
                                            cQuery3 += " 		dateadd(day, " //Função: Adicionar Numero em Campo Data
                                            cQuery3 += " 			DATEDIFF ( DAY , E1_EMISSAO, GETDATE() )"//Funcao: Calc.Difer.entre (EMISSAO NOTA - GETDATE()) = Nova Data Venc.Real
                                            cQuery3 += " 		,E1_VENCTO) " //Campo que será adicionado os dias Calculados
                                            cQuery3 += " 	,112) " //Converte para YYYYMMDD
                                            cQuery3 += " ,E1_HIST=RTRIM(LTRIM(E1_HIST))+' /MANISF ' +CONVERT(VARCHAR(10),GETDATE(),103)"//Grava Informacao para equipe do Financeiro ficar ciente
                                            cQuery3 += " ,E1_X_DTMAN='"+DTOS(date())+"'"
                                            cQuery3 += " FROM "+RetSqlName("SE1")+" INNER JOIN "+RetSqlName("SA1")+" A1 ON E1_CLIENTE=A1_COD AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 

                                            cQuery3 += " WHERE E1_NUM IN ('"+cNumNF+"')"
                                            cQuery3 += " AND E1_TIPO='NF'"
                                            cQuery3 += " AND E1_FILIAL='"+xFilial("SE1")+"'"
                                            cQuery3 += " AND E1_ORIGEM='MATA460'" 	//Travo para alterar SÓ Nota geradas do Mod.Faturamento TOTVS
                                            cQuery3 += " AND E1_PORTADO=' '" 		//Só traz os Titulos NAO ENVIADOS PARA BANCO
                                            cQuery3 += " AND E1_SALDO>0" 			//Só traz os Titulos EM ABERTO 
                                            cQuery3 += " AND A1_X_MANIF <> '2' "

                                            TcSqlExec(cQuery3)

                                // IF SE1->(DBSEEK(xFilial('SE1')+cnumNF+cSerieNF)) .and. cFilAnt=='1201'
                                //     Reclock('SE1',.F.)
                                //         E1_HIST=alltrim(E1_HIST)+' /MANISF ' +DTOS(date())
                                //         E1_X_DTMAN=DTOS(date())

                                //     MSUNLOCK()
                                // ENDIF
                    next            
                
                endif
                 
                 
                 IF Upper(oJson:GetJsonObject('chavelayout'))==upper("vi_int_envio_confirEmbarqueDet")    //passa itens
                    oItems:= oJson:GetJsonObject('list')            
                    cnumped:= Padr(oItems[1]:GetJsonObject('numpedido'),TAMSX3('C5_NUM')[1])
                    //cChave:= Padr(oJson:GetJsonObject('chavelayout'),TAMSX3('ZZ_LAYOUT')[1])
                    
                    IF SC5->(DBSEEK(xFilial('SC5')+cnumped)) .and. cFilAnt=='1201'
                        Reclock('SC5',.F.)
                            SC5->C5_X_STAPV:='7' //0=P Gerado;1=Liberado;2=Em Separacao;3=Sep Finaliz;4=Em Confer;5=Conf Finaliz;6=Faturado;7=Manif Imp;A=Antecip.;C=Cancel;D=Devol
                 
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
   // Self:SetResponse(_cMsgRet) //
   
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
