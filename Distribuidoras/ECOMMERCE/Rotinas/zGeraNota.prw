#INCLUDE "protheus.ch"    
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "shell.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#DEFINE ENTER Chr(13)+Chr(10) 

//Constantes
#Define STR_PULA	Chr(13)+ Chr(10)
#Define HDCODBAR 	15

/*���������������������������������������������������������������������������
���Fun��o    � zGeraNota � Autor � Genesis/Gustavo      � Data � 26/07/23 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera nota fiscal automaticamente                           ���
���������������������������������������������������������������������������*/
*---------------------*
User Function zGeraNota
*---------------------*
Local _aArea    := FwGetArea()
Local _aPvlDocS := {}
Local _nPrcVen  := 0
Local _cC5Num   := SC5->C5_NUM
Local _cSerie   := GetMV('SL_MATA461',.F.,'2')
Local _cEmbExp  := ""
Local _cDocNF   := ""
Local _cFunBkp  := FunName()
Local _nModBkp  := nModulo
Local _lGeraNota := .F.

SC5->(DbSetOrder(1))
SC5->(MsSeek(xFilial("SC5")+_cC5Num))

SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))

//� necess�rio carregar o grupo de perguntas MT460A, se n�o ser� executado com os valores default.
Pergunte("MT460A",.F.)

// Obter os dados de cada item do pedido de vendas liberado para gerar o Documento de Sa�da
While SC6->(!Eof() .And. C6_FILIAL == xFilial("SC6")) .And. SC6->C6_NUM == SC5->C5_NUM

    SC9->(DbSetOrder(1))
    SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM

    SE4->(DbSetOrder(1))
    SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO

    SB1->(DbSetOrder(1))
    SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))    //FILIAL+PRODUTO

    SB2->(DbSetOrder(1))
    SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL

    SF4->(DbSetOrder(1))
    SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES

    _nPrcVen := SC9->C9_PRCVEN
    If ( SC5->C5_MOEDA <> 1 )
        _nPrcVen := xMoeda(_nPrcVen,SC5->C5_MOEDA,1,dDataBase)
    EndIf

    If AllTrim(SC9->C9_BLEST) == "" .And. AllTrim(SC9->C9_BLCRED) == ""
        AAdd(_aPvlDocS,{ SC9->C9_PEDIDO,;
                        SC9->C9_ITEM,;
                        SC9->C9_SEQUEN,;
                        SC9->C9_QTDLIB,;
                        _nPrcVen,;
                        SC9->C9_PRODUTO,;
                        .F.,;
                        SC9->(RecNo()),;
                        SC5->(RecNo()),;
                        SC6->(RecNo()),;
                        SE4->(RecNo()),;
                        SB1->(RecNo()),;
                        SB2->(RecNo()),;
                        SF4->(RecNo())})
    EndIf

    SC6->(DbSkip())
EndDo

	SetFunName("MATA461")
    
    _cDocNF := MaPvlNfs(  /*aPvlNfs*/      _aPvlDocS,; // 01 - Array com os itens a serem gerados
                       /*_cSerieNFS*/      _cSerie,;   // 02 - Serie da Nota Fiscal
                       /*lMostraCtb*/      .F.,;       // 03 - Mostra Lan�amento Cont�bil
                       /*lAglutCtb*/       .F.,;       // 04 - Aglutina Lan�amento Cont�bil
                       /*lCtbOnLine*/      .F.,;       // 05 - Contabiliza On-Line
                       /*lCtbCusto*/       .T.,;       // 06 - Contabiliza Custo On-Line
                       /*lReajuste*/       .F.,;       // 07 - Reajuste de pre�o na Nota Fiscal
                       /*nCalAcrs*/        0,;         // 08 - Tipo de Acr�scimo Financeiro
                       /*nArredPrcLis*/    0,;         // 09 - Tipo de Arredondamento
                       /*lAtuSA7*/         .T.,;       // 10 - Atualiza Amarra��o Cliente x Produto
                       /*lECF*/            .F.,;       // 11 - Cupom Fiscal
                       /*_cEmbExp*/        _cEmbExp,;   // 12 - N�mero do Embarque de Exporta��o
                       /*bAtuFin*/         {||},;      // 13 - Bloco de C�digo para complemento de atualiza��o dos t�tulos financeiros
                       /*bAtuPGerNF*/      {||},;      // 14 - Bloco de C�digo para complemento de atualiza��o dos dados ap�s a gera��o da Nota Fiscal
                       /*bAtuPvl*/         {||},;      // 15 - Bloco de C�digo de atualiza��o do Pedido de Venda antes da gera��o da Nota Fiscal
                       /*bFatSE1*/         {|| .T. },; // 16 - Bloco de C�digo para indicar se o valor do Titulo a Receber ser� gravado no campo F2_VALFAT quando o par�metro MV_TMSMFAT estiver com o valor igual a "2".
                       /*dDataMoe*/        dDatabase,; // 17 - Data da cota��o para convers�o dos valores da Moeda do Pedido de Venda para a Moeda Forte
                       /*lJunta*/          .F.)        // 18 - Aglutina Pedido Iguais
    
    If !Empty(_cDocNF)
        Conout("Documento de Sa�da: " + _cSerie + "-" + _cDocNF + ", gerado com sucesso!!!")
        _lGeraNota := .T.
    EndIf

nModulo := _nModBkp
SetFunName(_cFunBkp)

FwRestArea(_aArea)
Return(_lGeraNota)
