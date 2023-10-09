#include "APWIZARD.CH"
#include "PROTHEUS.CH"
#include "FILEIO.CH"
#include "AP5MAIL.CH"
#include "topconn.ch"
#Include "Rwmake.ch"  
#INCLUDE "TOPCONN.CH"      
#Include "Avprint.ch"
#Include "Font.ch"
#INCLUDE "TOPCONN.CH"       
//==============================================================
//|Este progama gera uma Planilha em Excel com as Notas Fiscais|
//|de Venda de acorodo com os parametros do usuario            | 
//|que sofreram maniesto com transportador                     | 
//|Especifico da Salon Line                                    | 
//|Tabelas ustilizadas :                                       |
//|SF2 - Cabeçalho Nota Fiscal de Saida                        |
//|SZ1 - Tabela Personalizada Manisfesto                       |  
//|SA1 - Cadastro de Clientes                                  |
//|SA4 - Cadastro de Transportadoras                           |
//==============================================================
/*
============================================================================
|Fun‡…o    ³ SLNFMAN  ³ Autor ³ Eduardo Lourenco  ³ Data ³16/10/2020³±±    |
|===========================================================================
|±±³Descri‡…o ³ Relatorio em  Excel - Notas Fiscais de Venda X Manifesto   |
|===========================================================================
|±±³Uso       ³ Especifico Salon Line                                      |
============================================================================
*/
//=======================
User Function  FATR0014() 
//=======================
//
Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())
Local nRegSM0   := SM0->(RECNO())
//
If !ApOleClient('MsExcel')
	//
	Alert("Atenção! MsExcel nao instalado!")
	//
	Return
EndIf
//
cPerg := PADR("FATR0014",10)
GeraPerg()
//
Pergunte(cPerg,.T.)
//
Processa({|| fSelDados()} , "Selecionando Dados") 
//
//SM0->(dbGoto(nRegSM0))
//
RETURN NIL   
//
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fSelDados 					                              ³±±
±±³          ³ Captura dados principais	    	                          |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/      
//ßßßßßßßßßßßßßßßßßßßßßßßß
Static Function fSelDados()
//ßßßßßßßßßßßßßßßßßßßßßßßß
//
LOCAL oExcel	:= FWMSEXCEL():New()
LOCAL cQueryC	:= ''
//                                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona Dados - Clientes   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEOL := CHR(13)+CHR(10)                                                            
//    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿   
//³                Query NF X Manifesto           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
cQueryC := " SELECT "
cQueryC += " F2_FILIAL,F2_DOC,F2_SERIE,F2_TIPO,F2_EMISSAO,F2_CLIENTE,F2_LOJA, "
cQueryC += " A1_NOME,F2_X_NRMA,Z1_DTMA,Z1_HRMA,F2_TRANSP,A4_NOME "
cQueryC += " FROM SF2020 SF2 "
cQueryC += " INNER JOIN SZ1020 SZ1 " 
cQueryC += " ON SZ1.D_E_L_E_T_=''  AND Z1_FILIAL=F2_FILIAL AND Z1_NRMA=F2_X_NRMA " 
cQueryC += " INNER JOIN SA1020 SA1 "
cQueryC += " ON SA1.D_E_L_E_T_=''  AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA "
cQueryC += " INNER JOIN SA4020 SA4 "
cQueryC += " ON SA4.D_E_L_E_T_=''  AND A4_COD=F2_TRANSP "
cQueryC += " WHERE F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+ "' "
cQueryC += " AND  SF2.D_E_L_E_T_ = '' AND F2_TIPO  = 'N' AND  F2_X_NRMA <> ''
cQueryC += " ORDER BY F2_FILIAL, F2_DOC,F2_SERIE "
//
If Sele("TSQLC") <> 0
	TSQLC->(DbCloseArea())
Endif
//
TCQUERY cQueryC NEW ALIAS "TSQLC"
TcSetField("TSQLC","F2_FILIAL"	,"C",04,0)
TcSetField("TSQLC","F2_DOC" 	,"C",09,0)
TcSetField("TSQLC","F2_SERIE"	,"C",03,0)
TcSetField("TSQLC","F2_TIPO"	,"C",01,0)
TcSetField("TSQLC","F2_EMISSAO"	,"D",08,0)            
TcSetField("TSQLC","F2_CLIENTE"	,"C",06,0)
TcSetField("TSQLC","F2_LOJA"	,"C",02,0)
TcSetField("TSQLC","A1_NOME"	,"C",60,0)
TcSetField("TSQLC","F2_X_NRMA"	,"C",06,0)
TcSetField("TSQLC","Z1_DTMA"	,"D",08,0)
TcSetField("TSQLC","Z1_HRMA"	,"C",05,0)
TcSetField("TSQLC","F2_TRANSP"	,"C",06,0)
TcSetField("TSQLC","A4_NOME"	,"C",60,0)
//           
nRegs := 0
TSQLC->(DbEval({|x| nRegs++}))
ProcRegua(nRegs)
//										                
TSQLC->(dbGotop())
IF !TSQLC->(eof())
	oExcel:AddworkSheet("Notas Fiscais x Manifesto")
	//                                                                        
	cNomAba := "Notas Fiscais x Manifesto"
	cNomTit := "NF x Manifesto"
	oExcel:AddTable(cNomAba,cNomTit)
	oExcel:AddColumn(cNomAba		,cNomTit	,"FILIAL"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOME"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOTA FISCAL"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"SERIE"			,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"TIPO" 			,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"EMISSAO"			,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"CLIENTE" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"LOJA" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOME" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"MANIFESTO"		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"DT EMIS"       	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"HORA" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"COD TRANSP."  	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"TRANSPORTADORA"	,1		,1		,.F.	)
    Do While TSQLC->(!Eof())
		//
		IncProc("Processando Dados ...")
	    //
		xEmp	:=	" "
		//
		If	TSQLC->F2_FILIAL == "0101" 
			xEmp	:=	"CIMEX"
		ELSEIF TSQLC->F2_FILIAL == "0201"
			xEmp	:=	"CROZE"
		ELSEIF TSQLC->F2_FILIAL == "0301"
			xEmp	:=	"KOPEK"
		ELSEIF TSQLC->F2_FILIAL == "0401"
			xEmp	:=	"MACOK"
		ELSEIF TSQLC->F2_FILIAL == "0501"
			xEmp	:=	"QUBIT"
		ELSEIF TSQLC->F2_FILIAL == "0601"
			xEmp	:=	"ROJA"
		ELSEIF TSQLC->F2_FILIAL == "0701"
			xEmp	:=	"VIXEN"
		ELSEIF TSQLC->F2_FILIAL == "0801"
			xEmp	:=	"MAIZE"
		ELSEIF TSQLC->F2_FILIAL == "0901"
			xEmp	:=	"DEVINTEX FILIAL"
		ELSEIF TSQLC->F2_FILIAL == "0902"
			xEmp	:=	"DEVINTEX MG"
		ELSEIF TSQLC->F2_FILIAL == "1001"
			xEmp	:=	"GLAZY"
		ELSEIF TSQLC->F2_FILIAL == "1101"
			xEmp	:=	"BIZEZ"
		ELSEIF TSQLC->F2_FILIAL == "1201"
			xEmp	:=	"ZAKAT"
		ELSEIF TSQLC->F2_FILIAL == "1301"
			xEmp	:=	"HEXIL"
		ENDIF 	
		//
		oExcel:AddRow(cNomAba,cNomTit,{TSQLC->F2_FILIAL,xEmp,TSQLC->F2_DOC,TSQLC->F2_SERIE,TSQLC->F2_TIPO,;
		TSQLC->F2_EMISSAO,TSQLC->F2_CLIENTE,TSQLC->F2_LOJA,TSQLC->A1_NOME,TSQLC->F2_X_NRMA,;
		TSQLC->Z1_DTMA,TSQLC->Z1_HRMA,TSQLC->F2_TRANSP,TSQLC->A4_NOME})
		//							 	   
		TSQLC->(DbSkip())
		//
	Enddo     
    //
	cArquivo := "MANIFESTO.XML"                 
	If	!Empty(oExcel:aWorkSheet)
		//
		oExcel:Activate()
		oExcel:GetXMLFile("C:\ReportProtheus\"+cArquivo)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open("C:\ReportProtheus\"+cArquivo) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		//MSGINFO("Finalizado! Criado arquivo C:\ReportProtheus\"+cArquivo )
		Alert("Finalizado! Criado arquivo C:\ReportProtheus\"+cArquivo )
		//
	Else  
		//
		Alert("Não há dados para geração da planilha!") 
		//
	EndIf 
	//
Endif 
//
Return  
//
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GeraPerg					 	                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Potencial Florestal  Cria as Perguntas                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
//
//ßßßßßßßßßßßßßßßßßßßßßßßß
Static Function GeraPerg()
//ßßßßßßßßßßßßßßßßßßßßßßßß
//      
//
sAlias := Alias()
cPerg := PADR(cPerg,10)
aRegs :={}
//
DbSelectArea("SX1")               // Criar as Perguntas
SX1->(DbSetOrder(1))
//             01       02       03         04        05        06        07       08          09        10       11     12      13        14       15          16        17        18      19        20          21       22       23       24         25         26       27       28       29       30         31         32        33      34        35         36        37      38      39       40       41       42
//          X1_GRUPO,X1_ORDEM,X1_PERGUNT,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,X1_PRESEL,X1_GSC,X1_VALID,X1_VAR01,X1_DEF01,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG,X1_HELP,X1_PICTURE	 
Aadd(aRegs,{cPerg,"01","Dt. Emissão De  ","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Dt. Emissão Ate ","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"03","Rateio ?		   ","","","mv_ch3","C",01,0,0,"C","","Mv_Par03","Não","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","",""})
//
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 To FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next
//
dbSelectArea(sAlias)
//
Return()
