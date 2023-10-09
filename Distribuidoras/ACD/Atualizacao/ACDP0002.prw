#include "protheus.ch"
#INCLUDE 'rwmake.ch'
#include "apvt100.ch"
#include "sigaacd.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ACDP0002  ณ Autor ณ Genilson M Lucas 	     ณ Data ณ 09/08/18		ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Rotina para confer๊ncia do pedido de venda ap๓s separa็ใo.   	    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Utilizado no G5 - SALONLINE								    		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

User Function ACDP0002()

Private cPedido 	:= Space(TamSX3("C5_NUM")[01])
Private cEmpresa	:= SPACE(04)
Private cNomEmp		:= SPACE(10)
Private cEtiqVol	:= SPACE(20)
Private nTamSB1		:= TamSX3("B1_COD")[01]
Private cCodOpe 	:= CBRetOpe()
Private lFlag		:= .T.

If Empty(cCodOpe)
	VTAlert("Operador nao cadastrado","Aviso",.T.,3000) //"Operador nao cadastrado"###"Aviso"
	Return .F.
EndIf   

While .T.
	
	VTClear()
	@ 0,00 VTSAY 'Informar Pedido'
	@ 1,00 VTSAY "Filial:" VTGet cEmpresa pict '@!' Valid VldFilial() F3 "SM0"
	@ 1,15 VTSAY cNomEmp
	@ 2,00 VTSAY "Pedido:" VTGet cPedido pict '@!' Valid VldPedido() F3 "SC5" 
	VTRead
	
   	If VtLastKey() == 27                    
		Exit
	EndIf
	
	lFlag := .T.
 	Conferen()
EndDo  

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldFilial  บ Autor ณ Genilson M Lucas   บ Data ณ  09/08/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida filial informado.		                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ACD                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	VTAlert('Filial informada nao existe.','FILIAL',.T.,3000,4)
	cEmpresa	:= SPACE(04)
	VtClearGet("cEmpresa")
	Return .F.
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldPedido  บ Autor ณ Genilson M Lucas   บ Data ณ  09/08/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o pedido de venda		                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ACD                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldPedido()

If Empty(cPedido)
	//VTKeyBoard(chr(23))
	Return .F.
EndIf

If Len(cPedido) < 6
	Return .T.
Endif


//VALIDA PEDIDO E FAZ ATUALIZAวรO
SC5->(dbSetOrder(1))
If !SC5->(dbSeek(cEmpresa+cPedido ))
	VTAlert('Pedido nao cadastrado.','Aviso',.T.,3000,4) //"Nota fiscal nao cadastrada"###"Aviso"
	VTKeyBoard(chr(20))
	Return .F.
Else
	
	//VALIDAวีES DO PEDIDO PARA EFETUAR CONFERสNCIA
	If SC5->C5_X_STAPV == '2' .OR. SC5->C5_X_STAPV == '3' 
	
		RecLock("SC5",.F.)
			SC5->C5_X_DTICF	:= Date()
			SC5->C5_X_HRICF	:= time()
			SC5->C5_X_STAPV := '4'
			//SC5->C5_X_CONCX	:= Posicione('CB1',1,xFilial('CB1')+cCodOpe,'CB1_NOME')  //UsrFullName( cCodUser )
		SC5->(MsUnlock())	
	
	ElseIf SC5->C5_X_STAPV <> '4'
		VTAlert('Pedido nao separado.','Aviso',.T.,4000,4)
		VTKeyBoard(chr(20))
		Return .F.
	EndIf

EndIf

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Conferen บAutor  ณ Genilson M Lucas 	  บ Data ณ  09/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa leitura da etiqueta do produto.	     			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Conferen()

Local bkey16, bkey18

bKey16 := VTSetKey(16,{|| Pendente()},'Pendente')     // CTRL+F 
bKey18 := VTSetKey(18,{|| Resumo()},'Resumo')    // CTRL+R 

VTClear()
@ 0,00 VTSAY 'CONFERENCIA PEDIDO'
@ 1,00 VTSAY alltrim(substr(cNomEmp,1,8)) + "- PV: " + cPedido

While lFlag

	//ALTERAR PARA NรO RODAR NOVAMENTE, SOMENTE SE PULAR PRODUTO
	//lFlag := .F.

	@ 3,00 VTSAY 'Confirme o Produto'
	@ 4,00 VTGET cEtiqVol 	pict '@!' Valid VldEtiq()
	VTRead

	
	If VTLastkey() == 27
		If VTYesNo("Confirma sair da Conferencia?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
			//Finaliza()
			cEmpresa	:= SPACE(04)
			cNomEmp		:= SPACE(10)
			cPedido		:= Space(TamSX3("C5_NUM")[01])
			cEtiqVol	:= SPACE(20)
			VtClearGet("cEmpresa")
			VtClearGet("cPedido")
			VtClearGet("cEtiqVol")
			
			VtClearBuffer()
			Return .F.
		Else
			Loop
		EndIf	
	EndIf			
				
	cEtiqVol	:= SPACE(20)
	VtClearGet("cEtiqVol")  // Limpa o get
		
EndDo

vtsetkey(16,bkey16)
vtsetkey(18,bkey18)
VtClearBuffer()

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEtiq บAutor  ณ Genilson M Lucas 		บ Data ณ  09/08/18  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida etiqueta do volume		    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldEtiq()

Local cBuffer	:= cEtiqVol
Local cEtqPedi	:= ''
Local cEtqProd	:= ''
Local nEtqQtd	:= 1
Local nDivi		:= 0
Local lRet		:= .T.

If Empty(cEtiqVol)	
	Return .F.
EndIf

// BUSCO O PRODUTO EQUIVALENTE PELO CODIGO DE BARRAS
If LEFT(cBuffer,2) == 'PL'
	// PRODUTO/LOTE/QUANTIDADE
 
	cBuffer 	:= Substr(cBuffer , 4)//PARA NรO CONSIDERAR O PL  			
	nDivi		:= At("/",cBuffer)
	cEtqProd	:= Alltrim(Substr(cBuffer,1,  nDivi - 1)) 

	cBuffer 	:= Substr(cBuffer , nDivi+1)			
	nDivi		:= At("/",cBuffer)
	cEtqPedi	:= Alltrim(Substr(cBuffer,1,  nDivi - 1)) 
		
	cBuffer 	:= Substr(cBuffer , nDivi+1)   
	nEtqQtd		:= VAL(Alltrim(Substr(cBuffer,1)))

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial('SB1')+cEtqProd ))
	
	If cEtqPedi <> cPedido
		VTAlert('Pedido informado na etiquea esta incorreto.','Numero Pedido',.T.,5000,3)
		
		cEtiqVol	:= SPACE(20)
		VtClearGet("cEtiqVol")  // Limpa o get
		Return .F.
	EndIf
	
	If !(VTYesNo("Confirma conferencia do Pallet com " + TRANSFORM(nEtqQtd,"@E 9,999") + " volumes?",'Aviso',.T.)) 
		cEtiqVol	:= SPACE(20)
		VtClearGet("cEtiqVol")  // Limpa o get
		Return .F.	
	EndIf
Else
	SB1->(DbSetOrder(5))
	SB1->(DbSeek(xFilial('SB1')+cEtiqVol ))
EndIf

// REGISTRA CONFERสNCIA DO PRODUTO
DBSelectarea("SC6")
DBSetOrder(2)
If DBSeek(cEmpresa + Padr(SB1->B1_COD,nTamSB1) + cPedido,.F.)
	If (SC6->C6_X_VCXCO + nEtqQtd) <= SC6->C6_X_VCXIM
		Reclock("SC6",.F.)
			SC6->C6_X_VCXCO += nEtqQtd
		msunlock()
		
		//VtClearBuffer()
		//VTKeyBoard(chr(20))
		VTBEEP(1)
		cEtiqVol	:= SPACE(20)
		VtClearGet("cEtiqVol")  // Limpa o get
	Else
		VTAlert('Quantidade conferida maior que solicitado!','QUANTIDADE',.T.,2000 ,3)
		cEtiqVol	:= SPACE(20)
		VtClearGet("cEtiqVol")  // Limpa o get
		lRet :=  .f.	
	EndIf 

Else
	VTAlert('Produto nao existe no pedido.','Aviso',.T.,2000,3)
	
	cEtiqVol	:= SPACE(20)
	VtClearGet("cEtiqVol")  // Limpa o get
	lRet :=  .f.
EndIf	

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Finaliza บAutor  ณ Genilson M Lucas 		บ Data ณ  27/07/18  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Finaliza e zera configura็๕es		    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Finaliza()

Local cQuery	:= ''

cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_DESCRI, C6_X_VCXIM, C6_X_SEPAR, B1_X_LOCAL "
cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery	+= " WHERE C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' AND C6_X_VCXIM > 0 AND C6.D_E_L_E_T_ = '' "
cQuery	+= " AND C6_X_SEPAR <> C6_X_VCXIM AND C6_X_RESID = '' "
cQuery	+= " ORDER BY B1_X_LOCAL "
			
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPFIM",.T.,.T.)
			
If TMPFIM->(EOF())
	RecLock("SC5",.F.)
		If Empty(SC5->C5_NOTA)
			SC5->C5_X_STAPV := "5"
		Else
			SC5->C5_X_STAPV := "6"
		EndIf
	SC5->(MsUnlock())
	VTAlert('Conferencia finalizada com sucesso!','Aviso',.T.,6000,3)
Else
	// Gerar Pedido das Faltas 
	If SC5->C5_X_TLPCG == "P" .AND. SC5->C5_X_TLPCC == "P" 
		//lEtiqGer := .T.
		GeraPV()
	
	Elseif SC5->C5_X_TLPCG == "P" .AND. SC5->C5_X_TLPCC == "T"
		//lEtiqGer := .T.
		GeraPV()
	
	Elseif SC5->C5_X_TLPCG == "T" .AND. SC5->C5_X_TLPCC == "P"
		//lEtiqGer := .T.
		GeraPV()
	Endif
	
	VTAlert('Conferencia finalizada com corte.','CORTE',.T.,6000,3)
EndIf

TMPFIM->(DbCloseArea())

cEmpresa	:= SPACE(04)
cNomEmp		:= SPACE(10)
cPedido		:= Space(TamSX3("C5_NUM")[01])
cEtiqVol	:= SPACE(20)
VtClearGet("cEmpresa")
VtClearGet("cPedido")
VtClearGet("cEtiqVol")

VtClearBuffer()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ Pendente   ณ Autor  Genilson M Lucas   aณ Data ณ 17/03/04  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Lista os volumes pendentes de confer๊ncia.				  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Pendente()

Local aCab,aSize,aSave := VTSAVE()
Local aConf		:= {}
Local cQuery	:= ''

cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_X_VCXIM, C6_X_VCXCO, C6_X_RESID "
cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery	+= " WHERE C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' AND C6_X_VCXIM > 0 AND C6.D_E_L_E_T_ = '' "
cQuery	+= " AND C6_X_VCXIM <> C6_X_VCXCO  "
cQuery	+= " ORDER BY C6_PRODUTO "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC6",.T.,.T.)
		
TMPSC6->(DbGoTop())
While !Eof()
	
	aadd(aConf,{TMPSC6->C6_PRODUTO, TRANSFORM(TMPSC6->C6_X_VCXIM,"@E 9,999"),TRANSFORM(TMPSC6->C6_X_VCXCO,"@E 9,999") ,If(Empty(TMPSC6->C6_X_RESID),'Nao','Sim') })
		
	TMPSC6->(DbSkip())
EndDo	

TMPSC6->(DbCloseArea())

VTClear()
aCab  := {'Produto','Vol.','Conf.','Corte Sep'}
aSize := {7,5,5,9}
VTaBrowse(0,0,VTMAXROW(),VTMAXCOL(),aCab,aConf,aSize)

VtRestore(,,,,aSave)
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ Resumo     ณ Autor  Genilson M Lucas   aณ Data ณ 15/08/18  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Lista produtos conferidos.								  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Resumo()

Local aCab,aSize,aSave := VTSAVE()
Local aConf		:= {}
Local cQuery	:= ''

cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_X_VCXIM, C6_X_VCXCO, C6_X_RESID "
cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery	+= " WHERE C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' AND C6_X_VCXCO > 0 AND C6.D_E_L_E_T_ = '' "
cQuery	+= " ORDER BY C6_PRODUTO "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC6",.T.,.T.)
		
TMPSC6->(DbGoTop())
While !Eof()
	
	aadd(aConf,{TMPSC6->C6_PRODUTO, TRANSFORM(TMPSC6->C6_X_VCXIM,"@E 9,999"),TRANSFORM(TMPSC6->C6_X_VCXCO,"@E 9,999") })
		
	TMPSC6->(DbSkip())
EndDo	

TMPSC6->(DbCloseArea())

VTClear()
aCab  := {'Produto','Vol.','Conf.'}
aSize := {7,5,5}
VTaBrowse(0,0,VTMAXROW(),VTMAXCOL(),aCab,aConf,aSize)

VtRestore(,,,,aSave)
	
Return .T.


