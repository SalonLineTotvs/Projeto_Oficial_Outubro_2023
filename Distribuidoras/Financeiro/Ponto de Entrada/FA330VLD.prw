#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
//
/*���������������������������������������������������������������������������
���Programa  �FA330VLD   �Autor  � Andr� Salgado      � Data �  17/01/2021���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Nao Permitir Compensar NCC x NF      ���
���            entre Filiais Diferente                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Salon Line                                                 ���
���������������������������������������������������������������������������
Data 17/01/2021 - Chamado TK2101017 da Usu�ria Alessandra Financeiro 
Contas a REceber.
���������������������������������������������������������������������������*/
//==========================//
   User Function FA330VLD()
//==========================//
_Ret    :=  .T. 
_Filial :=  ""

For Z   := 1 to Len(Atitulos) 
    // Verifca o parametro de controle do cliente
    IF  MV_PAR02 == 1 
        _Filial := Atitulos[z,13] 
    Else   
        _Filial := Atitulos[z,16]
    Endif

    If  E1_Filial <> _Filial  .And. Atitulos[z,8] == .T.
        MsgBox('Prezado Usu�ri '+ cUserName + ' nao � poss�vel Compensar T�tulos de Filiais diferentes , verifique !!!', 'Informacao')
        _Ret    :=  .F.
        Return(_Ret)
    Endif


    //Chamado - TK2203360  - Autor Andr� 01/04/2022
    //Grava os Dados da Cobran�a do Titulo - Solic. Jacq / Alessandra
    IF !EMPTY(E1_PORTADO) .AND. EMPTY(E1_CODDIG)
        RecLock("SE1",.F.)
        E1_CODDIG := E1_PORTADO+E1_AGEDEP+E1_NUMBCO+E1_NUMBOR+E1_SITUACA+E1_IDCNAB
        MsUnLock()
    Endif

Next Z 

Return(_Ret)
