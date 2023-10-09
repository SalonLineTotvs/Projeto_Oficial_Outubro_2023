#INCLUDE "TOTVS.ch"


/*/{Protheus.doc} User Function grpcli()
    Localiza na tabela de Grupos de Clientes qual grupo ele pertence
    @type  Function User
    @author Samuel de Vincenzo
    @since xx/10/2022
    @version 1.0
/*/
User Function grpcli()
	Local cCodigo := ""
	Local cCnpj   := TRANSFORM( substr(M->A1_CGC,1,8), "@R 99.999.999" )
	Local cNome	  := ""
	Local aPergs  := {}
	Local cGrupo  := Space(TamSX3('ZD0_RAIZCN')[01])

	Aadd(aPergs, {1, "Grupo",  cGrupo,  "", ".T.", "ZD0", ".T.", 80,  .F.})

	DbSelectArea("ZD0")
	DbSetOrder(6)

	if (ZD0->( DbSeek(xFilial("ZD0")+cCnpj+TRANSFORM(M->A1_CGC, "@R 99999999999999") ) ) )
		cCodigo := ZD0->ZD0_RAIZCN
		M->A1_CNPJBAS   := ZD0->ZD0_RAIZCN
		M->A1_XNOMCON   := ZD0->ZD0_NOMGRP

	else

		// Verifico se o grupo de clientes existe
		// O grupo não existe incluo um novo ou incluo em um já existente
		DbSelectArea("ZD0")
	    DbSetOrder(2)
        
        if ! (ZD0->( DbSeek(xFilial("ZD0")+cCnpj) ) )

			if MsgYesNo("Grupo com a Raiz do CNPJ não encontrado!"+ Chr(13) + Chr(10) +" se deseja criar um novo, clique em SIM,"+ Chr(13) + Chr(10) +"mas se deseja amarrar a um grupo existente clique em NAO ", "Grupo de Clientes")
				RecLock("ZD0", .T.)
				ZD0_RAIZCN := cCnpj
				ZD0_NOMGRP := M->A1_NOME
				ZD0_CNPJ   := AllTrim(M->A1_CGC)
				ZD0_NOMECL := AllTrim(M->A1_NOME)

				ZD0->(MsUnlock())
				cCodigo := cCnpj
				M->A1_CNPJBAS   := cCnpj
				M->A1_XNOMCON   := M->A1_NOME
			else
				If ParamBox(aPergs, "Informe os parâmetros")

					DbSelectArea("ZD0")
	    			DbSetOrder(2)

					if ZD0->(DbSeek( xFilial("ZD0")+MV_PAR01 ))

						RecLock("ZD0", .T.)
						ZD0_RAIZCN := MV_PAR01
						ZD0_NOMGRP := ZD0->ZD0_NOMGRP
						ZD0_CNPJ   := AllTrim(M->A1_CGC)
						ZD0_NOMECL := AllTrim(M->A1_NOME)

						ZD0->(MsUnlock())
						cCodigo := MV_PAR01
						M->A1_CNPJBAS  := MV_PAR01
						M->A1_XNOMCON   := ZD0->ZD0_NOMGRP
					endif
				EndIf
			endif
		else
			// o grupo existe, então verifico se existe o cnpj já cadastrado
				cNome := ZD0->ZD0_NOMGRP

				RecLock("ZD0", .T.)
				ZD0_RAIZCN := cCnpj
				ZD0_NOMGRP := cNome
				ZD0_CNPJ   := AllTrim(M->A1_CGC)
				ZD0_NOMECL := AllTrim(M->A1_NOME)

				ZD0->(MsUnlock())

				cCodigo := ZD0->ZD0_RAIZCN
				M->A1_CNPJBAS  := ZD0->ZD0_RAIZCN
				M->A1_XNOMCON   := ZD0->ZD0_NOMGRP
		endif
	endif
Return cCodigo

