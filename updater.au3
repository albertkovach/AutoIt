#include <FileConstants.au3>

Update()

Func Update()
	$source = "\\zorb-srv\Operators\ORBdata\всякое\AutoIT\update channel\flame.exe"
	$destinationfile = @ScriptDir & "\flame.exe"

	Sleep (1000)
	If FileExists($destinationfile) Then
		Runwait(@ComSpec & " /c " & "xcopy " & '"' & $source & '"' & ' "' & $destinationfile & '"' & " /Y /H /I","",@SW_HIDE)
	Else
		FileWrite($destinationfile, "" )
		Sleep (500)
		Runwait(@ComSpec & " /c " & "xcopy " & '"' & $source & '"' & ' "' & $destinationfile & '"' & " /Y /H /i","",@SW_HIDE)
	EndIf
	Sleep (1000)
	
	Run($destinationfile)
	
	Exit
EndFunc

;FileCopy("\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\flame.exe", "\flame.exe", $FC_OVERWRITE + $FC_CREATEPATH)
	