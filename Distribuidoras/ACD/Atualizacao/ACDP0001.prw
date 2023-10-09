#include "protheus.ch"
#INCLUDE 'rwmake.ch'
#include "apvt100.ch"
#include "sigaacd.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ACDP0001  ณ Autor ณ Genilson M Lucas 		    ณ Data ณ 14/06/18     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa para executar a separa็ใo dos produtos via coletor.			  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ 																		  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

User Function ACDP0001()

Private cPedido 	:= Space(TamSX3("C5_NUM")[01])
Private cEmpresa	:= SPACE(04)
Private cNomEmp		:= SPACE(10)
Private cEtiqVol	:= SPACE(15)
Private cEtiqEnd	:= SPACE(12)
Private nOpcao		:= '1'
Private cCodOpe 	:= CBRetOpe()
Private nVolSep		:= 0
Private	nQuant		:= 0
Private	cProduto	:= ''
Private cLocal		:= ''
Private cItem		:= ''
Private lFlag		:= .T.
Private lCorta		:= .F.
Private lPula		:= .F.

If Empty(cCodOpe)
	VTAlert("Operador nao cadastrado","Aviso",.T.,3000) //"Operador nao cadastrado"###"Aviso"
	Return .F.
EndIf   

While .T.
	
	VTClear()
	@ 0,00 VTSAY 'Informar Pedido' //'Embarque'
	@ 1,00 VTSAY "Filial:" VTGet cEmpresa pict '@!' Valid VldFilial() F3 "SM0"
	@ 1,15 VTSAY cNomEmp
	@ 2,00 VTSAY "Pedido:" VTGet cPedido pict '@!' Valid VldPedido() F3 "SC5" //'Nota :'
	VTRead
	
   	If VtLastKey() == 27                    
		Exit
	EndIf
	
	lFlag := .T.
 	Separacao()
EndDo  

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldFilial  บ Autor ณ Genilson M Lucas   บ Data ณ  12/06/18  บฑฑ
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ00ฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldPedido  บ Autor ณ Genilson M Lucas   บ Data ณ  12/06/18   บฑฑ
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

nOpcao	:= '1'

//VALIDA PEDIDO E FAZ ATUALIZAวรO
SC5->(dbSetOrder(1))
If !SC5->(dbSeek(cEmpresa+cPedido ))
	VTAlert('Pedido nao cadastrado.','Aviso',.T.,3000,4) //"Nota fiscal nao cadastrada"###"Aviso"
	VTKeyBoard(chr(20))
	Return .F.
Else
	
	//INFORMAวรO SE PEDIDO ESTม COM DIVERSOS SEPARADORES
	If ALLTRIM(SC5->C5_X_SEPAR) == 'ACDP01'
		nOpcao	:= '2'
	EndIf	
	
	//VALIDAวีES DO PEDIDO PARA EFETUAR CONFERสNCIA
	If SC5->C5_X_STAPV == '1' .OR. SC5->C5_X_STAPV == 'A'
	   RecLock("SC5",.F.)
			SC5->C5_X_DTISP	:= Date()
			SC5->C5_X_HRISP	:= time()
			SC5->C5_X_STAPV := '2'
			IF nOpcao == '1'
				SC5->C5_X_SEPAR	:= cCodOpe
				SC5->C5_X_CFSEP	:= '1' //INICIADA
			Else
				SC5->C5_X_CFSEP	:= '4' //INICIADA
			EndIf
			
		SC5->(MsUnlock())	
	
	ElseIf nOpcao == '1'
		//EM PAUSA E  ( SEPARAวรO INICIADA OU CONFERERสNCIA INICADA )
		If SC5->C5_X_CFSEP == '2' .AND. (SC5->C5_X_STAPV == '2' .OR. SC5->C5_X_STAPV == '4')
			RecLock("SC5",.F.)
				SC5->C5_X_CFSEP	:= '1' //INICIADA
			SC5->(MsUnlock())	
	
		//PEDIDO EM SEPARAวรO
		ElseIf SC5->C5_X_CFSEP == '1' .and. ALLTRIM(SC5->C5_X_SEPAR) <> ALLTRIM(cCodOpe)
			VTAlert('Pedido em separacao.','Aviso',.T.,4000,4)
			VTKeyBoard(chr(20))
			Return .F.			
		ElseIf SC5->C5_X_STAPV <> '2' .AND. SC5->C5_X_STAPV <> '4' 
			VTAlert('Pedido nao liberado ou ja separado.','Aviso',.T.,4000,4)
			VTKeyBoard(chr(20))
			Return .F.
		ElseIf ALLTRIM(SC5->C5_X_SEPAR) <> ALLTRIM(cCodOpe)
			VTAlert('Pedido nao liberado ou ja separado.','Aviso',.T.,4000,4)
			VTKeyBoard(chr(20))
			Return .F.
		EndIf
	EndIf

EndIf

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Separacao บAutor  ณ Genilson M Lucas   บ Data ณ  12/06/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a separa็ใo do pedido de vendas.	        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Separacao()


Local cQuery	:= ''
Local cTxtSC6	:= ''

While lFlag

	//ALTERAR PARA NรO RODAR NOVAMENTE, SOMENTE SE PULAR PRODUTO
	lFlag := .F.
	
	If nOpcao	== '1'
		cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_DESCRI, C6_X_VCXIM, C6_X_SEPAR, B1_X_LOCAL "
		cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
		cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
		cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
		cQuery	+= " WHERE C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' AND C6_X_VCXIM > 0 AND C6.D_E_L_E_T_ = '' "
		cQuery	+= " AND C6_X_SEPAR <> C6_X_VCXIM AND C6_X_RESID = '' "
		cQuery	+= " ORDER BY B1_X_LOCAL "
	Else	
		
		cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_DESCRI, C6_X_VCXIM, C6_X_SEPAR, B1_X_LOCAL "
		cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
		cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
		cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
		cQuery	+= " WHERE C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' AND C6_X_VCXIM > 0 AND C6.D_E_L_E_T_ = '' "
		cQuery	+= " AND C6_X_SEPAR <> C6_X_VCXIM AND C6_X_RESID = '' AND C6_X_OPERA = '"+cCodOpe+"' "
		cQuery	+= " ORDER BY B1_X_LOCAL "
	EndIf
		
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC6",.T.,.T.)
	
	
	// Posiciona no topo
	TMPSC6->(DbGoTop())
	While !Eof()
	
		cProduto	:= TMPSC6->C6_PRODUTO
		cItem		:= TMPSC6->C6_ITEM
		cLocal		:= Posicione("SB1",1,xFilial("SB1")+TMPSC6->C6_PRODUTO,"B1_X_LOCAL")
		nVolSep		:= TMPSC6->C6_X_VCXIM - TMPSC6->C6_X_SEPAR
		
		VTClear()
		@ 0,00 VTSAY alltrim(substr(cNomEmp,1,8)) + "- PV: " + cPedido
		@ 1,00 VTSAY 'Endereco: '+ cLocal
		@ 2,00 VTSAY 'Qtd de Volume: '+ alltrim(transform(nVolSep,"@E 9,999"))
		@ 3,00 VTSAY 'Produto: '+ cProduto
		
		If nVolSep <= 3
			
			For i := 1 to nVolSep
				@ 5,00 VTSAY 'Confirme o Produto'
				@ 6,00 VTGET cEtiqVol pict '@!' Valid VldEtiq(1)
				@ 7,00 VTSAY alltrim(transform(I,"@E 9,999"))+' / '+alltrim(transform(nVolSep,"@E 9,999"))
				VTRead
			
				If VTLastkey() == 27
					If VTYesNo("Confirma sair da Separacao?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
						Finaliza()
						Return .F.
					Else
						i--
						Loop
					EndIf	
				EndIf	
				
				If lCorta .or. lPula	
					Exit
				EndIf
				
				nQuant++
			Next i
			
		//SEPARAวรO DE PRODUTO COM MAIOR DE 100 UNIDADES
		Else
			
			@ 5,00 VTSAY 'Endereco:'
			@ 5,10 VTGET cEtiqEnd 	pict '@!' Valid VldEnd()
			@ 6,00 VTSAY 'Produto: '
			@ 6,10 VTGET cEtiqVol 	pict '@!' Valid VldEtiq(2)
			VTRead
			
			If VTLastkey() == 27
				If VTYesNo("Confirma sair da Separacao?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
					Finaliza()
					Return .F.
				Else
					Loop
				EndIf	
			EndIf	
			
			If !lCorta .AND. !lPula	
		
				@ 7,00 VTSAY 'Quant.:  '
				@ 7,10 VTGET nQuant		pict '@E 999999,999' Valid VldQtd(nQuant)
				VTRead
				
				If VTLastkey() == 27
					If VTYesNo("Confirma sair da Separacao?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
						Finaliza()
						Return .F.
					Else
						Loop
					EndIf	
				EndIf	
				
			EndIf
				
		EndIf
		
		//ATUALIZA DADOS DO PRODUTO SEPARADO
		cTxtSC6 := " UPDATE "+RetSqlName("SC6")+" SET C6_X_SEPAR = ("+transform(nQuant,"@E 9,999") +" +C6_X_SEPAR) "
		cTxtSC6 += " WHERE D_E_L_E_T_ = '' AND C6_PRODUTO = '"+cProduto+"' AND C6_ITEM = '"+ cItem +"' AND "
		cTxtSC6 += " C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' "
		TcSqlExec(cTxtSC6)
		
		/*
		DBSelectarea("SC6")
		DBSetOrder(1)
		DBSeek(cEmpresa+cProduto + cItem
		
		Reclock("SC6",.F.)
			SC6->C6_X_SEPAR += ("+transform(n,"@E 9,999") +" +C6_X_SEPAR) 
		msunlock() 
		*/
		
		If lCorta
			VTAlert('Corte efetuado.','CORTE',.T.,3000,1)
			lCorta	:= .F.	
		ElseIf lPula
			VTAlert('Produto pendente de separacao.','PULA',.T.,3000,1)
			lPula	:= .F.
		Else
			VTAlert('Produto Separado.','Confirmacao',.T.,3000,1)	
		EndIf
		
		nQuant		:= 0
		cEtiqEnd		:= SPACE(12)
		cEtiqVol	:= SPACE(15)
		VtClearGet("cEtiqEnd")
		VtClearGet("cEtiqVol")  // Limpa o get
		
		//VAI PARA O PRำXIMO REGISTRO
		TMPSC6->(DbSkip())
	EndDo	
	
	
	//FINALIZADO TODA SEPARAวรO E SEM PULAR PRODUTO
	If Eof() .AND. !lFlag
	
		//OPERADOR ฺNICO
		If nOpcao	== '1'
			If SC5->C5_X_STAPV $ "2/4"
		
				RecLock("SC5",.F.)
				SC5->C5_X_DTFSP	:= Date()
				SC5->C5_X_HRFSP := time()
				SC5->C5_X_CFSEP	:= '3'//FINALIZADO
				If SC5->C5_X_STAPV = '2'
					SC5->C5_X_STAPV := "3" 
				EndIf		
				SC5->(MsUnlock())
					
			EndIf
			
			cEmpresa	:= SPACE(04)
			cNomEmp		:= SPACE(10)
			cPedido		:= Space(TamSX3("C5_NUM")[01])
			cEtiqVol	:= SPACE(15)
			VtClearGet("cEmpresa")
			VtClearGet("cPedido")
			VtClearGet("cEtiqVol")
			VtClearBuffer()
			VTAlert('Separacao finalizada com sucesso.','Confirmacao',.T.,6000,2)
		
		//ORDEM DE SEPARAวรO QUEBRADA
		Else
		
			cQuery	:= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6_ITEM, C6_DESCRI, C6_X_VCXIM, C6_X_SEPAR, B1_X_LOCAL "
			cQuery	+= " FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK)  "
			cQuery  += " INNER JOIN "+RetSqlName("SC9")+" C9 WITH(NOLOCK) ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = ''  "
			cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
			cQuery	+= " WHERE C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' AND C6_X_VCXIM > 0 AND C6.D_E_L_E_T_ = '' "
			cQuery	+= " AND C6_X_SEPAR <> C6_X_VCXIM AND C6_X_RESID = '' "
			cQuery	+= " ORDER BY B1_X_LOCAL "
			
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPFIM",.T.,.T.)
			
			If TMPFIM->(EOF())
				If SC5->C5_X_STAPV $ "2/4"
			
					RecLock("SC5",.F.)
					SC5->C5_X_DTFSP	:= Date()
					SC5->C5_X_HRFSP := time()
					SC5->C5_X_CFSEP	:= '3'//FINALIZADO
					If SC5->C5_X_STAPV = '2'
						SC5->C5_X_STAPV := "3" 
					EndIf		
					SC5->(MsUnlock())
						
				EndIf
				VTAlert('Separacao finalizada com sucesso.','SEGREGADO',.T.,6000,2)
			Else
				VTAlert('Pedido segregado pendente de finalizacao.','SEGREGADO',.T.,6000,2)
			EndIf
			
			cEmpresa	:= SPACE(04)
			cNomEmp		:= SPACE(10)
			cPedido		:= Space(TamSX3("C5_NUM")[01])
			cEtiqVol	:= SPACE(15)
			VtClearGet("cEmpresa")
			VtClearGet("cPedido")
			VtClearGet("cEtiqVol")
			VtClearBuffer()
			
			TMPFIM->(DbCloseArea())
			
		EndIf
	EndIf
	
	TMPSC6->(DbCloseArea())

EndDo

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEtiq บAutor  ณ Genilson M Lucas 		บ Data ณ  13/06/18  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida etiqueta do volume		    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldEtiq(nOpcao)
	
If Empty(cEtiqVol)	
	Return .f.
EndIf

//******************************************
// REGISTRA CORTE DO PRODUTO
//******************************************
If ALLTRIM(cEtiqVol) == 'C'
	If VTYesNo("Confirma CORTE do Produto?",'Aviso',.T.)
		If nOpcao == 1
			@ 5,00 VTSAY 'Informar Endereco'
			@ 6,00 VTGET cEtiqEnd pict '@!' Valid VldEnd()
			VTRead
		EndIf
		
		cTxtSC6 := " UPDATE "+RetSqlName("SC6")+" SET C6_X_RESID = 'R' "
		cTxtSC6 += " WHERE D_E_L_E_T_ = '' AND C6_PRODUTO = '"+cProduto+"' AND C6_ITEM = '"+ cItem +"' AND "
		cTxtSC6 += " C6_NUM = '"+cPedido+"' AND C6_FILIAL = '"+cEmpresa+"' "
		TcSqlExec(cTxtSC6)
		
		lCorta		:= .T.
		cEtiqEnd	:= SPACE(12)
		cEtiqVol	:= SPACE(15)
		VtClearGet("cEtiqEnd")  // Limpa o get
		VtClearGet("cEtiqVol")  // Limpa o get
		Return .T.
	Else
		cEtiqVol	:= SPACE(15)
		VtClearGet("cEtiqVol")
		Return .F.
	EndIf
EndIf

//******************************************
// PULA PRODUTO PARA VOLTAR NO FINAL
//******************************************
If ALLTRIM(cEtiqVol) == 'P'
	
	If VTYesNo("Confirma PULAR o Produto?",'Aviso',.T.) //'Confirma a saida?'###'Atencao'
		If nOpcao == 1
			@ 5,00 VTSAY 'Informar Endereco'
			@ 6,00 VTGET cEtiqEnd pict '@!' Valid VldEnd()
			VTRead
		EndIF
		
		lFlag		:= .T. // PARA VOLTAR AO INICIO
		lPula		:= .T. // REGISTRA PARA PULAR PRODUTO
		cEtiqEnd	:= SPACE(12)
		cEtiqVol	:= SPACE(15)
		VtClearGet("cEtiqEnd")  // Limpa o get
		VtClearGet("cEtiqVol")  // Limpa o get

		Return .T.
	Else
		cEtiqVol	:= SPACE(15)
		VtClearGet("cEtiqVol")
		Return .F.
	EndIf
EndIf

//******************************************
// REGISTRA CONFERสNCIA DO PRODUTO
//******************************************
SB1->(DbSetOrder(5))
SB1->(DbSeek(xFilial('SB1')+cEtiqVol ))
If ALLTRIM(SB1->B1_COD) == ALLTRIM(cProduto) 

	//VTBEEP(1)
	VtClearBuffer()
	VTKeyBoard(chr(20))
	lRet := .t.	
Else
	VTAlert('Produto incorreto.','Aviso',.T.,2000,3)
	If IsTelNet()
		cEtiqVol	:= SPACE(15)
		VtClearGet("cEtiqVol")  // Limpa o get
	Endif
	lRet :=  .f.
EndIf	

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEnd บAutor  ณ Genilson M Lucas 		บ Data ณ  13/06/18  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Endere็o.    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldEnd()

Local lRet	:= .T.

If Empty(cEtiqEnd)	
	Return .f.
EndIf

If ALLTRIM(cEtiqEnd) == 'E'	
	
	If ALLTRIM(cLocal) <> ''
		VTAlert('Endereco incorreto, favor verificar.','Atencao',.T.,3000,5)
		cEtiqEnd	:= SPACE(12)
		VtClearGet("cEtiqEnd")  // Limpa o get
		lRet	:= .F.
	EndIf
	//Return .f.
ElseIf ALLTRIM(cEtiqEnd) <> ALLTRIM('5*A'+cLocal)
	
	VTAlert('Endereco incorreto, favor verificar.','Atencao',.T.,3000,5)
	cEtiqEnd	:= SPACE(12)
	VtClearGet("cEtiqEnd")  // Limpa o get
	lRet	:= .F.

EndIf
	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldQtd บAutor  ณ Genilson M Lucas 		บ Data ณ  13/06/18  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida quantidade digitada.		    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldQtd(nQuantV)


If  nQuantV <> nVolSep  
	VTAlert('Quantidade informada DIFERENTE do solicitado.','QUANTIDADE',.T.,3000,5)
	nQuant		:= 0
	Return .F.
EndIf
	
Return .T.



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

cEmpresa	:= SPACE(04)
cNomEmp		:= SPACE(10)
cPedido		:= Space(TamSX3("C5_NUM")[01])
cEtiqEnd	:= SPACE(12)
cEtiqVol	:= SPACE(15)
nQuant:= 0
VtClearGet("cEmpresa")
VtClearGet("cPedido")
VtClearGet("cEtiqEnd")
VtClearGet("cEtiqVol")

RecLock("SC5",.F.)
	SC5->C5_X_CFSEP	:= '2'//EM PAUSA
SC5->(MsUnlock())

VtClearBuffer()
TMPSC6->(DbCloseArea())

Return .T.
