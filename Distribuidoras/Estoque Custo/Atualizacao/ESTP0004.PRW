#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
������������������������������������������������������������������a������Ĵ��
��� Funcao   � ESTP0005	 � Autor � Genilson M Lucas   � Data � 23/07/2018 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � AxCadastro da tela para controle de Produtos cortados.	  ���
���          � 								  							  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SALON LINE                                                 ���
��������������������������������������������������������������������������ٱ�
*/

User Function ESTP0004()
 
PRIVATE cCadastro  := "Produtos Cortados"
PRIVATE aRotina     := {}
 
AxCadastro("SZ2", OemToAnsi(cCadastro), 'AlwaysTrue()')
 
Return()