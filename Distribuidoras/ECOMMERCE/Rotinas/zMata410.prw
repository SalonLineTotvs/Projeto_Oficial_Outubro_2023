#INCLUDE "RWMAKE.CH"
#include "Protheus.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.CH"
#INCLUDE "Rwmake.CH"
#INCLUDE "Topconn.CH"
#include "TbiConn.CH"
#include "TbiCode.CH"
#INCLUDE "Ap5mail.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*�����������������������������������������������������������������������������
���Programa  � MCFAT90 � Autor � 	Genesis/Gustavo	 � Data �  24/07/23     ���
���������������������������������������������������������������������������͹��
���Descricao � Romaneio de Separacao                                        ���
�����������������������������������������������������������������������������*/
*---------------------*
User Function zMata410
*---------------------*
Local cFunBkp	 := FunName()
Local cFilialTab := FWxFilial('SC5')
Local _aArea 	 := FwGetArea()
Local nModBkp    := nModulo
Local _cAcessVD  := AllTrim(GetMV('SL_FIL_VD',.F.,'1501'))

//Alimenta vari�vel global
PutGlbValue("zMata410","SLECOMM")

nModulo    := 5
SetFunName("MATA410")

SC5->(DBSETFILTER({|| SC5->C5_FILIAL == _cAcessVD}, "SC5->C5_FILIAL == '"+_cAcessVD+"'")) // filtra a tabela de pedidos    

//Aplicado Filtro para pedidos 'M410FSQL'    
FwMsgRun(,{|| MATA410() }, "Aguarde Processamento...","Listando Pedidos de Venda")

SC5->(DBSETFILTER({|| .T.}, ".T."))

nModulo := nModBkp
SetFunName(cFunBkp)

//Limpa vari�vel global
ClearGlbValue("zMata410")
  
FwRestArea(_aArea)
Return
