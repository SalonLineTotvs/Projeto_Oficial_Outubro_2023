#include 'protheus.ch'
#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'
User Function SLFAT001()
Local aArea         := GetArea()
Local oTempTable    := Nil
Local aColumns      := {}    
Private oMarkBrowse
Private nValMinPv   := 100000 
Private cTempTable  := "" 
cTempTable := fBuildTmp(@oTempTable) 
DbSelectArea(cTempTable)
(cTempTable)->( DbSetOrder(1) )
(cTempTable)->( DbGoTop() )
if !pergunte("SLFAT001",.T.)
    Return
endif
dEmiIni := mv_par01
dEmiFim := mv_par02
cTraIni := mv_par03
cTraFim := mv_par04
cCliIni := mv_par05
cCliFim := mv_par06
cUfIni := mv_par07
cUfFim := mv_par08
cVenIni := mv_par09
cVenFim := mv_par10
cPedIni := mv_par11
cPedFim := mv_par12

fLoadTable(cTempTable)
aColumns := fBuildColumns()
oMarkBrowse := FWMarkBrowse():New()
oMarkBrowse:SetAlias(cTempTable)                
oMarkBrowse:SetDescription('Pedidos de Vendas')
oMarkBrowse:DisableReport()
oMarkBrowse:SetFieldMark( 'OK' )    
oMarkBrowse:SetTemporary(.T.)
oMarkBrowse:SetColumns(aColumns)
oMarkBrowse:SetSemaphore(.F.)
oMarkBrowse:AddButton("Confirmar", { || MsgRun("Por favor, aguarde! Processando registros...","Separação de Pedidos",{|| RunProc(cTempTable)}), MsAguarde({|| CloseBrowse() },'Encerrando...') },,,, .F., 2 )
oMarkBrowse:AddButton("Fechar"   , { || MsAguarde({|| CloseBrowse() },'Encerrando...')  },,2,,.F.)
oMarkBrowse:Activate()
oTempTable:Delete()
oMarkBrowse:DeActivate()
FreeObj(oTempTable)
FreeObj(oMarkBrowse)
RestArea( aArea )
Return 

Static Function fBuildTmp(oTempTable)
Local cAliasTemp := getNextAlias()
Local aFields    := {}
aAdd(aFields, { "OK"       , "C",  2, 0 })
aAdd(aFields, { "NUMPV"    , "C",  6, 0 })
aAdd(aFields, { "CLIENTE"  , "C",  6, 0 })
aAdd(aFields, { "LOJACLI"  , "C",  2, 0 })
aAdd(aFields, { "NOMECLI"  , "C", 20, 0 })
aAdd(aFields, { "TRANSP"   , "C", 20, 0 })
aAdd(aFields, { "EST"      , "C", 2 , 0 })
aAdd(aFields, { "VEND"     , "C", 20, 0 })
aAdd(aFields, { "VALOR"    , "C", 14, 0 })
oTempTable:= FWTemporaryTable():New(cAliasTemp)
oTemptable:SetFields( aFields )
oTempTable:AddIndex("01", {"NUMPV"} )    
oTempTable:Create()    
Return oTempTable:GetAlias()

Static Function fBuildColumns()
Local nX       := 0 
Local aColumns := {}
Local aStruct  := {}
AAdd(aStruct, {"OK"     , "C",  2 , 0})
AAdd(aStruct, {"NUMPV"  , "C",  6 , 0})
AAdd(aStruct, {"CLIENTE", "C",  6 , 0})
AAdd(aStruct, {"LOJACLI", "C",  2 , 0})
AAdd(aStruct, {"NOMECLI", "C", 20 , 0})
AAdd(aStruct, {"TRANSP" , "C", 20 , 0})
AAdd(aStruct, {"EST"    , "C", 2  , 0})
AAdd(aStruct, {"VEND"   , "C", 20 , 0})
AAdd(aStruct, {"VALOR"  , "C", 14 , 0})
For nX := 2 To Len(aStruct)    
    AAdd(aColumns,FWBrwColumn():New())
    aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
    aColumns[Len(aColumns)]:SetTitle(aStruct[nX][1])
    aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
    aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])              
Next nX
Return aColumns

Static Function fLoadTable(cTempTable)
Local cQuery    := ''
Local cAliasTMP := getNextAlias()
cQuery += "SELECT " 
cQuery += "    C5_NUM, "
cQuery += "    C5_CLIENTE, " 
cQuery += "    C5_LOJACLI, "
cQuery += "    A1_NOME, "
cQuery += "    (SELECT TOP 1 A4_NOME FROM "+RetSqlName("SA4")+" A4 WHERE C5.C5_TRANSP               = A4.A4_COD)            AS C5_TRANSP, " 
cQuery += "    (SELECT TOP 1 A1_EST  FROM "+RetSqlName("SA1")+" A1 WHERE C5.C5_CLIENT+C5.C5_LOJAENT = A1.A1_COD+A1.A1_LOJA) AS C5_EST, " 
cQuery += "    (SELECT SUM(C6_VALOR) C6_VALOR FROM "+RetSqlName("SC6")+" SC6 WHERE C5.C5_FILIAL+C5.C5_NUM = SC6.C6_FILIAL+SC6.C6_NUM) AS C5_VALOR, "
cQuery += "    (SELECT TOP 1 A3_NOME FROM "+RetSqlName("SA3")+" A3 WHERE C5.C5_VEND1                = A3.A3_COD)            AS C5_VEND " 
cQuery += "FROM "
cQuery += "    "+RetSqlName("SC5")+" C5 INNER JOIN ( 
cQuery += "                            SELECT C6_FILIAL, C6_NUM, SUM(C6_VALOR) C6_VALOR
cQuery += "                            FROM "+RetSqlName("SC6")+" C6
cQuery += "                            WHERE C6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+xFilial("SC6")+"' AND (C6_QTDVEN-C6_QTDENT) > 0 AND C6_BLQ <> 'R' 
cQuery += "                            GROUP BY C6_FILIAL, C6_NUM) A ON A.C6_FILIAL = C5_FILIAL AND A.C6_NUM = C5_NUM AND A.C6_VALOR > " + alltrim(str(nValMinPv)) 
cQuery += "              INNER JOIN "+RetSqlName("SA1")+" A1 ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1_FILIAL = '" + xFilial("SA1") +"' AND A1.D_E_L_E_T_ = ' '
cQuery += "WHERE 
cQuery += "    C5.D_E_L_E_T_ = ' '
cQuery += "    AND C5_EMISSAO BETWEEN '"+dtos(dEmiIni)+"' AND '"+dtos(dEmiFim)+"' "
cQuery += "    AND C5_FILIAL  = '" + xFilial("SC5") + "' "
cQuery += "    AND C5_LIBEROK = ' ' " 
cQuery += "    AND C5_TIPO NOT IN ('D','B') " 

cQuery += "    AND C5.C5_TRANSP BETWEEN '"+cTraIni+"' AND '"+cTraFim + "' " 
cQuery += "    AND C5.C5_CLIENT BETWEEN '"+cCliIni+"' AND '"+cCliFim + "' " 
cQuery += "    AND A1_EST BETWEEN '"+cUfIni+"' AND '"+cUfFim + "' " 
cQuery += "    AND C5.C5_VEND1 BETWEEN '"+cVenIni+"' AND '"+cVenFim + "' " 
cQuery += "    AND C5.C5_NUM BETWEEN '"+cPedIni +"' AND '"+ cPedFim + "' " 

cQuery += "ORDER BY 
cQuery += "    C5_NUM
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTMP, .F., .T.)
while (cAliasTMP)->(!eof())
    If( RecLock(cTempTable, .T.) )            
        (cTempTable)->NUMPV    := (cAliasTMP)->C5_NUM
        (cTempTable)->CLIENTE  := (cAliasTMP)->C5_CLIENTE
        (cTempTable)->LOJACLI  := (cAliasTMP)->C5_LOJACLI
        (cTempTable)->NOMECLI  := (cAliasTMP)->A1_NOME
        (cTempTable)->TRANSP   := (cAliasTMP)->C5_TRANSP
        (cTempTable)->EST      := (cAliasTMP)->C5_EST
        (cTempTable)->VEND     := (cAliasTMP)->C5_VEND
        (cTempTable)->VALOR   :=  str((cAliasTMP)->C5_VALOR,14,2) 
        MsUnLock()
    EndIf
    (cAliasTMP)->(DBSkip())
enddo
(cAliasTMP)->(DBCloseArea())
Return

Static Function RunProc(cAliasProc)
Local cMarca    := oMarkBrowse:Mark()
DbSelectArea(cAliasProc)
(cAliasProc)->(DbGoTop())
while (cAliasProc)->(!Eof())
    If oMarkBrowse:IsMark(cMarca)    
        U_SLFAT002((cAliasProc)->NUMPV)
        alert(((cAliasProc)->NUMPV) +' gerado ')
    endif
    (cAliasProc)->(DBSkip())
enddo
Return
