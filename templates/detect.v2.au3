#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
$mainwindow = GUICreate("DETECT.v2.exe", 240, 60)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
Global $Label1 = GUICtrlCreateLabel("Универсальный для ORBita v2", 15, 15, 200, 500)


HotKeySet("{NUMPADADD}", "ExecuteKey")


Local $hWnd = WinGetHandle("[CLASS:WindowsForms10.Window.8.app.0.21093c0_r6_ad1]", "")

Local $EditHandleToCopy = "WindowsForms10.EDIT.app.0.21093c0_r6_ad11"
Local $EditDataToCopy


Func ExecuteKey()
   $EditDataToCopy = ControlGetText($hWnd, "", $EditHandleToCopy)
   Send("{Enter}")
   Send($EditDataToCopy)
   Send("{Enter}")
EndFunc


Func CLOSEClicked()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd