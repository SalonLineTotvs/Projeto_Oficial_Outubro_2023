//#INCLUDE "SMATR010.CH"
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "TopConn.ch" 
#DEFINE  ENTER CHR(13)+CHR(10)

/*���������������������������������������������������������������������������           
���Fun��o    � F590CAN   � Autor � Genesis/Thiago       � Data � 13.06.19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � F590CAN - PE no cancelar - Manuten��o de Border�           ���
���������������������������������������������������������������������������*/
*--------------------*
User Function F590CAN                    
*--------------------*
Local _cTipo   := ParamIxb[1]
Local _cNumBor := ParamIxb[2]
Local _aArea   := GetArea()

IF _cTipo == 'R' .And. !Empty(SE1->E1_XNUMBCO)
	IF 	RecLock("SE1",.F.)
			Replace SE1->E1_PORTADO With SEA->EA_PORTADO
			Replace SE1->E1_AGEDEP	With SEA->EA_AGEDEP
			Replace SE1->E1_CONTA	With SEA->EA_NUMCON
		SE1->(MsUnLock())
	ENDIF
ENDIF
//cPortador := SEA->EA_PORTADO
//cAgeDep	:= SEA->EA_AGEDEP
//cConta	:= SEA->EA_NUMCON
				
RestArea(_aArea)
Return
