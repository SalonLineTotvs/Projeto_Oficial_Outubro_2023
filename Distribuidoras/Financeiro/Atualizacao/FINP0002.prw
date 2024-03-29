#include 'rwmake.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FINP0002 � Autor � Antonio Carlos        � Data � 25/05/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock disparado do Bradesco MultiPag para retornar     ���
���          � lay-out da forma de pagamento.                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNAB                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function FINP0002()
Local _cRetorno :=""

/*
//�����������������������������������������������������������������-  �
//�********************************************************************�
//�	SEGMENTO A,B - Pgto Atraves de Credito em Conta, Cheque, OP, DOC,  � 045 Layout do Lote
//�				   TED ou Pgto com Autenticacao 	                   �
//�********************************************************************�
//|Tab  Cod     Descri��o											   |
//�58	01    	CREDITO EM CONTA CORRENTE                              �
//�58	02    	CHEQUE PAGAMENTO/ADMINISTRATIVO                        �
//�58	03    	DOC                                                    �
//�58	04    	OP A DISPOSICAO COM AVISO PARA O FAVORECIDO            �
//�58	05    	CREDITO EM CONTA POUPANCA                              �
//�58	07    	TED CIP                                                �
//�58	08    	TED STR                                                �
//�58	10    	OP `A DISPOSICAO SEM AVISO PARA O FAVORECIDO           �
//�58	41    	TED - Outro Titular                                    �
//�58	43    	TED - Mesmo titular                                    �
//�58	44    	TED P/ TRANSF DE CTA INVESTIMENTO                      �
//�********************************************************************�
//|			SEGMENTO J - Pagamento de Titulos de Cobranca			   | 040 Layout do Lote
//�********************************************************************�
//�58	30    	LIQUIDACAO DE TITULOS EM COBRANCA NO ITAU              �
//�58	31    	PAGAMENTO DE TITULOS EM OUTRO BANCO                    �
//�********************************************************************�
//|	SEGMENTO O - Pagamento de Contas e Tributos com Codigo de Barras   | 012 Layout do Lote 
//�********************************************************************�
//�58	11    	PGTO DE CTAS E TRIBUTOS C/ CODIGO DE BARRAS            �
//�58	13    	PAGAMENTO A CONCESSIONARIAS                            �
//�58	91    	GNRE                                                   �
//�********************************************************************�
//|		SEGMENTO N - Pagamento de Tributos sem Codigo de Barras   	   | 012 Layout do Lote 
//�********************************************************************�
//�58	16    	PAGAMENTO DE TRIBUTOS - DARF NORMAL                    �
//�58	17    	PAGAMENTO DE TRIBUTOS - GPS                            �
//�58	18    	PAGAMENTO DE TRIBUTOS - DARF SIMPLES                   �
//�58	21    	PAGAMENTO DE TRIBUTOS - DARJ                           �
//�58	22    	PAGAMENTO DE TRIBUTOS - GARE-SP ICMS                   �
//�58	23    	PAGAMENTO DE TRIBUTOS - GARE-SP DR                     �
//�58	24    	PAGAMENTO DE TRIBUTOS - GARE-SP ITCMD                  �
//�58	25    	PAGAMENTO DE TRIBUTOS - IPVA                           �
//�58	26    	PAGAMENTO DE TRIBUTOS - LICENCIAMENTO                  �
//�58	27    	PAGAMENTO DE TRIBUTOS - DPVAT                          �
//������������������������������������������������������������������  �
*/

IF 	SEA->EA_MODELO = '01' .OR.	SEA->EA_MODELO = '02' .OR. SEA->EA_MODELO = '03' .OR. SEA->EA_MODELO = '04' .OR. SEA->EA_MODELO = '05' .OR. SEA->EA_MODELO = '07' .OR. SEA->EA_MODELO = '08' .OR. SEA->EA_MODELO = '41' .OR. SEA->EA_MODELO = '43' .OR. SEA->EA_MODELO = '44'
		_cRetorno := '045'
ELSEIF SEA->EA_MODELO = '30' .OR. SEA->EA_MODELO = '31'
		_cRetorno := '040'
ELSEIF SEA->EA_MODELO = '16' .OR. SEA->EA_MODELO = '17' .OR. SEA->EA_MODELO = '18' .OR. SEA->EA_MODELO = '21' .OR. SEA->EA_MODELO = '22' .OR. SEA->EA_MODELO = '23' .OR. SEA->EA_MODELO = '24' .OR. SEA->EA_MODELO = '25' .OR. SEA->EA_MODELO = '26' .OR. SEA->EA_MODELO = '27' .OR. SEA->EA_MODELO = '91' .OR. SEA->EA_MODELO = '11' .OR. SEA->EA_MODELO = '13'
			_cRetorno := '012'
//	ELSEIF SEA->EA_MODELO = ''
//		_cRetorno := '022'	//Bloqueto Eletronico - (Captura de Titulos em Cobran�a)
//	ELSEIF SEA->EA_MODELO = ''
//		_cRetorno := '010'	//Alega��o do Sacado
	ENDIF

Return(_cRetorno)

