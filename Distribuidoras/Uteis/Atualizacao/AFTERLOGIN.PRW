#INCLUDE "PROTHEUS.CH"                                                                                 
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AfterLogin � Autor � Genilson Lucas		 � Data � 14/11/17���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Executa ap�s usu�rio efetuar login no sistema.			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para SALONLINE                                   ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function AfterLogin()  

Local cAmbiente := GetEnvServer() //ambiente logado
Local cEmpresa	:= SM0->M0_CODIGO
/*
If cEmpresa == '01'
	If !(upper(cAmbiente) $ ('DEVINTEX/SALONLINE/01_COMPILA/01_HOMOLOGA/DEVINTEX_HMG'))
		Final("Prezado(a), o ambiente logado n�o corresponde a empresa, favor verificar!")
	EndIf
ElseIf cEmpresa == '02' 
	If (!(upper(cAmbiente) $ ('DISTRIBUIDORAS')) .AND. !(RetCodUsr() $ ALLTRIM(getmv('ES_USRAMB')))) .OR. !('LIBERADO'$ALLTRIM(getmv('ES_USRAMB')))
		Final("Prezado(a), o ambiente logado n�o corresponde a empresa, favor verificar!")
	EndIf
EndIf
*/
return()
