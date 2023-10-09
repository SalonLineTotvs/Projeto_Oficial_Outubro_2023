#Include 'Protheus.ch'

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠цддддддддддедддддддддддбдддддддбддддддддддддддддддддддбддддддбддaддддддд╢╠╠
╠╠Ё Funcao   Ё ESTP0005	 Ё Autor Ё Genilson M Lucas   Ё Data Ё 23/07/2018 Ё╠╠
╠╠цддддддддддедддддддддддадддддддаддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao Ё AxCadastro da tela para controle de Produtos cortados.	  Ё╠╠
╠╠Ё          Ё 								  							  ╢╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё SALON LINE                                                 Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
*/

User Function ESTP0004()
 
PRIVATE cCadastro  := "Produtos Cortados"
PRIVATE aRotina     := {}
 
AxCadastro("SZ2", OemToAnsi(cCadastro), 'AlwaysTrue()')
 
Return()