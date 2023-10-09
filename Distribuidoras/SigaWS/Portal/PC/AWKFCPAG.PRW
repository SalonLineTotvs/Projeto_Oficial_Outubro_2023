#Include 'protheus.ch'

#Define ENTER Chr(13)+Chr(10)   

*--------------------------------------------------------------------------------------------------------------*
User Function AWKFCPAG(_nItens,_lOnlyQry,_nRecSE2,_lConsulta,_dDataDe,_dDataAte,cCodAux,_nSaldo,_cTipo,_cGetHtm2)
*--------------------------------------------------------------------------------------------------------------*
Local _cQuery     := ''
Local _xHtm       := ''
Local _cReturn    := ''
Local _cBoxResumo := ''
Local _aBoxResumo := {}
Local _nR         := 0
Local _nSum       := 0
//Local _cMV_IMP  := "'INS','ISS','TX','TXA'"
Local _cMV_IMP    := MVABATIM+'|'+MVTAXA+'|'+MVTXA+'|'+MVIRF+'|'+MVINSS+'|'+MVCOFINS+'|'+MVPIS+'|'+MVCS+'|'+MVISS

Local aSm0  	:= u_zCJGetFil()
Local _nEmp 	:= 1
U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 

//Local _cBcoDados:= "MSSQL/PROTHEUS_PROD"  //Conexão no DbAccess com a outra base de Dados
//Local _cServer  := "10.50.1.10"         //Servidor que está configurado o DbAccess
//Local _nPorta   := 7890                 //Porta da conexão do DbAccess
//Local _nHandle  := 0                  //Ponteiro que armazenará a conexão

Default _nItens    := 0
Default _lOnlyQry  := .F.
Default _nRecSE2   := 0
Default _lConsulta := .F.
Default _dDataDe   := dDataBase
Default _dDataAte  := dDataBase
Default cCodAux    := ''
Default _nSaldo    := 0
Default _cTipo     := ''

_nItens := 0

//IF !_lOnlyQry
//    //Conecta com Banco
//    _nHandle  := TcLink(_cBcoDados, _cServer, _nPorta)
//    
//    //Se houve algum erro na conexão
//    If _nHandle < 0
//        MsgInfo("Não foi possível conectar! Erro: " + cValToChar(_nHandle), "Atenção")
//        Conout("ASPINIT - Falha de conexão "+cValToChar(nTopHnd))
//        Return("[#001] Não foi possível conectar! Erro: " + cValToChar(_nHandle))   
//    ENDIF
//ENDIF

_cQuery += " SELECT A2_NOME FORNECEDOR, E2_NUM+' - '+E2_PARCELA NUMERO, ISNULL(ED_DESCRIC,'') NATUREZA, 
_cQuery += "  		E2_SALDO SALDO, E2_EMISSAO EMISSAO, E2_VENCREA VENCIMENTO, SE2.R_E_C_N_O_ RECSE2, E2_FILORIG FILORIG, E2_TIPO TIPO, ISNULL(NF.RECSF2,0) RECSF2"+ENTER
_cQuery += "   FROM SE2020 SE2 (NOLOCK)  "+ENTER
_cQuery += "   INNER JOIN SA2020 SA2 ON SA2.D_E_L_E_T_='' AND A2_FILIAL='' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA "+ENTER
_cQuery += "   LEFT  JOIN SED020 SED ON SED.D_E_L_E_T_='' AND ED_FILIAL='' AND ED_CODIGO=E2_NATUREZ"+ENTER
_cQuery += "   OUTER APPLY ("+ENTER
_cQuery += " 			   SELECT ISNULL(SF1.R_E_C_N_O_,0) RECSF2"+ENTER
_cQuery += " 				FROM SF1020 SF1 "+ENTER
_cQuery += " 					WHERE SF1.D_E_L_E_T_='' AND F1_FILIAL = E2_FILORIG AND F1_DOC=E2_NUM AND F1_SERIE=E2_PREFIXO AND F1_FORNECE=E2_FORNECE AND F1_LOJA=E2_LOJA"+ENTER
_cQuery += " 			  ) NF"+ENTER
_cQuery += "     WHERE SE2.D_E_L_E_T_ = ''   "+ENTER
_cQuery += "       AND E2_SALDO    > 0  "+ENTER

//Monta Query para retorno no WF de conclusão
IF _lOnlyQry
    DbSelectArea('SE2'); SE2->(DbGoTop());SE2->(DbGoTo(_nRecSE2))

    _cQuery += "       AND E2_PREFIXO = '"+SE2->E2_PREFIXO+"' 	"+ENTER
    _cQuery += "       AND E2_NUM     = '"+SE2->E2_NUM+"' 		"+ENTER
    _cQuery += "       AND E2_FORNECE = '"+SE2->E2_FORNECE+"' 	"+ENTER
    _cQuery += "       AND E2_LOJA    = '"+SE2->E2_LOJA+"' 		"+ENTER

    //Ajustado para fazer por parcela e nao não Titulo
    _cQuery += "       AND SE2.R_E_C_N_O_    = "+AllTrim(cValToChar(_nRecSE2))+"     "+ENTER
ELSE    
    //_cQuery += "      AND E2_XWS_HTM <> ''  "+ENTER
    _cQuery += "      AND E2_XWS_DLI = ''  "+ENTER
    //_cQuery += "      AND E2_XWS_APR = '"+cCodAux+"'  "+ENTER
    _cQuery += "      AND E2_VENCREA BETWEEN '"+DtoS(_dDataDe)+"' AND '"+DtoS(_dDataAte)+"' "+ENTER
ENDIF

IF _cTipo == 'DOC'      //Documento Fiscal
    _cQuery += "  AND E2_TIPO NOT IN "+FormatIn(_cMV_IMP,'|')+" "
ElseIF _cTipo == 'IMP'  //Impostos
    _cQuery += "  AND E2_TIPO IN "+FormatIn(_cMV_IMP,'|')+" "
ENDIF

//_cQuery += " GROUP BY A2_COD,A2_LOJA,A2_NOME, E2_PREFIXO, E2_NUM, E2_EMISSAO "+ENTER
_cQuery += " ORDER BY 6,3,1 "+ENTER

IF _lOnlyQry
    Return(_cQuery)
ENDIF

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

IF _nMax > 0
    //Formata Cabecalho da pagina
    zLoadPage(@_xHtm,'_DIR',,1)
    While _DIR->(!Eof())
		_nItens ++
        _nSaldo += _DIR->SALDO
        //_xHtm := ''
        //zLoadHTML(@_xHtm,'_DIR',,_nItens)

        //Formata ITENS da pagina
        zLoadPage(@_xHtm,'_DIR',,2)

        IF (_nPos := aScan(_aBoxResumo,{|a| a[1]==_DIR->VENCIMENTO})) == 0
            aADD(_aBoxResumo,{_DIR->VENCIMENTO, 0, 0})
            _nPos := Len(_aBoxResumo)
        ENDIF

        IF AllTrim(_DIR->TIPO) $ _cMV_IMP
            _aBoxResumo[_nPos,3] += _DIR->SALDO
        ELSE        
            _aBoxResumo[_nPos,2] += _DIR->SALDO
        ENDIF
    
		//_cReturn += _xHtm
        _DIR->(DbSkip())
    EndDo
EndIF

IF Len(_aBoxResumo) > 0 
    _aBoxResumo := aSort(_aBoxResumo,,, { |x, y| x[1] < y[1] })

    _cBoxResumo  += ' 			<td bgcolor="#f2f4f7" width="20%">   '
    _cBoxResumo  += ' 			    <table bgcolor="#f2f4f7" border="1" width="100%">  '
    _cBoxResumo  += ' 			        <tr> '
    _cBoxResumo  += ' 			            <th colspan="3"><font color="#000" face="Arial" size="2">Quadro Resumo</font> </th> '
    _cBoxResumo  += ' 			        </tr> '
    _cBoxResumo  += ' 			        <tr> '
    _cBoxResumo  += ' 			            <td><font color="#000" face="Verdana" size="1"><center><b>Vencimento</b></center></font> </td> '
    _cBoxResumo  += ' 			            <td><font color="#000" face="Verdana" size="1"><center><b>A Pagar</b></center></font> </td> '
    _cBoxResumo  += ' 			            <td><font color="#000" face="Verdana" size="1"><center><b>Impostos</b></center></font> </td> '
    _cBoxResumo  += ' 			        </tr> '
    For _nR:=1 To Len(_aBoxResumo)
        
        IF _nSum >= 5
            Exit
        ENDIF

        IF _aBoxResumo[_nR,2] > 0 .Or. _aBoxResumo[_nR,3] > 0
            _cBoxResumo  += ' 			        <tr> '
            _cBoxResumo  += ' 			            <td><font color="#000" face="Verdana" size="1">'+DtoC(StoD(_aBoxResumo[_nR][1]))+'</font> </td> '
            _cBoxResumo  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$'+TransForm(_aBoxResumo[_nR][2],"@E 9,999,999.99")+'</p></font> </td> '
            _cBoxResumo  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$'+TransForm(_aBoxResumo[_nR][3],"@E 9,999,999.99")+'</p></font> </td> '
            _cBoxResumo  += ' 			        </tr> '
            _nSum++
        ENDIF
    Next _nR
    _cBoxResumo  += ' 			    </table>'
    _cBoxResumo  += ' 			</td> '
ENDIF

//Formata RODAPE da pagina
zLoadPage(@_xHtm,'_DIR',,3)
_cReturn += _xHtm

//Ajusta quadro de Resumo
_cGetHtm2  := STRTRAN(_cGetHtm2,'##_cTipoDOC##',_cBoxResumo)

//Desconecta
//TCUnlink(_nHandle)

Return(_cReturn)


*---------------------*
User Function AWKFCRJS
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

_cJavScpt += '	.zCorbutton { '
_cJavScpt += '	      background-color: #ddd; '
_cJavScpt += '	      border: none; '
_cJavScpt += '	      color: black; '
_cJavScpt += '	      padding: 6px 20px; '
_cJavScpt += '	      text-align: center; '
_cJavScpt += '	      text-decoration: none; '
_cJavScpt += '	      display: inline-block; '
_cJavScpt += '	      margin: 4px 2px; '
_cJavScpt += '	      cursor: pointer; '
_cJavScpt += '	      border-radius: 16px; '
_cJavScpt += '	      } '

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

_cJavScpt += '	function  zLoadIXB() {'
_cJavScpt += '		var zLoadIXB = document.getElementById("loading"),'
_cJavScpt += '			overflow = document.getElementById("overflow");'
_cJavScpt += '		zLoadIXB.className = "show";'
_cJavScpt += '		overflow.className = "overflow";'
_cJavScpt += '			var form = document.getElementById("PWFIXB");		'
_cJavScpt += '			form.submit();'
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
_cJavScpt+= ' 							<font face="Verdana" size="4"><b>Contas a Pagar</b></font> 
_cJavScpt+= '						</p>'  
_cJavScpt+= '					</font>'
_cJavScpt+= '          	</td>'
_cJavScpt+= '    	</tr>'
_cJavScpt+= '    	<tr bgcolor="#f2f4f7" align="left"> '
_cJavScpt+= '    		<td bgcolor="#f2f4f7" width="100%"> '
_cJavScpt+= '    			<font face="Verdana" size="1"><b>Olá ##RetCodUsr##, você tem ##_nItens## titulo(s) à pagar no valor de R$ ##_nSaldo## pendentes de aprovação!</b></font></p></font><br> '
_cJavScpt+= '    		</td>  '
_cJavScpt+= '    	</tr>  '
_cJavScpt+= '	</tbody>'
_cJavScpt+= ' </table>'

_cJavScpt += '<form action="./AWKFRET.APW" method="post" name="PWFCOM" id="PWFCOM"> '
_cJavScpt += '<form action="./AWKFIXB.APW" method="post" name="PWFIXB" id="PWFIXB"> '

Return _cJavScpt



*----------------------------------------------------*
User Function AWKFCRIXB(_lConsulta,_dDataDe,_dDataAte,_cTipoDOC)
*----------------------------------------------------*
Local _cParams := ""

Default _lConsulta := .F.
Default _dDataDe   := dDataBase
Default _dDataAte  := dDataBase
Default _cTipoDOC  := ''

_cParams  += ' <table bgcolor="#f2f4f7" border="0" width="100%"> '
_cParams  += ' 	<tbody> '
_cParams  += ' 		<tr bgcolor="#f2f4f7" align="center">     '



//_____________________________________________________ QUADRO RESUMO _____________________________________________________
_cParams  += '<!--QUADRO RESUMO-->  
_cParams  += ' ##_cTipoDOC## '
//_cParams  += ' 			<td bgcolor="#f2f4f7" width="20%">   '
//_cParams  += ' 			    <table bgcolor="#f2f4f7" border="1" width="100%">  '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <th colspan="3"><font color="#000" face="Arial" size="2">Quadro Resumo</font> </th> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><center><b>Vencimento</b></center></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><center><b>A Pagar</b></center></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><center><b>Impostos</b></center></font> </td> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1">01/01/22</font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 99,00</p></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 999.999,00</p></font> </td> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1">01/01/22</font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 99,00</p></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 999.999,00</p></font> </td> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1">01/01/22</font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 99,00</p></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 999.999,00</p></font> </td> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1">01/01/22</font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 99,00</p></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 999.999,00</p></font> </td> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			        <tr> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1">01/01/22</font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 99,00</p></font> </td> '
//_cParams  += ' 			            <td><font color="#000" face="Verdana" size="1"><p align="right">R$ 999.999,00</p></font> </td> '
//_cParams  += ' 			        </tr> '
//_cParams  += ' 			    </table>'
//_cParams  += ' 			</td> '

//_____________________________________________________ BOTOES _____________________________________________________
_cParams  += '<!--BOTOES-->                
_cParams  += ' 			<td bgcolor="#f2f4f7" width="60%">         '
//_cParams  += ' 				<form action="./AWKFIXB.APW" method="post" name="PWFIXB" id="PWFIXB"> '
_cParams  += ' 					<font color="#000" face="Verdana" size="1">Consulta Vencimento</font>  '
_cParams  += ' 					<input type="date" id="VenctoDE" name="VenctoDE" value="'+TransForm(DtoS(_dDataDe),'@R 9999-99-99')+'"> '
_cParams  += ' 					<font color="#000" face="Verdana" size="1">até</font>  '
_cParams  += ' 					<input type="date" id="VenctoAte" name="VenctoAte" value="'+TransForm(DtoS(_dDataAte),'@R 9999-99-99')+'"> '
_cParams  += ' 					<input type="hidden"id="__zUserID" name="__zUserID" value="'+cCodAux+'">'
_cParams  += ' 					<font face="Verdana">             '
_cParams  += ' 						<input name="Button1" value="Consultar" type="submit" class="zCorbutton" id="Button1" onclick="zLoadIXB();">         '
_cParams  += ' 					</font>	 '
_cParams  += ' 		            <br>  '
_cParams  += ' 					<font color="#000" face="Verdana" size="1">Consulta Operação: </font> '
_cParams  += ' 					<select name="tipoCP" id="tipoCP"> '
_cParams  += ' 					    <option value="All">Todos</option> '
_cParams  += ' 					    <option value="DOC">Contas à Pagar</option> '
_cParams  += ' 					    <option value="IMP">Impostos</option> '
_cParams  += ' 					</select> '
//_cParams  += ' 				</form>					 '
_cParams  += ' 			</td> '

//_____________________________________________________ QUADRO EM BRANCO _____________________________________________________
_cParams  += '<!--QUADRO RESUMO-->                
_cParams  += ' 			<td bgcolor="#f2f4f7" width="20%">   '
_cParams  += ' 			    <table bgcolor="#f2f4f7" border="0" width="100%">  '
'
_cParams  += ' 			    </table>'
_cParams  += ' 			</td> '

//_____________________________________________________ FINALIZA PAGINA _____________________________________________________
_cParams  += ' 		</tr> '
_cParams  += ' 	</tbody> '
_cParams  += ' </table> '
_cParams  += ' <br> '

Return _cParams

*-----------------------*
User Function AWKFCRBT()
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
User Function AWKFCRRT
*---------------------*
Local aRetornos := {}
Local _nDebug   := 1
Local _cFoi     := ''
Local nI        := 0

For nI := 1 TO Len(HTTPPOST->APOST)

	IF '#'+'APROVACAO_' $ HTTPPOST->APOST[nI] 
		//_cVar := HTTPPOST->APOST[nI]
		//_cVarApv := &("HTTPPOST->"+_cVar)
		//_cRecno := Substring(_cVar,AT('_',_cVar)+1,LEN(_cVar))
		
		//_nPosObs := ASCAN(HTTPPOST->APOST, { |x| UPPER(x) == "OBSERV_"+_cRecno })
		
	Else
		//IF 'OBSERV_' $ HTTPPOST->APOST[nI]  
        IF 'APROVACAO_' $ HTTPPOST->APOST[nI]  
			_cVar 		:= HTTPPOST->APOST[nI]
			_cVarObs 	:=  &("HTTPPOST->"+_cVar)
			_cRecno 	:= Substring(_cVar,AT('_',_cVar)+1,LEN(_cVar))
            __zUserID   := HTTPPOST->__ZUSERID
			
			_cOVar 		:= _cVar
			
			_nPosApv := ASCAN(HTTPPOST->APOST, { |x| UPPER(x) == "APROVACAO_"+_cRecno })
			IF _nPosApv > 0
				_cVar := HTTPPOST->APOST[_nPosApv]
				_cVarApv := &("HTTPPOST->"+_cVar)
			Else
				_cVarApv := ''
			Endif
		 
			IF !("X" $ _cVarApv) .AND. !(_cOVar $ _cFoi)
				aAdd(aRetornos,{_cVarApv, _cVarObs, __zUserID})
				_cFoi += _cOVar+";"
			Endif
		 
			_cVarApv := ''
			_cVarObs := ''
		ENdif
	Endif
	
Next

IF _nDebug == 0
	StartJob("u_AWKFCRAPV",'PORTAL',.F.,aRetornos)
Else
	u_AWKFCRAPV(aRetornos) 
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
User Function AWKFCRAPV(aRetornos)
*--------------------------------*
Local aSm0        := u_zCJGetFil()
Local _nEmp       := 1
Local _aSE2       := {}
Local nC          := 0
Local _nR         := 0
Local _cChavSE2   := ''
Local _cIDFin     := '000911'
Local _cQrySE2    := ''
Local _cLogPortal := ''

LOCAL _N_CHAVE   := 01
LOCAL _N_OBS     := 02
LOCAL _N_USERRET := 03
LOCAL _N_APROV   := 04
LOCAL _N_RECNO   := 05
LOCAL _N_USERID  := 06
LOCAL _N_FILIAL  := 07

U_fVerifJob(aSm0[_nEmp,1],aSm0[_nEmp,2],,,3) 

For nC := 1 To Len(aRetornos)	
	_xRetorno := STRTRAN(aRetornos[nC][1] ,"APV_" ,"")
	_nRecno   := VAL(STRTRAN(_xRetorno ,"S" ,""))
	_cObs     := Alltrim(aRetornos[nC][2])
    __zUserID := Alltrim(aRetornos[nC][3])
    _cAprov   := IIF("S" $ aRetornos[nC][1],'S','N')

    DBSelectArea('SE2');SE2->(DBSETORDER(1));SE2->(DBGOTO(_nRecno))
	_cChavSE2 := SE2->E2_FILIAL + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
	aAdd(_aSE2,{_cChavSE2, ALLTRIM(_cObs), _cIDFin, _cAprov, _nRecno, __zUserID,SE2->E2_FILIAL})

/*
	IF "S" $ aRetornos[nC][1]
		_xRetorno := STRTRAN(aRetornos[nC][1] ,"APV_" ,"")
		_nRecno   := VAL(STRTRAN(_xRetorno ,"S" ,""))
		_cObs     := Alltrim(aRetornos[nC][2])
        __zUserID := Alltrim(aRetornos[nC][3])
	
        DBSelectArea('SE2');SE2->(DBSETORDER(1));SE2->(DBGOTO(_nRecno,))
		_cChavSE2 := FwxFilial("SE2") + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA

		aAdd(_aSE2,{_cChavSE2,ALLTRIM(_cObs),_cIDFin,'S',_nRecno,__zUserID})
	ELSE
		_xRetorno := STRTRAN(aRetornos[nC][1] ,"APV_" ,"")
		_nRecno   := VAL(STRTRAN(_xRetorno ,"N" ,""))
		_cObs     := Alltrim(aRetornos[nC][2])
        __zUserID := Alltrim(aRetornos[nC][3])

        DBSelectArea('SE2');SE2->(DBSETORDER(1));SE2->(DBGOTO(_nRecno))
		_cChavSE2 := FwxFilial("SE2") + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
		
		aAdd(_aSE2,{_cChavSE2,ALLTRIM(_cObs),_cIDFin,'N',_nRecno,__zUserID})	
	ENDIF	
*/
Next nC

For _nR:=1 To Len(_aSE2)
    DBSelectArea('SE2');SE2->(DBSETORDER(1));SE2->(DBGOTO(_aSE2[_nR][_N_RECNO]))
    IF SE2->(Recno()) <> _aSE2[_nR][_N_RECNO]
        Loop
    ENDIF

	_cLogPortal := '****** Portal de Aprovação: '+DtoC(dDATABASE)+' - '+Time()+ENTER
	_cLogPortal += '> Aprovador: '+_aSE2[_nR][_N_USERID] + ' - '+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))   +ENTER
	_cLogPortal += 'Status: '+IIF(_aSE2[_nR][_N_APROV]=='S','APROVADO','REJEITADO')+ENTER
    _cLogPortal += 'Obs.: '+_aSE2[_nR][_N_OBS]+ENTER

    //01-Liberado | 02-Bloqueado | 99-Rejeitado
    _cStatus  := IIF(_aSE2[_nR][_N_APROV] == 'S','01','99')
    _cIDAprov := _aSE2[_nR][_N_USERID]

    _cFilial := _aSE2[_nR][_N_FILIAL]

    //Query para atualizar todas as parcelas
    _cQrySE2 := " SELECT E2_DATALIB, E2_STATLIB,  "+ENTER
    _cQrySE2 += " 		 E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_HIST, E2_ORIGEM, E2_NATUREZ, E2_MOEDA, R_E_C_N_O_ RECSE2 "+ENTER
    _cQrySE2 += "   FROM "+RetSqlName('SE2')+" SE2  "+ENTER
    _cQrySE2 += "     WHERE SE2.D_E_L_E_T_ = '' "+ENTER
    _cQrySE2 += "       AND E2_FILIAL  = '"+_cFilial+"'  	"+ENTER
    _cQrySE2 += "       AND E2_SALDO   > 0	"+ENTER    
    _cQrySE2 += "       AND E2_PREFIXO = '"+SE2->E2_PREFIXO+"' 	"+ENTER
    _cQrySE2 += "       AND E2_NUM     = '"+SE2->E2_NUM+"' 		"+ENTER
    _cQrySE2 += "       AND E2_FORNECE = '"+SE2->E2_FORNECE+"' 	"+ENTER
    _cQrySE2 += "       AND E2_LOJA    = '"+SE2->E2_LOJA+"'     "+ENTER

    //Ajustado para fazer por parcela e nao não Titulo
    _cQrySE2 += "       AND SE2.R_E_C_N_O_    = "+AllTrim(cValToChar(_aSE2[_nR][_N_RECNO]))+"     "+ENTER
    _cQrySE2 += " ORDER BY 5 "+ENTER

    IF Select('_DIR') > 0
        _DIR->(DbCloseArea())
    EndIF
    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySE2),'_DIR',.F.,.T.)
    DbSelectArea('_DIR');_DIR->(DbGoTop())
    _nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

    While _DIR->(!Eof())
        DbSelectArea('SE2'); SE2->(DbGoTo(_DIR->RECSE2))
        IF SE2->(Recno()) <> _DIR->RECSE2
            Return
        ENDIF

		_cLogPortal += ENTER + AllTrim(SE2->E2_XWS_LOG)

		IF  SE2->(RECLOCK('SE2',.F.))		
				Replace SE2->E2_XWS_APR With _cIDAprov
				Replace SE2->E2_XWS_DLI With dDataBase				
				Replace SE2->E2_DATALIB With SE2->E2_EMISSAO
				Replace SE2->E2_STATLIB With _cStatus
				Replace SE2->E2_XWS_LOG With _cLogPortal				
			SE2->(MSUNLOCK())
		Endif	

        _DIR->(DbSkip())
    EndDo
Next _nR

U_AWKFCRLIB(_aSE2)

U_fVerifJob(,,.T.,"FECHAR")

Return


*----------------------------*
User Function AWKFCRLIB(_aSE2)
*----------------------------*
Local _nP 		:= 0
Local _nR 		:= 0
Local _cHeader 	:= ''
Local _cEnable  := 'target="_blank" class=""'
Local _cDesable := 'target="_blank" class="disabled"'
Local _xEmails  := {}
Local _cNumTit  := ''
Local _zHtm     := ''
Local ___Obs    := ''

Local _cIDFin   := '000911'
Local _cIDFin2  := '000100'
Local _cRecWF   := {}
Local _nItens   := 0

LOCAL _N_CHAVE  := 01
LOCAL _N_OBS    := 02
LOCAL _N_USERID := 03
LOCAL _N_APROV  := 04
LOCAL _N_RECNO  := 05
LOCAL _N_USERID  := 06
zLoadHTML(@_zHtm,,'CABEC')

For _nR := 1 To Len(_aSE2)
	_xEmails := {}
    _xTemp   := ''
	
    DBSelectArea('SE2');SE2->(DBSETORDER(1));SE2->(DBGOTO(_aSE2[_nR][_N_RECNO]))
    IF SE2->(Recno()) <> _aSE2[_nR][_N_RECNO]
        Loop
    ENDIF

    //Qeury para retorno dos dados consolidados
    _cQryWF := u_AWKFCPAG(@_nItens,.T.,SE2->(Recno()))

    IF Select('_DIR') > 0
        _DIR->(DbCloseArea())
    EndIF
    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryWF),'_DIR',.F.,.T.)
    DbSelectArea('_DIR');_DIR->(DbGoTop())
    _nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

    IF _nMax > 0
        While _DIR->(!Eof())
            zLoadHTML(@_xTemp,'_DIR','CORPO')

            _xTemp := STRTRAN(_xTemp,'type="radio"','type="hidden"')    
            _xTemp := STRTRAN(_xTemp,'<!--inicio-->','<!--inicio')    
            _xTemp := STRTRAN(_xTemp,'<!--fim-->','-->')    

            ___Obs := ''
            //___Obs := IIF(_aSE2[_nR][_N_APROV] == 'N'," Rejeitado por "+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))+ ', pelo motivo: '," Aprovado por "+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))+ ': ')
            ___Obs := IIF(_aSE2[_nR][_N_APROV] == 'N'," Rejeitado por "+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))," Aprovado por "+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))+ ': ')
            ___Obs := ___Obs //+ _aSE2[_nR][_N_OBS]	

            //Escreve na Observação do Pedido
            //_xTemp  := STRTRAN(_xTemp,'</textarea></font>',___Obs+'</textarea>'+'</font>')	
            //Desabilita botões de Anexo
            _xTemp  := STRTRAN(_xTemp,_cEnable,_cDesable)	

            //Escreve na Observação do Pedido
            _xTemp  := STRTRAN(_xTemp,'##OBS##',___Obs+'</font>')	
            _DIR->(DbSkip())
        EndDo
    EndIF

    //Adiciona no HTML para o WF
    _zHtm += _xTemp
Next _nR

zLoadHTML(@_zHtm,,'RODAPE')

//    //_xHtm := ''
//	_xHtm := STRTRAN(Memoread(ALLTRIM(SE2->E2_XWS_HTM)),'type="radio"','type="hidden"')
//		
//	_xHtm := STRTRAN(_xHtm,'<!--inicio-->','<!--inicio')
//	_xHtm := STRTRAN(_xHtm,'<!--fim-->','-->')
//					
//	___Obs := ''
//	___Obs := IIF(_aSE2[_nR][_N_APROV] == 'N'," Rejeitado por "+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))+ ', pelo motivo: '," Aprovado por "+ Capital(UsrFullName(_aSE2[_nR][_N_USERID]))+ ': ')
//	___Obs := ___Obs + _aSE2[_nR][_N_OBS]	
//
//	//Escreve na Observação do Pedido
//	_xHtm  := STRTRAN(_xHtm,'</textarea></font>',___Obs+'</textarea>'+'</font>')	
//
//	//Desabilita botões de Anexo
//	_xHtm  := STRTRAN(_xHtm,_cEnable,_cDesable)	
//Next _nR

MemoWrite('C:\temp\TESTE_HTM.html',_zHtm)

aAdd(_xEmails, _cIDFin)
aAdd(_xEmails, _cIDFin2)

For _nP := 1 To Len(_xEmails)
	ConOut('enviando email liberacao/rejeicao ->'+UsrRetMail(_xEmails[_nP]))
	_cHeader += 'CR Salonline | Liberação Contas a Pagar'
	u_zSN_AspMail(_xEmails[_nP],UsrRetMail(_xEmails[_nP]),'','',_zHtm,_cHeader,,_cNumTit)
Next _nP	

Return

*------------------------------------*
Static Function zLoadHTML(_xHtm,_cAls,_cProcWF,_nItens)
*------------------------------------*
Local _nRecMin   := 0
Local _cHistor   := ''
Local _lVencido  := .F.

Default _cAls    := ''
Default _cProcWF := ''
Default _nItens  := 0

IF !Empty(_cAls)
    _nRecMin   := AllTrim(STR((_cAls)->RECSE2))
    DbSelectArea('SE2'); SE2->(DbGoTop());SE2->(DbGoTo((_cAls)->RECSE2))
    _cHistor  := AllTrim(SE2->E2_HIST)
    _lVencido := StoD((_cAls)->VENCIMENTO) < Date()
ENDIF

IF Empty(_cProcWF) .Or. _cProcWF == 'CABEC'
    _xHtm += '<!---------------------------------------------------- INICIO DO BLOCO POR TITULO ---------------------------------------------------> '
    _xHtm += '<head> '
    _xHtm += '  <meta http-equiv="Content-Language" content="en-us"> '
    _xHtm += '  <meta http-equiv="Content-Type" '
    _xHtm += ' content="text/html; charset=windows-1252"> '
    _xHtm += '  <meta name="GENERATOR" content="Microsoft FrontPage 6.0"> '
    _xHtm += '  <meta name="ProgId" content="FrontPage.Editor.Document"> '
    _xHtm += '  <title>Contas a Pagar</title> '
    _xHtm += '  <style> '
    _xHtm += 'TR.1 { font-size: 8pt;} '
    _xHtm += 'TD { font-size: 8pt; } '
    _xHtm += 'textarea { width: 100%; border: 1px solid #333; padding: 4px; } '
    _xHtm += 'a.disabled { pointer-events: none; cursor: default;} '
    _xHtm += '  </style> '
    _xHtm += '</head> '
    _xHtm += '<body bgproperties="fixed" style="background-color: rgb(255, 255, 255);"> '
    _xHtm += '<input name="FILIAL"      TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="EMAIL"       TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="APROVADOR"   TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="CODAPROV"    TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="NOME"        TEMPLATE_name="T1"      value="CP"      type="hidden"> '
    _xHtm += '<input name="RECNO"       TEMPLATE_name="RECID"   value="353246"  type="hidden"> '
    _xHtm += '<input name="TIPOWF"      TEMPLATE_name="T1"      value="CP"      type="hidden"> '
    _xHtm += ' '
    _xHtm += ' '
    _xHtm += '  <table bordercolorlight="#DFEFFF" bordercolordark="#DFEFFF" bgcolor="#f2f4f7" border="0" bordercolor="#dfefff" cellspacing="1" width="100%"> '
    _xHtm += '      <tbody> '
    _xHtm += '          <tr align="center" bgcolor="#333366" height="17"> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="20%"><font color="#ffffff" face="Verdana" size="1"><b>Fornecedor</b></font></td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="15%"><font color="#ffffff" face="Verdana" size="1"><b>Natureza</b></font></td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="10%"><font color="#ffffff" face="Verdana" size="1"><b>Numero</b></font></td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="5%" ><font color="#ffffff" face="Verdana" size="1"><b>Valor Total</b></font></td> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="5%" ><font color="#ffffff" face="Verdana" size="1"><b>Emissão</b></font> </td> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="5%" ><font color="#ffffff" face="Verdana" size="1"><b>Vencimento</b></font> </td> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="25%"><font color="#ffffff" face="Verdana" size="1"><b>Observação</b></font> </td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="15%"><font color="#ffffff" face="Verdana" size="1"><b>Aprovação</b></font> </td> '
    IF _cProcWF <> 'CABEC'
    //    _xHtm += '              <td style="background-color: rgb(40, 170, 243);" width="15%"><font color="#ffffff" face="Verdana" size="1"><b>Observação</b></font> </td> '
    ENDIF
    _xHtm += '          </tr> '
    _xHtm += '      </tbody> '
    _xHtm += '      <tbody> '
ENDIF 

IF Empty(_cProcWF) .Or. _cProcWF == 'CORPO'
    _xHtm += '          <tr height="17" > '
    _xHtm += '              <td width="20%"><font color="#000"                              Align="left"  face="Verdana" size="1">'                  +PadR((_cAls)->FORNECEDOR,50)+'</font></td> '
    _xHtm += '              <td width="15%"><font color="#000"                              Align="left"  face="Verdana" size="1">'                  +PadR((_cAls)->NATUREZA,40)+'</font></td> '
    _xHtm += '              <td width="10%"><font color="#000"                              Align="right" face="Verdana" size="1">'                  +(_cAls)->NUMERO+'</font></td> '
    _xHtm += '              <td width="5%" ><font color="'+IIF(!_lVencido,'#000','RED')+'"  Align="right" face="Verdana" size="1"><p align="right">' +TransForm((_cAls)->SALDO,'9,999,999.99')+'</p></font></td> '
    _xHtm += '              <td width="5%" ><font color="#000"                              Align="right" face="Verdana" size="1"><p align="center">'+DtoC(StoD((_cAls)->EMISSAO))+'</p></font></td> '
    _xHtm += '		        <td width="5%" ><font color="'+IIF(!_lVencido,'#000','RED')+'"  Align="right" face="Verdana" size="1"><p align="center">'+DtoC(StoD((_cAls)->VENCIMENTO))+'</p></font></td> '
    _xHtm += '		        <td width="25%"><font color="#000"                              Align="left"  face="Verdana" size="1">'                  +_cHistor+'</font></td> '
    _xHtm += ' '    
    
    IF _cProcWF <> 'CORPO'
        _xHtm += '	        <td style="background-color: rgb(83, 134, 139);" bgcolor="#53868B" height="21" width="15%"> '
        _xHtm += '			<!--inicio-->'
        _xHtm += '			    <p align="right"><font color="#ffffff" face="Verdana" size="1"> '
        _xHtm += '                  <font face="Verdana" size="1"><input                    name="APROVACAO_'+_nRecMin+'" TEMPLATE_name="APROV" value="APV_'+_nRecMin+'S" type="radio">Sim</font>&nbsp; '
        _xHtm += '                  <font face="Verdana" size="1"><input                    name="APROVACAO_'+_nRecMin+'" TEMPLATE_name="APROV" value="APV_'+_nRecMin+'N" type="radio">N&atilde;o </font>&nbsp; '
        _xHtm += '                  <font face="Verdana" size="1"><input checked="checked"  name="APROVACAO_'+_nRecMin+'" TEMPLATE_name="APROV" value="APV_'+_nRecMin+'X" type="radio">Mais Tarde</font></b></font> '
        _xHtm += '			        </font> '
        _xHtm += '	            </p>'
        _xHtm += '	        <!--fim-->'
        _xHtm += '          </td> '
        //_xHtm += '		    <td colspan="4">'
        //_xHtm += '		            <font face="Verdana" size="2"><textarea name="OBSERV_'+_nRecMin+'" TEMPLATE_name="OBSERV_'+_nRecMin+'" rows="1"></textarea></font>
        //_xHtm += '		    </td> '
        _xHtm += '	    </tr> '

        //_xHtm += '	    <tr> '
        //_xHtm += '		    <td width="9%" align="center"><font color="#000" face="Verdana" size="1"><b>Observação</b></font> </td> '
        //_xHtm += '		    <td colspan="8" width="35%"><font align="left"  face="Verdana" size="1">'+_cHistor+'</font></td> '
        //_xHtm += '      </tr> '

        //_xHtm += '	    <tr  style="height:5px;"  bgcolor="#ffffff"> '
        //_xHtm += '		    <td  colspan="9"  > </td> '
        //_xHtm += '	    </tr> '
    ELSE
        _xHtm += '		<td width="15%" ><font align="left" face="Verdana" size="1">##OBS##</font></td> '
    ENDIF
ENDIF

IF Empty(_cProcWF) .Or. _cProcWF == 'RODAPE'
    _xHtm += '    </tbody> '
    _xHtm += ' '
    _xHtm += '  </table> '
    _xHtm += '  &nbsp; '
    _xHtm += '</body> '
    _xHtm += '<!---------------------------------------------------- FIM DO BLOCO POR TITULO ---------------------------------------------------> '
    _xHtm += ''
ENDIF

RETURN


*------------------------------------*
Static Function zLoadPage(_xHtm,_cAls,_cProcWF,_nItens)
*------------------------------------*
Local _nRecMin   := 0
Local _cHistor   := ''
Local _cCorVcto  := 'bgcolor="#333366"'

Default _cAls    := ''
Default _cProcWF := ''
Default _nItens  := 0

IF !Empty(_cAls)
    _nRecMin   := AllTrim(STR((_cAls)->RECSE2))
    DbSelectArea('SE2'); SE2->(DbGoTop());SE2->(DbGoTo((_cAls)->RECSE2))
    _cHistor := AllTrim(SE2->E2_HIST)
ENDIF

//IF Empty(_cProcWF) .Or. _cProcWF == 'CABEC'
IF _nItens == 1
    _xHtm += '<!---------------------------------------------------- INICIO DO BLOCO POR TITULO ---------------------------------------------------> '
    _xHtm += '<head> '
    _xHtm += '  <meta http-equiv="Content-Language" content="en-us"> '
    _xHtm += '  <meta http-equiv="Content-Type" '
    _xHtm += ' content="text/html; charset=windows-1252"> '
    _xHtm += '  <meta name="GENERATOR" content="Microsoft FrontPage 6.0"> '
    _xHtm += '  <meta name="ProgId" content="FrontPage.Editor.Document"> '
    _xHtm += '  <title>Contas a Pagar</title> '
    _xHtm += '  <style> '
    _xHtm += 'TR.1 { font-size: 8pt;} '
    _xHtm += 'TD { font-size: 8pt; } '
    _xHtm += 'textarea { width: 100%; border: 1px solid #333; padding: 4px; } '
    _xHtm += 'a.disabled { pointer-events: none; cursor: default;} '
    _xHtm += '  </style> '
    _xHtm += '</head> '
    _xHtm += '<body bgproperties="fixed" style="background-color: rgb(255, 255, 255);"> '
    _xHtm += '<input name="FILIAL"      TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="EMAIL"       TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="APROVADOR"   TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="CODAPROV"    TEMPLATE_name="T1"      value=""        type="hidden"> '
    _xHtm += '<input name="NOME"        TEMPLATE_name="T1"      value="CP"      type="hidden"> '
    _xHtm += '<input name="RECNO"       TEMPLATE_name="RECID"   value="353246"  type="hidden"> '
    _xHtm += '<input name="TIPOWF"      TEMPLATE_name="T1"      value="CP"      type="hidden"> '
    _xHtm += ' '
    _xHtm += ' '
    _xHtm += '  <table bordercolorlight="#DFEFFF" bordercolordark="#DFEFFF" bgcolor="#f2f4f7" border="3" bordercolor="#D3D3D3" cellspacing="1" width="100%"> '
    _xHtm += '      <tbody> '
    _xHtm += '          <tr align="center" bgcolor="#333366" height="17"> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="20%"><font color="#ffffff" face="Verdana" size="1"><b>Fornecedor</b></font></td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="15%"><font color="#ffffff" face="Verdana" size="1"><b>Natureza</b></font></td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="10%"><font color="#ffffff" face="Verdana" size="1"><b>Numero</b></font></td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="5%" ><font color="#ffffff" face="Verdana" size="1"><b>Valor Total</b></font></td> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="5%" ><font color="#ffffff" face="Verdana" size="1"><b>Emissão</b></font> </td> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="5%" ><font color="#ffffff" face="Verdana" size="1"><b>Vencimento</b></font> </td> '
    _xHtm += '		        <td style="background-color: rgb(0,0,139);" width="25%"><font color="#ffffff" face="Verdana" size="1"><b>Observação</b></font> </td> '
    _xHtm += '              <td style="background-color: rgb(0,0,139);" width="15%"><font color="#ffffff" face="Verdana" size="1"><b>Aprovação</b></font> </td> '
    IF _cProcWF <> 'CABEC'
        //_xHtm += '              <td style="background-color: rgb(0,0,139);" width="15%"><font color="#ffffff" face="Verdana" size="1"><b>Comentario</b></font> </td> '
    ENDIF
    _xHtm += '          </tr> '
    _xHtm += '      </tbody> '
    _xHtm += '      <tbody> '
ENDIF 

_lVencido := StoD((_cAls)->VENCIMENTO) < Date()

//IF Empty(_cProcWF) .Or. _cProcWF == 'CORPO'
IF _nItens == 2
    _xHtm += '          <tr height="17" > '
    _xHtm += '              <td width="20%"><font color="#000"                              Align="left"  face="Verdana" size="1">'                  +PadR((_cAls)->FORNECEDOR,50)+'</font></td> '
    _xHtm += '              <td width="15%"><font color="#000"                              Align="left"  face="Verdana" size="1">'                  +PadR((_cAls)->NATUREZA,40)+'</font></td> '
    _xHtm += '              <td width="10%"><font color="#000"                              Align="right" face="Verdana" size="1">'                  +(_cAls)->NUMERO+'</font></td> '
    _xHtm += '              <td width="5%" ><font color="'+IIF(!_lVencido,'#000','RED')+'"  Align="right" face="Verdana" size="1"><p align="right">' +TransForm((_cAls)->SALDO,'9,999,999.99')+'</p></font></td> '
    _xHtm += '              <td width="5%" ><font color="#000"                              Align="right" face="Verdana" size="1"><p align="center">'+DtoC(StoD((_cAls)->EMISSAO))+'</p></font></td> '
    _xHtm += '		        <td width="5%" ><font color="'+IIF(!_lVencido,'#000','RED')+'"  Align="right" face="Verdana" size="1"><p align="center">'+DtoC(StoD((_cAls)->VENCIMENTO))+'</p></font></td> '
    _xHtm += '		        <td width="25%"><font color="#000"                              Align="left"  face="Verdana" size="1">'                  +_cHistor+'</font></td> '
    _xHtm += ' '    

    IF _cProcWF <> 'CORPO'
        _xHtm += '	        <td style="background-color: rgb(83, 134, 139);" bgcolor="#53868B" height="21" width="15%"> '
        _xHtm += '			<!--inicio-->'
        _xHtm += '			    <p align="right"><font color="#ffffff" face="Verdana" size="1"> '
        _xHtm += '                  <font face="Verdana" size="1"><input                    name="APROVACAO_'+_nRecMin+'" TEMPLATE_name="APROV" value="APV_'+_nRecMin+'S" type="radio">Sim</font>&nbsp; '
        _xHtm += '                  <font face="Verdana" size="1"><input                    name="APROVACAO_'+_nRecMin+'" TEMPLATE_name="APROV" value="APV_'+_nRecMin+'N" type="radio">N&atilde;o </font>&nbsp; '
        _xHtm += '                  <font face="Verdana" size="1"><input checked="checked"  name="APROVACAO_'+_nRecMin+'" TEMPLATE_name="APROV" value="APV_'+_nRecMin+'X" type="radio">Mais Tarde</font></b></font> '
        _xHtm += '			        </font> '
        _xHtm += '	            </p>'
        _xHtm += '	        <!--fim-->'
        _xHtm += '          </td> '
        //_xHtm += '		    <td colspan="4">'
        //_xHtm += '		            <font face="Verdana" size="2"><textarea name="OBSERV_'+_nRecMin+'" TEMPLATE_name="OBSERV_'+_nRecMin+'" rows="1"></textarea></font>
        //_xHtm += '		    </td> '
        _xHtm += '	    </tr> '

        //_xHtm += '	    <tr> '
        //_xHtm += '		    <td width="9%" align="center"><font color="#000" face="Verdana" size="1"><b>Observação</b></font> </td> '
        //_xHtm += '		    <td colspan="8" width="35%"><font align="left"  face="Verdana" size="1">'+_cHistor+'</font></td> '
        //_xHtm += '      </tr> '

        //_xHtm += '	    <tr  style="height:5px;"  bgcolor="#ffffff"> '
        //_xHtm += '		    <td  colspan="9"  > </td> '
        //_xHtm += '	    </tr> '
    ELSE
        _xHtm += '		<td width="15%" ><font align="left" face="Verdana" size="1">##OBS##</font></td> '
    ENDIF
ENDIF

//IF Empty(_cProcWF) .Or. _cProcWF == 'RODAPE'
IF _nItens == 3
    _xHtm += '    </tbody> '
    _xHtm += ' '
    _xHtm += '  </table> '
    _xHtm += '  &nbsp; '
    _xHtm += '</body> '
    _xHtm += '<!---------------------------------------------------- FIM DO BLOCO POR TITULO ---------------------------------------------------> '
    _xHtm += ''
ENDIF

RETURN
