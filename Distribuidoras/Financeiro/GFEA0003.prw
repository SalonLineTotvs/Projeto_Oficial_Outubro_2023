#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "Rwmake.ch"

//****************************************************
// Rotina para Criar a Documento de Entrada - CTE
// Solicitação - Marcio / Didacio / Pedro
// Autor       - André Salgado - 20/04/2022
//****************************************************

USER FUNCTION XGFEA03()

Local nTotCte := 0     //Total CTE Importado
Local cMsgPG  := ""

Private aLinha 	:= {}
Private aItens	:= {}      
Private aCabec	:= {}
Private lMsErroAuto := .F.
Private _cNaturez:= space(10)
Private cTituFAT:= space(10)
Private _cDistr := space(04)
Private _cEnter := CHR(13)+CHR(10)
Private cGrava  := 0     //Grava Fatura //


//TELA PARA SELECIONAR FATURA PARA IMPORTAR O CTE NO FISCAL
@ 247,182	To 350,550 Dialog oNota Title OemToAnsi("PARAMETRO PROCESSAR A FATURA NO FINANCEIRO")
@ 003,003	Say OemToAnsi("SELECIONAR A NATUREZA ?")
@ 003,075	Get _cNaturez valid !empty(_cNaturez) F3 "SED" size 50,50 
@ 015,003	Say OemToAnsi("Numero da Fatura ?")
@ 015,075	Get cTituFAT valid !empty(cTituFAT) size 50,50
@ 027,003	Say OemToAnsi("Informe a Distribuidora?")
@ 027,075	Get _cDistr valid !empty(_cDistr) F3 "ZE" size 50,50

@ 040,075   BmpButton Type 1 Action Close(oNota)
Activate Dialog oNota Centered
Set Device To Print


    if msgyesno("Confirma a Integração financeira dos CTE desta Fatura Nr."+cTituFAT+" ?")

        //Correção das Faturas com erro na Entrada do Lançamento - Inclui "0" a esquerda
      //lh salon  _cUpGXI := " UPDATE GXI010 SET GXI_NRFAT=RIGHT('0000000000'+RTRIM(GXI_NRFAT),10)"
     //lh salon   _cUpGXI += " WHERE D_E_L_E_T_=' ' AND SUBSTRING(GXI_NRFAT,10,1)=' '"
      //lh salon  TcSqlExec(_cUpGXI)


        //Busca a informação
        cTituFAT := strzero(val(cTituFAT),10)

        cQuery := " SELECT DISTINCT " 
        cQuery += " GXI_FILIAL, GXI_NRFAT, GXI_DTEMIS, GXI_DTVENC, GXI_VLFATU, "
        cQuery += " GXJ_EMISDF, A2_NOME,  A2_COD, A2_LOJA, GXJ_NRDF, GXJ_SERDF, "
        cQuery += " GXG_DTEMIS, GXG_VLDF, GXG_BASIMP, GXG_PCIMP, GXG_VLIMP"
        cQuery += " ,RIGHT(GXH_NRDC,9) NFS, F2_VALBRUT, F2_EMISSAO"
        cQuery += " ,XML_CHAVE"
        cQuery += " ,CASE WHEN RIGHT(RTRIM(XML_MUNMT),2)=RIGHT(RTRIM(XML_MUNDT),2) THEN '153' ELSE '054' END CFOP"

        cQuery += " FROM GXI020 GXI (NOLOCK)"
        cQuery += " INNER JOIN GXJ020 GXJ (NOLOCK) ON GXI_FILIAL=GXJ_FILIAL AND GXJ_NRIMP=GXI_NRIMP AND GXJ.D_E_L_E_T_=' ' "
        //cQuery += " INNER JOIN GXG020 GXG (NOLOCK) ON GXI_FILIAL=GXG_FILIAL AND LTRIM(GXJ_NRDF)=LTRIM(ROUND(GXG_NRDF,0)) AND GXG.D_E_L_E_T_=' '" 
        cQuery += " INNER JOIN GXG020 GXG (NOLOCK) ON GXI_FILIAL=GXG_FILIAL AND LTRIM(GXJ_NRDF)=SUBSTRING(GXG_NRDF, PATINDEX('%[^0]%', GXG_NRDF), LEN(GXG_NRDF)) AND GXG.D_E_L_E_T_=' '" 
        cQuery += " INNER JOIN GXH020 GXH (NOLOCK) ON GXG_FILIAL=GXH_FILIAL AND GXG_NRIMP=GXH_NRIMP AND GXH.D_E_L_E_T_=' ' AND GXH_SEQ='00001'"
        cQuery += " INNER JOIN GU3020 GU3 (NOLOCK) ON GU3_CDEMIT=GXI_EMIFAT AND GU3.D_E_L_E_T_=' ' "
        cQuery += " INNER JOIN CONDORXML  (NOLOCK) ON  LEFT(GU3_IDFED,8)=LEFT(XML_EMIT,8) AND"
        cQuery += " RIGHT('000000000'+RTRIM(GXJ_NRDF),9) = RIGHT(RTRIM(XML_NUMNF),9) AND GXG_DTEMIS=XML_EMISSA"
        cQuery += " LEFT JOIN SF2020 SF2 (NOLOCK) ON GXH_FILIAL=F2_FILIAL AND RIGHT(GXH_NRDC,9)=F2_DOC AND SF2.D_E_L_E_T_=' '"
        cQuery += " LEFT JOIN SA2020 SA2 (NOLOCK) ON LEFT(GU3_IDFED,14)=A2_CGC AND SA2.D_E_L_E_T_=' '"
        cQuery += " WHERE "
        cQuery += " GXI.D_E_L_E_T_=' ' AND XML_CHAVE<>' ' "
        cQuery += " AND GXI_NRFAT = '"+cTituFAT+"' "
        cQuery += " AND GXI_FILIAL= '"+_cDistr+"' "

        If Select("TRBOP") > 0
            TRBOP->( dbCloseArea() )
        EndIf

        dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRBOP", .F., .T.)


        //Valida dados se estão validados
        cFornVaz := ""

        //Valida se Esta Logado na Empresa correta
        if TRBOP->GXI_FILIAL <> cFilAnt
            Alert("Fatura pertence a Empresa - "+TRBOP->GXI_FILIAL+", para importar selecionar a Distribuidora correta.  Processo será abortado !"+" Foi digitado nos parametros:"+;
            cTituFAT+" - Dist."+_cDistr)
            return
        Endif



        //TELA PARA SELECIONAR FORNECEDOR DA FATURA
        cForCTE := LEFT(TRBOP->GXJ_EMISDF,8)
        cForFAT := space(06)
        cLojFat := space(02)
        @ 247,182	To 350,550 Dialog oNota Title OemToAnsi("PARAMETRO FATURA A PAGAR")
        @ 003,003	Say OemToAnsi("INFOR.FORNECEDOR FATURA ?")
        @ 003,075	Get cForFAT valid !empty(cForFAT) F3 "SA2" size 50,50 
        @ 015,003	Say OemToAnsi("Loja Forn ?")
        @ 015,075	Get cLojFat valid !empty(cLojFat) size 50,50
        @ 030,075   BmpButton Type 1 Action Close(oNota)
        Activate Dialog oNota Centered
        Set Device To Print



        While TRBOP->(!EOF())
            IF EMPTY(TRBOP->A2_COD)
                cFornVaz := TRBOP->GXJ_NRDF
            Endif

            DBSelectArea("TRBOP")
            TRBOP->(dbSkip())
        Enddo

        if !empty(cFornVaz)
            Alert("CTE não tem fornecedor cadastro, operação abortada ate o cadastro. CTE Nr:"+cFornVaz)
            return
        Endif


        //APRESENTA A INFORMAÇAO PARA USUARIO ANTES DE PROCESSAR
        _cMens := "Esta integração pode levantar alguns minutos, pode iniciar ?"+CRLF


        //ULTIMA CONFIRMAÇÃO ANTES DA GRAVACAO
        if msgyesno(upper(_cMens))

            DBSelectArea("TRBOP")
            TRBOP->( dbGoTop() )

            cNrCte :=""
            While TRBOP->(!EOF())

                cCodProd:= "SV0000000000067"
                cTes    := TRBOP->CFOP //"053"
                nQtdCom := 1
                nValUni := TRBOP->GXG_VLDF
                nBasIcm := TRBOP->GXG_BASIMP
                nPerIcm := TRBOP->GXG_PCIMP // GXG_VLIMP
                cNfsOri := TRBOP->NFS
                cNumNF  := STRZERO(val(TRBOP->GXJ_NRDF),9)
                cSerieNF:= LEFT(TRBOP->GXJ_SERDF,3)
                cDtEmiss:= stod(TRBOP->GXG_DTEMIS)
                cCodCli := TRBOP->A2_COD
                cLojCli := TRBOP->A2_LOJA
                cChvNfe := TRBOP->XML_CHAVE 

                
                //Verifica se foi importado - CTE
                DBSelectArea("SF1")
                DbSetorder(1)
                If DbSeek(xFilial("SF1")+padr(cNumNF,9)+padr(cSerieNF,3)+padr(cCodCli,6) )
                 //lh salon    DBSelectArea("TRBOP")
                 // lh salon  TRBOP->(dbSkip())
                 // lh salon   loop 
                Endif


                //Valida o Codigo do produto
                IF _cNaturez $ "9006A"          
                    cCodProd:= "SV0000000000042"    //PALETIZACAO
                ElseIF _cNaturez $ "9007A"
                    cCodProd:= "SV0000000000043"    //ARMAZENAGEM
                ElseIF _cNaturez $ "9011A"
                    cCodProd:= "SV0000000000044"    //DESCARGA
                ElseIF _cNaturez $ "9008A"
                    cCodProd:= "SV0000000000049"    //DIÁRIA
                ElseIF _cNaturez $ "9014A"
                    cCodProd:= "SV0000000000051"    //REENTREGA
                ElseIF _cNaturez $ "9011A"
                    cCodProd:= "SV0000000000053"    //AJUDANTE
                //ElseIF _cNaturez $ "9000A"
                //    cCodProd:= "SV0000000000054"  //SERVIÇO DE TRANSPORTE MUNICIPAL 
                ElseIF _cNaturez $ "9009A"
                    cCodProd:= "SV0000000000062"    //CARRO DEDICADO
                ElseIF _cNaturez $ "9000A"
                    cCodProd:= "SV0000000000065"    //FRETE VENDA DENTRO DO MUNICIPIO
                ElseIF _cNaturez $ "9005A"
                    cCodProd:= "SV0000000000068"    //DEVOLUÇÃO
                ElseIF _cNaturez $ "9013A"
                    cCodProd:= "SV0000000000069"    //ESTADIA /PERNOITE / PERMANECIA
                //ElseIF _cNaturez $ "9000A"
                //    cCodProd:= "SV0000000000071"  //AGENDAMENTO
                ELSE
                    cCodProd:= "SV0000000000067"
                Endif


                if nValUni>0
                    // Itens da NF
                    aLinha := {}
                    aadd(aLinha,{"D1_COD"   		,cCodProd 			,Nil})
                    aadd(aLinha,{"D1_QUANT" 		,nQtdCom 			,Nil})
                    aadd(aLinha,{"D1_VUNIT" 		,nValUni			,Nil})
                    aadd(aLinha,{"D1_TOTAL" 		,nValUni 	        ,Nil})
                    aadd(aLinha,{"D1_BASEICM" 		,nBasIcm 	        ,Nil})
                    aadd(aLinha,{"D1_PICM" 		    ,nPerIcm 	        ,Nil})
                    aadd(aLinha,{"D1_TES" 			,cTes				,Nil})
                    aadd(aLinha,{"D1_NFORI" 		,cNfsOri    		,Nil})
                    aadd(aLinha,{"AUTDELETA"		,"N"     			,Nil})
                    aadd(aItens,aLinha)

                    // Cabeçalho da Nota              
                    aadd(aCabec,{"F1_TIPO"   	,"N"})
                    aadd(aCabec,{"F1_FORMUL" 	,"N"})
                    aadd(aCabec,{"F1_DOC"    	,cNumNF})
                    aadd(aCabec,{"F1_SERIE"  	,cSerieNF})
                    aadd(aCabec,{"F1_EMISSAO"	,cDtEmiss})
                    aadd(aCabec,{"F1_FORNECE"	,cCodCli})
                    aadd(aCabec,{"F1_LOJA"   	,cLojCli})
                    aadd(aCabec,{"F1_ESPECIE"	,"NF"})       
                    aadd(aCabec,{"F1_CHVNFE" 	,cChvNfe})
                    aadd(aCabec,{"F1_MODAL"     ,"01"})       
                    aadd(aCabec,{"F1_TPCTE" 	,"N"})
                    aadd(aCabec,{"F1_ESPECI2" 	,cTituFAT})


                    //Salva dados para Informar o Usuario no final da Importação
                    cNrCte  += cNumNF + _cEnter
                    nTotCte += nValUni

                    //LH SALON INICIO 
                    /*
                    Begin Transaction
                        MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3)	// Doc Entrada 
                                
                        If !lMsErroAuto
                            lDel := .T.

                            cUpdSFT:= " UPDATE "+RetSqlName("SFT")+" SET FT_ESPECIE='CTE' WHERE FT_ESPECIE='NF' 
                            cUpdSFT+= " AND FT_FILIAL = '"+cfilant+"'" 
                            cUpdSFT+= " AND FT_ENTRADA= '"+dtos(ddatabase)+"' AND FT_NFISCAL='"+cNumNF+"'"
                            cUpdSFT+= " AND FT_SERIE  = '"+cSerieNF+"'        AND FT_CLIEFOR='"+cCodCli+"'"
                            TcSqlExec(cUpdSFT)

                            cUpdSF1:= " UPDATE "+RetSqlName("SF1")+" SET F1_ESPECIE='CTE' WHERE F1_ESPECIE='NF' 
                            cUpdSF1+= " AND F1_FILIAL = '"+cfilant+"'" 
                            cUpdSF1+= " AND F1_DTDIGIT= '"+dtos(ddatabase)+"' AND F1_DOC    ='"+cNumNF+"'"
                            cUpdSF1+= " AND F1_SERIE  = '"+cSerieNF+"'        AND F1_FORNECE='"+cCodCli+"'"
                            TcSqlExec(cUpdSF1)

                        Else
                            lDel := .F.
                            mostraerro()		// Gravar no Arquivo Texto
                            lMsErroAuto := .F.
                        EndIf
                    End Transaction
                    */
                    // lh salon fim 
                    aLinha 	:= {}
                    aItens	:= {}      
                    aCabec	:= {}
                ENDIF

                DBSelectArea("TRBOP")
                TRBOP->(dbSkip())
            Enddo

        endif
     Endif


//Informacao ao Usuario no Final do Processo
if nTotCte>0

    //Grava Fatura
    AtuFatCTE(cTituFAT,_cNaturez, cForFAT, cLojFat)

    MakeDir( "C:\Temp\" )
    cMsg := "Importaçao financeira concluida - Valor CTE Importado - "+transform(nTotCte,"@E 9999,999.99")+_cEnter+cNrCte+_cEnter
    if !empty(cMsgPG)
        cMsg += cMsgPG+_cEnter
    Endif
    cMsg += "Importado por - "+Alltrim(UsrRetName(__CUSERID))+" em "+dtoc(date())
    MemoWrit("C:\Temp\ImpCTE_Fatura_FIN_"+cTituFAT+".TXT",cMsg)

    MSGINFO(cMsg) //"Valor CTE Importado - "+transform(nTotCte,"@E 9999,999.99")+_cEnter+cNrCte)
    nTotCte := 0
    cMsgPG  := ""

Endif

Return 



//Atualiza o Contas a Pagas com os Dados da Fatura
Static FUNCTION AtuFatCTE(cTituFAT,_cNaturez, cForFAT, cLojFat)

//Private cTituFAT := cTituFAT    //Fatura
//Private _cNaturez:= _cNaturez   //Natureza


//Busca os dados
cQuery := " SELECT "
cQuery += " GXI_FILIAL, GXI_NRFAT, GXI_VLFATU, GXI_DTEMIS, GXI_DTVENC, GXI_ISSRET, GXI_IMPRET,"
cQuery += " GXI_EMIFAT, A2_NREDUZ, A2_COD, A2_LOJA"
cQuery += " FROM GXI020 GXI (NOLOCK) "
cQuery += " LEFT JOIN SA2020 SA2 (NOLOCK) ON GXI_EMIFAT=A2_CGC AND SA2.D_E_L_E_T_=' '"
cQuery += " WHERE GXI.D_E_L_E_T_=' ' "
cQuery += " AND GXI_NRFAT = '"+cTituFAT+"'"

If Select("TRBOP") > 0
    TRBOP->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRBOP", .F., .T.)

//Valida de tem Fornecedor
if empty(TRBOP->A2_COD)
    Alert("Fatura não tem fornecedor cadastro, operação abortada ate o cadastro. Fatura Nr:"+TRBOP->GXI_NRFAT)
    return
Endif


//Valida se Esta Logado na Empresa correta
if TRBOP->GXI_FILIAL <> cfilant
    Alert("Fatura pertence a Empresa - "+TRBOP->GXI_FILIAL+", para importar selecionar a Distribuidora correta.  Processo será abortado !")
    return
Endif


//Verifica se foi importado - CTE
cNumNF  := STRZERO(val(TRBOP->GXI_NRFAT),9)
cCodCli := TRBOP->A2_COD

DBSelectArea("SE2")
DbSetorder(1)   //Filial + Prefixo (Fixo) + Fatura + Parcela + Tipo(Fixo) + Fornecedor
If DbSeek(xFilial("SE2")+"CTE"+padr(cNumNF,9)+" "+"NF "+padr(cCodCli,6) )
    RETURN
Endif

//Dados do ExecAuto   
        aAuto   := {}
        aAdd(aAuto,{"E2_PREFIXO" , "CTE"           		,Nil})
        aAdd(aAuto,{"E2_NUM"     , Substr(TRBOP->GXI_NRFAT,2,9)	,Nil}) 
        aAdd(aAuto,{"E2_PARCELA" , ""					,Nil})
        aAdd(aAuto,{"E2_HIST"    , "CTE"            	,Nil})
        aAdd(aAuto,{"E2_TIPO"    , "FT"        			,Nil})
        aAdd(aAuto,{"E2_NATUREZ" , ALLTRIM(_cNaturez)	,Nil})	
        aAdd(aAuto,{"E2_NOMFOR"  , TRBOP->A2_NREDUZ		,Nil})	
        aAdd(aAuto,{"E2_FORNECE" , cForFAT /*TRBOP->A2_COD*/		,Nil})		
        aAdd(aAuto,{"E2_LOJA"    , cLojFat /*TRBOP->A2_LOJA*/		,Nil})		
        aAdd(aAuto,{"E2_EMISSAO" , dDatabase		    ,Nil})				
        aAdd(aAuto,{"E2_VENCTO"  , stod(TRBOP->GXI_DTVENC)	,Nil})				
        aAdd(aAuto,{"E2_VENCREA" , DataValida(stod(TRBOP->GXI_DTVENC),.T.)  ,Nil})				
        aAdd(aAuto,{"E2_VALOR"   , TRBOP->GXI_VLFATU    ,Nil})
        MSExecAuto({|z,y| Fina050(z,y)},aAuto,3) //Inclusao
            
        If lMsErroAuto
            MostraErro()
        Else
            cGrava := 1
            cMsgPG := "Dados Fatura - "+cTituFAT+" valor R$ "+transform(TRBOP->GXI_VLFATU,"@E 9999,999.99")
        EndIf
Return 
