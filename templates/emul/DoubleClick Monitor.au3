#include "..\MouseOnEvent.au3"

HotKeySet("{ESC}", "_Quit")

_MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT, '_DblClk_Event')
_MouseSetOnEvent($MOUSE_SECONDARYDBLCLK_EVENT, '_DblClk_Event')

While 1
	Sleep(10)
WEnd

Func _DblClk_Event($iEvent)
	Switch $iEvent
		Case $MOUSE_PRIMARYDBLCLK_EVENT
			ToolTip('Primary Mouse Button Double Clicked.')
		Case $MOUSE_SECONDARYDBLCLK_EVENT
			ToolTip('Secondary Mouse Button Double Clicked.')
	EndSwitch
EndFunc

Func _Quit()
	Exit
EndFunc
