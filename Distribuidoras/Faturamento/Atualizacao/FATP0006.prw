#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATP0006� Autor � Andre Valmir/Introde   � Data � 12/06/18 ���
�������������������������������������������������������������������������͹��
���Descricao � Trazer nome do Cliente/Fornecedor na Tela de Browse PV     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 				                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                  


User Function FATP0006()

Local cNForcli	:= ""
Local aAreaSC5	:= SC5->(getArea())
Local aAreaSA1	:= SA1->(getArea())
Local aAreaSA2	:= SA2->(getArea())


If M->C5_TIPO $ 'D*B'
	cNForcli	:= Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_NOME")
Else
	cNForcli	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NOME")
Endif
             
RestArea(aAreaSC5)
RestArea(aAreaSA1)
RestArea(aAreaSA2)

Return(cNForcli)