//****************************************************
//Programa - Mod.Faturamento - Relatorio BOOK TRANSPOPRTE
//Solicitado - Andre Salgado
//Autor - Richard / Introde - 27/09/21
//****************************************************
#include "Protheus.ch"

User function TK2105021()

Local oReport
Private oSection1	:= Nil
Private cPerg 		:= "TK2105021" 
Private cTitulo		:= "Relacao Book tranposrte"

Pergunte(cPerg)
oReport := ReportDef()
oReport:PrintDialog()

Return


Static Function ReportDef()
Local oReport
Local oSection1
Local aOrdem    := {"Empresa + Cliente+ Data"} 

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport|PrintReport(oReport, aOrdem)},"Este relatorio ira imprimir, conforme os parametros solicitados.")
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)
oReport:nFontBody   := 7


oSection1 := TRSection():New(oReport,"RELATORIO",{"SA1"},aOrdem)

    TRCell():New(oSection1,"CODCLI"	   	,"TRB","Codigo+loja"      ,,(06))
    TRCell():New(oSection1,"A1_NOME"  	,"TRB","Cliente"          ,,(40))
    TRCell():New(oSection1,"A1_NREDUZ"  ,"TRB","N.Fantasia"       ,,(40))
    TRCell():New(oSection1,"TipCli"	    ,"TRB","Tipo Cliente"     ,,(06))
    
	TRCell():New(oSection1,"A1_END"	    ,"TRB","ENDERECO"         ,,(40))
    TRCell():New(oSection1,"A1_BAIRRO"  ,"TRB","BAIRRO"           ,,(30))
    TRCell():New(oSection1,"A1_MUN"	    ,"TRB","CIDADE"           ,,(30))
    TRCell():New(oSection1,"A1_CEP"	    ,"TRB","CEP"              ,,(08))
    TRCell():New(oSection1,"A1_EST"	    ,"TRB","UF"               ,,(02))
	TRCell():New(oSection1,"A1_ENDREC"	,"TRB","ENDERECO RECEB."  ,,(40))
    TRCell():New(oSection1,"A1_DDD"	    ,"TRB","DDD"              ,,(03))
    TRCell():New(oSection1,"A1_TEL"	    ,"TRB","TELEFONE"         ,,(10))
	TRCell():New(oSection1,"A1_CONTATO"	,"TRB","CONTATO"  		  ,,(40))
    TRCell():New(oSection1,"CLASCLI"    ,"TRB","CLAS/CLIENTE"     ,,(09))
    TRCell():New(oSection1,"A1_CGC" 	,"TRB","CNPJ/CPF"         ,,(14))

	TRCell():New(oSection1,"A1_TRANSP"  ,"TRB","COD.TRANSP."	  ,,(09))
    TRCell():New(oSection1,"A4_NREDUZ" 	,"TRB","TRANSPORTADORA"   ,,(30))

    TRCell():New(oSection1,"A1_X_NOMRE"	,"TRB","NOME RESP"        ,,(30))
    TRCell():New(oSection1,"A1_X_EMAIL" ,"TRB","EMAIL RESP"       ,,(10))
    TRCell():New(oSection1,"A1_X_CELUL" ,"TRB","CEL RESP"         ,,(15))
    TRCell():New(oSection1,"A1_X_HRINI" ,"TRB","HORA INICIAL"     ,,(05))
    TRCell():New(oSection1,"A1_X_HRFIM" ,"TRB","HORA FIM"         ,,(05))
    TRCell():New(oSection1,"AGENDA" 	,"TRB","AGENDA"           ,,(03))
    TRCell():New(oSection1,"A1_X_TPAGE" ,"TRB","TIPO AGENDA"      ,,(15))
    TRCell():New(oSection1,"A1_X_DIASR" ,"TRB","DIAS/SEMAN"       ,,(10))
    TRCell():New(oSection1,"A1_X_NOMCO" ,"TRB","CONTATO"          ,,(30))
    TRCell():New(oSection1,"A1_X_EMCON"	,"TRB","E-MAIL CONTA"     ,,(30))
    TRCell():New(oSection1,"A1_X_CELCO"	,"TRB","CEL CONTA"        ,,(15))
    TRCell():New(oSection1,"A1_X_PORTA"	,"TRB","PORTAL"           ,,(30))
    TRCell():New(oSection1,"A1_X_USPOR" ,"TRB","USA PORTAL"       ,,(20))
    TRCell():New(oSection1,"A1_X_SENHA"	,"TRB","SENHA"            ,,(20))
    TRCell():New(oSection1,"COBDE"  	,"TRB","COB/DESC"         ,,(03))
    TRCell():New(oSection1,"A1_X_VALDE"	,"TRB","VALOR"            ,,(10))
    TRCell():New(oSection1,"DEPAL"      ,"TRB","DEV/PALETE"       ,,(03))
    TRCell():New(oSection1,"REPAL"  	,"TRB","REC/PALETE"       ,,(03))
    TRCell():New(oSection1,"SKUPA"  	,"TRB","SKU/PALETE"       ,,(03))
    TRCell():New(oSection1,"TDE"    	,"TRB","TDE"              ,,(03))
    TRCell():New(oSection1,"TRT"    	,"TRB","TRT"              ,,(03))
    TRCell():New(oSection1,"PALTR"  	,"TRB","COBRA"            ,,(03))
    TRCell():New(oSection1,"A1_X_ALTMA" ,"TRB","ALTURA MAX"       ,,(06))
    TRCell():New(oSection1,"PALMI"  	,"TRB","COBRA"            ,,(03))
    TRCell():New(oSection1,"VEICULO"	,"TRB","VEICULO"          ,,(10))
    TRCell():New(oSection1,"RESTRVEI"	,"TRB","RESTR/VEIC"       ,,(10))
    TRCell():New(oSection1,"A1_X_AJUDA" ,"TRB","AJUDANTE"         ,,(02))
    TRCell():New(oSection1,"CARDE"      ,"TRB","CAR DEDIC"        ,,(03))
    TRCell():New(oSection1,"FLOTA"      ,"TRB","FRET LOTA"        ,,(03))
    TRCell():New(oSection1,"BLQMA"      ,"TRB","BLOQ MANIF"       ,,(03))
    TRCell():New(oSection1,"A1_X_OBSLO"	,"TRB","OBSERVACOES"      ,,(10))

Return oReport


//Gera o Relatorio da Devoluçao
Static Function PrintReport(oReport, aOrdem)
Local oSection1 := oReport:Section(1)

//CASE WHEN A1_X_TPCLI='D' THEN 'DEMAIS' ELSE 'VIP' END CLASCLI, 


//Tipo de Cliente
IF MV_PAR05 = 1
	MV_PAR05 := "F"
ELSE
	MV_PAR05 := "J"
ENDIF

//Tipo Agendamento
IF MV_PAR06 = 1
	MV_PAR06 := "S"
	MV_PAR6  := "S"
	MV_PA6   := "S"
ELSEIF MV_PAR06 = 1
	MV_PAR06 := "N"
	MV_PAR6  := " "
	MV_PA6   := " "
else
	MV_PAR06 := "N"
	MV_PAR6  := " "
	MV_PA6   := "S"
ENDIF



#IFDEF TOP
	
	oSection1:BeginQuery()
	
BeginSQL alias 'TRB'

SELECT 
A1_COD+A1_LOJA CODCLI, A1_NOME, A1_NREDUZ,
CASE WHEN A1_PESSOA='F' THEN 'FISICA' ELSE 'JURIDICA' END TIPCLI,  
A1_EST, A1_CGC, A1_X_NOMRE,
CASE A1_X_PRIOR WHEN '0' THEN 'VIP' WHEN '1' THEN 'VIP' 
                WHEN '2' THEN 'AGENDADO' ELSE 'Demais' END CLASCLI, 

A1_X_EMAIL, A1_X_CELUL, A1_X_HRINI, A1_X_HRFIM,
A1_END, A1_BAIRRO, A1_MUN, A1_CEP, A1_ENDREC,A1_DDD, A1_TEL, A1_CONTATO,
A1_TRANSP, A4_NREDUZ,

CASE WHEN A1_X_AGEND='S' THEN 'SIM' ELSE 'NAO' END AGENDA,
CASE A1_X_TPAGE 
WHEN 'T' THEN 'Agendado pela transportadora'
WHEN 'R' THEN 'Agendado pelo Representante'
WHEN 'S' THEN 'Agendado pela Salon Line'
ELSE A1_X_TPAGE END A1_X_TPAGE,

A1_X_DIASR, A1_X_NOMCO, A1_X_EMCON, A1_X_CELCO, A1_X_PORTA,
A1_X_USPOR, A1_X_SENHA, A1_X_VALDE,
CASE WHEN A1_X_COBDE='S' THEN 'SIM' ELSE 'NAO' END COBDE,
CASE WHEN A1_X_DEPAL='S' THEN 'SIM' ELSE 'NAO' END DEPAL,
CASE WHEN A1_X_REPAL='S' THEN 'SIM' ELSE 'NAO' END REPAL,
CASE WHEN A1_X_SKUPA='S' THEN 'SIM' ELSE 'NAO' END SKUPA,
CASE WHEN A1_X_TDE='S'   THEN 'SIM' ELSE 'NAO' END TDE,
CASE WHEN A1_X_TRT='S'   THEN 'SIM' ELSE 'NAO' END TRT,
CASE WHEN A1_X_PALTR='S' THEN 'SIM' ELSE 'NAO' END PALTR,
CASE WHEN A1_X_PALMI='S' THEN 'SIM' ELSE 'NAO' END PALMI,

CASE
WHEN A1_X_VEICU='B' THEN 'BITREM'
WHEN A1_X_VEICU='C' THEN 'CARRETA'
WHEN A1_X_VEICU='T' THEN 'TRUCK'
WHEN A1_X_VEICU='O' THEN 'TOCO'
WHEN A1_X_VEICU='Q' THEN '3/4'
WHEN A1_X_VEICU='V' THEN 'VUC'
WHEN A1_X_VEICU='N' THEN 'VAN'
ELSE A1_X_VEICU END 
VEICULO, 

CASE
WHEN A1_X_RESTR='B' THEN 'BITREM'
WHEN A1_X_RESTR='C' THEN 'CARRETA'
WHEN A1_X_RESTR='T' THEN 'TRUCK'
WHEN A1_X_RESTR='O' THEN 'TOCO'
WHEN A1_X_RESTR='Q' THEN '3/4'
WHEN A1_X_RESTR='V' THEN 'VUC'
WHEN A1_X_RESTR='N' THEN 'VAN'
ELSE A1_X_RESTR END 
RESTRVEI, 

A1_X_AJUDA,

CASE WHEN A1_X_CARDE='S' THEN 'SIM' ELSE 'NAO' END CARDE,
CASE WHEN A1_X_FLOTA='S' THEN 'SIM' ELSE 'NAO' END FLOTA,
CASE WHEN A1_X_BLQMA='S' THEN 'SIM' ELSE 'NAO' END BLQMA,
A1_X_OBSLO
,SA1.R_E_C_N_O_

FROM SA1020 SA1 (NOLOCK)
LEFT JOIN SA4020 SA4 (NOLOCK) ON A1_TRANSP=A4_COD AND SA4.D_E_L_E_T_=' ' 

WHERE
    SA1.D_E_L_E_T_='  '
	AND A1_MSBLQL<>'1'
	AND A1_TRANSP  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
	AND A1_EST     BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
	AND A1_PESSOA  = %Exp:MV_PAR05%
	AND (A1_X_AGEND = %Exp:MV_PAR06% OR A1_X_AGEND = %Exp:MV_PAR6%  OR A1_X_AGEND = %Exp:MV_PA6%)
	AND A1_X_MSBLQ = %Exp:MV_PAR07%

ORDER BY A1_COD, A1_LOJA


/*
(
%Exp:MV_PAR06%='1'(
(AND %Exp:MV_PAR05%='1'
AND A1_PESSOA='F' AND (A1_COD+A1_LOJA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND A1.D_E_L_E_T_='  '))
OR
(AND %Exp:MV_PAR05%='2' 
AND A1_PESSOA='J' AND (A1_COD+A1_LOJA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND A1.D_E_L_E_T_='  ')) 
OR
(AND %Exp:MV_PAR05% IN ('1','2')
AND A1_PESSOA IN('F','J') AND (A1_COD+A1_LOJA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND A1.D_E_L_E_T_='  ')))


OR
%Exp:MV_PAR06%='2'(
(AND %Exp:MV_PAR05%='1'
AND A1_PESSOA='F' AND (A1_COD+A1_LOJA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND A1.D_E_L_E_T_='  '))
OR
(AND %Exp:MV_PAR05%='2'
AND A1_PESSOA='J' AND (A1_COD+A1_LOJA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND A1.D_E_L_E_T_='  ')) 
OR
(AND %Exp:MV_PAR05% IN ('1','2') 
AND A1_PESSOA IN('F','J') AND (A1_COD+A1_LOJA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND A1.D_E_L_E_T_='  '))))




WHERE 
            A1.D_E_L_E_T_='  '
            AND CODCLI BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
            (CASE %Exp:MV_PAR05%='F' THEN AND A1_PESSOA='F'
            CASE %Exp:MV_PAR03%='J' THEN AND A1_PESSOA='J'
            ELSE A1_PESSOA IN ('J','F'))
            
*/
	EndSQL
	oSection1:EndQuery()
	
#ENDIF
oSection1:Print()
return

/*------------------------------------FONTE PARA GERAR EM EXCELL-----------------------------------
#include "APWIZARD.CH"
#include "PROTHEUS.CH"
#include "FILEIO.CH"
#include "AP5MAIL.CH"
#include "topconn.ch"
#Include "Rwmake.ch"  
#INCLUDE "TOPCONN.CH"      
#Include "Avprint.ch"
#Include "Font.ch"
#INCLUDE "TOPCONN.CH"       
//==============================================================
//|Este progama gera uma Planilha em Excel                     |
//|com o Book de Transporte da Salon Line                      | 
//|Especifico da Salon Line                                    | 
//|Tabelas ustilizadas :                                       |
//|SA1 - Cadastro de Cliente 							       |
//==============================================================
/*
========================================================================================|
|Funâ€¡â€¦o    Â³ TK2105021  Â³ Autor Â³ Richard  Â³ Data         Â³28/09/2021Â³Â±Â±    |
|=======================================================================================|
| Relatorio em  Excel - MANIFESTOS  x Nota  -baseado no FATR018 de Eduardo lourenco     |
|=======================================================================================|
|					Especifico Salon Line                                               |
========================================================================================|
/X/
//=======================
User Function  TK2105021() 
//=======================
//
Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())
Local nRegSM0   := SM0->(RECNO())
//
If !ApOleClient('MsExcel')
	//
	Alert("AtenÃ§Ã£o! MsExcel nao instalado!")
	//
	Return
EndIf
//
cPerg := PADR("TK2105021",10)
GeraPerg()
//
Pergunte(cPerg,.T.)
//
Processa({|| fSelDados()} , "Selecionando Dados") 
//
RETURN NIL   
//

//
ÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃ
Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â
Â±Â±ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã
Â±Â±Â³Funâ€¡â€¦o	 Â³ fSelDados 					                      |Â±Â±
Â±Â±Â³          Â³ Captura dados principais	    	                      |Â±Â±
Â±Â±ÃƒÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã…Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã
Â±Â±Â³Uso       Â³ SALON LINE                                              Â³Â±Â
Â±Â±Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã�Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã
Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±
ÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸ
/X/      
//ÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸ
Static Function fSelDados()
//ÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸ
//
LOCAL oExcel	:= FWMSEXCEL():New()
LOCAL cQueryC	:= ''
//                                       
//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
//Â³ Seleciona Dados - Clientes   Â³
//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
cEOL := CHR(13)+CHR(10)                                                            
//    
//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿   
//Â³                Query NF X Manifesto           Â³
//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
//
cQueryC := " SELECT "
cQueryC += " A1_COD+A1_LOJA CODCLI, A1_NOME NOME,CASE WHEN A1_PESSOA='F' THEN 'FISICA' ELSE 'JURIDICA' END TIPCLI, "
cQueryC += " A1_EST UF, A1_CGC CNPJ, A1_X_NOMRE NOMERESP, CASE WHEN A1_X_TPCLI='D' THEN 'DEMAIS' ELSE 'VIP' END CLASCLI, "
cQueryC += " A1_X_EMAIL MAILRESP, A1_X_CELUL CELRESP, A1_X_HRINI HORAINI, A1_X_HRFIM HORAFIM, "
cQueryC += " CASE WHEN A1_X_AGEND='S' THEN 'SIM' ELSE 'NAO' END AGENDA, "
cQueryC += " A1_X_TPAGE TIPAGEN, A1_X_DIASR DIASEM, A1_X_NOMCO NOMECONT, A1_X_EMCON MAILCONT, A1_X_CELCO CELCONT, A1_X_PORTA PORTAL,"
cQueryC += " A1_X_USPOR USAPORTAL, A1_X_SENHA SENHA, CASE WHEN A1_X_COBDE='S' THEN 'SIM' ELSE 'NAO' END COBDESC,"
cQueryC += " A1_X_VALDE VALOR,"
cQueryC += " CASE WHEN A1_X_DEPAL='S' THEN 'SIM' ELSE 'NAO' END DEPAL,"
cQueryC += " CASE WHEN A1_X_REPAL='S' THEN 'SIM' ELSE 'NAO' END REPAL,"
cQueryC += " CASE WHEN A1_X_SKUPA='S' THEN 'SIM' ELSE 'NAO' END SKUPA,"
cQueryC += " CASE WHEN A1_X_TDE='S' THEN 'SIM' ELSE 'NAO' END TDE,"
cQueryC += " CASE WHEN A1_X_TRT='S' THEN 'SIM' ELSE 'NAO' END TRT,"
cQueryC += " CASE WHEN A1_X_PALTR='S' THEN 'SIM' ELSE 'NAO' END PALTR,"
cQueryC += " CASE WHEN A1_X_PALMI='S' THEN 'SIM' ELSE 'NAO' END PALMI,"
cQueryC += " CASE"
cQueryC += " WHEN A1_X_VEICU='B' THEN 'BITREM'."
cQueryC += " WHEN A1_X_VEICU='C' THEN 'CARRETA',"
cQueryC += " WHEN A1_X_VEICU='T' THEN 'TRUCK',"
cQueryC += " WHEN A1_X_VEICU='O' THEN 'TOCO',"
cQueryC += " WHEN A1_X_VEICU='Q' THEN '3/4',"
cQueryC += " WHEN A1_X_VEICU='V' THEN 'VUC',"
cQueryC += " WHEN A1_X_VEICU='N' THEN 'VAN',"
cQueryC += " ELSE A1_X_VEICU END VEICULO,"
cQueryC += " CASE"
cQueryC += " WHEN A1_X_RESTR='B' THEN 'BITREM'."
cQueryC += " WHEN A1_X_RESTR='C' THEN 'CARRETA',"
cQueryC += " WHEN A1_X_RESTR='T' THEN 'TRUCK',"
cQueryC += " WHEN A1_X_RESTR='O' THEN 'TOCO',"
cQueryC += " WHEN A1_X_RESTR='Q' THEN '3/4',"
cQueryC += " WHEN A1_X_RESTR='V' THEN 'VUC',"
cQueryC += " WHEN A1_X_RESTR='N' THEN 'VAN',"
cQueryC += " ELSE A1_X_RESTR END RESTVEI,"
cQueryC += " A1_AJUDA AJUDA,"
cQueryC += " CASE WHEN A1_X_CARDEA='S' THEN 'SIM' ELSE 'NAO' END CARDE,"
cQueryC += " CASE WHEN A1_X_FLOTA='S' THEN 'SIM' ELSE 'NAO' END FLOTA,"
cQueryC += " CASE WHEN A1_X_BLQMA='S' THEN 'SIM' ELSE 'NAO' END BLQMA,"
cQueryC += " A1_OBSLO OBSERV"
cQueryC += " FROM SA1020 A1 "

cQueryC += " WHERE  "
cQueryC += " " 

//
If Sele("TSQLM") <> 0
	TSQLM->(DbCloseArea())
Endif
//
TCQUERY cQueryC NEW ALIAS "TSQLM"
TcSetField("TSQLM","CODCLI" 	,"C",06,0)
TcSetField("TSQLM","NOME"   	,"C",40,0)
TcSetField("TSQLM","TIPOCLI"	,"C",06,0)            
TcSetField("TSQLM","UF"     	,"C",02,0)
TcSetField("TSQLM","CLASSCLI"	,"C",09,0)
TcSetField("TSQLM","CNPJ"   	,"C",14,0)
TcSetField("TSQLM","NOMERESP"	,"C",30,0)
TcSetField("TSQLM","MAILRESP"	,"C",10,0)
TcSetField("TSQLM","CELRESP"	,"C",15,0)
TcSetField("TSQLM","HORAINI"	,"C",05,0)
TcSetField("TSQLM","HORAFIM"	,"C",05,0)
TcSetField("TSQLM","AGENDA" 	,"C",03,0)
TcSetField("TSQLM","TIPAGEN"	,"C",15,0)
TcSetField("TSQLM","DIASEM"		,"C",10,0)
TcSetField("TSQLM","NOMECONT"	,"C",30,0)
TcSetField("TSQLM","MAILCONT"	,"C",30,0)
TcSetField("TSQLM","CELCONT"	,"C",15,0)
TcSetField("TSQLM","PORTAL"		,"C",30,0)
TcSetField("TSQLM","USAPORTAL"	,"C",20,0)
TcSetField("TSQLM","SENHA"  	,"C",20,0)
TcSetField("TSQLM","COBDESC"	,"C",03,0)
TcSetField("TSQLM","VALOR"		,"N",08,2)
TcSetField("TSQLM","DEPAL"   	,"C",03,0)
TcSetField("TSQLM","REPAL"  	,"C",03,0)
TcSetField("TSQLM","SKUPA"  	,"C",03,0)
TcSetField("TSQLM","TDE"       	,"C",03,0)
TcSetField("TSQLM","TRT"  	    ,"C",03,0)
TcSetField("TSQLM","COBRA"  	,"C",03,0)
TcSetField("TSQLM","ALTMAX"   	,"C",06,0)
TcSetField("TSQLM","PALMI"  	,"C",03,0)
TcSetField("TSQLM","VEICULO"  	,"C",10,0)
TcSetField("TSQLM","RESTVEIC"  	,"C",10,0)
TcSetField("TSQLM","AJUDA"  	,"C",02,0)
TcSetField("TSQLM","CARDEDIC"  	,"C",03,0) 
TcSetField("TSQLM","FLOTA"   	,"C",03,0)
TcSetField("TSQLM","BLOQMANIF" 	,"C",03,0)
TcSetField("TSQLM","OBSERV"  	,"C",10,0) 

//           
nRegs := 0
TSQLM->(DbEval({|x| nRegs++}))
ProcRegua(nRegs)
//										                
TSQLM->(dbGotop())
IF !TSQLM->(eof())
	oExcel:AddworkSheet("BookTransp")
	//                                                                        
	cNomAba := "Book"
	cNomTit := "Book transp"
	//
	oExcel:AddTable(cNomAba,cNomTit)
	oExcel:AddColumn(cNomAba		,cNomTit	,"CODCLI" 		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOME" 		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"TIPOCLI"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"UF"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"CLASSCLI" 	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"CNPJ" 		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOMERESP" 	,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"MAILRESP"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"CELRESP"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"HORAINI"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"HORAFIM"		,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"AGENDA"		,1		,1		,.F.	) 
	oExcel:AddColumn(cNomAba		,cNomTit	,"TIPAGEN"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"DIASEM"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"NOMECONT"		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"MAILCONT"  	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"CELCONT"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"PORTAL"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"USAPORTAL"	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"SENHA"	   	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"COBDESC"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"VALOR"	  	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"DEPAL"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"REPAL"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"SKUPA" 		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"TDE"	 	  	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"TRT"			,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"COBRA"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"ALTMAX" 		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"PALMI"	   	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"VEICULO" 		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"RESTVEIC"	  	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"AJUDA"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"CARDEDIC"		,1		,1		,.F.	)
	oExcel:AddColumn(cNomAba		,cNomTit	,"FLOTA" 		,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"BLOQMANIF"  	,1		,1		,.F.	)  
	oExcel:AddColumn(cNomAba		,cNomTit	,"OBSERV"		,1		,1		,.F.	)
	
	//
	Do While TSQLM->(!Eof())
		//
		IncProc("Processando Dados ...")
	    		
		oExcel:AddRow(cNomAba,cNomTit,{TSQLM->CODCLI,TSQLM->NOME,TSQLM->TIPCLI,;
		TSQLM->UF,TSQLM->CLASSCLI,TSQLM->CNPJ,TSQLM->NOMERESP,;
		TSQLM->MAILRESP,TSQLM->CELRESP,TSQLM->HORAINI,TSQLM->HORAFIM,TSDLM->AGENDA,;
		TSQLM->TIPAGEN,TSQLM->DIASEM,TSQLM->NOMECONT,TSQLM->MAILCONT,TSQLM->CELCONT,;
		TSQLM->PORTAL,TSQLM->USAPORTAL,TSQLM->SENHA,TSQLM->COBDESC,TSQLM->VALOR,;
		TSQLM->DEPAL,TSQLM->REPAL,TSQLM->SKUPA,TSQLM->TDE,TSQLM->TRT,TSQLM->COBRA,;
		TSQLM->ALTMAX,TSQLM->PALMI,TSQLM->VEICULO,TSQLM->RESTVEIV,TSQLM->AJUDA,TSQLM->CARDEDIC,;
		TSQLM->FLOTA,TSQLM->BLOQMANIF,TSQLM->OBSERV,})	
									 	   
		TSQLM->(DbSkip())
		//
	Enddo     
    //
	cArquivo := "BOOKTRANSP.XML"                 
	If	!Empty(oExcel:aWorkSheet)
		//
		oExcel:Activate()
		oExcel:GetXMLFile("C:\ReportProtheus\"+cArquivo)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open("C:\ReportProtheus\"+cArquivo) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		Alert("Finalizado! Criado arquivo C:\ReportProtheus\"+cArquivo )
		//
	Else  
		//
		Alert("NÃ£o hÃ¡ dados para geraÃ§Ã£o da planilha!") 
		//
	EndIf 
	//
Endif 
//
Return  
--------------------------FIM DO FONTE EM EXCELL---------------------------------------------------------*/
