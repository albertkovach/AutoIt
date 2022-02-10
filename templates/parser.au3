#include <Array.au3>
#include <Excel.au3>
#include <ExcelConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
$mainwindow = GUICreate("PARSER.exe", 300, 120)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)
Global $Label1 = GUICtrlCreateLabel("Pause/Break для подтяжки данных", 15, 15)
Global $Label2 = GUICtrlCreateLabel("Поиск по столбцу B, подтяжка А", 15, 35)
Global $Label3 = GUICtrlCreateLabel("Расположение таблицы: \Extras\parsing_table.xls", 15, 55)
$ShowAllLogData = GUICtrlCreateCheckbox("Режим отладки", 180, 80, 150, 25)
Local $LogIsChecked

Local $oExcel = _Excel_Open()
Local $WorkbookPath = @ScriptDir & "\Extras\parsing_table.xls"
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel", "Error creating the Excel application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
Local $Workbook = _Excel_BookOpen($oExcel, $WorkbookPath)
$Workbook = _Excel_BookAttach($WorkbookPath)

If @error Then
    MsgBox($MB_SYSTEMMODAL, "Excel", "Error opening workbook '" & @ScriptDir & "\Extras\parsing_table.xls'." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
    _Excel_Close($oExcel)
    Exit
EndIf



HotKeySet("{PAUSE}", "Parser")
;~ HotKeySet("{PRINTSCREEN}", "Test")

Local $hWnd = WinGetHandle("ORBita - [Индексирование]", "")
Local $EditFieldWithDataToFind = "Edit4"
Local $EditFieldWithResultToPaste = "Edit5"

Local $DataToFind
Local $DataAddress
Local $ResultAddress
Local $ResultData



Func Parser()

   $LogIsChecked = GuiCtrlRead($ShowAllLogData) = $GUI_CHECKED

   Local $SavingLog = _Excel_BookSave($Workbook)

   If $LogIsChecked Then
	  If Not IsObj($Workbook) Then
		 MsgBox($MB_SYSTEMMODAL, "Parser", "Not IsObj($oWorkbook)")
	  EndIf
	  MsgBox($MB_SYSTEMMODAL, "Parser", $SavingLog)
   EndIf
   If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_BookSave Example 1", "Error saving workbook." & @CRLF & "@error = " & @error & ", @extended = " & @extended)


   $DataToFind = ControlGetText($hWnd, "", $EditFieldWithDataToFind)


   If $DataToFind == "" Then
	  If $LogIsChecked Then
		 MsgBox($MB_SYSTEMMODAL, "Parser", "Пустое поле контрагента")
	  EndIf
   Else
	  Local $aResult = _Excel_RangeFind($Workbook, $DataToFind)
	  If @error Then
		 Exit
		 MsgBox($MB_SYSTEMMODAL, "Excel", "Error searching the range." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	  EndIf

	  If $LogIsChecked Then
		 MsgBox($MB_SYSTEMMODAL, "Parser", "Поле контрагента содержит данные")
		 MsgBox($MB_SYSTEMMODAL, "Parser", "Data from " & $EditFieldWithDataToFind & " :"  & @CRLF & $DataToFind)
		 _ArrayDisplay($aResult, "Parser", "", 0, "|", "Sheet|Name|Cell|Value|Formula|Comment")
	  EndIf

	  If UBound($aResult) < 1 Then

		 If $LogIsChecked Then
			MsgBox($MB_SYSTEMMODAL, "Excel", "Нет данных")
		 EndIf
	  Else
		 $DataAddress = $aResult[0][2]
		 $ResultAddress = StringReplace($DataAddress, "$B", "$A")
		 $ResultData = _Excel_RangeRead($Workbook, Default, $ResultAddress)
		 ControlSetText($hWnd, "", $EditFieldWithResultToPaste, $ResultData)

		 If $LogIsChecked Then
			MsgBox($MB_SYSTEMMODAL, "Parser", "Данные найдены")
			MsgBox($MB_SYSTEMMODAL, "Excel", "$DataAddress   " & $DataAddress & @CRLF & "$ResultAddress   " & $ResultAddress & @CRLF & "$ResultData   " & $ResultData)
		 EndIf
	  EndIf

   EndIf

EndFunc


;~ Func Test()
;~ EndFunc


Func CLOSEClicked()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd

