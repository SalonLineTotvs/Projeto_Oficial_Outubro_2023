#include "protheus.ch"
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATP0016  ºAutor  ³ Bruno             º Data ³  14/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para cancelar o pedido e Eliminar Resíduo           º±±
±±º          ³ 							                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SALON LINE -  SOLICITAÇÃO - GENILSON LUCAS                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function FATP0016() 

Local aAreaSC5  := SC5->(GetArea())   
Local cPedido   := C5_NUM

If ALLTRIM(SC5->C5_NOTA) == ""
	If MsgYesNo("Deseja confirmar o Cancelamento do Pedido "+cPedido+" ?","Atenção")   
	
	    SC6->( dbGoTop() ) 
	    SC6->( dbSeek( xFilial("SC6") + cPedido ) ) 
	
	    While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cPedido
	        //Estorna Liberação dos itens
	        MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil) 
	                        
	        //Eliminar Resíduo.                    
	        MaResDoFat() 
	        
	        SC6->( dbSkip() ) 
	    Enddo 
	
	    RecLock("SC5")
	    SC5->C5_X_STAPV :=  "C"
	    MsUnLock()
	
	    MsgInfo("O Pedido "+cPedido+" foi Cancelado com sucesso.","Aviso")
	
	EndIf
Else
	MsgAlert("Pedido de Venda já está faturado, favor verificar!","Cancelamento não Autorizado")
EndIf

RestArea(aAreaSC5)

Return 