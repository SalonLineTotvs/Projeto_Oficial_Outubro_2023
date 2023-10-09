//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zPegaMac
Pegando o MAC Address de máquinas hospedeiras com Windows
@since 23/09/2014
    @example
    u_zPegaMac()
/*/
*--------------------*
User Function zPegaMac
*--------------------*
    Local cComando  := "getmac > "
    Local _cDirServ := '\dirdoc\co01\'
    Local _cTemp    := 'C:\TEMP\'
    Local cNomBat   := "comando_mac.bat"
    Local cArquivo  := "mac_address.txt"
    Local cMac      := ""

	If Select("SX6") == 0
		RpcSetType(3)
		RpcSetEnv("01","02")
	Endif

    Private cDir      := IIF(!IsBlind(),GetTempPath(),_cDirServ)
    
    //Gravando em um .bat o comando
    MemoWrite(cDir + cNomBat, cComando + _cTemp + cArquivo)
     
    //Executando o comando através do .bat
    ShellExecute("OPEN", cDir+cNomBat, "", cDir, 0 )
     
    //Se existe o arquivo
    If File(_cTemp+cArquivo)
        ConOut("[zPegaMac] > Arquivo gerado.")
         
        //Gerando o MacAddress
        cMac := MemoRead(_cTemp + cArquivo)
        cMac := SubStr(cMac, RAt("=", cMac)+1, Len(cMac)) //Pegando a partir do ultimo igual
        cMac := SubStr(cMac, 1, At(" ", cMac)-1) //Pegando até o primeiro espaço
        cMac := StrTran(cMac, Chr(13)+Chr(10), "") //retirando os -enters-

        FErase(_cTemp + cArquivo)
    EndIf

    FErase(cDir + cNomBat)
    //Alert("|"+cMac+"|")
Return(cMac)
