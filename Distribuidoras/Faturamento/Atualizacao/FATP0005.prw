#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATP0005� Autor � Andre Valmir/Introde   � Data � 12/06/18 ���
�������������������������������������������������������������������������͹��
���Descricao � Trazer nome do Cliente/Fornecedor na Tela de Browse PV     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 				                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                  


User Function FATP0005()

Local cNCliFor	:= ""
Local aAreaSC5	:= SC5->(getArea())
Local aAreaSA1	:= SA1->(getArea())
Local aAreaSA2	:= SA2->(getArea())


If SC5->C5_TIPO $ 'D*B'
	cNCliFor	:= Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME")
Else
	cNCliFor	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
Endif
             
RestArea(aAreaSC5)
RestArea(aAreaSA1)
RestArea(aAreaSA2)

Return(cNCliFor)