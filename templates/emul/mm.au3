#include <GUIConstantsEx.au3>
#include <_MouseOnEvent.au3>


	Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
	$mainwindow = GUICreate("MagicMouse", 240, 60)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClick")
	GUISetState(@SW_SHOW)

	Global $STATUSlabel = GUICtrlCreateLabel("Нажмите дважды на ПКМ для СКМ", 18, 18, 250, 18)
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, 'MiddleClick')



Func MiddleClick()
	Send("notepad.exe{Enter}")
EndFunc




Func CLOSEClick()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd