#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#DEFINE  ENTER CHR(13)+CHR(10)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ºPrograma  ³ zArray2Excel º Autor ³ Genesis/Mateus  º Data ³ 27/11/14  ±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ±±
//±±ºDescricao ³ RELATORIO - Excel (GENERICO)                              ±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*----------------------------------------------*
User Function zArray2Excel(_zNome,_aCabs,_aItem)
*----------------------------------------------*
    Local aArea         := GetArea()
    Local oFWMsExcel
    Local oExcel
    Local _nR
    Local cArquivo      := GetTempPath()+'zArrExc1.xml'
     
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
     
    //Aba 01 - Teste
    //oFWMsExcel:AddworkSheet("Aba 1 Teste") //Não utilizar número junto com sinal de menos. Ex.: 1-
    //    //Criando a Tabela
    //    oFWMsExcel:AddTable("Aba 1 Teste","Titulo Tabela")
    //    //Criando Colunas
    //    oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col1",1,1) //1 = Modo Texto
    //    oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col2",2,2) //2 = Valor sem R$
    //    oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col3",3,3) //3 = Valor com R$
    //    oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col4",1,1)
    //    //Criando as Linhas
    //    oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{11,12,13,sToD('20140317')})
    //    oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{21,22,23,sToD('20140217')})
    //    oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{31,32,33,sToD('20140117')})
    //    oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{41,42,43,sToD('20131217')})
     
     
    //Aba 02 - Produtos
    oFWMsExcel:AddworkSheet("Aba 1")

        //Criando a Tabela
        oFWMsExcel:AddTable("Aba 1",_zNome)

        For _nR:=1 To Len(_aCabs)
            oFWMsExcel:AddColumn("Aba 1",_zNome,_aCabs[_nR],1)
        Next _nR 

        //Criando as Linhas... Enquanto não for fim da query
        For _nR:=1 To Len(_aItem)
            _aCols := _aItem[_nR]

            oFWMsExcel:AddRow("Aba 1",_zNome, _aCols)

            //oFWMsExcel:AddRow("Aba 1",_zNome,{;
            //                                                        QRYPRO->B1_COD,;
            //                                                        QRYPRO->B1_DESC,;
            //                                                        QRYPRO->B1_TIPO,;
            //                                                        QRYPRO->BM_GRUPO,;
            //                                                        QRYPRO->BM_DESC,;
            //                                                        Iif(QRYPRO->BM_PROORI == '0', 'Não Original', 'Original');
            //})
        //Pulando Registro
        Next _nR 
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
    RestArea(aArea)
Return


