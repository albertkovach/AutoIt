#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <Timers.au3>
#include <File.au3>
#include <Misc.au3>

#include <Date.au3>
#include <StaticConstants.au3>

#Include <GUIEdit.au3>
#Include <ScrollBarConstants.au3>



Global $VersionText = "ver 6.2b"
Global $VersionNumber = 62

$sPath_ini = @ScriptDir & "\prefs.ini"
Global $UpdateRequest = 0
IniWrite($sPath_ini, "ProgramDATA", "$VersionNumber", $VersionNumber)
Global $VersionFileLocation = "\\zorb-srv\Operators\ORBdata\всякое\AutoIT\update channel\version.txt"
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
	$GUIheight = 367
	$GUIctrltoffset = 55
	$GUIresizecaption = "-"
Else
	$GUIheight = 175
	$GUIctrltoffset = -135
	$GUIresizecaption = "+"
EndIf

Global $ClipFileLocation = "\\zorb-srv\Operators\ORBdata\всякое\AutoIT\update channel\clip.txt"
Global $ChatFileLocation = "\\zorb-srv\Operators\ORBdata\всякое\AutoIT\update channel\chat.txt"
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

	$source = "\\zorb-srv\Operators\ORBdata\всякое\AutoIT\update channel\updater.exe"
	$destination = @ScriptDir & "\"
	If FileExists($source) Then
		If FileExists(@ScriptDir & "/updater.exe") Then
		Else
			FileWrite(@ScriptDir & "/updater.exe", "" )
			Sleep (500)
			Runwait(@ComSpec & " /c " & "xcopy " & '"' & $source & '"' & ' "' & $destination & '"' & " /Y /H /I","",@SW_HIDE)
		EndIf
	EndIf

	$UpdateRequest = IniRead($sPath_ini, "ProgramDATA", "$UpdateRequest", "0")

	If $UpdateRequest = 1 Then
		$UpdateRequest = 0
		IniWrite($sPath_ini, "ProgramDATA", "$UpdateRequest", $UpdateRequest)
		InitializeGUI()
		MsgBox(4096, "", $VersionText)
	EndIf



	SingleScript(0)

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
	   Global $f1labelbtn = GUICtrlCreateButton("F1", 14, 145, 55, 20)
	   Global $f1edit = GUICtrlCreateInput ( "", 15, 165, 200)
	   GUICtrlSetOnEvent($f1labelbtn, "f1set")

	   Global $f2labelbtn = GUICtrlCreateButton("F2", 229, 145, 55, 20)
	   Global $f2edit = GUICtrlCreateInput ( "", 230, 165, 200)
	   GUICtrlSetOnEvent($f2labelbtn, "f2set")

	   Global $f3labelbtn = GUICtrlCreateButton("F3", 444, 145, 55, 20)
	   Global $f3edit = GUICtrlCreateInput ( "", 445, 165, 200)
	   GUICtrlSetOnEvent($f3labelbtn, "f3set")

	   Global $f4labelbtn = GUICtrlCreateButton("F4", 14, 200, 55, 20)
	   Global $f4edit = GUICtrlCreateInput ( "", 15, 220, 200)
	   GUICtrlSetOnEvent($f4labelbtn, "f4set")

	   Global $f5labelbtn = GUICtrlCreateButton("F5", 229, 200, 55, 20)
	   Global $f5edit = GUICtrlCreateInput ( "", 230, 220, 200)
	   GUICtrlSetOnEvent($f5labelbtn, "f5set")

	   Global $f6labelbtn = GUICtrlCreateButton("F6", 444, 200, 55, 20)
	   Global $f6edit = GUICtrlCreateInput ( "", 445, 220, 200)
	   GUICtrlSetOnEvent($f6labelbtn, "f6set")
	   
	   Global $f7labelbtn = GUICtrlCreateButton("F7", 14, 255, 55, 20)
	   Global $f7edit = GUICtrlCreateInput ( "", 15, 275, 200)
	   GUICtrlSetOnEvent($f7labelbtn, "f7set")

	   Global $f8labelbtn = GUICtrlCreateButton("F8", 229, 255, 55, 20)
	   Global $f8edit = GUICtrlCreateInput ( "", 230, 275, 200)
	   GUICtrlSetOnEvent($f8labelbtn, "f8set")

	   Global $f9labelbtn = GUICtrlCreateButton("F9", 444, 255, 55, 20)
	   Global $f9edit = GUICtrlCreateInput ( "", 445, 275, 200)
	   GUICtrlSetOnEvent($f9labelbtn, "f9set")
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
	   $f1text = GUICtrlRead($f1edit)
	   $f2text = GUICtrlRead($f2edit)
	   $f3text = GUICtrlRead($f3edit)
	   $f4text = GUICtrlRead($f4edit)
	   $f5text = GUICtrlRead($f5edit)
	   $f6text = GUICtrlRead($f6edit)
	   $f7text = GUICtrlRead($f7edit)
	   $f8text = GUICtrlRead($f8edit)
	   $f9text = GUICtrlRead($f9edit)
	   $numplustext = GUICtrlRead($numplusedit)

	   IniWrite($sPath_ini, "EditDATA", "$f1text", $f1text)
	   IniWrite($sPath_ini, "EditDATA", "$f2text", $f2text)
	   IniWrite($sPath_ini, "EditDATA", "$f3text", $f3text)
	   IniWrite($sPath_ini, "EditDATA", "$f4text", $f4text)
	   IniWrite($sPath_ini, "EditDATA", "$f5text", $f5text)
	   IniWrite($sPath_ini, "EditDATA", "$f6text", $f6text)
	   IniWrite($sPath_ini, "EditDATA", "$f7text", $f7text)
	   IniWrite($sPath_ini, "EditDATA", "$f8text", $f8text)
	   IniWrite($sPath_ini, "EditDATA", "$f9text", $f9text)
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
   Global $PGUPsetMouseEnable = IniRead($sPath_ini, "EditSET", "$PGUPsetMouseEnable", "0")
   Global $PGUPsetMouse1x = IniRead($sPath_ini, "EditSET", "$PGUPsetMouse1x", "")
   Global $PGUPsetMouse1y = IniRead($sPath_ini, "EditSET", "$PGUPsetMouse1y", "")
   Global $PGUPsetMouse2x = IniRead($sPath_ini, "EditSET", "$PGUPsetMouse2x", "")
   Global $PGUPsetMouse2y = IniRead($sPath_ini, "EditSET", "$PGUPsetMouse2y", "")

   Global $ENDtext = IniRead($sPath_ini, "EditDATA", "$ENDtext", "")
   Global $ENDsetENABLE = IniRead($sPath_ini, "EditSET", "$ENDsetENABLE", "1")
   Global $ENDsetAddENTER = IniRead($sPath_ini, "EditSET", "$ENDsetAddENTER", "1")
   Global $ENDsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$ENDsetAddBACKSPACE", "0")

   Global $PGDNtext = IniRead($sPath_ini, "EditDATA", "$PGDNtext", "")
   Global $PGDNsetENABLE = IniRead($sPath_ini, "EditSET", "$PGDNsetENABLE", "1")
   Global $PGDNsetAddENTER = IniRead($sPath_ini, "EditSET", "$PGDNsetAddENTER", "1")
   Global $PGDNsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$PGDNsetAddBACKSPACE", "0")
   Global $PGDNsetMouseEnable = IniRead($sPath_ini, "EditSET", "$PGDNsetMouseEnable", "0")
   Global $PGDNsetMouse1x = IniRead($sPath_ini, "EditSET", "$PGDNsetMouse1x", "")
   Global $PGDNsetMouse1y = IniRead($sPath_ini, "EditSET", "$PGDNsetMouse1y", "")
   Global $PGDNsetMouse2x = IniRead($sPath_ini, "EditSET", "$PGDNsetMouse2x", "")
   Global $PGDNsetMouse2y = IniRead($sPath_ini, "EditSET", "$PGDNsetMouse2y", "")

   If $GUIsize = 1 Then
	   Global $f1text = IniRead($sPath_ini, "EditDATA", "$f1text", "")
	   Global $f1setENABLE = IniRead($sPath_ini, "EditSET", "$f1setENABLE", "1")
	   Global $f1setAddENTER = IniRead($sPath_ini, "EditSET", "$f1setAddENTER", "1")
	   Global $f1setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f1setAddBACKSPACE", "0")

	   Global $f2text = IniRead($sPath_ini, "EditDATA", "$f2text", "")
	   Global $f2setENABLE = IniRead($sPath_ini, "EditSET", "$f2setENABLE", "1")
	   Global $f2setAddENTER = IniRead($sPath_ini, "EditSET", "$f2setAddENTER", "1")
	   Global $f2setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f2setAddBACKSPACE", "0")

	   Global $f3text = IniRead($sPath_ini, "EditDATA", "$f3text", "")
	   Global $f3setENABLE = IniRead($sPath_ini, "EditSET", "$f3setENABLE", "1")
	   Global $f3setAddENTER = IniRead($sPath_ini, "EditSET", "$f3setAddENTER", "1")
	   Global $f3setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f3setAddBACKSPACE", "0")

	   Global $f4text = IniRead($sPath_ini, "EditDATA", "$f4text", "")
	   Global $f4setENABLE = IniRead($sPath_ini, "EditSET", "$f4setENABLE", "1")
	   Global $f4setAddENTER = IniRead($sPath_ini, "EditSET", "$f4setAddENTER", "1")
	   Global $f4setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f4setAddBACKSPACE", "0")

	   Global $f5text = IniRead($sPath_ini, "EditDATA", "$f5text", "")
	   Global $f5setENABLE = IniRead($sPath_ini, "EditSET", "$f5setENABLE", "1")
	   Global $f5setAddENTER = IniRead($sPath_ini, "EditSET", "$f5setAddENTER", "1")
	   Global $f5setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f5setAddBACKSPACE", "0")

	   Global $f6text = IniRead($sPath_ini, "EditDATA", "$f6text", "")
	   Global $f6setENABLE = IniRead($sPath_ini, "EditSET", "$f6setENABLE", "1")
	   Global $f6setAddENTER = IniRead($sPath_ini, "EditSET", "$f6setAddENTER", "1")
	   Global $f6setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f6setAddBACKSPACE", "0")
	   
	   Global $f7text = IniRead($sPath_ini, "EditDATA", "$f7text", "")
	   Global $f7setENABLE = IniRead($sPath_ini, "EditSET", "$f7setENABLE", "1")
	   Global $f7setAddENTER = IniRead($sPath_ini, "EditSET", "$f7setAddENTER", "1")
	   Global $f7setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f7setAddBACKSPACE", "0")
	   
	   Global $f8text = IniRead($sPath_ini, "EditDATA", "$f8text", "")
	   Global $f8setENABLE = IniRead($sPath_ini, "EditSET", "$f8setENABLE", "1")
	   Global $f8setAddENTER = IniRead($sPath_ini, "EditSET", "$f8setAddENTER", "1")
	   Global $f8setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f8setAddBACKSPACE", "0")
	   
	   Global $f9text = IniRead($sPath_ini, "EditDATA", "$f9text", "")
	   Global $f9setENABLE = IniRead($sPath_ini, "EditSET", "$f9setENABLE", "1")
	   Global $f9setAddENTER = IniRead($sPath_ini, "EditSET", "$f9setAddENTER", "1")
	   Global $f9setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f9setAddBACKSPACE", "0")
   EndIf

   Global $numplustext = IniRead($sPath_ini, "EditDATA", "$numplustext", "")
   Global $NumPLUSsetENABLE = IniRead($sPath_ini, "EditSET", "$NumPLUSsetENABLE", "0")
   Global $NumPLUSsetAddENTER = IniRead($sPath_ini, "EditSET", "$NumPLUSsetAddENTER", "1")
   Global $NumPLUSsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$NumPLUSsetAddBACKSPACE", "0")
   Global $NumPLUSsetDETECT = IniRead($sPath_ini, "EditSET", "$NumPLUSsetDETECT", "0")

   Global $detectlang = IniRead($sPath_ini, "ProgramDATA", "$detectlang", "0")
   Global $langfastchange = IniRead($sPath_ini, "ProgramDATA", "$langfastchange", "0")
   Global $clipboardpaste = IniRead($sPath_ini, "ProgramDATA", "$clipboardpaste", "0")
   Global $minimizetotray = IniRead($sPath_ini, "ProgramDATA", "$minimizetotray", "0")

   $orbhtext = IniRead($sPath_ini, "DetectDATA", "$orbhtext", "WindowsForms10.Window.8.app.0.21093c0_r6_ad1")
   $orbitext = IniRead($sPath_ini, "DetectDATA", "$orbitext", "WindowsForms10.EDIT.app.0.21093c0_r6_ad11")
   ;$orbhtext = "WindowsForms10.Window.8.app.0.21093c0_r6_ad1"
   ;$orbhfulltext = "[CLASS:" & $orbhtext & "]"
   $orbhfulltext = "[HANDLE:" & $orbhtext & "]"
   $orbh = WinGetHandle($orbhfulltext)

   GUICtrlSetData ($INSERTedit, $INSERTtext)

   GUICtrlSetData ($ENDedit, $ENDtext)
   GUICtrlSetData ($PGDNedit, $PGDNtext)

   GUICtrlSetData ($HOMEedit, $HOMEtext)
   GUICtrlSetData ($PGUPedit, $PGUPtext)

	If $GUIsize = 1 Then
		GUICtrlSetData ($f1edit, $f1text)
		GUICtrlSetData ($f2edit, $f2text)
		GUICtrlSetData ($f3edit, $f3text)
		
		GUICtrlSetData ($f4edit, $f4text)
		GUICtrlSetData ($f5edit, $f5text)
		GUICtrlSetData ($f6edit, $f6text)
		
		GUICtrlSetData ($f7edit, $f7text)
		GUICtrlSetData ($f8edit, $f8text)
		GUICtrlSetData ($f9edit, $f9text)
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
		If $PGUPsetMouseEnable = 1 Then
			GUICtrlSetStyle($PGUPedit, $ES_READONLY)
			GUICtrlSetData ($PGUPedit, "using mouse clicks")
		Else
			GUICtrlSetStyle($PGUPedit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetData ($PGUPedit, $PGUPtext)
		EndIf

		HotKeySet("{PGUP}", "PGUP")
	Else
		GUICtrlSetStyle($PGUPedit, $ES_READONLY)
		GUICtrlSetData ($PGUPedit, $PGUPtext)
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
		If $PGDNsetMouseEnable = 1 Then
			GUICtrlSetStyle($PGDNedit, $ES_READONLY)
			GUICtrlSetData ($PGDNedit, "using mouse clicks")
		Else
			GUICtrlSetStyle($PGDNedit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetData ($PGDNedit, $PGDNtext)
		EndIf

		HotKeySet("{PGDN}", "PGDN")
	Else
		GUICtrlSetStyle($PGDNedit, $ES_READONLY)
		GUICtrlSetData ($PGDNedit, $PGDNtext)
		HotKeySet("{PGDN}")
	EndIf


	If $GUIsize = 1 Then
		If $f1setENABLE = 1 Then
			GUICtrlSetStyle($f1edit, $GUI_SS_DEFAULT_INPUT)
			;HotKeySet("^{1}", "f1")
			HotKeySet("{F1}", "f1")
		Else
			GUICtrlSetStyle($f1edit, $ES_READONLY)
			;HotKeySet("^{1}")
			HotKeySet("{F1}")
		EndIf

		If $f2setENABLE = 1 Then
			GUICtrlSetStyle($f2edit, $GUI_SS_DEFAULT_INPUT)
			;HotKeySet("^{2}", "f2")
			HotKeySet("{F2}", "f2")
		Else
			GUICtrlSetStyle($f2edit, $ES_READONLY)
			;HotKeySet("^{2}")
			HotKeySet("{F2}")
		EndIf

		If $f3setENABLE = 1 Then
			GUICtrlSetStyle($f3edit, $GUI_SS_DEFAULT_INPUT)
			;HotKeySet("^{3}", "f3")
			HotKeySet("{F3}", "f3")
		Else
			GUICtrlSetStyle($f3edit, $ES_READONLY)
			;HotKeySet("^{3}")
			HotKeySet("{F3}")
		EndIf

		If $f4setENABLE = 1 Then
			GUICtrlSetStyle($f4edit, $GUI_SS_DEFAULT_INPUT)
			;HotKeySet("^{4}", "f4")
			HotKeySet("{F4}", "f4")
		Else
			GUICtrlSetStyle($f4edit, $ES_READONLY)
			;HotKeySet("^{4}")
			HotKeySet("{F4}")
		EndIf

		If $f5setENABLE = 1 Then
			GUICtrlSetStyle($f5edit, $GUI_SS_DEFAULT_INPUT)
			;HotKeySet("^{5}", "f5")
			HotKeySet("{F5}", "f5")
		Else
			GUICtrlSetStyle($f5edit, $ES_READONLY)
			;HotKeySet("^{5}")
			HotKeySet("{F5}")
		EndIf

		If $f6setENABLE = 1 Then
			GUICtrlSetStyle($f6edit, $GUI_SS_DEFAULT_INPUT)
			;HotKeySet("^{6}", "f6")
			HotKeySet("{F6}", "f6")
		Else
			GUICtrlSetStyle($f6edit, $ES_READONLY)
			;HotKeySet("^{6}")
			HotKeySet("{F6}")
		EndIf
		
		If $f7setENABLE = 1 Then
			GUICtrlSetStyle($f7edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("{F7}", "f7")
		Else
			GUICtrlSetStyle($f7edit, $ES_READONLY)
			HotKeySet("{F7}")
		EndIf
		
		If $f8setENABLE = 1 Then
			GUICtrlSetStyle($f8edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("{F8}", "f8")
		Else
			GUICtrlSetStyle($f8edit, $ES_READONLY)
			HotKeySet("{F8}")
		EndIf
		
		If $f9setENABLE = 1 Then
			GUICtrlSetStyle($f9edit, $GUI_SS_DEFAULT_INPUT)
			HotKeySet("{F9}", "f9")
		Else
			GUICtrlSetStyle($f9edit, $ES_READONLY)
			HotKeySet("{F9}")
		EndIf
	EndIf

   ;HotKeySet("{F8}", "Test")

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
		;HotKeySet("{F1}", "fastlangchangeF1")
		;HotKeySet("{F2}", "fastlangchangeF2")
	Else
		GUICtrlSetStyle($LANGlabel, $GUI_SHOW)
		;HotKeySet("{F1}")
		;HotKeySet("{F2}")
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
		$GUIheight = 367
		$GUIctrltoffset = 55
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
	;GUISetState(@SW_DISABLE, $mainwindow)
	GUISetState(@SW_HIDE, $mainwindow)
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
   ;GUISetState(@SW_ENABLE, $mainwindow)
   GUISetState(@SW_SHOW, $mainwindow)
   HotKeySet("{ENTER}")
   GUIDelete($ChatWindow)
   $RefreshTimer = TimerInit()
EndFunc




Func SETUPset()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $INSERTsetwin = GUICreate("Настройки",300,250)
   GUISetOnEvent($GUI_EVENT_CLOSE, "SETUPsetClose")
   GUISetState(@SW_SHOW)

   Global $orbhlabel = GUICtrlCreateLabel("ORBita window class:", 15, 15, 120, 20)
   Global $orbhinput = GUICtrlCreateInput ( "", 15, 32, 270) 						; y + 17
   Global $orbilabel = GUICtrlCreateLabel("Control ClassnameNN:", 15, 60, 120, 20)  ; y + 28
   Global $orbiinput = GUICtrlCreateInput ( "", 15, 77, 270)

   Global $orbichkbtn = GUICtrlCreateButton("Проверка", 15, 105, 60)
   Global $orbichklabel = GUICtrlCreateLabel("Тут должен быть текст выбранного поля", 85, 110, 120)
   GUICtrlSetOnEvent($orbichkbtn, "SETUPcheck")

	Global $orbidtlnglabel = GUICtrlCreateLabel("Принудительный язык:", 15, 110+25, 118, 20)
	Global $orbidtlngchkbxauto = GUICtrlCreateCheckbox("Auto", 155, 110+20)
	Global $orbidtlngchkbxeng = GUICtrlCreateCheckbox("Eng", 200, 110+20)
	Global $orbidtlngchkbxrus = GUICtrlCreateCheckbox("Rus", 245, 110+20)
	GUICtrlSetOnEvent($orbidtlngchkbxauto, "DetectLngChkAuto")
	GUICtrlSetOnEvent($orbidtlngchkbxeng, "DetectLngChkEng")
	GUICtrlSetOnEvent($orbidtlngchkbxrus, "DetectLngChkRus")
	
	If $detectlang = 0 Then
	  GUICtrlSetState($orbidtlngchkbxauto, $GUI_CHECKED)
	  GUICtrlSetState($orbidtlngchkbxeng, $GUI_UNCHECKED)
	  GUICtrlSetState($orbidtlngchkbxrus, $GUI_UNCHECKED)
	ElseIf $detectlang = 1 Then
	  GUICtrlSetState($orbidtlngchkbxauto, $GUI_UNCHECKED)
	  GUICtrlSetState($orbidtlngchkbxeng, $GUI_CHECKED)
	  GUICtrlSetState($orbidtlngchkbxrus, $GUI_UNCHECKED)
	ElseIf $detectlang = 1 Then
	  GUICtrlSetState($orbidtlngchkbxauto, $GUI_UNCHECKED)
	  GUICtrlSetState($orbidtlngchkbxeng, $GUI_UNCHECKED)
	  GUICtrlSetState($orbidtlngchkbxrus, $GUI_CHECKED)
	EndIf

   Global $langfastchangechkbx = GUICtrlCreateCheckbox("Включить переключение языка на F1 - F2", 17, 140+20, 250)
   If $langfastchange = 1 Then
	  GUICtrlSetState($langfastchangechkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($langfastchangechkbx, $GUI_UNCHECKED)
   EndIf

   Global $clipboardpastechkbx = GUICtrlCreateCheckbox("Включить вставку на F3", 17, 160+20, 250)
   If $clipboardpaste = 1 Then
	  GUICtrlSetState($clipboardpastechkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($clipboardpastechkbx, $GUI_UNCHECKED)
   EndIf

   Global $minimizetotraychkbx = GUICtrlCreateCheckbox("Сворачивать в трей", 17, 180+20, 250)
   If $minimizetotray = 1 Then
	  GUICtrlSetState($minimizetotraychkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($minimizetotraychkbx, $GUI_UNCHECKED)
   EndIf

   Global $updatecheckbtn = GUICtrlCreateButton("Проверить обновления", 15, 205+20, 130, 20)
   GUICtrlSetOnEvent($updatecheckbtn, "UpdateCheckManual")

   $orbtext = ControlGetText($orbh, "", $orbitext)
   GUICtrlSetData ($orbichklabel, $orbtext)

   ;Global $setuprefrbtn = GUICtrlCreateButton("Обновить поля", 200, 8, 85, 20)
   ;GUICtrlSetOnEvent($setuprefrbtn, "SETUPcheck")

   GUICtrlSetData ($orbhinput, $orbhtext)
   GUICtrlSetData ($orbiinput, $orbitext)
EndFunc

Func DetectLngChkAuto()
	If BitAND(GUICtrlRead($orbidtlngchkbxauto), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($orbidtlngchkbxeng, $GUI_UNCHECKED)
		GUICtrlSetState($orbidtlngchkbxrus, $GUI_UNCHECKED)
	EndIf
EndFunc

Func DetectLngChkEng()
	If BitAND(GUICtrlRead($orbidtlngchkbxeng), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($orbidtlngchkbxauto, $GUI_UNCHECKED)
		GUICtrlSetState($orbidtlngchkbxrus, $GUI_UNCHECKED)
	EndIf
EndFunc

Func DetectLngChkRus()
	If BitAND(GUICtrlRead($orbidtlngchkbxrus), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($orbidtlngchkbxauto, $GUI_UNCHECKED)
		GUICtrlSetState($orbidtlngchkbxeng, $GUI_UNCHECKED)
	EndIf
EndFunc
	

Func SETUPsetClose()
   $orbhtext = GUICtrlRead($orbhinput)
   $orbitext = GUICtrlRead($orbiinput)

   IniWrite($sPath_ini, "DetectDATA", "$orbhtext", $orbhtext)
   IniWrite($sPath_ini, "DetectDATA", "$orbitext", $orbitext)

   ;$orbhfulltext = "[CLASS:" & $orbhtext & "]"
   $orbhfulltext = "[HANDLE:" & $orbhtext & "]"
   $orbh = WinGetHandle($orbhfulltext)
   ;$orbtext = ControlGetText($orbh, "", $orbitext)
   $orbtext = ControlGetText($orbh, "", "[HANDLE:" & $orbitext & "]")

   If BitAND(GUICtrlRead($orbidtlngchkbxauto), $GUI_CHECKED) = $GUI_CHECKED Then
	 $detectlang = 0
   ElseIf BitAND(GUICtrlRead($orbidtlngchkbxeng), $GUI_CHECKED) = $GUI_CHECKED Then
	 $detectlang = 1
   ElseIf BitAND(GUICtrlRead($orbidtlngchkbxrus), $GUI_CHECKED) = $GUI_CHECKED Then
	 $detectlang = 2
   EndIf
   IniWrite($sPath_ini, "ProgramDATA", "$detectlang", $detectlang)


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

   ;$orbhfulltext = "[CLASS:" & $orbhtext & "]"
   $orbhfulltext = "[HANDLE:" & $orbhtext & "]"
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
   Global $PGUPsetwin = GUICreate("PGUPset",400,300)
   GUISetState(@SW_SHOW)
   Global $PGUPsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $PGUPsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $PGUPsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $PGUPsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $PGUPsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $PGUPsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)


	Local $yadd = -70

	Global $PGUPsetMouseMainLabel = GUICtrlCreateLabel("Нажатия по координатам", 290, 20, 100, 40, $SS_CENTER)
	Global $PGUPsetMouseEnablechkbx = GUICtrlCreateCheckbox("Включить", 300, 55)

	Global $PGUPsetMouse1Label = GUICtrlCreateLabel("Первое нажатие", 300, 85, 140, 20)
	Global $PGUPsetMouse1xLabel = GUICtrlCreateLabel("X :", 320, 110, 20, 20)
	Global $PGUPsetMouse1yLabel = GUICtrlCreateLabel("Y :", 320, 135, 20, 20)
	Global $PGUPsetMouse1xEdit = GUICtrlCreateInput ( "", 340, 105, 40, 20)
	Global $PGUPsetMouse1yEdit = GUICtrlCreateInput ( "", 340, 130, 40, 20)
	Global $PGUPsetMouse2Label = GUICtrlCreateLabel("Второе нажатие", 300, 155, 140, 20)
	Global $PGUPsetMouse2xLabel = GUICtrlCreateLabel("X :", 320, 180, 20, 20)
	Global $PGUPsetMouse2yLabel = GUICtrlCreateLabel("Y :", 320, 205, 20, 20)
	Global $PGUPsetMouse2xEdit = GUICtrlCreateInput ( "", 340, 175, 40, 20)
	Global $PGUPsetMouse2yEdit = GUICtrlCreateInput ( "", 340, 200, 40, 20)

	Global $PGUPsetMouse1btn = GUICtrlCreateButton("Сканирование -> Сканировать", 298, 230, 84, 30, $BS_MULTILINE + $BS_VCENTER)
	Global $PGUPsetMouse2btn = GUICtrlCreateButton("Ввод данных -> Новая папка", 298, 265, 84, 30, $BS_MULTILINE + $BS_VCENTER)

	GUICtrlSetOnEvent($PGUPsetENABLEchkbx, "PGUPsetStates")
	GUICtrlSetOnEvent($PGUPsetMouseEnablechkbx, "PGUPsetStates")
	GUICtrlSetOnEvent($PGUPsetMouse1btn, "PGUPsetMouseScan")
	GUICtrlSetOnEvent($PGUPsetMouse2btn, "PGUPsetMouseIndex")

	GUICtrlSetData ($PGUPsetMouse1xEdit, $PGUPsetMouse1x)
	GUICtrlSetData ($PGUPsetMouse1yEdit, $PGUPsetMouse1y)
	GUICtrlSetData ($PGUPsetMouse2xEdit, $PGUPsetMouse2x)
	GUICtrlSetData ($PGUPsetMouse2yEdit, $PGUPsetMouse2y)

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

	If $PGUPsetMouseEnable = 1 Then
		GUICtrlSetState($PGUPsetMouseEnablechkbx, $GUI_CHECKED)
	Else
		GUICtrlSetState($PGUPsetMouseEnablechkbx, $GUI_UNCHECKED)
	EndIf


	PGUPsetStates()

	GUISetOnEvent($GUI_EVENT_CLOSE, "PGUPsetClose")
EndFunc


Func PGUPsetStates()
	If BitAND(GUICtrlRead($PGUPsetMouseEnablechkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$PGUPsetMouseEnable = 1
	Else
		$PGUPsetMouseEnable = 0
	EndIf

	If BitAND(GUICtrlRead($PGUPsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$PGUPsetENABLE = 1
	Else
		$PGUPsetENABLE = 0
	EndIf

	If $PGUPsetENABLE = 1 Then
		If $PGUPsetMouseEnable = 1 Then
			GUICtrlSetStyle($PGUPedit, $ES_READONLY)
			GUICtrlSetStyle($PGUPsetEdit, $ES_READONLY)

			GUICtrlSetState($PGUPsetMouseEnablechkbx, $GUI_ENABLE)
			GUICtrlSetState($PGUPsetMouse1btn, $GUI_SHOW)
			GUICtrlSetState($PGUPsetMouse2btn, $GUI_SHOW)
			GUICtrlSetStyle($PGUPsetMouse1xEdit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGUPsetMouse1yEdit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGUPsetMouse2xEdit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGUPsetMouse2yEdit, $GUI_SS_DEFAULT_INPUT)
		Else
			GUICtrlSetStyle($PGUPedit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGUPsetEdit, $GUI_SS_DEFAULT_INPUT)

			GUICtrlSetState($PGUPsetMouseEnablechkbx, $GUI_ENABLE)
			GUICtrlSetState($PGUPsetMouse1btn, $GUI_HIDE)
			GUICtrlSetState($PGUPsetMouse2btn, $GUI_HIDE)
			GUICtrlSetStyle($PGUPsetMouse1xEdit, $ES_READONLY)
			GUICtrlSetStyle($PGUPsetMouse1yEdit, $ES_READONLY)
			GUICtrlSetStyle($PGUPsetMouse2xEdit, $ES_READONLY)
			GUICtrlSetStyle($PGUPsetMouse2yEdit, $ES_READONLY)

		EndIf
	Else
		GUICtrlSetStyle($PGUPedit, $ES_READONLY)
		GUICtrlSetStyle($PGUPsetEdit, $ES_READONLY)

		GUICtrlSetState($PGUPsetMouseEnablechkbx, $GUI_DISABLE)
		GUICtrlSetState($PGUPsetMouse1btn, $GUI_HIDE)
		GUICtrlSetState($PGUPsetMouse2btn, $GUI_HIDE)

		GUICtrlSetStyle($PGUPsetMouse1xEdit, $ES_READONLY)
		GUICtrlSetStyle($PGUPsetMouse1yEdit, $ES_READONLY)
		GUICtrlSetStyle($PGUPsetMouse2xEdit, $ES_READONLY)
		GUICtrlSetStyle($PGUPsetMouse2yEdit, $ES_READONLY)
	EndIf

EndFunc


Func PGUPsetMouseScan()
	GUICtrlSetData ($PGUPsetMouse1xEdit, 167)
	GUICtrlSetData ($PGUPsetMouse1yEdit, 161)
	GUICtrlSetData ($PGUPsetMouse2xEdit, 120)
	GUICtrlSetData ($PGUPsetMouse2yEdit, 88)
EndFunc

Func PGUPsetMouseIndex()
	GUICtrlSetData ($PGUPsetMouse1xEdit, 58)
	GUICtrlSetData ($PGUPsetMouse1yEdit, 158)
	GUICtrlSetData ($PGUPsetMouse2xEdit, 518)
	GUICtrlSetData ($PGUPsetMouse2yEdit, 199)
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

	If BitAND(GUICtrlRead($PGUPsetMouseEnablechkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$PGUPsetMouseEnable = 1
	Else
		$PGUPsetMouseEnable = 0
	EndIf

	$PGUPsetMouse1x = GUICtrlRead($PGUPsetMouse1xEdit)
	$PGUPsetMouse1y = GUICtrlRead($PGUPsetMouse1yEdit)
	$PGUPsetMouse2x = GUICtrlRead($PGUPsetMouse2xEdit)
	$PGUPsetMouse2y = GUICtrlRead($PGUPsetMouse2yEdit)

	IniWrite($sPath_ini, "EditSET", "$PGUPsetENABLE", $PGUPsetENABLE)
	IniWrite($sPath_ini, "EditSET", "$PGUPsetAddENTER", $PGUPsetAddENTER)
	IniWrite($sPath_ini, "EditSET", "$PGUPsetAddBACKSPACE", $PGUPsetAddBACKSPACE)

	IniWrite($sPath_ini, "EditSET", "$PGUPsetMouseEnable", $PGUPsetMouseEnable)
	IniWrite($sPath_ini, "EditSET", "$PGUPsetMouse1x", $PGUPsetMouse1x)
	IniWrite($sPath_ini, "EditSET", "$PGUPsetMouse1y", $PGUPsetMouse1y)
	IniWrite($sPath_ini, "EditSET", "$PGUPsetMouse2x", $PGUPsetMouse2x)
	IniWrite($sPath_ini, "EditSET", "$PGUPsetMouse2y", $PGUPsetMouse2y)

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
   Global $PGDNsetwin = GUICreate("PGDNset",400,300)
   GUISetState(@SW_SHOW)
   Global $PGDNsetENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $PGDNsetAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $PGDNsetAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $PGDNsetEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $PGDNsetEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $PGDNsetEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)


	Local $yadd = -70

	Global $PGDNsetMouseMainLabel = GUICtrlCreateLabel("Нажатия по координатам", 290, 20, 100, 40, $SS_CENTER)
	Global $PGDNsetMouseEnablechkbx = GUICtrlCreateCheckbox("Включить", 300, 55)

	Global $PGDNsetMouse1Label = GUICtrlCreateLabel("Первое нажатие", 300, 85, 140, 20)
	Global $PGDNsetMouse1xLabel = GUICtrlCreateLabel("X :", 320, 110, 20, 20)
	Global $PGDNsetMouse1yLabel = GUICtrlCreateLabel("Y :", 320, 135, 20, 20)
	Global $PGDNsetMouse1xEdit = GUICtrlCreateInput ( "", 340, 105, 40, 20)
	Global $PGDNsetMouse1yEdit = GUICtrlCreateInput ( "", 340, 130, 40, 20)
	Global $PGDNsetMouse2Label = GUICtrlCreateLabel("Второе нажатие", 300, 155, 140, 20)
	Global $PGDNsetMouse2xLabel = GUICtrlCreateLabel("X :", 320, 180, 20, 20)
	Global $PGDNsetMouse2yLabel = GUICtrlCreateLabel("Y :", 320, 205, 20, 20)
	Global $PGDNsetMouse2xEdit = GUICtrlCreateInput ( "", 340, 175, 40, 20)
	Global $PGDNsetMouse2yEdit = GUICtrlCreateInput ( "", 340, 200, 40, 20)

	Global $PGDNsetMouse1btn = GUICtrlCreateButton("Сканирование -> Сканировать", 298, 230, 84, 30, $BS_MULTILINE + $BS_VCENTER)
	Global $PGDNsetMouse2btn = GUICtrlCreateButton("Ввод данных -> Новая папка", 298, 265, 84, 30, $BS_MULTILINE + $BS_VCENTER)

	GUICtrlSetOnEvent($PGDNsetENABLEchkbx, "PGDNsetStates")
	GUICtrlSetOnEvent($PGDNsetMouseEnablechkbx, "PGDNsetStates")
	GUICtrlSetOnEvent($PGDNsetMouse1btn, "PGDNsetMouseScan")
	GUICtrlSetOnEvent($PGDNsetMouse2btn, "PGDNsetMouseIndex")

	GUICtrlSetData ($PGDNsetMouse1xEdit, $PGDNsetMouse1x)
	GUICtrlSetData ($PGDNsetMouse1yEdit, $PGDNsetMouse1y)
	GUICtrlSetData ($PGDNsetMouse2xEdit, $PGDNsetMouse2x)
	GUICtrlSetData ($PGDNsetMouse2yEdit, $PGDNsetMouse2y)

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

	If $PGDNsetMouseEnable = 1 Then
		GUICtrlSetState($PGDNsetMouseEnablechkbx, $GUI_CHECKED)
	Else
		GUICtrlSetState($PGDNsetMouseEnablechkbx, $GUI_UNCHECKED)
	EndIf


	PGDNsetStates()

	GUISetOnEvent($GUI_EVENT_CLOSE, "PGDNsetClose")
EndFunc


Func PGDNsetStates()
	If BitAND(GUICtrlRead($PGDNsetMouseEnablechkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$PGDNsetMouseEnable = 1
	Else
		$PGDNsetMouseEnable = 0
	EndIf

	If BitAND(GUICtrlRead($PGDNsetENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$PGDNsetENABLE = 1
	Else
		$PGDNsetENABLE = 0
	EndIf

	If $PGDNsetENABLE = 1 Then
		If $PGDNsetMouseEnable = 1 Then
			GUICtrlSetStyle($PGDNedit, $ES_READONLY)
			GUICtrlSetStyle($PGDNsetEdit, $ES_READONLY)

			GUICtrlSetState($PGDNsetMouseEnablechkbx, $GUI_ENABLE)
			GUICtrlSetState($PGDNsetMouse1btn, $GUI_SHOW)
			GUICtrlSetState($PGDNsetMouse2btn, $GUI_SHOW)
			GUICtrlSetStyle($PGDNsetMouse1xEdit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGDNsetMouse1yEdit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGDNsetMouse2xEdit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGDNsetMouse2yEdit, $GUI_SS_DEFAULT_INPUT)
		Else
			GUICtrlSetStyle($PGDNedit, $GUI_SS_DEFAULT_INPUT)
			GUICtrlSetStyle($PGDNsetEdit, $GUI_SS_DEFAULT_INPUT)

			GUICtrlSetState($PGDNsetMouseEnablechkbx, $GUI_ENABLE)
			GUICtrlSetState($PGDNsetMouse1btn, $GUI_HIDE)
			GUICtrlSetState($PGDNsetMouse2btn, $GUI_HIDE)
			GUICtrlSetStyle($PGDNsetMouse1xEdit, $ES_READONLY)
			GUICtrlSetStyle($PGDNsetMouse1yEdit, $ES_READONLY)
			GUICtrlSetStyle($PGDNsetMouse2xEdit, $ES_READONLY)
			GUICtrlSetStyle($PGDNsetMouse2yEdit, $ES_READONLY)

		EndIf
	Else
		GUICtrlSetStyle($PGDNedit, $ES_READONLY)
		GUICtrlSetStyle($PGDNsetEdit, $ES_READONLY)

		GUICtrlSetState($PGDNsetMouseEnablechkbx, $GUI_DISABLE)
		GUICtrlSetState($PGDNsetMouse1btn, $GUI_HIDE)
		GUICtrlSetState($PGDNsetMouse2btn, $GUI_HIDE)

		GUICtrlSetStyle($PGDNsetMouse1xEdit, $ES_READONLY)
		GUICtrlSetStyle($PGDNsetMouse1yEdit, $ES_READONLY)
		GUICtrlSetStyle($PGDNsetMouse2xEdit, $ES_READONLY)
		GUICtrlSetStyle($PGDNsetMouse2yEdit, $ES_READONLY)
	EndIf

EndFunc


Func PGDNsetMouseScan()
	GUICtrlSetData ($PGDNsetMouse1xEdit, 167)
	GUICtrlSetData ($PGDNsetMouse1yEdit, 161)
	GUICtrlSetData ($PGDNsetMouse2xEdit, 120)
	GUICtrlSetData ($PGDNsetMouse2yEdit, 88)
EndFunc

Func PGDNsetMouseIndex()
	GUICtrlSetData ($PGDNsetMouse1xEdit, 58)
	GUICtrlSetData ($PGDNsetMouse1yEdit, 158)
	GUICtrlSetData ($PGDNsetMouse2xEdit, 518)
	GUICtrlSetData ($PGDNsetMouse2yEdit, 199)
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

	If BitAND(GUICtrlRead($PGDNsetMouseEnablechkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$PGDNsetMouseEnable = 1
	Else
		$PGDNsetMouseEnable = 0
	EndIf

	$PGDNsetMouse1x = GUICtrlRead($PGDNsetMouse1xEdit)
	$PGDNsetMouse1y = GUICtrlRead($PGDNsetMouse1yEdit)
	$PGDNsetMouse2x = GUICtrlRead($PGDNsetMouse2xEdit)
	$PGDNsetMouse2y = GUICtrlRead($PGDNsetMouse2yEdit)

	IniWrite($sPath_ini, "EditSET", "$PGDNsetENABLE", $PGDNsetENABLE)
	IniWrite($sPath_ini, "EditSET", "$PGDNsetAddENTER", $PGDNsetAddENTER)
	IniWrite($sPath_ini, "EditSET", "$PGDNsetAddBACKSPACE", $PGDNsetAddBACKSPACE)

	IniWrite($sPath_ini, "EditSET", "$PGDNsetMouseEnable", $PGDNsetMouseEnable)
	IniWrite($sPath_ini, "EditSET", "$PGDNsetMouse1x", $PGDNsetMouse1x)
	IniWrite($sPath_ini, "EditSET", "$PGDNsetMouse1y", $PGDNsetMouse1y)
	IniWrite($sPath_ini, "EditSET", "$PGDNsetMouse2x", $PGDNsetMouse2x)
	IniWrite($sPath_ini, "EditSET", "$PGDNsetMouse2y", $PGDNsetMouse2y)

	ApplyStates()

	GUISetState(@SW_ENABLE, $mainwindow)
	GUIDelete($PGDNsetwin)
EndFunc




Func f1set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f1setwin = GUICreate("f1set",300,300)
   GUISetState(@SW_SHOW)
   Global $f1setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f1setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f1setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f1setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f1setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f1setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($f1setEdit, $f1text)

   If $f1setENABLE = 1 Then
	  GUICtrlSetState($f1setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f1setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f1setAddENTER = 1 Then
	  GUICtrlSetState($f1setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f1setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f1setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f1setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f1setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f1setClose")
EndFunc

Func f1setClose()
	$f1text = GUICtrlRead($f1setEdit)
	GUICtrlSetData ($f1edit, $f1text)
	IniWrite($sPath_ini, "EditDATA", "$f1text", $f1text)

   If BitAND(GUICtrlRead($f1setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f1setENABLE = 1
   Else
	 $f1setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f1setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f1setAddENTER = 1
   Else
	 $f1setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f1setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f1setAddBACKSPACE = 1
   Else
	 $f1setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f1setENABLE", $f1setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f1setAddENTER", $f1setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f1setAddBACKSPACE", $f1setAddBACKSPACE)

   If $f1setENABLE = 1 Then
		GUICtrlSetStyle($f1edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{1}", "f1")
   Else
		GUICtrlSetStyle($f1edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f1setwin)
EndFunc


Func f2set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f2setwin = GUICreate("f2set",300,300)
   GUISetState(@SW_SHOW)
   Global $f2setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f2setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f2setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f2setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f2setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f2setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($f2setEdit, $f2text)

   If $f2setENABLE = 1 Then
	  GUICtrlSetState($f2setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f2setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f2setAddENTER = 1 Then
	  GUICtrlSetState($f2setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f2setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f2setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f2setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f2setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f2setClose")
EndFunc

Func f2setClose()
	$f2text = GUICtrlRead($f2setEdit)
	GUICtrlSetData ($f2edit, $f2text)
	IniWrite($sPath_ini, "EditDATA", "$f2text", $f2text)

   If BitAND(GUICtrlRead($f2setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f2setENABLE = 1
   Else
	 $f2setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f2setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f2setAddENTER = 1
   Else
	 $f2setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f2setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f2setAddBACKSPACE = 1
   Else
	 $f2setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f2setENABLE", $f2setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f2setAddENTER", $f2setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f2setAddBACKSPACE", $f2setAddBACKSPACE)

   If $f2setENABLE = 1 Then
		GUICtrlSetStyle($f2edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{2}", "f2")
   Else
		GUICtrlSetStyle($f2edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f2setwin)
EndFunc


Func f3set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f3setwin = GUICreate("f3set",300,300)
   GUISetState(@SW_SHOW)
   Global $f3setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f3setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f3setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f3setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f3setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f3setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($f3setEdit, $f3text)

   If $f3setENABLE = 1 Then
	  GUICtrlSetState($f3setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f3setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f3setAddENTER = 1 Then
	  GUICtrlSetState($f3setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f3setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f3setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f3setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f3setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f3setClose")
EndFunc

Func f3setClose()
	$f3text = GUICtrlRead($f3setEdit)
	GUICtrlSetData ($f3edit, $f3text)
	IniWrite($sPath_ini, "EditDATA", "$f3text", $f3text)

   If BitAND(GUICtrlRead($f3setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f3setENABLE = 1
   Else
	 $f3setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f3setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f3setAddENTER = 1
   Else
	 $f3setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f3setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f3setAddBACKSPACE = 1
   Else
	 $f3setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f3setENABLE", $f3setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f3setAddENTER", $f3setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f3setAddBACKSPACE", $f3setAddBACKSPACE)

   If $f3setENABLE = 1 Then
		GUICtrlSetStyle($f3edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{3}", "f3")
   Else
		GUICtrlSetStyle($f3edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f3setwin)
EndFunc


Func f4set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f4setwin = GUICreate("f4set",300,300)
   GUISetState(@SW_SHOW)
   Global $f4setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f4setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f4setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f4setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f4setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f4setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($f4setEdit, $f4text)

   If $f4setENABLE = 1 Then
	  GUICtrlSetState($f4setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f4setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f4setAddENTER = 1 Then
	  GUICtrlSetState($f4setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f4setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f4setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f4setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f4setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f4setClose")
EndFunc

Func f4setClose()
	$f4text = GUICtrlRead($f4setEdit)
	GUICtrlSetData ($f4edit, $f4text)
	IniWrite($sPath_ini, "EditDATA", "$f4text", $f4text)

   If BitAND(GUICtrlRead($f4setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f4setENABLE = 1
   Else
	 $f4setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f4setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f4setAddENTER = 1
   Else
	 $f4setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f4setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f4setAddBACKSPACE = 1
   Else
	 $f4setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f4setENABLE", $f4setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f4setAddENTER", $f4setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f4setAddBACKSPACE", $f4setAddBACKSPACE)

   If $f4setENABLE = 1 Then
		GUICtrlSetStyle($f4edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{4}", "f4")
   Else
		GUICtrlSetStyle($f4edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f4setwin)
EndFunc


Func f5set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f5setwin = GUICreate("f5set",300,300)
   GUISetState(@SW_SHOW)
   Global $f5setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f5setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f5setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f5setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f5setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f5setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($f5setEdit, $f5text)

   If $f5setENABLE = 1 Then
	  GUICtrlSetState($f5setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f5setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f5setAddENTER = 1 Then
	  GUICtrlSetState($f5setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f5setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f5setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f5setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f5setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f5setClose")
EndFunc

Func f5setClose()
	$f5text = GUICtrlRead($f5setEdit)
	GUICtrlSetData ($f5edit, $f5text)
	IniWrite($sPath_ini, "EditDATA", "$f5text", $f5text)

   If BitAND(GUICtrlRead($f5setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f5setENABLE = 1
   Else
	 $f5setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f5setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f5setAddENTER = 1
   Else
	 $f5setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f5setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f5setAddBACKSPACE = 1
   Else
	 $f5setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f5setENABLE", $f5setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f5setAddENTER", $f5setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f5setAddBACKSPACE", $f5setAddBACKSPACE)

   If $f5setENABLE = 1 Then
		GUICtrlSetStyle($f5edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{5}", "f5")
   Else
		GUICtrlSetStyle($f5edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f5setwin)
EndFunc


Func f6set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f6setwin = GUICreate("f6set",300,300)
   GUISetState(@SW_SHOW)
   Global $f6setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f6setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f6setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f6setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f6setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f6setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 60, 270, 250, 20)
   GUICtrlSetData ($f6setEdit, $f6text)

   If $f6setENABLE = 1 Then
	  GUICtrlSetState($f6setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f6setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f6setAddENTER = 1 Then
	  GUICtrlSetState($f6setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f6setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f6setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f6setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f6setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f6setClose")
EndFunc

Func f6setClose()
	$f6text = GUICtrlRead($f6setEdit)
	GUICtrlSetData ($f6edit, $f6text)
	IniWrite($sPath_ini, "EditDATA", "$f6text", $f6text)

   If BitAND(GUICtrlRead($f6setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f6setENABLE = 1
   Else
	 $f6setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f6setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f6setAddENTER = 1
   Else
	 $f6setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f6setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f6setAddBACKSPACE = 1
   Else
	 $f6setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f6setENABLE", $f6setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f6setAddENTER", $f6setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f6setAddBACKSPACE", $f6setAddBACKSPACE)

   If $f6setENABLE = 1 Then
		GUICtrlSetStyle($f6edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{6}", "f6")
   Else
		GUICtrlSetStyle($f6edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f6setwin)
EndFunc


Func f7set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f7setwin = GUICreate("f7set",300,300)
   GUISetState(@SW_SHOW)
   Global $f7setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f7setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f7setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f7setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f7setEdit = GUICtrlCreateEdit("", 15, 110, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f7setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 70, 270, 250, 20)
   GUICtrlSetData ($f7setEdit, $f7text)

   If $f7setENABLE = 1 Then
	  GUICtrlSetState($f7setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f7setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f7setAddENTER = 1 Then
	  GUICtrlSetState($f7setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f7setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f7setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f7setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f7setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f7setClose")
EndFunc

Func f7setClose()
	$f7text = GUICtrlRead($f7setEdit)
	GUICtrlSetData ($f7edit, $f7text)
	IniWrite($sPath_ini, "EditDATA", "$f7text", $f7text)

   If BitAND(GUICtrlRead($f7setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f7setENABLE = 1
   Else
	 $f7setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f7setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f7setAddENTER = 1
   Else
	 $f7setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f7setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f7setAddBACKSPACE = 1
   Else
	 $f7setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f7setENABLE", $f7setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f7setAddENTER", $f7setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f7setAddBACKSPACE", $f7setAddBACKSPACE)

   If $f7setENABLE = 1 Then
		GUICtrlSetStyle($f7edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{7}", "f7")
   Else
		GUICtrlSetStyle($f7edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f7setwin)
EndFunc


Func f8set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f8setwin = GUICreate("f8set",300,300)
   GUISetState(@SW_SHOW)
   Global $f8setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f8setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f8setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f8setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90, 250, 20)
   Global $f8setEdit = GUICtrlCreateEdit("", 15, 110, 280, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f8setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 80, 280, 250, 20)
   GUICtrlSetData ($f8setEdit, $f8text)

   If $f8setENABLE = 1 Then
	  GUICtrlSetState($f8setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f8setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f8setAddENTER = 1 Then
	  GUICtrlSetState($f8setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f8setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f8setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f8setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f8setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f8setClose")
EndFunc

Func f8setClose()
	$f8text = GUICtrlRead($f8setEdit)
	GUICtrlSetData ($f8edit, $f8text)
	IniWrite($sPath_ini, "EditDATA", "$f8text", $f8text)

   If BitAND(GUICtrlRead($f8setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f8setENABLE = 1
   Else
	 $f8setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f8setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f8setAddENTER = 1
   Else
	 $f8setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f8setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f8setAddBACKSPACE = 1
   Else
	 $f8setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f8setENABLE", $f8setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f8setAddENTER", $f8setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f8setAddBACKSPACE", $f8setAddBACKSPACE)

   If $f8setENABLE = 1 Then
		GUICtrlSetStyle($f8edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{8}", "f8")
   Else
		GUICtrlSetStyle($f8edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f8setwin)
EndFunc


Func f9set()
   GUISetState(@SW_DISABLE, $mainwindow)
   Global $f9setwin = GUICreate("f9set",300,300)
   GUISetState(@SW_SHOW)
   Global $f9setENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
   Global $f9setAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
   Global $f9setAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
   Global $f9setEditName = GUICtrlCreateLabel("Увеличенное поле данных", 90, 90, 250, 20)
   Global $f9setEdit = GUICtrlCreateEdit("", 15, 110, 290, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
   Global $f9setEditLabel = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 90, 290, 250, 20)
   GUICtrlSetData ($f9setEdit, $f9text)

   If $f9setENABLE = 1 Then
	  GUICtrlSetState($f9setENABLEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f9setENABLEchkbx, $GUI_UNCHECKED)
   EndIf

   If $f9setAddENTER = 1 Then
	  GUICtrlSetState($f9setAddENTERchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f9setAddENTERchkbx, $GUI_UNCHECKED)
   EndIf

   If $f9setAddBACKSPACE = 1 Then
	  GUICtrlSetState($f9setAddBACKSPACEchkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($f9setAddBACKSPACEchkbx, $GUI_UNCHECKED)
   EndIf

   GUISetOnEvent($GUI_EVENT_CLOSE, "f9setClose")
EndFunc

Func f9setClose()
	$f9text = GUICtrlRead($f9setEdit)
	GUICtrlSetData ($f9edit, $f9text)
	IniWrite($sPath_ini, "EditDATA", "$f9text", $f9text)

   If BitAND(GUICtrlRead($f9setENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f9setENABLE = 1
   Else
	 $f9setENABLE = 0
   EndIf

   If BitAND(GUICtrlRead($f9setAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f9setAddENTER = 1
   Else
	 $f9setAddENTER = 0
   EndIf

   If BitAND(GUICtrlRead($f9setAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
	 $f9setAddBACKSPACE = 1
   Else
	 $f9setAddBACKSPACE = 0
   EndIf

   IniWrite($sPath_ini, "EditSET", "$f9setENABLE", $f9setENABLE)
   IniWrite($sPath_ini, "EditSET", "$f9setAddENTER", $f9setAddENTER)
   IniWrite($sPath_ini, "EditSET", "$f9setAddBACKSPACE", $f9setAddBACKSPACE)

   If $f9setENABLE = 1 Then
		GUICtrlSetStyle($f9edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("^{9}", "f9")
   Else
		GUICtrlSetStyle($f9edit, $ES_READONLY)
   EndIf

   GUISetState(@SW_ENABLE, $mainwindow)
   GUIDelete($f9setwin)
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
	MouseClick("left", 749, 541, 1, 0)
	MouseClick("left", 526, 566, 1, 0)
	MouseClick("left", 922, 674, 1, 0)
   ;If $HOMEsetENABLE = 1 Then
	;	Send($HOMEtext)
	;	If $HOMEsetAddBACKSPACE = 1 Then
	;	  Send("{BACKSPACE}")
	;	EndIf
	;	If $HOMEsetAddENTER = 1 Then
	;	  Send("{ENTER}")
	;	EndIf
   ;EndIf
EndFunc

Func PGUP()
	If $PGUPsetENABLE = 1 Then
		If $PGUPsetMouseEnable = 1 Then
			;MouseClick("left", $PGUPsetMouse1x, $PGUPsetMouse1y, 1, 0)
			;MouseClick("left", $PGUPsetMouse2x, $PGUPsetMouse2y, 1, 0)
			MouseClick("left", 749, 541, 1, 0)
			MouseClick("left", 526, 590, 1, 0)
			MouseClick("left", 922, 674, 1, 0)
		Else
			Send($PGUPtext)
			If $PGUPsetAddBACKSPACE = 1 Then
				Send("{BACKSPACE}")
			EndIf
			If $PGUPsetAddENTER = 1 Then
				Send("{ENTER}")
			EndIf
		EndIf
	EndIf
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
		If $PGDNsetMouseEnable = 1 Then
			MouseClick("left", $PGDNsetMouse1x, $PGDNsetMouse1y, 1, 0)
			MouseClick("left", $PGDNsetMouse2x, $PGDNsetMouse2y, 1, 0)
		Else
			Send($PGDNtext)
			If $PGDNsetAddBACKSPACE = 1 Then
				Send("{BACKSPACE}")
			EndIf
			If $PGDNsetAddENTER = 1 Then
				Send("{ENTER}")
			EndIf
		EndIf
	EndIf
EndFunc

Func f1()
   If $f1setENABLE = 1 Then
		Send($f1text)
		If $f1setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f1setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f2()
   If $f2setENABLE = 1 Then
		Send($f2text)
		If $f2setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f2setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f3()
   If $f3setENABLE = 1 Then
		Send($f3text)
		If $f3setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f3setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f4()
   If $f4setENABLE = 1 Then
		Send($f4text)
		If $f4setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f4setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f5()
   If $f5setENABLE = 1 Then
		Send($f5text)
		If $f5setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f5setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f6()
   If $f6setENABLE = 1 Then
		Send($f6text)
		If $f6setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f6setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f7()
   If $f7setENABLE = 1 Then
		Send($f7text)
		If $f7setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f7setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f8()
   If $f8setENABLE = 1 Then
		Send($f8text)
		If $f8setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f8setAddENTER = 1 Then
		  Send("{ENTER}")
		EndIf
   EndIf
EndFunc

Func f9()
   If $f9setENABLE = 1 Then
		Send($f9text)
		If $f9setAddBACKSPACE = 1 Then
		  Send("{BACKSPACE}")
		EndIf
		If $f9setAddENTER = 1 Then
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
		If $detectlang = 0 Then
			$orbtext = ControlGetText($orbh, "", $orbitext)
			Send("{Enter}")
			;ControlSetText ($orbh, "", $orbitext, $orbtext)
			ControlSend ($orbh, "", $orbitext, $orbtext)
			Sleep(100)
			Send("{Enter}")
		ElseIf $detectlang = 1 Then
			fastlangchangeF2()
			$orbtext = ControlGetText($orbh, "", $orbitext)
			Send("{Enter}")
			;ControlSetText ($orbh, "", $orbitext, $orbtext)
			ControlSend ($orbh, "", $orbitext, $orbtext)
			fastlangchangeF1()
			Sleep(100)
			Send("{Enter}")
		ElseIf $detectlang = 2 Then
			fastlangchangeF1()
			$orbtext = ControlGetText($orbh, "", $orbitext)
			Send("{Enter}")
			;ControlSetText ($orbh, "", $orbitext, $orbtext)
			ControlSend ($orbh, "", $orbitext, $orbtext)
			Sleep(100)
			Send("{Enter}")
		EndIf
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


Func SingleScript($iMode = 0)
	; iMode=0  Close all executing scripts with the same name and continue.
	; iMode=1  Wait for completion of predecessor scripts with the same name.
	; iMode=2  Exit if other scripts with the same name are executing.
	; iMode=3  Test, if other scripts with the same name are executing.

	; UDF Name:         _SingleScript.au3
	; Author:       Exit   ( http://www.autoitscript.com/forum/user/45639-exit )
	; SourceCode:   http://www.autoitscript.com/forum/index.php?showtopic=178681   Version: 2021.04.14

    Local $oWMI, $oProcess, $oProcesses, $aHandle, $aError
    Local $sPrefix = StringLeft(@ScriptName, StringInStr(@ScriptName, ".") - 1)
    Local $sMutexName = "_SingleScript " & $sPrefix
    If $iMode < 0 Or $iMode > 3 Then Return SetError(-1, -1, -1)
    If $iMode = 0 Or $iMode = 3 Then ; (iMode = 0) close all other scripts with the same name.  (iMode = 3) check, if others are running.
        $oWMI = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
        If @error Then
            RunWait(@ComSpec & ' /c net start winmgmt  ', '', @SW_HIDE)
            RunWait(@ComSpec & ' /c net continue winmgmt  ', '', @SW_HIDE)
            $oWMI = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
        EndIf
        $oProcesses = $oWMI.ExecQuery("SELECT * FROM Win32_Process", "WQL", 0x30)
        For $oProcess In $oProcesses
            If $oProcess.ProcessId = @AutoItPID Then ContinueLoop
            If ($oProcess.Name = "AutoIt3.exe" And StringInStr($oProcess.CommandLine, "AutoIt3Wrapper")) Then ContinueLoop
            If Not (StringInStr($oProcess.Name & $oProcess.CommandLine, $sPrefix)) Then ContinueLoop
            If $iMode = 3 Then Return SetError(0, 1, 1) ; indicate other script is running. Return value and @extended set to 1.
            Sleep(1000) ; allow previous process to terminate
            If ProcessClose($oProcess.ProcessId) Then ContinueLoop
            MsgBox(262144, "Debug " & @ScriptName, "Error: " & @error & " Extended: " & @extended & @LF & "SingleScript Processclose error: " & $oProcess.Name & @LF & "******", 5)
        Next
    EndIf
    $aHandle = DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", 0, "bool", 1, "wstr", $sMutexName) ; try to create Mutex
    $aError = DllCall("kernel32.dll", "dword", "GetLastError") ; retrieve last error
    If Not $aError[0] Then Return SetError(0, 0, 0)
    If $iMode = "2" Then Exit 1
    If $iMode = "0" Then Return SetError(1, 0, 1) ; should not occur
    DllCall("kernel32.dll", "dword", "WaitForSingleObject", "handle", $aHandle[0], "dword", -1) ; infinite wait for lock
    Return SetError(0, 0, 0)
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