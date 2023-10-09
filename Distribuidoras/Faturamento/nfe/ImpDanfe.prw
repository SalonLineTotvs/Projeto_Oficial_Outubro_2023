#Include "Protheus.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ImpDanfe บAutor  ณThiago/Genesis      บ Data ณ  15/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para chamar a impressใo do Danfe e XML              บฑฑ
ฑฑบDesc.     ณ u_ImpDanfe                 					         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Usado para imprimir Danfe por outras rotinas  e o XML      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*--------------------------------------------*
User Function ImpDanfe()
                                               
     Private AFILBRW := {}
     Private cCondicao :=" "
     Private lSair := .F.

     WHILE lSair == .F.
          cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
          AFILBRW     := {'SF2',cCondicao}

          SpedDanfe()
/*
          if MSGYESNO("Deseja imprimir outra DANFE?")
               lSair := .F.
          else
               lSair := .T.
          endif
*/
          if MSGYESNO("Deseja Exportar o XML?")
             SpedExport(1)
               lSair := .T.
          else
               lSair := .T.
          endif

        
     enddo


Return
