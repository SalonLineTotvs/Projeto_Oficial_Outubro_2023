#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelMan ºAutor³ Andre Valmir / Introde  ºData³ 28/11/2017    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Relatorio emissão de Manifesto							  º±±
±±º			³  															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Salon Line                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß



±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÂÄÄÄÄÂÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      		   						             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                        						        ³±±
±±³ 08/03/18	ANDRE VALMIR		12:30								  						³±±
±±³ 02/04/18	ANDRE VALMIR		14:50 Posicionar a transportadora para buscar da Z1_TRANSP  ³±±
±±³									     								                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/                                                                           

/*
Campos Criados
C5_X_CONCX -> Conferente Caixa
C5_X_CONGR -> Conferente Granel

F2_X_NOMOT -> Nome do Motorista
F2_X_OBSCF -> Observação Conferente
F2_X_RGMOT -> RG do Motorista
F2_X_NRMA  -> Numero do Manifesto 
F2_X_DTMAN -> Data do Manifesto
F2_X_HRMAN -> Hora do Manifesto

Indicice 17 - F2_X_NRMA - > Numero do Manifesto

*/

      
User Function FATR0002(cNrManif)

Private oArial14  	:=	TFont():New("Arial",,14,,.F.,,,,,.F.,.F.)
Private oArial17N  	:=	TFont():New("Arial",,17,,.T.,,,,,.F.,.F.)
Private oArial18  	:=	TFont():New("Arial",,18,,.F.,,,,,.F.,.F.)
Private oArial18N  	:=	TFont():New("Arial",,18,,.T.,,,,,.F.,.F.)
Private oArial20N  	:=	TFont():New("Arial",,21,,.T.,,,,,.F.,.F.)
Private oArial21  	:=	TFont():New("Arial",,21,,.F.,,,,,.F.,.F.)
Private oArial21N  	:=	TFont():New("Arial",,21,,.T.,,,,,.F.,.F.)
Private oPrinter 	:=  Nil
Private cLocal		:=  "C:\Temp\"
Private MV_PAR01	:=  cNrManif

Private nLinX		:= 0
Private nLinY		:= 0
Private nLinDet		:= 0	// Linha Detalhe das NF's
Private nContNF		:= 0	// Contador NF
Private nLinTot		:= 0	// Linha Total	
Private nLinRod		:= 0	// Linha Rodape
Private nLimPag		:= 0	// Limite da Pagina
Private nPesoTCX	:= 0	// Peso Total Caixa
Private nPesoTGR	:= 0 	// Peso Total Granel
Private nQtdTCX		:= 0	// Quantidade Total de Caixa
Private nQtdTGR		:= 0	// Quantidade Total de Granel
Private nQtdTVol	:= 0	// Quantidade Total de Volumes	
Private cNumMan		:= ""	// Numero do Manifesto
Private lImpRod		:= .T.  // Variavel de controle Impressão Rodapé      
Private cDoc		:= ""
Private cSer		:= ""
Private cCli		:= ""
Private cLj			:= ""
Private nPBr		:= 0
Private mPalF		:= 0

nLinX := 0535
cNumMan := Alltrim(MV_PAR01)

cQuery	:= " SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_PBRUTO, F2_X_NRMA, C5_NUM	"
cQuery	+= " FROM SF2020 F2							"
cQuery	+= " INNER JOIN SC5020 C5 ON C5.D_E_L_E_T_ = '' AND C5_NOTA = F2_DOC AND C5_FILIAL = F2_FILIAL "
cQuery	+= " WHERE F2.D_E_L_E_T_ = ''				"
cQuery	+= " AND F2_FILIAL = '"+xFilial("SF2")+"'	"
cQuery	+= " AND F2_X_NRMA = '"+cNumMan+"'			"
cQuery	+= " ORDER BY C5_NOTA " // Ordenação por nota

If Select("TRBR02A") > 0
	TRBR02A->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TRBR02A"

DBSelectArea("TRBR02A")
TRBR02A->(dbGoTop())

ImpCabec()	// Imprimir Cabeçalho Principal
ImpCabNF()	// Imprimir Cabeçalho da NF

nLinDet := nLinX

While TRBR02A->(!EOF()) 
	
	nLinDet += 60
	nLimPag :=  nLinDet

	cDoc	:= TRBR02A->F2_DOC
	cSer	:= TRBR02A->F2_SERIE
	cCli	:= TRBR02A->F2_CLIENTE
	cLj		:= TRBR02A->F2_LOJA
	nPBr	:= TRBR02A->F2_PBRUTO

	
	If nLimPag <= 2105
		ImpDetNF()	// Imprimir Detalhe das NF's
		nContNF++
	Else	                                    
		oPrinter:EndPage()
		oPrinter:StartPage()
	
		NumPag()
	    nLinX	:= 100
	    ImpCabNF()
	    nLinDet := 255
	    ImpDetNF()	// Imprimir Detalhe das NF's
		nContNF++
	Endif 
		
	cQryc	:= " SELECT TOP 1 D2_CLIENTE, D2_LOJA, D2_PEDIDO	"
	cQryc	+= " FROM SD2020									"
	cQryc	+= " WHERE D_E_L_E_T_ = ''							"
	cQryc	+= " AND D2_FILIAL = '"+xFilial("SD2")+"'			"
	cQryc	+= " AND D2_DOC = '"+cDoc+"'						"

	If Select("TRBR02C") > 0
		TRBR02C->( dbCloseArea() )
	EndIf

	TCQUERY cQryc NEW ALIAS "TRBR02C"

	DBSelectArea("TRBR02C")
	TRBR02C->(dbGoTop())

	If Empty(TRBR02C->D2_CLIENTE)
		
		TRBR02C->( dbCloseArea() )

		cQryc	:= " SELECT TOP 1 D2_CLIENTE, D2_LOJA, D2_PEDIDO	"
		cQryc	+= " FROM SD20203									"
		cQryc	+= " WHERE D_E_L_E_T_ = ''							"
		cQryc	+= " AND D2_FILIAL = '"+xFilial("SD2")+"'			"
		cQryc	+= " AND D2_DOC = '"+cDoc+"'						"
		If Select("TRBR02C") > 0
			TRBR02C->( dbCloseArea() )
		EndIf

		TCQUERY cQryc NEW ALIAS "TRBR02C"
		DBSelectArea("TRBR02C")
		TRBR02C->(dbGoTop())

	Endif
	
	DBSelectArea("SC5")
	DBSetOrder(1)
	DBSeek(xFilial("SC5")+TRBR02C->D2_PEDIDO)
	
	nPesoTCX	+=	nPBr
	nQtdTCX		+=	SC5->C5_VOLUME1
	nQtdTGR		+=	SC5->C5_VOLUME2
	
	TRBR02A->(dbSkip())     

Enddo

nQtdTVol	:=	nQtdTCX + nQtdTGR
              
// Valida se vai caber na mesma pagina a linha de Totais
If nLinDet <= 1735    
	nLinTot := nLinDet
	ImpTotal()
Else
	oPrinter:EndPage()
	oPrinter:StartPage()
	oPrinter:Say(2170,0060,"N° Manifesto "+cNumMan,oArial14,,0)
	NumPag()
	nLinX	:= 100
    ImpCabNF()
	nLinTot := 160
	ImpTotal()
	nLinRod := 240
	ImpRodape()
Endif 

If lImpRod
	If nLinTot <= 1435
		nLinRod	:= nLinTot
		ImpRodape()
	Else
		oPrinter:EndPage()
		oPrinter:StartPage()
		oPrinter:Say(2170,0060,"N° Manifesto "+cNumMan,oArial14,,0)
		NumPag()
		nLinX	:= 100
	    ImpCabNF()
		nLinRod := 120	
		ImpRodape()
	Endif          
Endif

oPrinter:Preview()

Static Function ImpCabec()
		
	If oPrinter == Nil
		lPreview	:= .T.
		oPrinter 	:= FWMSPrinter():New("Manifesto N° "+cNumMan,IMP_PDF,.T.,,.T.,.F.,)
		oPrinter:SetPortrait()
		oPrinter:cPathPDF	:= cLocal
		oPrinter:SetPaperSize(DMPAPER_A4)
		oPrinter:SetLandscape() // Paisagem
		oPrinter:StartPage()
		oPrinter:Say(2170,0060,"N° Manifesto "+cNumMan,oArial14,,0)
		NumPag()
	EndIf


	//Variaveis para Busca SZ1 - Controle do Manifesto	
	cMotorista := GetAdvFVal("SZ1","Z1_MOTMA", xFilial("SZ1")+cNumMan)	//Busca Mororista
	cZ1_DTMA   := GetAdvFVal("SZ1","Z1_DTMA" , xFilial("SZ1")+cNumMan)	//Busca Data Manifesto
	cZ1_HRMA   := GetAdvFVal("SZ1","Z1_HRMA" , xFilial("SZ1")+cNumMan)	//Busca Hora Manifesto
	cRGMot     := GetAdvFVal("SZ1","Z1_RGMA" , xFilial("SZ1")+cNumMan)	//Busca RG Mororista
	cPlaca     := GetAdvFVal("SZ1","Z1_PLACA", xFilial("SZ1")+cNumMan)	//Busca PLACA
	cTransp    := GetAdvFVal("SZ1","Z1_TRANSP", xFilial("SZ1")+cNumMan)	//Busca Transportadora
	
	cPallets	:= Transform(GetAdvFVal("SZ1","Z1_PALLETS", xFilial("SZ1")+cNumMan),"99")// QTD DE PALLETS 
	cVeiculo	:= GetAdvFVal("SZ1","Z1_VEICULO", xFilial("SZ1")+cNumMan) // TIPO CAMINHÃO
	cLotacao	:= GetAdvFVal("SZ1","Z1_LOTACAO", xFilial("SZ1")+cNumMan) // LOTAÇÃO
	
	If cVeiculo = 'A'
		cVeiculo := 'A-VAN'
	ElseIf cVeiculo = 'B'
		cVeiculo := 'B-VUC'
	ElseIf cVeiculo = 'C'	
		cVeiculo := 'C-3/4'
	ElseIf cVeiculo = 'D'
		cVeiculo := 'D-TOCO'
	ElseIf cVeiculo = 'E'
		cVeiculo := 'E-TRUCK'
	ElseIf cVeiculo = 'F'
		cVeiculo := 'F-CARRETA'
	ElseIf cVeiculo = 'G'
		cVeiculo := 'G-BITREM'
	ElseIf cVeiculo = 'H'
		cVeiculo := 'H-RODOTREM'
	Else
		cVeiculo := 'I-AÉREO'
	EndIf
	
	oPrinter:Line(0075,0045,0075,3360,,"-1")
	oPrinter:Say(0155,0060,Alltrim(SM0->M0_FILIAL),oArial20N,,0)
	oPrinter:Say(0155,1400,"Emissão de Manifesto",oArial21N,,0)
	oPrinter:Line(0200,0045,0200,3360,,"-1")
	
	oPrinter:Say(0255,0060,"N° Manifesto:",oArial18N,,0)     
	oPrinter:Say(0255,0500,cNumMan,oArial18,,0)                 
	
	oPrinter:Say(0330,0060,"Transportadora:",oArial18N,,0)         
	oPrinter:Say(0330,0500,cTransp+" "+Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"),oArial18,,0)
	
	oPrinter:Say(0405,0060,"Motorista:",oArial18N,,0)
	oPrinter:Say(0405,0500,cMotorista,oArial18,,0)
	
	oPrinter:Say(0255,1780,"Data:",oArial18N,,0)		
	oPrinter:Say(0255,2100,Transform(cZ1_DTMA,"99/99/9999")+SPACE(3)+cZ1_HRMA,oArial18,,0)

	oPrinter:Say(0330,1780,"Qtd Pallets:",oArial18N,,0)		
	oPrinter:Say(0330,2100,cPallets,oArial18,,0)
	
	oPrinter:Say(0405,1780,"R.G.:",oArial18N,,0) 	
	oPrinter:Say(0405,2100,cRGMot,oArial18,,0)

	oPrinter:Say(0255,2600,"Lotação:",oArial18N,,0)		
	oPrinter:Say(0255,2800,IIF(cLotacao=='S',"Sim","Não"),oArial18,,0)
	
	oPrinter:Say(0330,2600,"Veiculo:",oArial18N,,0)	
	oPrinter:Say(0330,2800,cVeiculo,oArial18,,0)                  
	
	oPrinter:Say(0405,2600,"Placa:",oArial18N,,0)	
	oPrinter:Say(0405,2800,Alltrim(cPlaca),oArial18,,0)

	PalletF() //Imprime a quantide de pallets fechados

Return

Static Function ImpCabNF()
	  
	// Cabeçalho das Notas
	nlinx+= 75 
	oPrinter:Say(nLinX,0060,"N° NF",oArial17N,,0)
	oPrinter:Say(nLinX,0310,"Pedido",oArial17N,,0)
	oPrinter:Say(nLinX,0565,"Cliente",oArial17N,,0)
	oPrinter:Say(nLinX,1300,"Dt. Pedido",oArial17N,,0)
	oPrinter:Say(nLinX,1830,"Confer.GR",oArial17N,,0)
	oPrinter:Say(nLinX,2370,"Confer.CX",oArial17N,,0)
	oPrinter:Say(nLinX,2710,"Qtd Gr.",oArial17N,,0)
	oPrinter:Say(nLinX,2920,"Qtde.Cx",oArial17N,,0)
	oPrinter:Say(nLinX,3140,"Total Vol.",oArial17N,,0)  
	oPrinter:Line(nLinX+20,0045,nLinX+20,3360,,"-1")

Return	

Static Function ImpDetNF() 

	cQry	:= " SELECT TOP 1 D2_CLIENTE, D2_LOJA, D2_PEDIDO	"
	cQry	+= " FROM SD2020									"
	cQry	+= " WHERE D_E_L_E_T_ = ''							"
	cQry	+= " AND D2_FILIAL = '"+xFilial("SD2")+"'			"
	cQry	+= " AND D2_DOC = '"+cDoc+"'						"

	If Select("TRBR02B") > 0
		TRBR02B->( dbCloseArea() )
	EndIf

	TCQUERY cQry NEW ALIAS "TRBR02B"

	DBSelectArea("TRBR02B")
	TRBR02B->(dbGoTop())

	If Empty(TRBR02B->D2_CLIENTE)
		
		TRBR02B->( dbCloseArea() )

		cQry	:= " SELECT TOP 1 D2_CLIENTE, D2_LOJA, D2_PEDIDO	"
		cQry	+= " FROM SD20203									"
		cQry	+= " WHERE D_E_L_E_T_ = ''							"
		cQry	+= " AND D2_FILIAL = '"+xFilial("SD2")+"'			"
		cQry	+= " AND D2_DOC = '"+cDoc+"'						"
		If Select("TRBR02B") > 0
			TRBR02B->( dbCloseArea() )
		EndIf
		
		TCQUERY cQry NEW ALIAS "TRBR02B"
		DBSelectArea("TRBR02B")
		TRBR02B->(dbGoTop())

	Endif

	DBSelectArea("SC5")
	DBSetOrder(3)
	DBSeek(xFilial("SC5")+TRBR02B->D2_CLIENTE + TRBR02B->D2_LOJA + TRBR02B->D2_PEDIDO )

	oPrinter:Say(nLinDet,0060,cDoc,oArial17N,,0)
	oPrinter:Say(nLinDet,0310,SC5->C5_NUM,oArial17N,,0)
	oPrinter:Say(nLinDet,0565,SubStr(Posicione("SA1",1,xFilial("SA1")+cCli + cLj,"A1_NOME"),1,24),oArial17N,,0)
	oPrinter:Say(nLinDet,1300,Transform(SC5->C5_EMISSAO,"99/99/9999"),oArial17N,,0)
	oPrinter:Say(nLinDet,1830,SubStr(SC5->C5_X_CONGR,1,9),oArial17N,,0)   //***
	oPrinter:Say(nLinDet,2370,SubStr(SC5->C5_X_CONCX,1,9),oArial17N,,0)   //***
	oPrinter:Say(nLinDet,2730,Transform(SC5->C5_VOLUME2,"999999"),oArial17N,,0)
	oPrinter:Say(nLinDet,2960,Transform(SC5->C5_VOLUME1,"999999"),oArial17N,,0)
	oPrinter:Say(nLinDet,3200,Transform(SC5->(C5_VOLUME1+C5_VOLUME2),"999999"),oArial17N,,0)
		
Return
	
Static Function ImpTotal()

	//Variaveis para Busca SZ1 - Controle do Manifesto	
	cZ1_OBSM1 := AllTrim(GetAdvFVal("SZ1","Z1_OBSM1", xFilial("SZ1")+cNumMan))	//Busca Observacao 1
	cZ1_OBSM1 += " "+AllTrim(GetAdvFVal("SZ1","Z1_OBSM2", xFilial("SZ1")+cNumMan))	//Busca Observacao 2
	cZ1_OBSM1 += " "+AllTrim(GetAdvFVal("SZ1","Z1_OBSM3", xFilial("SZ1")+cNumMan))	//Busca Observacao 3
	cZ1_OBSM1 += " "+AllTrim(GetAdvFVal("SZ1","Z1_OBSM4", xFilial("SZ1")+cNumMan))	//Busca Observacao 4

	oPrinter:Say(nLinTot+120,0060,"Totais",oArial18N,,0)  
	oPrinter:Say(nLinTot+120,0315,"Qtde N.F.:",oArial18N,,0)
	oPrinter:Say(nLinTot+120,0585,Transform(nContNF,"999"),oArial18,,0)

	oPrinter:Say(nLinTot+120,1630,"0,00",oArial18N,,0)
	oPrinter:Say(nLinTot+120,2130,Transform(nPesoTCX,"@E 999,999.999"),oArial18N,,0)
	oPrinter:Say(nLinTot+120,2740,Transform(nQtdTGR,"99999"),oArial18N,,0)
	oPrinter:Say(nLinTot+120,2950,Transform(nQtdTCX,"99999"),oArial18N,,0)
	oPrinter:Say(nLinTot+120,3180,Transform(nQtdTVol,"99999"),oArial18N,,0)

	oPrinter:Say(nLinTot+240,0060,"Observações:",oArial18N,,0)			
	oPrinter:Say(nLinTot+240,0403,cZ1_OBSM1,oArial18,,0)      	

	nLinTot += 240

Return

Static Function ImpRodape()
	
	oPrinter:Line(nLinRod+600,0060,nLinRod+600,1200,,"-1")
	oPrinter:Say(nLinRod+650,0500,"Assinatura",oArial18N,,0)		
	
	lImpRod := .F.				
		
Return

Static Function NumPag()

oPrinter:Say(2170,0060,"N° Manifesto "+cNumMan,oArial14,,0)
		
oPrinter:Say(2170,1500,"Impressão: " + Transform(DDATABASE,"99/99/9999") +SPACE(03)+ SUBSTR(TIME(),1,5),oArial14,,0)	 		
		
nPag := oPrinter:NPAGECOUNT                       
oPrinter:Say(2170,3140,"Pagina "+Transform(nPag,"99"),oArial14,,0)

Return

Static Function PalletF()

Local _cQuery	:= ""
Local _cQry		:= ""
Local _cQry1	:= ""

_cQuery	:= " SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_PBRUTO, F2_X_NRMA, C5_NUM	"
_cQuery	+= " FROM SF2020 F2							"
_cQuery	+= " INNER JOIN SC5020 C5 ON C5.D_E_L_E_T_ = '' AND C5_NOTA = F2_DOC AND C5_FILIAL = F2_FILIAL "
_cQuery	+= " WHERE F2.D_E_L_E_T_ = ''				"
_cQuery	+= " AND F2_FILIAL = '"+xFilial("SF2")+"'	"
_cQuery	+= " AND F2_X_NRMA = '"+cNumMan+"'			"
_cQuery	+= " ORDER BY C5_NUM "

If Select("TRBR0PF") > 0
	TRBR0PF->( dbCloseArea() )
EndIf

TCQUERY _cQuery NEW ALIAS "TRBR0PF"

DBSelectArea("TRBR0PF")
TRBR0PF->(dbGoTop())

While TRBR0PF->(!EOF())

	_cDoc	:= TRBR0PF->F2_DOC
	_cSer	:= TRBR0PF->F2_SERIE
	_cCli	:= TRBR0PF->F2_CLIENTE
	_cLj	:= TRBR0PF->F2_LOJA
	_nPBr	:= TRBR0PF->F2_PBRUTO

	_cQry	:= " SELECT TOP 1 D2_CLIENTE, D2_LOJA, D2_PEDIDO	"
	_cQry	+= " FROM SD2020									"
	_cQry	+= " WHERE D_E_L_E_T_ = ''							"
	_cQry	+= " AND D2_FILIAL = '"+xFilial("SD2")+"'			"
	_cQry	+= " AND D2_DOC = '"+_cDoc+"'						"

	If Select("TRBR0PF2") > 0
		TRBR0PF2->( dbCloseArea() )
	EndIf

	TCQUERY _cQry NEW ALIAS "TRBR0PF2"

	DBSelectArea("TRBR0PF2")
	TRBR0PF2->(dbGoTop())

	If Empty(TRBR0PF2->D2_CLIENTE)
		
		TRBR0PF2->( dbCloseArea() )

		_cQry	:= " SELECT TOP 1 D2_CLIENTE, D2_LOJA, D2_PEDIDO	"
		_cQry	+= " FROM SD20203									"
		_cQry	+= " WHERE D_E_L_E_T_ = ''							"
		_cQry	+= " AND D2_FILIAL = '"+xFilial("SD2")+"'			"
		_cQry	+= " AND D2_DOC = '"+_cDoc+"'						"
		If Select("TRBR02B") > 0
			TRBR0PF2->( dbCloseArea() )
		EndIf
		
		TCQUERY cQry NEW ALIAS "TRBR0PF2"
		DBSelectArea("TRBR0PF2")
		TRBR0PF2->(dbGoTop())

	Endif

	DBSelectArea("SC5")
	DBSetOrder(3)
	DBSeek(xFilial("SC5")+TRBR0PF2->D2_CLIENTE + TRBR0PF2->D2_LOJA + TRBR0PF2->D2_PEDIDO )

	_cQry1:= " SELECT "
	_cQry1+= " F2_FILIAL,Z1_NRMA,Z1_DTMA,Z1_HRMA,Z1_MOTMA,Z1_LOTACAO, "
	_cQry1+= " Z1_PLACA,Z1_PALLETS,Z1_VEICULO,F2_DOC, F2_EST, "
	_cQry1+= " F2_EMISSAO,D2_PEDIDO,A1_NOME,A4_NOME, "
	_cQry1+= " SUM(D2_QUANT) QTD, SUM(D2_TOTAL) VLR_MERC, F2_VOLUME1, F2_PLIQUI, F2_PBRUTO "
	_cQry1+= " , sum(PFECHADO) PFECHADO"
	_cQry1+= " FROM SF2020 SF2 "
	_cQry1+= " INNER JOIN SZ1020 SZ1 ON SZ1.D_E_L_E_T_=''  AND Z1_FILIAL=F2_FILIAL AND Z1_NRMA=F2_X_NRMA "
	_cQry1+= " INNER JOIN SD2020 SD2 "
	_cQry1+= " ON SD2.D_E_L_E_T_=''  AND D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE "
	_cQry1+= " INNER JOIN SA1020 SA1 "
	_cQry1+= " ON SA1.D_E_L_E_T_=''  AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA "
	_cQry1+= " INNER JOIN SA4020 SA4 "
	_cQry1+= " ON SA4.D_E_L_E_T_=''  AND A4_COD = CASE WHEN Z1_TRANSP=' ' THEN F2_TRANSP ELSE Z1_TRANSP END"
	_cQry1+= " INNER JOIN ("
	_cQry1+= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, SUM(PFECHADO) PFECHADO FROM("
	_cQry1+= " SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, "
	_cQry1+= " CASE WHEN B1_XQTDPAL>0 THEN FLOOR((C6_QTDVEN-C6_X_VGRIM )/B1_XQTDPAL) ELSE 0 END PFECHADO"
	_cQry1+= " FROM SC6020 C6  (NOLOCK)"
	_cQry1+= " INNER JOIN SB1020 B1 ON C6_PRODUTO = B1_COD AND B1_FILIAL = '' AND B1.D_E_L_E_T_ = ''"
	_cQry1+= " WHERE C6.D_E_L_E_T_=' ' AND C6_NOTA<>' '"
	_cQry1+= " )TOTSC6 GROUP BY C6_FILIAL, C6_NUM, C6_PRODUTO"
	_cQry1+= " )PEDIDO ON D2_FILIAL=C6_FILIAL AND D2_PEDIDO=C6_NUM AND D2_COD=C6_PRODUTO"
	_cQry1+= " WHERE"
	_cQry1+= " SF2.D_E_L_E_T_ = '' AND F2_TIPO  = 'N' "
	_cQry1+= " AND D2_PEDIDO = '"+SC5->C5_NUM+"' "
	_cQry1+= " AND D2_FILIAL = '"+SC5->C5_FILIAL+"' "
	_cQry1+= " GROUP BY F2_FILIAL,Z1_NRMA,Z1_DTMA,Z1_HRMA,Z1_MOTMA,Z1_LOTACAO,"
	_cQry1+= " Z1_PLACA,Z1_PALLETS,Z1_VEICULO,F2_DOC, F2_EST,"
	_cQry1+= " F2_EMISSAO,D2_PEDIDO,A1_NOME,A4_NOME,F2_VOLUME1,F2_PLIQUI,F2_PBRUTO"
	_cQry1+= " ORDER BY F2_FILIAL,Z1_NRMA,Z1_DTMA "

    if SELECT("TRBSC6A") > 0 
        TRBSC6A->(DbCloseArea())
    Endif
    TCQUERY _cQry1 NEW ALIAS "TRBSC6A"
    mPalF += TRBSC6A->(PFECHADO)

	TRBR0PF->(dbSkip())     

EndDo

	oPrinter:Say(0480,2600,"Fechado:",oArial18N,,0)	  
	oPrinter:Say(0480,2850,Alltrim(Transform(mPalF,"999")),oArial18,,0) 	

Return
