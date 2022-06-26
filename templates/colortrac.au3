#include <GUIConstantsEx.au3>


	Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
	$mainwindow = GUICreate("Colorctac BW 300", 300, 70)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClick")
	GUISetState(@SW_SHOW)

	Global $STATUSlabel = GUICtrlCreateLabel("Нажмите F1 для автонастройки на Ч/Б 300dpi", 18, 18, 250, 18)
	HotKeySet("{F1}", "f1")



Func F1()
	MouseClick("left", 110, 258, 1, 0)
	Sleep(100)
	Sleep(100)
	MouseClick("left", 278, 332, 1, 0)
	Send("{DOWN}")
	Sleep(100)
	MouseClick("left", 280, 168, 1, 0)
	MouseClick("left", 280, 168, 1, 0)
	;MouseClickDrag ("left", 1158, 306, 1081, 350, 3)
EndFunc




Func CLOSEClick()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd