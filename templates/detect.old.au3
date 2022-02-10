#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
$mainwindow = GUICreate("DETECT.exe", 240, 60)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
Global $Label1 = GUICtrlCreateLabel("Дороги и мосты", 15, 15, 200, 500)


HotKeySet("{NUMPADDOT}", "ExecuteKey")


Local $hWnd = WinGetHandle("ORBita - [Индексирование]", "")
Local $EditFieldType = "Edit3"
Local $EditFieldDnum = "WindowsForms10.EDIT.app.0.141b42a_r7_ad16"
Local $EditFieldDdate = "WindowsForms10.EDIT.app.0.141b42a_r7_ad17"
Local $EditFieldMnum = "WindowsForms10.EDIT.app.0.141b42a_r7_ad18"
Local $EditFieldMdate = "WindowsForms10.EDIT.app.0.141b42a_r7_ad19"
Local $EditFieldContr = "Edit4"

Local $StartedNow = true

Local $Type
Local $Dnum
Local $Ddate
Local $Mnum
Local $Mdate
Local $Contr

Local $OldType
Local $OldDnum
Local $OldDdate
Local $OldMnum
Local $OldMdate
Local $OldContr

Local $EditHandleToCopy
Local $EditDataToCopy

Cycle()


Func ExecuteKey()
    MsgBox($MB_SYSTEMMODAL, "Parser", "stop")
   Send("{Enter}")
   Send($EditDataToCopy)
   Send("{Enter}")

   ;ControlSend($hWnd, "", $EditHandleToCopy, $EditDataToCopy)

   ;Sleep(100)
EndFunc


Func Cycle()
   While 1
	  Scanner()
   WEnd
EndFunc


Func Scanner()
   $Type = ControlGetText($hWnd, "", $EditFieldType)
   $Dnum = ControlGetText($hWnd, "", $EditFieldDnum)
   $Ddate = ControlGetText($hWnd, "", $EditFieldDdate)
   $Mnum = ControlGetText($hWnd, "", $EditFieldMnum)
   $Mdate = ControlGetText($hWnd, "", $EditFieldMdate)
   $Contr = ControlGetText($hWnd, "", $EditFieldContr)


   If $StartedNow == true Then
	  $OldType = $Type
	  $OldDnum = $Dnum
	  $OldDdate = $Ddate
	  $OldMnum = $Mnum
	  $OldMdate = $Mdate
	  $OldContr = $Contr

	  $StartedNow = false
   EndIf


   If $Type<>$OldType Then
	  GUICtrlSetData($Label1, $Type)
	  $EditHandleToCopy = $EditFieldType
	  $EditDataToCopy = $Type
   EndIf


   If $Dnum<>$OldDnum Then
	  GUICtrlSetData($Label1, $Dnum)
	  $EditHandleToCopy = $EditFieldDnum
	  $EditDataToCopy = $Dnum
   EndIf


   If $Ddate<>$OldDdate Then
	  GUICtrlSetData($Label1, $Ddate)
	  $EditHandleToCopy = $EditFieldDdate
	  $EditDataToCopy = $Ddate
   EndIf


   If $Mnum<>$OldMnum Then
	  GUICtrlSetData($Label1, $Mnum)
	  $EditHandleToCopy = $EditFieldMnum
	  $EditDataToCopy = $Mnum
   EndIf


   If $Mdate<>$OldMdate Then
	  GUICtrlSetData($Label1, $Mdate)
	  $EditHandleToCopy = $EditFieldMdate
	  $EditDataToCopy = $Mdate
   EndIf


   If $Contr<>$OldContr Then
	  GUICtrlSetData($Label1, $Contr)
	  $EditHandleToCopy = $EditFieldContr
	  $EditDataToCopy = $Contr
   EndIf


   $OldType = $Type
   $OldDnum = $Dnum
   $OldDdate = $Ddate
   $OldMnum = $Mnum
   $OldMdate = $Mdate
   $OldContr = $Contr

EndFunc




Func CLOSEClicked()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd