#include 'protheus.ch'
#include 'parmtype.ch'

USER FUNCTION altarmx()

LOCAL cAlias := "SD1"
PRIVATE aRotina     := { }
Private cPerg := "RESTR3X"
IF !Pergunte(cPerg,.T.)
   Return
Endif
PRIVATE cCadastro := "Classificar Itens Da Nota Fiscal: "+MV_PAR07+" - Fornecedor: "+ MV_PAR05

AADD(aRotina, { "Pesquisar" , "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
//AADD(aRotina, { "Enviar Local 01"   , "u_local01" , 0, 6 }) // função customizada
AADD(aRotina, { "Transferir para 02-Bom"    , "u_local02" , 0, 6 }) // função customizada
AADD(aRotina, { "Transferir para 03-Ruim"   , "u_local03" , 0, 6 }) // função customizada
AADD(aRotina, { "Transferir para AN-Falta"  , "u_local04" , 0, 6 }) // função customizada

AADD(aRotina, { "TODOS para 02-Bom"    , "u_localT2" , 0, 6 }) // função customizada
AADD(aRotina, { "TODOS para 03-Ruim"   , "u_localT3" , 0, 6 }) // função customizada
AADD(aRotina, { "TODOS para AN-Falta"  , "u_localT4" , 0, 6 }) // função customizada

dbSelectArea(cAlias)
dbSetOrder(1) 

set filter to SD1->D1_DOC = MV_PAR07 .and. SD1->D1_SERIE = MV_PAR09 .and. SD1->D1_FORNECE = MV_PAR05 .and. sd1->d1_local = '90'
mBrowse(6, 1, 22, 75, cAlias)
RETURN NIL

//---------------------
// chamada no aRotina
//---------------------
user function Local01()
            reclocK('SD1',.f.)
            replace d1_local  with '01' 
            replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'01'
            replace d1_movest with ddatabase 
            msunlock()
            alert('transferencia para o armazem 01 realizada com sucesso !!')
return
user function Local02()
            reclocK('SD1',.f.)
            replace d1_local  with '02'
            replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'02'
            replace d1_movest with ddatabase 
            msunlock()
            alert('transferencia para o armazem 02 realizada com sucesso !!')
return
user function Local03()
            reclocK('SD1',.f.)
            replace d1_local  with '03'
            replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'03'
            replace d1_movest with ddatabase 
            msunlock()
            alert('transferencia para o armazem 03 realizada com sucesso !!')
return
user function Local04()
            reclocK('SD1',.f.)
            replace d1_local  with 'AN'
            replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'AN'
            replace d1_movest with DATE() 
            msunlock()
            alert('transferencia para o armazem AN realizada com sucesso !!')
return

user function LocalT1()
   if msgyesno("Voce em certeza que DESEJA transferir todos os itens para o Armazem 01?")
               IF dbseek(xfilial('SD1')+  SD1->(MV_PAR07+MV_PAR09+MV_PAR05)  )
               WHILE SD1->D1_DOC = MV_PAR07 .and. SD1->D1_SERIE = MV_PAR09 .and. SD1->D1_FORNECE = MV_PAR05 
                  reclocK('SD1',.f.)
                  replace d1_local  with '01' 
                  replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'01'
                  replace d1_movest with DATE()
                  msunlock()
                  SD1->(DBSKIP())
               alert('transferencia TOTAL para o armazem 01 realizada com sucesso !!')
               END
               endif
   else
      alert('PROCESSO DE TRANSFERENCIA PARA O ARMAZEM 01 FOI ABORTADO')
   endif   
return
user function LocalT2()
   if msgyesno("Voce em certeza que DESEJA transferir todos os itens para o Armazem 02?")
               IF dbseek(xfilial('SD1')+  SD1->(MV_PAR07+MV_PAR09+MV_PAR05)  )
               WHILE SD1->D1_DOC = MV_PAR07 .and. SD1->D1_SERIE = MV_PAR09 .and. SD1->D1_FORNECE = MV_PAR05 
                  reclocK('SD1',.f.)
                  replace d1_local  with '02'
                  replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'02'
                  replace d1_movest with DATE()
                  msunlock()
                  SD1->(DBSKIP())
               alert('transferencia TOTAL para o armazem 02 realizada com sucesso !!')
               END
               endif
   else
      alert('PROCESSO DE TRANSFERENCIA PARA O ARMAZEM 02 FOI ABORTADO')
   endif   
return
user function LocalT3()
   if msgyesno("Voce em certeza que DESEJA transferir todos os itens para o Armazem 03?")
               IF dbseek(xfilial('SD1')+  SD1->(MV_PAR07+MV_PAR09+MV_PAR05)  )
               WHILE SD1->D1_DOC = MV_PAR07 .and. SD1->D1_SERIE = MV_PAR09 .and. SD1->D1_FORNECE = MV_PAR05 
                  reclocK('SD1',.f.)
                  replace d1_local  with '03'
                  replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'03'                  
                  replace d1_movest with DATE() 
                  msunlock()
                  SD1->(DBSKIP())
               alert('transferencia TOTAL para o armazem 03 realizada com sucesso !!')
               END
               endif
   else
      alert('PROCESSO DE TRANSFERENCIA PARA O ARMAZEM 03 FOI ABORTADO')
   endif   
return
user function LocalT4()
   if msgyesno("Voce em certeza que DESEJA transferir todos os itens para o Armazem AN?")
               IF dbseek(xfilial('SD1')+  SD1->(MV_PAR07+MV_PAR09+MV_PAR05)  )
               WHILE SD1->D1_DOC = MV_PAR07 .and. SD1->D1_SERIE = MV_PAR09 .and. SD1->D1_FORNECE = MV_PAR05 
                  reclocK('SD1',.f.)
                  replace d1_local  with 'AN'
                  replace d1_chassi with __cUserId + '-'+dtoc(DATE())+'-'+substring(time(),1,5)+'AN' 
                  replace d1_movest with DATE()
                  msunlock()
                  SD1->(DBSKIP())
               alert('transferencia TOTAL para o armazem AN realizada com sucesso !!')
               END
               ENDIF
   else
      alert('PROCESSO DE TRANSFERENCIA PARA O ARMAZEM AN FOI ABORTADO')
   endif   
return
