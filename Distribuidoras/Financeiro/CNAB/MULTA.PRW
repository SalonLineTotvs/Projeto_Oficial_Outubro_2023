#Include "Protheus.ch"

/*���������������������������������������������������������������������������
���Programa  �MULTA()  �Autor  �Eduardo Augusto      � Data �  14/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � FONTE DESENVOLVIDO PARA CALCULO DE JUROS MORA/DIA,         ���
���          � CONFORME LAYOUT CNAB ITAU COBRAN�A. (POSICOES 161 A 173)   ���
�������������������������������������������������������������������������͹��
���Uso       � Cofran Lanternas							                  ���
���������������������������������������������������������������������������*/

User Function MULTA()

Local _nMulta 	:= 0
Local _cBanco	:= SEE->EE_CODIGO
Local _cAgencia	:= SEE->EE_AGENCIA
Local _cConta	:= SEE->EE_CONTA
Local _cSubCta	:= SEE->EE_SUBCTA	

DbSelectArea("SEE")       
Dbsetorder(1)
Dbseek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubCta)                     

_nValLiq := u_xSE1LIQ() //VALOR LIQUIDO

If _cBanco == "341"
	//_nMulta := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XMULTA)/100),"@E 99,999,999.99"),",","")), 13, "0" )
	_nMulta := Padl( Alltrim(StrTran(Transform(((_nValLiq*SEE->EE_XMULTA)/100),"@E 99,999,999.99"),",","")), 13, "0" )
Else                                                                                                                        
	//_nMulta := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XMULTA)/100),"@E 99,999,999.99"),",","")), 04, "0" )
	_nMulta := Padl( Alltrim(StrTran(Transform(((_nValLiq*SEE->EE_XMULTA)/100),"@E 99,999,999.99"),",","")), 04, "0" )
EndIf

Return _nMulta                                                                    