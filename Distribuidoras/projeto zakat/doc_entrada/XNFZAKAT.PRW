#INCLUDE "PROTHEUS.CH"
#INCLUDE 'rwmake.ch'
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"

#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"    

user function XNFZAKAT()
putmV("XM_XPCNFE",.T.)

U_XMLDCONDOR()

putmV("XM_XPCNFE",.F.)//

RETURN
