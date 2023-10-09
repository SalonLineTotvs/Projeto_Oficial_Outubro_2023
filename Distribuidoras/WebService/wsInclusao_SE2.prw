//******************************************************************************************************************************************************************
//Projeto Webservice - Projeto Webservice, inclusão de PA das Comissão, apurada pelo Fabio Maximo
//Solicitação e autorização - Jacqueline / Elser / Fabio Maximo - Autorizado pelo Fernando Martins / Elser / Jacqueline
//Objetivo - Webservice ativo, para receber dados via Json, para Incluir no Contas a Pagar os PA do Valor da Comissão dos Vendedores
//Importante - Como informado pela Jacqueline, não precisa criar alçadas de analise ou valor, todos os valores será liberados. O Responsavel será Fabio Maximo do valor
//Autor deste Desenvolvimento - André Salgado / Introde - 30/11/2022
//******************************************************************************************************************************************************************

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

//http://salonline-bjrtrtrccn.dynamic-m.com:9095/api/v1/transfderegional
WSRESTFUL transfDeRegional DESCRIPTION "inclusao de titulos a pagar especifico para transferencias bancarias para as sedes regionais"
   
   WSDATA cfilial  AS STRING   OPTIONAL  // Parametros WS
   WSDATA cfornece AS STRING   OPTIONAL  // Parametros WS
   WSDATA chist    AS STRING   OPTIONAL  // Parametros WS
   WSDATA nvalor   AS FLOAT    OPTIONAL  // Parametros WS
   WSDATA ctipotit AS STRING   OPTIONAL  // Parametros WS

   WSMETHOD POST transfDeRegional;
   DESCRIPTION 'Grava titulos a pagar';
   WSSYNTAX '/api/v1/transfderegional';
   PATH '/api/v1/transfderegional'

END WSRESTFUL

//===============================================================================//
//                               METODO POST                                     //
//===============================================================================//
WSMETHOD POST transfDeRegional WSSERVICE transfderegional

Local aArea   		:= GetArea() 
Local oParseJSON     := Nil
Local aVetSE2        := {}
Local lRet           := .T.
Local cnoforn        := ""

Private cRes           := ""
Private lMsErroAuto  := .F.
Private cnumtit      := "0"+DTOS(Date())
Private cprefixo     := Space(3)
Private cparcela     := Space(2)
Private cloja        := "01"

Self:SetContentType("application/json")
cJson := FWJsonSerialize(Self, .F., .F., .T.)

FWJsonDeserialize(cJson, @oParseJSON)

dvencpar     := retVencto() // Criar Função ( Todo dia 10 do subsequente Caso 03/10 venc 10/10 caso 11/10 venc 10/11 )
dvectoRel    := DataValida(dvencpar, .T.)

cfornece    := oParseJSON:CFORNECE
chist       := oParseJSON:CHIST
nvalor      := oParseJSON:NVALOR
ctipotit    := oParseJSON:CTIPOTIT

cnatureza   := Alltrim(GETMV("ES_SE2NATU"))
cbanco      := Alltrim(GETMV("ES_SE2BANC"))
cagencia    := Alltrim(GETMV("ES_SE2AGEN"))
cconta      := Alltrim(GETMV("ES_SE2CONT"))

DbSelectArea("SE2")
DBSetOrder(1)

/*
conout("Filial:"+xFilial("SE2"))
conout("Natureza:"+cnatureza)
conout("Banco:"+cbanco)
conout("Agencia:"+cagencia)
conout("Conta:"+cconta)
*/

If nvalor <= 0

   cRes := '{ "codigo":201, "status":"Valor negativo não permitido", "fornecedor":"'+cfornece+'", "titulo":"'+cnumtit+'" }'
   lRet := .T.   

Else

   If !(SE2->( DbSeek( xFilial("SE2") + padr(cprefixo,3) + padr(cnumtit,9) + padr(cparcela,2) + padr(ctipotit,3) + padr(cfornece,6) + padr(cloja,2) ) ))

      If ctipotit = "PA"

         cnoforn := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_NREDUZ")
         
         // Quando o TIPO é PA o está ocorrendo erro no Execauto.
         lRetTit  :=  GravarSe2()
         If lRetTit
            lRet := .T.
            cRes := '{ "codigo":200, "status":"Incluido", "fornecedor":"'+cfornece+'", "titulo":"'+cnumtit+'" }'
         ElseIf Empty(cnoforn)
            lRet := .T.
            cRes := '{ "codigo":201, "status":"Fornecedor nao cadastrado", "fornecedor":"'+cfornece+'", "titulo":"'+cnumtit+'" }'
         Else
            lRet := .T.
            cRes := '{ "codigo":201, "status":"Nao existe Banco/Agencia/Conta", "fornecedor":"'+cfornece+'", "titulo":"'+cnumtit+'" }'
         Endif

      Else
      
         aAdd(aVetSE2, {"E2_NUM"          , cnumtit   ,   Nil})
         aAdd(aVetSE2, {"E2_PREFIXO"      , cprefixo  ,   Nil})
         aAdd(aVetSE2, {"E2_PARCELA"      , cparcela  ,   Nil})
         aAdd(aVetSE2, {"E2_TIPO"         , ctipotit  ,   Nil})
         aAdd(aVetSE2, {"E2_NATUREZ"      , cnatureza ,   Nil})
         aAdd(aVetSE2, {"E2_FORNECE"      , cfornece  ,   Nil})
         aAdd(aVetSE2, {"E2_LOJA"         , cloja     ,   Nil})
         aAdd(aVetSE2, {"E2_EMISSAO"      , dvencpar  ,   Nil})
         aAdd(aVetSE2, {"E2_VENCTO"       , dvencpar  ,   Nil})
         aAdd(aVetSE2, {"E2_VENCREA"      , dvectoRel ,   Nil})
         aAdd(aVetSE2, {"E2_VALOR"        , nvalor    ,   Nil})
         aAdd(aVetSE2, {"E2_EMIS1"	      , Date()    ,   Nil})
         aAdd(aVetSE2, {"E2_HIST"         , chist     ,   Nil})
         aAdd(aVetSE2, {"E2_MOEDA"        , 1         ,   Nil})
      
         If Len(aVetSE2) <= 0
            lRet := .T.
            cRes := '{ "Titulo nao encontrado" }'
         Else

            Begin Transaction

               MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)

               If lMsErroAuto
                  DisarmTransaction()
                  cError := MostraErro("/dirdoc", "Erro_Tit.log") // ARMAZENA A MENSAGEM DE ERRO (C:\TOTVS 12\protheus_data\dirdoc)
                  ConOut(PadC("Erro inclusao de titulo no Protheus", 80))
                  ConOut("Erro: "+ cError)
               Else
                  lRet := .T.
                  cRes := '{ "codigo":200, "status":"Incluido", "fornecedor":"'+cfornece+'", "titulo":"'+cnumtit+'" }'
               EndIf

               aVetSE2  := {}

            End Transaction  
         
         Endif
      
      Endif   

   Else

      lRet := .T.
      cRes := '{ "codigo":201, "status":"Ja existe esse titulo nessa data", "cprefixo":"'+cprefixo+'", "numero":"'+cnumtit+'", "fornecedor":"'+cfornece+'", "loja":"'+cloja+'" }'

   Endif

Endif

RestArea(aArea)
FreeObj(oParseJSON)        // Elimina objeto da memoria
Self:SetResponse( cRes )   // Envia a resposta

Return(lRet)

//===============================================================================//
//                    Função para gravar data Vencimento                         //
//===============================================================================//
/*
   Caso o Dia for menor que dia 10, o vencimento será para o mesmo mês.
   Caso o Dia for maior ou igual a 10, o vencimento será para o próximo mês. 
*/
Static Function retVencto()

Local nDiaVenc    := 10 // MV_PAR.. Pegar do Parametro
Local nDiaAtual   := Val(Left(DTOC(Date()),2))
Local nMesAtual   := Val(SubStr(DTOC(Date()),4,2))
Local nAnoAtual   := Val(SubStr(DTOC(Date()),7,4))
Local dDtVenc     := CTOD(" / / ")

If nDiaAtual < nDiaVenc
   dDtVenc  := CTOD( Alltrim(Str(nDiaVenc)) + "/" + Alltrim(Str(nMesAtual)) + "/" + Alltrim(Str(nAnoAtual)) )
Else
   dDtVenc  := CTOD( Alltrim(Str(nDiaVenc)) + "/" + Alltrim(Str((nMesAtual + 1))) + "/" + Alltrim(Str(nAnoAtual)) )
Endif

Return(dDtVenc)

//===============================================================================//
//                    Função para gravar SE2                                     //
//===============================================================================//
Static Function GravarSe2()

Local cnomefor := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_NREDUZ")
Local cnomraz  := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_NOME")
Local cbcoFor  := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_BANCO")
Local cAgeFor  := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_AGENCIA")
Local cCntFor  := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_NUMCON")
Local cDvFor   := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_DVCTA")
Local cCtaFor  := Posicione("SA2",1,xFilial("SA2")+cfornece+cloja,"A2_CONTA")
Local lTit     := .F.
Local cProc	   := FINFKSID('FKA','FKA_IDPROC')
Local cIdOrig  := FWUUIDV4()
Local cRet     := FWUUIDV4()
Local cChave   := ""

If Empty(cnomefor)
   lTit := .F.
   Return(lTit)
Endif

If !Empty(cconta)
   // Gravar SE2
   Begin Transaction

      DbSelectArea("SE2")
      DBSetOrder(1)

      cChave   := xFilial("SE2")+"|"+Space(3)+"|"+cnumtit+"|"+Space(2)+"|"+Padr(ctipotit,3)+"|"+cfornece+"|"+cloja                                                                  

      Reclock("SE2",.T.)

         SE2->E2_FILIAL    := xFilial("SE2")
         SE2->E2_NUM       := cnumtit
         SE2->E2_TIPO      := ctipotit
         SE2->E2_NATUREZ   := cnatureza
         SE2->E2_FORNECE   := cfornece
         SE2->E2_LOJA      := cloja
         SE2->E2_NOMFOR    := cnomefor
         SE2->E2_EMISSAO   := dvencpar
         SE2->E2_VENCTO    := dvencpar
         SE2->E2_VENCREA   := dvectoRel
         SE2->E2_VALOR     := nvalor
         SE2->E2_EMIS1     := Date()
         SE2->E2_HIST      := chist
         SE2->E2_SALDO     := nvalor
         SE2->E2_VENCORI   := dvencpar
         SE2->E2_MOEDA     := 1
         SE2->E2_RATEIO    := "N"
         SE2->E2_VLCRUZ    := nvalor
         SE2->E2_OCORREN   := "01"
         SE2->E2_ORIGEM    := "FINA050"
         SE2->E2_FLUXO     := "S"
         SE2->E2_DESDOBR   := "N"
         SE2->E2_MULTNAT   := "2"
         SE2->E2_PROJPMS   := "2"
         SE2->E2_DIRF      := "2"
         SE2->E2_MODSPB    := "1"
         SE2->E2_FILORIG   := xFilial("SE2")
         SE2->E2_BASEPIS   := nvalor
         SE2->E2_BASECSL   := nvalor
         SE2->E2_MDRTISS   := "1"
         SE2->E2_FORBCO    := cbcoFor  // 09/12/2022
         SE2->E2_FORAGE    := cAgeFor  // 09/12/2022
         SE2->E2_FORCTA    := cCntFor  // 09/12/2022
         SE2->E2_FCTADV    := cDvFor   // 09/12/2022
         SE2->E2_CONTAD    := cCtaFor  // 09/12/2022
         SE2->E2_FRETISS   := "1"
         SE2->E2_APLVLMN   := "1"
         SE2->E2_BASEISS   := nvalor
         SE2->E2_DATAAGE   := dvectoRel
         SE2->E2_BASEIRF   := nvalor
         SE2->E2_TEMDOCS   := "2"
         SE2->E2_STATLIB   := "01"
         SE2->E2_BASECOF   := nvalor
         SE2->E2_BASEINS   := nvalor
         SE2->E2_TPDESC    := "C"   

      SE2->(MsUnlock())

      // Gravar SE5
      DbSelectArea("SE5")
      DBSetOrder(1)

      Reclock("SE5",.T.)

         SE5->E5_FILIAL    := xFilial("SE5")
         SE5->E5_DATA      := dvectoRel
         SE5->E5_TIPO      := ctipotit
         SE5->E5_MOEDA     := "01"
         SE5->E5_VALOR     := nvalor
         SE5->E5_NATUREZ   := cnatureza
         SE5->E5_BANCO     := cbanco
         SE5->E5_AGENCIA   := cagencia
         SE5->E5_CONTA     := cconta
         SE5->E5_RECPAG    := "P"
         SE5->E5_BENEF     := cnomraz
         SE5->E5_HISTOR    := chist
         SE5->E5_TIPODOC   := "PA"
         SE5->E5_VLMOED2   := nvalor
         SE5->E5_NUMERO    := cnumtit
         SE5->E5_CLIFOR    := cfornece
         SE5->E5_LOJA      := cloja
         SE5->E5_DTDIGIT   := Date()
         SE5->E5_MOTBX     := "NOR"
         SE5->E5_RATEIO    := "N"
         SE5->E5_DTDISPO   := dvectoRel
         SE5->E5_FILORIG   := xFilial("SE5")
         SE5->E5_FORNECE   := cfornece
         SE5->E5_ORIGEM    := "RPC"
         SE5->E5_MOVFKS    := "S"
         SE5->E5_IDORIG    := cIdOrig
         SE5->E5_TABORI    := "FK5"

      SE5->(MsUnlock())

      // Gravar FK5
      DbSelectArea("FK5")
      DBSetOrder(1)

      Reclock("FK5",.T.)

         FK5->FK5_FILIAL   := xFilial("FK5")
         FK5->FK5_IDMOV    := cIdOrig
         FK5->FK5_DATA     := dvectoRel
         FK5->FK5_VALOR    := nvalor
         FK5->FK5_MOEDA    := "01"
         FK5->FK5_NATURE   := cnatureza
         FK5->FK5_RECPAG   := "P"
         FK5_TPDOC         := "PA"
         FK5_FILORI        := xFilial("FK5")
         FK5->FK5_ORIGEM   := "RPC"
         FK5->FK5_BANCO    := cbanco
         FK5->FK5_AGENCI   := cagencia
         FK5->FK5_CONTA    := cconta
         FK5->FK5_HISTOR   := chist
         FK5->FK5_VLMOE2   := nvalor
         FK5->FK5_DTDISP   := dvectoRel
         FK5->FK5_TERCEI	:= "2"
         FK5->FK5_TPMOV    := "1"
         FK5->FK5_STATUS   := "1"
         FK5->FK5_RATEIO   := "2"
         FK5->FK5_IDDOC    := FINGRVFK7('SE2', cChave)

      FK5->(MsUnlock())

      // Gravar FK7
      Reclock("FK7", .T.)

         FK7->FK7_FILIAL	:= xFilial("FK5")
         FK7->FK7_IDDOC	   := cRet
         FK7->FK7_ALIAS	   := "SE2"
         FK7->FK7_CHAVE	   := cChave 
         FK7->FK7_FILTIT   := xFilial("FK5")
         FK7->FK7_PREFIX   := cprefixo
         FK7->FK7_NUM      := cnumtit
         FK7->FK7_TIPO     := "PA"
         FK7->FK7_CLIFOR   := cfornece
         FK7->FK7_LOJA     := cloja

      FK7->(MsUnlock())

      //Grava FKA - Auxiliar
      RecLock("FKA", .T.)

         FKA_FILIAL 	:= xFilial("FKA")
         FKA_IDFKA	:= FWUUIDV4()
         FKA_IDPROC	:= cProc
         FKA_IDORIG	:= cIdOrig
         FKA_TABORI	:= "FK5"

      FKA->(MsUnlock())

      lTit := .T.
   
   End Transaction

Else
   lTit := .F.
Endif

Return(lTit)
