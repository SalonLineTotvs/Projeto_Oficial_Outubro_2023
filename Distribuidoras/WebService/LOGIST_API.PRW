#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "rwmake.ch"
#INCLUDE "protheus.ch"
#include "colors.ch"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#include 'COLORS.CH'
#Include "prtopdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOGIST_API  ºAutor  Tiberio            º Data ³  22/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Métodos API Rest                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico ()                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LOGIST_API
RETURN

//Metodo Post
WSRESTFUL LOGISTICAA DESCRIPTION "Serviço Rest para input de dados em tabela PEDIDO DE VENDA (SC5 / SC6) rev.07"

WSMETHOD POST DESCRIPTION "Metodo responsável por Receber dados da Logistica dos Produtos atendidos conforme informação da tabela SZG" WSSYNTAX "/LOGISTICAA"

END WSRESTFUL

WSMETHOD POST WSSERVICE LOGISTICAA

Local cBody       := ::GetContent() //retorna o conteudo do body
Local cKey        := "1234"  //SuperGetMV("MV_XAPIKEY",.F.,"1234")
Local nparam      := 1
Local lLog        := .T.
Local i           := 0

Private oData //objeto com os dados do body
Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .T.
Private cJsonErro      := '{"erro":"'
Private aItens         := {}

// define o tipo de retorno do método
::SetContentType("application/json")

//valida se o json foi deserealizado
if  !FWJsonDeserialize( cBody,@oData)
	//Retorna BadResquest
	SetRestFault(400, "ERROR ON DESERIALIZE JSON, VERIFY JSON ON BODY")
	return .F.
endif

aItens := aClone(oData:LOGISTICAA:ITENS)   // carrega matriz

//verifica se os dados foram preenchidos corretamente
if  LEN(aItens) == 0
	//Retorna BadResquest
	SetRestFault(400, "Invalid JSON Body")
	return .F.
endif

/*
if cKey != oData:apiKey
//Retorna Forbidden (nao autorizado)
SetRestFault(403,"Falha durante o login, verifique a chave")
return .F.
endif
*/

// Seta job para nao consumir licensas
//RpcSetType(3)
// Seta job para empresa filial desejadas
//RpcSetEnv( CEMP,CFIL,,, "EST", "BSAUTOR", {"SD3","SC2","SD4","SB1","SG1","SD4"}, , , ,  )
//RpcSetEnv( "02","0501",,, "FAT", "MATA410", {"SC5","SC6"}, , , ,  )

// Chama Rotina Customizada de Apontamento
U_INPUTLOGIS()

::SetResponse(cJsonErro)

return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INPUTONDA ºAutor  ³Microsiga           º Data ³  06/27/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui dados                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function INPUTLOGIS()

Local nCont     := 0
Local cAchouS := "x"

For n := 1 To Len(aItens)

	//Carrega as Variaveis
	cAcaoWS   := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ACAOWS)		//AÇÃO GRAVACAO
	xFilOrig  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_FILPED)	//Filial Origem - Distribuidora
	xPedOrig  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_NUM)		//Pedido de Venda
	xStausPV  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_STAPV)	//Status
	
	xItemProd := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_ITEM)   	//Item
	xProduto  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_PRODUTO)	//Produto

	//Data/Hora Inicial e Final (Separador)
	cDTISP	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_DTISP)	//Dt Inicio Separacao
	cDTFSP	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_DTFSP)	//Dt Final Separacao
	cHRISP 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_HRISP)	//Hr Inicio Separacao
	cHRFSP 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_HRFSP)	//Hr Final Separacao
	cNomSP	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_SEPAR)	//Nome Separador

	//Data/Hora Inicial e Final (Conferente CX)
	cDTICX	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_DTICF)	//Dt Inicio Conferencia
	cDTFCX	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_DTFCF)	//Dt Final Conferencia
	cHRICX 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_HRICF)	//Hr Inicio Conferencia
	cHRFCX 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_HRFCF)	//Hr Final Conferencia
	cNomLogCF := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_CONCX)	//Usuario Conferente
//	cCFSEP	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_CFSEP)	//Tipo Conferencia Coletor

	//Data/Hora Inicial e Final Conferente GR
	cDTIGR	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_DTIGR)	//Dt Inicio Separacao
	cDTFGR 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_DTCGR)	//Dt Final Separacao
	cHRIGR 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_HRIGR)	//Hr Inicio Separacao
	cHRFGR 	  := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_HRCGR)	//Hr Final Separacao
	cNomLogGR := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_CONGR)	//Nome Conferente GR

	cLicPVTP := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_TLPCC)		//LIBERACAO T=Total ou P=Parcial - CX
	cLicPVTG := ALLTRIM(oData:LOGISTICAA:ITENS[n]:ZG_TLPCG)		//LIBERACAO T=Total ou P=Parcial - GR	

	nQtdCoCX  := oData:LOGISTICAA:ITENS[n]:ZG_VCXCO				//Conferencia CX
	nQtdCoGR  := oData:LOGISTICAA:ITENS[n]:ZG_VGRCO 			//Conferencia GR
	nVolCoCX  := oData:LOGISTICAA:ITENS[n]:ZG_VOLUME1 			//Conferencia Volume CX
	nVolCoGR  := oData:LOGISTICAA:ITENS[n]:ZG_VOLUME2 			//Conferencia Volume GR

	//Ação - 1 Recebe Informação da Conclusão da Separação
	/*
	IF cAcaoWS="S"

		//Input Dados SC5
		DbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilOrig + xPedOrig )) .and. SC5->C5_X_STAPV <= "5"
			Reclock("SC5",.F.)
			SC5->C5_X_STAPV := xStausPV		//Status Separaçao 3 Finalizada
			SC5->C5_X_CFSEP := " "			//Flag Conferenci
			SC5->C5_ESPECI3	:= substr(dtos(date()),3,8) + substr(time(),1,2) + substr(time(),4,2)

			IF nVolCoCX>0 .OR. nVolCoGR>0
				If SC5->C5_X_ANTEC <> '1'
					SC5->C5_VOLUME1 := nVolCoCX //Quantidade Volume em CX
					SC5->C5_VOLUME2 := nVolCoGR //Quantidade Volume em GR
				EndIf
				SC5->C5_X_TLPCC := cLicPVTP
				SC5->C5_X_TLPCG := cLicPVTG
			Endif
 
			//SEPARACAO
			IF EMPTY(SC5->C5_X_DTFSP) //.and. !Empty(cDTISP)			
				SC5->C5_X_DTISP	:= STOD(cDTISP)	//Data Inicio Separacao
				SC5->C5_X_HRISP	:= cHRISP		//Hora Inicio Separacao
				SC5->C5_X_DTFSP	:= STOD(cDTFSP)	//Data Final Separacao
				SC5->C5_X_HRFSP := cHRFSP	 	//Data Final Separacao
				SC5->C5_X_SEPAR	:= cNomSP	  	//Separador
			Endif

			//CX - CAIXA
			IF EMPTY(SC5->C5_X_DTCCX) //.and. !Empty(cDTICX)
				SC5->C5_X_DTICF	:= STOD(cDTICX)	//Data Inicio Conferencia CX
				SC5->C5_X_HRICF	:= cHRICX		//Hora Inicio Conferencia CX
				SC5->C5_X_DTCCX	:= STOD(cDTFCX)	//Data Conclusao conferencia CX
				SC5->C5_X_HRCCX := cHRFCX		//Hora Conclusao conferencia CX
				SC5->C5_X_CONCX := cNomLogCF	//Codigo Coletor CX
			Endif

			//GR - GRANEL
			IF EMPTY(SC5->C5_X_DTCGR) //.and. !Empty(cDTIGR)
				SC5->C5_X_DTIGR	:= STOD(cDTIGR)	//Data Inicio Conferencia GR
				SC5->C5_X_HRIGR	:= cHRIGR		//Hora Inicio Conferencia GR
				SC5->C5_X_DTCGR	:= STOD(cDTFGR)	//Data Conclusao Conferencia GR
				SC5->C5_X_HRCGR := cHRFGR		//Hora Conclusao Conferencia GR
				SC5->C5_X_CONGR := cNomLogGR	//Codigo Coletor GR		
    		Endif

			SC5->(MsUnlock())
			cAchouS := "S "+xFilOrig + xPedOrig
		eLSE
			cAchouS := "nao "+xFilOrig + xPedOrig
		Endif


	//Ação - 3 Corte de Pedido (Quantidade não atendida)
	//ElseIF cAcaoWS="C"
	
		//cRefPesq := xFilOrig + xPedOrig
		//DbSelectArea("SC5")
		//SC5->(dbSetOrder(1))
		//If SC5->(dbSeek(xFilOrig + xPedOrig ))

			//Gerar CORTE
			//U_GERAPVWB(cRefPesq)

		//Endif
		

	//Ação - 2 Recebe Informação da Conclusão da Conferencia
	Else
	*/
		//Input Dados SC5
		DbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilOrig + xPedOrig)) //.and. SC5->C5_X_STAPV<"5"

			xStaPVAtual := SC5->C5_X_STAPV

			Reclock("SC5",.F.)

			//Regra do Status
			IF xStaPVAtual = "A"
				SC5->C5_X_STAPV := "6"	//Status Pedido Conferido após Faturamento Antecipado
			elseIF xStaPVAtual > "5"

			Else
				SC5->C5_X_STAPV := xStausPV	//Status Separaçao 3 Finalizada
			Endif

			SC5->C5_X_CFSEP := "" 		//"3" //cCFSEP	//Flag Conferencia Via Coletor
			SC5->C5_ESPECI3	:= substr(dtos(date()),3,8) + substr(time(),1,2) + substr(time(),4,2)

			IF nVolCoCX>0 .OR. nVolCoGR>0
				If SC5->C5_X_ANTEC <> '1'
					SC5->C5_VOLUME1 := nVolCoCX //Quantidade Volume em CX
					SC5->C5_VOLUME2 := nVolCoGR //Quantidade Volume em GR
				EndIf
				SC5->C5_X_TLPCC := cLicPVTP
				SC5->C5_X_TLPCG := cLicPVTG
			Endif
 
			//SEPARACAO
			IF EMPTY(SC5->C5_X_DTFSP) //.and. !Empty(cDTISP)			
				SC5->C5_X_DTISP	:= STOD(cDTISP)	//Data Inicio Separacao
				SC5->C5_X_HRISP	:= cHRISP		//Hora Inicio Separacao
				SC5->C5_X_DTFSP	:= STOD(cDTFSP)	//Data Final Separacao
				SC5->C5_X_HRFSP := cHRFSP	 	//Data Final Separacao
				SC5->C5_X_SEPAR	:= cNomSP	  	//Separador
			Endif

			//CX - CAIXA
			IF EMPTY(SC5->C5_X_DTCCX) //.and. !Empty(cDTICX)
				SC5->C5_X_DTICF	:= STOD(cDTICX)	//Data Inicio Conferencia CX
				SC5->C5_X_HRICF	:= cHRICX		//Hora Inicio Conferencia CX
				SC5->C5_X_DTCCX	:= STOD(cDTFCX)	//Data Conclusao conferencia CX
				SC5->C5_X_HRCCX := cHRFCX		//Hora Conclusao conferencia CX
				SC5->C5_X_CONCX := cNomLogCF	//Codigo Coletor CX
			Endif

			//GR - GRANEL
			IF EMPTY(SC5->C5_X_DTCGR) //.and. !Empty(cDTIGR)
				SC5->C5_X_DTIGR	:= STOD(cDTIGR)	//Data Inicio Conferencia GR
				SC5->C5_X_HRIGR	:= cHRIGR		//Hora Inicio Conferencia GR
				SC5->C5_X_DTCGR	:= STOD(cDTFGR)	//Data Conclusao Conferencia GR
				SC5->C5_X_HRCGR := cHRFGR		//Hora Conclusao Conferencia GR
				SC5->C5_X_CONGR := cNomLogGR	//Codigo Coletor GR		
    		Endif
    		
			SC5->(MsUnlock())
			cAchouS := "t "+xFilOrig + xPedOrig

			//Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9
			cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
			cTxtSC9 += " WHERE "
			cTxtSC9 += " C9_PEDIDO = '"+xPedOrig+"' AND C9_FILIAL='"+xFilial(xFilOrig)+"' AND C9_NFISCAL=' ' AND C9_BLEST<>' '"
			TcSqlExec(cTxtSC9)
			
		eLSE
			cAchouS := "g "+xFilOrig + xPedOrig
		Endif
		
		//Input Dados SC6
		DBSelectarea("SC6")
		DBSetOrder(2)
		If SC6->(dbSeek(xFilOrig + Padr(xProduto,15) + xPedOrig ))
			Reclock("SC6",.F.)
			SC6->C6_X_VCXCO := nQtdCoCX
			SC6->C6_X_VGRCO := nQtdCoGR
			msunlock()
		Endif

	//Endif

	nCont ++
	
Next n

	//*******************************************************
	// ROTINA PARA FAZER O CORTE
	//********************************************************
	U_GERAPVWB(cRefPesq)
	
	

cJsonErro := '{"ok":" '+Alltrim(Str(nCont))+' registros incluidos com sucesso !!!'+cAchouS+' }'

Return()
	