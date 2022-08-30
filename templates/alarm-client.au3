#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


HotKeySet("{F11}", "Engage")

Global $AlarmFileLocation = "\\zorb-srv\Operators\ORBdata\всякое\alarm.txt"




Func Engage()
	If FileExists($AlarmFileLocation) Then
	Else
		FileWrite($AlarmFileLocation, "" )
	EndIf
	
	$AlarmFile = FileOpen($AlarmFileLocation, 2)
	FileWrite($AlarmFile, "1")
	FileClose($AlarmFile)
EndFunc




While 1
	Sleep(100)
WEnd