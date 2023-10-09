#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
//
/*���������������������������������������������������������������������������
���Programa  �FA330VLD   �Autor  � Eduardo Lourenco   � Data �  17/01/2021���
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
//Alert("Entrou no Ponto")
//
For Z   := 1 to Len(Atitulos) 
    // Verifca o parametro de controle do cliente
    IF  MV_PAR02 == 1 
        //
        _Filial := Atitulos[z,13] 
        //
    Else   
        //
        _Filial := Atitulos[z,16]
    Endif
    //     
    If  E1_Filial <> _Filial  .And. Atitulos[z,8] == .T.
        //
        MsgBox('Prezado Usu�ri '+ cUserName + ' nao � poss�vel Compensar T�tulos de Filiais diferentes , verifique !!!', 'Informacao')
        _Ret    :=  .F.
        Return(_Ret)
        //
    Endif
    //
Next Z 
//
Return(_Ret)
