#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA410COR บAutor  ณ Genilson Lucas     บ Data ณ  18/11/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para altera็ใo da Legenda do Pedido de    บฑฑ
ฑฑบ          ณ Vendas.										              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SALON LINE -  SOLICITAวรO - ELSER / JACQUELINE             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA410COR()

Local aCores := {} // PARAMIXB traz a estrutura do array padrใo

//U_FATG002()
//0=Liberado;1=Rejeitado;2=Blq Risco;3=Blq Data;4=Blq Limite
aAdd(aCores, {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)", "ENABLE", "Pedido em Aberto"})
aAdd(aCores, {"!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)", "DISABLE", "Pedido Encerrado"})
aAdd(aCores, {"C5_X_STACR == '2' .or. C5_X_STACR == '3' .or. C5_X_STACR == '4' .and.Empty(C5_NOTA) ", "BR_PRETO", "Pedido Bloqueado"})
aAdd(aCores, {"C5_X_STACR == '1' .and.Empty(C5_NOTA) ", "BR_AZUL", "Pedido Rejeitado"})

aAdd(aCores, {"!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)", "BR_AMARELO", "Pedido Liberado"})
aAdd(aCores, {"C5_BLQ == '1'", "BR_AZUL"})
aAdd(aCores, {"C5_BLQ == '2'", "BR_LARANJA"})


Return aCores


Static Function Valida(nFilial, nPedido)


Return .T.