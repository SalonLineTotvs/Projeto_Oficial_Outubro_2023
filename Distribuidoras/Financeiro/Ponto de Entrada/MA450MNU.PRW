#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA450MNU �Autor  � Genilson M Lucas   � Data �  26/11/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada INCLUIR BOT�O (Outras A��es) no           ���
���          � na libera��o do pedido por cr�dito.                        ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - GENILSON LUCAS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA450MNU()

Local aArea := GetArea()
Local _cUsrPerm := SuperGetMV( "SL_APRVCRD", Nil, "000710|000592|000807|000841|" )	
Local _cUser    := RetCodUsr()

If FWIsInCallStack("MATA450A") .AND. _cUser $ _cUsrPerm 
	AADD( aRotina,{"Posi��o T�tulos Vencidos"	,"U_FATP0099()",0,4,20,NIL})
	AADD( aRotina,{"Relat�rio de Libera��o"		,"U_FATR0999()",0,3,20,NIL})
EndIf

RestArea(aArea)

Return()

