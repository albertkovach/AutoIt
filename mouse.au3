#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include "OnEventFunc.au3"

Opt("GUIOnEventMode", 1)

Global $mainwindow = GUICreate("Mouse", 180, 150)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)

;Global $Xlabel = GUICtrlCreateLabel("X: ", 10, 10, 60, 18)
;Global $Ylabel = GUICtrlCreateLabel("Y: ", 10, 30, 60, 18)
;Global $Clicklabel1 = GUICtrlCreateLabel("", 10, 50, 150, 18)
;Global $Clicklabel2 = GUICtrlCreateLabel("", 10, 70, 150, 18)

Global $StartMouseLearn = GUICtrlCreateButton("Добавить клик мыши", 10, 10, 140, 20)
Global $MainEdit = GUICtrlCreateEdit("", 10, 40, 140, 100, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
GUICtrlSetOnEvent($StartMouseLearn, "SetMouseClickInitialize")


Global $ClickDetected = False

Global $EditText


;HotKeySet("{F1}", "Flush")
;HotKeySet("{F10}", "MouseClickPopup")
;SetOnEventA("{F10}", "MyHK", $paramByVal, 34, $paramByRef, "$rrdd")

Global $MouseClickLearned = False
Global $MouseClickXc = 0
Global $MouseClickYc = 0
Global $MouseClickType = 0
	
	
While 1
	Sleep(100)
	;MousePosCheck()
WEnd



Func MousePosCheck()
	Local $aPos = MouseGetPos()
	GUICtrlSetData($Xlabel, "X: " & $aPos[0])
	GUICtrlSetData($Ylabel, "X: " & $aPos[1])
EndFunc


Func Flush()
	$ClickDetected = True
	GUICtrlSetData($Clicklabel1, "")
	GUICtrlSetData($Clicklabel2, "")
EndFunc


Func ClickDetect()
	If _IsPressed('01') Then
		If $ClickDetected == False Then
			GUICtrlSetData($Clicklabel2, "Single click ! x:" & $aPos[0] & ' y:' & $aPos[1])
			$ClickDetected = True
		EndIf
		GUICtrlSetData($Clicklabel1, "Every click ! x:" & $aPos[0] & ' y:' & $aPos[1])
		$ClickDetected = True
	EndIf
EndFunc





Func SetMouseClickInitialize()

	$returnedValue = MsgBox($MB_OKCANCEL, "Создать клик", "Наведите курсор на место и нажмите F10 !", 10)
	If $returnedValue == 1 Then
		SetOnEventA("{F10}", "SetMouseClickPopup", $paramByVal, $MainEdit)
	EndIf

EndFunc







Func SetMouseClickPopup($editfield)
	SetOnEventA("{F10}", "")
	Local $aPos = MouseGetPos()
	Global $SetMouseClickXPos = $aPos[0]
	Global $SetMouseClickYPos = $aPos[1]
	
	Global $SetMouseClickEdit = $editfield
	
	Global $MouseClickPopupWin = GUICreate("",170,75)
	GUISetState(@SW_SHOW)
	Local $DescLabel1 = GUICtrlCreateLabel("Координаты:", 10, 10, 200, 18)
	GUICtrlSetData($DescLabel1, "Координаты - X: " & $aPos[0] & ", Y: " & $aPos[1])
	Local $DescLabel2 = GUICtrlCreateLabel("Выберите клавишу:", 10, 25, 150, 18)
	Local $MouseSetLkeybtn = GUICtrlCreateButton("Левая", 15, 45, 65, 20)
	Local $MouseSetRkeybtn = GUICtrlCreateButton("Правая", 90, 45, 65, 20)
	SetOnEventA($MouseSetLkeybtn, "SetMouseClickL", $paramByRef, "$SetMouseClickXPos", $paramByRef, "$SetMouseClickYPos", $paramByRef, "$SetMouseClickEdit")
	SetOnEventA($MouseSetRkeybtn, "SetMouseClickR", $paramByRef, "$SetMouseClickXPos", $paramByRef, "$SetMouseClickYPos", $paramByRef, "$SetMouseClickEdit")

	GUISetOnEvent($GUI_EVENT_CLOSE, "MouseClickPopupClose")
EndFunc

Func SetMouseClickL($xPos, $yPos, $editfield)
	SetMouseClickPopupClose()
	Local $editfieldtext = GUICtrlRead($editfield)
	$editfieldtext = $editfieldtext & "<[McL-" & $xPos & "-" & $yPos & "]>"
	GUICtrlSetData ($editfield, $editfieldtext)
	;MsgBox($MB_SYSTEMMODAL, "Lkey", $editfieldtext & "-" & $xPos & "-" & $yPos)
EndFunc

Func SetMouseClickR($xPos, $yPos, $editfield)
	SetMouseClickPopupClose()
	Local $editfieldtext = GUICtrlRead($editfield)
	$editfieldtext = $editfieldtext & "<[McR-" & $xPos & "-" & $yPos & "]>"
	GUICtrlSetData ($editfield, $editfieldtext)
EndFunc

Func SetMouseClickPopupClose()
	GUIDelete($MouseClickPopupWin)
	RefreshEdit()
EndFunc




Func RefreshEdit()
	;MsgBox($MB_SYSTEMMODAL, "Out", $Txt)
	;GUICtrlSetData ($MainEdit, $EditText)
EndFunc




Func CLOSEClicked()
	Exit
EndFunc



#comments-start

Func MouseClickInitialize()

	$returnedValue = MsgBox($MB_OKCANCEL, "Создать клик", "Наведите курсор на место и нажмите F10 !", 10)
	If $returnedValue == 1 Then
		;MsgBox($MB_SYSTEMMODAL, "Создать клик", "Pressed OK !", 10)
		HotKeySet("{F10}", "MouseClickPopup")
		
		;While $MouseClickLearned == False
		;WEnd
		
		$MouseClickLearned = False
		;MsgBox($MB_SYSTEMMODAL, "Создать клик", "Клик создан !", 10)
	EndIf



	;Global $MouseClickInitializeWin = GUICreate("",220,75)
	;Local $DescLabel1 = GUICtrlCreateLabel("Наведите курсор на место и нажмите F10 !", 10, 10, 200, 18)
	;GUISetState(@SW_SHOW)
	;GUISetOnEvent($GUI_EVENT_CLOSE, "MouseClickInitializeClose")
EndFunc

Func MouseClickInitializeClose()
	GUIDelete($MouseClickInitializeWin)
EndFunc



Func MouseClickPopup()
	HotKeySet("{F10}", "")
	
	Global $MouseClickPopupWin = GUICreate("",170,75)
	GUISetState(@SW_SHOW)
	Local $DescLabel1 = GUICtrlCreateLabel("Координаты:", 10, 10, 200, 18)
	Local $DescLabel2 = GUICtrlCreateLabel("Выберите клавишу:", 10, 25, 150, 18)
	Local $MouseSetLkeybtn = GUICtrlCreateButton("Левая", 15, 45, 65, 20)
	Local $MouseSetRkeybtn = GUICtrlCreateButton("Правая", 90, 45, 65, 20)
	GUICtrlSetOnEvent($MouseSetLkeybtn, "MouseClickPopupClose")
	GUICtrlSetOnEvent($MouseSetRkeybtn, "MouseClickPopupClose")
	
	Local $aPos = MouseGetPos()
	
	GUICtrlSetData($DescLabel1, "Координаты - X: " & $aPos[0] & ", Y: " & $aPos[1])
   
	GUISetOnEvent($GUI_EVENT_CLOSE, "MouseClickPopupClose")
EndFunc

Func MouseClickPopupClose()
	HotKeySet("{F10}", "MouseClickPopup")
	
	
	GUIDelete($MouseClickPopupWin)
	
	$MouseClickLearned = True
EndFunc
#comments-end