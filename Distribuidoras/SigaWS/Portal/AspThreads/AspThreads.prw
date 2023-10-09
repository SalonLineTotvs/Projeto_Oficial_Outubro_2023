#include 'protheus.ch' 

*--------------------*
User Function ASPInit
*--------------------*
Conout("ASPINIT - Iniciando Thread Advpl ASP ["+cValToChar(ThreadID())+"]")
SET DATE BRITISH
SET CENTURY ON
Return .T.

*--------------------*
USER Function ASPConn
*--------------------*
Local cReturn := ''
Local cAspPage 
Local nTimer
Local nU       		:= 0
Local aSm0     		:= u_zCJGetFil()
Local _nEmp    		:= 1
Local cGetErr  		:= ''
Local _nItens  		:= 0
Local _nSaldo       := 0
Local _cPortal 		:= ''

Local _cGetHtm1 	:= ''
Local _cGetHtm2 	:= ''
Local _cGetHtm3 	:= ''
Local _cGetHtm4 	:= ''
Local _lConsulta 	:= Upper(AllTrim(httpPost->BUTTON1)) == Upper(AllTrim('Consultar'))

U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 
 
Private _dDataDe   := IIF(!_lConsulta,dDataBase  ,StoD(StrTran(httpPost->VENCTODE ,'-','')))
Private _dDataAte  := IIF(!_lConsulta,dDataBase+7,StoD(StrTran(httpPost->VENCTOATE,'-','')))
Private _cTipoDOC  := IIF(!_lConsulta,'',httpPost->TIPOCP)

cAspPage := HTTPHEADIN->MAIN

If !Empty(cAspPage)
  nTimer   := seconds()
  cAspPage := LOWER(cAspPage)
  conout("ASPCONN - Thread Advpl ASP ["+cValToChar(ThreadID())+"] "+"Processando ["+cAspPage+"]")

  do case 
  	case UPPER(ALLTRIM(cAspPage)) == 'AWKFLOGIN'
		// Execura a página INDEX.APH compilada no RPO 
		// A String retornada deve retornar ao Browser    
		cReturn := H_AWKFLOGIN() 

 	 case UPPER(ALLTRIM(cAspPage)) == 'AWKFAUTH'
  	
		cUsrAux := ALLTRIM(HTTPPOST->txt_Nome)
		cPswAux := ALLTRIM(HTTPPOST->txt_Senha)

		If Select("SX6") == 0
			RpcSetType(3)
			RpcSetEnv("01","02")
		Endif

	//ConOut('*********************** Login MAC Address:'+u_zPegaMac()) 

  	PswOrder(2)
    If !Empty(cUsrAux) .And. PswSeek(cUsrAux)
    	
    	aDadosUsr := U_xRetUsr(,cUsrAux)
    	
    	If Len(aDadosUsr) > 0
    	
	        cCodAux := aDadosUsr[1][1]
	    
	        If !PswName(cPswAux)
	             //cGetErr := "Usuário não Autenticado!"
				cGetErr := ' <html>'
				cGetErr += ' <head>'
				cGetErr += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
				cGetErr += ' </head> '
				cGetErr += ' <body> '
				cGetErr += '   <p>Usuário não Autenticado!&nbsp; '
				cGetErr += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
				cGetErr += ' </body> '
				cGetErr += ' </html> '					 
	        Else

				IF !zAcesso(HTTPPOST->txt_Portal,@_cPortal)
					cGetErr := ' <html>'
					cGetErr += ' <head>'
					cGetErr += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
					cGetErr += ' </head> '
					cGetErr += ' <body> '
					cGetErr += '   <p>Usuario sem acesso ao Portal: '+AllTrim(HTTPPOST->txt_Portal)+'&nbsp; '
					cGetErr += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
					cGetErr += ' </body> '
					cGetErr += ' </html> '		

				ELSE
					HTTPSESSION->LOGIN   := cUsrAux
					HTTPSESSION->PORTAL  := _cPortal
					
					//_____________________________________|     PORTAL - PEDIDO DE COMPRAS   |_____________________________________
					IF HTTPSESSION->PORTAL $ 'PC'
						_cGetHtm1 := u_AWKFPCJS()
						_cGetHtm2 += u_AWKFPCOM(@_nItens)
						IF _nItens > 0
							_cGetHtm3 += u_AWKFPCBT()
						ENDIF

					//_____________________________________|      PORTAL - CONTAS A PAGAR     |_____________________________________
					ELSEIF HTTPSESSION->PORTAL $ 'CR'
						_cGetHtm1 := u_AWKFCRJS()
						_cGetHtm2 := u_AWKFCRIXB(_lConsulta,@_dDataDe,@_dDataAte,@_cTipoDOC)
						_cGetHtm3 := u_AWKFCPAG(@_nItens,,,_lConsulta,@_dDataDe,@_dDataAte,cUsrAux,@_nSaldo,@_cTipoDOC,@_cGetHtm2)
						IF _nItens > 0
							_cGetHtm4 := u_AWKFCRBT()
						ENDIF

					//_____________________________________| PORTAL - SOLICITAÇÃO DE COMPPRAS |_____________________________________
					ELSEIF HTTPSESSION->PORTAL $ 'SC'
						_cGetHtm1 := u_AWKFSCJS()
						_cGetHtm2 += u_AWKFSCOM(@_nItens)
						IF _nItens > 0
							_cGetHtm3 += u_AWKFSCBT()
						ENDIF
					ENDIF

					//Ajsuta quantidade que vai ser impressa na frase "Olá XXXXX, você tem ##_nItens## pedido(s) pendente de aprovação!"
					_cGetHtm1 := StrTran(_cGetHtm1,'##RetCodUsr##',AllTrim(UsrFullName(cCodAux)))
					_cGetHtm1 := StrTran(_cGetHtm1,'##_nItens##',AllTrim(TransForm(_nItens,"@E 999,999")))
					_cGetHtm1 := StrTran(_cGetHtm1,'##_nSaldo##',AllTrim(TransForm(_nSaldo,"@E 99,999,999.99")))
					cGetErr   := _cGetHtm1 + _cGetHtm2 + _cGetHtm3 + _cGetHtm4
				ENDIF
	        ENDIF	        
	    Else
	    	//cGetErr := "Usuário não Autenticado!"
			cGetErr := ' <html>'
			cGetErr += ' <head>'
			cGetErr += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
			cGetErr += ' </head> '
			cGetErr += ' <body> '
			cGetErr += '   <p>Usuário não Autenticado!&nbsp; '
			cGetErr += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
			cGetErr += ' </body> '
			cGetErr += ' </html> '				
	    ENDIF      
     Else
        //cGetErr := "Usuário não Autenticado!"       
		cGetErr := ' <html>'
		cGetErr += ' <head>'
		cGetErr += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
		cGetErr += ' </head> '
		cGetErr += ' <body> '
		cGetErr += '   <p>Usuário não Autenticado!&nbsp; '
		cGetErr += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
		cGetErr += ' </body> '
		cGetErr += ' </html> '			
    ENDIF
 
  	cReturn := cGetErr
  case UPPER(ALLTRIM(cAspPage)) == 'AWKFRET'
  	IF Empty(HTTPSESSION->LOGIN)
  		//cGetErr := "Usuario não Autenticado"
		cGetErr := ' <html>'
		cGetErr += ' <head>'
		cGetErr += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
		cGetErr += ' </head> '
		cGetErr += ' <body> '
		cGetErr += '   <p>Usuario Desconectado:&nbsp; '
		cGetErr += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
		cGetErr += ' </body> '
		cGetErr += ' </html> '		
	
	//Consulta parametros de DATA (PORTAL)
	ElseIF _lConsulta
		cCodAux   := httpPost->__ZUSERID
		_cGetHtm1 := u_AWKFCRJS()
		_cGetHtm2 := u_AWKFCRIXB(_lConsulta,@_dDataDe,@_dDataAte,@_cTipoDOC)
		_cGetHtm3 := u_AWKFCPAG(@_nItens,,,_lConsulta,@_dDataDe,@_dDataAte,cCodAux,@_nSaldo,@_cTipoDOC,@_cGetHtm2)
		IF _nItens > 0
			_cGetHtm4 := u_AWKFCRBT()
		ENDIF
		//Ajsuta quantidade que vai ser impressa na frase "Olá XXXXX, você tem ##_nItens## pedido(s) pendente de aprovação!"
		_cGetHtm1 := StrTran(_cGetHtm1,'##RetCodUsr##',AllTrim(UsrFullName(cCodAux)))
		_cGetHtm1 := StrTran(_cGetHtm1,'##_nItens##',AllTrim(TransForm(_nItens,"@E 999,999")))
		_cGetHtm1 := StrTran(_cGetHtm1,'##_nSaldo##',AllTrim(TransForm(_nSaldo,"@E 99,999,999.99")))

		cGetErr   := _cGetHtm1 + _cGetHtm2 + _cGetHtm3 + _cGetHtm4

  	ELse
		//_____________________________________|   PORTAL - PEDIDO DE COMPRAS    |_____________________________________
		IF HTTPSESSION->PORTAL $ 'PC'
			cGetErr := U_AWKFPCRT()
		//_____________________________________|    PORTAL - CONTAS A PAGAR      |_____________________________________
		ELSEIF HTTPSESSION->PORTAL $ 'CR'
			cGetErr := U_AWKFCRRT()
		//_____________________________________| PORTAL - SOLICITACAO DE COMPRAS |_____________________________________
		ELSEIF HTTPSESSION->PORTAL $ 'SC'
			cGetErr := U_AWKFSCRT()			
		ENDIF	
  		HTTPSESSION->LOGIN := ""
  	Endif  	
  	cReturn := cGetErr

  case UPPER(ALLTRIM(cAspPage)) == 'AWKFANEXO'
  	If Empty(HTTPSESSION->LOGIN)
  		cGetErr := "Usuario não Autenticado"
  	ELse
  		cGetErr := u_AWKFFILE(HTTPGET->X,HTTPGET->F,HTTPGET->T)
  	Endif
  	cReturn := cGetErr

  case UPPER(ALLTRIM(cAspPage)) == 'AWKFPDFOP'
  		cGetErr := u_AWKFPDFOP(HTTPGET->X)
  		cReturn := cGetErr
  	
  case UPPER(ALLTRIM(cAspPage)) == 'AWKFLOFF'
  	If Empty(HTTPSESSION->LOGIN)
  		cGetErr := "Usuario não Autenticado"
  	ELse
  		HTTPSESSION->LOGIN := ""
		cGetErr := ' <html>'
		cGetErr += ' <head>'
		cGetErr += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
		cGetErr += ' </head> '
		cGetErr += ' <body> '
		cGetErr += '   <p>Usuario Desconectado:&nbsp; '
		cGetErr += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
		cGetErr += ' </body> '
		cGetErr += ' </html> '
  	Endif
  	cReturn := cGetErr

  case UPPER(ALLTRIM(cAspPage)) == 'ZZWAPV01'
  		_aProc := {}
  		For nU := 1 to len(HTTPGET->AGETS)
  			cIdent := HTTPGET->AGETS[nU]  			
  			aAdd(_aProc,{HTTPGET->AGETS[nU], &("HTTPGET->"+cIdent) })  			
  		Next nU  		
  		cReturn := u_ZZWAPV01(,,,_aProc)

  case UPPER(ALLTRIM(cAspPage)) == 'ZZWAPV02'  		
  		_aProc := {}
  		For nU := 1 to len(HTTPPOST->APOST)
  			cIdent := HTTPPOST->APOST[nU]  			
  			aAdd(_aProc,{HTTPPOST->APOST[nU], &("HTTPPOST->"+cIdent) })  			
  		Next nU  		
  		cReturn := u_ZZWAPV02(,_aProc,,)  		

  otherwise
    // retorna HTML para informar 
    // a condição de página desconhecida
    cReturn := "<html><body><center><b>"+;
               "Página AdvPL ASP não encontrada."+;
               "</b></body></html>"
  Endcase
  nTimer := seconds() - nTimer
  conout("ASPCONN - Thread Advpl ASP ["+cValToChar(ThreadID())+"] "+;
         "Processamento realizado em "+ alltrim(str(nTimer,8,3))+ "s.")
Endif

//U_fVerifJob(,,.T.,"FECHAR")

Return cReturn


*----------------------*
User Function zCJGetFil
*----------------------*
Local aSm0 := {}

If Select("SX6") == 0 
	OpenSm0('02',.T.)
	
	SM0->(DBGOTOP())
	
	While SM0->(!EOF())
		IF !Deleted()
			Aadd(aSm0,{SM0->M0_CODIGO,SM0->M0_CODFIL})
		Endif
	SM0->(DBSKIP())
	ENDDO
	
	SM0->(DBCLOSEAREA())
ELse
	IF !SELECT('SM0') > 0
		OpenSm0('02',.T.)
	ENdif
	Aadd(aSm0,{SM0->M0_CODIGO,SM0->M0_CODFIL})
Endif

Return(aSm0)

*----------------------------------------------------*
User Function fVerifJob(cEmp,cFil,lJob,cFaz,_nSetType)     
*----------------------------------------------------*
Default lJob   := .F.      
Default cFaz      := "ABRIR"
Default _nSetType := 1
                       
//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE                  
IF cFaz == "ABRIR"
	
	If Select("SX6") == 0 
 		lJob := .T.
     	RpcSetType(_nSetType)  
     	RpcSetEnv(cEmp,cFil)
	Else
	   lJob := .F.
	Endif

ElseIf lJob .and. UPPER(cFaz) == "FECHAR"
	Conout(' ')
	RpcClearEnv()                       
Endif
       
Return lJob

*---------------------------------------*
Static Function zAcesso(_cRadio,_cPortal)
*---------------------------------------*
Local _lAcesso  := .T.
Local _cUser_CR := AllTrim(GetMV('SL_ASPP_CR',.F.,'000000/000912/000910/000889/000100'))

Default _cRadio  := ''
Default _cPortal := ''

IF _cRadio == "Contas a Pagar"
	_lAcesso := cCodAux $ _cUser_CR
	_cPortal := 'CR'
ElseIF _cRadio == "Solicitacao de Compras"
	//_lAcesso := .F.
	_cPortal := 'SC'	
Else
	_cPortal := 'PC'
ENDIF

RETURN(_lAcesso)
