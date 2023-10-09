//*****************************************************
// Programa - Relatorio em Excel dos Pedidos em Aberto
// Solicitação - Clovis / Claudia
// Autor - Rogerio/Andre / Introde - 27/08/2021
//*****************************************************
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function asal003()

Local _cMens	:= "Confirmar geração do Relatorio OCT - Analise dos Pedidos de Venda ?"
Local nSomaProc := 0
Private aRet	:= {Ctod("  /  /  "),Ctod("  /  /  ")}
Private cTitulo	:= "Relacao OCT"

If !ParamBox( {;
	{1,"Dt Emissao Pedido De ",aRet[1],"@!",,,"",70,.F.},;
	{1,"Dt Emissao Pedido Ate",aRet[2],"@!",,,"",70,.F.};
	},"Dados para Geração do Relatorio OCT", @aRet,,,,,,,,.T.,.T. )
	Return
End If


//Variaveis
_MV_PAR01:= DTOS(aRet[1])
_MV_PAR02:= DTOS(aRet[2])


//Processa ou não 
If MsgYesNo(_cMens,"ATENÇÃO","YESNO")
	Processa({|| GeraExcel()	, "Gerando Arquivo Excel ..."})
ENDIF

Return


//Processa o arquivo Excel
Static Function GeraExcel()

//Local nFormat		:= 1
Local oExcel
Local oFWMsExcel
Local aWorkSheet	:= {}
Local cWorkSheet	:= "Relatorio"
Local cTable		:= cWorkSheet
Local aColunas		:= {}
Local cHora		    := Time()
Local cFilePath		:= GetTempPath()+'Relatorio_' + DtoS(ddatabase) + '_' + SubStr(cHora,1,2) + SubStr(cHora,4,2) + '.xls'
Local aLinhaAux		:= {}
Private oExcel
Private aXMLCol		:= {}
Private aXMLRow		:= {}

aAdd(aWorkSheet,'Pedido_Aberto')

oFWMsExcel:= FWMSExcel():New()
oFWMsExcel:AddworkSheet( aWorkSheet[1] )    

oFWMsExcel:AddTable( aWorkSheet[1], aWorkSheet[1] )

oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "EMPRESA"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Pedido"		,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Tipo Cliente",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Codigo"		,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Loja"		,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Razao Social",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Fantasia"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "UF"			,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "CNPJ"		,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Pedido",2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Pedido",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Cred"	,2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Cred"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Dias"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Horas"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Liberac",2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Liberac",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Dias"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Horas"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Logist",2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Logist",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Dias"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Horas"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Fatura",2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Fatura",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Dias"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Horas"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Manifesto"	,2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Manifesto"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Dias"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dia Horas"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Entrega",2,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Hora Entrega",1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Dias"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dif Horas"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "NOTA"		,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "TRANSPORT"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "MENS_NOTA"	,1,1,.F.)

cquery1:= " SELECT "
cquery1+= " LEFT(X5_DESCRI,10) EMPRESA, C5_NUM PEDIDO,  "
cquery1+= " C5_TIPOCLI TP_CLIENTE, C5_CLIENTE COD_CLI, C5_LOJACLI LOJA, A1_NOME R_SOCIAL, A1_NREDUZ FANTASIA,  A1_EST UF, A1_CGC CNPJ_CPF, "
cquery1+= " C5_EMISSAO DT_PEDIDO, C5_X_HRINC HR_PEDIDO, "
cquery1+= " C5_DLBCRE DT_CRED, "
cquery1+= " C5_HLBCRE HR_CRED, "
cquery1+= " CASE WHEN C5_DLBCRE<>' ' THEN DATEDIFF(day, C5_EMISSAO+' '+C5_X_HRINC,C5_DLBCRE+' '+C5_HLBCRE) ELSE ' ' END  DDIF01, "
cquery1+= " CASE WHEN C5_DLBCRE<>' ' THEN ROUND(( DATEDIFF(second, C5_EMISSAO+' '+C5_X_HRINC+':00',C5_DLBCRE+' '+C5_HLBCRE+':00')*1.0)/3600,2) ELSE 0 END HDIF01, "
cquery1+= " ISNULL(Z4_DTEMISS,'') DTCOM,  "
cquery1+= " ISNULL(Z4_HORA,'')    HRCOM, "
cquery1+= " CASE WHEN ISNULL(Z4_DTEMISS,' ')<>' ' AND ISNULL(Z4_HORA,'')<>' '  THEN DATEDIFF(day, C5_EMISSAO+' '+C5_X_HRINC,Z4_DTEMISS+' '+Z4_HORA) ELSE ' ' END DDIF02, "
cquery1+= " CASE WHEN ISNULL(Z4_DTEMISS,' ')<>' '  AND ISNULL(Z4_HORA,'')<>' ' THEN ROUND(( DATEDIFF(second, C5_EMISSAO+' '+C5_X_HRINC+':00',Z4_DTEMISS+' '+Z4_HORA+':00')*1.0)/3600,2) ELSE 0 END HDIF02, "
cquery1+= " C5_X_DTCCX DTLOG, "
cquery1+= " C5_X_HRCCX HRLOG, "
cquery1+= " CASE WHEN C5_X_DTCCX<>' ' THEN DATEDIFF(day, C5_EMISSAO+' '+C5_X_HRINC,C5_X_DTCCX+' '+C5_X_HRCCX) ELSE ' ' END  DDIF03, "
cquery1+= " CASE WHEN C5_X_DTCCX<>' ' THEN ROUND(( DATEDIFF(second, C5_EMISSAO+' '+C5_X_HRINC+':00',C5_X_DTCCX+' '+C5_X_HRCCX+':00')*1.0)/3600,2) ELSE 0 END HDIF03, "
cquery1+= " ISNULL(F2_EMISSAO,'') DTFAT, "
cquery1+= " ISNULL(F2_HORA,'')  HRFAT, "
cquery1+= " CASE WHEN ISNULL(F2_EMISSAO,' ')<>' ' THEN DATEDIFF(day, C5_EMISSAO+' '+C5_X_HRINC,F2_EMISSAO+' '+F2_HORA) ELSE ' ' END DDIF04, "
cquery1+= " CASE WHEN ISNULL(F2_EMISSAO,' ')<>' ' THEN ROUND(( DATEDIFF(second, C5_EMISSAO+' '+C5_X_HRINC+':00',F2_EMISSAO+' '+F2_HORA+':00')*1.0)/3600,2) ELSE 0 END HDIF04, "
cquery1+= " ISNULL(Z1_DTMA,'') DT_MAN, "
cquery1+= " ISNULL(Z1_HRMA,'') HR_MAN, "
cquery1+= " CASE WHEN ISNULL(Z1_DTMA,' ')<>' ' THEN DATEDIFF(day, C5_EMISSAO+' '+C5_X_HRINC,Z1_DTMA+' '+Z1_HRMA) ELSE ' ' END   DDIF05, "
cquery1+= " CASE WHEN ISNULL(Z1_DTMA,' ')<>' ' THEN ROUND(( DATEDIFF(second, C5_EMISSAO+' '+C5_X_HRINC+':00',Z1_DTMA+' '+Z1_HRMA+':00')*1.0)/3600,2) ELSE 0 END HDIF05, "
cquery1+= " F2_DTENTR   DT_ENT, "
cquery1+= " LEFT(F2_HORNFE,2)+':'+RIGHT(F2_HORNFE,2) HR_ENT, "
cquery1+= " CASE WHEN ISNULL(F2_DTENTR,' ')<>' ' THEN DATEDIFF(day, C5_EMISSAO+' '+C5_X_HRINC,F2_DTENTR+' '+LEFT(F2_HORNFE,2)+':'+RIGHT(F2_HORNFE,2)) ELSE ' ' END  DDIF06, "
cquery1+= " CASE WHEN ISNULL(F2_HORNFE,' ')<>' ' THEN ROUND(( DATEDIFF(second, C5_EMISSAO+' '+C5_X_HRINC+':00',F2_DTENTR+' '+LEFT(F2_HORNFE,2)+':'+RIGHT(F2_HORNFE,2)+':00')*1.0)/3600,2) ELSE 0 END HDIF06, "
cquery1+= " F2_DOC NOTA,  A4_NREDUZ TRANSPORT, C5_MENNOTA MENS_NOTA "
cquery1+= " FROM SC5020 C5 (NOLOCK) "
cquery1+= " INNER JOIN SA1020 A1 (NOLOCK) ON C5_CLIENTE=A1_COD AND A1_LOJA=C5_LOJAENT AND A1.D_E_L_E_T_=' '  "
cquery1+= " INNER JOIN SX5020 X5 (NOLOCK) ON X5_FILIAL='0101' AND X5_TABELA='ZE' AND C5_FILIAL=LEFT(X5_CHAVE,4) AND X5.D_E_L_E_T_=' ' "
cquery1+= " LEFT JOIN SZ4020 Z4 (NOLOCK) ON C5_X_NONDA=Z4_NUMONDA AND Z4.D_E_L_E_T_=' '  "
cquery1+= " LEFT JOIN SF2020 F2 (NOLOCK) ON C5_FILIAL=F2_FILIAL AND C5_NOTA=F2_DOC AND F2.D_E_L_E_T_=' '  "
cquery1+= " LEFT JOIN SZ1020 Z1 (NOLOCK) ON C5_FILIAL=Z1_FILIAL AND F2_X_NRMA=Z1_NRMA AND Z4.D_E_L_E_T_=' '  AND F2_X_NRMA<>' '  "
cquery1+= " LEFT JOIN SA4020 A4 (NOLOCK) ON Z1_TRANSP=A4_COD AND A4.D_E_L_E_T_=' '  "
cquery1+= " WHERE  "
cquery1+= " C5.D_E_L_E_T_=' '  "
cquery1+= " AND C5_EMISSAO between '"+_MV_PAR01+"' and '"+_MV_PAR02+"' "
cquery1+= " AND C5_TIPO NOT IN ('D','B') "
cquery1+= " AND C5_MENNOTA  NOT LIKE '%MIGS%' "
cquery1+= " ORDER BY 1,2 "

	MPSysOpenQuery( cQuery1, "QRY" )
	DbSelectArea("QRY")

	While QRY->( !Eof() )

		oFWMsExcel:AddRow(aWorkSheet[1],aWorkSheet[1], { ;
		QRY->EMPRESA, QRY->PEDIDO, QRY->TP_CLIENTE, QRY->COD_CLI, QRY->LOJA, QRY->R_SOCIAL,;
		QRY->FANTASIA, QRY->UF, QRY->CNPJ_CPF,;
		DTOC(STOD(QRY->DT_PEDIDO)), QRY->HR_PEDIDO, ;
		DTOC(STOD(QRY->DT_CRED)), QRY->HR_CRED, QRY->DDIF01, QRY->HDIF01, ;
		DTOC(STOD(QRY->DTCOM)), QRY->HRCOM, QRY->DDIF02, QRY->HDIF02, ;
		DTOC(STOD(QRY->DTLOG)), QRY->HRLOG, QRY->DDIF03, QRY->HDIF03,;
		DTOC(STOD(QRY->DTFAT)), QRY->HRFAT, QRY->DDIF04, QRY->HDIF04,;
		DTOC(STOD(QRY->DT_MAN)), QRY->HR_MAN, QRY->DDIF05, QRY->HDIF05,;
		DTOC(STOD(QRY->DT_ENT)), QRY->HR_ENT, QRY->DDIF06, QRY->HDIF06,;
		QRY->NOTA, QRY->TRANSPORT, QRY->MENS_NOTA} )

		QRY->( Dbskip() )
	End
	
	DBSELECTAREA("QRY")
	DBSKIP()
	
//END
MsgAlert("Planilha Gerada em: "+(cFilePath)) 

oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cFilePath)
oExcel := MsExcel():New()
oExcel:WorkBooks:Open(cFilePath)
oExcel:SetVisible(.T.)
oExcel:Destroy()

Return

//cria as perguntas
Static Function AjustaSX1()
PutSx1('RLFCDEV', "01", "Data De?" , "Ordem ?", 		"Ordem ?", 		  "mv_ch1", "D", 08, 0, 1, "G","","", "", "", "mv_par01",,,,,,,,,,,,,,,,,	{"Emissao da Fatura De", "", ""},{},{} )
PutSx1('RLFCDEV', "02", "Data Ate?", "Ordem ?", 		"Ordem ?", 		  "mv_ch2", "D", 08, 0, 1, "G","","", "", "", "mv_par02",,,,,,,,,,,,,,,,,	{"Emissao da Fatura Ate", "", ""},{},{} )
Return
