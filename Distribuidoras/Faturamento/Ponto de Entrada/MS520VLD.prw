#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MS520VLD  �Autor  �Introde             � Data �  02/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Execblock Validar Exclus�o NF Sa�da                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Bloquear Exclus�o Nf s/ Manifesto                          ���
�������������������������������������������������������������������������ͼ��
Melhoria:

> Sol.Genilson Lucas
> Data 06/08/2019 - (1) Andre Salgado / Travar para nao autorizar Cancelar NF j� enviada para MC (Monta Carga) solicita��o NF para Logistica

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MS520VLD()

Local _aArea 	:= GetArea()
Local lRet		:= .T.
Local cEnt 		:= Chr(13)+Chr(10)


//��������������������������������������8
//� N�O EXCLUIR NF COM MANIFESTO		�
//��������������������������������������8
If !Empty(SF2->F2_X_NRMA)
	MsgInfo("N�o foi poss�vel excluir Nota Fiscal: "+SF2->F2_DOC+", pois j� foi gerado manifesto."+cEnt+"Favor excluir Manifesto N� "+SF2->F2_X_NRMA+" e tentar novamente." ,"Aten��o")
	lRet	:= .F.
EndIf

//��������������������������������������8
//� N�o excluir NF com Monta Carga		�
//��������������������������������������8
If !Empty(SF2->F2_X_NRMC)
	MsgInfo("N�o foi poss�vel excluir Nota Fiscal: "+SF2->F2_DOC+", pois j� foi gerado Monta Carga."+cEnt+"Solu��o, fazer Devolu��o com a propria NF de Saida.";
	+cEnt+"Monta Carga N� "+SF2->F2_X_NRMC+"." ,"Aten��o")
	lRet	:= .F.
EndIf

RestArea(_aArea)

Return(lRet)
