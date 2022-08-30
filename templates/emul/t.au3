#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>

Global $hHook, $hStub_KeyProc, $iEditLog, $Gui
Global $ClickCount = 0
Global $hTimer


; в AutoIt3 v3.3.6.1 и ниже эти константы не определены
; Global Const $WM_MBUTTONDBLCLK = 0x0209
; Global Const $WM_RBUTTONDBLCLK = 0x0206
; Global Const $WM_MOUSEHWHEEL = 0x020E ???

_Main()

Func _Main()
	OnAutoItExitRegister("Cleanup")

	Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
	$mainwindow = GUICreate("MagicMouse", 240, 60)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClick")
	GUISetState(@SW_SHOW)

	Global $STATUSlabel = GUICtrlCreateLabel("Нажмите дважды на ПКМ для СКМ", 18, 18, 250, 18)

	Local $hmod
	$hStub_KeyProc = DllCallbackRegister("_KeyProc", "long", "int;wparam;lparam")
	$hmod = _WinAPI_GetModuleHandle(0)
	$hHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($hStub_KeyProc), $hmod)

EndFunc





Func _KeyProc($nCode, $wParam, $lParam)
	Local $tKEYHOOKS, $X, $Y, $tmp, $Delta
	If $nCode < 0 Then Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam) ; переход к следующей цепочки хуков в очереди (не срабатывает)

	Switch $wParam

		Case $WM_RBUTTONUP
			$tmp= 'Отжатие Правой кнопкой мыши'
			$ClickCount = $ClickCount + 1
			
			If $ClickCount == 2 Then
				$iDiff = TimerDiff($hTimer)
				If $iDiff < 700 Then
					Send("{ESC}")
					MouseClick($MOUSE_CLICK_MIDDLE)
					;Send("{UP}")
				EndIf
				
				$ClickCount = 0
			EndIf
			
			If $ClickCount == 1 Then
				$hTimer = TimerInit()
			EndIf

		Case Else
			Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam) ; переход к следующей цепочки хуков в очереди
	EndSwitch
	

EndFunc




Func Cleanup()
	_WinAPI_UnhookWindowsHookEx($hHook)
	DllCallbackFree($hStub_KeyProc)
	CLOSEClick()
EndFunc

Func CLOSEClick()
  Exit
EndFunc

While 1
   Sleep(100)
WEnd