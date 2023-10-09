/*---------------------------------------------------------------*/
#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
/*----------------------*/
User Function libgnre()
cQuery1 := " UPDATE SF6120 SET F6_TIPOGNU = CASE WHEN F6_EST in('PR','PA','DF','MG','MT','AP') THEN '10' "
cQuery1 += "      WHEN F6_EST in('SC') THEN '24' "
cQuery1 += "      WHEN F6_EST in('RS') THEN '22' END REGRA, "
cQuery1 += "      F6_DOCORIG = CASE WHEN F6_EST in('PR','PA','DF','MG','MT','AP','SC') THEN '1' "
cQuery1 += "           WHEN F6_EST in('RS') THEN '2' END NF "
cQuery1 += "      WHERE D_E_L_E_T_=' '  "
cQuery1 += "      AND F6_CDBARRA=' ' "
cQuery1 += "      AND F6_DTVENC>= GETDATE() - 5  "
//If ApMsgYesNo("Confirma execucaco da lib gnre?"+cquery1) 
        nStatus1 := TCSqlExec(cQuery1)
        if (nStatus1 < 0)
            conout("TCSQLError() " + TCSQLError())
        endif
        //alert('lib gnre - processo concluido')
//Endif      
Return()

/*---------------------------------------------------------------*/
#include "protheus.ch"
#include "rwmake.ch"    
#include "Topconn.ch"
/*----------------------*/
User Function aupdsf6()
cQuery1 := ""
cQuery1 += "      UPDATE SE2020 SET E2_HIST=LEFT(F6_DOC+' '+A1_NOME,40) "  																				
cQuery1 += "      	 FROM SE2020 F6 "
cQuery1 += "               INNER JOIN SF6020 E2 ON E2_FILIAL=F6_FILIAL AND E2_PREFIXO=LEFT(F6_NUMERO,3) AND E2_NUM=RIGHT(F6_NUMERO,9) AND E2.D_E_L_E_T_=' ' 	"
cQuery1 += "      	 INNER JOIN SA1020 A1 ON F6_CLIFOR=A1_COD AND F6_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' " 								
cQuery1 += "      	 AND E2_FORNECE='ESTADO' " 
cQuery1 += "      	 AND E2_HIST = ' ' "
cQuery1 += "      	 WHERE  F6.D_E_L_E_T_=' ' "

//If ApMsgYesNo("Confirma execucaco do aUPDSF6?"+cquery1) 
        nStatus1 := TCSqlExec(cQuery1)
        if (nStatus1 < 0)
            conout("TCSQLError() " + TCSQLError())
        endif
        //alert('aUPDSF6 - processo concluido')
//Endif      
Return()

User Function gnreori()
cQuery1 := ""
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'AC' AND F6_DTARREC >= GETDATE() - 5   "  
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'AL' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'22'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'AM' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'22'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'AM' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'AP' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'AP' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'CE' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'CE' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'DF' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'DF' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'GO' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'GO' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MA' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MA' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MG' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'    , F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MG' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MG' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MS' AND F6_DTARREC >= GETDATE() - 5   "
//cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MT' AND F6_DTARREC >= GETDATE() - 5   "
//cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'MT' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'PA' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'24'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'PE' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'24'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'PE' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'PI' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'PI' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'PR' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'PR' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'24'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'RJ' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'24'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'RJ' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'RO' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'RO' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'RR' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'22'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'RS' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'22'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'RS' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'22'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'RS' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'24'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'SC' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'SE' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'SE' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'10'	, F6_DOCORIG = 	'1'	WHERE F6_EST = 	'TO' AND F6_DTARREC >= GETDATE() - 5   "
cQuery1 += " UPDATE SF6020 SET F6_TIPOGNU = 	'22'	, F6_DOCORIG = 	'2'	WHERE F6_EST = 	'TO' AND F6_DTARREC >= GETDATE() - 5   "

       nStatus1 := TCSqlExec(cQuery1)
        if (nStatus1 < 0)
            conout("TCSQLError() " + TCSQLError())
        endif
        //alert('aUPDSF6 - processo concluido')
//Endif      
Return()


//=======================================================================================//
//                     Atualizar Dados da GNRE para o Estado do MT                       //
//=======================================================================================//
User Function AtuEstMT()

cQry1 := " SELECT F6_EST, F6_TIPOIMP, F6_CODREC     "
cQry1 += " FROM SF6020 F6 (NOLOCK)                  "
cQry1 += " WHERE F6.D_E_L_E_T_ = ' '                "
cQry1 += " AND F6_EST = 'MT'                        "
//cQry1 += " AND F6_GNREWS NOT IN ('T','S')         "
//cQry1 += " AND F6_CDBARRA = ' '                   "
cQry1 += " AND F6_FILIAL = '"+xFilial("SF6")+"'     "
cQry1 += " AND F6_DTARREC >= GETDATE() - 5          "

If Select("TMPMT") <> 0
    TMPMT->(DbCloseArea())
Endif

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TMPMT",.T.,.T.)
TMPMT->(DbGoTop())

While TMPMT->(!EOF())

    If TMPMT->F6_TIPOIMP = '3' .And. TMPMT->F6_CODREC = '100129'
        cQuery1 := "  UPDATE SF6020 SET F6_DETRECE = '000112', F6_TIPOGNU = '22', F6_DOCORIG = '2'  "
    Elseif TMPMT->F6_TIPOIMP = '3' .And. TMPMT->F6_CODREC = '100099'
        cQuery1 := "  UPDATE SF6020 SET F6_DETRECE = '000106', F6_TIPOGNU = '22', F6_DOCORIG = '2'  "
    Elseif TMPMT->F6_TIPOIMP = 'B' .And. TMPMT->F6_CODREC = '100129'
        cQuery1 := "  UPDATE SF6020 SET F6_DETRECE = '000057', F6_TIPOGNU = '22', F6_DOCORIG = '2'  "
    Elseif TMPMT->F6_TIPOIMP = 'B' .And. TMPMT->F6_CODREC = '100102'
        cQuery1 := "  UPDATE SF6020 SET F6_DETRECE = '000055', F6_TIPOGNU = '22', F6_DOCORIG = '2'  "
    Endif
    cQuery1 += " WHERE D_E_L_E_T_ = ' '                     "
    cQuery1 += " AND F6_EST = 'MT'                          "
    //cQuery1 += " AND F6_GNREWS NOT IN ('T','S')           "
    //cQuery1 += " AND F6_CDBARRA = ' '                     "
    cQuery1 += " AND F6_FILIAL = '"+xFilial("SF6")+"'       "
    cQuery1 += " AND F6_DTARREC >= GETDATE() - 5            "
    cQuery1 += " AND F6_TIPOIMP = '"+TMPMT->F6_TIPOIMP+"'   "
    cQuery1 += " AND F6_CODREC = '"+TMPMT->F6_CODREC+"'     "

    TCSqlExec(cQuery1)

    TMPMT->(DbSkip())

Enddo

TMPMT->(DbCloseArea())

Return()

User Function ace_gnre()
	u_libgnre()
	u_gnreori()
	u_aupdsf6()
    u_AtuEstMT()
	// msginfo("GNRE ATUALIZADA !")
return
