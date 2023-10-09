#INCLUDE 'PROTHEUS.CH'

User Function TK271ROTM()
Local aRotina := {} //Adiciona Rotina Customizada aos botoes do Browse

//aAdd( aRotina, { 'Filtra Chamado p/Usuario','U_XXX001', 0 , 7 })

Return aRotina


//Processa Rotina do Botão
User Function XXX001()

MsgAlert( 'Foi atualizado o sistema, por favor acesso a rotina novamente !')

Return Nil


//Processa o Fiiltro da tela
User Function TK271FIL()
Local cFiltro := ''			//Variavel padrão do filtro da Tela desta Rotina
Local cCod    := RetCodUsr() 		//Codigo do Usuario para Filtras as informações
Local 	aRet  := {Space(06),Space(06),space(1),space(06),ctod("  /  /  "),ctod("  /  /  "),Space(04)}	//variaveis das Perguntas do Filtro


//MENSAGEM AO USUARIO - Sim, executa o Programa do Filtro - Nao, ignora o programa - TK271FIL
_cMens := "Deseja filtrar seus chamados? "


If MsgYesNo(_cMens,"ATENÇÃO","YESNO")

//Tela dos Parametros para Filtro
If !ParamBox( {;
	{1,"Cod.Assunto       : ",aRet[1],"@!",,"T1","",70,.F.},;
	{1,"Operador          : ",aRet[2],"@!",,"SU7","",70,.F.},;
	{2,"Status            : ",aRet[3],{" ","Pendente","Encerrada"},50,,.F.},;
	{1,"Cod.Ação          : ",aRet[4],"@!",,"SUQ","",70,.F.},;
	{1,"Dt Ocorrencia De  : ",aRet[5],"@!",,,"",70,.F.},;
	{1,"Dt Ocorrencia Ate : ",aRet[6],"@!",,,"",70,.F.},;
	{1,"Filial            : ",aRet[7],"@!",,"SM0","",70,.F.}; 
    },"Parametro para Filtro da Informação ", @aRet,,,,,,,,.T.,.T. )

// inclui o parametro 7 - rogerio silva

//	{1,"Data Ação   :",aRet[4],"@!",,,"",70,.F.},;
//	{1,"Ocorrencia  :",aRet[6],"@!",,"SU9","",70,.F.},;
//	{1,"Transport.  :",aRet[7],"@!",,"SA4","",70,.F.};
//	},"Parametro para Filtro da Informação ", @aRet,,,,,,,,.T.,.T. )

	Return
End If


//Grava as Perguntas nas variaveis
cASSUNTO := aRet[1] //Cod do Assunto
cOPERADOR:= aRet[2] //Cod do Operado
cSTATUS  := aRet[3] //Status
cDsACAO  := aRet[4] //Desc.Acao
cDtOcorr1:= dtos(aRet[5]) //DtAção
cDtOcorr2:= dtos(aRet[6]) //DtAção
cFil := aRet[7]
cOcorre  := ""//aRet[6] //Desc.Acao
cTransp  := ""//aRet[7] //Desc.Acao

xcAlias	 := GetNextAlias()


    //Libera o campo FILTRO para Filtrar
    cUpd := " UPDATE SUC020 SET UC_MIDIA = ' '" + CHR(13)
    cUpd += " FROM SUC020 UC " + CHR(13)
    cUpd += " WHERE UC_MIDIA = '"+cCod+"'" + CHR(13)
    TcSqlExec(cUpd)


    //Atualiza o campo do Filtro do usuario
    cUpd := " UPDATE SUC020 SET UC_MIDIA = '"+cCod+"', UC_X_REPR= ITEM" + CHR(13)
    cUpd += " FROM SUC020 UC " + CHR(13)
    cUpd += " INNER JOIN SUD020 UD ON UC_FILIAL=UD_FILIAL AND UC_CODIGO=UD_CODIGO " + CHR(13)
    cUpd += "                       AND UD.D_E_L_E_T_=' ' " + CHR(13)
    cUpd += " INNER JOIN (SELECT UD_FILIAL FIL , UD_CODIGO COD, MAX(UD_ITEM) ITEM  FROM SUD020 D (NOLOCK)" + CHR(13)
    cUpd += "              WHERE D.D_E_L_E_T_=' '  GROUP BY UD_FILIAL, UD_CODIGO)MAX_LINHA " + CHR(13)
    cUpd += "               ON UD_FILIAL=FIL AND UD_CODIGO=COD AND UD_ITEM=ITEM" + CHR(13)

    cUpd += " WHERE UC.D_E_L_E_T_=' '" + CHR(13) 
    cUpd += " AND UC_CODCANC=' ' " + CHR(13)  //atendimento cancelado

    //Data da Ação 
    If !Empty(cDtOcorr1)
        // cUpd += " AND UC_DATA BETWEEN '"+cDtOcorr1+"'  AND '"+cDtOcorr2+"' " + CHR(13)
        cUpd += " AND UD_DTEXEC BETWEEN '"+cDtOcorr1+"'  AND '"+cDtOcorr2+"' " + CHR(13)
    Endif

    //Assunto
    If !Empty(cASSUNTO)
        cUpd += " AND UD_ASSUNTO= '"+cASSUNTO+"'" + CHR(13)
    Endif

    //Operador
    If !Empty(cOPERADOR)
        cUpd += " AND UC_OPERADO= '"+cOPERADOR+"'" + CHR(13)
    Endif

    //Status do Filtro
    If left(cSTATUS,1)="P"
        cUpd += " AND UC_STATUS IN ('1','2')" + CHR(13)
    ELSEIf left(cSTATUS,1)="E"
        cUpd += " AND UC_STATUS IN ('3')" + CHR(13)
//        cUpd += " AND UC_STATUS= '1'"
    Endif

    //Codigo da Ação 
    If !Empty(cDsACAO)
        cUpd += " AND UD_XSOLUCA= '"+cDsACAO+"'" + CHR(13)
    Endif

    //Filial - ROGERIO
    If !Empty(cFil)
        cUpd += " AND UC_FILIAL = '"+ALLTRIM(cfIL)+"' " + CHR(13)
    Endif


    //Data da ação 
    //If !Empty(cDtACAO)
    //    cUpd += " AND UD_DATA= '"+cDtACAO+"'" + CHR(13)
    //Endif

    //OCORRENCIA
    If !Empty(cOcorre)
        cUpd += " AND UD_OCORREN= '"+cOcorre+"'" + CHR(13) + CHR(13)
    Endif

    //OCORRENCIA
    If !Empty(cTransp)
        cUpd += " AND UD_X_TRANS= '"+cTransp+"'" + CHR(13)
    Endif
    TcSqlExec(cUpd)

//    memoWrite("C:\aa\sltmk.TXT" , cUpd)


    //ATUALIZA OS CAMPOS DO CABEÇALHO NO BRONWSER
    cUpd := " UPDATE SUC020 SET" + CHR(13)
    cUpd += "       UC_X_DOCOR = LEFT(U9_DESC,15)," + CHR(13)
    cUpd += "       UC_X_DTA   = UD_DATA," + CHR(13)
    cUpd += "       UC_X_ACAO  = LEFT(UQ_DESC,15)," + CHR(13)
    cUpd += "       UC_X_ASS   = LEFT(X5_DESCRI,15)" + CHR(13)
    cUpd += " FROM SUC020 UC" + CHR(13)
    cUpd += " INNER JOIN SUD020 UD ON UC_FILIAL=UD_FILIAL AND UC_CODIGO=UD_CODIGO AND LEFT(UC_X_REPR,2)=UD_ITEM AND UD.D_E_L_E_T_=' '" + CHR(13)
    cUpd += " INNER JOIN SU9020 U9  ON UD_OCORREN=U9_CODIGO AND U9.D_E_L_E_T_=' ' " + CHR(13)
    cUpd += " INNER JOIN SUQ120 UQ  ON UD_XSOLUCA=UQ_SOLUCAO AND UQ.D_E_L_E_T_=' ' " + CHR(13)
    cUpd += " INNER JOIN SX5020 X5  ON UC_FILIAL=X5_FILIAL AND UD_ASSUNTO=X5_CHAVE AND X5_TABELA='T1' AND X5.D_E_L_E_T_=' ' " + CHR(13)
    cUpd += " WHERE " + CHR(13)
    cUpd += "   UD.D_E_L_E_T_=' ' " + CHR(13)
    cUpd += "   AND UC_X_REPR<>' '" + CHR(13)
    cUpd += "   AND UC_MIDIA = '"+cCod+"'" + CHR(13)
    TcSqlExec(cUpd)
//    memoWrite("C:\aa\sltmk2.TXT" , cUpd)


    //Libera o campo FILTRO para Filtrar
    cUpdX := " SELECT COUNT(*) QTD " + CHR(13)
    cUpdX += " FROM SUC020 UC (NOLOCK) " + CHR(13)
    cUpdX += " WHERE D_E_L_E_T_=' ' AND UC_MIDIA = '"+cCod+"'" + CHR(13)
    TcSqlExec(cUpdX)

    DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cUpdX),xcAlias,.F.,.T.)

    cTotrEG := (xcAlias)->QTD

    Aviso("Atenção", "Total de Registros - "+transform(cTotrEG,"@E 999999"), {"Ok"})
    
     (xcAlias)->(DbCloseArea())


    //Chamada do Filtro com a variavel da Rotina Padrão "cFiltro" , não pode mudar a informação.
    cFiltro := "SUC->UC_MIDIA == '"+ cCod + "'" + CHR(13)

Endif

Return (cFiltro)
