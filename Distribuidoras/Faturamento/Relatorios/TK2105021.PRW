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
    TRCell():New(oSection1,"PALTR"  	,"TRB","Palet Transp"     ,,(03))
    TRCell():New(oSection1,"A1_X_ALTMA" ,"TRB","ALTURA MAX"       ,,(06))
    TRCell():New(oSection1,"PALMI"  	,"TRB","Rec P; Misto"     ,,(03))
    TRCell():New(oSection1,"VEICULO"	,"TRB","VEICULO"          ,,(10))
    TRCell():New(oSection1,"RESTRVEI"	,"TRB","RESTR/VEIC"       ,,(10))
    TRCell():New(oSection1,"A1_X_AJUDA" ,"TRB","AJUDANTE"         ,,(02))
    TRCell():New(oSection1,"CARDE"      ,"TRB","CAR DEDIC"        ,,(03))
    TRCell():New(oSection1,"FLOTA"      ,"TRB","FRET LOTA"        ,,(03))
    TRCell():New(oSection1,"BLQMA"      ,"TRB","BLOQ MANIF"       ,,(03))
    TRCell():New(oSection1,"A1_X_OBSLO"	,"TRB","OBSERVACOES"      ,,(10))

    TRCell():New(oSection1,"VENDEDOR"	,"TRB","Vendedor"	      ,,(15))
    TRCell():New(oSection1,"GERENTE"    ,"TRB","Gerente"          ,,(15))
    TRCell():New(oSection1,"A1_ULTCOM"  ,"TRB","Ult.Compra"       ,,(10))
    TRCell():New(oSection1,"A1_X_FILPV" ,"TRB","Distribuidora"    ,,(03))
    TRCell():New(oSection1,"A1_X_DTATU" ,"TRB","Data Atual"       ,,(10))
    TRCell():New(oSection1,"A1_X_AGHOR"	,"TRB","Agenda" 	      ,,(10))



    TRCell():New(oSection1,"A1_X_LRECE" ,"TRB","Local Receb"      ,,(10))
    TRCell():New(oSection1,"A1_X_DEVPL" ,"TRB","Devol.Pallets"    ,,(10))
    TRCell():New(oSection1,"A1_X_NFPAL" ,"TRB","NF Pallets"       ,,(10))
    TRCell():New(oSection1,"A1_X_CONF"	,"TRB","Conferencia"      ,,(10))

    TRCell():New(oSection1,"A1_X_NDF"   ,"TRB","Emiti NFD"  	 ,,(10))
    TRCell():New(oSection1,"A1_X_VPLAT" ,"TRB","Veiculo Plat"    ,,(10))
    TRCell():New(oSection1,"A1_X_EQUIP" ,"TRB","Equipamento"     ,,(20))
    TRCell():New(oSection1,"A1_X_COBRA"	,"TRB","Cobranca" 	     ,,(10))

    TRCell():New(oSection1,"A1_X_VALNF" ,"TRB","Validade NF"     ,,(10))
    TRCell():New(oSection1,"A1_X_COMPR" ,"TRB","Comprovante"     ,,(20))
    TRCell():New(oSection1,"A1_X_CADTR"	,"TRB","Cad.Transp"      ,,(10))


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
                WHEN '2' THEN 'Demais' ELSE 'Demais' END CLASCLI, 

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
A1_VEND, SA3.A3_NREDUZ VENDEDOR, GER.A3_NREDUZ GERENTE, A1_ULTCOM,  
//A1_X_FILPV,
LEFT(X5_DESCRI,10) A1_X_FILPV, 
A1_X_DTATU, CASE A1_X_AGHOR WHEN '1' THEN 'Horario Marcado' WHEN '2' THEN 'Ordem de Chegada' ELSE ' ' END A1_X_AGHOR, 
//A1_ENDREC,
A1_X_LRECE , 
//A1_X_DEPAL
A1_X_DEVPL,
A1_X_NFPAL, A1_X_CONF, A1_X_NDF, A1_X_VPLAT, A1_X_EQUIP, A1_X_COBRA, A1_X_VALNF,
A1_X_COMPR, A1_X_CADTR

FROM SA1020 SA1 (NOLOCK)
LEFT JOIN SA4020 SA4 (NOLOCK) ON A1_TRANSP=A4_COD AND SA4.D_E_L_E_T_=' ' 
LEFT JOIN SA3020 SA3 (NOLOCK) ON A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_=' '
LEFT JOIN SA3020 GER (NOLOCK) ON SA3.A3_GEREN = GER.A3_COD AND GER.D_E_L_E_T_=' '
LEFT JOIN SX5020 X5 (NOLOCK)  ON X5_FILIAL='0101' AND X5_TABELA='ZE' 
			AND A1_X_FILPV=LEFT(X5_CHAVE,4) AND X5.D_E_L_E_T_=' '      

WHERE
    SA1.D_E_L_E_T_='  '
	AND A1_MSBLQL<>'1'
	AND A1_TRANSP  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
	AND A1_EST     BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
	AND A1_PESSOA  = %Exp:MV_PAR05%
	AND (A1_X_AGEND = %Exp:MV_PAR06% OR A1_X_AGEND = %Exp:MV_PAR6%  OR A1_X_AGEND = %Exp:MV_PA6%)
	AND A1_X_MSBLQ = %Exp:MV_PAR07%

ORDER BY 1 //A1_COD, A1_LOJA


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
