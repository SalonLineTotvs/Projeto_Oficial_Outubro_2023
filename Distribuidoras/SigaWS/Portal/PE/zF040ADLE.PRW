#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE  ENTER CHR(13)+CHR(10) 

/*���������������������������������������������������������������������������
���Programa  � zF040ADLE   � Autor � Genesis/Gustavo   Data �  22/03/2239 ���
�������������������������������������������������������������������������͹��
���Descricao � PE - LEGENDA PERSONALIZADA                                 ���
���������������������������������������������������������������������������*/
*----------------------*
User Function zF040ADLE
*----------------------*
Local aArea := GetArea()
Local _aRet  := ParamIxb

IF SuperGetMv("MV_CTLIPAG",.F.,.F.)
    //aAdd(_aRet, {"BR_CANCEL", "Titulo aguardando liberacao - Rejeitado"})
ENDIF

RestArea(aArea)
Return(_aRet)
