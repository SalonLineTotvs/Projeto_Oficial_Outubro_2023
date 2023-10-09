//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � COMG0001 �Autor  �Genilson Lucas      � Data �  17/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �   Fonte visando cria��o de codigo de produto com base no   ���
���          �   grupo de produtos                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Salon Line - Cimex e Qibit                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COMG0001()

Local aArea   := GetArea()
Local cCodigo := ""
Local cGrupo  := M->B1_GRUPO
Local cTipo	  := M->B1_TIPO
Local cQryAux := ""
Local nTamGrp := TamSX3('B1_GRUPO')[01]
Local nTamCod := TamSX3('B1_COD')[01]    

If cTipo $ "MC/SV/AI" 
    If ! Empty(cGrupo)
        cCodigo := cGrupo + Replicate('0', nTamCod-nTamGrp)
         
        //Pegando o �ltimo c�digo (n�o foi fitraldo o DELET para manter a sequencia unica)
        cQryAux := " SELECT "                                                                        + CRLF
        cQryAux += "     ISNULL(MAX(B1_COD), '" + cCodigo + "') AS ULTIMO "                          + CRLF
        cQryAux += " FROM "                                                                          + CRLF
        cQryAux += "     " + RetSQLName('SB1') + " SB1 "                                             + CRLF
        cQryAux += " WHERE "                                                                         + CRLF
        cQryAux += "     B1_FILIAL = '" + FWxFilial('SB1') + "' "                                    + CRLF
        cQryAux += "     AND B1_GRUPO = '" + cGrupo + "' "                                           + CRLF
        cQryAux += "     AND SUBSTRING(B1_COD, 1, " + cValToChar(nTamGrp) + ") = '" + cGrupo + "' "  + CRLF
        TCQuery cQryAux New Alias "QRY_AUX"
         
        //Define o novo c�digo, incrementando 1 no final
        cCodigo := Soma1(QRY_AUX->ULTIMO)
            
        QRY_AUX->(DbCloseArea())
    EndIf
    
ElseIf Empty(cTipo)

	MsgInfo("Favor informar o Tipo do Produto.","Aten��o")

EndIf


RestArea(aArea)
Return cCodigo
