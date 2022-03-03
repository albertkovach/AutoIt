#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Timers.au3>
#include <File.au3>

#include <Date.au3>
#include <StaticConstants.au3>

#Include <GUIEdit.au3>
#Include <ScrollBarConstants.au3>



Global $VersionText = "ver 5.5"
Global $VersionNumber = 55

$sPath_ini = @ScriptDir & "\prefs.ini"
Global $UpdateRequest = 0
IniWrite($sPath_ini, "ProgramDATA", "$VersionNumber", $VersionNumber)
Global $VersionFileLocation = "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT\update channel\version.txt"
Global $UpdateCheckInternalDemand = 0

Global $password = 'туктук'
Global $NoPassword = 1

Global $Rus = '00000419'; Раскладка русского языка
Global $Eng = '00000409'; Раскладка английского языка

Global $GUIsize = IniRead($sPath_ini, "ProgramDATA", "$GUIsize", "0")
Global $GUIheight
Global $GUIctrltoffset
Global $GUIresizecaption = "-"
If $GUIsize = 1 Then
	$GUIheight = 312
	$GUIctrltoffset = 0
	$GUIresizecaption = "-"
Else
	$GUIheight = 175
	$GUIctrltoffset = -135
	$GUIresizecaption = "+"
EndIf

Global $ClipFileLocation = "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT\update channel\clip.txt"
Global $ChatFileLocation = "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT\update channel\chat.txt"
Global $RefreshTimer = TimerInit()
Global $RefreshTime = 700
Global $ClipIsOpen = 0
Global $ClipFileContent
Global $ClipFileContentOld
Global $ChatIsOpen = 0
Global $ChatFileContent
Global $ChatFileContentOld

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
Opt("GUIOnEventMode", 1)


Global $RestoreItem = TrayCreateItem("Восстановить")
TrayItemSetOnEvent(-1, "RESTOREClicked")
Global $CloseItem = TrayCreateItem("Закрыть")
TrayItemSetOnEvent(-1, "CLOSEClicked")
TraySetClick(1)



Global $orbhfulltext
Global $orbhtext
Global $orbitext
Global $orbtext
Global $orbh



CreateGUI()



Func CreateGUI()
	Global $mainwindow = GUICreate("FLAME.exe", 665, $GUIheight)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	
	Global $minimizetotray = IniRead($sPath_ini, "ProgramDATA", "$minimizetotray", "0")
	If $minimizetotray = 1 Then
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "MINIMIZEtoTrayClicked")
	Else
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "MINIMIZEtoTasksClicked")
	EndIf
	
	GUISetState(@SW_SHOW)

	Global $INSERTlabelbtn = GUICtrlCreateButton("INSERT", 14, 10, 55, 20)
	Global $INSERTedit = GUICtrlCreateInput ( "", 15, 30, 200)

	Global $passwordbtn = GUICtrlCreateButton("Запомнить", 70, 60, 90)
	GUICtrlSetOnEvent($passwordbtn, "Unlocker")

	If $NoPassword = 1 Then
		InitializeGUI()
	EndIf

	$UpdateRequest = IniRead($sPath_ini, "ProgramDATA", "$UpdateRequest", "0")

	If $UpdateRequest = 1 Then
		$UpdateRequest = 0
		IniWrite($sPath_ini, "ProgramDATA", "$UpdateRequest", $UpdateRequest)
		InitializeGUI()
		MsgBox(4096, "", $VersionText)
	EndIf

	$source = "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT\update channel\updater.exe"
	$destination = @ScriptDir & "\"
	If FileExists($source) Then
		If FileExists(@ScriptDir & "/updater.exe") Then
		Else
			FileWrite(@ScriptDir & "/updater.exe", "" )
			Sleep (500)
			Runwait(@ComSpec & " /c " & "xcopy " & '"' & $source & '"' & ' "' & $destination & '"' & " /Y /H /I","",@SW_HIDE)
		EndIf
	EndIf

EndFunc


Func Unlocker()
   If $password = GUICtrlRead($INSERTedit) Then
	  InitializeGUI()
   EndIf
EndFunc


Func InitializeGUI()
   GUICtrlSetState($passwordbtn,$GUI_HIDE)
   GUICtrlSetOnEvent($INSERTlabelbtn, "INSERTset")

   Global $HOMElabelbtn = GUICtrlCreateButton("HOME", 229, 10, 55, 20)
   Global $HOMEedit = GUICtrlCreateInput ( "", 230, 30, 200)
   GUICtrlSetOnEvent($HOMElabelbtn, "HOMEset")

   Global $PGUPlabelbtn = GUICtrlCreateButton("PGUP", 444, 10, 55, 20)
   Global $PGUPedit = GUICtrlCreateInput ( "", 445, 30, 200)
   GUICtrlSetOnEvent($PGUPlabelbtn, "PGUPset")
   
   Global $MinimizeWindowButton = GUICtrlCreateButton("\/", 626, 9, 18, 18)
   GUICtrlSetOnEvent($MinimizeWindowButton, "MINIMIZEtoTrayClicked")

   Global $ENDlabelbtn = GUICtrlCreateButton("END", 229, 70, 55, 20)
   Global $ENDedit = GUICtrlCreateInput ( "", 230, 90, 200)
   GUICtrlSetOnEvent($ENDlabelbtn, "ENDset")

   Global $PGDNlabelbtn = GUICtrlCreateButton("PGDN", 444, 70, 55, 20)
   Global $PGDNedit = GUICtrlCreateInput ( "", 445, 90, 200)
   GUICtrlSetOnEvent($PGDNlabelbtn, "PGDNset")

   Global $REFRESHbtn = GUICtrlCreateButton("Запомнить", 70, 60, 90)
   GUICtrlSetOnEvent($REFRESHbtn, "RefreshAndSave")

   Global $ResizeGUIButton = GUICtrlCreateButton($GUIresizecaption, 15, 97, 20, 20) ; y = 91
   GUICtrlSetOnEvent($ResizeGUIButton, "ResizeGUI")

   ;Global $ClipButton = GUICtrlCreateButton("bf", 45, 97, 20, 20)
   ;GUICtrlSetOnEvent($ClipButton, "ClipOpen")

   Global $ChatButton = GUICtrlCreateButton("ch", 45, 97, 20, 20)
   GUICtrlSetOnEvent($ChatButton, "ChatOpen")

	If $GUIsize = 1 Then
	   Global $ctrl1labelbtn = GUICtrlCreateButton("CTRL + 1", 14, 145, 55, 20)
	   Global $ctrl1edit = GUICtrlCreateInput ( "", 15, 165, 200)
	   GUICtrlSetOnEvent($ctrl1labelbtn, "ctrl1set")

	   Global $ctrl2labelbtn = GUICtrlCreateButton("CTRL + 2", 229, 145, 55, 20)
	   Global $ctrl2edit = GUICtrlCreateInput ( "", 230, 165, 200)
	   GUICtrlSetOnEvent($ctrl2labelbtn, "ctrl2set")

	   Global $ctrl3labelbtn = GUICtrlCreateButton("CTRL + 3", 444, 145, 55, 20)
	   Global $ctrl3edit = GUICtrlCreateInput ( "", 445, 165, 200)
	   GUICtrlSetOnEvent($ctrl3labelbtn, "ctrl3set")

	   Global $ctrl4labelbtn = GUICtrlCreateButton("CTRL + 4", 14, 200, 55, 20)
	   Global $ctrl4edit = GUICtrlCreateInput ( "", 15, 220, 200)
	   GUICtrlSetOnEvent($ctrl4labelbtn, "ctrl4set")

	   Global $ctrl5labelbtn = GUICtrlCreateButton("CTRL + 5", 229, 200, 55, 20)
	   Global $ctrl5edit = GUICtrlCreateInput ( "", 230, 220, 200)
	   GUICtrlSetOnEvent($ctrl5labelbtn, "ctrl5set")

	   Global $ctrl6labelbtn = GUICtrlCreateButton("CTRL + 6", 444, 200, 55, 20)
	   Global $ctrl6edit = GUICtrlCreateInput ( "", 445, 220, 200)
	   GUICtrlSetOnEvent($ctrl6labelbtn, "ctrl6set")
	EndIf

   Global $numpluslabelbtn = GUICtrlCreateButton("NUM +", 84, 255+$GUIctrltoffset, 55, 20)
   Global $numplusedit = GUICtrlCreateInput ( "", 85, 275+$GUIctrltoffset, 200)
   GUICtrlSetOnEvent($NumPLUSlabelbtn, "NumPLUSset")

   Global $SETUPbtn = GUICtrlCreateButton("", 15, 276+$GUIctrltoffset, 20, 20)
   Global $STATUSlabel = GUICtrlCreateLabel("ОК", 18, 279+$GUIctrltoffset-21, 20, 18)
   GUICtrlSetOnEvent($SETUPbtn, "SETUPset")
   
   Global $Calendarbtn = GUICtrlCreateButton("K", 45, 276+$GUIctrltoffset, 20, 20)
   GUICtrlSetOnEvent($Calendarbtn, "CalendarOpen")

   Global $LANGlabel = GUICtrlCreateLabel("Смена языка в Орбите: F1 - русский, F2 - английский", 360, 260+$GUIctrltoffset, 350, 20)
   Global $INSERTcopyHowTo = GUICtrlCreateLabel("Вставить скопированное на клавишу Insert - F3", 393, 280+$GUIctrltoffset, 350, 25)
   Global $VersionLabel = GUICtrlCreateLabel("ver 2.5 d", 300, 280+$GUIctrltoffset, 45, 15)
   GUICtrlSetData ($VersionLabel, $VersionText)
   
	If $minimizetotray = 1 Then
		GUICtrlSetState($MinimizeWindowButton,$GUI_HIDE)
	EndIf

   LoadPrefs()
EndFunc


Func RefreshAndSave()
   $INSERTtext = GUICtrlRead($INSERTedit)
   $ENDtext = GUICtrlRead($ENDedit)
   $PGDNtext = GUICtrlRead($PGDNedit)
   $HOMEtext = GUICtrlRead($HOMEedit)
   $PGUPtext = GUICtrlRead($PGUPedit)

   IniWrite($sPath_ini, "EditDATA", "$INSERTtext", $INSERTtext)
   IniWrite($sPath_ini, "EditDATA", "$ENDtext", $ENDtext)
   IniWrite($sPath_ini, "EditDATA", "$PGDNtext", $PGDNtext)
   IniWrite($sPath_ini, "EditDATA", "$HOMEtext", $HOMEtext)
   IniWrite($sPath_ini, "EditDATA", "$PGUPtext", $PGUPtext)

   If $GUIsize = 1 Then
	   $ctrl1text = GUICtrlRead($ctrl1edit)
	   $ctrl2text = GUICtrlRead($ctrl2edit)
	   $ctrl3text = GUICtrlRead($ctrl3edit)
	   $ctrl4text = GUICtrlRead($ctrl4edit)
	   $ctrl5text = GUICtrlRead($ctrl5edit)
	   $ctrl6text = GUICtrlRead($ctrl6edit)
	   $numplustext = GUICtrlRead($numplusedit)

	   IniWrite($sPath_ini, "EditDATA", "$ctrl1text", $ctrl1text)
	   IniWrite($sPath_ini, "EditDATA", "$ctrl2text", $ctrl2text)
	   IniWrite($sPath_ini, "EditDATA", "$ctrl3text", $ctrl3text)
	   IniWrite($sPath_ini, "EditDATA", "$ctrl4text", $ctrl4text)
	   IniWrite($sPath_ini, "EditDATA", "$ctrl5text", $ctrl5text)
	   IniWrite($sPath_ini, "EditDATA", "$ctrl6text", $ctrl6text)
   EndIf

   If $NumPLUSsetDETECT = 0 Then
		IniWrite($sPath_ini, "EditDATA", "$numplustext", $numplustext)
   EndIf

   IniWrite($sPath_ini, "DetectDATA", "$orbhtext", $orbhtext)
   IniWrite($sPath_ini, "DetectDATA", "$orbitext", $orbitext)
EndFunc


Func LoadPrefs()
   Global $INSERTtext = IniRead($sPath_ini, "EditDATA", "$INSERTtext", "")
   Global $INSERTsetENABLE = IniRead($sPath_ini, "EditSET", "$INSERTsetENABLE", "1")
   Global $INSERTsetAddENTER = IniRead($sPath_ini, "EditSET", "$INSERTsetAddENTER", "1")
   Global $INSERTsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$INSERTsetAddBACKSPACE", "0")

   Global $HOMEtext = IniRead($sPath_ini, "EditDATA", "$HOMEtext", "")
   Global $HOMEsetENABLE = IniRead($sPath_ini, "EditSET", "$HOMEsetENABLE", "1")
   Global $HOMEsetAddENTER = IniRead($sPath_ini, "EditSET", "$HOMEsetAddENTER", "1")
   Global $HOMEsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$HOMEsetAddBACKSPACE", "0")

   Global $PGUPtext = IniRead($sPath_ini, "EditDATA", "$PGUPtext", "")
   Global $PGUPsetENABLE = IniRead($sPath_ini, "EditSET", "$PGUPsetENABLE", "1")
   Global $PGUPsetAddENTER = IniRead($sPath_ini, "EditSET", "$PGUPsetAddENTER", "1")
   Global $PGUPsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$PGUPsetAddBACKSPACE", "0")

   Global $ENDtext = IniRead($sPath_ini, "EditDATA", "$ENDtext", "")
   Global $ENDsetENABLE = IniRead($sPath_ini, "EditSET", "$ENDsetENABLE", "1")
   Global $ENDsetAddENTER = IniRead($sPath_ini, "EditSET", "$ENDsetAddENTER", "1")
   Global $ENDsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ENDsetAddBACKSPACE", "0")

   Global $PGDNtext = IniRead($sPath_ini, "EditDATA", "$PGDNtext", "")
   Global $PGDNsetENABLE = IniRead($sPath_ini, "EditSET", "$PGDNsetENABLE", "1")
   Global $PGDNsetAddENTER = IniRead($sPath_ini, "EditSET", "$PGDNsetAddENTER", "1")
   Global $PGDNsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$PGDNsetAddBACKSPACE", "0")

   If $GUIsize = 1 Then
	   Global $ctrl1text = IniRead($sPath_ini, "EditDATA", "$ctrl1text", "")
	   Global $ctrl1setENABLE = IniRead($sPath_ini, "EditSET", "$ctrl1setENABLE", "1")
	   Global $ctrl1setAddENTER = IniRead($sPath_ini, "EditSET", "$ctrl1setAddENTER", "1")
	   Global $ctrl1setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ctrl1setAddBACKSPACE", "0")

	   Global $ctrl2text = IniRead($sPath_ini, "EditDATA", "$ctrl2text", "")
	   Global $ctrl2setENABLE = IniRead($sPath_ini, "EditSET", "$ctrl2setENABLE", "1")
	   Global $ctrl2setAddENTER = IniRead($sPath_ini, "EditSET", "$ctrl2setAddENTER", "1")
	   Global $ctrl2setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ctrl2setAddBACKSPACE", "0")

	   Global $ctrl3text = IniRead($sPath_ini, "EditDATA", "$ctrl3text", "")
	   Global $ctrl3setENABLE = IniRead($sPath_ini, "EditSET", "$ctrl3setENABLE", "1")
	   Global $ctrl3setAddENTER = IniRead($sPath_ini, "EditSET", "$ctrl3setAddENTER", "1")
	   Global $ctrl3setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ctrl3setAddBACKSPACE", "0")

	   Global $ctrl4text = IniRead($sPath_ini, "EditDATA", "$ctrl4text", "")
	   Global $ctrl4setENABLE = IniRead($sPath_ini, "EditSET", "$ctrl4setENABLE", "1")
	   Global $ctrl4setAddENTER = IniRead($sPath_ini, "EditSET", "$ctrl4setAddENTER", "1")
	   Global $ctrl4setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ctrl4setAddBACKSPACE", "0")

	   Global $ctrl5text = IniRead($sPath_ini, "EditDATA", "$ctrl5text", "")
	   Global $ctrl5setENABLE = IniRead($sPath_ini, "EditSET", "$ctrl5setENABLE", "1")
	   Global $ctrl5setAddENTER = IniRead($sPath_ini, "EditSET", "$ctrl5setAddENTER", "1")
	   Global $ctrl5setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ctrl5setAddBACKSPACE", "0")

	   Global $ctrl6text = IniRead($sPath_ini, "EditDATA", "$ctrl6text", "")
	   Global $ctrl6setENABLE = IniRead($sPath_ini, "EditSET", "$ctrl6setENABLE", "1")
	   Global $ctrl6setAddENTER = IniRead($sPath_ini, "EditSET", "$ctrl6setAddENTER", "1")
	   Global $ctrl6setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ctrl6setAddBACKSPACE", "0")
   EndIf

   Global $numplustext = IniRead($sPath_ini, "EditDATA", "$numplustext", "")
   Global $NumPLUSsetENABLE = IniRead($sPath_ini, "EditSET", "$NumPLUSsetENABLE", "0")
   Global $NumPLUSsetAddENTER = IniRead($sPath_ini, "EditSET", "$NumPLUSsetAddENTER", "1")
   Global $NumPLUSsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$NumPLUSsetAddBACKSPACE", "0")
   Global $NumPLUSsetDETECT = IniRead($sPath_ini, "EditSET", "$NumPLUSsetDETECT", "0")

   Global $langfastchange = IniRead($sPath_ini, "ProgramDATA", "$langfastchange", "0")
   Global $clipboardpaste = IniRead($sPath_ini, "ProgramDATA", "$clipboardpaste", "0")
   Global $minimizetotray = IniRead($sPath_ini, "ProgramDATA", "$minimizetotray", "0")

   $orbhtext = IniRead($sPath_ini, "DetectDATA", "$orbhtext", "WindowsForms10.Window.8.app.0.21093c0_r6_ad1")
   $orbitext = IniRead($sPath_ini, "DetectDATA", "$orbitext", "WindowsForms10.EDIT.app.0.21093c0_r6_ad11")
   ;$orbhtext = "WindowsForms10.Window.8.app.0.21093c0_r6_ad1"
   $orbhfulltext = "[CLASS:" & $orbhtext & "]"
   $orbh = WinGetHandle($orbhfulltext)

   GUICtrlSetData ($INSERTedit, $INSERTtext)

   GUICtrlSetData ($ENDedit, $ENDtext)
   GUICtrlSetData ($PGDNedit, $PGDNtext)

   GUICtrlSetData ($HOMEedit, $HOMEtext)
   GUICtrlSetData ($PGUPedit, $PGUPtext)

	If $GUIsize = 1 Then
		GUICtrlSetData ($ctrl1edit, $ctrl1text)
		GUICtrlSetData ($ctrl2edit, $ctrl2text)

		GUICtrlSetData ($ctrl3edit, $ctrl3text)
		GUICtrlSetData ($ctrl4edit, $ctrl4text)

		GUICtrlSetData ($ctrl5edit, $ctrl5text)
		GUICtrlSetData ($ctrl6edit, $ctrl6text)
   EndIf

   GUICtrlSetData ($numplusedit, $numplustext)

   ApplyStates()
EndFunc


Func ApplyStates()
   If $INSERTsetENABLE = 1 Then
		GUICtrlSetStyle($INSERTedit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{INSERT}", "INSERT")
   Else
		GUICtrlSetStyle($INSERTedit, $ES_READONLY)
		HotKeySet("{INSERT}")
   EndIf

	If $INSERTsetENABLE = 1 AND $clipboardpaste = 1 then
		HotKeySet("{F3}", "INSERTcopy")
		GUICtrlSetState($INSERTcopyHowTo, $GUI_SHOW)
	Else
		HotKeySet("{F3}")
		GUICtrlSetState($INSERTcopyHowTo, $GUI_HIDE)
	EndIf

   If $HOMEsetENABLE = 1 Then
		GUICtrlSetStyle($HOMEedit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{HOME}", "HOME")
   Else
		GUICtrlSetStyle($HOMEedit, $ES_READONLY)
		HotKeySet("{HOME}")
   EndIf

   If $PGUPsetENABLE = 1 Then
		GUICtrlSetStyle($PGUPedit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{PGUP}", "PGUP")
   Else
		GUICtrlSetStyle($PGUPedit, $ES_READONLY)
		HotKeySet("{PGUP}")
   EndIf

   If $ENDsetENABLE = 1 Then
		GUICtrlSetStyle($ENDedit, $GUI_SS_DEFAULT_INPUT)
		   HotKeySet("{END}", "END")
   Else
		GUICtrlSetStyle($ENDedit, $ES_READONLY)
		HotKeySet("{END}")
   EndIf

   If $PGDNsetENABLE = 1 Then
		GUICtrlSetStyle($PGDNedit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{PGDN}", "PGDN")
   Else
		GUICtrlSetStyle($PGDNedit, $ES_READONLY)
		HotKeySet("{PGDN}")
   EndIf


	If $GUIsize = 1 Then
		If $ctrl1setENABLE = 1 Then
			GUICtrlSetStyle($ctrl1edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("^{1}", "ctrl1")
		Else
			GUICtrlSetStyle($ctrl1edit, $ES_READONLY)
			HotKeySet("^{1}")
		EndIf

		If $ctrl2setENABLE = 1 Then
			GUICtrlSetStyle($ctrl2edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("^{2}", "ctrl2")
		Else
			GUICtrlSetStyle($ctrl2edit, $ES_READONLY)
			HotKeySet("^{2}")
		EndIf

		If $ctrl3setENABLE = 1 Then
			GUICtrlSetStyle($ctrl3edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("^{3}", "ctrl3")
		Else
			GUICtrlSetStyle($ctrl3edit, $ES_READONLY)
			HotKeySet("^{3}")
		EndIf

		If $ctrl4setENABLE = 1 Then
			GUICtrlSetStyle($ctrl4edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("^{4}", "ctrl4")
		Else
			GUICtrlSetStyle($ctrl4edit, $ES_READONLY)
			HotKeySet("^{4}")
		EndIf

		If $ctrl5setENABLE = 1 Then
			GUICtrlSetStyle($ctrl5edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("^{5}", "ctrl5")
		Else
			GUICtrlSetStyle($ctrl5edit, $ES_READONLY)
			HotKeySet("^{5}")
		EndIf

		If $ctrl6setENABLE = 1 Then
			GUICtrlSetStyle($ctrl6edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("^{6}", "ctrl6")
		Else
			GUICtrlSetStyle($ctrl6edit, $ES_READONLY)
			HotKeySet("^{6}")
		EndIf
	EndIf

   HotKeySet("{F8}", "Test")

   DetectCheck()
   HandleAndLangCheck()

   UpdateCheck()
EndFunc


Func HandleAndLangCheck()

   If WinGetHandle($orbhfulltext) = 0 Then
		GUICtrlSetState($STATUSlabel,$GUI_HIDE)
   Else
		GUICtrlSetState($STATUSlabel,$GUI_SHOW)
   EndIf


   If WinGetHandle($orbhfulltext) <> 0 AND $langfastchange = 1 Then
		GUICtrlSetStyle($LANGlabel, $GUI_HIDE)  ; Инвертировано, нелогично но работает
		HotKeySet("{F1}", "fastlangchangeF1")
		HotKeySet("{F2}", "fastlangchangeF2")
	Else
		GUICtrlSetStyle($LANGlabel, $GUI_SHOW)
		HotKeySet("{F1}")
		HotKeySet("{F2}")
	EndIf

EndFunc


Func ResizeGUI()
	If $GUIsize = 1 Then
		$GUIsize = 0
		$GUIheight = 175
		$GUIctrltoffset = -135
		$GUIresizecaption = "+"
	Else
		$GUIsize = 1
		$GUIheight = 312
		$GUIctrltoffset = 0
		$GUIresizecaption = "-"
	EndIf

	IniWrite($sPath_ini, "ProgramDATA", "$GUIsize", $GUIsize)

	GUIDelete($mainwindow)

	CreateGUI()
	InitializeGUI()
EndFunc



Func ClipOpen()
    $ClipIsOpen = 1
	GUISetState(@SW_DISABLE, $mainwindow)
	Global $ClipWindow = GUICreate("Clipboard",300,200)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ClipClose")
	GUISetState(@SW_SHOW)

	Global $ClipEdit = GUICtrlCreateEdit("", 15, 15, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))
	Global $ClipWriteBtn = GUICtrlCreateButton("Написать", 225, 170, 60, 22)
	Global $ClipRefreshEditBtn = GUICtrlCreateButton("Обновить", 155, 170, 60, 22)
	GUICtrlSetOnEvent($ClipWriteBtn, "ClipWrite")
	GUICtrlSetOnEvent($ClipRefreshEditBtn, "ClipRefreshEdit")

	ClipRefreshEdit()
EndFunc

Func ClipRefresh()
	$ClipFile = FileOpen($ClipFileLocation, 0)

	If $ClipFile = -1 Then
		;MsgBox(4096, "Ошибка", "Невозможно открыть файл.")
		FileWrite($ClipFileLocation,"")
		$ClipFile = FileOpen($ClipFileLocation, 0)
	EndIf

	$ClipFileContent = FileRead($ClipFile)
	FileClose($ClipFile)

	If $ClipFileContent <> $ClipFileContentOld Then
		GUICtrlSetData ($ClipEdit, $ClipFileContent)
	EndIf

	$ClipFileContentOld = $ClipFileContent
EndFunc


Func ClipWrite()
	$ClipFile = FileOpen($ClipFileLocation, 2)
		$ClipFileContent = GUICtrlRead($ClipEdit)
		FileWriteLine($ClipFile, $ClipFileContent)
	FileClose($ClipFile)
EndFunc


Func ClipRefreshEdit()
	GUICtrlSetData ($ClipEdit, $ClipFileContent)
EndFunc


Func ClipClose()
	$ClipIsOpen = 0
   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ClipWindow)
   $RefreshTimer = TimerInit()
EndFunc




Func ChatOpen()
    $ChatIsOpen = 1
	GUISetState(@SW_DISABLE, $mainwindow)
	Global $ChatWindow = GUICreate("Chat",300,200)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ChatClose")
	GUISetState(@SW_SHOW)

	Global $ChatHistoryEdit = GUICtrlCreateEdit("", 15, 15, 270, 90, BitOR($ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))
	Global $ChatEdit = GUICtrlCreateEdit("", 15, 115, 270, 50, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))

	HotKeySet("{ENTER}", "ChatWrite")

	Global $ClipOpenBtn = GUICtrlCreateButton("Открыть буфер", 15, 170, 100, 22)
	GUICtrlSetOnEvent($ClipOpenBtn, "ChatClipOpen")

	Global $ChatWipeBtn = GUICtrlCreateButton("Сбросить", 225, 170, 60, 22)
	GUICtrlSetOnEvent($ChatWipeBtn, "ChatWipe")

	GUICtrlSetData ($ChatHistoryEdit, $ChatFileContent)
EndFunc

Func ChatRefresh()
	$ChatFile = FileOpen($ChatFileLocation, 0)

	If $ChatFile = -1 Then
		;MsgBox(4096, "Ошибка", "Невозможно открыть файл.")
		FileWrite($ChatFileLocation,"")
		$ChatFile = FileOpen($ChatFileLocation, 0)
	EndIf

	$ChatFileContent = FileRead($ChatFile)
	FileClose($ChatFile)

	If $ChatFileContent <> $ChatFileContentOld Then
		GUICtrlSetData ($ChatHistoryEdit, $ChatFileContent)
		_GUICtrlEdit_Scroll($ChatHistoryEdit, $SB_SCROLLCARET)
	EndIf

	$ChatFileContentOld = $ChatFileContent
EndFunc


Func ChatWrite()
	$ChatFile = FileOpen($ChatFileLocation, 1)
		$ChatFileContent = GUICtrlRead($ChatEdit)
		FileWrite($ChatFile, $ChatFileContent & @CRLF)
	FileClose($ChatFile)
	GUICtrlSetData ($ChatEdit, "")
EndFunc

Func ChatWipe()
	$ChatFile = FileOpen($ChatFileLocation, 2)
		;MsgBox(4096, "", FileGetPos($ChatFile) & "   " & @error)
	FileClose($ChatFile)
EndFunc

Func ChatClipOpen()
	ChatClose()
	ClipOpen()
EndFunc

Func ChatClose()
	$ChatIsOpen = 0
   GUISetState(@SW_ENABLE, $mainwindow)
   HotKeySet("{ENTER}")
   GUIDelete($ChatWindow)
   $RefreshTimer = TimerInit()
EndFunc




Func SETUPset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $INSERTsetwin = GUICreate("Настройки",300,230)
   GUISetOnEvent($GUI_EVENT_CLOSE, "SETUPsetClose")
   GUISetState(@SW_SHOW)

   Global $orbhlabel = GUICtrlCreateLabel("ORBita window class:", 15, 15, 120, 20)
   Global $orbhinput = GUICtrlCreateInput ( "", 15, 32, 270) 						; y + 17
   Global $orbilabel = GUICtrlCreateLabel("Control ClassnameNN:", 15, 60, 120, 20)  ; y + 28
   Global $orbiinput = GUICtrlCreateInput ( "", 15, 77, 270)

   Global $orbichkbtn = GUICtrlCreateButton("Проверка", 15, 105, 60)
   Global $orbichklabel = GUICtrlCreateLabel("Тут должен быть текст выбранного поля", 85, 110, 120, 50)
   GUICtrlSetOnEvent($orbichkbtn, "SETUPcheck")

   Global $langfastchangechkbx = GUICtrlCreateCheckbox("Включить переключение языка на F1 - F2", 17, 140, 250)
   If $langfastchange = 1 Then
	  GUICtrlSetState($langfastchangechkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($langfastchangechkbx, $GUI_UNCHECKED)
   EndIf

   Global $clipboardpastechkbx = GUICtrlCreateCheckbox("Включить вставку на F3", 17, 160, 250)
   If $clipboardpaste = 1 Then
	  GUICtrlSetState($clipboardpastechkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($clipboardpastechkbx, $GUI_UNCHECKED)
   EndIf
   
   Global $minimizetotraychkbx = GUICtrlCreateCheckbox("Сворачивать в трей", 17, 180, 250)
   If $minimizetotray = 1 Then
	  GUICtrlSetState($minimizetotraychkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($minimizetotraychkbx, $GUI_UNCHECKED)
   EndIf

   Global $updatecheckbtn = GUICtrlCreateButton("Проверить обновления", 15, 205, 130, 20)
   GUICtrlSetOnEvent($updatecheckbtn, "UpdateCheckManual")

   $orbtext = ControlGetText($orbh, "", $orbitext)
   GUICtrlSetData ($orbichklabel, $orbtext)

   ;Global $setuprefrbtn = GUICtrlCreateButton("Обновить поля", 200, 8, 85, 20)
   ;GUICtrlSetOnEvent($setuprefrbtn, "SETUPcheck")

   GUICtrlSetData ($orbhinput, $orbhtext)
   GUICtrlSetData ($orbiinput, $orbitext)
EndFunc


Func SETUPsetClose()
   $orbhtext = GUICtrlRead($orbhinput)
   $orbitext = GUICtrlRead($orbiinput)

   IniWrite($sPath_ini, "DetectDATA", "$orbhtext", $orbhtext)
   IniWrite($sPath_ini, "DetectDATA", "$orbitext", $orbitext)

   $orbhfulltext = "[CLASS:" & $orbhtext & "]"
   $orbh = WinGetHandle($orbhfulltext)
   $orbtext = ControlGetText($orbh, "", $orbitext)

   If BitAND(GUICtrlRead($langfastchangechkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $langfastchange = 1
   Else
	 $langfastchange = 0
   EndIf
   IniWrite($sPath_ini, "ProgramDATA", "$langfastchange", $langfastchange)

   If BitAND(GUICtrlRead($clipboardpastechkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $clipboardpaste = 1
   Else
	 $clipboardpaste = 0
   EndIf
   IniWrite($sPath_ini, "ProgramDATA", "$clipboardpaste", $clipboardpaste)
   
   If BitAND(GUICtrlRead($minimizetotraychkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $minimizetotray = 1
   Else
	 $minimizetotray = 0
   EndIf
   IniWrite($sPath_ini, "ProgramDATA", "$minimizetotray", $minimizetotray)

   DetectCheck()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($INSERTsetwin)
   
	If $minimizetotray = 1 Then
		GUICtrlSetState($MinimizeWindowButton,$GUI_HIDE)
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "MINIMIZEtoTrayClicked")
	Else
		GUICtrlSetState($MinimizeWindowButton,$GUI_SHOW)
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "MINIMIZEtoTasksClicked")
	EndIf

	ApplyStates()
EndFunc


Func SETUPcheck()
   $orbhtext = GUICtrlRead($orbhinput)
   $orbitext = GUICtrlRead($orbiinput)

   IniWrite($sPath_ini, "DetectDATA", "$orbhtext", $orbhtext)
   IniWrite($sPath_ini, "DetectDATA", "$orbitext", $orbitext)

   $orbhfulltext = "[CLASS:" & $orbhtext & "]"
   $orbh = WinGetHandle($orbhfulltext)
   $orbtext = ControlGetText($orbh, "", $orbitext)

   GUICtrlSetData ($orbichklabel, $orbtext)
EndFunc



Func INSERTset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $INSERTsetwin = GUICreate("INSERTset",300,300)
   GUISetState(@SW_SHOW)
   Global $INSERTsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $INSERTsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $INSERTsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $INSERTsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $INSERTsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $INSERTsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($INSERTsetEdit, $INSERTtext)

   If $INSERTsetENABLE = 1 Then
	  GUICtrlSetState($INSERTsetENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($INSERTsetENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $INSERTsetAddENTER = 1 Then
	  GUICtrlSetState($INSERTsetAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($INSERTsetAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $INSERTsetAddBACKSPACE = 1 Then
	  GUICtrlSetState($INSERTsetAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($INSERTsetAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "INSERTsetClose")
EndFunc

Func INSERTsetClose()
	$INSERTtext = GUICtrlRead($INSERTsetEdit)
	GUICtrlSetData ($INSERTedit, $INSERTtext)
	IniWrite($sPath_ini, "EditDATA", "$INSERTtext", $INSERTtext)

   If BitAND(GUICtrlRead($INSERTsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $INSERTsetENABLE = 1
   Else
	 $INSERTsetENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($INSERTsetAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $INSERTsetAddENTER = 1
   Else
	 $INSERTsetAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($INSERTsetAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $INSERTsetAddBACKSPACE = 1
   Else
	 $INSERTsetAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$INSERTsetENABLE", $INSERTsetENABLE)
   IniWrite($sPath_ini, "EditSET", "$INSERTsetAddENTER", $INSERTsetAddENTER)
   IniWrite($sPath_ini, "EditSET", "$INSERTsetAddBACKSPACE", $INSERTsetAddBACKSPACE)

   ApplyStates()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($INSERTsetwin)
EndFunc


Func HOMEset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $HOMEsetwin = GUICreate("HOMEset",300,300)
   GUISetState(@SW_SHOW)
   Global $HOMEsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $HOMEsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $HOMEsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $HOMEsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $HOMEsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $HOMEsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($HOMEsetEdit, $HOMEtext)

   If $HOMEsetENABLE = 1 Then
	  GUICtrlSetState($HOMEsetENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($HOMEsetENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $HOMEsetAddENTER = 1 Then
	  GUICtrlSetState($HOMEsetAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($HOMEsetAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $HOMEsetAddBACKSPACE = 1 Then
	  GUICtrlSetState($HOMEsetAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($HOMEsetAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "HOMEsetClose")
EndFunc

Func HOMEsetClose()
	$HOMEtext = GUICtrlRead($HOMEsetEdit)
	GUICtrlSetData ($HOMEedit, $HOMEtext)
	IniWrite($sPath_ini, "EditDATA", "$HOMEtext", $HOMEtext)

   If BitAND(GUICtrlRead($HOMEsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $HOMEsetENABLE = 1
   Else
	 $HOMEsetENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($HOMEsetAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $HOMEsetAddENTER = 1
   Else
	 $HOMEsetAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($HOMEsetAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $HOMEsetAddBACKSPACE = 1
   Else
	 $HOMEsetAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$HOMEsetENABLE", $HOMEsetENABLE)
   IniWrite($sPath_ini, "EditSET", "$HOMEsetAddENTER", $HOMEsetAddENTER)
   IniWrite($sPath_ini, "EditSET", "$HOMEsetAddBACKSPACE", $HOMEsetAddBACKSPACE)

   ApplyStates()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($HOMEsetwin)
EndFunc


Func PGUPset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $PGUPsetwin = GUICreate("PGUPset",300,300)
   GUISetState(@SW_SHOW)
   Global $PGUPsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $PGUPsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $PGUPsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $PGUPsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $PGUPsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $PGUPsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($PGUPsetEdit, $PGUPtext)

   If $PGUPsetENABLE = 1 Then
	  GUICtrlSetState($PGUPsetENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($PGUPsetENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $PGUPsetAddENTER = 1 Then
	  GUICtrlSetState($PGUPsetAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($PGUPsetAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $PGUPsetAddBACKSPACE = 1 Then
	  GUICtrlSetState($PGUPsetAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($PGUPsetAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "PGUPsetClose")
EndFunc

Func PGUPsetClose()
	$PGUPtext = GUICtrlRead($PGUPsetEdit)
	GUICtrlSetData ($PGUPedit, $PGUPtext)
	IniWrite($sPath_ini, "EditDATA", "$PGUPtext", $PGUPtext)

   If BitAND(GUICtrlRead($PGUPsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $PGUPsetENABLE = 1
   Else
	 $PGUPsetENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($PGUPsetAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $PGUPsetAddENTER = 1
   Else
	 $PGUPsetAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($PGUPsetAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $PGUPsetAddBACKSPACE = 1
   Else
	 $PGUPsetAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$PGUPsetENABLE", $PGUPsetENABLE)
   IniWrite($sPath_ini, "EditSET", "$PGUPsetAddENTER", $PGUPsetAddENTER)
   IniWrite($sPath_ini, "EditSET", "$PGUPsetAddBACKSPACE", $PGUPsetAddBACKSPACE)

   ApplyStates()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($PGUPsetwin)
EndFunc


Func ENDset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ENDsetwin = GUICreate("ENDset",300,300)
   GUISetState(@SW_SHOW)
   Global $ENDsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ENDsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ENDsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ENDsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ENDsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ENDsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ENDsetEdit, $ENDtext)

   If $ENDsetENABLE = 1 Then
	  GUICtrlSetState($ENDsetENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ENDsetENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ENDsetAddENTER = 1 Then
	  GUICtrlSetState($ENDsetAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ENDsetAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ENDsetAddBACKSPACE = 1 Then
	  GUICtrlSetState($ENDsetAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ENDsetAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ENDsetClose")
EndFunc

Func ENDsetClose()
	$ENDtext = GUICtrlRead($ENDsetEdit)
	GUICtrlSetData ($ENDedit, $ENDtext)
	IniWrite($sPath_ini, "EditDATA", "$ENDtext", $ENDtext)

   If BitAND(GUICtrlRead($ENDsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ENDsetENABLE = 1
   Else
	 $ENDsetENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ENDsetAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ENDsetAddENTER = 1
   Else
	 $ENDsetAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ENDsetAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ENDsetAddBACKSPACE = 1
   Else
	 $ENDsetAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ENDsetENABLE", $ENDsetENABLE)
   IniWrite($sPath_ini, "EditSET", "$ENDsetAddENTER", $ENDsetAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ENDsetAddBACKSPACE", $ENDsetAddBACKSPACE)

   ApplyStates()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ENDsetwin)
EndFunc


Func PGDNset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $PGDNsetwin = GUICreate("PGDNset",300,300)
   GUISetState(@SW_SHOW)
   Global $PGDNsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $PGDNsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $PGDNsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $PGDNsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $PGDNsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $PGDNsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($PGDNsetEdit, $PGDNtext)

   If $PGDNsetENABLE = 1 Then
	  GUICtrlSetState($PGDNsetENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($PGDNsetENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $PGDNsetAddENTER = 1 Then
	  GUICtrlSetState($PGDNsetAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($PGDNsetAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $PGDNsetAddBACKSPACE = 1 Then
	  GUICtrlSetState($PGDNsetAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($PGDNsetAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "PGDNsetClose")
EndFunc

Func PGDNsetClose()
	$PGDNtext = GUICtrlRead($PGDNsetEdit)
	GUICtrlSetData ($PGDNedit, $PGDNtext)
	IniWrite($sPath_ini, "EditDATA", "$PGDNtext", $PGDNtext)

   If BitAND(GUICtrlRead($PGDNsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $PGDNsetENABLE = 1
   Else
	 $PGDNsetENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($PGDNsetAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $PGDNsetAddENTER = 1
   Else
	 $PGDNsetAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($PGDNsetAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $PGDNsetAddBACKSPACE = 1
   Else
	 $PGDNsetAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$PGDNsetENABLE", $PGDNsetENABLE)
   IniWrite($sPath_ini, "EditSET", "$PGDNsetAddENTER", $PGDNsetAddENTER)
   IniWrite($sPath_ini, "EditSET", "$PGDNsetAddBACKSPACE", $PGDNsetAddBACKSPACE)

   ApplyStates()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($PGDNsetwin)
EndFunc




Func ctrl1set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ctrl1setwin = GUICreate("ctrl1set",300,300)
   GUISetState(@SW_SHOW)
   Global $ctrl1setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ctrl1setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ctrl1setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ctrl1setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ctrl1setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ctrl1setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ctrl1setEdit, $ctrl1text)

   If $ctrl1setENABLE = 1 Then
	  GUICtrlSetState($ctrl1setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl1setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl1setAddENTER = 1 Then
	  GUICtrlSetState($ctrl1setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl1setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl1setAddBACKSPACE = 1 Then
	  GUICtrlSetState($ctrl1setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl1setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ctrl1setClose")
EndFunc

Func ctrl1setClose()
	$ctrl1text = GUICtrlRead($ctrl1setEdit)
	GUICtrlSetData ($ctrl1edit, $ctrl1text)
	IniWrite($sPath_ini, "EditDATA", "$ctrl1text", $ctrl1text)

   If BitAND(GUICtrlRead($ctrl1setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl1setENABLE = 1
   Else
	 $ctrl1setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl1setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl1setAddENTER = 1
   Else
	 $ctrl1setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl1setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl1setAddBACKSPACE = 1
   Else
	 $ctrl1setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ctrl1setENABLE", $ctrl1setENABLE)
   IniWrite($sPath_ini, "EditSET", "$ctrl1setAddENTER", $ctrl1setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ctrl1setAddBACKSPACE", $ctrl1setAddBACKSPACE)

   If $ctrl1setENABLE = 1 Then
		GUICtrlSetStyle($ctrl1edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{1}", "ctrl1")
   Else
		GUICtrlSetStyle($ctrl1edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ctrl1setwin)
EndFunc


Func ctrl2set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ctrl2setwin = GUICreate("ctrl2set",300,300)
   GUISetState(@SW_SHOW)
   Global $ctrl2setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ctrl2setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ctrl2setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ctrl2setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ctrl2setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ctrl2setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ctrl2setEdit, $ctrl2text)

   If $ctrl2setENABLE = 1 Then
	  GUICtrlSetState($ctrl2setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl2setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl2setAddENTER = 1 Then
	  GUICtrlSetState($ctrl2setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl2setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl2setAddBACKSPACE = 1 Then
	  GUICtrlSetState($ctrl2setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl2setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ctrl2setClose")
EndFunc

Func ctrl2setClose()
	$ctrl2text = GUICtrlRead($ctrl2setEdit)
	GUICtrlSetData ($ctrl2edit, $ctrl2text)
	IniWrite($sPath_ini, "EditDATA", "$ctrl2text", $ctrl2text)

   If BitAND(GUICtrlRead($ctrl2setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl2setENABLE = 1
   Else
	 $ctrl2setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl2setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl2setAddENTER = 1
   Else
	 $ctrl2setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl2setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl2setAddBACKSPACE = 1
   Else
	 $ctrl2setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ctrl2setENABLE", $ctrl2setENABLE)
   IniWrite($sPath_ini, "EditSET", "$ctrl2setAddENTER", $ctrl2setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ctrl2setAddBACKSPACE", $ctrl2setAddBACKSPACE)

   If $ctrl2setENABLE = 1 Then
		GUICtrlSetStyle($ctrl2edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{2}", "ctrl2")
   Else
		GUICtrlSetStyle($ctrl2edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ctrl2setwin)
EndFunc


Func ctrl3set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ctrl3setwin = GUICreate("ctrl3set",300,300)
   GUISetState(@SW_SHOW)
   Global $ctrl3setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ctrl3setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ctrl3setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ctrl3setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ctrl3setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ctrl3setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ctrl3setEdit, $ctrl3text)

   If $ctrl3setENABLE = 1 Then
	  GUICtrlSetState($ctrl3setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl3setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl3setAddENTER = 1 Then
	  GUICtrlSetState($ctrl3setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl3setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl3setAddBACKSPACE = 1 Then
	  GUICtrlSetState($ctrl3setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl3setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ctrl3setClose")
EndFunc

Func ctrl3setClose()
	$ctrl3text = GUICtrlRead($ctrl3setEdit)
	GUICtrlSetData ($ctrl3edit, $ctrl3text)
	IniWrite($sPath_ini, "EditDATA", "$ctrl3text", $ctrl3text)

   If BitAND(GUICtrlRead($ctrl3setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl3setENABLE = 1
   Else
	 $ctrl3setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl3setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl3setAddENTER = 1
   Else
	 $ctrl3setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl3setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl3setAddBACKSPACE = 1
   Else
	 $ctrl3setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ctrl3setENABLE", $ctrl3setENABLE)
   IniWrite($sPath_ini, "EditSET", "$ctrl3setAddENTER", $ctrl3setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ctrl3setAddBACKSPACE", $ctrl3setAddBACKSPACE)

   If $ctrl3setENABLE = 1 Then
		GUICtrlSetStyle($ctrl3edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{3}", "ctrl3")
   Else
		GUICtrlSetStyle($ctrl3edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ctrl3setwin)
EndFunc


Func ctrl4set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ctrl4setwin = GUICreate("ctrl4set",300,300)
   GUISetState(@SW_SHOW)
   Global $ctrl4setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ctrl4setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ctrl4setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ctrl4setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ctrl4setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ctrl4setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ctrl4setEdit, $ctrl4text)

   If $ctrl4setENABLE = 1 Then
	  GUICtrlSetState($ctrl4setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl4setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl4setAddENTER = 1 Then
	  GUICtrlSetState($ctrl4setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl4setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl4setAddBACKSPACE = 1 Then
	  GUICtrlSetState($ctrl4setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl4setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ctrl4setClose")
EndFunc

Func ctrl4setClose()
	$ctrl4text = GUICtrlRead($ctrl4setEdit)
	GUICtrlSetData ($ctrl4edit, $ctrl4text)
	IniWrite($sPath_ini, "EditDATA", "$ctrl4text", $ctrl4text)

   If BitAND(GUICtrlRead($ctrl4setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl4setENABLE = 1
   Else
	 $ctrl4setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl4setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl4setAddENTER = 1
   Else
	 $ctrl4setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl4setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl4setAddBACKSPACE = 1
   Else
	 $ctrl4setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ctrl4setENABLE", $ctrl4setENABLE)
   IniWrite($sPath_ini, "EditSET", "$ctrl4setAddENTER", $ctrl4setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ctrl4setAddBACKSPACE", $ctrl4setAddBACKSPACE)

   If $ctrl4setENABLE = 1 Then
		GUICtrlSetStyle($ctrl4edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{4}", "ctrl4")
   Else
		GUICtrlSetStyle($ctrl4edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ctrl4setwin)
EndFunc


Func ctrl5set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ctrl5setwin = GUICreate("ctrl5set",300,300)
   GUISetState(@SW_SHOW)
   Global $ctrl5setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ctrl5setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ctrl5setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ctrl5setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ctrl5setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ctrl5setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ctrl5setEdit, $ctrl5text)

   If $ctrl5setENABLE = 1 Then
	  GUICtrlSetState($ctrl5setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl5setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl5setAddENTER = 1 Then
	  GUICtrlSetState($ctrl5setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl5setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl5setAddBACKSPACE = 1 Then
	  GUICtrlSetState($ctrl5setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl5setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ctrl5setClose")
EndFunc

Func ctrl5setClose()
	$ctrl5text = GUICtrlRead($ctrl5setEdit)
	GUICtrlSetData ($ctrl5edit, $ctrl5text)
	IniWrite($sPath_ini, "EditDATA", "$ctrl5text", $ctrl5text)

   If BitAND(GUICtrlRead($ctrl5setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl5setENABLE = 1
   Else
	 $ctrl5setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl5setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl5setAddENTER = 1
   Else
	 $ctrl5setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl5setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl5setAddBACKSPACE = 1
   Else
	 $ctrl5setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ctrl5setENABLE", $ctrl5setENABLE)
   IniWrite($sPath_ini, "EditSET", "$ctrl5setAddENTER", $ctrl5setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ctrl5setAddBACKSPACE", $ctrl5setAddBACKSPACE)

   If $ctrl5setENABLE = 1 Then
		GUICtrlSetStyle($ctrl5edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{5}", "ctrl5")
   Else
		GUICtrlSetStyle($ctrl5edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ctrl5setwin)
EndFunc


Func ctrl6set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $ctrl6setwin = GUICreate("ctrl6set",300,300)
   GUISetState(@SW_SHOW)
   Global $ctrl6setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $ctrl6setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $ctrl6setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $ctrl6setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $ctrl6setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $ctrl6setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($ctrl6setEdit, $ctrl6text)

   If $ctrl6setENABLE = 1 Then
	  GUICtrlSetState($ctrl6setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl6setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl6setAddENTER = 1 Then
	  GUICtrlSetState($ctrl6setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl6setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $ctrl6setAddBACKSPACE = 1 Then
	  GUICtrlSetState($ctrl6setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($ctrl6setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "ctrl6setClose")
EndFunc

Func ctrl6setClose()
	$ctrl6text = GUICtrlRead($ctrl6setEdit)
	GUICtrlSetData ($ctrl6edit, $ctrl6text)
	IniWrite($sPath_ini, "EditDATA", "$ctrl6text", $ctrl6text)

   If BitAND(GUICtrlRead($ctrl6setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl6setENABLE = 1
   Else
	 $ctrl6setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl6setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl6setAddENTER = 1
   Else
	 $ctrl6setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($ctrl6setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $ctrl6setAddBACKSPACE = 1
   Else
	 $ctrl6setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$ctrl6setENABLE", $ctrl6setENABLE)
   IniWrite($sPath_ini, "EditSET", "$ctrl6setAddENTER", $ctrl6setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$ctrl6setAddBACKSPACE", $ctrl6setAddBACKSPACE)

   If $ctrl6setENABLE = 1 Then
		GUICtrlSetStyle($ctrl6edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{6}", "ctrl6")
   Else
		GUICtrlSetStyle($ctrl6edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($ctrl6setwin)
EndFunc



Func NumPLUSset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $NumPLUSsetwin = GUICreate("NumPLUSset",300,310)
   GUISetState(@SW_SHOW)
   Global $NumPLUSsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $NumPLUSsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $NumPLUSsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20

   Global $NumPLUSsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 100, 250, 20)
   Global $NumPLUSsetEdit = GUICtrlCreateEdit("", 15, 120, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $NumPLUSsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 280, 250, 20)
   GUICtrlSetData ($NumPLUSsetEdit, $NumPLUStext)

   Global $NumPLUSsetDETECTchkbx = GUICtrlCreateCheckbox("Detect", 15, 75)

   If $NumPLUSsetENABLE = 1 Then
	  GUICtrlSetState($NumPLUSsetENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($NumPLUSsetENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $NumPLUSsetAddENTER = 1 Then
	  GUICtrlSetState($NumPLUSsetAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($NumPLUSsetAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $NumPLUSsetAddBACKSPACE = 1 Then
	  GUICtrlSetState($NumPLUSsetAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($NumPLUSsetAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   If $NumPLUSsetDETECT = 1 Then
	  GUICtrlSetState($NumPLUSsetDETECTchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($NumPLUSsetDETECTchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "NumPLUSsetClose")
EndFunc

Func NumPLUSsetClose()
	$NumPLUStext = GUICtrlRead($NumPLUSsetEdit)
	GUICtrlSetData ($NumPLUSedit, $NumPLUStext)
	IniWrite($sPath_ini, "EditDATA", "$NumPLUStext", $NumPLUStext)

   If BitAND(GUICtrlRead($NumPLUSsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $NumPLUSsetENABLE = 1
   Else
	 $NumPLUSsetENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($NumPLUSsetAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $NumPLUSsetAddENTER = 1
   Else
	 $NumPLUSsetAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($NumPLUSsetAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $NumPLUSsetAddBACKSPACE = 1
   Else
	 $NumPLUSsetAddBACKSPACE = 0
   EndIf

   If BitAND(GUICtrlRead($NumPLUSsetDETECTchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $NumPLUSsetDETECT = 1
   Else
	 $NumPLUSsetDETECT = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$NumPLUSsetENABLE", $NumPLUSsetENABLE)
   IniWrite($sPath_ini, "EditSET", "$NumPLUSsetAddENTER", $NumPLUSsetAddENTER)
   IniWrite($sPath_ini, "EditSET", "$NumPLUSsetAddBACKSPACE", $NumPLUSsetAddBACKSPACE)
   IniWrite($sPath_ini, "EditSET", "$NumPLUSsetDETECT", $NumPLUSsetDETECT)

   DetectCheck()

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($NumPLUSsetwin)
EndFunc





Func INSERT()
   If $INSERTsetENABLE = 1 Then
		Send($INSERTtext)
		If $INSERTsetAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $INSERTsetAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   Else
   EndIf
EndFunc

Func INSERTcopy()
	$INSERTtext = ClipGet()
	GUICtrlSetData ($INSERTedit, $INSERTtext)
	RefreshAndSave()
EndFunc

Func HOME()
   If $HOMEsetENABLE = 1 Then
		Send($HOMEtext)
		If $HOMEsetAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $HOMEsetAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func PGUP()
   If $PGUPsetENABLE = 1 Then
		Send($PGUPtext)
		If $PGUPsetAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $PGUPsetAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
   
   MouseClick("left", 184, 178, 1, 0)
   MouseClick("left", 112, 96, 1, 0)
   
EndFunc

Func END()
   If $ENDsetENABLE = 1 Then
		Send($ENDtext)
		If $ENDsetAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ENDsetAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func PGDN()
   If $PGDNsetENABLE = 1 Then
		Send($PGDNtext)
		If $PGDNsetAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $PGDNsetAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
   
	MouseClick("left", 62, 177, 1, 1)
	MouseClick("left", 518, 217, 1, 1)
   
EndFunc

Func ctrl1()
   If $ctrl1setENABLE = 1 Then
		Send($ctrl1text)
		If $ctrl1setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ctrl1setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func ctrl2()
   If $ctrl2setENABLE = 1 Then
		Send($ctrl2text)
		If $ctrl2setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ctrl2setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func ctrl3()
   If $ctrl3setENABLE = 1 Then
		Send($ctrl3text)
		If $ctrl3setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ctrl3setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func ctrl4()
   If $ctrl4setENABLE = 1 Then
		Send($ctrl4text)
		If $ctrl4setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ctrl4setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func ctrl5()
   If $ctrl5setENABLE = 1 Then
		Send($ctrl5text)
		If $ctrl5setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ctrl5setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func ctrl6()
   If $ctrl6setENABLE = 1 Then
		Send($ctrl6text)
		If $ctrl6setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $ctrl6setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func NumPLUS()
   If $NumPLUSsetDETECT = 1 Then
		Detect()
   Else
	   If $NumPLUSsetENABLE = 1 Then
			Send($NumPLUStext)
			If $NumPLUSsetAddBACKSPACE = 1 Then
			  Send("{BACKSPACE}")
			EndIf
			If $NumPLUSsetAddENTER = 1 Then
			  Send("{ENTER}")
			EndIf
	   EndIf
   EndIf
EndFunc

Func Detect()

Local $SearchResult
Local $LettersFinded = 0

   If WinGetHandle($orbhfulltext) = 0 Then
		;MsgBox(0, 'Ошибка', "Нет подключения")
   Else
		$orbtext = ControlGetText($orbh, "", $orbitext)
		Send("{Enter}")
		ControlSetText ($orbh, "", $orbitext, $orbtext)
		Sleep(100)
		Send("{Enter}")
   EndIf
EndFunc

Func DetectCheck()
   If $NumPLUSsetDETECT = 1 Then
		HotKeySet("{NUMPADADD}", "NumPLUS")
		GUICtrlSetStyle($NumPLUSedit, $ES_READONLY)

		If WinGetHandle($orbhfulltext) = 0 Then
			GUICtrlSetData ($NumPLUSedit, "Неправильный ORBita window class")
		Else
			$orbtext = ControlGetText($orbh, "", $orbitext)
			If @error Then
				GUICtrlSetData ($NumPLUSedit, "Неправильный ClassnameNN")
			Else
				GUICtrlSetData ($NumPLUSedit, "               ===== detect =====")
			EndIf
		EndIf
   Else
		If $NumPLUSsetENABLE = 1 Then
			HotKeySet("{NUMPADADD}", "NumPLUS")
			GUICtrlSetStyle($NumPLUSedit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetData ($NumPLUSedit, $numplustext)
		Else
			GUICtrlSetStyle($NumPLUSedit, $ES_READONLY)
			HotKeySet("{NUMPADADD}")
		EndIf
   EndIf

EndFunc


Func UpdateCheck()
	$VersionFile = FileOpen($VersionFileLocation, 0)

	If $VersionFile = -1 Then
		FileWrite($ChatFileLocation,"")
		$VersionFile = FileOpen($VersionFileLocation, 0)
		FileClose($VersionFile)
	Else
		$VersionFileContent = FileRead($VersionFile)
		FileClose($VersionFile)

		If $VersionFileContent > $VersionNumber Then
			MsgBox(4096, "", "Есть обновление!")
			$UpdateRequest = 1
			IniWrite($sPath_ini, "ProgramDATA", "$UpdateRequest", $UpdateRequest)
			Run(@ScriptDir & "\updater.exe")
			Exit
		Else
			If $UpdateCheckInternalDemand = 1 Then
				$UpdateCheckInternalDemand = 0
				MsgBox(4096, "", "Обновлений нет")
			EndIf
		EndIf
	EndIf

EndFunc


Func UpdateCheckManual()
	$UpdateCheckInternalDemand = 1
	UpdateCheck()
EndFunc


Func fastlangchangeF1()
	_WinAPI_SetKeyboardLayout($Rus, $orbh)
EndFunc


Func fastlangchangeF2()
	_WinAPI_SetKeyboardLayout($Eng, $orbh)
EndFunc



Func _WinAPI_SetKeyboardLayout($sLayout, $hWnd)
	If Not WinExists($hWnd) Then
		Return SetError(1, 0, 0)
	EndIf
	Local $Ret = DllCall('user32.dll', 'long', 'LoadKeyboardLayout', 'str', StringFormat('%08s', StringStripWS($sLayout, 8)), 'int', 0)
	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf
	DllCall('user32.dll', 'ptr', 'SendMessage', 'hwnd', $hWnd, 'int', 0x0050, 'int', 1, 'int', $Ret[0])
	Return SetError(0, 0, 1)
EndFunc









Func CalendarOpen()
	GUISetState(@SW_DISABLE, $mainwindow)
	Global $calendarwindow = GUICreate("Календарь смен", 335, 245)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CalendarClose")
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
EndFunc


Func CalendarClose()
	GUISetState(@SW_ENABLE, $mainwindow)
	GUIDelete($calendarwindow)
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
			GUICtrlSetFont($xoffset, $ClndrTextSize+0.5, $ClndrTextThickness+200, 0, $ClndrFont)
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































While 1
	Sleep(100)

	if $ClipIsOpen = 1 Then
		if TimerDiff($RefreshTimer)>$RefreshTime then
		   $RefreshTimer = TimerInit()
		   ClipRefresh()
		EndIf
	EndIf

	if $ChatIsOpen = 1 Then
		if TimerDiff($RefreshTimer)>$RefreshTime then
		   $RefreshTimer = TimerInit()
		   ChatRefresh()
		EndIf
	EndIf
WEnd

Func CLOSEClicked()
	Exit
EndFunc


Func MINIMIZEtoTrayClicked()
	GUISetState(@SW_HIDE)
	TraySetState(1)
EndFunc

Func MINIMIZEtoTasksClicked()
	GUISetState(@SW_MINIMIZE)
EndFunc

Func RESTOREClicked()
    TraySetState(2)
    GUISetState(@SW_SHOW)
    GUISetState(@SW_RESTORE)
EndFunc





#comments-start

Интеллектуальная обработка в Detect - автопереключение языка при нахождении русских или англ. символов

	;MsgBox(4096, "", "Записано")
num+ backspace

 ; ^ CTRL, + SHIFT; ! ALT
;Send ("#{SPACE}")

		Global $Letters[58] = ['й','ц','у','к','е','н','г','ш','щ','з','х','ъ','ф','ы','в','а','п','р','о','л','д','ж','э','я','ч','с','м','и','т','ь','б','ю','q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m']

		For $i = 0 To 47
			$SearchResult = StringInStr($orbtext, $Letters[$i])
			If $SearchResult > 0 Then
				$LettersFinded = 1
			EndIf
		Next

		$LettersFinded = 0
		fastlangchangeF2()
		
		;ControlSend($orbh, "", $orbitext, $orbtext, 1)
		;Send($orbtext, 1)


Выделить проверку на подключение к WinHandle в отдельный класс
Перевод языка до и после поля

	$ORBv2 =  "[CLASS:" & $SetManualORBv2editText & "]"
	MsgBox(0, 'Результат', ControlGetText($ORBv2, "", GUICtrlRead($SetManualADedit, 1)))
	$ORBv2 = WinGetHandle($ORBv2, "")
	GUICtrlSetData ($LabelTestText, ControlGetText($ORBv2, "", GUICtrlRead($SetManualADedit, 1)))

#comments-end