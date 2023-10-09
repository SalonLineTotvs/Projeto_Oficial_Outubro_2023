#include "protheus.ch"
#include "Totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FATP0016  �Autor  � Bruno             � Data �  14/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para cancelar o pedido e Eliminar Res�duo           ���
���          � 							                                  ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - GENILSON LUCAS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function FATP0016() 

Local aAreaSC5  := SC5->(GetArea())   
Local cPedido   := C5_NUM

If ALLTRIM(SC5->C5_NOTA) == ""
	If MsgYesNo("Deseja confirmar o Cancelamento do Pedido "+cPedido+" ?","Aten��o")   
	
	    SC6->( dbGoTop() ) 
	    SC6->( dbSeek( xFilial("SC6") + cPedido ) ) 
	
	    While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cPedido
	        //Estorna Libera��o dos itens
	        MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil) 
	                        
	        //Eliminar Res�duo.                    
	        MaResDoFat() 
	        
	        SC6->( dbSkip() ) 
	    Enddo 
	
	    RecLock("SC5")
	    SC5->C5_X_STAPV :=  "C"
	    MsUnLock()
	
	    MsgInfo("O Pedido "+cPedido+" foi Cancelado com sucesso.","Aviso")
	
	EndIf
Else
	MsgAlert("Pedido de Venda j� est� faturado, favor verificar!","Cancelamento n�o Autorizado")
EndIf

RestArea(aAreaSC5)

Return 