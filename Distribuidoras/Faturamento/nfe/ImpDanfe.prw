#Include "Protheus.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
 
/*���������������������������������������������������������������������������
���Programa  � ImpDanfe �Autor  �Thiago/Genesis      � Data �  15/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para chamar a impress�o do Danfe e XML              ���
���Desc.     � u_ImpDanfe                 					         ���
�������������������������������������������������������������������������͹��
���Uso       � Usado para imprimir Danfe por outras rotinas  e o XML      ���
���������������������������������������������������������������������������*/
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
