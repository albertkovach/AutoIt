#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


Opt("GUIOnEventMode", 1)

Global $AlarmFileLocation = "\\zorb-srv\Operators\ORBdata\всякое\alarm.txt"
Global $AlarmState = 0

HotKeySet("{F11}", "AlarmWinClose")

Main()

Func Main()

	While 1
		CheckSize()
		
		If $AlarmState == 1 Then
			$AlarmState = 0
			AlarmWinOpen()
		EndIf
	
		Sleep(100)
	WEnd

EndFunc




Func CheckTXT()
	$AlarmFile = FileOpen($AlarmFileLocation, 0)
	$AlarmFileContent = FileRead($AlarmFileLocation)
	FileClose($AlarmFile)

	If $AlarmFileContent == "1" Then
		$AlarmState = 1
		
		$AlarmFile = FileOpen($AlarmFileLocation, 2)
		FileClose($AlarmFile)
	EndIf
EndFunc


Func CheckSize()

	If FileExists($AlarmFileLocation) Then
	
		$AlarmFileSize = FileGetSize ($AlarmFileLocation)
		
		If $AlarmFileSize > 0 Then
			$AlarmState = 1
			
			$AlarmFile = FileOpen($AlarmFileLocation, 2)
			FileClose($AlarmFile)
		EndIf
	
	Else
		FileWrite($AlarmFileLocation, "" )
	EndIf


EndFunc







Func AlarmWinOpen()
	Global $AlarmWin = GUICreate("ALARM",1900,1000)
	GUISetState(@SW_SHOW)
	
	While 1
		GUISetBkColor(0x2828F1)
		Sleep(150)
		GUISetBkColor(0xF12828)
		Sleep(150)
	WEnd

EndFunc

Func AlarmWinClose()
	GUISetState(@SW_HIDE)
	Main()
EndFunc







