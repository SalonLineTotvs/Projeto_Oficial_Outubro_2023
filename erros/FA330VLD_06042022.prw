#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
//
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณFA330VLD   บAutor  ณ Eduardo Lourenco   บ Data ณ  17/01/2021บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para Nao Permitir Compensar NCC x NF      บฑฑ
ฑฑบ            entre Filiais Diferente                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Salon Line                                                 บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Data 17/01/2021 - Chamado TK2101017 da Usuแria Alessandra Financeiro 
Contas a REceber.
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
        MsgBox('Prezado Usuแri '+ cUserName + ' nao ้ possํvel Compensar Tํtulos de Filiais diferentes , verifique !!!', 'Informacao')
        _Ret    :=  .F.
        Return(_Ret)
        //
    Endif
    //
Next Z 
//
Return(_Ret)
