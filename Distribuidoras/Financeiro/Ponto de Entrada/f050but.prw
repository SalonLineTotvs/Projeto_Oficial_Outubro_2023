#include "rwmake.ch"
USER FUNCTION F050BUT()
Return({{'RAS352',{ || LIMPARI() },'Elimina Origem'}})
static function limpari()
    if msgyesno("Confirma retirar origem?")
        se2->(reclock("SE2",.F.))
        se2->(E2_ORIGEM) := ''
        se2->(E2_NATUREZ) := ''
        se2->(MSUNLOCK())
        se2->(DBCOMMIT())
        MSGINFO("Registro atualizado !")
    endif
Return 
