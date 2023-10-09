#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
���Programa  � zFINALeg   � Autor � Genesis/Gustavo   Data �  06/06/2023  ���
�������������������������������������������������������������������������͹��
���Descricao � PE - LEGENDA PERSONALIZADA (CONTAS A PAGAR E RECEBER)      ���
���������������������������������������������������������������������������*/
*--------------------* 
User Function zFINALeg
 *--------------------*
Local _nReg      := PARAMIXB[1] // Com valor: Abrir a telinha de legendas ### Sem valor: Retornar as regras
Local _cAlias    := PARAMIXB[2] // SE1 ou SE2
Local _aRegras   := PARAMIXB[3] // Regras do padr�o
Local _aLegendas := PARAMIXB[4] // Legendas do padr�o
Local _aRet      := {}
Local _nI        := 0

/*
    Sem Recno --> Retornar array com as regras para o Browse colocar as cores nas colunas.
    Com Recno --> Chamada quando acionado bot�o Legendas do browse -> Abrir telinha de Legendas (BrwLegenda)
*/
If _nReg == Nil
    If _cAlias == "SE1"
        //Exemplo para retornar as mesmas regras do padr�o sem altera��o
        _aRet := _aRegras     
 
    Else // SE2
        //Exemplo: adicionar uma regra de legenda "mais priorit�ria" que as do padr�o
        IF SuperGetMv("MV_CTLIPAG",.F.,.F.)
            aAdd(_aRet, {"SE2->E2_STATLIB == '99'", "BR_CANCEL"})
        ENDIF
     
        //Regras do padr�o para retorno
        For _nI := 1 To Len(_aRegras)
            aAdd(_aRet,{_aRegras[_nI][1],_aRegras[_nI][2]})
        Next _nI
    Endif
 
Else // Abrir telinha de Legendas (BrwLegenda)
 
    If _cAlias == "SE1" 
        //aAdd(_aLegendas,{"BR_CANCEL","Titulo aguardando liberacao - Rejeitado"})
 
    Else // SE2
        //Adicionar a cor e descri��o de legendas para SE2 aqui. Exemplo:
        aAdd(_aLegendas,{"BR_CANCEL","Titulo aguardando liberacao - Rejeitado"})
    Endif
    BrwLegenda(cCadastro, "Legenda", _aLegendas)
Endif
 
Return(_aRet)
