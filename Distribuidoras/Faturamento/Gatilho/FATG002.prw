#Include "Protheus.Ch"
#Include "TopConn.Ch"

User Function FATG002()
Local cQry1    := ""
Local cQry2    := ""
Local cQry3    := ""
Local cQry4    := ""
 Local cQry5    := ""

//PREPARE ENVIRONMENT EMPRESA '02' FILIAL '0101' MODULO "FAT"

  		//STATUS 1=PENDENTE quando estiver com bloqueio.
        cQry1   := " UPDATE "+RetSQLName("SC5")+" SET C5_X_STACR='1' "
        cQry1   += " FROM "+RetSQLName("SC5")+" C5 WITH (NOLOCK) "
        cQry1   += " INNER JOIN "+RetSQLName("SC9")+" C9 WITH (NOLOCK) "
        cQry1   += " ON C5_FILIAL+C5_NUM=C9_FILIAL+C9_PEDIDO AND C9.D_E_L_E_T_=' ' "
        cQry1   += " WHERE C5.D_E_L_E_T_=' ' AND C5_TIPO='N' "
        cQry1   += " AND C5_NOTA=' ' AND C5_X_STACR IN (' ','1','2') " 
        cQry1   += " AND (C9_BLCRED <> ' ')  "
        
         //STATUS 5=LIBERADO quando não tiver bloqueio de crédito.
        cQry2   := " UPDATE "+RetSQLName("SC5")+" SET C5_X_STACR='0' "
        cQry2   += " FROM "+RetSQLName("SC5")+" C5 WITH (NOLOCK) "
        cQry2   += " INNER JOIN "+RetSQLName("SC9")+" C9 WITH (NOLOCK) "
        cQry2   += " ON C5_FILIAL+C5_NUM=C9_FILIAL+C9_PEDIDO AND C9.D_E_L_E_T_=' ' "
        cQry2   += " WHERE C5.D_E_L_E_T_=' ' AND C5_TIPO='N' "
        cQry2   += " AND C5_NOTA=' ' AND C5_X_STACR='1' "
        cQry2   += " AND C9_BLCRED = ' '  " 
         
        //STATUS 2=BONIFICAÇÃO - Olhando o CFOP e Cond. Pagamento
        /*
        cQry2   := " UPDATE "+RetSQLName("SC5")+" SET C5_X_STACR='2' "
        cQry2   += " FROM "+RetSQLName("SC5")+" C5 WITH (NOLOCK) "
        cQry2   += " INNER JOIN "+RetSQLName("SC6")+" C6 WITH (NOLOCK) "
        cQry2   += " ON C5_FILIAL+C5_NUM=C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_=' ' "
        cQry2   += " WHERE C5.D_E_L_E_T_=' ' AND C5_TIPO='N' "
        cQry2   += " AND C5_NOTA=' '  AND C5_X_STACR=' ' "
        cQry2   += " AND C5_CONDPAG='057'  AND C6_CF IN ('5910','6910') "
        cQry2   += " AND C5_EMISSAO > '20190311' "
        */
        
        //STATUS 3=TROCA - Olhando o CFOP e Cond. Pagamento
        /*
        cQry3   := " UPDATE "+RetSQLName("SC5")+" SET C5_X_STACR='3' "
        cQry3   += " FROM "+RetSQLName("SC5")+" C5 WITH (NOLOCK) "
        cQry3   += " INNER JOIN "+RetSQLName("SC6")+" C6 WITH (NOLOCK) "
        cQry3   += " ON C5_FILIAL+C5_NUM=C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_=' ' "
        cQry3   += " WHERE C5.D_E_L_E_T_=' ' AND C5_TIPO='N' "
        cQry3   += " AND C5_NOTA=' '  AND C5_X_STACR =' ' "
        cQry3   += " AND C5_CONDPAG='057'  AND C6_CF IN ('5949','6949') "
        cQry3   += " AND C5_EMISSAO > '20190311' "
        */
            
        //STATUS 4=SALDO quando o pedido tiver falta.
        /*
        cQry4   := " UPDATE "+RetSQLName("SC5")+" SET C5_X_STACR='4' "
        cQry4   += " WHERE C5.D_E_L_E_T_=' ' AND C5_TIPO='N' "
        cQry4   += " AND C5_NOTA=' '  " 
        cQry4   += " AND C5_X_DIGIT<>'WEBSERVICE' "
        cQry4   += " AND C5_EMISSAO > '20190311' "
        cQry4   += " AND C5_X_STACR IN (' ','1','2','3') "
        	*/

        
        
        TcSqlExec(cQry1)
        TcSqlExec(cQry2)
        
        //TcSqlExec(cQry2)
        //TcSqlExec(cQry3)
        //TcSqlExec(cQry4)
        


//RESET ENVIRONMENT

Return()