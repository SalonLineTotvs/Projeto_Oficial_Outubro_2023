#Include "Protheus.ch"
#Include "Avprint.ch"
#Include "Font.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ? ESTR0004     ºAutor³ Genilson M Lucas       		  ?Data ? 21/08/2018 º±?                                     
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ? Impressão da etiqueta para conferência do Pallet.		                 º±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß     
*/
                                              
User Function ESTR0004()
Local   aParam      := {}

Private cPedido		:= SPACE(06)
Private cProduto    := SPACE(15)
Private nQtdVol		:= 0
Private nQuantUn 	:= 0
Private cCodUser     := RetCodUsr()
Private aRet      	:= {}
Private cAutImp	    := GetMv("ES_ESTR004")

//Local _oDlg99
//Private _Ok         := .T.
//Private _cUsua  	:= Space(30)
//Private _cLiber 	:= Space(15)
//Private oGet1
//Private oGet2
	/*
	If !Empty(cUserAuto) .and. ! Upper(cUserName) $ Upper(cUserAuto) 
		Define MsDialog _oDlg99 Title "Liberacao de etiqueta " From 246,223 To 385,576 PIXEL
			
		@ 005,010 Say OemToAnsi("Usuario nao autorizado a imprimir etiqueta. ") OF _oDlg99 PIXEL Size 160,8
		@ 015,010 Say OemToAnsi("Solicite liberação.") OF _oDlg99 PIXEL Size 160,8
			
		@ 030,010 Say OemToAnsi("Usuario de Liberacao:") OF _oDlg99 PIXEL Size 59,8
		@ 029,065 MSGet oGet1 VAR _cUsua OF _oDlg99  PIXEL Size 76,10
		@ 045,010 Say OemToAnsi("Senha de Liberacao:")  OF _oDlg99 PIXEL Size 59,8 //26
		@ 044,065 MSGet oGet2 VAR _cLiber PASSWORD VALID _Ok   := CHKPSW() OF _oDlg99 PIXEL Size 76,10 //25
				   	
		DEFINE SBUTTON FROM 58,080 TYPE 01 ACTION (_oDlg99:end())  ENABLE OF _oDlg99 
		DEFINE SBUTTON FROM 58,125 TYPE 02 ACTION (_oDlg99:end() ) ENABLE OF _oDlg99
			
		Activate MSDialog _oDlg99 Centered
	EndIF
	/*/
If cCodUser $ cAutImp

	aadd(aParam, { 1, "Pedido"			,	cPedido		,"@!"  ,".T.","SC5",".T.",050,.T.		} )  
	aadd(aParam, { 1, "Produto"			,	cProduto	,"@!"  ,".T.","SB1",".T.",050,.T.		} )  
	aadd(aParam, { 1, "Volumes"			,	nQtdVol 	,"9999",".T.",""   ,".T.",050,.T.		} )
				
	If ParamBox( 	aParam, "Etiqueta P.A.",aRet,,,,,,,,.F.,.T.)    
	    cPedido		:= aRet[1]
	    cProduto  	:= aRet[2]
		nQtdVol		:= aRet[3]
	Endif  
	
	
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1") + cProduto )) .and. SB1->B1_TIPO == 'PA'
		nQuantUn	:= nQtdVol *SB1->B1_QE
		Processa({|| ImpEtiq()},"Aguarde imprimindo etiqueta do Pallet...") 
	EndIF	
Else
	MsgAlert("Usuário sem permissão para impressão!","Atenção")
EndIf

Return()



Static Function ImpEtiq()

Local N			:= 0
Local aContr01  := {}	
Local cTamLinha	:= 40

Private oPrn:= TMSPrinter():New( "Etiqueta" )
Private nLin := 6


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
#xtranslate :ARIAL_18_NEGRITO     => \[15\]
#xtranslate :ARIAL_24_NEGRITO     => \[16\]
#xtranslate :ARIAL_40_NEGRITO     => \[17\]
#xtranslate :ARIAL_60_NEGRITO     => \[18\]
#xtranslate :ARIAL_11_NEGRITO     => \[19\]


oFont1 := oSend(TFont(),"New","HAETTENSCHWEILER" ,0,16,,.F.,,,,,,,,,,,oPrn )
oFont2 := oSend(TFont(),"New","Arial NARROW" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont3 := oSend(TFont(),"New","Arial BLACK" ,0,54,,.T.,,,,,,,,,,,oPrn )

oFont4 := oSend(TFont(),"New","Century Gothic" ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont5 := oSend(TFont(),"New","Century Gothic" ,0,11,,.T.,,,,,,,,,,,oPrn )
oFont6 := oSend(TFont(),"New","Century Gothic" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont7 := oSend(TFont(),"New","Century Gothic" ,0,14,,.T.,,,,,,,,,,,oPrn )

oFont8  := oSend(TFont(),"New","Arial" ,0,09,,.F.,,,,,,,,,,,oPrn )
oFont9  := oSend(TFont(),"New","Arial" ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont10 := oSend(TFont(),"New","Arial" ,0,12,,.F.,,,,,,,,,,,oPrn )
oFont11 := oSend(TFont(),"New","Arial" ,0,18,,.F.,,,,,,,,,,,oPrn )

oFont12 := oSend(TFont(),"New","Arial" ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont13 := oSend(TFont(),"New","Arial" ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont14 := oSend(TFont(),"New","Arial" ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont15 := oSend(TFont(),"New","Arial" ,0,18,,.T.,,,,,,,,,,,oPrn )
oFont16 := oSend(TFont(),"New","Arial" ,0,24,,.T.,,,,,,,,,,,oPrn )
oFont17 := oSend(TFont(),"New","Arial" ,0,40,,.T.,,,,,,,,,,,oPrn )
oFont18 := oSend(TFont(),"New","Arial" ,0,60,,.T.,,,,,,,,,,,oPrn )


oPrn:SetPortrait()  // SetLandscape()


	oPrn:StartPage()
	oPrn:Say(nLin,015,"CODIGO PA" 	,oFont4)
	oPrn:Say(nLin,300,"PEDIDO" 		,oFont4)
	oPrn:Say(nLin,500,"VOLUMES"   	,oFont4)
	oPrn:Say(nLin,700,"QTD UNIT" 	,oFont4)
	
	nLin += 35
	
	oPrn:Say(nLin,015, cProduto						 ,oFont6)
	oPrn:Say(nLin,300, cPedido						 ,oFont6)
	oPrn:Say(nLin,500,Transform(nQtdVol ,"@E 99,999"),oFont6)
	oPrn:Say(nLin,700,Transform(nQuantUn,"@E 99,999"),oFont6)
	
	nLin += 65
	
	oPrn:Say(nLin,015,"DESCRICAO",oFont4)
	
	aContr01 := {}	
	cContr01 :=  Alltrim(SB1->B1_DESC)
	For n:=1 To MlCount(cContr01 ,cTamLinha)
		If	! Empty(AllTrim(MemoLine(cContr01 ,cTamLinha,n)))
			aAdd(aContr01, AllTrim(MemoLine(cContr01 ,cTamLinha,n)))
		EndIf
	Next  
	For n:=1 To Len(aContr01)
		nLin += 37
		oPrn:Say(nLin,015,aContr01[n] ,oFont6)
	Next n
			
	MSBAR3("CODE128",2.1 ,0.8,'PL/'+alltrim(cProduto)+'/'+cPedido+'/'+alltrim( Str(nQtdVol)),oPrn,.F.,,.T.,0.029,1,.F.,,"CODE128",.F.)	
	
	nLin += 250
	oPrn:Say(nLin,010,"IMPRESSO POR: "+UsrRetName( cCodUser ),oFont4)
	
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

//AVENDPAGE
oPrn:EndPage()

MS_Flush()
oPrn:Preview() 

//oPrn:Print()
oPrn:End()

Return() 

/*
Static Function CHKPSW()

LOCAL _aUser,_lRet1:=.T.

PswOrder(2)	//ALTERADO PARA A VERSÃO PROTHEUS11
If PswSeek(_cUsua, .T. )   //Validado Nome do Usuario
	
	If PswName(_cLiber)		//Validada a Senha
		_aUser:=pswret(1)
		If ! Upper( AllTrim( _aUser[1,2] ) ) $ Upper( cUserAuto  )
			MsgStop("Voce NAO tem autorizacao para imprimir etiquetas.","Sem Autorizacao","INFO")
			_cLiber  := Space(15)
			_lRet1:=.F.
		End
	Else
		MsgStop("Usuario/Senha NAO cadastrado!!!","Sem Cadastro","INFO")
		_lRet1:=.F.
		_cLiber  := Space(15)
	Endif
	
Else
	MsgStop("Usuario/Senha NAO cadastrado!!!","Sem Cadastro","INFO")
	_lRet1:=.F.
	_cLiber  := Space(15)
Endif

Return(_lRet1)
*/
