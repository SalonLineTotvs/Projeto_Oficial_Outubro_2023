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
//|Este progama gera uma Planilha em Excel com os Manifestos   |
//|da Salon Line do Call Center por NF Faturada x Manifesto    | 
//|conforme modelo de Eecel da Luana            | 
//|Especifico da Salon Line                                    | 
//|Tabelas ustilizadas :                                       |
//|SZ1 - Cadastro de Manifesto 							       |
//==============================================================
/*
========================================================================================|
|Fun‡…o    ³ FATR0018  ³ Autor ³ Eduardo Lourenco  ³ Data ³17/03/2021³±±    |
|=======================================================================================|
|           Relatorio em  Excel - MANIFESTOS  x Nota                                    |
|=======================================================================================|
|					Especifico Salon Line                                               |
========================================================================================|
*/
//=======================
User Function  FATR0018() 
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
cPerg := PADR("FATR0018",10)
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
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
cQueryC += " F2_FILIAL,Z1_NRMA,Z1_DTMA,Z1_HRMA,Z1_MOTMA,Z1_LOTACAO, "
cQueryC += " Z1_PLACA,Z1_PALLETS,Z1_VEICULO,F2_DOC, "
cQueryC += " F2_EMISSAO,D2_PEDIDO,A1_NOME,A4_NOME, "
cQueryC += " SUM(D2_QUANT) QTD, SUM(D2_TOTAL) VLR_MERC, F2_VOLUME1, F2_PLIQUI, F2_PBRUTO "
cQueryC += " FROM SF2020 SF2 "
cQueryC += " INNER JOIN SZ1020 SZ1 " 
cQueryC += " ON SZ1.D_E_L_E_T_=''  AND Z1_FILIAL=F2_FILIAL AND Z1_NRMA=F2_X_NRMA " 
cQueryC += " INNER JOIN SD2020 SD2 "
cQueryC += " ON SD2.D_E_L_E_T_=''  AND D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE "
cQueryC += " INNER JOIN SA1020 SA1 "
cQueryC += " ON SA1.D_E_L_E_T_=''  AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA "
cQueryC += " INNER JOIN SA4020 SA4 "
cQueryC += " ON SA4.D_E_L_E_T_=''  AND A4_COD=F2_TRANSP "
cQueryC += " WHERE F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+ "' "
cQueryC += " AND  SF2.D_E_L_E_T_ = '' AND F2_TIPO  = 'N' 
cQueryC += " GROUP BY F2_FILIAL,Z1_NRMA,Z1_DTMA,Z1_HRMA,Z1_MOTMA,Z1_LOTACAO,"
cQueryC += " Z1_PLACA,Z1_PALLETS,Z1_VEICULO,F2_DOC," 
cQueryC += " F2_EMISSAO,D2_PEDIDO,A1_NOME,A4_NOME,F2_VOLUME1,F2_PLIQUI,F2_PBRUTO"
cQueryC += " ORDER BY F2_FILIAL,Z1_NRMA,Z1_DTMA "
//
If Sele("TSQLM") <> 0
	TSQLM->(DbCloseArea())
Endif
//
TCQUERY cQueryC NEW ALIAS "TSQLM"
TcSetField("TSQLM","F2_FILIAL"	,"C",04,0)
TcSetField("TSQLM","F2_DOC" 	,"C",09,0)
TcSetField("TSQLM","Z1_NRMA"	,"C",06,0)
TcSetField("TSQLM","F2_EMISSAO"	,"D",08,0)            
TcSetField("TSQLM","Z1_DTMA"	,"D",08,0)
TcSetField("TSQLM","Z1_HRMA"	,"C",05,0)
TcSetField("TSQLM","Z1_MOTMA"	,"C",60,0)
TcSetField("TSQLM","Z1_PLACA"	,"C",07,0)
TcSetField("TSQLM","Z1_LOTACAO"	,"C",01,0)
TcSetField("TSQLM","Z1_PALLETS"	,"N",2,0)
TcSetField("TSQLM","Z1_VEICULO"	,"C",01,0)
TcSetField("TSQLM","A1_NOME"	,"C",60,0)
TcSetField("TSQLM","A4_NOME"	,"C",60,0)
TcSetField("TSQLM","D2_PEDIDO"	,"C",06,0)
TcSetField("TSQLM","QTD"		,"N",14,2)
TcSetField("TSQLM","VLR_MERC"	,"N",14,2)
TcSetField("TSQLM","F2_VOLUME1"	,"N",6,0)
TcSetField("TSQLM","F2_PLIQUI"	,"N",11,4)
TcSetField("TSQLM","F2_PBRUTO"	,"N",11,4)
//           
nRegs := 0
TSQLM->(DbEval({|x| nRegs++}))
ProcRegua(nRegs)
//										                
TSQLM->(dbGotop())
IF !TSQLM->(eof())
	oExcel:AddworkSheet("Manifestos")
	//                                                                        
	cNomAba := "Manifestos"
	cNomTit := "Manifestos"
	//
	oExcel:AddTable(cNomAba,cNomTit)
	oExcel:AddColumn(cNomAba		,cNomTit	,"FILIAL"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NR MANIFESTO"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"DT MANIFESTO"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"HR MANIFESTO"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"MOTORISTA"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"LOTACAO" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"PLACA" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"PALLETS" 			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"VEICULO"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"PEDIDO"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOTA"				,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"DT NOTA"			,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"CLIENTE"			,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"TRANSPORTADORA"	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"QUANTIDADE"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"VLR MERCADORIA"	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"VOLUME"      		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"PESO LIQUIDO"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"PESO BRUTO"  		,1		,1		,.F.	)
	//
	Do While TSQLM->(!Eof())
		//
		IncProc("Processando Dados ...")
	    //
		xEmp	:=	" "
		//
		If	TSQLM->F2_FILIAL == "0101" 
			xEmp	:=	"CIMEX"
		ELSEIF TSQLM->F2_FILIAL == "0201"
			xEmp	:=	"CROZE"
		ELSEIF TSQLM->F2_FILIAL == "0301"
			xEmp	:=	"KOPEK"
		ELSEIF TSQLM->F2_FILIAL == "0401"
			xEmp	:=	"MACOK"
		ELSEIF TSQLM->F2_FILIAL == "0501"
			xEmp	:=	"QUBIT"
		ELSEIF TSQLM->F2_FILIAL == "0601"
			xEmp	:=	"ROJA"
		ELSEIF TSQLM->F2_FILIAL == "0701"
			xEmp	:=	"VIXEN"
		ELSEIF TSQLM->F2_FILIAL == "0801"
			xEmp	:=	"MAIZE"
		ELSEIF TSQLM->F2_FILIAL == "0901"
			xEmp	:=	"DEVINTEX FILIAL"
		ELSEIF TSQLM->F2_FILIAL == "0902"
			xEmp	:=	"DEVINTEX MG"
		ELSEIF TSQLM->F2_FILIAL == "1001"
			xEmp	:=	"GLAZY"
		ELSEIF TSQLM->F2_FILIAL == "1101"
			xEmp	:=	"BIZEZ"
		ELSEIF TSQLM->F2_FILIAL == "1201"
			xEmp	:=	"ZAKAT"
		ELSEIF TSQLM->F2_FILIAL == "1301"
			xEmp	:=	"HEXIL"
		ENDIF 	
		//
		xVeiculo	:= " "
		If	Z1_VEICULO == "A"
			xVeiculo	:= "VAN"
		Elseif Z1_VEICULO == "B"
			xVeiculo	:= "VUC"
		Elseif Z1_VEICULO == "C"	
			xVeiculo	:= "3/4"
		Elseif Z1_VEICULO == "D"
			xVeiculo	:= "TOCO"
		Elseif Z1_VEICULO == "E"
			xVeiculo	:= "TRUCK"
		Elseif Z1_VEICULO == "F"
			xVeiculo	:= "CARRETA"
		Elseif Z1_VEICULO == "G"
			xVeiculo	:= "BITREM"
		Elseif Z1_VEICULO == "H"
			xVeiculo	:= "RODOTREM"
		Elseif Z1_VEICULO == "I"
			xVeiculo	:= "AEREO"
		Endif	
		//
		oExcel:AddRow(cNomAba,cNomTit,{xEmp,TSQLM->Z1_NRMA,TSQLM->Z1_DTMA,;
		TSQLM->Z1_HRMA,TSQLM->Z1_MOTMA,TSQLM->Z1_LOTACAO,TSQLM->Z1_PLACA,;
		TSQLM->Z1_PALLETS,xVeiculo,TSQLM->D2_PEDIDO,TSQLM->F2_DOC,;
		TSQLM->F2_EMISSAO,TSQLM->A1_NOME,TSQLM->A4_NOME,;
		TSQLM->QTD,TSQLM->VLR_MERC,TSQLM->F2_VOLUME1,TSQLM->F2_PLIQUI,TSQLM->F2_PBRUTO})
		//							 	   
		TSQLM->(DbSkip())
		//
	Enddo     
    //
	cArquivo := "OCORRENCIA.XML"                 
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
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
