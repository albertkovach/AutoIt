#AutoIt3Wrapper_Add_Constants=n

#include <GUIConstantsEx.au3>
#include "OnEventFunc.au3"; assuming the udf is in the script dir


Opt("GUIOnEventMode", 1)

Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode",1)

Opt("TrayAutoPause", 0); Script will not be paused when clicking the tray icon.
TrayCreateItem("Test1")
TRaySetOnEventA(-1, "TrayIt1")
TrayCreateItem("")
TrayCreateItem("Feature List: OFF")
TrayCreateItem("")

TraySetState()



$rrdd = 99
$gui = GUICreate("test eventfuncs udf")

GUICtrlCreateButton("but1", 20, 20, 100, 22)
SetOnEventA(-1, "funcone", $paramByRef, "$rrdd", $paramByVal, 2, $paramByVal, 37, $paramByVal, "battery", $paramByVal, "parm5")
GUICtrlCreateButton("but2", 20, 60, 100, 22)
$but2index = SetOnEventA(-1, "functwo", $paramByVal, "pigs", $paramByVal, "cows", $paramByVal, "sheep")
SetOnEventA("{F7}", "MyHK", $paramByVal, 34, $paramByRef, "$rrdd")

$lab1 = GUICtrlCreateLabel($rrdd, 150, 20, 80, 22)
;Guisetonevent($GUI_EVENT_CLOSE,"AllDone")

;set a gui even. NB for gui events the first parameter must be passed by Val and the value must either be 0
; or the handle of the window the event is for.
SetOnEventA($GUI_EVENT_CLOSE, "AllDone", $paramByVal, $gui, $paramByRef, "$rrdd")
ConsoleWrite("eventclose = " & $GUI_EVENT_CLOSE & @CRLF)
GUISetState()
;$count = 0
While 1

    Sleep(20)

WEnd

Func TrayIt1()
    MsgBox(262144, "Tray event", "ok")
EndFunc   ;==>TrayIt1


Func AllDone($rr, $b)
    ConsoleWrite("all done = " & $rr & " $b = " & $b & @CRLF)
    Exit
EndFunc   ;==>AllDone


Func funcone(ByRef $a, $b, $c, $d, $e)
    ConsoleWrite($a & ', ' & $b & ', ' & $c & ', ' & $d & ', ' & $e & @CRLF)

    GUICtrlSetData($lab1, $rrdd)
    If $a > 200 Then SetOnEvent("{F7}", "");remove hotkey
EndFunc   ;==>funcone

Func functwo($h, $j, $k)
    ConsoleWrite($h & ', ' & $j & ', ' & $k & @CRLF)
    $rrdd += 16;change the value of $rrdd and see that but1 shows the change
EndFunc   ;==>functwo

Func MyHK($p1, $p2)
    MsgBox(262144, 'You have ' & $p1, "and also " & $p2)
EndFunc   ;==>MyHK
