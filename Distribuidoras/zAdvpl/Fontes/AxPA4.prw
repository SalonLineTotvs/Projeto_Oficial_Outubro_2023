#Include "PROTHEUS.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  ³ AXPA4      º Autor ³ Genesis/Genesis  º Data ³ 27/11/14   ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
//±±ºDescricao ³ RELATORIO - CADASTRO DE QUERY  (GENERICO)                 ±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*------------------*
User Function AXPA4
*------------------*
Private cCadastro := ""
Private aRotina := { {"Pesquisar" ,"AxPesqui" 	,0,1} ,;
		             {"Visualizar","AxVisual"	,0,2} ,;
	    	         {"Incluir"   ,"U_PA4_MANUT",0,3} ,;
	        	     {"Alterar"   ,"U_PA4_MANUT",0,4} ,;
            		 {"Excluir"   ,"AxDeleta"   ,0,5} ,;
            		 {"Pergunte"  ,"U_PA4_VIS"  ,0,1} ,;
            		 {"Copy Perg" ,"U_PA4_CPY"  ,0,1} ,;
            		 {"Exec Relat","U_RelPA4"   ,0,1}  }
 //            		 {"Cfg Perg"  ,"U_RelPA4"   ,0,1}  } 
            		 
dbSelectArea("PA4")
mBrowse( 6,1,22,75,"PA4")

Return .T.
*-----------------------------------------------*
User Function PA4_MANUT(cAlias,nReg,nOpc)
*-----------------------------------------------*
Private _cCodigo	:= GetMv("MV_XQUERY")
Private _cNome		:= Space(Len(PA4->PA4_NOME))
Private _cQry		:= Space(Len(PA4->PA4_QUERY))
Private _cPerg    	:= Space(Len(PA4->PA4_CPERG))
Private _cVar    	:= Space(Len(PA4->PA4_TAMREL))
Private _cTipRel    := Space(Len(PA4->PA4_TIPREL))
Private _cUsrPA4 	:= Space(Len(PA4->PA4_USER))
Private _cUsrBAK 	:= Space(Len(PA4->PA4_USER))
Private _oUsrPA4
Private _oUsrBAK

Private _lWhen		:= .T.
Private nOpca     	:= 0
Private aItems      := {}
Private _cVar       := ''
Private _aTipRel    := {}
Private _cTipRel    := ''
Private _cUsrPA4    := ''
Private _cUsrBAK    := ''

SetKey(VK_F12,{|| xPA4F3() })

AAdd( aItems, "P" )
AAdd( aItems, "M" )
AAdd( aItems, "G" )

AAdd( _aTipRel, "1-Tela" )
AAdd( _aTipRel, "2-Excel" )
AAdd( _aTipRel, "3-Ambos" )

IF nOpc <> 3

	_cCodigo	:= PA4->PA4_CODIGO
	_cNome		:= PA4->PA4_NOME
	_cQry		:= PA4->PA4_QUERY
	_cPerg    	:= PA4->PA4_CPERG
	
	_cVar   	:= PA4->PA4_TAMREL
	_cTipRel   	:= PA4->PA4_TIPREL	
	_cUsrPA4  	:= PadR(PA4->PA4_USER,TamSX3('PA4_USER')[1])
	_cUsrBAK    := ''
	
	IF !Empty(_cTipRel)
		IF ( _nPos := aScan(_aTipRel,{|a| _cTipRel $ a}) ) > 0
			_cTipRel := _aTipRel[_nPos]
		ENDIF
	ENDIF
	
	IF nOpc == 2 .OR. nOpc == 5
		_lWhen	:= .F.	
	EndIf

Endif

	DEFINE FONT oFont NAME "Arial" SIZE 7,16   //6,15
			
	DEFINE MSDIALOG _oDlgSel TITLE OemToAnsi("Cadastro da Query") FROM 0,0 TO 520,900 PIXEL

		@13,410 BUTTON "OK"  	     	SIZE 34,14 FONT _oDlgSel:oFont ACTION (_oDlgSel:End(),nOpca:=1) OF _oDlgSel PIXEL
		@40,410 BUTTON "Cancela"     	SIZE 34,14 FONT _oDlgSel:oFont ACTION (IF(MSGYESNO("Tem certeza que deseja abandonar ?"), (_oDlgSel:End(),nOpca:=0,xClear()),.T.) ) OF _oDlgSel PIXEL
			
		@13,002 TO 33,056  LABEL "Codigo" OF _oDlgSel PIXEL
		@13,60  TO 33,400  LABEL "Nome" OF _oDlgSel PIXEL
		
		@20,005 MSGET _cCodigo Picture("@!") When .F. OF _oDlgSel PIXEL SIZE 50,10
	    @20,065 MSGET _cNome   Picture("@!") When _lWhen OF _oDlgSel PIXEL SIZE 320,10                                                                              
	
		@35,005 GET oMemo  VAR _cQry  MEMO HSCROLL When _lWhen  OF _oDlgSel PIXEL SIZE 390,190	
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont:=oFont
		
		@238,002 TO 258,056  LABEL "Parametro" OF _oDlgSel PIXEL
		@244,005 MSGET _cPerg Picture("@!") When .T. OF _oDlgSel PIXEL SIZE 50,10		

		@238,068 TO 258,122  LABEL "Tipo.Imp.Rel" OF _oDlgSel PIXEL
		@245,070 COMBOBOX oTipRel VAR _cTipRel ITEMS _aTipRel SIZE 50, 10 OF _oDlgSel PIXEL 
		
		@238,132 TO 258,186  LABEL "Tam.Relatorio" OF _oDlgSel PIXEL
		@245,135 COMBOBOX oCombo VAR _cVar ITEMS aItems SIZE 50, 10 OF _oDlgSel PIXEL 

		
		@238,202 TO 258,385  LABEL "User Acesso" OF _oDlgSel PIXEL
		@244,205 MSGET _oUsrPA4 Var(_cUsrPA4) Picture("@!") When .T. OF _oDlgSel PIXEL SIZE 150,10
		@244,355 BUTTON("<F12> User")  SIZE 30,10 OF _oDlgSel PIXEL ACTION(xPA4F3())
				
	ACTIVATE MSDIALOG _oDlgSel CENTER
	
	
IF nOpca == 1 .AND. nOpc <> 2
	IF nOpc == 5
		PA4->(RECLOCK("PA4",.F.))
	  		PA4->(DBDELETE())
	    PA4->(MSUNLOCK())
	    Return .T.
	EndIf
		
	IF nOpc == 3
       PA4->(RECLOCK("PA4",.T.))
	ElseIf nOpc == 4
       PA4->(RECLOCK("PA4",.F.))
	EndIf

	    Replace PA4->PA4_CODIGO With _cCodigo
	    Replace PA4->PA4_NOME   With _cNome
		Replace PA4->PA4_QUERY  With _cQry    
		Replace PA4->PA4_CPERG  With _cPerg
		Replace PA4->PA4_TAMREL With _cVar
		Replace PA4->PA4_TIPREL With LEFT(_cTipRel,1)
		Replace PA4->PA4_USER   With _cUsrPA4
			
    PA4->(MSUNLOCK())

	IF nOpc == 3
		DbSelectArea("SX6")
		DbSetOrder(1)
		DbSeek(Space(02)+"MV_XQUERY")
		If Found()
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := Soma1(_cCodigo)
			SX6->X6_CONTENG := SX6->X6_CONTEUD 
			SX6->X6_CONTSPA := SX6->X6_CONTEUD 
			MsUnLock()
		End If 
	ENDIF

Endif
xClear()
Return .T.            

*--------------------*
Static Function xClear
*--------------------*


//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('xClear','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________
_cCodigo 	:= ''
_cNome 		:= ''
_cQry     	:= ''
_cPerg 		:= ''
Return

*--------------------*
User Function PA4_VIS
*--------------------*
Local _cPrg := PA4->PA4_CPERG

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('PA4_VIS','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

IF !Empty(_cPrg)
	Pergunte(_cPrg,.T.)
Else
	MsgAlert("<b>Parametro </b> não configurado ", "Aviso")
ENDIF

Return

*--------------------*
USer Function PA4_CPY
*--------------------*                  
Local _aPBox := {}
Local _aRet  := {}

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('PA4_CPY','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

	
aAdd(_aPBox,{9,"Parametros - Copia de estrutura",150,7,.T.})
aAdd(_aPBox,{1,"Pergunta antiga",Space(10),"","","","",0,.F.})
aAdd(_aPBox,{1,"Pergunta nova",Space(10),"","","","",0,.F.})

If !ParamBox(_aPBox,"Bloqueio de Orçamento...",@_aRet)
	Return
ENDIF	

u_zCpySX1(_aRet[2], _aRet[3], .T.)
	
Return

*-------------------*
User Function PA4_CFG
*-------------------*

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('PA4_CFG','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

Return

*------------------------------------------*
Static Function _xScanUSR(_oUsrPA4,_cUsrPA4)
*------------------------------------------*
Local _cRetPad1 := ''


//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('_xScanUSR','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________
IF ConPad1(,,,"USRPA4",_cRetPad1,,.F.)
	IF !Empty(_cRetPad1) //__cRetorn
	 	_cUsrPA4 := AllTrim(_cUsrPA4)+AllTrim(_cRetPad1)+'|'
	 	_cUsrPA4 := PadR(_cUsrPA4,TamSX3('PA4_USER')[1]) 
	 	_oUsrPA4:BUFFER := _cUsrPA4 
	 	_oUsrPA4:Refresh()        
	 	_oDlgSel:Refresh()        
	ENDIF
ENDIF

Return

*----------------------*
Static Function _xF4BAK
*----------------------*

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('_xF4BAK','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

IF !Empty(_cUsrBAK)
 	_cUsrPA4 := AllTrim(_oUsrPA4:BUFFER)+AllTrim(_cUsrBAK)+'|'
 	_cUsrPA4 := PadR(_cUsrPA4,TamSX3('PA4_USER')[1]) 
 	_oUsrPA4:BUFFER := _cUsrPA4 
 	_oUsrPA4:Refresh()        
 	_oDlgSel:Refresh()        
ENDIF

Return(.T.) 

*----------------------*
Static Function xPA4F3
*----------------------*

//[##]Genesis\Gustavo L - Mapeamento de programas para LOBO GUARA_________________________________________
IF (Upper(GetEnvServer()) $ AllTrim(GetMV('SN_CLSLOBO',.F.,'LOBO'))) .And. GetMV('SN_CLSTRUE',.F.,.F.)
	u_SN_CLSLOGO('xPA4F3','AXPA4.prw') //1º User Function | 2° Nome.PRW
ENDIF //__________________________________________________________________________________________________

SetKey(VK_F12,{|| Nil })

IF !Pergunte('PA4USR',.T.)
	Return
ENDIF     
_cUsrBAKx := AllTrim(MV_PAR01)                   

IF !Empty(_cUsrBAKx)
 	_cUsrPA4 := AllTrim(_oUsrPA4:BUFFER)+AllTrim(_cUsrBAKx)+'|'
 	_cUsrPA4 := PadR(_cUsrPA4,TamSX3('PA4_USER')[1]) 
 	_oUsrPA4:BUFFER := _cUsrPA4 
 	_oUsrPA4:Refresh()        
 	_oDlgSel:Refresh()        
ENDIF

SetKey(VK_F12,{|| xPA4F3() })
Return 
