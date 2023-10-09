#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'FWMVCDef.ch'
#INCLUDE 'rwmake.ch'

/*
PROJETO ALTERACAO DE TRANSPORTADORA EM MULTIPLOS CADASTROS DE CLIENTES

//****************************************************************************************
// SALON LINE
// FUNÇÃO		- Rotina - Alterar transportadora em multiplos clientes
// MODULO		- 
// AUTORIZAÇÃO	- Kelsen 
// AUTOR 		- Gustavo Luna / Salon Line - DATA 16/08/2022

// Criado consulta padrao(SXB):
//     SA1SL0

// MELHORIA
// 

//****************************************************************************************
*/

User Function FATP0019()

Local oDLgEd1       := Nil
Local nOpc          := 0

Private _cCodCl1  := "      "
Private _cTrns    := "      "
Private _cUF      := "  "
Private _oBrowse
Private _cCad     := "Vinculo Clientes x Transportadoras"
Private cMark := GetMark()
Private lMark := .T.
Private _cHrIni	  	:= StrTran( Time(), ":", "" )
Private _cPatch	  	:= "\logs_salon\FATP0019\Alteracao_FINxCLI"+ DTOS( Date() )+"-"+_cHrIni+".log"

Gravalog( _cPatch,  time()+" -  ")
Gravalog( _cPatch,  time()+" >> [FATP0019] - Iniciando a Rotina de alteração. Usuário:  " + RetCodUsr() + " - " + cUserName )
Gravalog( _cPatch,  time()+" >> ================================================================================"  )
Gravalog( _cPatch,  time()+" -  ")
Gravalog( _cPatch,  time()+" >> Data: "+DTOC(Date()) + " | Hora : "+Time() )
Gravalog( _cPatch,  time()+" -  ")
Gravalog( _cPatch,  time()+" -  ")

//Tela com opcoes para filtrar os clientes
DEFINE MSDIALOG oDLgEd1 TITLE "Filtros" From 1,0 To 200, 190 PIXEL

@ 018, 010 SAY "Cod Cliente:" of oDLgEd1 PIXEL
@ 015, 055 MsGet _cCodCl1 of oDLgEd1 F3 "SA1SL0" PIXEL SIZE 020,010

@ 038, 10 SAY "Cod. Transpor.:" of oDLgEd1 PIXEL
@ 035, 55 MsGet _cTrns of oDLgEd1 F3 "SA4" PIXEL SIZE 020,010

@ 058, 10 SAY "UF:" of oDLgEd1 PIXEL
@ 055, 55 MsGet _cUF of oDLgEd1 F3 "12" PIXEL SIZE 020,010

DEFINE SBUTTON FROM 080,018 TYPE 1 ACTION (nOpc := 1, oDLgEd1:End()) ENABLE OF oDLgEd1 PIXEL
DEFINE SBUTTON FROM 080,052 TYPE 2 ACTION oDLgEd1:End() ENABLE OF oDLgEd1 PIXEL
ACTIVATE MSDIALOG oDLgEd1 CENTER

If nOpc > 0
    Gravalog( _cPatch,  time()+" Filtro Setado - Cod Cli:  " + _cCodCl1 + " - Cond Transp.:" + _cTrns + " - UF: " + _cUF)
    Gravalog( _cPatch,  time()+" -  ")
    Processa( { || CLIXTRAN() },"Aguarde...", "Carregando Informações..." )
EndIf

Return

Static Function CLIXTRAN()

Local _cQry	        := ""
Local _cTMP         := "_cTMP"
Local _cArqTrb
Local _aCampos	    := {}
Local _aSeek        := {}
Local _cInd1, _cInd2, _cInd3, _cInd4 := ""

If Select(_cTMP) > 0
	_cTMP->( dbCloseArea() )
EndIf

//Query que buscara os clientes a serem alterados
_cQry := " SELECT '' 'MARK', A1_COD 'CODIGO', A1_LOJA 'LOJA', A1_NOME 'NOME',                                                            " + CRLF
_cQry += " A1_NREDUZ 'NREDUZCLI', A1_CGC 'CGC', A1_EST 'UF', A4_COD 'CODTRANSP', A4_NOME 'NOMETRANSP', A4_NREDUZ 'NREDUZTRAN'            " + CRLF
_cQry += " FROM " + RetSqlName( "SA1" ) + " SA1                                                                                          " + CRLF
_cQry += " LEFT JOIN " + RetSqlName( "SA4" ) + " SA4 ON A4_COD = A1_TRANSP AND SA4.D_E_L_E_T_ = ''                                       " + CRLF
_cQry += " WHERE SA1.D_E_L_E_T_ =''                                                                                                      " + CRLF
If !Empty(_cCodCl1)
    _cQry += " AND SA1.A1_COD ='"+_cCodCl1 +"'                                                                                           " + CRLF
EndIf
If !Empty(_cTrns)
    _cQry += " AND SA1.A1_TRANSP ='"+_cTrns +"'                                                                                          " + CRLF
EndIf
If !Empty(_cUF)
    _cQry += " AND SA1.A1_EST ='"+_cUF +"'                                                                                               " + CRLF
EndIf
_cQry += " ORDER BY CODIGO, LOJA                                                                                                         " + CRLF
dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQry ), _cTMP , .F., .T. )

AAdd(_aCampos,{"MARK"  	         ,"C",002,0}) //Este campo será usado para marcar/desmarcar
AAdd(_aCampos,{"CODIGO"          ,"C",006,0})
AAdd(_aCampos,{"LOJA"            ,"C",002,0})
AAdd(_aCampos,{"NOME"            ,"C",040,0})
AAdd(_aCampos,{"NREDUZCLI"       ,"C",020,0})
AAdd(_aCampos,{"CGC"             ,"C",014,0})
AAdd(_aCampos,{"UF"              ,"C",002,0})
AAdd(_aCampos,{"CODTRANSP"       ,"C",006,0})
AAdd(_aCampos,{"NOMETRANSP"      ,"C",040,0})
AAdd(_aCampos,{"NREDUZTRAN"      ,"C",020,0})

If Select("TRB") > 0
    dbSelectArea("TRB")
    TRB->( dbCloseArea() )
Endif

_cArqTrb   := CriaTrab(_aCampos,.T.)
_cInd1 := Alltrim(CriaTrab(,.F.))
_cInd2 := _cInd1
_cInd3 := _cInd1
_cInd4 := _cInd1

_cInd1 := Left(_cInd1,5) + Right(_cInd1,2) + "A"
_cInd2 := Left(_cInd2,5) + Right(_cInd2,2) + "B"
_cInd3 := Left(_cInd3,5) + Right(_cInd3,2) + "C"
_cInd4 := Left(_cInd4,5) + Right(_cInd4,2) + "D"

If File(_cInd1+OrdBagExt())
    FErase(_cInd1+OrdBagExt())
EndIf
If File(_cInd2+OrdBagExt())
    FErase(_cInd2+OrdBagExt())
EndIf
If File(_cInd3+OrdBagExt())
    FErase(_cInd3+OrdBagExt())
EndIf
If File(_cInd4+OrdBagExt())
    FErase(_cInd4+OrdBagExt())
EndIf

dbUseArea(.T.,,_cArqTrb,"TRB",Nil,.F.)
IndRegua("TRB", _cInd1, "CODIGO" ,,, "Index Cod Cliente")
IndRegua("TRB", _cInd2, "NOME"   ,,, "Index Nome Cliente")
IndRegua("TRB", _cInd3, "CGC"    ,,, "Index CGC Cliente")
dbClearIndex()
dbSetIndex(_cInd1+OrdBagExt())
dbSetIndex(_cInd2+OrdBagExt())
dbSetIndex(_cInd3+OrdBagExt())

dbSelectArea(_cTMP)
dbGoTop()

//monta o trb com as informacaoes buscadas
While _cTMP->( !EOF() )
        If RecLock("TRB",.t.)
            TRB->MARK                   := _cTMP->MARK
            TRB->CODIGO                 := _cTMP->CODIGO
            TRB->LOJA                   := _cTMP->LOJA
            TRB->NOME                   := _cTMP->NOME
            TRB->NREDUZCLI              := _cTMP->NREDUZCLI
            TRB->CGC                    := _cTMP->CGC
            TRB->UF                     := _cTMP->UF
            TRB->CODTRANSP              := _cTMP->CODTRANSP
            TRB->NOMETRANSP             := _cTMP->NOMETRANSP
            TRB->NREDUZTRAN             := _cTMP->NREDUZTRAN
            MsUnLock()
            Gravalog( _cPatch,  time()+" Dados tela - Cod Cli:  " + _cTMP->CODIGO + "/" + _cTMP->LOJA + " - Transp.: " +_cTMP->CODTRANSP)
            Gravalog( _cPatch,  time()+" -  ")
        Endif
        TRB->(DbGoTop())
        _cTMP->(dbSkip())
EndDo

aAdd(_aSeek,{"Cod Cliente"	 ,{{"","C",006,0,"CODIGO"    ,1,}}, NIL } )
aAdd(_aSeek,{"Nome Cliente"  ,{{"","C",030,0,"NOME"      ,2,}}, NIL } )
aAdd(_aSeek,{"CGC Cliente"   ,{{"","C",014,0,"CGC"       ,3,}}, NIL } )

If TRB->(!Eof())
    _oBrowse := FWMarkBrowse():New()
    _oBrowse:SetMenuDef("")
    _oBrowse:SetDescription(_cCad)
    _oBrowse:SetFieldMark( 'MARK' ) 
    _oBrowse:SetAlias("TRB")
    _oBrowse:SetSeek(.T.,_aSeek)
    _oBrowse:SetMark( cMark, "TRB", 'MARK' )
    _oBrowse:SetIgnoreARotina(.T.)
    _oBrowse:SetAllMark( { || MarcTds()})
    _oBrowse:SetTemporary(.T.)

    _oBrowse:SetColumns(_Colum("CODIGO"	        ,"Codigo Cliente"		,02,"@!",0,006,0))
    _oBrowse:SetColumns(_Colum("LOJA"           ,"Loja Cliente"	        ,03,"@!",0,002,0))
    _oBrowse:SetColumns(_Colum("NOME"           ,"Nome Cliente"	        ,04,"@!",0,040,0))
    _oBrowse:SetColumns(_Colum("NREDUZCLI"      ,"Nome Fantasia"	    ,05,"@!",0,020,0))
    _oBrowse:SetColumns(_Colum("CGC"	        ,"CGC Cliente"	        ,06,"@!",0,014,0))
    _oBrowse:SetColumns(_Colum("UF"	            ,"Estado Cliente"	    ,07,"@!",0,002,0))
    _oBrowse:SetColumns(_Colum("CODTRANSP"	    ,"Cod Transpor."	    ,08,"@!",0,006,0))
    _oBrowse:SetColumns(_Colum("NOMETRANSP"	    ,"Nome Transpor."	    ,09,"@!",0,040,0))
    _oBrowse:SetColumns(_Colum("NREDUZTRAN"	    ,"Nome Fantasia"	    ,10,"@!",0,020,0))

    _oBrowse:AddButton("Alterar transportadora"    , { || SelectTr() },,,, .F., 2 )

    _oBrowse:Activate()

Else
    Return
EndIf

If !Empty(_cArqTrb)
    Ferase(_cArqTrb+GetDBExtension())
    Ferase(_cArqTrb+OrdBagExt())
    _cArqTrb := ""
    TRB->(DbCloseArea())
Endif

Return

Static Function MarcTds()

Local _cAliasTRB    := "TRB"

dbSelectArea(_cAliasTRB)
(_cAliasTRB)->(dbGoTop())

While !(_cAliasTRB)->(Eof())

    RecLock(_cAliasTRB, .F.)
        If lMark
            (_cAliasTRB)->MARK := cMark
        Else
            (_cAliasTRB)->MARK := ""
        EndIf
    MsUnLock()
    (_cAliasTRB)->( dbSkip() )
EndDo
lMark := !lMark
_oBrowse:Refresh(.T.)
_oBrowse:oBrowse:Refresh()

Return

//tela que seleciona a transportadora a ser cadastrada nos clientes
Static Function SelectTr()

Local oDLgEdt       := Nil
Local nOpcClick     := 0
Local cDado1        := "      "

DEFINE MSDIALOG oDLgEdt TITLE "Transportadora" From 1,0 To 110, 400 PIXEL

@ 005, 010 SAY "Selecione a Transportadora que deseja aplicar nos clientes selecionados:" ;
of oDLgEdt PIXEL

@ 023, 70 SAY "Cod. Transpor.:" of oDLgEdt PIXEL
@ 020, 110 MsGet cDado1 of oDLgEdt Valid (existcpo("SA4", cDado1)) F3 "SA4" PIXEL SIZE 020,010

DEFINE SBUTTON FROM 040,130 TYPE 1 ACTION (nOpcClick := 1, IIF( !Empty(cDado1), oDLgEdt:End(), .F.)) ENABLE OF oDLgEdt PIXEL
DEFINE SBUTTON FROM 040,160 TYPE 2 ACTION oDLgEdt:End() ENABLE OF oDLgEdt PIXEL
ACTIVATE MSDIALOG oDLgEdt CENTER

If nOpcClick > 0 
    Gravalog( _cPatch,  time()+" Transp. selecionada para alteração:  " + cDado1 )
    Gravalog( _cPatch,  time()+" -  ")
    Processa( { || AlterTr(cDado1) },"Aguarde...", "Processando Informações..." )
EndIf

Return

//altera os dados dos clientes selecionados
Static Function AlterTr(cDado1)

Local _cAliasTRB    := "TRB"
Local _aDados       := {}
Local lTdOk         := .T.

Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.

dbSelectArea(_cAliasTRB)
(_cAliasTRB)->(dbGoTop())

Begin Transaction

While !(_cAliasTRB)->(Eof())
    _aDados := {}
    If !Empty((_cAliasTRB)->MARK)
        DbSelectArea("SA1")
        ("SA1")->(DbSetOrder(1))
        ("SA1")->(DbSeek(xFilial("SA1")+(_cAliasTRB)->CODIGO+(_cAliasTRB)->LOJA))

        DbSelectArea("SA4")
        ("SA4")->(DbSetOrder(1))
        ("SA4")->(DbSeek(xFilial("SA4")+cDado1))

        _aDados := { {"A1_COD",     ("SA1")->A1_COD , Nil} ,;
                     {"A1_LOJA",    ("SA1")->A1_LOJA, Nil} ,;
                     {"A1_TRANSP",  cDado1          , Nil} }
        
        Gravalog( _cPatch,  time()+" Alterando Transp. do Cliente:  " + ("SA1")->A1_COD + "/" + ("SA1")->A1_LOJA ;
        + " de: " + ("SA1")->A1_TRANSP + " para: " + cDado1)
        Gravalog( _cPatch,  time()+" -  ")
        lMsErroAuto := .F.
        MSExecAuto({|x,y| Mata030(x,y)},_aDados,4) //3- Inclusão, 4- Alteração, 5- Exclusão

        If !lMsErroAuto
            RecLock(_cAliasTRB, .F.)
            (_cAliasTRB)->MARK          := ""
            (_cAliasTRB)->CODTRANSP     := ("SA4")->A4_COD 
            (_cAliasTRB)->NOMETRANSP    := ("SA4")->A4_NOME
            (_cAliasTRB)->NREDUZTRAN    := ("SA4")->A4_NREDUZ
            MsUnLock()
        Else
            lTdOk := .F.
            Gravalog( _cPatch,  time()+" - ERRO!!! : Não foi possível alterar o cadastro do cliente " +  ("SA1")->A1_COD + "/" + ("SA1")->A1_LOJA)
            Gravalog( _cPatch,  time()+" -  ")
            DisarmTransaction()
            MsgAlert("Não foi possível alterar o cadastro do cliente " +  ("SA1")->A1_COD + "/" + ("SA1")->A1_LOJA ;
            , "Erro!")
            MostraErro()
            _oBrowse:Refresh(.T.)
            _oBrowse:oBrowse:Refresh()
            Break
            Return
        EndIf
    EndIf

    (_cAliasTRB)->( dbSkip() )
EndDo

End Transaction

If lTdOk
    Gravalog( _cPatch,  time()+" - ALTEROU TODOS OS DADOS COM SUCESSO! ")
    Gravalog( _cPatch,  time()+" -  ")
    MsgInfo("Cadastros alterados com sucesso!", "Processo...")
EndIf
lMark := .T.
_oBrowse:Refresh(.T.)
_oBrowse:oBrowse:Refresh()

Return

Static Function _Colum(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)

Local aColumn
Local bData 	:= {||}
Default nAlign 	:= 1
Default nSize 	:= 20
Default nDecimal:= 0
Default nArrData:= 0  

If nArrData > 0
    bData := &("{||" + cCampo +"}") //&("{||_oBrowse:DataArray[_oBrowse:At(),"+STR(nArrData)+"]}")
EndIf

/* Array da coluna
[n][01] Título da coluna
[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Máscara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a edição
[n][09] Code-Block de validação da coluna após a edição
[n][10] Indica se exibe imagem
[n][11] Code-Block de execução do duplo clique
[n][12] Variável a ser utilizada na edição (ReadVar)
[n][13] Code-Block de execução do clique no header
[n][14] Indica se a coluna está deletada
[n][15] Indica se a coluna será exibida nos detalhes do Browse
[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
*/
aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}


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
