#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "Rwmake.ch"

//**********************************************
// Rotina para Criar a Fatura
// Solicitação - Marcio / Didacio / Pedro
// Autor       - André Salgado - 20/04/2022
//**********************************************

USER FUNCTION XGFEA01()

Local _cNaturez     := space(10)
Private lMsErroAuto := .F.
Private cTituFAT    := space(10)
Private nTotCte     := 0


//TELA PARA SELECIONAR NATUREZA FINANCEIRA
@ 247,182	To 350,550 Dialog oNota Title OemToAnsi("PARAMETRO PROCESSAR A FATURA NO FINANCEIRO")
@ 003,003	Say OemToAnsi("SELECIONAR A NATUREZA ?")
@ 003,075	Get _cNaturez F3 "SED" size 50,50
@ 015,003	Say OemToAnsi("Numero da Fatura ?")
@ 015,075	Get cTituFAT  size 50,50
@ 030,075   BmpButton Type 1 Action Close(oNota)
Activate Dialog oNota Centered
Set Device To Print


if !Empty(cTituFAT)

    cTituFAT := strzero(val(cTituFAT),10)

    if msgyesno("CONFIRMA INTEGRACAO DA FATURA "+cTituFAT+" com contas a Pagar ???")

        cQuery := " SELECT "
        cQuery += " GXI_FILIAL, GXI_NRFAT, GXI_VLFATU, GXI_DTEMIS, GXI_DTVENC, GXI_ISSRET, GXI_IMPRET,"
        cQuery += " GXI_EMIFAT, A2_NREDUZ, A2_COD, A2_LOJA"
        cQuery += " FROM GXI020 GXI (NOLOCK) "
        cQuery += " INNER JOIN GU3020 GU3 (NOLOCK) ON GU3_CDEMIT=GXI_EMIFAT AND GU3.D_E_L_E_T_=' ' "
        cQuery += " LEFT JOIN SA2020 SA2 (NOLOCK) ON LEFT(GU3_IDFED,14)=A2_CGC AND SA2.D_E_L_E_T_=' '"        
        cQuery += " WHERE GXI.D_E_L_E_T_=' ' "
        cQuery += " AND GXI_NRFAT = '"+cTituFAT+"'"
        cQuery += " AND GXI_FILIAL= '"+XFILIAL("GXI")+"'"
      
        MemoWrit("C:\AA\GFEFATURA_"+cTituFAT+".TXT",cQuery)

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


        //APRESENTA A INFORMAÇAO PARA USUARIO ANTES DE PROCESSAR
        _cMens := "Sera feito a integração com Financeiro desta Fatura"+CRLF
        _cMens += "Fatura   - "+TRBOP->GXI_NRFAT+CRLF
        _cMens += "Valor    - "+transform(TRBOP->GXI_VLFATU,"@E 9999,999.99")+CRLF
        _cMens += "Natureza - "+_cNaturez+" "+posicione("SED",1,xFilial("SED")+_cNaturez,"ED_DESCRIC")
        cNumNF  := STRZERO(val(TRBOP->GXI_NRFAT),9)
        cCodCli := TRBOP->A2_COD

        //Verifica se foi importado - CTE
        DBSelectArea("SE2")
        DbSetorder(1)   //Filial + Prefixo (Fixo) + Fatura + Parcela + Tipo(Fixo) + Fornecedor
        If DbSeek(xFilial("SE2")+"CTE"+padr(cNumNF,9)+" "+"NF "+padr(cCodCli,6) )
            RETURN
        Endif


        //ULTIMA CONFIRMAÇÃO ANTES DA GRAVACAO
        if msgyesno(upper(_cMens))
    
            aAuto   := {}
            aAdd(aAuto,{"E2_PREFIXO" , "CTE"           		,Nil})
            aAdd(aAuto,{"E2_NUM"     , Substr(TRBOP->GXI_NRFAT,2,9)	,Nil}) 
            aAdd(aAuto,{"E2_PARCELA" , ""					,Nil})
            aAdd(aAuto,{"E2_HIST"    , "CTE"            	,Nil})
            aAdd(aAuto,{"E2_TIPO"    , "FT"        			,Nil})
            aAdd(aAuto,{"E2_NATUREZ" , ALLTRIM(_cNaturez)	,Nil})	
            aAdd(aAuto,{"E2_NOMFOR"  , TRBOP->A2_NREDUZ		,Nil})	
            aAdd(aAuto,{"E2_FORNECE" , TRBOP->A2_COD		,Nil})		
            aAdd(aAuto,{"E2_LOJA"    , TRBOP->A2_LOJA		,Nil})		
            aAdd(aAuto,{"E2_EMISSAO" , dDatabase		    ,Nil})				
            //aAdd(aAuto,{"E2_VENCTO"  , dDatabase        	,Nil})				
            //aAdd(aAuto,{"E2_VENCREA" , DataValida(dDatabase,.T.)  ,Nil})				
            aAdd(aAuto,{"E2_VENCTO"  , stod(TRBOP->GXI_DTVENC)	,Nil})				
            aAdd(aAuto,{"E2_VENCREA" , DataValida(stod(TRBOP->GXI_DTVENC),.T.)  ,Nil})				
            aAdd(aAuto,{"E2_VALOR"   , TRBOP->GXI_VLFATU    ,Nil})
    /*
            aAdd(aAuto,{"E2_PORTADO" , SA2->A2_BANCO  			    ,Nil})
            aAdd(aAuto,{"E2_FORBCO"  , SA2->A2_BANCO			    ,Nil})
            aAdd(aAuto,{"E2_FORAGE"  , SA2->A2_AGENCIA			    ,Nil})
            aAdd(aAuto,{"E2_FORCTA"  , SA2->A2_NUMCON			    ,Nil})		
            aAdd(aAuto,{"E2_APROVA"  , DTOS(DDATABASE)+"-"+LEFT(Time(),5)+"-"+USRRETNAME(RetCodUsr()),Nil})		
    */
            MSExecAuto({|z,y| Fina050(z,y)},aAuto,3) //Inclusao
                
            If lMsErroAuto
                MostraErro()
            Else
                nTotCte := 1
                //ConfirmSX8()
            EndIf
        endif
     Endif

Endif

//Informacao ao Usuario no Final do Processo
if nTotCte>0
    MSGINFO("Importacao concluida da Fatura - "+cTituFAT+" valor R$ "+transform(TRBOP->GXI_VLFATU,"@E 9999,999.99"))
Endif

Return 
