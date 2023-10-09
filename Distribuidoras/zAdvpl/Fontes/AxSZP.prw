#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Fileio.ch"

#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ AxSZP  º Autor ³ Genesis/Gustavo    º Data ³    /  /       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Documentos...                                  º±±
±±º          ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/         
*-----------------*
User Function AxSZP
*-----------------* 
Private _aCores := {	{ 'ZP_MSBLQL == "1"'				, 'BR_VERMELHO' },;
						{ 'ZP_MSBLQL <> "1"'				, 'BR_VERDE'    } }
						
PRIVATE aRotina := { 	{OemToAnsi("Pesquisar") 	        ,"AxPesqui"  	,00,01	},;
						{OemToAnsi("Visual")		        ,"AxVisual"		,00,02	},;
						{OemToAnsi("Incluir")		        ,"AxInclui"		,00,03	},;
						{OemToAnsi("Alterar")		        ,"AxAltera"		,00,04	},;
						{OemToAnsi("Excluir")  		        ,"u_zSZPDel"	,00,05	},;
                        {OemToAnsi("@ Armazenar PDF")	    ,"u_xSZPImp"	,00,03	},;
                        {OemToAnsi("@ Exportar PDF")	    ,"u_xSZPExp"	,00,04	},;
                        {OemToAnsi("@ Visualizar PDF")	    ,"u_xSZPVis"	,00,04	},;
                        {OemToAnsi("@ Envio do Certificado"),"u_ASZP2SD2"	,00,04	},;                        
						{OemToAnsi("Legenda")   	        ,"u_xSZPLegen" 	,00,01	} }                                              

//Define o cabecalho da tela de atualizacoes 
PRIVATE cCadastro := OemToAnsi("Controle de Documentos - Sunnyvale")

dbSelectArea("SZP")
SZP->(dbSetOrder(1))
mBrowse(06,01,22,75,"SZP",,,,,,_aCores)

Return                  

*-------------------*
User Function zSZPDel
*-------------------*

If MsgYesNo('Confirma a exclusão do documento ?',"Controle de Documentos - Sunnyvale")
    IF  Reclock("SZP",.F.)
            SZP->(dbdelete())
        SZP->(MsUnlock())
    ENDIF
    //_nOk := AxDeleta("SZT",SZT->(RECNO()),5)	
    //IF _nOk == 3
Endif

Return

*----------------------*
User Function xSZPLegen
*----------------------*        
BrwLegenda(OemToAnsi("Controle de Documentos - Sunnyvale")  ,;
						"LEGENDA", { {"ENABLE"  ,"Habiliado"},;
									 {"DISABLE" ,"Bloqueado" }})
Return


//https://terminaldeinformacao.com/2019/04/13/como-diminuir-o-tamanho-de-um-arquivo-pdf-utilizando-o-foxit-pdf/
//https://terminaldeinformacao.com/2021/06/16/como-usar-o-banco-de-conhecimento/
//https://terminaldeinformacao.com/2020/09/04/como-importar-arquivos-para-o-banco-de-conhecimento/

*--------------------*
User Function xSZPImp
*--------------------*
Local _aSZP := Array(6,'')

//Carrega daddos para SZP
_aSZP[1] := ''
_aSZP[2] := 'SZP'
_aSZP[3] := 'AxSZP'
_aSZP[4] := 'Arquivos Manuais'
_aSZP[5] := ''

If ExistBlock("zSZPIAuto")
    ExecBlock("zSZPIAuto",.F.,.F.,_aSZP)
ENDIF 
Return

*--------------------*
User Function xSZPExp
*--------------------*
Local _aSZP  := Array(6,'')

//Carrega daddos para SZP
_aSZP[1] := SZP->(Recno())
_aSZP[2] := .F.

If ExistBlock("zSZPEAuto")
    ExecBlock("zSZPEAuto",.F.,.F.,_aSZP)
ENDIF 
Return

*--------------------*
User Function xSZPVis
*--------------------*
Local _aSZP  := Array(6,'')

//Carrega daddos para SZP
_aSZP[1] := SZP->(Recno())
_aSZP[2] := 'Controle de Documentos - Sunnyvale'
            
If ExistBlock("zSZPVAuto")
    ExecBlock("zSZPVAuto",.F.,.F.,_aSZP)
ENDIF 
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ zAbreArq  º Autor ³ Genesis/Gustavo    º Data ³    /  /    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± Função para abrir arquivos conforme preferências do Sistema Operacional¹±±
±± u_zAbreArq("E:\Documentos\","novo.pdf")                                ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
*--------------------------------------*
User Function zAbreArq(cDirP, cNomeArqP)
*--------------------------------------*
Local aArea := GetArea()
 
//Tentando abrir o objeto
nRet := ShellExecute("open", cNomeArqP, "", cDirP, 1)
 
//Se houver algum erro
If nRet <= 32
    MsgStop("Não foi possível abrir o arquivo " +cDirP+cNomeArqP+ "!", "Atenção")
EndIf 
 
RestArea(aArea)
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xSZPAuto  º Autor ³ Genesis/Gustavo    º Data ³    /  /    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± Função para GRAVAR dados na tabela SZP - Controle de Documentos        ¹±±
±± 'Chave','Tabela','Funname','Descricao','Chave ITem'                    ¹±±
±± Exemplo: 'PV','SC6','MATA410','Desenho Engenharia','ITEM+PROD'         ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
*---------------------*
User Function zSZPIAuto
*---------------------*
Local _aParam       := ParamIxb
Local _aArea        := GetArea()
Local aFiles        := {} // O array receberá os nomes dos arquivos e do diretório
Local aSizes        := {} // O array receberá os tamanhos dos arquivos e do diretorio
Local _cTempOri     := GetTempPath()
Local _cTempDes     := AllTrim(GetMv("MV_DIREST",.F.,'C:\TEMP\'))
Local _nP           := 0
Local _ctargetDir   := ''
Local _aDirSel      := {}
Local _cDirNo       := ''
Local _cTexto64     := ''
Local nHandle       := ''

Local _n1MB         := (1024*1024) //Calculo de Mege Bytes
Local _nMax_MB      := 1
Local _cLogVld      := ''

//Funções para validação dos dados do INI
Local cServerIni    := GetAdv97()
Local cClientIni    := GetRemoteIniName()
Local _cAmbienet    := GetEnvServer()
Local _cDb_Secao    := "DBAccess"      //vamos ser os parametros da seção [General]
Local _cDb_Chave    := "MemoMega"      //qual chave queremos retornar o valor
Local _cDb_Padrao   := "NaoEncontrado" //se nao encontrar esse é o valor padrao a ser retornado
Local _cEn_Secao    := _cAmbienet      //vamos ser os parametros da seção [General]
Local _cEn_Chave    := "TopMemoMega"   //qual chave queremos retornar o valor

//Retorna o MemoMega do DBAccess (ini ambiente)
_cRet_Dba := GetPvProfString(_cDb_Secao, _cDb_Chave, _cDb_Padrao, cServerIni)
//Retorna o TopMemoMega do ambiente logado
_cRet_Env := GetPvProfString(_cEn_Secao, _cEn_Chave, _cDb_Padrao, cServerIni)

IF _cRet_Dba <> _cRet_Env
        _cPopUp := ' <font color="#A4A4A4" face="Arial" size="7">Atenção</font> '
        _cPopUp += ' <br> '
        _cPopUp += ' <font color="#FF0000" face="Arial" size="2">Divergencia de Ambiente</font> '
        _cPopUp += ' <br><br> '
        
        _cPopUp += ' <font color="#000000" face="Arial" size="3">Ambiente: '+_cAmbienet+'</font> '
        _cPopUp += ' <br>'
        _cPopUp += ' <font color="#000000" face="Arial" size="3">Chave: '+_cEn_Chave+' - Conteudo: '+_cRet_Env+' Mb </font> '
        _cPopUp += ' <br>'
        _cPopUp += ' <font color="#000000" face="Arial" size="3">Chave: '+_cDb_Chave+' - Conteudo: '+_cRet_Dba+' Mb </font> '

        _cPopUp += ' <br><br> '
        _cPopUp += ' <font color="#000000" face="Arial" size="2">Necessári ajuste no INI ['+cServerIni+']</font> <br>'
        _cPopUp += ' <br><br> '

        MsgAlert(_cPopUp,'Bloqueio Exlcuir Residuo')
    Return
Else 
    _nMax_MB := VAL(_cRet_Env)
ENDIF

IF Len(_aParam) >= 5

    IF FWIsInCallStack("U_zMT120FIM")
        _ctargetDir := _aParam[6]
    ELSE
        _ctargetDir := tFileDialog( "All files (*.*) | All Text files (*.txt) ",'Selecao de Arquivos',, _cTempOri, .F., GETF_MULTISELECT )
    ENDIF
    _aDirSel    := Separa(_ctargetDir,';',.T.)

    For _nP:=1 To Len(_aDirSel)
        aFiles := {}; aSizes := {}
        IF File(_aDirSel[_nP])
            ADir(_aDirSel[_nP], aFiles, aSizes) //Verifica o tamanho do arquivo, parâmetro exigido na FRead.

            nHandle := fOpen(_aDirSel[_nP] , FO_READWRITE + FO_SHARED )
            cString := ""
            FRead( nHandle, cString, aSizes[1] ) //Carrega na variável cString, a string ASCII do arquivo.

            _cTexto64 := Encode64(cString) //Converte o arquivo para BASE64
                        
            fClose(nHandle) //Fecha arquivo log temp

            //Valida tamanho do arquivos
            IF (aSizes[1] /_n1MB) > _nMax_MB
                _cLogVld += 'Arquivo: '+_aDirSel[_nP] +ENTER
                _cLogVld += 'Tamanho: '+TransForm((aSizes[1] /_n1MB),'@E 999,999.999') +' MegaBytes'+ENTER+ENTER
                Loop
            ENDIf

            //Valida tamanho do arquivos
            IF zJaExist(_aDirSel[_nP],_aParam[5])
                _cLogVld += 'Duplicidade: '+_aDirSel[_nP] +ENTER+ENTER
                Loop
            ENDIf

            IF !Empty(_cTexto64)
                    _cNameDir := Separa(_aDirSel[_nP],'\',.T.)[Len(Separa(_aDirSel[_nP],'\',.T.))]
                IF  RecLock('SZP',.T.)
                        Replace SZP->ZP_FILIAL  With FwxFilial('SZP')
                        Replace SZP->ZP_CODIGO  With _aParam[1]
                        Replace SZP->ZP_TABELA  With _aParam[2]
                        Replace SZP->ZP_ORIGEM  With _aParam[3]
                        Replace SZP->ZP_DIRDOC  With _aDirSel[_nP]
                        Replace SZP->ZP_ARQUIVO With AllTrim(_cNameDir)
                        Replace SZP->ZP_NOME    With _aParam[4]
                        Replace SZP->ZP_BASE64  With _cTexto64
                        Replace SZP->ZP_CHAVE   With AllTrim(iIF(!Empty(_aParam[5]), _aParam[5], StrTran(Upper(_cNameDir),'.PDF','')))
                        Replace SZP->ZP_MSBLQL  With CriaVar('ZP_MSBLQL')
                    SZP->(MsUnLock())
                ENDIF
            ENDIF
        Else
            _cDirNo += _aDirSel[_nP]
        EndIF
    Next _nP
ENDIF

IF !Empty(_cLogVld)
    u_zMsgLog(_cLogVld, "Log - Controle de Documentos ", 1, .T.)
ENDIF

RestArea(_aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ zSZPEAuto  º Autor ³ Genesis/Gustavo    º Data ³    /  /   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± Função para EXPORTAR dados na tabela SZP - Controle de Documentos      ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
*--------------------------------*
Static Function zJaExist(_cNewArq,_cChvArq)
*--------------------------------*
Local _lExist   := .F.
Local _cNomeArq :=  Upper(Separa(_cNewArq,'\',.T.)[Len(Separa(_cNewArq,'\',.T.))])
Local _cQryZP   := ''
Local _lDel     := FWIsInCallStack("U_zMT120FIM")

_cQryZP += " SELECT SZP.R_E_C_N_O_ RECSZP "+ENTER
_cQryZP += "  FROM "+RetSQLName('SZP')+" SZP (NOLOCK) "+ENTER
_cQryZP += "    WHERE SZP.D_E_L_E_T_ = ''  "+ENTER
_cQryZP += "      AND ZP_FILIAL         = '"+xFilial('SZP')+"' "+ENTER
_cQryZP += "      AND ( UPPER(ZP_ARQUIVO) = '"+_cNomeArq+"' "+ENTER
_cQryZP += "            OR
_cQryZP += "            ZP_CHAVE = '"+_cChvArq+"' "+ENTER
_cQryZP += "          )"+ENTER

IF Select('_DIR') > 0
	_DIR->(DbCloseArea())
EndIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryZP),'_DIR',.F.,.T.)
DbSelectArea('_DIR');_DIR->(DbGoTop())
_nMax := Contar('_DIR',"!Eof()"); _DIR->(DbGoTop())

//Processo onde sera deteltado o arquivos para geracao do novo
IF _lDel
    While _DIR->(!Eof())
        DbSelectArea('SZP'); SZP->(DbGoTo(_DIR->RECSZP))
        IF SZP->(Recno()) == _DIR->RECSZP
            IF 	Reclock("SZP",.F.)
                    SZP->(dbdelete())
                SZP->(MsUnlock())	
            ENDIF	
        ENDIF
        _DIR->(DbSkip())
    EndDo
Else
    IF !Empty(_cNomeArq) .And. !Empty(_DIR->RECSZP)
        _lExist := .T.
    ENDIF
ENDIF

Return(_lExist)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ zSZPEAuto  º Autor ³ Genesis/Gustavo    º Data ³    /  /   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± Função para EXPORTAR dados na tabela SZP - Controle de Documentos      ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
*---------------------*
User Function zSZPEAuto
*---------------------*
Local _aParam       := ParamIxb
Local _aArea        := GetArea()
Local _cTempDes     := AllTrim(GetMv("MV_DIREST",.F.,'C:\TEMP\'))
Local _cDirServ     := '\dirdoc\co'+cEmpAnt+'\'
Local _nP           := 0
Local _cDirNo       := ''
Local _cTexto64     := ''
Local nHandle       := ''
Local _lAuto        := .F.
Local _cGeraArq     := ''

//Função para criar diretório com seus subdiretórios, com a vantagem de criar todo o caminho.
FWMakeDir(_cDirServ)

//Chamado do ADVL ASP (Portal de Liberacao)
IF FWIsInCallStack("U_AWKFFILE")
    _cTempDes := _cDirServ
ENDIF

IF Len(_aParam) >= 2

    DbSelectArea('SZP'); SZP->(DbGoto(_aParam[1]))
    IF SZP->(Recno()) <> _aParam[1]
        Return
    EndIF
    _lAuto := _aParam[2]

    _cNameArq := Lower(AllTrim(SZP->ZP_ARQUIVO))
    _cGeraArq := Lower(_cTempDes+_cNameArq)
    _cTexto64 := SZP->ZP_BASE64
    fErase(_cGeraArq)

    IF !File(_cGeraArq)
        //Cria uma cópia do arquivo utilizando cTexto em um processo inverso(Decode64) para validar a conversão.    
        nHandle := fCreate(_cGeraArq)
        FWrite(nHandle, Decode64(_cTexto64))
        fclose(nHandle)

        IF File(_cGeraArq) .And. !_lAuto
            u_zAbreArq(_cTempDes,_cNameArq)
        ENDIF
    ELSE
        _cDirNo += _cGeraArq
    ENDIF
Endif

RestArea(_aArea)
Return(_cGeraArq)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ zSZPEAuto  º Autor ³ Genesis/Gustavo    º Data ³    /  /   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± Função para EXPORTAR dados na tabela SZP - Controle de Documentos      ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
*---------------------*
User Function zSZPVAuto
*---------------------*
Local _aParam       := ParamIxb
Local _aArea        := GetArea()
Local _cTempDes     := AllTrim(GetMv("MV_DIREST",.F.,'C:\TEMP\'))
Local _nP           := 0
Local _cDirNo       := ''
Local _cTexto64     := ''
Local nHandle       := ''
Local _cLegCab      := ''
Local cBaseUrl      := "https://www.w3schools.com/html/"
Local cHtml         := "<!DOCTYPE html>"+;
                        "<html>"+;
                            "<head>"+;
                                "<link rel='stylesheet' href='styles.css'>"+;
                            "</head>"+;
                            "<body>"+;
                                "<h1>TWebEngine com SetHtml</h1>"+;
                                "<p>Este HTML foi carregado através da função SetHtml!</p>"+;
                                "<br>"+;
                                "<img src='workplace.jpg' alt='Workplace'>"+;
                            "</body>"+;
                        "</html>"

//Tamanho da janela
Private aTamanho    := MsAdvSize()
Private nJanLarg    := aTamanho[5]
Private nJanAltu    := aTamanho[6]

//Navegador Internet
Private oWebChannel
Private nPort
Private oWebEngine
Private _oDlg

IF Len(_aParam) >= 2

    DbSelectArea('SZP'); SZP->(DbGoto(_aParam[1]))
    IF SZP->(Recno()) <> _aParam[1]
        Return
    EndIF

    _cLegCab  := ParamIxb[2]
    _cNameArq := Lower(AllTrim(SZP->ZP_ARQUIVO))
    _cGeraArq := Lower(_cTempDes+_cNameArq)
    _cTexto64 := SZP->ZP_BASE64
    fErase(_cGeraArq)

    IF !File(_cGeraArq)
        //Cria uma cópia do arquivo utilizando cTexto em um processo inverso(Decode64) para validar a conversão.    
        nHandle := fCreate(_cGeraArq)
        FWrite(nHandle, Decode64(_cTexto64))
        fclose(nHandle)

        IF File(_cGeraArq)
            DEFINE DIALOG _oDlg TITLE _cLegCab FROM 000,000 TO nJanAltu,nJanLarg PIXEL
            
                // Prepara o conector WebSocket
                PRIVATE oWebChannel := TWebChannel():New()
                nPort := oWebChannel:connect()
                
                // Cria componente
                oWebEngine := TWebEngine():New(_oDlg, 0, 0, 100, 100,_cGeraArq, nPort)

                //oWebEngine:bLoadFinished := {|self,url| conout("Termino da carga do pagina: " + url) }
                
                //Executa a navegação para URL selecionada
                //oWebEngine:navigate("http://totvs.com.br")
                
                oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT

                //Renderiza e exibe o código HTML informado.
                //oWebEngine:setHtml(cHtml, cBaseUrl)

            ACTIVATE DIALOG _oDlg CENTERED
            fErase(_cGeraArq)
        ENDIF
    ELSE
        _cDirNo += _cGeraArq
    ENDIF
Endif

Return
//______________________________________________________________________________________________________________________________
//______________________________________________________________________________________________________________________________
//______________________________________________________________________________________________________________________________

User Function xSZPPa2()
    Local aArea := GetArea()
 
    fMontaTela()
 
    RestArea(aArea)
Return
 
Static Function fMontaTela()
    Private nLargBtn      := 50

    //Objetos e componentes
    Private oDlgPulo
    Private oFwLayer
    Private oPanTitulo
    Private oPanGrid

    //Cabeçalho
    Private oSayModulo, cSayModulo := 'SPODS'
    Private oSayTitulo, cSayTitulo := 'Painel de Produção - Smart Pods'
    Private oSaySubTit, cSaySubTit := 'Exemplo usando FWLayer'

    //Tamanho da janela
    Private aSize := MsAdvSize(.F.)
    Private nJanLarg := aSize[5]
    Private nJanAltu := aSize[6]

    //Fontes
    Private cFontUti    := "Tahoma"
    Private oFontMod    := TFont():New(cFontUti, , -38)
    Private oFontSub    := TFont():New(cFontUti, , -20)
    Private oFontSubN   := TFont():New(cFontUti, , -20, , .T.)
    Private oFontBtn    := TFont():New(cFontUti, , -14)
    Private oFontSay    := TFont():New(cFontUti, , -12)

    //Grid
    Private aCampos     := {}
    Private cAliasTmp   := "TST_" + RetCodUsr()
    Private aColunas    := {}
 
    //Campos da Temporária
    aAdd(aCampos, { "CODIGO" , "C", TamSX3("BM_GRUPO")[1], 0 })
    aAdd(aCampos, { "DESCRI" , "C", TamSX3("BM_DESC")[1],  0 })
 
    //Cria a tabela temporária
    oTempTable:= FWTemporaryTable():New(cAliasTmp)
    oTempTable:SetFields( aCampos )
    oTempTable:Create()
 
    //Busca as colunas do browse
    aColunas := fCriaCols()
 
    //Popula a tabela temporária
    Processa({|| fPopula()}, "Processando...")
 
    //Cria a janela
    DEFINE MSDIALOG oDlgPulo TITLE "Painel de Produção - Smart Pods"  FROM 0, 0 TO nJanAltu, nJanLarg PIXEL
 
        //Criando a camada
        oFwLayer := FwLayer():New()
        oFwLayer:init(oDlgPulo,.F.)
 
        //Adicionando 3 linhas, a de título, a superior e a do calendário
        oFWLayer:addLine("TIT", 10, .F.)
        oFWLayer:addLine("COR", 90, .F.)
 
        //Adicionando as colunas das linhas
        oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
        oFWLayer:addCollumn("BLANKBTN",     040, .T., "TIT")
        oFWLayer:addCollumn("BTNSAIR",      010, .T., "TIT")
        oFWLayer:addCollumn("COLGRID",      100, .T., "COR")
 
        //Criando os paineis
        oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
        oPanSair   := oFWLayer:GetColPanel("BTNSAIR",    "TIT")
        oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")
 
        //Títulos e SubTítulos
        oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oPanHeader, "", oFontMod,  , , , .T., RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
        oSayTitulo := TSay():New(004, 065, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
        oSaySubTit := TSay():New(014, 065, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 300, 30, , , , , , .F., , )
 
        //Criando os botões
        oBtnSair := TButton():New(006, 001, "Fechar",             oPanSair, {|| oDlgPulo:End()}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )
 
        //Cria a grid
        oGetGrid := FWBrowse():New()
        oGetGrid:SetDataTable()
        oGetGrid:SetInsert(.F.)
        oGetGrid:SetDelete(.F., { || .F. })
        oGetGrid:SetAlias(cAliasTmp)
        oGetGrid:DisableReport()
        oGetGrid:DisableFilter()
        oGetGrid:DisableConfig()
        oGetGrid:DisableReport()
        oGetGrid:DisableSeek()
        oGetGrid:DisableSaveConfig()
        oGetGrid:SetFontBrowse(oFontSay)
        oGetGrid:SetColumns(aColunas)
        oGetGrid:SetOwner(oPanGrid)
        oGetGrid:Activate()

    Activate MsDialog oDlgPulo Centered
    oTempTable:Delete()
Return
 
Static Function fCriaCols()
    Local nAtual   := 0 
    Local aColunas := {}
    Local aEstrut  := {}
    Local oColumn
     
    //Adicionando campos que serão mostrados na tela
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    aAdd(aEstrut, {"CODIGO", "Código",                "C", TamSX3('BM_GRUPO')[01],   0, ""})
    aAdd(aEstrut, {"DESCRI", "Descrição",             "C", TamSX3('BM_DESC')[01],    0, ""})
 
    //Percorrendo todos os campos da estrutura
    For nAtual := 1 To Len(aEstrut)
        //Cria a coluna
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| (cAliasTmp)->" + aEstrut[nAtual][1] +"}"))
        oColumn:SetTitle(aEstrut[nAtual][2])
        oColumn:SetType(aEstrut[nAtual][3])
        oColumn:SetSize(aEstrut[nAtual][4])
        oColumn:SetDecimal(aEstrut[nAtual][5])
        oColumn:SetPicture(aEstrut[nAtual][6])
        oColumn:bHeaderClick := &("{|| fOrdena('" + aEstrut[nAtual][1] + "') }")
 
        //Adiciona a coluna
        aAdd(aColunas, oColumn)
    Next
Return aColunas
 
Static Function fPopula()
    Local nAtual := 0
    Local nTotal := 0
 
    DbSelectArea("SBM")
    SBM->(DbSetOrder(1))
    SBM->(DbGoTop())
 
    //Define o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
    SBM->(DbGoTop())
 
    //Enquanto houver itens
    While ! SBM->(EoF())
        //Incrementa a régua
        nAtual++
        IncProc("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
 
        //Grava na temporária
        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->CODIGO := SBM->BM_GRUPO
            (cAliasTmp)->DESCRI := SBM->BM_DESC
        (cAliasTmp)->(MsUnlock())
 
        SBM->(DbSkip())
    EndDo
Return

*-------------------*
User Function xSZPSD2
*-------------------*
Local _aParamBox := {}
Local _aRet      := {}
Local bOk        := {|| .T. } 
Local _cNF_De    := Space(9)
Local _cNF_Ate   := 'ZZZZZZZZZ'
Local _cSerie    := Space(3)
Local _lMTA410   := FwIsInCallStack('MATA410')

aAdd(_aParamBox,{9,"Documento de Documentos - Certificados"        ,150,7,.T.})
aAdd(_aParamBox,{1,"Emissao De"   ,dDataBase,"","","","",50,.T.}) // Tipo data
aAdd(_aParamBox,{1,"Emissao Ate"  ,dDataBase,"","","","",50,.T.}) // Tipo data
aAdd(_aParamBox,{1,"Nota Fisal De: ",  _cNF_De ,"@!",'.T.','SF2','.T.',120,.F.})
aAdd(_aParamBox,{1,"Nota Fisal De: ",  _cNF_aTE,"@!",'.T.','SF2','.T.',120,.T.})
aAdd(_aParamBox,{1,"Serie da NF",       _cSerie,"@!",'.T.','','.T.',120,.T.})


If ParamBox(_aParamBox,"Gerenciamento de Arquivos",@_aRet,bOk,,,,,,,.F.,.F.)
    //_aParam := {MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05, MV_PAR06}
    //U_xSZP2SD2(_aParam)
ENDIF


Return
