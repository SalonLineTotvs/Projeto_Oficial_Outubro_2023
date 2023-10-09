#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ? FATR0008     ºAutor³ Valmir         			       Data ? 07/12/2018 º±?                                     
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ? Relatorio de pedidos deletados					                     º±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
         
 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄaÄÄÄÄÄÄÄ´±±
±±³ 						ULTIMAS ATUALIZAÇÕES      					                                       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ 	NOME             ³ 	HORA                               	 									  ³±±
±±³ 									 																	  ³±±
±±³ 																										  ³±±
±±³ 									 																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function FATR0008()

// para obter as informações de alteração 
Private cUserA 		:= "" 
Private cDataA 		:= "" 
Private cQuery 		:= ""
Private dDtDE		:= ctod("  /  /  ")	
Private dDtATE		:= ddatabase		
Private aAreaAtu	:= GetArea() 	              
Private cMail 		:= GETMV("ES_FATR008")
Private oFiltro


DEFINE MSDIALOG oFiltro FROM 000,000 TO 280,300 TITLE Alltrim(OemToAnsi("FILTRO DE PEDIDOS DELETADOS")) Pixel

oSayLn4		:= tSay():New(0030,0005,{||"EMISSAO DE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet4		:= tGet():New(0028,0080,{|u| if(Pcount()>0,dDtDE:=u,dDtDE) },oFiltro,40,10,,,,,,,,.T.,,,,,,,,,,"dDtDE",,,,,.F.)

oSayLn5		:= tSay():New(0050,0005,{||"EMISSAO ATE?"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
oGet5		:= tGet():New(0048,0080,{|u| if(Pcount()>0,dDtATE:=u,dDtATE) },oFiltro,40,10,,,,,,,,.T.,,,,,,,,,,"dDtATE",,,,,.F.)  
                                                                                                                                 
@ 070, 0080 BmpButton Type 01 Action Close(oFiltro)
@ 070, 0110 BmpButton Type 02 Action Close(oFiltro)
 	
Activate Dialog oFiltro Centered

cQuery	:= " SELECT CASE C5_FILIAL																								"
cQuery	+= " WHEN '0101' THEN 'CIMEX'                                                                                           " 	
cQuery	+= " WHEN '0201' THEN 'CROZE'                                                                                           "
cQuery	+= " WHEN '0301' THEN 'KOPEK'                                                                                           "
cQuery	+= " WHEN '0401' THEN 'MACO '                                                                                           "
cQuery	+= " WHEN '0501' THEN 'QUBIT'                                                                                           "
cQuery	+= " WHEN '0601' THEN 'ROJA '                                                                                           "
cQuery	+= " WHEN '0701' THEN 'VIXEN'                                                                                           "
cQuery	+= " WHEN '0801' THEN 'MAIZE'                                                                                           "
cQuery	+= " WHEN '0901' THEN 'DEVINTEX FILIAL'                                                                                 "
cQuery	+= " WHEN '0902' THEN 'DEVINTEX FILIAL - MG'END EMPRESA,                                                                "
cQuery	+= " C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, SUM(C6_VALOR) C6_VALOR, 'DELETADO' C5STATUS, C5_USERLGA, C5_USERLGI       "
cQuery	+= " FROM SC5020 C5 WITH (NOLOCK)                                                                                       "
cQuery	+= " 	INNER JOIN SC6020 C6 WITH (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = '*'         "
cQuery	+= " 	INNER JOIN SA1020 A1 WITH (NOLOCK) ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_ = ''       "
cQuery	+= " WHERE C5.D_E_L_E_T_ = '*'                                                                                          "
cQuery	+= " AND C5_EMISSAO BETWEEN '"+DTOS(dDtDE)+"'	AND '"+DTOS(dDtATE)+"'                                                  "
cQuery	+= " GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_USERLGA, C5_USERLGI                                "    

If Select("TMPSC5") <> 0
	DbSelectArea("TMPSC5")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TMPSC5"

dbSelectArea("TMPSC5")
TMPSC5->(dbGoTop())


cAssunto	:= "Relatório de Pedidos Excluídos"

cBody		:= '<html>'
cBody		+= '<body bgcolor="#FfFFFF">
cBody		+= '<table style="width:1105px;margin-left:5px;" border="0" cellpadding="0" cellspacing="0">
cBody		+= '<tbody>
cBody		+= '<tr>
cBody		+= '<td valign="top" width="1100" height="30" style="background-color:#0000FF; margin-left:10px;-webkit-border-
cBody		+= 'radius:5px;-moz-border-radius:5px;border-radius:5px;vertical-align:middle; width:1100px;overflow:hidden;margin-
cBody		+= 'left:12px;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;" >
cBody		+= '&nbsp;&nbsp;&nbsp;&nbsp;Relatório de Pedidos Excluídos
cBody		+= '</td>
cBody		+= '</tr>
cBody		+= '<tr>
cBody		+= '<td align="left" valign="top">
cBody		+= '<table style="width:1100px;" border="0" cellpadding="0" cellspacing="0">
cBody		+= '<tbody>
cBody		+= '<tr>
cBody		+= '<td width="4">&nbsp;</td>
cBody		+= '<td align="left" bgcolor="#FFFFFF" valign="top" width="1010" style="padding-left:14px;padding-
cBody		+= 'right:14px;padding-top:18px;padding-bottom:14px; border-left:1px solid #b2b2b2; border-right:1px solid
cBody		+= '#bcbcbc; border-bottom:1px solid #bcbcbc;-webkit-border-bottom-right-radius: 5px;-webkit-border-bottom-
cBody		+= 'left-radius: 5px;-moz-border-radius-bottomright: 5px;-moz-border-radius-bottomleft: 5px;border-bottom-
cBody		+= 'right-radius: 5px;border-bottom-left-radius: 5px;">
cBody		+= '<table style="width:1070px" border="0" cellpadding="0" cellspacing="0">
cBody		+= '<tbody>
cBody		+= '<tr>
cBody		+= '<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 20px; color:
cBody		+= '#000000; line-height: 24px;" align="left" valign="top">Prezados,</td>
cBody		+= '</tr>
cBody		+= '<tr>
cBody		+= '<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 15px; color:
cBody		+= '#000000; line-height: 21px;" align="left" valign="top"><br />Houve exclusão de pedidos de vendas
cBody		+= '<br />
cBody		+= '<br />
cBody		+= '<table>
cBody		+= '<tr>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="250">Empresa	
cBody		+= '</td>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Num PV	
cBody		+= '</td>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Cliente	
cBody		+= '</td>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="40">Loja	
cBody		+= '</td>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="700">Nome	
cBody		+= '</td>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="50">Valor	
cBody		+= '</td> 
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Status	
cBody		+= '</td> 
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Usuario Del.	
cBody		+= '</td>
cBody		+= '<td 
cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Data Delete	
cBody		+= '</td>
cBody		+= '</tr>

While TMPSC5->(!EOF()) 
	
	cUserA := FWLeUserlg("TMPSC5->C5_USERLGA")
	cDataA := FWLeUserlg("TMPSC5->C5_USERLGA", 2)
	
	cBody		+= '<td 
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="250">'+TMPSC5->EMPRESA+'</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSC5->C5_NUM+'</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSC5->C5_CLIENTE+'</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="40">'+TMPSC5->C5_LOJACLI+'</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="700">'+TMPSC5->A1_NOME+'</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="50">'+TRANSFORM(TMPSC5->C6_VALOR,"@E 999,999.99")+'</td>
	cBody		+= '<td                                                                                                                                                   
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+TMPSC5->C5STATUS+'</td>
	cBody		+= '<td                                                                                                                                                   
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+cUserA+'</td>
	cBody		+= '<td                                                                                                                                                   
	cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+cDataA+'</td>
	cBody		+= '<tr>

	TMPSC5->(dbSkip())

Enddo

cBody		+= '</tbody>
cBody		+= '</table>
cBody		+= '</td>
cBody		+= '</tr>
cBody		+= '</tbody>
cBody		+= '</table>
cBody		+= '</td>
cBody		+= '</tr>
cBody		+= '</tbody>
cBody		+= '</table>
cBody		+= '</body>
cBody		+= '</html>'
	
       
U_SendMail( cMail,,, cAssunto, cBody, )
		
Alert("E-mail Enviado")

RestArea(aAreaAtu)

Return()