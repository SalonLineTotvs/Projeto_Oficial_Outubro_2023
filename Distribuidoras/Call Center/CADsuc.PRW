#include 'protheus.ch'
#include 'parmtype.ch'

USER FUNCTION cadsuc()

LOCAL cAlias := "SUC"
PRIVATE cCadastro := "Reforma Atendimentos Call Center"
PRIVATE aRotina     := { }
AADD(aRotina, { "Pesquisar" , "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
AADD(aRotina, { "**Cancelar Atendimento**"   , "u_SUCCancelar" , 0, 6 }) // função customizada
If !(__cUserId $ GETMV("ES_CADSUC"))
    ALERT("ROTINA DESABILITADA PARA ESTE USUARIO")	
    RETURN
EndIf
dbSelectArea(cAlias)
dbSetOrder(1) 
mBrowse(6, 1, 22, 75, cAlias) 
RETURN NIL

//---------------------
// chamada no aRotina
//---------------------
user function SUCCancelar()
            reclocK('SUC',.f.)
            replace uc_codcanc with '999999'
            replace UC_DTENCER WITH CTOD('//') 
            replace uc_codencer with ''
            msunlock()
            alert('Atendimento modificado !!')
return
