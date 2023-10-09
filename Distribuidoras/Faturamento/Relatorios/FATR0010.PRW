#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATR0010 บ Autor ณ Andre Valmir/Introdeบ Data ณ  14/12/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Envio de email emissใo de GNRE no sistema         		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                       

User Function FATR0010()

Local cMail 	:= ''
Local cCopia	:= '' 
Local lMail		:= .T.
Local cAssunto	:= ''
Local cBody		:= ''
Local cBodyX	:= ''
Local cQrySF6	:= ''
Local cEnt 		:= Chr(13)+Chr(10)
Local cPedVen	:= ''    
Local nValTot	:= 0

//PREPARE ENVIRONMENT EMPRESA '02' FILIAL '0101' MODULO "FAT"

cMail 	:= GETMV("ES_FATR010")
cCopia	:= GETMV("ES_FATR10C")

cQrySF6 := " SELECT CASE F6_FILIAL 																								"
cQrySF6 += " WHEN '0101' THEN 'CIMEX'   																						"    
cQrySF6 += " WHEN '0201' THEN 'CROZE'                                                                                           "
cQrySF6 += " WHEN '0301' THEN 'KOPEK'                                                                                           "
cQrySF6 += " WHEN '0401' THEN 'MACO '                                                                                           "
cQrySF6 += " WHEN '0501' THEN 'QUBIT'                                                                                           "
cQrySF6 += " WHEN '0601' THEN 'ROJA '                                                                                           "
cQrySF6 += " WHEN '0701' THEN 'VIXEN'                                                                                           "
cQrySF6 += " WHEN '0801' THEN 'MAIZE'                                                                                           "
cQrySF6 += " WHEN '0901' THEN 'DEVINTEX FILIAL'                                                                                 "
cQrySF6 += " WHEN '0902' THEN 'DEVINTEX FILIAL - MG' END EMPRESA, F6_FILIAL,                                                    			"
cQrySF6 += " A1_COD, A1_LOJA, A1_NOME, F6_EST, F6_NUMERO, F6_VALOR, F6_DTVENC, F6_DOC, A4_NREDUZ							    "
cQrySF6 += " FROM SF6020 F6 WITH (NOLOCK)                                                                                       "
cQrySF6 += " 	INNER JOIN SA1020 A1 WITH (NOLOCK) ON F6_CLIFOR = A1_COD AND F6_LOJA = A1_LOJA AND A1.D_E_L_E_T_ = ''           "
cQrySF6 += " 	INNER JOIN SA4020 A4 WITH (NOLOCK) ON A1_TRANSP = A4_COD AND A4.D_E_L_E_T_ = ''                                 "
cQrySF6 += " WHERE F6.D_E_L_E_T_ = ''                                                                                           "
cQrySF6 += " AND F6_X_ENVEM = ''  						                                                                        "

If Select("TMPSF6") <> 0
	DbSelectArea("TMPSF6")
	DbCloseArea()
Endif

TCQUERY cQrySF6 NEW ALIAS "TMPSF6"

dbSelectArea("TMPSF6")
TMPSF6->(dbGoTop())
                        

If !Empty(TMPSF6->F6_NUMERO)
    
	cAssunto	:= "Previsใo de inclusใo de GNRE para pagamento"
	
	cBody		:= '<html>'
	cBody		+= '<body bgcolor="#FfFFFF">
	cBody		+= '<table style="width:1105px;margin-left:5px;" border="0" cellpadding="0" cellspacing="0">
	cBody		+= '<tbody>
	cBody		+= '<tr>
	cBody		+= '<td valign="top" width="1100" height="30" style="background-color:#0000FF; margin-left:10px;-webkit-border-
	cBody		+= 'radius:5px;-moz-border-radius:5px;border-radius:5px;vertical-align:middle; width:1100px;overflow:hidden;margin-
	cBody		+= 'left:12px;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;" >
	cBody		+= '&nbsp;&nbsp;&nbsp;&nbsp;Houve inclusใo de GNRE para pagamento
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
	cBody		+= '#000000; line-height: 21px;" align="left" valign="top"><br />Houve inclusใo de GNRE para pagamento
	cBody		+= '<br />
	cBody		+= '<br />
	cBody		+= '<table>
	cBody		+= '<tr>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="350">Empresa	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Cod.Cliente	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Loja	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="1100">Nome Cliente	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Estado	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="50">Num.GNRE	
	cBody		+= '</td> 
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="100">Valor GNRE	
	cBody		+= '</td>    
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Data Venc.	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Num. NF	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="230">Transportadora	
	cBody		+= '</td>
	cBody		+= '</tr>
	
	While TMPSF6->(!EOF())
	    
		cBody		+= '<td 
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="350">'+Alltrim(TMPSF6->EMPRESA)+'</td>
		cBody		+= '<td 
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSF6->A1_COD+'</td>
		cBody		+= '<td 
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSF6->A1_LOJA+'</td>
		cBody		+= '<td 
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="1100">'+Substr(Alltrim(TMPSF6->A1_NOME),1,36)+'</td>
		cBody		+= '<td 
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSF6->F6_EST+'</td>
		cBody		+= '<td 
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="50">'+TMPSF6->F6_NUMERO+'</td>
		cBody		+= '<td                                                                                                                                                   
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="100">'+TRANSFORM(TMPSF6->F6_VALOR,"@E 999,999,999.99")+'</td>
		cBody		+= '<td                                                                                                                                                   
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+SUBSTR(F6_DTVENC,7,2)+'/'+SUBSTR(F6_DTVENC,5,2)+'/'+SUBSTR(F6_DTVENC,1,4)+'</td>
		cBody		+= '<td                                                                                                                                                   
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+TMPSF6->F6_DOC+'</td>
		cBody		+= '<td                                                                                                                                                   
		cBody		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="230">'+Alltrim(TMPSF6->A4_NREDUZ)+'</td>	
		cBody		+= '<tr>   
		
		nValTot		+= TMPSF6->F6_VALOR
	
		TMPSF6->(dbSkip())
	
	Enddo                  

	cBody		+= '<tr>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="350">Valor Total GNRE	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="1100">	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="50">	
	cBody		+= '</td> 
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="100">'+TRANSFORM(nValTot,"@E 999,999,999.99")+'	
	cBody		+= '</td>    
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">	
	cBody		+= '</td>
	cBody		+= '<td 
	cBody		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="230">	
	cBody		+= '</td>
	cBody		+= '</tr>
	
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
	nValTot := 0

	TMPSF6->(dbGoTop())
	
	While TMPSF6->F6_FILIAL="0801" 

		cBodyX		:= '<html>'
		cBodyX		+= '<body bgcolor="#FfFFFF">
		cBodyX		+= '<table style="width:1105px;margin-left:5px;" border="0" cellpadding="0" cellspacing="0">
		cBodyX		+= '<tbody>
		cBodyX		+= '<tr>
		cBodyX		+= '<td valign="top" width="1100" height="30" style="background-color:#0000FF; margin-left:10px;-webkit-border-
		cBodyX		+= 'radius:5px;-moz-border-radius:5px;border-radius:5px;vertical-align:middle; width:1100px;overflow:hidden;margin-
		cBodyX		+= 'left:12px;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;" >
		cBodyX		+= '&nbsp;&nbsp;&nbsp;&nbsp;Houve inclusใo de GNRE para pagamento
		cBodyX		+= '</td>
		cBodyX		+= '</tr>
		cBodyX		+= '<tr>
		cBodyX		+= '<td align="left" valign="top">
		cBodyX		+= '<table style="width:1100px;" border="0" cellpadding="0" cellspacing="0">
		cBodyX		+= '<tbody>
		cBodyX		+= '<tr>
		cBodyX		+= '<td width="4">&nbsp;</td>
		cBodyX		+= '<td align="left" bgcolor="#FFFFFF" valign="top" width="1010" style="padding-left:14px;padding-
		cBodyX		+= 'right:14px;padding-top:18px;padding-bottom:14px; border-left:1px solid #b2b2b2; border-right:1px solid
		cBodyX		+= '#bcbcbc; border-bottom:1px solid #bcbcbc;-webkit-border-bottom-right-radius: 5px;-webkit-border-bottom-
		cBodyX		+= 'left-radius: 5px;-moz-border-radius-bottomright: 5px;-moz-border-radius-bottomleft: 5px;border-bottom-
		cBodyX		+= 'right-radius: 5px;border-bottom-left-radius: 5px;">
		cBodyX		+= '<table style="width:1070px" border="0" cellpadding="0" cellspacing="0">
		cBodyX		+= '<tbody>
		cBodyX		+= '<tr>
		cBodyX		+= '<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 20px; color:
		cBodyX		+= '#000000; line-height: 24px;" align="left" valign="top">Prezados,</td>
		cBodyX		+= '</tr>
		cBodyX		+= '<tr>
		cBodyX		+= '<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 15px; color:
		cBodyX		+= '#000000; line-height: 21px;" align="left" valign="top"><br />Houve inclusใo de GNRE para pagamento
		cBodyX		+= '<br />
		cBodyX		+= '<br />
		cBodyX		+= '<table>
		cBodyX		+= '<tr>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="350">Empresa	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Cod.Cliente	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Loja	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="1100">Nome Cliente	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">Estado	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="50">Num.GNRE	
		cBodyX		+= '</td> 
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="100">Valor GNRE	
		cBodyX		+= '</td>    
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Data Venc.	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">Num. NF	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="230">Transportadora	
		cBodyX		+= '</td>
		cBodyX		+= '</tr>
		
		While TMPSF6->(!EOF()) .And. TMPSF6->F6_FILIAL="0801" 
		    
			cBodyX		+= '<td 
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="350">'+Alltrim(TMPSF6->EMPRESA)+'</td>
			cBodyX		+= '<td 
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSF6->A1_COD+'</td>
			cBodyX		+= '<td 
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSF6->A1_LOJA+'</td>
			cBodyX		+= '<td 
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="1100">'+Substr(Alltrim(TMPSF6->A1_NOME),1,36)+'</td>
			cBodyX		+= '<td 
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="80">'+TMPSF6->F6_EST+'</td>
			cBodyX		+= '<td 
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="50">'+TMPSF6->F6_NUMERO+'</td>
			cBodyX		+= '<td                                                                                                                                                   
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="100">'+TRANSFORM(TMPSF6->F6_VALOR,"@E 999,999,999.99")+'</td>
			cBodyX		+= '<td                                                                                                                                                   
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+SUBSTR(F6_DTVENC,7,2)+'/'+SUBSTR(F6_DTVENC,5,2)+'/'+SUBSTR(F6_DTVENC,1,4)+'</td>
			cBodyX		+= '<td                                                                                                                                                   
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="70">'+TMPSF6->F6_DOC+'</td>
			cBodyX		+= '<td                                                                                                                                                   
			cBodyX		+= 'style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;" width="230">'+Alltrim(TMPSF6->A4_NREDUZ)+'</td>	
			cBodyX		+= '<tr>   
			
			nValTot		+= TMPSF6->F6_VALOR
		
			TMPSF6->(dbSkip())
		
		Enddo                  
	
		cBodyX		+= '<tr>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="350">Valor Total GNRE	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="1100">	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="80">	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="50">	
		cBodyX		+= '</td> 
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="100">'+TRANSFORM(nValTot,"@E 999,999,999.99")+'	
		cBodyX		+= '</td>    
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="70">	
		cBodyX		+= '</td>
		cBodyX		+= '<td 
		cBodyX		+= 'style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="230">	
		cBodyX		+= '</td>
		cBodyX		+= '</tr>
		
		cBodyX		+= '</tbody>
		cBodyX		+= '</table>
		cBodyX		+= '</td>
		cBodyX		+= '</tr>
		cBodyX		+= '</tbody>
		cBodyX		+= '</table>
		cBodyX		+= '</td>
		cBodyX		+= '</tr>
		cBodyX		+= '</tbody>
		cBodyX		+= '</table>
		cBodyX		+= '</body>
		cBodyX		+= '</html>'
		
	EndDo	  
	
	U_SendMail( cCopia,,, cAssunto, cBodyX, )
	
		
	cQrySF6 := " UPDATE SF6020 SET F6_X_ENVEM = '1' WHERE F6_X_ENVEM = '' "
	TcSqlExec(cQrySF6)
		
	cQrySE2 := " UPDATE SE2020 SET E2_HIST=LEFT(F6_DOC+' '+A1_NOME,40)   																				"
	cQrySE2 += " FROM SF6020 F6         																												"
	cQrySE2 += " INNER JOIN SE2020 E2 ON E2_FILIAL=F6_FILIAL AND E2_PREFIXO=LEFT(F6_NUMERO,3) AND E2_NUM=RIGHT(F6_NUMERO,9) AND E2.D_E_L_E_T_=' ' 		"
	cQrySE2 += " INNER JOIN SA1020 A1 ON F6_CLIFOR=A1_COD AND F6_LOJA=A1_LOJA AND A1.D_E_L_E_T_=' ' 													"
	cQrySE2 += " AND E2_FORNECE='ESTADO'                                                                                                                "
	cQrySE2 += " AND E2_HIST <> ''  	                                                                                                                "	
	cQrySE2 += " WHERE F6.D_E_L_E_T_=' ' 						                                                                                        "
	
	TcSqlExec(cQrySE2)
		
Endif

//RESET ENVIRONMENT

Return()		