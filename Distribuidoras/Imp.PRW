#include "Totvs.ch"
#include "Fileio.ch"
#include "TopConn.ch"
#Include "Protheus.Ch"
#include "rwmake.ch"
#include "TBICONN.CH"        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ Imp ³ Autor ³ Gustavo S A Barbosa ³ Data ³03/04/2023  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Devolução              	    	 			  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 			                                                 ³±±
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

User Function Imp(cDocInv)
	
	Local aRet		:= {}
	Local aParam	:= {}

	Local date	:= space(08)		

	aadd(aParam, { 1, "Qual Mês e Ano"		,	CTOD(date)		,"@!",".T.",,".T.",080,.F.	} )

	If ParamBox( aParam, "Relatorio de Devolução",aRet,,,,,,,,.F.,.T.)    

		date	:= aRet[1]

	Else
		Return()
	Endif

		PROCESSA( { || RunProc(date) }, "RELATORIO", "POR FAVOR AGUARDE, GERANDO REGISTROS...", .F.)

Return()

Static Function RunProc(date)

Local oFWMsExcel
Local oExcel                                                     
Local cTime := SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2) + SUBSTR(TIME(), 7, 2)
Local cArquivo	:= "C:\Temp\"+'Rel_Dev_'+cTime+'.xls' //GetTempPath()+'programacao_'+cNroOnda+'_'+cTime+'.xls'
Local cWorkSheet 
Local cTable	 
Local aColunas	:= {}
Local aLinhaAux	:= {}
local cQueryLK	:= ""
local nAux
            
cQueryLK := " SELECT D2_TIPO,																												"
cQueryLK += " D2_FILIAL, 																													"
cQueryLK += " D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE,																						"
cQueryLK += " D2_COD, D2_UM, D2_QUANT, D2_PRCVEN, D2_TOTAL, 																				"
cQueryLK += " D2_VALIPI, D2_VALICM, D2_ICMSRET, D2_CF, 																						"
cQueryLK += " D2_IPI, D2_PICM, D2_NFORI, D2_ITEMORI, 																						"
cQueryLK += " F2_CHVNFE																														"
cQueryLK += " FROM SD2020 D2 (NOLOCK)																										"
cQueryLK += " INNER JOIN SF2020 F2 (NOLOCK) ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC  AND D2_SERIE=F2_SERIE AND F2.D_E_L_E_T_=' ' 			"
cQueryLK += " AND F2_CHVNFE<>' ' 																											"
cQueryLK += " WHERE D2.D_E_L_E_T_=' ' 																										"
cQueryLK += " AND D2_TIPO in('D','B')																										"
cQueryLK += " AND LEFT(D2_EMISSAO,6)= '"+SubStr(DTOS(date), 0, 6)+"'																			"
cQueryLK += " AND D2_CLIENTE='002196'																										"
cQueryLK += " ORDER BY D2_FILIAL, D2_DOC, D2_ITEM																							"

If Select("QLK") > 0
	QLK->(dbCloseArea())
Endif

TCQUERY cQueryLK NEW ALIAS "QLK"

QLK->(dbGoTop())

//Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()

cWorkSheet	:= "RELATORIO DE DEVOLUCAO"
cTable		:= "RELATORIO DE DEVOLUCAO"
aColunas	:= {}

// Colunas 

aAdd(aColunas, " D2_TIPO	")
aAdd(aColunas, " D2_FILIAL	")
aAdd(aColunas, " D2_DOC		")
aAdd(aColunas, " D2_SERIE	")
aAdd(aColunas, " D2_EMISSAO	")
aAdd(aColunas, " D2_CLIENTE	")
aAdd(aColunas, " D2_COD		")
aAdd(aColunas, " D2_UM		")
aAdd(aColunas, " D2_QUANT	")
aAdd(aColunas, " D2_PRCVEN	")
aAdd(aColunas, " D2_TOTAL	")
aAdd(aColunas, " D2_VALIPI	")
aAdd(aColunas, " D2_VALICM	")
aAdd(aColunas, " D2_ICMSRET	")
aAdd(aColunas, " D2_CF		")
aAdd(aColunas, " D2_IPI		")
aAdd(aColunas, " D2_PICM	")
aAdd(aColunas, " D2_NFORI	")
aAdd(aColunas, " D2_ITEMORI	")
aAdd(aColunas, " F2_CHVNFE	")


//Aba 01 - Teste
oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
 
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet, cTable)
 

//Criando Colunas		Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
For nAux := 1 To Len(aColunas)

	If aColunas[nAux] $ "QUANTIDADE"
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 2)
	Else
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
	Endif   

Next

While QLK->(!EOF())
	
 	aLinhaAux		:= Array(10) // quantidade de colunas
	
	aLinhaAux[1]	:= QLK->D2_TIPO
	aLinhaAux[2]	:= QLK->D2_FILIAL
	aLinhaAux[3]	:= QLK->D2_DOC
	aLinhaAux[4]	:= QLK->D2_SERIE
	aLinhaAux[5]	:= STOD(QLK->D2_EMISSAO)
	aLinhaAux[6]	:= QLK->D2_CLIENTE
	aLinhaAux[7]	:= QLK->D2_COD
	aLinhaAux[8]	:= QLK->D2_UM
	aLinhaAux[9]	:= QLK->D2_QUANT
	aLinhaAux[10]	:= QLK->D2_PRCVEN
	aLinhaAux[11]	:= QLK->D2_TOTAL
	aLinhaAux[12]	:= QLK->D2_VALIPI
	aLinhaAux[13]	:= QLK->D2_VALICM
	aLinhaAux[14]	:= QLK->D2_ICMSRET
	aLinhaAux[15]	:= QLK->D2_CF
	aLinhaAux[16]	:= QLK->D2_IPI
	aLinhaAux[17]	:= QLK->D2_PICM
	aLinhaAux[18]	:= QLK->D2_NFORI
	aLinhaAux[19]	:= QLK->D2_ITEMORI
	aLinhaAux[20]	:= QLK->F2_CHVNFE

	//Adiciona a linha no Excel
	oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
			
	QLK->(dbSkip())

Enddo
 
//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
      
//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
oExcel:WorkBooks:Open(cArquivo)       //Abre uma planilha
oExcel:SetVisible(.T.)                //Visualiza a planilha
//oExcel:Destroy()                    //Encerra o processo do gerenciador de tarefas

//FErase(cArquivo)
QLK->(dbCloseArea())

Return()
