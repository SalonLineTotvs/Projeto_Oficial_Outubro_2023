#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#INCLUDE "rwmake.ch"
#Include "Font.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

User Function FATP0099()

Private _oDlg     := ""
Private _oDados   := ""
Private _aDados   := {}
Private _nSaldo   := 0
Private _nTit     := 0
Private _cBasCGC     := LEFT(Alltrim(TRB->A1_CGC),8) + "%"
Private _cCodCli    := TRB->A1_COD
Private _cLojCli    := TRB->A1_LOJA
Private _cVlrCred    := TRANSFORM(POSICIONE("SA1", 1,  xFilial( "SA1" ) + TRB->A1_COD + TRB->A1_LOJA, "A1_LC" ), "@E 999,999,999,999.99")
Private _dDtCred    := POSICIONE("SA1", 1,  xFilial( "SA1" ) + TRB->A1_COD + TRB->A1_LOJA, "A1_VENCLC" )

_cVlrCred:=0
//_cVlrCred:=TRANSFORM(_cVlrCred, "@E 999,999,999,999.99")

cQryLim2 := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_RISCO, A1_VENCLC, A1_LC ,A1_LCFIN"
cQryLim2 += " FROM SA1020  A1 "
cQryLim2 += " WHERE A1_CGC BETWEEN '"+_cBasCGC+"' AND '"+LEFT(Alltrim(_cBasCGC),8)+"999999' AND A1.D_E_L_E_T_ = '' "
cQryLim2 += " ORDER BY A1_COD, A1_LOJA "

cQryLim2 :=	ChangeQuery(cQryLim2)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryLim2),"LIM2",.T.,.T.)
	
LIM2->(DbGoTop())

While ("LIM2")->(!EOF())
		//cNomCli := LIM2->A1_NOME
		//cRisco  := LIM2->A1_RISCO
		//dLimCred:= STOD(LIM2->A1_VENCLC)
		_cVlrCred 	+= LIM2->A1_LC+LIM2->A1_LCFIN
		
	("LIM2")->( DbSkip() )
enddo
//LIM2->(dbCloseArea())

("LIM2")->(DbCloseArea())


BeginSQL alias 'XTRB'

    SELECT CASE 
	WHEN E1_FILIAL='0101' THEN '0101 - CIMEX'
	WHEN E1_FILIAL='0201' THEN '0201 - CROZE'
	WHEN E1_FILIAL='0301' THEN '0301 - KOPEK'
	WHEN E1_FILIAL='0401' THEN '0401 - MACO'
	WHEN E1_FILIAL='0501' THEN '0501 - QUBIT'
	WHEN E1_FILIAL='0601' THEN '0601 - ROJA'
	WHEN E1_FILIAL='0701' THEN '0701 - VIXEN'
	WHEN E1_FILIAL='0801' THEN '0801 - MAIZE'
	WHEN E1_FILIAL IN('0902','0901') THEN 'DEVINTEX'
    WHEN E1_FILIAL='1101' THEN '1101 - BIZEZ'
	WHEN E1_FILIAL='1201' THEN '1201 - ZAKAT'
	WHEN E1_FILIAL='1301' THEN '1301 - HEXIL'
	WHEN E1_FILIAL='1401' THEN '1401 - TROLL'
	ELSE E1_FILIAL END
    'EMPRESA', E1_NUM 'NUMERO', E1_PREFIXO 'PREFIXO', E1_PARCELA 'PARCELA', 
	E1_TIPO 'TIPO', E1_CLIENTE 'CLIENTE', E1_LOJA 'LOJA', A1_RISCO 'RISCO', A1_CGC 'CNPJ', 
	E1_HIST 'HISTORICO', E1_EMISSAO 'EMISSAO', E1_VENCREA 'VENCTO', E1_VALOR 'VALOR', E1_SALDO 'SALDO',
    E1.R_E_C_N_O_ 'REGISTRO'
    FROM %Table:SE1% E1 
    INNER JOIN %Table:SA1% A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.%NotDel% AND A1_CGC LIKE %Exp:_cBasCGC%
    WHERE E1.%NotDel% AND E1_SALDO > '0'
    AND E1_TIPO='NF' AND E1_VENCREA < %Exp:DATE()% 
    ORDER BY E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_EMISSAO

EndSQL

DbSelectArea("XTRB")
("XTRB")->(Dbgotop())
If ("XTRB")->(!EOF())
	While ("XTRB")->(!EOF())

		AADD(_aDados,{  ("XTRB")->EMPRESA,;
						("XTRB")->NUMERO,;
						("XTRB")->PREFIXO,;
						("XTRB")->PARCELA,;
						("XTRB")->TIPO,;
						("XTRB")->CLIENTE,;
						("XTRB")->LOJA,;
						("XTRB")->RISCO,;
						TRANSFORM(("XTRB")->CNPJ,"@R 99.999.999/9999-99"),;
						("XTRB")->HISTORICO,;
						STOD(("XTRB")->EMISSAO),;
						STOD(("XTRB")->VENCTO),;
						"R$ "+TRANSFORM(("XTRB")->VALOR, "@E 999,999,999.99"),;
						"R$ "+TRANSFORM(("XTRB")->SALDO, "@E 999,999,999.99"),;
						("XTRB")->REGISTRO;
						})
		
		_nSaldo += ("XTRB")->SALDO
		_nTit++

		("XTRB")->( DbSkip() )

	EndDo

Else

			AADD(_aDados,{  " ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ",;
						" ";	
							})

EndIf

("XTRB")->(DbCloseArea())

DEFINE MSDIALOG _oDlg FROM 0,0 TO 550,1200 TITLE "Posição Títulos Vencidos do Grupo a Receber" PIXEL

@ 005,004 TO 230,599 LABEL " Títulos Vencidos do Grupo" PIXEL COLOR CLR_RED OF _oDlg

@ 015,006 LISTBOX _oDados Fields HEADER " Empresa", " Numero Titulo", " Prefixo", " Parcela", " Tipo", ;
" Codigo Cliente" , " Loja", " Risco", " CNPJ", " Historico", " Emissao Titulo", " Vencimento", " Valor Titulo", " Saldo", "Registro" ;
COLSIZES 060/*Empresa*/, 060/*Numero*/, 030/*Prefixo*/, 030/*Parcela*/, 030/*Tipo*/, 030/*Cliente*/, ;
060/*Loja*/, 030/*Risco*/, 060/*CNPJ*/, 120/*Hist*/, 060/*Emissao*/, 060/*Vencimento*/, 060/*Valor*/, ;
060/*Saldo*/, 060/*Registro*/ SIZE 592, 207 OF _oDlg PIXEL

_oDados:SetArray( _aDados )
_oDados:bLine := { || { 	_aDados[_oDados:nAt,1]/*Empresa*/, _aDados[_oDados:nAt,2]/*Numero*/ 						 ,;			
                            _aDados[_oDados:nAt,3]/*Prefixo*/, _aDados[_oDados:nAt,4]/*Parcela*/						 ,;
                            _aDados[_oDados:nAt,5]/*Tipo*/   , _aDados[_oDados:nAt,6]/*Cliente*/						 ,;
                            _aDados[_oDados:nAt,7]/*Loja*/   , _aDados[_oDados:nAt,8]/*Risco*/  						 ,;
                            _aDados[_oDados:nAt,9]/*CNPJ*/   , _aDados[_oDados:nAt,10]/*Hist*/							 ,;
                            _aDados[_oDados:nAt,11]/*Emissao*/, _aDados[_oDados:nAt,12]/*Vencimento*/					 ,;
                            _aDados[_oDados:nAt,13]/*Valor*/  , _aDados[_oDados:nAt,14]/*Saldo*/                         ,;
                            _aDados[_oDados:nAt,15]/*Registro*/ } }


@ 240,005 SAY "Valor Credito: " of _oDlg PIXEL
@ 240,060 SAY "R$" + TRANSFORM(_cVlrCred, "@E 999,999,999,999.99") of _oDlg PIXEL

@ 255,005 SAY "Venc. Lim. Credito: " of _oDlg PIXEL
@ 255,060 SAY DTOC(_dDtCred) of _oDlg PIXEL

@ 240,130 SAY "Qtd. de Títulos: " of _oDlg PIXEL
@ 240,190 SAY _nTit of _oDlg PIXEL

@ 255,130 SAY "Total Saldo Vencido: " of _oDlg PIXEL
@ 255,190 SAY "R$" + TRANSFORM(_nSaldo, "@E 999,999,999.99") of _oDlg PIXEL

@ 245, 530  Button  "&Ok"    Size 30, 15 Pixel Action ( _oDlg:End() )

@ 245, 490  Button  "&Excel"    Size 30, 15 Pixel Action ( ;
Processa( { || GerExcel() },"Aguarde...", "Gerando arquivo.. ." ))

@ 245, 450  Button  "&Visualizar"    Size 30, 15 Pixel Action ( VisuTit() )

@ 245, 405  Button  "&Lib. Pedidos"    Size 35, 15 Pixel Action ( LibPV(_cCodCli, _cLojCli) )

ACTIVATE MSDIALOG _oDlg CENTERED

Return

Static Function GerExcel()

Local oFWMsExcel
Local oExcel
Local cArquivo    := GetTempPath()+'zTstExc1.xml'
Local nX          := 0
    
//Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()
    
//Aba 01 - Teste
oFWMsExcel:AddworkSheet("Posição") //Não utilizar número junto com sinal de menos. Ex.: 1-
//Criando a Tabela
oFWMsExcel:AddTable("Posição","Titulos Vencidos GP")
//Criando Colunas
//1 = Modo Texto
//2 = Valor sem R$
//3 = Valor com R$
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","EMPRESA",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","NUMERO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","PREFIXO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","PARCELA",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","TIPO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","CLIENTE",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","LOJA",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","RISCO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","CNPJ",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","HISTORICO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","EMISSAO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","VENCTO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","VALOR",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","SALDO",1,1)
oFWMsExcel:AddColumn("Posição","Titulos Vencidos GP","REGISTRO",1,1)
//Criando as Linhas
For nX := 1 To Len(_aDados)
    oFWMsExcel:AddRow("Posição","Titulos Vencidos GP",{;
                                                            _aDados[nX,1],;
                                                            _aDados[nX,2],;
                                                            _aDados[nX,3],;
                                                            _aDados[nX,4],;
                                                            _aDados[nX,5],;
                                                            _aDados[nX,6],;
                                                            _aDados[nX,7],;
                                                            _aDados[nX,8],;
                                                            _aDados[nX,9],;
                                                            _aDados[nX,10],;
                                                            _aDados[nX,11],;
                                                            _aDados[nX,12],;
                                                            _aDados[nX,13],;
                                                            _aDados[nX,14],;
                                                            _aDados[nX,15];
    })
    
    //Pulando Registro
Next nX

oFWMsExcel:AddRow("Posição","Titulos Vencidos GP",{"Valor Credito:","R$" + TRANSFORM(_cVlrCred, "@E 999,999,999,999.99"),"","","","Qtd. de Títulos: ",_nTit,"","","","","","","",""})
oFWMsExcel:AddRow("Posição","Titulos Vencidos GP",{"Venc. Lim. Credito: ",DTOC(_dDtCred),"","","","Total Saldo  Vencido: ","R$" + TRANSFORM(_nSaldo, "@E 999,999,999.99"),"","","","","","","",""})

//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
        
//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
oExcel:SetVisible(.T.)                 //Visualiza a planilha
oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
    
Return

Static Function VisuTit

Local cFilorig := cFilAnt

DbSelectArea("SE1")
DbSetOrder(2)
DbSeek(Left(_oDados:aArray[_oDados:nAt][1],4) + _oDados:aArray[_oDados:nAt][6] + _oDados:aArray[_oDados:nAt][7] ; 
    + _oDados:aArray[_oDados:nAt][3] + _oDados:aArray[_oDados:nAt][2];
    + _oDados:aArray[_oDados:nAt][4] + _oDados:aArray[_oDados:nAt][5])

cFilAnt := SE1->E1_FILIAL
FA280Visua("SE1",SE1->(Recno()),2)
cFilAnt := cFilorig

("SE1")->(DBCLOSEAREA())

Return

Static Function LibPV(_cCliente, _cLoja)

Private cCodLoja	:= _cCliente + _cLoja

Private cCGC		:= LEFT(alltrim(Posicione("SA1",1,xFilial("SA1")+cCodLoja,"A1_CGC")),8)+ "%"
Private _cRisco		:= alltrim(Posicione("SA1",1,xFilial("SA1")+cCodLoja,"A1_RISCO"))
Private nCred		:= 0
Private nValPed		:= 0
Private nTitulo		:= 0
Private nRA			:= 0
Private nNCC		:= 0
Private cNomCli 	:= ""
Private cRisco  	:= ""
Private dLimCred	:= ""
Private nDiasAtr	:= 0
Private _lTitulo	:= .F.
Private _cCodCli	:= _cCliente
Private _cLojCli	:= _cLoja

Private lMark		:= .T.
Private aBrwPV		:= {}
Private aBrwCr		:= {}

cQryLim := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_RISCO, A1_VENCLC, A1_LC,A1_LCFIN "
cQryLim += " FROM SA1020  A1 "
cQryLim += " WHERE A1_CGC BETWEEN '"+cCGC+"' AND '"+LEFT(Alltrim(cCGC),8)+"999999' AND A1.D_E_L_E_T_ = '' "
cQryLim += " ORDER BY A1_COD, A1_LOJA "

cQryLim :=	ChangeQuery(cQryLim)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryLim),"LIM",.T.,.T.)
	
LIM->(DbGoTop())


While ("LIM")->(!EOF())
		cNomCli := LIM->A1_NOME
		cRisco  := LIM->A1_RISCO
		dLimCred:= STOD(LIM->A1_VENCLC)
		nCred 	+= LIM->A1_LC+LIM->A1_LCFIN
	("LIM")->( DbSkip() )
enddo
LIM->(dbCloseArea())

//******************************
// BUSCA DADOS DO CREDITO
//*********************************
BuscaCR()

//***********************************
// BUSCA DADOS DOS PEDISO EM ABERTO
//***********************************
BuscaPV()

//***********************************
// MONTA TELA COM O CRÉDITO
//***********************************
MontaTela()


Return()


//****************************************************
// BUSCA INFORMAÇÕES DO CRÉDITO
//*****************************************************
Static Function BuscaCR()

Local _dData    := Date()
Local cQry	:= ''

if Select("CRED") > 0
	CRED->(dbclosearea())
endif

cQry  := " SELECT "
cQry  += " CASE WHEN E1_TIPO='NF' THEN '1 - TITULO' WHEN E1_TIPO='RA' THEN '2 - RA' WHEN E1_TIPO='NCC' THEN '3 - NCC' ELSE '4 - '+E1_TIPO END TIPO, "
cQry  += " E1_FILIAL, E1_NUM, E1_CLIENTE+'-'+E1_LOJA CLIENTE, E1_VENCREA, E1_SALDO AS SALDO, E1_HIST "
cQry  += " FROM SE1020 E1   "
cQry  += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_CGC BETWEEN '"+cCGC+"' AND '"+LEFT(Alltrim(cCGC),8)+"999999' AND A1.D_E_L_E_T_ = '' "
cQry  += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 AND E1_TIPO NOT IN('CF-','CS-','IR-','PI-') "
cQry  += " AND E1_TIPO <> 'NF' "
cQry  += " UNION ALL "
cQry  += " SELECT "
cQry  += " CASE WHEN E1_TIPO='NF' THEN '1 - TITULO' WHEN E1_TIPO='RA' THEN '2 - RA' WHEN E1_TIPO='NCC' THEN '3 - NCC' ELSE '4 - '+E1_TIPO END TIPO, "
cQry  += " E1_FILIAL, E1_NUM, E1_CLIENTE+'-'+E1_LOJA CLIENTE, E1_VENCREA, E1_SALDO AS SALDO, E1_HIST "
cQry  += " FROM SE1020 E1   "
cQry  += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_CGC BETWEEN '"+cCGC+"' AND '"+LEFT(Alltrim(cCGC),8)+"999999' AND A1.D_E_L_E_T_ = '' "
cQry  += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 AND E1_TIPO NOT IN('CF-','CS-','IR-','PI-') "
cQry  += " AND E1_TIPO = 'NF' "   //AND E1_VENCREA < '"+Dtos(_dData)+"' "  //
cQry  += " ORDER BY 1,2,3

cQry :=	ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"CRED",.T.,.T.)

//Trabalha a Informação
dbSelectArea("CRED")
dbGoTop()
While !Eof()

	If CRED->TIPO = "1 - TITULO"
		nTitulo += CRED->SALDO 		//Saldo do Contas a Receber em Aberto ate DdataBase (SE1) - tipo NF
		_lTitulo := .T.
	ElseIf CRED->TIPO = "2 - RA"
		nRA     += CRED->SALDO		//Saldo do 'RA' em Aberto ate DdataBase (SE1) - tipo RA
	ElseIf CRED->TIPO = "3 - NCC"
		nNCC    += CRED->SALDO		//Saldo do 'NCC' em Aberto ate DdataBase (SE1) - tipo NCC
	Endif
	
	//nDiasAtr	:= DateDiffDay(STOD(CRED->E1_VENCREA), dDataBase )
		
	aAdd(aBrwCr, {CRED->TIPO,;
	CRED->E1_FILIAL,;
	CRED->E1_NUM ,;
	CRED->CLIENTE,;
	STOD(CRED->E1_VENCREA),;
	CRED->SALDO,;
	nDiasAtr,;
	CRED->E1_HIST})                                                              
		
	CRED->(dbSkip())
Enddo
	
CRED->(dbCloseArea())

Return()


//***********************************
// BUSCA DADOS DOS PEDIDOS EM ABERTO
//***********************************
Static Function BuscaPV()

Local cQuery 		:= ""
Local cSitCred		:= ""

If Select("TRBSC5") > 0
	TRBSC5->( dbCloseArea() )
EndIf

cQuery :=	" SELECT C5_FILIAL, CASE C5_FILIAL "
cQuery +=	" WHEN '0101' THEN 'CIMEX'       "
cQuery +=	" WHEN '0201' THEN 'CROZE'       "
cQuery +=	" WHEN '0301' THEN 'KOPEK'       "
cQuery +=	" WHEN '0401' THEN 'MACO '       "
cQuery +=	" WHEN '0501' THEN 'QUBIT'       "
cQuery +=	" WHEN '0601' THEN 'ROJA '       "
cQuery +=	" WHEN '0701' THEN 'VIXEN'       "
cQuery +=	" WHEN '0801' THEN 'MAIZE'       "
cQuery +=	" WHEN '0901' THEN 'DEVINTEX FILIAL' "
cQuery +=	" WHEN '0902' THEN 'DEVINTEX FILIAL - MG' " 
cQuery +=	" WHEN '1001' THEN 'GLAZY' "
cQuery +=	" WHEN '1101' THEN 'BIZEZ' "
cQuery +=	" WHEN '1201' THEN 'ZAKAT' "
cQuery +=	" WHEN '1301' THEN 'HEXIL' "
cQuery +=	" WHEN '1401' THEN 'TROLL' "
cQuery +=	" END EMPRESA,  C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO,  A1_NOME, A3_GEREN, A3_NREDUZ, C5_X_STACR, C5_X_STAPV,  ROUND(SUM(VALOR),2) VALOR "
cQuery +=	" FROM (  "
cQuery +=	" SELECT  C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO,  A1_NOME, A31.A3_GEREN, A32.A3_NREDUZ, C5_X_STACR, C5_X_STAPV, C6_PRODUTO, C6_VALOR VALOR "
cQuery +=	" FROM SC5020 C5 WITH (NOLOCK) "
cQuery +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_='' " 
cQuery +=	" INNER JOIN SF4020 F4 ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES AND F4_DUPLIC='S' "
cQuery +=	" AND (F4_TEXTO LIKE 'VENDA%' OR F4_TEXTO LIKE 'VD%') AND F4.D_E_L_E_T_=' ' " 
cQuery +=	" INNER JOIN SC9020 C9 WITH (NOLOCK) ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C9.D_E_L_E_T_=''  "
cQuery +=	" AND (C9.C9_BLEST NOT IN ('','10','ZZ') OR C9.C9_BLCRED NOT IN ('','10','ZZ') ) AND C9_NFISCAL ='' "
cQuery +=	" AND C9.C9_PRODUTO = C6_PRODUTO "
cQuery +=	" INNER JOIN SA1020 A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_=''   "
cQuery +=	" LEFT JOIN SA3020 A31 WITH (NOLOCK) ON A31.A3_COD = C5_VEND1 AND A31.D_E_L_E_T_ = '' "
cQuery +=	" LEFT JOIN SA3020 A32 WITH (NOLOCK) ON A32.A3_COD = A31.A3_GEREN AND A32.D_E_L_E_T_ = '' "
cQuery +=	" WHERE C5.D_E_L_E_T_=''  "
cQuery +=	" AND C5_CLIENTE = '"+_cCodCli+"' AND C5_LOJACLI ='"+_cLojCli+"' AND C5_XLBCRED = 'T' "
cQuery +=	" ) X  "
cQuery +=	" GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO, A1_NOME, A3_GEREN, A3_NREDUZ, C5_X_STACR, C5_X_STAPV    "
cQuery +=	" ORDER BY C5_FILIAL, C5_NUM"    

TCQUERY cQuery NEW ALIAS "TRBSC5"

//Processa o Resultado
dbSelectArea("TRBSC5")
TRBSC5->(dbGoTop())

While TRBSC5->(!EOF())

	If TRBSC5->C5_X_STACR == '0'
		cSitCred := "0 - Liberado"
	ElseIf TRBSC5->C5_X_STACR == '1'
		cSitCred := "1 - Rejeitado"
	ElseIf TRBSC5->C5_X_STACR == '2'
		cSitCred := "2 - Blq Risco"
	ElseIf TRBSC5->C5_X_STACR == '3'
		cSitCred := "3 - Blq Data"
	Else 
		cSitCred := "4 - Blq Limite"
	EndIf
	
	aAdd(aBrwPV,{IF(ALLTRIM(lMark) = 'F', .T., .F.) ,;
	TRBSC5->C5_FILIAL,;
	TRBSC5->C5_NUM,;
	STOD(TRBSC5->C5_EMISSAO),;
	TRBSC5->C5_CLIENTE+"-"+TRBSC5->C5_LOJACLI,;
	SubStr(TRBSC5->A1_NOME,1,25),;
	TRBSC5->A3_GEREN+" "+TRBSC5->A3_NREDUZ,;
	cSitCred,;
	TRBSC5->C5_X_STAPV,;
	TRBSC5->VALOR})
		
	nValPed += TRBSC5->VALOR
	                                                               	
	TRBSC5->(dbSkip())
Enddo


TRBSC5->( dbCloseArea() )
Return()



//****************************************************
// APRESENTAR TDS OS PEDIDOS PENDENTES DO CLIENTE
//****************************************************
Static Function MontaTela()

Private oFont 	:= TFont():New('Courier new',,-14,.F.,.T.)
Private oFont1	:= TFont():New('Courier new',,-20,.F.,.T.)
Private oFont2	:= TFont():New('Courier new',,-18,.F.,.T.)
Private oFont3	:= TFont():New('Courier new',,-15,.F.,.T.)
Private oFont4	:= TFont():New('Courier new',,-24,.F.,.T.)
Private cUserLib := RetCodUsr()
Private cNomUser := USRRETNAME(RetCodUsr())

Private oOK 		:= LoadBitmap(GetResources(),'br_verde')
Private oNO 		:= LoadBitmap(GetResources(),'br_vermelho')

Private oTelPV
Private oGet1
Private oGet

Private nPedSel		:= 0

	
DEFINE MSDIALOG oTelPV FROM 38,16 TO 660,1090 TITLE Alltrim(OemToAnsi("ANALISE DE CRÉDITO")) Pixel

@ 002, 005 To 040, 535 Label Of oTelPV Pixel

//CABEÇALHO
oSay  	:= TSay():New(010,015,{|| "Cliente:" },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(010,057,{|| Substr(cNomCli,1,35) },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(022,015,{|| "Risco: "  },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(022,057,{|| cRisco  },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(010,225,{|| "Raiz CNPJ:" },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(010,290,{|| TRANSFORM(cCGC, "@R 99.999.999") },oTelPV,,oFont3,,,,.T.,) 

oSay  	:= TSay():New(022,225,{||  "Lim. de Crédito: " },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(022,300,{||  TRANSFORM(nCred	,"@E 99,999,999.99") },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(010,410,{||  "Dt. Vencimento:" },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(010,480,{||  dLimCred },oTelPV,,oFont3,,,,.T.,)

//@ 022,473 Button "CADASTRO CLIENTE" size 55,12 action MATA030() OF oTelPV PIXEL


//RODAPÉ
oSayT  	:= TSay():New(145,370,{|| "TOTAL DE PEDIDOS: " },oTelPV,,oFont3,,,,.T.,)
oGetT	:= tGet():New(143,455,{|u| if(Pcount()>0,nValPed:=u,nValPed) },,70,12,"@E 99,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValPed",,,,.F.,,,)

oSay  	:= TSay():New(265,010,{|| "Contas a Receber:  " + IF(nTitulo=0,"0",	TRANSFORM(nTitulo	,"@E 99,999,999.99")) },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(280,010,{|| "RA - Recto Adto : " +  IF(nRA=0,"0",		TRANSFORM(nRA 		,"@E 99,999,999.99")) },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(295,010,{|| "NCC - NF.Devoluc: " + IF(nNCC=0,"0",	TRANSFORM(nNCC		,"@E 99,999,999.99")) },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(265,250,{|| "SALDO DE CRÉDITO " },oTelPV,,oFont4,,,,.T.,)
oSayT  	:= TSay():New(290,250,{|| Transform(nCred + nRA + nNCC - nValPed - nTitulo	, "@E 99,999,999.99") },oTelPV,,oFont4,,,,.T.,If(nCred + nRA + nNCC - nValPed - nTitulo>0,CLR_GREEN,CLR_HRED))

@ 265,473.4 Button "LIBERAR PV" size 55,12 action Processa( {|| Libera()  }) OF oTelPV PIXEL
@ 280,473.4 Button "REJEITA PV" size 55,12 action Processa( {|| Rejeita() }) OF oTelPV PIXEL
@ 295,473.4 Button "FECHAR"  size 55,12 action oTelPV:End() OF oTelPV PIXEL


//*********************************
// LISTA DE PEDIDO
//**********************************
If Len(aBrwPV) == 0
	aAdd(aBrwPV,{.T.,SPACE(04),SPACE(06),SPACE(06),SPACE(06),SPACE(04),SPACE(04),SPACE(04),SPACE(04),0 })
Endif

oListBo	:= twBrowse():New(042,005,530,100,,{" ","FILIAL","PEDIDO","EMISSÃO","CÓDIGO","RAZÃO SOCIAL","GERENTE","STATUS CRÉDITO","STATUS PEDIDO","VALOR"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
oListBo:SetArray(aBrwPV)
oListBo:bLine := {||{ IIf(aBrwPV[oListBo:nAt][1],LoadBitmap( GetResources(), "UNCHECKED" ),LoadBitmap( GetResources(), "CHECKED" )),; //flag
aBrwPV[oListBo:nAt,02],;
aBrwPV[oListBo:nAt,03],;
aBrwPV[oListBo:nAt,04],;
aBrwPV[oListBo:nAt,05],;
aBrwPV[oListBo:nAt,06],;
aBrwPV[oListBo:nAt,07],;
aBrwPV[oListBo:nAt,08],;
aBrwPV[oListBo:nAt,09],;
aBrwPV[oListBo:nAt,10]}}

oListBo:bLDblClick := {|| Iif(oListBo:nColPos <> 5,(aBrwPV[oListBo:nAt,1] := !aBrwPV[oListBo:nAt,1]),(aBrwPV[oListBo:nAt,1] := .T.,)), oListBo:Refresh(), AtuAcols()  } 


//***************************
//LISTA DE CRÉDITO
//*****************************
If Len(aBrwCr) == 0
	aAdd(aBrwCr,{SPACE(04),SPACE(04),SPACE(04),SPACE(04),SPACE(04),SPACE(04),0,0,SPACE(10)})
Endif

oListBo2	:= twBrowse():New(160,005,530,100,,{"TIPO","FILIAL","NÚMERO","CLIENTE","VENC. REAL","SALDO","DIAS VENC.","HISTÓRICO"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
oListBo2:SetArray(aBrwCr)
oListBo2:bLine := {||{ aBrwCr[oListBo2:nAt,01],;
aBrwCr[oListBo2:nAt,02],;
aBrwCr[oListBo2:nAt,03],;
aBrwCr[oListBo2:nAt,04],;
aBrwCr[oListBo2:nAt,05],;
aBrwCr[oListBo2:nAt,06],;
aBrwCr[oListBo2:nAt,07],;
aBrwCr[oListBo2:nAt,08]}}
           
AtuAcols()

ACTIVATE MSDIALOG oTelPV centered

Return()          


//****************************************************************
//  Faz Liberação de Crédito de Todos os Pedido
//****************************************************************
Static Function Libera()

Local nx	:= 0
Local _cUser    := RetCodUsr()
Local _cNomeUsr := UsrRetName(_cUser)
Local cQuery	:= ""

If nValPed > 0

	If MsgYesNo("Deseja confirmar liberação dos pedidos selecionados?","Atenção!")
		
		For nx := 1 To Len(aBrwPV)
			
			If !aBrwPV[nx][1]	//Campo MARCADO (.F.)
				
				//QUERY COM UPDATE NO BANCO DE DADO PARA ATUALIZAÇÃO
				cQuery := " UPDATE "+RetSqlName("SC9")+" SET C9_BLCRED='', C9_BLEST ='' "
				cQuery += " WHERE "
				cQuery += " C9_FILIAL+ C9_PEDIDO = '"+aBrwPV[nx][2]+aBrwPV[nx][3]+"'  AND D_E_L_E_T_ = '' "
				TcSqlExec(cQuery)

                cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='0', C5_XUSRLIB = '"+_cNomeUsr+"', C5_XDTLIBM = '"+DtoS(DATE())+"' , C5_XLBCRED = 'F' "
				cQuery += " WHERE "
				cQuery += " C5_FILIAL+C5_NUM = '"+aBrwPV[nx][2]+aBrwPV[nx][3]+"' AND D_E_L_E_T_ = '' "
				TcSqlExec(cQuery)

				dbSelectArea("ZA1")
				dbSetOrder(1)
				RecLock("ZA1", .T.)
				ZA1->ZA1_FILIAL := aBrwPV[nx][2]
				ZA1->ZA1_PEDIDO := aBrwPV[nx][3]
				ZA1->ZA1_DTLIB  := Date()
				ZA1->ZA1_USER   := _cNomeUsr
				ZA1->ZA1_HORA   := Time()
				ZA1->(MsUnlock())

			Endif
				
		Next nx
		
		MSGINFO("Liberação dos pedidos efetuada com sucesso. ","Sucesso")
		
	Else
		
		MSGINFO("PROCESSO CANCELADO PELO USUARIO")
		
	Endif
	
Else
	MSGINFO("Nenhum pedido selecionado para liberação.","Atenção")
Endif

oTelPV:End()

Return()


//****************************************************************
//  Marca Pedido como Rejeitado
//****************************************************************
Static Function Rejeita()

Local nx	    := 0

If nValPed > 0
	
	If MsgYesNo("Deseja REJEITAR os pedidos selecionados?","Atenção!")
		
		For nx := 1 To Len(aBrwPV)
			
			If !aBrwPV[nx][1]  .AND. aBrwPV[nx][9] == "0"	//Campo MARCADO (.F.) AND Status do Pedido tem que ser "0"

				cQuery := " UPDATE "+RetSqlName("SC9")+" SET C9_BLCRED='09' "
				cQuery += " WHERE "
				cQuery += " C9_FILIAL+ C9_PEDIDO = '"+aBrwPV[nx][2]+aBrwPV[nx][3]+"'  AND D_E_L_E_T_ = '' "
				TcSqlExec(cQuery)
			
				cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='1' "
				cQuery += " WHERE "
				cQuery += " C5_FILIAL+C5_NUM = '"+aBrwPV[nx][2]+aBrwPV[nx][3]+"' AND D_E_L_E_T_ = '' "
				TcSqlExec(cQuery)
			Endif
				
		Next nx
		
		MSGINFO("Pedidos rejeitados com sucesso.","Sucesso")
		
	Else
		
		MSGINFO("PROCESSO CANCELADO PELO USUARIO")
		
	Endif
	
Else
	MSGINFO("Nenhum pedido selecionado para fazer o processo de rejeição.","Atenção")
Endif

Return()


//*******************************************************************
//Função - Atualiza ACOLS - Grid em Tela
//*******************************************************************
Static Function AtuAcols(_lFlag, _cFilial, _cPedido )

Local nx	:= 0

//Sempre Zera para Calcular novamente
nValPed		:= 0	
nPedSel		:= 0

For nx := 1 To Len(aBrwPV)
	
	If !aBrwPV[nx][1] 	//Campo MARCADO (.F.)
		
		nValPed 	+= aBrwPV[nx][10]		// Valor
				
		nPedSel++
	
	Endif 
		
Next nx

//Refresh em Tela
oGetT:Refresh()
oSayT:Refresh()

oTelPV:Refresh()
oListBo:Refresh()

Return()
