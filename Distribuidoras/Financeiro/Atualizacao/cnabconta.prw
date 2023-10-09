#include 'protheus.ch'
#include 'parmtype.ch'

user function retbco()
   if ALLTRIM(se2->e2_xbco) <> ''
      return se2->e2_xbco
   endif
   if ALLTRIM(se2->e2_forbco) <> ''
      return se2->e2_forbco
   endif
   if ALLTRIM(sa2->a2_banco) <> ''
      return sa2->a2_banco
   endif
return

user function retage()
   if ALLTRIM(se2->e2_xagenc) <> ''
      return se2->e2_xagenc
   endif
   if ALLTRIM(se2->e2_forage) <> ''
      return se2->e2_forage
   endif
   if ALLTRIM(sa2->a2_agencia)<> ''
      return sa2->a2_agencia
   endif
return

user function retcta()
   if ALLTRIM(se2->e2_xcta) <> ''
      return substr(strzero(val(se2->E2_xcta),13),1,12)+" "+substr(strzero(val(se2->E2_xcta),13),13,1)
   endif
   if ALLTRIM(se2->E2_FORCTA+se2->E2_FCTADV) <> ''
      return strz(val(se2->E2_FORCTA),12)+" "+se2->E2_FCTADV
   endif
   if ALLTRIM(sa2->a2_numcon+sa2->a2_dvcta) <> ''
      return strz(val(sa2->a2_numcon),12)+" "+sa2->a2_dvcta
   endif
return

user function retcpf()
   if alltrim(se2->e2_xcnpj) <> ''
      return se2->e2_xcnpj
   else    
      return sa2->a2_cgc
   endif
return

user function retnom()
      return sa2->a2_nome
return

