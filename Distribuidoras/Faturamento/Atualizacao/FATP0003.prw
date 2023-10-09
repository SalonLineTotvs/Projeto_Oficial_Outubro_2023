#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ?IMPEX_ZA1      บAutor?Genilson M Lucas     		 ?Data ?09/03/2018 บฑ?
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ?Rotina para importar faturamento.					              บฑ?
ฑฑ?        ?                                                                       บฑ?
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam    ?ExpA1 = Array contendo subarrays para rotinas de execauto              บฑ?
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?                ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑ?
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ? Programador  ? Data   ?Motivo da Alteracao                                    บฑ?
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ? CJdeCampos   ? 20/08/2018 ? Ajuste do codigo da transportadora               บฑ?
ฑฑ?              ?        ?                                                       บฑ?
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FATP0003()     

Local aUpdPV 		:= {}
Local lEnd 			:= .F.

aUpdPV := U_ImportArq() 

If Len(aUpdPV) > 0
	MsAguarde({|lEnd| CRIAPV(@lEnd,aUpdPV) },"Importacao de Pedidos de Venda","Aguarde... Processando... ",.T.)
Endif  

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ?CRIAPV      บAutor?Genilson M Lucas     		 ?Data ?09/03/2018 บฑ?
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ?Rotina para update de Material						              บฑ?
ฑฑ?        ?                                                                       บฑ?
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam    ?ExpA1 = Array contendo subarrays para rotinas de execauto              บฑ?
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?                ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑ?
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ? Programador  ? Data   ?Motivo da Alteracao                                    บฑ?
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?              ?        ?                                                       บฑ?
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function CRIAPV(lEnd,aProds)
Local aArea     := GetArea()
Local cNumPV    := ""
Local aCabec    := {}		
Local aItens    := {}
Local lRet 	    := .F.
Local cCliente_ := ''
Local cLoja_    := ''
Local cTes_     := '502'
Local cCodPag_	:= ''
Local cSeq		:= '01'
Local cCodTrp	:= ""			// alteracao CJDECAMPOS

cNumPV 	:= GetSxeNum("SC5","C5_NUM")
RollBAckSx8()
				
//cFilant := cFilPed


Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))
SB1->(DbSetOrder(1))
DA1->(DbSetOrder(1))
SF4->(DbSetOrder(1))

If xFilial("SC6")	== '0801'
	 cTes_ := Alltrim(GETMV("ES_FATP003"))//'502'
ElseIf xFilial("SC6")	== '0901'	 
	 cTes_ := '528'
EndIf

ProcRegua(Len(aProds))
For nX := 1 To Len(aProds)
	
	if nX == 1
		cCgcOrg := alltrim(substr(aProds[nX][1],23,20))
		cCgcOrg := Replace(cCgcOrg,'-','')
		cCgcOrg := Replace(cCgcOrg,'.','')
		cCgcOrg := alltrim(Replace(cCgcOrg,'/',''))
		SA1->(DbSetOrder(3))
		If SA1->(DbSeek(xFilial("SA1")+ALLTRIM(cCgcOrg)))
			cCliente_  	:= SA1->A1_COD
			cLoja_		:= SA1->A1_LOJA	
			cTabela		:= SA1->A1_TABELA
			cCodPag_	:= SA1->A1_COND
			cCodTrp		:= SA1->A1_TRANSP		// alteracao CJDECAMPOS			
			If Empty(cCodPag_)
				cCodPag_	:=  '000'			
			Endif 
			aadd(aCabec,{"C5_NUM"   	,cNumPV,Nil})		
			aadd(aCabec,{"C5_TIPO" 		,"N",Nil})		
			aadd(aCabec,{"C5_CLIENTE"	,cCliente_,Nil})		
			aadd(aCabec,{"C5_LOJACLI"	,cLoja_,Nil})		
			aadd(aCabec,{"C5_LOJAENT"	,cLoja_,Nil})		
			aadd(aCabec,{"C5_CONDPAG"	,cCodPag_ ,Nil})
			aadd(aCabec,{"C5_TRANSP"	,cCodTrp ,Nil})   // alteracao CJDECAMPOS			aadd(aCabec,{"C5_TRANSP","" ,Nil})
			aadd(aCabec,{"C5_X_STAPV"	,"5" ,Nil}) 
		Else
			MsgAlert("Cliente nao cadastrado, favor verificar o CNPJ informado.","Atencao")
			Return()
		Endif
		SA1->(DbSetOrder(1))

	Else
		//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		nPrcVen := 0
		nQtd	:= 0
		If SB1->(DbSeek(xFilial("SB1")+ALLTRIM(substr(aProds[nX][1],3,13)) ))
			DA1->(DbSeek(xFilial("DA1")+cTabela+ALLTRIM(substr(aProds[nX][1],3,13)) ))
				
				nPrcVen := DA1->DA1_PRCVEN
				If nPrcVen == 0
					nPrcVen := 0.01
				Endif
				nQtd	:= val(ALLTRIM(substr(aProds[nX][1],68,9))+","+ALLTRIM(substr(aProds[nX][1],77,6)))
				If nQtd == 0		
					nQtd := 1		
				Endif
				aLinha := {}
				
				aadd(aLinha,{"C6_ITEM",cSeq,Nil})			
				aadd(aLinha,{"C6_PRODUTO",ALLTRIM(SB1->B1_COD),Nil})
				aadd(aLinha,{"C6_UM",SB1->B1_UM,Nil})
				aadd(aLinha,{"C6_LOCAL",SB1->B1_LOCPAD,Nil})
				aadd(aLinha,{"C6_DESCRI",SB1->B1_DESC,Nil})			
				aadd(aLinha,{"C6_QTDVEN",nQtd,Nil})			
				aadd(aLinha,{"C6_PRCVEN",nPrcVen,Nil})			
				aadd(aLinha,{"C6_PRUNIT",nPrcVen,Nil})
				aadd(aLinha,{"C6_VALOR",(nPrcVen * nQtd )  ,Nil})			
				aadd(aLinha,{"C6_TES",cTes_,Nil})
					
				aadd(aItens,aLinha)
				
				cSeq	:= soma1(cSeq)				
		Endif
	EndIf
Next
If Len(aItens) > 0
	MATA410(aCabec,aItens,3)		
		
	If !lMsErroAuto
		
		lRet := .T.			
		MsgInfo("Pedido "+cNumPV+" gerado com Sucesso") 
		//ConfirmSX8()		
	Else			
		//Alert("Erro na inclusao!")
		mostraerro()
		lFim := .T.
		//RollBAckSx8()		
	EndIf
Endif
RestArea(aArea)
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑ?
ฑฑบPrograma  ณImportArq    บAutor  ณFernando Amorim     ?Data ? 19/03/12บฑ?
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑ?
ฑฑบDesc.     ?Importacao de arquivo CSV.		                          บฑ?
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑ?
ฑฑบUso       ?ImpLerArq								  				  บฑ?
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
*/
User Function ImportArq()                                                  
                              //tipo de arquivo 1 para CSV , 2 para TXT
Local nOpc			:= 0

Private cFileArq	:= ""
Private aDadosArq	:= {}


Private cCadastro	:= "Importacao de Arquivo para o Protheus"
Private aSay 		:= {}
Private aButton		:= {}     
//Private OMAINWND	

aAdd( aSay, "Esta rotina ira importar as informacoes contidas em um arquivo")
aAdd( aSay, "INFORMACOES IMPORTANTES" )

//aAdd( aSay, " 1-O nome do arquivo deve ser igual ao nome da tabela a ser importada. Ex: SE1.TXT")

//aAdd( aSay, " 2-O nome das colunas dever?ser igual ao nome dos campos PROTHEUS. Ex: E1_NUM")


AAdd( aButton, { 5, .T., { || cFileArq := cGetFile( "Arquivo TXT | *.TXT|", "Selecione o arquivo Excel",1, cFileArq, .T. ) } } )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch() } } )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	If !File(cFileArq)
		Alert( "Arquivo nao localizado!!!" )
		Return( Nil )
	Endif
	
	
	
	Processa({|| aDadosArq := ImpLerArq(cFileArq)},"Aguarde Processando a leitura do arquivo...") 
   	If Len(aDadosArq) == 0                                                                                                     
   		Alert( "Nenhum registro sera importado!" )
		Return( Nil )
	Endif
	
Endif

Return aDadosArq

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑ?
ฑฑบPrograma  ณImpLerArq บAutor  ณFernando Amorim     ?Data ? 19/03/12   บฑ?
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑ?
ฑฑบDesc.     ณLer o arquivo CSV ou Txt                                    บฑ?
ฑฑ?         ?                                                           บฑ?
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑ?
ฑฑบUso       ?Importa็ใo                                                 บฑ?
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
*/    

static Function ImpLerArq(cArquivo)

Local cLinha 		:= ""
Local cTrecho 		:= ""
Local nHdl 			:= 0
Local nX 			:= 0
Local nQtde			:= 0
Local nTotReg		:= 0
Local lLinha1 		:= .F.  			// Define se eh a fim de arquivo  
Local nY  			:= 0
Local nI   			:= 0 
Local nLinha        := 0

Private aCpoCabec 	:= {}	
Private aCpoSX3		:= {}
Private aExecAuto		:= {}    
Private aRetExecAu	:= {}
Private nTamCpoX3	:= 10 

nHdl := FT_FUSE(cArquivo)
nTotReg := FT_FLASTREC()
FT_FGOTOP()
ProcRegua(nTotReg)
nY  := 0
nI	:= 0  
nX := 0   

 
  
//	leitura do arquivo txt para montagem dos itens de importa็ใo
lLinha0 := .F.
While !FT_FEOF()  .and. !lLinha0
   	

	nI	:= 0
	cLinha := FT_FREADLN()
	cLinha := Alltrim(cLinha)
	nX++
	aDad	:= {} 
	if !Empty(alltrim(cLinha)) .AND. Substr(cLinha,1,2) $ ('10|20')
		While !Empty(alltrim(cLinha))
	  	
			
			aAdd( aDad,   cLinha  )                                             
			cLinha := ' '
		End
		aAdd( aRetExecAu, aDad )
	Else
		lLinha0 := .T.
	
	Endif                                     

	IncProc()

	FT_FSKIP()
End

	

FT_FUSE()



Return  aRetExecAu           
