#INCLUDE"RWMAKE.CH"            
#INCLUDE"TOPCONN.CH"
#INCLUDE"PROTHEUS.CH" 
#include 'totvs.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FONT.CH"

User Function SF1140I()
RETURN

user Function Getate()
    Local cDoc   :=""
    Local cSerie :=""
    Local cLj    :="" 
    Local nForG  := 0
    Local cItemD1:= StrZero(1,TamSX3("D1_ITEM")[1])
    Local cSerie := Iif(xFilial("SUC")="0902","1  ","2  ") 
    Local cDocTMK:= Substr(aArqXml[oArqXML:nAt,2],4,9)  //Nr Nota de Devolução do Cliente
    Local dDocTMK:=  aArqXml[oArqXML:nAt,03]            //Data da emissao de Devolução do Cliente
    Local nTNFTMK:= aArqXml[oArqXML:nAt,17]            //Valor Total da Nota

    aCabec := {}
    aItens := {}
    aLinha := {}


    //!! Valida de já foi lançado !!
    cQuery:= " SELECT COUNT(*) QTD, UC_CODIGO "
    cQuery+= " FROM SUC020 UC (NOLOCK) "
    cQuery+= " WHERE D_E_L_E_T_=' ' AND UC_X_NFD = '"+cDocTMK+"' AND UC_FILIAL='"+xFilial("SUC")+"' "
    cQuery+= " AND UC_CHAVE ='"+CONDORXML->XML_CODLOJ+"'"
    cQuery+= " GROUP BY UC_CODIGO"
    cQuery+= " ORDER BY 2 DESC"
    TCQUERY cQuery NEW ALIAS "TRBSC6A"

    dbSelectArea("TRBSC6A")
    TRBSC6A->(dbGoTop())
    if TRBSC6A->QTD > 0 
        Aviso("Atenção", "Nota Já Importada no Atendimento Nr."+TRBSC6A->UC_CODIGO+CRLF+CRLF+"Selecionar outro Atendimento ! ", {"Ok"})
        TRBSC6A->(DbCloseArea())
        return
    Else
        TRBSC6A->(DbCloseArea())
    Endif



    IF  cTIPO = 'D'  //.and. ('ROGERIO.TMK' $ upper(Alltrim(SubStr(cUsuario,7,15))) .or. 'LUANA' $ upper(Alltrim(SubStr(cUsuario,7,15))) .or. 'CLOVIS' $ upper(Alltrim(SubStr(cUsuario,7,15))) )
        if msgyesno('ATENÇÃO antes de gerar o Atendimento, deixar as COLUNAS:'+CRLF+;
        ' >> NFO - Nota Fiscal Original na POSIÇÃO 15 '+CRLF+;
        ' >> Codigo de Barras na POSIÇÃO 16 '+CRLF+CRLF+;
        'Confirma a geração do Atendimento para Call Center ?') = .t. 

                lMsErroAuto:=.F.
                cAssunto    := space(6)
                cOcorrencia := space(6)
                cNfo        := space(9)
                cNrNFO      := ""
                
                DEFINE DIALOG   oDlg TITLE "Parametro Atendimento" FROM 000,000 TO 200,230 PIXEL
                @ 010,10 say "Assunto    " of oDlg Pixel 
                @ 010,50 MsGet oGet Var cAssunto  VALID !EMPTY(cAssunto)  of oDlg Picture "@!"    F3 "T1" Pixel 
                @ 024,10 say "Ocorrencia " of oDlg Pixel 
                @ 024,50 MsGet oGet Var cOcorrencia   of oDlg Picture "@!"    F3 "XU9" Pixel 
                @ 038,10 say "NFO" of oDlg Pixel 
                @ 038,50 MsGet oGet Var cNfo    of oDlg Picture "@!" Pixel 
                @ 70,50 BUTTON 'Confirmar' SIZE 30,11 PIXEL OF oDlg ACTION (oDlg:End())

                ACTIVATE DIALOG oDlg CENTERED


                //Valida Preenchimento dos campos 
                if empty(cAssunto) .or. empty(cOcorrencia)
                    Aviso("Atenção", "Falta informar os parametros, atendimento do CallCenter nao autorizado !", {"Ok"})
                    return
                Endif


                _cNFOx := strzero(val(TRIM(cNfo)),9)
                UC_X_TRANS := POSICIONE("SF2",1,xFilial("SF2")+_cNFOx,"F2_TRANSP")
                UC_X_NOMTR := POSICIONE("SA4",1,xFilial("SA4")+UC_X_TRANS,"A4_NREDUZ")
                UC_X_NRMA  := POSICIONE("SF2",1,xFilial("SF2")+_cNFOx,"F2_X_NRMA")
                UC_XDTNFO  := POSICIONE("SF2",1,xFilial("SF2")+_cNFOx,"F2_EMISSAO")


                // SUC - CABEÇALHO DO ATENDIMENTO
                aadd(aCabec,{"UC_DATA"    ,dDatabase                 ,Nil})
                AADD(aCabec,{"UC_CODCONT" ,ccodforn                  ,Nil}) //Codigo do Contato
                AADD(aCabec,{"UC_ENTIDAD" ,"SA1"                     ,Nil}) //Alias da Entidade
                AADD(aCabec,{"UC_CHAVE"   ,ccodforn+clojforn         ,Nil}) //Codigo e Loja da Entidade
                //AADD(aCabec,{"UC_OPERADO" ,cOperador                 ,Nil}) //Codigo do Operador //AllTrim(TKOPERADOR())
                AADD(aCabec,{"UC_OPERACA" ,"1"                       ,Nil}) //1-Receptivo 2- Ativo
                AADD(aCabec,{"UC_STATUS"  ,"1"                       ,Nil}) //1-Planejada, 2-Pendente, 3-Encerrada
                AADD(aCabec,{"UC_MIDIA"   ,"000823"                  ,Nil}) //1-Planejada, 2-Pendente, 3-Encerrada
                AADD(aCabec,{"UC_INICIO"  ,TIME()                    ,Nil})
                AADD(aCabec,{"UC_FIM"     ,TIME()                    ,Nil})
                AADD(aCabec,{"UC_DTENCER" ,                          ,Nil})
                AADD(aCabec,{"UC_PROSPEC" ,.F.                       ,Nil})  
                AADD(aCabec,{"UC_X_NFD"   ,cDocTMK                   ,Nil}) //Nf DO Cliente para Distribuidora
                AADD(aCabec,{"UC_X_NFDVL" ,nTNFTMK                   ,Nil}) //Nf DO Cliente para Distribuidora
                AADD(aCabec,{"UC_XNFDVL2" ,nTNFTMK                   ,Nil}) //Nf DO Cliente para Distribuidora
                AADD(aCabec,{"UC_XDTNFD"  ,dDocTMK                   ,Nil}) //Nr Manifesto


                // SUD - ITEM DO ATENDIMENTO
                For nForG := 1 To Len(oMulti:aCols)
                    nIX := nForG
                    cProd := ''

                    If !oMulti:aCols[nIX,Len(oMulti:aHeader)+1]
                            aLinha := {}
                            aadd(aLinha,{"UD_ASSUNTO",cAssunto       ,Nil})
                            aadd(aLinha,{"UD_OCORREN",cOcorrencia    ,Nil})

                            //Regra do De/Para
                            if Empty(oMulti:aCols[nIX][4])
                                cProd:= substr(oMulti:aCols[nIX][16],8,5)   //Codigo EAN
                            else
                                cProd:= (oMulti:aCols[nIX][4])              //De/Para já feito
                            endif        

                            //Valida se tem Nota, senão aborta a gravação
                            if empty(cProd)
                                Aviso("Atenção", "Falta informar CODIGO DO PRODUTO, atendimento do CallCenter nao autorizado !", {"Ok"})
                                return
                            Endif


                            aadd(aLinha,{"UD_PRODUTO",cProd         ,Nil})
                            aadd(aLinha,{"UD_DATA"   ,dDatabase      ,Nil})
                            aadd(aLinha,{"UD_STATUS" ,"1"            ,Nil}) 

                            if Empty(oMulti:aCols[nIX][15]) //48
                                aadd(aLinha,{"UD_NNF",strzero(val(cNfo),9)    ,Nil}) 
                                cNrNFO := strzero(val(cNfo),9)
                            else
                                aadd(aLinha,{"UD_NNF",(oMulti:aCols[nIX][15]) ,Nil}) 
                                cNrNFO := (oMulti:aCols[nIX][15])
                            endif        

                            //Valida se tem Nota, senão aborta a gravação
                            if empty(cNrNFO) .or. cNrNFO="000000000"
                                Aviso("Atenção", "Falta informar numero da NFO - Nota Fiscal Original, atendimento do CallCenter nao autorizado !", {"Ok"})
                                return
                            Endif

                            aadd(aLinha,{"UD_VLRTOTA",(oMulti:aCols[nIX][9]),Nil})
                            aadd(aLinha,{"UD_QTDAJU",(oMulti:aCols[nIX][6]) ,Nil}) 
                            aadd(aLinha,{"UD_OBS"   ,(oMulti:aCols[nIX][19]),Nil})

                            nQTDSD2 := POSICIONE("SD2",3,xFilial("SD2")+cNrNFO+cSerie+ccodforn+clojforn+cProd,"D2_QUANT")
                            nVlrSD2	:= POSICIONE("SD2",3,xFilial("SD2")+cNrNFO+cSerie+ccodforn+clojforn+cProd,"D2_PRCVEN")

                            IF nQTDSD2=0 
                                nQTDSD2 := posicione("SB1",1,xFilial("SB1")+cProd,"B1_QE")
                            Endif

                            if nVlrSD2=0
                                nVlrSD2 := (oMulti:aCols[nIX][9])
                            Endif

                            //Valida se existe NFO x Cliente informado
                            if nVlrSD2=0
                                Aviso("Atenção", "NFO - Nota Fiscal Original informada não localizada para este cliente, atendimento do CallCenter nao autorizado !", {"Ok"})
                                return
                            Endif

                            aadd(aLinha,{"UD_X_NNF" ,cDocTMK                ,Nil}) 
                            aadd(aLinha,{"UD_QTD"   ,nQTDSD2                ,Nil})
                            aadd(aLinha,{"UD_VLRUNT",nVlrSD2                ,Nil}) 
                            aadd(aLinha,{"UD_VLRTOT",nQTDSD2* nVlrSD2       ,Nil})

                            aadd(aLinha,{"UD_X_TRANS",UC_X_TRANS            ,Nil}) 
                            aadd(aLinha,{"UD_X_NOMTR",UC_X_NOMTR            ,Nil})
                            aadd(aLinha,{"UD_XNRMAN" ,UC_X_NRMA             ,Nil}) 
                            aadd(aLinha,{"UD_XDTNFO" ,UC_XDTNFO             ,Nil})
                            aadd(aLinha,{"UD_XDTNFD" ,dDocTMK               ,Nil}) 

                            aadd(aItens,aLinha)
                    Endif
                Next nForG

                IF EMPTY(UC_X_TRANS)
                    UC_X_TRANS := POSICIONE("SF2",1,xFilial("SF2")+cNrNFO,"F2_TRANSP")
                    UC_X_NOMTR := POSICIONE("SA4",1,xFilial("SA4")+UC_X_TRANS,"A4_NREDUZ")
                    UC_X_NRMA  := POSICIONE("SF2",1,xFilial("SF2")+cNrNFO,"F2_X_NRMA")
                    UC_XDTNFO  := POSICIONE("SF2",1,xFilial("SF2")+cNrNFO,"F2_EMISSAO")
                Endif

                AADD(aCabec,{"UC_X_NFO"   ,cNrNFO     ,Nil}) //NF Original da Venda
                AADD(aCabec,{"UC_X_TRANS" ,UC_X_TRANS ,Nil}) //Cod.Transp.
                AADD(aCabec,{"UC_X_NOMTR" ,UC_X_NOMTR ,Nil}) //Nome Transp.
                AADD(aCabec,{"UC_X_NRMA"  ,UC_X_NRMA  ,Nil}) //Nr Manifesto
                AADD(aCabec,{"UC_XMAN"    ,UC_X_NRMA  ,Nil}) //Nr Manifesto
                AADD(aCabec,{"UC_XDTNFO"  ,UC_XDTNFO  ,Nil}) //Nr Manifesto


                //ExecAuto - Atendimento do CallCenter
                SetModulo("SIGATMK","TMK")
                TMKA271(aCabec,aItens,3,"1") 

                If lMsErroAuto
                    Mostraerro()
                    DisarmTransaction() 
                    MSGINFO( 'Atendimento nao gerado, efetuar a correção e tentar novamente  !', 'Atendimento' )
                ELSE

                    cQueryUC := " SELECT MAX(UC_CODIGO) CODIGO  FROM SUC020  (NOLOCK)"
                    cQueryUC += " WHERE D_E_L_E_T_=' ' AND UC_FILIAL='"+xFilial("SUC")+"'"
                    cQueryUC += "       AND UC_DATA='"+DTOS(DDATABASE)+"'"
                    TCQUERY cQueryUC NEW ALIAS "TRBSC6"

                    dbSelectArea("TRBSC6")
                    TRBSC6->(dbGoTop())
                    if !Empty(TRBSC6->CODIGO) 
                        cAtendiUC := TRBSC6->CODIGO
                        TRBSC6->(DbCloseArea())
                        MSGINFO( 'ATENDIMENTO GERADO COM SUCESSO - NR.'+cAtendiUC, 'Atendimento' )                        
                    Else
                        TRBSC6->(DbCloseArea())
                        MSGINFO( 'ATENDIMENTO GERADO COM SUCESSO - NR. 000159'  , 'Atendimento' )
                    Endif

                    //Grava a data do Processamento
                    Reclock("CONDORXML",.F.)
                        //CONDORXML->XML_CONFCO	:= Date()
                        CONDORXML->XML_NUMRPS := DTOS(Date())+" "+SUBSTR(TIME(),1,5)
                    msunlock()

                EndIf

            //Atualiza o campo Total NFD            
            cUpdSUC := " UPDATE SUC020 SET UC_X_NFDVL=VNFD"
            cUpdSUC += " FROM SUC020 "
            cUpdSUC += "     INNER JOIN "
            cUpdSUC += "     (SELECT UD_FILIAL FIL, UD_CODIGO CODIGO, SUM(UD_VLRTOTA) VNFD"
            cUpdSUC += "     FROM SUD020 UD (NOLOCK)"
            cUpdSUC += "     INNER JOIN SUC020 UC (NOLOCK) ON UD_FILIAL=UC_FILIAL AND UD_CODIGO=UC_CODIGO"
            cUpdSUC += "                                 AND UC.D_E_L_E_T_=' ' AND UC_STATUS<>'3'"
            cUpdSUC += "     WHERE UD.D_E_L_E_T_=' '"
            cUpdSUC += "        AND UD_VLRTOTA>0"
            cUpdSUC += "        GROUP BY UD_FILIAL, UD_CODIGO"
            cUpdSUC += "     )A ON UC_FILIAL=FIL AND UC_CODIGO=CODIGO"
            cUpdSUC += " WHERE UC_STATUS<>'3'"
            TcSqlExec(cUpdSUC)
            
            else
        //        alert('ESTA NAO Ã‰ UMA NOTA DE ENTRADA POR DEVOLUCAO')
        ENDIF
    endif
Return()


User Function XMLCTE24()
Local cInObj := ParamIxb[1]
Local oInObj := ParamIxb[2]
Local aAreaOld:= GetArea()
If cInObj == 'DOC'
Private oBtnAxDoc1 := TMenuItem():New(oInObj,"Gerar Atendimento",,,,{|| (sfGerAte90,Eval(bRefrPerg)) },,,,,,,,,)
oInObj:add(oBtnAxDoc1) 
EndIf
Restarea(aAreaOld)
Return

User Function XMLCTE07()
Local aUsrBtn := ParamIxb[1]
aadd(aUsrBtn,{"Preto",{|| u_Getate(),Eval(bRefrPerg) },"Gera Call Center"}) 
aadd(aUsrBtn,{"Preto",{|| u_restr003(),Eval(bRefrPerg) },"Relatorio Devolucao"}) 
aadd(aUsrBtn,{"Preto",{|| u_altarmx(),Eval(bRefrPerg) },"Classificar uma Devolucao"}) 
aadd(aUsrBtn,{"Preto",{|| u_altarmz(),Eval(bRefrPerg) },"Devolucoes a Classificacar"}) 
aadd(aUsrBtn,{"Preto",{|| u_gpeddev(),Eval(bRefrPerg) },"Gerar Pedido Devol. Devintex"}) 

Return aUsrBtn
