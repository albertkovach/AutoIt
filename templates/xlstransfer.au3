#include <Array.au3>
#include <Excel.au3>
#include <ExcelConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
$mainwindow = GUICreate("xlsTransfer.exe", 300, 120)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
Global $Label1 = GUICtrlCreateLabel("Выдача по столбцам A - H", 80, 15)
Global $Label2 = GUICtrlCreateLabel("Следующий адрес: ", 15, 35)
Global $Label3 = GUICtrlCreateLabel("Следующие данные: ", 15, 55)
Global $Label4 = GUICtrlCreateLabel("Расположение таблицы: \Extras\transfer.xlsx", 50, 75)
$ShowAllLogData = GUICtrlCreateCheckbox("Режим отладки", 180, 90, 150, 25)

Local $LogIsChecked

Local $oExcel = _Excel_Open()
Local $WorkbookPath = @ScriptDir & "\Extras\transfer.xlsx"
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel", "Error creating the Excel application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
Local $Workbook = _Excel_BookOpen($oExcel, $WorkbookPath)
$Workbook = _Excel_BookAttach($WorkbookPath)

If @error Then
    MsgBox($MB_SYSTEMMODAL, "Excel", "Error opening workbook '" & @ScriptDir & "\Extras\parsing_table.xls'." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
    _Excel_Close($oExcel)
    Exit
EndIf


Local $hWnd = WinGetHandle("[CLASS:WindowsForms10.Window.8.app.0.21093c0_r7_ad1]", "")
Local $EditHandleToCopy = "WindowsForms10.EDIT.app.0.21093c0_r7_ad11"


 HotKeySet("{PAUSE}", "Transfer")

Local $ColumnCounter = 1
Local $ColumnName
Local $RowCounter = 9

Local $DataAddress
Local $ResultData


Func Transfer()
   $LogIsChecked = GuiCtrlRead($ShowAllLogData) = $GUI_CHECKED

   If $ColumnCounter <= 8 Then
	  Switch $ColumnCounter
		 Case 1
			$ColumnName = "A"
		 Case 2
			$ColumnName = "B"
		 Case 3
			$ColumnName = "C"
		 Case 4
			$ColumnName = "D"
		 Case 5
			$ColumnName = "E"
		 Case 6
			$ColumnName = "F"
		 Case 7
			$ColumnName = "G"
		 Case 8
			$ColumnName = "H"
		 EndSwitch
		 $ColumnCounter = $ColumnCounter + 1
   ElseIf $ColumnCounter == 9 Then
	  $RowCounter = $RowCounter + 1
	  $ColumnCounter = 1
	  $ColumnName = "A"
	  $ColumnCounter = $ColumnCounter + 1
   EndIf

   $DataAddress = $ColumnName & String ( $RowCounter )
   $ResultData = _Excel_RangeRead($Workbook, Default, $DataAddress)

   GUICtrlSetData($Label3, $ErrorCount)
   GUICtrlSetData($Label3, $ErrorCount)

   If $LogIsChecked Then
		 MsgBox($MB_SYSTEMMODAL, "xlsTransfer.exe", $DataAddress)
		 MsgBox($MB_SYSTEMMODAL, "xlsTransfer.exe", $ResultData)
   EndIf

   Switch $ColumnCounter-1
	  Case 1
		 Send("{DEL}")
		 Send($ResultData)
		 Send("{Enter}")
	  Case 2 ;= "B"
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
	  Case 3
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
		 Send($ResultData)
		 Send("{Enter}")
	  Case 4
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
		 Send($ResultData)
		 Send("{Enter}")
	  Case 5
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
		 Send($ResultData)
		 Send("{Enter}")
	  Case 6
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
		 Send($ResultData)
		 Send("{Enter}")
	  Case 7
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
	  Case 8
		 Send("{DEL}")
		 Send($ResultData)
		 Sleep(500)
		 Send("{Enter}")
	  EndSwitch


EndFunc


Func CLOSEClicked()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd

