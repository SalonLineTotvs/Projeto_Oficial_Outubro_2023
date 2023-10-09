#INCLUDE 'rwmake.ch'
#Include "TopConn.Ch"
#DEFINE _EOL Chr(13) + Chr(10)	//Enter
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WB_LOG001 ºAutor  ³TIBERIO OSNI        º Data ³  08/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia dos dados para Servidor B                            º±±
±±º          ³ Foi criado uma tabela na base da B (01)                    º±±
±±º          ³ ALIAS - SZG - Campos para receber de Vendas (02)           º±±
±±º          ³ Foram criados só os campos necessarios para B              º±±
±±º          ³                                                            º±±
±±º          ³ Informar (VARIAVEL) numero da Onda para buscar nos Ped.Vda º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
> AÇÃO(1) - Rotina de montagem ONDA envia os dados para B - Responsavel Usuario Vendas
> AÇÃO(2) - Será enviado o cadastro de Produtos para B
> AÇÃO(3) - Flag data (B1_DTREFP1 ) na tabela SB1020 - Atualiza Flag no final do Processamento com RESTOR REST
> AÇÃO(4) - Flag data (Z4_DTENLOG ) na tabela SC5020 - Será atualizado no Programa REST WebService
> CRIAR   - PARAMETRO ES_URLLOG1 - Tipo Caracter - Conteudo - http://192.168.0.30:9003/ONDA  - Descricao - Endereço URL Webservice Incluir Pedido Venda

// ALTERAÇÕES
Data 21/08/2020 - Autor André Salgado - Melhoria para corrigir problema de envio de dados para Logistica
> Liberado na Query para trazer o Codigo Z3_SIGLA, para todas as Transportadora que tiver Banco SZ3
> Retirar Caracter Especiais na Transmissão

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Ação - Envia Pedido de Venda para (Servidor B)
User Function WB_LOG098()


Local aAreaSC5  := SC5->(GetArea())   
Local cPedido   := C5_NUM
Local cfilial   := C5_FILIAL
Local ccliente   := C5_CLIENTE
Local cloja   := C5_LOJACLI
Local ctransp   := C5_TRANSP

PRIVATE cPostPar:= ""
PRIVATE nRecExpX:= 0
PRIVATE cPed	:= ""
public cerr :=""

If ALLTRIM(SC5->C5_X_STAPV) == "A"
	If MsgYesNo("Deseja Reenviar o Pedido "+cPedido+" para Logistica ?","Atenção")   

		If Select("QRY") > 0
			dbSelectArea("QRY")
			dbCloseArea()
		Endif

		If Select("QRX") > 0
			dbSelectArea("QRX")
			dbCloseArea()
		Endif

		ccep := Posicione("SA1",1,XFILIAL("SA1") + ccliente + cloja, "A1_CEP")   //posicione ()  A1_CEP BETWEEN Z3_CEP_INI  AND Z3_CEP_FIN
		cuf :=  Posicione("SA1",1,XFILIAL("SA1") + ccliente + cloja, "A1_EST")  // A1_EST=Z3_UF
		cemp := Posicione("SA4",1,XFILIAL("SA4") + ctransp , "A4_ECSERVI")  //A4_ECSERVI=Z3_EMPRESA

		cQuery0:= " SELECT " 
		cQuery0+= " top 1 Z3_EMPRESA, Z3_UF, Z3_CEP_INI, Z3_CEP_FIN,Z3_SIGLA, Z3_SETOR FROM SZ3020 WITH(NOLOCK)  "
		cQuery0+= " WHERE D_E_L_E_T_=' '   "
		cQuery0+= " AND '"+ccep+"'  between Z3_CEP_INI and Z3_CEP_FIN   "
 		cQuery0+= " 	AND Z3_UF= '"+cuf+"'   "
	 	cQuery0+= "	AND  Z3_EMPRESA='"+cemp+"'    "
	//	cQuery0+= " order by  Z3_SIGLA desc   

		dbUseArea(.t.,"TopConn", TcGenQry(,,cQuery0),"QRX",.T.,.F.)


		dbSelectArea("QRX")
		dbGotop()

		csigla := alltrim(QRX->Z3_SIGLA)
		csetor := alltrim(QRX->Z3_SETOR)

		//faço update no campo C5_ESPECIE para Vazio , pois é a regra atual
		cUpdSC5:= " UPDATE SC5020 SET C5_ESPECI3='' WHERE C5_FILIAL='"+cfilial+"' AND C5_NUM='"+cPedido+"' AND D_E_L_E_T_=' '  "
		TcSqlExec(cUpdSC5)	

		//Busca dados dos Pedido de Venda
		//Ação (1) - Busca dados da ONDA
		cQuery:= " SELECT"
		cQuery+= " 	C6_NUM, C6_FILIAL, C6_ITEM, C5_X_NONDA, C6_CLI, C6_LOJA, C6_NUMPCOM, A1_NREDUZ, C6_PRODUTO, C5_EMISSAO, C5_X_STAPV,"
		cQuery+= " 	C6_QTDVEN, C6_X_VCXIM, C6_X_VGRIM, C6_X_VCXCO, C6_X_VGRCO, C6_X_RESID, C6_TES, C5_VOLUME1, C5_VOLUME2,"
		cQuery+= " 	C5_X_DTICF, C5_X_HRICF, C5_X_CONCX, C5_X_DTCCX, C5_X_HRCCX, C5_X_CONGR,"
		cQuery+= " 	C5_X_DTCGR, C5_X_HRCGR, C5_X_DTIGR, C5_X_HRIGR, C5_X_CFSEP, "
		cQuery+= " 	C5_X_DTISP, C5_X_HRISP, C5_X_DTFSP, C5_X_HRFSP, C5_X_SEPAR,"
		cQuery+= " 	C5_X_TVLCX, C5_X_TVLGR, "
		cQuery+= " 	A4_ECSERVI, A4_NREDUZ, A1_MUN, A1_EST, A1_CEP, CASE WHEN C5_X_ANTEC<>'2' THEN C5_X_ANTEC ELSE ' ' END C5_X_ANTEC,"
		cQuery+= " 	ISNULL(Z3_SIGLA,'  ') ZG_SIGLA, ISNULL(Z3_SETOR,'') ZG_SETOR"

		cQuery+= " FROM SC5020 C5 WITH(NOLOCK)"
		cQuery+= " 	INNER JOIN SC6020 C6 WITH(NOLOCK) ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C6.D_E_L_E_T_=' '"
		cQuery+= " 	INNER JOIN SA1020 A1 WITH(NOLOCK) ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND A1.D_E_L_E_T_=' '"
		//Campo utilizado para FLAG os Pedidos já enviados
		//cQuery+= " 	INNER JOIN SZ4020 Z4 WITH(NOLOCK) ON C5_X_NONDA=Z4_NUMONDA AND Z4.D_E_L_E_T_=' ' AND Z4_DTENLOG=' '"//Busca os Pedidos Autorizados
		cQuery+= " 	LEFT  JOIN SA4020 A4 WITH(NOLOCK) ON C5_TRANSP=A4_COD  AND A4.D_E_L_E_T_=' '"
		cQuery+= " 	LEFT  JOIN 	
		cQuery+= " 	(SELECT DISTINCT Z3_EMPRESA, Z3_UF, Z3_CEP_INI, Z3_CEP_FIN,Z3_SIGLA, Z3_SETOR FROM SZ3020 WITH(NOLOCK) WHERE D_E_L_E_T_=' ')TRANS"
		cQuery+= " 	 ON A4_ECSERVI=Z3_EMPRESA AND A1_EST=Z3_UF "// DESABILITADO EM 21/08/2020 PARA TRAZER PARA TODAS AS TRANSPORTADA...AND A4_NREDUZ='ATIVA' 
		cQuery+= " 	 AND A1_CEP BETWEEN Z3_CEP_INI  AND Z3_CEP_FIN AND Z3_SIGLA='"+csigla+"' "

		cQuery+= " WHERE C5.D_E_L_E_T_=' '"
		cQuery+= " and C5_NUM = '"+cPedido+"'     "
		cQuery+= " and C5_FILIAL='"+cfilial+"'  "
		cQuery+= " 		AND C5_ESPECI3=' '"	//Flag dos Pedidos Já transmitidos para LOGISTICA
		cQuery+= " ORDER BY C6_FILIAL, C6_NUM,C6_ITEM"



		cUpdSZ4:= " UPDATE SZ4020 SET Z4_HRENLOG = '.'"
		cUpdSZ4+= " WHERE "
		cUpdSZ4+= " Z4_DTENLOG=' ' "		    //Campo utilizado para FLAG os Pedidos já enviados
		TcSqlExec(cUpdSZ4)			//Ação (4)

		dbUseArea(.t.,"TopConn", TcGenQry(,,cQuery),"QRY",.T.,.F.)


		dbSelectArea("QRY")
		dbGotop()

		While !EOF()
			
			//Variveis de Controle do arquivo Webservice
			cPostPar:= '{"ONDA":{"ITENS": ['		//Estrutura
			nRecExpX:= 0							//Contador Linha
			cPed	:= QRY->C6_FILIAL+QRY->C6_NUM	//Envia Cada Pedido WebService

			
			While !EOF() .and. cPed	= QRY->C6_FILIAL+QRY->C6_NUM
				
				nRecExpX ++
				
				cPostPar += '{ '+_EOL
				cPostPar += '"ZG_NUM"    : "'+QRY->C6_NUM+'",'+_EOL
				cPostPar += '"ZG_FILPED" : "'+QRY->C6_FILIAL+'",'+_EOL
				cPostPar += '"ZG_ITEM"   : "'+QRY->C6_ITEM+'",'+_EOL
				cPostPar += '"ZG_NONDA"  : "'+QRY->C5_X_NONDA+'",'+_EOL
				cPostPar += '"ZG_CLI"    : "'+QRY->C6_CLI+'",'+_EOL
				cPostPar += '"ZG_LOJA"   : "'+QRY->C6_LOJA+'",'+_EOL
				cPostPar += '"ZG_NREDUZ" : "'+TRIM(FwNoAccent(QRY->A1_NREDUZ))+'",'+_EOL
				cPostPar += '"ZG_PRODUTO": "'+TRIM(QRY->C6_PRODUTO)+'",'+_EOL
				cPostPar += '"ZG_ECSERVI": "'+QRY->A4_ECSERVI+'",'+_EOL
				cPostPar += '"ZG_NREDUZT": "'+TRIM(FwNoAccent(QRY->A4_NREDUZ))+'",'+_EOL
				cPostPar += '"ZG_MUN"    : "'+TRIM(FwNoAccent(QRY->A1_MUN))+'",'+_EOL
				cPostPar += '"ZG_EST"    : "'+QRY->A1_EST+'",'+_EOL
				cPostPar += '"ZG_CEP"    : "'+QRY->A1_CEP+'",'+_EOL
				cPostPar += '"ZG_EMISSAO": "'+QRY->C5_EMISSAO+'",'+_EOL
				cPostPar += '"ZG_QTDVEN": '+str(QRY->C6_QTDVEN)+","+_EOL
				cPostPar += '"ZG_VCXIM" : '+str(QRY->C6_X_VCXIM)+","+_EOL
				cPostPar += '"ZG_VGRIM" : '+str(QRY->C6_X_VGRIM)+","+_EOL
				cPostPar += '"ZG_TLNCX" : '+str(QRY->C5_X_TVLCX)+","+_EOL
				cPostPar += '"ZG_TLNGR" : '+str(QRY->C5_X_TVLGR)+","+_EOL

				cPostPar += '"ZG_ANTEC" : "'+TRIM(QRY->C5_X_ANTEC)+'",'+_EOL
				cPostPar += '"ZG_SIGLA" : "'+TRIM(QRY->ZG_SIGLA)+'",'+_EOL
				cPostPar += '"ZG_SETOR" : "'+TRIM(QRY->ZG_SETOR)+'",'+_EOL

				cPostPar += '"ZG_LINHA" : '+Alltrim(Str(nRecExpX))+_EOL
				cPostPar += '}'
				cPostPar += ','
				
				DbSelectArea("QRY")
				Dbskip()
			End
			
			//Envia para REST
			cPostPar := SUBSTR(cPostPar,1,LEN(cPostPar)-1)
			cPostPar += ']  }}'

			U_Envpost0(cPed)

			DbSelectArea("QRY")
			
		End
		If	"SUCESSO" $ cerr
		MsgInfo("O Pedido "+cPedido+" foi integrado com sucesso na Logistica.","Aviso")
		else
		MsgInfo("O Pedido "+cPedido+" NAO integrado.","Aviso")
		endif
	EndIf
Else
	MsgAlert("Pedido de Venda já está faturado, favor verificar!","integração não Realizada")
EndIf

RestArea(aAreaSC5)

//Return 

//CORTE DE PEDIDO - PLANO B, acionar quando nao funcionar WS
/*
cQuery1:= " SELECT C5_FILIAL, C5_NUM FROM SC5020 WITH(NOLOCK)"
cQuery1+= " 	WHERE D_E_L_E_T_=' ' AND RIGHT(C5_ESPECI3,1)='C'"
cQuery1+= " AND (C5_X_TLPCC='P' OR C5_X_TLPCG='P')"
cQuery1+= " AND C5_ESPECI2=' ' "
cQuery1+= " AND C5_X_DTICF>='20200225'"

If Select("QR1") > 0
	dbSelectArea("QR1")
	dbCloseArea()
Endif

dbUseArea(.t.,"TopConn", TcGenQry(,,cQuery1),"QR1",.T.,.F.)


dbSelectArea("QR1")
dbGotop()
While !EOF()

	cRefPesq := QR1->C5_FILIAL + QR1->C5_NUM

	//U_GeraPVWB(cRefPesq)	

	DbSelectArea("QR1")
	Dbskip()
End
*/

Return



//Integração com REST

User Function Envpost0(cPed)

Local cUrl      := alltrim(GETMV("ES_URLLOG1")) //"http://192.168.0.10:9003/ONDA" // WB_URLLOG1 - SERVIDOR "B"  //alltrim(GETMV("ES_URLLOG1"))
Local nTimeOut  := 30 //Segundos
Local aHeaderStr:= {}
Local cHeaderRet:= ""
Local cResponse := ""
Local cErro     := ""
Local Enter	 	:= CHR(13)+CHR(10)
public cerr :=""

aAdd(aHeaderStr,"Content-Type| application/x-www-form-urlencoded")
aAdd(aHeaderStr,"Content-Length| " + Alltrim(Str(Len(cPostPar))) )
//aAdd(aHeaderStr,"GET /res/sample")
//aAdd(aHeaderStr,"Host: localhost:8080")
//aAdd(aHeaderStr,"Accept:application/json")
//aAdd(aHeaderStr,"tenantId:01,1001")

//HttpGetStatus()
//cComunic := HttpCGet( cUrl , cPostPar , nTimeOut , aHeaderStr , @cHeaderRet )		//DESABILIDADO POIS VAMOS USAR O cREsponse
cResponse:= HttpCPost( cUrl , cPostPar , nTimeOut , aHeaderStr , @cHeaderRet ) 
cerr:=cResponse
VarInfo("Header:", cHeaderRet )
VarInfo("Retorno:", cResponse )
VarInfo("Erro:", HTTPGetStatus(cErro) )
VarInfo("Erro:", cErro )

//msginfo(cErro,"cErro")
//msginfo(cResponse,"cResponse")


//if !Empty(cComunic) //cResponse) 	//Precisei trocar para validar se o serviço esta ativo  -  cResponse, não retorna
//VALIDA CONEXÃO
If alltrim(cErro) <> "Created"
	Aviso("ERRO DE COMUNICAÇÃO","Webserve sem comunicação, integração NÃO REALIZADA, acione equipe da TI"+ Enter+Enter +"Pedido: "+cPed+ Enter + Enter +"Rotina: "+FunName()+" - "+Dtoc(date())+" - "+substr(time(),1,5),{"CIENTE"})
	
//VALIDA SE TEVE RETORNO POSITIVO
ElseIf	"SUCESSO" $ cResponse
	
	//FLAG PEDIDO
	cUpdSC5:= " UPDATE SC5020 SET C5_ESPECI3='X' WHERE C5_FILIAL='"+SUBSTR(cPed,1,4)+"' AND C5_NUM='"+SUBSTR(cPed,5,6)+"' and C5_ESPECI3=' ' "
	TcSqlExec(cUpdSC5)			//Ação (4)

/*	//Retorno OK da Gravação - SZ4
	cUpdSZ4:= " UPDATE SZ4020 SET Z4_DTENLOG = CONVERT(VARCHAR(10),GETDATE(),112), Z4_HRENLOG = '"+SUBSTR(TIME(),1,5)+"'"
	cUpdSZ4+= " WHERE "
	cUpdSZ4+= " Z4_HRENLOG = '.'"
	cUpdSZ4+= " AND Z4_DTENLOG = ' '"	//Campo utilizado para FLAG os Pedidos já enviados para Logistica
	TcSqlExec(cUpdSZ4)			//Ação (4)
*/

Else
	Aviso("Pedido NÃO Integrado","Integração não realizada do Pedido "+cPed+", acione equipe da TI."+ Enter+Enter +"Rotina: "+FunName()+" - "+Dtoc(date())+" - "+substr(time(),1,5),{"CIENTE"})
Endif
	
Return()

