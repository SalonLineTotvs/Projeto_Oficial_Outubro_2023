#INCLUDE 'rwmake.ch'
#Include "TopConn.Ch"
#DEFINE _EOL Chr(13) + Chr(10)	//Enter
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WB_LOG002 ºAutor  ³Andre Salgado       º Data ³  08/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno informacao da Logistica                            º±±
±±º          ³ Foi criado uma tabela na base da Logistica (01)            º±±
±±º          ³ ALIAS - SZG - Campos para receber de Vendas (02)           º±±
±±º          ³ Foram criados só os campos necessarios para Logistica      º±±
±±º          ³                                                            º±±
±±º          ³ Informar (VARIAVEL) numero da Onda para buscar nos Ped.Vda º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

> AÇÃO(1) - Rotina Retorno Informação da SEPARACAO e CONFERENCIA da LOGISTICA para DISTRIBUIDORA - Responsavel Usuario LOGISTICA
> AÇÃO(2) - Flag data (ZG_DTIMPLO ) na tabela SZG020 - Será atualizado no Programa REST WebService
> CRIAR   - PARAMETRO ES_URLLOGR - Tipo Caracter - Conteudo - http://192.168.0.30:9003/LOGISTICAA  - Descricao - Endereço URL Webservice Retorno Logistica
 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Ação - Retorno da informação do Pedido de Venda da Logistica para Distribuidora
User Function WB_LOG10(cPedX)

PRIVATE cPostPar:= ""
PRIVATE cPedX 	:= cPedX //space(10)

/*
Set Device To Screen
@ 001,200 To 200,500 Dialog oNota Title OemToAnsi("Parâmetros")
//@ 025,015 Say OemToAnsi("Empresa")
//@ 025,070 Get cEmpPed SIZE 50,50
@ 040,015 Say OemToAnsi("Numero Pedido")
@ 040,070 Get cPedX SIZE 50,50
@ 087,070 BmpButton Type 1 Action oNota:End()
Activate Dialog oNota Centered
Set Device To Print
*/


If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif

//Busca dados da analise da SEPARACAO ou CONFERENCIA
//Ação (1) - Retorna informacao da (01) LOGISTICA para (02) DISTRIBUIDORA
cQuery:= " SELECT "
cQuery+= "  CASE WHEN ZG_STAPV='3' THEN	'S' ELSE 'X' END ACAOWS,"
cQuery+= "  ZG_NUM, ZG_FILPED, CASE WHEN ZG_ANTEC='1' THEN '6' ELSE ZG_STAPV END ZG_STAPV,"
cQuery+= "  ZG_ITEM, ZG_PRODUTO, ZG_VCXCO, ZG_VGRCO, ZG_VOLUME1, ZG_VOLUME2, ZG_TLPCC, ZG_TLPCG,"
cQuery+= "  ZG_DTISP, ZG_DTFSP, ZG_HRISP, ZG_HRFSP, UPPER(CB1_NOME) ZG_SEPAR,"
cQuery+= "  ZG_DTICF, ZG_DTCCX, ZG_HRICF, ZG_HRCCX, UPPER(ZG_CONCX) ZG_CONCX,"
cQuery+= "  ZG_DTIGR, ZG_DTCGR, ZG_HRIGR, ZG_HRCGR, UPPER(ZG_CONGR) ZG_CONGR"
cQuery+= " FROM SZG010 ZG WITH(NOLOCK)"
cQuery+= " 	LEFT JOIN CB1010 CB1 WITH(NOLOCK) ON  LEFT(ZG_SEPAR,6)=CB1_CODOPE AND CB1.D_E_L_E_T_=' '"
cQuery+= " WHERE ZG.D_E_L_E_T_=' '"
cQuery+= " 		AND ZG_STAPV  IN('5') "	//Busca Pedido '3' SEPARAÇÃO FINALIZADA  //  '5' Conferencia Finalizada

IF !EMPTY(cPedX)
	cQuery+= " 		AND ZG_FILPED = '"+LEFT(cPedX,4)+"' AND ZG_NUM='"+RIGHT(cPedX,6)+"'"
else
	cQuery+= " 		AND ZG_DTRETLO=' '"	
Endif

//Envia informação do Pedido com CORTE
cQuery+= " UNION ALL"
cQuery+= " SELECT   DISTINCT 'C' ACAOWS,  ZG_NUM, ZG_FILPED, ZG_STAPV, '01' ZG_ITEM, ' ' ZG_PRODUTO, 0 ZG_VCXCO, 0 ZG_VGRCO,"
cQuery+= "   0 ZG_VOLUME1, 0 ZG_VOLUME2, ' ' ZG_TLPCC, ' ' ZG_TLPCG,  ' ' ZG_DTISP, ' ' ZG_DTFSP, ' ' ZG_HRISP, ' ' ZG_HRFSP, ' '  ZG_SEPAR,"
cQuery+= "   ' ' ZG_DTICF, ' ' ZG_DTCCX, ' ' ZG_HRICF, ' ' ZG_HRCCX, ZG_USCORT  ZG_CONCX,  ' ' ZG_DTIGR, ' ' ZG_DTCGR, ' ' ZG_HRIGR, ' ' ZG_HRCGR, ' '  ZG_CONGR"
cQuery+= " FROM SZG010 ZG WITH(NOLOCK)"
cQuery+= " WHERE ZG.D_E_L_E_T_=' ' AND ZG_STAPV  IN('5') AND ZG_USCORT<>' '"

IF !EMPTY(cPedX)
	cQuery+= " 		AND ZG_FILPED = '"+LEFT(cPedX,4)+"' AND ZG_NUM='"+RIGHT(cPedX,6)+"'"
else
	cQuery+= " 		AND ZG_DTRETLO=' '"	
Endif

cQuery+= " ORDER BY 1 DESC,3,2,5"

MemoWrit("C:\AA\RETORNO.TXT",cQuery)

dbUseArea(.t.,"TopConn", TcGenQry(,,cQuery),"QRY",.T.,.F.)


//Variveis de Controle do arquivo Webservice
cPostPar := '{"LOGISTICAA":{"ITENS": ['
nRecExpX := 0

dbSelectArea("QRY")
dbGotop()
While !EOF()
	
	nRecExpX ++
	if nRecExpX < 733 	//Limite do SIZE Overflow
		cPostPar += '{ '
		cPostPar += '"ACAOWS"    : "'+allTRIM(QRY->ACAOWS)+'",'
		cPostPar += '"ZG_NUM"    : "'+allTRIM(QRY->ZG_NUM)+'",'
		cPostPar += '"ZG_FILPED" : "'+allTRIM(QRY->ZG_FILPED)+'",'
		cPostPar += '"ZG_STAPV"  : "'+allTRIM(QRY->ZG_STAPV)+'",'
		cPostPar += '"ZG_ITEM"   : "'+allTRIM(QRY->ZG_ITEM)+'",'
		cPostPar += '"ZG_PRODUTO": "'+allTRIM(QRY->ZG_PRODUTO)+'",'

		//SEPARCAO		
		cPostPar += '"ZG_DTISP"  : "'+allTRIM(QRY->ZG_DTISP)+'",'
		cPostPar += '"ZG_DTFSP"  : "'+allTRIM(QRY->ZG_DTFSP)+'",'
		cPostPar += '"ZG_HRISP"  : "'+allTRIM(QRY->ZG_HRISP)+'",'
		cPostPar += '"ZG_HRFSP"  : "'+allTRIM(QRY->ZG_HRFSP)+'",'
		cPostPar += '"ZG_SEPAR"  : "'+allTRIM(QRY->ZG_SEPAR)+'",'

		//CONFERENCIA - CX(caixa)
		cPostPar += '"ZG_DTICF"  : "'+allTRIM(QRY->ZG_DTICF)+'",'
		cPostPar += '"ZG_DTFCF"  : "'+allTRIM(QRY->ZG_DTCCX)+'",'
		cPostPar += '"ZG_HRICF"  : "'+allTRIM(QRY->ZG_HRICF)+'",'
		cPostPar += '"ZG_HRFCF"  : "'+allTRIM(QRY->ZG_HRCCX)+'",'
		cPostPar += '"ZG_CONCX"  : "'+allTRIM(QRY->ZG_CONCX)+'",'

		//CONFERENCIA - GR(granel)
		cPostPar += '"ZG_DTIGR"  : "'+allTRIM(QRY->ZG_DTIGR)+'",'
		cPostPar += '"ZG_DTCGR"  : "'+allTRIM(QRY->ZG_DTCGR)+'",'
		cPostPar += '"ZG_HRIGR"  : "'+allTRIM(QRY->ZG_HRIGR)+'",'
		cPostPar += '"ZG_HRCGR"  : "'+allTRIM(QRY->ZG_HRCGR)+'",'
		cPostPar += '"ZG_CONGR"  : "'+allTRIM(QRY->ZG_CONGR)+'",'

		cPostPar += '"ZG_TLPCC"  : "'+allTRIM(QRY->ZG_TLPCC)+'",'
		cPostPar += '"ZG_TLPCG"  : "'+allTRIM(QRY->ZG_TLPCG)+'",'		
		
		cPostPar += '"ZG_VCXCO"	 : '+str(QRY->ZG_VCXCO)+","
		cPostPar += '"ZG_VGRCO"  : '+str(QRY->ZG_VGRCO)+","
		cPostPar += '"ZG_VOLUME1": '+str(QRY->ZG_VOLUME1)+","
		cPostPar += '"ZG_VOLUME2": '+str(QRY->ZG_VOLUME2)
		
		cPostPar += '}'
		cPostPar += ','
		
		
	Else
		
		//Envia para REST
		cPostPar := SUBSTR(cPostPar,1,LEN(cPostPar)-1)
		cPostPar += ']  }}'

		MemoWrit("C:\AA\SSSTXg.TXT",cPostPar)
		U_EnvWB02()
		
		cPostPar += '{ '
		cPostPar += '"ACAOWS"    : "'+allTRIM(QRY->ACAOWS)+'",'
		cPostPar += '"ZG_NUM"    : "'+allTRIM(QRY->ZG_NUM)+'",'
		cPostPar += '"ZG_FILPED" : "'+allTRIM(QRY->ZG_FILPED)+'",'
		cPostPar += '"ZG_STAPV"  : "'+allTRIM(QRY->ZG_STAPV)+'",'
		cPostPar += '"ZG_ITEM"   : "'+allTRIM(QRY->ZG_ITEM)+'",'
		cPostPar += '"ZG_PRODUTO": "'+allTRIM(QRY->ZG_PRODUTO)+'",'

		//SEPARCAO		
		cPostPar += '"ZG_DTISP"  : "'+allTRIM(QRY->ZG_DTISP)+'",'
		cPostPar += '"ZG_DTFSP"  : "'+allTRIM(QRY->ZG_DTFSP)+'",'
		cPostPar += '"ZG_HRISP"  : "'+allTRIM(QRY->ZG_HRISP)+'",'
		cPostPar += '"ZG_HRFSP"  : "'+allTRIM(QRY->ZG_HRFSP)+'",'
		cPostPar += '"ZG_SEPAR"  : "'+IF(LEN(QRY->ZG_SEPAR)=6, alltrim(UsrFullName(QRY->ZG_SEPAR)), alltrim(QRY->ZG_SEPAR))+'",'

		//CONFERENCIA - CX(caixa)
		cPostPar += '"ZG_DTICF"  : "'+allTRIM(QRY->ZG_DTICF)+'",'
		cPostPar += '"ZG_DTFCF"  : "'+allTRIM(QRY->ZG_DTCCX)+'",'
		cPostPar += '"ZG_HRICF"  : "'+allTRIM(QRY->ZG_HRICF)+'",'
		cPostPar += '"ZG_HRFCF"  : "'+allTRIM(QRY->ZG_HRCCX)+'",'
		cPostPar += '"ZG_CONCX"  : "'+allTRIM(QRY->ZG_CONCX)+'",'

		//CONFERENCIA - GR(granel)
		cPostPar += '"ZG_DTIGR"  : "'+allTRIM(QRY->ZG_DTIGR)+'",'
		cPostPar += '"ZG_DTCGR"  : "'+allTRIM(QRY->ZG_DTCGR)+'",'
		cPostPar += '"ZG_HRIGR"  : "'+allTRIM(QRY->ZG_HRIGR)+'",'
		cPostPar += '"ZG_HRCGR"  : "'+allTRIM(QRY->ZG_HRCGR)+'",'
		cPostPar += '"ZG_CONGR"  : "'+allTRIM(QRY->ZG_CONGR)+'",'

		cPostPar += '"ZG_TLPCC"  : "'+allTRIM(QRY->ZG_TLPCC)+'",'
		cPostPar += '"ZG_TLPCG"  : "'+allTRIM(QRY->ZG_TLPCG)+'",'		
		
		cPostPar += '"ZG_VCXCO"	 : '+str(QRY->ZG_VCXCO)+","
		cPostPar += '"ZG_VGRCO"  : '+str(QRY->ZG_VGRCO)+","
		cPostPar += '"ZG_VOLUME1": '+str(QRY->ZG_VOLUME1)+","
		cPostPar += '"ZG_VOLUME2": '+str(QRY->ZG_VOLUME2)
				
		cPostPar += '}'
		cPostPar += ','
		
	Endif
	
	DbSelectArea("QRY")
	Dbskip()
End

cPostPar := SUBSTR(cPostPar,1,LEN(cPostPar)-1)
cPostPar += ']  }}'

MemoWrit("C:\AA\SSSTXg.TXT",cPostPar)

//Envia para REST
If nRecExpX > 0
	
	//Atualiza os Dados na LOGISTICA
	U_EnvWB02()
	
Endif

Return



//Integração com REST
User Function EnvWB02()

Local cUrl      := alltrim(GETMV("ES_URLLOGR")) //"http://192.168.0.30:9003/LOGISTICAA" // WB_URLLOGI - SERVIDOR "LOGISTICA"
Local nTimeOut  := 30 //Segundos //### 03/09/2020
Local aHeaderStr:= {}
Local cHeaderRet:= ""
Local _aJsonFields	:= {}
Local _nRetParser	:= 0
Local _oJson		:= Nil
Local _oJHashMap	:= Nil

//aAdd(aHeaderStr,"Content-Type| application/x-www-form-urlencoded")
//aAdd(aHeaderStr,"Content-Length| " + Alltrim(Str(Len(cPostPar))) )

//HttpGetStatus()
//cComunic := HttpCGet( cUrl , cPostPar , nTimeOut , aHeaderStr , @cHeaderRet ) //### 03/09/2020
//cResponse := HttpCPost( cUrl , cPostPar , nTimeOut , aHeaderStr , @cHeaderRet )
_cPostRet:= HttpPost( cUrl, "", cPostPar, nTimeOut, aHeaderStr, @cHeaderRet ) 	
_nTamRetJs	:= Len( AllTrim( cValToChar( _cPostRet ) ) ) 									// Gera o tamanho da string do retorno
_oJson		:= tJsonParser():New()															// Cria o objeto para fazer o parser do Json
_lRetorno	:= .T.							// Ajusta o Retorno para os proximos produtos caso tenha gerado algum erro no produto anterior

// Faz o Parser da mensagem JSon e extrai para Array (aJsonfields) e cria tambem um HashMap para os dados da mensagem (_oJHashMap)
_lRetorno	:= _oJson:Json_Hash( _cPostRet, _nTamRetJs, @_aJsonFields, @_nRetParser, @_oJHashMap )

//VarInfo("Header:", cHeaderRet )
//VarInfo("Retorno:", cResponse )
//VarInfo("Erro:", HTTPGetStatus(cErro) )
//VarInfo("Erro:", cErro )
//Se gravou na LOGISTCA - FLAG ONDA
//if !Empty(cComunic) //cResponse) 
//If 'ok' $ cResponse						//### 03/09/2020
If _lRetorno				//### 03/09/2020
	//Retorno OK da Gravação - SZG
	cUpdSZG:= " UPDATE SZG010 SET ZG_DTRETLO = CONVERT(VARCHAR(10),GETDATE(),112), ZG_HRRETLO='"+Substr(Time(),1,5)+"' "
	cUpdSZG+= " WHERE "
	cUpdSZG+= " 	ZG_STAPV = '5' "	//Busca Pedido '5' CONFERENCIA FINALIZADA 
	cUpdSZG+= " 	AND ZG_DTRETLO=' ' "
	TcSqlExec(cUpdSZG)			//Ação(2)
Endif	
//else
	//Aviso("ATENCAO","SEM COMUNICAÇÃO, solicitação NÃO ATENDIDA, acione equipe da TI"+ Enter+Enter +"Rotina: "+FunName()+" - "+Dtoc(date())+" - "+substr(time(),1,5),{"CIENTE"})	
//Endif

Return
