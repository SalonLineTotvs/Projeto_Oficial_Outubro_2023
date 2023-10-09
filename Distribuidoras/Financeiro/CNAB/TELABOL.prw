#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "PrTopDef.ch"

#DEFINE ENTER Chr(13)+Chr(10) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ TELABOL  ºAutor  ³Eduardo Augusto     º Data ³  26/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte para Tela de Impressão de Boletos com filtros para   º±±
±±º          ³ Seleção dos titulos da Tabela SE1 (Contas a Receber).      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cofran Lanternas					                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TELABOL()                              

Local cTitulo	:= "Seleção de Boletos"
Local oOk		:= LoadBitmap(GetResources(),"LBOK")
Local oNo		:= LoadBitmap(GetResources(),"LBNO")
Local cVar

Local _cBanco		:= ""
Local _cAgencia		:= ""
Local _cConta		:= ""
Local _ccta		:= ""
Local _Tipo			:= ""
Local _EmisIni		:= CtoD("  /  /  ")
Local _EmisFim		:= CtoD("  /  /  ")
Local _cTitulo		:= ""
Local _cBordero		:= ""
Local cQuery 		:= "" 

Private oDlg
Private oChk
Private oLbx
Private lChk 		:= .F.
Private lMark 		:= .F.
Private aVetor 		:= {}
Private cPerg    	:= "TELABOL"
Private _cUsrBol1  	:= AllTrim(GetMV('MC_USRBOL1',.F.,''))
Private _cUsrBol2  	:= AllTrim(GetMV('MC_USRBOL2',.F.,''))
Private _oSay1
Private _oSay2
Private oFontSAY 	:= TFont():New('Courier new',,-22,.T.)
Private _cEmailTO   := 'A1_EMAIL'

DbSelectArea('SA1')
IF SA1->(FieldPos("A1_EMAILNF")) > 0
	_cEmailTO := 'A1_EMAILNF'
EndIf

ValidPerg()
If !Pergunte(cPerg,.T.)	// SELECIONE O BANCO
	Return
EndIf
_cBanco			:= Mv_Par01
_cAgencia		:= Mv_Par02
_cConta			:= Mv_Par03
_cSubcta		:= Mv_Par04
_Tipo			:= Mv_Par05
_EmisIni		:= Mv_Par06
_EmisFim		:= Mv_Par07
_cTitulo		:= Mv_Par08
_cBordero		:= Mv_Par09
_cNfsEletro		:= Mv_Par10
_cPrefDe		:= Mv_Par11
_cPrefAte		:= Mv_Par12
_cManifesto		:= Mv_Par13

_lUsrAcess := __cUserID $ _cUsrBol1 .Or. __cUserID $ _cUsrBol2
IF _lUsrAcess
	IF _Tipo == 2 .And. __cUserID $ _cUsrBol1
		MsgInfo("Usuario sem acesso de impressão da 2º Via",'Acesso [#MC_USRBOL1]')
		Return
	ElseIF _Tipo == 1 .And. __cUserID $ _cUsrBol2
		MsgInfo("Usuario sem acesso de impressão da 1º Via",'Acesso [#MC_USRBOL2]')
		Return	
	ENDIF	
ENDIF

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery := " SELECT E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VALOR, E1_VENCTO, E1_VENCREA, E1_TIPO, E1_PORTADO, E1_NUMBOR, E1_NUMBCO, E1_XNUMBCO, E1_NFELETR, E1_FILORIG, E1_SALDO FROM "+ENTER
cQuery += RetSqlName("SE1") +ENTER
cQuery += " WHERE D_E_L_E_T_ = '' "+ENTER
cQuery += " AND E1_FILIAL = '"+FWxFilial('SE1')+"' "+ENTER
cQuery += " AND E1_SALDO <> 0 "+ENTER
cQuery += " AND E1_TIPO IN ('NF','BOL','FT','DP','NDC') " +ENTER
//cQuery += " AND E1_BOLETO = '1' "+ENTER
cQuery += " AND E1_XBOLETO = '1' "+ENTER
cQuery += " AND E1_PREFIXO BETWEEN '"+_cPrefDe+"' AND '"+_cPrefAte+"' "+ENTER

//If !Empty (_cNfsEletro)
//    cQuery += "AND E1_NFELETR = '" + _cNfsEletro + "' "
//ElseIf !Empty(_cTitulo) 
//	cQuery += " AND E1_NUM = '" + _cTitulo + "' "
//Else
//	cQuery += " AND E1_EMISSAO BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "                                                                                	
//EndIf
If Mv_Par05 == 1
	cQuery += " AND E1_PORTADO = '' "+ENTER
	cQuery += " AND E1_AGEDEP = '' "+ENTER
	cQuery += " AND E1_CONTA = '' "+ENTER
	cQuery += " AND E1_NUMBCO = '' "+ENTER
	cQuery += " AND E1_XNUMBCO = '' "+ENTER
	cQuery += " AND E1_SALDO > 0 "+ENTER
	cQuery += " AND E1_TIPO IN ('NF','BOL','FT','DP','NDC') "+ENTER
	If !Empty (_cNfsEletro)
    	cQuery += "AND E1_NFELETR = '" + _cNfsEletro + "' "+ENTER
    ElseIf !Empty(_cTitulo) 
		cQuery += " AND E1_NUM = '" + _cTitulo + "' "+ENTER
	Else
		cQuery += " AND E1_EMISSAO BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "+ENTER
	EndIf
ElseIf Mv_Par05 == 2
	cQuery += " AND E1_NUMBCO <> '' "+ENTER
	cQuery += " AND E1_SALDO > 0 "+ENTER
	cQuery += " AND E1_TIPO IN ('NF','BOL','FT','DP','NDC') "+ENTER
	cQuery += " AND E1_EMISSAO BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "    +ENTER                                                                            	
	If !Empty (_cNfsEletro)
    	cQuery += "AND E1_NFELETR = '" + _cNfsEletro + "' "+ENTER
    ElseIf !Empty(_cTitulo) 
		cQuery += " AND E1_NUM = '" + _cTitulo + "' "+ENTER
	ElseIf !Empty(_cBordero)
		cQuery += " AND E1_NUMBOR = '" + _cBordero + "' "+ENTER
//	ElseIf !Empty(_EmisIni) .or. !Empty(_EmisFim)
//		cQuery += " AND E1_EMISSAO BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "                                                                                	
	Else
		cQuery += " AND E1_PORTADO = '" + _cBanco + "' "+ENTER
		cQuery += " AND E1_AGEDEP = '" + _cAgencia + "' "+ENTER
		cQuery += " AND E1_CONTA = '" + _cConta + "' "+ENTER
	EndIf
EndIf
If Mv_Par13 == 1
		cQuery += " AND E1_SALDO <> 0 "+ENTER
ENDIF
If Mv_Par13 == 2
		cQuery += " AND E1_X_DTMAN <> '' "+ENTER
ENDIF
If Mv_Par13 == 3
		cQuery += " AND E1_X_DTMAN = '' "+ENTER
endif
cQuery += " ORDER BY 4, 5, 6, 7 "+ENTER
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","E1_EMISSAO","D")
TcSetField("TMP","E1_VENCTO" ,"D")
TcSetField("TMP","E1_VENCREA","D")
TcSetField("TMP","E1_VALOR"  ,"N",12,2)

DbSelectArea("TMP")
DbGoTop()
While !TMP->(Eof())
	aAdd(aVetor, { lMark, TMP->E1_PREFIXO,;									// Marca e Desmarca // Prefixo
				   TMP->E1_NUM,;											// Numero do Titulo
				   TMP->E1_PARCELA,;										// Parcela
				   TMP->E1_NFELETR,;										//Numero da Nota fiscal de serviço
				   TMP->E1_CLIENTE,;										// Codigo do Cliente
				   TMP->E1_LOJA,;											// Loja
				   TMP->E1_NOMCLI,;											// Nome do Cliente
				   TMP->E1_EMISSAO,;										// Data de Emissao
				   AllTrim(Transform(TMP->E1_VALOR,"@E 999,999,999.99")),;	// Valor do Titulo
				   TMP->E1_VENCTO,;											// Data de Vencimento
				   TMP->E1_VENCREA,;										// Data de Vencimento Real
				   TMP->E1_TIPO,;											// Tipo de Titulo
				   TMP->E1_PORTADO,;										// Banco
				   TMP->E1_AGEDEP,;											// Agencia
				   TMP->E1_CONTA,;											// Conta
				   TMP->E1_NUMBOR,;											// Numero do Bordero
				   TMP->E1_NUMBCO,;											// Nosso Numero
				   TMP->E1_XNUMBCO,;										// Nosso Numero para 2a Via
				   TMP->E1_FILIAL ,;										// Filial
				   TMP->E1_FILORIG,;										// Filial Origem
				   AllTrim(Transform(TMP->E1_SALDO,"@E 999,999,999.99")),;	// Saldo do Titulo
				   AllTrim(Posicione("SA1",1,xFilial("SA1")+TMP->E1_CLIENTE+TMP->E1_LOJA,_cEmailTO)) }) //Email

	TMP->(DbSkip())
End

DbSelectArea("TMP")
DbCloseArea()
If Len(aVetor) == 0
	MsgAlert("Não foi Selecionado nenhum Titulo para Impressão de Boleto",cTitulo)
	Return
EndIf

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 To 511,1292 PIXEL
@010,010 LISTBOX oLbx VAR cVar FIELDS Header " ", "Prefixo", "N° Titulo", "Parcela","N° NF Serviço", "Cod. Cliente", "Loja", "Nome Cliente", "Data Emissão", "Valor R$", "Vencimento", "Vencimento Real", "Tipo", "Portador", "Agencia", "Conta", "Bordero", "Nosso N° Sistema", "Nosso N° Backup", "Filial", "Origem", "Saldo", 'E-mail' SIZE 630,230 Of oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],Marca('1',lChk,aVetor),oLbx:Refresh())
oLbx:SetArray(aVetor)
oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo),; 
					aVetor[oLbx:nAt,02],;
					aVetor[oLbx:nAt,03],;
					aVetor[oLbx:nAt,04],;
					aVetor[oLbx:nAt,05],;
					aVetor[oLbx:nAt,06],;
					aVetor[oLbx:nAt,07],;
					aVetor[oLbx:nAt,08],;
					aVetor[oLbx:nAt,09],;
					aVetor[oLbx:nAt,10],;
					aVetor[oLbx:nAt,11],;
					aVetor[oLbx:nAt,12],;
					aVetor[oLbx:nAt,13],;
					aVetor[oLbx:nAt,14],;
					aVetor[oLbx:nAt,15],;
					aVetor[oLbx:nAt,16],;
					aVetor[oLbx:nAt,17],;
					aVetor[oLbx:nAt,18],;
					aVetor[oLbx:nAt,19],;
					aVetor[oLbx:nAt,20],;
					aVetor[oLbx:nAt,21],;
					aVetor[oLbx:nAt,22],;
					aVetor[oLbx:nAt,23] }}
If oChk <> Nil
	@245,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" Size 60,007 PIXEL Of oDlg On Click(Iif(lChk,Marca('2',lChk,aVetor),Marca('2',lChk,aVetor)))
EndIf
@245,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" SIZE 60,007 PIXEL Of oDlg On Click(aEval(aVetor,{|x| x[1] := lChk}),oLbx:Refresh(),Marca('2',lChk,aVetor))
@243,130 BUTTON "Cancelar Boletos Total" SIZE 100, 011 Font oDlg:oFont ACTION {CanceTot(aVetor),oDlg:End()} OF oDlg PIXEL

// Validar se é segunda via; se for segunda precisa carregar o banco do titulo e não da variavel
If _Tipo ==2
	DbSelectArea('SE1'); SE1->(DbSetOrder(1))
	If DbSeek(xFilial("SE1") + aVetor[oLbx:nAt,2] + aVetor[oLbx:nAt,3] + aVetor[oLbx:nAt,4])
		_cBanco			:= SE1->E1_PORTADO
		_cAgencia		:= SE1->E1_AGEDEP
		_cConta			:= SE1->E1_CONTA
	Endif	
Endif

If _cBanco == "341"		//_____|    ITAU   |_____
	@243,480 BUTTON "Confirmar" SIZE 050, 011 Font oDlg:oFont ACTION {U_ProcItau(@aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero),oDlg:End()} Of oDlg PIXEL
ElseIf _cBanco == "237"	//_____| BRADESCO  |_____
	@243,480 BUTTON "Confirmar" SIZE 050, 011 Font oDlg:oFont ACTION {U_ProcBrad(@aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero),oDlg:End()} Of oDlg PIXEL
ElseIf _cBanco == "033"	//_____| SANTANDER |_____
	@243,480 BUTTON "Confirmar" SIZE 050, 011 Font oDlg:oFont ACTION {U_Proce033(@aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero),oDlg:End()} Of oDlg PIXEL
ElseIf _cBanco == "001"	//_____|   BRASIL  |_____
	@243,480 BUTTON "Confirmar" SIZE 050, 011 Font oDlg:oFont ACTION {U_ProcBrasi(@aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero),oDlg:End()} Of oDlg PIXEL
ElseIf _cBanco == "422"	//_____|   SAFRA   |_____
	@243,480 BUTTON "Confirmar" SIZE 050, 011 Font oDlg:oFont ACTION {U_ProcSafr(@aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_cBordero),oDlg:End()} Of oDlg PIXEL
EndIf

@243,535 BUTTON "Consulta"  SIZE 050, 011 Font oDlg:oFont ACTION VisuSE1() OF oDlg PIXEL
@243,590 BUTTON "Cancela"   SIZE 050, 011 Font oDlg:oFont ACTION oDlg:End() OF oDlg PIXEL


@ 233, 300 Say "Valor Selecionado:" COLOR CLR_RED PIXEL Of oDlg
_oSay1 := TSay():New(243,267,{||Transform(0,"@E 9,999,999.99")},oDlg,,oFontSAY,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)
@ 233, 400 Say "Saldo Selecionado:" COLOR CLR_RED PIXEL Of oDlg
_oSay2 := TSay():New(243,370,{||Transform(0,"@E 9,999,999.99")},oDlg,,oFontSAY,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

ACTIVATE MSDIALOG oDlg CENTER

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ VisuSE1  ºAutor  ³Eduardo Augusto     º Data ³  22/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para Chamada do mBrowse da Tela de Inlcusao do      º±±
±±º          ³ Contas a Receber (Somente Consulta)             			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ I2I Eventos							                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function VisuSE1()

Local cCadastro 	:= "Tela do Contas a Receber"
Local aRotina 		:= { {"Pesquisar","AxPesqui",0,1}, {"Visualizar","AxVisual",0,2} }
Local cDelFunc 		:= ".T."
Local cString 		:= "SE1"

DbSelectArea("SE1")
SE1->(dbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
dbSelectArea(cString)
mBrowse(6,1,22,75,cString)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Marca     ºAutor  ³Eduardo Augusto     º Data ³  22/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que Marca ou Desmarca todos os Objetos.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ I2I Eventos						                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Marca(_cOpc,lMarca,aVetor)

Local i
Local _nVTot := 0
Local _nVSld := 0

For i := 1 To Len(aVetor)
	IF _cOpc == '2'
		aVetor[i][1] := lMarca
	ENDIF	

	IF aVetor[i][1]
		_nVTot += VAL(StrTran(StrTran(aVetor[i][10],'.',''),',','.'))
		_nVSld += VAL(StrTran(StrTran(aVetor[i][22],'.',''),',','.'))
	ENDIF
Next
oLbx:Refresh()

_oSay1:SetText(Transform(_nVTot,"@E 9,999,999.99"))
_oSay1:CtrlRefresh()
_oSay2:SetText(Transform(_nVSld,"@E 9,999,999.99"))
_oSay2:CtrlRefresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³CANCETOT  ºAutor  ³Eduardo Augusto     º Data ³  22/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para Limpar os campos da Tabela SE1 quando o Boleto º±±
±±º		     ³ sofrer cancelamento total das informações...				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mirai							                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function CanceTot(aVetor)

Local j

For j := 1 To Len(aVetor)
	If aVetor [j][1] == .T.
		DbSelectArea("SE1")                      
		DbSetOrder(1)
		If DbSeek(xFilial("SE1") + aVetor[j][2] + aVetor[j][3] + aVetor[j][4] + aVetor[j][13])
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO	:= ""
			SE1->E1_XNUMBCO	:= ""
			SE1->E1_CODBAR	:= ""
			SE1->E1_CODDIG	:= ""
			SE1->E1_PORTADO	:= ""
			SE1->E1_AGEDEP	:= ""
			SE1->E1_CONTA	:= ""
			SE1->E1_SITUACA	:= "0"
			MsUnLock()
		EndIf
	EndIf
Next

MsgInfo("Cancelamento de Boleto Total Finalizado com Sucesso")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Marca     ºAutor  ³Eduardo Augusto     º Data ³  22/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que Perguntas do SX1.					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ I2I Eventos						                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidPerg()

Local i
Local j
_sAlias := Alias()

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Banco              :","","","Mv_chB","C",03,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","",""})
aAdd(aRegs,{cPerg,"02","Agencia            :","","","Mv_chC","C",05,0,0,"G","","Mv_Par02",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Conta              :","","","Mv_chD","C",10,0,0,"G","","Mv_Par03",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","SubCta             :","","","Mv_chE","C",03,0,0,"G","U_VALSUBCT()","Mv_Par04",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo de Impressao  :","","","Mv_chF","N",01,0,0,"C","","Mv_Par05","1a Via","1a Via","1a Via","","","2a Via","2a Via","2a Via","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emissao de         :","","","Mv_chG","D",08,0,0,"G","","Mv_Par06",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Emissao ate        :","","","Mv_chH","D",08,0,0,"G","","Mv_Par07",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","N° do Titulo       :","","","Mv_chI","C",09,0,0,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","",""})
aAdd(aRegs,{cPerg,"09","N° do Bordero      :","","","Mv_chJ","C",06,0,0,"G","","Mv_Par09",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","N° NF de Serviço   :","","","Mv_chl","C",06,0,0,"G","","Mv_Par10","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","",""})
aAdd(aRegs,{cPerg,"11","Prefixo De         :","","","Mv_chL","C",03,0,0,"G","","Mv_Par11",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Prefixo Ate        :","","","Mv_chM","C",03,0,0,"G","","Mv_Par12",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Manifesto S/N ?    :","","","Mv_chN","N",01,0,0,"C","","Mv_Par13","Ambos","","","","","Sim","","","","","Nao","","","","","","","","","","","","","","","","","",""})


For i := 1 to Len(aRegs)
	If !DbSeek(cPerg + aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	EndIf
Next

DbSkip()
DbSelectArea(_sAlias)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³VALCT   ºAutor  ³Microsiga          º Data ³  28/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de validador da Subconta.						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Salon                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function VALSUBCT()

Local lRet := .T.

DbSelectArea("SEE")
SEE->(DbSetOrder(1))	// EE_FILIAL + EE_CODIGO + EE_AGENCIA + EE_CONTA + EE_CTA
lRet := SEE->(dbSeek(xFilial("SEE") + Mv_Par01 + Mv_Par02 + Mv_Par03 + Mv_Par04 ))

If Mv_Par05 == 1 // para que não entre na validação caso seja impressão segunda via
	If !lRet
		MsgAlert("conta não relacionada com o Banco informado no Parâmetro, favor informar a conta correta!!!")
		lRet := .F.
	EndIf
Else
	lRet := .T.
EndIf

Return lRet    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  xSE1LIQ     ºAutor  ³Microsiga          º Data ³  06/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para calculo do valor Liquido do TITULO 		  º±±
±±º          ³ SALDO - IMPOSTOS                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xSE1LIQ                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/               
*--------------------*
User Function xSE1LIQ
*--------------------*
Local _aArea   := GetArea()
Local _aArE1   := SE1->(GetArea())
Local _nValLiq := SE1->E1_SALDO
Local _nVlAbat := SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)

_nValLiq := Round(SE1->E1_SALDO - _nVlAbat,2)

RestArea(_aArE1)
RestArea(_aArea)
Return(_nValLiq)

*--------------------------------*
User Function zClearBol(cFileName)
*--------------------------------*
IF File(cFileName)
	fErase(cFileName)
ENDIF
Return
