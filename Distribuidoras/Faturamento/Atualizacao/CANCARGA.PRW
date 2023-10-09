*---------------------------------------------------------------*
#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
/*----------------------*/
User Function CanCarga()
/*----------------------*/
MsgRun("Selecionando registros, Aguarde...","",{|| CursorWait(), montaC5() ,CursorArrow()})
Return

/************************/
Static Function montac5()
/*************************/
dbSelectArea("SC5")
aordem := SC2->(IndexOrd())
SC5->(DbSetOrder(1))
_cAlias := Alias()
_nRecno := Recno()
_cFiltr2 := " C5_X_STAPV='1' "
MsFilter(_cFiltr2)
SC5->(DbGotop())
aRotina:= {{"Pesquisar"     ,"AxPesqui" , 0 , 1 },;
           {"Voltar PV Gerado" ,'ExecBlock("cValid0",.F.,.F.,4),CloseBrowse()' , 0 , 4 }}
cMarca := GetMark()
cCadastro := OEMTOANSI("Alteracao do Status")
MarkBrowse(_cAlias,"C5_XCG", , ,.F.,cMarca, , , , , )     
SC5->(DbClearFilter())
SC5->(DbSetOrder(aordem))

Return

/*********************/
user Function cValid0() 
/*********************/

If ApMsgYesNo("Confirma Reabertura dos Pedidos Marcados?")
   SC5->(DbGotop())
   While ! SC5->(Eof())
       If SC5->c5_Xcg <> '  '
          libcarga()
          RECLOCK('SC5',.F.)
          SC5->c5_Xcg := '  '
          MSUNLOCK()
          DBCOMMIT()
       Endif   
       SC5->(DbSkip())
   Enddo
Endif      
Return

static function libcarga()
    
    cQuery1 := " UPDATE SC5020 SET C5_X_STAPV='0', C5_X_NONDA=' ', C5_X_ANTEC = '2', C5_X_TLNCX=0, C5_X_TVLCX=0, C5_X_TLNGR=0,C5_X_TVLGR=0, C5_X_DTIMP= '' , "
    cQuery1 += " C5_X_HRIMP = '', C5_X_USIMP='', C5_X_DTISP= '', C5_X_HRISP = '', C5_X_SEPAR = '', C5_X_CFSEP='', C5_X_DTOLO = '', C5_ESPECI3 = '' "
    cQuery1 += " WHERE C5_NOTA=' '  AND C5_X_STAPV = '1' AND C5_FILIAL + C5_NUM = '"+ (SC5->C5_FILIAL+SC5->C5_NUM)+"'" 
    
    cQuery2 := " UPDATE SC6020 SET C6_X_VCXIM=0,C6_X_VGRIM=0, C6_X_VCXCO=0, C6_X_VGRCO=0, C6_X_SEPAR = 0, C6_X_RESID = '' "
    cQuery2 := " FROM SC6020 INNER JOIN SC5020 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_X_STAPV='0' "
    cQuery2 := " WHERE C6_NOTA=' ' AND C6_FILIAL+C6_NUM =  '"+ (SC5->C5_FILIAL+SC5->C5_NUM)+"'"

    nStatus1 := TCSqlExec(cQuery1)
    if (nStatus1 < 0)
        conout("TCSQLError() " + TCSQLError())
    endif

    nStatus1 := TCSqlExec(cQuery2)
    if (nStatus1 < 0)
        conout("TCSQLError() " + TCSQLError())
    endif
    //alert('processo concluido pedido '+(SC5->C5_FILIAL+SC5->C5_NUM))
return
