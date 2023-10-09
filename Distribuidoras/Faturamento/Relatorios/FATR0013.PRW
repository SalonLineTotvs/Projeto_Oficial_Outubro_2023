#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'topconn.ch'
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR0013 º Autor ³ Genilson M Lucas	 º Data ³  29/09/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para envio dos produtos com corte	 	 		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SalonLine										          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR0013()

Local cAssunto 		:= "Relação de Corte de Produto - "
//Local cEmail	    := GetMV("ES_FATR013")
Local cEmail	    := ""                                                                                                  "

Local cBody		 	:= ""
Local cAnexo    	:= "" 
Local dDtCorte		:= Date()-1
Local cQuery1		:= ""
Local cQuery2		:= ""
Local cQuery3		:= ""
Local cPedido		:= ""

Local nTCortePV		:= 0
Local nTCorte		:= 0
Local nTPedido		:= 0

//VARIAVEL PARA TABELA TEMPORARIA
local oTable as object
local aFields as array
local nConnect as numeric
local lCloseConnect as logical
local cAlias as char
local cTableName as char
local cAreaQuery as char
local cQuerySQL as char

PREPARE ENVIRONMENT EMPRESA '02' FILIAL '0101' MODULO "FAT"

cEmail	+= "mario.s@salonline.com.br; coordenacao.logistica@devintex.com.br; claudia.vericio@salonline.com.br; "        
cEmail	+= "elser@bestresults.com.br; protheus.logs@salonline.com.br"

//--------------------------------------------------------------------------
//Esse bloco efetua a conexão com o DBAccess caso a mesma ainda não exista
//--------------------------------------------------------------------------
if TCIsConnected()
    nConnect := TCGetConn()
    lCloseConnect := .F.
else
    nConnect := TCLink()
    lCloseConnect := .T.
endif

//-------------------------------------------------------------------------------------------
// CRIAÇÃO DA TABELA TEMPORÁRIA
//-------------------------------------------------------------------------------------------
if nConnect >= 0
    //--------------------------------------------------------------------
    //O primeiro parâmetro de alias, possui valor default
    //O segundo parâmetro de campos, pode ser atribuido após o construtor
    //--------------------------------------------------------------------
    oTable := FWTemporaryTable():New( cAlias, aFields)

    //----------------------------------------------------
    //O array de campos segue o mesmo padrão do DBCreate:
    //1 - C - Nome do campo
    //2 - C - Tipo do campo
    //3 - N - Tamanho do campo
    //4 - N - Decimal do campo
    //----------------------------------------------------
    aFields := {}

    aAdd(aFields, {"PRODUTO", "C", 36, 0})
    aAdd(aFields, {"VALOR"  , "N", 10, 0})
  
    oTable:SetFields(aFields)

    //---------------------
    //Criação dos índices
    //---------------------
    oTable:AddIndex("01", {"PRODUTO"} )

    //---------------------------------------------------------------
    //Pronto, agora temos a tabela criado no espaço temporário do DB
    //---------------------------------------------------------------
    oTable:Create()

    //------------------------------------
    //Pego o alias da tabela temporária
    //------------------------------------
    cAlias := oTable:GetAlias()

    //--------------------------------------------------------
    //Pego o nome real da tabela temporária no banco de dados
    //--------------------------------------------------------
    cTableName := oTable:GetRealName()

EndIf


//****************************************************************
//QUERY DE CONSULTA DOS PRODUTOS CORTADOS
//****************************************************************
cQuery1	:= " SELECT CASE 	WHEN C5_FILIAL='0101' THEN 'CIMEX' WHEN C5_FILIAL='0201' THEN 'CROZE' WHEN C5_FILIAL='0301' THEN 'KOPEK' "
cQuery1	+= "		WHEN C5_FILIAL='0401' THEN 'MACO' 	       WHEN C5_FILIAL='0501' THEN 'QUBIT' WHEN C5_FILIAL='0601' THEN 'ROJA' "
cQuery1	+= "		WHEN C5_FILIAL='0701' THEN 'VIXEN' 	       WHEN C5_FILIAL='0801' THEN 'MAIZE' WHEN C5_FILIAL='0901' THEN 'DEVINTEX' " 
cQuery1	+= " 		WHEN C5_FILIAL='0902' THEN 'DEVINTEX-MG'   WHEN C5_FILIAL='1001' THEN 'GRAZY' WHEN C5_FILIAL='1101' THEN 'BIZEZ' "
cQuery1	+= " 		WHEN C5_FILIAL='1201' THEN 'ZAKATA' 	   WHEN C5_FILIAL='1301' THEN 'HEXIL' "
cQuery1	+= " 		ELSE C5_FILIAL END EMPRESA, C5_FILIAL FILIAL, "

cQuery1	+= " C5_NUM PEDIDO, C6_PRODUTO, (C6_QTDVEN - C6_QTDLIB) QTD_VEN, ( (C6_QTDVEN - C6_QTDLIB) * C6_PRCVEN)  CORTE "

cQuery1	+= " FROM SC5020 C5 WITH (NOLOCK) "
cQuery1	+= " INNER JOIN SC6020 C6 WITH (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = '' "
cQuery1	+= " INNER JOIN SB1020 B1 WITH (NOLOCK) ON B1_COD = C6_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery1	+= " WHERE C5.D_E_L_E_T_ = '' AND C6_BLQ <> ''  AND C5_NOTA NOT IN ('XXXXXXXXX')  AND "
cQuery1	+= " (C5_X_DTCCX = '"+dtos(dDtCorte)+"' OR C5_X_DTCGR = '"+dtos(dDtCorte)+"')"
//cQuery1	+= " (C5_X_DTCCX BETWEEN '20201001' AND '20201031' OR C5_X_DTCGR BETWEEN '20201001' AND '20201031' )"

cQuery1	+= " ORDER BY C5_FILIAL, C5_NUM "


DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB1",.T.,.T.)
	

	cAssunto += Transform(dDtCorte,"99/99/9999")
    
    cBody	:= '<html>'
	cBody	+= '	<head>'
	cBody	+= '		<meta content="text/html; charset=ISO-8859-1"http-equiv="content-type">'
	cBody	+= '		<title></title>
	cBody	+= '	</head>
	cBody	+= '	<body>
	cBody	+= '	<span style="font-family: Arial;">Segue relação dos produtos cortados no dia: '+Transform(dDtCorte,"99/99/9999")+'</span><br style="font-family: Arial;">
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">
	
	cBody+= '<table border="1" color="#000000" cellspacing="0" cellpadding="0" width="70%">'
		
	cBody+= '<tr>'
	cBody+= '<td width="12%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>FILIAL</B></font></td>'  
	cBody+= '<td width="12%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>PEDIDO</B></font></td>'
	cBody+= '<td width="12%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>PRODUTO</B></font></td>'
	cBody+= '<td width="9%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>QTD</B></font></td>'
	cBody+= '<td width="10%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>TOTAL CORTE</B></font></td>'
	cBody+= '<td width="20%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>TOTAL PEDIDO</B></font></td>'
	cBody+= '<td width="15%" BGCOLOR="#D8D8D8">'
	cBody+= '<font size="2" face="Verdana"><B>% CORTE</B></font></td>'
	cBody+= '</tr> ' 
			
	While TRB1->(!EOF())
		
		cPedido	:= TRB1->FILIAL+TRB1->PEDIDO
		
		While TRB1->(!EOF()) .and. cPedido	== TRB1->FILIAL+TRB1->PEDIDO
			cBody+= '<tr>'
			cBody+= '<td width="12%">'
			cBody+= '<font size="2" face="Verdana">'+TRB1->EMPRESA+'</font></td>'   
			cBody+= '<td width="12%">' 
			cBody+= '<font size="2" face="Verdana">'+TRB1->PEDIDO+'</font></td>'
			cBody+= '<td width="12%">' 
			cBody+= '<font size="2" face="Verdana">'+TRB1->C6_PRODUTO+'</font></td>'	
			cBody+= '<td width="9%">' 
			cBody+= '<font size="2" face="Verdana">'+transform(TRB1->QTD_VEN,"@E 99,999")  +'</font></td>'					
			cBody+= '<td width="20%">' 
			cBody+= '<font size="2" face="Verdana">R$ '+transform(TRB1->CORTE,"@E 999,999.99")  +'</font></td>'
			
			nTCortePV	+= TRB1->CORTE
			nTCorte	  	+= TRB1->CORTE
			
			//------------------------------
			// Consulta se Produto Existe
			//------------------------------
			(cAlias)->(DBSetOrder(1)) //N_COD+C_NAME
			
			if (cAlias)->(DBSeek(TRB1->C6_PRODUTO))
			   ConOut("Registro encontrado =)")
			else
			  	//------------------------------
			  	//Inserção de dados 
			   	//------------------------------
			   	(cAlias)->(DBAppend())
			   	(cAlias)->PRODUTO := TRB1->C6_PRODUTO
			   	(cAlias)->(DBCommit())
			    
			Endif
			

			TRB1->(dbSkip())
			
			If cPedido	== TRB1->FILIAL+TRB1->PEDIDO
				cBody+= '</tr>'
			EndIf
		Enddo
		
		//VALOR TOTAL DO PEDIDO
		cQuery2	:= " SELECT SUM(C6_QTDVEN * C6_PRCVEN) V_PEDIDO "
		cQuery2	+= " FROM SC5020 C5 WITH (NOLOCK) "
		cQuery2	+= " INNER JOIN SC6020 C6 WITH (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = '' "
		cQuery2	+= " WHERE C5.D_E_L_E_T_ = '' AND C5_FILIAL+C5_NUM = '"+cPedido+"' "
		//cQuery2	+= " GROUP BY C5_FILIAL, C5_NUM "
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"TRB2",.T.,.T.)
		
		cBody+= '<td width="20%">' 
		cBody+= '<font size="2" face="Verdana">R$ '+transform(TRB2->V_PEDIDO,"@E 999,999.99") +'</font></td>'
		cBody+= '<td width="15%">' 
		cBody+= '<font size="2" face="Verdana">'+transform( (nTCortePV/TRB2->V_PEDIDO) * 100 ,"@E 99.99")+' %</font></td>'
			
		cBody+= '</tr>'
		
		nTPedido	+= TRB2->V_PEDIDO
		nTCortePV 	:= 0
		
		TRB2->(dbCloseArea())
		
	Enddo
		
	cBody += '</table>' 
	
	//****************************************************************
	//QUERY SOMA O VALOR CONFERIDO NO DIA
	//****************************************************************
	cQuery3	+= " SELECT SUM(C6_QTDVEN * C6_PRCVEN) VAL_CONFER "
	
	cQuery3	+= " FROM SC5020 C5 WITH (NOLOCK) "
	cQuery3	+= " INNER JOIN SC6020 C6 WITH (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = '' "
	cQuery3	+= " WHERE C5.D_E_L_E_T_ = '' AND C6_BLQ = ''  AND C5_NOTA NOT IN ('XXXXXXXXX')  AND "
	cQuery3	+= " (C5_X_DTCCX = '"+dtos(dDtCorte)+"' OR C5_X_DTCGR = '"+dtos(dDtCorte)+"')"
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"TRB3",.T.,.T.)
	
	
	//****************************************************************
	// INFORMA TOTAL CORTADO
	//****************************************************************
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">'
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">'
	
	cBody	+= '	<span style="font-family: Arial;">TOTAL DE CORTE: R$  '+Transform(nTCorte,"@E 999,999.99")+'</span><br style="font-family: Arial;">'
	cBody	+= '	<span style="font-family: Arial;">TOTAL DE PEDIDOS C/ CORTE: R$ '+Transform(nTPedido,"@E 99,999,999.99")+'  ('+transform( (nTCorte/nTPedido) * 100 ,"@E 99.99")+' %)</span><br style="font-family: Arial;">'
	cBody	+= '	<span style="font-family: Arial;">TOTAL CONFERIDO NO DIA: R$ '+Transform(TRB3->VAL_CONFER,"@E 99,999,999.99")+'  ('+transform( (nTCorte/TRB3->VAL_CONFER) * 100 ,"@E 99.99")+' %)</span><br style="font-family: Arial;">'
	
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">'
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">'
	
	//---------------------------------------------------------
    // EXECUTA CONSULTA DO RESUMO DOS PRODUTOS PARA IMPRESSÃO
    //---------------------------------------------------------
    cAreaQuery := GetNextAlias()

    cQuerySQL := "SELECT PRODUTO FROM " + cTableName + " ORDER BY PRODUTO " 
    DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuerySQL), cAreaQuery, .T., .T.)
    
    cBody	+= '	<span style="font-family: Arial;">RESUMO DOS PRODUTOS CORTADOS</span><br style="font-family: Arial;">'
    while !(cAreaQuery)->(Eof())
        
        cBody	+= '	<span style="font-family: Arial;">'+(cAreaQuery)->PRODUTO+'</span><br style="font-family: Arial;">'
        
        
        (cAreaQuery)->(DBSkip())
    enddo

    //-----------------------------------------------------------
    //Sempre fecho a workarea após utilizar do retorno da query
    //-----------------------------------------------------------
    (cAreaQuery)->(DBCloseArea())


	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">'
	cBody	+= '	<span style="font-family: Arial;"></span><br style="font-family: Arial;">'
	cBody	+= '	<span style="font-family: Arial;">Rotina Automática - Programa FATR0013</span><br style="font-family: Arial;">'
	cBody += '</body>' 
	cBody += '</html>'


	U_SendMail( cEmail,,, cAssunto, cBody,cAnexo )

			
TRB1->( dbCloseArea() )
TRB3->( dbCloseArea() )

//-------------------------------------------------------------------
//Fecho e apago a tabela temporária
//-------------------------------------------------------------------
oTable:Delete()
    
    
//--------------------------------------
//Fecha a conexão criada para os testes
//--------------------------------------
if lCloseConnect
    TCUnLink()
endif

RESET ENVIRONMENT

Return()
