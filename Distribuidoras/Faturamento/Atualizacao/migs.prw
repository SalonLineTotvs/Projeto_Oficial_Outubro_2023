#Include "Protheus.Ch"
#Include "TopConn.Ch"
#include "rwmake.ch"
#include "TBICONN.CH"        
#include "TopConn.ch"
#include "Fileio.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ESTP0008 º Autor ³ANDRE SALGADO/INTRODEº Data ³  21/03/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Le arquivo CSV conforme layout definido na SALONLINE       º±±
±±º          ³ SERÁ Importado para Rotina GERAÇÃO NOTAS "MIGS"            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento - Rotina Importação das MIGS                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºValidação - 
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  

/*
LAYOUT DO ARQUIVO CSV
#;CPF;Nome;email;Telefone;Endereco;Bairro;Cidade;UF;CEP;Complemento
*/

User Function migs()

carq := ""
aRet		:= {Space(15),Space(15),space(03)}

If !ParamBox( {;
	{1,"01.Produto",aRet[1],"@!",,"SB1","",70,.F.},;
	{1,"02.Produto",aRet[2],"@!",,"SB1","",70,.F.},;
	{1,"TES Notas MIGS",aRet[3],"@!",,"SF4","",70,.F.};
	},"Parametros para Gerar NF MIGS", @aRet,,,,,,,,.T.,.T. )
	
	Return
End If

cProd01	:= aRet[1]
cProd02	:= aRet[2]
cTES_	:= aRet[3]



If Empty(cArq)
	Private aAmb      := GetArea()
	Private cTipo     := 'Arquivos Textos (*.CSV)     | *.CSV | '
	Private oFont     := TFont():New("Tahoma",,-11,.F.,,,,,.F.)
	Private oDlg      := MSDialog():New(10,10,300,500,"IMPORTAÇÃO DO MIGS ...",,,,,,,,,.T.)
	Private oSay1     := TSay():New(2,2,{|| "Esta rotina tem a função importar Arquivos do Cadastro MIGS no formato .CSV" },oDlg,,oFont,,,,)
	Private oSay2     := TSay():New(3,2,{|| "Obs.: .CSV = Excel(separado por vírgulas)" },oDlg,,oFont,,,,)
	Private oSay3     := TSay():New(4,2,{|| "LAYOUT do arquivo: " },oDlg,,oFont,,,,)
	Private oBtnOK    := TButton() :New(100,130,"Importar" ,oDlg,{|| rptstatus({|| GeraCSV(nGet1:=cGetFile(cTipo, 'Selecao de Arquivos', 1, 'C:\', .F., ,.F., .T. ))}) },50,15,,,,.T.,,,,{|lRet|})
	Private oBtnClose := TButton() :New(100,180,"Fechar",oDlg,{||oDlg:End()},50,15,,,,.T.)
	oDlg:Activate(,,,.T.,,,)
	Return()
Else
	GeraCSV(cArq)
Endif

//Busca Arquivo
Static Function GeraCSV(cArq)

Private cPath		:= cArq
Private nArquivo	:= FT_FUSE(cPath)
Private nTotRec 	:= FT_FLASTREC()
Private cLinha		:= ""
Private _cEnter 	:= CHR(13)+CHR(10)     
Private cCampoVaz   := ""   
Private nErroVaz	:= 0  
Private lRet		:= .F.
Private	cValdPrd	:= ""
Private cValdLte    := ""
Private cValdDta    := ""
Private cValdLoc    := ""    
Private cQuery 		:= ''   
Private nOk			:= 0
Private nNo			:= 0


If File(cPath)
	If MsgYesNo("Deseja Importar o Arquivo das MIGS ? " + cPath )        		
		Processa({|| PROCARQ() }, "Processando Arquivo...",,.T.)   
	Else
		FClose(nArquivo)
	EndIf
Else
	Alert("Arquivo não encontrado !")
EndIf

Return()  


//Processa arquivo
Static Function PROCARQ()

Private aRet
Private nCount
Private cArq 
Private cTxt
Private nHdl
Private cLinha
Private aResult		:= {}
Private aVetor		:= {}
Private aItenSB7	:= {}
Private _ATMP       := {}
Private n     		:= 1
Private cTime 		:= SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)
Private cValLog 	:= ""    
Private nErro		:= 0
Private cQuery 		:= ''
Private cLogErr     := ""

FT_FGOTOP()
ProcRegua(nTotRec)

// DEFINE TABELA TEMPORARIA
AAdd ( _aTmp, {"TMP_COD" 		,"C", 06, 00} )
_cTable := CriaTrab(_aTmp,.T.)

DbUseArea(.T.,"DBFCDX",_cTable,"TEMP",.T.,.F.)
	    

While (!FT_FEOF())

	cLinha 	:= " "
	cLinha 	:= FT_FREADLN()
	aColuna	:= {}
	aColuna	:= Separa(cLinha,";")

    //Grava Variaveis
	cCPF	:= Alltrim(aColuna[02])  //CPF
    cCPF    := STRTRAN(STRTRAN(STRTRAN(STRTRAN(cCPF,".",""),"-",""),"/","")," ","")
    cCPF    := STRZERO(val(cCPF),11)
    _cpfok  := CGC(cCPF,,.f.)   //Valida o CPF

    cNOME	:= FwNoAccent(UPPER(Alltrim(aColuna[03])))  //NOME
    cEMAIL  := Alltrim(aColuna[04])  //Email
    cTelCel := STRTRAN(STRTRAN(STRTRAN(Alltrim(aColuna[05]),"(",""),")","")," ","")  //telefone
    cEnderec:= FwNoAccent(UPPER(Alltrim(aColuna[06])))  //Endereço
    cBairro := FwNoAccent(UPPER(Alltrim(aColuna[07])))  //Bairro
    cMunic  := FwNoAccent(UPPER(Alltrim(aColuna[08])))  //Cidade
    cEstado := Alltrim(aColuna[09])  //Cidade
    cCEP    := Alltrim(aColuna[10])  //Cidade
    cCompl  := FwNoAccent(UPPER(Alltrim(aColuna[11])))  //Complemento

    if !_cpfok .or. cCPF="00000000000"
        cLogErr += "CPF invalido - "+cCPF+" "+cNOME +CRLF
    
    else

        DBSelectArea("SA1")
        DBSetOrder(3)
        DBSeek(xFilial("SA1") + cCPF )

        If Found()
            Reclock("SA1",.f.)
    		SA1->A1_NATUREZ	:= "10020"		//Natureza Criada para e-comerce
            Msunlock()
        Else
            cNumCli	:= GetSXENum("SA1","A1_COD")
            While .T.
                SA1->(DbSetOrder(1))
                IF SA1->( DbSeek(xFilial("SA1")+cNumCli) )
                    ConfirmSX8()
                    cNumCli	:= GetSXENum("SA1","A1_COD")
                    Loop
                Else
                    Exit
                EndIF
            EndDO
            
            Dbselectarea("SA1")
            
            //Codigo do Municipio por Estado com base em suas CAPITAIS
            cCodMun := CodMuni(cEstado)

            Reclock("SA1",.T.)
            SA1->A1_FILIAL	:= xFilial("SA1")
            SA1->A1_COD         := cNumCli
            SA1->A1_LOJA        := "01"
            SA1->A1_NOME        := cNOME
            SA1->A1_NREDUZ      := cNOME
            SA1->A1_END         := cEnderec
            SA1->A1_BAIRRO      := cBairro
            SA1->A1_MUN         := cMunic
            SA1->A1_EST         := cEstado
            SA1->A1_CEP         := cCEP
            SA1->A1_CGC         := cCPF
            SA1->A1_TIPO        := "F"
            SA1->A1_PESSOA	:= If(Len(Alltrim(cCPF)) > 11,"J","F")
            SA1->A1_PAIS        := "105"
            SA1->A1_DTNASC	:= ddatabase  	//Data da Primeira Compra
            SA1->A1_NATUREZ	:= "10020"		//Natureza Criada para e-comerce
            SA1->A1_RISCO	:= "A"
            SA1->A1_CODPAIS	:= IF(cEstado="EX","02496","01058")
            SA1->A1_COD_MUN	:= cCodMun
            SA1->A1_RECISS	:= "2"

            Msunlock()
            ConfirmSx8()
        Endif

    	DbSelectArea("TEMP")
        RecLock("TEMP",.T.)
        TEMP->TMP_COD		:= SA1->A1_COD
        MsUnLock()

    endif
	FT_FSKIP()	

EndDo

IF !EMPTY(cLogErr)
    MsgInfo("Teve inconsistencia nos dados, não sera processa o arquivos das MIGS, corrigir os erros abaixo:"+CRLF+cLogErr,"Atenção")
    MemoWrite("C:\TEMP\Log_erro_import.txt", cLogErr)
    TEMP->(DbCloseArea())
    Return
ELSE

    //Processa os Pedidos de venda das MIGS
    DbSelectArea("TEMP")
    TEMP->(DbGoTop())

    lMsHelpAuto := .T.
    lMsErroAuto := .F.

    cLoja_    := '01'
    CTRANSP1_ := ""     //?? Qual transportadora
    cCodPag_  := '000'
    cTes_     := cTES_
    cSeq	  := '01'
    cFlacCab  := .T.
    cUsusario := 'WEBSERVICE'

    While !Eof()

       	DbSelectArea("TEMP")

        cCliente_ := TEMP->TMP_COD
        aCabec    := {}
        aItens    := {}

        if Empty(cCliente_)
            TEMP->(DbSkip())
        Endif


        //******************************** - item 01  **********************************
        cProdSB1:= cProd01 //"43180"
        cNumPV 	:= GetSxeNum("SC5","C5_NUM")
        RollBAckSx8()

        aadd(aCabec,{"C5_NUM"    ,cNumPV   	,Nil})
        aadd(aCabec,{"C5_TIPO"   ,"N"      	,Nil})
        aadd(aCabec,{"C5_CLIENTE",cCliente_	,Nil})
        aadd(aCabec,{"C5_LOJACLI",cLoja_   	,Nil})
        aadd(aCabec,{"C5_LOJAENT",cLoja_   	,Nil})
        aadd(aCabec,{"C5_CONDPAG",cCodPag_ 	,Nil})
//        aadd(aCabec,{"C5_TRANSP",cTransp1_ 	,Nil})
        aadd(aCabec,{"C5_MENNOTA","PROJETO MIGS ",Nil})
        aadd(aCabec,{"C5_VOLUME1",1     	,Nil})
        aadd(aCabec,{"C5_ESPECI1","CAIXA"	,Nil})
        aadd(aCabec,{"C5_X_DIGIT",cUsusario ,Nil})
        aadd(aCabec,{"C5_X_STAPV","5"       ,Nil})

        //Itens
        If SB1->( DbSeek(xFilial("SB1")+cProdSB1 ))
            nPrcVen := SB1->B1_UPRC //PRV1                             //PRECO
            cTes_   := cTes_ //TES DE SAIDA
            cDESCSB1:= alltrim(SB1->B1_DESC)                    //DESCRICAO
            cUNSB1  := SB1->B1_UM                               //UNIDADE DE MEDIDA

            If nPrcVen == 0
                nPrcVen := 0.01
            Endif
                
            aLinha := {}
            aadd(aLinha,{"C6_ITEM"	,cSeq		,Nil})
            aadd(aLinha,{"C6_PRODUTO"	,cProdSB1	,Nil})
            aadd(aLinha,{"C6_UM"	,cUNSB1         ,Nil})
            aadd(aLinha,{"C6_LOCAL"	,"01" 		,Nil})
            aadd(aLinha,{"C6_DESCRI"	,cDESCSB1	,Nil})
            aadd(aLinha,{"C6_QTDVEN"	,1      	,Nil})
            aadd(aLinha,{"C6_PRCVEN"	,nPrcVen	,Nil})
            aadd(aLinha,{"C6_PRUNIT"	,nPrcVen	,Nil})
            aadd(aLinha,{"C6_VALOR"	,(nPrcVen * 1 )	,Nil})
            aadd(aLinha,{"C6_TES"	,cTes_		,Nil})

            aadd(aItens,aLinha)
            //  cSeq := soma1(cSeq)
        Endif


        //******************************** - item 02  **********************************
        cProdSB1:= cProd02 //"43460"
        If SB1->( DbSeek(xFilial("SB1")+cProdSB1 ))
            nPrcVen := SB1->B1_UPRC //PRV1                             //PRECO
            cTes_   := cTes_ //TES DE SAIDA
            cDESCSB1:= alltrim(SB1->B1_DESC)                    //DESCRICAO
            cUNSB1  := SB1->B1_UM                               //UNIDADE DE MEDIDA

            If nPrcVen == 0
                nPrcVen := 0.01
            Endif
                
            aLinha := {}
            aadd(aLinha,{"C6_ITEM"	,"02"	    ,Nil})
            aadd(aLinha,{"C6_PRODUTO"	,cProdSB1   ,Nil})
            aadd(aLinha,{"C6_UM"	,cUNSB1     ,Nil})
            aadd(aLinha,{"C6_LOCAL"	,"01" 	    ,Nil})
            aadd(aLinha,{"C6_DESCRI"	,cDESCSB1   ,Nil})
            aadd(aLinha,{"C6_QTDVEN"	,1          ,Nil})
            aadd(aLinha,{"C6_PRCVEN"	,nPrcVen    ,Nil})
            aadd(aLinha,{"C6_PRUNIT"	,nPrcVen	,Nil})
            aadd(aLinha,{"C6_VALOR"	,(nPrcVen * 1 )	,Nil})
            aadd(aLinha,{"C6_TES"	,cTes_		,Nil})

            aadd(aItens,aLinha)
        Endif

        //Executa ExecAuto PV
        GeraNFxPV()	//**** gera nota fiscal

       	DbSelectArea("TEMP")
        TEMP->(DbSkip())
    EndDO

ENDIF

TEMP->(DbCloseArea())

FClose(nHdl)

Return()



//=================================================================//
// RELATORIO DA IMPORTAÇÃO 
//=================================================================//
//U_RELLOGPROC



//Busca o Codigo do Municipio por Estado com base nas suas Capitais
//Solução Por ANDRE SALGADO - DATA 23/02/2017
Static Function CodMuni(cEstUF)
cEstad := cEstUF
cCodMun := " "

//Codigo do Municipio por Estado com base em suas CAPITAIS
IF cEstad = "PA"
	cCodMun := "01402"
ElseIF cEstad = "MG"
	cCodMun := "06200"
ElseIF cEstad = "RR"
	cCodMun :=  "00100"
ElseIF cEstad = "DF"
	cCodMun :=  "00108"
ElseIF cEstad = "MS"
	cCodMun := "02704"
ElseIF cEstad = "MT"
	cCodMun := "03403"
ElseIF cEstad = "PR"
	cCodMun := "06902"
ElseIF cEstad = "SC"
	cCodMun := "05407"
ElseIF cEstad = "CE"
	cCodMun := "04400"
ElseIF cEstad = "GO"
	cCodMun := "08707"
ElseIF cEstad = "PB"
	cCodMun := "07507"
ElseIF cEstad = "AP"
	cCodMun := "00303"
ElseIF cEstad = "AL"
	cCodMun := "04302"
ElseIF cEstad = "AM"
	cCodMun := "02603"
ElseIF cEstad = "RN"
	cCodMun := "08102"
ElseIF cEstad = "TO"
	cCodMun := "21000"
ElseIF cEstad = "RS"
	cCodMun := "14902"
ElseIF cEstad = "RO"
	cCodMun := "00205"
ElseIF cEstad = "PE"
	cCodMun := "11606"
ElseIF cEstad = "AC"
	cCodMun := "00401"
ElseIF cEstad = "RJ"
	cCodMun := "04557"
ElseIF cEstad = "BA"
	cCodMun := "27408"
ElseIF cEstad = "MA"
	cCodMun := "11300"
ElseIF cEstad = "SP"
	cCodMun := "50308"
ElseIF cEstad = "PI"
	cCodMun := "11001"
ElseIF cEstad = "ES"
	cCodMun := "05309"
ElseIF cEstad = "EX"
	cCodMun := "99999"
Else
	cEstad  := "SP"
	cCodMun := "50308"
Endif
Return(cCodMun)

//******************************************
//Processa Geração do PEDIDO DE VENDA
//******************************************
Static Function GeraNFxPV()

//Executa ExecAuto PV
MATA410(aCabec,aItens,3)

If !lMsErroAuto
	//Força a Liberação do Estoque do Pedido de Venda
	cQueryC9 := " UPDATE "+RetSqlName("SC9")+" SET C9_BLEST=' ' WHERE C9_PEDIDO='"+cNumPV+"' AND C9_FILIAL='"+XFILIAL("SC9")+"' AND D_E_L_E_T_=' ' AND C9_BLEST<>' '"
	TcSqlExec(cQueryC9)
	FATURA(cNumPV)
Else
	mostraerro()
EndIf

//Zera Variaveis
cNumPV	:= ""
aCabec	:= {}
aItens	:= {}
cFlacCab:= .T.	//Liberado Cabeçalho
nTotQueb:= 0
cSeq	:= '01'

Return

//Processa Faturamento
Static Function FATURA(cNumPV)
Local aAreaSM0	 := SM0->(GetArea())
Local cError     := ""
Local cWarning   := ""
Local aPvlNfs 	 := {}
Local nItemNf 	 := 0
Local cNota      := ''
Private cNFIni	 := ""
Private cNFFim	 := ""
Private cControle:= 0
Private aCabec 	 := {}
Private aItens 	 := {}
Private aLinha   := {}
Private cSerie   := "2  "	//SERIE OFICIAL DE FATURAMENTO !!

nItemNf := a460NumIt(cSerie)

SC6->(DbSeek(xFilial("SC6")+cNumPV+"01") )

Do While !SC6->(Eof()) .and.  SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = cNumPV
					
	SC9->(DbSeek(xFilial("SC9")+cNumPV+SC6->C6_ITEM) )
	SC5->(DbSeek(xFilial("SC5")+cNumPV) )
	SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )
	SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO) )
	SB2->(DbSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL)) )
	SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )
					
	aAdd(aPvlNfs,{ SC9->C9_PEDIDO,;
			SC9->C9_ITEM,;
			SC9->C9_SEQUEN,;
			SC9->C9_QTDLIB,;
			SC9->C9_PRCVEN,;
			SC9->C9_PRODUTO,;
			.f.,;
			SC9->(RecNo()),;
			SC5->(RecNo()),;
			SC6->(RecNo()),;
			SE4->(RecNo()),;
			SB1->(RecNo()),;
			SB2->(RecNo()),;
			SF4->(RecNo())})

	If ( Len(aPvlNfs) >= nItemNf )
	    cNota   := MaPvlNfs(aPvlNfs,cSerie,.F.,.F.,.F.,.F.,.F.,0,0,.F.,.F.)
		aPvlNfs := {}
	EndIf
			
	SC6->(DbSkip())		
EndDo
				
                
//***********************************************
// INICIA PROCESSO DE FATURAMENTO
//***********************************************
If Len(aPvlNfs)	> 0
	cNota   := MaPvlNfs(aPvlNfs,cSerie,.F.,.F.,.F.,.F.,.F.,0,0,.F.,.F.)
EndIf
	
If !Empty(cNota)
    cControle++

	If cControle == 1
		cNFIni	  := cNota
		cNFFim	  := cNota
	Else
		cNFFim	  := cNota
	EndIf

	//Faz a transmissao da Nota
    If cControle > 0
//***		RptStatus( {|lEnd| TranAuto()}, "Aguarde...","Fazendo transmissão da nota fiscal", .T. )
	EndIf            

Else
//	MsgAlert("Pedido gerado " + cNumPV + chr(13) + chr(10) + "Nao foi possivel gerar a Nota Fiscal "  ,"Não gerou NF")
EndIF


RestArea(aAreaSM0)
return(cNota)



//******************************************************************
// FAZ TRANSMISSÃO DA NF FATURADA
//******************************************************************
Static Function TranAuto()
AutoNfeEnv(cEmpAnt,right(cNumEmp,4),"0","1",cSerie,cNFIni,cNFFim)
Return()
