#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
���Funcao    � FING0003  �Autor  � Carolina A. /Introde �Data� 11/06/20198  ���
�������������������������������������������������������������������������͹��
���Observacao�Envia o valor Liquido no arquivo CNAB                       ���
���          �Solicita��o Jacqueline/Financeiro                           ���
���          �                                                            ���
Link de apoio:
http://tdn.totvs.com/display/public/PROT/FIN0014_CNAB_Dica_de_CNAB-Tratamento_de_AB-na_remessa
http://tdn.totvs.com/pages/releaseview.action?pageId=6070773
�����������������������������������������������������������������������������
*/
User Function FING0003()
Local nValCNABx := 0

nValCNABx := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)

Return(nValCNABx)
