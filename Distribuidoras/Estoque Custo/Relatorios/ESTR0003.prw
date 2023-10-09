#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ? ESTR0003     ºAutor³ Pedro Lima         			  ?Data ? 12/04/2018 º±?                                     
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ? Impressão do relatório de conferência de devoluções.                   º±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
         
 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					                                       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	 									  ³±±
±±³ 19/04/18	ANDRE VALMIR		12:30 																	  ³±±
±±³ 23/04/18	ANDRE VALMIR		10:10 																	  ³±±
±±³ 29/06/2018  ANDRE VALMIR 	    16:30 ADICIONADO O NUMERO DA PAGINA    									  ³±±
±±³ 																										  ³±±
±±³ 									 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function ESTR0003(lConfAut)
Local dData := ctod('')
Local oHORAC, _ODlg, oSay,oData
Local cHORAC		 := space(5)
Local aRegs := {}

Private nLin		 := 4300
Private lUnderLine   := .F.
Private ArialN6      := TFont():New("Arial"	,,6	,,.F.,,,,,lUnderLine)
Private ArialN6B     := TFont():New("Arial"	,,6	,,.T.,,,,,lUnderLine)
Private ArialN8      := TFont():New("Arial"	,,8	,,.F.,,,,,lUnderLine)
Private ArialN8B     := TFont():New("Arial"	,,8	,,.T.,,,,,lUnderLine)
Private ArialN9B     := TFont():New("Arial"	,,9	,,.T.,,,,,lUnderLine)
Private ArialN10     := TFont():New("Arial"	,,10,,.F.,,,,,lUnderLine)
Private ArialN10B    := TFont():New("Arial"	,,10,,.T.,,,,,lUnderLine)
Private ArialN12     := TFont():New("Arial"	,,12,,.F.,,,,,lUnderLine)
Private ArialN12B    := TFont():New("Arial"	,,12,,.T.,,,,,lUnderLine)
Private ArialN14BU   := TFont():New("Arial"	,,14,,.T.,,,,.T.,.T.)
Private ArialN14     := TFont():New("Arial"	,,14,,.F.,,,,,lUnderLine)
Private ArialN15     := TFont():New("Arial"	,,15,,.F.,,,,,lUnderLine)
Private ArialN14B    := TFont():New("Arial"	,,14,,.T.,,,,,lUnderLine)
Private ArialN18     := TFont():New("Arial"	,,18,,.F.,,,,,lUnderLine)
Private ArialN18B    := TFont():New("Arial"	,,18,,.T.,,,,,lUnderLine)
Private ArialN20     := TFont():New("Arial"	,,20,,.F.,,,,,lUnderLine)
Private ArialN20B    := TFont():New("Arial"	,,20,,.T.,,,,,lUnderLine)
Private ArialN22     := TFont():New("Arial"	,,22,,.F.,,,,,lUnderLine)
Private ArialN24     := TFont():New("Arial"	,,24,,.F.,,,,,lUnderLine)
Private ArialN24B    := TFont():New("Arial"	,,24,,.T.,,,,,lUnderLine)
Private ArialN28     := TFont():New("Arial"	,,28,,.F.,,,,,lUnderLine)
Private Times14	  	 := TFont():New("Times New Roman",,14   ,,.T.,,,,,.F. )
Private Times20      := TFont():New("Times New Roman",,20   ,,.T.,,,,,.F. )
Private Arial08		 := TFont():New("Arial"          ,,08   ,,.T.,,,,,.F. )
Private Arial12	  	 := TFont():New("Arial"          ,,12   ,,.T.,,,,,.F. )
Private oFont		 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Private cPerg := "DISDEV0001"

Default lConfAut:= .f.

//AjustaSX1(cPerg)

//IF !Pergunte(cPerg,.T.)  // Pergunta no SX1
//   Return
//Endif

   

If !lConfAut
	lConfAut := MsgYesNo('Deseja gerar a Conferência de Devolução?')
Endif       

       If   lConfAut
			
			Imprime()
			SET DEVICE TO SCREEN
			MS_FLUSH()             
			
			Return()  
			
		Endif            

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFun‡„o    ³RUNREPORT ?Autor ?                   ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescri‡„o ?Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±?
±±?         ?monta a janela com a regua de processamento.               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Imprime2()
SET DEVICE TO SCREEN
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFun‡„o    ³RUNREPORT ?Autor ?                   ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescri‡„o ?Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±?
±±?         ?monta a janela com a regua de processamento.               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function Imprime()

Local aDesc			:= {}
Local cQuery		:= ""
Local nY			:= 0
Local nI			:= 0
Local aAreaSD1      := SD1->(GetArea())
Local aAreaSA1      := SA1->(GetArea())
Local aAreaSA2      := SA2->(GetArea())
Local aAreaSF1      := SF1->(GetArea())
Local aAreaSB1      := SB1->(GetArea())   
Local nValTotDes	:= 0
Local nTotBom		:= 0
Local nTotRuim		:= 0
Local nTotFalta		:= 0
Local nTotqUAREN	:= 0

Private cCodPED		:= ""
Private oPrn 
 
//SD1->(DbSetOrder(1))

		If Select( "TRBSD1" ) <> 0
			TRBSD1->(DbCloseArea())
		EndIf
		

cQuery	:= " Select R_E_C_N_O_ RECSD1 "
cQuery	+= " from " + RETSqlName("SD1") + " SD1  "
cQuery 	+= " WHERE 	SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery  += " 				AND SD1.D1_DOC = '"+SF1->F1_DOC+"' "
cQuery  += " 				AND SD1.D1_SERIE = '"+SF1->F1_SERIE+"' "
cQuery  += " 				AND SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"' "
cQuery  += " 				AND SD1.D1_LOJA = '"+SF1->F1_LOJA+"'  "
cQuery  += " 				AND SD1.D_E_L_E_T_ <> '*' "
cQuery  += "ORDER BY SD1.D1_DOC+SD1.D1_COD+SD1.D1_LOTECTL+SD1.D1_DTVALID "
/*
cQuery	:= " Select R_E_C_N_O_ RECSD1 "
cQuery	+= " from " + RETSqlName("SD1") + " SD1  "
cQuery 	+= " WHERE 	SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery  += " 				AND SD1.D1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery  += " 				AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
cQuery  += " 				AND SD1.D1_DOC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery  += " 				AND SD1.D1_SERIE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery  += " 				AND SD1.D1_FORNECE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery  += " 				AND SD1.D1_LOJA BETWEEN '  ' AND 'ZZZ' "
cQuery  += " 				AND SD1.D_E_L_E_T_ <> '*' "
cQuery  += "ORDER BY SD1.D1_DOC+SD1.D1_COD+SD1.D1_LOTECTL+SD1.D1_DTVALID " 
*/
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBSD1", .F., .T.)  

oPrn := TMSPrinter():New()
oPrn:Setup()
oPrn :SetPortrait()
nCent := 11 
cItem := "00"
nCent := 4.5
cTravamento := "" 
while !TRBSD1->(EOF())

 	SD1->(DbGOTO(TRBSD1->RECSD1)) 	
 //	If cTravamento <> SD1->(D1_DOC+D1_COD+D1_LOTECTL+DTOS(D1_DTVALID) )
 		nI++
 		SA2->(DbSetOrder(1))
 		SA2->(DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA) )
 		
 		SA1->(DbSetOrder(1))
 		SA1->(DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA) )	
 		
 		SB1->(DbSetOrder(1))
 		SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD)) 
 		
 		If nLin > 3100 
 			Cabec()
 			nCent := 4.5 
 			nLin += 20
 		Endif
	    DbSelectArea("NNR")
	    NNR->(DbSetOrder(1)) // NNR_FILIAL + NNR_CODIGO
	    NNR->(DbSeek(xFilial("SD1") + SD1->D1_LOCAL))
 		aDesc := U_Trata(SB1->B1_DESC,40)
 		
 		nValTotDes := SD1->D1_TOTAL - SD1->D1_VALDESC
 		nValUnit := nValTotDes / SD1->D1_QUANT 

 		
		oPrn:Say( nLin + 05, 0050, sd1->d1_local+' '+SD1->D1_COD,  ArialN10B)   
 		oPrn:Say( nLin + 05, 0350, If(!Empty(aDesc[1][1]),Substr(aDesc[1][1],1,40),Substr(SB1->B1_DESC,1,40)) ,  ArialN10B) 
 	    oPrn:Say( nLin + 05, 1250, STR(SD1->D1_QUANT),  ArialN10B) 
 		//oPrn:Say( nLin + 05, 1500, TRANSFORM(SD1->D1_VUNIT,"@E 999,999.99"),  ArialN10B) 
 		oPrn:Say( nLin + 05, 1500, TRANSFORM(nValUnit,"@E 999,999.99"),  ArialN10B) 
 		oPrn:Say( nLin + 05, 1750, STR(nValTotDes),  ArialN10B) 
		 do case
			case SD1->D1_LOCAL = '02'
				estado := 'BOM'
				nTotBom		+= nValTotDes
			case SD1->D1_LOCAL = '03'
				estado := 'RUIM'
				nTotRuim	+= nValTotDes
			case SD1->D1_LOCAL = 'AN'
				estado := 'SEM FISICO(FALTA)'
				nTotFalta	+= nValTotDes
			case SD1->D1_LOCAL = '90'
				estado := 'QUARENTENA'
				nTotqUAREN 	+= nValTotDes
			OTHERWISE
			 	estado := 'ERR'
		 endcase
 		oPrn:Say( nLin + 05, 2170,estado,  ArialN10B) 
 		nCent+= 4.7		   
 		nLin += 90     

 //	Endif

 	//cTravamento := SD1->( D1_DOC+D1_COD+D1_LOTECTL+DTOS(D1_DTVALID) )
 	
	TRBSD1->(DBSkip())
End  

nLin += 080
If nLin < 3200 //3400 
	oPrn:Box( nLin-2, 0028, nLin-1, 2350 )
	nLin += 100
	oPrn:Say( nLin + 005, 0050, "EMITIDO POR:     ________________________" ,  ArialN10B) 
	
	oPrn:Say( nLin + 140, 0050, "TOTAL BOM R$: "+Str(nTotBom) ,  ArialN10B) 	
	oPrn:Say( nLin + 200, 0050, "TOTAL RUIM R$: "+Str(nTotRuim) ,  ArialN10B) 
	oPrn:Say( nLin + 280, 0050, "TOTAL FALTA R$: "+Str(nTotFalta) ,  ArialN10B) 
	oPrn:Say( nLin + 350, 0050, "TOTAL qUARENTENA R$: "+Str(nTotQUAREN) ,  ArialN10B) 

Else
	Cabec() 
	
	nLin	+= 100
	oPrn:Say( nLin + 005, 0050, "EMITIDO POR:     ________________________" ,  ArialN10B) 

	oPrn:Say( nLin + 120, 0050, "TOTAL BOM R$: "+Str(nTotBom) ,  ArialN10B) 	
	oPrn:Say( nLin + 200, 0050, "TOTAL RUIM R$ "+Str(nTotRuim) ,  ArialN10B) 
	oPrn:Say( nLin + 280, 0050, "TOTAL FALTA R$ "+Str(nTotFalta) ,  ArialN10B) 
	oPrn:Say( nLin + 350, 0050, "TOTAL qUARENTENA R$ "+Str(nTotqUAREN) ,  ArialN10B) 

Endif

oPrn:EndPage()
//oPrn:Preview()
oPrn:Print()
TRBSD1->(DbCloseArea())

RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aAreaSB1)

Return  



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFun‡„o    ³Cabec     ?Autor ?                   ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescri‡„o ?Header das colunas do Relatorio.                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function Cabec( )   

Local cLogo	:= FisxLogo("1")

oPrn:EndPage()
oPrn:StartPage()
NumPag()
nLin := 120
oPrn:Box( nLin-20, 0028, nLin+120, 2350 )
oPrn:Say( nLin-100, 0030, SM0->M0_FILIAL				, ArialN20B, 100 ) 
oPrn:Say( nLin+10, 0230, "Conferência de Devolução"	, ArialN20B, 100 ) 

//oPrn:SayBitmap( nLin-10, 1850, cLogo, 510, 170 )  
//PAC->(DbSetOrder(2))   
//PAC->(DbSeek(xFilial("PAC")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
//MSBAR("CODE128",3.2 ,12,ALLTRIM(PAC->PAC_CONF),oPrn,.F.,,.T.,0.030,1,.T.,,"CODE128",.F.)	

oPrn:Say( nLin + 150, 0030, "CLIENTE:", ArialN12B, 100 )
oPrn:Say( nLin + 150, 1850, "NFO:", ArialN12B, 100 )  			  
oPrn:Say( nLin + 220, 0030, "NOTA:", ArialN12B, 100 )   
oPrn:Say( nLin + 290, 0030, "EMISSAO:", ArialN12B, 100 )
oPrn:Say( nLin + 290, 1850, "DIGITACAO:", ArialN12B, 100 )  

oPrn:Say( nLin + 150, 0400, "("+SD1->D1_FORNECE+") "+Substr(SA1->A1_NOME,1,45), ArialN12B, 100 )
oPrn:Say( nLin + 150, 2080, Alltrim(SD1->D1_NFORI) + " / " + Alltrim(SD1->D1_SERIORI) , ArialN12B, 100 )
oPrn:Say( nLin + 220, 0400, Alltrim(SD1->D1_DOC) + " / " + Alltrim(SD1->D1_SERIE) , ArialN12B, 100 )
oPrn:Say( nLin + 290, 0400, DTOC(SD1->D1_EMISSAO), ArialN12B, 100 ) 
oPrn:Say( nLin + 290, 2140, DTOC(SD1->D1_DTDIGIT), ArialN12B, 100 ) 

nLin := 520                                         

oPrn:Box( nLin-2, 0028, nLin-1, 2350 )   
nLin += 70                                                                                 	
oPrn:Say( nLin + 05, 0050, "CODIGO ",ArialN14B)   
oPrn:Say( nLin + 05, 0350, "DESCRIÇÃO",ArialN14B) 
oPrn:Say( nLin + 05, 1350, "QTD" ,	ArialN14B) 
oPrn:Say( nLin + 05, 1570, "UNIT",	ArialN14B)
oPrn:Say( nLin + 05, 1850, "TOTAL",	ArialN14B)
oPrn:Say( nLin + 05, 2120, "STATUS",ArialN14B)

nLin += 90
oPrn:Box( nLin-2, 0028, nLin-1, 2350 )
		
Return( Nil )  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³TrataMemo   ºAutor  Fernando Amorim(Cafu)Data ? 05/25/14   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

User Function Trata(cMsg, nTotCarac)

Local aLinQuebra := {}
Local aLinMemo := {}

aLinQuebra := VerificaQuebra(cMsg, nTotCarac)

aLinMemo   := VerificaQtdCarac(nTotCarac, aLinQuebra)

// Retorna o array contendo as linhas para impressao
Return aLinMemo    
   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³SAOPREL   ºAutor  ³Microsiga           ?Data ? 05/25/14   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

Static Function VerificaQuebra(cMsg, nTotCarac)

Local aLinQuebra := {}
Local nPosIni := 0
Local nPosFim := 0
Local nPosIniSo := 0
Local nPosFimSo := 0
Local nPosCarac := 0
Local cMsgCort := ''
Local cMsgSobra := ''
Local nTamMsg := 0

// Muda a quebra de linha para o caracter # na string inteira
cMsg := AllTrim(StrTran(cMsg, Chr(13)+Chr(10), '#' ))

cMsgSobra := cMsg

While Len(cMsgSobra) > 0
	
	// Pega a quantidade de caracteres da mensagem
	nTamMsg := Len(cMsgSobra)

	// Busca a posicao do caracter #
	nPosCarac := At('#',cMsgSobra)
	
	// Se encontrar o caracter # adiciona ao array a mensagem cortada conforme o numero de caracteres informado no parametro
	If nPosCarac > 0
	
		nPosIni := 1
		nPosFim := nPosCarac - 1
		
		// Corta a mensagem de acordo com a posicao inicial e final
		cMsgCort := SubStr(cMsgSobra,nPosIni,nPosFim)
		
		// Adiciona a informacao ao array
		Aadd(aLinQuebra, {cMsgCort})
		
		// Faz o calculo da posicao inicial e final para pegar a sobra da mensagem que ainda nao foi cortada
		nPosIniSo := nPosCarac + 1
		nPosFimSo := (nTamMsg - Len(cMsgCort)) - 1
		
		// Pega a sobra da mensagem que ainda nao foi cortada
		cMsgSobra := SubStr(cMsgSobra, nPosIniSo, nPosFimSo)
	
	Else
		
		// Senao encontrar o caracter # adiciona a sobra da mensagem no array
		Aadd(aLinQuebra, {cMsgSobra})
		
		// Limpa a variavel para sair do loop
		cMsgSobra := ''

	EndIf

EndDo

Return aLinQuebra


Static Function NumPag()

nPag := oPrn:NPAGE
oPrn:Say(40,2120,"Página "+Transform(nPag,"99"),ArialN12B,,0)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³SAOPREL   ºAutor  ³Microsiga           ?Data ? 05/25/14   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

Static Function VerificaQtdCarac(nTotCarac, aLinQuebra)

Local aLinMemo := {}
Local nPosIni := 1
Local nPosIniLp := 0
Local nPosFimLp := 0
Local cMsgCort := ''
Local nNumLoop := 0
Local y := 0
Local x := 0
Local cMsgSobra := ''
Local nTamMsg := 0
Local cMsgCort := ''

For y := 1 To Len(aLinQuebra)

	// Se a quantidade de caracteres for maior que a quantidade passada pelo paramentro entao corta a mensagem
	If Len(aLinQuebra[y][1]) > nTotCarac
		nNumLoop := Iif((Len(aLinQuebra[y][1]) % nTotCarac) == 0, Len(aLinQuebra[y][1]) / nTotCarac, Int(Len(aLinQuebra[y][1]) / nTotCarac) + 1) // Arredonda para mais sempre
		nPosIniLp := 1
		nPosFimLp := nTotCarac
		cMsgSobra := aLinQuebra[y][1]
		
		For x := 1 To nNumLoop
			nTamMsg := Len(cMsgSobra) // Pega a quantidade de caracteres que sobraram
			cMsgCort := SubStr(cMsgSobra, nPosIni, nTotCarac) // Corta a mensagem
			Aadd(aLinMemo, {cMsgCort}) // Adiciona a mensagem cortada ao array
			nPosIniLp := nPosFimLp + 1
			nPosFimLp := nPosIniLp + (nTotCarac - 1)
			cMsgSobra := SubStr(aLinQuebra[y][1], nPosIniLp, (nTamMsg - Len(cMsgCort))) // Retira da string o conteudo que ja foi adicionado ao array
		Next x
	Else
		Aadd(aLinMemo, {aLinQuebra[y][1]}) // Senao houver a necessidade de cortar a mensagem novamente o conteudo e inserido direto no array
	EndIf

Next y
	
Return aLinMemo       


Static Function AjustaSX1()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aHelpPor01 := {'Informe o armazem inicial a ser consider' , 'ado na filtragem.                         ', ''}
Local aHelpPor02 := {'Informe o armazem final a ser considerad' , 'o na filtragem.                           ', ''}
Local aHelpPor03 := {'Informe o codigo do produto inicial a   ' , 'ser considerado na filtragem.             ', ''}
Local aHelpPor04 := {'Informe o codigo do produto final a ser ' , 'considerado na filtragem.                 ', ''}
Local aHelpPor05 := {'Informe se deverá deletar a tabela      ' , 'LOG_SLD.                                  ', ''}

PutSx1(cPerg,'01' ,'Emissao de       ?',''				 ,''			 ,'mv_ch1','D'  ,08     ,0      ,0     ,'G','                                ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'  ','')
PutSx1(cPerg,'02' ,'Emissao ate      ?',''				 ,''			 ,'mv_ch2','D'  ,08     ,0      ,0     ,'G','                                ','mv_par02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'  ','')
PutSx1(cPerg,'03' ,'Digitação de     ?',''				 ,''			 ,'mv_ch3','D'  ,08     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'  ','')
PutSx1(cPerg,'04' ,'Digitação Ate    ?',''				 ,''			 ,'mv_ch4','D'  ,08     ,0      ,0     ,'G','                                ','mv_par04','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'  ','')
PutSx1(cPerg,'05' ,'Cliente/For de   ?',''				 ,''			 ,'mv_ch5','C'  ,06     ,0      ,0     ,'G','                                ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SA1','')
PutSx1(cPerg,'06' ,'Cliente/For Ate  ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','                                ','mv_par06','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SA1','')
PutSx1(cPerg,'07' ,'Nota Fiscal de   ?',''				 ,''			 ,'mv_ch7','C'  ,09     ,0      ,0     ,'C','                                ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'               ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SF1','')
PutSx1(cPerg,'08' ,'Nota Fiscal Ate  ?',''				 ,''			 ,'mv_ch8','C'  ,09     ,0      ,0     ,'G','                                ','mv_par08','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SF1','')
PutSx1(cPerg,'09' ,'Serie de         ?',''				 ,''			 ,'mv_ch9','C'  ,03     ,0      ,0     ,'G','                                ','mv_par09','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SF1','')
PutSx1(cPerg,'10' ,'Serie Ate        ?',''				 ,''			 ,'mv_cha','C'  ,03     ,0      ,0     ,'G','                                ','mv_par10','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SF1','')


Return NIL
