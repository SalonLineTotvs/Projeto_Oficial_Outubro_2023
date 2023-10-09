#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#INCLUDE "rwmake.ch"
#Include "Font.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FINP0003    บ Autor ณ Genilson M Lucas    Data ณ  28/07/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina: Projeto Cobran็a								      บฑฑ
ฑฑบ          ณTRAZER - Tela para Consultar mais FACIL os dados da Cobran็aบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ   a) Busca os Pedidos de Venda em ABERTO (SC6) (tempo real)บฑฑ
ฑฑบ          ณ   b) Busca o contas a receber em Aberto (SE1) <  Ddatabase บฑฑ
ฑฑบ          ณ   c) Tem a possibilidade de Atualizar a Informa็ใo (SA1)   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 														      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function FINP0003(_cFilial, _cCliente, _cLoja)

Private cCodLoja	:= _cCliente + _cLoja

//alert(_cFilial+ _cCliente+ _cLoja)

Private cCGC		:= LEFT(alltrim(Posicione("SA1",1,xFilial("SA1")+cCodLoja,"A1_CGC")),8)
Private nCred		:= 0
Private nValPed		:= 0
Private nTitulo		:= 0
Private nRA			:= 0
Private nNCC		:= 0
Private cNomCli 	:= ""
Private cRisco  	:= ""
Private dLimCred	:= ""
Private nDiasAtr	:= 0

Private lMark		:= .T.
Private aBrwPV		:= {}
Private aBrwCr		:= {}



//*******************************************************
//BUSCA CLIENTE E DESPOIS BUSCA O PRIMEIRO CำDIGO DO GRUPO
//*******************************************************

//dbSelectArea("SA1")
//dbSetOrder(1)
//dbSeek(xFilial("SA1")+cCodLoja)


cQryLim := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_RISCO, A1_VENCLC, A1_LC "
cQryLim += " FROM SA1020  A1 "
cQryLim += " WHERE A1_CGC BETWEEN '"+cCGC+"' AND '"+cCGC+"999999' AND A1.D_E_L_E_T_ = '' "
cQryLim += " ORDER BY A1_COD, A1_LOJA "

cQryLim :=	ChangeQuery(cQryLim)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryLim),"LIM",.T.,.T.)
	
LIM->(DbGoTop())

cNomCli := LIM->A1_NOME
cRisco  := LIM->A1_RISCO
dLimCred:= STOD(LIM->A1_VENCLC)
nCred 	:= LIM->A1_LC

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
// MONTA TELA COM O CRษDITO
//***********************************
MontaTela()


Return()


//****************************************************
// BUSCA INFORMAวีES DO CRษDITO
//*****************************************************
Static Function BuscaCR()

Local cQry	:= ''

if Select("CRED") > 0
	CRED->(dbclosearea())
endif

cQry  := " SELECT "
cQry  += " CASE WHEN E1_TIPO='NF' THEN '1 - TITULO' WHEN E1_TIPO='RA' THEN '2 - RA' WHEN E1_TIPO='NCC' THEN '3 - NCC' ELSE '4 - '+E1_TIPO END TIPO, "
cQry  += " E1_FILIAL, E1_NUM, E1_CLIENTE+'-'+E1_LOJA CLIENTE, E1_VENCREA, E1_SALDO AS SALDO, E1_HIST "
cQry  += " FROM SE1020 E1   "
cQry  += " INNER JOIN SA1020 A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_CGC BETWEEN '"+cCGC+"' AND '"+cCGC+"999999' AND A1.D_E_L_E_T_ = '' "
cQry  += " WHERE E1.D_E_L_E_T_=' ' AND E1_SALDO > 0 AND E1_TIPO NOT IN('CF-','CS-','IR-','PI-') "
cQry  += " ORDER BY 1,2,3

cQry :=	ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"CRED",.T.,.T.)


//Trabalha a Informa็ใo
dbSelectArea("CRED")
dbGoTop()
While !Eof()

	If CRED->TIPO = "1 - TITULO"
		nTitulo += CRED->SALDO 		//Saldo do Contas a Receber em Aberto ate DdataBase (SE1) - tipo NF
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
// BUSCA DADOS DOS PEDISO EM ABERTO
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

cQuery +=	" END EMPRESA,  C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO,  A1_NOME, A3_GEREN, A3_NREDUZ, C5_X_STACR, C5_X_STAPV,  ROUND(SUM(VALOR),2) VALOR "
cQuery +=	" FROM (  "
cQuery +=	" SELECT  C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_EMISSAO,  A1_NOME, A31.A3_GEREN, A32.A3_NREDUZ, C5_X_STACR, C5_X_STAPV, C6_PRODUTO, C6_VALOR VALOR "
cQuery +=	" FROM SC5020 C5 WITH (NOLOCK) "
cQuery +=	" INNER JOIN SC6020 C6 WITH (NOLOCK) ON C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM AND C6.D_E_L_E_T_='' " 
cQuery +=   " INNER JOIN SF4020 F4 ON C6_FILIAL+C6_TES = F4_FILIAL+F4_CODIGO AND F4_DUPLIC='S' AND F4.D_E_L_E_T_=' ' "
cQuery +=	" INNER JOIN SC9020 C9 WITH (NOLOCK) ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_=''  "
cQuery +=	" INNER JOIN SA1020 A1 WITH (NOLOCK) ON C5_CLIENTE = A1_COD AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_=''   "
cQuery +=	" LEFT JOIN SA3020 A31 WITH (NOLOCK) ON A31.A3_COD = C5_VEND1 AND A31.D_E_L_E_T_ = '' "
cQuery +=	" LEFT JOIN SA3020 A32 WITH (NOLOCK) ON A32.A3_COD = A31.A3_GEREN AND A32.D_E_L_E_T_ = '' "
 
cQuery +=	" WHERE C5.D_E_L_E_T_=''  AND C5_TIPO = 'N' AND C5_NOTA = ''  "
cQuery +=	" AND A1_CGC BETWEEN '"+cCGC+"' AND '"+cCGC+"999999' "
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

	
DEFINE MSDIALOG oTelPV FROM 38,16 TO 660,1090 TITLE Alltrim(OemToAnsi("ANALISE DE CRษDITO")) Pixel

@ 002, 005 To 040, 535 Label Of oTelPV Pixel

//CABEวALHO
oSay  	:= TSay():New(010,015,{|| "Cliente:" },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(010,057,{|| Substr(cNomCli,1,35) },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(022,015,{|| "Risco: "  },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(022,057,{|| cRisco  },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(010,225,{|| "Raiz CNPJ:" },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(010,290,{|| TRANSFORM(cCGC, "@R 99.999.999") },oTelPV,,oFont3,,,,.T.,) 

oSay  	:= TSay():New(022,225,{||  "Lim. de Cr้dito: " },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(022,300,{||  TRANSFORM(nCred	,"@E 99,999,999.99") },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(010,410,{||  "Dt. Vencimento:" },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(010,480,{||  dLimCred },oTelPV,,oFont3,,,,.T.,)

@ 022,473 Button "CADASTRO CLIENTE" size 55,12 action MATA030() OF oTelPV PIXEL


//RODAPษ
oSayT  	:= TSay():New(145,370,{|| "TOTAL DE PEDIDOS: " },oTelPV,,oFont3,,,,.T.,)
oGetT	:= tGet():New(143,455,{|u| if(Pcount()>0,nValPed:=u,nValPed) },,70,12,"@E 99,999,999.99",,,,oFont3,,,.T.,,,,,,,.T.,,,"nValPed",,,,.F.,,,)

oSay  	:= TSay():New(265,010,{|| "Contas a Receber:  " + IF(nTitulo=0,"0",	TRANSFORM(nTitulo	,"@E 99,999,999.99")) },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(280,010,{|| "RA - Recto Adto : " +  IF(nRA=0,"0",		TRANSFORM(nRA 		,"@E 99,999,999.99")) },oTelPV,,oFont3,,,,.T.,)
oSay  	:= TSay():New(295,010,{|| "NCC - NF.Devoluc: " + IF(nNCC=0,"0",	TRANSFORM(nNCC		,"@E 99,999,999.99")) },oTelPV,,oFont3,,,,.T.,)

oSay  	:= TSay():New(265,250,{|| "SALDO DE CRษDITO " },oTelPV,,oFont4,,,,.T.,)
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

oListBo	:= twBrowse():New(042,005,530,100,,{" ","FILIAL","PEDIDO","EMISSรO","CำDIGO","RAZรO SOCIAL","GERENTE","STATUS CRษDITO","STATU PEDIDO","VALOR"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
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
//LISTA DE CRษDITO
//*****************************
If Len(aBrwCr) == 0
	aAdd(aBrwCr,{SPACE(04),SPACE(04),SPACE(04),SPACE(04),SPACE(04),SPACE(04),0,0,SPACE(10)})
Endif

oListBo2	:= twBrowse():New(160,005,530,100,,{"TIPO","FILIAL","NฺMERO","CLIENTE","VENC. REAL","SALDO","DIAS VENC.","HISTำRICO"},,oTelPV,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
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
//  Faz Libera็ใo de Cr้dito de Todos os Pedido
//****************************************************************
Static Function Libera()

Local nx	:= 0

If nValPed > 0
	
	If MsgYesNo("Deseja confirmar libera็ใo dos pedidos selecionados?","Aten็ใo!")
		
		For nx := 1 To Len(aBrwPV)
			
			If !aBrwPV[nx][1]  .AND. aBrwPV[nx][9] == "0"	//Campo MARCADO (.F.) AND Status do Pedido tem que ser "0"
					
				//QUERY COM UPDATE NO BANCO DE DADO PARA ATUALIZAวรO
				cQuery := " UPDATE "+RetSqlName("SC9")+" SET C9_BLCRED='' "
				cQuery += " WHERE "
				cQuery += " C9_FILIAL+ C9_PEDIDO = '"+aBrwPV[nx][2]+aBrwPV[nx][3]+"'  AND D_E_L_E_T_ = '' "
				TcSqlExec(cQuery)
	
				cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_X_STACR='0' "
				cQuery += " WHERE "
				cQuery += " C5_FILIAL+C5_NUM = '"+aBrwPV[nx][2]+aBrwPV[nx][3]+"'  AND D_E_L_E_T_ = '' "
				TcSqlExec(cQuery)
	
			Endif
				
		Next nx
		
		//Processa({|| U_WB_LOG001() },"Aguarde, integrando pedidos para logํstica...")
		
		MSGINFO("Libera็ใo dos pedidos efetuada com sucesso. ","Sucesso")
		
	Else
		
		MSGINFO("PROCESSO CANCELADO PELO USUARIO")
		
	Endif
	
Else
	MSGINFO("Nenhum pedido selecionado para libera็ใo.","Aten็ใo")
Endif

oTelPV:End()

Return()


//****************************************************************
//  Marca Pedido como Rejeitado
//****************************************************************
Static Function Rejeita()

Local cMail 	:= "genilson.lucas@salonline.com.br"//GETMV("ES_MAIL")
Local _cTo		:= UsrRetMail(__cUserId)
Local cBody		:= ''
Local nx	:= 0

If nValPed > 0
	
	If MsgYesNo("Deseja REJEITAR os pedidos selecionados?","Aten็ใo!")
		
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
		
		cAssunto := "Pedido Rejeitado pelo Financeiro"
		cBody := Chr(13)+Chr(10);
		+"Usuario: "+SUBSTR(CUSUARIO,7,15)+" - "+DTOC(DDATABASE)+" - "+SUBSTR(TIME(),1,5)+ Chr(13)+Chr(10);
		+"Codigo : "+SA1->A1_COD+" "+SA1->A1_LOJA+" - Razao Social: "+ALLTRIM(SA1->A1_NOME)
	
		U_SendMail( cMail,_cTo,, cAssunto, cBody, )
	
		MSGINFO("Pedidos rejeitados com sucesso.","Sucesso")
		
	Else
		
		MSGINFO("PROCESSO CANCELADO PELO USUARIO")
		
	Endif
	
Else
	MSGINFO("Nenhum pedido selecionado para fazer o processo de rejei็ใo.","Aten็ใo")
Endif

Return()


//*******************************************************************
//Fun็ใo - Atualiza ACOLS - Grid em Tela
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

