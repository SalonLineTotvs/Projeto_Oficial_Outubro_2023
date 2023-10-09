#Include "Protheus.ch"
#INCLUDE 'rwmake.ch'
#INCLUDE "TOPCONN.CH"

//Ponto de Entrada - Incluir botoão na tela do CALL CENTER com mais Opções para Usuario (Consulta Nota / Resumo do Atendimento / Danfe )
//Solicitação - Daniele França / Fernando Medeiros
//Autor - Rodrigo Altafini / AMR - Data 08/03/2019
//Link oficial daq Totvs - http://tdn.totvs.com/pages/releaseview.action?pageId=6787833

User Function TMKCBPRO()

Local aButtons := {}

AAdd(aButtons ,{ "Resumo Atendimento",	{|| cResumoB() }, 'Resumo Atendimento','Resumo Atendimento'})	//Tela com Resumo do Atendimento
AAdd(aButtons ,{ "Consulta Nota"	 ,	{|| cConNF() }, 'Consulta Nota','Consulta Nota'})				//Utilizado a Consulta padrão Nota Fiscal
AAdd(aButtons ,{ "Danfe"			 ,	{|| u_zGerDanfe()}, 'Danfe','Danfe'})							//Função para Gerar Danfe em PDF

Return(aButtons)



//***   Montar Resumo do Atendimento   ***
Static Function cResumoB()

//Busca os dados do Resumo do Atendimento
cQuery := " SELECT DISTINCT"
cQuery += " UD_CODIGO, UD_ITEM,"
cQuery += " UD_OCORREN,UD_SOLUCAO,"
cQuery += " 'Ocor: '+RTRIM(U9_DESC)+' - Açao: '+RTRIM(UQ_DESC) DESCC,"
cQuery += " SUBSTRING(UD_DATA,7,2)+'/'+SUBSTRING(UD_DATA,5,2)+'/'+SUBSTRING(UD_DATA,1,4) DATA, UPPER(U7_NREDUZ) USUARIO, U0_NOME CC,"
cQuery += " CASE WHEN UD_STATUS='1' THEN 'Pendente' else 'Atendido' end SITUACAO,"
cQuery += " UD_OBS"

cQuery += " FROM "+RetSqlName("SUD")+" UD"														//Item do Atendimento
cQuery += " LEFT JOIN "+RetSqlName("SU9")+" U9 ON UD_OCORREN=U9_CODIGO  AND U9.D_E_L_E_T_=' '"	//Tab OCorrencias
cQuery += " LEFT JOIN "+RetSqlName("SUQ")+" UQ ON UD_SOLUCAO=UQ_SOLUCAO AND UQ.D_E_L_E_T_=' '"	//Tab AÇÕES
cQuery += " LEFT JOIN "+RetSqlName("SU7")+" U7 ON UQ_CODRESP=U7_CODUSU  AND U7.D_E_L_E_T_=' '"	//Tab Operador
cQuery += " LEFT JOIN "+RetSqlName("SU0")+" U0 ON U7_POSTO  =U0_CODIGO  AND U0.D_E_L_E_T_=' '"	//Tab Grupo

cQuery += " WHERE UD.D_E_L_E_T_=' '"
cQuery += " AND UD_CODIGO = '"+M->UC_CODIGO+"'"
cQuery += " AND UD_FILIAL = '"+xFilial("SUD")+"'"

cQuery += " ORDER BY 1,2"


DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

//Monta resultado em Tela
@ 017,000 To 520,1200 Dialog oInfo Title OemToAnsi("Resumo do Atendimento Nr."+M->UC_CODIGO)
aCampos := {}
AADD(aCampos,{"DATA"	,"Data Atend","@!","10","0"})
AADD(aCampos,{"USUARIO"	,"Usuario"	 ,"@!","15","0"})
AADD(aCampos,{"CC"		,"Depto"	 ,"@!","15","0"})
AADD(aCampos,{"SITUACAO","Situacao"	 ,"@!","10","0"})
AADD(aCampos,{"DESCC"	,"Ocorrencia / Acao","@!","40","0"})

@ 001,002 Say OemToAnsi("Registros Obtidos:")  Size 162,8
@ 009,001 To 228,570 BROWSE "TRB" FIELDS aCampos
@ 235,100 Say "Total de Registro Selecionados :"
@ 238,328 BmpButton Type 1 Action Close(oInfo)
Activate Dialog oInfo
dbSelectArea("TRB")
dbCloseArea()

Return





//*** Consulta Nota Fiscal em Tela ***
Static Function cConNF()

Private cNota   := space(09)

//!!! Tela de Parametros !!!
Define MsDialog oDlg Title "PARAMETROS"
@ 002,005 Say "INFORME A NOTA FISCAL: " OF oDlg PIXEL
@ 002,070 Get cNota  picture "@!" size 50,50
@ 53,90 Button "Buscar"  size 30,12 action oDlg:End() // Fecha a Tela
Activate Dialog oDlg CENTERED

//Função padrão para COnsultar Nota
//Mc090Visual("SF2",TRB->SF2_RECN,3) //Não funcionam, precisei recriar a chamada

dbSelectArea("SF2")
dbSetOrder(1)
MsSeek(xFilial("SF2")+PADR(cNota,9)+"2  ")		//Filial + Nota + Serie da Nota "FIXO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a pilha da funcao fiscal                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()
MaFisEnd()


dbSelectArea("SD2")
dbSetOrder(3)
cAliasSD2 := CriaTrab(,.F.)
lQuery := .T.
cQuery := "SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_TIPO,R_E_C_N_O_ SD2RECNO "
cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
cQuery += "SD2.D2_DOC='"+cNota+"' AND "
cQuery += "SD2.D2_SERIE='2  ' AND "		//Fixo
cQuery += "SD2.D2_FILIAL='"+xFilial("SF2")+"' AND "
cQuery += "SD2.D_E_L_E_T_=' ' "
cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)


While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
	SF2->F2_DOC == (cAliasSD2)->D2_DOC .And.;
	SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
	SF2->F2_CLIENTE == (cAliasSD2)->D2_CLIENTE .And.;
	SF2->F2_LOJA == (cAliasSD2)->D2_LOJA
	If SF2->F2_TIPO == (cAliasSD2)->D2_TIPO
		If lQuery
			SD2->(MsGoto((cAliasSD2)->SD2RECNO))
		EndIf
		A920NFSAI("SD2",SD2->(RecNo()),0)
		Exit
	EndIf
	dbSelectArea(cAliasSD2)
	dbSkip()
EndDo

If lQuery
	dbSelectArea(cAliasSD2)
	dbCloseArea()
	dbSelectArea("SD2")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a pilha da funcao fiscal                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisRestore()

Return (.T.)




//***  GERA DANFE EM ARQUIVO PDF  ***
//Bibliotecas
#Include "Protheus.ch"
#INCLUDE 'rwmake.ch'
#Include "TBIConn.ch"
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"


/*/{Protheus.doc} zGerDanfe 
Função que gera a danfe e o xml de uma nota em uma pasta passada por parâmetro
@author Atilio
@since 10/02/2019
@version 1.0
@param cNota, characters, Nota que será buscada
@param cSerie, characters, Série da Nota
@param cPasta, characters, Pasta que terá o XML e o PDF salvos
@type function
@example u_zGerDanfe("000123ABC", "1", "C:\TOTVS\NF")
@obs Para o correto funcionamento dessa rotina, é necessário:
1. Ter baixado e compilado o rdmake danfeii.prw
2. Ter baixado e compilado o zSpedXML.prw - https://terminaldeinformacao.com/2017/12/05/funcao-retorna-xml-de-uma-nota-em-advpl/
/*/

User Function zGerDanfe() //cNota, cSerie, cPasta)
Local aArea     := GetArea()
Local cIdent    := ""
Local cArquivo  := ""
Local oDanfe    := Nil
Local oDlg
Local lEnd      := .F.
Local nTamNota  := TamSX3('F2_DOC')[1]
Local nTamSerie := TamSX3('F2_SERIE')[1]
Private PixelX
Private PixelY
Private nConsNeg
Private nConsTex
Private oRetNF
Private nColAux
Private cNota   := SPACE(09)

//!!! Tela de Parametros !!!
Define MsDialog oDlg Title "PARAMETROS"
@ 002,005 Say "INFORME A NOTA FISCAL: " OF oDlg PIXEL
@ 002,068 Get cNota  picture "@!" size 50,50
@ 53,90 Button "Buscar"  size 30,12 action oDlg:End() // Fecha a Tela
Activate Dialog oDlg CENTERED

Private cSerie  := "2  "
Private cPasta  := "c:\TEMP\Arquivo1.xml" //GetTempPath()

//Se existir nota
If ! Empty(cNota)
	//Pega o IDENT da empresa
	cIdent := RetIdEnti()
	
	//Se o último caracter da pasta não for barra, será barra para integridade
	If SubStr(cPasta, Len(cPasta), 1) != "\"
		cPasta += "\"
	EndIf
	
	//Gera o XML da Nota
	cArquivo := cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
	u_zSpedXML(cNota, cSerie, cPasta + cArquivo  + ".xml", .F.)
	
	//Define as perguntas da DANFE
	Pergunte("NFSIGW",.F.)
	MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
	MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
	MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
	MV_PAR04 := 2                          //NF de Saida
	MV_PAR05 := 1                          //Frente e Verso = Sim
	MV_PAR06 := 2                          //DANFE simplificado = Nao
	
	//Cria a Danfe
	oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., , .T.)
	
	//Propriedades da DANFE
	oDanfe:SetResolution(78)
	oDanfe:SetPortrait()
	oDanfe:SetPaperSize(DMPAPER_A4)
	oDanfe:SetMargin(60, 60, 60, 60)
	
	//Força a impressão em PDF
	oDanfe:nDevice  := 6
	oDanfe:cPathPDF := cPasta
	oDanfe:lServer  := .F.
	oDanfe:lViewPDF := .T.
	
	//Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
	PixelX    := oDanfe:nLogPixelX()
	PixelY    := oDanfe:nLogPixelY()
	nConsNeg  := 0.4
	nConsTex  := 0.5
	oRetNF    := Nil
	nColAux   := 0
	
	//Chamando a impressão da danfe no RDMAKE
	RPTStatus( {|lEnd| U_DANFEProc(@oDanfe, @lEnd, cIDEnt, Nil, Nil, , ,,.F. )}, "Imprimindo DANFE..." )
	//RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
	oDanfe:Print()
EndIf

RestArea(aArea)
Return



//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zSpedXML
Função que gera o arquivo xml da nota (normal ou cancelada) através do documento e da série disponibilizados
@author Atilio
@since 25/07/2017
@version 1.0
@param cDocumento, characters, Código do documento (F2_DOC)
@param cSerie, characters, Série do documento (F2_SERIE)
@param cArqXML, characters, Caminho do arquivo que será gerado (por exemplo, C:\TOTVS\arquivo.xml)
@param lMostra, logical, Se será mostrado mensagens com os dados (erros ou a mensagem com o xml na tela)
@type function
@example Segue exemplo abaixo
u_zSpedXML("000000001", "1", "C:\TOTVS\arquivo1.xml", .F.) //Não mostra mensagem com o XML

u_zSpedXML("000000001", "1", "C:\TOTVS\arquivo2.xml", .T.) //Mostra mensagem com o XML
/*/

User Function zSpedXML(cDocumento, cSerie, cArqXML, lMostra)
Local aArea        := GetArea()
Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWebServ
Local cIdEnt       := StaticCall(SPEDNFE, GetIdEnt)
Local cTextoXML    := ""
Default cDocumento := ""
Default cSerie     := ""
Default cArqXML    := GetTempPath()+"arquivo_"+cSerie+cDocumento+".xml"
Default lMostra    := .F.

//Se tiver documento
If !Empty(cDocumento)
	cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
	cSerie     := PadR(cSerie,     TamSX3('F2_SERIE')[1])
	
	//Instancia a conexão com o WebService do TSS
	oWebServ:= WSNFeSBRA():New()
	oWebServ:cUSERTOKEN        := "TOTVS"
	oWebServ:cID_ENT           := cIdEnt
	oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
	oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
	aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
	aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (cSerie+cDocumento)
	oWebServ:nDIASPARAEXCLUSAO := 0
	oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"
	
	//Se tiver notas
	If oWebServ:RetornaNotas()
		
		//Se tiver dados
		If Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
			
			//Se tiver sido cancelada
			If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
				cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
				
				//Senão, pega o xml normal
			Else
				cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
			EndIf
			
			//Gera o arquivo
			MemoWrite(cArqXML, cTextoXML)
			
			//Se for para mostrar, será mostrado um aviso com o conteúdo
			If lMostra
				Aviso("zSpedXML", cTextoXML, {"Ok"}, 3)
			EndIf
			
			//Caso não encontre as notas, mostra mensagem
		Else
			ConOut("zSpedXML > Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...")
			
			If lMostra
				Aviso("zSpedXML", "Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...", {"Ok"}, 3)
			EndIf
		EndIf
		
		//Senão, houve erros na classe
	Else
		ConOut("zSpedXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
		
		If lMostra
			Aviso("zSpedXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return
