#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function RFAT16()

Private cTitulo		:= "Relacao OC"
Private cPerg		:= "RFAT16"
Pergunte(cPerg) 

Processa({|| GeraExcel()	, "Gerando Arquivo Excel ..."})

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
Local x:= 0
Private oExcel
Private aXMLCol		:= {}
Private aXMLRow		:= {}
Private DadosFinais := {}

aAdd(aWorkSheet,'Atendimentos - Tempo em cada setor')

oFWMsExcel:= FWMSExcel():New()
oFWMsExcel:AddworkSheet( aWorkSheet[1] )    
oFWMsExcel:AddTable( aWorkSheet[1], aWorkSheet[1] )
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Distribuidora"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Atendimento"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Numero Atendimento"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Ocorrencia"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Seq"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Assunto"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Desc Assunto"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Ocorrencia"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Desc Ocorrencia"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Solucao"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Desc Solucao"	,1,1,.F.)	
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Dias de Permanencia"	,1,1,.F.)
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Data Encerramento"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Obs"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Status"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Cliente"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "Nome"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "UF"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "NFD"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "DT NFD"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "NFO"	,1,1,.F.) 
oFWMsExcel:AddColumn(aWorkSheet[1], aWorkSheet[1], "DT NFO"	,1,1,.F.) 

    cquery1:= " SELECT  "
    cquery1+= "     CASE "
    cquery1+= " 	WHEN UD_FILIAL='0101' THEN 'CIMEX'"
    cquery1+= " 	WHEN UD_FILIAL='0201' THEN 'CROZE'"
    cquery1+= " 	WHEN UD_FILIAL='0301' THEN 'KOPEK'"
    cquery1+= " 	WHEN UD_FILIAL='0401' THEN 'MACO'"
    cquery1+= " 	WHEN UD_FILIAL='0501' THEN 'QUBIT'"
    cquery1+= " 	WHEN UD_FILIAL='0601' THEN 'ROJA'"
    cquery1+= " 	WHEN UD_FILIAL='0701' THEN 'VIXEN'"
    cquery1+= " 	WHEN UD_FILIAL='0801' THEN 'MAIZE'"
    cquery1+= " 	WHEN UD_FILIAL IN('0902','0901') THEN 'DEVINTEX'"
    cquery1+= "     WHEN UD_FILIAL='1101' THEN 'BIZEZ'"
    cquery1+= " 	WHEN UD_FILIAL='1201' THEN 'ZAKAT'"
    cquery1+= " 	WHEN UD_FILIAL='1301' THEN 'HEXIL'"
    cquery1+= " 	ELSE UD_FILIAL END NOMEMPRESA, UC_FILIAL, " 
    cquery1+= "     CASE "
    cquery1+= " 	WHEN UD_STATUS ='1' THEN 'PENDENTE'"
    cquery1+= " 	WHEN UD_STATUS ='2' THEN 'ENCERRADO'"
    cquery1+= " 	ELSE UD_STATUS END UDSTATUS, " 
    cquery1+= "     UC_DATA, UD_CODIGO, UD_DATA, UD_ITEM, UD_OCORREN, X5_DESCRI, UD_ASSUNTO, U9_DESC, UD_XSOLUCA, UD_OBS,UC_CHAVE, A1_NOME, A1_EST,UC_X_NFD"
    cquery1+= " 	,(substring(UD_XDTNFD,7,2)+'/'+substring(UD_XDTNFD,5,2)+'/'+substring(UD_XDTNFD,1,4)) AS SUD_XDTNFD"
    cquery1+= "     ,UC_X_NFO"
    cquery1+= " 	,(substring(UD_XDTNFO,7,2)+'/'+substring(UD_XDTNFO,5,2)+'/'+substring(UD_XDTNFO,1,4)) AS SUD_XDTNFO"
    cquery1+= " , UC_DTENCER"
    cquery1+= " , UC_CODENCE FROM SUD020 "
    cquery1+= " INNER JOIN SUC020 ON UC_FILIAL = UD_FILIAL AND UC_CODIGO = UD_CODIGO "
    cquery1+= " LEFT  JOIN SU9020 ON U9_FILIAL = '' AND UD_OCORREN = U9_CODIGO  AND UD_ASSUNTO = U9_ASSUNTO "
    cquery1+= " LEFT  JOIN SX5020 ON X5_TABELA = 'T1' AND X5_CHAVE = UD_ASSUNTO AND UD_FILIAL = X5_FILIAL AND SX5020.D_E_L_E_T_ = ' ' "
    cquery1+= " LEFT  JOIN SA1020 ON A1_COD = SUBSTRING(UC_CHAVE,1,6) AND A1_LOJA = SUBSTRING(UC_CHAVE,7,2) "
//    cquery1+= " WHERE UC_DATA BETWEEN '20220701' AND '20220731' "
    cquery1+= " WHERE UC_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
    cquery1+= " AND UC_FILIAL BETWEEN '"+(mv_par03)+"' AND '"+(mv_par04)+"' "
    cquery1+= " AND UC_STATUS BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"' "
    cquery1+= " AND UD_CODIGO <> '' "
    cquery1+= " AND SUD020.D_E_L_E_T_ = ' ' "
    cquery1+= " AND SUC020.D_E_L_E_T_ = ' ' "
    cquery1+= " AND SA1020.D_E_L_E_T_ = ' ' "
    
    cquery1+= " ORDER BY UC_FILIAL, UD_CODIGO, UD_ITEM DESC"

	MPSysOpenQuery( cQuery1, "QRY" )
	DbSelectArea("QRY")
    atendimentoatual:= ''
    diaanterior:=ctod('//')

	While QRY->( !Eof() )
    // CONSISTIR LINHA ANTERIOR AQUI

        if  atendimentoatual <> QRY->UC_FILIAL+QRY->UD_CODIGO
            diaanterior:=stod(ud_data)
            uc_atendimento := stod(uc_data)
            ud_atendimento := stod(ud_data)
            ucencer := stod(QRY->UC_DTENCER)
//          oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], { QRY->NOMEMPRESA	, uc_atendimento	, QRY->UD_CODIGO	, ud_atendimento	, QRY->UD_ITEM	, QRY->(UD_ASSUNTO), QRY->(x5_descri)	, QRY->(UD_OCORREN), QRY->(U9_DESC), QRY->UD_XSOLUCA, (Posicione("SUR",2,xFilial("SUR")+QRY->UD_OCORREN+QRY->UD_XSOLUCA,"UR_DESC")) , (IIF(ALLTRIM(QRY->UC_CODENCE)<>'', 0 ,(DIAANTERIOR - DATE())))*(-1) ,ucencer, QRY->(UD_OBS), QRY->(UDSTATUS), QRY->(UC_CHAVE), QRY->(A1_NOME), QRY->(A1_EST),QRY->(UC_X_NFD),QRY->(UD_XDTNFD),QRY->(UC_X_NFO),QRY->(UD_XDTNFO)  } )
                                          aadd(DadosFinais, { QRY->NOMEMPRESA	, uc_atendimento	, QRY->UD_CODIGO	, ud_atendimento	, QRY->UD_ITEM	, QRY->(UD_ASSUNTO), QRY->(x5_descri)	, QRY->(UD_OCORREN), QRY->(U9_DESC), QRY->UD_XSOLUCA, (Posicione("SUR",2,xFilial("SUR")+QRY->UD_OCORREN+QRY->UD_XSOLUCA,"UR_DESC")) , (IIF(ALLTRIM(QRY->UC_CODENCE)<>'', 0 ,(DIAANTERIOR - DATE())))*(-1) ,ucencer, QRY->(UD_OBS), QRY->(UDSTATUS), QRY->(UC_CHAVE), QRY->(A1_NOME), QRY->(A1_EST),QRY->(UC_X_NFD),QRY->(SUD_XDTNFD),QRY->(UC_X_NFO),QRY->(SUD_XDTNFO), (QRY->UC_FILIAL+QRY->NOMEMPRESA+QRY->UD_CODIGO+QRY->UD_ITEM)  } )
            atendimentoatual := QRY->UC_FILIAL+QRY->UD_CODIGO
            diaanterior :=  STOD(QRY->UD_DATA)
        else
            uc_atendimento := stod(uc_data)
            ud_atendimento := stod(ud_data)
//          oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], { QRY->NOMEMPRESA	, uc_atendimento	, QRY->UD_CODIGO	, ud_atendimento	, QRY->UD_ITEM	, QRY->(UD_ASSUNTO), QRY->(x5_descri)	, QRY->(UD_OCORREN), QRY->(U9_DESC), QRY->UD_XSOLUCA, (Posicione("SUR",2,xFilial("SUR")+QRY->UD_OCORREN+QRY->UD_XSOLUCA,"UR_DESC")) ,                                ((ud_atendimento - diaanterior))*(-1),       , QRY->(UD_OBS), QRY->(UDSTATUS), QRY->(UC_CHAVE), QRY->(A1_NOME), QRY->(A1_EST),QRY->(UC_X_NFD),QRY->(UD_XDTNFD),QRY->(UC_X_NFO),QRY->(UD_XDTNFO)  } )
                                          aadd(DadosFinais,  { QRY->NOMEMPRESA	, uc_atendimento	, QRY->UD_CODIGO	, ud_atendimento	, QRY->UD_ITEM	, QRY->(UD_ASSUNTO), QRY->(x5_descri)	, QRY->(UD_OCORREN), QRY->(U9_DESC), QRY->UD_XSOLUCA, (Posicione("SUR",2,xFilial("SUR")+QRY->UD_OCORREN+QRY->UD_XSOLUCA,"UR_DESC")) ,                                ((ud_atendimento - diaanterior))*(-1),       , QRY->(UD_OBS), QRY->(UDSTATUS), QRY->(UC_CHAVE), QRY->(A1_NOME), QRY->(A1_EST),QRY->(UC_X_NFD),QRY->(SUD_XDTNFD),QRY->(UC_X_NFO),QRY->(SUD_XDTNFO), (QRY->UC_FILIAL+QRY->NOMEMPRESA+QRY->UD_CODIGO+QRY->UD_ITEM)  } )
            atendimentoatual := QRY->UC_FILIAL+QRY->UD_CODIGO
            diaanterior :=  STOD(QRY->UD_DATA)
        endif
		QRY->( Dbskip() )
	End
	
	DBSELECTAREA("QRY")
	DBSKIP()
	
//END

MsgAlert("Planilha Gerada em: "+(cFilePath+ ' Registros: ' + str(len(DadosFinais))) )

aSort(DadosFinais,,, {|x, y| x[23] < y[23]})
for x=1 to len(DadosFinais)
//    oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], { QRY->NOMEMPRESA, uc_atendimento, QRY->UD_CODIGO, ud_atendimento, QRY->UD_ITEM, QRY->(UD_ASSUNTO), QRY->(x5_descri)	, QRY->(UD_OCORREN), QRY->(U9_DESC), QRY->UD_XSOLUCA, (Posicione("SUR",2,xFilial("SUR")+QRY->UD_OCORREN+QRY->UD_XSOLUCA,"UR_DESC")) ,                                ((ud_atendimento - diaanterior))*(-1),       , QRY->(UD_OBS), QRY->(UDSTATUS), QRY->(UC_CHAVE), QRY->(A1_NOME), QRY->(A1_EST),QRY->(UC_X_NFD),QRY->(UD_XDTNFD),QRY->(UC_X_NFO),QRY->(UD_XDTNFO)  } )
    oFWMsExcel:AddRow(aWorkSheet[1], aWorkSheet[1], { DadosFinais[x,1], DadosFinais[x,2], DadosFinais[x,3], DadosFinais[x,4], DadosFinais[x,5], DadosFinais[x,6],DadosFinais[x,7], DadosFinais[x,8], DadosFinais[x,9], DadosFinais[x,10], DadosFinais[x,11],DadosFinais[x,12],DadosFinais[x,13],DadosFinais[x,14],DadosFinais[x,15],DadosFinais[x,16],DadosFinais[x,17], DadosFinais[x,18],DadosFinais[x,19],DadosFinais[x,20],DadosFinais[x,21],DadosFinais[x,22]  } )
next

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
