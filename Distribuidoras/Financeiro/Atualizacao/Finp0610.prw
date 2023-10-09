#include 'protheus.ch'
#INCLUDE "TOPCONN.CH"        
#INCLUDE "TBICONN.CH"   

#DEFINE CMD_OPENWORKBOOK 1
#DEFINE CMD_CLOSEWORKBOOK 2
#DEFINE CMD_ACTIVEWORKSHEET 3 
#DEFINE CMD_READCELL 4

#DEFINE   OPEN_FILE_ERROR -1      
#DEFINE  CRLF Chr(13)+Chr(10)   

/* FINP0001 - Claudia Cabral -05/12/2016
Importação de títulos a pagar através de planilha Excel
*/ 

user function Finp0610()
Local aParam  	 := {}
Local aArea   	 := GetArea() 
Private oDlg, oDlg1           
Private aRet     := {}
Private dDtvenc  := Ctod('')
Private cHistor  := space(25)
Private cFile    := ''           
Private cTipo    := space(03)
Private cNatureza := space(10)// GetNewPar("MV_XNATPG","41044001")   
     
  	aadd(aParam, { 6, "Arquivo",padr("",150),"",,"",90 ,.T.,"Arquivos .XLS|*.XLS","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE	} )  
	aadd(aParam, { 1, "Data vencimento",	dDtVenc	,"",".T.","",".T.",55,.T.		} ) 
	aadd(aParam, { 1, "Historico",	cHistor	,"@!",".T.","",".T.",100,.T.		} )
	aadd(aParam, { 1, "Tipo",	cTipo	,"@!",".T.","05",".T.",30,.T.		} )  
	aadd(aParam, { 1, "Natureza",	cNatureza	,"@!",".T.","SED",".T.",50,.T.		} )  
	If ParamBox( 	aParam, "Integracao Titulos a pagar",aRet,,,,,,,,.F.,.T.)    
	    cFile   	:= aRet[1]
		DDtVenc 	:= aRet[2]
		cHistor 	:= aRet[3]
		cTipo   	:= aRet[4]
		cNatureza 	:= aRet[5]
		
		RptStatus( {|lEnd| RunProc(@lEnd,cFile, dDtVenc,cHistor)}, "Aguarde...","Executando rotina.", .T. )          
	Endif  
Return 
          

STATIC FUNCTION RUNPROC(lEnd,cFile, dDtVenc,cHistor)
	Local nLidos   	:= 0
	Local nIncGra  	:= 0    
	Local cDirDocs 	:= MsDocPath() 
	Local cArquivo 	:= "IMPFOLHA_LOG"+STRTRAN(time(),":","")              
	Local cPath	 	:= AllTrim(GetTempPath()) 
	Local cArqTXT  	:= Space(40)
	Local nHandle  	:= 0   
	Local aErros    := {}
	Local lErro     := .F.
	Local aLog      := {}
	Local cPastaXls := 'Relacao de Lancamentos Bancario'
	Local nLinIni   := 5 // primeira linha a ser lida
	Local cNomeCel  := "B" //Nome do fornecedor
	Local cCPFCel   := "C" //CPF do fornecedor
	Local cVlrCel   := "E" //Valor do titulo
	Local cGetCpf   := ''
	Local cGetVlr   := 0
	Local aCells    :={}
	Local nHdl      := 0
	Local nPlanXLS  := 1
	Local nPastaXLS := 1
	Local cBuffer   := ''
	Local nI        := 0
	Local cFim      := ''
	Local cCelFim   := ''
	Local aItens    := {}
	Local xX        := 0
	Local nMax      := 0
	Local nLog      := 0
	Local nX        := 0
	Local aAuto     := {}
	Local nSalvo    := 0
	Local cNumTit   := space(09)
		
	Private lMsHelpAuto := .t.
	Private lMsErroAuto := .f.
	Private lAutoErrNoFile := .T. 
	If file (cDirDocs+"\"+cArquivo+".TXT" )
		Ferase(cDirDocs+"\"+cArquivo+".TXT")
	Endif
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".TXT",0) 
	
	If nHandle == -1
    	MsgStop('Erro de criação do arquivo de log, FERROR '+str(ferror(),4))
		Return
  	EndIF
	If ! File('C:\DLL\readexcel.dll')
		Alert( "DLL  não localizada!!!" )
		FClose(nHandle)   
		Return
	EndIF
	If ! File(cFile)
		Alert( "Arquivo não localizado!!!" )
		FClose(nHandle)   
		Return
	Endif
	
	aAdd(aCells,{cCPFCel+AllTrim(Str(nLinIni)),cVlrCel+AllTrim(Str(nLinIni))})
	
	//localiza e habilita a biblioteca responsavel por ler planilha excel
	nHdl:= ExecInDLLOpen('C:\DLL\readexcel.dll')
	//se a dll estiver no local indicado
	If nHdl < 0
		Aviso("Atenção","O arquivo readexcel.dll deverá ser gravado na pasta C:\DLL\.", {"Ok"}, 2, "Arquivo Inexistente!")
		FClose(nHandle)   
		return
	EndIF	
		    
	//Carrega a planilha excel o abre
	cBuffer := cFile + Space(512) //coloca o local + nome da planilha excel + 512 bytes de espaco em memoria
	nPlanXLS := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer) //Carrega o Excel, Exibe ao usuario e retorna controle	    
   
	If  nPlanXLS <> 0  
		Aviso("Atenção","Arquivo "+cFile+" inexistente.", {"Ok"}, 2, "Arquivo Inexistente!") //informa erro critico ao usuario
		cBuffer := Space(512)
		ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
		ExecInDLLClose(nHdl)
		FClose(nHandle)   
		Return
	EndIF
	cPastaXls := 'Relacao de Lancamentos Bancario'
	//seleciona a pasta dentro da planilha excel
	cBuffer := cPastaXLS + Space(512) //Seleciona a planilha dentro do excel
	nPastaXLS := ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer) //executa a leitura
	
	if (nPastaXLS <> 0) 
		cPastaXls := 'Plan1'
		//seleciona a pasta dentro da planilha excel
		cBuffer := cPastaXLS + Space(512) //Seleciona a planilha dentro do excel
		nPastaXLS := ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer) //executa a leitura
		if (nPastaXLS <> 0)
			cPastaXls := 'Planilha1'
			//seleciona a pasta dentro da planilha excel
			cBuffer := cPastaXLS + Space(512) //Seleciona a planilha dentro do excel
			nPastaXLS := ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer) //executa a leitura 
			if (nPastaXLS <> 0)
				MsgStop("Pasta "+cPastaXLS+" inexistente na planilha excel. Evite acentuações de qualquer tipo.") //informa erro critico ao usuario
				cBuffer := Space(512)
				ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
				ExecInDLLClose(nHdl)
				FClose(nHandle)   
				Return
			Endif
		Endif
	EndIF      
	
	SetRegua(600)
	nI := 1
	Do While .T.
		//cBuffer := aCells[nI,2] + Space(1024)
		//nBytes := ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
            
        cBuffer := cCPFCel + alltrim(str(nLinIni))  + Space(1024)
		nBytes := ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		cGetCPF := AllTrim(Subs(cBuffer, 1, nBytes))                             		
		    
		cBuffer := cVlrCel + alltrim(str(nLinIni)) + Space(1024)
		nBytes  := ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		nGetVlr := AllTrim(Subs(cBuffer, 1, nBytes)) 
			
		//Ler celula se esta no fim
		cCelfim  := cNomeCel + alltrim(str(nLinIni))
		cBuffer := cCelfim + Space(1024)
		nBytes := ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		cFim := AllTrim(Subs(cBuffer, 1, nBytes))

		if empty(alltrim(cFim)) 
			nLinIni	:= 5 //primeira linha a ser lida
			Exit 
		else
			IncRegua()
			nI++
			nLinIni++  
			//aAdd(aCells,{cCPFCel+AllTrim(Str(nLinIni)),cVlrCel+AllTrim(Str(nLinIni))})
			aAdd(aItens,{cGetCpf,nGetVlr,cFim})	// 
		endif
		
	EndDo

	//Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	
	nLidos := 0
	nMax   := Len(aItens)
	For xx := 1 to nMax
		IncRegua()
		nLidos++          
		lErro := .F.
		lMsErroAuto := .F.  
		If Empty(aItens[xx,1])
			lErro := .T.
			aadd(aErros,{" CPF vazio - " + aItens[xx,3] +  CRLF } )
		EndIF
		SA2->(DbSetOrder(3))
		If ! lErro .and. ! SA2->(DbSeek(xFilial("SA2") + LimpaCpf(aItens[xx,1])))
			lErro := .T.
			aadd(aErros,{" CPF não cadastrado : " + aItens[xx,1] + ' - ' + aItens[xx,3]  +  CRLF } )
		EndIF
		cNumTit := alltrim(cTipo )+ right(Str(year(dDtvenc),4),2) + alltrim(strZero(month(dDtvenc),2)) + alltrim(strzero(day(dDtvenc),2))
		SE2->(DbSetOrder(1))
    	if ! lErro .and. SE2->( DbSeek(xFilial("SE2") + "FOL" + cNumTit + '  ' + cTipo + SA2->A2_COD + SA2->A2_LOJA ))
    		IF SE2->E2_TIPO == cTipo .AND. SE2->E2_PREFIXO == 'FOL' .AND. SE2->E2_VENCTO == dDtVenc .AND. SE2->E2_FORNECE = SA2->A2_COD
    			lErro := .T.
    			aadd(aErros,{" Título já cadastrado para o CPF: " + aItens[xx,1] + ' - ' + aItens[xx,3] +  CRLF } )
    		EndIF 
		EndIF
		
		If  VAL(STRTRAN(aItens[xx,2],",",".")) <= 0
			lErro := .T.
    		aadd(aErros,{" Valor do título zerado para o CPF: " + aItens[xx,1] + ' - ' + aItens[xx,3]  +  CRLF } )
		EndIF
		SA2->(DbSetOrder(1))          
		SE2->(DbSetOrder(1))                                                                                   
		If !lErro
			//cNumTit := alltrim(cTipo )+ right(Str(year(dDtvenc),4),2) + alltrim(strZero(month(dDtvenc),2)) + alltrim(strzero(day(dDtvenc),2))
			//cNumTit := Replicate ("0",TamSX3("E2_NUM")[01] - len(cNumTit))+ cNumTit  
			aAdd(aAuto,{"E2_PREFIXO" , "FOL"              			,Nil})
			aAdd(aAuto,{"E2_NUM"     , cNumTit					  	,Nil}) 
			aAdd(aAuto,{"E2_PARCELA" , ''							,Nil})
			aAdd(aAuto,{"E2_HIST"    , cHistor                 		,Nil})
			aAdd(aAuto,{"E2_TIPO"    , cTipo        				,Nil})
			aAdd(aAuto,{"E2_NATUREZ" , cNatureza		 			,Nil})	
			aAdd(aAuto,{"E2_NOMFOR"  , SA2->A2_NREDUZ	 			,Nil})	
			aAdd(aAuto,{"E2_FORNECE" , SA2->A2_COD		 			,Nil})		
			aAdd(aAuto,{"E2_LOJA"    , SA2->A2_LOJA		 			,Nil})		
			aAdd(aAuto,{"E2_EMISSAO" , dDatabase					,Nil})				
			aAdd(aAuto,{"E2_VENCTO"  , dDtVenc						,Nil})				
			aAdd(aAuto,{"E2_VENCREA" , DataValida(dDtVenc,.T.)	    ,Nil})				
			aAdd(aAuto,{"E2_VALOR"   , VAL(STRTRAN(aItens[xx,2],',','.'))		    ,Nil})
			aAdd(aAuto,{"E2_PORTADO" , SA2->A2_BANCO  			    ,Nil})
			aAdd(aAuto,{"E2_FORBCO"  , SA2->A2_BANCO			    ,Nil})
			aAdd(aAuto,{"E2_FORAGE"  , SA2->A2_AGENCIA			    ,Nil})
			aAdd(aAuto,{"E2_FORCTA"  , SA2->A2_NUMCON			    ,Nil})		
							
			MSExecAuto({|zz,yy| Fina050(zz,yy)},aAuto,3) //Inclusao
			
			If lMsErroAuto
				AutoGrLog("Inclusão do Título a pagar do CPF : " + SA2->A2_CGC )  
				AutoGrLog("")
				AutoGrLog(Replicate("-", 20))
				lErro := .t.
				aLog := GetAutoGRLog()                                             
				nLog := Len(aLog)
				For nx:= 1 to nLog
					aadd(aErros,{aLog[nx] +  CRLF } ) 					
				Next
			Else
				//ConfirmSX8()
				nIncGra++
			EndIf
        EndIF
    Next	 
	If Len(aErros) <= 0 
		MSGSTOP("Processo de importacao de titulos finalizado sem erros ")
		FClose(nHandle)      
	Else  
		nMax := Len(aErros)                          
		nSalvo := FWrite( nHandle, "Total de Titulos lidos " + STR(NLIDOS) + CRLF )    
		If nSalvo <=0
    		MsgStop('Erro de gravação do arquivo de log, FERROR '+str(ferror(),4))
  		EndIF 
		nSalvo := FWrite( nHandle, "Titulos incluidos      " + STR(nIncGra) + CRLF ) 
		nSalvo := FWrite( nHandle, "Erros encontrados :" +  CRLF ) 
		
	 	For xx:= 1 to nMax                        
	 		nSalvo := FWrite( nHandle, aErros[xx,1]  + CRLF )
	 	Next              
	 	FClose(nHandle)     
		CpyS2T( cDirDocs+"\"+cArquivo+".txt" , cPath, .T. )  
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' )
			Return
		EndIf
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".txt" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Endif

return

Static Function LimpaCPF(cCPF)
cCPF := StrTran(cCpf,".")
cCPF := StrTran(cCpf,"/")
cCPF := StrTran(cCpf,"-")
cCPF := Alltrim(cCpf)
Return cCPF		
