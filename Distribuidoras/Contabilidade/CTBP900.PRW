#include "Protheus.ch"
#include "Fileio.ch"
#include "TopConn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"

User function CTBP900()

/* Programa         :      CTBP900
Data da criação     :      31/01/2023
Autor               :      Andre Salgado - Introde Integrated Solutions
Objetivo            :      Lancamento de apuração do custo conforme alinhado com Victor/Contador Concretize
                           Como nao esta sendo feito apuraçao do Estoque no Sistema, foi feito este desenvolvimento
                           IMPORTANTE: Quando tiver configurado Custo no Modulo Estoque, nao deve utilizar mais esta rotina
Status              :      Desenvolvimento para SalonLine
*/

Local aSays         := {}
Local aButtons      := {}
Local nOpcA         := 0

Private cCadastro   := "Lancamentos Contabeis Off-Line / Custo"
Private aRetImp     := { ctod("  /  /  "),ctod("  /  /  ") } 
Private lMSErroAuto := .F.	
Private aCab        := {}
Private aItens      := {}


//***************************************************************************************************
		aadd(aSays,"   Este programa tem como objetivo gerar automaticamente os")
		aadd(aSays,"   lancamentos contabeis dos movimentos de custo do estoque (entrada/saida)")
		aadd(aSays,"   ATENCAO: A visualizacao dos lancamentos por custo tem um ")
		aadd(aSays,"   grande processo, sera gerado o lancamento direto para contabilidade.")
        aadd(aSays,"   ")
        aadd(aSays,"   Importante: Rotina desenvolvida p/apuracao custo ate ter o Custo Medio no Mod.Estoque.")
		aadd(aButtons, { 5,.T.,{|| Parametros() } } )
		aadd(aButtons, { 1,.T.,{|| nOpcA:= 1, (FechaBatch(),Confirmar()) }} )
		aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )		
		FormBatch( cCadastro, aSays, aButtons )		

Return()


// Parametros
Static Function Parametros()
If !ParamBox( {;
              {1,"Data Inicial",aRetImp[1],,,,,70,.F.},;
              {1,"Data Final"  ,aRetImp[2],,,,,70,.F.};
       },"Parametros Filtro de Mov.Custo", @aRetImp,,,,,,,,.T.,.T. )
       Return
EndIf

Return()


// Confirmar
Static Function Confirmar()

if !Empty(aRetImp[1])
    Processa({|| RunProc() }, "Lançamento Contabil...")
ENDIF

Return()



// Processa atualizacao do Custo / geracao
Static Function RunProc()

Local _cPopUp  := ''
Local _cPopFim := ''

//Atualiza Custo
cQuery := " UPDATE "+RETSQLNAME("SD1")+" SET D1_CUSTO = CASE WHEN ROUND((D1_QUANT*CUSD1),2) > D1_TOTAL THEN D1_CUSTO ELSE ROUND((D1_QUANT*CUSD1),2) END"
cQuery += " FROM   "+RETSQLNAME("SD1")+" D11"
cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" F4 ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' AND F4_ESTOQUE='S'"
cQuery += " INNER JOIN "
cQuery += " (SELECT D1_FILIAL FILL, D1_COD CODD,"
cQuery += " ROUND( CASE WHEN SUM(D1_CUSTO)<=0 THEN SUM(D1_TOTAL-D1_VALICM) ELSE SUM(D1_CUSTO) END  /SUM(D1_QUANT),4 ) CUSD1"
cQuery += " FROM "+RETSQLNAME("SD1")+" D1"
cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" F4 ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' AND F4_ESTOQUE='S'"
cQuery += " WHERE D1.D_E_L_E_T_=' ' "
cQuery += " AND D1_CF IN('1102','1101','2101','2102','1403','2403')"
cQuery += " AND LEFT(D1_DTDIGIT,6) between '202101' and '"+SUBSTR(DTOS(aRetImp[2]),1,6)+"' "
cQuery += " AND D1_FORNECE='002196' AND D1_QUANT>0"
cQuery += " GROUP BY D1_FILIAL, D1_COD"
cQuery += " )CUSTO_ENTRADA ON D1_FILIAL=FILL AND D1_COD=CODD"
cQuery += " WHERE D11.D_E_L_E_T_=' ' "
cQuery += " AND LEFT(D1_DTDIGIT,6)='"+SUBSTR(DTOS(aRetImp[2]),1,6)+"' "
cQuery += " AND D1_TIPO='D'"
TcSqlExec(cQuery)


//Atualiza Custo
cQuery1 := " UPDATE "+RETSQLNAME("SD2")+" SET D2_CUSTO1 = CASE WHEN D2_CF IN ('5411','6411') THEN D2_TOTAL ELSE (D2_QUANT*CUSD1) END "
cQuery1 += " FROM "+RETSQLNAME("SD2")+" D2"
cQuery1 += " INNER JOIN "+RETSQLNAME("SF4")+" F4 ON D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' AND F4_ESTOQUE='S'"
cQuery1 += " INNER JOIN "
cQuery1 += " (SELECT D1_FILIAL, D1_COD,"
cQuery1 += " ROUND( CASE WHEN SUM(D1_CUSTO)<=0 THEN SUM(D1_TOTAL-D1_VALICM) ELSE SUM(D1_CUSTO) END /SUM(D1_QUANT),4) CUSD1"
cQuery1 += " FROM "+RETSQLNAME("SD1")+" D1"
cQuery1 += " INNER JOIN "+RETSQLNAME("SF4")+" F4 ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4.D_E_L_E_T_=' ' AND F4_ESTOQUE='S'"
cQuery1 += " WHERE D1.D_E_L_E_T_=' ' "
cQuery1 += " AND D1_CF IN('1102','1101','2101','2102','1403','2403')"
cQuery1 += " AND LEFT(D1_DTDIGIT,6) = '"+SUBSTR(DTOS(aRetImp[2]),1,6)+"'"
cQuery1 += " AND D1_FORNECE='002196' AND D1_QUANT>0"
cQuery1 += " GROUP BY D1_FILIAL, D1_COD"
cQuery1 += " )CUSTO_ENTRADA ON D2_FILIAL=D1_FILIAL AND D2_COD=D1_COD "
cQuery1 += " WHERE D2.D_E_L_E_T_=' ' "
cQuery1 += " AND LEFT(D2_EMISSAO,6) = '"+SUBSTR(DTOS(aRetImp[2]),1,6)+"'"
TcSqlExec(cQuery1)
Sleep(100000)


//Busca os dados
cQuery := " SELECT FIL,"
cQuery += " ROUND(SUM(VENDA),2) NFS_VENDA,"
cQuery += " ROUND(SUM(BONIF),2) NFS_BONIF,"
cQuery += " ROUND(SUM(DEVOLUCAO),2) NFS_DEV,"
cQuery += " ROUND(SUM(NFE_DEV_CLIENTE),2) NFE_DEVC"
cQuery += " FROM("

cQuery += " SELECT D2_FILIAL FIL, "
cQuery += " CASE WHEN SUBSTRING(D2_CF,1,4) not IN('5411','6411') and SUBSTRING(D2_CF,2,3)<>'910' THEN D2_CUSTO1 ELSE 0 END VENDA,"
cQuery += " CASE WHEN SUBSTRING(D2_CF,1,4) IN('5411','6411') THEN D2_CUSTO1 ELSE 0 END DEVOLUCAO,"
cQuery += " CASE WHEN SUBSTRING(D2_CF,2,3)='910' THEN D2_CUSTO1 ELSE 0 END BONIF,"
cQuery += " 0 NFE_DEV_CLIENTE"
cQuery += " FROM "+RETSQLNAME("SD2")+" D2"
cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" F4 ON D2_FILIAL=F4_FILIAL AND D2_TES=F4_CODIGO AND F4.D_E_L_E_T_=' '  AND F4_ESTOQUE='S'"
cQuery += " WHERE "
cQuery += " D2.D_E_L_E_T_=' ' "
cQuery += " AND LEFT(D2_EMISSAO,6)='"+SUBSTR(DTOS(aRetImp[2]),1,6)+"'"

cQuery += " UNION ALL"
cQuery += " SELECT D1_FILIAL FIL, 0 VENDA, 0 DEVOLUCAO, 0 BONIF, D1_CUSTO NFE_DEV_CLIENTE"
cQuery += " FROM "+RETSQLNAME("SD1")+" D1"
cQuery += " INNER JOIN "+RETSQLNAME("SF4")+" F4 ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO AND F4.D_E_L_E_T_=' '  AND F4_ESTOQUE='S'"
cQuery += " WHERE D1.D_E_L_E_T_=' '"
cQuery += " AND D1_TIPO='D'"
cQuery += " AND LEFT(D1_DTDIGIT,6)='"+SUBSTR(DTOS(aRetImp[2]),1,6)+"'"

cQuery += " )TOTAL  WHERE FIL='"+cFilAnt+"' "
cQuery += " GROUP BY FIL"
cQuery += " ORDER BY 1,3"

/*
If Select("TMPCTB") <> 0
       DbSelectArea("TMPCTB")
       DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TMPCTB"

dbSelectArea("TMPCTB")
TMPCTB->(dbGoTop())
*/

// TCQUERY cQuery NEW ALIAS "TMPCTB"
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPCTB", .F., .T.)    
DbSelectArea('TMPCTB');TMPCTB->(DBGoTop())
_nMax := Contar('TMPCTB',"!Eof()"); TMPCTB->(DbGoTop())
If _nMax == 0
       _cPopUp += ' <font color="#A4A4A4" face="Arial" size="7"> Atenção </font> '
	_cPopUp += ' <br><br> '
	_cPopUp += ' <font color="#FF0000" face="Arial" size="4"> Lançamentos Contábeis </font> '
	_cPopUp += ' <br><br> '
	_cPopUp += ' <font color="#000000" face="Arial" size="3"> Não foram identificados registros para processamento. </font> '
	Alert(_cPopUp,'Geração de Lançamentos Contábeis')
       Return .F.
EndIf

While TMPCTB->(!EOF())

       cDt 	  := aRetImp[2]
       cFil   := XFILIAL("CT2")
       aCab   := {}
       aItens := {}
       nL 	  := '000'

       aAdd(aCab,  {'DDATALANC'   ,cDt ,NIL} )


       //Custo de Venda
       IF TMPCTB->NFS_VENDA>0      
       nL := strzero(val(nL)+1,3)      	                  	
                     aAdd(aItens,{{'CT2_FILIAL' ,cFilAnt		    ,NIL},;
                                   {'CT2_LINHA' ,nL	                ,NIL},;
                                   {'CT2_DC'    ,"3"                ,NIL},;
                                   {'CT2_DEBITO',"32101001"         ,NIL},;
                                   {'CT2_CREDIT',"11501002"	        ,NIL},;
                                   {'CT2_MOEDLC',"01"          		,NIL},;
                                   {'CT2_HIST'  ,"CUSTO DE VENDA DO PERIODO"	,NIL},;
                                   {'CT2_CCD'   ,""     			,NIL},;
                                   {'CT2_CCC'   ,""				    ,NIL},;
                                   {'CT2_TPSALD',"1"    			,NIL},;
                                   {'CT2_ORIGEM',"CTBP900"     		,NIL},;
                                   {'CT2_VALOR' ,TMPCTB->NFS_VENDA  ,NIL},;
                                   {'CT2_ITEMD' ,""     			,NIL},;
                                   {'CT2_ITEMC' ,""     			,NIL}} )
       Endif


       //Custo de Bonificacao
       IF TMPCTB->NFS_BONIF>0      
       nL := strzero(val(nL)+1,3)      	                  	
                     aAdd(aItens,{{'CT2_FILIAL' ,cFilAnt		    ,NIL},;
                                   {'CT2_LINHA' ,nL	              	,NIL},;
                                   {'CT2_DC'    ,"3"               	,NIL},;
                                   {'CT2_DEBITO',"32101001"        	,NIL},;
                                   {'CT2_CREDIT',"11501002"	        ,NIL},;
                                   {'CT2_MOEDLC',"01"          		,NIL},;
                                   {'CT2_HIST'  ,"CUSTO DE BONIFICACAO NO PERIODO",NIL},;
                                   {'CT2_CCD'   ,""     			,NIL},;
                                   {'CT2_CCC'   ,""				    ,NIL},;
                                   {'CT2_TPSALD',"1"    			,NIL},;
                                   {'CT2_ORIGEM',"CTBP900"     		,NIL},;
                                   {'CT2_VALOR' ,TMPCTB->NFS_BONIF  ,NIL},;
                                   {'CT2_ITEMD' ,""     			,NIL},;
                                   {'CT2_ITEMC' ,""     			,NIL}} )

       Endif


       //Custo de Devolucao Fabrica
       IF TMPCTB->NFS_DEV>0      
       nL := strzero(val(nL)+1,3)      	                  	
                     aAdd(aItens,{{'CT2_FILIAL' ,cFilAnt		    ,NIL},;
                                   {'CT2_LINHA' ,nL	              	,NIL},;
                                   {'CT2_DC'    ,"3"               	,NIL},;
                                   {'CT2_DEBITO',"33426001"        	,NIL},;
                                   {'CT2_CREDIT',"11501002"	        ,NIL},;
                                   {'CT2_MOEDLC',"01"          		,NIL},;
                                   {'CT2_HIST'  ,"CUSTO DE DEVOLUCAO NO PERIODO",NIL},;
                                   {'CT2_CCD'   ,""     			,NIL},;
                                   {'CT2_CCC'   ,""				    ,NIL},;
                                   {'CT2_TPSALD',"1"    			,NIL},;
                                   {'CT2_ORIGEM',"CTBP900"     		,NIL},;
                                   {'CT2_VALOR' ,TMPCTB->NFS_DEV    ,NIL},;
                                   {'CT2_ITEMD' ,""     			,NIL},;
                                   {'CT2_ITEMC' ,""     			,NIL}} )
  
       Endif


       //Custo de Devolucao Cliente
       IF TMPCTB->NFE_DEVC>0      
       nL := strzero(val(nL)+1,3)      	                  	
                     aAdd(aItens,{{'CT2_FILIAL' ,cFilAnt		    ,NIL},;
                                   {'CT2_LINHA' ,nL	              	,NIL},;
                                   {'CT2_DC'    ,"3"                ,NIL},;
                                   {'CT2_DEBITO',"11501002"         ,NIL},;
                                   {'CT2_CREDIT',"32101001"	        ,NIL},;
                                   {'CT2_MOEDLC',"01"          		,NIL},;
                                   {'CT2_HIST'  ,"CUSTO DEVOLUCAO MERCADORIA NO PERIODO",NIL},;
                                   {'CT2_CCD'   ,""     			,NIL},;
                                   {'CT2_CCC'   ,""				    ,NIL},;
                                   {'CT2_TPSALD',"1"    			,NIL},;
                                   {'CT2_ORIGEM',"CTBP900"     		,NIL},;
                                   {'CT2_VALOR' ,TMPCTB->NFE_DEVC   ,NIL},;
                                   {'CT2_ITEMD' ,""     			,NIL},;
                                   {'CT2_ITEMC' ,""     			,NIL}} )
       Endif

       TMPCTB->(dbSkip())
Enddo


//Processa lançamento - Rotina padrão do Sistema para validação interna e auditoria cfe.alinhado Victor
MSExecAuto({|x,y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)
if lMsErroAuto
       MostraErro()
endif

_cPopFim += ' <font color="#A4A4A4" face="Arial" size="7"> Sucesso </font> '
_cPopFim += ' <br><br> '
_cPopFim += ' <font color="#5CE617" face="Arial" size="4"> Lançamentos Contábeis </font> '
_cPopFim += ' <br><br> '
_cPopFim += ' <font color="#000000" face="Arial" size="3"> O processamento dos lançamentos contábeis foi efetivado no sistema. </font> '
Alert(_cPopFim,'Geração de Lançamentos Contábeis')

RETURN
