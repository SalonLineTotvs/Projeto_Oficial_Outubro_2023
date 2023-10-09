    //Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zLimpaEsp
Função que limpa os caracteres especiais dentro de um campo
@type function
@author Genesis / Thiago
@param lEndereco, Lógico, Define se o campo é endereço (caso sim, o traço e vírgula serão ignorados)
    @example
    u_zLimpaEsp()
/*/
*----------------------------------------*
User Function zLimpaEsp(lEndereco,_lUpper)
*----------------------------------------*
    Local aArea       := GetArea()
    Local cCampo      := ReadVar()
    Local cConteudo   := &(cCampo)
    Local nTamOrig    := Len(cConteudo)
    lOCAL _cMaster    := ''
    lOCAL _cCpoMVC    := ''
    Local oModel      := FwModelActive()

    Default lEndereco := .F.
    Default _lUpper   := .T.
     
    //Retirando caracteres
    cConteudo := StrTran(cConteudo, "'", "")
    cConteudo := StrTran(cConteudo, "#", "")
    cConteudo := StrTran(cConteudo, "%", "")
    cConteudo := StrTran(cConteudo, "*", "")
    cConteudo := StrTran(cConteudo, "&", "E")
    cConteudo := StrTran(cConteudo, ">", "")
    cConteudo := StrTran(cConteudo, "<", "")
    cConteudo := StrTran(cConteudo, "!", "")
    cConteudo := StrTran(cConteudo, "@", "")
    cConteudo := StrTran(cConteudo, "$", "")
    cConteudo := StrTran(cConteudo, "(", "")
    cConteudo := StrTran(cConteudo, ")", "")
    cConteudo := StrTran(cConteudo, "_", "")
    cConteudo := StrTran(cConteudo, "=", "")
    cConteudo := StrTran(cConteudo, "+", "")
    cConteudo := StrTran(cConteudo, "{", "")
    cConteudo := StrTran(cConteudo, "}", "")
    cConteudo := StrTran(cConteudo, "[", "")
    cConteudo := StrTran(cConteudo, "]", "")
    cConteudo := StrTran(cConteudo, "/", "")
    cConteudo := StrTran(cConteudo, "?", "")
    cConteudo := StrTran(cConteudo, ".", "")
    cConteudo := StrTran(cConteudo, "\", "")
    cConteudo := StrTran(cConteudo, "|", "")
    cConteudo := StrTran(cConteudo, ":", "")
    cConteudo := StrTran(cConteudo, ";", "")
    cConteudo := StrTran(cConteudo, '"', '')
    cConteudo := StrTran(cConteudo, '°', '')
    cConteudo := StrTran(cConteudo, 'ª', '')
    cConteudo := StrTran(cConteudo, '~', '')
    cConteudo := StrTran(cConteudo, '  ', ' ')
     
    //Se não for endereço, retira também o - e a ,
    If !lEndereco
        cConteudo := StrTran(cConteudo, ",", "")
        cConteudo := StrTran(cConteudo, "-", "")
    EndIf

    //Upper
    IF _lUpper
        cConteudo := Upper(FwCutOff(FwNoAccent(cConteudo)))
        cConteudo := StrTran(cConteudo, '  ', ' ')
    ENDIF
     
    //Adicionando os espaços a direita
    cConteudo := Alltrim(cConteudo)
    cConteudo += Space(nTamOrig - Len(cConteudo))
     
    //Definindo o conteúdo do campo
    &(cCampo+" := '"+cConteudo+"' ")

    //Rotina MVC - precisa abrir o fonte de origem e encontra o nome do formulário. Pesquisa por "GetValue" - Exemplo: oModel:GetValue("MdFieldSBE","BE_LOCALIZ")
    IF Funname() == "MATA015"
        _cMaster := 'MdFieldSBE'
        _cCpoMVC := StrTran(cCampo,'M->','')
        _cValor  := oModel:GetValue( _cMaster, _cCpoMVC )
        oModel:SetValue(_cMaster,_cCpoMVC ,cConteudo)
    ENDIF

    RestArea(aArea)
Return(cConteudo)
 