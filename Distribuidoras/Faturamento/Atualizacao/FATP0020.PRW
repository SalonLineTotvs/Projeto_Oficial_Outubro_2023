#Include 'totvs.ch'
#Include 'parmtype.ch'
#Include 'FWMVCDef.ch'
#Include 'rwmake.ch'

/*
PROJETO ALTERACAO DE DADOS FINANCEIROS NO CADASTROS DE CLIENTES ATRAVÉS DE IMPORTACAO DE CSV

//****************************************************************************************
// SALON LINE
// FUNÇÃO		- Rotina - Alteracao de dados financeiros no cadastro de clientes
// MODULO		- 
// AUTORIZAÇÃO	- Kelsen 
// AUTOR 		- Gustavo Luna / Salon Line - DATA 03/10/2022

// MELHORIA
// 

//****************************************************************************************
*/

User Function FATP0020()

Local cArq      := ""
Local cLinha    := ""
Local _lPrimlin := .T.
Local lValid    := .F.
Local nX        := 1

Private _aDados     := {}
Private _cHrIni	  	:= StrTran( Time(), ":", "" )
Private _cPatch	  	:= "\logs_salon\FATP0020\Alteracao_FINxCLI"+ DTOS( Date() )+"-"+_cHrIni+".log"

Gravalog( _cPatch,  time()+" -  ")
Gravalog( _cPatch,  time()+" >> [FATP0020] - Iniciando a Rotina de alteração. Usuário:  " + RetCodUsr() + " - " +cUserName )
Gravalog( _cPatch,  time()+" >> ================================================================================"  )
Gravalog( _cPatch,  time()+" -  ")
Gravalog( _cPatch,  time()+" >> Data: "+DTOC(Date()) + " | Hora : "+Time() )
Gravalog( _cPatch,  time()+" -  ")
Gravalog( _cPatch,  time()+" -  ")

//trás a tela de seleção de arquivo
cArq := Upper( Alltrim( cGetFile( "Arquivo CSV|*.csv", "Selecione o arquivo", 0, , .T., GETF_NETWORKDRIVE + GETF_LOCALHARD + GETF_LOCALFLOPPY) ) )

//se arquivo apontado, continua
If ! Empty( cArq )

    Gravalog( _cPatch,  time()+" - Arquivo: " + cArq)
    Gravalog( _cPatch,  time()+" -  ")

    //abre o arquivo para utilização
    FT_FUSE( cArq)
    ProcRegua( FT_FLASTREC( ) )
    FT_FGOTOP( )

    //leitura das linhas do arquivo
    While !FT_FEOF()
        IncProc("Lendo o arquivo...")
        cLinha := FT_FREADLN()

        //SE que verifica se é a primeira linha - cabeçalho
        If _lPrimlin
            FT_FSKIP()
            _lPrimlin := .F.
            loop
            //adiciona os dados da linha no array
        Else    
            AADD( _aDados, Separa( cLinha,";",.F.) )
        EndIf
        FT_FSKIP()
    EndDo

    Gravalog( _cPatch,  time()+" - Validando Arquivo... ")
    Gravalog( _cPatch,  time()+" -  ")
    
    If !Empty(_aDados)
        For nX := 1 To Len(_aDados)
            _aDados[nx][1] := STRZERO(Val(_aDados[nx][1]),6) //adiciona os '0's no codigo do cliente
            _aDados[nx][2] := STRZERO(Val(_aDados[nx][2]),2) //adiciona os '0's no loja do cliente
            DbSelectArea("SA1")
            ("SA1")->(DbSetOrder(1))
            If !("SA1")->(DbSeek(xFilial("SA1")+_aDados[nX][1]+_aDados[nX][2]))
                MsgAlert("Não foi possível localizar o Cliente: " + _aDados[nX][1]+"/"+_aDados[nX][2] + CRLF +;
                "Por favor, verifique a linha " + CValToChar(nx+1) + " do arquivo.", "Atenção!")
                Return
            EndIf
            If ! AllTrim(_aDados[nX][3]) $ ("ABCDE") .OR. Len(AllTrim(_aDados[nX][3])) > 1
                MsgAlert("Tipo de Risco Inválido: " + _aDados[nX][3] + CRLF +;
                "Por favor, verifique a linha " + CValToChar(nx+1) + " do arquivo.", "Atenção!")
                Return
            EndIf
            If CTOD(_aDados[nX][4]) < dDataBase
                MsgAlert("Data Inválida: " + _aDados[nX][4] + CRLF +;
                "Por favor, verifique a linha " + CValToChar(nx+1) + " do arquivo.", "Atenção!")
                Return
            EndIf
        Next nX
        lValid := .T.
    Else
        MsgAlert("Dados Importados Invalidos!", "Atenção!")
        Return
    EndIf

    If lValid
        Gravalog( _cPatch,  time()+" - Arquivo validado! ")
        Gravalog( _cPatch,  time()+" -  ")
        TELAVAL()
    Else
        Gravalog( _cPatch,  time()+" - Arquivo invalido! ")
        Gravalog( _cPatch,  time()+" -  ")
    EndIf
Else
    ApMsgInfo( "Arquivo não informado." + CRLF + "Favor selecionar um arquivo válido para a Importação dos valores!", "Atenção..." )
EndIf

Return

Static Function TELAVAL()

Local _lImporta := .F.
Local _oDlg
Local _oDados

DEFINE MSDIALOG _oDlg FROM 0,0 TO 510,800 TITLE "Importação dos dados financeiros" PIXEL

@ 030,002 TO 250,399 LABEL " Valores Importados " PIXEL COLOR CLR_RED OF _oDlg

@ 040,005 LISTBOX _oDados Fields HEADER " Codigo Cliente" , " Cliente Loja", " Risco Cliente", " Venc. Lim. Credito", " Lim. Credito" ;
COLSIZES 060, 040, 060, 060, 090 SIZE 393, 207 OF _oDlg PIXEL

_oDados:SetArray( _aDados )
_oDados:bLine := { || { 	_aDados[_oDados:nAt,1]			, _aDados[_oDados:nAt,2]									 ,;			
                            _aDados[_oDados:nAt,3]			, _aDados[_oDados:nAt,4]									 ,;
                            _aDados[_oDados:nAt,5] 	                                                                     } }

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar( _oDlg, { || _lImporta := .T., _oDlg:End() }, { || _lImporta := .F., _oDlg:End() } )

If _lImporta
    Gravalog( _cPatch,  time()+" - CONFIRMOU AS INFORMAÇÕES DO ARQUIVO ")
    Gravalog( _cPatch,  time()+" -  ")
    Processa( { || PROCESS() },"Aguarde...")
Else
    Gravalog( _cPatch,  time()+" - NÃO CONFIRMOU AS INFORMAÇÕES DO ARQUIVO ")
    Gravalog( _cPatch,  time()+" -  ")
EndIf
    
Return

Static Function PROCESS()

Local nX
Local _aClient  := {}
Local lTdOk     := .T.

Private lMsErroAuto := .F.

ProcRegua(Len(_aDados))

Begin Transaction

For nX := 1 To Len(_aDados)
    IncProc("Processando registro " + cValToChar(nX) + " de " + cValToChar(Len( _aDados)) + "...")
    
    DbSelectArea("SA1")
    ("SA1")->(DbSetOrder(1))
    If ("SA1")->(DbSeek(xFilial("SA1")+_aDados[nX][1]+_aDados[nX][2]))

        _aClient := {   {"A1_COD",     ("SA1")->A1_COD , Nil} ,;
                        {"A1_LOJA",    ("SA1")->A1_LOJA, Nil} ,;
                        {"A1_RISCO",   _aDados[nX][3]  , Nil} ,;
                        {"A1_VENCLC",  CTOD(_aDados[nX][4])  , Nil} ,;
                        {"A1_LC",      Val(Strtran(_aDados[nX][5],"." ,""))   , Nil}}

        Gravalog( _cPatch,  time()+" - GRAVANDO OS DADOS: ")
        Gravalog( _cPatch,  time()+" - CLIENTE: " + ("SA1")->A1_COD)
        Gravalog( _cPatch,  time()+" - LOJA: " + ("SA1")->A1_LOJA)
        Gravalog( _cPatch,  time()+" - RISCO: " + _aDados[nX][3])
        Gravalog( _cPatch,  time()+" - VECIMENTO: " +  _aDados[nX][4])
        Gravalog( _cPatch,  time()+" - VALOR: " + _aDados[nX][5])
        Gravalog( _cPatch,  time()+" -  ")
        lMsErroAuto := .F.
        MSExecAuto({|x,y| Mata030(x,y)},_aClient,4) //3- Inclusão, 4- Alteração, 5- Exclusão
    EndIf

    If lMsErroAuto
        lTdOk := .F.
        DisarmTransaction()
        Gravalog( _cPatch,  time()+" - ERRO!!! : Não foi possível alterar o cadastro do cliente " +  ("SA1")->A1_COD + "/" + ("SA1")->A1_LOJA)
        Gravalog( _cPatch,  time()+" -  ")
        MsgAlert("Não foi possível alterar o cadastro do cliente " +  ("SA1")->A1_COD + "/" + ("SA1")->A1_LOJA +;
        ". O processo será cancelado!", "Erro!")
        MostraErro()
        Break
        Return
    EndIf

Next nX

End Transaction

If lTdOk
    Gravalog( _cPatch,  time()+" - ALTEROU TODOS OS DADOS COM SUCESSO! ")
    Gravalog( _cPatch,  time()+" -  ")
    MsgInfo("Cadastros alterados com sucesso!", "Processo...")
EndIf

Return



// Function    : Gravalog
// Description : Funcao estatica que realiza a gravacao do arquivo de log

static function Gravalog( cFile, cText )

local nHandle

cText += chr(13) + chr(10)

if !file(cFile)

    if (nHandle := fCreate(cFile, 1)) = -1
        Gravalog( _cPatch,  time()+" >> Arquivo nao foi criado: ("+cFile+")")
    else
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif

else
    
    nHandle := fOpen(cFile, 2)
    nLength := fSeek(nHandle, 0, 2)
    
    if  nLength+len(cText)>=1048580
        
        fClose(nHandle)
        
        IF  fRename(cFile, cFile+"."+dtos(date())+"-"+alltrim(str(seconds()))) = -1
            Gravalog( _cPatch,  time()+" >> Arquivo nao foi renomeado: ("+cFile+")")
        endif
        
        gravalog(cFile,cText)
        
    endif
    
    if  fError() != 0
        Gravalog( _cPatch,  time()+" >> Arquivo nao foi aberto: ("+cFile+")")
    else
        cText := fReadStr(nHandle,nLength) + cText
        fWrite(nHandle, cText)
        fClose(nHandle)
    endif
endif

Return
