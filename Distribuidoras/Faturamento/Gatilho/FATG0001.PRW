#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � RFATG04  � Autor � Genilson M Lucas		  � Data � 15/05/2018  ���
���          �          �       � 						   �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Valida Produto (Apenas uma Vez por Pedido)                     ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � SalonLIne						                              ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function FATG0001()

Local cUsusario	:= alltrim(M->C5_X_DIGIT) 
Local cProduto  := aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"})]

//CAMPO FIXO NA PRIMEIRA POSI��O
Local cNumPed	:= aCols[1,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_NUMPCOM"})]
//Local cTes		:= aCols[1,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_TES"})]
//Local cCFOP		:= aCols[1,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_CF"})]


//VALIDA SOMENTE 1 ITEM POR PEDIDO 
If  cUsusario <> 'WEBSERVICE' .or. Altera
	For i:=1 to Len(aCols)
		If i <> n
			If  acols[i,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"})] == cProduto
				MsgAlert("O produto "+Alltrim(acols[i,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"})])+" j� est� cadastrado neste pedido.","Valida��o Produto","Alert")
				cProduto	:=	Space(15)
			EndIf
	    EndIf
	Next
EndIf 


//VALIDA PRODUTO BLOQUEADO
Dbselectarea("SB1")
DbSetOrder(1)
Dbseek(xFilial("SB1")+cProduto)
If SB1->B1_X_MSBLQ = '1' .AND. M->C5_TIPO = 'N' .and. FunName() <> "FATP0003"
	MsgAlert("O produto " +ALLTRIM(cProduto)+ " est� bloqueado para utiliza��o.","Produto Bloqueado","Alert")
	cProduto	:=	Space(15)
EndIf

	
//REPLICA NUMERO DO PEDIDO PARA OUTROS ITENS
If n > 1
	aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_NUMPCOM"})]	:= cNumPed
	//aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_TES"})]		:= cTes
	//aCols[n,Ascan(aHeader,{|x| Alltrim(x[2])=="C6_CF"})]		:= cCFOP
EndIf
 
Return(cProduto)