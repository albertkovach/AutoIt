#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

$sPath_ini = @ScriptDir & "\prefs.ini"


Global $INSERTeditNametext
Global $INSERTeditDatetext
Global $INSERTeditNumtext

Global $HOMEeditNametext
Global $HOMEeditDatetext
Global $HOMEeditNumtext

Global $PGUPeditNametext
Global $PGUPeditDatetext
Global $PGUPeditNumtext

Global $ENDeditNametext
Global $ENDeditDatetext
Global $ENDeditNumtext

Global $PGDNeditNametext
Global $PGDNeditDatetext
Global $PGDNeditNumtext
	

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
$mainwindow = GUICreate("FLAME АСВ.exe", 665, 370)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)

Initialize()
RefreshAndSave()



Func Initialize()
	Global $INSERTlabel = GUICtrlCreateLabel("INSERT", 15, 10)
	Global $INSERTeditName = GUICtrlCreateInput ( "", 15, 40, 200)
	Global $INSERTeditDate = GUICtrlCreateInput ( "", 15, 70, 200)
	Global $INSERTeditNum = GUICtrlCreateInput ( "", 15, 100, 200)

	Global $HOMElabel = GUICtrlCreateLabel("HOME", 230, 10)
	Global $HOMEeditName = GUICtrlCreateInput ( "", 230, 40, 200)
	Global $HOMEeditDate = GUICtrlCreateInput ( "", 230, 70, 200)
	Global $HOMEeditNum = GUICtrlCreateInput ( "", 230, 100, 200)

	Global $PGUPlabel = GUICtrlCreateLabel("PGUP", 445, 10)
	Global $PGUPeditName = GUICtrlCreateInput ( "", 445, 40, 200)
	Global $PGUPeditDate = GUICtrlCreateInput ( "", 445, 70, 200)
	Global $PGUPeditNum = GUICtrlCreateInput ( "", 445, 100, 200)

	Global $LabelName = GUICtrlCreateLabel("Заголовок", 150, 200)
	Global $LabelDate = GUICtrlCreateLabel("Крайние даты", 150, 230)
	Global $LabelNum = GUICtrlCreateLabel("Номер описи", 150, 260)

	Global $LabelSP1 = GUICtrlCreateLabel("Пустое поле затирает текст", 25, 310)
	Global $LabelSP2 = GUICtrlCreateLabel("Оставить подтянувшийся текст в поле ввода: введите ==", 25, 330)

	Global $ENDlabel = GUICtrlCreateLabel("END", 230, 180)
	Global $ENDeditName = GUICtrlCreateInput ( "", 230, 200, 200)
	Global $ENDeditDate = GUICtrlCreateInput ( "", 230, 230, 200)
	Global $ENDeditNum = GUICtrlCreateInput ( "", 230, 260, 200)

	Global $PGDNlabel = GUICtrlCreateLabel("PGDN", 445, 180)
	Global $PGDNeditName = GUICtrlCreateInput ( "", 445, 200, 200)
	Global $PGDNeditDate = GUICtrlCreateInput ( "", 445, 230, 200)
	Global $PGDNeditNum = GUICtrlCreateInput ( "", 445, 260, 200)


	Global $REFRESHbtn = GUICtrlCreateButton("Запомнить", 15, 150, 90, 30)
	GUICtrlSetOnEvent($REFRESHbtn, "RefreshAndSave")


	HotKeySet("{INSERT}", "INSERT")

	HotKeySet("{END}", "END")
	HotKeySet("{PGDN}", "PGDN")

	HotKeySet("{HOME}", "HOME")
	HotKeySet("{PGUP}", "PGUP")
	
	
	$INSERTeditNametext = IniRead($sPath_ini, "FlameACBDATA", "$INSERTeditNametext", "")
	$INSERTeditDatetext = IniRead($sPath_ini, "FlameACBDATA", "$INSERTeditDatetext", "")
	$INSERTeditNumtext = IniRead($sPath_ini, "FlameACBDATA", "$INSERTeditNumtext", "")
   
	$HOMEeditNametext = IniRead($sPath_ini, "FlameACBDATA", "$HOMEeditNametext", "")
	$HOMEeditDatetext = IniRead($sPath_ini, "FlameACBDATA", "$HOMEeditDatetext", "")
	$HOMEeditNumtext = IniRead($sPath_ini, "FlameACBDATA", "$HOMEeditNumtext", "")

	$PGUPeditNametext = IniRead($sPath_ini, "FlameACBDATA", "$PGUPeditNametext", "")
	$PGUPeditDatetext = IniRead($sPath_ini, "FlameACBDATA", "$PGUPeditDatetext", "")
	$PGUPeditNumtext = IniRead($sPath_ini, "FlameACBDATA", "$PGUPeditNumtext", "")

	$ENDeditNametext = IniRead($sPath_ini, "FlameACBDATA", "$ENDeditNametext", "")
	$ENDeditDatetext = IniRead($sPath_ini, "FlameACBDATA", "$ENDeditDatetext", "")
	$ENDeditNumtext = IniRead($sPath_ini, "FlameACBDATA", "$ENDeditNumtext", "")
	
	$PGDNeditNametext = IniRead($sPath_ini, "FlameACBDATA", "$PGDNeditNametext", "")
	$PGDNeditDatetext = IniRead($sPath_ini, "FlameACBDATA", "$PGDNeditDatetext", "")
	$PGDNeditNumtext = IniRead($sPath_ini, "FlameACBDATA", "$PGDNeditNumtext", "")
	
	GUICtrlSetData ($INSERTeditName, $INSERTeditNametext)
	GUICtrlSetData ($INSERTeditDate, $INSERTeditDatetext)
	GUICtrlSetData ($INSERTeditNum, $INSERTeditNumtext)
	
	GUICtrlSetData ($HOMEeditName, $HOMEeditNametext)
	GUICtrlSetData ($HOMEeditDate, $HOMEeditDatetext)
	GUICtrlSetData ($HOMEeditNum, $HOMEeditNumtext)
	
	GUICtrlSetData ($PGUPeditName, $PGUPeditNametext)
	GUICtrlSetData ($PGUPeditDate, $PGUPeditDatetext)
	GUICtrlSetData ($PGUPeditNum, $PGUPeditNumtext)
	
	GUICtrlSetData ($ENDeditName, $ENDeditNametext)
	GUICtrlSetData ($ENDeditDate, $ENDeditDatetext)
	GUICtrlSetData ($ENDeditNum, $ENDeditNumtext)
	
	GUICtrlSetData ($PGDNeditName, $PGDNeditNametext)
	GUICtrlSetData ($PGDNeditDate, $PGDNeditDatetext)
	GUICtrlSetData ($PGDNeditNum, $PGDNeditNumtext)
	
EndFunc




Func RefreshAndSave()
	$INSERTeditNametext = GUICtrlRead($INSERTeditName)
	$INSERTeditDatetext = GUICtrlRead($INSERTeditDate)
	$INSERTeditNumtext = GUICtrlRead($INSERTeditNum)

	$HOMEeditNametext = GUICtrlRead($HOMEeditName)
	$HOMEeditDatetext = GUICtrlRead($HOMEeditDate)
	$HOMEeditNumtext = GUICtrlRead($HOMEeditNum)

	$PGUPeditNametext = GUICtrlRead($PGUPeditName)
	$PGUPeditDatetext = GUICtrlRead($PGUPeditDate)
	$PGUPeditNumtext = GUICtrlRead($PGUPeditNum)

	$ENDeditNametext = GUICtrlRead($ENDeditName)
	$ENDeditDatetext = GUICtrlRead($ENDeditDate)
	$ENDeditNumtext = GUICtrlRead($ENDeditNum)

	$PGDNeditNametext = GUICtrlRead($PGDNeditName)
	$PGDNeditDatetext = GUICtrlRead($PGDNeditDate)
	$PGDNeditNumtext = GUICtrlRead($PGDNeditNum)


	IniWrite($sPath_ini, "FlameACBDATA", "$INSERTeditNametext", $INSERTeditNametext)
	IniWrite($sPath_ini, "FlameACBDATA", "$INSERTeditDatetext", $INSERTeditDatetext)
	IniWrite($sPath_ini, "FlameACBDATA", "$INSERTeditNumtext", $INSERTeditNumtext)
	
	IniWrite($sPath_ini, "FlameACBDATA", "$HOMEeditNametext", $HOMEeditNametext)
	IniWrite($sPath_ini, "FlameACBDATA", "$HOMEeditDatetext", $HOMEeditDatetext)
	IniWrite($sPath_ini, "FlameACBDATA", "$HOMEeditNumtext", $HOMEeditNumtext)
	
	IniWrite($sPath_ini, "FlameACBDATA", "$PGUPeditNametext", $PGUPeditNametext)
	IniWrite($sPath_ini, "FlameACBDATA", "$PGUPeditDatetext", $PGUPeditDatetext)
	IniWrite($sPath_ini, "FlameACBDATA", "$PGUPeditNumtext", $PGUPeditNumtext)
	
	IniWrite($sPath_ini, "FlameACBDATA", "$ENDeditNametext", $ENDeditNametext)
	IniWrite($sPath_ini, "FlameACBDATA", "$ENDeditDatetext", $ENDeditDatetext)
	IniWrite($sPath_ini, "FlameACBDATA", "$ENDeditNumtext", $ENDeditNumtext)
	
	IniWrite($sPath_ini, "FlameACBDATA", "$PGDNeditNametext", $PGDNeditNametext)
	IniWrite($sPath_ini, "FlameACBDATA", "$PGDNeditDatetext", $PGDNeditDatetext)
	IniWrite($sPath_ini, "FlameACBDATA", "$PGDNeditNumtext", $PGDNeditNumtext)

EndFunc




Func CLOSEClicked()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd




Func INSERT()
		If $INSERTeditNametext <> "==" Then
			Send("{DEL}")
			Send($INSERTeditNametext) ; заголовок
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $INSERTeditDatetext <> "==" Then
			Send("{DEL}")
			Send($INSERTeditDatetext) ; крайние даты
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $INSERTeditNumtext <> "==" Then
			Send("{DEL}")
			Send($INSERTeditNumtext) ; номер описи
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
EndFunc


Func HOME()
		If $HOMEeditNametext <> "==" Then
			Send("{DEL}")
			Send($HOMEeditNametext) ; заголовок
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $HOMEeditDatetext <> "==" Then
			Send("{DEL}")
			Send($HOMEeditDatetext) ; крайние даты
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $HOMEeditNumtext <> "==" Then
			Send("{DEL}")
			Send($HOMEeditNumtext) ; номер описи
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
EndFunc


Func PGUP()
		If $PGUPeditNametext <> "==" Then
			Send("{DEL}")
			Send($PGUPeditNametext) ; заголовок
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $PGUPeditDatetext <> "==" Then
			Send("{DEL}")
			Send($PGUPeditDatetext) ; крайние даты
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $PGUPeditNumtext <> "==" Then
			Send("{DEL}")
			Send($PGUPeditNumtext) ; номер описи
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
EndFunc


Func END()
		If $ENDeditNametext <> "==" Then
			Send("{DEL}")
			Send($ENDeditNametext) ; заголовок
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $ENDeditDatetext <> "==" Then
			Send("{DEL}")
			Send($ENDeditDatetext) ; крайние даты
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $ENDeditNumtext <> "==" Then
			Send("{DEL}")
			Send($ENDeditNumtext) ; номер описи
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
EndFunc


Func PGDN()
		If $PGDNeditNametext <> "==" Then
			Send("{DEL}")
			Send($PGDNeditNametext) ; заголовок
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $PGDNeditDatetext <> "==" Then
			Send("{DEL}")
			Send($PGDNeditDatetext) ; крайние даты
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
		If $PGDNeditNumtext <> "==" Then
			Send("{DEL}")
			Send($PGDNeditNumtext) ; номер описи
			Send("  ")
			Send("{BACKSPACE}")
			Send("{BACKSPACE}")
		EndIf
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
EndFunc




