#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*/
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  �xRetUsr   � Autor � Guilherme D. Gesualdo � Data da Criacao  � 28/01/20               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Descricao � Fun��o que retorna login, nome e e-mail do usu�rio do protheus passado como par�metro.                       ���
���          �                      									                               						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Protheus 12.1.25																								���
���		     � 																												���
���		     �					 												                                            ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Parametros� 	cCodUsr - C�digo do usu�rio Protheus								                                        ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Retorno   �  aDadosRet - Array com os seguintes dados nesa ordem: LOGIN, NOME, EMAIL			                 	        ���
���			 � 														                                                 	    ���
���������������������������������������������������������������������������������������������������������������������������͹��
���Usuario   �                                                                                          					���
���������������������������������������������������������������������������������������������������������������������������͹��
���Setor     � TI		                                                                              						���
���������������������������������������������������������������������������������������������������������������������������͹��
���            			          	ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL                   						���
���������������������������������������������������������������������������������������������������������������������������͹��
���Autor     � Data     � Motivo da Alteracao  				               �Usuario(Filial+Matricula+Nome)    �Setor        ���
���������������������������������������������������������������������������������������������������������������������������ĺ��
���----------�----------�--------------------------------------------------�----------------------------------�-------------���
���������������������������������������������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������������������������
/*/
*-----------------------------------*
User Function xRetUsr(cCodUsr,cLogin)
*-----------------------------------*
Local cQryUsr 	:= ""
Local cAliasUsr := GetNextAlias()
Local aDadosRet := {}

Default cCodUsr	:= __cUserID
Default cLogin 	:= "" 

If !Empty(cCodUsr) .OR. !Empty(cLogin)
	cQryUsr := "	SELECT	X.USR_ID CODIGO,  "
	cQryUsr += "		USR_CODIGO LOGIN,  "
	cQryUsr += "		USR_NOME NOME, "
	cQryUsr += "		USR_EMAIL EMAIL , "
	cQryUsr += "		ISNULL( USR_GRUPO, '') 'GRUPO', "
	cQryUsr += "		USR_DEPTO 'DEPTO' " 
	cQryUsr += " FROM SYS_USR X (NOLOCK) "
	cQryUsr += " LEFT JOIN SYS_USR_GROUPS (NOLOCK)  Y ON Y.USR_ID=X.USR_ID AND Y.D_E_L_E_T_='' "
	cQryUsr += " WHERE X.D_E_L_E_T_ = ' '  "
	If !Empty(cCodUsr)
		cQryUsr += "AND X.USR_ID = '"+cCodUsr+"' "
	ElseIf !Empty(cLogin)
		cQryUsr += "AND X.USR_CODIGO = '"+cLogin+"' "
	EndIf
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQryUsr ), cAliasUsr, .F., .T. )
	
	If (cAliasUsr)->(!EOF())	
		AADD(aDadosRet,{ALLTRIM((cAliasUsr)->CODIGO),ALLTRIM((cAliasUsr)->LOGIN),ALLTRIM((cAliasUsr)->NOME),ALLTRIM((cAliasUsr)->EMAIL) , ALLTRIM((cAliasUsr)->DEPTO), ALLTRIM((cAliasUsr)->GRUPO)  })	
	EndIf 	
EndIf

(cAliasUsr)->(dbCloseArea())

Return(aDadosRet)
