/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIL   �Autor  �Andre Salgado       � Data �  09/02/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada FILTRA e s� Autorizar os Pedidos de Venda  ���
���          � Campo C5_X_STAPV = '5' ou  C5_X_STAPV = 'A'                ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - GENILSON LUCAS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460FIL()

Local cFil	:= ""
Local aArea	:= GetArea()

IF SM0->M0_CODIGO="02"	//S� Processar para Empresa DISTRIBUIDORA
	
	cFil+= " (C9_CODISS = '5' .or. C9_CODISS = 'A') "
	
Endif

RestArea(aArea)

Return(cFil)
