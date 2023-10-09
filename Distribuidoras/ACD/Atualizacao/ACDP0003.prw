#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#include "apvt100.ch"
#include "sigaacd.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AACD01    ³ Autor ³ GENILSON             ³ Data ³ 12/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inventário pelo coletor de Dados.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ACD               	    		    			          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// CRIAR INDICE LOCAL + LOCALIZ
User Function ACDP0003()

Local lContagem		:= .T.
Local i				:= 1
Local nQtd1			:= 0

Private cCodBar     := Space(15)
Private cProduto	:= Space(15)
Private cLocalEtiq 	:= Space(03)
Private cLocal  	:= Space(02)
Private cEnder  	:= Space(15)
Private nQtd	  	:= 0   

cUser		:= __CUSERID
cNomeUser	:= SUBSTR(UsrFullName(__CUSERID),1,15)
  
While .T.
	VTClear()
	@ 0,00 VTSAY  "Ender.:"   VTGet cLocalEtiq PICTURE '@!' Valid !Empty(cLocalEtiq) .and. VlLocal()
	@ 0,13 VTSAY  "-" VTGet cEnder  PICTURE '@!' Valid !Empty(cEnder) .AND. VlEndereco()   
	@ 1,00 VTSAY  "Produto:"  VTGet cCodBar    PICTURE "@!" Valid !Empty(cCodBar) .AND. VlProduto()   
	@ 2,00 VTSAY  "Qtd:" VTGet nQtd   PICTURE '@E 99999' VALID VlQtd()
	
	VTRead
	
	If !EMPTY(cCodBar) .and. !EMPTY(cEnder) .and. !EMPTY(cLocal)
		If VTYesNo("Deseja gravar dados","Confirmação")
			
			dbSelectArea("SB7")
			While !eof() .and. SB7->B7_LOCAL == cLocal .and. ALLTRIM(SB7->B7_LOCALIZ) == ALLTRIM(cEnder)
				If EMPTY(SB7->B7_COD)
					//DADOS GERADOS PARA O INVENTÁRIO
					RecLock("SB7",.F.)
					SB7->B7_COD			:= cProduto
					SB7->B7_QUANT   	:= nQtd   
					SB7->B7_ORIGEM		:= "COLETOR"
					SB7->B7_DATA		:= DDATABASE
					SB7->B7_X_USER		:= cUser
					SB7->B7_X_NOME		:= cNomeUser
					MsUnLock()
					VTBeep(1)
					
					lContagem			:= .F.
					
					If i == 2 .and. nQtd1 <> nQtd
						RecLock("SB7",.T.)
						SB7->B7_LOCAL	:= cLocal
						SB7->B7_LOCALIZ	:= cEnder
						SB7->B7_CONTAGE	:= '3'
						SB7->B7_DOC		:= '022019'
						MsUnLock()
					EndIf
					
					Exit
				
				ElseIf ALLTRIM(SB7->B7_COD)	<> ALLTRIM(cProduto)
					VTBEEP(2)
					VTALERT("Produto Divergente da Primeira Contagem","ATENCAO",.T.,3000)
					lContagem			:= .F.
					Exit					
				ElseIf SB7->B7_X_USER == cUser
					VTBEEP(2)
					VTALERT("Usuario ja registrou contagem para esse endereco.","ATENCAO",.T.,3000)
					lContagem			:= .F.
					Exit
				EndIf
				
				i++
				nQtd1	:= SB7->B7_QUANT// REGISTRA PRIMEIRA CONTAGEM
				 
				SB7->(DbSkip())
			EndDo
					
			If lContagem		
				VTBEEP(2)
				VTALERT("Contagem ja finalizada para esse endereco.","ATENCAO",.T.,3000)
			EndIf
					
		EndIf
		
		//LIMPA VARIAVES TELA
		cCodBar		:= Space(15)
		cLocalEtiq	:= Space(03)
		cLocal  	:= Space(02)
		cEnder  	:= Space(15)
		nQtd	  	:= 0

		VtClearGet("cCodBar")
		VtClearGet("cLocalEtiq")
		VtClearGet("cLocal")
		VtClearGet("cEnder")

		cProduto	:= SPACE(15)		
		lContagem	:= .T.
		nQtd1		:= 0
		I			:= 1
		
		Loop
		//Else
		//VTBEEP(3)
		//VTALERT("Dados nao foram gravados.","ATENCAO",.T.,2000)
	EndIf
	
	If VTLastkey() == 27
		If VTYesNo("Confirma sair do Inventario?",'Aviso',.T.)
			Return .F.
		EndIf
	Else
		//LIMPA VARIAVES
		cCodBar		:= SPACE(15)
		cLocalEtiq	:= Space(03)
		cLocal  	:= Space(02)
		cEnder  	:= Space(15)
		nQtd	  	:= 0
		
		VtClearGet("cCodBar")
		VtClearGet("cLocalEtiq")
		VtClearGet("cLocal")
		VtClearGet("cEnder")
		
		cProduto	:= SPACE(15)
				
		Loop
	EndIf
EndDo


Return()



//*****************************************************************
// VALIDA LOCAL DIGITADO								         *
//*****************************************************************
Static Function VlLocal()  

Local lValLocal := .F.

If LEFT(cLocalEtiq,1) == "5"
	cLocal	:= '01'
	lValLocal := .T.    
	
ElseIf LEFT(cLocalEtiq,1) == "4"
	cLocal	:= '02'
	lValLocal := .T.      

ElseIf LEFT(cLocalEtiq,1) == "6"
	cLocal	:= '03'
	lValLocal := .T.      
	   
Else
	VTBEEP(2)
	VTALERT("Armazem informado nao existe.","ATENCAO",.T.,3000)
	cLocalEtiq	:= SPACE(03)
	VtClearGet("cLocalEtiq")
EndIf

Return(lValLocal)



//*****************************************************************
// VALIDA PRODUTO DIGITADO E RETORNA COM AS INFORMAÇÕES         *
//*****************************************************************
Static Function VlEndereco()  

Local lValEnd := .F.


If SB7->(DbSetOrder(04), DbSeek( xFilial("SB7")+cLocal+cEnder, .F. ) )
	
	lValEnd := .T.         
	
Else
	VTBEEP(2)
	VTALERT("Registro nao localizado.","ATENCAO",.T.,3000)
	cEnder		:= SPACE(15)
	VtClearGet("cEnder")
EndIf

Return(lValEnd)



//*****************************************************************
// VALIDA PRODUTO DIGITADO E RETORNA COM AS INFORMAÇÕES         *
//*****************************************************************
Static Function VlProduto()  

Local lVal := .F.

If Alltrim(cCodBar) $ ("Z")
	@ 4,00 VTSAY  "ZERADO"
	cProduto := If(Alltrim(cCodBar)=='Z','ZERADO','DIVERSOS')
	lVal := .T. 
		
ElseIf Len(Alltrim(cCodBar)) == 13
	//VTALERT("EAN13","ATENCAO",.T.,5000)
	If SB1->(DbSetOrder(13), DbSeek( xFilial("SB1")+Alltrim(cCodBar),.F. ))
		
		cProduto	:= SB1->B1_COD   
		@ 4,00 VTSAY  "Produto: " + cProduto
		@ 5,00 VTSAY substr(SB1->B1_DESC,1,20)
		@ 6,00 VTSAY substr(SB1->B1_DESC,21,40)
	    
		lVal := .T.         
		
	EndIf
Else
	//VTALERT("DUN14 "+cCodBar,"ATENCAO",.T.,5000)
	
	If SB1->(DbSetOrder(05), DbSeek( xFilial("SB1")+Alltrim(cCodBar),.F. ))
		
		cProduto	:= SB1->B1_COD  
		@ 4,00 VTSAY  "Produto: " + cProduto
		@ 5,00 VTSAY substr(SB1->B1_DESC,1,20)
		@ 6,00 VTSAY substr(SB1->B1_DESC,21,40)
			    
		lVal := .T. 
	EndIf
EndIf

If !lVal
	VTBEEP(2)
	VTALERT("Produto nao existe.","ATENCAO",.T.,3000)
	cCodBar		:= SPACE(15)
	VtClearGet("cCodBar")
EndIf

Return(lVal)



//*****************************************************************
// VALIDA QUANTIDADE DIGITADA							         *
//*****************************************************************
Static Function VlQtd()  

Local lValQtd:= .F.

If nQtd > 0
	lValQtd := .T.
	
ElseIf nQtd = 0 .AND. Alltrim(cCodBar) $ ("Z/D")
	lValQtd := .T.
	
EndIf

Return(lValQtd)

