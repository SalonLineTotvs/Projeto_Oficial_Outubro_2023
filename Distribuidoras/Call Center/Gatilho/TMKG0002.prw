#INCLUDE "PROTHEUS.CH"

/*
Solicitante: Daniele França
Desc. Gatilho para alimentar os Campos UC_x_TRANS e UC_X_NOMTRA na tela 
Call Center.
*/

User Function TMKG0002()       
Local _cRet 	:= M->UD_PRODUTO
Local nPos1		:= GdFieldPos("UD_VLRTOT")
Local nPos2		:= GdFieldPos("UD_NNF")                
Local nPos3		:= GdFieldPos("UD_X_NNF")  
Local nPos4		:= GdFieldPos("UD_QTD")
Local nPos5		:= GdFieldPos("UD_VLRUNT")
Local nPos6		:= GdFieldPos("UD_VLRTOT")                  
Local cSerie	:= Iif(xFilial("SUC")="0902","1  ","2  ") 

If n > 0
	aCols[n][nPos4]	:= POSICIONE("SD2",3,xFilial("SD2")+StrZero(Val(aCols[n][nPos2]),9)+cSerie+LEFT(aCols[n][nPos3],8)+M->UD_PRODUTO,'D2_QUANT')
	aCols[n][nPos5]	:= POSICIONE("SD2",3,xFilial("SD2")+StrZero(Val(aCols[n][nPos2]),9)+cSerie+LEFT(aCols[n][nPos3],8)+M->UD_PRODUTO,'D2_PRCVEN')    
	aCols[n][nPos1]	:= POSICIONE("SD2",3,xFilial("SD2")+StrZero(Val(aCols[n][nPos2]),9)+cSerie+LEFT(aCols[n][nPos3],8)+M->UD_PRODUTO,'D2_TOTAL')

	M->UC_X_NFO		:= StrZero(Val(aCols[n][nPos2]),9)	    
	M->UC_X_NFDVL	:= M->UC_X_NFDVL + aCols[n][nPos6]
EndIf  
	
GetdRefresh()


Return (_cRet)
