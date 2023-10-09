#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

#DEFINE ENTER Chr(13)+Chr(10) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡„o    ³ SLECOPICK  ³ Autor ³ Genesis/Gustavo    ³ Data ³24/07/2024 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  TELA INTERATIVA DOS PEDIDOS DA LOJA VIRTUAL               ³±±
±±³		     ³  PARA GERACAO DOS PICKINGS		                          ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*---------------------*
User Function SLECOPICK
*---------------------*
Local _nN     := 0
Local _N_MARK := 01
Local _N_PWEB := 02
Local _N_PVND := 03

Local _lLiberOK := .F.
Local _cImpt_To := '' //AllTrim(GetMV('MC_FT80IMP',.F.,'SEC8425191CDAF3'))
Local _cInSC5   := ''

Private _aPvSep := {}

IF zMarkBrwPZU()
	For _nN:=1 To Len(_aPvSep)
         IF _aPvSep[_nN][_N_MARK]  		 	           
			DbSelectArea('SC5');SC5->(DbSetOrder(1));SC5->(DbGoTop())
			IF SC5->(DbSeek(xFilial('SC5')+_aPvSep[_nN][_N_PVND]))
			_cInSC5 += SC5->C5_NUM+'|'				
			ENDIF
         ENDIF
     Next _nN

	IF !Empty(_cInSC5)
		FwMsgRun(,{|| u_MCFATR80(_cImpt_To,_lLiberOK,_cInSC5) }, "Aguarde Processamento...","Imprimindo romaneio de Separação")
	ENDIF
ENDIF

RETURN

*-------------------------*
Static Function zMarkBrwPZU
*-------------------------*
Local _nOpca := 0
Local _lOpca := .F.

//Tamanho da Janela
Private aSize := MsAdvSize(.F.)
Private nJanLarg := aSize[5]
Private nJanAltu := aSize[6]

Private lMarker  := .T.
 
//Alimenta o array
zBUSDATA()

DEFINE MSDIALOG _o3Dlg TITLE OemtoAnsi('Picklist de Separação (Venda Direta) - SolonLine') FROM 000, 000  TO nJanAltu, nJanLarg OF PIXEL Style 128
_o3Dlg:lEscClose := .F. 

    oPnMaster := tPanel():New(0,0,,_o3Dlg,,,,,,0,0)
    oPnMaster:Align := CONTROL_ALIGN_ALLCLIENT
 
    oDespesBrw := fwBrowse():New()
    oDespesBrw:setOwner( oPnMaster )
 
    oDespesBrw:setDataArray()
    oDespesBrw:setArray(_aPvSep)
    oDespesBrw:disableConfig()
    oDespesBrw:disableReport()
 
    oDespesBrw:SetLocate() // Habilita a Localização de registros
 
    //Create Mark Column
    oDespesBrw:AddMarkColumns(  {|| IIf(_aPvSep[oDespesBrw:nAt,01], "LBOK", "LBNO")},;  //Code-Block image
                                {|| SelectOne(oDespesBrw, _aPvSep)},;                   //Code-Block Double Click
                                {|| SelectAll(oDespesBrw, 01, _aPvSep) })               //Code-Block Header Click
 
    oDespesBrw:addColumn({"Pedido Web" 		, {||_aPvSep[oDespesBrw:nAt,02]}, "C", "@!"    , 1, 06 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,02]",, .F., .T., , "ETDESPES1"    })
    oDespesBrw:addColumn({"Pedido Venda"	, {||_aPvSep[oDespesBrw:nAt,03]}, "C", "@!"    , 1, 06 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,03]",, .F., .T., , "ETDESPES2"    })
    oDespesBrw:addColumn({"Emissão"			, {||_aPvSep[oDespesBrw:nAt,04]}, "C", "@!"    , 1, 10 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,04]",, .F., .T., , "ETDESPES3"    })
    oDespesBrw:addColumn({"Cliente" 		, {||_aPvSep[oDespesBrw:nAt,05]}, "C", "@!"    , 1, 30 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,05]",, .F., .T., , "ETDESPES4"    })
	oDespesBrw:addColumn({"Transportadora"	, {||_aPvSep[oDespesBrw:nAt,06]}, "C", "@!"    , 1, 30 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,06]",, .F., .T., , "ETDESPES5"    })
	oDespesBrw:addColumn({"Endereço"		, {||_aPvSep[oDespesBrw:nAt,07]}, "C", "@!"    , 1, 20 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,07]",, .F., .T., , "ETDESPES6"    })
	oDespesBrw:addColumn({"Bairro"			, {||_aPvSep[oDespesBrw:nAt,08]}, "C", "@!"    , 1, 15 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,08]",, .F., .T., , "ETDESPES7"    })
	oDespesBrw:addColumn({"Municipio"		, {||_aPvSep[oDespesBrw:nAt,09]}, "C", "@!"    , 1, 15 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,09]",, .F., .T., , "ETDESPES8"    })
	oDespesBrw:addColumn({"CEP"				, {||_aPvSep[oDespesBrw:nAt,10]}, "C", "@!"    , 1, 09 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,10]",, .F., .T., , "ETDESPES9"    })
	oDespesBrw:addColumn({"UF"				, {||_aPvSep[oDespesBrw:nAt,11]}, "C", "@!"    , 1, 02 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,11]",, .F., .T., , "ETDESPESA"    })
	oDespesBrw:addColumn({"Complemento"		, {||_aPvSep[oDespesBrw:nAt,12]}, "C", "@!"    , 1, 20 , , .T. , , .F.,, "_aPvSep[oDespesBrw:nAt,12]",, .F., .T., , "ETDESPESB"    })

    //oDespesBrw:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
 
    oDespesBrw:Activate(.T.)
 
ACTIVATE MSDIALOG _o3Dlg ON INIT EnchoiceBar(_o3Dlg,{|| (_nOpca:=1,_o3Dlg:End()) },{|| _o3Dlg:End()}) CENTERED

IF _nOpca == 1
    _lOpca := aScan(_aPvSep,{|a| a[1]}) > 0
ENDIF

Return(_lOpca)
 
 
*------------------------------------------* 
Static Function SelectOne(oBrowse, aArquivo)
*------------------------------------------*
aArquivo[oDespesBrw:nAt,1] := !aArquivo[oDespesBrw:nAt,1]
oBrowse:Refresh()
Return(.T.)
 
*------------------------------------------------* 
Static Function SelectAll(oBrowse, nCol, aArquivo)
*------------------------------------------------* 
Local _ni := 1

For _ni := 1 to len(aArquivo)
    aArquivo[_ni,1] := lMarker
Next
oBrowse:Refresh()
lMarker:=!lMarker
Return(.T.)
 
//Alimenta a tabela temporaria
*----------------------*
Static Function zBUSDATA
*----------------------*
Local _cQrySCR := "  
Local _cPerg   := "SLPICK0A"
Local _cPVDe   := ''
Local _cPVAte  := ''
Local _dDtDe   := StoD('')
Local _dDtAte  := StoD('')
Local _cTrDe   := ''
Local _cTrAte  := ''

_aPvSep := {}

u_xPutSx1(_cPerg,"01","Emissão De:       	","Emissão De:       	","Emissão De:       	","mv_ch01","D",08,00,00,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","")
u_xPutSx1(_cPerg,"02","Emissão Ate:      	","Emissão Ate:      	","Emissão Ate:      	","mv_ch02","D",08,00,00,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","")
u_xPutSx1(_cPerg,"03","Pedido Venda De:  	","Pedido Venda De:  	","Pedido Venda De:  	","mv_ch03","C",06,00,00,"G","","SC5","","","mv_par03","","","","","","","","","","","","","","","","")
u_xPutSx1(_cPerg,"04","Pedido Venda Ate:	","Pedido Venda Ate:	","Pedido Venda Ate:	","mv_ch04","C",06,00,00,"G","","SC5","","","mv_par04","","","","","","","","","","","","","","","","")
u_xPutSx1(_cPerg,"05","Transportadora De:  	","Transportadora De:  	","Transportadora De:  	","mv_ch05","C",06,00,00,"G","","SA4","","","mv_par05","","","","","","","","","","","","","","","","")
u_xPutSx1(_cPerg,"06","Transportadora Ate:  ","Transportadora Ate:  ","Transportadora Ate:  ","mv_ch06","C",06,00,00,"G","","SA4","","","mv_par06","","","","","","","","","","","","","","","","")

IF !Pergunte(_cPerg,.T.)
   Return
Endif 

_dDtDe  := MV_PAR01
_dDtAte := MV_PAR02
_cPVDe  := MV_PAR03
_cPVAte := MV_PAR04
_cTrDe  := MV_PAR05
_cTrAte := MV_PAR06

_cQrySCR += " SELECT	PZU_FILIAL FILIAL, PZU_PEDECO PED_WEB, PZU_NUM PED_VD, PZU_DATA DATA,  "+ENTER
_cQrySCR += " 		    PZU_CLIENT+'/'+PZU_LOJA+' - '+ISNULL(A1_NOME,'') CLIENTE,  "+ENTER
_cQrySCR += " 		    PZU_TRANSP+' - '+ISNULL(A4_NOME,'') TRANSP, "+ENTER
_cQrySCR += " 		    PZU_STATUS, "+ENTER
_cQrySCR += " 		    PZU_ENDENT,PZU_BAENTR,PZU_MUNENT,PZU_CEPENT,PZU_UFENTR,PZU_COMENT, "+ENTER
_cQrySCR += " 		    PZU.R_E_C_N_O_ RECPZU,SC5.R_E_C_N_O_ RECSC5 "+ENTER
_cQrySCR += " FROM "+RetSqlName('PZU')+" PZU  "+ENTER
_cQrySCR += " INNER JOIN "+RetSqlName('SC5')+" SC5 ON SC5.D_E_L_E_T_ = '' AND C5_FILIAL = PZU_FILIAL AND C5_NUM=PZU_NUM "+ENTER
_cQrySCR += " INNER JOIN "+RetSqlName('SA1')+" SA1 ON SA1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD=PZU_CLIENT AND A1_LOJA=PZU_LOJA "+ENTER
_cQrySCR += " LEFT  JOIN "+RetSqlName('SA4')+" SA4 ON SA4.D_E_L_E_T_ = '' AND A4_FILIAL = '"+xFilial('SA4')+"' AND A4_COD=PZU_TRANSP "+ENTER
_cQrySCR += " WHERE PZU.D_E_L_E_T_ = '' "+ENTER
_cQrySCR += "   AND PZU_STATUS = '3' "+ENTER
_cQrySCR += "   AND PZU_NUM    BETWEEN '"+_cPVDe+"'       AND '"+_cPVAte+"' "+ENTER
_cQrySCR += "   AND PZU_DATA   BETWEEN '"+DtoS(_dDtDe)+"' AND '"+DtoS(_dDtAte)+"' "+ENTER
_cQrySCR += "   AND PZU_TRANSP BETWEEN '"+_cTrDe+"'       AND '"+_cTrAte+"' "+ENTER
_cQrySCR += " ORDER BY 1,2 "+ENTER

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQrySCR),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

IF _nMax > 0
    While _DIR->(!Eof())
        aAdd(_aPvSep,{.F.,	Alltrim(_DIR->PED_WEB), _DIR->PED_VD, StoD(_DIR->DATA), _DIR->CLIENTE, _DIR->TRANSP,;
							Alltrim(_DIR->PZU_ENDENT),Alltrim(_DIR->PZU_BAENTR),Alltrim(_DIR->PZU_MUNENT),Alltrim(_DIR->PZU_CEPENT),Alltrim(_DIR->PZU_UFENTR),Alltrim(_DIR->PZU_COMENT),;
							_DIR->RECPZU,_DIR->RECSC5})
        _DIR->(DbSkip())
    EndDo
EndIF

Return(.T.)
 