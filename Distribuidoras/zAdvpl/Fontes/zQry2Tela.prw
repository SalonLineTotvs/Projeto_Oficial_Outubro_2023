#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"   

#DEFINE ENTER Chr(13)+Chr(10)  

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  ³ zQry2Tela º Autor ³ Genesis/Mateus     º Data ³ 27/11/14  ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
//±±ºDescricao ³ RELATORIO - TELA (GENERICO)                               ±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*-------------------------------------------------*
User Function zQry2Tela(_cQuery, _cCabec, _cTAMREL)
*-------------------------------------------------*
//³ Declaracao de Variaveis                                             
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := _cCabec
Local nLin         := 80

Private Cabec1       := ""
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('zQry2Tela','zQry2Tela.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

IF _cTAMREL == 'P'
	Private limite           := 80
	Private tamanho          := "P"
ElseIF _cTAMREL == 'P'
	Private limite           := 132
	Private tamanho          := "M"
Else 
	Private limite           := 220
	Private tamanho          := "G"
ENDIF	
PRIVATE _aDados     := {}
PRIVATE _aEstrut    := {}
PRIVATE _cCabRet    := ''

Private nomeprog         := "zQry2Tela" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "zQry2Tela" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, _cQuery, _cCabec, _cTAMREL) },Titulo)
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  ³ zQry2TRep º Autor ³ Genesis/Mateus     º Data ³ 27/11/14  ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
//±±ºDescricao ³ RELATORIO - TELA (GENERICO)                               ±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, _cQuery, _cCabec, _cTAMREL)

Local nOrdem
Local _nU, _nG
//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('RunReport','zQry2Tela.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________
        
Processa({|| fProcessa(_cQuery, _cCabec, _cTAMREL) }, "Processando...")


IF Len(_aDados) == 0
	MsgInfo('Nao houve retorno de dados a serem impressos','Atencao')
	Return
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(LEN(_aDados))

Cabec1 := _cCabRet

FOR _NG:=1 TO LEN(_aDados)
     
	_aLinImp := _aDados[_NG]
   //³ Verifica o cancelamento pelo usuario...                             
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   _nCols := 0   
   For _nU:=1 to Len(_aLinImp)
   		 
		IF _aEstrut[_nU][2] $ 'C' .And. Valtype(_aDados[_NG][_nU]) == 'C'
			_cPrint := PadR(Upper(_aDados[_NG][_nU]),_aEstrut[_nU][3])
		ElseIF _aEstrut[_nU][2] $ 'D' .Or. Valtype(_aDados[_NG][_nU]) == 'D'
			_cPrint := DtoC(_aDados[_NG][_nU])
		ElseIF _aEstrut[_nU][2] $ 'N' .And. Valtype(_aDados[_NG][_nU]) == 'N'
			DbSelectArea('SX3'); SX3->(dbSetOrder(2))
			IF SX3->(MsSeek(_aEstrut[_nU][1]))
				_cPrint := PadL(AllTrim(TransForm(_aDados[_NG][_nU], X3Picture(_aEstrut[_nU][1]))),_aEstrut[_nU][3])	
			Else
				_cPrint := PadL(AllTrim(TransForm(_aDados[_NG][_nU], '@e 999,999,999,99')),_aEstrut[_nU][3])			
			EndIF
		ENDIF 
		@nLin,_nCols PSAY _cPrint		
		_nCols += _aEstrut[_nU][3] + 2			
   Next _nU
   
   nLin := nLin + 1 // Avanca a linha de impressao

Next _NG

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  ³ zQry2TRep º Autor ³ Genesis/Mateus     º Data ³ 27/11/14  ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
//±±ºDescricao ³ RELATORIO - TELA (GENERICO)                               ±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*---------------------------------------------------*
Static Function fProcessa(_cQuery, _cCabec, _cTAMREL)
*---------------------------------------------------*
Local aArea       := GetArea()
Local aAreaX3     := SX3->(GetArea())
Local nAux        := 0

Local aColunas    := {}
//Local aEstrut     := {}
Local aLinhaAux   := {}
Local cTitulo     := ""
Local nTotal      := 0
Local nAtual      := 0

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('fProcessa','zQry2Tela.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

//Se tiver a consulta
If !Empty(_cQuery)  	
	TCQuery _cQuery New Alias "QRY_AUX"
	
	DbSelectArea('SX3')
	SX3->(DbSetOrder(2)) //X3_CAMPO
	
	//Percorrendo a estrutura
	aEstrut  := QRY_AUX->(DbStruct()) 
	_aEstrut := aClone(aEstrut )
	
	ProcRegua(Len(aEstrut))
	For nAux := 1 To Len(aEstrut)
		IncProc("Incluindo coluna "+cValToChar(nAux)+" de "+cValToChar(Len(aEstrut))+"...")
		cTitulo := ""
		
		//Se conseguir posicionar no campo
		If SX3->(DbSeek(aEstrut[nAux][1]))
			cTitulo := Alltrim(SX3->X3_TITULO)
			
			//Se for tipo data, transforma a coluna
			If SX3->X3_TIPO == 'D'
				TCSetField("QRY_AUX", aEstrut[nAux][1], "D")
			EndIf
		Else
			cTitulo := Capital(Alltrim(aEstrut[nAux][1]))
		EndIf
				
		//Adicionando nas colunas
		aAdd(aColunas, cTitulo)
		IF aEstrut[nAux][2] $ 'C'
			_nTamTit := LEN(Upper(AllTrim(cTitulo))) 
			_nTamCpo := aEstrut[nAux][3]
			//Caso o tamanho do titulo seja maior que o tamanho do campo grava espaco pelo titulos
			IF _nTamTit > _nTamCpo              
				aEstrut[nAux][3] := _aEstrut[nAux][3] := _nTamTit
              	_cCabRet += PadR(Upper(cTitulo),aEstrut[nAux][3])+Space(02)
			Else
				_cCabRet += PadR(Upper(cTitulo),aEstrut[nAux][3])+Space(02)
			ENDIF
			
		ElseIF  aEstrut[nAux][2] $ 'D'
			_cCabRet += PadR(Upper(cTitulo),aEstrut[nAux][3])+Space(02)
		ELSE
			_cCabRet += PadL(Upper(cTitulo),aEstrut[nAux][3])+Space(02)
		ENDIF
	Next
			
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
		aADD(_aDados, aLinhaAux)
				
		QRY_AUX->(DbSkip())
	EndDo
		
	QRY_AUX->(DbCloseArea())
EndIf

RestArea(aAreaX3)
RestArea(aArea)
Return
