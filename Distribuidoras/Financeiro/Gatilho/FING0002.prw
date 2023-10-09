#INCLUDE 'PROTHEUS.CH'

/* 
Gatilho para bloquear inclusão de títulos com tipo NCC no Contas a Receber.
Solicitante: Jacqueline Fárias
*/
User function FING0002() 
Local cUserId   := RetCodUsr()
Local cTipo     := M->E1_TIPO

If cTipo == 'NCC' .And. !(cUserId $ GETMV("ES_FING02")) // Parametros dos usuários com permissão para incluir Título com tipo NCC
    ALERT("Tipo NCC NÃO AUTORIZADO para lançamento Manual no Modulo Financeiro !") 
    cTipo := Space(3)
EndIf

Return cTipo
