;Mouse Scroll Right: click = minimize window, double-click = maximize window
WheelRight::
;MsgBox, Right Wheel
if WheelRightCount > 0 ; SetTimer already started, so we log the keypress instead.
{
WheelRightCount += 1
return
}
; Otherwise, this is the first press of a new series. Set count to 1 and start the timer
WheelRightCount = 1
SetTimer, TimerWheelRight, 500 ; Wait for more presses within a 500 millisecond window.
return

TimerWheelRight:
SetTimer, TimerWheelRight, off
if WheelRightCount > 10
{
MouseClick, Middle
}

; Regardless of which action above was triggered, reset the count to
; prepare for the next series of presses:
WheelRightCount = 0
return

WheelLeft::return

#MaxHotkeysPerInterval 5000