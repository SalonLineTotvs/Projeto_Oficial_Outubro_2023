#include "Totvs.ch"
#include "Fileio.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ FATR0009 ³ Autor ³ André Valmir 		³ Data ³20/12/2018    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Pedidos de Vendas com Falta por Onda	  	  ³±±
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

User Function FATR0009(cNroOnda, cOpcao)

Private cTipo	:= cOpcao

PROCESSA( { || RunProc() }, "RELATORIO DE PEDIDOS COM FALTA", "POR FAVOR AGUARDE, GERANDO REGISTROS...", .F.)

Return()

Static Function RunProc()
                       

Local cArqTmp
Local oFWMsExcel
Local oExcel                                                     
Local cTime := SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2) + SUBSTR(TIME(), 7, 2)
Local cArquivo	:= GetTempPath()+'Relatorio_'+cNroOnda+'_'+cTime+'.xls'
Local cWorkSheet 
Local cTable	 
Local aColunas	:= {}
Local aLinhaAux	:= {}
local cQuery	:= ""
            

If cTipo == 'N'
	cQuery := " SELECT C6_PRODUTO, C6_DESCRI, SUM(C6_QTDVEN) C6_QTDVEN 	"
	cQuery += " FROM SC6020 C6 WITH (NOLOCK) "
	cQuery += " 	INNER JOIN SC5020 C5 WITH (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5.D_E_L_E_T_ = ''   "
	cQuery += " WHERE C6.D_E_L_E_T_ = '' "
	cQuery += " AND C5_X_NONDA = '"+cNroOnda+"' AND C6_X_ESTOQ = 'N' "
	cQuery += " GROUP BY C6_PRODUTO, C6_DESCRI "
	cQuery += " ORDER BY C6_PRODUTO "
Else
	cQuery := " SELECT C6_PRODUTO, C6_DESCRI, SUM(C6_QTDVEN) C6_QTDVEN 	"
	cQuery += " FROM SC6020 C6 WITH (NOLOCK) "
	cQuery += " 	INNER JOIN SC5020 C5 WITH (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5.D_E_L_E_T_ = ''   "
	cQuery += " WHERE C6.D_E_L_E_T_ = '' "
	cQuery += " AND C5_X_ONDLG = '"+cNroOnda+"' AND C6_X_ESTOQ = 'N' "
	cQuery += " GROUP BY C6_PRODUTO, C6_DESCRI "
	cQuery += " ORDER BY C6_PRODUTO "
EndIf


If Select("TMP") > 0
	TMP->(dbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(dbGoTop())

//Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()

cWorkSheet	:= "PEDIDOS COM FALTA"
cTable		:= "PEDIDOS COM FALTA"
aColunas	:= {}

// Colunas 
aAdd(aColunas, "PRODUTO")
aAdd(aColunas, "DESCRICAO")
aAdd(aColunas, "QUANTIDADE")
	
//Aba 01 - Teste
oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
 
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet, cTable)
 
	//Criando Colunas
For nAux := 1 To Len(aColunas)
	
	If aColunas[nAux] == "QUANTIDADE"
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 2)
	Else
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
	Endif

Next

While TMP->(!EOF())
	
 	aLinhaAux		:= Array(3) // quantidade de colunas
	
	aLinhaAux[1]	:= TMP->C6_PRODUTO
	aLinhaAux[2]	:= TMP->C6_DESCRI
	aLinhaAux[3]	:= TMP->C6_QTDVEN

		
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