#include 'Ap5Mail.ch'
#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA030TOK º Autor ³ Andre Valmir/Introdeº Data ³  07/11/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ponto de Entrada alteração do cliente					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SOL. DANIELE FRANÇA - CHAMADO TK1810290                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/           

User Function MA030TOK()
  
Local cConAnter	:= ""
Local cConAtual	:= ""
Local cMail 	:= GETMV("ES_MA030TO")
Local cMailTran	:= GETMV("ES_MA030TP")
Local lRet		:= .T.
Local aAreaAtu	:= GetArea()
Local cAssunto	:= ''
Local cBody		:= ''
Local cNomUser 	:= USRRETNAME(RetCodUsr())
Local aClass	:= {"Sem Classificação","0-Vip 0","1-Vip 1","2-Vip 2","3-Normal","4-VIP FARM"}
                   //1 					2			3     4
                   //Vazio			    0			1	  2	

Local cTranpAnt	:= ""
Local cTranpAtu	:= ""	

nConAnter	:= IF(Empty(SA1->A1_X_PRIOR),1,VAL(SA1->A1_X_PRIOR)+2 )
nConAtual	:= IF(Empty(M->A1_X_PRIOR)  ,1,VAL(M->A1_X_PRIOR)+2   )

cTranpAnt 	:= SA1->A1_TRANSP 
cTranpAtu	:= M->A1_TRANSP

If Altera

	If nConAnter != nConAtual
		
		cAssunto	:= " Aviso de Alteração na classificação de Cliente "+M->A1_COD+"/"+M->A1_LOJA+" - "+M->A1_NOME
		cBody		:= '<html>' 
		cBody		+= '	<body bgcolor="#FfFFFF">
		cBody		+= '		<table style="width: 691px;margin-left:5px;" border="0" cellpadding="0" cellspacing="0">
		cBody		+= '	<tbody>
		cBody		+= '	<tr>
		cBody		+= '		<td valign="top" width="691" height="30" style="background-color:#0000FF; margin-left:10px;-webkit-border-
		cBody		+= '		radius:5px;-moz-border-radius:5px;border-radius:5px;vertical-align:middle; width:691px;overflow:hidden;margin-
		cBody		+= '		left:12px;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;" >
		cBody		+= '		&nbsp;&nbsp;&nbsp;&nbsp;Alteração de Prioridade
		cBody		+= '		</td>
		cBody		+= '	</tr>
		cBody		+= '	<tr>
		cBody		+= '		<td align="left" valign="top">
		cBody		+= '			<table style="width: 705px;" border="0" cellpadding="0" cellspacing="0">
		cBody		+= '            	<tbody>
		cBody		+= '					<tr>
		cBody		+= '                     	<td width="2">&nbsp;</td>
		cBody		+= '                      	<td align="left" bgcolor="#FFFFFF" valign="top" width="664" style="padding-left:14px;padding-
		cBody		+= '						right:14px;padding-top:18px;padding-bottom:14px; border-left:1px solid #b2b2b2; border-right:1px solid
		cBody		+= '                       	#bcbcbc; border-bottom:1px solid #bcbcbc;-webkit-border-bottom-right-radius: 5px;-webkit-border-bottom-
		cBody		+= '                       	left-radius: 5px;-moz-border-radius-bottomright: 5px;-moz-border-radius-bottomleft: 5px;border-bottom-
		cBody		+= '                        right-radius: 5px;border-bottom-left-radius: 5px;">
		cBody		+= '                       	<table style="width: 664px" border="0" cellpadding="0" cellspacing="0">
		cBody		+= '                      	<tbody>
		cBody		+= '                      	<tr>
		cBody		+= '                       	<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 20px; color:
		cBody		+= '                     	#000000; line-height: 24px;" align="left" valign="top">Prezados,</td>
		cBody		+= '                      	</tr>
		cBody		+= '                     	<tr>
		cBody		+= '                     	<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 15px; color:
		cBody		+= '                     	#000000; line-height: 21px;" align="left" valign="top"><br />Houve alteração na classificação do Cliente
		cBody		+= '                     	<br />
		cBody		+= '                    	<br />
		cBody		+= '                     	<table>
		cBody		+= '                    		<tr>
		cBody		+= '                           		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Cliente
		cBody		+= '                           		</td>
		cBody		+= '                           		<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+M->A1_COD+"/"+M->A1_LOJA+" - "+M->A1_NOME+'<br /></td>
		cBody		+= '                       		</tr>	
		cBody		+= '                           	<tr>
		cBody		+= '                           		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '								serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Data da
		cBody		+= '                             	Alteração</td>
		cBody		+= '								<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                            	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+Transform(DDATABASE,"99/99/9999")+" "+SUBSTR(TIME(),1,5)+'</td>
		cBody		+= '                       		</tr>
		cBody		+= '                           	<tr>
		cBody		+= '                       	   		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                            	serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Alterado
		cBody		+= '                            	Por</td>
		cBody		+= '                             	<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                            	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+cNomUser+'</td>
		cBody		+= '                         	 </tr>
		cBody		+= '                     		 <tr>
		cBody		+= '                          		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Prioridade Anterior
		cBody		+= '                             	</td>
		cBody		+= '                              	<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                             	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+aClass[nConAnter]+'</td>
		cBody		+= '								<br>
		cBody		+= '                         	</tr> 
		cBody		+= '                     		 <tr>
		cBody		+= '                          		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Prioridade Atual
		cBody		+= '                             	</td>
		cBody		+= '                              	<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                             	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+aClass[nConAtual]+'</td>
		cBody		+= '								<br>
		cBody		+= '                         	</tr>
		cBody		+= '                          	<tr>
		cBody		+= '                           		</table>
		cBody		+= '                                	E-mail enviado automaticamente, favor não responder
		cBody		+= '                               	</td>
		cBody		+= '							</tr>
		cBody		+= '  							</tbody>
		cBody		+= '                     	</table>
		cBody		+= '                     </td>
		cBody		+= '                 </tr>
		cBody		+= '             </tbody>
		cBody		+= '    	</table>
		cBody		+= '	</td>
		cBody		+= '</tr>
		cBody		+= '</tbody>
		cBody		+= '</table>
		cBody		+= '</body>
		cBody		+= '</html>
		
		U_SendMail( cMail,,, cAssunto, cBody, )	

	Endif                     

	
	If cTranpAnt != cTranpAtu
		
		cAssunto	:= " Aviso de Alteração da Transportadora do Cliente "+M->A1_COD+"/"+M->A1_LOJA+" - "+M->A1_NOME
		cBody		:= '<html>' 
		cBody		+= '	<body bgcolor="#FfFFFF">
		cBody		+= '		<table style="width: 691px;margin-left:5px;" border="0" cellpadding="0" cellspacing="0">
		cBody		+= '	<tbody>
		cBody		+= '	<tr>
		cBody		+= '		<td valign="top" width="691" height="30" style="background-color:#0000FF; margin-left:10px;-webkit-border-
		cBody		+= '		radius:5px;-moz-border-radius:5px;border-radius:5px;vertical-align:middle; width:691px;overflow:hidden;margin-
		cBody		+= '		left:12px;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;" >
		cBody		+= '		&nbsp;&nbsp;&nbsp;&nbsp;Alteração de Transportadora
		cBody		+= '		</td>
		cBody		+= '	</tr>
		cBody		+= '	<tr>
		cBody		+= '		<td align="left" valign="top">
		cBody		+= '			<table style="width: 705px;" border="0" cellpadding="0" cellspacing="0">
		cBody		+= '            	<tbody>
		cBody		+= '					<tr>
		cBody		+= '                     	<td width="2">&nbsp;</td>
		cBody		+= '                      	<td align="left" bgcolor="#FFFFFF" valign="top" width="664" style="padding-left:14px;padding-
		cBody		+= '						right:14px;padding-top:18px;padding-bottom:14px; border-left:1px solid #b2b2b2; border-right:1px solid
		cBody		+= '                       	#bcbcbc; border-bottom:1px solid #bcbcbc;-webkit-border-bottom-right-radius: 5px;-webkit-border-bottom-
		cBody		+= '                       	left-radius: 5px;-moz-border-radius-bottomright: 5px;-moz-border-radius-bottomleft: 5px;border-bottom-
		cBody		+= '                        right-radius: 5px;border-bottom-left-radius: 5px;">
		cBody		+= '                       	<table style="width: 664px" border="0" cellpadding="0" cellspacing="0">
		cBody		+= '                      	<tbody>
		cBody		+= '                      	<tr>
		cBody		+= '                       	<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 20px; color:
		cBody		+= '                     	#000000; line-height: 24px;" align="left" valign="top">Prezados,</td>
		cBody		+= '                      	</tr>
		cBody		+= '                     	<tr>
		cBody		+= '                     	<td style="font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 15px; color:
		cBody		+= '                     	#000000; line-height: 21px;" align="left" valign="top"><br />Houve alteração na Transportadora do Cliente
		cBody		+= '                     	<br />
		cBody		+= '                    	<br />
		cBody		+= '                     	<table>
		cBody		+= '                    		<tr>
		cBody		+= '                           		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Cliente
		cBody		+= '                           		</td>
		cBody		+= '                           		<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+M->A1_COD+"/"+M->A1_LOJA+" - "+M->A1_NOME+'<br /></td>
		cBody		+= '                       		</tr>	
		cBody		+= '                           	<tr>
		cBody		+= '                           		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '								serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Data da
		cBody		+= '                             	Alteração</td>
		cBody		+= '								<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                            	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+Transform(DDATABASE,"99/99/9999")+" "+SUBSTR(TIME(),1,5)+'</td>
		cBody		+= '                       		</tr>
		cBody		+= '                           	<tr>
		cBody		+= '                       	   		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                            	serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Alterado
		cBody		+= '                            	Por</td>
		cBody		+= '                             	<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                            	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+cNomUser+'</td>
		cBody		+= '                         	 </tr>
		cBody		+= '                     		 <tr>
		cBody		+= '                          		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Transportadora Anterior
		cBody		+= '                             	</td>
		cBody		+= '                              	<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                             	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+cTranpAnt+"-"+Posicione("SA4",1,xFilial("SA4")+cTranpAnt,"A4_NREDUZ")+'</td>
		cBody		+= '								<br>
		cBody		+= '                         	</tr> 
		cBody		+= '                     		 <tr>
		cBody		+= '                          		<td style="background-color:#bcbcbc;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                           		serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;" width="200">Transportadora Atual
		cBody		+= '                             	</td>
		cBody		+= '                              	<td style="background-color:#e6e6e6;font-family: Calibri, Arial, Helvetica, Verdana, sans-
		cBody		+= '                             	serif;font-size: 15px;padding:2px;padding-left:5px;" width="410">'+cTranpAtu+"-"+Posicione("SA4",1,xFilial("SA4")+cTranpAtu,"A4_NREDUZ")+'</td>
		cBody		+= '								<br>
		cBody		+= '                         	</tr>
		cBody		+= '                          	<tr>
		cBody		+= '                           		</table>
		cBody		+= '                                	E-mail enviado automaticamente, favor não responder
		cBody		+= '                               	</td>
		cBody		+= '							</tr>
		cBody		+= '  							</tbody>
		cBody		+= '                     	</table>
		cBody		+= '                     </td>
		cBody		+= '                 </tr>
		cBody		+= '             </tbody>
		cBody		+= '    	</table>
		cBody		+= '	</td>
		cBody		+= '</tr>
		cBody		+= '</tbody>
		cBody		+= '</table>
		cBody		+= '</body>
		cBody		+= '</html>
		
		U_SendMail( cMailTran,,, cAssunto, cBody, )	

	Endif
	

Endif                       

RestArea(aAreaAtu)

Return(lRet)
