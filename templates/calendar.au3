#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>

$sPath_ini = @ScriptDir & "\prefs.ini"


Opt("GUIOnEventMode", 1)

Global $calendarwindow = GUICreate("Календарь смен", 335, 245)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)


Global $ClndGUIstartX = 20
Global $ClndGUIxStretch = 25

Global $ClndGUIstartY = 35
Global $ClndGUIyStretch = 25

Global $ClndrFont = "Gregoria"
Global $ClndrTextSize = 9
Global $ClndrTextThickness = 400

Global $Weekday
Global $MyDate, $MyTime
Global $DateLabel

Global $StartDate = "2019/02/02 00:00:00"
Global $DaysAmount
Global $WorkDay = 2
Global $OffDay = 2

Global $NewDate

CalendarGUIinit()
CalendarInitDay()



While 1
	Sleep(100)
WEnd

Func CLOSEClicked()
	Exit
EndFunc






Func CalendarGUIinit()
	Global $ClndrMonthLabel = GUICtrlCreateLabel(DateToMonthShort(@MON), $ClndGUIstartX + $ClndGUIxStretch, $ClndGUIstartY - $ClndGUIyStretch+5, $ClndGUIxStretch*5, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetFont($ClndrMonthLabel, $ClndrTextSize+3, $ClndrTextThickness, 0)
	; Добавить запись почасовки в память
	
	Global $xoffset
	Global $calendxoffsetfirstitem = int($ClndrMonthLabel)-3
	Global $calendxoffsetidforfont
	Global $calendxoffsetcurrmonth = 42
	Global $calendxoffsettimetableid
	
	Global $SalaryDate
	Global $SalaryWeekday
	Global $DaysAmountSalary
	Global $ClndrHourSalary = 296
	Global $ClndrMonthSalaryAdvance
	Global $ClndrMonthSalaryRemains
	
	Global $ClndrWorkdayCount
	Global $ClndrOffdayCount
	Global $ClndrHourSalaryInputText
	Global $ClndrMonthSalaryDirty
	Global $ClndrMonthSalaryClean
	Global $ClndrAdvanceDays
	Global $ClndrIsHoliday
	

	Global $mon = GUICtrlCreateLabel("Пн", $ClndGUIstartX, 						  $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $tue = GUICtrlCreateLabel("Вт", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $wed = GUICtrlCreateLabel("Ср", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $thr = GUICtrlCreateLabel("Чт", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $frd = GUICtrlCreateLabel("Пт", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $sat = GUICtrlCreateLabel("Сб", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $sun = GUICtrlCreateLabel("Вс", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY, $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)


	Global $1 = GUICtrlCreateLabel ("x01", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $2 = GUICtrlCreateLabel ("x02", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $3 = GUICtrlCreateLabel ("x03", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $4 = GUICtrlCreateLabel ("x04", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $5 = GUICtrlCreateLabel ("x05", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $6 = GUICtrlCreateLabel ("x06", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $7 = GUICtrlCreateLabel ("x07", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)

	Global $8 = GUICtrlCreateLabel ("x08", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $9 = GUICtrlCreateLabel ("x09", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $10 = GUICtrlCreateLabel("x10", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $11 = GUICtrlCreateLabel("x11", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $12 = GUICtrlCreateLabel("x12", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $13 = GUICtrlCreateLabel("x13", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $14 = GUICtrlCreateLabel("x14", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)

	Global $15 = GUICtrlCreateLabel("x15", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $16 = GUICtrlCreateLabel("x16", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $17 = GUICtrlCreateLabel("x17", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $18 = GUICtrlCreateLabel("x18", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $19 = GUICtrlCreateLabel("x19", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $20 = GUICtrlCreateLabel("x20", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $21 = GUICtrlCreateLabel("x21", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)

	Global $22 = GUICtrlCreateLabel("x22", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $23 = GUICtrlCreateLabel("x23", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $24 = GUICtrlCreateLabel("x24", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $25 = GUICtrlCreateLabel("x25", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $26 = GUICtrlCreateLabel("x26", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $27 = GUICtrlCreateLabel("x27", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $28 = GUICtrlCreateLabel("x28", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)

	Global $29 = GUICtrlCreateLabel("x29", $ClndGUIstartX, 						  $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $30 = GUICtrlCreateLabel("x30", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $31 = GUICtrlCreateLabel("x31", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $32 = GUICtrlCreateLabel("x32", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $33 = GUICtrlCreateLabel("x33", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $34 = GUICtrlCreateLabel("x34", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $35 = GUICtrlCreateLabel("x35", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)

	Global $36 = GUICtrlCreateLabel("x36", $ClndGUIstartX, 					      $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $37 = GUICtrlCreateLabel("x37", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $38 = GUICtrlCreateLabel("x38", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $39 = GUICtrlCreateLabel("x39", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $40 = GUICtrlCreateLabel("x40", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $41 = GUICtrlCreateLabel("x41", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	Global $42 = GUICtrlCreateLabel("x42", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)


	Global $Bx01 = GUICtrlCreateLabel("", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx02 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx03 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx04 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx05 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx06 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx07 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*1), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx08 = GUICtrlCreateLabel("", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx09 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx10 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx11 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx12 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx13 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx14 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*2), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx15 = GUICtrlCreateLabel("", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx16 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx17 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx18 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx19 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx20 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx21 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*3), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx22 = GUICtrlCreateLabel("", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx23 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx24 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx25 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx26 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx27 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx28 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*4), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx29 = GUICtrlCreateLabel("", $ClndGUIstartX, 						 $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx30 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx31 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx32 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx33 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx34 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx35 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*5), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx36 = GUICtrlCreateLabel("", $ClndGUIstartX, 					     $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx37 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*1), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx38 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*2), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx39 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*3), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx40 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*4), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx41 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*5), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)
	Global $Bx42 = GUICtrlCreateLabel("", $ClndGUIstartX + ($ClndGUIxStretch*6), $ClndGUIstartY + ($ClndGUIyStretch*6), $ClndGUIxStretch, $ClndGUIyStretch, $SS_ETCHEDFRAME)

	Global $ClndrYearLabel = GUICtrlCreateLabel(@YEAR, $ClndGUIstartX + ($ClndGUIxStretch*5) + 8, $ClndGUIstartY + ($ClndGUIyStretch*7), $ClndGUIxStretch*2, $ClndGUIyStretch, $SS_CENTER + $SS_CENTERIMAGE)
	
	Global $ClndrWorkdayCountLabel = GUICtrlCreateLabel("Рабочих дней:", 				$ClndGUIstartX + ($ClndGUIxStretch*7) + 15, 	$ClndGUIstartY + ($ClndGUIyStretch*1), 		$ClndGUIxStretch*5)
	Global $ClndrOffdayCountLabel = GUICtrlCreateLabel("Выходных:", 					$ClndGUIstartX + ($ClndGUIxStretch*7) + 15, 	$ClndGUIstartY + ($ClndGUIyStretch*2) -5, 	$ClndGUIxStretch*5)
	Global $ClndrMonthSalaryRemainDaysLabel = GUICtrlCreateLabel("Дней до з/п:", 		$ClndGUIstartX + ($ClndGUIxStretch*7) + 15, 	$ClndGUIstartY + ($ClndGUIyStretch*3) -10, 	$ClndGUIxStretch*7)

	Global $ClndrSalaryButton = GUICtrlCreateButton("", 	  $ClndGUIstartX + ($ClndGUIxStretch*7) + 15, 	$ClndGUIstartY - $ClndGUIyStretch+10, 20, 20)
	Global $ClndMonthPrevBtn = GUICtrlCreateButton("<<",      $ClndGUIstartX, 						        $ClndGUIstartY - $ClndGUIyStretch+10, $ClndGUIxStretch-5, $ClndGUIyStretch-6, $SS_CENTER + $SS_CENTERIMAGE)
	Global $ClndMonthNextBtn = GUICtrlCreateButton(">>",      $ClndGUIstartX + ($ClndGUIxStretch * 6) + 5,  $ClndGUIstartY - $ClndGUIyStretch+10, $ClndGUIxStretch-5, $ClndGUIyStretch-6, $SS_CENTER + $SS_CENTERIMAGE)
	Global $ClndrToCurrMonthButton = GUICtrlCreateButton("\/",$ClndGUIstartX + ($ClndGUIxStretch * 8) + 15, $ClndGUIstartY - $ClndGUIyStretch+10, $ClndGUIxStretch-5, $ClndGUIyStretch-6, $SS_CENTER)

	GUICtrlSetOnEvent($ClndrSalaryButton, "SalaryOpen")
	GUICtrlSetOnEvent($ClndMonthPrevBtn, "CalendarMonthPrev")
	GUICtrlSetOnEvent($ClndMonthNextBtn, "CalendarMonthNext")
	GUICtrlSetOnEvent($ClndrToCurrMonthButton, "CalendarInitDay")
	
	GUICtrlSetFont($ClndrYearLabel, $ClndrTextSize+2, $ClndrTextThickness, 0)
	
	GUICtrlSetFont($ClndrWorkdayCountLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)
	GUICtrlSetFont($ClndrOffdayCountLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)
	GUICtrlSetFont($ClndrMonthSalaryRemainDaysLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)

	
	If @MDAY < 11 OR @MDAY > 26 Then	; Считаем до 11
		
		If @MDAY > 26 Then	; В другом месяце
		
			$SalaryDate = _DateAdd('M', +1, _NowCalcDate())
			_DateTimeSplit($SalaryDate, $MyDate, $MyTime)
			$SalaryDate = @YEAR & "/" & $MyDate[2] & "/11 00:00:00"
			
			_DateTimeSplit($SalaryDate, $MyDate, $MyTime)
			$SalaryWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])
			If $SalaryWeekday = 6 Then
				$SalaryDate = _DateAdd('D', -1, $SalaryDate)
			ElseIf $SalaryWeekday = 7 Then
				$SalaryDate = _DateAdd('D' -2, $SalaryDate)
			EndIf
			
			$DaysAmountSalary = _DateDiff('D', _NowCalcDate(), $SalaryDate)
			GUICtrlSetData ($ClndrMonthSalaryRemainDaysLabel, "Дней до з/п: " & $DaysAmountSalary)
			
		ElseIf @MDAY < 11 Then	; В этом месяце
		
			$SalaryDate = @YEAR & "/" & @MON & "/11 00:00:00"
			
			_DateTimeSplit($SalaryDate, $MyDate, $MyTime)
			$SalaryWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])
			If $SalaryWeekday = 6 Then
				$SalaryDate = _DateAdd('D', -1, $SalaryDate)
			ElseIf $SalaryWeekday = 7 Then
				$SalaryDate = _DateAdd('D', -2, $SalaryDate)
			EndIf
			
			$DaysAmountSalary = _DateDiff('D', _NowCalcDate(), $SalaryDate)
			GUICtrlSetData ($ClndrMonthSalaryRemainDaysLabel, "Дней до з/п: " & $DaysAmountSalary)
		EndIf
		
	ElseIf @MDAY > 11 OR @MDAY < 26 Then	; Считаем до 26
	
			$SalaryDate = @YEAR & "/" & @MON & "/26 00:00:00"
			
			_DateTimeSplit($SalaryDate, $MyDate, $MyTime)
			$SalaryWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])
			If $SalaryWeekday = 6 Then
				$SalaryDate = _DateAdd('D', -1, $SalaryDate)
			ElseIf $SalaryWeekday = 7 Then
				$SalaryDate = _DateAdd('D', -2, $SalaryDate)
			EndIf
			
			$DaysAmountSalary = _DateDiff('D', _NowCalcDate(), $SalaryDate)
			GUICtrlSetData ($ClndrMonthSalaryRemainDaysLabel, "Дней до аванса: " & $DaysAmountSalary)
		
	EndIf


	For $x = -5 To 42
		Global $calendxoffsetidforfont = $calendxoffsetfirstitem + $x + 10 ; Применение шрифта по умолчанию
		GUICtrlSetFont($calendxoffsetidforfont, $ClndrTextSize, $ClndrTextThickness, 0)
	Next

EndFunc



Func RenderCalendar()

	Global $MonthFirstWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])
	; Переход на первый день первой недели календаря
	$ClndOutputDate = _DateAdd('d', -$MonthFirstWeekday+1, $ClndOutputDate)
	_DateTimeSplit($ClndOutputDate, $MyDate, $MyTime)
	Global $CurrentWeekday = _DateToDayOfWeekISO ($MyDate[1], $MyDate[2], $MyDate[3])

	$ClndrWorkdayCount = 0
	$ClndrOffdayCount = 0
	$ClndrAdvanceDays = 0

	; Отрисовка следующих дней
	For $x = 0 To 42
		$InternalCycleDate = _DateAdd('d', +$x, $ClndOutputDate)
		_DateTimeSplit($InternalCycleDate, $MyDate, $MyTime)
		$xoffset = $calendxoffsetfirstitem + $x + 11 ; Смещение для правильного подключения к GUILabel (считаются по порядку)
		; Подключен к каждой ячейке календаря по очереди
		
		; Выделение дней текущего выбранного месяца
		If $MyDate[2] <> $ClndSelectedMonth Then
			GUICtrlSetColor($xoffset, 0x6a6a6a)
			GUICtrlSetFont($xoffset, $ClndrTextSize-2, $ClndrTextThickness, 0, $ClndrFont)
			GUICtrlSetStyle($xoffset+$calendxoffsetcurrmonth, $SS_ETCHEDFRAME)
		Else
			GUICtrlSetColor($xoffset, 0x000000)
			GUICtrlSetFont($xoffset, $ClndrTextSize+0.5, $ClndrTextThickness, 0, $ClndrFont)
			GUICtrlSetStyle($xoffset+$calendxoffsetcurrmonth, $SS_BLACKFRAME)
		EndIf
		
		If $MyDate[2] = 1 AND $MyDate[3] <= 8 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 2 AND $MyDate[3] = 23 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 3 AND $MyDate[3] = 8 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 5 AND $MyDate[3] = 1 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 5 AND $MyDate[3] = 1 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 5 AND $MyDate[3] = 9 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 6 AND $MyDate[3] = 12 Then
			$ClndrIsHoliday = 1
		ElseIf $MyDate[2] = 11 AND $MyDate[3] = 4 Then
			$ClndrIsHoliday = 1
		Else
			$ClndrIsHoliday = 0
		EndIf

		If $ClndrIsHoliday = 1 Then
			GUICtrlSetColor($xoffset, 0xf34723)
			;GUICtrlSetFont($xoffset, $ClndrTextSize+0.5, $ClndrTextThickness+200, 0, $ClndrFont)
		EndIf

		
		; Выделение сегодняшнего дня
		Local $TempDate, $TempTime
		_DateTimeSplit(_NowCalcDate(), $TempDate, $TempTime)
		
		If $MyDate[1] = $TempDate[1] AND $MyDate[2] = $TempDate[2] AND $MyDate[3] = $TempDate[3] Then
			GUICtrlSetColor($xoffset, 0x000000)
			GUICtrlSetFont($xoffset, $ClndrTextSize+0.5, $ClndrTextThickness+200, 0, $ClndrFont)
		EndIf


		; Отрисовка графика
		$DaysAmount = _DateDiff( 'D',$StartDate, $InternalCycleDate)
		
		If $InternalCycleDate >= $StartDate Then
			$calendxoffsettimetableid = $calendxoffsetfirstitem + $x + 11
			If $DaysAmount-(Int($DaysAmount/($WorkDay+$OffDay))* ($WorkDay+$OffDay)) <= ($WorkDay-1) Then
				GUICtrlSetBkColor ($calendxoffsettimetableid, 0xa2c4c9 )
				
				If $ClndrIsHoliday = 1 Then
					GUICtrlSetBkColor ($calendxoffsettimetableid, 0xA8D7BD );b6d7a8
				EndIf
				
				If $MyDate[2] = $ClndSelectedMonth Then
					$ClndrWorkdayCount = $ClndrWorkdayCount +1
					If $MyDate[3] <= 15 Then
						$ClndrAdvanceDays = $ClndrAdvanceDays +1
					EndIf
				EndIf
			Else
				GUICtrlSetBkColor ($calendxoffsettimetableid, 0xeeeeee )
				If $MyDate[2] = $ClndSelectedMonth Then
					$ClndrOffdayCount = $ClndrOffdayCount +1
				EndIf
			EndIf
		EndIf
		
		; Установка даты в ячейку
		GUICtrlSetData ($xoffset, $MyDate[3])
	Next
	
	; Установка стиля на место, это заплатка из-за смещения в цикле
	GUICtrlSetStyle($ClndrYearLabel, $GUI_SS_DEFAULT_LABEL)
	GUICtrlSetStyle($ClndrYearLabel, $SS_CENTER + $SS_CENTERIMAGE)
	
	GUICtrlSetData($ClndrWorkdayCountLabel, "Рабочих дней: " & $ClndrWorkdayCount)
	GUICtrlSetData($ClndrOffdayCountLabel, "Выходных: " & $ClndrOffdayCount)
EndFunc


Func DateToMonthShort($month)
    Switch $month
        Case 01
            Return "Январь"
        Case 02
            Return "Февраль"
        Case 03
            Return "Март"
        Case 04
            Return "Апрель"
        Case 05
            Return "Май"
        Case 06
            Return "Июнь"
        Case 07
            Return "Июль"
        Case 08
            Return "Август"
        Case 09
            Return "Сентябрь"
        Case 10
            Return "Октябрь"
        Case 11
            Return "Ноябрь"
        Case 12
            Return "Декабрь"
        Case Else
            Return ""
        EndSwitch
EndFunc



Func CalendarInitDay()
	GUICtrlSetState($ClndrToCurrMonthButton,$GUI_HIDE)
	GUICtrlSetState($ClndrMonthSalaryRemainDaysLabel,$GUI_SHOW)
	
	_DateTimeSplit(_NowCalcDate(), $MyDate, $MyTime)

	Global $ClndSelectedDate = _NowCalcDate()
	Global $ClndSelectedYear = $MyDate[1]
	Global $ClndSelectedMonth = $MyDate[2]
	Global $ClndSelectedDay = 1
	Global $ClndOutputDate

	Global $ClndOutputDate = $ClndSelectedYear & "/" & $ClndSelectedMonth & "/" & $ClndSelectedDay & " 00:00:00"
	_DateTimeSplit($ClndOutputDate, $MyDate, $MyTime)
	
	GUICtrlSetData ($ClndrMonthLabel, DateToMonthShort($ClndSelectedMonth))
	GUICtrlSetData ($ClndrYearLabel, $MyDate[1])
	
	RenderCalendar()
EndFunc


Func CalendarMonthPrev()
	GUICtrlSetState($ClndrToCurrMonthButton,$GUI_SHOW)
	GUICtrlSetState($ClndrMonthSalaryRemainDaysLabel,$GUI_HIDE)

	$ClndSelectedDate = _DateAdd('M', -1, $ClndSelectedDate)
	_DateTimeSplit($ClndSelectedDate, $MyDate, $MyTime)
	$ClndSelectedYear = $MyDate[1]
	$ClndSelectedMonth = $MyDate[2]
	$ClndSelectedDay = 1
	$ClndOutputDate = $ClndSelectedYear & "/" & $ClndSelectedMonth & "/" & $ClndSelectedDay & " 00:00:00"
	_DateTimeSplit($ClndOutputDate, $MyDate, $MyTime)
	
	GUICtrlSetData ($ClndrMonthLabel, DateToMonthShort($ClndSelectedMonth))
	GUICtrlSetData ($ClndrYearLabel, $MyDate[1])
	
	RenderCalendar()
EndFunc


Func CalendarMonthNext()
	GUICtrlSetState($ClndrToCurrMonthButton,$GUI_SHOW)
	GUICtrlSetState($ClndrMonthSalaryRemainDaysLabel,$GUI_HIDE)

	$ClndSelectedDate = _DateAdd('M', +1, $ClndSelectedDate)
	_DateTimeSplit($ClndSelectedDate, $MyDate, $MyTime)
	$ClndSelectedYear = $MyDate[1]
	$ClndSelectedMonth = $MyDate[2]
	$ClndSelectedDay = 1
	$ClndOutputDate = $ClndSelectedYear & "/" & $ClndSelectedMonth & "/" & $ClndSelectedDay & " 00:00:00"
	_DateTimeSplit($ClndOutputDate, $MyDate, $MyTime)
	
	GUICtrlSetData ($ClndrMonthLabel, DateToMonthShort($MyDate[2]))
	GUICtrlSetData ($ClndrYearLabel, $MyDate[1])
	
	RenderCalendar()
EndFunc




Func SalaryOpen()
	GUISetState(@SW_DISABLE, $calendarwindow)
	Global $salarywindow = GUICreate("Зарплата", 155, 155)
	GUISetOnEvent($GUI_EVENT_CLOSE, "SalaryClose")
	GUISetState(@SW_SHOW)
	
	Global $ClndrMonthSalaryDirtyLabel = GUICtrlCreateLabel("Грязными:", 20, 20, 150)
	Global $ClndrMonthSalaryCleanLabel = GUICtrlCreateLabel("Чистыми:", 20, 40, 150)
	Global $ClndrMonthSalaryAdvanceLabel = GUICtrlCreateLabel("В аванс:", 20, 65, 150)
	Global $ClndrMonthSalaryRemainsLabel = GUICtrlCreateLabel("В зарплату:", 20, 85, 150)
	
	Global $ClndrHourSalaryInput = GUICtrlCreateInput ("296", 35, 116, 40, 20, $ES_CENTER)
	Global $ClndrHourSalaryInputNote = GUICtrlCreateLabel("в час", 80, 119, 30)
	Global $ClndrHourSalaryBtnOk = GUICtrlCreateButton("ок", 110, 116, 20, 20)
	GUICtrlSetOnEvent($ClndrHourSalaryBtnOk, "SalaryHourOK")

	$ClndrHourSalary = IniRead($sPath_ini, "CalendarDATA", "$ClndrHourSalary", "296")
	GUICtrlSetData($ClndrHourSalaryInput, $ClndrHourSalary)
	
	
	$ClndrMonthSalaryDirty = int($ClndrHourSalary*11*$ClndrWorkdayCount)
	$ClndrMonthSalaryClean = int($ClndrHourSalary*11*$ClndrWorkdayCount*0.87)
	$ClndrMonthSalaryAdvance = int(1200 * $ClndrAdvanceDays * 0.87)
	$ClndrMonthSalaryRemains = $ClndrMonthSalaryClean - $ClndrMonthSalaryAdvance
	
	GUICtrlSetData($ClndrMonthSalaryDirtyLabel, "Грязными: " & $ClndrMonthSalaryDirty)
	GUICtrlSetData($ClndrMonthSalaryCleanLabel, "Чистыми: " & $ClndrMonthSalaryClean)
	GUICtrlSetData($ClndrMonthSalaryAdvanceLabel, "В аванс: " & $ClndrMonthSalaryAdvance)
	GUICtrlSetData($ClndrMonthSalaryRemainsLabel, "В зарплату: " & $ClndrMonthSalaryRemains)
	
	GUICtrlSetFont($ClndrMonthSalaryDirtyLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)
	GUICtrlSetFont($ClndrMonthSalaryCleanLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)
	GUICtrlSetFont($ClndrMonthSalaryAdvanceLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)
	GUICtrlSetFont($ClndrMonthSalaryRemainsLabel, $ClndrTextSize+1, $ClndrTextThickness, 0)
EndFunc


Func SalaryHourOK()
	$ClndrHourSalary = GUICtrlRead($ClndrHourSalaryInput)
	IniWrite($sPath_ini, "CalendarDATA", "$ClndrHourSalary", $ClndrHourSalary)

	SalaryClose()
	Sleep(50)
	SalaryOpen()
EndFunc


Func SalaryClose()
   GUISetState(@SW_ENABLE, $calendarwindow)
   GUIDelete($salarywindow)
   $RefreshTimer = TimerInit()
EndFunc





#comments-start

	MsgBox(4096, "", $x)

	MsgBox(4096, "", $MyDate[1] & "/" & $MyDate[2] & "/" & $MyDate[3])

	MsgBox(4096, "", "Сегодня : " & _DateDayOfWeek($iWeekDay))

	; Получит полное название дня недели
	$sLongDayName = _DateDayOfWeek( @WDAY )

	; Получит сокращенное название дня недели
	$sShortDayName = _DateDayOfWeek( @WDAY, 1 )

	MsgBox( 4096, "День недели", "Сегодня : " & $sLongDayName & " (" & $sShortDayName & ")" )

	; Calculated eventlogdate which returns second since 1970/01/01 00:00:00
	$sNewDate = _DateAdd('s', 1087497645, "1970/01/01 00:00:00")
	MsgBox($MB_SYSTEMMODAL, "", "Date: " & $sNewDate)

	_DateTimeSplit("2005/01/01 14:30", $MyDate, $MyTime)

	For $x = 1 To $MyDate[0]
		MsgBox(4096, $x, $MyDate[$x])
	Next
	For $x = 1 To $MyTime[0]
		MsgBox(4096, $x, $MyTime[$x])
	Next

	Global $Weekday = _DateToDayOfWeekISO (@YEAR, @MON, @MDAY)

#comments-end
