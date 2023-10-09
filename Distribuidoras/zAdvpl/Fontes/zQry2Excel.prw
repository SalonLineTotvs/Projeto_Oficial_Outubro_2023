#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#DEFINE  ENTER CHR(13)+CHR(10)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  ³ SNQry2Excel º Autor ³ Genesis/Mateus  º Data ³ 27/11/14   ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
//±±ºDescricao ³ RELATORIO - Excel (GENERICO)                              ±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*-----------------------------------------*
User Function zQry2Excel(cQryAux, cTitAux) 
*-----------------------------------------*
Default cQryAux   := ""
Default cTitAux   := "Título"

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('zQry2Excel','zQry2Excel.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

Processa({|| fProcessa(cQryAux, cTitAux) }, "Processando...")
Return

*-----------------------------------------*
Static Function fProcessa(cQryAux, cTitAux)
*-----------------------------------------*
Local aArea       := GetArea()
Local aAreaX3     := SX3->(GetArea())
Local nAux        := 0
Local oFWMsExcel
Local oExcel
Local cDiretorio  := GetTempPath()
Local cArquivo    := 'zQry2Excel.xml'
Local cArqFull    := cDiretorio + cArquivo
Local cWorkSheet  := "Aba - Principal"
Local cTable      := ""
Local aColunas    := {}
Local aEstrut     := {}
Local aLinhaAux   := {}
Local cTitulo     := ""
Local nTotal      := 0
Local nAtual      := 0
Default cQryAux   := ""
Default cTitAux   := "Título"

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('fProcessa','zQry2Excel.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

cTable := cTitAux

//Se tiver a consulta
If !Empty(cQryAux)
	//TCQuery cQryAux New Alias "QRY_AUX"
	If Select("QRY_AUX") > 0   	
		QRY_AUX->(DbCloseArea())
	EndIf
				
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryAux),"QRY_AUX",.F.,.T.)
	DbSelectArea("QRY_AUX");QRY_AUX->(DbGotop())	
	
	DbSelectArea('SX3')
	SX3->(DbSetOrder(2)) //X3_CAMPO
	
	//Percorrendo a estrutura
	aEstrut := QRY_AUX->(DbStruct())
	ProcRegua(Len(aEstrut))

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()
	oFWMsExcel:AddworkSheet(cWorkSheet)
	oFWMsExcel:AddTable(cWorkSheet, cTable)
		
	For nAux := 1 To Len(aEstrut)
		IncProc("Incluindo coluna "+cValToChar(nAux)+" de "+cValToChar(Len(aEstrut))+"...")
		cTitulo := ""
		
		//Se conseguir posicionar no campo
		If SX3->(DbSeek(aEstrut[nAux][1]))
			cTitulo := Alltrim(SX3->X3_TITULO)
			
			//Se for tipo data, transforma a coluna
			IF SX3->X3_TIPO == 'D'
				TCSetField("QRY_AUX", aEstrut[nAux][1], "D")
			EndIf
		Else
			cTitulo := Capital(Alltrim(aEstrut[nAux][1]))
		EndIf
		
		//Adicionando nas colunas
		aAdd(aColunas, cTitulo)

		//Se conseguir posicionar no campo
		IF SX3->(DbSeek(aEstrut[nAux][1]))			
			IF SX3->X3_TIPO == 'N'
				oFWMsExcel:AddColumn(cWorkSheet, cTable, cTitulo, 2, 2)  
			Else
				oFWMsExcel:AddColumn(cWorkSheet, cTable, cTitulo, 1, 1)  
			EndIf
		Else
			oFWMsExcel:AddColumn(cWorkSheet, cTable, cTitulo, 1, 1)  
		EndIf
		
	Next
		    
	/*
	//Adicionando as Colunas
	For nAux := 1 To Len(aColunas)
		//cWorkSheet	Caracteres	Nome da planilha	 		 
	 	//cTable		Caracteres	Nome da planilha	 
	 	//cColumn		Caracteres	Titulo da tabela que será adicionada	 
	 	//nAlign		Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	 
	 	//nFormat  		Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	 	 
	 	//lTotal   		Lógico		Indica se a coluna deve ser totalizada
		oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
	Next
	*/
	
	//Definindo o total da barra
	DbSelectArea("QRY_AUX")
	QRY_AUX->(DbGoTop())
	Count To nTotal
	ProcRegua(nTotal)
	nAtual := 0
	
	//Percorrendo os produtos
	QRY_AUX->(DbGoTop())
	While !QRY_AUX->(EoF())
		nAtual++
		IncProc("Processando registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		
		//Criando a linha
		aLinhaAux := Array(Len(aColunas))
		For nAux := 1 To Len(aEstrut)
			aLinhaAux[nAux] := &("QRY_AUX->"+aEstrut[nAux][1])
		Next
		
		//Adiciona a linha no Excel
		oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
		                       	
		QRY_AUX->(DbSkip())
	EndDo
	
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArqFull)
	
	//Se tiver o excel instalado
	If ApOleClient("msexcel")
		oExcel := MsExcel():New()
		oExcel:WorkBooks:Open(cArqFull)
		oExcel:SetVisible(.T.)
		oExcel:Destroy()
		
	Else
		//Se existir a pasta do LibreOffice 5
		If ExistDir("C:\Program Files (x86)\LibreOffice 5")
			WaitRun('C:\Program Files (x86)\LibreOffice 5\program\scalc.exe "'+cDiretorio+cArquivo+'"', 1)
			
			//Senão, abre o XML pelo programa padrão
		Else
			ShellExecute("open", cArquivo, "", cDiretorio, 1)
		EndIf
	EndIf
	
	QRY_AUX->(DbCloseArea())
EndIf

RestArea(aAreaX3)
RestArea(aArea)
Return
