#include "protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³FA60FIL   ºAutor  ³ Andre salgado       º Data ³  17/05/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Filtrar Só Titulos de Clientes       º±±
±±º          ³     EMCOMANDANTE ESTAO SENDO RETIRADOS     				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Salon Line                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Data 07/06/2018 - Sol.Renato J / Autorizada Genilson / Autor André Salgado
=> (01) Incluir opção para Filtra Titulos com Historico MANIF
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FA60FIL()

//Local aArea 	:= GetArea()

SetPrvt("CFILTRO")

cfiltro := ""

If MsgYesNo("Será feito Filtro para trazer SOMENTE TITULO(s) DE CLIENTE(s), não será apresentado NF Encomendantes ?","Atenção!")
	cfiltro := " !(E1_CLIENTE $ '001629,000871,000534,001286,001398') .AND. SE1->E1_X_FORMP <> 'DP ' "
	/*
	000871 - ALFALOG (E)
	000534 - AQUARIUS(E)
	001286 - TEXTOR  (E)
	001398 - CAREX   (E)
	*/
	
	
	//(01) Melhoria Filtra Titulo que foram MANIFESTADOS
	If MsgYesNo("Deseja Filtrar Titulos Manifestado ?","Atenção!")
		cfiltro := " SE1->E1_X_DTMAN <> CTOD(' / / ') .AND. SE1->E1_X_FORMP <> 'DP ' "		//BOTAO SIM
	Else
		cfiltro := " !(E1_CLIENTE $ '001629,000871,000534,001286,001398') .AND. SE1->E1_X_FORMP <> 'DP ' "	//BOTAO NAO
	Endif	
	
else
	cfiltro := " E1_MDCRON=' ' .AND. SE1->E1_X_FORMP <> 'DP ' "
EndIf

//RestArea(aArea)

Return(cfiltro)
