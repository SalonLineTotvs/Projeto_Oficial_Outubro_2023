#include 'protheus.ch'

#Define ENTER Chr(13)+Chr(10)   

*-----------------------------*
User Function AWKFPCOM(_nItens)
*-----------------------------*
Local _cQuery   := ''
Local _xHtm     := ''
Local _cReturn  := ''

//Local _cBcoDados:= "MSSQL/PROTHEUS_PROD"  //Conexão no DbAccess com a outra base de Dados
//Local _cServer  := "10.50.1.10"         //Servidor que está configurado o DbAccess
//Local _nPorta   := 7890                 //Porta da conexão do DbAccess
//Local _nHandle  := 0                  //Ponteiro que armazenará a conexão

Default _nItens   := 0

Local aSm0  	:= u_zCJGetFil()
Local _nEmp 	:= 1
U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 

_nItens := 0

//Conecta com Banco
//_nHandle  := TcLink(_cBcoDados, _cServer, _nPorta)
// 
////Se houve algum erro na conexão
//If _nHandle < 0
//    MsgInfo("Não foi possível conectar! Erro: " + cValToChar(_nHandle), "Atenção")
//  	Conout("ASPINIT - Falha de conexão "+cValToChar(_nHandle))
//	Return("[#001] Não foi possível conectar! Erro: " + cValToChar(_nHandle))   
//ENDIF

//_cQuery := " SELECT DISTINCT SCR.R_E_C_N_O_ 'RECSCR', CR_NUM,MIN(C7_TIPO) 'C7_TIPO', MIN(C7_DATPRF) 'ENTG',CR_XHTML"
//_cQuery += " FROM SCR010 SCR "
//_cQuery += " INNER JOIN SC7010 SC7 ON SC7.D_E_L_E_T_='' AND C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM "
//_cQuery += " WHERE SCR.D_E_L_E_T_='' AND CR_STATUS = '02' AND ( CR_USER='"+cCodAux+"' OR "
//_cQuery += " CR_USER IN ( SELECT AK_USER FROM SAK010 WHERE D_E_L_E_T_='' AND AK_APROSUP IN ( "
//_cQuery += " SELECT AK_COD FROM SAK010 WHERE D_E_L_E_T_='' AND AK_USER='"+cCodAux+"') )  ) AND C7_CONAPRO='B' AND C7_QUJE<C7_QUANT AND C7_RESIDUO=''   GROUP BY SCR.R_E_C_N_O_,CR_NUM,CR_XHTML  ORDER BY 3,4 "


_cQuery := " SELECT DISTINCT SCR.R_E_C_N_O_ 'RECSCR', CR_NUM,(C7_TIPO) 'C7_TIPO', (C7_DATPRF) 'ENTG',CR_XHTML, CR_USER 
_cQuery += " FROM SCR020 SCR 
_cQuery += " INNER JOIN SC7020 SC7 ON SC7.D_E_L_E_T_='' AND C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM AND C7_TIPO = CASE WHEN CR_TIPO='PC' THEN 1 ELSE 2 END "+ENTER
_cQuery += " 						 AND C7_CONAPRO = 'B' AND C7_QUJE<C7_QUANT AND C7_RESIDUO=''   "+ENTER
_cQuery += " WHERE SCR.D_E_L_E_T_=''  "+ENTER
_cQuery += " AND CR_FILIAL  = '"+FwxFilial('SCR')+"'  "+ENTER
_cQuery += " AND CR_STATUS  = '02'  "+ENTER
_cQuery += " AND CR_USER    = '"+cCodAux+"' "+ENTER
_cQuery += " AND CR_XHTML  <> '' "+ENTER
_cQuery += " AND (	CR_USER = '"+cCodAux+"' "+ENTER
_cQuery += "     OR  "+ENTER
_cQuery += " 		CR_USER IN ( SELECT AK_USER 
_cQuery += " 						FROM SAK020 SAK (NOLOCK) "+ENTER
_cQuery += " 							WHERE SAK.D_E_L_E_T_=''  "+ENTER
_cQuery += " 						     AND AK_APROSUP IN ( SELECT AK_COD  "+ENTER
_cQuery += " 													FROM SAK020 SAK (NOLOCK) "+ENTER
_cQuery += " 														WHERE SAK.D_E_L_E_T_=''  "+ENTER
_cQuery += " 														  AND AK_USER='"+cCodAux+"') )  )  "+ENTER
_cQuery += " ORDER BY 3,4  "+ENTER

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

Conout('*************** PORTAL_SNY *************** [AWKFPCOM] - Retorn:'+AllTrim(Str(_nMax)))

IF _nMax > 0
    While _DIR->(!Eof())
		_nItens ++
		_xHtm := STRTRAN(Memoread(ALLTRIM(_DIR->CR_XHTML)),"APROVACAO",'APROVACAO_'+cValToChar(_DIR->RECSCR) )  
		_xHtm := STRTRAN(_xHtm,"OBSERV",'OBSERV_'+cValToChar(_DIR->RECSCR) )
		_cReturn += _xHtm
        _DIR->(DbSkip())
    EndDo
EndIF

//Desconecta
//TCUnlink(_nHandle)

Return(_cReturn)

*-----------------------*
User Function AWKFPCBT()
*------------------------*
cButton:= ''

cButton+= ' '
cButton+= ' </form> '
cButton+= '            &nbsp;<table bgcolor="#f2f4f7" border="0" width="100%">'
cButton+= '                <tbody>'
cButton+= '                    <tr bgcolor="#f2f4f7" align="right">'
cButton+= '                        <td bgcolor="#f2f4f7" width="100%">'
cButton+= '                            <font face="Verdana">'
cButton+= '                                <input name="Button2" value="Enviar" type="submit" id="Button2" onclick="loading();">'
cButton+= '                            </font>&nbsp;'
cButton+= '							   <font face="Verdana"><input name="B2" value="Limpar" type="reset" ></font>&nbsp;&nbsp;&nbsp;'
cButton+= '							   		<font face="Verdana" size="4" ><b>Aprovar Todos: &nbsp;</b></font>
cButton+= '              	           		<font face="Verdana" size="4"><input name="ApvAll" value="S" type="radio" onclick="handleClick();" >Sim.</font>&nbsp;
cButton+= '              			   		<font face="Verdana" size="4"><input name="ApvAll" value="N" type="radio" onclick="handleClick();" >Não. </font>&nbsp;
cButton+= '                			   		<font face="Verdana" size="4"><input checked="checked" name="ApvAll" value="X" type="radio" onclick="handleClick();" >Mais Tarde.</font></b></font>
cButton+= '							   </font>
cButton+= '                        </td>'
cButton+= '                    </tr>'
cButton+= '                </tbody>'
cButton+= '            </table>'

Return cButton

*---------------------*
User Function AWKFPCJS
*---------------------*
_cJavScpt :=""

_cJavScpt += ' <style>'
_cJavScpt += '	#loading{'
_cJavScpt += '		display: none;'
_cJavScpt += '		z-index: 10;'
_cJavScpt += '		position: absolute;'
_cJavScpt += '		color: #fff;'
_cJavScpt += '		top: 10;'
_cJavScpt += '		left: 40%;'
_cJavScpt += '		font-size: x-large;'

_cJavScpt += '	}'
_cJavScpt += '	.show{'
_cJavScpt += '		display: block !important;'
_cJavScpt += '	}'
_cJavScpt += '	#overflow{'
_cJavScpt += '		display: none;'
_cJavScpt += '	}'
_cJavScpt += '	.overflow{'
_cJavScpt += '		position: fixed;'
_cJavScpt += '		width: 100%;'
_cJavScpt += '		height: 100%;'
_cJavScpt += '		background-color: rgba(0,0,0,0.8);'
_cJavScpt += '		z-index: 5;'
_cJavScpt += '		display: block !important;'
_cJavScpt += '	}'
_cJavScpt += ' .onclick-menu {position: relative;display: inline-block;list-style:none;cursor:pointer}'
_cJavScpt += ' .onclick-menu:before {content: "Summary payments supplier";background-color:#94a4a5;}'
_cJavScpt += ' .onclick-menu:focus {pointer-events: none;}'
_cJavScpt += ' .onclick-menu:focus .onclick-menu-content {opacity: 1;visibility: visible;pointer-events: auto;}'
_cJavScpt += ' .onclick-menu-content {margin: 0; padding: 0;position: absolute;z-index: 1;opacity: 0;visibility: hidden;transition: visibility 0.5s;top:25px; left:0; background-color:#fff;}'
_cJavScpt += ' .menuli {margin: 0; padding: 0;display:block; width:500px;}'
_cJavScpt += '  </style>'

_cJavScpt += '<SCRIPT LANGUAGE="javascript" TYPE="text/javascript"> '

_cJavScpt += 'function handleClick() {'

_cJavScpt += '  objOpcao1 = document.getElementsByName("ApvAll");'
_cJavScpt += '  var inputs = document.getElementsByTagName("input");'

_cJavScpt += '	if (objOpcao1[0].checked == true){ '

_cJavScpt += '		for(var i = 0; i < inputs.length; i++) {'
_cJavScpt += '			if(inputs[i].type.toLowerCase() == "radio" && inputs[i].value.indexOf("APV") > -1 && inputs[i].value.indexOf("S") > -1) {'
_cJavScpt += '				inputs[i].checked = true;'
_cJavScpt += '			}'
_cJavScpt += '		}'

_cJavScpt += '     }  else if (objOpcao1[1].checked == true) {'

_cJavScpt += '		for(var i = 0; i < inputs.length; i++) {'
_cJavScpt += '			if(inputs[i].type.toLowerCase() == "radio" && inputs[i].value.indexOf("APV") > -1 && inputs[i].value.indexOf("N") > -1) {'
_cJavScpt += '				inputs[i].checked = true;'
_cJavScpt += '			}'
_cJavScpt += '		}'

_cJavScpt += '	 } else if (objOpcao1[2].checked == true) {'

_cJavScpt += '		for(var i = 0; i < inputs.length; i++) {'
_cJavScpt += '			if(inputs[i].type.toLowerCase() == "radio" && inputs[i].value.indexOf("APV") > -1 && inputs[i].value.indexOf("X") > -1) {'
_cJavScpt += '				inputs[i].checked = true;'
_cJavScpt += '			}'
_cJavScpt += '		}'

_cJavScpt += '	 }'

_cJavScpt += '}'

_cJavScpt += '	function  loading() {'
_cJavScpt += '		var loading = document.getElementById("loading"),'
_cJavScpt += '			overflow = document.getElementById("overflow");'
_cJavScpt += '		loading.className = "show";'
_cJavScpt += '		overflow.className = "overflow";'
//_cJavScpt += '		setTimeout(function teste2(){'
_cJavScpt += '			var form = document.getElementById("PWFCOM");		'
_cJavScpt += '			form.submit();'
//_cJavScpt += '		}, 5000);'
_cJavScpt += '		return false;'
_cJavScpt += '	}'

_cJavScpt += 'function getSecs(sHors, sMins, sSecs, campo){'
_cJavScpt += '	sSecs++;'
	
_cJavScpt += '	sMins = "0"+sMins;'
_cJavScpt += '	sHors = "0"+sHors;'
 
_cJavScpt += '	if(sSecs==60){sSecs=0;sMins++;'
_cJavScpt += '    if(sMins<=9)sMins="0"+sMins;'
_cJavScpt += '    }'
_cJavScpt += '	if(sMins==60){sMins="0"+0;sHors++;'
_cJavScpt += '    if(sHors<=9)sHors="0"+sHors;'
_cJavScpt += '	}'
_cJavScpt += '	if(sSecs<=9)sSecs="0"+sSecs;'
     
_cJavScpt += '	document.getElementById(campo).innerHTML=sHors+"<font color=#000000>:</font>"+sMins+"<font color=#000000>:</font>"+sSecs;'

_cJavScpt += '    setTimeout("getSecs("+sHors+", "+sMins+","+sSecs+", '+ "'"+'" +campo+ "'+"'"+')",1000);'
	
_cJavScpt += '	}'

_cJavScpt += '</SCRIPT>'

_cJavScpt += '<body style="margin:0;">'
_cJavScpt += '<div id="overflow"></div>'
_cJavScpt += '	<div id="loading">'
_cJavScpt += '		Carregando...'
_cJavScpt += '	</div>'

_cJavScpt += '<table bgcolor="#f2f4f7" border="0" width="100%">'
_cJavScpt+= '	<tbody>'
_cJavScpt+= '		<tr bgcolor="#f2f4f7" align="right">'
_cJavScpt+= '			<td bgcolor="#f2f4f7" width="100%">'
_cJavScpt+= '				<span id="clock1"></span>
_cJavScpt+= '					<script>setTimeout("getSecs(0,0,-1, \"clock1\")",1000);</script>'
_cJavScpt+= ' 					<font face="Verdana" size="2"><a href="./AWKFLOFF.apw"> Logoff</a></font>&nbsp;</span>'	
_cJavScpt+= ' 						<p style="text-align: center;  margin-top: 0;">'
_cJavScpt+= ' 							<img src="https://cdn.desconto.com.br/img/merchants/132446/360-logo/v1/salonline-descontos.png" alt="SalonLine"><br>'
_cJavScpt+= ' 							<font face="Verdana" size="4"><b>Pedidos de Compra</b></font> 
_cJavScpt+= '						</p>'  
_cJavScpt+= '					</font>'
_cJavScpt+= '          	</td>'
_cJavScpt+= '    	</tr>'
_cJavScpt+= '    	<tr bgcolor="#f2f4f7" align="left"> '
_cJavScpt+= '    		<td bgcolor="#f2f4f7" width="100%"> '
_cJavScpt+= '    			<font face="Verdana" size="1"><b>Olá ##RetCodUsr##, você tem ##_nItens## pedido(s) pendente de aprovação!</b></font></p></font><br> '
_cJavScpt+= '    		</td>  '
_cJavScpt+= '    	</tr>  '
_cJavScpt+= '	</tbody>'
_cJavScpt+= ' </table>'

_cJavScpt += '<form action="./AWKFRET.APW" method="post" name="PWFCOM" id="PWFCOM"> '

Return _cJavScpt


*---------------------*
User Function AWKFPCRT
*---------------------*
Local aRetornos := {}
Local _nDebug   := 1
Local _cFoi     := ''
Local nI        := 0

For nI := 1 to Len(HTTPPOST->APOST)

	IF 'APROVACAO_' $ HTTPPOST->APOST[nI] 
		//_cVar := HTTPPOST->APOST[nI]
		//_cVarApv := &("HTTPPOST->"+_cVar)
		//_cRecno := Substring(_cVar,AT('_',_cVar)+1,LEN(_cVar))
		
		//_nPosObs := ASCAN(HTTPPOST->APOST, { |x| UPPER(x) == "OBSERV_"+_cRecno })
		
	Else
		IF 'OBSERV_' $ HTTPPOST->APOST[nI]  
			_cVar 		:= HTTPPOST->APOST[nI]
			_cVarObs 	:=  &("HTTPPOST->"+_cVar)
			_cRecno 	:= Substring(_cVar,AT('_',_cVar)+1,LEN(_cVar))
			
			_cOVar 		:= _cVar
			
			_nPosApv := ASCAN(HTTPPOST->APOST, { |x| UPPER(x) == "APROVACAO_"+_cRecno })
			IF _nPosApv > 0
				_cVar := HTTPPOST->APOST[_nPosApv]
				_cVarApv := &("HTTPPOST->"+_cVar)
			Else
				_cVarApv := ''
			Endif
		 
			IF !("X" $ _cVarApv) .AND. !(_cOVar $ _cFoi)
				aAdd(aRetornos,{_cVarApv,_cVarObs})
				_cFoi += _cOVar+";"
			Endif
		 
			_cVarApv := ''
			_cVarObs := ''
		ENdif
	Endif
	
Next

IF _nDebug == 0
	StartJob("u_AWKFPCAPV",'PORTAL',.F.,aRetornos)
Else
	u_AWKFPCAPV(aRetornos) 
Endif

__cRetorno := ' <html>'
__cRetorno += ' <head>'
__cRetorno += '   <meta http-equiv="refresh" content="2; url=./AWKFLOGIN.APW">'
__cRetorno += ' </head> '
__cRetorno += ' <body> '
__cRetorno += '   <p>'+"Retorno Recebido com Sucesso "+TIME()
__cRetorno += '  <a href="./AWKFLOGIN.APW">Login</a></p> '
__cRetorno += ' </body> '
__cRetorno += ' </html> '

Return __cRetorno


*--------------------------------*
User Function AWKFPCAPV(aRetornos)
*--------------------------------*
Local aSm0  := u_zCJGetFil()
Local _nEmp := 1
Local _aPcs := {}
Local nC    := 0

U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 

For nC:=1 To Len(aRetornos)
	
	IF "S" $ aRetornos[nC][1]
		_xRetorno := STRTRAN(aRetornos[nC][1] ,"APV_" ,"")
		_nRecno   := VAL(STRTRAN(_xRetorno ,"S" ,""))
		_cObs     := alltrim(aRetornos[nC][2])
	
		SCR->(DBSETORDER(1))
		SCR->(DBGOTO(_nRecno))
		
		aAdd(_aPcs,{SCR->CR_NUM,ALLTRIM(_cObs),SCR->CR_USER,SCR->(Recno())})
	
		Private INCLUI := .F.
		A097ProcLib(SCR->(Recno()),2,,,,,dDataBase,)
		//A097ProcSup(SCR->(Recno()),2,SCR->CR_TOTAL,cAprovS,SCR->CR_GRUPO,SCR->CR_OBS,SCR->CR_APROV,SCR->CR_DATALIB)
	Else
		_xRetorno := STRTRAN(aRetornos[nC][1] ,"APV_" ,"")
		_nRecno := VAL(STRTRAN(_xRetorno ,"N" ,""))
		_cObs := alltrim(aRetornos[nC][2])

		SCR->(DBSETORDER(1))
		SCR->(DBGOTO(_nRecno))
		
		aAdd(_aPcs,{SCR->CR_NUM,ALLTRIM(_cObs),SCR->CR_USER,SCR->(Recno())})
		
		cChave := xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
			
	   	bBlock := ErrorBlock( { |e| ChecErro(e) } )
		BEGIN SEQUENCE
			MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,_cObs}, dDataBase ,7,,,,,,,cChave)
		RECOVER
			lRet := .F.
		END SEQUENCE
		ErrorBlock(bBlock)		
	Endif	
Next nC

U_AWKFPCLIB(_aPcs)

U_fVerifJob(,,.T.,"FECHAR")

Return

*----------------------------*
User Function AWKFPCLIB(_aPcs)
*----------------------------*
Local nP 		:= 0
Local nG 		:= 0
Local _cHeader 	:= ''
Local _cEnable  := 'target="_blank" class=""'
Local _cDesable := 'target="_blank" class="disabled"'
Local _xEmails := {}

For nG := 1 To Len(_aPcs)	
	_xEmails := {}
	_nRecSCR := _aPcs[nG][4]
	
	DBSelectArea('SC7');SC7->(DBSETORDER(1))
	SC7->(DBSEEK(xFilial("SC7")+Substr(_aPcs[nG][1],1,len(SC7->C7_NUM))))
	
	IF SC7->C7_CONAPRO == 'L' .OR. SC7->C7_CONAPRO == 'R'
		
		cQuery := "SELECT R_E_C_N_O_ FROM "+RetSQLName("SW2")+" WHERE D_E_L_E_T_ = ' ' AND W2_PO_SIGA = '"+SC7->C7_NUM+"'" 
				
		IIf(Select("ZZZ") > 0,ZZZ->(DbCloseArea()),NIL)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'ZZZ',.T.,.T.)
		
		If ZZZ->(!Eof())		
			cQueryUpd := " UPDATE "+RETSQLNAME("SW2")+" SET W2_CONAPRO = '"+SC7->C7_CONAPRO+"' WHERE R_E_C_N_O_ = "+CVALTOCHAR(ZZZ->R_E_C_N_O_)+" "	
			IF !(TcSqlExec(cQueryUpd) >= 0)					
				Conout('Erro ao atualizar a Purchase Order. R_E_C_N_O_ = '+CVALTOCHAR(ZZZ->R_E_C_N_O_))
			Endif			
		EndIf
		
		DBSelectArea('SC1');SC1->(DBSETORDER(6))
		IF SC1->(DBSEEK(xFilial("SC1")+Substr(SC7->C7_NUM,1,len(SC1->C1_PEDIDO))))
			aAdd(_xEmails, SC1->C1_USER)
		Endif			
		aAdd(_xEmails, SC7->C7_USER)
		
		cQuery := "SELECT * FROM SCR020 WHERE D_E_L_E_T_=''  AND CR_NUM='"+SC7->C7_NUM+"'" 
		cQuery += " AND (CR_VALLIB > 0  "+IIF(SC7->C7_CONAPRO == 'R'," OR CR_STATUS='06' ",'')+" ) "
		
		IIf(Select("ZZZ") > 0,ZZZ->(DbCloseArea()),NIL)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'ZZZ',.T.,.T.)
		
		While ZZZ->(!Eof())		
			//aAdd(_xEmails, ZZZ->CR_USER )			
			ZZZ->(DBSKIP())
		Enddo
	
		ZZZ->(DBGOTOP())
		_xHtm := STRTRAN(Memoread(ALLTRIM(ZZZ->CR_XHTML)),'type="radio"','type="hidden"')
		
		_xHtm := STRTRAN(_xHtm,'<!--inicio-->','<!--inicio')
		_xHtm := STRTRAN(_xHtm,'<!--fim-->','-->')
		
		//IF !Empty(_aPcs[nG][2])			
			___Obs := ''
			___Obs := IIF(SC7->C7_CONAPRO == 'R'," Rejeitado por "+ Capital(UsrFullName(_aPcs[nG][3]))+ ', pelo motivo: '," Aprovado por "+ Capital(UsrFullName(_aPcs[nG][3]))+ ': ')
			___Obs := ___Obs+_aPcs[nG][2]			

			//Escreve na Observação do Pedido
			_xHtm  := STRTRAN(_xHtm,'</textarea></font>',___Obs+'</textarea>'+'</font>')	

			//Desabilita botões de Anexo
			_xHtm  := STRTRAN(_xHtm,_cEnable,_cDesable)	
		//Endif 
		
		DBSelectArea('SCR');SCR->(DbGoTop());SCR->(DbGoto(_nRecSCR))
		IF _nRecSCR == SCR->(Recno())
			IF 	RecLock('SCR',.F.)
					Replace SCR->CR_OBS With ___Obs
				SCR->(MsUnLock())
			ENDIF
		ENDIF
	
		For nP := 1 To Len(_xEmails)
			conout('enviando email liberacao/rejeicao ->'+UsrRetMail(_xEmails[nP])+" - N.  "+SC7->C7_NUM)

			IF SC7->C7_TIPO == 2
				_cHeader += 'AE SalonLine| Autorização de Entrega nº '+SC7->C7_NUM+' - '+IIF(SC7->C7_CONAPRO == 'R',"Rejeitado",'Aprovado')
			ELSE
				_cHeader += 'PC SalonLine | Pedido de Compras nº '+SC7->C7_NUM+' - '+IIF(SC7->C7_CONAPRO == 'R',"Rejeitado",'Aprovado')
			ENDIF

			//u_E2Email('',_xEmails[nP],_xHtm,'WFLW - Compras - '+IIF(SC7->C7_CONAPRO == 'R',"Rejeitado",'Aprovado')+' - '+Substr(_aPcs[nG][1],1,len(SC7->C7_NUM)))
			u_zSN_AspMail(_xEmails[nP],UsrRetMail(_xEmails[nP]),'','',_xHtm,_cHeader,,SC7->C7_NUM)
		Next nP
	
	Endif	
Next

Return

*---------------------------------------------*
User Function AWKFFILE(_cFile,_cFilProc,_cOrig)     
*---------------------------------------------*
Local cHtml		:= ''      
Local cBuffer	:= space(1024)            
Local hArq       
Local nTam             
Local _cNameDir := ''
Local _cQrySZP  := ''
Local _aSZP     := Array(6,'')
Local _cDirServ := ''
Local _cDirExp  := ''
Local _cProc    := ''

//Local _cBcoDados:= "MSSQL/PROTHEUS_PROD"  //Conexão no DbAccess com a outra base de Dados
//Local _cServer  := "10.50.1.10"         //Servidor que está configurado o DbAccess
//Local _nPorta   := 7890                 //Porta da conexão do DbAccess
//Local _nHandle  := 0                  //Ponteiro que armazenará a conexão

Local aSm0  	:= u_zCJGetFil()
Local _nEmp 	:= 1
U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 

Default _cFile    := '' //HTTPGET->X
Default _cFilProc := '' //HTTPGET->F
Default _cOrig    := '' //HTTPGET->T

_cDirServ := '\dirdoc\co'+cEmpAnt+'\'

//Função para criar diretório com seus subdiretórios, com a vantagem de criar todo o caminho.
FWMakeDir(_cDirServ)

//U_fVerifJob(_aSm0[_nEmp,1],_aSm0[_nFil,2],,,3)

_cFilProc := _aSm0[_nFil,2]

//Conecta com Banco
//_nHandle  := TcLink(_cBcoDados, _cServer, _nPorta)
 
//Se houve algum erro na conexão
//If _nHandle < 0
//    MsgInfo("Não foi possível conectar! Erro: " + cValToChar(_nHandle), "Atenção")
//  	Conout("ASPINIT - Falha de conexão "+cValToChar(_nHandle))
//	Return("[#002] Não foi possível conectar! Erro: " + cValToChar(_nHandle))   
//ENDIF

cQuery := "SELECT * FROM ACB020 WHERE D_E_L_E_T_='' AND ACB_CODOBJ='"+_cFile+"' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'ZZZ',.T.,.T.)

DbSelectArea('ZZZ')
ZZZ->(DBGOTOP())

//IF ZZZ->(!EOF())
//	_cFile     := '\dirdoc\co01\shared\'+ALLTRIM(ZZZ->ACB_OBJETO)
//	_cNameDir := ALLTRIM(ZZZ->ACB_OBJETO)
//Else
//	_cFile := ''
//Endif

_cProc += '1,'
//TCUnlink(_nHandle)
_cProc += '2,'
//____________________________________________________________[ VERIFICA ARQUIVO PDF EM BASE 64 ]___________________________________________________

IF .T. //!Empty(_cFile)
	If Select("SX6") == 0
		RpcSetType(3)
		RpcSetEnv("01","02")
	Endif
	_cProc += '3,'
	_cQrySZP := " SELECT R_E_C_N_O_ RECSZP FROM SZP020 SZP (NOLOCK) WHERE SZP.D_E_L_E_T_='' AND ZP_TABELA = '"+_cOrig+"' AND ZP_CHAVE = '"+_cFile+"' "

	_cProc += '4,'
	IF Select('_DIR') > 0
		_DIR->(DbCloseArea())
	EndIF
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySZP),'_DIR',.F.,.T.)
	DbSelectArea('_DIR');_DIR->(DbGoTop())
	_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

	While _DIR->(!Eof())
		_cProc += '5,'
		DbSelectArea('SZP'); SZP->(DbGoTo(_DIR->RECSZP))
		IF SZP->(Recno()) == _DIR->RECSZP
			_cProc += '5,'
			_cNameDir := AllTrim(SZP->ZP_ARQUIVO)
			//Carrega daddos para SZP
			_aSZP[1] := SZP->(Recno())
			_aSZP[2] := .T.

			If ExistBlock("zSZPEAuto")
				_cProc += '7,'
				_cDirExp := ExecBlock("zSZPEAuto",.F.,.F.,_aSZP)
				_cProc += '8['+_cDirExp+'],'
			ENDIF 
			Exit
		ENDIF
		_DIR->(DbSkip())
	EndDo

	IF File(_cDirExp)
		_cProc += '9,'
		//Copiando o arquivo via CpyT2S
		//CpyT2S(_cDirExp, _cDirServ)

		_cProc += '10,'
		//Apaga Aruivo da Temporaria
		//fErase(_cDirExp)

		_cProc += '11,'
		_cFile := _cDirServ + _cNameDir
		_cProc += '12['+_cFile+'],'
		//_cFile    := '\dirdoc\co01\rel_pc_084276.pdf'
	ENDIF
ENDIF

aFiles := {}
aSizes := {}

_cProc += '13,'
IF File(_cFile)

	_cProc += '14,'
    ADir(_cFile, aFiles, aSizes) //Verifica o tamanho do arquivo, parâmetro exigido na FRead
    //nHandle := fOpen(_cFile , FO_READWRITE + FO_SHARED )
	nHandle := fOpen(_cFile)
    cString := ""
	nTam 	:=  aSizes[1]
    FRead( nHandle, @cString, aSizes[1] ) //Carrega na variável cString, a string ASCII do arquivo
    _cTexto64 := Encode64(cString) //Converte o arquivo para BASE64

    fClose(nHandle) //Fecha arquivo log temp

	//etorna o conteúdo do identificador Content-length do header HTTP - (.APL, .APW).
	nRet := HTTPRCTLen()
	
	//Habilita/Desabilita o envio parcial do HTML - HyperText Markup Language.
	HttpSetPart(.T.) 
				
	//Indica o tipo de pacote HTTP - HyperText Transfer Protocol (Protocolo de Transferência de Hipertexto),  que será retornado para uma determinada requisição HTTP.
	__Type := 'application/octet-stream' 	
	HttpCTType(__Type) 

	//Provê informações sobre como apresentar uma mensagem ou parte de um pacote.
	_type2 := 'attachment; filename="'+_cNameDir+'"'    	
	HttpCTDisp(_type2)      	

	//Indica o tamanho do pacote HTTP - HyperText Transfer Protocol (Protocolo de Transferência de Hipertexto) que será enviado ao browser.
	HttpCTLen(nTam)      	

	//HTTPSend(cImagem) 

	//Retorna uma string HTML - Hypertext Markup Language a um browser durante o processamento de uma requisição realizada através de um link APW - Advanced Program Web, utilizando Working Threads, durante o processamento.    		
	//HttpSend(_cTexto64) 
	HttpSend(cString)

	//Apaga Aruivo da Temporaria
	fErase(_cFile)
Else
	cHtml += '      ----------------------------------------------------------------Arquivo '+_cFile+' não encontrado. Filial: '+_cFilProc+'. Origem: '+_cOrig+'  --------------------------------------------------------------------------------'      
	cHtml += '<br><br>'
	cHtml += _cProc
ENDIF

Return(cHtml)

//______________________________________________________________________________________________________________________________________________________
If !file(_cFile)      	
	cHtml += '      --------------------------------------------------------------------------------Arquivo '+_cFile+' não encontrado.      --------------------------------------------------------------------------------'      
	
ElseIf (hArq := FOpen(_cFile)) < 0      	
	cHtml += '      --------------------------------------------------------------------------------Falha na Abertura do Arquivo '+_cFile+' ( FERROR '+str(ferror(),4)+' )      --------------------------------------------------------------------------------'      
Else      	      	
// Le o arquivo e manda p/ o browse       	

nTam := FSeek(hArq, 0, 2)      	
//FSeek(hArq, 0, 0 )     

cBuffer := Space(nEof:=Fseek(hArq,0,2)) 

Fseek(hArq,0,0)                        // posiciona no inicio do arquivo 
fRead(hArq,@cBuffer,nEof)              // lê o arquivo e armazena em cBuffer 
fClose(hArq)                           // fecha o arquivo    

//cImagem := Encode64(cBuffer) 

nRet := HTTPRCTLen()
 
HttpSetPart(.T.) 
	      	  
__Type := 'application/octet-stream' 	
HttpCTType(__Type) 
_type2 := 'attachment; filename="'+_cFile+'"'    	
HttpCTDisp(_type2)      	
HttpCTLen(nTam)      	

//HTTPSend(cImagem) 

//While FRead(hArq, @cBuffer, 1024)>0      		
	HttpSend(cBuffer)      	
//EndDo      	

//FClose(hArq)
       		      
Endif            

Return cHtml

*----------------------------------*
User Function AWKFPDFOP( cFile )     
*-----------------------------------*       
Local cHtml		:= ''      
Local cBuffer	:= space(1024)            
Local hArq       
Local nTam             

//Local _cBcoDados:= "MSSQL/PROTHEUS_PROD"  //Conexão no DbAccess com a outra base de Dados
//Local _cServer  := "10.50.1.10"         //Servidor que está configurado o DbAccess
//Local _nPorta   := 7890                 //Porta da conexão do DbAccess
//Local _nHandle   := 0                  	//Ponteiro que armazenará a conexão

Local aSm0  	:= u_zCJGetFil()
Local _nEmp 	:= 1
U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 

__OP := cFile
IF !Empty(cFile)
	cFile := '\dirdoc\co'+cEmpAnt+'\shared\op\'+ALLTRIM(cFile)+'.htm'
Else
	cFile := 'XXX'
Endif

If !file(cFile)      	
	cHtml += '      --------------------------------------------------------------------------------Arquivo '+cFile+' não encontrado.      --------------------------------------------------------------------------------'      
	RETURN 'Não encontrado'
ElseIf (hArq := FOpen(cFile)) < 0      	
	cHtml += '      --------------------------------------------------------------------------------Falha na Abertura do Arquivo '+cFile+' ( FERROR '+str(ferror(),4)+' )      --------------------------------------------------------------------------------'      
	Return 'Erro abrir arquivo'	
Else      	      	

////Conecta com Banco
//_nHandle  := TcLink(_cBcoDados, _cServer, _nPorta)
// 
////Se houve algum erro na conexão
//If _nHandle < 0
//    MsgInfo("Não foi possível conectar! Erro: " + cValToChar(_nHandle), "Atenção")
//  	Conout("ASPINIT - Falha de conexão "+cValToChar(_nHandle))
//	Return("[#003] Não foi possível conectar! Erro: " + cValToChar(_nHandle))  
//ENDIF

_cQryExc := " UPDATE SC2020 SET C2_XIMPRES = 'S' WHERE C2_NUM='"+__OP+"'"	
IF !(TcSqlExec(_cQryExc) >= 0)					
	Conout('Problema ao excluir informações fiscais. Contate o Suporte')
	Return 'Erro alterar OP'
Endif		

//TCUnlink(_nHandle)

// Le o arquivo e manda p/ o browse       	

nTam := FSeek(hArq, 0, 2)      	
//FSeek(hArq, 0, 0 )     

cBuffer:=Space(nEof:=Fseek(hArq,0,2)) 

Fseek(hArq,0,0)                        // posiciona no inicio do arquivo 
fRead(hArq,@cBuffer,nEof)              // lê o arquivo e armazena em cBuffer 
fClose(hArq)                           // fecha o arquivo    


cBuffer := strtran(cBuffer,'Zoom Out</a>', 'Zoom Out</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:window.print()" style="font-size:12px;">Imprimir</a>' )
cBuffer := strtran(cBuffer,'lgmid.bmp', 'http://www.adufertil.com.br/images/logo_adufertil.gif')
cBuffer := strtran(cBuffer,'</style><div', '</style><body onload="javascript:zoom(0.3)"><div' )


//cImagem := Encode64(cBuffer) 
/*
nRet := HTTPRCTLen()
 
HttpSetPart(.T.) 
	      	  
__Type := 'application/octet-stream'
__Type := 'text/html' 	
HttpCTType(__Type) 
_type2 := 'attachment; filename="'+cFile+'"'    	
HttpCTDisp(_type2)      	
HttpCTLen(nTam)      	

//HTTPSend(cImagem) */

//While FRead(hArq, @cBuffer, 1024)>0      		
	HttpSend(cBuffer)      	
//EndDo      	

//FClose(hArq)
       		      
Endif            

Return cHtml

*-----------------------------------------------------------------------------*
User Function zSN_AspMail(_cID_User,_cTo,_cCopia,_cCC,_cCorpo,_cHeader,_aAnexo,_cNumPC)
*-----------------------------------------------------------------------------*
Default _cID_User   := __cUserID
Default _cTo 	 	:= UsrRetMail(_cID_User)
Default _cCopia 	:= Alltrim(GetMV('SN_MAILASP',.F.,''))
Default _cCC	 	:= '' //"gustavo@gsconsulti.com.br"
Default _cHeader 	:= "SalonLine | Portal de Liberação"
Default _aAnexo 	:= {}
Default _cCorpo 	:= ''
Default _cNumPC     := ''

_cTo := 'gustavo@gsconsulti.com.br'
//_cNomUsr := Capital(UsrFullName(_aWF[_nW][2]))
//_cTo     := UsrRetMail(_aWF[_nW][2])

_aSendo   := u_g2EnvMail(_cTo,_cCopia,_cCC, _cHeader, _cCorpo, _aAnexo,'', .F., ,.T.)
_lSend    := _aSendo[1]
_cLogMail := AllTrim(_aSendo[2])
_cLogStts := _aSendo[3]	//1=Enviado;2=Erro Cfg e-mail;3=Erro Conteudo

IF !_lSend .And. !IsBlind()
	//MsgAlert("<b>Workflow não enviado!</b> <br><br> Verifique o log dos titulos selecionados.<br><br>"+_cLogMail, "Atenção")
ENDIF 

//zGrvSZKWFU_zGrvSZKWF(.T.,_cNumPC,_lSend,_cLogStts,_cLogMail,_cID_User,_cTo,_cCopia,_cCC, _cHeader, _cCorpo, _aAnexo) 
RETURN
