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
//|SF6 - Cabeçalho Nota Fiscal de Saida                        |
//|SA1 - Cadastro de Clientes                                  |
//|SA4 - Cadastro de Transportadoras                           |
//==============================================================
/*
============================================================================
|Fun‡…o    ³ FATR0016  ³ Autor ³ Eduardo Lourenco  ³ Data ³04/11/2020³±±    |
|===========================================================================
|±±³Descri‡…o ³ Relatorio em  Excel - Tabela SF6                           |
|===========================================================================
|±±³Uso       ³ Especifico Salon Line                                      |
============================================================================
*/
//=======================
User Function  FATR0016() 
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
cPerg := PADR("FATR0016",10)
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
LOCAL cQueryF	:= ''
//                                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona Dados - Clientes   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEOL := CHR(13)+CHR(10)                                                            
//    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿   
//³                Query guias                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
cQueryF := " SELECT "
cQueryF += " F6_FILIAL,F6_DOC,F6_SERIE,F6_CLIFOR,F6_LOJA, "
cQueryF += " A1_NOME,F6_CNPJ,F6_CODREC,F6_EST,F6_VALOR,F6_DTARREC,A4_NOME "
cQueryF += " FROM SF6020 SF6 "
cQueryF += " INNER JOIN SF2020 SF2 " 
cQueryF += " ON SF2.D_E_L_E_T_=''  AND F2_FILIAL=F6_FILIAL AND F2_DOC=F6_DOC AND F2_SERIE=F6_SERIE " 
cQueryF += " INNER JOIN SA1020 SA1 "
cQueryF += " ON SA1.D_E_L_E_T_=''  AND A1_COD=F6_CLIFOR AND A1_LOJA=F6_LOJA "
cQueryF += " INNER JOIN SA4020 SA4 "
cQueryF += " ON SA4.D_E_L_E_T_=''  AND A4_COD=F2_TRANSP "
cQueryF += " WHERE F6_DTARREC BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+ "' "
cQueryF += " AND F6_EST	BETWEEN	'"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQueryF += " AND F2_TRANSP BETWEEN	'"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQueryF += " AND  SF6.D_E_L_E_T_ = '' 
cQueryF += " ORDER BY F6_FILIAL, F6_DOC,F6_SERIE "
//
If Sele("TSQLF") <> 0
	TSQLF->(DbCloseArea())
Endif
//
TCQUERY cQueryF NEW ALIAS "TSQLF"
TcSetField("TSQLF","F6_FILIAL"	,"C",04,0)
TcSetField("TSQLF","F6_DOC" 	,"C",09,0)
TcSetField("TSQLF","F6_SERIE"	,"C",03,0)
TcSetField("TSQLF","F6_CLIFOR"	,"C",06,0)
TcSetField("TSQLF","F6_LOJA"	,"C",02,0)
TcSetField("TSQLF","A1_NOME"	,"C",60,0)
TcSetField("TSQLF","F6_CNPJ"	,"C",14,0)
TcSetField("TSQLF","F6_CODREC"	,"C",15,0)
TcSetField("TSQLF","F6_EST"		,"C",02,0)
TcSetField("TSQLF","F6_VALOR"	,"N",14,2)
TcSetField("TSQLF","F6_DTARREC"	,"D",08,0)
TcSetField("TSQLF","A4_NOME"	,"C",60,0)
//           
nRegs := 0
TSQLF->(DbEval({|x| nRegs++}))
ProcRegua(nRegs)
//										                
TSQLF->(dbGotop())
IF !TSQLF->(eof())
	oExcel:AddworkSheet("GUIAS ENVIO FINANCEIRO")
	//                                                                        
	cNomAba := "GUIAS ENVIO FINANCEIRO"
	cNomTit := "GUIAS SF6"
	oExcel:AddTable(cNomAba,cNomTit)
	oExcel:AddColumn(cNomAba		,cNomTit	,"DISTR"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"FILIAL"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOTA FISCAL"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"SERIE"			,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"CLI/FORNEC"		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"LOJA" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOME" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"CNPJ"				,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"COD. RECEITA"    	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"TIPO" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"UF"			  	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"VALOR" 		 	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"DATA"			  	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"TRANSP."			,1		,1		,.F.	)
    Do While TSQLF->(!Eof())
		//
		IncProc("Processando Dados ...")
	    //
		xEmp	:=	" "
		xTipo	:=	" " 
		//
		If	TSQLF->F6_FILIAL == "0101" 
			xEmp	:=	"CIMEX"
		ELSEIF TSQLF->F6_FILIAL == "0201"
			xEmp	:=	"CROZE"
		ELSEIF TSQLF->F6_FILIAL == "0301"
			xEmp	:=	"KOPEK"
		ELSEIF TSQLF->F6_FILIAL == "0401"
			xEmp	:=	"MACOK"
		ELSEIF TSQLF->F6_FILIAL == "0501"
			xEmp	:=	"QUBIT"
		ELSEIF TSQLF->F6_FILIAL == "0601"
			xEmp	:=	"ROJA"
		ELSEIF TSQLF->F6_FILIAL == "0701"
			xEmp	:=	"VIXEN"
		ELSEIF TSQLF->F6_FILIAL == "0801"
			xEmp	:=	"MAIZE"
		ELSEIF TSQLF->F6_FILIAL == "0901"
			xEmp	:=	"DEVINTEX FILIAL"
		ELSEIF TSQLF->F6_FILIAL == "0902"
			xEmp	:=	"DEVINTEX MG"
		ELSEIF TSQLF->F6_FILIAL == "1001"
			xEmp	:=	"GLAZY"
		ELSEIF TSQLF->F6_FILIAL == "1101"
			xEmp	:=	"BIZEZ"
		ELSEIF TSQLF->F6_FILIAL == "1201"
			xEmp	:=	"ZAKAT"
		ELSEIF TSQLF->F6_FILIAL == "1301"
			xEmp	:=	"HEXIL"
		ENDIF 	
		//
		If	Alltrim(TSQLF->F6_CODREC) == "100099"
			xTipo	:=	"ICMS ST"
		ELSEIF	Alltrim(TSQLF->F6_CODREC) == "100129"		
			xTipo	:=	"FCP"
		ELSEIF	Alltrim(TSQLF->F6_CODREC) == "100102"		
			xTipo	:=	"DIFAL"
		ENDIF 		
		//	
		oExcel:AddRow(cNomAba,cNomTit,{TSQLF->F6_FILIAL,xEmp,;
		TSQLF->F6_DOC,TSQLF->F6_SERIE,TSQLF->F6_CLIFOR,TSQLF->F6_LOJA,;
		TSQLF->A1_NOME,TSQLF->F6_CNPJ,TSQLF->F6_CODREC,xTipo,;
		TSQLF->F6_EST,TSQLF->F6_VALOR,TSQLF->F6_DTARREC,TSQLF->A4_NOME})
		//							 	   
		TSQLF->(DbSkip())
		//
	Enddo     
    //
	cArquivo := "GUIAS001.XML"                 
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
Aadd(aRegs,{cPerg,"01","Dt. Arrecadacao De  ","","","mv_ch1","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Dt. Arrecadacao Ate ","","","mv_ch2","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","UF De "     		 ,"","","mv_ch3","C",02,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","12","","","",""})
Aadd(aRegs,{cPerg,"04","UF Ate "     		 ,"","","mv_ch4","C",02,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","12","","","",""})
Aadd(aRegs,{cPerg,"05","Transp De"      	 ,"","","mv_ch5","C",06,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","",""})
Aadd(aRegs,{cPerg,"06","Transp Ate"      	 ,"","","mv_ch6","C",06,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","",""})
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
