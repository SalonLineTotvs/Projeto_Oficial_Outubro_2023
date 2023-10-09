#Include "Protheus.Ch"
#Include "RwMake.Ch"
#Include "TopConn.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460QRY   �Autor  �Andre Salgado       � Data �  09/02/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada FILTRA e s� Autorizar os Pedidos de Venda  ���
���          � Campo C5_X_STAPV = '5' ou  C5_X_STAPV = 'A'                ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - GENILSON LUCAS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460QRY()

Local cQry	:= ""
Local cParam:= PARAMIXB[1]
Local nTipo	:= PARAMIXB[2]
Local aArea := GetArea()


IF SM0->M0_CODIGO="02"	//S� Processar para Empresa DISTRIBUIDORA
	
	If nTipo == 1
		//���������������������������������������������������Ŀ
		//�Tira as aspas simples da primeira e ultima posicao.�
		//�����������������������������������������������������
		cParam:= SubStr(Alltrim(cParam),1,Len(cParam))
		
		//����������������������������������������������������������Ŀ
		//�Montagem do Update Filtro Stastus Pedido                  �
		//������������������������������������������������������������
		cQry:= " UPDATE "+RetSqlName("SC9")+" SET C9_CODISS = C5_X_STAPV"
		cQry+= " FROM "+RetSqlName("SC9")+" SC9 "
		cQry+= " INNER JOIN "+RetSqlName("SC5")+" SC5 "
		cQry+= " ON SC5.D_E_L_E_T_ = ' '"
		cQry+= " AND C5_NUM    = C9_PEDIDO"
		cQry+= " AND C5_FILIAL = C9_FILIAL"
		cQry+= " WHERE"
		cQry+= " C5_X_STAPV in ('5','A')"		//REGRA CAMPO STATUS (FILTRAR 5 e A)
		cQry+= " AND C5_TIPOCLI <> 'X' "		// VALMIR 02/07/2018 (NAO ATULIZAR PARA PEDIDO DE EXPORTA��O)
		cQry+= " AND SC9.D_E_L_E_T_ = ' '"
		cQry+= " AND " + cParam
		
		//��������������������������������
		//�Executa Update no arquivo SC9.�
		//��������������������������������
		IF TcSqlExec(cQry) < 0
			MsgStop("Erro ao executar a instru��o " + CRLF + TCSQLError() )
			Return()
		Endif
		
		cParam+= " AND SC9.C9_CODISS IN('5','A') "
		
	EndIf
Endif
RestArea(aArea)

Return(cParam)
