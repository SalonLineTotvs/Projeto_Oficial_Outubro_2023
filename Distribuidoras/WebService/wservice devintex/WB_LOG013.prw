#INCLUDE 'rwmake.ch'
#Include "TopConn.Ch"
#DEFINE _EOL Chr(13) + Chr(10)	//Enter
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WB_LOG013 ºAutor  ³Andre Salgado       º Data ³  25/05/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Transferi Conferencia Finalizada para "Z1" Expedicao       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

//alltrim(GETMV("ES_LOG013T"))	//Parametro Criado para autorizar este processamento

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Rotina com chamado do Programa - ESTP0015.prw
User Function WB_LOG13(cOP)

PRIVATE cPostPar:= ""
PRIVATE cEmpPed := Substr(cOP,1,4)	//space(04)
PRIVATE cPedX 	:= Substr(cOP,5,6)	//space(06)
PRIVATE lRet	:= .F.


/*
//Tela Parametros
Set Device To Screen
@ 001,200 To 200,500 Dialog oNota Title OemToAnsi("Parametro Transferencia Expedicao")
@ 025,015 Say OemToAnsi("Empresa")
@ 025,070 Get cEmpPed SIZE 50,50
@ 040,015 Say OemToAnsi("Numero Pedido")
@ 040,070 Get cPedX SIZE 50,50
@ 087,070 BmpButton Type 1 Action Process()
@ 087,100 BmpButton Type 2 Action oNota:End()
Activate Dialog oNota Centered
Set Device To Print

Return


//Processa
Static Function Process()

IF Empty(cEmpPed)
	Alert("Informar o codigo da Distribuidora !")
	Return
Endif

IF Empty(cPedX )
	Alert("Informar o Numero do Pedido !")
	Return
Endif

MsAguarde({|| Atualiza()},"Processamento","Aguarde a finalização do processamento...")

Return



//Valida processo conforme Parametros Informados
Static Function Atualiza()
*/


If !empty(cEmpPed) .and. !Empty(cPedX)

	//Analise Status do Pedido
	If Select("QRZ") > 0
		dbSelectArea("QRZ")
		dbCloseArea()
	Endif

	cQuery := " SELECT ZG_PRODUTO, ZG_ITEM,                                         "
	cQuery += " CASE WHEN ZG_VCXCO>0 THEN ZG_VCXCO*B1_QE ELSE 0 END + ZG_VGRCO QTDCO"
	cQuery += " FROM SZG010 ZG WITH(NOLOCK)                                         "
	cQuery += " INNER JOIN SB1010 B1 ON ZG_PRODUTO=B1_COD AND B1.D_E_L_E_T_=' '     "
	cQuery += " WHERE ZG.D_E_L_E_T_=' ' AND ZG_STAPV  IN('4','5') AND ZG_USERCAN=' '    "
//	cQuery += " 	AND ZG_ITEM IN('01','02') "
	cQuery += " AND ZG_FILPED = '"+cEmpPed+"' AND ZG_NUM='"+cPedX +"'               "
	cQuery += " AND (CASE WHEN ZG_VCXCO>0 THEN ZG_VCXCO*B1_QE ELSE 0 END + ZG_VGRCO)>0"
	cQuery += " ORDER BY ZG_ITEM							"

	dbUseArea(.t.,"TopConn", TcGenQry(,,cQuery),"QRZ",.T.,.F.)


	dbSelectArea("QRZ")
	dbGotop()

	While !EOF()

		//Gera Transferencia Local "01" para "Z1"
		IF !EMPTY(QRZ->ZG_PRODUTO)
			lRet := .T.
			//ESTP0010(PRODUTO, QUANTIDADE, LOTE, DT VALID, LOCAL ORIGINAL, LOCAL DESTINO, OBSERVACAO)
			U_ESTP0010(QRZ->ZG_PRODUTO, QRZ->QTDCO,"",CTOD("  /  /  "), "01", "Z1", cEmpPed+cPedX+QRZ->ZG_ITEM)
		Endif

		dbSelectArea("QRZ")
		Dbskip()
	End



	//Atualiza Produtos Transferidos
	IF lRet
		cUpdSZG := " UPDATE SZG010 SET ZG_USERCAN='Z1' WHERE ZG_STAPV IN('4','5') AND ZG_FILPED = '"+cEmpPed+"' AND ZG_NUM='"+cPedX +"' "
		TcSqlExec(cUpdSZG)
	Endif


	//Limpa Variaveis
	cEmpPed := space(04)
	cPedX 	:= space(06)

Endif

Return
