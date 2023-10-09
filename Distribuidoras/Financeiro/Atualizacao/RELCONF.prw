//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RELCONF
Relatório - Relat Conferencia - Descontos 
@type Function User
@author Samuel Vincenzo
@since 20/09/2022
@version 1.0
/*/
	
User Function RELCONF()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "RELCONF01"
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectSC5 := Nil
    Local oSectSC6 := Nil
    Local oSectSE1 := Nil
	Local oBreak := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"RELCONF",;		//Nome do Relatório
								"Relat Conferencia - Descontos",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .T.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	oReport:SetLineHeight(50)
	oReport:nFontBody := 08
	
	//Criando a seção da SC5
	oSectSC5 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Pedido de Venda",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectSC5:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectSC5, "C5_FILIAL", "QRY_AUX", "Filial", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_NUM", "QRY_AUX", "Numero", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "COD", "QRY_AUX", "Codigo/Loja", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "A1_NOME", "QRY_AUX", "Nome", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "CONDPAG", "QRY_AUX", "Cond Pag", /*Picture*/, 21, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_X_FORMP", "QRY_AUX", "Form PAGTO", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_X_DCONT", "QRY_AUX", "% Desc. Contrato", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_X_DEXPO", "QRY_AUX", "% Desc Exporadico", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_X_DPRAZ", "QRY_AUX", "% Desc Prazo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_X_DACOR", "QRY_AUX", "% Desc Acordo Log", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_X_DFRET", "QRY_AUX", "% Desc Frete FOB", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_NOTA", "QRY_AUX", "Nota Fiscal", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSC5, "C5_SERIE", "QRY_AUX", "Serie", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
    //Criando a seção da SC5
	oSectSE1 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Títulos Conta a Receber",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectSE1:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	oSectSE1:lHeaderVisible := .T.
    
    TRCell():New(oSectSE1, "E1_PREFIXO", "QRY_AUX", "Prefixo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_NUM", "QRY_AUX", "No. Titulo", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_PARCELA", "QRY_AUX", "Parcela", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_EMISSAO", "QRY_AUX", "DT Emissao", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_VENCTO", "QRY_AUX", "Vencimento", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_VENCREA", "QRY_AUX", "Vencto real", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_VALOR", "QRY_AUX", "Vlr.Titulo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_DCONT", "QRY_AUX", "% Desc Contrato", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_VCONT", "QRY_AUX", "Vlr Desc Contrato", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_DEXPO", "QRY_AUX", "% Desc Expor", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_VEXPO", "QRY_AUX", "Vlr D Expora", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_DPRAZ", "QRY_AUX", "% Desc Prazo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_VPRAZ", "QRY_AUX", "Vlr D Prazo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_DACOR", "QRY_AUX", "% Desc Acord", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_VACOR", "QRY_AUX", "% D Aco Log", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_FRETF", "QRY_AUX", "% D Fret FOB", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_VFRET", "QRY_AUX", "Vlr Fret FOB", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectSE1, "E1_X_VTOTD", "QRY_AUX", "Vlr Tot Desc", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectSC5,{|| QRY_AUX->(C5_NUM) },{|| "SEPARACAO DO RELATORIO" })
	oSectSC5:SetHeaderBreak(.T.)


Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectSC5 := Nil
    Local oSectSE1 := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cNum     := ""

	//Pegando as seções do relatório
	oSectSC5 := oReport:Section(1)
	oSectSE1 := oReport:Section(2)
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT distinct"		+ STR_PULA
	cQryAux += "	C5.C5_FILIAL,"		+ STR_PULA
	cQryAux += "	C5.C5_NUM,"		+ STR_PULA
	cQryAux += "	CONCAT(C5.C5_CLIENTE,'L',C5.C5_LOJACLI) COD,"		+ STR_PULA
	cQryAux += "	A1.A1_NOME,"		+ STR_PULA
	cQryAux += "	CONCAT(C5.C5_CONDPAG,' - ', E4_DESCRI) CONDPAG,"		+ STR_PULA
	cQryAux += "	C5.C5_X_FORMP,"		+ STR_PULA
	cQryAux += "	C5.C5_X_DCONT,"		+ STR_PULA
	cQryAux += "	C5.C5_X_DEXPO,"		+ STR_PULA
	cQryAux += "	C5.C5_X_DPRAZ,"		+ STR_PULA
	cQryAux += "	C5.C5_X_DACOR,"		+ STR_PULA
	cQryAux += "	C5.C5_X_DFRET,"		+ STR_PULA
	cQryAux += "	C5.C5_EMISSAO,"		+ STR_PULA
	cQryAux += "	C5.C5_NOTA,"		+ STR_PULA
	cQryAux += "	C5.C5_SERIE,"		+ STR_PULA
    cQryAux += "	E1.E1_PREFIXO,"		+ STR_PULA
	cQryAux += "	E1.E1_NUM,"		+ STR_PULA
	cQryAux += "	E1.E1_PEDIDO,"		+ STR_PULA
	cQryAux += "	E1.E1_PARCELA,"		+ STR_PULA
	cQryAux += "	E1.E1_EMISSAO,"		+ STR_PULA
	cQryAux += "	E1.E1_VENCTO,"		+ STR_PULA
	cQryAux += "	E1.E1_VENCREA,"		+ STR_PULA
	cQryAux += "	E1.E1_VALOR,"		+ STR_PULA
	cQryAux += "	E1.E1_X_DCONT,"		+ STR_PULA
	cQryAux += "	E1.E1_X_VCONT,"		+ STR_PULA
	cQryAux += "	E1.E1_X_DEXPO,"		+ STR_PULA
	cQryAux += "	E1.E1_X_VEXPO,"		+ STR_PULA
	cQryAux += "	E1.E1_X_DPRAZ,"		+ STR_PULA
	cQryAux += "	E1.E1_X_VPRAZ,"		+ STR_PULA
	cQryAux += "	E1.E1_X_DACOR,"		+ STR_PULA
	cQryAux += "	E1.E1_X_VACOR,"		+ STR_PULA
	cQryAux += "	E1.E1_X_FRETF,"		+ STR_PULA
	cQryAux += "	E1.E1_X_VFRET,"		+ STR_PULA
	cQryAux += "	E1.E1_X_VTOTD"		+ STR_PULA
	cQryAux += "	FROM"+ RetSqlName("SC5") +" C5"		+ STR_PULA
	cQryAux += "		INNER JOIN "+ RetSqlName("SE4") +" E4 ON E4.E4_CODIGO = C5.C5_CONDPAG AND E4.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "		INNER JOIN "+ RetSqlName("SA1") +" A1 ON A1.A1_COD = C5.C5_CLIENTE AND A1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "		INNER JOIN "+ RetSqlName("SE1") +" E1 ON E1.E1_PEDIDO = C5.C5_NUM AND E1.E1_FILIAL = C5.C5_FILIAL AND E1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "   WHERE C5_FILIAL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' AND " + STR_PULA
    cQryAux += "   C5_NUM BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' AND " + STR_PULA
    cQryAux += "   C5_CLIENTE BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' AND"		+ STR_PULA
	cQryAux += "   C5_LOJACLI BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"' AND"		+ STR_PULA
	cQryAux += "   C5_EMISSAO BETWEEN '"+ DtoS(MV_PAR09) +"' AND '"+ DtoS(MV_PAR10) +"' " +STR_PULA
	cQryAux := ChangeQuery(cQryAux)	
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "C5_EMISSAO", "D")
	TCSetField("QRY_AUX", "E1_EMISSAO", "D")
	TCSetField("QRY_AUX", "E1_VENCTO", "D")
	TCSetField("QRY_AUX", "E1_VENCREA", "D")
	
	//Enquanto houver dados
	oSectSC5:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registros. Aguarde... ")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectSC5:PrintLine()
		cNum := QRY_AUX->(C5_NUM)
		cNota := QRY_AUX->(C5_NOTA)
        
		while QRY_AUX->E1_PEDIDO == cNum
			oSectSE1:Init()
           	oSectSE1:PrintLine()
			QRY_AUX->(DbSkip())
        endDo
		oSectSE1:Finish()	
		QRY_AUX->(DbSkip())
	EndDo

	oSectSC5:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return
