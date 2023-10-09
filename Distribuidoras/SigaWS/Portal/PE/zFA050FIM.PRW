#include "TOTVS.ch"    
#include "protheus.ch"
#include "topconn.ch"

#DEFINE ENTER Chr(13)+Chr(10)  

/*/{Protheus.doc} MT120FIM
//Ponto de entrada na finalização do Contas a Receber
@author Genesis/Gustavo
@since 12/06/2023
/*/
*----------------------*
User Function zFA050FIM
*----------------------*
Local _aAreaSE2 := SE2->(FwGetArea())
Local _cChavSE2 := FwxFilial("SE2") + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA

IF SE2->E2_PREFIXO == 'GGG'
    //Gera relatorio em base 64 para abertura no portal
    //zSE22SZP()        
    oProcess := U_zMontaSE2(_cChavSE2)
Endif

FwRestArea(_aAreaSE2) 
Return

*---------------------------------*
User Function zMontaSE2(_cChavSE2)
*---------------------------------*
Local _aArea	:= FwGetArea()
Local _aAreaSE2	:= SE2->(FwGetArea())
Local _cDest    := GetNewPar("MZ_PATHWF","\web\PortalSny\WORKFLOW")+"\emp"+cEmpAnt+"\"
Local _cQrySE2  := ''
Local _nRecSE2  := SE2->(Recno())
Local _aRecSE2  := {}
Local _nT       := 0

Local _cLogPortal := ''
Local _cIDAprov   := AllTrim(GetMV('SL_WFSE2CP',.F.,'000911'))


DbSelectArea("SA2");SA2->(DbSetOrder(1));SA2->(DbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))

_cMoeda := GetMV('MV_SIMB'+cValToChar(SE2->E2_MOEDA))

_cQrySE2 += " SELECT E2_DATALIB, E2_STATLIB,  "+ENTER
_cQrySE2 += " 		 E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_VENCTO, E2_VENCREA, E2_VALOR, E2_HIST, E2_ORIGEM, E2_NATUREZ, E2_MOEDA, R_E_C_N_O_ RECSE2 "+ENTER
_cQrySE2 += "   FROM "+RetSqlName('SE2')+" SE2 (NOLOCK)  "+ENTER
_cQrySE2 += "     WHERE SE2.D_E_L_E_T_ = '' "+ENTER
_cQrySE2 += "      AND E2_FILIAL  = '"+xFilial('SE2')+"'  	"+ENTER
_cQrySE2 += "      AND E2_SALDO   > 0	"+ENTER   
_cQrySE2 += "      AND E2_PREFIXO = '"+SE2->E2_PREFIXO+"' 	"+ENTER
_cQrySE2 += "      AND E2_NUM     = '"+SE2->E2_NUM+"' 		"+ENTER
_cQrySE2 += "      AND E2_FORNECE = '"+SE2->E2_FORNECE+"' 	"+ENTER
_cQrySE2 += "      AND E2_LOJA    = '"+SE2->E2_LOJA+"' 		"+ENTER
_cQrySE2 += " ORDER BY 5 "+ENTER

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySE2),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

IF _nMax > 0
    DbSelectArea('SE2'); SE2->(DbGoTo(_DIR->RECSE2))
    IF SE2->(Recno()) <> _DIR->RECSE2
        Return
    ENDIF

	//A classe TWFProcess é responsável pela criação e gerenciamento do processo
	oProcess := TWFProcess():New( "400000", "Contas a Pagar" )

	oProcess:NewVersion(.T.)

	oProcess :NewTask("Contas a Pagar", GetNewPar("MZ_PATHWF","\WORKFLOW")+"\HTML\PWFCR.htm", .T.)
	
	_cTipo := 'CR'
	oHtml    := oProcess:oHTML

		
	oHtml:ValByName("TIPOWF"		, "CP")
	oHtml:ValByName("C7_TIPO"		, _cTipo)
	oHtml:ValByName("RECNO"			, cValToChar(SE2->(RECNO())) )
	oHtml:ValByName("Aprovacao"		, "APV_"+cValToChar(SE2->(RECNO())) )
	
	oHtml:ValByName("NOME"			, "CP")
	oHtml:ValByName("TIPODOC"		, "Contas a Pagar")
	oHtml:ValByName("C7_NUM"		, SE2->E2_NUM)
	oHtml:ValByName("FORNECE"		, SA2->A2_COD + "/" + SA2->A2_LOJA)
	oHtml:ValByName("A2_NREDUZ"		, SA2->A2_NREDUZ)
	oHtml:ValByName("EMISSAO"		, DTOC(SE2->E2_EMISSAO))
	oHtml:ValByName("Y6_DESCRI"		, 'vazio 1'     )
	oHtml:ValByName("Y6_DESCRI"		, 'vazio 2'     )
	oHtml:ValByName("MOEDA1"		, _cMoeda     )
	oHtml:ValByName("MOEDA2"		, _cMoeda     )
	oHtml:ValByName("MOEDA3"		, _cMoeda     )                	
	oHtml:ValByName("SOLICIT"		, Capital(UsrFullName(__cUserID))  )
	oHtml:ValByName("dtnece"		, DTOC(SE2->E2_EMISSAO) )
	
	oHtml:ValByName("COMPRA"		, 'vazio 3')
	
	_cTotalDesc := 0
	_cTotalPed  := 0

	While _DIR->(!Eof())
	
		aAdd(_aRecSE2, _DIR->RECSE2)

		DbSelectArea('SE2'); SE2->(DbGoTo(_DIR->RECSE2))
		IF SE2->(Recno()) <> _DIR->RECSE2
			Return
		ENDIF
        
        aAdd((oHtml:ValByName("it.item"			)), SE2->E2_PREFIXO)
        aAdd((oHtml:ValByName("it.produto"		)), SE2->E2_NUM)
        aAdd((oHtml:ValByName("it.descri"		)),SE2->E2_PARCELA)
        //aAdd((oHtml:ValByName("it.descri"		)), MSMM(SB1->B1_DESC_I))
        aAdd((oHtml:ValByName("it.um"			)), SE2->E2_TIPO)
        aAdd((oHtml:ValByName("it.quant"		)), DtoC(SE2->E2_VENCTO))
        aAdd((oHtml:ValByName("it.preco"		)), DtoC(SE2->E2_VENCREA))
        aAdd((oHtml:ValByName("it.total"		)), Transform(SE2->E2_VALOR,'@E 999,999,999.99'))
        aAdd((oHtml:ValByName("it.ccusto"		)), SE2->E2_NATUREZ      )
        aAdd((oHtml:ValByName("it.ipi"			)), SE2->E2_ORIGEM)
        aAdd((oHtml:ValByName("it.desc"			)), Transform(SE2->E2_DESCONT,'@E 999,999,999.99')    )
        aAdd((oHtml:ValByName("it.obs"		    )), Alltrim(SE2->E2_HIST))
        
		//aAdd((oHtml:ValByName("it.space"		)), " "      )
        _cTotalPed  += SE2->E2_VALOR
        _cTotalDesc += SE2->E2_DESCONT
        
        IF Len(_aRecSE2) <> _nMax
            aAdd((oHtml:ValByName("it.space"		)), " "      )
        Else
			_cNum := 'CP'+SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
            _cLinks := 	ADGetArq(_cNum)		
            aAdd((oHtml:ValByName("it.space"		)), _cLinks      )
        Endif

		_DIR->(DbSkip())
    EnddO
	
	oHtml:ValByName("TOTALGERAL"		, Transform(_cTotalPed,'@E 999,999,999.99')     )
	oHtml:ValByName("TOTALDESC"			, Transform(_cTotalDesc,'@E 999,999,999.99')     )
	_cObs := ""

	oProcess:cTo  := NIL
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL
	
	cMailId    := oProcess:Start(_cDest)

	_cLogPortal += '****** Solicitação de Liberação: '+DtoC(dDATABASE)+' - '+Time()+ENTER
	_cLogPortal += '> Solicitante: '+__cUSerID + ' - '+ Capital(UsrFullName(__cUserID))   +ENTER
	_cLogPortal += '> Aprovador: '+_cIDAprov + ' - '+ Capital(UsrFullName(_cIDAprov))   +ENTER
	_cLogPortal += 'Portal: '+cMailId+".HTM"   +ENTER

	For _nT:=1 To Len(_aRecSE2)
		DbSelectArea('SE2'); SE2->(DbGoTo(_aRecSE2[_nT]))
		IF SE2->(Recno()) <> _aRecSE2[_nT]
			Return
		ENDIF

		_cLogPortal +=  + AllTrim(SE2->E2_XWS_LOG)

		IF  SE2->(RECLOCK('SE2',.F.))		
				Replace SE2->E2_XWS_HTM With _cDest+cMailId+".HTM"		
				Replace SE2->E2_XWS_APR With _cIDAprov
				Replace SE2->E2_XWS_DLI With CriaVar('E2_XWS_DLI')
				
				Replace SE2->E2_DATALIB With StoD('')
				Replace SE2->E2_STATLIB With '01'
				Replace SE2->E2_XWS_LOG With _cLogPortal				
			SE2->(MSUNLOCK())
		Endif
	Next _nT	
ENDIF

DbSelectArea('SE2'); SE2->(DbGoTo(_nRecSE2))

FwRestArea(_aArea)
FwRestArea(_aAreaSE2)

Return oProcess


*----------------------------*
Static Function ADGetArq(_cNum)
*----------------------------*
Local _cLinks  := ''
Local _nCntTxt := 0
Local _cFilial := ''
Local _cTabela := 'SE2'

_cQuery := " SELECT * FROM "+RetSqlName('SZP')+" SZP WHERE SZP.D_E_L_E_T_='' AND ZP_TABELA = '"+_cTabela+"' AND ZP_CODIGO = '"+_cNum+"' "

IF Select('_TRB') > 0
	_TRB->(DbCloseArea())
ENDIF
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "_TRB", .F., .T.)    
DbSelectArea('_TRB');_TRB->(DBGoTop())
_nMax := Contar('_TRB',"!Eof()"); _TRB->(DbGoTop())

While _TRB->(!EOF())
    _cFilial := '02' //ZZZ->AC9_FILIAL
	_nCntTxt++
	_cLinks += '&nbsp;&nbsp;<a href="./AWKFANEXO.APW?X='+_TRB->ZP_CHAVE+'&F='+_cFilial+'&T='+_cTabela+'" target="_blank" class="">Anexo_'+cValToChar(_nCntTxt)+'</a>'

	_TRB->(DbSkip())
EndDo 

Return(_cLinks)

*----------------------*
Static Function zSE22SZP
*----------------------*
Local _cAnexo   := '' //u_SNYCOMR90(SC7->C7_NUM, .F., .F.)
Local _cPath    := GetSrvProfString("StartPath","")
Local _cDirServ := '\dirdoc\co'+cEmpAnt+'\'
Local _aSZP     := Array(6,'')

//Função para criar diretório com seus subdiretórios, com a vantagem de criar todo o caminho.
FWMakeDir(_cDirServ)

IF !Empty(_cAnexo)
	IF File(_cAnexo)
		CPYT2S(_cAnexo, _cDirServ ,.T.)
		_cFile := _cDirServ + StrTran(_cAnexo,Alltrim(GetMv("MV_DIREST")),'')    

        FErase(_cAnexo) 

        //Carrega daddos para SZP
        _aSZP[1] := SE2->E2_NUM
        _aSZP[2] := 'SE2'
        _aSZP[3] := 'PORTALSNY'
        _aSZP[4] := 'Contas a Pagar'
        _aSZP[5] := 'CP'+xFilial('SE2')+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
        _aSZP[6] := _cFile
        If ExistBlock("zSZPIAuto")
            ExecBlock("zSZPIAuto",.F.,.F.,_aSZP)
            FErase(_cFile)
        ENDIF
	ENDIF
ENDIF  

RETURN
