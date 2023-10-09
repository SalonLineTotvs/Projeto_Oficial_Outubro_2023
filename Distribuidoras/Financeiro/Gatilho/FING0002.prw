#INCLUDE 'PROTHEUS.CH'

/* 
Gatilho para bloquear inclus�o de t�tulos com tipo NCC no Contas a Receber.
Solicitante: Jacqueline F�rias
*/
User function FING0002() 
Local cUserId   := RetCodUsr()
Local cTipo     := M->E1_TIPO

If cTipo == 'NCC' .And. !(cUserId $ GETMV("ES_FING02")) // Parametros dos usu�rios com permiss�o para incluir T�tulo com tipo NCC
    ALERT("Tipo NCC N�O AUTORIZADO para lan�amento Manual no Modulo Financeiro !") 
    cTipo := Space(3)
EndIf

Return cTipo
