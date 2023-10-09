#Include "Protheus.ch"
#Include "TopConn.ch"
#DEFINE  ENTER CHR(13)+CHR(10)

//���������������������������������������������������������������������������
//���Programa  � RelPA4      � Autor � Genesis/Gustavo  � Data � 27/11/14  ��
//������������������������������������������������������������������������ͱ�
//���Descricao � RELATORIO - Tela de Parametros (GENERICO)                 ��
//���������������������������������������������������������������������������
*-------------------*
USER FUNCTION RelPA4
*-------------------*
Local _aPBox := {}
Local _aRet  := {}

Private _cNomeArq  := ""
Private cPerg      := 'RELPA4'

u_xPutSx1(cPerg,"01","Codigo do Relatorio","Codigo do Relatorio","Codigo do Relatorio","mv_ch01","C",06,00,00,"G","","PA4","","","mv_par01","","","","","","","","","","","","","","","","")

IF !Pergunte(cPerg,.T.)
	Return
ENDIF

DBSELECTAREA('PA4');PA4->(DbGoTop());PA4->(DBSETORDER(1))
IF PA4->(DBSEEK(xFILIAL("PA4") + MV_PAR01))
    
    _cTipRel    := PA4->PA4_TIPREL
	
	//_cQryCad 	:=  ('"'+ChangeQuery(AllTrim(PA4->PA4_QUERY))+'"')	
	IF '[text()]' $ AllTrim(PA4->PA4_QUERY)
	 	_cQryCad 	:= AllTrim(PA4->PA4_QUERY)		
	Else
		_cQryCad 	:=  ('"'+ChangeQuery(AllTrim(PA4->PA4_QUERY))+'"')	
	ENDIF

	_lObrigPerg := 'MV_PAR' $ _cQryCad

	IF !EmptY(PA4->PA4_USER)
		IF !(__cUserID $ AllTrim(PA4->PA4_USER))
			MsgInfo('Usuario sem permiss�o de acesso ao relat�rio:'+ENTER+PA4->PA4_CODIGO+' - '+AllTrim(PA4->PA4_NOME),'Acesso restrito')
			Return		
		ENDIF		
	ENDIF
	  
	IF _lObrigPerg                                                              
		cPerg := PA4->PA4_CPERG
		IF Empty(cPerg)
			MsgAlert('Obrigat�rio configurar os Parametros para '+PA4->PA4_CODIGO+' - '+AllTrim(PA4->PA4_NOME),'Aviso')
			Return
		ENDIF
		
		IF !Pergunte(cPerg,.T.)
			Return
		ENDIF
	ENDIF	

		IF '[text()]' $ AllTrim(PA4->PA4_QUERY)
		//_cQuery 	:=  &('"'+AllTrim(PA4->PA4_QUERY)+'"')
		_cQuery 	:=  ChangeQuery(AllTrim(PA4->PA4_QUERY))
		_cQuery     :=  StrTran(_cQuery,'TEXT()'        ,'text()')
		_cQuery     :=  StrTran(_cQuery,"PATH(' ')"     ,"PATH('')")
		_cQuery     :=  StrTran(_cQuery,"TYPE) .VALUE("	,"TYPE).value(")

		//Especifico quando houver "SELECT COALESCE(" em subquery
		_cQuery     :=  StrTran(_cQuery,'FROM ECT'        ,'')		

		_cQuery 	:=  &('"'+_cQuery+'"')			
	Else
		_cQuery 	:=  &('"'+ChangeQuery(AllTrim(PA4->PA4_QUERY))+'"')	
	ENDIF	
		    
	IF _cTipRel == '3'
		aAdd(_aPBox,{9,"Tipo de Impressao do Relat�rio",150,7,.T.})
		aAdd(_aPBox,{3,"Relat�rio",1,{"Tela","Excel","T-Report"},50,"",.F.})
		
		If !ParamBox(_aPBox,"Bloqueio de Or�amento...",@_aRet)
			Return
		ENDIF 
	ELSE     
		_aRet    := {0,0}
		_aRet[2] := VAL(_cTipRel)
	ENDIF
		
	IF _aRet[2] == 2
		u_zQry2Excel(_cQuery, PA4->PA4_CODIGO+' - '+AllTrim(PA4->PA4_NOME))
	ElseIF _aRet[2] == 1
		u_zQry2Tela(_cQuery, PA4->PA4_CODIGO+' - '+AllTrim(PA4->PA4_NOME), PA4->PA4_TAMREL)
	ELSE
		u_zQry2TRep(_cQuery, PA4->PA4_CODIGO+' - '+AllTrim(PA4->PA4_NOME), PA4->PA4_TAMREL)				
	ENDIF
Else
	MsgAlert('Relat�rio n�o localizado','Aviso')
ENDIF

Return

//u_zIntoSql('D2_LOCAL', 'MV_PAR05')
*----------------------------------*
User Function zIntoSql(_cCpo, _cPar)
*----------------------------------*
Local _czREts := '1=1'

IF !Empty(&(_cPar))
	_czREts := _cCpo + " IN ('"+StrTran(Alltrim(&(_cPar)),",","','")+"') "
ENDIF

Return(_czREts)
