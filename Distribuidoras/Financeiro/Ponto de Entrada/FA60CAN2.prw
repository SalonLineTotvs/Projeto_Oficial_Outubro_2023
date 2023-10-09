//#INCLUDE "SMATR010.CH"
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "TopConn.ch" 
#DEFINE  ENTER CHR(13)+CHR(10)

/*���������������������������������������������������������������������������           
���Fun��o    � FA60CAN2  � Autor � Genesis/Thiago       � Data � 13.06.19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � FA60CAN2 - Grava��o de SE1 no estorno do border�.          ���
���������������������������������������������������������������������������*/
*--------------------*
User Function FA60CAN2                    
*--------------------*

	//Verifica se o campo de Backup existe
	IF SE1->(FieldPos('E1_XNUMBCO')) > 0 
		If !Empty(SE1->E1_XNUMBCO) .AND. !Empty(SE1->E1_PORTADO)
			IF 	Reclock("SE1",.F.)
				Replace SE1->E1_NUMBCO With SE1->E1_XNUMBCO
				SE1->(MsUnLock())
			Endif
		ElseIf !Empty(SE1->E1_XNUMBCO) .AND. Empty(SE1->E1_PORTADO)
			IF 	Reclock("SE1",.F.)
				Replace SE1->E1_XNUMBCO With SE1->E1_NUMBCO
				SE1->(MsUnLock())
			ENDIF
		ENDIF
	ENDIF

Return
