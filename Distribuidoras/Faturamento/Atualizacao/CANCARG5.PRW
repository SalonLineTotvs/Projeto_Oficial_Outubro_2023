*---------------------------------------------------------------*
#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
/*----------------------*/
User Function CanCarg5()
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
           {"Voltar Conf Finaliz" ,'ExecBlock("cValid1",.F.,.F.,4),CloseBrowse()' , 0 , 4 }}
cMarca := GetMark()
cCadastro := OEMTOANSI("Alteracao do Status")
MarkBrowse(_cAlias,"C5_XCG", , ,.F.,cMarca, , , , , )     
SC5->(DbClearFilter())
SC5->(DbSetOrder(aordem))

Return

/*********************/
user Function cValid1() 
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
    
    cQuery1 := " UPDATE SC5020 SET C5_X_STAPV='5' "
    cQuery1 += " WHERE C5_FILIAL + C5_NUM = '"+ (SC5->C5_FILIAL+SC5->C5_NUM)+"'" 

    nStatus1 := TCSqlExec(cQuery1)
    if (nStatus1 < 0)
        conout("TCSQLError() " + TCSQLError())
    endif
    //alert('processo concluido pedido '+(SC5->C5_FILIAL+SC5->C5_NUM))
return
