#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'FWMVCDef.ch'
#INCLUDE 'rwmake.ch'

User Function MA030ROT()

Local aButtons := {}

Aadd(aButtons, { "Clientes x Transp.","U_FATP0019()", 0,6 } )
Aadd(aButtons, { "Imp. Dados Financ.","U_FATP0020()", 0,6 } )


Return(aButtons)
