#Include "Protheus.ch"
#Include "Rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³FSSALOTT  ºAutor  ³Eduardo Silva      º Data ³  22/08/2023  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para tratamento do Valor Total Monetario Juros e  º±±
±±º          ³ Multa 042 a 056.                                        	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Salonline                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FSSALOTT() 
Local _Area		:= GetArea()
Local nJuros	:= 0
Local nMulta	:= 0
Local cTotVlTr  := ""
Local cChaveB	:= Substr(cChave,1,6)
SE2->( dbSetOrder(15) )	// E2_FILIAL + E2_NUMBOR
If SE2->( dbSeek(xFilial("SE2") + cChaveB, .F.) )
	While SE2->( !Eof() ) .And. SE2->E2_NUMBOR == cChaveB
		If Alltrim(SE2->E2_TIPO) == "TX"
			nJuros += SE2->E2_JUROS
			nMulta += SE2->E2_MULTA
		EndIf
		SE2->( dbSkip() )
	EndDo
EndIf
cTotVlTr := PadL(Alltrim(Str((nSomaValor + nJuros + nMulta) * 100 )), 14, "0")
RestArea(_Area)
Return cTotVlTr
