#include 'totvs.ch'
#include 'topconn.ch'
#include 'fileio.ch'

user function SLFAT002(cPedido)

local aArea         := getArea()
local nValMinPv     := 100000
local aDadosPV      := {}
local nLim400k      := 400000
local nLim100k      := 100000
local nLimite       := 0
local nSubTotal     := 0
local lExcPVOrig    := .T.
Private aCabec          := {}
Private aLinha          := {}
Private aItens          := {}
Private lMsErroAuto     := .F.
Private lMsHelpAuto     := .T.
Private lAutoErrNoFile  := .T.
if getTotalPv(cPedido) >= nValMinPv
    load_Items(cPedido, @aDadosPV)
    while len(aDadosPV) > 0
        nTotItems := calcTotItm(aDadosPV)
        if nTotItems > 0 
            if nTotItems <= nLim400k
                if nTotItems <= nLim100k
                    nLimite := 0
                else
                    nLimite :=  nLim100k
                endif
            else
                nLimite := nLim400k
            endif
        endif
        while len(aDadosPV) > 0 //.and. nSubTotal <= nLimite
            nSubTotal += aDadosPV[1,16]
            if nLimite > 0
                if nSubTotal >= nLimite
                    if Len(aCabec) = 0
                        UpdExecAut(cPedido,aDadosPV[1])
                        ADel(aDadosPV,1)
                        aSize(aDadosPV, Len(aDadosPV)-1)
                    endif
                    if GerarPedido()
                        lExcPVOrig := .F.
                    endif
                    aCabec     := {}
                    aLinha     := {}
                    aItens     := {}
                    exit
                else
                    UpdExecAut(cPedido,aDadosPV[1])
                    ADel(aDadosPV,1)
                    aSize(aDadosPV, Len(aDadosPV)-1)
                endif
            else
                UpdExecAut(cPedido,aDadosPV[1])
                ADel(aDadosPV,1)
                aSize(aDadosPV, Len(aDadosPV)-1)
            endif
        enddo
        nSubTotal := 0
    enddo
    if Len(aCabec) > 0
        if GerarPedido()
            lExcPVOrig := .F.
        endif
    endif                
    if lExcPVOrig 
        ExcPvOrig(cPedido)    
    endif
else
    MsgAlert("O total da mercadoria do Pedido de venda é menor que o valor mínimo estabelecido: " + transform(nValMinPv, "@R 999,999.99"), "Valor Mínimo do PV")
endif
restArea(aArea)
return

static function getTotalPv(cPedido)
Local nTotalPV  := 0
Local cQuery    := ''
Local cAliasTMP := getNextAlias()
cQuery += " SELECT "
cQuery += "     SUM(((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN)) C6_VALOR"
cQuery += " FROM " 
cQuery += "     " + RetSqlName("SC6") + " C6 "
cQuery += " WHERE "
cQuery += "     C6.D_E_L_E_T_ = ' ' "
cQuery += "     AND C6_FILIAL  = '" + xFilial("SC6") + "' "
cQuery += "     AND C6_NUM  = '" + cPedido + "' "
cQuery += "     AND (C6_QTDVEN-C6_QTDENT) > 0 "
cQuery += "     AND C6_BLQ <> 'R' "
cQuery += "     AND C6_QTDEMP = 0 "
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)
nTotalPV := (cAliasTMP)->C6_VALOR
(cAliasTMP)->(DBCloseArea())
return nTotalPV

Static Function load_Items(cPedido, aDadosPV)
Local cQuery    := ''
Local cAliasTMP := getNextAlias()
Local lcontinua :=.f.
cQuery += " SELECT "
cQuery += " C5_TIPO, C5_CLIENTE, C5_LOJACLI, C5_TRANSP, C5_NATUREZ, C5_CONDPAG, C5_TIPOCLI, C6_ITEM, C6_PRODUTO, (C6_QTDVEN-C6_QTDENT) C6_QTDVEN , C6_PRCVEN, ((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C6_VALOR, C6_TES, C6_LOCAL"
cQuery += " FROM " + RetSqlName("SC5") + " C5 INNER JOIN " +  RetSqlName("SC6") + " C6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_ = ' ' AND (C6_QTDVEN-C6_QTDENT) > 0 AND C6_BLQ <> 'R' " 
cQuery += " WHERE "
cQuery += "     C5.D_E_L_E_T_ = ' ' "
cQuery += "     AND C5_FILIAL  = '" + xFilial("SC5") + "' "
cQuery += "     AND C5_NUM  = '" + cPedido + "' "
cQuery += "     AND C5_LIBEROK = ' ' " 
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)
TCSetField(cAliasTMP,"C6_QTDVEN","N",tamSx3("C6_QTDVEN")[1],tamSx3("C6_QTDVEN")[2])
TCSetField(cAliasTMP,"C6_PRCVEN","N",tamSx3("C6_PRCVEN")[1],tamSx3("C6_PRCVEN")[2])
TCSetField(cAliasTMP,"C6_VALOR","N",tamSx3("C6_VALOR")[1],tamSx3("C6_VALOR")[2])
lcontinua := .t.
while (cAliasTMP)->(!eof())
    IF getadvfval('SB1','B1_X_MSBLQ',XFILIAL('SB1')+ (cAliasTMP)->C6_PRODUTO,1) <> '2'
        Alert(' Pedido: '+ cPedido+ ' Item Bloqueado : '+(cAliasTMP)->C6_PRODUTO)
        lcontinua:=.f.
    ENDIF
    (cAliasTMP)->(DBSkip())
end
if lcontinua = .f.
    final(' Pedido: '+ cPedido+ ' Com itens Bloqueados ')
ENDIF

(cAliasTMP)->(dbgotop())
while (cAliasTMP)->(!eof())
    IF getadvfval('SB1','B1_X_MSBLQ',XFILIAL('SB1')+ (cAliasTMP)->C6_PRODUTO,1) = '2'
        AAdd(aDadosPV, { (cAliasTMP)->C5_TIPO, (cAliasTMP)->C5_CLIENTE, (cAliasTMP)->C5_LOJACLI, (cAliasTMP)->C5_TRANSP, , (cAliasTMP)->C5_NATUREZ, (cAliasTMP)->C5_CONDPAG, (cAliasTMP)->C5_TIPOCLI, , , , (cAliasTMP)->C6_ITEM, (cAliasTMP)->C6_PRODUTO, (cAliasTMP)->C6_QTDVEN, (cAliasTMP)->C6_PRCVEN, (cAliasTMP)->C6_VALOR, (cAliasTMP)->C6_TES, (cAliasTMP)->C6_LOCAL } )
        (cAliasTMP)->(DBSkip())
    else    
        Final(' Pedido: '+ cPedido+ ' Item Bloqueado : '+(cAliasTMP)->C6_PRODUTO)
    ENDIF
end
ASort(aDadosPV,,,{|x,y| x[16] > y[16]})
(cAliasTMP)->(DBCloseArea())
return Nil

Static Function calcTotItm(aDadosPV)
local nTotal    := 0 
local i         := 0
for i:=1 to Len(aDadosPV)
    nTotal += aDadosPV[i,16]
next
return nTotal

Static Function UpdExecAut(cPedido,aDadosPV)
aLinha := {}
if Len(aCabec) = 0
    aadd(aCabec, {"C5_TIPO"    , aDadosPV[01]   ,Nil})
    aadd(aCabec, {"C5_CLIENTE" , aDadosPV[02]   ,Nil})
    aadd(aCabec, {"C5_LOJACLI" , aDadosPV[03]   ,Nil})
    aadd(aCabec, {"C5_TRANSP"  , aDadosPV[04]   ,Nil})
    aadd(aCabec, {"C5_NATUREZ" , aDadosPV[06]   ,Nil})
    aadd(aCabec, {"C5_CONDPAG" , aDadosPV[07]   ,Nil})  
    aadd(aCabec, {"C5_TIPOCLI" , aDadosPV[08]   ,Nil})
    aadd(aCabec, {"C5_XPVO"    , cPedido        ,Nil}) 
endif
aadd(aLinha,{"C6_ITEM"   , aDadosPV[12], Nil})
aadd(aLinha,{"C6_PRODUTO", aDadosPV[13], Nil})
aadd(aLinha,{"C6_QTDVEN" , aDadosPV[14], Nil})
aadd(aLinha,{"C6_PRCVEN" , aDadosPV[15], Nil})
aadd(aLinha,{"C6_VALOR"  , aDadosPV[16], Nil})
aadd(aLinha,{"C6_TES"    , aDadosPV[17], Nil})
aadd(aLinha,{"C6_LOCAL"  , aDadosPV[18], Nil})
aadd(aItens, aLinha)
return
 
Static Function GerarPedido()  
local nX
MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, 3, .F.)
If lMsErroAuto
    MostraErro()
    aLog        := GetAutoGRLog()
    cDescricao  := 'Erro ao gravar MsExecAuto(). Detalhes abaixo:' + CHR(13)+CHR(10)
    For nX := 1 To Len(aLog)
        cDescricao += aLog[nX]+CHR(13)+CHR(10)
    next
    GeraArquivoLog(cDescricao)
endif
return lMsErroAuto

Static Function GeraArquivoLog(cTexto)
local cArqLog := FCreate(GetTempPath()+"erro_geracao_pv_" + SubStr(time(),1,2) + SubStr(time(),4,2) + SubStr(time(),7,2) + ".log") 
if cArqLog = -1
    MsgAlert("Erro ao criar arquivo - ferror " + Str(Ferror()), "ErroGerTxt")
else
    FWrite(cArqLog, cTexto + CRLF)
    FClose(cArqLog)
endif
return Nil

Static Function ExcPvOrig(cPedido)
local nX
aCabecExc   := {}
aItensExc   := {}
aLinha      := {}
aSaveArea   := getArea()   
lMsErroAuto := .F.
SC5->(DbSetOrder(1))
if SC5->(DBSeek(xFilial("SC5")+cPedido))
    aadd(aCabecExc, {"C5_NUM"     , SC5->C5_NUM     ,Nil})
    aadd(aCabecExc, {"C5_TIPO"    , SC5->C5_TIPO    ,Nil})
    aadd(aCabecExc, {"C5_CLIENTE" , SC5->C5_CLIENTE ,Nil})
    aadd(aCabecExc, {"C5_LOJACLI" , SC5->C5_LOJACLI ,Nil})
    aadd(aCabecExc, {"C5_TRANSP"  , SC5->C5_TRANSP  ,Nil})
    aadd(aCabecExc, {"C5_NATUREZ" , SC5->C5_NATUREZ ,Nil})
    aadd(aCabecExc, {"C5_CONDPAG" , SC5->C5_CONDPAG ,Nil})  
    aadd(aCabecExc, {"C5_TIPOCLI" , SC5->C5_TIPOCLI ,Nil})
    SC6->(DBSetOrder(1))
    SC6->(DBSeek(xFilial("SC6")+SC5->C5_NUM))
    while SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM
        aLinha := {}
        aadd(aLinha,{"C6_ITEM"   , SC6->C6_ITEM, Nil})
        aadd(aLinha,{"C6_PRODUTO", SC6->C6_PRODUTO, Nil})
        aadd(aLinha,{"C6_QTDVEN" , SC6->C6_QTDVEN, Nil})
        aadd(aLinha,{"C6_PRCVEN" , SC6->C6_PRCVEN, Nil})
        aadd(aLinha,{"C6_VALOR"  , SC6->C6_VALOR, Nil})
        aadd(aLinha,{"C6_TES"    , SC6->C6_TES, Nil})
        aadd(aLinha,{"C6_LOCAL"  , SC6->C6_LOCAL, Nil})
        aadd(aItensExc, aLinha)
        SC6->(DBSkip())
    enddo
    restArea(aSaveArea)    
    MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabecExc, aItensExc, 5)
    If lMsErroAuto
        MostraErro()
        aLog        := GetAutoGRLog()
        cDescricao  := 'Erro ao gravar MsExecAuto(). Detalhes abaixo:' + CHR(13)+CHR(10)
        For nX := 1 To Len(aLog)
            cDescricao += aLog[nX]+CHR(13)+CHR(10)
        next
        GeraArquivoLog(cDescricao)
    endif
endif
restArea(aSaveArea)
return lMsErroAuto

