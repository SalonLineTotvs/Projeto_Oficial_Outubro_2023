#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER Chr(13)+Chr(10) 

/*���������������������������������������������������������������������������
���Programa  � SigaFAT   � Autor � Genesis/Gustavo   Data �  01/06/2023   ���
�������������������������������������������������������������������������͹��
���Descricao � PE - Ap�s login no modulo de faturamento                   ���
���������������������������������������������������������������������������*/ 
*-------------------*
User Function SigaFAT
*-------------------*
Local _cUpdLib := ''

IF cEmpAnt == '02'  
    //Atualizacao do campo 'E2_DATALIB' projeto portal Salonline
	_cUpdLib := " UPDATE "+RetSqlName('SE2')+" SET E2_DATALIB = E2_EMISSAO WHERE D_E_L_E_T_='' AND (E2_ORIGEM in ('SIGAEIC ') OR E2_STATLIB = '') AND E2_DATALIB = '' "
	cRet := TcSqlExec(_cUpdLib)
	If cRet <> 0
		MsgInfo( 'Erro na execu��o [UpdLib: E2_DATALIB] ' + " " + TcSQLError() ,'Alerta')
	EndIf 
ENDIF

Return
