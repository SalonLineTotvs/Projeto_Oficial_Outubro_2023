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

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥Programa  ≥ RCTBR002 ≥  Autor ≥Andre Salgado/Introde        a≥ Data ≥ 18/10/2022 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒ¡ƒ¡ƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ 		  																≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥             Relatorio de IntegraÁ„o Compras x Contabilidade               		≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function RCTBR002()
Local aParam1  	 := {}
Private dt_start := SPACE(8)
Private dt_end   := SPACE(8)
Private _cFilDe  := SPACE(4)
Private _cFilAte := "ZZZZ"
Private aRet     := {}

//Parametro de Filtro com Usuario
aAdd(aParam1,{1,"Data de "	 ,Ctod(dt_start),"","","","",50,.F.}) // Tipo data
aAdd(aParam1,{1,"Data atÈ "	 ,Ctod(dt_end)	,"","","","",50,.F.}) // Tipo data
aAdd(aParam1,{1,"Filial de " ,_cFilDe 		,"","","SM0","",50,.F.}) // Filial De
aAdd(aParam1,{1,"Filial atÈ ",_cFilAte		,"","","SM0","",50,.F.}) // Filial Ate


If ParamBox( 	aParam1, "Par‚metro",aRet,,,,,,,,.F.,.T.)  
	dt_start:= aRet[1]   
	dt_end	:= aRet[2]
	_cFilDe := aRet[3]
	_cFilAte:= aRet[4]
EndIf
	   	

If MsgYesNo("Confirma a geraÁ„o do Relatorio ?","ATEN«√O","YESNO")
	RptStatus( {|lEnd| doThing()}, "Aguarde...","Gerando o Relatorio", .T. )
Endif

return



//Gera Relatorio
Static Function doThing()
		
Local oExcel	:= FWMSEXCEL():New()
Local cNomAba, cNomTit


		cQueryC := " SELECT * FROM (" + chr(13)
		cQueryC += " SELECT LEFT(X5_DESCRI,10)  FILIAL,'Mod.Compras' TIPOLANC,F1_DOC NOTA, F1_SERIE SERIE, F1_FORNECE+F1_LOJA CODREM, F1_EMISSAO DT_EMIS, F1_DTDIGIT DT_DIGIT," + chr(13)
		cQueryC += " round(F1_VALBRUT,2) VLR_BRUTO, round(ISNULL(F3_VALICM,0),2) ICMS, F3_CFO CFOP," + chr(13)
		cQueryC += " CASE WHEN F1_TIPO IN('D','B') THEN 'NF DEVOLUCAO' ELSE 'NF ENTRADA' END TIPON, ISNULL(A2_NOME, A1_NOME) R_SOCIAL," + chr(13)
		cQueryC += " CASE WHEN F1_DTLANC<>' ' THEN 'CONTABILIZADO' ELSE 'NAO CONTABILIZADO' END STATUSX" + chr(13)
		cQueryC += " ,F1_ESPECIE TIPO, '' HISTOR, '' BANCO, '' PARCELA," + chr(13)
		//cQueryC += " ,CASE WHEN F1_DTLANC<>' ' THEN ' ' ELSE 'Gerar a Rotina integracao' END MOTIVO"
		cQueryC += " CASE WHEN ISNULL(E2_NUM,'')='' THEN '' " + chr(13)
		cQueryC += " 	  WHEN ISNULL(ED_CONTA,'')='' THEN 'NATUREZA SEM CONTA CONTABIL' ELSE " + chr(13)
		cQueryC += " 	  CASE WHEN F1_DTLANC<>' ' THEN ' ' ELSE 'Gerar a Rotina integracao' END  END MOTIVO" + chr(13)

		cQueryC += " FROM SF1020 SF1 (NOLOCK)" + chr(13)
		cQueryC += " LEFT JOIN SX5020 SX5 ON SX5.D_E_L_E_T_=' ' AND X5_TABELA='ZE' AND X5_FILIAL='0101' AND F1_FILIAL=LEFT(X5_CHAVE,4)" + chr(13)
		cQueryC += " LEFT JOIN SF3020 SF3 (NOLOCK) ON F1_FILIAL=F3_FILIAL " + chr(13)
		cQueryC += " AND F1_DOC=F3_NFISCAL AND F1_SERIE=F3_SERIE AND F1_FORNECE=F3_CLIEFOR AND F1_LOJA=F3_LOJA AND SF3.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " LEFT JOIN SA2020 SA2 (NOLOCK) ON F1_FORNECE=A2_COD AND F1_LOJA=A2_LOJA AND F1_TIPO NOT IN('D','B') AND SA2.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " LEFT JOIN SA1020 SA1 (NOLOCK) ON F1_FORNECE=A1_COD AND F1_LOJA=A1_LOJA AND F1_TIPO IN('D','B') AND SA1.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " LEFT JOIN SE2020 SE2 ON F1_FILIAL=E2_FILIAL AND F1_SERIE=E2_PREFIXO AND F1_DOC=E2_NUM AND " + chr(13)
		cQueryC += " 			F1_FORNECE=E2_FORNECE AND F1_LOJA=E2_LOJA AND SE2.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " LEFT JOIN SED020 SED ON E2_NATUREZ=ED_CODIGO AND SED.D_E_L_E_T_=' ' " + chr(13)

		cQueryC += " WHERE " + chr(13)
		cQueryC += " SF1.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " AND F1_DTDIGIT between  '"+DTOS(dt_start)+"' and '"+DTOS(dt_end)+"' " + chr(13)
		cQueryC += " AND F1_FILIAL  between  '"+_cFilDe+"' and '"+_cFilAte+"' " + chr(13)
//		cQueryC += " AND F1_DTLANC= ' ' "

		cQueryC += " UNION ALL" + chr(13)
		cQueryC += " SELECT LEFT(X5_DESCRI,10)  FILIAL,'Mod.Faturamento' TIPOLANC, F2_DOC NOTA, F2_SERIE SERIE, F2_CLIENTE+F2_LOJA CODREM, F2_EMISSAO DT_EMIS, F2_EMISSAO DT_DIGIT," + chr(13)
		cQueryC += " round(F2_VALBRUT,2) VLR_BRUTO, round(ISNULL(F3_VALICM,0),2) ICMS, F3_CFO CFOP," + chr(13)
		cQueryC += " CASE WHEN F2_TIPO IN('D','B') THEN 'NF DEVOLUCAO' ELSE 'NF SAIDA' END TIPON, ISNULL(A2_NOME, A1_NOME) R_SOCIAL," + chr(13)
		cQueryC += " CASE WHEN F2_DTLANC<>' ' THEN 'CONTABILIZADO' ELSE 'NAO CONTABILIZADO' END STATUSX" + chr(13)
		cQueryC += " ,F2_ESPECIE TIPO, '' HISTOR, '' BANCO, '' PARCELA" + chr(13)
		cQueryC += " ,CASE WHEN F2_DTLANC<>' ' THEN ' ' ELSE 'Gerar a Rotina integracao' END MOTIVO" + chr(13)
		cQueryC += " FROM SF2020 SF2 (NOLOCK)" + chr(13)
		cQueryC += " LEFT JOIN SX5020 SX5 ON SX5.D_E_L_E_T_=' ' AND X5_TABELA='ZE' AND X5_FILIAL='0101' AND F2_FILIAL=LEFT(X5_CHAVE,4)" + chr(13)
		cQueryC += " LEFT JOIN SF3020 SF3 (NOLOCK) ON F2_FILIAL=F3_FILIAL " + chr(13)
		cQueryC += " AND F2_DOC=F3_NFISCAL AND F2_SERIE=F3_SERIE AND F2_CLIENTE=F3_CLIEFOR AND F2_LOJA=F3_LOJA AND SF3.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " LEFT JOIN SA2020 SA2 (NOLOCK) ON F2_CLIENTE=A2_COD AND F2_LOJA=A2_LOJA AND F2_TIPO IN('D','B') AND SA2.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " LEFT JOIN SA1020 SA1 (NOLOCK) ON F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND F2_TIPO NOT IN('D','B') AND SA1.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " WHERE " + chr(13)
		cQueryC += " SF2.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " AND F2_EMISSAO between  '"+DTOS(dt_start)+"' and '"+DTOS(dt_end)+"' " + chr(13)
		cQueryC += " AND F2_FILIAL  between  '"+_cFilDe+"' and '"+_cFilAte+"' " + chr(13)
//		cQueryC += " AND F2_DTLANC= ' ' "

		cQueryC += " UNION ALL"
		cQueryC += " SELECT LEFT(X5_DESCRI,10)  FILIAL, 'Mod.Financeiro' TIPOLANC, E5_NUMERO NOTA, E5_PREFIXO SERIE,  E5_CLIFOR+E5_LOJA CODREM, E5_DATA DT_EMIS, E5_DATA DT_DIGIT," + chr(13)
		cQueryC += " round(E5_VALOR,2) VLR_BRUTO, 0 ICMS, '' CFOP," + chr(13)
		cQueryC += " E5_RECPAG TIPON, E5_BENEF R_SOCIAL," + chr(13)
		cQueryC += " CASE WHEN E5_LA<>' ' or E5_TIPO='PA' THEN 'CONTABILIZADO' ELSE 'NAO CONTABILIZADO' END STATUSX" + chr(13)
		cQueryC += " ,E5_TIPO TIPO, E5_HISTOR, E5_BANCO BANCO, E5_PARCELA PARCELA" + chr(13)
		cQueryC += " ,CASE WHEN E5_LA<>' ' or E5_TIPO='PA' THEN ' ' ELSE 'Natureza ok, Banco ok, Gerar a Rotina integracao' END MOTIVO" + chr(13)
		cQueryC += " FROM SE5020 SE5 (NOLOCK)" + chr(13)
		cQueryC += " LEFT JOIN SX5020 SX5 ON SX5.D_E_L_E_T_=' ' AND X5_TABELA='ZE' AND X5_FILIAL='0101' AND E5_FILIAL=LEFT(X5_CHAVE,4)" + chr(13)
		cQueryC += " WHERE " + chr(13)
		cQueryC += " SE5.D_E_L_E_T_=' ' " + chr(13)
		cQueryC += " AND E5_DATA between  '"+DTOS(dt_start)+"' and '"+DTOS(dt_end)+"' " + chr(13)
		cQueryC += " AND E5_SITUACA=' ' " + chr(13)
		//cQueryC += " AND E5_LOTE NOT IN ('8851','8852')"
		cQueryC += " AND E5_TIPODOC NOT IN ('DC','JR','ML')" + chr(13)
		cQueryC += " AND E5_TIPO<>'PA' " + chr(13)
		cQueryC += " AND E5_FILIAL  between  '"+_cFilDe+"' and '"+_cFilAte+"' " + chr(13)
		cQueryC += " )A WHERE MOTIVO<>' ' " + chr(13)

		cQueryC += " ORDER BY 1,2,7,3"


		If Select("RCT002") <> 0
			RCT002->(DbCloseArea())
		Endif

		TCQUERY cQueryC NEW ALIAS "RCT002" 

		TcSetField("RCT002","FILIAL"	,"C",55,0)
		TcSetField("RCT002","TIPOLANC"	,"C",55,0)
		TcSetField("RCT002","NOTA"		,"C",55,0)
		TcSetField("RCT002","SERIE"		,"C",55,0)
		TcSetField("RCT002","CODREM"	,"C",55,0)
		TcSetField("RCT002","DT_EMIS"	,"D",08,0)
		TcSetField("RCT002","DT_DIGIT"	,"D",08,0)
		TcSetField("RCT002","VLR_BRUTO"	,"N",16,2)
		//TcSetField("RCT002","ICMS"	,"N",16,2)
//		TcSetField("RCT002","CFOP"	,"N",16,2)
		TcSetField("RCT002","R_SOCIAL"	,"C",55,0)
//		TcSetField("RCT002","STATUSX"	,"C",55,0)
		TcSetField("RCT002","ORIGEM"	,"C",55,0)
		TcSetField("RCT002","TIPO"		,"C",55,0)
		TcSetField("RCT002","HISTOR"	,"C",55,0)
		TcSetField("RCT002","BANCO"		,"C",55,0)
		TcSetField("RCT002","PARCELA"	,"C",55,0)
		TcSetField("RCT002","MOTIVO"	,"C",55,0)

		nRegs := 0
		RCT002->(DbEval({|x| nRegs++}))
		ProcRegua(nRegs)
				
		RCT002->(dbGotop())
		IF !RCT002->(eof())
			oExcel:AddworkSheet("IntegraÁ„o Compras x Contabilidade")

			cNomAba := "IntegraÁ„o Compras x Contabilidade"
			cNomTit := "IntegraÁ„o Compras x Contabilidade"

			oExcel:AddTable(cNomAba,cNomTit)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Filial"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Tipo de Lancamento" ,1	,1	,.F.)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Nota"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Serie"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Codigo"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Data de Emissao" ,1		,1	,.F.)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Data de DigitaÁ„o",1		,1	,.F.)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Valor Bruto" ,1	,1		,.F.	)
//			oExcel:AddColumn(cNomAba		,cNomTit	, "ICMS" 	,1		,1		,.F.	)
//			oExcel:AddColumn(cNomAba		,cNomTit	, "CFOP" 	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Raz„o Social",1	,1		,.F.	)
//			oExcel:AddColumn(cNomAba		,cNomTit	, "Status"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Origem"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Tipo"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Historico",1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Banco"	,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Parcela" ,1		,1		,.F.	)
			oExcel:AddColumn(cNomAba		,cNomTit	, "Motivo"	,1		,1		,.F.	)

			Do While RCT002->(!Eof())

				IncProc("Processando Dados ...")

//				oExcel:AddRow(cNomAba,cNomTit,{RCT002->FILIAL,RCT002->TIPOLANC, RCT002->NOTA, RCT002->SERIE, RCT002->CODREM, DTOC(RCT002->DT_EMIS),DTOC(RCT002->DT_DIGIT),;
//				RCT002->VLR_BRUTO, RCT002->ICMS, RCT002->CFOP, RCT002->R_SOCIAL, RCT002->STATUSX, RCT002->TIPO, RCT002->HISTOR, RCT002->BANCO, RCT002->PARCELA})
				oExcel:AddRow(cNomAba,cNomTit,{RCT002->FILIAL,RCT002->TIPOLANC, RCT002->NOTA, RCT002->SERIE,;
				RCT002->CODREM, DTOC(RCT002->DT_EMIS),DTOC(RCT002->DT_DIGIT),RCT002->VLR_BRUTO, RCT002->R_SOCIAL,;
				RCT002->TIPON,RCT002->TIPO, RCT002->HISTOR, RCT002->BANCO, RCT002->PARCELA,;
				RCT002->MOTIVO})

				RCT002->(DbSkip())

			Enddo

		endif


		cArquivo := "Relatorio.XML"
		If	!Empty(oExcel:aWorkSheet)
			
			MakeDir( "C:\Temp\" )
			oExcel:Activate()
			oExcel:GetXMLFile("C:\Temp\"+cArquivo)
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open("C:\Temp\"+cArquivo) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
			
			MsgInfo("Finalizado! Criado arquivo C:\Temp\"+cArquivo , "Concluido !")
			
		Else
		
			Alert("N„o h· dados para geraÁ„o da planilha!")
	
		EndIf

Return()
