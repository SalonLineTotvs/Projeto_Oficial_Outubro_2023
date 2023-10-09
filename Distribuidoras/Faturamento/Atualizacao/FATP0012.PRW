#include "protheus.ch"
#INCLUDE "RWMAKE.CH"                                    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ FATP0012 ºAutor  ³ GENILSON LUCAS     º Data ³ 06/09/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para mudar campo personalizavel.                  º±±
±±º          ³ 														      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SALONLINE						 	 	                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FATP0012()

Local oWindow, oStaLG, oStaFT, oStaMN, oStaCM, oObsInt, oStaPR, oStatX
Local lComer	:= .F.
Local lStatusCM	:= .F.
Local lStatusLG	:= .F.
Local lStatusFT := .F.
Local lStatusMN	:= .F.
Local lStatusPR	:= .F.  
Local lStatusNF	:= .F.
Local lStatusTR	:= .F.
Local lStatusCR	:= .F.
Local cUser			:= ALLTRIM(__cUserId)
Local cUserCom		:= GETMV("ES_FATP12A")
Local cUserStaCM	:= GETMV("ES_FATP12B")
Local cUserStaLG	:= GETMV("ES_FATP12C")
Local cUserStaFT	:= GETMV("ES_FATP12D")
Local cUserStaMN	:= GETMV("ES_FATP12E")
Local cUserStaNF	:= GETMV("ES_FATP12F")
Local cUserStaTR	:= GETMV("ES_FATP12G")
Local cUserStaCR	:= GETMV("ES_FATP12H")


Private cTransp 	:= SC5->C5_TRANSP
Private cCondPag	:= SC5->C5_CONDPAG
Private cObsLog		:= SC5->C5_X_OBSLO 
Private cObsInt		:= Alltrim(SC5->C5_X_OBSIN)
Private cMotNF		:= SC5->C5_MENNOTA

Private	cStaLG 	:= SC5->C5_X_STALG	
Private cStaFT 	:= SC5->C5_X_STAFT
Private cStaMN 	:= SC5->C5_X_STAMN	
Private	cStaCM 	:= SC5->C5_X_STACM	
Private cStaPr	:= SC5->C5_X_SONLG 	// Campo Temporario até criar o campo em produção
Private cStaCR 	:= SC5->C5_X_STACR
Private	aStaLG 	:= {"","1=Falta de Produto","2=Acúmulo de Pedidos","3=Sistema","4=Pedido Antecipado"}
Private aStaFT 	:= {"","1=Fiscal","2=Excesso Pedidos","3=Cliente Retira","4=Aguar Pagar Guia","5=Cliente C/ Pendên. Fiscal SEFAZ","6=Sistema","7=Site Emissão Guias" }
Private aStaCR 	:= {"1=Pendente","2=Bonificação","3=Troca","4=Saldo","5=Liberado"}
Private aStaMN 	:= {"","1=Cliente Retira","2=Aguardando Guia","3=PIN","4=Sistema","5=Aguardando Coleta","6=Pedido Antecipado","7=Divergência na NF"}
Private	aStaCM 	:= {"","1=Pagamento Antecipado","2=Crédito","3=Parado Comercial","4=Programado","5=Falta de Produto","6=Agu.Término Fech"}  
Private	aPriEsp	:= {"","1","2","3","4","5"}
Private dDtEntre	:= SC5->C5_FECENT
Private dDtReagen	:= SC5->C5_X_DTAGE

If cUser $ cUserCom .and. EMPTY(SC5->C5_NOTA) .AND. SC5->C5_X_STAPV == '0'
	lComer	:= .T.
EndIf
     
If cUser $ cUserCom .AND. SC5->C5_X_STAPV $ ('A/0')
	lStatusPR	:= .T.
EndIf

If cUser $ cUserStaCM .AND. SC5->C5_X_STAPV == '0'
	lStatusCM	:= .T.
EndIf

If cUser $ cUserStaLG .AND. SC5->C5_X_STAPV $ ('A/1/2/3/4')
	lStatusLG	:= .T.
EndIf

If cUser $ cUserStaFT .AND. SC5->C5_X_STAPV $ ('A/5')
	lStatusFT	:= .T.
EndIf

If cUser $ cUserStaMN .AND. SC5->C5_X_STAPV == '6'
	lStatusMN	:= .T.
EndIf  
        
If cUser $ cUserStaNF .AND. EMPTY(SC5->C5_NOTA) .AND. SC5->C5_X_STAPV $ ('0/1/2/3/4')
	lStatusNF	:= .T.
EndIf                

If cUser $ cUserStaTR .AND. EMPTY(SC5->C5_NOTA) 
	lStatusTR	:= .T.
Endif

If cUser $ cUserStaFT .AND. EMPTY(SC5->C5_NOTA) .AND. SC5->C5_X_STAPV $ ('0/1/2/3/4')
	lStatusFT	:= .T.
EndIf                
              
If cUser $ cUserStaCR .AND. SC5->C5_X_STAPV $ ('0/1/2/3/4/5')
	lStatusCR	:= .T.
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a Janela de Alteracao                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

@ 105,074 To 460,700 Dialog oWindow Title OemToAnsi("Alterar informações do pedido - " + SC5->C5_NUM )

@ 005,005 To 170,310 //Label OemToAnsi('Informaçõe Cadastrais')
@ 015,010 Say "Transportadora: "
@ 015,170 Say "Cond. de Pagam."
@ 030,010 Say "Obs. Logística:"
@ 045,010 Say "Obs. Interna:"
@ 080,010 Say "Mensagem NF:"

@ 015,060 Get cTransp	Size 035,10 WHEN lStatusTR	F3 "SA4" VALID ExistCpo("SA4") 
@ 015,220 Get cCondPag	Size 035,10 WHEN lComer F3 "SE4" VALID ExistCpo("SE4")
@ 030,060 Get cObsLog	Size 230,10 WHEN lComer
@ 045,060 GET oObsInt	Var cObsInt MEMO SIZE 230, 030 OF oWindow COLORS 0, 16777215 PIXEL WHEN lComer
@ 080,060 Get cMotNF	Size 230,10 WHEN lStatusNF

//@ 050,005 To 110,310 Label OemToAnsi('Status do Pedido') 


@ 095,010 Say "Status Comercial:"
@ 095,170 Say "Status Faturamento:"
@ 110,010 Say "Status Logística:"
@ 110,170 Say "Status Manifesto:"
@ 125,010 Say "Status :"
@ 125,170 Say "PV c/ Prioridade:"
@ 140,010 Say "Agendamento: "   
@ 140,170 Say "Reagendamento:"

@ 095,060 MSCOMBOBOX oStaCM VAR cStaCM ITEMS aStaCM Size 80,07   OF oWindow  COLORS 0, 16777215 PIXEL When lStatusCM
@ 110,060 MSCOMBOBOX oStaLG VAR cStaLG ITEMS aStaLG Size 80,07   OF oWindow  COLORS 0, 16777215 PIXEL When lStatusLG
@ 095,220 MSCOMBOBOX oStaFT VAR cStaFT ITEMS aStaFT Size 80,07   OF oWindow  COLORS 0, 16777215 PIXEL When lStatusFT
@ 110,220 MSCOMBOBOX oStaMN VAR cStaMn ITEMS aStaMn Size 80,07   OF oWindow  COLORS 0, 16777215 PIXEL When lStatusMN
@ 125,060 MSCOMBOBOX oStaCR VAR cStaCR ITEMS aStaCR Size 80,07   OF oWindow  COLORS 0, 16777215 PIXEL When lStatusCR
@ 125,220 MSCOMBOBOX oStaPR VAR cStaPr ITEMS aPriEsp Size 35,07   OF oWindow  COLORS 0, 16777215 PIXEL When lStatusPR

If cUser $ cUserCom .or. cUser $ cUserStaCM
	@ 140,060 Get dDtEntre Size 045,10 //When lStatusCM
	@ 140,220 Get dDtReagen Size 045,10 
Else	
	@ 140,060 Get dDtEntre Size 045,10 When .F.
	@ 140,220 Get dDtReagen Size 045,10 When .F.
Endif


@ 155,110 BmpButton Type 1 Action( Close(oWindow), Processa( {|| cMsg := Atualiza()}, "Atualizando dados..." ) )
@ 155,150 BmpButton Type 2 Action( Close(oWindow) )

Activate Dialog oWindow Centered


Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Atualiza  ºAutor  ³ GENILSON LUCAS    º Data ³ 06/09/2018   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza os dados do pedido.		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Atualiza()    

RecLock('SC5',.F.)

	SC5->C5_CONDPAG	:= cCondPag
	SC5->C5_TRANSP	:= cTransp
	SC5->C5_X_OBSLO := cObsLog
	SC5->C5_X_OBSIN	:= ALLTRIM(cObsInt)
	SC5->C5_FECENT	:= dDtEntre
	
	SC5->C5_X_STALG		:= cStaLG
	SC5->C5_X_STACR		:= cStaCR
	SC5->C5_X_STAMN		:= cStaMn
	SC5->C5_X_STACM		:= cStaCM
	SC5->C5_X_SONLG		:= cStaPr
	SC5->C5_MENNOTA		:= cMotNF 
	SC5->C5_TRANSP		:= cTransp 
	SC5->C5_X_DTAGE		:= dDtReagen
	
MsUnlock()

Return()          


Static Function Refresh()
                   

If nRadio = 1
	_cItem	:= "  "
	@ 060,060 Get cItem Size 010,10 When .F.
Else
	_cItem	:= space(4)
	@ 060,060 Get cItem Size 010,10 //When .F.
EndIf

oWindow:Refresh()

Return()