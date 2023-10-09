#Include "Protheus.Ch"
#Include "RwMake.Ch"
#Include "TopConn.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460QRY   บAutor  ณAndre Salgado       บ Data ณ  09/02/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada FILTRA e s๓ Autorizar os Pedidos de Venda  บฑฑ
ฑฑบ          ณ Campo C5_X_STAPV = '5' ou  C5_X_STAPV = 'A'                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SALON LINE -  SOLICITAวรO - GENILSON LUCAS                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460QRY()

Local cQry	:= ""
Local cParam:= PARAMIXB[1]
Local nTipo	:= PARAMIXB[2]
Local aArea := GetArea()


IF SM0->M0_CODIGO="02"	//S๓ Processar para Empresa DISTRIBUIDORA
	
	If nTipo == 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTira as aspas simples da primeira e ultima posicao.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cParam:= SubStr(Alltrim(cParam),1,Len(cParam))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do Update Filtro Stastus Pedido                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQry:= " UPDATE "+RetSqlName("SC9")+" SET C9_CODISS = C5_X_STAPV"
		cQry+= " FROM "+RetSqlName("SC9")+" SC9 "
		cQry+= " INNER JOIN "+RetSqlName("SC5")+" SC5 "
		cQry+= " ON SC5.D_E_L_E_T_ = ' '"
		cQry+= " AND C5_NUM    = C9_PEDIDO"
		cQry+= " AND C5_FILIAL = C9_FILIAL"
		cQry+= " WHERE"
		cQry+= " C5_X_STAPV in ('5','A')"		//REGRA CAMPO STATUS (FILTRAR 5 e A)
		cQry+= " AND C5_TIPOCLI <> 'X' "		// VALMIR 02/07/2018 (NAO ATULIZAR PARA PEDIDO DE EXPORTAวรO)
		cQry+= " AND SC9.D_E_L_E_T_ = ' '"
		cQry+= " AND " + cParam
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta Update no arquivo SC9.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF TcSqlExec(cQry) < 0
			MsgStop("Erro ao executar a instru็ใo " + CRLF + TCSQLError() )
			Return()
		Endif
		
		cParam+= " AND SC9.C9_CODISS IN('5','A') "
		
	EndIf
Endif
RestArea(aArea)

Return(cParam)
