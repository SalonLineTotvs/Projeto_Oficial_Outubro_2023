#include "TOTVS.ch"    
#include "protheus.ch"
#include "topconn.ch"

#DEFINE ENTER Chr(13)+Chr(10)  


/*/{Protheus.doc} MT120FIM
//Ponto de entrada na finalização de confirmação do pedido
@author MATEUS.POLI
@since 12/06/2019
@version 1.0
@return ${return}, ${return_description}
@history Wellington Torres 22-08-2022 - Erro ao tentar estorna uma Purchase Order no SIGAEIC, o erro também acontece no SIGACOM, 
porém não impede de excluir/estornar o processo, adicionei ao primeiro IF, apenas INCLUSAO, ALTERACAO e cópia.
Wellington Torres 30-08-2022 - Inseri (Empty(nOpcao) .And. FWIsInCallStack("EICPO400")) para que funcione a geração de pedido integrada a aprovação via EIC.

@type function
/*/
*----------------------*
User Function zMT120FIM(nOpcao,cNumPC,nOpcA)
*----------------------*
Local _aAreaSC7 := SC7->(GetArea())
Local _lCopy := IIF(Type('lCop') <> 'U', lCop, .F.)

Private _aStopLnOBS := {0,0,''}

DbSelectArea("SC7");SC7->(DbSetOrder(1))

IF SC7->(DbSeek(xFilial("SC7") + cNumPC))
    IF nOpcA == 1 .And. (nOpcao == 3 .Or. nOpcao == 4 .Or. _lCopy) .Or. (Empty(nOpcao) .And. FWIsInCallStack("EICPO400")) //Ajustar aqui, ao estornar PO via EIC é chamada nOpcA = 1 e nOpcao = 5, para que funcione na inclusão é necessário que nOpcao seja vazio.
        IF Empty(SC7->C7_NUMIMP)
            //xGetTipo(cNumPC)
        Endif

        //Gera relatorio em base 64 para abertura no portal
        zSC72SZP()
        
        oProcess := U_MontaPCSC7(cNumPC)
    Endif
Endif
//nOpcao = 5 --Estorno

//OBSERV
RestArea(_aAreaSC7) 
Return

*----------------------------------------------*
User Function MontaPCSC7(_cNum,oProcess,_xAlias)
*----------------------------------------------*
Local aSvArea	:= GetArea()
Local aSvAreaCR	:= SCR->(GetArea())
Local _cDest    := GetNewPar("MZ_PATHWF","\web\PortalSny\WORKFLOW")+"\emp"+cEmpAnt+"\"
Local _cQrySCR  := ''
Local _cCorCab  := ''

DbSelectArea("SC7");SC7->(DbSetOrder(1));SC7->(DbSeek(xFilial("SC7") + _cNum))
DbSelectArea("SA2");SA2->(DbSetOrder(1));SA2->(DbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))
DbSelectArea("SC1");SC1->(DbSetOrder(1));SC1->(DbSeek(xFilial("SC1") + SC7->C7_NUMSC))
//DbSelectArea("SCR");SCR->(DBSETORDER(4)) //Alterada posição do índice de 4 para 5 - ajuste em função do índice alterado pela migração - 12.1.33 - 2022012523 
//SCR->(DBSEEK(xFilial('SCR')+_cNum))

_cMoeda := GetMV('MV_SIMB'+cValToChar(SC7->C7_MOEDA))

_cQrySCR := " SELECT SCR.R_E_C_N_O_ REC_SCR FROM "+RetSqlName('SCR')+" SCR WHERE SCR.D_E_L_E_T_='' AND CR_FILIAL = '"+xFilial('SCR')+"' AND CR_NUM='"+SC7->C7_NUM+"' "

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySCR),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

While _DIR->(!Eof())

    DbSelectArea('SCR'); SCR->(DbGoTo(_DIR->REC_SCR))
    IF SCR->(Recno()) <> _DIR->REC_SCR
        LOOP
    ENDIF

	//IF SCR->CR_STATUS <> '02'
	//	SCR->(DBSKIP())
	//	LOOP
	//ENdif
	
	DbSelectArea("SC7");SC7->(DbSetOrder(1));SC7->(DbSeek(xFilial("SC7") + _cNum))
	
	oProcess := TWFProcess():New( "400000", "Pedido de Compras" )

    _cTipo := ''

	oProcess:NewVersion(.T.)
	IF !Empty(SC7->C7_NUMIMP)
		oProcess :NewTask("Pedido de Compras", GetNewPar("MZ_PATHWF","\WORKFLOW")+"\HTML\PWFCOMIMP.htm", .T.)
		_cTipo   := 'Importacao'
		_cCorCab := 'rgb(0, 102, 0)'
	Else
		oProcess :NewTask("Pedido de Compras", GetNewPar("MZ_PATHWF","\WORKFLOW")+"\HTML\PWFCOM.htm", .T.)    
		IF SC7->C7_TIPO == 1
			_cTipo   := 'Pedido de Compras'
			_cCorCab := 'rgb(25, 25, 112)'
		Else
			_cTipo   := 'Autorização de Entrega'
			_cCorCab := 'rgb(0, 102, 0)'
		Endif
	Endif
	
	oHtml    := oProcess:oHTML

	oHtml:ValByName("zCOR_CABEC"	, _cCorCab)

	oHtml:ValByName("TIPOWF"		, "PC")
	oHtml:ValByName("C7_TIPO"		, _cTipo)
	oHtml:ValByName("RECNO"			, cValToChar(SCR->(RECNO())) )
	oHtml:ValByName("Aprovacao"		, "APV_"+cValToChar(SCR->(RECNO())) )
	
	oHtml:ValByName("NOME"			, "PC")
	oHtml:ValByName("TIPODOC"		, "Pedido de Compra")
	oHtml:ValByName("C7_NUM"		, SC7->C7_NUM)
	oHtml:ValByName("FORNECE"		, SA2->A2_COD + "/" + SA2->A2_LOJA)
	oHtml:ValByName("A2_NREDUZ"		, SA2->A2_NREDUZ)
	oHtml:ValByName("EMISSAO"		, DTOC(SC7->C7_EMISSAO))
	oHtml:ValByName("Y6_DESCRI"		, SC7->C7_COND+" - "+Posicione("SE4",1,xFILIAL("SE4")+SC7->C7_COND,"E4_DESCRI")     )
	oHtml:ValByName("Y6_DESCRI"		, SC7->C7_COND+" - "+Posicione("SE4",1,xFILIAL("SE4")+SC7->C7_COND,"E4_DESCRI")     )
	oHtml:ValByName("MOEDA1"		, _cMoeda     )
	oHtml:ValByName("MOEDA2"		, _cMoeda     )
	oHtml:ValByName("MOEDA3"		, _cMoeda     )                	
	oHtml:ValByName("SOLICIT"		, SC7->C7_NUMSC  )
	oHtml:ValByName("dtnece"		, DTOC(SC7->C7_DATPRF) )
	
	_cCompra := SC7->C7_USER
	oHtml:ValByName("COMPRA"		, POSICIONE("SY1",3,xFILIAL("SY1")+_cCompra ,"Y1_NOME"))
	
	_cTotalDesc := 0
	_cTotalPed  := 0
	DbSelectArea("SC7");SC7->(DBSETORDER(1))
	IF SC7->(DBSEEK(xFILIAL("SC7")+_cNum))
        Do While SC7->(!Eof()) .And. xFilial("SC7") == SC7->C7_FILIAL .AND.  SC7->C7_NUM == _cNum
            
            SB1->(DBSETORDER(1))
            SB1->(DBSEEK(xFILIAL("SB1")+SC7->C7_PRODUTO))
            
            aAdd((oHtml:ValByName("it.item"			)), SC7->C7_ITEM)
            aAdd((oHtml:ValByName("it.produto"		)), SC7->C7_PRODUTO)
            aAdd((oHtml:ValByName("it.descri"		)), SB1->B1_DESC)
            //aAdd((oHtml:ValByName("it.descri"		)), MSMM(SB1->B1_DESC_I))
            aAdd((oHtml:ValByName("it.um"			)), SB1->B1_UM)
            aAdd((oHtml:ValByName("it.quant"		)), Transform(SC7->C7_QUANT,'@E 999,999,999.99'))
            aAdd((oHtml:ValByName("it.preco"		)), Transform(SC7->C7_PRECO,'@E 999,999,999.99')) 
        //	aAdd((oHtml:ValByName("it.total"		)), Transform((SC7->C7_QUANT*SC7->C7_PRECO)-SC7->C7_VLDESC,'@E 999,999,999.99'))
            aAdd((oHtml:ValByName("it.total"		)), Transform(SC7->C7_TOTAL-SC7->C7_VLDESC,'@E 999,999,999.99'))
            aAdd((oHtml:ValByName("it.ccusto"		)), SC7->C7_CC      )
            aAdd((oHtml:ValByName("it.ipi"			)), Transform(SC7->C7_VALIPI,'@E 999,999,999.99'))
            aAdd((oHtml:ValByName("it.desc"			)), Transform(SC7->C7_VLDESC,'@E 999,999,999.99')    )
            //aAdd((oHtml:ValByName("it.obs"		)), Alltrim(SC7->C7_XOBS2))
            aAdd((oHtml:ValByName("it.obs"		)), Alltrim(SC7->C7_OBS))
            //aAdd((oHtml:ValByName("it.space"		)), " "      )
            _cTotalPed += (SC7->C7_QUANT*SC7->C7_PRECO) - SC7->C7_VLDESC
            _cTotalDesc += SC7->C7_VLDESC
        
            DbSelectArea("SC7")
            SC7->(DbSkip())
            
            IF SC7->(!Eof()) .And. xFilial("SC7") == SC7->C7_FILIAL .AND.  SC7->C7_NUM == _cNum
                aAdd((oHtml:ValByName("it.space"		)), " "      )
            Else
                _cLinks := 	ADGetArq(_cNum)		
                aAdd((oHtml:ValByName("it.space"		)), _cLinks      )
            Endif
        EnddO
    Endif
	
	oHtml:ValByName("TOTALGERAL"		, Transform(_cTotalPed,'@E 999,999,999.99')     )
	oHtml:ValByName("TOTALDESC"			, Transform(_cTotalDesc,'@E 999,999,999.99')     )
	_cObs := ""

	oProcess:cTo  := NIL
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL
	
	cMailId    := oProcess:Start(_cDest)
	
	IF  SCR->(RECLOCK('SCR',.F.))		
		    Replace SCR->CR_XHTML With _cDest+cMailId+".HTM"		
		SCR->(MSUNLOCK())
	Endif
	
    _DIR->(DbSkip())
EndDo

SCR->(RestArea(aSvAreaCR))
RestArea(aSvArea)

Return oProcess


*----------------------------*
Static Function ADGetArq(_cNum)
*----------------------------*
Local _cLinks  := ''
Local _nCntTxt := 0
Local _cFilial := ''
Local _cTabela := 'SC7'
/*
_cQuery := " SELECT * FROM AC9010 AC9 " 
_cQuery += " WHERE AC9.D_E_L_E_T_='' and AC9.AC9_FILENT='"+xFilial('SC7')+"' AND AC9_ENTIDA='SC7' "
_cQuery += " AND AC9_CODENT like '"+xFilial('SC7')+_cNum+"%' "

IIF(SELECT('ZZZ') > 0 , ZZZ->(DBCLOSEAREA()), NIL)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'ZZZ',.T.,.T.)

DbSelectArea('ZZZ')
ZZZ->(DBGOTOP())

While ZZZ->(!Eof())
    _cFilial := '02' //ZZZ->AC9_FILIAL
	_nCntTxt++
	_cLinks += '&nbsp;&nbsp;<a href="./AWKFANEXO.APW?X='+ZZZ->AC9_CODOBJ+'&F='+_cFilial+'" target="_blank" class="">Anexo_'+cValToChar(_nCntTxt)+'</a>'
	ZZZ->(DBSKIP())
Enddo
*/

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
Static Function zSC72SZP
*----------------------*							
Local _cAnexo   := u_SNYCOMR90(SC7->C7_NUM, .F., .F.)
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
        _aSZP[1] := SC7->C7_NUM
        _aSZP[2] := 'SC7'
        _aSZP[3] := 'PORTALSNY'
        _aSZP[4] := 'Pedido de Compras'
        _aSZP[5] := 'SC7'+xFilial('SC7')+SC7->C7_NUM
        _aSZP[6] := _cFile
	        If ExistBlock("zSZPIAuto")
            ExecBlock("zSZPIAuto",.F.,.F.,_aSZP)
            FErase(_cFile)
        ENDIF
	ENDIF
ENDIF  

RETURN
