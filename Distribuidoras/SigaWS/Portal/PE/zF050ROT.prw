//Bibliotecas
#Include "Protheus.ch"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  zF050ROT                                                                                      |
 | Desc:  Adiciona a��es relacionadas no Contas a Pagar                                                 |
 *------------------------------------------------------------------------------------------------------*/
*--------------------*
User Function zF050ROT
*--------------------*
Local _aRotina := ParamIxb

IF SuperGetMv("MV_CTLIPAG",.F.,.F.)
//aAdd( _aRotina, { '@ Aprova��o Financeira' ,"u_zWS_SE2()"   , 0, 4})
ENDIF

Return(_aRotina)
