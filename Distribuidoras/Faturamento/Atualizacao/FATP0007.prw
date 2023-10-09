#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATP0007� Autor � Andre Valmir/Introde   � Data � 12/06/18 ���
�������������������������������������������������������������������������͹��
���Descricao � Trazer nome do Cliente/Fornecedor na Tela de Browse da     ���
���          � Nota Fiscal de Sa�da.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � 				                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                  


User Function FATP0007()

Local cNomeCli	:= ""
Local aAreaSF2	:= SF2->(getArea())
Local aAreaSA1	:= SA1->(getArea())
Local aAreaSA2	:= SA2->(getArea())


If SF2->F2_TIPO $ 'D*B'
	cNomeCli	:= Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_NOME")
Else
	cNomeCli	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")
Endif
             
RestArea(aAreaSF2)
RestArea(aAreaSA1)
RestArea(aAreaSA2)

Return(cNomeCli)