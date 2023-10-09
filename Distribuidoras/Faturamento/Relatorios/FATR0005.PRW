#include "Totvs.ch"
#include "Fileio.ch"
#include "TopConn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATR0005 ³ Autor ³ André Valmir 		³ Data ³28/08/2018    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio da Programação dos pedidos de vendas    		  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      			  		   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	  ³±±
±±³ 																	  ³±±
±±³ 																	  ³±±
±±³ 																	  ³±±
±±³ 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function FATR0005(cNroOnda, cOpcao)

Private cTipo	:= cOpcao

PROCESSA( { || RunProc() }, "PROGRAMAÇÃO DE PEDIDOS", "POR FAVOR AGUARDE, GERANDO REGISTROS...", .F.)

Return()

Static Function RunProc()

Local cArqTmp
Local oFWMsExcel
Local oExcel                                                     
Local cTime := SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2) + SUBSTR(TIME(), 7, 2)
Local cArquivo	:= "C:\Temp\"+'programacao_'+cNroOnda+'_'+cTime+'.xls' //GetTempPath()+'programacao_'+cNroOnda+'_'+cTime+'.xls'
Local cWorkSheet 
Local cTable	 
Local aColunas	:= {}
Local aLinhaAux	:= {}
local cQuery	:= ""
            
If cTipo == 'N'
	cQuery := " SELECT CASE 	"
	cQuery += " WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
	cQuery += " WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA'   "
	cQuery += " WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
	cQuery += " WHEN C5_FILIAL='0902' THEN 'DEVINTEX-MG' "
	cQuery += " ELSE C5_FILIAL END EMPRESA, "
	cQuery += " C5_FILIAL, C5_EMISSAO, C5_NUM, A1_NOME, A1_EST, A1_MUN, SUM(C6_VALOR) C6_VALOR, SUM(C6_X_VCXIM) VOLUME, "
	cQuery += " SUM(C6_QTDVEN * B1_PESO) PESO_LIQ, SUM(C6_QTDVEN * B1_PESBRU) PESO_BRU, A4_NREDUZ "
	cQuery += " ,CASE F4_DUPLIC WHEN 'S' THEN 'VENDA' ELSE 'BONIFICAÇÃO' END TPPED"
	cQuery += " FROM " + RetSqlName("SC5")+ " C5 WITH (NOLOCK) "
	cQuery += " INNER JOIN " +RETSQLNAME("SC6")+ " C6 WITH (NOLOCK) ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C6.D_E_L_E_T_ = '' 	"
	cQuery += " INNER JOIN " +RETSQLNAME("SF4")+ " F4 WITH (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES=F4_CODIGO AND F4.D_E_L_E_T_ = ''"
	cQuery += " INNER JOIN " +RETSQLNAME("SA1")+ " A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = '' 	"
	cQuery += " INNER JOIN " +RETSQLNAME("SA4")+ " A4 WITH (NOLOCK) ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''	"
	cQuery += " INNER JOIN " +RETSQLNAME("SB1")+ " B1 WITH (NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ''	"
	cQuery += " WHERE C5_X_NONDA = '"+cNroOnda+"' "
	cQuery += " AND C5.D_E_L_E_T_ = ''	"
	cQuery += " GROUP BY C5_FILIAL, C5_EMISSAO, C5_NUM, A1_NOME, A1_EST, A1_MUN, A4_NREDUZ,F4_DUPLIC "
	cQuery += " ORDER BY 1,2 "
Else
	cQuery := " SELECT CASE 	"
	cQuery += " WHEN C5_FILIAL='0101' THEN 'CIMEX' 	WHEN C5_FILIAL='0201' THEN 'CROZE' 	WHEN C5_FILIAL='0301' THEN 'KOPEK' "
	cQuery += " WHEN C5_FILIAL='0401' THEN 'MACO' 	WHEN C5_FILIAL='0501' THEN 'QUBIT' 	WHEN C5_FILIAL='0601' THEN 'ROJA'   "
	cQuery += " WHEN C5_FILIAL='0701' THEN 'VIXEN' 	WHEN C5_FILIAL='0801' THEN 'MAIZE' 	WHEN C5_FILIAL='0901' THEN 'DEVINTEX' "
	cQuery += " WHEN C5_FILIAL='0902' THEN 'DEVINTEX-MG' "
	cQuery += " ELSE C5_FILIAL END EMPRESA, "
	cQuery += " C5_FILIAL, C5_EMISSAO, C5_NUM, A1_NOME, A1_EST, A1_MUN, SUM(C6_VALOR) C6_VALOR, SUM(C6_X_VCXIM) VOLUME, "
	cQuery += " SUM(C6_QTDVEN * B1_PESO) PESO_LIQ, SUM(C6_QTDVEN * B1_PESBRU) PESO_BRU, A4_NREDUZ "
	cQuery += " ,CASE F4_DUPLIC WHEN 'S' THEN 'VENDA' ELSE 'BONIFICAÇÃO' END TPPED"
	cQuery += " FROM " + RetSqlName("SC5")+ " C5 WITH (NOLOCK) "
	cQuery += " INNER JOIN " +RETSQLNAME("SC6")+ " C6 WITH (NOLOCK) ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C6.D_E_L_E_T_ = '' 	"
	cQuery += " INNER JOIN " +RETSQLNAME("SA1")+ " A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ = '' 	"
	cQuery += " INNER JOIN " +RETSQLNAME("SF4")+ " F4 WITH (NOLOCK) ON C6_FILIAL=F4_FILIAL AND C6_TES=F4_CODIGO AND F4.D_E_L_E_T_ = ''	"
	cQuery += " INNER JOIN " +RETSQLNAME("SA4")+ " A4 WITH (NOLOCK) ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = ''	"
	cQuery += " INNER JOIN " +RETSQLNAME("SB1")+ " B1 WITH (NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = ''	"
	cQuery += " WHERE C5_X_ONDLG = '"+cNroOnda+"' "
	cQuery += " AND C5.D_E_L_E_T_ = ''	"
	cQuery += " GROUP BY C5_FILIAL, C5_EMISSAO, C5_NUM, A1_NOME, A1_EST, A1_MUN, A4_NREDUZ,F4_DUPLIC "
	cQuery += " ORDER BY 1,2 "
EndIf


If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(dbGoTop())

//Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()

cWorkSheet	:= "PROGRAMAÇÃO DE PEDIDOS"
cTable		:= "PROGRAMAÇÃO DE PEDIDOS"
aColunas	:= {}

// Colunas 
aAdd(aColunas, "EMPRESA")
aAdd(aColunas, "DATA")
aAdd(aColunas, "PEDIDO")
aAdd(aColunas, "CLIENTE")
aAdd(aColunas, "UF")
aAdd(aColunas, "CIDADE")
aAdd(aColunas, "VALOR")
aAdd(aColunas, "VOLUME PREVISTO")
aAdd(aColunas, "PESO LIQ PREVISTO")
aAdd(aColunas, "PESO BRU PREVISTO")
aAdd(aColunas, "TRANSPORTADORA")
aAdd(aColunas, "TIPO DE PEDIDO")
	
//Aba 01 - Teste
oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
 
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet, cTable)
 
	//Criando Colunas
For nAux := 1 To Len(aColunas)
	
	If aColunas[nAux] == "VALOR"
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 2)
	Else
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
	Endif

Next

While TMP->(!EOF())
	
 	aLinhaAux		:= Array(12) // quantidade de colunas
	
	aLinhaAux[1]	:= TMP->EMPRESA
	aLinhaAux[2]	:= STOD(TMP->C5_EMISSAO)
	aLinhaAux[3]	:= TMP->C5_NUM
	aLinhaAux[4]	:= TMP->A1_NOME
	aLinhaAux[5]	:= TMP->A1_EST
	aLinhaAux[6]	:= TMP->A1_MUN
	aLinhaAux[7]	:= TMP->C6_VALOR
	aLinhaAux[8]	:= TMP->VOLUME
	aLinhaAux[9]	:= TMP->PESO_LIQ
	aLinhaAux[10]	:= TMP->PESO_BRU
	aLinhaAux[11]	:= TMP->A4_NREDUZ
	aLinhaAux[12]	:= TMP->TPPED
				
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
