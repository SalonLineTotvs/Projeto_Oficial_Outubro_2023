#include 'Ap5Mail.ch'
#include "rwmake.ch"
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � M030Inc  � Autor � Andre Luis / Introde � Data �  04/04/2014罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escri噭o � Ponto de Entrada apos Gravacao - Cliente (SA1)            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SOL. BRUNA / SANDRA DA EMERSON - NUTSTEEL                   罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function M030Inc()

Local nOpcao := PARAMIXB //Precisa informar com este Parametros, sen鉶 envia varios email a toda hora
Local cMail 	:= GETMV("ES_MAIL")
Local _cTo		:= UsrRetMail(__cUserId)
Local cAssunto	:= ''
Local cBody		:= ''

If Inclui .and. nOpcao == 0 //Inclusao
	cAssunto := "NOVO CLIENTE CADASTRADO"
	cBody := Chr(13)+Chr(10);
	+"Usuario: "+SUBSTR(CUSUARIO,7,15)+" - "+DTOC(DDATABASE)+" - "+SUBSTR(TIME(),1,5)+ Chr(13)+Chr(10);
	+"Codigo : "+SA1->A1_COD+" "+SA1->A1_LOJA+" - Razao Social: "+ALLTRIM(SA1->A1_NOME)
	
	U_SendMail( cMail,_cTo,, cAssunto, cBody, )
Endif

Return(.t.)

