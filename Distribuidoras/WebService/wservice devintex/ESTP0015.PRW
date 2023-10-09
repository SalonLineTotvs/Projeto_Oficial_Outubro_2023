#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'rwmake.ch'
#INCLUDE 'colors.ch'
#Include "Avprint.ch"
#Include "Font.ch"
#define MB_ICONASTERISK  64

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ESTP0015	 ³ Autor ³ André Valmir 		³ Data ³07/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de conferência de pedido de vendas					  ³±±
±±³          ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
Link Tabela de CORES:
http://www.helpfacil.com.br/forum/display_topic_threads.asp?ForumID=1&TopicID=27176

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					                                       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	 									  ³±±
±±³ 26/02/18	ANDRE SALGADO		18:00								 									  ³±±
±±³ 27/02/18	ANDRE VALMIR		19:45								  									  ³±±
±±³	01/03/18	GENILSON LUCAS		10:00								 									  ³±±
±±³ 06/03/18	ANDRE VALMIR		19:00							 										  ³±±
±±³ 07/03/18	ANDRE VALMIR		10:00																	  ³±±
±±³ 07/03/18	ANDRE Salgado		13:00 - Regra 02 item iguais 											  ³±±
±±³ 07/03/18	ANDRE Salgado		17:20 - Incluir Etiqueta DISTRIBUIDORA									  ³±±
±±³ 08/03/18	ANDRE VALMIR		19:45							 										  ³±±
±±³ 09/03/18	ANDRE VALMIR		19:30																	  ³±±
±±³ 13/03/18	ANDRE VALMIR		20:10																	  ³±±
±±³ 15/03		GENILSON			29:30 REGRA PARA LIMPAR CONF 											  ³±±
±±³ 16/03/18	ANDRE VALMIR		11:30 REGRA PARA ATUALIZAR STATUS/GERAR PV ANTES DE IMPRIMIR ETIQUETA	  ³±±
±±³ 19/03/18	ANDRE VALMIR		19:30 																	  ³±±
±±³ 21/03/18	ANDRE VALMIR		21:30 																	  ³±±
±±³ 22/03/18	ANDRE VALMIR		15:20 																	  ³±±
±±³ 23/03/18	ANDRE VALMIR		16:00 																	  ³±±
±±³ 25/04/18	GENILSON LUCAS		18:00																	  ³±±
±±³ 29/10/18	ANDRE VALMIR		16:00 ADICIONADO NA IMPRESSÃO DA ETIQUETA (CONTEM CAIXA E GRANEL)         ³±±
±±³ 25/05/20	ANDRE SALGADO		20:00 CONFIGURAR A TRANSFERENCIA AUTOMATICA PARA LOCAL "Z1" - Expedição - Programa WB_LOG013
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

** Criar os campos **
C5_XCCDSEP - Tipo C - 8 - CX COD Separador
C5_XCNMSEP - Tipo C -20 - CX Nome Separador
C5_XCDTSEP - Tipo D - 8 - CX Dt Separador
C5_XCHRSEP - Tipo C - 8 - CX Hr Separador

C5_XGCDSEP - Tipo C - 8 - GR COD Separador
C5_XGNMSEP - Tipo C -20 - GR Nome Separador
C5_XGDTSEP - Tipo D - 8 - GR Dt Separador
C5_XGHRSEP - Tipo C - 8 - GR Hr Separador

C5_XCCDCNF - Tipo C - 8 - CX COD Conferente
C5_XCNMCNF - Tipo C -20 - CX Nome Conferente
C5_XCDTCNF - Tipo D - 8 - CX Dt Conferente
C5_XCHRCNF - Tipo C - 8 - CX Hr Conferente

C5_XGCDCNF - Tipo C - 8 - GR COD Conferente
C5_XGNMCNF - Tipo C -20 - GR Nome Conferente
C5_XGDTCNF - Tipo D - 8 - GR Dt Conferente
C5_XGHRCNF - Tipo C - 8 - GR Hr Conferente

B1_X_EAN13 - Tipo C - 13- EAN 13
Criado Indice (13) - SB1- B1_FILIAL + B1_X_EAN13

ZH_X_EAN13 - Tipo C - 13- EAN 13
Criado Indice (2) - SZH- ZH_FILIAL + ZH_X_EAN13


==> Atualizar Campo PadrÃ£o nesta REGRA
C5_VOLUME1 - Atualizar Quantidade de Volumes de CAIXA
C5_VOLUME2 - Atualizar Quantidade de Volumes de GRANEL

C6_XQTCXCX - Tipo N (12,2)	- Qtd Conferida CAIXA  (grava durante o processo)
C6_XQTCXGR - Tipo N (12,2)	- Qtd Conferida GRANEL (grava durante o processo)

Criado o C6_XQTDCON - Tipo N (12,2)	- Qtd Conferida  (grava durante o processo)
Criado o C6_XQTDSAL - Tipo N (12,2)	- Qtd Conf.Salva (grava EFETIVAÃ‡ÃƒO do processo)


C5_X_TLPCC	- Tipo - Caracter C (1) - Lib.T/P.CX (Lib.Total/Parcial Caixa) Lista OpÃ§Ãµes P=Parcial;T=Total
C5_X_TLPCG	- Tipo - Caracter C (1) - Lib.T/P.GR (Lib.Total/Parcial Granel) Lista OpÃ§Ãµes P=Parcial;T=Total

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTP0015()


// Declaracao das variaveis
Local 	aAreaAtu	:= GetArea()
Local 	aRet		:= {Space(04),Space(06),space(1)}

Private oGetDad
Private	aHeader		:= {}
Private	aCols		:= {}
Private	aCols2		:= {}
Private cOp  		:= ""
Private cTPConfCG	:= ""
Private cPI  		:= ""
Private lMsErroAuto	:= .F.

Private oBrowse
Private oFont1 		:= TFont():New("ARIAL",,-15,,.F.)
Private oFont2 		:= TFont():New("ARIAL",,-18,,.T.)

Private lgravaCAB 	:= .T.	//Flag para confirmar Gravacao
Private aCabec		:= {}	//Cabeçalho
Private aLinha		:= {}	//Item - temporario
Private aItens		:= {}	//Item - Final

Private nSeqIPV		:= 0	//Sequencia
Private cTxtUpdate	:= ""
Private lGerPed 	:= .F.	// *** Valmir (Flag para gerar pedido de vendas caso a senha seja validada.
Private lVazio		:= .F.	// Caso for tentar conferir com falta e a quantidade de todos itens for igual a zero, o sistema nao deve gerar a conferencia
Private nQtd		:= 0	// Caso tenha dado .F. uma vez incrementa   *** Valmir (22/12/17)
Private lValidaGrd	:= .F.
Private lValConfer	:= .F.  // Validar conferencia Total
Private lGerEtiq	:= .F.
Private cItem		:= ""
Private nQtdVolCX	:= 0
Private lWebSrv 	:= .F.

Private cTrans01Z1	:= alltrim(GETMV("ES_LOG013T"))	//Parametro Autorizar a Transferencia entre "01" e "Z1"  - "S"



//	{1,"Codigo do Pedido",aRet[1],"@!","ExistCPO('SC5',Left(MV_PAR01,6))","SC5","",70,.F.},;
If !ParamBox( {;
	{1,"Empresa",aRet[1],"@!",,,"",70,.F.},;
	{1,"Codigo do Pedido",aRet[2],"@!",,"SZG","",70,.F.},;
	{2,"Caixa/Granel",aRet[3],{"Caixa","Granel"},50,,.F.};
	},"Conferencia de Separação de Estoque", @aRet,,,,,,,,.T.,.T. )
	
	Return
End If

cEmpresaD	:= aRet[1]
cOp 	 	:= aRet[1]+aRet[2]	//Numero do Pedido de Venda
cTPConfCG	:= IIF(aRet[3] == "Caixa","C","G")	//Tipo de Conferencia Caixa/Granel


//Nome da Distribuidora
IF cEmpresaD = "0101"
	cNomeCliD := "CIMEX"
ElseIF cEmpresaD = "0201"
	cNomeCliD := "CROZE"
ElseIF cEmpresaD = "0301"
	cNomeCliD := "KOPEK"
ElseIF cEmpresaD = "0401"
	cNomeCliD := "MACO"
ElseIF cEmpresaD = "0501"
	cNomeCliD := "QUBIT"
ElseIF cEmpresaD = "0601"
	cNomeCliD := "ROJA"
ElseIF cEmpresaD = "0701"
	cNomeCliD := "VIXEN"
ElseIF cEmpresaD = "0801"
	cNomeCliD := "MAIZE"
ElseIF cEmpresaD = "091"
	cNomeCliD := "DEV FIL 0002"
ElseIF cEmpresaD = "0902"
	cNomeCliD := "DEV MG"
Else
	cNomeCliD := cEmpresaD
Endif



//Muda Status - Pedido de Venda
SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp))

If cTPConfCG = "C"
	
	If SZG->ZG_STAPV $ "2/3" //EM SEPARCAO OU SEPARACAO FINALIZADA
		//		reclock("SZG",.F.)
		//		SZG->ZG_STAPV	:= "4"	// INICIOU CONFERENCIA
		//		SZG->ZG_DTICF	:= Date()
		//		SZG->ZG_HRICF	:= TIME()
		//		msunlock()
		
		cQuery1 := " UPDATE SZG010 SET ZG_STAPV = '4', ZG_DTICF = '"+DTOS(Date())+"', ZG_HRICF = '"+LEFT(TIME(),5)+"' "
		cQuery1 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' AND ZG_HRICF = '' "
		TcSqlExec(cQuery1)
		
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SZG->ZG_TLPCC)
			U_SLPCPA51(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Endif
		
	ElseIf SZG->ZG_STAPV $ "4"
		//		reclock("SZG",.F.)
		If Empty(SZG->ZG_HRICF)
			//			SZG->ZG_DTICF	:= Date()
			//			SZG->ZG_HRICF	:= TIME()
			cQuery2 := " UPDATE SZG010 SET ZG_DTICF = '"+DTOS(Date())+"', ZG_HRICF = '"+LEFT(TIME(),5)+"' "
			cQuery2 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' AND ZG_HRICF = '' "
			TcSqlExec(cQuery2)
		Endif
		//		msunlock()
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SZG->ZG_TLPCC)
			U_SLPCPA51(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Endif
		
		
	ElseIf SZG->ZG_STAPV $ "0/1" //.OR. Empty(SC5->C5_X_DTISP) Verificar com Genilson (19/03/2018)
		MSGALERT("FAVOR SOLICITAR LIBERAÇÃO DO PEDIDO PARA INICIAR CONFERÊNCIA.","PEDIDO NÃO LIBERADO")
		Return()
	Else
		MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Return()
	Endif
Else
	If SZG->ZG_STAPV $ "1/2/3/A" //LIBERADO, EM SEPARACAO, SEPARACAO FINALIZADA OU ANTECIPADO
		If SZG->ZG_TLNCX = 0
			//			reclock("SZG",.F.)
			//			SZG->ZG_STAPV	:= "4"	// INICIOU CONFERENCIA
			//			msunlock()
			cQuery3 := " UPDATE SZG010 SET ZG_STAPV='4' "
			cQuery3 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
			TcSqlExec(cQuery3)
		EndIf
		
		If Empty(SZG->ZG_HRIGR) // Valmir (16/03/2018)
			//			reclock("SZG",.F.)
			//			SZG->ZG_DTIGR	:= Date()
			//			SZG->ZG_HRIGR	:= TIME()
			//			msunlock()
			
			cQuery4 := " UPDATE SZG010 SET ZG_DTIGR = '"+DTOS(Date())+"', ZG_HRIGR = '"+LEFT(TIME(),5)+"' "
			cQuery4 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
			TcSqlExec(cQuery4)
			
		EndIf
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SZG->ZG_TLPCG)
			U_SLPCPA51(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Endif
		
	ElseIf SZG->ZG_STAPV $ "4" //"4/5/6/7"
		If Empty(SZG->ZG_HRIGR) // Valmir (16/03/2018)
			//			reclock("SZG",.F.)
			//			SZG->ZG_DTIGR	:= Date()
			//			SZG->ZG_HRIGR	:= TIME()
			//			msunlock()
			
			cQuery5 := " UPDATE SZG010 SET ZG_DTIGR = '"+DTOS(Date())+"', ZG_HRIGR = '"+LEFT(TIME(),5)+"' "
			cQuery5 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
			TcSqlExec(cQuery5)
			
		EndIf
		
		//Apresenta Tela da Conferencia de Produto
		If Empty(SZG->ZG_TLPCG)
			U_SLPCPA51(aAreaAtu)
		Else
			MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Endif
		
	ElseIf SZG->ZG_STAPV $ "0"
		MSGALERT("FAVOR SOLICITAR LIBERAÇÃO DO PEDIDO PARA INICIAR CONFERÊNCIA.","PEDIDO NÃO LIBERADO")
		Return()
	Else
		MSGALERT("PEDIDO ENCONTRA-SE COM CONFERÊNCIA FINALIZADA.","ATENÇÃO")
		Return()
	Endif
EndIf


RestArea( aAreaAtu )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA51  | Autor ³ Andre Valmir         ³ Data ³07/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta grid para atualizar lotes de acordo com a leitura    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SLPCPA51(aAreaAtu)

// Definicao das variaveis
Local 	oDlg
Local	oCodBar
Local 	oFontLin	:= TFont():New("ARIAL",,20,,.T.)
Local 	cQuery		:= ""
Local 	cAlias		:= GetNextAlias()
Local	cCodBar		:= Space(20)
Local	cNomePrd	:= Space(70)
Local 	cTipo		:= Space(1)
Local	cLote		:= Space(15)

Local	cLocaliza	:= Space(15)
Local   nTamB1		:= TamSX3('B1_COD')[01]

Local 	cNomeCli 	:= Space(100)
Local	nLinha		:= 0
Local 	nLinIni		:= 065
Local 	nLinFim		:= 300
Local	nColIni		:= 1
Local 	nColFim		:= 350
Local 	nFator		:= 1
Local 	aSize 		:= MsAdvSize()
Local 	aVetDados	:= {}

Private lRetornoPlt := .F.
Private	cProduto	:= Space(15)
Private cQtdVolDig	:= 0


//Busca o Pedido Selecionado
/*
cQuery	:= " SELECT C6_NUM D4_OP, C6_PRODUTO D4_COD, C6_LOCAL D4_LOCAL, C6_LOTECTL D4_LOTECTL,"
cQuery	+= " SUM("+IF(cTPConfCG="C","C6_X_VCXIM","C6_X_VGRIM") +") C6_QTDVEN,"
cQuery	+= " SUM("+IF(cTPConfCG="C","C6_X_VCXCO","C6_X_VGRCO") +") B2_QATU,"
cQuery	+= IF(cTPConfCG="C","C5_VOLUME1","C5_VOLUME2") +" C5_VOLUME1"
cQuery	+= " FROM "+RetSqlName("SC6")+" C6 "
cQuery  += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C5.D_E_L_E_T_=' ' AND C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery	+= " WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery	+= " AND C6_NUM = '"+cOp+"' "
cQuery	+= " AND C6.D_E_L_E_T_ = '' "
cQuery	+= " AND C6_BLQ = '' "

If cTPConfCG="C"
cQuery	+= " AND C6_X_VCXIM > 0 "
Else
cQuery	+= " AND C6_X_VGRIM > 0 "
Endif

cQuery	+= " GROUP BY C6_NUM, C6_PRODUTO, C6_LOCAL, C6_LOTECTL,"
cQuery	+= IF(cTPConfCG="C","C5_VOLUME1","C5_VOLUME2")
cQuery	+= " ORDER BY 1,2"
*/


cQuery	:= " SELECT"
cQuery	+= " 	ZG_NUM D4_OP, ZG_PRODUTO D4_COD, '01' D4_LOCAL, ' ' D4_LOTECTL,"
cQuery	+= " 	SUM("+IF(cTPConfCG="C","ZG_VCXIM","ZG_VGRIM") +") C6_QTDVEN,"
cQuery	+= " 	SUM("+IF(cTPConfCG="C","ZG_VCXCO","ZG_VGRCO") +") B2_QATU,"
cQuery	+= 	IF(cTPConfCG="C","ZG_VOLUME1","ZG_VOLUME2") +" C5_VOLUME1"
cQuery	+= " FROM SZG010 ZG"
cQuery	+= " WHERE "
cQuery	+= " 	ZG_FILPED = '"+SUBSTR(cOp,1,4)+"'"
cQuery	+= " 	AND ZG_NUM= '"+SUBSTR(cOp,5,6)+"'"
cQuery	+= " 	AND ZG.D_E_L_E_T_ = ''"

If cTPConfCG="C"
	cQuery	+= " 	AND ZG_VCXIM > 0 "
Else
	cQuery	+= " 	AND ZG_VGRIM > 0 "
Endif

cQuery	+= " GROUP BY ZG_NUM, ZG_PRODUTO, ZG_VOLUME1,"
cQuery	+= IF(cTPConfCG="C","ZG_VOLUME1","ZG_VOLUME2")
cQuery	+= " ORDER BY 1,2"
//MemoWrit("C:\AA\BUSCAC6.TXT",cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

If (cAlias)->(!EOF())
	
	// Montagem de aHeader
	vCampos	:= {"D4_COD","C6_QTDVEN","B2_QATU"}
	cQtdVol	:= (cAlias)->C5_VOLUME1
	
	//nQtdVolPL:= 0	// Quantidade de Pallets digitado pelo operador, para sair quantiade de etiquetas conforme definido pelo operador
	
	
	DbSelectArea("SX3")
	SX3->(DBSetOrder(2))
	
	For nVez:=1 To Len(vCampos)
		cCampo:=vCampos[nVez]
		SX3->(DBSeek(cCampo,.F.))
		SX3->(aAdd( aHeader,{	IIF(alltrim(X3_CAMPO)=="B2_QATU","Qtde Conferida",IIF(alltrim(X3_CAMPO)=="C6_QTDVEN","Qtde Volume",X3_TITULO)),X3_CAMPO,X3_PICTURE,IIF(alltrim(X3_CAMPO)=="B1_DESC",50,X3_TAMANHO),X3_DECIMAL,;
		"", X3_USADO,X3_TIPO,,"","",;
		"","",IIF(alltrim(X3_CAMPO)=="D4_LOTECTL",_cVisual:='A',_cVisual:='V'),"",""}))
	Next nVez
	
	(cAlias)->(DBGoTop())
	
	// Compatibiliza numeros e datas
	SX3->(DBSetOrder(2))
	For nVez:=1 to (cAlias)->(FCount())
		cCampo:=(cAlias)->(FieldName(nVez))
		If SX3->(DBSeek(cCampo))
			If Alltrim(upper(SX3->X3_TIPO))$"DN"
				SX3->(TcSetField(cAlias,cCampo,X3_TIPO,X3_TAMANHO,X3_DECIMAL))
			EndIf
			
		EndIf
	next nVez
	
	// Alimenta o Grid.
	SX3->(DBSetOrder(1))
	(cAlias)->(DBGoTop())
	
	While (cAlias)->(!EOF())
		
		SB1->(DbSetOrder(1),DbSeek(xFilial("SB1") + (cAlias)->D4_COD ))
		//SZH->(DbSetOrder(1),DbSeek(xFilial("SZH") + (cAlias)->D4_COD ))
		(cAlias)->(aAdd(aCols, {D4_COD,C6_QTDVEN,B2_QATU,.F.}))
		(cAlias)->(DbSkip())
	Enddo
	
	(cAlias)->(DbCloseArea())
	
	/*
	cQuery	:= " SELECT 'D4' TIPO, C6_NUM D4_OP, C6_PRODUTO D4_COD, C6_LOCAL D4_LOCAL, C6_X_VCXIM C6_QTDVEN, C6_LOTECTL D4_LOTECTL,' ' D4_TRT, C6_LOCAL DC_LOCALIZ "
	cQuery	+= " ,A1_NOME"
	cQuery	+= " FROM "+RetSqlName("SC6")+" C6"
	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" A1 ON C6_CLI=A1_COD AND C6_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' '
	cQuery	+= " WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
	cQuery	+= " AND C6_NUM = '"+cOp+"'
	cQuery	+= " AND C6.D_E_L_E_T_ = '' "
	cQuery	+= " ORDER BY 2,3"
	*/
	
	cQuery	:= " SELECT 'D4' TIPO, ZG_NUM D4_OP, ZG_PRODUTO D4_COD, '01' D4_LOCAL, ZG_VCXIM C6_QTDVEN, ' ' D4_LOTECTL,' ' D4_TRT, '01' DC_LOCALIZ "
	cQuery	+= " ,ZG_NREDUZ A1_NOME, ZG_STAPV, ZG_TLPCC, ZG_ANTEC "
	cQuery	+= " FROM SZG010 ZG"
	cQuery	+= " WHERE "
	cQuery	+= " 	ZG_FILPED + ZG_NUM = '"+cOp+"'"
	cQuery	+= " 	AND ZG.D_E_L_E_T_ = '' "
	cQuery	+= " ORDER BY 2,3"
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)
	
	// Alimenta o Grid.	-> Deixar (Valmir)
	SX3->(DBSetOrder(1))
	
	(cAlias)->(DBGoTop())
	
	cNomeCli := (cAlias)->A1_NOME	//NOME DO CLIENTE
	
	cStatusPV:= (cAlias)->ZG_STAPV //Posicione("SC5",1,xFilial("SC5")+Alltrim(cOp),"C5_X_STAPV")
	ZG_TLPCC := (cAlias)->ZG_TLPCC
	cAnte	 := (cAlias)->ZG_ANTEC
	
	While (cAlias)->(!EOF())
		
		SB1->(DbSetOrder(1),DbSeek(xFilial("SB1") + (cAlias)->D4_COD ))
		//SZH->(DbSetOrder(1),DbSeek(xFilial("SZH") + (cAlias)->D4_COD ))
		
		(cAlias)->(aAdd(aCols2, {D4_COD,SB1->B1_DESC,D4_LOCAL,D4_LOTECTL,DC_LOCALIZ,C6_QTDVEN,D4_TRT,IIF(TIPO=="D4","OK",""),0.00,.F.}))
		//(cAlias)->(aAdd(aCols2, {D4_COD,SZH->ZH_DESC,D4_LOCAL,D4_LOTECTL,DC_LOCALIZ,C6_QTDVEN,D4_TRT,IIF(TIPO=="D4","OK",""),0.00,.F.}))
		
		(cAlias)->(DbSkip())
	Enddo
	(cAlias)->(DbCloseArea())
	
	
	// Ajustes em aSize, permitindo que opere bem em diversas resolucoes, supondo que seja utilizado
	// para dimensionar o dialog principal e um getdados na parte de baixo
	aSize[4] += 5
	aSize[5] := aSize[5]/2+270 // Ajustar o tamanho da Tela (300) alterado para 270.
	
	
	Do Case
		Case cStatusPV == "0"
			cStatus 	:= "PV Gerado"
			
		Case cStatusPV == "1"
			cStatus 	:= "Liberado"
			
		Case cStatusPV == "2"
			cStatus 	:= "Em Separação"
			
		Case cStatusPV == "3"
			cStatus		:= "Sep Finalizada"
			
		Case cStatusPV == "4"
			cStatus		:= "Em Conferência"
			
		Case cStatusPV == "5"
			cStatus		:= "Confer Finalizada"
			
		Case cStatusPV == "6"
			cStatus		:= "Faturado"
			
		Case cStatusPV == "7"
			cStatus		:= "Manif Imp"
			
		Case cStatusPV	== "A"
			cStatus		:= "Antecipado"
			
		Otherwise
			cStatus		:= " "
	EndCase
	
	// Definicao da janela de dialogo para alteracao dos lotes
	Define MsDialog oDlg Title cNomeCliD+" - Separação de Pedido " + Alltrim(cOp) + " - "+cStatus + Space(5)+ "Conferência " + IF(cTPConfCG="C","CAIXA","GRANEL") From 450,0 to 1050,800 /**nFator*/ PIXEL
	
	@ 003,005 Say "PEDIDO" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 015,005 Say oOp Var cOp FONT oFont2 COLOR CLR_BLACK,CLR_RED size 50,10 OF oDlg PIXEL
	
	@ 003,090 Say "CLIENTE - "+cNomeCliD FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 015,095 Say oNomeCli Var cNomeCli size 188,10 FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	
	If cTPConfCG = "C" .AND. cStatus == "4" .AND. ZG_TLPCC == "P" //.AND. SC5->C5_X_STAPV == "4" .AND. SC5->C5_X_TLPCC == "P"
		@ 035,005 Say "CÓD. DE BARRAS" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Else
		@ 035,005 Say "CÓD. DE BARRAS" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,005 Get oCodBar Var cCodBar picture "@!" size 100,11 Valid(aVetDados := SLPCPA22(cCodBar,cProduto,cLote,cLocaliza), cProduto:= PADR(aVetDados[1],nTamB1),cLote:="",cLocaliza:="",POSGETD(cProduto,cLote,cLocaliza), SLPCPA25(cCodBar,cProduto,cLote,oCodBar,cLocaliza),cCodBar:=Space(50),cProduto:=Space(15),cLote:=Space(15),nQtd:=0,cLocaliza:=Space(15) ) FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Endif
	
	IF cTPConfCG="G"
		@ 035,150 Say "QTD. VOLUME PEDIDO" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,150 Get cQtdVol picture "@E 9999" size 10,11 FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Else
		@ 035,130 Say "QTD. VOLUME PALLET" FONT oFont1 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
		@ 047,130 Get cQtdVolDig picture "@E 9999" size 40,11 Valid(Iif(cQtdVolDig > 0.and.lRetornoPlt==.F.,U_LoginPlx(),.T.)) FONT oFont2 COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	Endif
	
	
	//@ 010,300 Button "Etiquetas"	size 55,18 action (IIF(MsgYesNo("Confirma?"),Processa( {|| SLPCPA27(cOp) }, "Aguarde...", "Gerando...",.F.),.F.),oDlg:End()) OF oDlg PIXEL
	
	@ 010,280 Button "Conferir"		size 55,18 action (IIF(MsgYesNo("Confirma a conferência?"),Processa( {|| SLPCPA24(),oDlg:End() }, "Aguarde...", "Liberando Pedido..",.F.),.F.),) OF oDlg PIXEL
	If Empty(cAnte)
		@ 010,340 Button "Conferencia c/ Falta"	size 55,18 action (IIF(MsgYesNo("Confirma a Conferência c/ Falta ?"),Processa( {|| SLPCPA26() }, "Aguarde...", "Gerando Pedido com Saldo...",.F.),.F.),oDlg:End()) OF oDlg PIXEL
	Endif
	@ 035,280 Button "Limpa Conferencia" 	size 55,18 action (IIF(MsgYesNo("Confirma Limpeza na conferência feita até o momento ?"),Processa( {|| SLPCPA30(),oDlg:End() }, "Aguarde...", "Efetuando Limpeza..",.F.),.F.),) OF oDlg PIXEL
	@ 035,340 Button "Fechar" size 55,18 action oDlg:End() // Fecha a Tela
	
	oGetDad:=MsNewGetDados():New(nLinIni,nColIni,nLinFim,nColFim,Nil, _cLinOk:='Allwaystrue()',,,,,_nLimite:=9999,,,lApagaOk:=.f.,oDlg,aHeader,aCols)
	
	nLarg	:= 800//int(aSize[5]*nFator)
	oGetDad:oBrowse:nWidth:=nLarg
	cursorarrow()
	
	//Muda de COR o GRID
	oGetDad:oBrowse:SetBlkBackColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][2] <> oGetDad:aCols[oGetDad:nAt][3], " + Str(CLR_WHITE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] ," + Str(CLR_LIGHTGRAY) + "," + Str(CLR_WHITE) + "))}"))
	oGetDad:oBrowse:SetBlkColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][3]=0, " + Str(CLR_HBLUE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] .or. oGetDad:aCols[oGetDad:nAt][3] > 0," + Str(CLR_GREEN) + "," + Str(CLR_WHITE) + "))}"))
	oGetDad:oBrowse:Refresh()
	
	ACTIVATE MSDIALOG oDlg centered
	
Else
	
	MsgStop("NAO EXISTEM ITENS A SEREM CONFERINDOS NESTE PEDIDO!!!")
	
End If

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ SLPCPA24  | Autor ³ Andre Valmir         ³ Data ³18/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava e gera ETIQUETA                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA24()	// Conferencia

Local cCodUser 		:= RetCodUsr()

SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp /*+ "01"*/))

If SZG->ZG_STAPV == "5"     // Antigo SC5->C5_X_STAPV == "3"
	Tone()
	Alert("ESTE PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, FAVOR SELECIONAR OUTRO PARA CONFERÊNCIA")
	Tone()
	Return
Endif

If cTPConfCG = "C" .AND. SZG->ZG_STAPV == "4" .AND. !Empty(SZG->ZG_TLPCC)
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA DO PEDIDO, "+Alltrim(cOp)+" FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")
	Tone()
	Return
Endif

If cTPConfCG = "G" .AND. SZG->ZG_STAPV == "4" .AND. !Empty(SZG->ZG_TLPCG)
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA DO PEDIDO "+Alltrim(cOp)+",FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")
	Tone()
	Return
Endif


If cTPConfCG="G"
	
	Reclock("SZG",.F.)
	SZG->ZG_VOLUME2 := cQtdVol	//Gravar VOLUME EM GRANEL
	msunlock()
	
	cQuery6 := " UPDATE SZG010 SET ZG_VOLUME2 = "+str(cQtdVol)
	cQuery6 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQuery6)
	
	
	If cQtdVol <= 0
		Tone()
		Aviso("ATENCAO","INFORMAR A QUANTIDADE DE VOLUMES PARA EFETIVAR A GRAVAÇÃO",{"OK"})
		Tone()
		Return
	Else
		
		ValidarQtd()
		SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp /*+ "01"*/))	//Posiciona Novamente
		
		If !lValConfer
			Return
		Endif
		
		If lValConfer .and. Empty(SZG->ZG_CONGR)
			
			Reclock("SZG",.F.)
			SZG->ZG_VOLUME2 := cQtdVol	//Gravar VOLUME EM GRANEL
			SZG->ZG_CONGR := UsrFullName( cCodUser )
			SZG->ZG_DTCGR := Date()
			SZG->ZG_HRCGR := TIME()
			SZG->ZG_TLPCG := "T"
			msunlock()
			
			cQuery7 := " UPDATE SZG010 ZG_VOLUME2= "+LTRIM(str(cQtdVol))+", ZG_CONGR = '"+LEFT(UsrFullName( cCodUser ),30)+"',"
			cQuery7 += "  ZG_DTCGR = '"+DTOS(Date())+"', ZG_HRCGR = '"+LEFT(TIME(),5)+"', ZG_TLPCG='T'"
			cQuery7 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
			TcSqlExec(cQuery7)
			
		Endif
	Endif
	
Else	// Caixa
	
	If Empty(SZG->ZG_DTFSP)
		Tone()
		MSGALERT("ATENÇÃO, FAVOR FINALIZAR A SEPARAÇÃO PARA CONSEGUIR FINALIZAR A CONFERÊNCIA!!!")
		Tone()
		Return
	Endif
	
	
	ValidarQtd()
	SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp /*+ "01"*/))	//Posiciona Novamente
	
	If !lValConfer
		Return
	Endif
	
	
	If lValConfer .and. Empty(SZG->ZG_CONCX)	//****
		CalcVolCX(cOp)
		
		Reclock("SZG",.F.)
		SZG->ZG_VOLUME1 := nQtdVolCX
		SZG->ZG_CONCX := UsrFullName( cCodUser )
		SZG->ZG_DTCCX := Date()
		SZG->ZG_HRCCX := TIME()
		SZG->ZG_TLPCC := "T"
		msunlock()
		
		cQuery7 := " UPDATE SZG010 SET ZG_VOLUME1= "+alltrim(str(nQtdVolCX))+", ZG_CONCX = '"+LEFT(UsrFullName( cCodUser ),30)+"',"
		cQuery7 += "  ZG_DTCCX = '"+DTOS(Date())+"', ZG_HRCCX = '"+LEFT(TIME(),5)+"', ZG_TLPCC='T'"
		cQuery7 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' AND ZG_DTCCX = '' "
		TcSqlExec(cQuery7)
		
	Endif
Endif

// Gerar Pedido das Faltas (Valmir 27/02/2018)
If SZG->ZG_TLPCG == "P" .AND. SZG->ZG_TLPCC == "P"
	//lEtiqGer := .T.
	//	GeraPV()
	
Elseif SZG->ZG_TLPCG == "P" .AND. SZG->ZG_TLPCC == "T"
	//lEtiqGer := .T.
	//	GeraPV()
	
Elseif SZG->ZG_TLPCG == "T" .AND. SZG->ZG_TLPCC == "P"
	//lEtiqGer := .T.
	//	GeraPV()
Endif

SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp /*+ "01"*/))

// Valida Caixa e Granel
If !Empty(SZG->ZG_TLPCG) .and. !Empty(SZG->ZG_TLPCC) //9999!!!!!****
	//	Reclock("SZG",.F.)
	//	SZG->ZG_STAPV := "5"
	//	msunlock()
	
	cQuery8 := " UPDATE SZG010 SET ZG_STAPV = '5' "
	cQuery8 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQuery8)

	lWebSrv := .T.
	//U_WB_LOG10(cOp)

	//???***	//!!!Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9 - Esta no Programa WEbService
	//	cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
	//	cTxtSC9 += " WHERE "
	//	cTxtSC9 += " C9_PEDIDO='"+cOp+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
	//	TcSqlExec(cTxtSC9)
	
Endif

// Validar se e somente Granel
IF SZG->ZG_TLNCX = 0 .AND. SZG->ZG_TLNGR > 0
	//	Reclock("SZG",.F.)
	//	SZG->ZG_STAPV := "5"
	//	msunlock()
	
	cQuery9 := " UPDATE SZG010 SET ZG_STAPV = '5' "
	cQuery9 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQuery9)

	lWebSrv := .T.
	//U_WB_LOG10(cOp)
	
	
	//???***	//!!!Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9 - Esta no Programa WEbService
	//	cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
	//	cTxtSC9 += " WHERE "
	//	cTxtSC9 += " C9_PEDIDO='"+cOp+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
	//	TcSqlExec(cTxtSC9)
	
Endif

// Validar se e somente Caixa
IF SZG->ZG_TLNCX > 0 .AND. SZG->ZG_TLNGR = 0
	//	Reclock("SZG",.F.)
	//	SZG->ZG_STAPV := "5"
	//	msunlock()
	
	cQueryA := " UPDATE SZG010 SET ZG_STAPV = '5' "
	cQueryA += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQueryA)

	lWebSrv := .T.
	//U_WB_LOG10(cOp)
	
	
	//???***	//!!!Andre Salgado (21/03/18) - Melhoria para garantir que vai liberar 100% o SC9  - Esta no Programa WEbService
	//	cTxtSC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
	//	cTxtSC9 += " WHERE "
	//	cTxtSC9 += " C9_PEDIDO='"+cOp+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
	//	TcSqlExec(cTxtSC9)
	
Endif

//Imprimir ETIQUETA

nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )

//lValConfer := .T.
if nOpc = 1 .AND. !lGerEtiq
	SLPCPA27(cOp)
Endif


/*
//Atualiza Dados do Pedido de Venda
*/


Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ SLPCPA22  | Autor ³ Andre Valmir         ³ Data ³18/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tratamento do array com os lotes X array da separacao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SLPCPA22(cCodBar,cProduto,cLote,cLocaliza)

Local aVetDados := {}

aVetDados := Separa(UPPER(Alltrim(cCodBar)),"}",.T.)

If Empty(cCodBar) .OR. Len(Alltrim(cCodBar)) < 6   // Valmir (22/03/2018)
	
	aVetDados := {"","",""}
	
ElseIf LEFT(cCodBar,3) $ ('PR-/AC-') .and. cTPConfCG = "G"
	
	If SB1->(DbSetOrder(1), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)),.F. ))
	//If SZH->(DbSetOrder(1), DbSeek( xFilial("SZH")+UPPER(Alltrim(cCodBar)),.F. ))
		aVetDados := {}
		AADD(aVetDados, SB1->B1_COD) //SZH->ZH_COD)
		AADD(aVetDados, substr(cCodBar,8,15))
		AADD(aVetDados, "")
	EndIf
	
Else
	
	IF cTPConfCG="C" //?"CAIXA"	- Tipo de Codigo de Barras DUM14 - Controlado no sistema -> B1_CODBAR
		If SB1->(DbSetOrder(5), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)),.F. ))
		//If SZH->(DbSetOrder(3), DbSeek( xFilial("SZH")+UPPER(Alltrim(cCodBar)),.F. ))
			aVetDados := {}
			AADD(aVetDados, SB1->B1_COD ) //SZH->ZH_COD)
			AADD(aVetDados, substr(cCodBar,8,15))
			AADD(aVetDados, "")
		EndIf
		
	Else	//?"GRANEL"	- Tipo de Codigo de Barras EAN13 - Controlado no sistema -> B1_X_EAN13 , foi criado indice (SB1 - Order 13)
		If SB1->(DbSetOrder(13), DbSeek( xFilial("SB1")+UPPER(Alltrim(cCodBar)),.F. ))
		//If SZH->(DbSetOrder(2), DbSeek( xFilial("SZH")+UPPER(Alltrim(cCodBar)),.F. ))
			aVetDados := {}
			AADD(aVetDados, SB1->B1_COD) //ZH->ZH_COD)
			AADD(aVetDados, substr(cCodBar,8,15))
			AADD(aVetDados, "")
		EndIf
	Endif
	
End If

Return aVetDados

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA26   | Autor ³ Andre Valmir        ³ Data ³17/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar Pedido de Venda Sobre o SALDO de Produto nao Entregue³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA26 // Conferencia com falta

//Variaveis - ExecAuto PEDIDO DE VENDA

//Local _cENTER   := "CHR(13)+CHR(10)"
Local ContX			:= 0
Local ContX1		:= 0
Local ContG			:= 0
Local ContG1		:= 0
Local cCodUser 		:= RetCodUsr()

//SZG->(DbSetOrder(1),DbSeek(Alltrim(cOp) )) //DbSeek(xFilial("SC5") + Alltrim(cOp) ))
SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp /*+ "01"*/))

If SZG->ZG_STAPV == "5"     // Antigo SC5->C5_X_STAPV == "3"
	Tone()
	Alert("ESTE PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, FAVOR SELECIONAR OUTRO PARA CONFERÊNCIA")
	Tone()
	Return
Endif

If cTPConfCG = "C" .AND. Empty(SZG->ZG_DTFSP)
	Tone()
	Alert("ATENÇÃO, FAVOR FINALIZAR A SEPARAÇÃO PARA CONSEGUIR FINALIZAR A CONFERÊNCIA!!!")
	Tone()
	Return
Endif

If cTPConfCG = "C" .AND. SZG->ZG_STAPV == "4" .AND. SZG->ZG_TLPCC == "P"
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA COM FALTA DO PEDIDO, "+Alltrim(cOp)+" FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")
	Tone()
	Return
Endif

If cTPConfCG = "G" .AND. SZG->ZG_STAPV == "4" .AND. SZG->ZG_TLPCG == "P"
	Tone()
	MSGALERT("ATENÇÃO, JÁ FOI FEITO CONFERÊNCIA COM FALTA DO PEDIDO "+Alltrim(cOp)+",FAVOR SELECIONAR OUTRO PEDIDO PARA CONFERÊNCIA")
	Tone()
	Return
Endif


For i = 1 to Len(aCols)
	If oGetDad:ACOLS[i][2] = 0
		lVazio := .T.
	Else
		lVazio := .F.
		nQtd++
	Endif
Next i

If nQtd > 0
	lVazio := .F.
Endif

//"01"
//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + Alltrim(cOp)+cItem ))
DBSelectarea("SZG")
//DBSetOrder(1)
//DbgoTop()
//DbSeek(Alltrim(cOp)) // )) xFilial("SZG")+Alltrim(cOp))
DBSetOrder(2)
DbgoTop()
DBSeek(xFilial("SZG") + cOp /*+ "01"*/)


While SZG->(!eof()) .AND. SZG->(ZG_FILPED+ZG_NUM) = Alltrim(cOp)
	
	// Validar Caixa
	If SZG->ZG_VCXCO > 0
		ContX++
	Else
		ContX1++
	Endif
	
	// Validar Granel
	If SZG->ZG_VGRCO > 0
		ContG++
	Else
		ContG1++
	Endif
	
	SZG->(dbskip())
	
Enddo

// ContG != 0 Para poder gerar pedido com caixa ok, e granel 100% com falta.
If cQtdVol<=0 .and. cTPConfCG = "G" .AND. ContG != 0
	Tone()
	Aviso("ATENCAO","INFORMAR A QUANTIDADE DE VOLUMES PARA EFETIVAR A GRAVAÇÃO",{"OK"})
	Tone()
	Return
Endif


//Solicitar TROCA SENHA PARA PROCESSAR
If !lVazio
	If ContX > 0 .or. ContG >0
		U_zLoginZ() //cUsrLog, cPswLog)
	Else
		Tone()
		Alert("NÃO É POSSIVEL EFETIVAR A CONFERÊNCIA COM FALTA DEVIDO CAIXA/GRANEL ESTAREM TODOS ZERADOS!!!")
		Tone()
		Return
	Endif
Else
	Tone()
	Alert("PEDIDO NÃO LIBERADO PARA CONFERÊNCIA, FAVOR FAZER A IMPRESSÃO DA ORDEM DE SEPARAÇÃO!!!")
	Tone()
	Return
Endif

If lGerPed

	DBSelectarea("SZG")
	DBSetOrder(2)
	DbgoTop()
	DBSeek(xFilial("SZG") + cOp /*+ "01"*/)
	
	reclock("SZG",.F.)
	
	If cTPConfCG = "G"
		SZG->ZG_VOLUME2 := cQtdVol	//Gravar VOLUME EM GRANEL
        //========================================================================//
        // Valmir (20/08/20)
        cQuery12 := " UPDATE SZG010 SET ZG_VOLUME2 = "+str(cQtdVol)			
		cQuery12 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
		TcSqlExec(cQuery12)
        //========================================================================//
	Endif
	
	IF cTPConfCG = "C"
		CalcVolCX(cOp)
		If Empty(SZG->ZG_TLPCC)
			SZG->ZG_VOLUME1 := nQtdVolCX
			SZG->ZG_TLPCC	:= "P"
			SZG->ZG_CONCX 	:= UsrFullName( cCodUser )
			SZG->ZG_DTCCX 	:= Date()
			SZG->ZG_HRCCX 	:= TIME()
		Endif

		cQuery10 := " UPDATE SZG010 SET ZG_VOLUME1= "+alltrim(str(nQtdVolCX))+", ZG_CONCX = '"+LEFT(UsrFullName( cCodUser ),30)+"',"
		cQuery10 += "  ZG_DTCCX = '"+DTOS(Date())+"', ZG_HRCCX = '"+LEFT(TIME(),5)+"', ZG_TLPCC='P'"
		cQuery10 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' AND ZG_DTCCX = '' "
		TcSqlExec(cQuery10)


	Else
		If Empty(SZG->ZG_TLPCG)
			SZG->ZG_TLPCG	:= "P"
			SZG->ZG_CONGR 	:= UsrFullName( cCodUser )
			SZG->ZG_DTCGR 	:= Date()
			SZG->ZG_HRCGR 	:= TIME()
		Endif

		cQuery11 := " UPDATE SZG010 ZG_VOLUME2= "+alltrim(str(cQtdVol))+", ZG_CONGR = '"+LEFT(UsrFullName( cCodUser ),30)+"',"
		cQuery11 += "  ZG_DTCGR = '"+DTOS(Date())+"', ZG_HRCGR = '"+LEFT(TIME(),5)+"', ZG_TLPCG='P'"
		cQuery11 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
		TcSqlExec(cQuery11)

	Endif
	
	msunlock()
	
Else
	Return
Endif

If !Empty(SZG->ZG_TLPCC) .and. !Empty(SZG->ZG_TLPCG)
	//	reclock("SZG",.F.)
	//	SZG->ZG_STAPV := "5"
	//	msunlock()
	
	cQueryB := " UPDATE SZG010 SET ZG_STAPV = '5' "
	cQueryB += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQueryB)

	lWebSrv := .T.
	//U_WB_LOG10(cOp)
	
	
	//	GeraPV()	// Valmir (06/02/2018)
Endif


//SZG->(DbSetOrder(1),DbSeek(Alltrim(cOp) ))  //DbSeek(xFilial("SC5") + cOp ))
SZG->(DbSetOrder(2),DbSeek(xFilial("SZG") + cOp /*+ "01"*/))

// Gerar Pedido das Faltas Caixa
If Empty(SZG->ZG_TLPCG) .AND. SZG->ZG_TLPCC == "P" .AND. SZG->ZG_TLNCX > 0 .AND. SZG->ZG_TLNGR = 0
	//	reclock("SZG",.F.)
	//	SZG->ZG_STAPV := "5"
	//	msunlock()
	cQueryC := " UPDATE SZG010 SET ZG_STAPV = '5' "
	cQueryC += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQueryC)

	lWebSrv := .T.
	//U_WB_LOG10(cOp)
	
	//	GeraPV()
	// Gerar Pedido das Faltas Granel
Elseif Empty(SZG->ZG_TLPCC) .AND. SZG->ZG_TLPCG == "P" .AND. SZG->ZG_TLNCX = 0 .AND. SZG->ZG_TLNGR > 0
	//	reclock("SZG",.F.)
	//	SZG->ZG_STAPV := "5"
	//	msunlock()
	
	cQueryD := " UPDATE SZG010 SET ZG_STAPV = '5' "
	cQueryD += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQueryD)
	
	lWebSrv := .T.
	//U_WB_LOG10(cOp)
	//	GeraPV()
Endif

nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )

//lValConfer := .T.
if nOpc = 1 .AND. !lGerEtiq
	SLPCPA27(cOp)
Endif

Return()



//GERA PEDIDO QUANDO TIVER FALTA DE PRODUTO
Static Function GeraPV()

/*
//Busca o SALDO do PEDIDO
cQuerySaldo := " SELECT"
cQuerySaldo += " C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_LOJAENT, C5_CONDPAG,"
cQuerySaldo += " C6_PRODUTO, C6_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * C6_X_VCXCO)+C6_X_VGRCO) SALDO_C6, C6_PRCVEN, C6_PRUNIT, C6_TES, C6_NUM"
cQuerySaldo += " FROM "+RetSqlName("SC5")+" C5"
cQuerySaldo += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_=' '"
cQuerySaldo += " INNER JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO= B1_COD AND B1.D_E_L_E_T_=' ' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuerySaldo += " WHERE C5.D_E_L_E_T_=' '"
cQuerySaldo += " AND C6_FILIAL = '"+xFilial("SC6")+"' "
cQuerySaldo += " AND C5_NUM = '"+cOp+"'"
cQuerySaldo += " AND C6_BLQ = ' '"
cQuerySaldo += " AND C6_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * C6_X_VCXCO)+C6_X_VGRCO) > 0 "
//cQuerySaldo += " AND (C6_X_VCXIM+C6_X_VGRIM) <> (C6_X_VCXCO+C6_X_VGRCO) " // ADICIONADO GENILSON LUCAS
cQuerySaldo += " ORDER BY C6_PRODUTO"
*/

//Busca o SALDO do PEDIDO
cQuerySaldo := " SELECT"
cQuerySaldo += " ZG_NUM C5_NUM, ZG_CLIENTE C5_CLIENTE, ZG_LOJA C5_LOJACLI, ZG_LOJA C5_LOJAENT, '000' C5_CONDPAG,"
//cQuerySaldo += " ZG_PRODUTO, ZG_QTDVEN-((CASE WHEN ZH_QE=0 THEN 1 ELSE ZH_QE END * ZG_VCXCO)+ZG_VGRCO) SALDO_C6, 0 C6_PRCVEN, 0 C6_PRUNIT, ' ' C6_TES, ZG_NUM C6_NUM"
cQuerySaldo += " ZG_PRODUTO, ZG_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * ZG_VCXCO)+ZG_VGRCO) SALDO_C6, 0 C6_PRCVEN, 0 C6_PRUNIT, ' ' C6_TES, ZG_NUM C6_NUM"
cQuerySaldo += " FROM SZG010 ZG"
cQuerySaldo += " INNER JOIN SB1010 B1 ON ZG_PRODUTO= B1_COD AND B1.D_E_L_E_T_=' ' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuerySaldo += " WHERE ZG.D_E_L_E_T_=' '"
cQuerySaldo += " AND ZG_FILPED + ZG_NUM = '"+cOp+"'"
//cQuerySaldo += " AND ZG_QTDVEN-((CASE WHEN ZH_QE=0 THEN 1 ELSE ZH_QE END * ZG_VCXCO)+ZG_VGRCO) > 0 "
cQuerySaldo += " AND ZG_QTDVEN-((CASE WHEN B1_QE=0 THEN 1 ELSE B1_QE END * ZG_VCXCO)+ZG_VGRCO) > 0 "
cQuerySaldo += " ORDER BY C6_PRODUTO"

If Select("TRB1") > 0
	TRB1->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuerySaldo),"TRB1", .F., .T.)
TCSETFIELD("TRB1","SALDO_C6"	,"N",16,2)  //Quantidade
TCSETFIELD("TRB1","C6_PRCVEN"	,"N",16,4)  //Valor Unitario


dbSelectArea("TRB1")
While !EOF() .AND.  TRB1->C5_NUM = cOp
	
	//Prepara o Cabecalho do Pedido de Venda  (SC5)
	If 	lgravaCAB
		cDoc	:= GetSxeNum("SC5","C5_NUM")
		RollBAckSx8()
		
		aadd(aCabec,{"C5_NUM"		,cDoc		,Nil})
		aadd(aCabec,{"C5_TIPO"		,"N"		,Nil})
		aadd(aCabec,{"C5_CLIENTE"	,TRB1->C5_CLIENTE,Nil})
		aadd(aCabec,{"C5_LOJACLI"	,TRB1->C5_LOJACLI,Nil})
		aadd(aCabec,{"C5_LOJAENT"	,TRB1->C5_LOJAENT,Nil})
		aadd(aCabec,{"C5_CONDPAG"	,TRB1->C5_CONDPAG,Nil})
		aadd(aCabec,{"C5_MENNOTA"	,"SALDO PEDIDO VENDA "+LEFT(cOp,6)	,Nil})
		aadd(aCabec,{"C5_PESOL"		,1 			,Nil})
		lgravaCAB := .F.
	Endif
	
	
	//Prepara o ITEM do Pedido de Venda  (SC6)
	Dbselectarea("SB1")
	DbSetOrder(1)
	Dbseek(xFilial("SB1")+TRB1->C6_PRODUTO)
	IF SB1->B1_X_MSBLQ <> '1'
		nSeqIPV ++					 //Sequencial do Item
		
		aLinha := {}
		aadd(aLinha,{"C6_ITEM"		,StrZero(nSeqIPV,2)			,Nil})
		aadd(aLinha,{"C6_PRODUTO"	,TRB1->C6_PRODUTO			,Nil})
		aadd(aLinha,{"C6_QTDVEN"	,TRB1->SALDO_C6				,Nil})
		aadd(aLinha,{"C6_PRCVEN"	,Round(TRB1->C6_PRCVEN,4)	,Nil})
		aadd(aLinha,{"C6_PRUNIT"	,Round(TRB1->C6_PRUNIT,4)	,Nil})
		aadd(aLinha,{"C6_TES"		,TRB1->C6_TES				,Nil})
		aadd(aLinha,{"C6_NUM"		,cDoc						,Nil})
		aadd(aItens,aLinha)
		
	Endif
	
	dbSelectArea("TRB1")
	dbSkip()
	
Enddo

//****************************************************************
//* Inclusao - PEDIDO DE VENDA (EXECAUTO)
//****************************************************************
if !lgravaCAB
	ALERT("1 - ANALISE ESTE PARTE !!! - NAO SERA PROCESSO AQUI NA LOGISTICA")
	
	// Atualiza pedido de vendas Original
	SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + Padr(cOp,6)))
	
	While SC6->(!eof()) .and. SC6->C6_NUM=Padr(cOp,6)
		
		//If SC6->(C6_X_VCXIM+C6_X_VGRIM) <> SC6->(C6_X_VCXCO+C6_X_VGRCO)
		cProduto := SC6->C6_PRODUTO
		
		cTxtUpdate += " UPDATE "+RetSqlName("SC6")+" SET C6_OP=' ', C6_QTDEMP=0, C6_QTDEMP2=0,"
		
		cTxtUpdate += " C6_OK  = CASE WHEN (C6_X_VCXIM+C6_X_VGRIM)>0 AND (C6_X_VCXCO+C6_X_VGRCO)<= 0 THEN '1O'"
		cTxtUpdate += "              WHEN (C6_X_VCXIM+C6_X_VGRIM)=(C6_X_VCXCO+C6_X_VGRCO) THEN ' ' ELSE '1O' END,"
		
		cTxtUpdate += " C6_BLQ = CASE WHEN (C6_X_VCXIM+C6_X_VGRIM)>0 AND (C6_X_VCXCO+C6_X_VGRCO)<= 0 THEN 'R'"
		cTxtUpdate += "               WHEN (C6_X_VCXIM+C6_X_VGRIM)=(C6_X_VCXCO+C6_X_VGRCO) THEN ' ' ELSE 'R' END,"
		
		cTxtUpdate += " C6_QTDLIB = C6_X_VGRCO+(C6_X_VCXCO*B1_QE), C6_QTDLIB2 = C6_X_VGRCO+(C6_X_VCXCO*B1_QE)  "
		
		cTxtUpdate += " FROM "+RetSqlName("SC6")+ " C6 LEFT JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO = B1_COD AND B1.D_E_L_E_T_ = ''
		cTxtUpdate += " WHERE "
		cTxtUpdate += " C6_NUM='"+cOp+"' AND C6_FILIAL='"+xFilial("SC6")+"' AND C6_PRODUTO='"+cProduto+"'"
		//EndIf
		
		SC6->(dbskip())
		
	Enddo
	
	TcSqlExec(cTxtUpdate)
	
	/*** Valmir***/
	// "01"
	//SC9->(DbSetOrder(1),DbSeek(xFilial("SC9") + Padr(cOp,6) + "01" ))
	DBSelectArea("SC9")
	DBSetOrder(1)
	DBGotop()
	DBSeek(xFilial("SC9")+Alltrim(cOp))
	
	While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cOp)
		
		SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp+SC9->(C9_ITEM+C9_PRODUTO)))
		
		If SC6->C6_QTDLIB > 0
			RecLock("SC6",.F.)
			SC6->C6_QTDEMP 	:= SC6->C6_QTDLIB
			SC6->C6_QTDEMP2	:= SC6->C6_QTDLIB2
			SC6->( MsUnLock() )
		Endif
		
		
		If SC6->C6_QTDLIB = 0
			RecLock("SC9",.F.)
			SC9->(dbDelete())
			SC9->( MsUnLock() )
		Else
			RecLock("SC9",.F.)
			SC9->C9_QTDLIB 	:= SC6->C6_QTDLIB
			SC9->C9_QTDLIB2 := SC6->C6_QTDLIB
			SC9->C9_BLEST	:= ""
			//SC9->C9_BLCRED 	:= ""
			SC9->( MsUnLock() )
		Endif
		
		SC9->(dbskip())
		
	Enddo
	/*
	SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cOp ))
	Reclock("SC5",.F.)
	SC5->C5_X_STAPV := "5"
	msunlock()
	*/
	//GERA PEDIDO DE VENDA COM SALDO - NECESSÁRIO 1 PRODUTO
	If Len(aItens) > 0
		MATA410(aCabec,aItens,3)	//FUNCAO PADRAO TOTVS PARA CRIACAO PEDIDO DE VENDA
		
		If !lMsErroAuto
			MsgInfo("PEDIDO COM SALDO "+Alltrim(cDoc)+" GERADO COM SUCESSO!","ATENCAO!")
		Else
			lMostraErro	:= .T.
			Mostraerro()
			
			cPara	 := 'asalgado@introde.com.br' //genilson.lucas@salonline.com.br; asilva@introde.com.br'
			cAssunto := 'PEDIDO COM FALTA NÃO GERADO'
			cBody	 := 'Pedido '+ xFilial("SC5") + ' - ' + Alltrim(cOp) + ' não gerou saldo, favor verificar!'
			U_SendMail( cPara, '', '', cAssunto, cBody,'' )
		EndIf
	EndIf
	
	//Funcao para Gravar e gerar Etiqueta
	
	SLPCPA27(cOp)
	lGerEtiq := .T.
	
Endif

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA27   | Autor ³ Andre Valmir        ³ Data ³18/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza Impressão da Etiqueta                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA27(cOp)

Private cTipoimp	:= cTPConfCG //"C","G")	//Tipo de Conferencia Caixa/Granel     //"CX"	// Tipo de Impressao (Caixa / Granel )

//Transfere o Saldo do Estoque Conferido para Local "Z1" - Expedição
If cTrans01Z1="S"
	U_WB_LOG13(cOp)
Endif


//Envia informação para WebService - Distribuidora
If lWebSrv 
	U_WB_LOG10(cOp)
	lWebSrv := .F.
Endif


//Imprime Etiqueta
Processa({|X| lEnd := X, ImpEtiq()})

RETURN(.T.)


//*****************************************************************************
Static Function ImpEtiq()
//*****************************************************************************

Private nDes	:= 0  // Deslocamento
//Private cQuery	:= ""
Private cContem		:= ""
Private	cCXGR		:= ""
Private cSigla		:= ""

#xtranslate :HAETTENSCHWEILER_16           => \[1\]
#xtranslate :ARIAL_NARROW_14_NEGRITO        => \[2\]
#xtranslate :ARIAL_BLACK_54_NEGRITO        => \[3\]
#xtranslate :CENTURY_GOTHIC_10_NEGRITO     => \[4\]
#xtranslate :CENTURY_GOTHIC_11_NEGRITO     => \[5\]
#xtranslate :CENTURY_GOTHIC_12_NEGRITO     => \[6\]
#xtranslate :CENTURY_GOTHIC_14_NEGRITO     => \[7\]
#xtranslate :ARIAL_09             => \[8\]
#xtranslate :ARIAL_10             => \[9\]
#xtranslate :ARIAL_12             => \[10\]
#xtranslate :ARIAL_18             => \[11\]
#xtranslate :ARIAL_10_NEGRITO     => \[12\]
#xtranslate :ARIAL_12_NEGRITO     => \[13\]
#xtranslate :ARIAL_14_NEGRITO     => \[14\]
#xtranslate :ARIAL_14_NEGRITO     => \[15\]
#xtranslate :ARIAL_14_NEGRITO     => \[16\]
#xtranslate :ARIAL_40_NEGRITO     => \[17\]
#xtranslate :ARIAL_60_NEGRITO     => \[18\]

AVPRINT oPrn NAME "Etiqueta"

oFont1 := oSend(TFont(),"New","HAETTENSCHWEILER" ,0,16,,.F.,,,,,,,,,,,oPrn )
oFont2 := oSend(TFont(),"New","Arial NARROW" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont3 := oSend(TFont(),"New","Arial BLACK" ,0,54,,.T.,,,,,,,,,,,oPrn )

oFont4 := oSend(TFont(),"New","Century Gothic" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont5 := oSend(TFont(),"New","Century Gothic" ,0,11,,.T.,,,,,,,,,,,oPrn )
oFont6 := oSend(TFont(),"New","Century Gothic" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont7 := oSend(TFont(),"New","Century Gothic" ,0,14,,.T.,,,,,,,,,,,oPrn )

oFont8  := oSend(TFont(),"New","Arial" ,0,09,,.F.,,,,,,,,,,,oPrn )
oFont9  := oSend(TFont(),"New","Arial" ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont10 := oSend(TFont(),"New","Arial" ,0,12,,.F.,,,,,,,,,,,oPrn )
oFont11 := oSend(TFont(),"New","Arial" ,0,18,,.F.,,,,,,,,,,,oPrn )

oFont12 := oSend(TFont(),"New","Arial" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont13 := oSend(TFont(),"New","Arial" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont14 := oSend(TFont(),"New","Arial" ,0,13,,.T.,,,,,,,,,,,oPrn )
oFont15 := oSend(TFont(),"New","Arial" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont16 := oSend(TFont(),"New","Arial" ,0,24,,.T.,,,,,,,,,,,oPrn )
oFont17 := oSend(TFont(),"New","Arial" ,0,40,,.T.,,,,,,,,,,,oPrn )
oFont18 := oSend(TFont(),"New","Arial" ,0,60,,.T.,,,,,,,,,,,oPrn )

aFontes := {oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8,;
oFont9, oFont10, oFont11, oFont12, oFont13, oFont14, oFont15, oFont16, oFont17, oFont18  }

oBrush	:= TBrush():New(,4)

oPrn:SetPortrait()  // SetLandscape()

DbSelectArea("SZG")
DbSetOrder(2)
DbSeek(xFilial("SZG") + cOp /*+ "01"*/)

If Found()
	cNomCli		:=	SZG->ZG_NREDUZ	//Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME"))
	cTabTransp	:=	SZG->ZG_ECSERVI	//Alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_ECSERVI"))
	cNomTransp	:=	SZG->ZG_NREDUZT	//Alltrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NREDUZ"))
	cMun		:=	SZG->ZG_MUN		//Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_MUN"))
	cUF 		:=	SZG->ZG_EST		//Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_EST"))
	cCEP		:= 	SZG->ZG_CEP		//Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_CEP"))
	
	//### 21/09/20 Valmir - Gravar Sigla
	cSigla		:=  SZG->ZG_SIGLA

	If SZG->ZG_TLNCX > 0 .AND. SZG->ZG_TLNGR > 0
		cContem	:= "CONTEM"
		cCXGR	:= "CX/GR"
	Endif
	
	Imprime()
Endif


oSend(oFont1,"End")
oSend(oFont2,"End")
oSend(oFont3,"End")
oSend(oFont4,"End")
oSend(oFont5,"End")
oSend(oFont6,"End")
oSend(oFont7,"End")
oSend(oFont8,"End")
oSend(oFont9,"End")
oSend(oFont10,"End")
oSend(oFont11,"End")
oSend(oFont12,"End")
oSend(oFont13,"End")
oSend(oFont14,"End")
oSend(oFont15,"End")
oSend(oFont16,"End")
oSend(oFont17,"End")
oSend(oFont18,"End")

//AVENDPRINT
MS_Flush()
oPrn:Preview()
//oPrn:Print()
oPrn:End()

Return() // ImpEtiq()


//*****************************************************************************
Static Function Imprime()
//*****************************************************************************

nQtdEtiCX := SZG->ZG_VOLUME1
nQtdEtiGR := SZG->ZG_VOLUME2


If cTipoimp == "C"	//CAIXA
	For nCx:=1 to nQtdEtiCX
		ImpDet(nCx)
	Next
Endif

//	cTipoimp := "GR"

If cTipoimp == "G"	//GRANEL
	For nGr:=1 to nQtdEtiGR
		ImpDet(nGr)
	Next
Endif


Return() // Imprime()


//*****************************************************************************
Static Function ImpDet(nNumEtiq)
//*****************************************************************************

Private cTexto	:= ""
Private	cStartPath	:= GetSrvProfString('Startpath','')//,;
Private lGrvDt		:= GETMV("ES_ESTP015")

//AVPAGE

cPedForn := LEFT(cOp,4)
IF cPedForn="0101"
	xFilNome:= "CIMEX"
ElseIF cPedForn="0201"
	xFilNome:= "CROZE"
ElseIF cPedForn="0301"
	xFilNome:= "KOPEK"
ElseIF cPedForn="0401"
	xFilNome:= "MACO"
ElseIF cPedForn="0501"
	xFilNome:= "QUBIT"
ElseIF cPedForn="0601"
	xFilNome:= "ROJA"
ElseIF cPedForn="0701"
	xFilNome:= "VIXEN"
ElseIF cPedForn="0801"
	xFilNome:= "MAIZE"
ElseIF cPedForn="0901"
	xFilNome:= "DEVINTEX"
ElseIF cPedForn="0902"
	xFilNome:= "DEVINTEX"
ELSE
	xFilNome:= cPedForn
ENDIF

cTexto := xFilNome
oPrn:Say(nLin(0.3), nCol(0.4),cTexto,oFont16)

If lGrvDt

	//### 25/09/20 - Conforme E-mail do Jose (Gestão de Fretes)
	oPrn:Say(nLin(0.3), nCol(3.65),"Emissao",oFont12)
	oPrn:Say(nLin(0.6), nCol(3.5),DTOC(DDATABASE),oFont12)
	oPrn:Say(nLin(0.9), nCol(3.85),Left(Time(),5),oFont12)

Endif

If cTipoimp == "C"
	cTexto	:= Substr(cOp,5,6)+";"+cTipoimp+";"+ alltrim(Transform(nCx,"@E 9999"))
	MSBAR("EAN128", 0.3, 5.20, cTexto, oPrn, .F.,,.T., 0.025,0.80 ,.F.,,, .F. )
Else
	cTexto	:= Substr(cOp,5,6)+";"+cTipoimp+";"+ alltrim(Transform(nGr,"@E 9999"))
	MSBAR("EAN128", 0.3, 5.20, cTexto, oPrn, .F.,,.T., 0.025,0.80 ,.F.,,, .F. )
EndIf

cTexto := "PV: " + Substr(cOp,5,6)
oPrn:Say(nLin(1.3), nCol(0.4),cTexto,oFont15)

If cTipoimp == "C"
	
	If nQtdEtiCX > 9999	// Valmir (23/11/2018)
		cTexto := "CX: " +Padl(nCx,5,"0")+"/"+Padl(nQtdEtiCX,5,"0")
		oPrn:Say(nLin(1.3), nCol(3.9),cTexto,oFont15)
	Else
		cTexto := "CX: " +Padl(nCx,4,"0")+"/"+Padl(nQtdEtiCX,4,"0")
		oPrn:Say(nLin(1.3), nCol(3.9),cTexto,oFont15)
	Endif
	
Else
	If nQtdEtiGR > 9999	// Valmir (23/11/2018)
		cTexto := "GR: " +Padl(nGr,5,"0")+"/"+Padl(nQtdEtiGR,5,"0")
		oPrn:Say(nLin(1.3), nCol(3.9),cTexto,oFont15)
	Else
		cTexto := "GR: " +Padl(nGr,4,"0")+"/"+Padl(nQtdEtiGR,4,"0")
		oPrn:Say(nLin(1.3), nCol(3.9),cTexto,oFont15)
	Endif
	
Endif

cTexto := cContem
oPrn:Say(nLin(1.1), nCol(7.0),cTexto,oFont14)		//### Valmir 25/09/2020 nLin(1.0)

cTexto := cCXGR
oPrn:Say(nLin(1.4), nCol(7.2),cTexto,oFont14)



//cTexto := "TRANSP.: " + cNomTransp
cTexto := cNomTransp
oPrn:Say(nLin(2.0), nCol(0.4),cTexto,oFont15)
/*     VALMIR (16/05/19)
If !Empty(cTabTransp) //Codigo da tabela da transportadora

cQuery	:= " SELECT * FROM " + RetSqlName("SZ3") + " WITH(NOLOCK)  "
cQuery	+= " WHERE Z3_EMPRESA = '"+cTabTransp+"' AND "
cQuery	+= " Z3_CEP_INI <= '"+cCEP+"' AND Z3_CEP_FIN >= '"+cCEP+"' "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSZ3",.T.,.T.)

cTexto 	:= " ( "+ alltrim(TMPSZ3->Z3_SIGLA)
If !Empty(TMPSZ3->Z3_SETOR)
cTexto	+=" - "+ alltrim(TMPSZ3->Z3_SETOR) + " )"
Else
cTexto	+= " )"
EndIf
oPrn:Say(nLin(1.8), nCol(5.5),cTexto,oFont16)

TMPSZ3->(DbCloseArea())
EndIf
*/
//cTexto := "CLIENTE: " + Substr(cNomCli,1,25)
cTexto := Substr(cNomCli,1,25)
oPrn:Say(nLin(2.7), nCol(0.4),cTexto,oFont15)

cTexto := Alltrim(cMun) + Space(4) + cUF 
oPrn:Say(nLin(3.4), nCol(0.4),Alltrim(cTexto),oFont15)

//### 25/09/2020 Valmir
cTexto :=  "( "+Alltrim(cSigla)+" )"
oPrn:Say(nLin(3.1), nCol(6.5),Alltrim(cTexto),oFont16)

oPrn:EndPage()

Return() // ImpDet()


//*****************************************************************************
Static Function nLin(nVal)
//*****************************************************************************

Local nRet

nRet := (300/2.54) * (nVal + nDes)

Return(nRet)  // nLin()


//*****************************************************************************
Static Function nCol(nVal)
//*****************************************************************************

Local nRet

nRet := (300/2.54) * (nVal)

Return(nRet)  // nCol()


RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//User Function	ImpEtqP()

//Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ SLPCPA30   | Autor ³ Andre Valmir        ³ Data ³21/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpa Conferencia							              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SLPCPA30()

//Local lRet := .T.
//Preparar para gravar no SC6 *** - Gravar em Tempo REAL
DBSelectArea("SZG")
DBSetOrder(2)
DBSeek(xFilial("SZG") + cOp /*+ "01"*/)

If SZG->ZG_STAPV <> "4"
	
	Tone()
	MsgAlert("PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, NÃO SENDO POSSÍVEL LIMPAR A CONFERÊNCIA","ATENÇÃO")
	Tone()
	Return()
	
ElseIf (cTPConfCG="C" .and.!Empty(SZG->ZG_TLPCC)) .or. ;
	(cTPConfCG="G" .and.!Empty(SZG->ZG_TLPCG) )
	
	Tone()
	MsgAlert("PEDIDO "+Alltrim(cOp)+" JÁ ENCONTRA-SE CONFERIDO, NÃO SENDO POSSÍVEL LIMPAR A CONFERÊNCIA","ATENÇÃO")
	Tone()
	Return()
	
Endif

If cTPConfCG="C"
	/*
	reclock("SZG",.F.)
	SZG->ZG_VOLUME1	:= 0
	SZG->ZG_TLPCC	:= ""
	 
	// Valmir(16/03/2018)
	SZG->ZG_CONCX := ""
	SZG->ZG_DTCCX	:= CTOD(" / / ")
	SZG->ZG_HRCCX	:= ""
	msunlock()
	*/
	cQuery1 := " UPDATE SZG010 SET ZG_VOLUME1 = 0, ZG_TLPCC=' ', ZG_CONCX=' ', ZG_DTCCX=' ', ZG_HRCCX=' ' "
	cQuery1 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQuery1)
	
Else
	/*
	reclock("SZG",.F.)
	SZG->ZG_VOLUME2	:= 0
	SZG->ZG_X_TLPCG	:= ""
	// Valmir(16/03/2018)
	SZG->ZG_CONGR := ""
	SZG->ZG_DTCGR := CTOD(" / / ")
	SZG->ZG_HRCGR := ""
	msunlock()
	*/
	cQuery1 := " UPDATE SZG010 SET ZG_VOLUME2 = 0, ZG_X_TLPCG=' ', ZG_CONGR=' ', ZG_DTCGR=' ', ZG_HRCGR=' ' "
	cQuery1 += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
	TcSqlExec(cQuery1)
	
Endif


DBSelectArea("SZG")
DBSetOrder(2)
DbgoTop()
DBSeek(xFilial("SZG") + cOp /*+ "01"*/)

IF cTPConfCG="C"	//SEPARACAO =>  C=CAIXA
	
	For nY := 1 To Len(aCols)
		While SZG->(!eof()) .and. Alltrim(SZG->(ZG_FILPED+ZG_NUM)) == Alltrim(cOp)
			reclock("SZG",.F.)
			SZG->ZG_VCXCO := 0
			msunlock()
			SZG->(dbskip())
		Enddo
	Next nY
	
ELSE				//SEPARACAO =>  G=GRANEL
	For nY := 1 To Len(aCols)
		While SZG->(!eof()) .and. Alltrim(SZG->(ZG_FILPED+ZG_NUM)) == Alltrim(cOp)
			reclock("SZG",.F.)
			SZG->ZG_VGRCO := 0
			msunlock()
			SZG->(dbskip())
		Enddo
	Next nY
	
ENDIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ POSGETD   | Autor ³ Andre Valmir         ³ Data ³26/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Posiciona na linha correspondente a leitura                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function POSGETD(cProduto,cLote,cLocaliza)

Local nPos := 0

nPos := aScan(aCols,{|_vPdo| _vPdo[1]==cProduto })

If nPos > 0
	
	oGetDad:GoTo(nPos)
	oGetDad:oBrowse:Refresh()
	
End If

Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Funcao   ³ SLPCPA25  | Autor ³ Andre Valmir         ³ Data ³21/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a validacao e baixa virtual no Grid                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SLPCPA25(cCodBar,cProduto,cLote,oCodBar,cLocaliza)

Local _nLinPrd 		:= 0
Local _nLinGrid 	:= 0
Local nSeq			:= 0
Local nRow			:= 0
Local nSaldoLt		:= 0
Local nQtdAcols2	:= 0
Local nCopias		:= 2
Local nPeso 		:= 0
Local lOk		:= .F.

Private oTelGR
Private nQtdPrd := 0
Private oFont 	:= TFont():New('Courier new',,-15,.T.,.T.)

_nLinGrid:= aScan(oGetDad:aCols,{|_vPdo| _vPdo[1]==cProduto })

If _nLinGrid==0 .And. !Empty(cProduto)
	Tone()
	alert("Produto não encontrado no Pedido.","Verifique!")
	Tone()
	
	oGetDad:oBrowse:Refresh() 		// Atualiza Grid
	oGetDad:GoTo(1)
	oCodBar:SetFocus()				// Posiciona no Campo
	
	Return()
End If


If Empty(cProduto)
	Return()
End If

If LEFT(cProduto,3) $ ('PR-/AC-')
	DEFINE MSDIALOG oTelGR FROM 000,000 TO 130,300 TITLE Alltrim(OemToAnsi("QUANTIDADE DE VOLUMES - GRANEL")) Pixel
	
	oSayLn2 := tSay():New(41,05,{||"INFORMAR QTD: "},oTelGR,,oFont,,,,.T.,CLR_BLACK,CLR_RED,60,20)
	oGet := tGet():New(38,80,{|u| if(Pcount()>0,nQtdPrd:=u,nQtdPrd) },oTelGR,40,12,"@E 999999",{|| IIF(nQtdPrd > 0,.T.,.F.) },,,oFont,,,.T.,,,,,,,,,,"nQtdPrd",,,,,.F.,,)
	
	ACTIVATE MSDIALOG oTelGR CENTERED ON INIT EnchoiceBar(oTelGR,{||lOk:= .T.,oTelGR:End()},{||oTelGR:End()},,)
	
	If lOk
		cQtdVolDig	:= nQtdPrd
	Else
		Return()
	EndIf
EndIf

//oGetDad:oBrowse:Refresh() 		// Atualiza Grid

IF oGetDad:aCols[oGetDad:nAt][2] <= oGetDad:aCols[oGetDad:nAt][3]
	
	Tone()
	MsgAlert("QUANTIDADE ULTRAPASSOU CONTAGEM.","ATENÇÃO!")
	Tone()
Else
	AtuAcols(cProduto)				// Soma a quantidade do Grid
Endif

oGetDad:oBrowse:SetBlkBackColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][2] <> oGetDad:aCols[oGetDad:nAt][3], " + Str(CLR_WHITE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] ," + Str(CLR_LIGHTGRAY) + "," + Str(CLR_WHITE) + "))}"))
oGetDad:oBrowse:SetBlkColor( &("{|| IIF(oGetDad:aCols[oGetDad:nAt][3]=0, " + Str(CLR_HBLUE) + ",IIF(oGetDad:aCols[oGetDad:nAt][2] == oGetDad:aCols[oGetDad:nAt][3] .or. oGetDad:aCols[oGetDad:nAt][3] > 0," + Str(CLR_GREEN) + "," + Str(CLR_WHITE) + "))}"))

oGetDad:oBrowse:Refresh() 		// Atualiza Grid
oGetDad:GoTo(1)
oCodBar:SetFocus()

Return



//*************************** Atualiza o ACOLS ***************************
//Leitura do Codigo de Barras Validado na Conferencia (CAIXA / GRANEL)
//************************************************************************
Static Function AtuAcols(cProduto)
Local cCodUser 		:= RetCodUsr()

//cItem := Posicione("SC6",2,xFilial("SC6")+cProduto+Alltrim(cOp),"C6_ITEM")
//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp + cItem + cProduto))
//SC5->(DbSetOrder(1),DbSeek(xFilial("SC5") + cNumPV ))
//ALERT(cProduto)
SZG->(DbSetOrder(3),DbSeek(xFilial("SZG") + cOp + cProduto ))

If cTPConfCG="C" .AND. cQtdVolDig>0 .AND. SZG->ZG_VCXCO > 0 //SC6->C6_X_VCXCO > 0
	Alert("ATENÇÃO, QUANTIDADE DIGITADA INVALIDA, FAVOR REVER QUANTIDADE!!!")
	Return
Endif

//Contador de leitura - Criado para atender a Demanda do Lancamento da Quantidade do Pallet
IF cQtdVolDig > 0			//Se FOR INFORMADO A QUANTIDADE DE VOLUME
	cContQtd := cQtdVolDig	//Calculo com informacao de VOLUME INFORMADO
else
	cContQtd := 1			//Calculo da Leitura Codigo de Barras
Endif

//Preparar para gravar no SC6 *** - Gravar em Tempo REAL
DBSelectarea("SZG")
DBSetOrder(3)
DbSeek(xFilial("SZG") + cOp + cProduto )

IF cTPConfCG="C"	//SEPARACAO =>  C=CAIXA
	
	//busca faturamento para processar
	If SZG->ZG_VCXCO < SZG->ZG_VCXIM .and. alltrim(cProduto) == Alltrim(SZG->ZG_PRODUTO)
		
		If (SZG->ZG_VCXCO + cQtdVolDig) > SZG->ZG_VCXIM
			Tone()
			Alert("ATENÇÃO QUANTIDADE DE CAIXAS DIGITADAS NO PALLET É MAIOR QUE A QUANTIDADE SOLICITADA!!!")
			Tone()
			Return()
		Endif
		
		
		Reclock("SZG",.F.)
		SZG->ZG_VCXCO += cContQtd
		msunlock()
		
	Endif
	
	
ELSE		//SEPARACAO =>  G=GRANEL
	
	//busca faturamento para processar
	If SZG->ZG_VGRCO < SZG->ZG_VGRIM .and. alltrim(cProduto) == Alltrim(SZG->ZG_PRODUTO)
		
		If (SZG->ZG_VGRCO + cContQtd) > SZG->ZG_VGRIM
			Tone()
			Alert("ATENÇÃO QUANTIDADE DE VOLUME DIGITADA É MAIOR QUE A QUANTIDADE SOLICITADA!!!")
			Tone()
			Return()
		Endif
		
		reclock("SZG",.F.)
		SZG->ZG_VGRCO += cContQtd
		msunlock()
		
	Endif
	
	
ENDIF

//ATUALIZA GRID COM NOVA QUANTIDADE
For nX := 1 To Len(aCols)
	If alltrim(cProduto) =	alltrim(oGetDad:aCols[nx][1])
		oGetDad:aCols[nx][3] 	+= cContQtd
	Endif
Next nX

//Zera variavel
cQtdVolDig := 0

Return()



//Tela de Validacao para Usuario informara "CONTRA-SENHA" para liberar processo interno
User Function zLoginZ(cUsrLog, cPswLog)

Local oGrpLog
Local oBtnConf
Private lRetorno := .F.
Private oDlgPvt
Private oSayUsr
Private oGetUsr, cGetUsr := Space(25)
Private oSayPsw
Private oGetPsw, cGetPsw := Space(20)
Private oGetErr, cGetErr := ""
//DimensÃµes da janela
Private nJanLarg := 200
Private nJanAltu := 200

//Criando a janela
DEFINE MSDIALOG oDlgPvt TITLE "Login" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
//Grupo de Login
@ 003, 001     GROUP oGrpLog TO (nJanAltu/2)-1, (nJanLarg/2)-3         PROMPT "Login: "     OF oDlgPvt COLOR 0, 16777215 PIXEL
//Label e Get de Usuario
@ 013, 006   SAY   oSayUsr PROMPT "Cod.Usuário:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
@ 020, 006   MSGET oGetUsr VAR    cGetUsr           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL

//Label e Get da Senha
@ 033, 006   SAY   oSayPsw PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
@ 040, 006   MSGET oGetPsw VAR    cGetPsw           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL PASSWORD

//Get de Log, pois se for Say, nao da para definir a cor
@ 060, 006   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
oGetErr:lActive := .F.
oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")

//Botoes
@ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar"             SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ACTION (fVldUsr()) PIXEL
oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
ACTIVATE MSDIALOG oDlgPvt CENTERED

//Se a rotina foi confirmada e deu certo, atualiza o usuario e a senha
If lRetorno
	//alert("Usuario Validado")
	lGerPed := .T.
EndIf

//    RestArea(aArea)
Return lRetorno

/*---------------------------------------------------------------------*
| Func:  fVldUsr                                                      |
| Autor: Daniel Atilio                                                |
| Data:  17/09/2015                                                   |
| Desc:  FunÃ§Ã£o para validar se o usuÃ¡rio existe                      |
*---------------------------------------------------------------------*/

Static Function fVldUsr()

Local cUsrAux	:= Alltrim(cGetUsr)
Local cPswAux	:= Alltrim(cGetPsw)
Local cCodAux	:= ""
Local cUsrDig

If Empty(cUsrAux)
	Return
Endif

PswOrder(2)
If PswSeek( Alltrim(cGetUsr), .T. )
	cUsrDig := PswRet()[1][1]
else
	cGetErr := "USUÁRIO NÃO ENCONTRADO!!!"
	oGetErr:Refresh()
	Return		
Endif


DBSelectArea("CB1")
DBSetOrder(2)
DBSeek(xFilial("CB1")+cUsrDig)

If Found() .AND. CB1->CB1_X_ATCF == "1"

	//Pega o codigo do usuario
	PswOrder(2)
	
	If  PswSeek(cUsrAux,.T.)
		
		//Agora verifica se a senha bate com o usuario
		If !PswName(cPswAux)
			cGetErr := "SENHA INVÁLIDA!"
			oGetErr:Refresh()
			Return
			
			
			//Senao, atualiza o retorno como verdadeiro
		Else
			lRetorno := .T.
		endif
		
		//Senao atualiza o erro e retorna para a rotina
	Else
		cGetErr := "USUÁRIO NÃO ENCONTRADO!!!"
		oGetErr:Refresh()
		oDlgPvt:End()
		Return
	EndIf
	
	//Se o retorno for valido, fecha a janela
	If lRetorno

		//Atualiza Usuario do CORTE do Pedido	
		cQuery1 := " UPDATE SZG010 SET ZG_USCORT='"+CB1->CB1_NOME+"' "
		cQuery1 += " 	WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
		TcSqlExec(cQuery1)
		oDlgPvt:End()
	EndIf
	
Else
	Alert("USUÁRIO NÃO AUTORIZADO A FAZER CONFERÊNCIA COM FALTA!!!")
	oGetErr:Refresh()
	oDlgPvt:End()
	Return
	
Endif

		/*
		//Atualiza Usuario do CORTE do Pedido	
		cQuery1 := " UPDATE SZG010 SET ZG_USCORT='ANTONIO JOAO' "
		cQuery1 += " 	WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
		TcSqlExec(cQuery1)
		oDlgPvt:End()
		*/

Return


// Validar Liberacao do Pallet
User Function LoginPlx(cUsrLogPlt, cPswLogPlt)

Local oGrpLogPlt
Local oBtnConfPlt
Private oDlgPvtPlt
Private oSayUsrPlt
Private oGetUsrPlt, cGetUsrPlt := Space(25)
Private oSayPswPlt
Private oGetPswPlt, cGetPswPlt := Space(20)
Private oGetErrPlt, cGetErrPlt := ""
//Dimensoes da janela
Private nJanLargPl := 200
Private nJanAltuPl := 200

//Criando a janela
DEFINE MSDIALOG oDlgPvtPlt TITLE "Login" FROM 000, 000  TO nJanAltuPl, nJanLargPl COLORS 0, 16777215 PIXEL
//Grupo de Login
@ 003, 001     GROUP oGrpLogPlt TO (nJanAltuPl/2)-1, (nJanLargPl/2)-3         PROMPT "Login: "     OF oDlgPvtPlt COLOR 0, 16777215 PIXEL
//Label e Get de Usuario
@ 013, 006   SAY   oSayUsrPlt PROMPT "Cod.Usuário:"        SIZE 030, 007 OF oDlgPvtPlt                    PIXEL
@ 020, 006   MSGET oGetUsrPlt VAR    cGetUsrPlt           SIZE (nJanLargPl/2)-12, 007 OF oDlgPvtPlt COLORS 0, 16777215 PIXEL

//Label e Get da Senha
@ 033, 006   SAY   oSayPswPlt PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvtPlt                    PIXEL
@ 040, 006   MSGET oGetPswPlt VAR    cGetPswPlt           SIZE (nJanLargPl/2)-12, 007 OF oDlgPvtPlt COLORS 0, 16777215 PIXEL PASSWORD

//Get de Log, pois se for Say, nao da para definir a cor
@ 060, 006   MSGET oGetErrPlt VAR    cGetErrPlt        SIZE (nJanLargPl/2)-12, 007 OF oDlgPvtPlt COLORS 0, 16777215 NO BORDER PIXEL
oGetErrPlt:lActive := .F.
oGetErrPlt:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")

//Botoes
@ (nJanAltuPl/2)-18, 006 BUTTON oBtnConfPlt PROMPT "Confirmar"             SIZE (nJanLargPl/2)-12, 015 OF oDlgPvtPlt ACTION (fVldUsrPlt()) PIXEL
oBtnConfPlt:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
ACTIVATE MSDIALOG oDlgPvtPlt CENTERED

Return(lRetornoPlt)


/*---------------------------------------------------------------------*
| Func:  fVldUsrPlt                                                      |
| Autor: Daniel Atilio                                                |
| Data:  17/09/2015                                                   |
| Desc:  FunÃ§Ã£o para validar se o usuÃ¡rio existe                      |
*---------------------------------------------------------------------*/

Static Function fVldUsrPlt()

Local cUsrAuxPlt	:= Alltrim(cGetUsrPlt)
Local cPswAuxPlt	:= Alltrim(cGetPswPlt)
Local cCodAuxPlt	:= ""
Local cUsrDigPlt	:= ""

If Empty(cUsrAuxPlt)
	Return
Endif

PswOrder(2)
If PswSeek( Alltrim(cGetUsrPlt), .T. )
	cUsrDigPlt := PswRet()[1][1]
Endif


DBSelectArea("CB1")
DBSetOrder(2)
DBSeek(xFilial("CB1")+cUsrDigPlt)

If Found() .AND. CB1->CB1_X_LBPL == "1"
	
	//Pega o codigo do usuario
	PswOrder(2)
	
	If  PswSeek(cUsrAuxPlt,.T.)
		
		//Agora verifica se a senha bate com o usuario
		If !PswName(cPswAuxPlt)
			cGetErrPlt := "SENHA INVÁLIDA!"
			oGetErrPlt:Refresh()
			Return
			
			
			//Senao, atualiza o retorno como verdadeiro
		Else
			lRetornoPlt := .T.
		endif
		
		//Senao atualiza o erro e retorna para a rotina
	Else
		cGetErrPlt := "USUÁRIO NÃO ENCONTRADO!!!"
		oGetErrPlt:Refresh()
		Return
	EndIf
	
	//Se o retorno for valido, fecha a janela
	If lRetornoPlt
	
		oDlgPvtPlt:End()
	EndIf
	
Else
	Alert("USUÁRIO NÃO AUTORIZADO A FAZER CONFERÊNCIA DE PALLET!!!")
	Return
	
Endif

Return

// Função para somar a quantidade de volumes
//*******************************************************************************************************
Static Function CalcVolCX(cOp)

Private cQryVol		:= GetNextAlias()
Private	cQueryVol	:= ""

cQueryVol	:= "  SELECT SUM(ZG_VCXCO) C6_X_VCXCO "
cQueryVol	+= "  FROM SZG010 ZG "
cQueryVol	+= "  WHERE ZG.D_E_L_E_T_ = '' "
cQueryVol	+= "  AND ZG_FILPED+ZG_NUM = '"+cOp+"' "
//cQueryVol	+= "  AND ZG_FILIAL = '"+xFilial("SC6")+"' "     				// ###Valmir (19/06/2019)
//cQueryVol	+= "  AND ZG_FILIAL = '"+xFilial("SZG")+"' " 					// ###Valmir (19/06/2019)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryVol),cQryVol,.F.,.T.)

nQtdVolCX := (cQryVol)->C6_X_VCXCO

(cQryVol)->(DbCloseArea())

Return(nQtdVolCX)

//*******************************************************************************************************


// Validar as Quantidades

Static Function ValidarQtd()

Local ContCX		:= 0	// Contador Linha Caixa
Local ContCX1		:= 0	// Contador Linha Caixa1
Local ContGR		:= 0 	// Contador Linha Granel
Local ContGR1		:= 0 	// Contador Linha Granel
Local lValidGrid	:= .F.	// Validar se o grid esta preenchido
Local nCont			:= 0


If cTPConfCG="G"
	
	For i = 1 to Len(aCols)
		If oGetDad:ACOLS[i][2] = 0
			lValidGrid := .T.
		Else
			lValidGrid := .F.
			nCont++
		Endif
	Next i
	
	If !lValidGrid
		// "01"
		//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp + cItem ))
		DBSelectarea("SZG")
		DBSetOrder(2)
		DBSeek(xFilial("SZG") + cOp /*+ "01"*/ )
		
		While SZG->(!eof()) .AND. SZG->(ZG_FILPED+ZG_NUM) = cOp
			
			// Validar Granel
			If  SZG->ZG_VGRIM == SZG->ZG_VGRCO
				ContGR++
			Else
				ContGR1++
			Endif
			
			SZG->(dbskip())
			
		Enddo
		
		
		If ContGR1 > 0
			
			lValConfer := .F.
			Tone()
			Alert("NÃO É POSSIVEL FINALIZAR A CONFERÊNCIA, AINDA EXISTEM SALDOS PARA CONFERÊNCIA!!!")
			Tone()
			Return
			
		Else
			//Imprimir ETIQUETA
			
			//nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )
			
			lValConfer := .T.
			//if nOpc = 1
			//	SLPCPA27(cOp)
			//Endif
			
		Endif
		
	Else
		Tone()
		Alert("PEDIDO NÃO LIBERADO PARA CONFERÊNCIA, FAVOR FAZER A IMPRESSÃO DA ORDEM DE SEPARAÇÃO!!!")
		Tone()
		Return
	Endif
	
Else	//CONFERENCIA - CAIXA
	
	
	If nCont > 0
		lValidGrid := .F.
	Endif
	
	If !lValidGrid                                        // "01"
		
		//SC6->(DbSetOrder(1),DbSeek(xFilial("SC6") + cOp + cItem ))
		DBSelectarea("SZG")
		DBSetOrder(2)	//DBSetOrder(1) // Valmir(15/05/2019)
		DbgoTop()
		DBSeek(xFilial("SZG") + cOp )
		
		While SZG->(!eof()) .AND. SZG->(ZG_FILPED+ZG_NUM) = cOp
			
			// Validar Caixa
			If SZG->ZG_VCXIM == SZG->ZG_VCXCO
				ContCX++
			Else
				ContCX1++
			Endif
			
			SZG->(dbskip())
			
		Enddo
		
		If ContCX1 > 0
			
			lValConfer := .F.
			Tone()
			Alert("NÃO É POSSIVEL FINALIZAR A CONFERÊNCIA, AINDA EXISTEM SALDOS PARA CONFERÊNCIA CAIXA/GRANEL!!!")
			Tone()
			Return
			
		Else
			//Imprimir ETIQUETA
			
			//???***SC9->(DbSetOrder(1),DbSeek(xFilial("SC9") + Padr(cOp,6) + "01" ))
			/*
			While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cOp)
			
			RecLock("SC9",.F.)
			SC9->C9_BLEST	:= ""
			SC9->( MsUnLock() )
			
			SC9->(dbskip())
			
			Enddo
			*/
			
			// Valmir (07/03/2018) Adicionar regra caso nao exista Granel para conferir o sistema atualizar o STATUS
			DBSelectarea("SZG")
			DBSetOrder(2)	
			DBSeek(xFilial("SZG") + cOp /*+ "01"*/ )
			
			If SZG->ZG_TLNGR = 0
				
				//				Reclock("SZG",.F.)
				//				SZG->ZG_STAPV := "5"
				//				msunlock()
				cQueryE := " UPDATE SZG010 SET ZG_STAPV = '5'"
				cQueryE += " WHERE ZG_FILPED+ZG_NUM = '"+cOp+"' "
				TcSqlExec(cQueryE)

				lWebSrv := .T.
				//U_WB_LOG10(cOp)
				
			Endif
			
			//			nOpc := 1 //aviso( "ATENCAO","DESEJA IMPRIMIR AS ETIQUETAS?",{"SIM","NAO"} )
			
			lValConfer := .T.
			
			//			if nOpc = 1
			//				SLPCPA27(cOp)
			//			Endif
			
		Endif
		
	Else
		Alert("PEDIDO NÃO LIBERADO PARA CONFERÊNCIA, FAVOR FAZER A IMPRESSÃO DA ORDEM DE SEPARAÇÃO!!!")
		Return
	Endif
	
Endif

/*                                                          // "01"
SC9->(DbSetOrder(1),DbSeek(xFilial("SC9") + Padr(cOp,6) + "01" ))

While SC9->(!eof()) .and. SC9->C9_PEDIDO == Alltrim(cOp)

RecLock("SC9",.F.)
SC9->C9_BLEST	:= ""
SC9->( MsUnLock() )

SC9->(dbskip())

Enddo
*/

/*
//!!!Andre Salgado (22/03/18) - Melhoria para garantir que vai liberar 100% o SC9
cTxtSC9f := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' "
cTxtSC9f += " WHERE "
cTxtSC9f += " C9_PEDIDO='"+Alltrim(cOp)+"' AND C9_FILIAL='"+xFilial("SC9")+"' "
TcSqlExec(cTxtSC9f)
*/

Return
