#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณProcSafr  บAutor  ณ Eduardo Augusto    บ Data ณ  03/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para mostrar o processamento da tela de gera็ใo de  บฑฑ
ฑฑบ          ณ boletos.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function ProcSafr(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero,_cSpool)

Private oObj
Private _lBolOK 		:= .F.
Default  _cBanco		:= ""
Default  _cAgencia		:= ""
Default  _cConta		:= ""
Default  _cSubcta		:= ""
Default  _Tipo			:= ""
Default  _EmisIni		:= CtoD("  /  /  ")
Default  _EmisFim		:= CtoD("  /  /  ")
Default  _cTitulo		:= ""
Default  _cBordero		:= ""     
Default _cSpool         := ""

oObj := MsNewProcess():New({|lEnd| BolSafra(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero,_cSpool,@_lBolOK) },"Processando","Gerando Boletos...",.T.)	//Processamento da gera็ใo de boletos
oObj:Activate()

Return(_lBolOK)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบ Programa      ณ BOLETOS                          บ Data ณ 03/08/2020  บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao     ณ Programa para Geracao de Boleto Grafico Itau          บฑฑ
ฑฑบ				  ณ	utilizando o Objeto FWMSPTRINTER.					  บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออหอออออออออัออออออออออออออออออออออนฑฑ
ฑฑบ Desenvolvedor ณ Eduardo Augusto      บ Empresa ณ EAPS Desenvolvimento บฑฑ
ฑฑฬอออออออออออออออุออออออออออออหออออออออัสออออออหออฯออออออออออออออออออออออนฑฑ
ฑฑบ Linguagem     ณ Advpl      บ Versao ณ 12    บ Sistema ณ Microsiga     บฑฑ
ฑฑฬอออออออออออออออุออออออออออออสออออออออฯอออออออสอออออออออออออออออออออออออนฑฑ
ฑฑบ Modulo(s)     ณ SIGAFIN                                               บฑฑ
ฑฑฬอออออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Tabela(s)     ณ SM0 / SE1 / SEE / SA6                                 บฑฑ
ฑฑฬอออออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observacao    ณ  Alterado Dia 23/09/2014                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function BolSafra(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero,_cSpool,_lBolOK)

Local nCont     		:= 0
Local i
Local lRet				:=	.T.
Private oPrint   		:= Nil
Private oFont18N,oFont18,oFont16N,oFont16,oFont14N,oFont12N,oFont10N,oFont14,oFont12,oFont10,oFont08N
Private _limpr	 		:= .T.
//Private cBitmap	 	:= "\system\Logohsbc.jpg"
Private lAdjustToLegacy := .F.
Private lDisableSetup   := .T.
Private lServer         := .T.      as logical // Indica impressรฃo via Server (.REL Nรฃo serรก copiado para o Client). Default รฉ .F <<<<<<<<<----------------------iMPORTANTE----------
Private lViewPDF        := .F.      as logical // Quando o tipo de impressรฃo for PDF, define se arquivo serรก exibido apรณs a impressรฃo. O default รฉ .T.
Private _nVlrAbat		:= 0
Private aFilePDF		:= {}	
Default  _cBanco		:= ""
Default  _cAgencia		:= ""
Default  _cConta		:= ""
Default  _cSubcta		:= ""
Default  _Tipo			:= ""
Default  _EmisIni		:= CtoD("  /  /  ")
Default  _EmisFim		:= CtoD("  /  /  ")
Default  _cTitulo		:= ""
Default  _cBordero		:= ""
Default _cSpool         := ""

oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
oFont18 	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont16 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont14 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
oFont06		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont05N	:= TFont():New("Arial",05,05,,.T.,,,,.T.,.F.)
oFont05		:= TFont():New("Arial",05,05,,.F.,,,,.T.,.F.)
oFont04N	:= TFont():New("Arial",04,04,,.T.,,,,.T.,.F.)
oFont04		:= TFont():New("Arial",04,04,,.F.,,,,.T.,.F.)

nReq := 0
nReq := Len(aVetor)

If oObj != Nil
	oObj:SetRegua1(nReq)
	oObj:SetRegua2(nReq)
EndIf   

For i := 1 to Len(aVetor)
	oObj:IncRegua1("Processando, Analisando os Boletos... " )
	_lBolOK := .F.
	If aVetor[i,1] == .T.
		nCont++
		// Contas a Receber
   		dbSelectArea("SE1")
		SE1->( dbSetOrder(1) )	// E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
		SE1->(dbSeek(aVetor[i,20] + aVetor[i,2] + aVetor[i,3] + aVetor[i,4] + aVetor[i,13]))
		// Alimento a variavel com os abatimentos dos impostos
		_nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA) + SE1->E1_ACRESC - SE1->E1_DECRESC
		nTitAnt := cValToChar(SE1->E1_NUM)     //--Salvo n๚mero do Titulo para posterior utiliza็ใo
		nPrfAnt := SE1->E1_PREFIXO 			   //--Salvo prefixo do Titulo para posterior utiliza็ใo
		nFilAnt := SE1->E1_FILIAL
		// Parametros Bancos
		dbSelectArea("SEE")
		SEE->( dbSetOrder(1) )	// EE_FILIAL + EE_CODIGO + EE_AGENCIA + EE_CONTA + EE_SUBCTA
		SEE->( dbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta) )
		_cDvAge		:= SEE->EE_DVAGE
		_cDvCta		:= SEE->EE_DVCTA
		_cCart		:= SEE->EE_CODCART
		_nxJuros	:= SEE->EE_XJUROS
		_nxMulta	:= SEE->EE_XMULTA
		_cProtesto	:= SEE->EE_DIASPRT
		_cCodEmp	:= SEE->EE_CODEMP

		lRet	:=	U_CodBco422(_cBanco,_cAgencia,_cConta,_cDvCta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero)
		//Jonas, em caso de nosso numero nใo preenchido aborta impressใo 
		If !lRet
			Return
		EndIf
		If !Empty (SE1->E1_NFELETR)
		_cArquivo :=  DTOS(DATE())+ "_422_"+cValToChar(i)	//_cArquivo := AllTrim(SE1->E1_FILIAL) + "_" + StrZero(Val(SE1->E1_NFELETR),9) + "_" + Alltrim(SE1->E1_PARCELA) + "_422" 
		Else	
		_cArquivo :=  DTOS(DATE())+ "_422_"+cValToChar(i)	//_cArquivo := AllTrim(SE1->E1_FILIAL) + "_" + AllTrim(SE1->E1_NUM) + "_" + Alltrim(SE1->E1_PARCELA) + "_422" 
		Endif
		cFileName := "C:\Boleto422\" + _cArquivo
		clocal:="C:\Boleto422"
		U_zClearBol(@cFileName)
		
		// Impressao
		//oPrint := FWMSPrinter():New(_cArquivo, IMP_PDF, lAdjustToLegacy,, lDisableSetup,,,,,,,.F.,)// Ordem obrigแtoria de configura็ใo do relat๓rio
		oPrint := FWMSPrinter():New(_cArquivo,,lAdjustToLegacy,clocal,lDisableSetup,NIL, NIL, "PDF", lServer, NIL, NIL, lViewPDF) //<--- a impressรฃo deve ser realizada por IMP_SPOOL, caso contrรกrio nรฃo darรก certo.
    			
		oPrint:SetResolution(72)			// Default
		oPrint:SetPortrait() 				// SetLandscape() ou SetPortrait()
		oPrint:SetPaperSize(9)				// A4 210mm x 297mm  620 x 876
		oPrint:SetMargin(10,10,10,10)		// < nLeft>, < nTop>, < nRight>, < nBottom>
		oPrint:cPathPDF := "C:\Boleto422\"

		//IMPRESSรO AUTOMATICA
		IF !Empty(_cSpool)	
			aRet := GetImpWindows(.F.) // Indica se, verdadeiro (.T.), retorna as impressoras do Application Server; caso contrแrio, falso (.F.), do Smart Client.
			IF (_nImpter := aScan(aRet, AllTrim(_cSpool))) > 0
				oPrint:SetDevice(IMP_SPOOL) //2-Impressora
				oPrint:cPrinter 	:= aRet[_nImpter]
				oPrint:cPathPrint 	:= "\SPOOL\"
				oPrint:cPathPDF 	:= ''
				_lBolOK := .T.	 				
			Else	
				_lBolOK := .F.	
				IF !IsBlind() 
					_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Aten็ใo</font> '
					_cPopUp += ' <br> '
					_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Boleto Automatico</font> '
					_cPopUp += ' <br>'
					_cPopUp += ' <font color="#000000" face="Arial" size="3">Impressora: '+_cSpool+', nใo configurada </font> '
					_cPopUp += ' <br> '
					_cPopUp += ' <font color="#000000" face="Arial" size="2">Por gentileza, entre em contato com o administrador! </font> '
					Alert(_cPopUp,'Boleto Automatico')
				ENDIF
				oPrint := Nil
				Return(_lBolOK)	
			ENDIF
		ENDIF

		//oPrint:SetViewPdf(_limpr)
		oPrint:StartPage()   	// Inicia uma nova pแgina
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )	// A1_FILIAL + A1_COD
		SA1->( dbSeek(xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA ),.F.) )
		//	Montagem do Box + Dados
		// < nRow>, < nCol>, < nBottom>, < nRight>, [ cPixel]
		// 1ฐ Parte
		_cBcoLogo:=""
		_cDigBanco:=""
		aBcos := { {"422","7", "Logo422.jpg"}  }
		nF := ASCan(aBcos ,{|x|, x[1] == _cBanco })
		If nF == 0
			MsgBox(Iif(Empty(_cBanco),"O numero do banco nao foi informado","Nao ha layout previsto para o banco " + _cBanco))
		Else
			_lContinua := .T.
			_cDigBanco := aBcos[nF,2]
			_cBcoLogo  := aBcos[nF,3]
		EndIf
		oPrint:SayBitmap(0020,0025,_cBcoLogo,0085,0020)
		oPrint:Say(0036,0110, "|" + _cBanco + "-" + _cDigBanco + "|" ,oFont18N,100)	// C๓digo do Banco + Dํgito
		cCgcSM0 := SM0->M0_CGC
		oPrint:Say (0036, 0448,"Comprovante de Entrega",oFont12N )	// Comprovante de Entrega
		BuzzBox  (0040,0025,0065,0325)	// Box Beneficiแrio + Cnpj
		oPrint:Say (0046, 0026,"Beneficiแrio",oFont06N )
		oPrint:Say (0056, 0026,Alltrim(Substr(SM0->M0_NOMECOM,1,30)),oFont06 )
		oPrint:Say (0046, 0140,"Endere็o",oFont06N )
		oPrint:Say (0053, 0140,Alltrim(Substr(SM0->M0_ENDCOB,1,30)) + " - " + UPPER(Alltrim(SM0->M0_BAIRCOB)),oFont06 )
		oPrint:Say (0060, 0140,"CEP: " + Alltrim(Substr(SM0->M0_CEPCOB,1,5)) + "-" + Alltrim(Substr(SM0->M0_CEPCOB,6,3)) + " - " + Alltrim(SM0->M0_CIDCOB) + " / " + Alltrim(SM0->M0_ESTCOB),oFont06 )
		oPrint:Say (0046,0270,"Cnpj" ,oFont06N,100) 
		oPrint:Say (0056,0270,Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont06) //Cnpj do Beneficiแrio
		BuzzBox  (0040,0325,0065,0410)	// Box Agencia / Codigo do Cedente
		oPrint:Say (0046, 0326,"Ag๊ncia/C๓digo Beneficiแrio",oFont06N )
		IF AllTrim(_cAgencia) $ "0097"
			oPrint:Say (0060, 0340,"09700 / " + Padl(Substr(Alltrim(_cConta),1,7),8,"0") + Substr(Alltrim(_cDvCta),1,1),oFont08,100)
		ELSE
			oPrint:Say (0060, 0340,PadL(Substr(Alltrim(_cAgencia),1,4),5,"0") + " / " + Padl(Substr(Alltrim(_cConta),1,7),8,"0") + Substr(Alltrim(_cDvCta),1,1),oFont08,100)
		ENDIF
		BuzzBox  (0040,0410,0065,0480)	// Nฐ do Documento
		oPrint:Say (0046, 0411,"Nฐ do Documento",oFont06N )
		If !Empty (SE1->E1_NFELETR)
			//oPrint:Say (0060, 0411,SE1->E1_PREFIXO +  StrZero(Val(SE1->E1_NFELETR),9) + SE1->E1_PARCELA,oFont08 )
			oPrint:Say (0060, 0411,  StrZero(Val(SE1->E1_NFELETR),9) + SE1->E1_PARCELA,oFont08 )
		Else
			oPrint:Say (0060, 0411,SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,oFont08 )
		Endif
		//oPrint:Say (0060, 0415,SE1->E1_NUM + " " + SE1->E1_PARCELA,oFont08 )
		BuzzBox  (0040,0480,0140,0560)	// Box de Selecao
		oPrint:Say (0050, 0481,"(  )Mudou-se"               ,oFont06N,100)
		oPrint:Say (0060, 0481,"(  )Ausente"                ,oFont06N,100)
		oPrint:Say (0070, 0481,"(  )Nใo existe nบ indicado"	,oFont06N,100)
		oPrint:Say (0080, 0481,"(  )Recusado"               ,oFont06N,100)
		oPrint:Say (0090, 0481,"(  )Nใo procurado"          ,oFont06N,100)
		oPrint:Say (0100, 0481,"(  )Endere็o insuficiente"  ,oFont06N,100)
		oPrint:Say (0110, 0481,"(  )Desconhecido"           ,oFont06N,100)
		oPrint:Say (0120, 0481,"(  )Falecido"               ,oFont06N,100)
		oPrint:Say (0130, 0481,"(  )Outros(anotar no verso)",oFont06N,100)
		BuzzBox  (0065,0025,0090,0250)	// Box do Pagador
		oPrint:Say (0071, 0026,"Pagador",oFont06N )
		oPrint:Say (0081, 0026,Upper(SA1->A1_NOME),oFont08 )
		BuzzBox  (0065,0250,0090,0350)	// Box do Vencimento
		oPrint:Say (0071, 0251,"Vencimento",oFont06N )
		oPrint:Say (0085, 0301,Substr( DtoS(SE1->E1_VENCREA),7,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),5,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),1,4 ),oFont08 )
		BuzzBox  (0065,0350,0090,0480)	// Box do Valor do Documento
		oPrint:Say (0071, 0351,"Valor do Documento",oFont06N )
		oPrint:Say (0085, 0420,Alltrim(Transform(SE1->E1_SALDO - _nVlrAbat,"@E 999,999,999.99")),oFont08N )
		BuzzBox  (0090,0025,0140,0250)	// Box Recebi(emos) o Bloqueto / Titulo com as caracteristicas acima
		oPrint:Say (0107, 0026,"Recebi(emos) o Bloqueto / Titulo",oFont08N )
		oPrint:Say (0117, 0026,"com as caracteristicas acima",oFont08N )
		BuzzBox  (0090,0250,0115,0330)	// Box de Data
		oPrint:Say (0096, 0251,"Data",oFont06N )
		BuzzBox  (0090,0330,0115,0480)	// Box de Assinatura
		oPrint:Say (0096, 0331,"Assinatura",oFont06N )
		BuzzBox  (0115,0250,0140,0330)	// Box de Data
		oPrint:Say (0121, 0251,"Data",oFont06N )
		BuzzBox  (0115,0330,0140,0480)	// Box de Entregador
		oPrint:Say (0121, 0331,"Entregador",oFont06N )
		// 2ฐ Parte
		oPrint:SayBitmap(0160,0025,_cBcoLogo,0085,0020)
		oPrint:Say(0176,0110, "|" + _cBanco + "-" + _cDigBanco + "|" ,oFont18N,100)	// C๓digo do Banco + Dํgito
		oPrint:Say (0176, 0470,"Recibo do Pagador",oFont12N )	// Recibo do Pagador
		BuzzBox  (0180,0025,0205,0425)	// Local de Pagamento
		oPrint:Say (0186, 0026,"Local de Pagamento",oFont06N )
		oPrint:Say  (0196, 0096,"Pagแvel em qualquer Banco do Sistema de Compensa็ใo",oFont06N )
		BuzzBox  (0180,0425,0205,0560)	// Vencimento
		oPrint:Say (0186, 0426,"Vencimento",oFont06N )
		oPrint:Say (0196, 0476,Substr( DtoS(SE1->E1_VENCREA),7,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),5,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),1,4 ),oFont08 )
		BuzzBox  (0205,0025,0230,0425)	// Beneficiario
		oPrint:Say (0211, 0026,"Beneficiแrio",oFont06N )
		oPrint:Say (0221, 0026,Alltrim(SM0->M0_NOMECOM),oFont06 )
		oPrint:Say (0211, 0205,"Endere็o",oFont06N )
		oPrint:Say (0218, 0205,Alltrim(Substr(SM0->M0_ENDCOB,1,30)) + " - " + UPPER(Alltrim(SM0->M0_BAIRCOB)),oFont06 )
		oPrint:Say (0225, 0205,"CEP: " + Alltrim(Substr(SM0->M0_CEPCOB,1,5)) + "-" + Alltrim(Substr(SM0->M0_CEPCOB,6,3)) + " - " + Alltrim(SM0->M0_CIDCOB) + " / " + Alltrim(SM0->M0_ESTCOB),oFont06 )
		oPrint:Say (0211, 0375,"Cnpj" ,oFont06N,100) 
		oPrint:Say (0221, 0375,Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont06) //Cnpj do Beneficiแrio
		BuzzBox  (0205,0425,0230,0560)	// Agencia 	/ Codigo do Cedente
		oPrint:Say (0211, 0426,"Ag๊ncia/C๓digo Beneficiแrio",oFont06N )
		IF AllTrim(_cAgencia) $ "0097"
			oPrint:Say (0221, 0436,"09700 / " + Padl(Substr(Alltrim(_cConta),1,7),8,"0") + Substr(Alltrim(_cDvCta),1,1),oFont08,100)
		ELSE
			oPrint:Say (0221, 0436,PadL(Substr(Alltrim(_cAgencia),1,4),5,"0") + " / " + Padl(Substr(Alltrim(_cConta),1,7),8,"0") + Substr(Alltrim(_cDvCta),1,1),oFont08,100)
		ENDIF
		BuzzBox  (0230,0025,0255,0100)	// Data do Documento
		oPrint:Say (0236, 0026,"Data do Documento",oFont06N )
		oPrint:Say (0250, 0056,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont08 )
		BuzzBox  (0230,0100,0255,0225)	// Nro. Documento + Parcela
		oPrint:Say (0236, 0101,"Nฐ do Documento",oFont06N )
		If !Empty (SE1->E1_NFELETR)
			//oPrint:Say (0250, 0111,SE1->E1_PREFIXO +  StrZero(Val(SE1->E1_NFELETR),9) + SE1->E1_PARCELA,oFont08 )
			oPrint:Say (0250, 0111,  StrZero(Val(SE1->E1_NFELETR),9) + SE1->E1_PARCELA,oFont08 )
		Else
			oPrint:Say (0250, 0111,SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,oFont08 )
		Endif
		//oPrint:Say (0250, 0111,SE1->E1_NUM + " " + SE1->E1_PARCELA,oFont08 )
		BuzzBox  (0230,0225,0255,0275)	// Especie Doc.
		oPrint:Say (0236, 0226,"Especie Doc.",oFont06N )
		oPrint:Say (0250, 0246,"DM",oFont08 )
		BuzzBox  (0230,0275,0255,0325)	// Aceite
		oPrint:Say (0236, 0276,"Aceite",oFont06N )
		oPrint:Say (0250, 0306,"N",oFont08 )
		BuzzBox  (0230,0325,0255,0425)	// Data do Processamento
		oPrint:Say (0236, 0326,"Data do Processamento",oFont06N )
		oPrint:Say (0250, 0356,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont08 )
		BuzzBox  (0230,0425,0255,0560)	// Nosso Numero
		oPrint:Say (0236, 0426,"Nosso Numero",oFont06N )
		oPrint:Say (0250, 0476,Substr(SE1->E1_NUMBCO,1,Len(Alltrim(SE1->E1_NUMBCO))-1) + "-" + Right(AllTrim(SE1->E1_NUMBCO),1),oFont08 ) 
		BuzzBox  (0255,0025,0280,0100)	// Uso do Banco
		oPrint:Say (0261, 0026,"Uso do Banco",oFont06N )
		BuzzBox  (0255,0100,0280,0165)	// Carteira
		oPrint:Say (0261, 0101,"Carteira",oFont06N )
		oPrint:Say (0275, 0131,Substr(_cCart,2,2),oFont08 )
		BuzzBox  (0255,0165,0280,0225)	// Especie
		oPrint:Say (0261, 0166,"Especie",oFont06N )
		oPrint:Say (0275, 0186,"R$",oFont08 )
		BuzzBox  (0255,0225,0280,0325)	// Quantidade
		oPrint:Say (0261, 0226,"Quantidade",oFont06N )
		BuzzBox  (0255,0325,0280,0425)	// Valor
		oPrint:Say (0261, 0326,"Valor",oFont06N )
		BuzzBox  (0255,0425,0280,0560)	// Valor do Documento
		oPrint:Say (0261, 0426,"Valor do Documento",oFont06N )
		oPrint:Say (0275, 0476,Alltrim(Transform(SE1->E1_SALDO - _nVlrAbat,"@E 999,999,999.99")),oFont08N )
		BuzzBox  (0280,0025,0380,0425)	// Instru็๕es (Todas as Informa็๕es deste Bloqueto sใo de Exclusiva Responsabilidade do Cedente)
		oPrint:Say  (0286, 0026,"INSTRUวีES (Todas as informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio)",oFont06N )
		oPrint:Say  (0306,0026,"Ap๓s vencimento cobrar mora de R$ ..... " + Alltrim(Transform((((SE1->E1_SALDO - _nVlrAbat) * _nxJuros)/100)/30,"@E 99,999,999.99")) + " ao dia", oFont08,100)
		oPrint:Say  (0316,0026,"Sujeito a protesto ap๓s o vencimento.", oFont08,100)
		//If SEE->EE_XMULTA > 0
		//	oPrint:Say  (0326,0026,"Multa por atraso de " + Alltrim(Transform(_nxMulta,"@E 99,999,999.99")) + " % ao m๊s.", oFont08,100)
		//EndIf
		//oPrint:Say  (0336,0026,"Protestar apos " + _cProtesto + " dias ๚teis do vencimento.", oFont08,100)
		//If !Empty(SE1->E1_DECRESC)
		//	oPrint:Say  (0346,0026,"Conceder Desconto de R$ ..... " + AllTrim(Transform((SE1->E1_DECRESC),"@E 99,999,999.99")), oFont08,100)
		//EndIf
		BuzzBox  (0280,0425,0300,0560)	// (-) Desconto / Abatimento
		oPrint:Say (0286, 0426,"(-) Desconto / Abatimento",oFont06N )
		BuzzBox  (0300,0425,0320,0560)	// (-) Outras Dedu็๕es
		oPrint:Say (0306, 0426,"(-) Outras Dedu็๕es",oFont06N )
		BuzzBox  (0320,0425,0340,0560)	// (+) Mora / Multa
		oPrint:Say (0326, 0426,"(+) Mora / Multa",oFont06N )
		BuzzBox  (0340,0425,0360,0560)	// (+) Outros Acrescimos
		oPrint:Say (0346, 0426,"(+) Outros Acrescimos",oFont06N )
		BuzzBox  (0360,0425,0380,0560)	// (=) Valor Cobrado
		oPrint:Say (0366, 0426,"(=) Valor Cobrado",oFont06N )
		BuzzBox  (0380,0025,0450,0560)	// Pagador / Pagador Avalista
		oPrint:Say (0386, 0026,"Pagador",oFont06N )
		oPrint:Say  (0396,0106,Upper(SA1->A1_NOME),oFont06 ,100)
		oPrint:Say  (0406,0106,SA1->(If(Empty(A1_ENDCOB),A1_END,A1_ENDCOB) + " " + If(Empty(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)),oFont08 ,100)
		oPrint:Say  (0416,0106,SA1->(If(Empty(SA1->A1_CEPC),SA1->A1_CEP,SA1->A1_CEPC) + " " + If(Empty(SA1->A1_MUNC),SA1->A1_MUN,SA1->A1_MUNC) + " " + If(Empty(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)),oFont08 ,100)
		oPrint:Say  (0426,0106,SA1->(Transform(Alltrim(SA1->A1_CGC),PesqPict("SA1","A1_CGC")) + "               " + A1_INSCR),oFont08 ,100)
		oPrint:Say (0448, 0026,"Beneficiแrio Final",oFont06N )
		oPrint:Say  (0455,0360,"Autentica็ใo Mecโnica",oFont06,100)
		// 3ฐ Parte
		oPrint:SayBitmap(0480,0025,_cBcoLogo,0085,0020)
		_cCodBar := Alltrim(SE1->E1_CODBAR)
		_cNumBol := Alltrim(SE1->E1_CODDIG)
		_cCodBarLit := Left(_cNumBol,5) + "." + Substr(_cNumBol,6,5) + "   " +;			// Campo 1
					   Substr(_cNumBol,11,5) + "." + Substr(_cNumBol,16,6) + "   " +;	// Campo 2
					   Substr(_cNumBol,22,5) + "." + Substr(_cNumBol,27,6) + "   " +;	// Campo 3
					   Substr(_cNumBol,33,1) + "   " +;									// Campo 4
					   Substr(_cNumBol,34)												// Campo 5
		oPrint:Say(0496,0200,_cCodBarLit,oFont14N,100)
		oPrint:Say(0496,0110, "|" + _cBanco + "-" + _cDigBanco + "|" ,oFont18N,100)	// C๓digo do Banco + Dํgito
		BuzzBox  (0500,0025,0525,0425)	// Local de Pagamento
		oPrint:Say (0506, 0026,"Local de Pagamento",oFont06N )
		oPrint:Say  (0516, 0096,"Pagแvel em qualquer Banco do Sistema de Compensa็ใo",oFont06N )
		BuzzBox  (0500,0425,0525,0560)	// Vencimento
		oPrint:Say (0506, 0426,"Vencimento",oFont06N )
		oPrint:Say (0516, 0476,Substr( DtoS(SE1->E1_VENCREA),7,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),5,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),1,4 ),oFont08 )
		BuzzBox  (0525,0025,0550,0425)	// Beneficiario
		oPrint:Say (0531, 0026,"Beneficiแrio",oFont06N )
		oPrint:Say (0541, 0026,ALLTRIM(SM0->M0_NOMECOM),oFont06 )
		oPrint:Say (0531, 0205,"Endere็o",oFont06N )
		oPrint:Say (0538, 0205,Alltrim(Substr(SM0->M0_ENDCOB,1,30)) + " - " + UPPER(Alltrim(SM0->M0_BAIRCOB)),oFont06 )
		oPrint:Say (0545, 0205,"CEP: " + Alltrim(Substr(SM0->M0_CEPCOB,1,5)) + "-" + Alltrim(Substr(SM0->M0_CEPCOB,6,3)) + " - " + Alltrim(SM0->M0_CIDCOB) + " / " + Alltrim(SM0->M0_ESTCOB),oFont06 )
		oPrint:Say (0531, 0375,"Cnpj" ,oFont06N,100) 
		oPrint:Say (0541, 0375,Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont06) //Cnpj do Beneficiแrio
		BuzzBox  (0525,0425,0550,0560)	// Agencia / Codigo do Cedente
		oPrint:Say (0531, 0426,"Ag๊ncia/C๓digo Beneficiแrio",oFont06N )
		IF AllTrim(_cAgencia) $ "0097"
			oPrint:Say (0541, 0436,"09700 / " + Padl(Substr(Alltrim(_cConta),1,7),8,"0") + Substr(Alltrim(_cDvCta),1,1),oFont08,100)
		ELSE
			oPrint:Say (0541, 0436,PadL(Substr(Alltrim(_cAgencia),1,4),5,"0") + " / " + Padl(Substr(Alltrim(_cConta),1,7),8,"0") + Substr(Alltrim(_cDvCta),1,1),oFont08,100)
		ENDIF
		BuzzBox  (0550,0025,0575,0100)	// Data do Documento
		oPrint:Say (0556, 0026,"Data do Documento",oFont06N )
		oPrint:Say (0570, 0046,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont08 )
		BuzzBox  (0550,0100,0575,0225)	// Nro. Documento + Parcela
		oPrint:Say (0556, 0101,"Nฐ do Documento",oFont06N )
		If !Empty (SE1->E1_NFELETR)
			//oPrint:Say (0570, 0111,SE1->E1_PREFIXO +  Alltrim(SE1->E1_NFELETR) + SE1->E1_PARCELA,oFont08 )
			oPrint:Say (0570, 0111,  StrZero(Val(SE1->E1_NFELETR),9) + SE1->E1_PARCELA,oFont08 )
		Else
			oPrint:Say (0570, 0111,SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,oFont08 )
		Endif
		//oPrint:Say (0570, 0111,SE1->E1_NUM + " " + SE1->E1_PARCELA,oFont08 )
		BuzzBox  (0550,0225,0575,0275)	// Especie Doc.
		oPrint:Say (0556, 0226,"Especie Doc.",oFont06N )
		oPrint:Say (0570, 0246,"DM",oFont08 )
		BuzzBox  (0550,0275,0575,0325)	// Aceite
		oPrint:Say (0556, 0276,"Aceite",oFont06N )
		oPrint:Say (0570, 0296,"N",oFont08 )
		BuzzBox  (0550,0325,0575,0425)	// Data do Processamento
		oPrint:Say (0556, 0326,"Data do Processamento",oFont06N )
		oPrint:Say (0570, 0356,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont08 )
		BuzzBox  (0550,0425,0575,0560)	// Nosso Numero
		oPrint:Say (0556, 0426,"Nosso Numero",oFont06N )
		oPrint:Say (0570, 0476,Substr(SE1->E1_NUMBCO,1,Len(Alltrim(SE1->E1_NUMBCO))-1) + "-" + Right(AllTrim(SE1->E1_NUMBCO),1),oFont08 )
		BuzzBox  (0575,0025,0600,0100)	// Uso do Banco
		oPrint:Say (0581, 0026,"Uso do Banco",oFont06N )
		BuzzBox  (0575,0100,0600,0165)	// Carteira
		oPrint:Say (0581, 0101,"Carteira",oFont06N )
		oPrint:Say (0595, 0131,Substr(_cCart,2,2),oFont08 )
		BuzzBox  (0575,0165,0600,0225)	// Especie
		oPrint:Say (0581, 0166,"Especie",oFont06N )
		oPrint:Say (0595, 0186,"R$",oFont08 )
		BuzzBox  (0575,0225,0600,0325)	// Quantidade
		oPrint:Say (0581, 0226,"Quantidade",oFont06N )
		BuzzBox  (0575,0325,0600,0425)	// Valor
		oPrint:Say (0581, 0326,"Valor",oFont06N )
		BuzzBox  (0575,0425,0600,0560)	// Valor do Documento
		oPrint:Say (0581, 0426,"Valor do Documento",oFont06N )
		oPrint:Say (0595, 0476,Alltrim(Transform(SE1->E1_SALDO - _nVlrAbat,"@E 999,999,999.99")),oFont08N )
		BuzzBox  (0600,0025,0700,0425)	// Instru็๕es (Todas as Informa็๕es deste Bloqueto sใo de Exclusiva Responsabilidade do Cedente)
		oPrint:Say  (0606, 0026,"INSTRUวีES (Todas as informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio)",oFont06N )
		oPrint:Say  (0626,0026,"Ap๓s vencimento cobrar mora de R$ ..... " + Alltrim(Transform((((SE1->E1_SALDO - _nVlrAbat) * _nxJuros)/100)/30,"@E 99,999,999.99")) + " ao dia", oFont08,100)
		oPrint:Say  (0636,0026,"Sujeito a protesto ap๓s o vencimento.", oFont08,100)
		//If SEE->EE_XMULTA > 0
		//	oPrint:Say  (0646,0026,"Multa por atraso de " + Alltrim(Transform(_nxMulta,"@E 99,999,999.99")) + " % ao m๊s.", oFont08,100)
		//EndIf
		//oPrint:Say  (0656,0026,"Protestar apos " + _cProtesto + " dias ๚teis do vencimento.", oFont08,100)
		//If !Empty(SE1->E1_DECRESC)
		//	oPrint:Say  (0666,0026,"Conceder Desconto de R$ ..... " + AllTrim(Transform((SE1->E1_DECRESC),"@E 99,999,999.99")), oFont08,100)
		//EndIf
		BuzzBox  (0600,0425,0620,0560)	// (-) Desconto / Abatimento
		oPrint:Say (0606, 0426,"(-) Desconto / Abatimento",oFont06N )
		BuzzBox  (0620,0425,0640,0560)	// (-) Outras Dedu็๕es
		oPrint:Say (0626, 0426,"(-) Outras Dedu็๕es",oFont06N )
		BuzzBox  (0640,0425,0660,0560)	// (+) Mora / Multa
		oPrint:Say (0646, 0426,"(+) Mora / Multa",oFont06N )
		BuzzBox(0660,0425,0680,0560)	// (+) Outros Acrescimos
		oPrint:Say(0666, 0426,"(+) Outros Acrescimos",oFont06N )
		BuzzBox(0680,0425,0700,0560)	// (=) Valor Cobrado
		oPrint:Say(0686, 0426,"(=) Valor Cobrado",oFont06N )
		BuzzBox(0700,0025,0770,0560)	// Pagador / Pagador Avalista
		oPrint:Say(0706, 0026,"Pagador",oFont06N )
		oPrint:Say(0716,0106,Upper(SA1->A1_NOME),oFont08 ,100)
		oPrint:Say(0726,0106,SA1->(If(Empty(A1_ENDCOB),A1_END,A1_ENDCOB) + " " + If(Empty(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)),oFont08 ,100)
		oPrint:Say(0736,0106,SA1->(If(Empty(SA1->A1_CEPC),SA1->A1_CEP,SA1->A1_CEPC) + " " + If(Empty(SA1->A1_MUNC),SA1->A1_MUN,SA1->A1_MUNC) + " " + If(Empty(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)),oFont08 ,100)
		oPrint:Say(0746,0106,SA1->(Transform(Alltrim(SA1->A1_CGC),PesqPict("SA1","A1_CGC")) + "               " + A1_INSCR),oFont08 ,100)
		oPrint:Say(0768, 0026,"Beneficiแrio Final",oFont06N )
		//oPrint:Say (0768, 0106,ALLTRIM(SM0->M0_NOMECOM) + Space(05) + Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont08N )
		oPrint:Say(0775,0400,"Autentica็ใo Mecโnica - Ficha de Compensa็ใo",oFont06,100)
		oPrint:FWMSBAR("INT25",66.2,2.0,_cCodBar,oPrint,.F.,,,,1.0,,,,.F.)  //28.0
				oPrint:SetViewPDF(.F.)
     	oPrint:EndPage()
     	oPrint:Preview(.F.)
		
		
		//add expressao para aceitar senha no doc pdf//
			////cSenhaRelatorio := "b07085"
	
		CPFouCNPJ:=posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE + E1_LOJA ),"A1_CGC")   
		cSenhaRelatorio := "S"+substr(CPFouCNPJ,1,5)

	    ShellExecute( "Open", "C:\TOTVS-ORACLE\printer.exe", cFileName+".rel PDF_WITH_PASSWORD senhauser "+cSenhaRelatorio,clocal, 1 )
 	   // ShellExecute( "Open", "C:\TOTVS-ORACLE\printer.exe", cFileName+".pdf PDF_WITH_PASSWORD senhauser "+cSenhaRelatorio,clocal, 1 )
			u_T151FWMSG()
		_cArquivo:=_cArquivo+".pdf"
		cFileName:=cFileName+".pdf"

		//Caso for impressใo direta (impressora) nao envia e-mail
		// _lBolOK := .T.
		// IF !Empty(_cSpool)
		// 	IF oPrint <> Nil
		// 		oPrint:Preview()
		// 		FreeObj(oPrint)
		// 		MS_FLUSH()
		// 		oPrint := Nil
		// 	EndIF
		// 	U_zClearBol(@cFileName)
		// Else
		// 	oPrint:Print()

			//--Tratamento auxiliar para validar se ้ um novo titulo de outro cliente para envio	 
			nChave1   := aVetor[i,20]+aVetor[i,2]+aVetor[i,3] 				 				    			   //--Chave auxiliar 1//
			nChave2   := aVetor[i,20]+aVetor[i,2]+aVetor[i,3]+aVetor[i,4] 					    			   //--Chave auxiliar 2
			lExistPP  := If(Ascan(aVetor,{|x|x[1] == .T. .And. x[20]+x[2]+x[3] ==  nChave1 .And.;
											x[20]+x[2]+x[3]+x[4] >  nChave2}) > 0,.T.,.F.) 				   	    //--Verifica se existe proximo parcela
			lExistPT  := If(Ascan(aVetor,{|x|x[1] == .T. .And. x[20]+x[2]+x[3]+x[4] ==  nChave2 }) > 0,.T.,.F.) //--Verifica se existe proximo Titulo
			If lExistPP		
				AADD(aFilePDF,{cFilename,_cArquivo})
			EndIf		
			If !lExistPP .And. lExistPT

				AADD(aFilePDF,{cFilename,_cArquivo}) 
				oObj:IncRegua2("Enviando por e-mail boletos do Tํtulo " + Alltrim(aVetor[i,3]) )

				U_MCFATA03(aVetor[i,20], aVetor[i,21], aVetor[i,3],aVetor[i,2],aFilePDF,aVetor[i,5]) 
				aFilePDF := {} //--Limpa array para novos arquivos
			EndIf
		//ENDIF
	EndIf
Next

//Caso nao for impressใo direta (impressora) abrirแ diret๓rio
IF Empty(_cSpool)
	MsgInfo("Foram Salvos " + AllTrim(Str(nCont)) + " Boletos no Diret๓rio C:\Boleto422\")
	WinExec( "Explorer.exe C:\Boleto422")
ENDIF

Return(_lBolOK)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma ณ BuzzBox         บAutorณ Silvio Cazela              บ Data ณ 24/04/2013 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricaoณ Desenha um Box Sem Preenchimento                                       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function BuzzBox(_nLinIni,_nColIni,_nLinFin,_nColFin) // < nRow>, < nCol>, < nBottom>, < nRight>

oPrint:Line( _nLinIni,_nColIni,_nLinIni,_nColFin,CLR_BLACK, "-2")
oPrint:Line( _nLinFin,_nColIni,_nLinFin,_nColFin,CLR_BLACK, "-2")
oPrint:Line( _nLinIni,_nColIni,_nLinFin,_nColIni,CLR_BLACK, "-2")
oPrint:Line( _nLinIni,_nColFin,_nLinFin,_nColFin,CLR_BLACK, "-2")

Return

/*/{Protheus.doc} CodBco422
(long_description) Fonte p/ Tratamento Do Nosso Numero, Digitos Verificadores, Montagem da Linha Digitavel e Codigo de Barras.
@type  Static Function
@author user Eduardo Silva
@since date 03.08.2020
@version version 12.1.25
@param param, param_type, param_descr
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function CodBco422(_cBanco,_cAgencia,_cConta,_cDvCta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero)

Local _cNumBar    := ""
Local _cNossoNum  := ""
Local lRet			:=	.T.
//Private _cBanco	  := _cBanco
private _cDigBar  := ""
Private _cDigCor  := ""
Private _nDigtc3  := 0
Private cQuery	  := ""
Private _cDig1bar := 0

Default  _cBanco		:= ""
Default  _cAgencia		:= ""
Default  _cConta		:= ""
Default  _cSubcta		:= ""
Default  _Tipo			:= ""
Default  _EmisIni		:= CtoD("  /  /  ")
Default  _EmisFim		:= CtoD("  /  /  ")
Default  _cTitulo		:= ""
Default	 _cBordero		:= ""

If Select( "TMP" ) > 0
	TMP->( dbCloseArea() )
EndIf
cSelect	:= " SELECT  *			" 									+ ENTER
cFrom	:= " FROM "+ RetSqlName("SEE") +" SEE " 					+ ENTER
cWhere	:= " WHERE SEE.EE_FILIAL 	= '" +  xFilial("SEE")  + "' "	+ ENTER
cWhere	+= " 	AND SEE.D_E_L_E_T_ 	= ' '" 							+ ENTER
cWhere	+= " 	AND SEE.EE_CODIGO= '" + _cBanco + "'  	" 			+ ENTER
cQuery := cSelect + cFrom + cWhere
MemoWrite( "rfatr01b.sql" , cQuery )
TcQuery cQuery New Alias "TMP"

_cParcIni	:= SE1->E1_PARCELA
_cPrefixo	:= SE1->E1_PREFIXO
_cNum    	:= SE1->E1_NUM
_cParcFim	:= SE1->E1_PARCELA

If Empty(_cBanco)
	_cBanco   := TMP->EE_CODIGO
	_cAgencia := TMP->EE_AGENCIA
	_cConta   := TMP->EE_CONTA
	_cDvCta   := TMP->EE_DVCTA
	_cSubcta  := TMP->EE_SUBCTA
EndIf

_cNossoNum	:= ""

If _Tipo == 2 .And. !Empty(SE1->E1_XNUMBCO)
  _cNossoNum := SE1->E1_XNUMBCO
Else
	_cNossoNum	:= Nosso422(_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero)
EndIf

//Jonas, tratando em caso de nosso numero vir vazio
If Empty(_cNossoNum)
	Msginfo("Nosso n๚mero nใo preenchido, verifique se a tabela de parametros para o banco informado esta preenchida (SEE).")
	lRet:=.F.
	Return lRet
EndIf

_cNossoNum	:= Alltrim(_cNossoNum)
_cNossoDig	:= Right(_cNossoNum,1)
_cNossoNum	:= Left(_cNossoNum,Len(_cNossoNum)-1)
_cDigBar	:= ""
_cNumBar	:= _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)

If !Empty(_cNossoNum) .Or. !Empty(_cNumBar) .Or. !Empty(_cNumbol)
	If SE1->(Reclock(Alias(),.F.))
		SE1->E1_NUMBCO  :=_cNossoNum + _cNossoDig
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO  := _cNossoNum + _cNossoDig
		Else
			SE1->E1_NUMBCO  := SE1->E1_NUMBCO
		EndIf
		SE1->E1_PORTADO	:= _cBanco
		SE1->E1_AGEDEP	:= _cAgencia
		SE1->E1_CONTA	:= _cConta
		SE1->E1_CODBAR  := _cNumBar
		SE1->E1_CODDIG  := _cNumBol
		If Empty(SE1->E1_XNUMBCO) // Vazio
			SE1->E1_XNUMBCO := SE1->E1_NUMBCO
		Else // Ja gravaDo
			If _Tipo == 2 .And. !Empty(SE1->E1_XNUMBCO)
  				SE1->E1_NUMBCO := SE1->E1_XNUMBCO // Usa o original
			Else
				_cNossoNum := SE1->E1_XNUMBCO
			EndIf
		EndIf
		SE1->( MsUnLock() )
	EndIf
EndIf

RetIndex("SA1")

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ_fNumBol  บAutor  ณEduardo Silva       บ Data ณ  03/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para Montagem da Linha Digitavel.				  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon                                                       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)

_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
_cDig1	 := _fDigVer(_cCampo1,_cBanco)
_cCampo2 := Substr(_cNumBar,25,10)
_cDig2	 := _fDigVer(_cCampo2,_cBanco)
_cCampo3 := Substr(_cNumBar,35,10)
_cDig3	 := _fDigVer(_cCampo3,_cBanco)
_cCampo4 := _cDigBar
_cCampo5 := Substr(_cNumBar,06,14)
_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5

Return _cNumBol

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ_fNumBar  บAutor  ณEduardo Silva       บ Data ณ  03/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para Montagem do C๓digo de Barras.				  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon                                                      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,_cDigBar,_cNossoDig)

_cCampo1 := _cBanco
_cCampo1 += "9"
_cCampo1 += Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4)
_cCampo1 += Strzero((SE1->E1_SALDO - _nVlrAbat) * 100,10)
_cCampo1 += "7"
IF AllTrim(_cAgencia) $ "0097"
	_cCampo1 += "09700"
ELSE
	_cCampo1 += Strzero(Val(Alltrim(_cAgencia)),5)
ENDIF
_cCampo1 += Strzero(Val(Alltrim(_cConta)),8)
_cCampo1 += Strzero(Val(Alltrim(_cDvCta)),1)
_cCampo1 += _cNossoNum
_cCampo1 += _cNossoDig
_cCampo1 += "2"
_cNumBar := Left(_cCampo1,4) + (_cDigBar := _fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)


Return _cNumBar

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ_fDigVer  บAutor  ณEduardo Silva       บ Data ณ  03/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para calcular os Digitos Verificadores dos campos บฑฑ
ฑฑบ          ณ 1, 2 e 3.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon                                                      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function _fDigVer(_cCampo,_cBanco)

Local _nVez		:= 0
Local _nFator	:= 0
Local _nPeso	:= 2
Local _nReturn	:= 0
Local _nResult	:= 0
Local _cResult	:= ""

For _nVez := Len(_cCampo) To 1 Step - 1
	_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
	_cResult := Strzero(_nResult,2)
	_nFator	 += Val(Substr(_cResult,1,1))
	_nFator  += Val(Substr(_cResult,2,1))
	_nPeso := If(_nPeso == 2,1,2)
Next

_nReturn := Mod(_nFator,10)

If _nReturn > 0
	_nReturn := 10 - _nReturn
EndIf

SEE->( dbCloseArea() )

Return Str(_nReturn,1)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ_fDigBar  บAutor  ณEduardo Silva       บ Data ณ  03/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para calcular o Digito Verificador Centralizador. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon                                                       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function _fDigBar(_cCampo,_cBanco)

Local _nVez		:= 0
Local _nPeso	:= 2
Local _nFator	:= 0
Local _nResto	:= 0

For _nVez := Len(_cCampo) to 1 Step -1
	_nFator += Val(Substr(_cCampo,_nVez,1)) * _nPeso
	_nPeso  := If(_nPeso < 9,_nPeso + 1,2)
Next

_nResto := Mod(_nFator,11)

If _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10
	_nResto := 1
Else
	_nResto := 11 - _nResto
EndIf

SEE->( dbCloseArea() )

Return Str(_nResto,1)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณNosso422  บAutor  ณEduardo Silva       บ Data ณ  03/08/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para calcular o digito do Nosso Numero.			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon                                                       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Nosso422(_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero)

Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _cResult    := ""
Local _nFator     := 0
Local _nVez       := 0

If Empty(SE1->E1_NUMBCO)
	dbSelectArea("SEE")
	dbSetOrder(1)	// EE_FILIAL + EE_CODIGO + EE_AGENCIA + EE_CONTA + EE_SUBCTA
	If dbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta,.T.)
		RecLock("SEE",.F.)
		SEE->EE_FAXATU := Soma1(SEE->EE_FAXATU,8)
		MsUnlock()
		_xNosso_num := Strzero(Val(SEE->EE_FAXATU),8)
		_xVariavel	:= _xNosso_num
		_nPeso  := 2
		_nFator := 0
		_nResto := 0
		For _nVez := Len(_xVariavel) to 1 Step -1
			_nFator += Val(Substr(_xVariavel,_nVez,1)) * _nPeso
			_nPeso  := If(_nPeso < 9,_nPeso + 1,2)
		Next
		_nResto := Mod(_nFator,11)
		If _nResto == 1
			_cResult := "0"
		ElseIf _nResto == 0
			_cResult := "1"
		Else
			_nResto  := 11 - _nResto
			_cResult := Str(_nResto,1)
		EndIf
	Else
		Conout("Nใo existe configura็ใo para o banco informado SEE, favor preencher.")
		Msginfo("Nใo existe configura็ใo para o banco informado SEE, favor preencher.")
	EndIf
Else
	_cRet := SE1->E1_NUMBCO
EndIf

Return(_xNosso_num + _cResult)
