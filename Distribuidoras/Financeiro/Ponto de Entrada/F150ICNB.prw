#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  F150ICNB    ³ Autor ³ Genesis/Gustavo    ³ Data³ 25.0.2019   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Alteração do numero E1_IDCNAB...                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Especifico³ Salon                                                ³±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ -= MASCARA =- ÜÜÜÜÜÜÜÜÜÜÜÜÜ     
ÜÜ > PREFIXO + NUMERO   + PARCELA          	ÜÜ	
ÜÜ   XXX       XXXXXXXXX  X       	-> 15  	ÜÜ
ÜÜ > IDCNAB									ÜÜ
ÜÜ   XXXXXXXXXX         			-> 10   ÜÜ
ÜÜ > PREFIXO + NUMERO   + PARCELA 			ÜÜ
ÜÜ   X         XXXXXXXX   X 		-> 10	ÜÜ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/ 
*----------------------* 
User Function F150ICNB()
*----------------------* 
Local _cIdCnab := PARAMIXB[1] 

Local _aAreaSE1 := SE1->(GetArea())
Local _aAreaSEA := SEA->(GetArea())
                                                 
IF SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO <> SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
	SE1->(DBSETORDER(1));SE1->(DBSEEK(xFilial('SE1')+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO))
ENDIF  
//_cIdCnab := Right(SEA->EA_NUM,8) + SEA->EA_PARCELA               
_cIdCnab := Left(AllTrim(SE1->E1_PREFIXO),1) + Right(SE1->E1_NUM,7) + PadR(AllTrim(SE1->E1_PARCELA),2)
RestArea(_aAreaSE1)                  
RestArea(_aAreaSEA)

Return(_cIdCnab)
