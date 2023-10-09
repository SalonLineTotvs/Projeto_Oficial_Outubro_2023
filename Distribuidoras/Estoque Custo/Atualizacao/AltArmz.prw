#include 'protheus.ch'
#include 'parmtype.ch'

USER FUNCTION altarmz()

LOCAL cAlias := "SD1"
PRIVATE cCadastro := "Itens Devolvidos e Pendentes de Classificacao do Armazem"
PRIVATE aRotina     := {}
AADD(aRotina, { "Pesquisar" , "AxPesqui", 0, 1 })
AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
dbSelectArea(cAlias)
dbSetOrder(1) 
set filter to sd1->d1_local = '90'
mBrowse(6, 1, 22, 75, cAlias)
RETURN NIL
 