//Bibliotecas
#Include "Protheus.ch"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  F040URET                                                                                      |
 | Desc:  Adiciona ações relacionadas no Contas a Pagar                                                 |
 *------------------------------------------------------------------------------------------------------*/
*--------------------*
User Function zF040URET
*--------------------*
Local _aArea   := GetArea()
Local _aNewRet := {}
Local _nR      := 0
Local _aRetor  := ParamIxb[1]
Local _aLegen  := ParamIxb[2]

//Aprovação Via Portal
IF SuperGetMv("MV_CTLIPAG",.F.,.F.)
    aAdd(_aNewRet, {"SE2->E2_STATLIB == '99'", "BR_CANCEL"})
ENDIF

For _nR:=1 To Len(_aRetor)
    aAdd(_aNewRet, {_aRetor[_nR][1], _aRetor[_nR][2]})
Next _nR

RestArea(_aArea)
Return(_aNewRet)
