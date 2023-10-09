#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³ SLREST20  ³ Autor ³ Genilson M Lucas   ³ Data ³ 15/03/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza impressao de etiqueta de Produto Acabado ou PI     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SALON LINE                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ESTR0002()

Local cCadastro	:= "Impressao Etiqueta PA"
Local oPrn      := TMSPrinter():New(cCadastro)
Local nCol		:= 040
Local oFont5    := TFont():New( "Arial",,11,,.t.,,,,,.F. )
Local aRet		:= {Space(15),Space(10),CTOD("")}
Local nLin 		:= 020


If !Parambox({	{1,"Código do Produto"	,aRet[1],"@!","","SB1","",50,.T.},;
				{1,"Lote"				,aRet[2],"@!","","",""   ,50,.T.},;
				{1,"Dt Validade"		,aRet[3],"@!","","",""   ,50,.T.}},;
				"Impressao Etiquetas para Caixa",@aRet)
		Return
EndIf                                     
	
Dbselectarea("SB1")
If Dbseek(xFilial("SB1")+aRet[1] )
                                                                
	oPrn:SetPortrait()
	oPrn:Setup()
	oPrn:StartPage()
		
	cEncom  := Left(Alltrim(Posicione("SA2",1,xFilial("SA2")+ SB1->B1_PROC,"A2_NOME")),20)
		   			
	oPrn:Say( nLin, nCol, "PRD: " + Alltrim(SB1->B1_COD) + " - " + SB1->B1_TIPO + " || " + cEncom,oFont5,, )
	nLin += 46
	oPrn:Say( nLin, nCol, Alltrim(SB1->B1_DESC),oFont5,, )
	nLin += 46
	oPrn:Say( nLin, nCol,"Qtd Emb: " + alltrim(str(SB1->B1_QE))  ,oFont5,, )
	oPrn:Say( nLin, nCol+260,"Lote: " + alltrim(aRet[2])  ,oFont5,, )
	oPrn:Say( nLin, nCol+620,"Validade: " + DTOC(aRet[3])  ,oFont5,, )
				
	MSBAR("EAN128", 2.1, 1.50, alltrim(SB1->B1_CODBAR), oPrn, .F.,,.T., 0.025,1.00 ,.T.,,, .F. )
							
					
	//oPrn:EndPage()
	MS_FLUSH()
	oPrn:Preview()
Else

	MsgAlert("Nao existem dados a serem exibidos!")
	Return()

End If

Return()