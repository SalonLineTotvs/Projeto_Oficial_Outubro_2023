#include "protheus.ch"
/*���������������������������������������������������������������������������
���Programa  �FA60FIL   �Autor  � Andre salgado       � Data �  17/05/2018���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Filtrar S� Titulos de Clientes       ���
���          �     EMCOMANDANTE ESTAO SENDO RETIRADOS     				  ���
�������������������������������������������������������������������������͹��
���Uso       � Salon Line                                                 ���
���������������������������������������������������������������������������
Data 07/06/2018 - Sol.Renato J / Autorizada Genilson / Autor Andr� Salgado
=> (01) Incluir op��o para Filtra Titulos com Historico MANIF
���������������������������������������������������������������������������*/

User Function FA60FIL()

//Local aArea 	:= GetArea()

SetPrvt("CFILTRO")

cfiltro := ""

If MsgYesNo("Ser� feito Filtro para trazer SOMENTE TITULO(s) DE CLIENTE(s), n�o ser� apresentado NF Encomendantes ?","Aten��o!")
	cfiltro := " !(E1_CLIENTE $ '001629,000871,000534,001286,001398') .AND. SE1->E1_X_FORMP <> 'DP ' "
	/*
	000871 - ALFALOG (E)
	000534 - AQUARIUS(E)
	001286 - TEXTOR  (E)
	001398 - CAREX   (E)
	*/
	
	
	//(01) Melhoria Filtra Titulo que foram MANIFESTADOS
	If MsgYesNo("Deseja Filtrar Titulos Manifestado ?","Aten��o!")
		cfiltro := " SE1->E1_X_DTMAN <> CTOD(' / / ') .AND. SE1->E1_X_FORMP <> 'DP ' "		//BOTAO SIM
	Else
		cfiltro := " !(E1_CLIENTE $ '001629,000871,000534,001286,001398') .AND. SE1->E1_X_FORMP <> 'DP ' "	//BOTAO NAO
	Endif	
	
else
	cfiltro := " E1_MDCRON=' ' .AND. SE1->E1_X_FORMP <> 'DP ' "
EndIf

//RestArea(aArea)

Return(cfiltro)
