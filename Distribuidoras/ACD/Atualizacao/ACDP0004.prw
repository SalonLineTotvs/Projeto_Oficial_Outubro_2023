#include "protheus.ch"
#include "apvt100.ch"
#include "sigaacd.ch"
#include "topconn.ch"

/*
�������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������Ŀ��
���Fun��o    � ACDP0004  � Autor � Genilson M Lucas 		     � Data � 11/06/08 ���
��������������������������������������������������������������������������������������Ĵ��
���Descri��o � Embarque | Conf de volume              						  		   ���
��������������������������������������������������������������������������������������Ĵ��
���Uso       � Rotina de embarque simples sobre o volume do pedido					   ���
���������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
*/ 

User Function ACDP0004()

Private cPedido 	:= Space(TamSX3("C5_NUM")[01])
Private cEtiqPed	:= SPACE(15)
Private cCodOpe 	:= CBRetOpe()
Private cEmpresa	:= SPACE(04)
Private cNomEmp		:= SPACE(10)
Private nVolTotal	:= 0
Private lFimEmb		:= .F.

If Empty(cCodOpe)
	VTAlert("Operador nao cadastrado","Aviso",.T.,4000) //"Operador nao cadastrado"###"Aviso"
	Return .F.
EndIf   

While .T.
	
	VTClear()
	@ 0,00 VTSAY 'Informar Pedido'
	@ 1,00 VTSAY "Filial:" VTGet cEmpresa pict '@!' Valid VldFilial() F3 "SM0"
	@ 2,00 VTSAY "Pedido:" VTGet cPedido pict '@!' Valid VldPedido() F3 "SC5" //'Nota :'
	
	VTRead
   	If VtLastKey() == 27    
   		VtClearBuffer()
		Exit
	EndIf
 	Embarque()
EndDo  

Return 


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � VldFilial  � Autor � Genilson M Lucas   � Data �  12/06/18  ���
��������������������������������������������������������������������������͹��
���Desc.     � Valida filial informado.		                               ���
��������������������������������������������������������������������������͹��
���Uso       � ACD                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function VldFilial()

If Empty(cEmpresa)
	Return .F.
Endif

DbSelectArea("SM0")
DbSetOrder(1)
If dbSeek('02'+cEmpresa,.F.)
	cNomEmp	:= SM0->M0_FILIAL
Else
	VTAlert('Filial informada nao existe.','FILIAL',.T.,4000,4)
	cEmpresa	:= SPACE(04)
	VtClearGet("cEmpresa")
	Return .F.
EndIf

Return()



/*
������������������������������������������������������������������������������
�������������������������������������������������������������������00�����������
��������������������������������������������������������������������������ͻ��
���Programa  � VldPedido  � Autor � Genilson M Lucas   � Data �  12/06/18   ���
��������������������������������������������������������������������������͹��
���Desc.     � Valida o pedido de venda		                              ���
��������������������������������������������������������������������������͹��
���Uso       � ACD                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function VldPedido()

Local nVolume1	:= 0
Local nVolume2	:= 0

If Empty(cPedido)
	//VTKeyBoard(chr(23))
	Return .F.
	
ElseIf Len(cPedido) < 6
	Return .t.
Endif

SC5->(dbSetOrder(1))
If !SC5->(dbSeek(cEmpresa+cPedido ))
	VTAlert('Pedido nao cadastrado.','Aviso',.T.,4000,4) //"Nota fiscal nao cadastrada"###"Aviso"
	VTKeyBoard(chr(20))
	Return .F.
Else
	//VALIDA��ES DO PEDIDO PARA EFETUAR CONFER�NCIA
	If Empty(SC5->C5_NOTA)
		VTAlert('Pedido n�o faturado.','Aviso',.T.,4000,4) //"Nota fiscal nao cadastrada"###"Aviso"
		VTKeyBoard(chr(20))
		Return .F.
	
	ElseIf SC5->C5_X_CFVOL == '2'
		VTAlert('Conferencia de embarque ja efetuado.','Aviso',.T.,4000,4) //"Nota fiscal nao cadastrada"###"Aviso"
		VTKeyBoard(chr(20))
		Return .F.		
	EndIf
	nVolume1	:= SC5->C5_VOLUME1
	nVolume2	:= SC5->C5_VOLUME2
	nVolTotal	:= SC5->C5_VOLUME1 + SC5->C5_VOLUME2
	
	RecLock("SC5",.F.)
		SC5->C5_X_CFVOL	:= '1'		
	SC5->(MsUnlock())


	//Grava os volumes para serem conferidod
	SZ2->(DbSetOrder(1))
	SZ2->(DbSeek(cEmpresa+cPedido))
	If SZ2->(Eof())
		If nVolume1 > 0
			For I := 1 to nVolume1
				
				RecLock("SZ2",.T.)
				
				SZ2->Z2_FILIAL	:=  cEmpresa
				SZ2->Z2_PEDIDO	:=  cPedido
				SZ2->Z2_TIPO	:= 'C'
				SZ2->Z2_VOLUME	:=  alltrim(Transform(i,"@E 9999"))	
				SZ2->(MsUnlock())
			
			Next I
		EndIf
		
		If nVolume2 > 0
			For I := 1 to nVolume2
				
				RecLock("SZ2",.T.)
				
				SZ2->Z2_FILIAL	:=  cEmpresa
				SZ2->Z2_PEDIDO	:=  cPedido
				SZ2->Z2_TIPO	:= 'G'
				SZ2->Z2_VOLUME	:=  alltrim(Transform(i,"@E 9999"))	
				SZ2->(MsUnlock())
			
			Next I
		EndIf
	Endif
EndIf

Return .t.



/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � Embarque �Autor  �Henrique Gomes Oikawa� Data �  31/03/04   ���
��������������������������������������������������������������������������͹��
���Desc.     � Faz o embarque dos itens da nota fiscal         			   ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function Embarque()

Local lFlag	:= .F.
Local bkey06

bKey06 := VTSetKey(06,{|| Faltas()},STR0009)    // CTRL+F //"Faltantes"

For i := 1 to nVolTotal

	@ 4,00 VTSAY 'Leia a Etiqueta' 
	@ 5,00 VTGET cEtiqPed pict '@!' Valid VldEtiq(cEtiqPed)
	@ 6,00 VTSAY 'VOLUME: '+alltrim(transform(I,"@E 9,999"))+' / '+alltrim(transform(nVolTotal,"@E 9,999"))
	VTRead
	
	If VTLastkey() == 27
		If ! VTYesNo("Confirma finalizacao da conferencia?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
			I--
			Loop
		EndIf
		
		lFlag	:= TudoOk()
		
		If lFlag
			I--
			Loop
		EndIf
		
		cEmpresa	:= SPACE(04)
		cPedido		:= Space(TamSX3("C5_NUM")[01])
		cEtiqPed	:= SPACE(15)
		VtClearGet("cEmpresa")
		VtClearGet("cPedido")
		VtClearGet("cEtiqPed")
		VtClearBuffer()
		Return .F.
	EndIf

Next I


lFlag	:= TudoOk()
VtClearBuffer()
vtsetkey(06,bkey06)

Return()



/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � VldEtiq �Autor  � Genilson M Lucas 		� Data �  13/06/18  ���
���������������������������������������������������������������������������͹��
���Desc.     � Valida etiqueta do volume								    ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function VldEtiq(cEtiqProd)

Local cBuffer	:= cEtiqProd
Local cEtqTipo	:= ''
Local cEtqPed	:= ''
Local cEtqItem	:= ''
Local nDivi		:= 0
		
If Empty(cEtiqProd)
	Return .f.
EndIf

nDivi	 	:= At(";",cBuffer)
cEtqPed		:= Alltrim(Substr(cBuffer,1,  nDivi - 1))   

cBuffer 	:= Substr(cBuffer , nDivi+1)  			
nDivi		:= At(";",cBuffer)
cEtqTipo	:= Alltrim(Substr(cBuffer,1,  nDivi - 1)) 

cBuffer 	:= Substr(cBuffer , nDivi+1)   
cEtqItem	:= Alltrim(cBuffer)

If cEtqPed	<> alltrim(cPedido)
	VTAlert('Este volume nao pertence para esse pedido.','Aviso',.T.,6000,4)
	If IsTelNet()
		cEtiqPed	:= SPACE(15)
		VtClearGet("cEtiqProd")  // Limpa o get
	Endif
	Return .f.
EndIf

SZ2->(DbSetOrder(1))
DbGoTop()
If SZ2->(DbSeek(cEmpresa+cEtqPed+cEtqTipo+cEtqItem))
	If SZ2->Z2_CONFERI <> '1'
		RecLock("SZ2",.F.)
			SZ2->Z2_CONFERI	:= '1'
		SZ2->(MsUnlock())
		VTBEEP(1)
	Else
	
		//
		//
		// NECESS�RIO TRATATIVA DE BLOQUEIO
		//
		//
		VTAlert('Volume ja foi lido.','Aviso',.T.,4000,4)
		cEtiqPed := SPACE(15)
		VtClearGet("cEtiqPed")  // Limpa o get
		
		Return .f.
	EndIf
Else
	VTAlert('Etiqueta Invalida.','Aviso',.T.,4000,4)
	cEtiqPed := SPACE(15)
	VtClearGet("cEtiqPed")  // Limpa o get
	Return .f.
EndIf	

	VtClearBuffer()
	VTKeyBoard(chr(20))
	lRet := .t.

Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �TudoOk     � Autor  Genilson M Lucas   a� Data � 31/03/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o statusdo pedido para gerar manifesto.		 ) ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TudoOk()
Local lReturn	:= .F.
Local cTxtSZ2	:= ''
SZ2->(DbSetOrder(1))
SZ2->(DbSeek(cEmpresa+cPedido))
While !Eof() .and. SZ2->(Z2_FILIAL+Z2_PEDIDO) = cEmpresa+cPedido
	
	If SZ2->Z2_CONFERI <> '1'
		lReturn	:= .T.
	EndIf

	SZ2->(DbSkip())

EndDo
If lReturn
	If VTYesNo("Conferencia nao finalizada, sera estornado todos os registros. Deseja continuar?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
	
		cTxtSZ2 := " UPDATE "+RetSqlName("SZ2")+" SET D_E_L_E_T_ = '*' "
		cTxtSZ2 += " WHERE D_E_L_E_T_ = '' AND "
		cTxtSZ2 += " Z2_PEDIDO ='"+Alltrim(cPedido)+"' AND Z2_FILIAL ='"+cEmpresa+"' "
		TcSqlExec(cTxtSZ2)
		
		RecLock("SC5",.F.)
			SC5->C5_X_CFVOL := '3'	
		SC5->(MsUnlock())
	
		Return .F.
	EndIf
Else
	RecLock("SC5",.F.)
		SC5->C5_X_CFVOL := '2'	
	SC5->(MsUnlock())
	
	cEmpresa	:= SPACE(04)
	cPedido		:= Space(TamSX3("C5_NUM")[01])
	cEtiqPed	:= SPACE(15)
	VtClearGet("cEmpresa")
	VtClearGet("cPedido")
	VtClearGet("cEtiqPed")
	VTAlert('Embarque Finalizado.','Confirmacao',.T.,4000,2)
EndiF

	
Return(lReturn)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Faltas     � Autor  Genilson M Lucas   a� Data � 17/03/04  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista os volumes pendentes de confer�ncia.				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Faltas()

Local aCab,aSize,aSave := VTSAVE()
Local aConf	:= {}

SZ2->(DbSetOrder(1))
SZ2->(DbGotop())
SZ2->(DbSeek(cEmpresa+cPedido))
While !Eof() .and. SZ2->(Z2_FILIAL+Z2_PEDIDO) = cEmpresa+cPedido
	
	If SZ2->Z2_CONFERI <> '1'
		If SZ2->Z2_TIPO = 'C'
			aadd(aConf,{'Caixa',SZ2->Z2_VOLUME})
		Else
			aadd(aConf,{'Granel',SZ2->Z2_VOLUME})
		EndIf
	EndIf

	SZ2->(DbSkip())

EndDo

VTClear()
aCab  := {'Tipo','Volume'}
aSize := {10,16}
VTaBrowse(0,0,7,19,aCab,aConf,aSize)

VtRestore(,,,,aSave)
	
Return .T.
