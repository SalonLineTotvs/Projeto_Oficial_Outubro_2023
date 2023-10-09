#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "topconn.ch"

User Function MTA410T()
Local nX := 0

Local nPosValdesc  := aScan(aHeader, {|x| AllTrim(x[2])=="C6_VALDESC"}) 
Local nPosValTota  := aScan(aHeader, {|x| AllTrim(x[2])=="C6_VALOR"}) 
Local nTotValdesc  := 0
Local nTotValtota  := 0
//--
For nX := 1 to Len(aCols)
	nTotValdesc += aCols[nX][nPosValdesc]
	nTotValtota += aCols[nX][nPosValtota]
Next nX
//ALERT(nTotValdesc)
//ALERT(nTotValtota)
dbselectarea('SC5')
reclock('SC5',.F.)
C5_XVTOTA := nTotValtota 
C5_XVDESC := nTotValdesc
c5_XVBRUT := nTotValdesc + nTotValtota
MSUNLOCK()
DBCOMMIT()
//--
RETURN
