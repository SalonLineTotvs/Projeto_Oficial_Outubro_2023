#INCLUDE "PROTHEUS.CH"                                                                                 
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AfterLogin ³ Autor ³ Genilson Lucas		 ³ Data ³ 14/11/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Executa após usuário efetuar login no sistema.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico para SALONLINE                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function AfterLogin()  

Local cAmbiente := GetEnvServer() //ambiente logado
Local cEmpresa	:= SM0->M0_CODIGO
/*
If cEmpresa == '01'
	If !(upper(cAmbiente) $ ('DEVINTEX/SALONLINE/01_COMPILA/01_HOMOLOGA/DEVINTEX_HMG'))
		Final("Prezado(a), o ambiente logado não corresponde a empresa, favor verificar!")
	EndIf
ElseIf cEmpresa == '02' 
	If (!(upper(cAmbiente) $ ('DISTRIBUIDORAS')) .AND. !(RetCodUsr() $ ALLTRIM(getmv('ES_USRAMB')))) .OR. !('LIBERADO'$ALLTRIM(getmv('ES_USRAMB')))
		Final("Prezado(a), o ambiente logado não corresponde a empresa, favor verificar!")
	EndIf
EndIf
*/
return()
