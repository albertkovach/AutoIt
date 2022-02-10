#include <Array.au3>
#include <Excel.au3>
#include <ExcelConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
$mainwindow = GUICreate("watchdog.exe", 320, 110)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
Global $Label1 = GUICtrlCreateLabel("Держит в памяти последнего контрагента", 15, 15)
Global $Label2 = GUICtrlCreateLabel("Счетчик ошибок: ", 15, 35)
Global $Label3 = GUICtrlCreateLabel("0", 105, 35)
Global $Label4 = GUICtrlCreateLabel("Время ошибки", 15, 55)
Global $StartBtn = GUICtrlCreateButton("Запуск", 15, 80, 80, 20)
$StopChck = GUICtrlCreateCheckbox("Остановка", 110, 78, 85, 25)
$ShowAllLogData = GUICtrlCreateCheckbox("Режим отладки", 200, 78, 150, 25)
$RepairData = GUICtrlCreateCheckbox("Исправление", 200, 58, 85, 25)
GUICtrlSetOnEvent($StartBtn, "Start")

Local $LogIsChecked
Local $RepairDataIsChecked

Local $hWnd = WinGetHandle("ORBita - [Индексирование]", "")
Local $EditFieldNum = "WindowsForms10.EDIT.app.0.141b42a_r7_ad15"
Local $EditFieldKontr = "Edit4"
Local $EditFieldINN = "Edit5"

Local $Num
Local $Kontr
Local $INN

Local $SavedNum
Local $SavedKontr

Local $ErrorCount = 0
Local $Started = false

GUICtrlSetState ( $StopChck, $GUI_HIDE )

Func Start()
   $Started = True
   GUICtrlSetState ( $StopChck, $GUI_SHOW )
   GUICtrlSetState ( $StartBtn, $GUI_HIDE )
   If $LogIsChecked Then
	  MsgBox($MB_SYSTEMMODAL, "Watch Dog", "Запуск")
   EndIf
   Main()
EndFunc


Func Main()
   While $Started
	  Do
		 $Num = ControlGetText($hWnd, "", $EditFieldNum)
		 $Kontr = ControlGetText($hWnd, "", $EditFieldKontr)
		 $INN = ControlGetText($hWnd, "", $EditFieldINN)
		 Sleep(250)
		 CheckboxRead()
	  Until $Num <> "" AND $Kontr <> "" AND $INN <> ""

	  If $LogIsChecked Then
		 MsgBox($MB_SYSTEMMODAL, "Watch Dog", "Заполняется ИНН, сохраняю контрагента. Жду ввода нового документа")
	  EndIf

	  $SavedKontr = ControlGetText($hWnd, "", $EditFieldKontr)
	  $SavedNum = ControlGetText($hWnd, "", $EditFieldNum)

	  Do
		 $Num = ControlGetText($hWnd, "", $EditFieldNum)
		 Sleep(1000)
		 CheckboxRead()
	  Until $Num <> $SavedNum

	  If $LogIsChecked Then
		  MsgBox($MB_SYSTEMMODAL, "Watch Dog", "Сменился ШК. Вижу новое поле. Проверяю, совпадает ли контрагент")
	  EndIf

	  $Kontr = ControlGetText($hWnd, "", $EditFieldKontr)

	  If $Kontr <> $SavedKontr Then
		 If $RepairDataIsChecked == false Then
			MsgBox($MB_SYSTEMMODAL, "Watch Dog", "Не совпадает контрагент. Увеличиваю счетчик ошибок")
		 EndIf

		 $ErrorCount = $ErrorCount + 1
		 Local $ErrorTime = _NowTime()
		 GUICtrlSetData($Label3, $ErrorCount)
		 GUICtrlSetData($Label4, $ErrorTime)

		 If $LogIsChecked Then
			 MsgBox($MB_SYSTEMMODAL, "Watch Dog", "Возвращаю контрагента на место")
		 EndIf

		 If $RepairDataIsChecked == true Then
			ControlSetText($hWnd, "", $EditFieldKontr, $SavedKontr)
		 EndIf
	  EndIf

	  If $Kontr == $SavedKontr Then
		 If $LogIsChecked Then
			 MsgBox($MB_SYSTEMMODAL, "Watch Dog", "Все в порядке")
		  EndIf
	   EndIf

	  CheckboxRead()

   WEnd
EndFunc

Func CheckboxRead()
   $LogIsChecked = GuiCtrlRead($ShowAllLogData) = $GUI_CHECKED
   $RepairDataIsChecked = GuiCtrlRead($RepairData) = $GUI_CHECKED
EndFunc

Func CLOSEClicked()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd

