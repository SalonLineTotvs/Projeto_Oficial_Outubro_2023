#INCLUDE "PROTHEUS.CH"                                                                                 
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AfterLogin � Autor � Genilson Lucas		 � Data � 14/11/17���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Executa ap�s usu�rio efetuar login no sistema.			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para SALONLINE                                   ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function AfterLogin()  

Local cAmbiente := GetEnvServer() //ambiente logado
Local cEmpresa	:= SM0->M0_CODIGO
Local _cUapcred := SuperGetMV( "SL_APRVCRD", Nil, "000710|000592|000807|000841|" )	//usuario que lib pv bloq. por credito
Local _cUser    := RetCodUsr()
Local _cQuery   := ""
Local _cTMP     := GetNextAlias()

If cEmpresa == '01'
	If !(upper(cAmbiente) $ ('DEVINTEX/SALONLINE/01_COMPILA/01_HOMOLOGA/DEVINTEX_HMG'))
		Final("Prezado(a), o ambiente logado n�o corresponde a empresa, favor verificar!")
	EndIf
EndIf

If _cUser $ _cUapcred
	_cQuery := " SELECT C5_NUM FROM SC5020 WHERE C5_XLBCRED = 'T' AND D_E_L_E_T_ =''  " + CRLF
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, _cQuery ), _cTMP , .F., .T. )
	DbSelectArea( _cTMP )
    (_cTMP)->( DbGoTop() )
    If(_cTMP)->( ! EOF() )
        MsgInfo("H� pedidos com bloqueio de cr�dito que necessitam de avalia��o...", "Aten��o...")
    EndIf
	(_cTMP)->( DbCloseArea() )
EndIf

return()
