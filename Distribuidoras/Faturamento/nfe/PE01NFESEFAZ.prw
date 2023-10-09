#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"

#Define ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ PE01NFESEFAZ ³ Autor ³ Gustavo Markx    ³ Data ³21/06/2023  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para nota fiscal eletronica               ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*------------------------*
User Function PE01NFESEFAZ
*------------------------*
Local _nR 			:= 0  

Local lEndFis 		:= GetNewPar("MV_SPEDEND",.F.)

//Parametros da Rotina
Private _aProd     	:= ParamIXB[1]
Private _cMensCli	:= ParamIXB[2]
Private _cMensFis 	:= ParamIXB[3]
Private _aDest		:= ParamIXB[4]
Private _aNota		:= ParamIXB[5]
Private _aInfoItem 	:= ParamIXB[6]
Private _aDupl 		:= ParamIXB[7]
Private _aTransp	:= ParamIXB[8]
Private _aEntrega	:= ParamIXB[9]
Private _aRetirada	:= ParamIXB[10]
Private _aVeiculo	:= ParamIXB[11]
Private _aReboque	:= ParamIXB[12]
Private _aNfVincRur	:= ParamIXB[13]
//Nota Fiscal 4.0
Private _aEspVol	:= ParamIXB[14]
Private _aNfVinc	:= ParamIXB[15]
Private _aDetPag	:= ParamIXB[16]
Private _aObsCont	:= ParamIXB[17]
//Parametros do fonte
Private _aArea := GetArea()
Private _aArC6 := SC6->(GetArea())
Private _aArC2 := SD2->(GetArea())
Private _aArB1 := SB1->(GetArea())

Private _cFilial  := FWxFilial('SC5')

//Tipo de NF: 0=ENTRADA | 1=SAIDA
_cTipoNF := _aNota[4]
// Numero da NF
_cNfnum:= _aNota[2]

IF _cTipoNF == '1'//|_____________________________[ NOTA FISCAL DE SAIDA]_____________________________
	//POSICIONA NO PEDIDO DE VENDA
	DbselectArea('SC5');SC5->(DbGoTop());SC5->(DbSetOrder(1))
	_cNumPed := _aInfoItem[1][1]

	IF SC5->(MsSeek(xFilial("SC5") + _cNumPed))

		DbselectArea('SA1');SA1->(DbGoTop());SA1->(DbSetOrder(1))
		IF SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )
			//ALTERAÇÃO SALONLINE - GENILSON LUCAS
			If !Empty(SA1->A1_X_MSGNF)
				_cMensFis += ALLTRIM(SA1->A1_X_MSGNF)
			EndIf	
		EndIf
		_cMensFis += " | NOS PAGAMENTOS APOS O VENCIMENTO SERAO COBRADOS ENCARGOS MORATORIOS"

		//[Numero Pedido Salon - MENSAGEM COMPLEMENTAR]________________________________
		_cMensFis += '| PEDIDO: '+ AllTrim(_cNumPed)
				
		//[NUMERO DO PEDIDO DO CLIENTE]________________________________<nitemped> = Item.Ped.Com (C6_ITEMPC) E <xped> = Num.Ped.Com (C6_NUMPCOM)
		IF !SC5->C5_TIPO $ 'B,D'
			For _nR:=1 TO Len(_aProd)
				_cProdPV := _aProd[_nR][02]
				_cNumPV  := _aProd[_nR][38]
				_cItemPV := _aProd[_nR][39]

				DbselectArea('SC6');SC6->(DbGoTop());SC6->(DbSetOrder(1))
				IF SC6->(DbSeek(xFilial('SC6') + _cNumPV + _cItemPV + _cProdPV))					
					//INFORMACOES DO PEDIDO DO CLIENTE
					IF !Empty(SC6->C6_NUMPCOM)
						//_aProd[_nR][04] := AllTrim(_aProd[_nR][04]) +' | REF.CLIENTE: '+AllTrim(SC6->C6_NUMPCOM)+ iif(!Empty(SC6->C6_ITEMPC),'-','')+AllTrim(SC6->C6_ITEMPC)
					ENDIF	
				ENDIF	

				////INFORMACOES DO PEDIDO DO CLIENTE
				If  !(AllTrim(SC6->C6_NUMPCOM) $ _cMensFis) .And. !Empty(SC6->C6_NUMPCOM)
					_cMensFis += " | REF CLIENTE: " + SC6->C6_NUMPCOM		
				EndIf

				DbselectArea('SF4');SF4->(DbGoTop());SF4->(DbSetOrder(1))
				IF SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )
					//SOLICITAÇÃO FERNANDO MEDEIROS E ROGERIO SASSO
					If SF4->F4_ART274 == "1"  .And. IIF(!lEndFis,ConvType(SM0->M0_ESTCOB),ConvType(SM0->M0_ESTENT)) == "SP"
						If !("Tags vBCSTRet e vICMSSTRet do XML" $ _cMensFis)
							_cMensFis += "Valores referentes a Base de Cálculo ICMS/ST e valores Retidos são os constantes nas Tags vBCSTRet e vICMSSTRet do XML. "
						EndIf
					EndIF				
				ENDIF											
			Next _nR	
		ENDIF
	ENDIF
								
//Tipo de NF: 0=ENTRADA | 1=SAIDA
ElseIf _cTipoNF == '0'//|_____________________________[ NOTA FISCAL DE ENTRADA]_____________________________//

ENDIF

RestArea(_aArea)
RestArea(_aArC6)
RestArea(_aArC2)
RestArea(_aArB1)

Return({_aProd,_cMensCli,_cMensFis,_aDest,_aNota,_aInfoItem,_aDupl,_aTransp,_aEntrega,_aRetirada,_aVeiculo,_aReboque,_aNfVincRur,_aEspVol,_aNfVinc,_aDetPag,_aObsCont})

*----------------------------------------*
Static Function ConvType(xValor,nTam,nDec)
*----------------------------------------*
Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(NoAcento(SubStr(xValor,1,nTam)))
EndCase
Return(cNovo)
