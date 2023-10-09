#INCLUDE "protheus.ch"
#include "Rwmake.ch"
#include "ap5mail.ch"
#Include "TopConn.Ch"

//****************************************************************************************
//CLIENTE		- SALON LINE
//FUNÇÃO		- Rotina - Enviar email Comanda
//MODULO		- Mod.Financeiro \ Atualizações \ Especifico \ # Envia Email Cobranca
//AUTORIZAÇÃO	- Renato Jacob / Genilson Lucas
//AUTOR 		- ANDRE SALGADO / INTRODE - DATA 06/07/2018 - TELEFONE 99440-6266

// Criado parametro:
//     ES_FINP02A - Tipo C - Informar o Email para Copia da Cobrança

// MELHORIA
// Data 18/01/19 - Sol.Renato - Chamado TK1901171 Filtra só Titulos Manifestados - autor André Salgado/Introde

//****************************************************************************************

User Function FINP0001()

cQL		:= CHR(13) + CHR(10)		//Enter
cQueryUp:= ""

//Parametro para Envio
MV_PAR01:= space(6)			// Cliente DE
MV_PAR02:= "ZZZZZZ"			// Cliente ATE
MV_PAR03:= space(6)			// Cliente DE
MV_PAR04:= "ZZZZZZ"			// Cliente ATE
MV_PAR05:= ctod("  /  /  ")	// Data DE
MV_PAR06:= ddatabase		// Data ATE
MV_PAR07:= "S" 				// Filtra Só cliente com email
MV_PAR08:= space(300)		// Email de transmissão
MV_PAR09:= space(02)		// Tipo de Cobranca De
MV_PAR10:= "ZZ"				// Tipo de Cobranca Ate
MV_PAR11:= "S" 				// Filtra Titulo MANIFESTADOS


//Monta Tela
@ 200, 001 To 480,580 Dialog oGeraTxt Title OemToAnsi("Parametros para Filtro ")
@ 005, 018 Say "Cliente De "
@ 005, 085 get MV_PAR01	size 50,50	F3 "SA1"
@ 015, 018 Say "Cliente Ate"
@ 015, 085 get MV_PAR02	size 50,50	F3 "SA1"
@ 025, 018 Say "Vendedor De"
@ 025, 085 get MV_PAR03	size 50,50	F3 "SA3"
@ 035, 018 Say "Vendedor Ate"
@ 035, 085 get MV_PAR04	size 50,50	F3 "SA3"
@ 045, 018 Say "Vencimento De "
@ 045, 085 get MV_PAR05	size 50,50
@ 055, 018 Say "Vencimento Ate "
@ 055, 085 get MV_PAR06	size 50,50
@ 065, 018 Say "Filtra só Cliente c/EMAIL "
@ 065, 085 get MV_PAR07	size 50,50
@ 075, 018 Say "Email p/Copia "
@ 075, 085 get MV_PAR08	size 100,100
@ 085, 018 Say "Tipo de Cobranca De "
@ 085, 085 get MV_PAR09	size 50,50	F3 "ZX"
@ 095, 018 Say "Tipo de Cobranca Ate "
@ 095, 085 get MV_PAR10	size 50,50	F3 "ZX"
@ 105, 018 Say "Filtra Titulos Manifestados"
@ 105, 085 get MV_PAR11	size 50,50

@ 120, 128 BmpButton Type 01 Action (GeraEM(),Close(oGeraTxt))
@ 120, 158 BmpButton Type 02 Action Close(oGeraTxt)
Activate Dialog oGeraTxt Centered

return


Static Function GeraEM()

//Busca os dados
cQuery := " SELECT "
cQuery += " E1_NUM, E1_PARCELA, A1_NOME, E1_CLIENTE,E1_LOJA, "
cQuery += " (convert(char(10),cast(E1_VENCREA as smalldatetime),103)) E1_VENCREA, E1_SALDO, A1_X_MAILC A1_EMAIL, E1_VEND1, A3_EMAIL, A3_NOME, A1_CGC,"
cQuery += " (convert(char(10),cast(E1_VENCREA as smalldatetime)+14,103)) LIMITE"
cQuery += " FROM "+RetSqlName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON E1_CLIENTE=A1_COD AND E1_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN  "+RetSqlName("SA3")+" A3 ON E1_VEND1=A3_COD AND A3.D_E_L_E_T_=' '"
cQuery += " WHERE E1.D_E_L_E_T_=' '"
cQuery += " 	AND E1_SALDO>0"
cQuery += " 	AND E1_FILIAL='"+xFilial("SE1")+"'"
cQuery += " 	AND E1_TIPO IN ('NF','DP','FT')"

//Incluir os Filtros dos Parametros
cQuery += " 	AND E1_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += " 	AND E1_VEND1   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " 	AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
//cQuery += " 	AND E1_INSTR2  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "		//Tipo de Cobrança

IF MV_PAR11="S"	//Filtra Só titulos MANIFESTADOS
	cQuery += " 	AND E1_X_DTMAN <> ' ' "
Endif

IF MV_PAR07="S"	//Filtra Cliente SÓ COM EMAIL
	cQuery += " AND A1_X_MAILC <> ' ' "
Endif

cQuery += " ORDER BY 4,5,1,2"

IF Select("TRV")>0
	DbSelectArea("TRV")
	DbCloseArea()
ENDIF
TCQUERY cQuery ALIAS TRV NEW



dbselectarea("TRV")
While !eof()
	
	//Variaveis
	cEmaiSA3:= alltrim(TRV->A3_EMAIL)	//Email Representante
	cNomeSA3:= alltrim(TRV->A3_NOME)	//Nome do Representante
	cEmaiSA1:= alltrim(TRV->A1_EMAIL)	//Email Cliente
	cNomeSA1:= alltrim(TRV->A1_NOME)	//Nome do Cliente
	cCodCli := TRV->E1_CLIENTE			//Codigo do Cliente
	cLJCli	:= TRV->E1_LOJA				//Loja do Cliente
	cCNPJCli:= Transform(TRV->A1_CGC,"@R 99.999.999/9999-99")
	
	//Validação Email
	If Empty(cEmaiSA1)
		Aviso("Atenção","Cliente sem Email no Cadastro, nao sera enviado para "+cCodCli+"/"+cLJCli+" "+cNomeSA1,{'Ok'})
		DBSKIP()
		LOOP
	Endif

	//Validação Email
	If Empty(cEmaiSA3)
		Aviso("Atenção","Representante sem Email no Cadastro, nao sera enviado para "+cNomeSA3,{'Ok'})
		DBSKIP()
		LOOP
	Endif

	
	_cMailTec:= cEmaiSA3 +";"+alltrim(MV_PAR08)		//Email Vendedor + Email Informado nos Parametros
	cMailDest:= cEmaiSA1							//Email do Cliente
	

	//Descrição do Email foi enviado pelo Sr. Renato Jacob / Juliana / Depto Financeiro	
	//Corpo do EMAIL
	cHtml := "Prezado(a) Cliente"+cQL+cQL+cQL
	cHtml += "Poderia confirmar o pagamento dos titulos vencidos, por favor?"+cQL+cQL
	
	cCorpo:= ""
	
	//Monta Impressão do Corpo com as Notas Atrasadas
	While cCodCli=TRV->E1_CLIENTE .AND. cLJCli=TRV->E1_LOJA
		
		cCorpo += " Duplicata: "+TRV->E1_NUM+if(Empty(TRV->E1_PARCELA),""," Parc."+TRV->E1_PARCELA)+cQL
		cCorpo += " Vencimento "+TRV->E1_VENCREA+cQL
		cCorpo += " Valor R$ "+transform(Round(TRV->E1_SALDO,2),"@E 999,999.99")
		cCorpo += cQL+cQL
		
		If TRV->LIMITE=dtoc(ddatabase) //Limite da data da cobrança
			cCorpo += "Lembrando que: HOJE é data limite para pagamento na rede bancária."+cQL+cQL+cQL		
		Else
			cCorpo += "Lembrando que a data limite para pagamento na rede bancária é dia:"+TRV->LIMITE+cQL+cQL+cQL
		Endif


	//Atualiza a Informação no Contas a Receber                    
		cQueryUp += " UPDATE "+RetSqlName("SE1")+" SET E1_TURMA = '"+PADR(dtoc(ddatabase)+" "+SUBSTR(CUSUARIO,7,15),20)+"' WHERE "
		cQueryUp += " E1_FILIAL = '"+xFilial("SE1")+"' AND "
		cQueryUp += " E1_NUM    = '"+TRV->E1_NUM   +"' AND "
		cQueryUp += " E1_PARCELA= '"+TRV->E1_PARCELA+"'"+cQL
			
		TRV->(dbskip())
		
	ENDDO
		
	cHtml += cCorpo+cQL	//Dados do Titulos
	cHtml += "Caro(a) representante:"+cQL+cQL
	cHtml += "Entrar em contato com o cliente, informar sobre o titulo vencido e nos retornar."+cQL+cQL+cQL+cQL
	cHtml += "Atencionamente,"+cQL+cQL
	cHtml += "Depto Contas a Receber - Salon Line"+cQL
	cHtml += "11 4210-5959 - Ramal 1015"+cQL
	
	cAssunto:= alltrim(cNomeSA1)+" - "+cCodCli+" LOJA "+cLJCli+TRIM(SM0->M0_FILIAL)+" "+cCNPJCli
	cCodCli := ""
	
	//FUNÇÃO - Envia email
	WF_EMAIL_(_cMailTec,cMailDest,cHtml,cAssunto)
	
ENDDO


//Atualiza Informação - CR
If !Empty(cQueryUp)
	TcSqlExec(cQueryUp)
Endif


Return




//Função para Transmissão de EMAIL
Static Function WF_EMAIL_(_cMailTec,_cTo,_cCorpo,cAssunto)

//PRIVATE _lResult // Resultado do Envio do e-mail
_cSmtpSrv   := ALLTRIM(GETMV("MV_RELSERV"))
cAccount	:= GETMV("MV_RELACNT") //"renato.cobranca@salonline.com.br" //GETMV("MV_RELACNT")
cEnvia    	:= GETMV("MV_RELACNT")
cPassword 	:= GETMV("MV_RELPSW")
cRecebe   	:= _cTo
cCC       	:= _cMailTec+","+trim(GETMV("ES_FINP02A"))
cCCo 		:= "" //GETMV("MV_EMAILCO")

cMensagem 	:= _cCorpo


CONNECT SMTP SERVER _cSmtpSrv ACCOUNT cAccount PASSWORD cPassword Result lConectou
MAILAUTH(cAccount,cPassword)


If	( lConectou )
	
	SEND MAIL FROM cEnvia;
	TO cRecebe;
	CC cCC;
	BCC cCCo;
	SUBJECT cAssunto;
	BODY cMensagem;
	RESULT lEnviado
	DISCONNECT SMTP SERVER Result lDisConectou
	
	If	( ! lConectou )
		GET MAIL ERROR _cSmtpError
		ConOut(_cSmtpError)
		_lReturn := .f.
		Alert("FALHA NO ENVIO DO E-MAIL !!!")
	EndIf
	
	DISCONNECT SMTP SERVER
	//	ConOut('Desconectando do Servidor')
	_lReturn := .t.
Else
	GET MAIL ERROR _cSmtpError
	ConOut(_cSmtpError)
	ALERT("ERRO")
	_lReturn := .f.
EndIf

Return( Nil )
