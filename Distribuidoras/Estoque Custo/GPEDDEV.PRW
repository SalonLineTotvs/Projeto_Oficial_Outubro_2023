#Include "Protheus.Ch"
#Include "TopConn.Ch"
#include "rwmake.ch"
#include "TBICONN.CH"        
#include "TopConn.ch"
#include "Fileio.ch"

USER FUNCTION GPEDDEV()

/* anotacoes
1 - vai gerar um por filial? inicialmente sem prepare environment
2 - verificar a tes de cada filial com o assis
3 - marcar o que ja foi processado? 
4 - somente almoxarifado '01'? ~90~
5 -
*/

Local nPrcVen   := 0
Local cTes_     := ''             //TES DE SAIDA
Local cDESCSB1  := ''             //DESCRICAO
Local cUNSB1    := ''             //UNIDADE DE MEDIDA
//Local lMsHelpAuto := .T.
Local lMsErroAuto := .F.
Local cCodPag_  := "003"      //Condição de Pagamento - Bonificação
Local cTes_     := "510"     //Regra Tes Inteligente
Local cSeq	    := '01'       //Inicio dos Produtos
//Local cFlacCab  := .T.
Local cUsusario := 'GPEDDEV'

   //Gera o Pedido DE DEVOLUCAO
//Alert(" Colocar a Data para Importar.... esta fixo 11/02/2022 !")

cDataGera := ddatabase // ctod("11/02/22") //"20220211" //

/*
    cPedGde:= " SELECT TOP 10 "
    cPedGde+= " D1_FILIAL, D1_DTDIGIT, D1_COD, SUM(D1_QUANT) QTD,  MAX(VUNIT)VUNIT, MAX(DOC) DOC, SERIE, SUM(QTDX) QTDX "
    cPedGde+= " FROM SD1020 D1 (NOLOCK) "
    cPedGde+= " INNER JOIN SF4020 F4 (NOLOCK) ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' AND F4.D_E_L_E_T_=' '  "
    cPedGde+= " LEFT JOIN ( "

    cPedGde+= " SELECT  "
    cPedGde+= " D1_FILIAL FILIAL, D1_COD COD, D1_DOC DOC, D1_SERIE SERIE, D1_VUNIT VUNIT, D1_QUANT QTDx "
    cPedGde+= " FROM SD1020 D1 (NOLOCK) "
    cPedGde+= " INNER JOIN SF4020 F4 (NOLOCK) ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' AND F4.D_E_L_E_T_=' '  "
    cPedGde+= " WHERE D1.D_E_L_E_T_=' '  "
    cPedGde+= " AND D1_DTDIGIT > '20200101' "
    cPedGde+= " AND D1_TIPO='N' "
    cPedGde+= " AND D1_FORNECE='002196' "
    cPedGde+= " AND (D1_QUANT-D1_QTDEDEV)>0 "
    cPedGde+= " )A ON D1_FILIAL=FILIAL AND  D1_COD=COD "

    cPedGde+= " WHERE D1.D_E_L_E_T_=' '  "
    cPedGde+= " AND D1_DTDIGIT ='"+DTOS(DDATABASE) +"'"
    cPedGde+= " AND D1_FILIAL = '"+XFILIAL("SD1")+"' "
    cPedGde+= " AND D1_TIPO='D' "
    cPedGde+= " GROUP BY D1_FILIAL, D1_DTDIGIT, D1_COD,SERIE "
*/

    cPedGde:= " SELECT D1_FILIAL, D1_DTDIGIT, D1_COD, QTD, ACUMULADO, SALDO_DEV, DOC_DEV,"
    cPedGde+= " SERIE_DEV, VUNIT_DEV, ITEM_DEV   FROM("

    cPedGde+= " SELECT D1_FILIAL, D1_DTDIGIT, D1_COD, SUM(D1_QUANT) QTD"
    cPedGde+= " FROM SD1020 D1 (NOLOCK)"
    cPedGde+= " INNER JOIN SF4020 F4 (NOLOCK) ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' AND F4.D_E_L_E_T_=' '"
    cPedGde+= " WHERE D1.D_E_L_E_T_=' ' AND D1_DTDIGIT ='"+DTOS(cDataGera)+"' AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND D1_TIPO='D'"
    cPedGde+= " GROUP BY D1_FILIAL, D1_DTDIGIT, D1_COD"
    cPedGde+= " )TABELA_DEVOLUCAO_DIGITADO_PELO_ASSIS"

    cPedGde+= " INNER JOIN ("
    cPedGde+= " SELECT  D1_FILIAL FILIAL, D1_COD COD, D1_ITEM ITEM_DEV,D1_DOC DOC_DEV, D1_SERIE SERIE_DEV, D1_VUNIT VUNIT_DEV, (D1_QUANT-D1_QTDEDEV) SALDO_DEV"
    cPedGde+= " ,SUM((D1_QUANT-D1_QTDEDEV)) OVER ("
    cPedGde+= "       PARTITION BY D1_COD"
    cPedGde+= "       ORDER BY D1_COD ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS ACUMULADO"
    cPedGde+= " FROM SD1020 D1 (NOLOCK)"
    cPedGde+= " INNER JOIN SF4020 F4 (NOLOCK) ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' AND F4.D_E_L_E_T_=' '"
    cPedGde+= " WHERE "
    cPedGde+= " D1.D_E_L_E_T_=' '   AND D1_DTDIGIT > '20200101'  AND D1_TIPO='N'  AND D1_FORNECE='002196'"
    cPedGde+= " AND (D1_QUANT-D1_QTDEDEV)>0  "
    cPedGde+= " AND D1_FILIAL='"+XFILIAL("SD1")+"'"
    cPedGde+= " )TAB_DEV_X_NOTAS_DEVINTEX_COM_SALDO ON D1_FILIAL=FILIAL AND  D1_COD=COD  "

    cPedGde+= " INNER JOIN ("
    cPedGde+= " SELECT D1_FILIAL F, D1_DTDIGIT DT, D1_COD C, MAX(DOC_DEV) NF FROM( "
    cPedGde+= " SELECT D1_FILIAL, D1_DTDIGIT, D1_COD, QTD, ACUMULADO, SALDO_DEV, DOC_DEV, SERIE_DEV, VUNIT_DEV, ITEM_DEV   FROM("
    cPedGde+= " SELECT D1_FILIAL, D1_DTDIGIT, D1_COD, SUM(D1_QUANT) QTD"
    cPedGde+= " FROM SD1020 D1 (NOLOCK)  "
    cPedGde+= " INNER JOIN SF4020 F4 (NOLOCK) ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' AND F4.D_E_L_E_T_=' ' "
    cPedGde+= " WHERE D1.D_E_L_E_T_=' ' AND D1_DTDIGIT='"+DTOS(cDataGera)+"' AND D1_FILIAL='"+XFILIAL("SD1")+"' AND D1_TIPO='D'"
    cPedGde+= " GROUP BY D1_FILIAL, D1_DTDIGIT, D1_COD"
    cPedGde+= " )TABELA_DEVOLUCAO_DIGITADA"

    cPedGde+= " INNER JOIN ("
    cPedGde+= " SELECT  D1_FILIAL FILIAL, D1_COD COD, D1_ITEM ITEM_DEV,D1_DOC DOC_DEV, D1_SERIE SERIE_DEV, D1_VUNIT VUNIT_DEV, (D1_QUANT-D1_QTDEDEV) SALDO_DEV  "
    cPedGde+= " ,SUM((D1_QUANT-D1_QTDEDEV)) OVER ("
    cPedGde+= "     PARTITION BY D1_COD"
    cPedGde+= "     ORDER BY D1_COD ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS ACUMULADO"
    cPedGde+= " FROM SD1020 D1 (NOLOCK) "
    cPedGde+= " INNER JOIN SF4020 F4 (NOLOCK) ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' AND F4.D_E_L_E_T_=' ' "
    cPedGde+= " WHERE "
    cPedGde+= " D1.D_E_L_E_T_=' '   AND D1_DTDIGIT > '20200101'  AND D1_TIPO='N'  AND D1_FORNECE='002196' "
    cPedGde+= " AND (D1_QUANT-D1_QTDEDEV)>0 "
    cPedGde+= " AND D1_FILIAL='"+XFILIAL("SD1")+"'"
    cPedGde+= " )VINCULOS_TABELAS ON D1_FILIAL=FILIAL AND  D1_COD=COD "
    cPedGde+= " )TOTAL_NF "
    cPedGde+= " WHERE QTD<=SALDO_DEV"
    cPedGde+= " GROUP BY D1_FILIAL, D1_DTDIGIT, D1_COD "
    cPedGde+= " )VINCULO_TABELA_COM_NF_DEVINTEX_PARA_VINCULO "
    cPedGde+= " ON D1_FILIAL=F AND D1_DTDIGIT=DT AND D1_COD=C AND DOC_DEV=NF"

MemoWrit("C:\Temp\a.TXT",cPedGde) 

    If Sele("QRY") <> 0
        QRY->(DbCloseArea())
    Endif    
    TCQUERY cPedGde NEW ALIAS "QRY"

    If Sele("QRY") = 0
        aLERT('****** Nao ha itens DEVOLVIDOS a serem processados na data de hoje')
        return
    Endif    

	DbSelectArea("QRY")
    dbgotop()

    aCabec    := {}
    aItens    := {}
    cSeq      := '01'

    // rogerio criar o cabecalho c5
    //******************************** - item 01  **********************************
    cNumPV 	:= GetSxeNum("SC5","C5_NUM")
    RollBAckSx8()
    aadd(aCabec,{"C5_NUM"    ,cNumPV   	,Nil})
    aadd(aCabec,{"C5_TIPO"   ,"D"      	,Nil})
    aadd(aCabec,{"C5_CLIENTE","002196"	,Nil})
    aadd(aCabec,{"C5_LOJACLI","01"  	,Nil})
    aadd(aCabec,{"C5_LOJAENT","01"   	,Nil})
    aadd(aCabec,{"C5_CONDPAG",cCodPag_ 	,Nil})
    //        aadd(aCabec,{"C5_TRANSP",cTransp1_ 	,Nil})
    aadd(aCabec,{"C5_MENNOTA","** DEVOLUCAO DAS DEVOLUCOES PARA A DEVINTEX",Nil})
    aadd(aCabec,{"C5_VOLUME1",1     	,Nil})
    aadd(aCabec,{"C5_ESPECI1","CAIXA"	,Nil})
    aadd(aCabec,{"C5_X_DIGIT",cUsusario ,Nil})
    aadd(aCabec,{"C5_X_STAPV","0"       ,Nil})

    While QRY->( !Eof() )
                aLinha := {}

                If SB1->( DbSeek(xFilial("SB1")+qry->D1_COD))
                    nPrcVen := QRY->VUNIT_DEV //iif(SB1->B1_UPRC=0,0.01,round(SB1->B1_UPRC * 1.01,2)) //(taxa passada pelo Marcio/Contador)  //PRECO
                    cDESCSB1:= alltrim(SB1->B1_DESC)    //DESCRICAO
                    cUNSB1  := SB1->B1_UM               //UNIDADE DE MEDIDA
                    if SB1->B1_X_MSBLQ = '1'
                        ALERT('DESCARTANDO '+qry->D1_COD)
                        QRY->( DBSKIP() )
                        loop
                    endif
                endif 

                aadd(aLinha,{"C6_ITEM"	 ,cSeq	    	,Nil})
                aadd(aLinha,{"C6_PRODUTO",qry->D1_COD   ,Nil})
                aadd(aLinha,{"C6_UM"	 ,cUNSB1        ,Nil})
                aadd(aLinha,{"C6_LOCAL"	 ,'01'	        ,Nil})
                aadd(aLinha,{"C6_DESCRI" ,cDESCSB1      ,Nil})
                aadd(aLinha,{"C6_QTDVEN" ,QRY->QTD     	,Nil})
                aadd(aLinha,{"C6_PRCVEN" ,nPrcVen       ,Nil})
                aadd(aLinha,{"C6_PRUNIT" ,nPrcVen       ,Nil})
                aadd(aLinha,{"C6_VALOR"	 ,nPrcVen*QRY->QTD,Nil})

                aadd(aLinha,{"C6_NFORI"   ,QRY->DOC_DEV     ,Nil})
                aadd(aLinha,{"C6_SERIORI" ,QRY->SERIE_DEV   ,Nil})
                aadd(aLinha,{"C6_ITEMORI" ,QRY->ITEM_DEV    ,Nil})

                aadd(aLinha,{"C6_TES"	 ,cTes_	        	,Nil}) // PENSAR ROGERIO
                
                aadd(aItens,aLinha)
                cSeq := soma1(cSeq)
                QRY->( DBSKIP() )
    End
    if len(aItens) = 0
        alert('nao ha itens para geracao de pedido ')
    else
        MATA410(aCabec,aItens,3)

        If !lMsErroAuto
            //Força a Liberação do Estoque do Pedido de Venda
    //        cQueryC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST='X', D_E_L_E_T_='*' WHERE C9_PEDIDO='"+cNumPV+"' AND C9_FILIAL='"+XFILIAL("SC9")+"' AND D_E_L_E_T_=' ' "
    //        TcSqlExec(cQueryC9)
        //	FATURA(cNumPV)
            MsgInfo("Processo concluido com Sucesso, transmitir este Pedido das DEVOLUCOES para a Logistica - "+cNumPV)
        Else
            mostraerro()
        EndIf
    endif
Return
