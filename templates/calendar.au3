#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $mainwindow = GUICreate("FLAME.exe", 200, 200)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)


Global $1 = GUICtrlCreateLabel("x01", 15, 30, 20, 20)
Global $2 = GUICtrlCreateLabel("x02", 35, 30, 20, 20)
Global $3 = GUICtrlCreateLabel("x03", 55, 30, 20, 20)
Global $4 = GUICtrlCreateLabel("x04", 75, 30, 20, 20)
Global $5 = GUICtrlCreateLabel("x05", 95, 30, 20, 20)
Global $6 = GUICtrlCreateLabel("x06", 115, 30, 20, 20)
Global $7 = GUICtrlCreateLabel("x07", 135, 30, 20, 20)

Global $8 = GUICtrlCreateLabel("x08", 15, 50, 20, 20)
Global $9 = GUICtrlCreateLabel("x09", 35, 50, 20, 20)
Global $10 = GUICtrlCreateLabel("x10", 55, 50, 20, 20)
Global $11 = GUICtrlCreateLabel("x11", 75, 50, 20, 20)
Global $12 = GUICtrlCreateLabel("x12", 95, 50, 20, 20)
Global $13 = GUICtrlCreateLabel("x13", 115, 50, 20, 20)
Global $14 = GUICtrlCreateLabel("x14", 135, 50, 20, 20)

Global $15 = GUICtrlCreateLabel("x15", 15, 70, 20, 20)
Global $16 = GUICtrlCreateLabel("x16", 35, 70, 20, 20)
Global $17 = GUICtrlCreateLabel("x17", 55, 70, 20, 20)
Global $18 = GUICtrlCreateLabel("x18", 75, 70, 20, 20)
Global $19 = GUICtrlCreateLabel("x19", 95, 70, 20, 20)
Global $20 = GUICtrlCreateLabel("x20", 115, 70, 20, 20)
Global $21 = GUICtrlCreateLabel("x21", 135, 70, 20, 20)

Global $22 = GUICtrlCreateLabel("x22", 15, 90, 20, 20)
Global $23 = GUICtrlCreateLabel("x23", 35, 90, 20, 20)
Global $24 = GUICtrlCreateLabel("x24", 55, 90, 20, 20)
Global $25 = GUICtrlCreateLabel("x25", 75, 90, 20, 20)
Global $26 = GUICtrlCreateLabel("x26", 95, 90, 20, 20)
Global $27 = GUICtrlCreateLabel("x27", 115, 90, 20, 20)
Global $28 = GUICtrlCreateLabel("x28", 135, 90, 20, 20)

Global $29 = GUICtrlCreateLabel("x29", 15, 110, 20, 20)
Global $30 = GUICtrlCreateLabel("x30", 35, 110, 20, 20)
Global $31 = GUICtrlCreateLabel("x31", 55, 110, 20, 20)
Global $32 = GUICtrlCreateLabel("x32", 75, 110, 20, 20)
Global $33 = GUICtrlCreateLabel("x33", 95, 110, 20, 20)
Global $34 = GUICtrlCreateLabel("x34", 115, 110, 20, 20)
Global $35 = GUICtrlCreateLabel("x35", 135, 110, 20, 20)

Global $36 = GUICtrlCreateLabel("x36", 15, 130, 20, 20)
Global $37 = GUICtrlCreateLabel("x37", 35, 130, 20, 20)
Global $38 = GUICtrlCreateLabel("x38", 55, 130, 20, 20)
Global $39 = GUICtrlCreateLabel("x39", 75, 130, 20, 20)
Global $40 = GUICtrlCreateLabel("x40", 95, 130, 20, 20)
Global $41 = GUICtrlCreateLabel("x41", 115, 130, 20, 20)
Global $42 = GUICtrlCreateLabel("x42", 135, 130, 20, 20)


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
MsgBox(4096, "MyDate " & $MyDate[3], "CurrentWeekday " & $CurrentWeekday)


; Отрисовка следующих дней
For $x = 0 To 42
	$NewDate1 = _DateAdd('d', +$x, $NewDate)
	_DateTimeSplit($NewDate1, $MyDate, $MyTime)
	Global $xoffset = $x + 3 ; Смещение для правильного подключения к GUILabel
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
