#INCLUDE "Ap5Mail.ch"  
#INCLUDE"RWMAKE.CH"            
#INCLUDE"PROTHEUS.CH" 
#include 'totvs.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ SalonLine			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ MT120OK   ³ Autor ³                 ³ Data ³               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  													      |±±
±±³			 | 										               		  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

user function MT120OK()
Local cNumero   := CA120NUM
Local cXFilial  := cFilAnt
Local lRet      := .T.
Local nCount    := 0
Local cCnpjFor  := GETNEWPAR('SL_DEVINTE','01773518000635')
Local cLocal    := GETNEWPAR('SL_LOCPAD','95')
Local _cEmail   := GETNEWPAR('SL_DEVMAIL','alessandra.nicolau@salonline.com.br')
Local nPosLocal := ASCAN(aheader,{|x| alltrim(x[2])=="C7_LOCAL"})
Local nPosTipo	:= ASCAN(aheader,{|x| alltrim(x[2])=="C7_UM"})
Local nPosProd	:= ASCAN(aheader,{|x| alltrim(x[2])=="C7_PRODUTO"})
Local nPosDesc	:= ASCAN(aheader,{|x| alltrim(x[2])=="C7_DESCRI"})
Local nPosQuant	:= ASCAN(aheader,{|x| alltrim(x[2])=="C7_QUANT"})
Local cCodFor   := Posicione('SA2',3,xFilial('SA2')+cCnpjFor,'A2_COD')
Local cLojFor   := Posicione('SA2',3,xFilial('SA2')+cCnpjFor,'A2_LOJA')
Local _cPatch	:= "\system\Zakat_SC7\" + cXFilial+cNumero+DTOS(Date())+SubStr(time(),1,2)+SubStr(time(),4,2)+SubStr(time(),7,2)+'.TXT'

IF cXFilial=='1201' .AND. CA120FORN+CA120LOJ == cCodFor+cLojFor
    for nCount:=1 to len(aCols)
        IF aCols[nCount][nPosLocal]<>cLocal
            Msgalert('Almoxarifado Inválido para o pedido Zakat X Devintex! - Item'+cvaltochar(nCount))
            lRet:=.F.
            exit
        endif
    next
ENDIF

IF cXFilial=='1201' .AND. CA120FORN+CA120LOJ == cCodFor+cLojFor .AND. lRet
    Gravalog( _cPatch,PADR('PCZAKAT',22)+PADR('38.429.600/0001-42',23)+cNumero)
    for nCount:=1 to len(aCols)
		cTexto:=padr('20'+alltrim(aCols[nCount][nPosProd]),15)+PADR(aCols[nCount][nPosDesc],50)+aCols[nCount][nPosTipo]+STRZERO(aCols[nCount][nPosQuant],9)+'000000'
        Gravalog( _cPatch,cTexto)
    next
    ENVMAIL(,_cEmail,'PEDIDO DE COMPRAS ZAKAT x DEVINTEX Nº ' +cNumero,,_cPatch,.F.)
ENDIF

return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ SalonLine			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ Gravalog  ³ Autor ³                 ³ Data ³               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  													      |±±
±±³			 | 										               		  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

static function Gravalog(cFile,cText)

local nHandle

cText += chr(13) + chr(10)

if !file(cFile)
    if (nHandle := fCreate(cFile, 1)) = -1
        Conout("Arquivo nao foi criado: ("+cFile+")")
    else
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif
else
    
    nHandle := fOpen(cFile, 2)
    nLength := fSeek(nHandle, 0, 2)
    
    if nLength+len(cText)>=1048580
        
        fClose(nHandle)
        
        IF fRename(cFile, cFile+"."+dtos(date())+"-"+alltrim(str(seconds()))) = -1
            Conout("Arquivo nao foi renomeado: ("+cFile+")")
        endif
        
        gravalog(cFile,cText)
        
    endif
    
    if fError() != 0
        Conout("Arquivo nao foi aberto: ("+cFile+")")
    else
        cText := fReadStr(nHandle,nLength) + cText
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif
endif

return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ SalonLine			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ ENVMAIL   ³ Autor ³                 ³ Data ³               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  													      |±±
±±³			 | 										               		  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

STATIC Function ENVMAIL(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Variaveis da função

Private _nTentativas := 0
Private _cSMTPServer := GetMV("MV_RELSERV")
Private _cAccount    := GetMV("MV_RELACNT")
Private _cPassword   := GetMV("MV_RELPSW")
Private _lEnviado    := .F.
Private _cUsuario    := Upper(AllTrim(cUserName))

// Validação dos campos do email

If _pcBcc == NIL
	_pcBcc := ""
EndIf

_pcBcc := StrTran(_pcBcc," ","")

If _pcOrigem == NIL
	_pcOrigem := GetMV("MV_RELACNT")
EndIf

_pcOrigem := StrTran(_pcOrigem," ","")

If _pcDestino == NIL
	_pcDestino := "seuemail@dominio.com.br"
EndIf

_pcDestino := StrTran(_pcDestino," ","")

If _pcSubject == NIL
	_pcSubject := "Sem Subject (ENVMAIL)"
EndIf

If _pcBody == NIL
	_pcBody := "Sem Body (ENVMAIL)"
EndIf

If _pcArquivo == NIL
	_pcArquivo := ""
EndIf

For _nAux := 1 To 10
	_pcOrigem := StrTran(_pcOrigem," ;","")
	_pcOrigem := StrTran(_pcOrigem,"; ","")
Next

If _plAutomatico == NIL
	_plAutomatico := .F.
EndIf

// Executa a função, mostrando a tela de envio (.T.) ou não (.F.)

If !_plAutomatico
	Processa({||EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)},"Enviando Email(s)...")
Else
	EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
EndIf

If !_plAutomatico
	If !_lEnviado
		MsgStop("Atenção: Erro no envio de Email!!!")
	EndIf
Else
	ConOut("Atenção: Erro no envio de Email!")
Endif

Return _lEnviado


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ SalonLine			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ EnviaEmail³ Autor ³                 ³ Data ³               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  													      |±±
±±³			 | 										               		  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function EnviaEmail(_pcOrigem,_pcDestino,_pcSubject,_pcBody,_pcArquivo,_plAutomatico,_pcBcc)
// Veriaveis da função
//**************************************************************
Local _nTentMax := 50  // Tentativas máximas
Local _nSecMax  := 30  // Segundos máximos  
Local _cTime    := (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
Local _nAuxTime := 0
Local lAutentica    := GetMV("MV_RELAUTH") 

// O que ocorrer primeiro (segundos ou tentativas), ele para.
//**************************************************************
_cTime += _nSecMax

If !_plAutomatico
	ProcRegua(_nTentMax)
EndIf

// Exibe mensagem no console/Log
//**************************************************************
ConOut("ENVMAIL=> ***** Envio de Email ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

For _nTentativas := 1 To _nTentMax
	
	If !_plAutomatico
		IncProc("Tentativa "+AllTrim(Str(_nTentativas)))
	EndIf
	ConOut("ENVMAIL=> ***** Tentativa "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))
	
	CONNECT SMTP SERVER _cSMTPServer ACCOUNT _cAccount PASSWORD _cPassword RESULT _lEnviado
	
	
	If _lEnviado
	
		// Verifica se o E-mail necessita de Autenticacao
     	If lAutentica     
        	_lEnviado := MailAuth(_cAccount,_cPassword) 
    	Else
       	_lEnviado := .T.
    	Endif
    	
		If Empty(_pcBcc)
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		Else
			If Empty(_pcArquivo)
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody FORMAT TEXT RESULT _lEnviado
			Else
				SEND MAIL FROM _pcOrigem TO _pcDestino BCC _pcBcc SUBJECT _pcSubject BODY _pcBody ATTACHMENT _pcArquivo FORMAT TEXT RESULT _lEnviado
			EndIf
		EndIf
		DISCONNECT SMTP SERVER
	EndIf
	
	If _lEnviado .Or. _cTime <= (Val(Substr(Time(),1,2))*60*60)+(Val(Substr(Time(),4,2))*60)+Val(Substr(Time(),7,2))
		_nTentativas := _nTentMax
	EndIf
	
Next

ConOut("ENVMAIL=> ***** Resultado de Envio "+IIf(_lEnviado,"T","F")+" / "+AllTrim(Str(_nTentativas))+" ***** "+AllTrim("DE:"+_pcOrigem)+"*"+AllTrim("P/:"+_pcDestino)+"*"+AllTrim("S:"+_pcSubject)+"*"+AllTrim("A:"+_pcArquivo))

Return
