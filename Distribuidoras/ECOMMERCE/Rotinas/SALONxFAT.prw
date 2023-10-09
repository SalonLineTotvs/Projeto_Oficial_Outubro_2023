#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xGatPrdPrc  º Autor ³ Genesis/Gustavo   Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilho para rastro dos precos...                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/         
*----------------------*
User Function xGatPrdPrc
*----------------------*
Local aArea      := GetArea() 
Local aArDA1     := DA1->(GetArea()) 
Local aArDA0     := DA0->(GetArea())           

Private _cAlsCb := iIF(FunName()=='MATA410','C5','CJ')
Private _cAlsIt := iIF(FunName()=='MATA410','C6','CK')
					
Private _nPPrcDj := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_XPRCDJ' })
Private _nPPrcMi := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_XPRCMI' })

Private _nPTabDj := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_XTABDJ' })
Private _nPTabMi := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_XTABMI' })
                                                             
Private _nPProd  := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_PRODUTO'})
Private _nPQuant := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_QTDVEN' })
Private _nPVenda := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_PRCVEN' })
Private _nPPrUnit:= aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_PRUNIT' })
Private _nPValor := aScan(aHeader,{|X| Upper(Alltrim(x[2]))== _cAlsIt+'_VALOR' })

//Valida Utilizacao da Customizacao
IF !U_EmpUseRot(iIF(_cAlsCb=='C5','01','09'))
	Return
EndIF

IF 	_nPPrcDj > 0
	IF _cAlsCb=='C5'
		aCols[n][_nPPrcDj]:= CriaVar(_cAlsIt+'_XPRCDJ')
	Else
		&((oGetDad:CTRB)+'->'+_cAlsIt+'_XPRCDJ') := CriaVar(_cAlsIt+'_XPRCDJ')
	EndIF
EndIF
IF _nPPrcMi > 0
	IF _cAlsCb=='C5'
		aCols[n][_nPPrcMi] := CriaVar(_cAlsIt+'_XPRCMI')
	ELSE
		&((oGetDad:CTRB)+'->'+_cAlsIt+'_XPRCMI') := CriaVar(_cAlsIt+'_XPRCMI')
	EndIF
EndIF
			
IF !Empty( &('M->'+_cAlsCb+'_TABELA') )
	IF ReadVar()=='M->'+_cAlsIt+'_PRODUTO'
		IF _cAlsCb=='C5'
			aCols[n][_nPProd]  := &('M->'+_cAlsIt+'_PRODUTO')
		Else 
			&((oGetDad:CTRB)+'->'+_cAlsIt+'_PRODUTO') := &('M->'+_cAlsIt+'_PRODUTO')
		EndIF
	EndIF 

	DbSelectArea('DA0');DA0->(DbSetORder(1))
	DbSelectArea('DA1');DA1->(DbSetORder(1));DA1->(DbGoTop())
	IF DA0->(DbSeek(xFilial('DA0')+&('M->'+_cAlsCb+'_TABELA')))
		IF ( (Empty(DA0->DA0_DATDE) .Or. DA0->DA0_DATDE  <= dDataBase) .And. (Empty(DA0->DA0_DATATE) .Or. DA0->DA0_DATATE >= dDataBase) .And. DA0->DA0_ATIVO=='1')		
			IF DA1->(DbSeek(xFilial('DA1')+&('M->'+_cAlsCb+'_TABELA')+ iIF(_cAlsCb=='C5', aCols[n][_nPProd], &((oGetDad:CTRB)+'->'+_cAlsIt+'_PRODUTO')) ))
				IF 	_nPPrcDj > 0                            //Soma valor dos impostos (media de calculo PIC)
					_nNewVal := xPcValTab('DA1_XPRCDJ')
					IF _cAlsCb=='C5'
						aCols[n][_nPPrcDj]							:= (_nNewVal / u_xAlqUf(iIF(_cAlsCb=='C5', aCols[n][_nPProd], &((oGetDad:CTRB)+'->'+_cAlsIt+'_PRODUTO')),SA1->A1_EST))
					Else
						&((oGetDad:CTRB)+'->'+_cAlsIt+'_XPRCDJ') 	:= (_nNewVal / u_xAlqUf(iIF(_cAlsCb=='C5', aCols[n][_nPProd], &((oGetDad:CTRB)+'->'+_cAlsIt+'_PRODUTO')),SA1->A1_EST))
					EndIF
					
					IF _cAlsCb=='C5'
						aCols[n][_nPTabDj] := _nNewVal
					else
						&((oGetDad:CTRB)+'->'+_cAlsIt+'_XTABDJ') := _nNewVal
					EndIF
				EndIF
				IF _nPPrcMi > 0								//Soma valor dos impostos (media de calculo PIC)
					_nNewVal := xPcValTab('DA1_XPRCMI')
					IF _cAlsCb=='C5'
						aCols[n][_nPPrcMi] 							:= (_nNewVal / u_xAlqUf(iIF(_cAlsCb=='C5', aCols[n][_nPProd], &((oGetDad:CTRB)+'->'+_cAlsIt+'_PRODUTO')),SA1->A1_EST))	
					Else 
						&((oGetDad:CTRB)+'->'+_cAlsIt+'_XPRCMI') 	:= (_nNewVal / u_xAlqUf(iIF(_cAlsCb=='C5', aCols[n][_nPProd], &((oGetDad:CTRB)+'->'+_cAlsIt+'_PRODUTO')),SA1->A1_EST))	
					EndIF
					
					IF _cAlsCb=='C5'
						aCols[n][_nPTabMi]							:= _nNewVal
					Else
						&((oGetDad:CTRB)+'->'+_cAlsIt+'_XTABMI') 	:= _nNewVal
					EndIF
				EndIF
				IF _cAlsCb=='C5'
					aCols[n][_nPVenda]							:= iIF(_cAlsCb=='C5', aCols[n][_nPPrcMi], &((oGetDad:CTRB)+'->'+_cAlsIt+'_XPRCMI'))
				else 
					&((oGetDad:CTRB)+'->'+_cAlsIt+'_PRCVEN')  	:= iIF(_cAlsCb=='C5', aCols[n][_nPPrcMi], &((oGetDad:CTRB)+'->'+_cAlsIt+'_XPRCMI'))
				EndIF
				
		   		IF _cAlsCb=='C5'
		   			aCols[n][_nPPrUnit] 						:= CriaVar(_cAlsIt+'_PRUNIT')
		   		Else 
		   			&((oGetDad:CTRB)+'->'+_cAlsIt+'_PRUNIT') 	:= CriaVar(_cAlsIt+'_PRUNIT')
		   		EndIF
				
				IF _cAlsCb=='C5'
					_nValNet := A410Arred((aCols[n][_nPQuant]*aCols[n][_nPVenda]),(_cAlsIt+'_PRCVEN'))
				Else
					_nValNet := A410Arred((&((oGetDad:CTRB)+'->'+_cAlsIt+'_QTDVEN')*&((oGetDad:CTRB)+'->'+_cAlsIt+'_PRCVEN')),(_cAlsIt+'_PRCVEN'))
				EndIF
				
				IF _nValNet > 0
					If ExistTrigger(_cAlsIt+'_PRCVEN ') .And. _cAlsCb == 'C5'
						&('M->'+_cAlsIt+'_PRCVEN') := aCols[n][_nPVenda]
						RunTrigger(2,n,nil,,_cAlsIt+'_PRCVEN ')
					Endif
					
					IF _cAlsCb=='C5'
						aCols[n][_nPValor] := _nValNet	
					Else 
						&((oGetDad:CTRB)+'->'+_cAlsIt+'_VALOR') := _nValNet
					EndIF
					
					IF _cAlsCb=='C5'
						Ma410Rodap(Nil,aCols[n][_nPValor],0)
					Else
						oGetDad:ForceRefresh()
					EndIF
					GetDRefresh()
				EndIF			
			ENDIF
		Else
			MsgStop("Tabela de Preço Bloqueada ou fora de Vigência","Atenção")
		EndIF
	EndIF
EndIF
DA0->(DbCloseArea())
DA1->(DbCloseArea())
RestArea(aArea)
RestArea(aArDA0)
RestArea(aArDA1)
Return
/*
Local nPProduto		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPNumLote     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
Local nPLoteCtl     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
Local nPQtdVen		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})				
Local nPDescon		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local lPrcDec       := SuperGetMV("MV_PRCDEC",,.F.)  

nPrcTab := A410Tabela(aCols[n][nPProduto],M->C5_TABELA,n,aCols[n][nPQtdVen],M->C5_CLIENTE,M->C5_LOJACLI,If(nPLoteCtl>0,aCols[n][nPLoteCtl],""),If(nPNumLote>0,aCols[n][nPNumLote],""),NIL,NIL,.T.)							
aCols[n][nCntFor] := A410Arred(FtDescCab(nPrcTab,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})*(1-(aCols[n][nPDescon]/100)),"C6_PRCVEN",If(cPaisLoc=="CHI" .And. lPrcDec,M->C5_MOEDA,NIL))

*/
*--------------------------------*
Static Function xPcValTab(_cCampo)
*--------------------------------*
Local _nValorTb := 0

_nPrcVen   :=  &('DA1->'+_cCampo)
_nMoedaTab := DA1->DA1_MOEDA
_nFator    := DA1->DA1_PERDES
_nValorTb := xMoeda(_nPrcVen,_nMoedaTab, &('M->'+_cAlsCb+'_MOEDA'),,TamSx3("D2_PRCVEN")[2])

Return(_nValorTb)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ValUnitNet  º Autor ³ Genesis/Gustavo   Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula Preço Unitário Sem Impostos...                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PIC/Pharmaspecial                                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/         
*-----------------------*
User Function ValUnitNet
*-----------------------*
Local aArea     := GetArea()
Local _lRet     := .F.

Local _nPProdut := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_PRODUTO'})
Local _nPTes    := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_TES'})    

Local _nPQtdVen := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_QTDVEN'})
Local _nPPrcBrt := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_XPRCBRT'})
Local _nPPrcVnd := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_PRCVEN'}) 
Local _nPValor  := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_VALOR'})

Local _nPPrcDj  := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_XPRCDJ'})
Local _nPPrcMi  := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_XPRCMI'})	                        

Local _nPTabDj  := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_XTABDJ'})
Local _nPTabMi  := aScan(aHeader,{|X| Upper(Alltrim(x[2]))=='C6_XTABMI'})	                        

Local _nQtdIT    := 1
Local _nValNet   := 0
Local _cCampoBrt := iIF('C6_XPRCBRT'$ReadVar(),ReadVar(),'aCols[n][_nPPrcBrt]')
Local _nCampoBrt := iIF('C6_XPRCBRT'$ReadVar(),M->C6_XPRCBRT,aCols[n][_nPPrcBrt])

//Valida Utilizacao da Customizacao
IF !U_EmpUseRot('01')
	Return
EndIF

//Nao calcula item deletado
IF aCols[n][Len(aHeader)+1]
	Return(.F.) 
EndIF

//Conferencia de VAlor utilizado
IF _nCampoBrt <= 0 //&(_cCampoBrt) <= 0
	MsgStop("Informe um preço bruto de venda válido!","Atenção")
	Return(.F.)	
EndIF

//Validacao do TES
DbSelectArea('SF4')
IF !ExistCpo('SF4',aCols[n][_nPTes]) .Or. Vazio(aCols[n][_nPTes]) 
	MsgStop("Informe um código de TES válido!","Atenção")
	Return(.F.)
EndIF

//            Preco Tabela      , Prc Tab+Impostos, Preco de Venda
_aCalcVlr := {aCols[n][_nPTabDj], 0               , _nCampoBrt}

MaFisIni(	Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT),;	// 1-Codigo Cliente/Fornecedor
			SC5->C5_LOJAENT,;											// 2-Loja do Cliente/Fornecedor
			"C",;														// 3-C:Cliente , F:Fornecedor
			"N",;			   											// 4-Tipo da NF
			SA1->A1_TIPO,;	   											// 5-Tipo do Cliente/Fornecedor
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461")
			
//Agrega os itens para a funcao fiscal
MaFisAdd(	aCols[n][_nPProdut],; 	// 1-Codigo do Produto ( Obrigatorio )
			aCols[n][_nPTes],;	 	// 2-Codigo do TES ( Opcional )
			_nQtdIT,; 		 		// 3-Quantidade ( Obrigatorio )
			aCols[n][_nPPrcDj],;	// 4-Preco Unitario ( Obrigatorio )
			0,;    		   			// 5-Valor do Desconto ( Opcional )
			"",;	   				// 6-Numero da NF Original ( Devolucao/Benef )
			"",;					// 7-Serie da NF Original ( Devolucao/Benef )
			0,;						// 8-RecNo da NF Original no arq SD1/SD2
			0,;						// 9-Valor do Frete do Item ( Opcional )
			0,;						// 10-Valor da Despesa do item ( Opcional )
			0,;						// 11-Valor do Seguro do item ( Opcional )
			0,;						// 12-Valor do Frete Autonomo ( Opcional )
			aCols[n][_nPPrcDj],;	// 13-Valor da Mercadoria ( Obrigatorio )
			0)
		
//nPrcLista := A410Arred(nValMerc/SC6->C6_QTDVEN,"C6_PRCVEN")
_nFR_ITTot := MaFisRet(1,"IT_TOTAL")
_nFR_NFTot := MaFisRet(,"NF_TOTAL")   	
_nFR_NFMer := MaFisRet(,"NF_VALMERC")
	
_aCalcVlr[2] := _nFR_ITTot 
			
//Finaliza rotinas do Fiscal
MaFisEnd()

_nValNet := A410Arred((_aCalcVlr[1]*_aCalcVlr[3]) / _aCalcVlr[2],"C6_PRCVEN")
IF _nValNet > 0
	aCols[n][_nPPrcVnd] := _nValNet
	If ExistTrigger('C6_PRCVEN ')
		M->C6_PRCVEN := aCols[n][_nPPrcVnd]
		RunTrigger(2,n,nil,,'C6_PRCVEN ')
	Endif
	aCols[n][_nPValor] := A410Arred(aCols[n][_nPQtdVen]*aCols[n][_nPPrcVnd],"C6_PRCVEN")
	//	Ma410Rodap(Nil,aCols[n][_nPValor],0)
	GetDRefresh()
	_lRet := .T.
EndIF
	
RestArea(aArea)
Return(_lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xAlqUf     º Autor ³ Genesis/Gustavo   Data ³    /  /      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ::Função para calculo da aliquota tributario média::       º±±
±±º            PIS + COFINS + IPI                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/         
*--------------------------------*
User Function xAlqUf(_cProd,_cEst)
*--------------------------------*
Local _nAliq  := 0
Local aArea   := GetArea()
Local aArB1   := SB1->(GetArea())
Local _cMvUf  := Upper(AllTrim(GetMV('MV_XESTICM',.F.,'')))
Local _nMvUf  := VAL(iIF(Alltrim(_cEst)$_cMvUf, SubStr(_cMvUf,At(_cEst,_cMvUf)+Len(_cEst),02), '0'))
Local _nVlPis := GetMV("MV_TXPIS",.F.,0)
Local _nVlCof := GetMV("MV_TXCOF",.F.,0)
//pis + cofins + icms = 7,65
//EMP      PIS    COF            ]
//PIC     1.65    7.6
//PAH     0.65    3.0

DbselectArea('SB1') 
SB1->(DbSetOrder(1)) 
IF SB1->(DbSeek(xFilial('SB1')+_cProd))
	IF (AllTrim(SB1->B1_ORIGEM) $ '1276' .And. _cEst <> "SP") .And. SB1->B1_XCAMEX == 'N'
		_nMvUf := 4
	EndIF
EndIF   

_nAliq := (((((_nMvUf + _nVlPis + _nVlCof)-100)/100)) * -1)

RestArea(aArB1)
RestArea(aArea)
Return(_nAliq)
              
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PM410VOL   º Autor ³ Genesis/Gustavo   Data ³  28/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Alteração de informacoes do pedido de venda                º±±
±±º                                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/   
*---------------------*
User Function PM410VOL
*---------------------*
Local oDlgGet
Local lOk       := .T.
Local nOpcGet   := 1

Local _oVolume1
Local _nVolume1	:= SC5->C5_VOLUME1

Local _oPesoL
Local _nPesoL	:= SC5->C5_PESOL  //CriaVar('C5_PESOL') //Space(TamSX3('C5_PESOL')[1])//SC5->C5_PESOL

Local _oPesoB
Local _nPesoB	:= SC5->C5_PBRUTO //CriaVar('C5_PBRUTO') //Space(TamSX3('C5_PBRUTO')[1])//SC5->C5_PBRUTO

Local cTransp  	:= SC5->C5_TRANSP
Local cNTransp 	:= Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
Local oNTransp

Local aComboBx	:= CTBCBOX("C5_TPFRETE")
Local cComboBx  := SC5->C5_TPFRETE

Local lConf := .F.

Local _lProc := .F.

IF !Empty(SC5->C5_NOTA)
	Return(.T.) 
ENDIF

DEFINE MSDIALOG oDlgGet FROM  100,4 TO 298,463 TITLE "Alteração do Pedido de Venda - "+SC5->C5_NUM PIXEL Style 128
oDlgGet:lEscClose := .F.

	@ 02,02 TO 97,230 PIXEL

	@ 07,10 SAY "Tipo Frete" SIZE 70,9 of oDlgGet PIXEL
	@ 16,10 ComboBox cComboBx Items aComboBx Size 072,050 PIXEL OF oDlgGet WHEN(.F.) /*IIf(cEmpAnt == "02", .T., .F.)*/
		
	@ 32,10 SAY "Transportadora" SIZE 070,009 of oDlgGet PIXEL
	@ 41,10 MSGET cTransp  SIZE 050,009 F3("SA4") OF oDlgGet PIXEL VALID(ExistCpo("SA4",cTransp), cNTransp:=Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")) HASBUTTON WHEN(.F.) /* IIf(cEmpAnt == "02", .T., .F.)*/
	@ 41,70 MSGET oNTransp VAR cNTransp SIZE 150,9 OF oDlgGet PIXEL WHEN .F.
	
	@ 57,10 SAY "Volume" SIZE 70,9 of oDlgGet PIXEL
	@ 66,10 MSGET _oVolume1 VAR _nVolume1 Picture("@E 9,999,999") SIZE 050,9 When(!lConf) OF oDlgGet PIXEL VALID(_nVolume1==0.Or._nVolume1>0) HASBUTTON
	
	@ 57,70 SAY  "Peso Liquido" SIZE 70,9 of oDlgGet PIXEL
	@ 66,70 MSGET _oPesoL VAR _nPesoL Picture(PesqPict('SC5','C5_PESOL')) SIZE 050,9 When(.F.) OF oDlgGet PIXEL  HASBUTTON	
	
	@ 57,140 SAY "Peso Bruto"   SIZE 70,9 of oDlgGet PIXEL
	@ 66,140 MSGET _oPesoB VAR _nPesoB Picture(PesqPict('SC5','C5_PBRUTO')) SIZE 050,9 When(.F.) OF oDlgGet PIXEL  HASBUTTON			
			
	//@ 82,10 CheckBox oConf Var lConf Prompt "Liberação de Faturamento" Valid(xChkLbFat(_nVolume1,@lConf,_oVolume1,oConf,oDlgGet))  Size 080,008 PIXEL OF oDlgGet When IIf(cEmpAnt == "02", .T., .F.)

	@ 082,140 BUTTON OemToAnsi("Confirmar")  SIZE 35,12 ACTION(oDlgGet:End(),nOpcGet:=2)
	@ 082,175 BUTTON OemToAnsi("Cancelar")   SIZE 35,12 ACTION(oDlgGet:End())	
ACTIVATE MSDIALOG oDlgGet CENTERED

If nOpcGet == 2
	_lProc := .T.
	
	Begin Transaction
		//Alteracao Cabecalho do Pedido
		IF 	RecLock("SC5",.F.)
				If cEmpAnt == "02" 
					Replace SC5->C5_TPFRETE With SubStr(cComboBx,1,1)                                     
					Replace SC5->C5_TRANSP	With cTransp
					Replace SC5->C5_PESOL   With _nPesoL//Val(Transform(_nPesoL,'@e 999.999'))
					Replace SC5->C5_PBRUTO  With _nPesoB//Val(Transform(_nPesoB,'@e 999.999'))   
   				    Replace SC5->C5_VOLUME1	With _nVolume1					
				Else
					Replace SC5->C5_PESOL   With _nPesoL//Val(Transform(_nPesoL,'@e 999.999'))
					Replace SC5->C5_PBRUTO  With _nPesoB//Val(Transform(_nPesoB,'@e 999.999'))
   				    Replace SC5->C5_VOLUME1	With _nVolume1
				EndIf
			SC5->(MsUnlock())	
		EndIF
		//Liberacao de Faturamento
		IF lConf    
			_lLibNota := .T.
			DbSelectArea('SC9')
			SC9->(DbSetOrder(1))
			IF SC9->(DbSeek(xFilial('SC9')+SC5->C5_NUM))
			
				//Faz varredura para verificacao se todos os itens foram separados grava flg e conferencia de seracao
				Do While SC9->(!Eof()) .And. SC9->C9_FILIAL==xFilial('SC9') .And. SC9->C9_PEDIDO==SC5->C5_NUM
					IF SubStr(SC9->C9_XLIBOK,1,1)=='X'
						IF 	RecLock("SC9",.F.)
								Replace SC9->C9_XLIBOK With SubStr(SC9->C9_XLIBOK,1,1)+'X'
							SC9->(MsUnlock())	
						EndIF
					Else 
						_lLibNota := .F.	
					EndIF
					SC9->(DbSkip())
				EndDo 
				     
				//Libera Flag para faturamento
				IF _lLibNota                    
					DbSelectArea('SC9');SC9->(DbGoTop())
					IF SC9->(DbSeek(xFilial('SC9')+SC5->C5_NUM))
						Do While SC9->(!Eof()) .And. SC9->C9_FILIAL==xFilial('SC9') .And. SC9->C9_PEDIDO==SC5->C5_NUM
								IF 	RecLock("SC9",.F.)
										//Replace SC9->C9_XLIBTOT With 'S'
									SC9->(MsUnlock())	
								EndIF
							SC9->(DbSkip())
						EndDo
					EndIF					
				EndIF
				
			EndIF
			SC9->(DbCloseArea())
		EndIF
	End Transaction
EndIf

Return(_lProc)  

*-------------------------------------------------*
Static Function  xChkLbFat(_nVolume1,lConf,_oVolume1,oDlgGet)
*-------------------------------------------------*
Local _lRet := .T.
IF _nVolume1==0
	MsgInfo('É obrigatório informar o Volume!','Atenção')
	lConf := .F.
EndIF            
_oVolume1:Refresh(); oDlgGet:Refresh(); _oVolume1:SetFocus()
Return(_lRet)
