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
±±ºPrograma  ³ONDAAPI    ºAutor  Tiberio             º Data ³  22/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Métodos API Rest                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico ()                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION ONDAAPI
RETURN

//Metodo Post
WSRESTFUL ONDA DESCRIPTION "Serviço Rest para input de dados em tabela customizada"

WSMETHOD POST DESCRIPTION "Metodo responsável por Receber dados e incluir em tabela SZG" WSSYNTAX "/ONDA"

END WSRESTFUL

WSMETHOD POST WSSERVICE ONDA

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

aItens := aClone(oData:ONDA:ITENS)    // carrega matriz

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

// Chama Rotina Customizada de Apontamento
U_INPUTONDA()

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
User Function INPUTONDA()

//Local aGetArea  := GetArea()
Local cFilial   := ""
Local nQtdVen   := 0
Local cNum      := ""
Local nCont     := 0


For n := 1 To Len(aItens)
	
	//Carrega as Variaveis - SZG
	cNum    := ALLTRIM(oData:ONDA:ITENS[n]:ZG_NUM)		//Pedido de Venda
	cFilPV  := ALLTRIM(oData:ONDA:ITENS[n]:ZG_FILPED)	//Distribuidora de Orige
	cItemPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_ITEM)		//Item PV
	cOnda	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_NONDA)	//Onda
	cCliPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_CLI)		//Cliente
	cLjPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_LOJA)		//Loja
	//cNPCom	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_NUMPCOM)	//Num PC Cliente
	cNReduz	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_NREDUZ)	//Nome CLiente
	cProdPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_PRODUTO)	//Produto
	cECSERV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_ECSERVI)	//Tipo Servico Transportadora
	cNRedTra:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_NREDUZT)	//Transportadora
	cMUNPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_MUN)		//Municipio PV
	cESTPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_EST)		//Estado UF
	cCEPPV	:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_CEP)		//CEP
	cEmisPV := ALLTRIM(oData:ONDA:ITENS[n]:ZG_EMISSAO)	//Emissao - DATA
	nQtdVen	:= oData:ONDA:ITENS[n]:ZG_QTDVEN			//Quantidade de Venda
	nQtdCXI	:= oData:ONDA:ITENS[n]:ZG_VCXIM				//QTD CX Impressa
	nQtdGRI	:= oData:ONDA:ITENS[n]:ZG_VGRIM				//QTD GR Impressa
	nTLNCX	:= oData:ONDA:ITENS[n]:ZG_TLNCX  			//Total linha CX
	nTLNGR	:= oData:ONDA:ITENS[n]:ZG_TLNGR				//Total linha GR

	cAntec := ALLTRIM(oData:ONDA:ITENS[n]:ZG_ANTEC)		//Pedido Antecipado
	_cSigla:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_SIGLA)		//Sigla
	_cSetor:= ALLTRIM(oData:ONDA:ITENS[n]:ZG_SETOR)		//Setor

	
	
	//Input Dados SZG
	DbSelectArea("SZG")
	DBSetOrder(2)	//Filial + EMPRESA + NUMERO DO PEDIDO + ITEM
	If !SZG->(dbSeek(xFilial("SZG") + Padr(cFilPV,04)  + Padr(cNum,06) + Padr(cItemPV,02) ))
		
		Reclock("SZG",.T.)
		SZG->ZG_NUM		:= cNum			//Pedido de Venda
		SZG->ZG_FILPED	:= cFilPV		//Distribuidora
		SZG->ZG_ITEM	:= cItemPV		//Item do Pedido de Venda
		SZG->ZG_NONDA	:= cOnda		//Numero ONDA
		SZG->ZG_CLI		:= cCliPV		//Cliente
		SZG->ZG_LOJA	:= cLjPV		//Loja
		//SZG->ZG_NUMPCOM	:= cNPCom		//Num PC Cliente
		SZG->ZG_NREDUZ	:= cNReduz		//Nome CLiente
		SZG->ZG_PRODUTO	:= cProdPV		//Produto
		SZG->ZG_ECSERVI	:= cECSERV		//Tipo Servico Transportadora
		SZG->ZG_NREDUZT	:= cNRedTra		//Transportadora
		SZG->ZG_MUN		:= cMUNPV		//Municipio PV
		SZG->ZG_EST		:= cESTPV		//Estado UF
		SZG->ZG_CEP		:= cCEPPV		//CEP
		
		SZG->ZG_EMISSAO	:= STOD(cEmisPV)//Emissao PV
		
		SZG->ZG_QTDVEN	:= nQtdVen		//Quantidade Vendida
		SZG->ZG_VCXIM	:= nQtdCXI		//QTD CX Impressa
		SZG->ZG_VGRIM	:= nQtdGRI		//QTD GR Impressa
		SZG->ZG_TLNCX	:= nTLNCX		//Total linha CX
		SZG->ZG_TLNGR	:= nTLNGR		//Total linha GR
		
		//Dados FIXOS conforme a Importação
		SZG->ZG_DTIMPLO	:= DATE()				//Data Importacao
		SZG->ZG_HRIMPLO := SUBSTR(TIME(),1,5)	//Hora Importacao
		SZG->ZG_STAPV	:= "1"					//Status PV - Impresso

		SZG->ZG_ANTEC	:= cAntec	//Pedido Antecipado
		SZG->ZG_SIGLA	:= _cSigla	//Sigla, informação da Transportadora para Geração de Etiqueta
		SZG->ZG_SETOR	:= _cSetor	//Setor, informação da Transportadora para Geração de Etiqueta
		
		MsUnlock()
	Endif
	nCont ++

Next n

//Retorno WS
If nCont > 0
	cJsonErro := '{"SUCESSO":" '+Alltrim(Str(nCont))+' registros incluídos com sucesso !!!"}'
EndIf
	
Return()
