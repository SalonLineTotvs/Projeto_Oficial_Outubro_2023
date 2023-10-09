#Include "Protheus.ch"
#Include "Avprint.ch"
#Include "Font.ch"
#INCLUDE "RWMAKE.CH"

USER FUNCTION FATR0006()

//*****************************************************************************
// Solicitação - Bruno Mineiro / Projeto AMAZON
// Autorizado  - Genilson Lucas
// Autor       - Valmir / Introde - Data 15/10/2018
//*****************************************************************************
/*              MELHORIA(s)
Autor /Data - Andre Salgado/Introde - Data 16/10/2018
Configurar o codigo de Barras do numero da DANFE
Autor /Data - Andre Salgado/Introde - Data 05/12/2018
Configurar o codigo de Barras do numero da DANFE, validado com Coletor
Criar a Pergunta MV_PAR02 - Data Validade para Imprimir Etiqueta
*/
//*****************************************************************************
Private cNumNF
Private nQtdEti
Private cPerg	:= "ESTR05"
//Parametros 	- MV_PAR01 - Informar o Codigo NOTA FISCAL                                                                   x
//Parametros 	- MV_PAR02 - Informar o Validade LOTE  X1_VALID >>> Iif(ddatabase+365>mv_par02,(alert("Data Valida!"),.f.),.t.)

If !Pergunte(cPerg, .T.)
	Return (.T.)
Endif

Processa({|X| lEnd := X, ImpEtiq()})

RETURN(.T.)


//*****************************************************************************
Static Function ImpEtiq()
//*****************************************************************************

Private cQuery	:= ""
Private nDes	:= 0  // Deslocamento
Private oPRN	:= tmsprinter():new("Eti")
Private cNumNF	:= MV_PAR01

#xtranslate :HAETTENSCHWEILER_16        => \[1\]
#xtranslate :ARIAL_NARROW_14_NEGRITO    => \[2\]
#xtranslate :ARIAL_BLACK_54_NEGRITO     => \[3\]
#xtranslate :CENTURY_GOTHIC_10_NEGRITO  => \[4\]
#xtranslate :CENTURY_GOTHIC_11_NEGRITO  => \[5\]
#xtranslate :CENTURY_GOTHIC_12_NEGRITO  => \[6\]
#xtranslate :CENTURY_GOTHIC_14_NEGRITO  => \[7\]
#xtranslate :ARIAL_09             		=> \[8\]
#xtranslate :ARIAL_10             		=> \[9\]
#xtranslate :ARIAL_12             		=> \[10\]
#xtranslate :ARIAL_18             		=> \[11\]
#xtranslate :ARIAL_10_NEGRITO     		=> \[12\]
#xtranslate :ARIAL_12_NEGRITO     		=> \[13\]
#xtranslate :ARIAL_14_NEGRITO     		=> \[14\]
#xtranslate :ARIAL_14_NEGRITO     		=> \[15\]
#xtranslate :ARIAL_14_NEGRITO     		=> \[16\]
#xtranslate :ARIAL_40_NEGRITO     		=> \[17\]
#xtranslate :ARIAL_60_NEGRITO     		=> \[18\]

AVPRINT oPrn NAME "Etiqueta"

oFont1  := oSend(TFont(),"New","HAETTENSCHWEILER" ,0,16,,.F.,,,,,,,,,,,oPrn )
oFont2  := oSend(TFont(),"New","Arial NARROW" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont3  := oSend(TFont(),"New","Arial BLACK" ,0,54,,.T.,,,,,,,,,,,oPrn )
oFont4  := oSend(TFont(),"New","Century Gothic" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont5  := oSend(TFont(),"New","Century Gothic" ,0,11,,.T.,,,,,,,,,,,oPrn )
oFont6  := oSend(TFont(),"New","Century Gothic" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont7  := oSend(TFont(),"New","Century Gothic" ,0,14,,.T.,,,,,,,,,,,oPrn )

oFont8  := oSend(TFont(),"New","Arial" ,0,09,,.F.,,,,,,,,,,,oPrn )
oFont9  := oSend(TFont(),"New","Arial" ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont10 := oSend(TFont(),"New","Arial" ,0,12,,.F.,,,,,,,,,,,oPrn )
oFont11 := oSend(TFont(),"New","Arial" ,0,18,,.F.,,,,,,,,,,,oPrn )
oFont12 := oSend(TFont(),"New","Arial" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont13 := oSend(TFont(),"New","Arial" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont14 := oSend(TFont(),"New","Arial" ,0,13,,.T.,,,,,,,,,,,oPrn )
oFont15 := oSend(TFont(),"New","Arial" ,0,13,,.F.,,,,,,,,,,,oPrn )
oFont15n:= oSend(TFont(),"New","Arial" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont16 := oSend(TFont(),"New","Arial" ,0,20,,.T.,,,,,,,,,,,oPrn )
oFont17 := oSend(TFont(),"New","Arial" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont18 := oSend(TFont(),"New","Arial" ,0,60,,.T.,,,,,,,,,,,oPrn )

//aFontes := {oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8,oFont9, oFont10, oFont11, oFont12, oFont13, oFont14, oFont15, oFont16, oFont17, oFont18  }

oBrush	:= TBrush():New(,4)

oPrn:SetPortrait()  // SetLandscape()


//Busca os dados no Banco
cQuery	:= " SELECT DISTINCT F2_FILIAL, F2_DOC, F2_CHVNFE, D2_PEDIDO, F2_VOLUME1, MAX(C6_NUMPCOM) C6_NUMPCOM,	"
cQuery	+= " F2_CLIENTE, F2_LOJA, A1_NOME, A1_END, A1_BAIRRO, A1_EST, A1_CEP, A1_MUN "
cQuery	+= " FROM "+RetSqlName("SF2") +" F2 WITH (NOLOCK) "
cQuery	+= " 	INNER JOIN " +RetSqlName("SA1") +" A1 WITH (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = '' "
cQuery	+= " 	INNER JOIN " +RetSqlName("SD2") +" D2 WITH (NOLOCK) ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND D2.D_E_L_E_T_ = '' "
cQuery	+= " 	INNER JOIN " +RetSqlName("SC6") +" C6 WITH (NOLOCK) ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND C6.D_E_L_E_T_ = '' AND D2_COD = C6_PRODUTO "
cQuery	+= " WHERE "
cQuery	+= " 	F2.D_E_L_E_T_=' ' AND F2_FILIAL='"+xFilial("SF2")+"' "
cQuery	+= " 	AND F2_DOC = '"+MV_PAR01+"'
cQuery	+= " GROUP BY "
cQuery	+= " 	F2_FILIAL, F2_DOC, F2_CHVNFE ,F2_CLIENTE, F2_LOJA, A1_NOME, D2_PEDIDO, F2_VOLUME1,F2_CLIENTE, F2_LOJA, "
cQuery	+= " 	A1_NREDUZ, A1_END, A1_BAIRRO, A1_EST, A1_CEP, A1_MUN "

If Select("TRB1") > 0
	TRB1->(DbCloseArea())
Endif
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)

DBSelectArea("SF2")
DBSetOrder(1)
DBSeek(xFilial("SF2")+Alltrim(MV_PAR01))

If Found()
	
	nQtdEti		:=	TRB1->F2_VOLUME1
	cNumCHV		:=	TRB1->F2_CHVNFE
	cPV			:=	TRB1->D2_PEDIDO
	nVol		:=	TRB1->F2_VOLUME1
	cNumPVCli	:=	TRB1->C6_NUMPCOM
	cNomeCLi	:=	TRB1->A1_NOME
	cEnd		:=	SUBSTR(TRB1->A1_END,1,37)
	cBairro		:=	SUBSTR(TRB1->A1_BAIRRO,1,35)
	cUF			:=	TRB1->A1_EST
	cCep		:=	TRB1->A1_CEP
	cMun		:=	TRB1->A1_MUN
	
	Imprime()
Else
	msginfo("Nota fiscal não localizada")
	Return()
Endif

oSend(oFont1 ,"End")
oSend(oFont2 ,"End")
oSend(oFont3 ,"End")
oSend(oFont4 ,"End")
oSend(oFont5 ,"End")
oSend(oFont6 ,"End")
oSend(oFont7 ,"End")
oSend(oFont8 ,"End")
oSend(oFont9 ,"End")
oSend(oFont10,"End")
oSend(oFont11,"End")
oSend(oFont12,"End")
oSend(oFont13,"End")
oSend(oFont14,"End")
oSend(oFont15,"End")
oSend(oFont16,"End")
oSend(oFont17,"End")
oSend(oFont18,"End")

AVENDPRINT

Return() // ImpEtiq()


//*****************************************************************************
Static Function Imprime()
//*****************************************************************************

Private _cEnter := CHR(13)+CHR(10)

CPYS2T("\system\modelo_Etiqueta_Amazon.LBL","C:\TEMP\") //Copia o arquivo do Zebra Designer para computador local do cliente

cMsg := "MUITO IMPORTANTE PRECISA GERAR ESTA ETIQUETA EM CONJUNTO COM O SOFTWARE ZEBRA DESIGNER, PARA GERAR O CODIGO DE BARRAS."+_cEnter+_cEnter
cMsg += "Procedimento:"+_cEnter
cMsg += " (1) Imprimir as Etiquetas pelo Protheus;"+_cEnter
cMsg += " (2) Abrir Zebra Desing arquivo modelo C:\TEMP\Modelo_etiqueta_amazon.lbl"+_cEnter
cMsg += " (3) Informar o numero da Chave da DANFE neste modelo da Zebra"+_cEnter
cMsg += " (4)Voltar as etiquetas já impressa e gerar novamente agora com a impressao pelo Zebra Designer"

MSGALERT(cMsg,"ATENCAO")


For nQtd:=1 to nQtdEti
	ImpDet(nQtd)
Next

Return() // Imprime()


//*****************************************************************************
Static Function ImpDet(nNumEtiq)
//*****************************************************************************

Private cTexto	:= ""
Private	cStartPath	:= GetSrvProfString('Startpath','')//,;
//		cFileLogo	:= cStartPath + 'LGRL0101' + '.bmp'

AVPAGE

cTexto	:= substr(cNumCHV,1,44)  //44
//MSBAR("INT25", 0.4, 0.2, cTexto, oPrn, .F.,,.T., 0.0214, 1.0 ,.F.,,, .F. )
//MSBAR("INT25", 0.6, 0.5, cTexto, oPrn, .F.,,.T., 0.0211, 1.0 ,.F.,,, .F. ) //valmir  inicio

//**MSBAR3("EAN128",0.6,0.6,cTexto,oPrn,.F.,,.T.,0.0211,1.25,.T.,,,.F.,4)
//PLANO B - IMPRIMIR AS ETIQUETAS DEPOIS VOLTAR A IMPRIMIR NOVAMENTE COM O CODIGO DE BARRAS DA NOTA DE 44 POSIÇÕES PELO SISTEMA ZEBRA DESIGN


//TENTATIVAS....
//MSBAR("CODE128", 0.6, 0.15, cTexto, oPrn, .F.,,.F., 0.02, 1.25 ,.F.,,, .F. ) //nao funciona na vertical
//MSBAR("INT25", 0.6, 0.5, cTexto, oPrn, .F.,,.F., 0.0212, 1.25 ,.T.,,, .F. )

//MSBAR("CODABAR",0.6,0.5,cTexto,oPrn,.F.,,.T.,0.013, 1 ,NIL,NIL,NIL)
//MSBAR("EAN128", 0.6, 0.5, cTexto, oPrn, .F.,,.T., 0.030,1.0 ,.F.,,, .F. )  //funcionou mais muito grande
//MSBAR("EAN128", 0.6, 0.5, cTexto, oPrn, .F.,,.T., 0.020,1.0 ,.F.,,, .F. )  //0.030  funcionou mais muito grande
//MSBAR("EAN128", 0.6, 0.5, cTexto, oPrn, .F.,,.T., 0.018,1.0 ,.F.,,, .F. )  //certo mais nao le !!!!!!
//MSBAR("EAN128", 0.6, 0.7, cTexto, oPrn, .F.,,.T., 0.022,1.0 ,.F.,,, .F. )  //certo mais nao le !!!!!!
//MSBAR("CODE128", 0.6, 0.8, cTexto, oPrn, .F.,,.T., 0.020,1.0 ,.F.,,, .F. )
//MSBAR("EAN128", 0.6, 0.8, cTexto, oPrn, .F.,,.T., 0.021,1.1 ,.F.,,, .F. )


cTexto := cNumCHV
//oPrn:Say(nLin(1.6), nCol(0.5),cTexto,oFont15n)

oPrn:box(nLin(3.8), nCol(0.4),nLin(7.0),nCol(9.8))


// DADOS DO DESTINATARIO
cTexto := "DESTINATARIO "
oPrn:Say(nLin(3.8), nCol(0.5),cTexto,oFont17)

cTexto := "GRU5"
oPrn:Say(nLin(2.6), nCol(8.2),cTexto,oFont16)

cTexto := cNomeCLi
oPrn:Say(nLin(4.5), nCol(0.5),Substr(cTexto,1,35),oFont15)

cTexto := cEnd
oPrn:Say(nLin(5.0), nCol(0.5),cTexto,oFont15)

cTexto := cBairro
oPrn:Say(nLin(5.5), nCol(0.5),cTexto,oFont15)

cTexto := Alltrim(cMun) + Space(5) + cUF
oPrn:Say(nLin(6.0), nCol(0.5),cTexto,oFont15)

cTexto := SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3)
oPrn:Say(nLin(6.5), nCol(0.5),cTexto,oFont15)

oPrn:box(nLin(7.2), nCol(0.4),nLin(10.5),nCol(9.8))


// DADOS DO REMETENTE
cTexto := "REMETENTE"
oPrn:Say(nLin(7.3), nCol(0.5),cTexto,oFont17)

cTexto := SUBSTR(SM0->M0_NOMECOM,1,36)
oPrn:Say(nLin(8.0), nCol(0.5),cTexto,oFont15)

cTexto := SM0->M0_ENDCOB
oPrn:Say(nLin(8.5), nCol(0.5),cTexto,oFont15)

cTexto := SM0->M0_BAIRCOB
oPrn:Say(nLin(9.0), nCol(0.5),cTexto,oFont15)

cTexto := Alltrim(SM0->M0_CIDCOB) + Space(5) + Alltrim(SM0->M0_ESTCOB)
oPrn:Say(nLin(9.5), nCol(0.5),cTexto,oFont15)

cTexto := SUBSTR(SM0->M0_CEPCOB,1,5) + "-" + SUBSTR(SM0->M0_CEPCOB,6,3)
oPrn:Say(nLin(10.0), nCol(0.5),cTexto,oFont15)

cTexto := "VAL.LOTE: " +dtoc(MV_PAR02) //"31/03/2020"
oPrn:Say(nLin(10.7), nCol(0.5),cTexto,oFont17)

cTexto := "VOL: " +Padl(nQtd,4,"0")+" / " +Padl(nQtdEti,4,"0")
oPrn:Say(nLin(10.7), nCol(6.2),cTexto,oFont15)

cTexto	:= cNumPVCli
//MSBAR("EAN128", 11.5, 0.5, cTexto, oPrn, .F.,,.T., 0.030,1.0 ,.F.,,, .F. )
MSBAR("EAN128", 11.6, 0.5, cTexto, oPrn, .F.,,.T., 0.030,1.0 ,.F.,,, .F. )

cTexto := "Número do pedido de compra " +cNumPVCli
oPrn:Say(nLin(13.0), nCol(0.5),cTexto,oFont15)

AVENDPAGE

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

Return(nRet)
