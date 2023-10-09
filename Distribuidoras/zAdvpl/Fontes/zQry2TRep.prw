	#include "TOTVS.ch"    
	#include "protheus.ch"
	#include "topconn.ch"

	#DEFINE ENTER Chr(13)+Chr(10)  

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//±±ºPrograma  ³ zQry2TRep º Autor ³ Genesis/Mateus     º Data ³ 27/11/14  ±±
	//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
	//±±ºDescricao ³ RELATORIO - MODELO T-REPORT (GENERICO)                    ±±
	//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*---------------------------------------*
	User Function zQry2TRep(cQryAux, cTitAux)
	*---------------------------------------*
	Default cQryAux   := ""
	Default cTitAux   := "Título"

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('zQry2TRep','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________

	Processa({|| fProcessa(cQryAux, cTitAux) }, "Processando...")
	Return

	*-----------------------------------------*
	Static Function fProcessa(cQryAux, cTitAux)
	*-----------------------------------------*
	Private _cNomeRel := 'ZZADRG02'+Criatrab(Nil,.F.)
	Private _nPosi    := 1
	Private _nXX      := 1

	Private oReport
	Private oContas

	Private cTitulo := cTitAux                       

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('fProcessa','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________

	_cReturn:= ''

	//if ! LeArqX(_cDir+cArqMemo+"." + _par01,@_cReturn) 
	//	MsgInfo("Problemas na leitura do arquivo, verifique!!! ")
	//	Return()
	//endif

	/*
	SX1->(DBSETORDER(1))
	IF SX1->(DBSEEK(_cPerg1))
		If !Pergunte(_cPerg1,.T.)
			Return
		Else
		
			For nMv := 1 To 40
				_cVar := &( "MV_PAR" + StrZero( nMv, 2, 0 ) )
				//_cVar := ALLTRIM(_cVar)
				
				IF Type("_cVar") == "D"
					_cVar := DTOS(_cVar)
				ElseIf Type("_cVar") == 'N'
					_cVar := cValToChar(_cVar)
				Elseif Type("_cVar") == 'U'
					_cVar := ''
				Elseif ';' $ _cVar .OR. '*' $ _cVar 
					IF ';' $ _cVar
						_cVar := ALLTRIM(_cVar)+'!!'
					Endif
					IF '*' $ _cVar
						_cVar := ALLTRIM(_cVar)+';!!'
					Endif
					_cVar := FormatIn( _cVar, ";" )
				Else
					_cVar := ALLTRIM(_cVar)
				Endif						
				_cReturn := STRTRAN( _cReturn, "MV_PAR" + StrZero( nMv, 2, 0 ) , _cVar )			
			Next nMv		
		Endif
	Endif
	_cReturn := STRTRAN( _cReturn, "P_MOD" , cModulo )
	*/

	FWMsgRun(,{|| GerArqX(cQryAux, cTitAux) }, "Configurando Campos", "Configurando Campos...")

	Return


	*-----------------------------------*
	Static function LeArqX(cFile,_cReturn)
	*----------------------------------*
	Local oFile

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('LeArqX','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________

	oFile := FWFileReader():New(cFile)
	if (oFile:Open())
	while (oFile:hasLine())
		_cReturn += oFile:GetLine(.T.)
	end
	oFile:Close()       
	Else
	MsgStop("File Open Error","ERROR")
	Return(.F.)
	endif

	Return .T.


	*---------------------------------------*
	Static function GerArqX(cQryAux, cTitAux)
	*---------------------------------------*
	Private cAliasTRB := "_ARQ" 

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('GerArqX','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________

	If !Empty(cQryAux)
		//TCQuery cQryAux New Alias "_ARQ"
		If Select("_ARQ") > 0   	
			_ARQ->(DbCloseArea())
		EndIf
					
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryAux),"_ARQ",.F.,.T.)
		DbSelectArea("_ARQ");_ARQ->(DbGotop())		

		IF _ARQ->(Eof()) .AND. _ARQ->(Bof())
			MsgAlert('Não há dados')
			Return .T.
		Endif
	else
		MsgAlert('Não há dados')
		Return .T.
	endif

	aStrut := _ARQ->(dbStruct())

	// Faz as definicoes do relatorio
	oReport := ReportDef()

	// Abre janela para opcoes do usuario
	oReport:PrintDialog()

	Return

	*---------------------------*
	Static Function ReportDef()
	*---------------------------*
	Local cDescr1	:= " "
	Local nT

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('ReportDef','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := TReport():New("ZZADRG02","Genericos",cPerg, {|oReport| ReportPrint(oReport,cAliasTrb)},cDescr1)
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)      

	Pergunte(oReport:uParam,.F.)

	cTitulo := oReport:Title() 
	//oReport:SetTitle(cTitulo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oVendas := TRSection():New(oReport,"Relacao de Vendas"	,{cAliasTrb},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)
	oContas := TRSection():New(oReport,"Genericos",{cAliasTrb}) //,,,,,,,,,,.F.,,,,,,)
	oContas:SetTotalInLine(.F.)
	oContas:SetTotalText("Total ")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                                ³
	//³                                                                        ³
	//³TRCell():New                                                            ³
	//³ExpO1 : Objeto TSection que a secao pertence                            ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
	//³ExpC3 : Nome da tabela de referencia da celula                          ³
	//³ExpC4 : Titulo da celula                                                ³
	//³        Default : X3Titulo()                                            ³
	//³ExpC5 : Picture                                                         ³
	//³        Default : X3_PICTURE                                            ³
	//³ExpC6 : Tamanho                                                         ³
	//³        Default : X3_TAMANHO                                            ³
	//³ExpL7 : Informe se o tamanho esta em pixel                              ³
	//³        Default : False                                                 ³
	//³ExpB8 : Bloco de código para impressao.                                 ³
	//³        Default : ExpC2                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Secao 1 - Cliente                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
																																						
	oBreak := NIL

	For nT:= 1 to (Len(aStrut))
		
		TRCell():New(oContas,aStrut[nT][1]	,;
		cAliasTrb	,;
		IIF(Empty(GetSx3Cache(aStrut[nT][1],"X3_TITULO")),aStrut[nT][1],alltrim(GetSx3Cache(aStrut[nT][1],"X3_TITULO"))),;
		IIF(Empty(GetSx3Cache(aStrut[nT][1],"X3_TITULO")),IIF(aStrut[nT][2] == 'N',"@E 9,999,999,999.9999",'@!'),alltrim(GetSx3Cache(aStrut[nT][1],"X3_PICTURE")))		,;
		IIF(Empty(GetSx3Cache(aStrut[nT][1],"X3_TITULO")),aStrut[nT][3],GetSx3Cache(aStrut[nT][1],"X3_TAMANHO")),;
		.F.,;
		{|| PRINT_CPO() })	
			
		
		oContas:Cell(aStrut[nT][1]):SetSize(oContas:Cell(aStrut[nT][1]):GetSize(),.F.)
		
		IF aStrut[nT][2] == 'N'
			oContas:Cell(aStrut[nT][1]):SetHeaderAlign("RIGHT")
			
			TRFunction():New(oContas:Cell(aStrut[nT][1])	,/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		Endif
		
	Next nT


	Return(oReport)

	*-----------------------------------------------*
	Static Function ReportPrint(oReport,cAliasTrb)
	*-----------------------------------------------*

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('ReportPrint','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________
		
		cTitulo := _cNomeRel
		oReport:SetTitle(cTitulo)

		//oBreak := NIL

		//TRFunction():New(oContas:Cell("TOTAL")	,/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		//TRFunction():New(oContas:Cell("QTDVEN")	,/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		//TRFunction():New(oContas:Cell("QTDENT")	,/* cID */,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

		
		oContas:SetAutoSize(.F.)
		
		oReport:Section(1):SetHeaderPage()
										
		oReport:Section(1):Init()
		oReport:Section(1):Print()	
		
		oReport:Section(1):Finish()
		
		(cAliasTRB)->(DBCLOSEAREA())

	Return
		
	*---------------------*
	Static Function PRINT_CPO()
	*---------------------*

	//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
	IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
		u_SN_CLSLOGO('PRINT_CPO','zQry2TRep.prw') //1º User Function | 2° Nome.PRW
	ENDIF //__________________________________________________________________________________________________

	aReg := {}

	IF _nXX > LEN(aStrut)
		_nXX := 1
	Endif

	nT := _nXX

	IF Empty(GetSx3Cache(aStrut[nT][1],"X3_CBOX"))
		
		_cTp := GetSx3Cache(aStrut[nT][1],"X3_TIPO")
		IF Empty(_cTp) 
			aAdd(aReg,&('_ARQ->'+aStrut[nT][1]))
		Else
			IF ALLTRIM(_cTp) == 'D'
				aAdd(aReg,DTOC(STOD(&('_ARQ->'+aStrut[nT][1]))))
			Else
				aAdd(aReg,&('_ARQ->'+aStrut[nT][1]))
			Endif
		Endif

	Else
		_aOpc := RetSX3Box(GetSx3Cache(aStrut[nT][1],"X3_CBOX"),,,1)
		_nPosi := aScan(_aOpc,{|x| x[2] == &('_ARQ->'+aStrut[nT][1]) })
		
		IF _nPosi > 0
			aAdd(aReg, _aOpc[_nPosi][3] ) 
		Else
			aAdd(aReg,&('_ARQ->'+aStrut[nT][1]))
		Endif
		
	Endif
			
	_nXX++
			
	Return aReg[1]
