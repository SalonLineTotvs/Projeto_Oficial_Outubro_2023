#Include "Protheus.ch"
                            
/*                    
Módulo: Call Centerr
Ponto de Entrada para adicionar novo botão na barra lateral da tela de Call Center.
*/
User Function TMKBARLA(aBotao, aTitulo)

aAdd( aBotao,{"POSCLI"  , {|| TMKP0001()} ,"Encerrar Atendimento"} )	

Return( aBotao )

/*
Desc.: Alterar todos os status para "Encerrado"
Solic.: Daniele França
*/
Static Function TMKP0001()
Local aArea	:= GetArea() 
Local nPos  := aScan(aHeader, {|x| AllTrim(x[2])=="UD_STATUS"})    

M->UC_STATUS	:= "3"   
                         
For nX := 1 to Len(aCols)
    // Verifica somente linhas nao deletadas
	If !aCols[nX][Len(aHeader)+1]   
		aCols[nX][nPos] := "2" 
	Endif 
Next nX

RestArea(aArea)

Return