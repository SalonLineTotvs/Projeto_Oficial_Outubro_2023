#Include "Totvs.ch"
#Include "Protheus.ch"
#Include "ProtDef.ch"
#Include "RWMake.ch" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³SAFTRIB  ºAutor  ³Eduardo Silva	     º Data ³  02/10/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  CNAB SAFRA - Banco Safra - Pagamento de Tributos N e O.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Salonline							                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SafTrib()
Local _cRet := ""
If SEA->EA_MODELO $ "01" //Pagamento GPS
	_cRet := Substr(SE2->E2_CODRET,1,4)										//Codigo do pagamento / pos. 098-101
	_cRet += Strzero(Val(SE2->E2_XCOMPET),6)								//Competencia / pos. 102-107
	_cRet += PadL(Alltrim(SM0->M0_CGC),14,"0")								//Identificação do Contribuinte - CNPJ/CEI/CPF / 108-121
	_cRet += Strzero(SE2->E2_XVLINSS*100,15)								//Valor de pagamento do INSS / 122-136
	_cRet += Strzero(SE2->E2_XOUTENT*100,15)								//Valor Outras Entidades/ 137-151
	_cRet += Strzero((SE2->E2_JUROS + SE2->E2_MULTA)*100,15)				//Atualização monetaria /	152-166
	_cRet += Space(100)														//Valor total arrecadado / 167-266
	_cRet += Space(45)														//Brancos / 267-311
	_cRet += Space(80)														//Uso da empresa / 312-391
ElseIf SEA->EA_MODELO $ "02" //Pagamento de Darf Normal
	_cRet := "2"															//Tipo de Inscr. Contribuinte / pos. 098-098
	_cRet += PadL(Alltrim(SM0->M0_CGC),14,"0")								//Identificação do Contribuinte - CNPJ/CGC/CPF / 099-0112
	_cRet += GravaData(SE2->E2_X_APURA,.F.,8) 								//Competencia / 113-120
	_cRet += Strzero(0,17)													//Numero de referencia / 121-137
	_cRet += Substr(SE2->E2_CODRET,1,4)										//Codigo da Receita / 138-141
	_cRet += Strzero(SE2->E2_SALDO*100,15)									//Valor Principal / 142-156
	_cRet += Strzero(SE2->E2_MULTA*100,15)									//Valor da Multa / 157-171
	_cRet += Strzero((SE2->E2_JUROS)*100,15)								//Valor de Juros+Encargos / 172-186
	_cRet += GravaData(SE2->E2_VENCREA,.F.,8)								//Data de Vencimento / 187-194
	_cRet += Space(100)		                              					//Brancos / 195-294
	_cRet += Space(17)														//Uso Exclusivo Safra / 295-311
	_cRet += Space(80)														//Mensagem do retorno do Arquivo / 312-391
ElseIf SEA->EA_MODELO $ "03"//Pagamento de Darf Simples
	_cRet += Strzero(Day(SE2->E2_X_APURA),2) + Strzero(Month(SE2->E2_X_APURA),2) + Str(Year(SE2->E2_X_APURA),4)			// Apuração pos. 098-105
	_cRet += "6106"															//Codigo do pagamento / 106-109
	_cRet += Strzero(SE2->E2_SALDO*100,15)									//Valor Principal / 110-124
	_cRet += Strzero(SE2->E2_MULTA*100,15)									//Valor da Multa / 125-139
	_cRet += Strzero((SE2->E2_JUROS)*100,15)								//Valor de Juros+Encargos / 140-154
	_cRet += PadL(Alltrim(SM0->M0_CGC),14,"0")								//Identificação do Contribuinte - CNPJ/CGC/CPF / 155-168
	_cRet += Strzero(SE2->E2_XESPRB,5)										//Percentual da receita Bruta / 169-173
	_cRet += Strzero(SE2->E2_XESVRBA*100,15)								//Valor da receita bruta acumulada / 174-188
	_cRet += Space(123)														//Brancos / 189-311
	_cRet += Space(80)														//Mensagem do retorno do Arquivo / pos. 312-391
ElseIf SEA->EA_MODELO $ "04" // Pagamento de Gare DR SP
	_cRet += "2"															//Tipo de Inscr. Contribuinte / pos. 098-098
	_cRet += PadL(Alltrim(SM0->M0_CGC),14,"0")								//Identificação do Contribuinte - CNPJ/CGC/CPF / 099-0112
	_cRet += PadL(Alltrim(SM0->M0_ENDENT),40,"")							//Endereço do Contribuinte / 113-152
	_cRet += PadL(Alltrim(SM0->M0_CIDENT),30,"")							//Cidade do Contribuinte / 153-182
	_cRet += PadL(Alltrim(SM0->M0_ESTENT),2,"0")							//Estado do Contribuinte / 183-184
	_cRet += PadL(Alltrim(SM0->M0_CNAE),10,"0")								//Codigo Nacional de Arrecadação Estadual do Contribuinte / 185-194
	_cRet += Space(30)														//Descricao do Tributo / 195-224
	_cRet += Space(07)														//Placa do Veiculo / 225-231
	_cRet += Substr(SE2->E2_CODRET,1,4)										//Codigo da Receita GARE / 232-235
	_cRet += Strzero(Day(SE2->E2_VENCREA),2) + Strzero(Month(SE2->E2_VENCREA),2) + Str(Year(SE2->E2_VENCREA),4)//Data de Vencimento da GARE / 236-243
	_cRet += PadL(Alltrim(SM0->M0_INSC),12,"0")								//Codigo da Inscricao Estadual ou Codigo do Municipio do Contribuinte - IE / 244-255
	_cRet += Strzero(SE2->E2_XESCDA,13)										//Numero da divida ativa / 256-268
	_cRet += Strzero(SE2->E2_XESNPN,13)										//Codigo AIIM / 269-281
	_cRet += Strzero(SE2->E2_SALDO*100,15)									//Valor de pagamento GARE / 282-296
	_cRet += Strzero((SE2->E2_JUROS)*100,15)								//Valor de Juros+Encargos da GARE / 297-311
	_cRet += Strzero(SE2->E2_MULTA*100,15)									//Valor da Multa da GARE/ 312-326	
	_cRet += Strzero(0,15)													//Valor da Honorarios / 327-341
	_cRet += Space(30)		                              					//Observações / 342-371
	_cRet += Space(20)														//Uso exclusivo do Banco Safra / 372-391
ElseIf SEA->EA_MODELO $ "05" //Pagamento de Gare-SP (ICMS/DR/ITCMD)
	_cRet += "2"															//Tipo de Inscr. Contribuinte / pos. 098-098
	_cRet += PadL(Alltrim(SM0->M0_CGC),14,"0")								//Identificação do Contribuinte - CNPJ/CGC/CPF / 099-0112
	_cRet += PadL(Alltrim(SM0->M0_ENDENT),40,"")							//Endereço do Contribuinte / 113-152
	_cRet += PadL(Alltrim(SM0->M0_CIDENT),30,"")							//Cidade do Contribuinte / 153-182
	_cRet += PadL(Alltrim(SM0->M0_ESTENT),2,"0")							//Estado do Contribuinte / 183-184
	_cRet += PadL(Alltrim(SM0->M0_CNAE),10,"0")								//Codigo Nacional de Arrecadação Estadual do Contribuinte / 185-194
	_cRet += Substr(SE2->E2_CODRET,1,4)										//Codigo da Receita GARE / 195-198
	_cRet += Strzero(Day(SE2->E2_VENCREA),2) + Strzero(Month(SE2->E2_VENCREA),2) + Str(Year(SE2->E2_VENCREA),4)//Data de Vencimento da GARE / 199-206
	_cRet += PadL(Alltrim(SM0->M0_INSC),12,"0")								//Codigo da Inscricao Estadual ou Codigo do Municipio do Contribuinte - IE / 207-218
	_cRet += Strzero(SE2->E2_XESCDA,13)										//Numero da divida ativa / 219-231
	_cRet += Strzero(Val(SE2->E2_XCOMPET),6)								//Competencia / 232-237
	_cRet += Strzero(SE2->E2_XESNPN,13)										//Codigo AIIM / 238-250
	_cRet += Strzero(SE2->E2_SALDO*100,15)									//Valor de pagamento GARE / 251-265
	_cRet += Strzero((SE2->E2_JUROS)*100,15)								//Valor de Juros+Encargos da GARE / 266-280
	_cRet += Strzero(SE2->E2_MULTA*100,15)									//Valor da Multa da GARE/ 281-295
	_cRet += Strzero(SE2->E2_ACRESC*100,15)									//Valor de Acrescimo Financeiro / 296-310
	_cRet += Strzero(0,15)													//Valor da Honorarios / 311-325
	_cRet += Space(30)		                              					//Observações / 326-355
	_cRet += Space(36)														//Uso exclusivo do Banco Safra / 356-391
ElseIf SEA->EA_MODELO $ "06/07/09/10" // Pagamento de Tributo Federal c/ Codigo de Barras
	_cRet := "D"															//D=Digitacao - L=Leitora / pos. 098-098
	_cRet += PadL(Alltrim(SE2->E2_CODBAR),48,"")							//Codigo de Barras / pos. 099-146
	_cRet += Space(165)														//Uso exclusivo do Banco Safra / 147-311
	_cRet += Space(80)														//Mensagem do retorno do Arquivo / 312-391
ElseIf SEA->EA_MODELO $ "08" // Pagamento de Tributo Federal c/ Codigo de Barras
	_cRet := "D"															//D=Digitacao - L=Leitora / pos. 098-098
	_cRet += PadL(Alltrim(SE2->E2_CODBAR),48,"")							//Codigo de Barras / pos. 099-146
	_cRet += Strzero(0,16)													//Ident. do FGTS / 147-162
	_cRet += Space(149)														//Uso exclusivo do Banco Safra / 163-311
	_cRet += Space(80)														//Mensagem do retorno do Arquivo / 312-391
ElseIf SEA->EA_MODELO $ "99" // Pagamento de Tributo Federal c/ Codigo de Barras
	_cRet := "D"															//D=Digitacao - L=Leitora / pos. 098-098
	_cRet += PadL(Alltrim(SE2->E2_CODBAR),48,"")							//Codigo de Barras / pos. 099-146
	_cRet += GravaData(SE2->E2_VENCREA,.F.,8)								//Data de Vencimento da GARE / 147-154
	_cRet += Space(157)														//Uso exclusivo do Banco Safra / 155-311
	_cRet += Space(80)														//Mensagem do retorno do Arquivo / 312-391
EndIf
Return _cRet
