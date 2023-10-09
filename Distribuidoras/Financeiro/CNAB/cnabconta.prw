#Include "Protheus.ch"
#Include "ParmType.ch"

/*���������������������������������������������������������������������������
���Programa  �RETBCO    �Autor  �Eduardo Silva      � Data �  22/09/2023  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para tratamento do retorno do codigo do Banco.    ���
���          �                                                        	  ���
�������������������������������������������������������������������������͹��
���Uso       � Salonline                                                  ���
���������������������������������������������������������������������������*/

User Function retbco()
Local cBcoFor := ""
If !Empty(SE2->E2_CODBAR)
   cBcoFor := Substr(SE2->E2_CODBAR,1,3)
Else
   If Alltrim(SE2->E2_XBCO) <> ''
      cBcoFor := SE2->E2_XBCO
   ElseIf Alltrim(SE2->E2_FORBCO) <> ''
      cBcoFor := SE2->E2_FORBCO
   ElseIf Alltrim(SA2->A2_BANCO) <> ''
      cBcoFor := SA2->A2_BANCO
   EndIf
EndIf
Return cBcoFor

/*���������������������������������������������������������������������������
���Programa  �RETAGE    �Autor  �Eduardo Silva      � Data �  22/09/2023  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para tratamento do retorno da Ag�ncia.            ���
���          �                                                        	  ���
�������������������������������������������������������������������������͹��
���Uso       � Salonline                                                  ���
���������������������������������������������������������������������������*/

User Function retage()
cRetAge := ""
If cBanco == "422"
   If Alltrim(SE2->E2_XAGENC) <> ''
      cRetAge := Strzero(Val(SE2->E2_XAGENC),7)
   ElseIf Alltrim(SE2->E2_FORAGE) <> ''
      cRetAge := Strzero(Val(SE2->E2_FORAGE),7)
   ElseIf Alltrim(SA2->A2_AGENCIA) <> ''
      cRetAge := Strzero(Val(SA2->A2_AGENCIA),7)
   EndIf
Else
   If Alltrim(SE2->E2_XAGENC) <> ''
      cRetAge := SE2->E2_XAGENC
   ElseIf Alltrim(SE2->E2_FORAGE) <> ''
      cRetAge := SE2->E2_FORAGE
   ElseIf Alltrim(SA2->A2_AGENCIA) <> ''
      cRetAge := SA2->A2_AGENCIA
   EndIf
EndIf
Return cRetAge

/*���������������������������������������������������������������������������
���Programa  �RETCTA    �Autor  �Eduardo Silva      � Data �  22/09/2023  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para tratamento do retorno da Conta.              ���
���          �                                                        	  ���
�������������������������������������������������������������������������͹��
���Uso       � Salonline                                                  ���
���������������������������������������������������������������������������*/

User Function retcta()
Local cRetCta := ""
If cBanco == "422"
   If Alltrim(SE2->E2_XCTA) <> ''
      cRetCta := Strzero(Val(Substr(SE2->E2_XCTA,1,At(" ",SE2->E2_XCTA) - 2) + Right(Alltrim(SE2->E2_XCTA),1)),10)
   ElseIf Alltrim(SE2->E2_FORCTA+SE2->E2_FCTADV) <> ''
      cRetCta := Strzero(Val(SE2->E2_FORCTA),9) + Right(Alltrim(SE2->E2_FCTADV),1)
   ElseIf Alltrim(SA2->A2_NUMCON + SA2->A2_DVCTA) <> ''
      cRetCta := Strzero(Val(SA2->A2_NUMCON),9) + Right(Alltrim(SA2->A2_DVCTA),1)
   EndIf
Else
   If Alltrim(SE2->E2_XCTA) <> ''
      cRetCta := Substr(Strzero(Val(SE2->E2_XCTA),13),1,12) + " " + Substr(Strzero(Val(SE2->E2_XCTA),13),13,1)
   ElseIf Alltrim(SE2->E2_FORCTA+SE2->E2_FCTADV) <> ''
      cRetCta := Strzero(Val(SE2->E2_FORCTA),12) + " " + SE2->E2_FCTADV
   ElseIf Alltrim(SA2->A2_NUMCON + SA2->A2_DVCTA) <> ''
      cRetCta := Strzero(Val(SA2->A2_NUMCON),12) + " " + SA2->A2_DVCTA
   EndIf
EndIf
Return cRetCta

/*���������������������������������������������������������������������������
���Programa  �RETCPF    �Autor  �Eduardo Silva      � Data �  22/09/2023  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para tratamento do retorno do CPF ou CNPJ.        ���
���          �                                                        	  ���
�������������������������������������������������������������������������͹��
���Uso       � Salonline                                                  ���
���������������������������������������������������������������������������*/

User Function retcpf()
Local cRetCPF := ""
If Alltrim(SE2->E2_XCNPJ) <> ''
   cRetCPF := SE2->E2_XCNPJ
Else    
   cRetCPF := SA2->A2_CGC
EndIf
Return cRetCPF

/*���������������������������������������������������������������������������
���Programa  �RETNOM    �Autor  �Eduardo Silva      � Data �  22/09/2023  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para tratamento do retorno do Nome do Fornecedor. ���
���          �                                                        	  ���
�������������������������������������������������������������������������͹��
���Uso       � Salonline                                                  ���
���������������������������������������������������������������������������*/

User Function retnom()
Local cRetNom := ""
If Alltrim(SE2->E2_XNOME) <> ''
   cRetNom := SE2->E2_XNOME
ElseIf Alltrim(SA2->A2_NOME) <> ''
   cRetNom := SA2->A2_NOME
EndIf
Return cRetNom

/*���������������������������������������������������������������������������
���Programa  �RETINSC   �Autor  �Eduardo Silva      � Data �  28/09/2023  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para tratamento do retorno do Tipo de Inscri��o.  ���
���          � Cpf ou Cnpj.                                            	  ���
�������������������������������������������������������������������������͹��
���Uso       � Salonline                                                  ���
���������������������������������������������������������������������������*/

User Function retinsc()
cTipInsc := Iif(!Empty(Alltrim(SE2->E2_XCNPJ)) .And. Len(Alltrim(SE2->E2_XCNPJ)) == 11, "1", Iif(!Empty(Alltrim(SE2->E2_XCNPJ)) .And. Len(Alltrim(SE2->E2_XCNPJ)) == 14, "2", Iif(SA2->A2_TIPO == "F", "1", "2")))
Return cTipInsc
