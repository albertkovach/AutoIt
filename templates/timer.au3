#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Timers.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>

Global $iMemo, $hStatusBar, $progress, $percent = 0, $direction = 1

_Example_CallBack()

Func _Example_CallBack()
    Local $hGUI, $iTimerProgress, $btn_change, $iWait = 10, $btn_state
    Local $aParts[3] = [75, 330, -1]

    $hGUI = GUICreate("Таймеры с использованием CallBack-функции", 400, 320)
    $iMemo = GUICtrlCreateEdit("", 2, 32, 396, 226, BitOR($WS_HSCROLL, $WS_VSCROLL))
    GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
    $btn_state = GUICtrlCreateButton("Запуск прогресса", 70, 270, 120, 25)
    $btn_change = GUICtrlCreateButton("Изменить задержку", 215, 270, 110, 25)
    GUICtrlSetState($btn_change, $GUI_DISABLE)
    $hStatusBar = _GUICtrlStatusBar_Create($hGUI, $aParts)
    _GUICtrlStatusBar_SetText($hStatusBar, "Таймеры")
    _GUICtrlStatusBar_SetText($hStatusBar, @tab & @tab & StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC), 2)
    $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
    GUICtrlSetColor($progress, 0xff0000)
    _GUICtrlStatusBar_EmbedControl($hStatusBar, 1, GUICtrlGetHandle($progress))
    GUISetState()

    ; создание первого таймера, с частотой 1 сек, время в строке состояния
    _Timer_SetTimer($hGUI, 1000, "_UpdateStatusBarClock")

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $btn_state
                If GUICtrlRead($btn_state) = "Запуск прогресса" Then
                    ; создание второго таймера, с частотой 10 или 250 мсек, прогресс бар
                    $iTimerProgress = _Timer_SetTimer($hGUI, $iWait, "_UpdateProgressBar")
                    If @error Or $iTimerProgress = 0 Then ContinueLoop
                    GUICtrlSetData($btn_state, "Остановить прогресс")
                    GUICtrlSetState($btn_change, $GUI_ENABLE)
                Else
                    GUICtrlSetState($btn_change, $GUI_DISABLE)
                    _Timer_KillTimer($hGUI, $iTimerProgress) ; Прибивает таймер
                    GUICtrlSetData($btn_state, "Запуск прогресса")
                EndIf

            Case $btn_change
                If $iWait = 10 Then ; переключает задержку
                    $iWait = 250
                Else
                    $iWait = 10
                EndIf
                MemoWrite("Таймер для прогресса установлен в: " & $iWait & " миллисекунд")
                $iTimerProgress = _Timer_SetTimer($hGUI, $iWait, "", $iTimerProgress) ; перезапуск таймера с другим интервалом времени
        EndSwitch
    WEnd
    ConsoleWrite("Прибиты все таймеры? " & _Timer_KillAllTimers($hGUI) & @CRLF)
    GUIDelete()
EndFunc   ;==>_Example_CallBack

; Функция обратного вызова, обновления строки состояния
Func _UpdateStatusBarClock($hWnd, $Msg, $iIDTimer, $dwTime)
    #forceref $hWnd, $Msg, $iIDTimer, $dwTime
    _GUICtrlStatusBar_SetText($hStatusBar, @tab & @tab & StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC), 2)
EndFunc   ;==>_UpdateStatusBarClock

; Функция обратного вызова, обновления прогресс бара
Func _UpdateProgressBar($hWnd, $Msg, $iIDTimer, $dwTime)
    #forceref $hWnd, $Msg, $iIDTimer, $dwTime
    $percent += 5 * $direction
    GUICtrlSetData($progress, $percent)
    If $percent = 100 Or $percent = 0 Then $direction *= -1
    If $percent = 100 Then
        GUICtrlSetColor($progress, 0xff0000)
    ElseIf $percent = 0 Then
        GUICtrlSetColor($progress, 0x0000ff)
    EndIf
EndFunc   ;==>_UpdateProgressBar

; Записывает строку в элемент для заметок
Func MemoWrite($sMessage)
    GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite