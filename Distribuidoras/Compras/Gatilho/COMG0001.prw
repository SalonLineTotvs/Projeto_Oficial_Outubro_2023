//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMG0001 ºAutor  ³Genilson Lucas      º Data ³  17/10/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Fonte visando criação de codigo de produto com base no   º±±
±±º          ³   grupo de produtos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Salon Line - Cimex e Qibit                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
         
        //Pegando o último código (não foi fitraldo o DELET para manter a sequencia unica)
        cQryAux := " SELECT "                                                                        + CRLF
        cQryAux += "     ISNULL(MAX(B1_COD), '" + cCodigo + "') AS ULTIMO "                          + CRLF
        cQryAux += " FROM "                                                                          + CRLF
        cQryAux += "     " + RetSQLName('SB1') + " SB1 "                                             + CRLF
        cQryAux += " WHERE "                                                                         + CRLF
        cQryAux += "     B1_FILIAL = '" + FWxFilial('SB1') + "' "                                    + CRLF
        cQryAux += "     AND B1_GRUPO = '" + cGrupo + "' "                                           + CRLF
        cQryAux += "     AND SUBSTRING(B1_COD, 1, " + cValToChar(nTamGrp) + ") = '" + cGrupo + "' "  + CRLF
        TCQuery cQryAux New Alias "QRY_AUX"
         
        //Define o novo código, incrementando 1 no final
        cCodigo := Soma1(QRY_AUX->ULTIMO)
            
        QRY_AUX->(DbCloseArea())
    EndIf
    
ElseIf Empty(cTipo)

	MsgInfo("Favor informar o Tipo do Produto.","Atenção")

EndIf


RestArea(aArea)
Return cCodigo
