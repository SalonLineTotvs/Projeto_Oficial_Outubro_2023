#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410   � Autor � GENILSON LUCAS     � Data �  04/12/20   ���                      
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada ap�s confirma��o e antes da grava��o do	  ���
��� 		 � pedido de venda.											  ���
�������������������������������������������������������������������������͹��
���ALTERACOES REALIZADAS                                                  ���
�������������������������������������������������������������������������͹�� 
��� 		   															  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA410()

Local _aArea:=GetArea()


Private i			:= 0
Private _nQtdlib    := ASCAN( aHeader, {|x|AllTrim(x[2])=="C6_QTDLIB"} )
Private _nQtdVen	:= ASCAN( aHeader, {|x|AllTrim(x[2])=="C6_QTDVEN"} )
Private _clocal 	:= ASCAN( aHeader, {|x|AllTrim(x[2])=="C6_LOCAL"} )


//�������������������������������������������������������������������������Ŀ
//� FAZ LIBERA��O DO PEDIDO DE FORMA AUTOMATICA
//���������������������������������������������������������������������������  

 //IF cfilant <>'1201' .and. aCols[1, _clocal] <>'95' // //cfilctr    //                                                               
	For i:=1 to Len(aCols)
		If !aCols[i,Len(aHeader)+1]	//.and. aCols[i, _clocal] <>'95' //----> CONSIDERA SOMENTE LINHAS NAO DELETADAS
			
			aCols[i, _nQtdlib]	:= aCols[i, _nQtdVen]
					
		EndIf
	Next
 //endif
	

RestArea(_aArea)
Return(.T.)
