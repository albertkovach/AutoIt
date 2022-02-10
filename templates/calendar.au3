#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $mainwindow = GUICreate("FLAME.exe", 300, 300)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)

   Global $HOMElabelbtn = GUICtrlCreateButton("HOME", 229, 10, 55, 20)

Global $ClndGUIstartX = 30
Global $ClndGUIxStretch = 23

Global $ClndGUIstartY = 60
Global $ClndGUIyStretch = 23

    Local $font
    ;$font = "Comic Sans MS"


Global $mon = GUICtrlCreateLabel("Пн", $ClndGUIstartX, 						  $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)
Global $tue = GUICtrlCreateLabel("Вт", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)
Global $wed = GUICtrlCreateLabel("Ср", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)
Global $thr = GUICtrlCreateLabel("Чт", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)
Global $frd = GUICtrlCreateLabel("Пт", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)
Global $sat = GUICtrlCreateLabel("Сб", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)
Global $sun = GUICtrlCreateLabel("Вс", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch)

Global $1 = GUICtrlCreateLabel("x01", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)
Global $2 = GUICtrlCreateLabel("x02", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)
Global $3 = GUICtrlCreateLabel("x03", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)
Global $4 = GUICtrlCreateLabel("x04", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)
Global $5 = GUICtrlCreateLabel("x05", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)
Global $6 = GUICtrlCreateLabel("x06", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)
Global $7 = GUICtrlCreateLabel("x07", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch)

Global $8 = GUICtrlCreateLabel("x08", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)
Global $9 = GUICtrlCreateLabel("x09", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)
Global $10 = GUICtrlCreateLabel("x10", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)
Global $11 = GUICtrlCreateLabel("x11", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)
Global $12 = GUICtrlCreateLabel("x12", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)
Global $13 = GUICtrlCreateLabel("x13", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)
Global $14 = GUICtrlCreateLabel("x14", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch)

Global $15 = GUICtrlCreateLabel("x15", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)
Global $16 = GUICtrlCreateLabel("x16", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)
Global $17 = GUICtrlCreateLabel("x17", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)
Global $18 = GUICtrlCreateLabel("x18", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)
Global $19 = GUICtrlCreateLabel("x19", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)
Global $20 = GUICtrlCreateLabel("x20", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)
Global $21 = GUICtrlCreateLabel("x21", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch)

Global $22 = GUICtrlCreateLabel("x22", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)
Global $23 = GUICtrlCreateLabel("x23", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)
Global $24 = GUICtrlCreateLabel("x24", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)
Global $25 = GUICtrlCreateLabel("x25", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)
Global $26 = GUICtrlCreateLabel("x26", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)
Global $27 = GUICtrlCreateLabel("x27", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)
Global $28 = GUICtrlCreateLabel("x28", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch)

Global $29 = GUICtrlCreateLabel("x29", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)
Global $30 = GUICtrlCreateLabel("x30", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)
Global $31 = GUICtrlCreateLabel("x31", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)
Global $32 = GUICtrlCreateLabel("x32", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)
Global $33 = GUICtrlCreateLabel("x33", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)
Global $34 = GUICtrlCreateLabel("x34", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)
Global $35 = GUICtrlCreateLabel("x35", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, 20)

Global $36 = GUICtrlCreateLabel("x36", $ClndGUIstartX, 								    $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)
Global $37 = GUICtrlCreateLabel("x37", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)
Global $38 = GUICtrlCreateLabel("x38", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)
Global $39 = GUICtrlCreateLabel("x39", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)
Global $40 = GUICtrlCreateLabel("x40", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)
Global $41 = GUICtrlCreateLabel("x41", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)
Global $42 = GUICtrlCreateLabel("x42", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, 20)

For $x = -1 To 49
	GUICtrlSetFont($x, 9, 700, 0)
Next






Global $Weekday
Global $MyDate, $MyTime
Global $DateLabel




; Переход на первый день месяца, вычисление дня недели этого дня
$NewDate = _DateAdd('d', -@MDAY+1, _NowCalcDate())
_DateTimeSplit($NewDate, $MyDate, $MyTime)
Global $MonthFirstWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])


; Переход на первый день первой недели календаря
$NewDate = _DateAdd('d', -$MonthFirstWeekday+1, $NewDate)
_DateTimeSplit($NewDate, $MyDate, $MyTime)
Global $CurrentWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])
;MsgBox(4096, "MyDate " & $MyDate[3], "CurrentWeekday " & $CurrentWeekday)


; Отрисовка следующих дней
For $x = 0 To 42
	$NewDate1 = _DateAdd('d', +$x, $NewDate)
	_DateTimeSplit($NewDate1, $MyDate, $MyTime)
	Global $xoffset = $x + 11 ; Смещение для правильного подключения к GUILabel (считаются по порядку)
	GUICtrlSetData ("$" + $xoffset, $MyDate[3])
	
	;MsgBox(4096, "MyDate " & $MyDate[3], "x " & $x & ", xoffset " & $xoffset)
Next




	
While 1
	Sleep(100)
WEnd

Func CLOSEClicked()
	Exit
EndFunc





#comments-start

MsgBox(4096, "", "Сегодня : " & _DateDayOfWeek($iWeekDay))

; Получит полное название дня недели
$sLongDayName = _DateDayOfWeek( @WDAY )

; Получит сокращенное название дня недели
$sShortDayName = _DateDayOfWeek( @WDAY, 1 )

MsgBox( 4096, "День недели", "Сегодня : " & $sLongDayName & " (" & $sShortDayName & ")" )

; Subtract 2 weeks from today
$sNewDate = _DateAdd('w', -2, _NowCalcDate())
MsgBox($MB_SYSTEMMODAL, "", "Today minus 2 weeks: " & $sNewDate)

; Add 15 minutes to current time
$sNewDate = _DateAdd('n', 15, _NowCalc())
MsgBox($MB_SYSTEMMODAL, "", "Current time +15 minutes: " & $sNewDate)

; Calculated eventlogdate which returns second since 1970/01/01 00:00:00
$sNewDate = _DateAdd('s', 1087497645, "1970/01/01 00:00:00")
MsgBox($MB_SYSTEMMODAL, "", "Date: " & $sNewDate)



Global $MyDate, $MyTime
_DateTimeSplit("2005/01/01 14:30", $MyDate, $MyTime)

For $x = 1 To $MyDate[0]
    MsgBox(4096, $x, $MyDate[$x])
Next
For $x = 1 To $MyTime[0]
    MsgBox(4096, $x, $MyTime[$x])
Next


$iWeekday = _DateToDayOfWeek (@YEAR, @MON, @MDAY)
MsgBox(4096, "", "Номер дня недели сегодня: " & $iWeekDay)
Global $sNewDate = _DateAdd('d', 5, _NowCalcDate())
MsgBox($MB_SYSTEMMODAL, "", "Today + 5 days: " & $sNewDate)


If $Weekday >= 1 AND @MDAY >= 7 Then
	; Вторая неделя месяца. Вычисление прошлой недели
	PreviousWeekRefresh()
Else
	$NewDate = _DateAdd('d', $Weekday-2, _NowCalcDate())
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($21, $MyDate[3])
	
EndIf


Func PreviousWeekRefresh()
	$NewDate = _DateAdd('d', $Weekday-2, _NowCalcDate())
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($17, $MyDate[3])
	
	$NewDate = _DateAdd('d', -1, $NewDate)
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($16, $MyDate[3])
	
	$NewDate = _DateAdd('d', -1, $NewDate)
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($15, $MyDate[3])
	
	$NewDate = _DateAdd('d', -1, $NewDate)
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($14, $MyDate[3])
	
	$NewDate = _DateAdd('d', -1, $NewDate)
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($13, $MyDate[3])
	
	$NewDate = _DateAdd('d', -1, $NewDate)
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($12, $MyDate[3])
	
	$NewDate = _DateAdd('d', -1, $NewDate)
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ($11, $MyDate[3])
EndFunc

Global $Weekday = _DateToDayOfWeekISO (@YEAR, @MON, @MDAY)


; Проверка на какой строчке будет первый день
If $Weekday >= 1 AND @MDAY >= 7 Then
	; Вторая неделя месяца. Вычисление прошлой недели
Else

EndIf





; Отрисовка предыдущих дней
For $x = 1 To $MonthFirstWeekday
	$NewDate = _DateAdd('d', - $x, _NowCalcDate())
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ("$" + $x, $MyDate[3])
Next


; Отрисовка следующих дней
For $x = $MonthFirstWeekday-1 To 42-$MonthFirstWeekday
	$NewDate = _DateAdd('d', +$x, _NowCalcDate())
	_DateTimeSplit($NewDate, $MyDate, $MyTime)
	GUICtrlSetData ("$" + $x, $MyDate[3])
Next


$x = $MonthFirstWeekday * 1
$DateLabel = "$" + $MonthFirstWeekday

GUICtrlSetData ($DateLabel, $MyDate[3])


MsgBox(4096, $MyDate[3], $MonthFirstWeekday)




#comments-end
