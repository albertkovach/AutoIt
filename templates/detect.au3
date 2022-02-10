#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>

$sPath_ini = @ScriptDir & "\prefs.ini"

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
Global $mainwindow = GUICreate("DETECT.exe", 240, 80)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)

Global $EnterPasswordEdit = GUICtrlCreateInput("", 15, 15, 80, 20)
Global $EnterPasswordBtn = GUICtrlCreateButton("Запомнить", 15, 50, 80, 20)
Global $LabelMain = GUICtrlCreateLabel("Выберите версию:", 15, 15, 200, 35)
Global $SetOldBtn = GUICtrlCreateButton("Старая", 15, 40, 65)
Global $SetV2btn = GUICtrlCreateButton("Версия 2", 115, 40, 65)
Global $LabelStop = GUICtrlCreateLabel("Выход: CTRL+NUM.", 155, 40, 65, 40)
Global $LabelOldVer = GUICtrlCreateLabel("Старая версия", 30, 40)
Global $LabelProject = GUICtrlCreateLabel("Дороги и Мосты", 30, 55)
Global $LabelV2ver = GUICtrlCreateLabel("ORBita v2", 15, 45)

Global $v2setupbtn = GUICtrlCreateButton("Настройка", 75, 40, 65)

   GUICtrlSetOnEvent($EnterPasswordBtn, "PasswordCheck")
   GUICtrlSetOnEvent($SetOldBtn, "SetOld")
   GUICtrlSetOnEvent($SetV2btn, "SetV2")
   GUICtrlSetOnEvent($v2setupbtn, "v2setup")

Local $Password = "туктук"
;Local $Password = ""

Local $hORBwind

Local $ORBold = "ORBita - [Индексирование]"
Local $ORBv2 = "[CLASS:WindowsForms10.Window.8.app.0.21093c0_r30_ad1]"

Local $EditHandleToCopyV2 = "WindowsForms10.EDIT.app.0.21093c0_r7_ad12"
Local $EditHandleToCopyV2ad10 = "WindowsForms10.EDIT.app.0.21093c0_r7_ad10"
Local $EditHandleToCopyV2ad11 = "WindowsForms10.EDIT.app.0.21093c0_r7_ad11"
Local $EditHandleToCopyV2ad12 = "WindowsForms10.EDIT.app.0.21093c0_r7_ad12"
Local $EditHandleToCopyV2ad13 = "WindowsForms10.EDIT.app.0.21093c0_r7_ad13"

Local $SetAD10btnState
Local $SetAD11btnState
Local $SetAD12btnState
Local $SetAD13btnState
Local $SetManualADbtnState
Local $SetManualADrefrbtnState
Local $SetManualADeditText
Local $SetManualORBv2editText
;~ Local $EditHandleToCopyV2adManual = ""

Local $EditFieldType = "Edit3"
Local $EditFieldDnum = "WindowsForms10.EDIT.app.0.141b42a_r7_ad16"
Local $EditFieldDdate = "WindowsForms10.EDIT.app.0.141b42a_r7_ad17"
Local $EditFieldMnum = "WindowsForms10.EDIT.app.0.141b42a_r7_ad18"
Local $EditFieldMdate = "WindowsForms10.EDIT.app.0.141b42a_r7_ad19"
Local $EditFieldContr = "Edit4"



Local $SetManualADeditText


Local $StartedNow = true
Local $OldVerSelected = false;
Local $VersionSelected = false;

Local $Type
Local $Dnum
Local $Ddate
Local $Mnum
Local $Mdate
Local $Contr

Local $OldType
Local $OldDnum
Local $OldDdate
Local $OldMnum
Local $OldMdate
Local $OldContr

Local $EditHandleToCopy
Local $EditDataToCopy

OnStart()

Func OnStart()
   GUICtrlSetState ( $LabelStop, $GUI_HIDE )
   GUICtrlSetState ( $LabelOldVer, $GUI_HIDE )
   GUICtrlSetState ( $LabelProject, $GUI_HIDE )
   GUICtrlSetState ( $LabelV2ver, $GUI_HIDE )

   GUICtrlSetState ( $LabelMain, $GUI_HIDE )
   GUICtrlSetState ( $SetOldBtn, $GUI_HIDE )
   GUICtrlSetState ( $SetV2btn, $GUI_HIDE )

   GUICtrlSetState ( $v2setupbtn, $GUI_HIDE )

   GUICtrlSetState ( $EnterPasswordEdit, $GUI_SHOW )
   GUICtrlSetState ( $EnterPasswordBtn, $GUI_SHOW )

   $SetAD10btnState = IniRead($sPath_ini, "DetectDATA", "$SetAD10btnState", "1")
   $SetAD11btnState = IniRead($sPath_ini, "DetectDATA", "$SetAD11btnState", "1")
   $SetAD12btnState = IniRead($sPath_ini, "DetectDATA", "$SetAD12btnState", "0")
   $SetAD13btnState = IniRead($sPath_ini, "DetectDATA", "$SetAD13btnState", "1")
   $SetManualADbtnState = IniRead($sPath_ini, "DetectDATA", "$SetManualADbtn", "1")
   $SetManualADrefrbtnState = IniRead($sPath_ini, "DetectDATA", "$SetManualADrefrbtn", "0")
   $SetManualADeditText = IniRead($sPath_ini, "DetectDATA", "$SetManualADeditText", "WindowsForms10.EDIT.app.0.21093c0_r7_ad11")
   $SetManualORBv2editText = IniRead($sPath_ini, "DetectDATA", "$SetManualORBv2editText", "WindowsForms10.Window.8.app.0.21093c0_r30_ad1")

   $ORBv2 =  "[CLASS:" & $SetManualORBv2editText & "]"
   ;MsgBox($MB_SYSTEMMODAL, "Parser", $ORBv2)


   If $SetAD10btnState == 0 Then
	  $EditHandleToCopyV2 = $EditHandleToCopyV2ad10
   EndIf

   If $SetAD11btnState == 0 Then
	  $EditHandleToCopyV2 = $EditHandleToCopyV2ad11
   EndIf

   If $SetAD12btnState == 0 Then
	  $EditHandleToCopyV2 = $EditHandleToCopyV2ad12
   EndIf

   If $SetAD13btnState == 0 Then
	  $EditHandleToCopyV2 = $EditHandleToCopyV2ad13
   EndIf

   If $SetManualADbtnState == 0 Then
	  $EditHandleToCopyV2 = $SetManualADeditText
   EndIf

EndFunc


Func PasswordCheck()
   If GUICtrlRead($EnterPasswordEdit) == $Password Then
	  Unlock()
   EndIf
EndFunc


Func Unlock()
   GUICtrlSetState ( $LabelMain, $GUI_SHOW )
   GUICtrlSetState ( $SetOldBtn, $GUI_SHOW )
   GUICtrlSetState ( $SetV2btn, $GUI_SHOW )

   GUICtrlSetState ( $EnterPasswordEdit, $GUI_HIDE )
   GUICtrlSetState ( $EnterPasswordBtn, $GUI_HIDE )

   HotKeySet("{NUMPADADD}", "ExecuteKey")
   HotKeySet("^{NUMPADDOT}", "StopKey")
   ;HotKeySet("{PRINTSCREEN}", "StopKey")NUMPADDOT
EndFunc



Func ExecuteKey()
   ;MsgBox($MB_SYSTEMMODAL, "Parser", "ExecuteKey")
   If $VersionSelected == true Then
	  If $OldVerSelected == true Then
		 Send("{Enter}")
		 Send($EditDataToCopy)
		 Send("{Enter}")
	  EndIf
	  If $OldVerSelected == false Then
		 $EditDataToCopy = ControlGetText($hORBwind, "", $EditHandleToCopyV2)
		 Send("{Enter}")
		 Send($EditDataToCopy)
		 Send("{Enter}")
	  EndIf
   EndIf

EndFunc


Func StopKey()
   ;MsgBox($MB_SYSTEMMODAL, "Parser", "StopKey")
   StopExec()
   ;OnStart()
EndFunc

Func v2setup()
    GUISetState(@SW_DISABLE, $mainwindow)
	Global $windowv2setup = GUICreate("Edit selector", 270, 200)

    Global $LabelMain = GUICtrlCreateLabel("Выберите идентификатор поля ввода:", 10, 8, 200, 35)
	Global $SetAD10btn = GUICtrlCreateButton("ad10", 15, 30, 40)
	Global $SetAD11btn = GUICtrlCreateButton("ad11", 65, 30, 40)
	Global $SetAD12btn = GUICtrlCreateButton("ad12", 15, 60, 40)
	Global $SetAD13btn = GUICtrlCreateButton("ad13", 65, 60, 40)
	Global $SetADtest = GUICtrlCreateButton("Проверка", 115, 30, 60)
	Global $LabelTestText = GUICtrlCreateLabel("Тут должен быть текст выбранного поля", 115, 60, 120, 35)
	Global $SetManualADbtn = GUICtrlCreateButton("Ручной ввод ClassnameNN", 30, 95, 160, 20)
	Global $SetManualADrefrbtn = GUICtrlCreateButton("Обновить", 190, 95, 60, 20)
	Global $SetManualADedit = GUICtrlCreateInput("", 31, 120, 218)
	Global $LabelSetManualORBv2 = GUICtrlCreateLabel("Класс окна Орбиты", 85, 148, 100, 20)
	Global $SetManualORBv2refrbtn = GUICtrlCreateButton("Обновить", 190, 145, 60, 20)
	Global $SetManualORBv2edit = GUICtrlCreateInput("", 31, 170, 218, 20)

	GUISetState(@SW_SHOW)
    GUISetOnEvent($GUI_EVENT_CLOSE, "v2setupdelete")

   GUICtrlSetData ($SetManualADedit, $SetManualADeditText)
   GUICtrlSetData ($SetManualORBv2edit, $SetManualORBv2editText)

	GUICtrlSetOnEvent($SetAD10btn, "SetAD10btnH")
	GUICtrlSetOnEvent($SetAD11btn, "SetAD11btnH")
	GUICtrlSetOnEvent($SetAD12btn, "SetAD12btnH")
	GUICtrlSetOnEvent($SetAD13btn, "SetAD13btnH")
	GUICtrlSetOnEvent($SetManualADbtn, "SetManualADbtnH")
	GUICtrlSetOnEvent($SetManualADrefrbtn, "SetManualADrefrbtnH")
	GUICtrlSetOnEvent($SetADtest, "SetADtestH")
	GUICtrlSetOnEvent($SetManualORBv2refrbtn, "SetManualORBv2refrbtnH")

   If $SetAD10btnState == 1 Then
	  GUICtrlSetState($SetAD10btn,$GUI_ENABLE)
   Else
	  GUICtrlSetState($SetAD10btn,$GUI_DISABLE)
   EndIf

   If $SetAD11btnState == 1 Then
	  GUICtrlSetState($SetAD11btn,$GUI_ENABLE)
   Else
	  GUICtrlSetState($SetAD11btn,$GUI_DISABLE)
   EndIf

   If $SetAD12btnState == 1 Then
	  GUICtrlSetState($SetAD12btn,$GUI_ENABLE)
   Else
	  GUICtrlSetState($SetAD12btn,$GUI_DISABLE)
   EndIf

   If $SetAD13btnState == 1 Then
	  GUICtrlSetState($SetAD13btn,$GUI_ENABLE)
   Else
	  GUICtrlSetState($SetAD13btn,$GUI_DISABLE)
   EndIf

   If $SetManualADbtnState == 1 Then
	  GUICtrlSetState($SetManualADbtn,$GUI_ENABLE)
   Else
	  GUICtrlSetState($SetManualADbtn,$GUI_DISABLE)
   EndIf

   If $SetManualADrefrbtnState == 1 Then
	  GUICtrlSetState($SetManualADrefrbtn,$GUI_ENABLE)
   Else
	  GUICtrlSetState($SetManualADrefrbtn,$GUI_DISABLE)
   EndIf


EndFunc



Func SetAD10btnH()
   GUICtrlSetState($SetAD10btn,$GUI_DISABLE)
   GUICtrlSetState($SetAD11btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD12btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD13btn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADbtn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADrefrbtn,$GUI_DISABLE)

   IniWrite($sPath_ini, "DetectDATA", "$SetAD10btnState", "0")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD11btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD12btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD13btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADbtn", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADrefrbtn", "0")

   $EditHandleToCopyV2 = $EditHandleToCopyV2ad10
EndFunc

Func SetAD11btnH()
   GUICtrlSetState($SetAD10btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD11btn,$GUI_DISABLE)
   GUICtrlSetState($SetAD12btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD13btn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADbtn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADrefrbtn,$GUI_DISABLE)

   IniWrite($sPath_ini, "DetectDATA", "$SetAD10btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD11btnState", "0")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD12btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD13btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADbtn", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADrefrbtn", "0")

   $EditHandleToCopyV2 = $EditHandleToCopyV2ad11
EndFunc

Func SetAD12btnH()
   GUICtrlSetState($SetAD10btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD11btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD12btn,$GUI_DISABLE)
   GUICtrlSetState($SetAD13btn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADbtn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADrefrbtn,$GUI_DISABLE)

   IniWrite($sPath_ini, "DetectDATA", "$SetAD10btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD11btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD12btnState", "0")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD13btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADbtn", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADrefrbtn", "0")

   $EditHandleToCopyV2 = $EditHandleToCopyV2ad12
EndFunc

Func SetAD13btnH()
   GUICtrlSetState($SetAD10btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD11btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD12btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD13btn,$GUI_DISABLE)
   GUICtrlSetState($SetManualADbtn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADrefrbtn,$GUI_DISABLE)

   IniWrite($sPath_ini, "DetectDATA", "$SetAD10btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD11btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD12btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD13btnState", "0")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADbtn", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADrefrbtn", "0")

   $EditHandleToCopyV2 = $EditHandleToCopyV2ad13
EndFunc

Func SetManualADbtnH()
   GUICtrlSetState($SetAD10btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD11btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD12btn,$GUI_ENABLE)
   GUICtrlSetState($SetAD13btn,$GUI_ENABLE)
   GUICtrlSetState($SetManualADbtn,$GUI_DISABLE)
   GUICtrlSetState($SetManualADrefrbtn,$GUI_ENABLE)

   IniWrite($sPath_ini, "DetectDATA", "$SetAD10btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD11btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD12btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetAD13btnState", "1")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADbtn", "0")
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADrefrbtn", "1")

   $SetManualADeditText = GUICtrlRead($SetManualADedit)
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADeditText", $SetManualADeditText)

   $EditHandleToCopyV2 = $SetManualADeditText
EndFunc

Func SetManualADrefrbtnH()
   $SetManualADeditText = GUICtrlRead($SetManualADedit)
   IniWrite($sPath_ini, "DetectDATA", "$SetManualADeditText", $SetManualADeditText)

   $EditHandleToCopyV2 = $SetManualADeditText
EndFunc

Func SetManualORBv2refrbtnH()
   $SetManualORBv2editText = GUICtrlRead($SetManualORBv2edit)
   $ORBv2 =  "[CLASS:" & $SetManualORBv2editText & "]"
   IniWrite($sPath_ini, "DetectDATA", "$SetManualORBv2editText", $SetManualORBv2editText)
   MsgBox($MB_SYSTEMMODAL, "Parser", $ORBv2)
EndFunc


Func SetADtestH()
   GUICtrlSetData ($LabelTestText, ControlGetText($ORBv2, "", $EditHandleToCopyV2))
EndFunc



Func v2setupdelete()
   $SetManualORBv2editText = GUICtrlRead($SetManualORBv2edit)
   $ORBv2 =  "[CLASS:" & $SetManualORBv2editText & "]"
   IniWrite($sPath_ini, "DetectDATA", "$SetManualORBv2editText", $SetManualORBv2editText)
   ;MsgBox($MB_SYSTEMMODAL, "Parser", $ORBv2)

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($windowv2setup)
EndFunc








Func SetOld()
   $hORBwind = WinGetHandle($ORBold, "")

   GUICtrlSetState ( $SetOldBtn, $GUI_HIDE )
   GUICtrlSetState ( $SetV2btn, $GUI_HIDE )

   GUICtrlSetState ( $LabelStop, $GUI_SHOW )
   GUICtrlSetState ( $LabelOldVer, $GUI_SHOW )
   GUICtrlSetState ( $LabelProject, $GUI_SHOW )
   GUICtrlSetState ( $LabelV2ver, $GUI_HIDE )
   GUICtrlSetData($LabelMain, "")

   $VersionSelected = true;
   $OldVerSelected = true;
   Cycle()
EndFunc

Func SetV2()
   $hORBwind = WinGetHandle($ORBv2, "")

   GUICtrlSetState ( $SetOldBtn, $GUI_HIDE )
   GUICtrlSetState ( $SetV2btn, $GUI_HIDE )

   GUICtrlSetState ( $LabelStop, $GUI_SHOW )
   GUICtrlSetState ( $LabelOldVer, $GUI_HIDE )
   GUICtrlSetState ( $LabelProject, $GUI_HIDE )
   GUICtrlSetState ( $LabelV2ver, $GUI_SHOW )
   GUICtrlSetState ( $v2setupbtn, $GUI_SHOW )
   GUICtrlSetData($LabelMain, "Универсальный режим")

   $VersionSelected = true;
   $OldVerSelected = false;
EndFunc

Func StopExec()
   GUICtrlSetState ( $SetOldBtn, $GUI_SHOW )
   GUICtrlSetState ( $SetV2btn, $GUI_SHOW )

   GUICtrlSetState ( $LabelStop, $GUI_HIDE )
   GUICtrlSetState ( $LabelOldVer, $GUI_HIDE )
   GUICtrlSetState ( $LabelProject, $GUI_HIDE )
   GUICtrlSetState ( $LabelV2ver, $GUI_HIDE )
   GUICtrlSetState ( $v2setupbtn, $GUI_HIDE )
   GUICtrlSetData($LabelMain, "Выберите версию:")

   $VersionSelected = false;
   $OldVerSelected = false;
EndFunc




Func Cycle()
   While 1
	  if $OldVerSelected == true AND $VersionSelected == true Then
		 Scanner()
	  EndIf
	  if $OldVerSelected == false OR $VersionSelected == false Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc


Func Scanner()
   $Type = ControlGetText($hORBwind, "", $EditFieldType)
   $Dnum = ControlGetText($hORBwind, "", $EditFieldDnum)
   $Ddate = ControlGetText($hORBwind, "", $EditFieldDdate)
   $Mnum = ControlGetText($hORBwind, "", $EditFieldMnum)
   $Mdate = ControlGetText($hORBwind, "", $EditFieldMdate)
   $Contr = ControlGetText($hORBwind, "", $EditFieldContr)


   If $StartedNow == true Then
	  $OldType = $Type
	  $OldDnum = $Dnum
	  $OldDdate = $Ddate
	  $OldMnum = $Mnum
	  $OldMdate = $Mdate
	  $OldContr = $Contr

	  $StartedNow = false
   EndIf


   If $Type<>$OldType Then
	  GUICtrlSetData($LabelMain, $Type)
	  $EditHandleToCopy = $EditFieldType
	  $EditDataToCopy = $Type
   EndIf


   If $Dnum<>$OldDnum Then
	  GUICtrlSetData($LabelMain, $Dnum)
	  $EditHandleToCopy = $EditFieldDnum
	  $EditDataToCopy = $Dnum
   EndIf


   If $Ddate<>$OldDdate Then
	  GUICtrlSetData($LabelMain, $Ddate)
	  $EditHandleToCopy = $EditFieldDdate
	  $EditDataToCopy = $Ddate
   EndIf


   If $Mnum<>$OldMnum Then
	  GUICtrlSetData($LabelMain, $Mnum)
	  $EditHandleToCopy = $EditFieldMnum
	  $EditDataToCopy = $Mnum
   EndIf


   If $Mdate<>$OldMdate Then
	  GUICtrlSetData($LabelMain, $Mdate)
	  $EditHandleToCopy = $EditFieldMdate
	  $EditDataToCopy = $Mdate
   EndIf


   If $Contr<>$OldContr Then
	  GUICtrlSetData($LabelMain, $Contr)
	  $EditHandleToCopy = $EditFieldContr
	  $EditDataToCopy = $Contr
   EndIf


   $OldType = $Type
   $OldDnum = $Dnum
   $OldDdate = $Ddate
   $OldMnum = $Mnum
   $OldMdate = $Mdate
   $OldContr = $Contr

EndFunc




Func CLOSEClicked()
  Exit
EndFunc



While 1
   Sleep(100)
WEnd


