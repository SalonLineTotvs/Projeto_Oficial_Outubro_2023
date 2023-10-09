#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function MT103FIM()
Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO.....
Local cAliasTmp := GetNextAlias()
Local xnRecno := 0
local cNF :=SF1->F1_DOC
local cSerieNF :=SF1->F1_SERIE
local cForn :=SF1->F1_FORNECE
local cloj :=SF1->F1_LOJA
local clocal:=""

DBSELECTAREA('SD1')
	DBSETORDER(1)
clocal:=POSICIONE('SD1',1,xFilial('SD1')+cNF+cSerieNF+cForn+cloj,'D1_LOCAL')

if cFilAnt=="1201" .and. INCLUI .and. clocal=="97" // logico  .... INCLUI ou  ALTERA .F. ou .T. ??  ////
    If MsgYesNo("DESEJA INTEGRAR COM A ATIVA?")
       // PREPARE ENVIRONMENT EMPRESA "02" FILIAL "1201" MODULO "COM" TABLES "SA2", "SD1", "SB1","SF1" ,"SA4"
            u_SLJsonSF1(cNF,cSerieNF,cForn,cloj)
            MSGINFO("INTEGRAÇÃO EFETUADA COM SUCESSO")   
      //  RESET ENVIRONMENT
    Else
		
	  MSGINFO("INTEGRAÇÃO CANCELADA PELO USUARIO")
		
	  Endif
endif
//IF nOpcao = 3 .AND. nConfirma = 1
// cCodEmp := FWCodEmp()
// IF cCodEmp == "01"


//      cQuery := "SELECT * FROM "+RetSqlName("SD1")+" D1 "
//      cQuery += "WHERE D1.D_E_L_E_T_ = ‘ ‘ AND D1.D1_FILIAL = ‘"+XFILIAL("SD1")+"‘ "
//      cQuery += "AND D1.D1_DOC = ‘"+SF1->F1_DOC+"‘ AND D1.D1_SERIE = ‘"+SF1->F1_SERIE+"‘AND D1.D1_FORNECE = ‘"+SF1->F1_FORNECE+"‘ AND D1.D1_LOJA = ‘"+SF1->F1_LOJA+"‘ "
//      dbUseArea(.T., ‘TOPCONN‘, TCGenQry(,,cQuery),‘TSD1‘, .F., .T.)
//      cQuery := ChangeQuery(cQuery)

//           WHILE TSD1->(!EOF())
          
//           cQuery := "SELECT D7.R_E_C_N_O_ AS REC FROM "+RetSqlName("SD7")+" D7 "
//           cQuery += "WHERE D7.D_E_L_E_T_ = ‘ ‘ AND D7.D7_FILIAL = ‘"+XFILIAL("SD7")+"‘ "
//           cQuery += "AND D7.D7_DOC = ‘"+TSD1->D1_DOC+"‘ AND D7.D7_SERIE = ‘"+TSD1->D1_SERIE+"‘AND D7.D7_FORNECE = ‘"+TSD1->D1_FORNECE+"‘ AND D7.D7_LOJA = ‘"+TSD1->D1_LOJA+"‘ "
//           dbUseArea(.T., ‘TOPCONN‘, TCGenQry(,,cQuery),‘TSD7‘, .F., .T.)
//           cQuery := ChangeQuery(cQuery)
     
//           WHILE TSD7->(!EOF())
//                SD7->(DBCLOSEAREA())
//                SD7->(DBSETORDER(1))
//                SD7->(DBGOTO(TSD7->REC))
//                RECLOCK("SD7",.F.)
//                SD7->D7_ZLOTEFO := TSD1->D1_LOTEFOR
//                SD7->D7_ZDTFABR := STOD(TSD1->D1_DFABRIC)
//                MSUNLOCK()
//                TSD7->(DBSKIP())
//           ENDDO
//           TSD7->(DBCLOSEAREA())
//           TSD1->(DBSKIP())
//           TSD1->(DBCLOSEAREA())
//      ENDDO
//      TSD1->(DBCLOSEAREA())
// //ENDIF
//ENDIF

RETURN()
