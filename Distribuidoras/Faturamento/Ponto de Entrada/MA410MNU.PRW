#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410MNU  �Autor  �Andre Salgado       � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada INCLUIR BOT�O (Outras A��es) no            ���
���          � PEDIDO DE VENDA (Pre-Nota)                                 ���
�������������������������������������������������������������������������͹��
���Uso       � SALON LINE -  SOLICITA��O - GENILSON LUCAS                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410MNU()

Local cCodUser := RetCodUsr()

IF SM0->M0_CODIGO="02"	//S� Processar para Empresa DISTRIBUIDORA
	
	AADD( aRotina,{"Atualizar Informa��es"	,"U_FATP0012()",0,4,20,NIL})
	aadd( aRotina,{"Pre-Nota"				,"MATR730",0,7,0, nil} )
		
	If cCodUser	$ GETMV("ES_MA410MN")
		aadd(aRotina,{'Atualizar TES'  		,'U_FATP0004()',,,,NIL})
		aadd(aRotina,{'Atu. TES Ori 2' 		,'U_FATP0008()',,,,NIL})
		aadd(aRotina,{'Atu. TES Isento FECP','U_FATP0009()',,,,NIL})
		aadd(aRotina,{'Atu. TES por Produto','U_FATP0017()',,,,NIL})		// Chamado Valdir (TK1909035)
	Endif

	If cCodUser	$ GETMV("ES_FATP016")
		aadd(aRotina,{'Cancelar Pedido'		,'U_FATP0016()',,,,NIL})
	Endif

	If cCodUser	$ GETMV("ES_WBLOG98") //adicionado LH salonline
		aadd(aRotina,{'Reenviar PV Logistica'		,'U_WB_LOG098()',,,,NIL})
	Endif
	
	If cCodUser	== '000000'
		aadd(aRotina,{'Voltar Status'		,'U_FATP0015()',,,,NIL})
	EndIf
Endif


Return()

