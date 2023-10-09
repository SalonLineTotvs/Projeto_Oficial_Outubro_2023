#Include "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

User Function M450ABRW()
Local _cQuery := PARAMIXB[1] 
Local _cUser    := RetCodUsr()
Local _cUsrPerm := SuperGetMV( "SL_APRVCRD", Nil, "000710|000592|000807|000841|" )	
Local _cModel   := '2'
Local _dData    := DATE()

If _cUser $ _cUsrPerm
        _cQuery += " AND C5_XLBCRED = 'T' " + CRLF
EndIf

Return _cQuery
