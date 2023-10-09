//Projeto - Call Center - Automitizar a linha do aCols para trazer preenchido conforme informação da primeira linha
//Solicitação - Danille França / Fernando Medeiros
//Autor - Rodrigo Altafini - AMR Consultoria
//Data - 08/03/2019

//Função - Criar um Gatilho no campo UD_ASSUNTO , para acionar a automação do aCols

#INCLUDE "PROTHEUS.CH"

USER FUNCTION TMKG001()
       
local cAssunto := M->UD_ASSUNTO
                            
if n > 1

	//aCols[n][4]  := aCols[n-1][4]	// Informação da Nota Fiscal
	aCols[n][14] := aCols[n-1][14]	// Informação da Ocorrencia
	aCols[n][15] := aCols[n-1][15]	// Detalhe    da Ocorrencia
	aCols[n][16] := aCols[n-1][16]	// Informação da Acao	
	aCols[n][17] := aCols[n-1][17]	// Detalhe    da Acao
	aCols[n][20] := aCols[n-1][20]	// Responsavel
	aCols[n][21] := aCols[n-1][21]	// Nome
	
	GetdRefresh()

endif

return cAssunto


/*
X- CONTATO - CNPJ

- DATA EXECUCAO - 
  DATA SEGUNDA EXCUÇÃO
  ULTIMO DATA DATA DE ATENDIMENTO

- AGENDA OPERADOR -  EM ANDAMENTO...

X- GRADE DE ATUALIZAÇÃO - MOSTRAR

- DADOS WORKFLOW - NOVO LAYOUT SOLIC. DANI

X - BROWNSER  - DATA ATENDIMENTO (UC_DATA)

X - NAO TEM O CAMPO QUANTIDADE - 
    A) DEVOLIDA, QUANTIDADE
    B) VALOR 

- CONSULTA ATENDIMENTO - SUD
- VARIOS EMAIL
- CONSULTA EM TELA RESUMO
- RELATORIO 

*/

/* Implantação CallCenter - 
Tabelas normalizadas entre si
SU7 / SU0 / AGI / AGJ / AG9 / SKK

Tabela Compartilhadas:
SU0
SU7
SU9
SUQ
SUR
SU5
AC8

Campos Criados:
SUD..

*/
