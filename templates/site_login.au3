#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>

Opt("GUIOnEventMode", 1)

Global $mainwindow = GUICreate("FLAME.exe", 200, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)



Global $SiteCombo = GUICtrlCreateCombo("", 15, 15, 100, 23, $CBS_DROPDOWNLIST + $WS_VSCROLL) ; стиль не редактируемого списка
GUICtrlSetData(-1, "d|m", "d")

Global $LoginBtn = GUICtrlCreateButton("Login", 15, 40, 55, 20)
GUICtrlSetOnEvent($LoginBtn, "Login")

HotKeySet("{NUMPADADD}", "SelectNext")
HotKeySet("{NUMPADSUB}", "SelectPrev")
HotKeySet("{NUMPADMULT}", "Login")


Local $Array[2][4]
$Array[0][0] = ""
$Array[0][1] = ""
$Array[0][2] = ""
$Array[0][3] = ""


$Array[1][0] = ""
$Array[1][1] = ""
$Array[1][2] = ""
$Array[1][3] = ""


Func Login()
	$x = GUICtrlSendMsg($SiteCombo, $CB_GETCURSEL, 0, 0)

	ShellExecute($Array[$x][0]) ; Site
	Sleep(3000)
	
	Send($Array[$x][1], 0)		; Tasks to login
	Send($Array[$x][2], 1)		; Login
	Send("{TAB}")
	Send($Array[$x][3], 1)		; Pass
	Send("{ENTER}")
EndFunc




Func SelectNext()
	$Count = GUICtrlSendMsg($SiteCombo, $CB_GETCOUNT, 0, 0)
	$Selected = GUICtrlSendMsg($SiteCombo, $CB_GETCURSEL, 0, 0)
	$Next = $Selected + 1

	If $Selected > $Count Then
		$Next = $Selected
	EndIf
	
	GUICtrlSendMsg($SiteCombo, $CB_SETCURSEL, $Next, 0)
EndFunc


Func SelectPrev()
	$Count = GUICtrlSendMsg($SiteCombo, $CB_GETCOUNT, 0, 0)
	$Selected = GUICtrlSendMsg($SiteCombo, $CB_GETCURSEL, 0, 0)
	$Next = $Selected - 1
	
	If $Next < 0 Then
		$Next = 0
	EndIf
	
	GUICtrlSendMsg($SiteCombo, $CB_SETCURSEL, $Next, 0)
EndFunc





	
While 1
	Sleep(100)
WEnd

Func CLOSEClicked()
	Exit
EndFunc
