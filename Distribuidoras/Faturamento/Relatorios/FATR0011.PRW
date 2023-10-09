#include "Totvs.ch"
#include "Fileio.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATR0011 ³ Autor ³ André Valmir 		³ Data ³25/02/2019    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Produção com base na programação da Onda	  	  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DISTRIBUIDORA                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      			  		   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	  ³±±
±±³ 																	  ³±±
±±³ 																	  ³±±
±±³ 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function FATR0011(dDtProg)

PROCESSA( { || RunProc() }, "RELATORIO DE PRODUÇÃO", "POR FAVOR AGUARDE, GERANDO REGISTROS...", .F.)

Return()

Static Function RunProc()
                       

Local cArqTmp
Local oFWMsExcel
Local oExcel                                                     
Local cTime := SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2) + SUBSTR(TIME(), 7, 2)
Local cArquivo	:= GetTempPath()+'Relatorio_'+dtos(dDtProg)+'_'+cTime+'.xls'
Local cWorkSheet 
Local cTable	 
Local aColunas	:= {}
Local aLinhaAux	:= {}
local cQuery	:= ""
            
cQuery := " select PRODUTO, DESCRICAO, TIPO, LINHA, ROUND(IIF(saldo < 0,0,SALDO),0) ESTOQUE, ROUND(LOGISTICA,0) LOGISTICA, LIBERADO, ROUND(normal,0) NORMAL,ROUND(ANT,0) ANT, ROUND(QT,0) ONDA, ROUND(LOGISTICA+LIBERADO+NORMAL+ANT+QT,0) CARTEIRA, ROUND(IIF(saldo < 0,0,SALDO)-(LOGISTICA+LIBERADO+NORMAL+ANT+QT),0) SALDO FROM (					    "
cQuery += " select X.produto, X.DESCRICAO, X.TIPO,CLASSIFICACAO.LINHA,                                                                                                                                                                                                                                                                                  "
cQuery += " MAX(SC.S_LOG) SALDO, SUM(LOGISTICA) LOGISTICA,SUM(LIBERADO) LIBERADO, SUM(OndaAnteriorN) normal,SUM(OndaAnteriorAnt) ANT, SUM(OndaAtualQT) QT, SUM(OndaAtualR$) R$ from (                                                                                                                                                              "
cQuery += " select C6_PRODUTO produto, B1_DESC DESCRICAO,b1_x_msblq bloqueado,                                                                                                                                                                                                                                                                          "
cQuery += " CASE B1_POSIPI                                                                                                                                                                                                                                                                                                                              "
cQuery += "      WHEN '33051000' THEN 'COSMETICOS'                                                                                                                                                                                                                                                                                                      "
cQuery += "      WHEN '33052000' THEN 'COSMETICOS'                                                                                                                                                                                                                                                                                                      "
cQuery += "      WHEN '33059000' THEN 'COSMETICOS'                                                                                                                                                                                                                                                                                                      "
cQuery += "      WHEN '33072010' THEN 'COSMETICOS'                                                                                                                                                                                                                                                                                                      "
cQuery += "      WHEN '33079000' THEN 'COSMETICOS'                                                                                                                                                                                                                                                                                                      "
cQuery += "      WHEN '34011900' THEN 'COSMETICOS'                                                                                                                                                                                                                                                                                                      "
cQuery += " 	 WHEN '39232110' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " 	 WHEN '85098090' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " 	 WHEN '85102000' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " 	 WHEN '85109011' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " 	 WHEN '85163100' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " 	 WHEN '85163200' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " 	 WHEN '85169000' THEN 'ELETRICOS'                                                                                                                                                                                                                                                                                                       "
cQuery += " ELSE 'OUTROS' END TIPO,                                                                                                                                                                                                                                                                                                                     "
cQuery += " IIF(C5_X_DTOLO not in ('"+dtos(dDtProg)+"') and C5_X_STAPV IN ('2','3','4','5'),SUM(C6_QTDVEN),0 ) LOGISTICA,                                                                                                                                                                                                                               "
cQuery += " IIF(C5_X_DTOLO not in ('"+dtos(dDtProg)+"') and C5_X_STAPV IN ('1'),SUM(C6_QTDVEN),0 ) LIBERADO,                                                                                                                                                                                                                                            "
cQuery += " iif((C5_X_DTOLO not in ('"+dtos(dDtProg)+"') and C5_X_DTOLO not in ('')  and (C5_X_STAPV IN ('0') and c5_nota='') ),sum(C6_qtdven),0) OndaAnteriorN,                                                                                                                                                                                        "
cQuery += " iif(C5_X_DTOLO not in ('"+dtos(dDtProg)+"') and C5_X_DTOLO NOT IN ('') and (C5_X_STAPV IN ('A')  AND C5_NOTA!=''),sum(C6_qtdven),0) OndaAnteriorAnt,                                                                                                                                                                                        "
cQuery += " iif(C5_X_DTOLO in ('"+dtos(dDtProg)+"'),sum(C6_qtdven),0) OndaAtualQT,                                                                                                                                                                                                                                                                      "
cQuery += " iif(C5_X_DTOLO in ('"+dtos(dDtProg)+"'),sum(C6_VALOR),0) OndaAtualR$                                                                                                                                                                                                                                                                        "
cQuery += " from PROTHEUS_PROD.DBO.SC6020 WITH (NOLOCK)                                                                                                                                                                                                                                                                                                 "
cQuery += " join PROTHEUS_PROD.DBO.SC5020 WITH (NOLOCK)  on C5_FILIAL = C6_FILIAL and C5_NUM = C6_NUM and SC5020.D_E_L_E_T_=''                                                                                                                                                                                                                          "
cQuery += " INNER JOIN PROTHEUS_PROD.DBO.SA1020 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND SA1020.D_E_L_E_T_=''                                                                                                                                                                                                                  "
cQuery += " INNER JOIN PROTHEUS_PROD.DBO.SB1020 WITH (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1020.D_E_L_E_T_='' AND B1_COD BETWEEN '00000' AND '99999'                                                                                                                                                                                                    "
cQuery += " where SC6020.D_E_L_E_T_='' AND A1_SATIV1 NOT IN ('000003','000004') AND SUBSTRING(C5_NOTA,1,3) NOT IN ('XXX',' XX') and b1_x_msblq='2'                                                                                                                                                                                                      "
cQuery += " AND C5_X_TIPO2 ='2' AND C5_TIPO ='N'  AND C6_BLQ != 'R'                                                                                                                                                                                                                                                                                     "
cQuery += " group by c6_produto,C6_FILIAL+C6_NUM, C5_X_STAPV, B1_POSIPI,B1_DESC , C5_X_ONDLG,C5_X_ONSUB,c5_nota,C5_X_ANTEC,C5_X_DTOLO,C5_X_HROLG,b1_x_msblq) X                                                                                                                                                                                          "
cQuery += " INNER JOIN [SLGROUP-JQCDQKGHCN.DYNAMIC-M.COM,1433].[PROTHEUS_PROD].[dbo].[UVSaldoLog] SC  WITH (NOLOCK) ON X.PRODUTO = SC.B2_COD "                                                                                                                                                                                                                                           "
//cQuery += " INNER JOIN [PROTHEUS_PROD].[dbo].[FVConsolidadoLog] SC  WITH (NOLOCK) ON X.PRODUTO = SC.PRODUTO                                                                                                                                                                                                                                           "
cQuery += " LEFT JOIN  [AGENTTIA_SFA_C].[dbo].[ProdutosLinha] CLASSIFICACAO WITH (NOLOCK) ON CLASSIFICACAO.CODPROD = X.PRODUTO                                                                                                                                                                                                                          "
cQuery += " GROUP BY X.produto, X.DESCRICAO, X.TIPO,CLASSIFICACAO.LINHA,bloqueado                                                                                                                                                                                                                                                                       "
cQuery += " ) ZZZ where QT > 0 and  TIPO= 'COSMETICOS'                                                                                                                                                                                                                                                                                                  "
cQuery += " order by SALDO                                                                                                                                                                                                                                                                                                                              "
                                                                                                                                                                                                                                                                                                                                                        
If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(dbGoTop())

//Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()

cWorkSheet	:= "RELATORIO PRODUÇÃO"
cTable		:= "RELATORIO PRODUÇÃO"
aColunas	:= {}

// Colunas 
aAdd(aColunas, "PRODUTO")
aAdd(aColunas, "DESCRICAO")
aAdd(aColunas, "TIPO") 
aAdd(aColunas, "LINHA")
aAdd(aColunas, "ESTOQUE")
aAdd(aColunas, "LOGISTICA")
aAdd(aColunas, "LIBERADO")
aAdd(aColunas, "NORMAL")
aAdd(aColunas, "ANT")
aAdd(aColunas, "ONDA")
aAdd(aColunas, "CARTEIRA")
aAdd(aColunas, "SALDO")
	
//Aba 01 - Teste
oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
 
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet, cTable)
 
	//Criando Colunas
For nAux := 1 To Len(aColunas)
	
	If aColunas[nAux] == "ESTOQUE" .OR. aColunas[nAux] == "LOGISTICA" .OR. aColunas[nAux] == "LIBERADO" .OR. aColunas[nAux] == "NORMAL" .OR. aColunas[nAux] == "ANT" .OR. aColunas[nAux] == "ONDA" .OR. aColunas[nAux] == "CARTEIRA" .OR. aColunas[nAux] == "SALDO"
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 2)
	Else
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
	Endif

Next

While TMP->(!EOF())
	
 	aLinhaAux		:= Array(12) // quantidade de colunas
	
	aLinhaAux[1]	:= TMP->PRODUTO
	aLinhaAux[2]	:= TMP->DESCRICAO
	aLinhaAux[3]	:= TMP->TIPO 
	aLinhaAux[4]	:= TMP->LINHA
	aLinhaAux[5]	:= TMP->ESTOQUE
	aLinhaAux[6]	:= TMP->LOGISTICA
	aLinhaAux[7]	:= TMP->LIBERADO
	aLinhaAux[8]	:= TMP->NORMAL
	aLinhaAux[9]	:= TMP->ANT
	aLinhaAux[10]	:= TMP->ONDA
	aLinhaAux[11]	:= TMP->CARTEIRA
	aLinhaAux[12]	:= TMP->SALDO	
		
	//Adiciona a linha no Excel
	oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
			
	TMP->(dbSkip())

Enddo
 
//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
     
//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
oExcel:WorkBooks:Open(cArquivo)       //Abre uma planilha
oExcel:SetVisible(.T.)                //Visualiza a planilha
//oExcel:Destroy()                      //Encerra o processo do gerenciador de tarefas

//FErase(cArquivo)
TMP->(dbCloseArea())

Return()