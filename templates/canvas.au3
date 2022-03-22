#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

	$hGUI = GUICreate("лх")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	Opt("GUIOnEventMode", 1)
	
	$Graph = GUICtrlCreateGraphic("",100,200)

	GUICtrlSetBkColor($Graph, 0xffffff)
	GUICtrlSetGraphic($Graph, $GUI_GR_PIE, 50, 50, 40, 0, 30)
	
	GUISetState(@SW_SHOW) 

	Global $Angle = 10

While 1
	;GUISetState(@SW_SHOW)
	If $Angle >= 360 Then
		$Angle = 10
	EndIf
	$Angle = $Angle + 2
	
	GUICtrlSetGraphic($Graph, $GUI_GR_PIE, 50, 50, 40, $Angle)
	GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
	;MsgBox(4096, 'Тест', "")
	
	Sleep(100)
	;GUISetState(@SW_HIDE)
WEnd



Func CLOSEClicked()
	Exit
EndFunc