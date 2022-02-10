#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $mainwindow = GUICreate("FLAME.exe", 100, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
	
	
While 1
	Sleep(100)
WEnd

Func CLOSEClicked()
	Exit
EndFunc