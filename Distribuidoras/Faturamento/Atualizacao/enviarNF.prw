#INCLUDE "PROTHEUS.CH"

/*�������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������Ŀ��
��� Empresa  � Introde					                                  						���
�����������������������������������������������������������������������������������������������Ĵ��
��� Funcao   � enviarNF � Autor � 		        � 					           Data� 22/11/2022 ���
�����������������������������������������������������������������������������������������������Ĵ��
���Descricao � Enviar Numero da Nota Fiscal para a Logistica                                    ���
���          � 											                  						���
�����������������������������������������������������������������������������������������������Ĵ��
��� Uso      � Distribuidoras                                              						���
������������������������������������������������������������������������������������������������ٱ� 
���������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������
*/ 

/*
    U_enviarNF("0101", "026694", "123456789", "18/11/2022")
*/

User Function enviarNF(cFilPed, cNumPV, cNumNF, cDataEmis)

Local cUrl          := 'http://slgroup-wtkpqtqgcn.dynamic-m.com:8095/rest/api/v1/recebernf?'
Local cPostPar      := ''
Local aHeaderStr    := {}

cPostPar += 'cfildist='+cFilPed+'&'
cPostPar += 'cpedven='+cNumPV+'&'
cPostPar += 'cnumnf='+cNumNF+'&'
cPostPar += 'ddataemi='+cDataEmis+''

aAdd(aHeaderStr,"Content-Type| application/x-www-form-urlencoded")
aAdd(aHeaderStr,"Content-Length| " + Alltrim(Str(Len(cPostPar))) )

cResponse := HttpCPost( cUrl + cPostPar )

Return()
