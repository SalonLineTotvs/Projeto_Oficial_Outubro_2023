///*************************************************************************************
//Solicitação - Didacio (Fiscal) / Eduardo (Financeiro) 
//Ação - Ponto de Entrada p/trocar o Vencimento do Imposto Retido, para fazer sobre a Data de Emissao
//Autor - Rogerio / Introde - Dez/2021
///*************************************************************************************
#INCLUDE "PROTHEUS.CH"

User function F050MDVC()
Local dNextDay := ParamIxb[1] //data calculada pelo sistema
Local cIMposto := ParamIxb[2]
Local dEmissao := ParamIxb[3]
Local dEmis1   := ParamIxb[4]
Local dVencRea := ParamIxb[5] 
// Local nNextMes := Month(dVencRea)+1
Local nNextMes := Month(dEmissao)+1

If cImposto $ "PIS,CSLL,COFINS"//Calcula data 20 do prÃ³ximo mes 
//    dNextDay := CTOD("20/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))//Acho o ultimo dia util do periodo desejado 
      dNextDay := CTOD("20/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+Substr(Str(Iif(nNextMes==13,Year(dEmissao)+1,Year(dEmissao))),2))//Acho o ultimo dia util do periodo desejado 
    dNextday := DataValida(dNextday,.F.)
EndIf  

Return dNextDay
