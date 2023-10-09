//*******************************************************************************
// Programa - NOTFIS - Programa gera um arquivo Texto no Layout Proceda NOTFIS
// Solicitação - Jose Santos/ Frete  - Autorizado - Kelsen 
// Autor    - Gustavo Barbosa / Andre Salgado - INTRODE - Ago/2022
//*******************************************************************************
#include 'protheus.ch'

user function notfis()

local cNF_Ini := ""
local cNF_Fim := ""
local nHdl

if pergunte("NOTFIS",.T.)

    cNF_Ini  := MV_PAR01
    cNF_Fim  := MV_PAR02
    cNF_Ser  := MV_PAR03
    cPathArq := alltrim(MV_PAR04)

    if validFile(cPathArq, @nHdl)
        Processa({ || RunProc(cNF_Ini, cNF_Fim, cNF_Ser, nHdl )},"Por favor, aguarde. Gerando arquivo...")
        fClose(nHdl)
    endif

endif

return

static function validFile(cPathArq, nHdl)

nHdl := fcreate(cPathArq)

if nHdl == -1
	MsgInfo("Não foi possível gerar o arquivo de exportação!","Atencao!")
	return(.F.)
else
    return(.T.)   
endif

static function RunProc(cNF_Ini, cNF_Fim, cNF_Ser, nHdl)

local lFirst := .T.

SF2->(DbSetOrder(1))
SF2->(DBSeek(xFilial("SF2")+cNF_Ini))

while SF2->(!eof()) .and. SF2->F2_FILIAL = xFilial("SF2") .and. SF2->F2_DOC <= cNF_Fim

    if SF2->F2_SERIE != cNF_Ser
        SF2->(DBSkip())
        loop
    endif

    if lFirst
        SA4->(DbSetOrder(1))
        SA4->(DBSeek(xFilial("SA4")+SF2->F2_TRANSP))
        GrvReg000(nHdl)
        lFirst := .F.
    endif

    GrvReg310(nHdl) //Codigo do Arquivo


    //Busca dados da Transportadora
    SA4->(DbSetOrder(1))
    SA4->(DBSeek(xFilial("SA4")+SF2->F2_TRANSP))
    GrvReg311(nHdl) //Dados da Transportadora 

    //Busca dadosdo Cliente
    SA1->(DbSetOrder(1))
    SA1->(DBSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
    GrvReg312(nHdl) //Dados do Cliente

    GrvReg313(nHdl) //Dados da Nota Fiscal
    

    SD2->(DbSetOrder(3))
    SD2->(DBSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))


    //Variavel para Contar os itens na Linha e gravar o TEXTO
    cGeraTxt := 0
    _nVol1 := _nVol2 := _nVol3 := _nVol4 := 0
    _Cod1  := _Cod2  := _Cod3  := _Cod4  := ""
    _TotVol:= 0

    while SD2->(!eof()) .and. SD2->D2_FILIAL = xFilial("SD2");
                        .and. SD2->D2_DOC = SF2->F2_DOC; 
                        .and. SD2->D2_SERIE = SF2->F2_SERIE;
                        .and. SD2->D2_CLIENTE = SF2->F2_CLIENTE;
                        .and. SD2->D2_SERIE = SF2->F2_SERIE

        //Converte a Quantidade em Caixa
        _nQE     := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_QE")
        cGeraTxt := cGeraTxt + 1


        //Monta arquivo Variavel
        if cGeraTxt=1
            _nVol1   := ROUND(SD2->D2_QUANT / _nQE, 0)
            _Cod1    := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CODBAR")+" "+SD2->D2_COD
            _TotVol  += _nVol1

        Elseif cGeraTxt=2
            _nVol2   := ROUND(SD2->D2_QUANT / _nQE, 0)
            _Cod2    := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CODBAR")+" "+SD2->D2_COD
            _TotVol  += _nVol2

        Elseif cGeraTxt=3
            _nVol3   := ROUND(SD2->D2_QUANT / _nQE, 0)
            _Cod3    := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CODBAR")+" "+SD2->D2_COD
            _TotVol  += _nVol3

        Elseif cGeraTxt=4
            _nVol4   := ROUND(SD2->D2_QUANT / _nQE, 0)
            _Cod4    := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CODBAR")+" "+SD2->D2_COD
            _TotVol  += _nVol4

            //Processa Linha do Produto
            GrvReg314(nHdl)

            //Zera Variavel
            cGeraTxt := 0
            _nVol1 := _nVol2 := _nVol3 := _nVol4 := 0
            _Cod1  := _Cod2  := _Cod3  := _Cod4  := ""

        Endif

        SD2->(DBSkip())
    
    enddo

    //Processa Ultima Linha do Produto
    if cGeraTxt<4
         GrvReg314(nHdl)
    Endif

    //Busca dados da Transportadora
    SA4->(DbSetOrder(1))
    SA4->(DBSeek(xFilial("SA4")+SF2->F2_TRANSP))
    GrvReg317(nHdl) //Dados da Responsavel pelo Frete

    SF2->(DBSkip())

enddo

//Total dos Registros Processados
GrvReg318(nHdl)

return



//Header Arquivo
static function GrvReg000(nHdl)

local idReg  := "000"
local idRem  := PADR(SA4->A4_NREDUZ,35) //PADR("MIRA TI",35)
local idDest := PADR(SA4->A4_NOME,35) //PADR("MIRA TRANSPORTES",35)
local dtReg  := substr(DToC(Date()),1,2) + substr(DToC(Date()),4,2) + substr(DToC(Date()),9,2)
local hrReg  := substr(time(),1,2) + substr(time(),4,2)
local idInte := "NOT" + substr(dtoc(date()),1,2) + substr(dtoc(date()),4,2) + substr(time(),1,2) + substr(time(),4,2) + "S"
local filler := space(145)

fwrite(nHdl, idReg + idRem + idDest + dtReg + hrReg + idInte + filler + CRLF)

return



//Header Arquivo - Documento
static function GrvReg310(nHdl)

local idReg  := "310"
local idDoc  := "NOTFI" + substr(dtoc(date()),1,2) + substr(dtoc(date()),4,2) + substr(time(),1,2) + substr(time(),4,2) + "S"
local filler := space(223) 

fwrite(nHdl, idReg + idDoc + filler + CRLF)

return 


//Dados do Embargador
static function GrvReg311(nHdl)

local idReg     := "311"
local cCnpjEmb  := SA4->A4_CGC //"58506155003604"
local cIeEmb    := PADR(SA4->A4_INSEST,15) //PADR("796823524115",15)
local cEndEmb   := PADR(SA4->A4_END,40) //PADR("AVENIDA NOVO BRASIL, 861",40)
local cCidEmb   := PADR(SA4->A4_MUN,35) //PADR("GUARULHOS",35)
local cCepEmb   := Transform(SA4->A4_CEP,"@R 99999-999") //Transform("07221010","@R 99999-999")
local cEstEmb   :=  PADR(SA4->A4_EST,9) // PADR("SP",9)
local dDtEmbq   := substr(dtoc(date()),1,2) + substr(dtoc(date()),4,2) + substr(dtoc(date()),7,4)
local cNomEmb   := space(40)
local filler    := space(67) //74) 

fwrite(nHdl, idReg + cCnpjEmb + cIeEmb + cEndEmb + cCidEmb + cCepEmb + cEstEmb + dDtEmbq + cNomEmb + filler + CRLF)

return 



//DADOS DO DESTINATÁRIO DA MERCADORIA
static function GrvReg312(nHdl)

local idReg      := "312"
local cNomDest   := PADR(SA1->A1_NOME,40)   //PADR("MIRA TRANSPORTES SP",40)
local cCnpjDest  := PADR(SA1->A1_CGC,13)    //"58506155000184"
local cIeDest    := PADR(SA1->A1_INSCR,15)
local cEndDest   := PADR(SA1->A1_END,40)    //PADR("RUA SAO QUIRINO 1090",40)
local cBaiDest   := PADR(SA1->A1_BAIRRO,20) //  PADR("VILA GUILHERME",20)
local cCidDest   := PADR(SA1->A1_MUN,35)   //PADR("SAO PAULO",35)
local cCepDest   := Transform(SA1->A1_CEP,"@R 99999-999") //Transform("02056070","@R 99999-999")
local cCodMunD   := "000000000"
local cEstDest   := PADR(SA1->A1_EST,9)
local cAreaFret  := space(4)
local cTelDest   := PADR(TRIM(SA1->A1_DDD)+TRIM(SA1->A1_TEL),35)
local filler     := space(7) 

fwrite(nHdl, idReg + cNomDest + cCnpjDest + cIeDest + cEndDest + cBaiDest + cCidDest + cCepDest + cCodMunD + cEstDest + cAreaFret + cTelDest  + filler + CRLF)

return 



//DADOS DE NOTA FISCAL
static function GrvReg313(nHdl)

fwrite(nHdl, "313";
            + PADR(iIF(EMPTY(SF2->F2_X_NRMA),SF2->F2_DOC,SF2->F2_X_NRMA),15);
            + Space(7);
            + "1"; //1 = RODOVIÁRIO; 2 = AÉREO; 3 = MARÍTIMO;4 = FLUVIAL; 5 = FERROVIÁRIO
            + "1"; //1 = CARGA FECHADA; 2 = CARGA FRACIONADA
            + "2"; //1 = FRIA; 2 = SECA; 3 = MISTA
            + SF2->F2_TPFRETE;  //C = CIF; F = FOB
            + SF2->F2_SERIE;
            + strzero(val(SF2->F2_DOC),8);
            + dtos(SF2->F2_EMISSAO); 
            + PADR("COSMETICO",15); //NATUREZA (TIPO) DA MERCADORIA EX: CALÇADOS, CONFECÇÕES, ABRASIVOS, ETC.
            + PADR("CAIXAS",15);    //ESPÉCIE DE ACONDICIONAMENTO - EX: FARDOS, AMARRADOS, CAIXAS, ETC.
            + strzero((SF2->F2_VOLUME1*100),7);
            + strzero((SF2->F2_VALBRUT*100),15);
            + strzero((SF2->F2_PBRUTO*100),7);
            + strzero(0,5);
            + IIF(SF2->F2_VALICM > 0, "S","N");
            + "S";
            + strzero((SF2->F2_SEGURO*100),15);
            + strzero((SF2->F2_VALBRUT*100),15);
            + space(7); //NO DA PLACA CAMINHÃO OU DA CARRETA
            + Space(1); //PLANO DE CARGA RÁPIDA (S/N)?
            + space(15);    //VALOR DO FRETE PESO-VOLUME
            + Space(15);    //VALOR AD VALOREM
            + Space(15);    //VALOR TOTAL DAS TAXAS
            + Replicate("0",15);    //VALOR TOTAL DO FRETE
            + "I";  //AÇÃO DO DOCUMENTO
            + PADR(SF2->F2_DOC,10); //NÚMERO DO PEDIDO / ORDEM DE COMPRA
            + Space(17); //FILLER
            + CRLF)

return 



//DADOS DA MERCADORIA DA NOTA FISCAL
static function GrvReg314(nHdl)

fwrite(nHdl, "314";
            + iif(_nVol1>0,STRZERO(_nVol1*100,7),space(07));
            + PADR(if(_nVol1>0,"CAIXAS",""),15);    //ESPÉCIE DE ACONDICIONAMENTO
            + PADR(_Cod1,30);
            + iif(_nVol2>0,STRZERO(_nVol2*100,7),space(07));
            + PADR(if(_nVol2>0,"CAIXAS",""),15);    //ESPÉCIE DE ACONDICIONAMENTO
            + PADR(_Cod2,30);
            + iif(_nVol3>0,STRZERO(_nVol3*100,7),space(07));
            + PADR(if(_nVol3>0,"CAIXAS",""),15);    //ESPÉCIE DE ACONDICIONAMENTO
            + PADR(_Cod3,30);
            + iif(_nVol4>0,STRZERO(_nVol4*100,7),space(07));
            + PADR(if(_nVol4>0,"CAIXAS",""),15);    //ESPÉCIE DE ACONDICIONAMENTO
            + PADR(_Cod4,30);
            + space(29);
            + CRLF)

return 


//DADOS DO responsavel pelo Frete
static function GrvReg317(nHdl)

local idReg      := "317"
local cNomDest   := PADR(SA4->A4_NOME,40) //PADR("MIRA TRANSPORTES SP",40)
local cCnpjDest  := SA4->A4_CGC //"58506155000184"
local cIeDest    := PADR(SA4->A4_INSEST,15) //PADR("115237721119",15)
local cEndDest   := PADR(SA4->A4_END,40) //PADR("RUA SAO QUIRINO 1090",40)
local cBaiDest   := PADR(SA4->A4_BAIRRO,20) //PADR("VILA GUILHERME",20)
local cCidDest   := PADR(SA4->A4_MUN,35) //PADR("SAO PAULO",35)
local cCepDest   := Transform(SA4->A4_CEP,"@R 99999-999") //Transform("02056070","@R 99999-999")
local cCodMunD   := "000000000"
local cEstDest   := PADR(SA4->A4_EST,9) //PADR("SP",9)
local cAreaFret  := space(4)
local cTelDest   := PADR("11999999999",35)
local filler     := space(7) 

fwrite(nHdl, idReg + cNomDest + cCnpjDest + cIeDest + cEndDest + cBaiDest + cCidDest + cCepDest + cCodMunD + cEstDest + cAreaFret + cTelDest  + filler + CRLF)

return 


//TOTAL DO REGISTRO
static function GrvReg318(nHdl)

fwrite(nHdl, "318";
            + strzero((SF2->F2_VALBRUT*100),15);
            + strzero((SF2->F2_PBRUTO*100),15);
            + strzero((SF2->F2_PBRUTO*100),15);
            + strzero((_TotVol*100),15);
            + strzero((SF2->F2_VALBRUT*100),15);
            + Replicate("0",15);    //VALOR TOTAL DO FRETE
            + Space(147); //FILLER
            + CRLF)
return 
