#INCLUDE "RWMAKE.CH"
#INCLUDE "Ap5mail.CH"
#include "Protheus.CH"  
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.CH"
#INCLUDE "Rwmake.CH"
#INCLUDE "Topconn.CH"
#include "TbiConn.CH"
#include "TbiCode.CH"
#INCLUDE "Ap5mail.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SY_FATR01 º Autor ³ 	Genesis/Gustavo	 º Data ³  26/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Separação                                       ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*--------------------------------------*
User Function MCFATR81(_cNumPV,_lValida)
*--------------------------------------*
Default _cNumPV := Space(TamSX3('C5_NUM')[1])                                         
Default _lValida   := .F.

Private _lSepOK  := .T.
Private cIniFile  := GetADV97() 
Private _cRaiz    := GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile ) 
Private _cMdagua  := _cRaiz+"Mdagua.BMP"

/*** IMAGENS ***/
Private _cLogo      := _cRaiz+"Logo"+xFilial('SC5')+".png" //FisxLogo("1") //"\system\_RLgr01.bmp"
_cMdagua  := _cRaiz+"R41lgrl01.bmp"

Private _cPergPA0 	:= 'MCFATR81'
Private _cFilC5     := xFilial('SC5')
Private _cPedC5     := ''

u_xPutSx1(_cPergPA0,"01","Pedido De: 		","Pedido De: 		","Pedido De:    	","mv_ch01","C",06,00,00,"G","" ,"SC5","","","mv_par01","","","","","","","","","","","","","","","","")

Pergunte(_cPergPA0,.F.)
SetMVValue(_cPergPA0,"MV_PAR01", _cNumPV)

IF !_lValida
	IF !Pergunte(_cPergPA0,.T.)
		Return
	EndIF
	_cPedC5 := MV_PAR01     
ELSE
	_cPedC5 := SC5->C5_NUM
EndIF

//Caso a impressão for em Excel
Private _lExcel   := .T.
Private _cNomeArq := ''
Private _nHdl     := 0
Private _cHtml    := ''
Private _nPag     := 1

lEnd := .F.
Processa({|lEnd| MXR902A(_lValida,@_lSepOK) },"Aguarde imprimindo...")

Return(_lSepOK)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SY_FATR01 º Autor ³ 	Genesis/Gustavo	 º Data ³  26/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Separação                                       ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*---------------------------------------*
Static Function MXR902A(_lValida,_lSepOK)
*---------------------------------------*
Local _nPV     := 0
Local _cQryZZ  := ''

//Excel - Monta Arquivo
xExcel('1',_nPV, @_cNomeArq)

DbSelectArea('SC5');SC5->(DbSetOrder(1))
IF !SC5->(DBSeek(xFilial("SC5")+_cPedC5))
	_cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
	_cPopUp += ' <br> '
	_cPopUp += ' <font color="#FF0000" face="Arial" size="2">Venda Direta - Salonline</font> '
	_cPopUp += ' <br><br>'
	_cPopUp += ' <font color="#000000" face="Arial" size="3">Relatório de conferencia</font> '
	_cPopUp += ' <br><br> '
	_cPopUp += ' <font color="#000000" face="Arial" size="2">Pedido invalido: '+_cPedC5+'</font> '			
	Alert(_cPopUp,'VD')
	RETURN
ENDIF      		

//_______________________________________________________[ QUANDRO CABEC ]_______________________________________________________
MontaCabec() //Excel
xExcelCols() //Excel

_cQryZZ += " SELECT ISNULL(LIB.ITEM,'') ITEM, BBB.* "+ENTER
_cQryZZ += " FROM ( "+ENTER
_cQryZZ += " SELECT AAA.PRODUTO, B1_DESC, B1_CODBAR, SUM(AAA.QTDLIB) QTDLIB, SUM(AAA.LEITURA) LEITURA, SUM(AAA.QTDLIB) - SUM(AAA.LEITURA) SALDO "+ENTER
_cQryZZ += " 	FROM ( "+ENTER
_cQryZZ += " 		SELECT C9_PRODUTO PRODUTO, C9_QTDLIB QTDLIB, 0 LEITURA "+ENTER
_cQryZZ += " 		  FROM "+RetSqlName('SC9')+" SC9 (NOLOCK)  "+ENTER
_cQryZZ += " 		   WHERE SC9.D_E_L_E_T_=''  "+ENTER
_cQryZZ += " 		    AND C9_FILIAL  = '"+_cFilC5+"'  "+ENTER
//caso ja tenha sido faturado
IF !Empty(SC5->C5_NOTA)
	_cQryZZ += " 			AND C9_BLCRED = '10'  "+ENTER
ELSE
	_cQryZZ += " 			AND C9_BLCRED <> '10'  "+ENTER
ENDIF
_cQryZZ += " 			AND C9_PEDIDO  = '"+_cPedC5+"' "+ENTER
_cQryZZ += " 		UNION ALL "+ENTER
_cQryZZ += " 		SELECT ZZZ_PRODUT PRODUTO, 0 QTDLIB,SUM(ZZZ_QUANT) LEITURA "+ENTER
_cQryZZ += " 		 FROM "+RetSqlName('ZZZ')+" ZZZ (NOLOCK)  "+ENTER
_cQryZZ += " 		   WHERE ZZZ.D_E_L_E_T_=''  "+ENTER
_cQryZZ += " 			 AND ZZZ_FILIAL = '"+_cFilC5+"'  "+ENTER
_cQryZZ += " 			 AND ZZZ_PEDIDO = '"+_cPedC5+"' "+ENTER
_cQryZZ += " 		GROUP BY ZZZ_PRODUT "+ENTER
_cQryZZ += " 	) AAA "+ENTER
_cQryZZ += "     INNER JOIN SB1020 SB1 ON SB1.D_E_L_E_T_='' AND B1_FILIAL='' AND B1_COD=AAA.PRODUTO "+ENTER
_cQryZZ += "     GROUP BY AAA.PRODUTO, B1_DESC, B1_CODBAR "+ENTER
_cQryZZ += " 	) BBB "+ENTER
_cQryZZ += "     OUTER APPLY ( "+ENTER
_cQryZZ += "                 SELECT SEP.C9_ITEM ITEM "+ENTER
_cQryZZ += "                 FROM "+RetSqlName('SC9')+" SEP (NOLOCK) "+ENTER
_cQryZZ += "                 WHERE SEP.D_E_L_E_T_ = ''  "+ENTER
_cQryZZ += "                     AND SEP.C9_FILIAL   =  '"+_cFilC5+"'  "+ENTER
//caso ja tenha sido faturado
IF !Empty(SC5->C5_NOTA)
	_cQryZZ += " 				AND SEP.C9_BLCRED = '10'  "+ENTER
ELSE
	_cQryZZ += " 				AND SEP.C9_BLCRED <> '10'  "+ENTER
ENDIF
_cQryZZ += "                     AND SEP.C9_PEDIDO   = '"+_cPedC5+"' "+ENTER
_cQryZZ += "                     AND SEP.C9_PRODUTO  = BBB.PRODUTO "+ENTER
_cQryZZ += "             ) LIB "+ENTER
_cQryZZ += " ORDER BY 1,2 "+ENTER

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryZZ),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
			
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())
DbSelectArea('_DIR');_DIR->(DbGoTop())

IF _nMax == 0
	_lSepOK := .F.
ENDIF

While _DIR->(!Eof())
    _cCorIt := '#000000'
    IF Empty(_DIR->ITEM)
        _cCorIt := '#000000'    
		_lSepOK := .F.
    ElseIF _DIR->SALDO == 0
        _cCorIt := '#04B404'
    ElseIF  _DIR->SALDO < 0
        _cCorIt := '#FE2E2E'
		_lSepOK := .F.
    ElseIF  _DIR->SALDO > 0
        _cCorIt := '#FFFF00'
		_lSepOK := .F.
    ENDIF

	_cHtml += '     <tr> '
	_cHtml += '         <td class="xl24" 	width="10%" align="Center"  colspan="1" Bgcolor="'+_cCorIt+'" ><font face = "Arial" size="1"><b>'+ _DIR->ITEM          +'</b></font></td>
	_cHtml += '         <td class="xl24" 	width="10%" align="Left"    colspan="1"                       ><font face = "Arial" size="1">'+ _DIR->PRODUTO	    +'</font></td>
	_cHtml += '         <td class="xl24" 	width="10%" align="Left"    colspan="3"                       ><font face = "Arial" size="1">'+ _DIR->B1_DESC	    +'</font></td>
	_cHtml += '         <td class="xl24" 	width="10%" align="Left"    colspan="1"                       ><font face = "Arial" size="1">'+ _DIR->B1_CODBAR	    +'</font></td>
	_cHtml += ' 		<td class="tabela" 	width="10%" align="Right"   colspan="1"                       ><font face = "Arial" size="1">'+ TransForm(_DIR->QTDLIB   ,'@e 9,999,999.999') 	+'</font></td>
	_cHtml += ' 		<td class="tabela" 	width="10%" align="Right"   colspan="1"                       ><font face = "Arial" size="1">'+ TransForm(_DIR->LEITURA	,'@e 9,999,999.999')+'</font></td>
	_cHtml += ' 		<td class="tabela" 	width="10%" align="Right"   colspan="1"                       ><font face = "Arial" size="1">'+ TransForm(_DIR->SALDO	,'@e 9,999,999.999') 	+'</font></td>
	_cHtml += '     </tr> '			
	_DIR->(DbSkip())
EndDo

//Retorna para consulta de lidacao usando a mesma Query do relatório
IF _lValida
	RETURN
ENDIF

_cHtml += ' </table> '

xExcel('F',_nPV, @_cNomeArq)

_cHtml += " <br><br> "
_cHtml += " </body> "
_cHtml += " </html> "
	
Return                                                                         

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SY_FATR01 º Autor ³ 	Genesis/Gustavo	 º Data ³  26/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Separação                                       ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*--------------------------*
Static Function xEmpFil(_cFil)
*--------------------------*
Local _aRet := {}
aADD(_aRet, AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_NOMECOM')))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_ENDENT'))))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_BAIRENT'))))
aADD(_aRet, Capital(AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_CIDENT'))))
aADD(_aRet, AllTrim(RetField('SM0',1,cEmpAnt+_cFil,'M0_ESTENT')))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_CEPENT'),'@r 99999-999'))
//aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'),'@r 99 9999-9999'))
aADD(_aRet, RetField('SM0',1,cEmpAnt+_cFil,'M0_TEL'))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_INSC'),'@r 999.999.999.999'))
aADD(_aRet, TransForm(RetField('SM0',1,cEmpAnt+_cFil,'M0_CGC'),"@r 99.999.999/9999-99"))

Return(_aRet)                                                                      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SY_FATR01 º Autor ³ 	Genesis/Gustavo	 º Data ³  26/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Separação                                       ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-------------------------------------------*
Static Function xExcel(_cOp, _nPV, _cNomeArq)
*-------------------------------------------*
Default _cOp := ''
Default _nPV := 1

IF _cOp == '1'
	Private _cNomeArq := 'C:\temp\SL_FAT01_'+DtoS(dDataBase)+StrTran(Time(),':','')+'.xls'
	Private _nOpcP    := 1
	
	_nHdl := fCreate(_cNomeArq)
	If _nHdl == -1
		MsgInfo("O arquivo de nome "+_cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

ELSEIF _cOp == 'F'
	fWrite(_nHdl,_cHtml,Len(_cHtml))
	fClose(_nHdl)

	If Aviso("Geração de Relatório","O arquivo "+_cNomeArq+" foi gerado com sucesso! Deseja abrir o arquivo gerado?",{"Abrir","Finalizar"}) == 1
		ShellExecute("open",_cNomeArq,"","",5)
	ENDIF 
ENDIF

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SY_FATR01 º Autor ³ 	Genesis/Gustavo	 º Data ³  26/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Separação                                       ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-------------------------*
Static Function MontaCabec
*-------------------------*
Private _aEmp    := xEmpFil(cFilAnt)   

_cHtml := ' <html><body> '
_cHtml += ' <title>@ Relatório de Separação</title> '
_cHtml += ' <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> '
_cHtml += " <style type='text/css'> "
_cHtml += ' 	td.tabela 	{ '
_cHtml += ' 					font-size: 10px; ' 
_cHtml += ' 					font-family: verdana,tahoma,arial,sans-serif; ' 
_cHtml += ' 					border-width: 1px;  '
_cHtml += ' 					padding: 0px;  '
_cHtml += ' 					border-style: dotted; ' 
_cHtml += ' 					border-color: gray;  '
_cHtml += ' 					-moz-border-radius: ;  '
_cHtml += ' 				} '
_cHtml += ' 	td.tabela2	{ '
_cHtml += ' 					font-size: 10px; ' 
_cHtml += ' 					font-family: verdana,tahoma,arial,sans-serif; ' 
_cHtml += ' 					border-width: 1px; 
_cHtml += ' 					padding: 0px; 
_cHtml += ' 					border-style: dotted; 
_cHtml += ' 					border-color: gray; 
_cHtml += ' 					-moz-border-radius: ;;
_cHtml += ' 					font-color: blue; 
_cHtml += ' 				}
_cHtml += ' 	td.xl24   	{	mso-style-parent:style0; 
_cHtml += ' 					font-size: 11px; 
_cHtml += ' 					mso-number-format:\@; '
_cHtml += ' 					border-width: 1px; 
_cHtml += ' 					padding: 0px; 
_cHtml += ' 					border-style: dotted; 
_cHtml += ' 					border-color: gray; 
_cHtml += ' 					-moz-border-radius: ; 
_cHtml += ' 				}
_cHtml += ' 	td.titulo 	{
_cHtml += ' 					font-size: 13px; 
_cHtml += ' 					font-family: verdana,tahoma,arial,sans-serif; 
_cHtml += ' 					font-weight: bold; 
_cHtml += ' 					padding: 0px; 
_cHtml += ' 				}
_cHtml += ' </style>
_cHtml += ' 
_cHtml += ' <table>
_cHtml += ' <tr>
_cHtml += ' 
_cHtml += ' <body>
_cHtml += ' 
_cHtml += ' <table Border="0" Width="1055">
_cHtml += '     <tr>
_cHtml += '     </tr>
_cHtml += '     <tr>
_cHtml += '         <td Colspan="3" Rowspan="4"> <img Src="https://cdn.desconto.com.br/img/merchants/132446/360-logo/v1/salonline-descontos.png" width="250"> </td>
//_cHtml += '         <td Colspan="4"> <font face = "Courier New" Size = "1"> </font></td>
_cHtml += '         <td Colspan="6" align="center"><font face = "Courier New" size="4" ><b>'+AllTrim(_aEmp[1])+'</b></font></th>
_cHtml += '         <td Colspan="1"><font face = "Courier New" size="1">Data: '+DtoC(dDataBase)+' </font></th>
_cHtml += '         <td Colspan="2"><font face = "Courier New" size="1">Página: '+TransForm(_nPag,'@e 999')+ ' </font></th>		
_cHtml += '     </tr>
_cHtml += '     <tr>
//_cHtml += '         <td Colspan="4"> <font face = "Courier New" Size = "1"> </font></td>
_cHtml += '         <td Colspan="6"><div align="center" class="style3"><font Face="Arial" Size="2">'+ AllTrim(_aEmp[2])+' - '+AllTrim(_aEmp[3])+' - ' + AllTrim(_aEmp[4])+' - '+AllTrim(_aEmp[5])+' - CEP.: '+AllTrim(_aEmp[6]) +'</font></td>
_cHtml += '         <td Colspan="3"> <font face = "Courier New" Size = "1"> Emissão: '+DtoC(dDataBase)+'</font></td>
_cHtml += '     </tr>
_cHtml += '     <tr>
//_cHtml += '         <td Colspan="4"> <font face = "Courier New" Size = "1"> </font></td>
_cHtml += '         <td Colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" >CNPJ: '+AllTrim(_aEmp[9]) +' - I.E.: '+AllTrim(_aEmp[8])+'</font></td>
_cHtml += '         <td colspan="3"> <font face = "Courier New" size = "2" color="#0040FF"><b>Relatório de Separação</b></font></td>
_cHtml += '    </tr>
_cHtml += '     <tr>
//_cHtml += '         <td Colspan="4"> <font face = "Courier New" Size = "1"> </font></td>
_cHtml += '         <td colspan="6"><div align="center" class="style3"><font face = "Arial" size = "2" >Fone: '+AllTrim(_aEmp[7])+' - www.salonline.com </font></td> '
IF Empty(SC5->C5_NOTA)
	_cHtml += ' 		<td colspan="3"><font face = "Courier New" size = "1"> </font></td>		
ELSE
	_cHtml += '         <td colspan="3"> <font face = "Courier New" size = "2" color="#F08080"><b>Nota Fiscal nº.: '+SC5->C5_NOTA+'-'+SC5->C5_SERIE+'</b></font></td>
ENDIF
_cHtml += ' 	</tr>
_cHtml += ' </table>
_cHtml += ' <br>

fWrite(_nHdl,_cHtml,Len(_cHtml))
_cHtml := ""

Return .T.      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ SY_FATR01 º Autor ³ 	Genesis/Gustavo	 º Data ³  26/07/23     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Separação                                       ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*------------------------*
Static Function xExcelCols
*------------------------*
_cHtml += ' <br> '	
_cHtml += ' <table border="0" width="1055" > '
_cHtml += '     <tr> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="1" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Item	</font></td> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="1" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Produto</font></td> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="3" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Descrição</font></td> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="1" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Código Barra</font></td> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="1" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Qtd Venda</font></td> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="1" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Separação</font></td> '
_cHtml += '         <td class="tabela" width="10%" align="Center" colspan="1" Bgcolor="#00008B"><font face = "Arial" size="2" Color="#FFFFFF" >Saldo</font></td> '
_cHtml += '     </tr> '
	
fWrite(_nHdl,_cHtml,Len(_cHtml))
_cHtml := ""

Return .T.
