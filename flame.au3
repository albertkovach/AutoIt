#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <Constants.au3>
#include <Timers.au3>
#include <File.au3>
#include <Misc.au3>
#include <Array.au3>

#include <Date.au3>
#include <StaticConstants.au3>

#Include <GUIEdit.au3>
#Include <ScrollBarConstants.au3>

#include "OnEventFunc.au3"

Sleep(100)

Global $VersionText = "ver 8.0"
Global $VersionNumber = 80

$sPath_ini = @ScriptDir & "\prefs.ini"
Global $UpdateRequest = 0
IniWrite($sPath_ini, "ProgramDATA", "$VersionNumber", $VersionNumber)
Global $VersionFileLocation = "\\zorb-srv\Operators\ORBdata\всякое\AutoIT\update channel\version.txt"
Global $UpdateCheckInternalDemand = 0

Global $password = 'туктук'
Global $NoPassword = 1

Global $Rus = '00000419'; Раскладка русского языка
Global $Eng = '00000409'; Раскладка английского языка

GUICheckSize()


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


	_SingleScript(0)

EndFunc




Func Unlocker()
   If $password = GUICtrlRead($INSERTedit) Then
	  InitializeGUI()
   EndIf
EndFunc


Func InitializeGUI()	; Создание все элементов GUI


	Global $REFRESHbtn = GUICtrlCreateButton("Запомнить", 70, 60, 90)
	GUICtrlSetOnEvent($REFRESHbtn, "RefreshAndSave")

	Global $RestartButton = GUICtrlCreateButton("⇆", 603, 9, 18, 18)
	GUICtrlSetFont ( $RestartButton, 13 )
	GUICtrlSetOnEvent($RestartButton, "RestartProgram")
	
	Global $MinimizeWindowButton = GUICtrlCreateButton("\/", 626, 9, 18, 18)
	GUICtrlSetOnEvent($MinimizeWindowButton, "MINIMIZEtoTrayClicked")

	Global $ResizeGUIButton = GUICtrlCreateButton($GUIresizecaption, 15, 97, 20, 20) ; y = 91
	GUICtrlSetOnEvent($ResizeGUIButton, "GUIResize")

	Global $ChatButton = GUICtrlCreateButton("ch", 45, 97, 20, 20)
	GUICtrlSetOnEvent($ChatButton, "ChatOpen")

	Global $SETUPbtn = GUICtrlCreateButton("", 15, 276+$GUIctrltoffset, 20, 20)
	Global $STATUSlabel = GUICtrlCreateLabel("ОК", 18, 279+$GUIctrltoffset-21, 20, 18)
	GUICtrlSetState($STATUSlabel,$GUI_HIDE)
	GUICtrlSetOnEvent($SETUPbtn, "SETUPset")

	Global $Calendarbtn = GUICtrlCreateButton("K", 45, 276+$GUIctrltoffset, 20, 20)
	GUICtrlSetOnEvent($Calendarbtn, "CalendarOpen")

	Global $LANGlabel = GUICtrlCreateLabel("Смена языка в Орбите: F1 - русский, F2 - английский", 360, 260+$GUIctrltoffset, 350, 20)
	Global $INSERTcopyHowTo = GUICtrlCreateLabel("Вставить скопированное на клавишу Insert - F3", 360, 280+$GUIctrltoffset, 350, 25)
	Global $VersionLabel = GUICtrlCreateLabel("ver 2.5 d", 300, 280+$GUIctrltoffset, 45, 15)
	GUICtrlSetData ($VersionLabel, $VersionText)
	
	
	GUICtrlSetState($passwordbtn,$GUI_HIDE)
	SetOnEventA($INSERTlabelbtn, "KeySetup", $paramByVal, "$INSERTtext", $paramByVal, "$INSERTsetENABLE", $paramByVal, "$INSERTsetAddENTER", $paramByVal, "$INSERTsetAddBACKSPACE")
	
	Global $HOMElabelbtn = GUICtrlCreateButton("HOME", 229, 10, 55, 20)
	Global $HOMEedit = GUICtrlCreateInput ( "", 230, 30, 200)
	SetOnEventA($HOMElabelbtn, "KeySetup", $paramByVal, "$HOMEtext", $paramByVal, "$HOMEsetENABLE",	$paramByVal, "$HOMEsetAddENTER", $paramByVal, "$HOMEsetAddBACKSPACE")
	
	Global $PGUPlabelbtn = GUICtrlCreateButton("PGUP", 444, 10, 55, 20)
	Global $PGUPedit = GUICtrlCreateInput ( "", 445, 30, 200)
	SetOnEventA($PGUPlabelbtn, "KeySetup", $paramByVal, "$PGUPtext", $paramByVal, "$PGUPsetENABLE",	$paramByVal, "$PGUPsetAddENTER", $paramByVal, "$PGUPsetAddBACKSPACE")
	
	Global $ENDlabelbtn = GUICtrlCreateButton("END", 229, 70, 55, 20)
	Global $ENDedit = GUICtrlCreateInput ( "", 230, 90, 200)
	SetOnEventA($ENDlabelbtn, "KeySetup", $paramByVal, "$ENDtext", $paramByVal, "$ENDsetENABLE", $paramByVal, "$ENDsetAddENTER", $paramByVal, "$ENDsetAddBACKSPACE")
	
	Global $PGDNlabelbtn = GUICtrlCreateButton("PGDN", 444, 70, 55, 20)
	Global $PGDNedit = GUICtrlCreateInput ( "", 445, 90, 200)
	SetOnEventA($PGDNlabelbtn, "KeySetup", $paramByVal, "$PGDNtext", $paramByVal, "$PGDNsetENABLE",	$paramByVal, "$PGDNsetAddENTER", $paramByVal, "$PGDNsetAddBACKSPACE")
	
	Global $f1labelbtn = GUICtrlCreateButton("F1", 14, 145+$GUIctrlhideoffset, 55, 20)
	Global $f1edit = GUICtrlCreateInput ( "", 15, 165+$GUIctrlhideoffset, 200)
	SetOnEventA($f1labelbtn, "KeySetup", $paramByVal, "$f1text", $paramByVal, "$f1setENABLE", $paramByVal, "$f1setAddENTER", $paramByVal, "$f1setAddBACKSPACE")
	
	Global $f2labelbtn = GUICtrlCreateButton("F2", 229, 145+$GUIctrlhideoffset, 55, 20)
	Global $f2edit = GUICtrlCreateInput ( "", 230, 165+$GUIctrlhideoffset, 200)
	SetOnEventA($f2labelbtn, "KeySetup", $paramByVal, "$f2text", $paramByVal, "$f2setENABLE", $paramByVal, "$f2setAddENTER", $paramByVal, "$f2setAddBACKSPACE")
	
	Global $f3labelbtn = GUICtrlCreateButton("F3", 444, 145+$GUIctrlhideoffset, 55, 20)
	Global $f3edit = GUICtrlCreateInput ( "", 445, 165+$GUIctrlhideoffset, 200)
	SetOnEventA($f3labelbtn, "KeySetup", $paramByVal, "$f3text", $paramByVal, "$f3setENABLE", $paramByVal, "$f3setAddENTER", $paramByVal, "$f3setAddBACKSPACE")
	
	Global $f4labelbtn = GUICtrlCreateButton("F4", 14, 200+$GUIctrlhideoffset, 55, 20)
	Global $f4edit = GUICtrlCreateInput ( "", 15, 220+$GUIctrlhideoffset, 200)
	SetOnEventA($f4labelbtn, "KeySetup", $paramByVal, "$f4text", $paramByVal, "$f4setENABLE", $paramByVal, "$f4setAddENTER", $paramByVal, "$f4setAddBACKSPACE")

	Global $f5labelbtn = GUICtrlCreateButton("F5", 229, 200+$GUIctrlhideoffset, 55, 20)
	Global $f5edit = GUICtrlCreateInput ( "", 230, 220+$GUIctrlhideoffset, 200)
	SetOnEventA($f5labelbtn, "KeySetup", $paramByVal, "$f5text", $paramByVal, "$f5setENABLE", $paramByVal, "$f5setAddENTER", $paramByVal, "$f5setAddBACKSPACE")
	
	Global $f6labelbtn = GUICtrlCreateButton("F6", 444, 200+$GUIctrlhideoffset, 55, 20)
	Global $f6edit = GUICtrlCreateInput ( "", 445, 220+$GUIctrlhideoffset, 200)
	SetOnEventA($f6labelbtn, "KeySetup", $paramByVal, "$f6text", $paramByVal, "$f6setENABLE", $paramByVal, "$f6setAddENTER", $paramByVal, "$f6setAddBACKSPACE")
	
	Global $f7labelbtn = GUICtrlCreateButton("F7", 14, 255+$GUIctrlhideoffset, 55, 20)
	Global $f7edit = GUICtrlCreateInput ( "", 15, 275+$GUIctrlhideoffset, 200)
	SetOnEventA($f7labelbtn, "KeySetup", $paramByVal, "$f7text", $paramByVal, "$f7setENABLE", $paramByVal, "$f7setAddENTER", $paramByVal, "$f7setAddBACKSPACE")
	
	Global $f8labelbtn = GUICtrlCreateButton("F8", 229, 255+$GUIctrlhideoffset, 55, 20)
	Global $f8edit = GUICtrlCreateInput ( "", 230, 275+$GUIctrlhideoffset, 200)
	SetOnEventA($f8labelbtn, "KeySetup", $paramByVal, "$f8text", $paramByVal, "$f8setENABLE", $paramByVal, "$f8setAddENTER", $paramByVal, "$f8setAddBACKSPACE")
	
	Global $f9labelbtn = GUICtrlCreateButton("F9", 444, 255+$GUIctrlhideoffset, 55, 20)
	Global $f9edit = GUICtrlCreateInput ( "", 445, 275+$GUIctrlhideoffset, 200)
	SetOnEventA($f9labelbtn, "KeySetup", $paramByVal, "$f9text", $paramByVal, "$f9setENABLE", $paramByVal, "$f9setAddENTER", $paramByVal, "$f9setAddBACKSPACE")
	
	Global $numpluslabelbtn = GUICtrlCreateButton("NUM +", 84, 255+$GUIctrltoffset, 55, 20)
	Global $numplusedit = GUICtrlCreateInput ( "", 85, 275+$GUIctrltoffset, 200)
	;GUICtrlSetOnEvent($numpluslabelbtn, "RestartProgram")
	SetOnEventA($numpluslabelbtn, "KeySetup", $paramByVal, "$numplustext", $paramByVal, "$numplussetENABLE", $paramByVal, "$numplussetAddENTER", $paramByVal, "$numplussetAddBACKSPACE")


	If $minimizetotray = 1 Then
		GUICtrlSetState($MinimizeWindowButton,$GUI_HIDE)
	EndIf

	ReloadPrefs()
EndFunc


Func RefreshAndSave()	; Чтение всех полей и запись в INI
	$INSERTtext = GUICtrlRead($INSERTedit)
	$ENDtext = GUICtrlRead($ENDedit)
	$PGDNtext = GUICtrlRead($PGDNedit)
	$HOMEtext = GUICtrlRead($HOMEedit)
	$PGUPtext = GUICtrlRead($PGUPedit)
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

	IniWrite($sPath_ini, "EditDATA", "$INSERTtext", $INSERTtext)
	IniWrite($sPath_ini, "EditDATA", "$ENDtext", $ENDtext)
	IniWrite($sPath_ini, "EditDATA", "$PGDNtext", $PGDNtext)
	IniWrite($sPath_ini, "EditDATA", "$HOMEtext", $HOMEtext)
	IniWrite($sPath_ini, "EditDATA", "$PGUPtext", $PGUPtext)

	IniWrite($sPath_ini, "EditDATA", "$f1text", $f1text)
	IniWrite($sPath_ini, "EditDATA", "$f2text", $f2text)
	IniWrite($sPath_ini, "EditDATA", "$f3text", $f3text)
	IniWrite($sPath_ini, "EditDATA", "$f4text", $f4text)
	IniWrite($sPath_ini, "EditDATA", "$f5text", $f5text)
	IniWrite($sPath_ini, "EditDATA", "$f6text", $f6text)
	IniWrite($sPath_ini, "EditDATA", "$f7text", $f7text)
	IniWrite($sPath_ini, "EditDATA", "$f8text", $f8text)
	IniWrite($sPath_ini, "EditDATA", "$f9text", $f9text)

	If $NumPLUSsetDETECT = 0 Then
		IniWrite($sPath_ini, "EditDATA", "$numplustext", $numplustext)
	EndIf

	IniWrite($sPath_ini, "DetectDATA", "$orbhtext", $orbhtext)
	IniWrite($sPath_ini, "DetectDATA", "$orbitext", $orbitext)
EndFunc


Func ReloadPrefs()		; Чтение INI и запись в поля, сцеплен с ApplyStates()
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

	Global $f1text = IniRead($sPath_ini, "EditDATA", "$f1text", "")
	Global $f1setENABLE = IniRead($sPath_ini, "EditSET", "$f1setENABLE", "0")
	Global $f1setAddENTER = IniRead($sPath_ini, "EditSET", "$f1setAddENTER", "1")
	Global $f1setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f1setAddBACKSPACE", "0")

	Global $f2text = IniRead($sPath_ini, "EditDATA", "$f2text", "")
	Global $f2setENABLE = IniRead($sPath_ini, "EditSET", "$f2setENABLE", "0")
	Global $f2setAddENTER = IniRead($sPath_ini, "EditSET", "$f2setAddENTER", "1")
	Global $f2setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f2setAddBACKSPACE", "0")

	Global $f3text = IniRead($sPath_ini, "EditDATA", "$f3text", "")
	Global $f3setENABLE = IniRead($sPath_ini, "EditSET", "$f3setENABLE", "0")
	Global $f3setAddENTER = IniRead($sPath_ini, "EditSET", "$f3setAddENTER", "1")
	Global $f3setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f3setAddBACKSPACE", "0")

	Global $f4text = IniRead($sPath_ini, "EditDATA", "$f4text", "")
	Global $f4setENABLE = IniRead($sPath_ini, "EditSET", "$f4setENABLE", "0")
	Global $f4setAddENTER = IniRead($sPath_ini, "EditSET", "$f4setAddENTER", "1")
	Global $f4setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f4setAddBACKSPACE", "0")

	Global $f5text = IniRead($sPath_ini, "EditDATA", "$f5text", "")
	Global $f5setENABLE = IniRead($sPath_ini, "EditSET", "$f5setENABLE", "0")
	Global $f5setAddENTER = IniRead($sPath_ini, "EditSET", "$f5setAddENTER", "1")
	Global $f5setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f5setAddBACKSPACE", "0")

	Global $f6text = IniRead($sPath_ini, "EditDATA", "$f6text", "")
	Global $f6setENABLE = IniRead($sPath_ini, "EditSET", "$f6setENABLE", "0")
	Global $f6setAddENTER = IniRead($sPath_ini, "EditSET", "$f6setAddENTER", "1")
	Global $f6setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f6setAddBACKSPACE", "0")

	Global $f7text = IniRead($sPath_ini, "EditDATA", "$f7text", "")
	Global $f7setENABLE = IniRead($sPath_ini, "EditSET", "$f7setENABLE", "0")
	Global $f7setAddENTER = IniRead($sPath_ini, "EditSET", "$f7setAddENTER", "1")
	Global $f7setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f7setAddBACKSPACE", "0")

	Global $f8text = IniRead($sPath_ini, "EditDATA", "$f8text", "")
	Global $f8setENABLE = IniRead($sPath_ini, "EditSET", "$f8setENABLE", "0")
	Global $f8setAddENTER = IniRead($sPath_ini, "EditSET", "$f8setAddENTER", "1")
	Global $f8setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f8setAddBACKSPACE", "0")

	Global $f9text = IniRead($sPath_ini, "EditDATA", "$f9text", "")
	Global $f9setENABLE = IniRead($sPath_ini, "EditSET", "$f9setENABLE", "0")
	Global $f9setAddENTER = IniRead($sPath_ini, "EditSET", "$f9setAddENTER", "1")
	Global $f9setAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$f9setAddBACKSPACE", "0")

	Global $numplustext = IniRead($sPath_ini, "EditDATA", "$numplustext", "")
	Global $NumPLUSsetENABLE = IniRead($sPath_ini, "EditSET", "$NumPLUSsetENABLE", "0")
	Global $NumPLUSsetAddENTER = IniRead($sPath_ini, "EditSET", "$NumPLUSsetAddENTER", "1")
	Global $NumPLUSsetAddBACKSPACE = IniRead($sPath_ini, "EditSET", "$NumPLUSsetAddBACKSPACE", "0")
	Global $NumPLUSsetDETECT = IniRead($sPath_ini, "EditSET", "$NumPLUSsetDETECT", "0")

	Global $detectlang = IniRead($sPath_ini, "ProgramDATA", "$detectlang", "0")
	Global $langfastchange = IniRead($sPath_ini, "ProgramDATA", "$langfastchange", "0")
	Global $clipboardpaste = IniRead($sPath_ini, "ProgramDATA", "$clipboardpaste", "0")
	Global $minimizetotray = IniRead($sPath_ini, "ProgramDATA", "$minimizetotray", "0")

	$orbhtext = IniRead($sPath_ini, "DetectDATA", "$orbhtext", "")
	$orbitext = IniRead($sPath_ini, "DetectDATA", "$orbitext", "")
	;$orbhfulltext = "[CLASS:" & $orbhtext & "]"
	$orbhfulltext = "[HANDLE:" & $orbhtext & "]"
	$orbh = WinGetHandle($orbhfulltext)

	GUICtrlSetData ($INSERTedit, $INSERTtext)
	GUICtrlSetData ($ENDedit, $ENDtext)
	GUICtrlSetData ($PGDNedit, $PGDNtext)
	GUICtrlSetData ($HOMEedit, $HOMEtext)
	GUICtrlSetData ($PGUPedit, $PGUPtext)

	GUICtrlSetData ($f1edit, $f1text)
	GUICtrlSetData ($f2edit, $f2text)
	GUICtrlSetData ($f3edit, $f3text)
	GUICtrlSetData ($f4edit, $f4text)
	GUICtrlSetData ($f5edit, $f5text)
	GUICtrlSetData ($f6edit, $f6text)
	GUICtrlSetData ($f7edit, $f7text)
	GUICtrlSetData ($f8edit, $f8text)
	GUICtrlSetData ($f9edit, $f9text)
	GUICtrlSetData ($numplusedit, $numplustext)

	ApplyStates()
EndFunc


Func ApplyStates()		; Применение стилей полей и HotKeySet
	If $INSERTsetENABLE = 1 Then
		GUICtrlSetStyle($INSERTedit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{INSERT}", "INSERT")
	Else
		GUICtrlSetStyle($INSERTedit, $ES_READONLY)
		HotKeySet("{INSERT}")
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


	If $f4setENABLE = 1 Then
		GUICtrlSetStyle($f4edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{F4}", "f4")
	Else
		GUICtrlSetStyle($f4edit, $ES_READONLY)
		HotKeySet("{F4}")
	EndIf

	If $f5setENABLE = 1 Then
		GUICtrlSetStyle($f5edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{F5}", "f5")
	Else
		GUICtrlSetStyle($f5edit, $ES_READONLY)
		HotKeySet("{F5}")
	EndIf

	If $f6setENABLE = 1 Then
		GUICtrlSetStyle($f6edit, $GUI_SS_DEFAULT_INPUT)
		HotKeySet("{F6}", "f6")
	Else
		GUICtrlSetStyle($f6edit, $ES_READONLY)
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

	;HotKeySet("{F8}", "Test")

	DetectCheck()
	FastLangCheck()
	FastClipPasteCheck()

	UpdateCheck()
EndFunc


Func GUICheckSize()
	Global $GUIsize = IniRead($sPath_ini, "ProgramDATA", "$GUIsize", "0")

	Global $GUIheight
	Global $GUIctrltoffset
	Global $GUIctrlhideoffset
	Global $GUIresizecaption
	If $GUIsize = 0 Then
		$GUIsize = 0
		$GUIheight = 175
		$GUIctrltoffset = -135
		$GUIctrlhideoffset = 150
		$GUIresizecaption = "+"
	Else
		$GUIsize = 1
		$GUIheight = 367
		$GUIctrltoffset = 55
		$GUIctrlhideoffset = 0
		$GUIresizecaption = "-"
	EndIf
EndFunc


Func GUIResize()
	If $GUIsize = 1 Then
		$GUIsize = 0
		$GUIheight = 175
		$GUIctrltoffset = -135
		$GUIctrlhideoffset = 150
		$GUIresizecaption = "+"
	Else
		$GUIsize = 1
		$GUIheight = 367
		$GUIctrltoffset = 55
		$GUIctrlhideoffset = 0
		$GUIresizecaption = "-"
	EndIf

	IniWrite($sPath_ini, "ProgramDATA", "$GUIsize", $GUIsize)
	
	GUIDelete($mainwindow)

	CreateGUI()
EndFunc





Func FastLangCheck()
	If $f1setENABLE == 1 OR $f2setENABLE == 1 Then
		If $f1setENABLE == 0 Then 
			GUICtrlSetStyle($f1edit, $ES_READONLY)
			HotKeySet("{F1}", "")
		Else
			GUICtrlSetStyle($f1edit, $GUI_SHOW)
			HotKeySet("{F1}", "f1")
		EndIf

		If $f2setENABLE == 0 Then 
			GUICtrlSetStyle($f2edit, $ES_READONLY)
			HotKeySet("{F2}", "")
		Else
			GUICtrlSetStyle($f2edit, $GUI_SHOW)
			HotKeySet("{F2}", "f2")
		EndIf
		
		
		If $langfastchange == 1 Then
			GUICtrlSetState($LANGlabel, $GUI_SHOW)
			GUICtrlSetData($LANGlabel, "Отключите клавиши F1 и F2 для быстрой смены языка !")
		EndIf
	Else
		GUICtrlSetStyle($f1edit, $ES_READONLY)
		GUICtrlSetStyle($f2edit, $ES_READONLY)

		If $langfastchange == 1 Then
			GUICtrlSetState($LANGlabel, $GUI_SHOW)
			
			If WinGetHandle($orbhfulltext) = 0 Then
				GUICtrlSetData($LANGlabel, "Для быстрой смены языка настройте Handle Орбиты !")
			Else
				GUICtrlSetData($LANGlabel, "Смена языка в Орбите: F1 - русский, F2 - английский")
				HotKeySet("{F1}", "fastlangchangeF1")
				HotKeySet("{F2}", "fastlangchangeF2")
			EndIf
		EndIf
	EndIf
	
	
	If $langfastchange == 0 Then
		GUICtrlSetState($LANGlabel, $GUI_HIDE)
		
		If $f1setENABLE == 0 OR $f2setENABLE == 0 Then
			HotKeySet("{F1}", "")
			HotKeySet("{F2}", "")
		EndIf
	EndIf
	
EndFunc


Func FastClipPasteCheck()
	If $f3setENABLE == 0 Then
		GUICtrlSetStyle($f3edit, $ES_READONLY)
		
		If $clipboardpaste == 1 Then
			HotKeySet("{F3}", "INSERTcopy")
			GUICtrlSetState($INSERTcopyHowTo, $GUI_SHOW)
			GUICtrlSetData($INSERTcopyHowTo, "Нажмите F3 для вставки буфера на клавишу INSERT")
		Else
			HotKeySet("{F3}")
			GUICtrlSetState($INSERTcopyHowTo, $GUI_HIDE)
		EndIf
			
	Else
		HotKeySet("{F3}", "f3")
		GUICtrlSetStyle($f3edit, $GUI_SS_DEFAULT_INPUT)
		
		If $clipboardpaste == 1 Then
			GUICtrlSetState($INSERTcopyHowTo, $GUI_SHOW)
			GUICtrlSetData($INSERTcopyHowTo, "Отключите клавишу F3 для работы с быстрым буфером !")
		Else
			GUICtrlSetState($INSERTcopyHowTo, $GUI_HIDE)
		EndIf
	EndIf

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
	Global $SETUPsetwin = GUICreate("Настройки",300,250+40)
	GUISetOnEvent($GUI_EVENT_CLOSE, "SETUPsetClose")
	GUISetState(@SW_SHOW)

	Global $autotunebtn = GUICtrlCreateButton("Автопоиск настроек Detect", 15, 15, 200)
	GUICtrlSetOnEvent($autotunebtn, "AutotuneSet")

	Global $orbhlabel = GUICtrlCreateLabel("ORBita Window Handle:", 15+10, 15+35, 120, 20)
	Global $orbhinput = GUICtrlCreateInput ( "", 15+10, 32+35, 270-10) 						; y + 17
	Global $orbilabel = GUICtrlCreateLabel("Control ClassnameNN:", 15+10, 60+35, 120, 20)  ; y + 28
	Global $orbiinput = GUICtrlCreateInput ( "", 15+10, 77+35, 270-10)

	Global $orbichkbtn = GUICtrlCreateButton("Проверка", 15, 105+35, 60)
	Global $orbichklabel = GUICtrlCreateLabel("Тут должен быть текст выбранного поля", 85, 110+35, 120)
	GUICtrlSetOnEvent($orbichkbtn, "SETUPcheck")

	Global $orbidtlnglabel = GUICtrlCreateLabel("Принудительный язык:", 15, 110+25+35, 118, 20)
	Global $orbidtlngchkbxauto = GUICtrlCreateCheckbox("Auto", 155, 110+20+35)
	Global $orbidtlngchkbxeng = GUICtrlCreateCheckbox("Eng", 200, 110+20+35)
	Global $orbidtlngchkbxrus = GUICtrlCreateCheckbox("Rus", 245, 110+20+35)
	GUICtrlSetOnEvent($orbidtlngchkbxauto, "SETUPdetectLngChkAuto")
	GUICtrlSetOnEvent($orbidtlngchkbxeng, "SETUPdetectLngChkEng")
	GUICtrlSetOnEvent($orbidtlngchkbxrus, "SETUPdetectLngChkRus")
	
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

   Global $langfastchangechkbx = GUICtrlCreateCheckbox("Включить переключение языка на F1 - F2", 17, 140+20+35, 250)
   If $langfastchange = 1 Then
	  GUICtrlSetState($langfastchangechkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($langfastchangechkbx, $GUI_UNCHECKED)
   EndIf

   Global $clipboardpastechkbx = GUICtrlCreateCheckbox("Включить вставку на F3", 17, 160+20+35, 250)
   If $clipboardpaste = 1 Then
	  GUICtrlSetState($clipboardpastechkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($clipboardpastechkbx, $GUI_UNCHECKED)
   EndIf

   Global $minimizetotraychkbx = GUICtrlCreateCheckbox("Сворачивать в трей", 17, 180+20+35, 250)
   If $minimizetotray = 1 Then
	  GUICtrlSetState($minimizetotraychkbx, $GUI_CHECKED)
   Else
	  GUICtrlSetState($minimizetotraychkbx, $GUI_UNCHECKED)
   EndIf

   Global $updatecheckbtn = GUICtrlCreateButton("Проверить обновления", 15, 205+20+35, 130, 20)
   GUICtrlSetOnEvent($updatecheckbtn, "UpdateCheckManual")

   $orbtext = ControlGetText($orbh, "", $orbitext)
   GUICtrlSetData ($orbichklabel, $orbtext)

   ;Global $setuprefrbtn = GUICtrlCreateButton("Обновить поля", 200, 8, 85, 20)
   ;GUICtrlSetOnEvent($setuprefrbtn, "SETUPcheck")

   GUICtrlSetData ($orbhinput, $orbhtext)
   GUICtrlSetData ($orbiinput, $orbitext)
EndFunc


Func SETUPdetectLngChkAuto()
	If BitAND(GUICtrlRead($orbidtlngchkbxauto), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($orbidtlngchkbxeng, $GUI_UNCHECKED)
		GUICtrlSetState($orbidtlngchkbxrus, $GUI_UNCHECKED)
	EndIf
EndFunc

Func SETUPdetectLngChkEng()
	If BitAND(GUICtrlRead($orbidtlngchkbxeng), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($orbidtlngchkbxauto, $GUI_UNCHECKED)
		GUICtrlSetState($orbidtlngchkbxrus, $GUI_UNCHECKED)
	EndIf
EndFunc

Func SETUPdetectLngChkRus()
	If BitAND(GUICtrlRead($orbidtlngchkbxrus), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($orbidtlngchkbxauto, $GUI_UNCHECKED)
		GUICtrlSetState($orbidtlngchkbxeng, $GUI_UNCHECKED)
	EndIf
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
   GUIDelete($SETUPsetwin)

	If $minimizetotray = 1 Then
		GUICtrlSetState($MinimizeWindowButton,$GUI_HIDE)
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "MINIMIZEtoTrayClicked")
	Else
		GUICtrlSetState($MinimizeWindowButton,$GUI_SHOW)
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "MINIMIZEtoTasksClicked")
	EndIf

	ApplyStates()
	FastLangCheck()
	FastClipPasteCheck()
EndFunc





Func AutotuneSet()
	$autotwinh = WinGetHandle("[REGEXPCLASS:(?i)WindowsForms10.Window.8.app.0.21*]")
	
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "", "Невозможно найти Handle Орбиты !" & @CRLF & "Проверьте, запущена ли она или введите вручную !")
		;Exit
	Else
		GUISetState(@SW_DISABLE, $SETUPsetwin)
		Global $autotunewin = GUICreate("Автопоиск",240,150)
		GUISetOnEvent($GUI_EVENT_CLOSE, "AutotuneSetClose")
		GUISetState(@SW_SHOW)

		Global $autotconnstatus = GUICtrlCreateLabel("Найден ORBita Window Handle !", 15, 15)
		Global $autotconnh = GUICtrlCreateInput("0x00000000000C024C", 15, 32)
		GUICtrlSetStyle($autotconnh, $ES_READONLY)

		Global $orbtlabel = GUICtrlCreateLabel("Введите текущий текст искомого поля:", 15, 15+45, 210, 20)  ; y + 28
		Global $orbtinput = GUICtrlCreateInput ( "", 15, 32+45, 210)

		Global $autotcontrbtn = GUICtrlCreateButton("Поиск", 14, 57+45, 60, 22)
		GUICtrlSetOnEvent($autotcontrbtn, "AutotuneCtrlFind")

		GUICtrlSetData ($orbhinput, $autotwinh)
	EndIf

EndFunc


Func AutotuneCtrlFind()
	$autotctrh = WinGetHandle("[REGEXPCLASS:(?i)WindowsForms10.Window.8.app.0.21*]")
	
	$orbttext = GUICtrlRead($orbtinput)
	
	$ControlClNN = _FindControlHandleByText($autotctrh, $orbttext)
	
	If $ControlClNN == "0" Then
		MsgBox($MB_SYSTEMMODAL, "Автопоиск", "Невозможно найти этот текст в окне программы !")
	Else
		MsgBox($MB_SYSTEMMODAL, "Автопоиск", "Найден ClassnameNN !" & @CRLF & $ControlClNN)
		GUICtrlSetData ($orbiinput, $ControlClNN)
		AutotuneSetClose()
	EndIf

EndFunc


Func AutotuneSetClose()
   GUISetState(@SW_ENABLE, $SETUPsetwin)
   GUIDelete($autotunewin)
   SETUPcheck()
EndFunc






Func KeySetup($KeyTextIni, $KeyEnabledIni, $KeyAddEnterIni, $KeyAddBackspaceIni)
	Global $KeyTextIniToF = $KeyTextIni
	Global $KeyEnabledIniToF = $KeyEnabledIni
	Global $KeyAddEnterIniToF = $KeyAddEnterIni
	Global $KeyAddBackspaceIniToF = $KeyAddBackspaceIni
	
	Global $KeyText = IniRead($sPath_ini, "EditDATA", $KeyTextIniToF, "")
	Global $KeyENABLE = IniRead($sPath_ini, "EditSET", $KeyEnabledIniToF, "1")
	Global $KeyAddENTER = IniRead($sPath_ini, "EditSET", $KeyAddEnterIniToF, "1")
	Global $KeyAddBACKSPACE = IniRead($sPath_ini, "EditSET", $KeyAddBackspaceIniToF, "0")

	Local $guimargin

	GUISetState(@SW_DISABLE, $mainwindow)
	If KeySetupNameDetect($KeyTextIni) == "Клавиша NUM +" Then
		$guimargin = 10
		Global $keysetupwin = GUICreate(KeySetupNameDetect($KeyTextIni),300, 360)
		GUISetState(@SW_SHOW)
		
		Global $KeySetupDETECTchkbx = GUICtrlCreateCheckbox("Detect", 15, 75)
		If $NumPLUSsetDETECT = 1 Then
			GUICtrlSetState($KeySetupDETECTchkbx, $GUI_CHECKED)
		Else
			GUICtrlSetState($KeySetupDETECTchkbx, $GUI_UNCHECKED)
		EndIf
	Else
		$guimargin = 0
		Global $keysetupwin = GUICreate(KeySetupNameDetect($KeyTextIni),300, 350+$guimargin)
		GUISetState(@SW_SHOW)
	EndIf
	
	
	Global $KeySetupENABLEchkbx = GUICtrlCreateCheckbox("Включить", 15, 15)
	If $KeyENABLE = 1 Then
		GUICtrlSetState($KeySetupENABLEchkbx, $GUI_CHECKED)
	Else
		GUICtrlSetState($KeySetupENABLEchkbx, $GUI_UNCHECKED)
	EndIf
	
	Global $KeySetupAddENTERchkbx = GUICtrlCreateCheckbox("Добавлять ENTER", 15, 35)
	If $KeyAddENTER = 1 Then
		GUICtrlSetState($KeySetupAddENTERchkbx, $GUI_CHECKED)
	Else
		GUICtrlSetState($KeySetupAddENTERchkbx, $GUI_UNCHECKED)
	EndIf
	
	Global $KeySetupAddBACKSPACEchkbx = GUICtrlCreateCheckbox("Добавлять BACKSPACE", 15, 55)  ; y + 20
	If $KeyAddBACKSPACE = 1 Then
		GUICtrlSetState($KeySetupAddBACKSPACEchkbx, $GUI_CHECKED)
	Else
		GUICtrlSetState($KeySetupAddBACKSPACEchkbx, $GUI_UNCHECKED)
	EndIf
	
	Local $KeySetupEditName = GUICtrlCreateLabel("Увеличенное поле данных", 80, 90+$guimargin, 160, 20)
	Global $KeySetupEdit = GUICtrlCreateEdit("", 15, 110+$guimargin, 270, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))  ; y + 20
	GUICtrlSetData ($KeySetupEdit, $KeyText)
	
	Global $KeySetupHelpbtn = GUICtrlCreateButton("？", 267, 87+$guimargin, 18, 18)
	GUICtrlSetFont ($RestartButton, 13)
	GUICtrlSetOnEvent($KeySetupHelpbtn, "CommandInterpreterHowTo")
	
	Global $KeySetupResetbtn = GUICtrlCreateButton("⌧", 244, 87+$guimargin, 18, 18)
	GUICtrlSetFont ($KeySetupResetbtn, 11)
	GUICtrlSetOnEvent($KeySetupResetbtn, "KeySetupResetEdit")
	
	Global $AddEnterBtn = GUICtrlCreateButton("ENTER", 14, 270+$guimargin, 85, 20)
	Global $AddBackspaceBtn = GUICtrlCreateButton("BACKSPACE", 107, 270+$guimargin, 85, 20)
	Global $AddDeleteBtn = GUICtrlCreateButton("DELETE", 200, 270+$guimargin, 86, 20)
	Global $AddEscBtn = GUICtrlCreateButton("ESC", 14, 270+$guimargin+25, 85, 20)
	Global $AddArrowsBtn = GUICtrlCreateButton("Добавить стрелки", 107, 270+$guimargin+25, 179, 20)
	Global $StartMouseLearn = GUICtrlCreateButton("Добавить клик мыши", 14, 270+$guimargin+50, 133, 20)
	Global $AddSleepBtn = GUICtrlCreateButton("Добавить задержку", 153, 270+$guimargin+50, 133, 20)

	SetOnEventA($AddEnterBtn, "KeySetupAdd", $paramByVal, "e")
	SetOnEventA($AddBackspaceBtn, "KeySetupAdd", $paramByVal, "b")
	SetOnEventA($AddDeleteBtn, "KeySetupAdd", $paramByVal, "d")
	SetOnEventA($AddEscBtn, "KeySetupAdd", $paramByVal, "c")
	SetOnEventA($AddArrowsBtn, "KeySetupAdd", $paramByVal, "a")
	GUICtrlSetOnEvent($StartMouseLearn, "SetMouseClickInitialize")
	SetOnEventA($AddSleepBtn, "KeySetupAdd", $paramByVal, "s")
	
	
	SetOnEventA($GUI_EVENT_CLOSE, "KeySetupClose", $paramByVal, $KeyTextIniToF, $paramByVal, $KeyEnabledIniToF, $paramByVal, $KeyAddEnterIniToF, $paramByVal, $KeyAddBackspaceIniToF)
EndFunc


Func KeySetupResetEdit()
	$KeyText = ""
	IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
	GUICtrlSetData ($KeySetupEdit, $KeyText)
EndFunc


Func KeySetupAdd($type)
	GUISetState(@SW_DISABLE, $keysetupwin)
	Global $KeySetupAddType = $type

	If $KeySetupAddType == "e" Then
		Global $keysetupaddenterwin = GUICreate("ENTER", 240, 50)
		GUISetState(@SW_SHOW)
		GUISetOnEvent($GUI_EVENT_CLOSE, "KeySetupAddClose")
		
		Local $label = GUICtrlCreateLabel("Количество нажатий:", 10, 18, 115, 20)
		Global $KeySetupAddEdit = GUICtrlCreateInput("1", 125, 14, 25)
		
		Local $btn = GUICtrlCreateButton("Добавить", 160, 13, 70, 22)
		SetOnEventA($btn, "KeySetupAddOk", $paramByVal, "e")
		
	ElseIf $KeySetupAddType == "b" Then
		Global $keysetupaddenterwin = GUICreate("BACKSPACE", 240, 50)
		GUISetState(@SW_SHOW)
		GUISetOnEvent($GUI_EVENT_CLOSE, "KeySetupAddClose")
		
		Local $label = GUICtrlCreateLabel("Количество нажатий:", 10, 18, 115, 20)
		Global $KeySetupAddEdit = GUICtrlCreateInput("1", 125, 14, 25)
		
		Local $btn = GUICtrlCreateButton("Добавить", 160, 13, 70, 22)
		SetOnEventA($btn, "KeySetupAddOk", $paramByVal, "b")
		
	ElseIf $KeySetupAddType == "d" Then
		Global $keysetupaddenterwin = GUICreate("DELETE", 240, 50)
		GUISetState(@SW_SHOW)
		GUISetOnEvent($GUI_EVENT_CLOSE, "KeySetupAddClose")
		
		Local $label = GUICtrlCreateLabel("Количество нажатий:", 10, 18, 115, 20)
		Global $KeySetupAddEdit = GUICtrlCreateInput("1", 125, 14, 25)
		
		Local $btn = GUICtrlCreateButton("Добавить", 160, 13, 70, 22)
		SetOnEventA($btn, "KeySetupAddOk", $paramByVal, "d")
		
	ElseIf $KeySetupAddType == "c" Then
		Global $keysetupaddenterwin = GUICreate("ESC", 240, 50)
		GUISetState(@SW_SHOW)
		GUISetOnEvent($GUI_EVENT_CLOSE, "KeySetupAddClose")
		
		Local $label = GUICtrlCreateLabel("Количество нажатий:", 10, 18, 115, 20)
		Global $KeySetupAddEdit = GUICtrlCreateInput("1", 125, 14, 25)
		
		Local $btn = GUICtrlCreateButton("Добавить", 160, 13, 70, 22)
		SetOnEventA($btn, "KeySetupAddOk", $paramByVal, "c")
		
	ElseIf $KeySetupAddType == "s" Then
		Global $keysetupaddenterwin = GUICreate("Задержка", 240+5, 65)
		GUISetState(@SW_SHOW)
		GUISetOnEvent($GUI_EVENT_CLOSE, "KeySetupAddClose")
		
		Local $label1 = GUICtrlCreateLabel("Введите задержку:", 10, 18, 115, 20)
		Global $KeySetupAddEdit = GUICtrlCreateInput("50", 125-5, 14, 30)
		Local $label2 = GUICtrlCreateLabel("Примеры: 50 - 0.5сек, 100 - 1сек и тд", 20, 40, 200, 20)
		
		Local $btn = GUICtrlCreateButton("Добавить", 160+5, 13, 70, 22)
		SetOnEventA($btn, "KeySetupAddOk", $paramByVal, "s")
		
	ElseIf $KeySetupAddType == "a" Then
		Global $keysetupaddenterwin = GUICreate("Стрелки", 215, 100)
		GUISetState(@SW_SHOW)
		GUISetOnEvent($GUI_EVENT_CLOSE, "KeySetupAddClose")
		
		Local $btnu = GUICtrlCreateButton("Вверх", 70+10, 10, 55, 22)
		Local $btnl = GUICtrlCreateButton("Влево", 10+10, 37, 55, 22);+27
		Local $btnd = GUICtrlCreateButton("Вниз", 70+10, 37, 55, 22)
		Local $btnr = GUICtrlCreateButton("Вправо", 130+10, 37, 55, 22)
		
		SetOnEventA($btnu, "KeySetupAddOk", $paramByVal, "au")
		SetOnEventA($btnl, "KeySetupAddOk", $paramByVal, "al")
		SetOnEventA($btnd, "KeySetupAddOk", $paramByVal, "ad")
		SetOnEventA($btnr, "KeySetupAddOk", $paramByVal, "ar")
		
		Local $label = GUICtrlCreateLabel("Количество нажатий:", 10+10, 70, 115, 20)
		Global $KeySetupAddEdit = GUICtrlCreateInput("1", 125+10, 66, 25)
	EndIf
EndFunc


Func KeySetupAddOk($type)
	If StringIsDigit(GUICtrlRead($KeySetupAddEdit)) == "1" Then
		If $type == "e" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{ENTER}"
			Else
				$KeyText = $KeyText & "{ENTER " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
		ElseIf $type == "b" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{BACKSPACE}"
			Else
				$KeyText = $KeyText & "{BACKSPACE " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
		ElseIf $type == "d" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{DELETE}"
			Else
				$KeyText = $KeyText & "{DELETE " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
		ElseIf $type == "c" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{ESC}"
			Else
				$KeyText = $KeyText & "{ESC " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
			
			
		ElseIf $type == "s" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) <> "" Then
				$KeyText = $KeyText & "{Sleep " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
			
			
		ElseIf $type == "au" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{UP}"
			Else
				$KeyText = $KeyText & "{UP " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
		ElseIf $type == "al" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{LEFT}"
			Else
				$KeyText = $KeyText & "{LEFT " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
		ElseIf $type == "ad" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{DOWN}"
			Else
				$KeyText = $KeyText & "{DOWN " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
		ElseIf $type == "ar" Then
			$KeyText = GUICtrlRead($KeySetupEdit)
			If GUICtrlRead($KeySetupAddEdit) == "" OR GUICtrlRead($KeySetupAddEdit) == "1" Then
				$KeyText = $KeyText & "{RIGHT}"
			Else
				$KeyText = $KeyText & "{RIGHT " & GUICtrlRead($KeySetupAddEdit) & "}"
			EndIf
			IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
			GUICtrlSetData ($KeySetupEdit, $KeyText)
			
		EndIf
		
		KeySetupAddClose()
	Else
		MsgBox ($MB_ICONERROR, "Ошибка !", "Введите число !")
	EndIf
EndFunc


Func KeySetupAddClose()
	GUIDelete($keysetupaddenterwin)
	GUISetState(@SW_RESTORE, $mainwindow)
	GUISetState(@SW_ENABLE, $keysetupwin)
	GUISetState(@SW_RESTORE, $keysetupwin)
EndFunc


Func KeySetupClose($KeyTextIni, $KeyEnabledIni, $KeyAddEnterIni, $KeyAddBackspaceIni)
	$KeyText = GUICtrlRead($KeySetupEdit)
	IniWrite($sPath_ini, "EditDATA", $KeyTextIni, $KeyText)

	If BitAND(GUICtrlRead($KeySetupENABLEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$KeyENABLE = 1
	Else
		$KeyENABLE = 0
	EndIf
	IniWrite($sPath_ini, "EditSET", $KeyEnabledIni, $KeyENABLE)

	If BitAND(GUICtrlRead($KeySetupAddENTERchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$KeyAddENTER = 1
	Else
		$KeyAddENTER = 0
	EndIf
	IniWrite($sPath_ini, "EditSET", $KeyAddEnterIni, $KeyAddENTER)

	If BitAND(GUICtrlRead($KeySetupAddBACKSPACEchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
		$KeyAddBACKSPACE = 1
	Else
		$KeyAddBACKSPACE = 0
	EndIf
	IniWrite($sPath_ini, "EditSET", $KeyAddBackspaceIni, $KeyAddBACKSPACE)
	
	
	If KeySetupNameDetect($KeyTextIni) == "Клавиша NUM +" Then
		If BitAND(GUICtrlRead($KeySetupDETECTchkbx), $GUI_CHECKED) = $GUI_CHECKED Then
			$NumPLUSsetDETECT = 1
		Else
			$NumPLUSsetDETECT = 0
		EndIf
		IniWrite($sPath_ini, "EditSET", "$NumPLUSsetDETECT", $NumPLUSsetDETECT)
		DetectCheck()
	EndIf
	
	
	ReloadPrefs()
	GUISetState(@SW_ENABLE, $mainwindow)
	GUIDelete($keysetupwin)
EndFunc

Func KeySetupNameDetect($Name)
	If $Name == "$INSERTtext" Then
		Return "Клавиша INSERT"
	ElseIf $Name == "$ENDtext" Then
		Return "Клавиша END"
	ElseIf $Name == "$PGDNtext" Then
		Return "Клавиша PAGE DOWN"
	ElseIf $Name == "$HOMEtext" Then
		Return "Клавиша HOME"
	ElseIf $Name == "$PGUPtext" Then
		Return "Клавиша PAGE UP"
	ElseIf $Name == "$f1text" Then
		Return "Клавиша F1"
	ElseIf $Name == "$f2text" Then
		Return "Клавиша F2"
	ElseIf $Name == "$f3text" Then
		Return "Клавиша F3"
	ElseIf $Name == "$f4text" Then
		Return "Клавиша F4"
	ElseIf $Name == "$f5text" Then
		Return "Клавиша F5"
	ElseIf $Name == "$f6text" Then
		Return "Клавиша F6"
	ElseIf $Name == "$f7text" Then
		Return "Клавиша F7"
	ElseIf $Name == "$f8text" Then
		Return "Клавиша F8"
	ElseIf $Name == "$f9text" Then
		Return "Клавиша F9"
	ElseIf $Name == "$numplustext" Then
		Return "Клавиша NUM +"
	EndIf
EndFunc





Func SetMouseClickInitialize()
	$KeyText = GUICtrlRead($KeySetupEdit)
	IniWrite($sPath_ini, "EditDATA", $KeyTextIniToF, $KeyText)
	
	$returnedValue = MsgBox($MB_OKCANCEL, "Создать клик", "Наведите курсор на место и нажмите F10 !", 10)
	If $returnedValue == 1 Then
		SetOnEventA("{F10}", "SetMouseClickPopup", $paramByVal, $KeySetupEdit)
	EndIf
EndFunc


Func SetMouseClickPopup($editfield)
	SetOnEventA("{F10}", "")
	Local $aPos = MouseGetPos()
	Global $SetMouseClickXPos = $aPos[0]
	Global $SetMouseClickYPos = $aPos[1]
	
	Global $SetMouseClickEdit = $editfield
	
	Global $MouseClickPopupWin = GUICreate("",170,75)
	GUISetState(@SW_SHOW)
	Local $DescLabel1 = GUICtrlCreateLabel("Координаты:", 10, 10, 200, 18)
	GUICtrlSetData($DescLabel1, "Координаты - X: " & $aPos[0] & ", Y: " & $aPos[1])
	Local $DescLabel2 = GUICtrlCreateLabel("Выберите клавишу:", 10, 25, 150, 18)
	Local $MouseSetLkeybtn = GUICtrlCreateButton("Левая", 15, 45, 65, 20)
	Local $MouseSetRkeybtn = GUICtrlCreateButton("Правая", 90, 45, 65, 20)
	SetOnEventA($MouseSetLkeybtn, "SetMouseClickL", $paramByRef, "$SetMouseClickXPos", $paramByRef, "$SetMouseClickYPos", $paramByRef, "$SetMouseClickEdit")
	SetOnEventA($MouseSetRkeybtn, "SetMouseClickR", $paramByRef, "$SetMouseClickXPos", $paramByRef, "$SetMouseClickYPos", $paramByRef, "$SetMouseClickEdit")

	GUISetOnEvent($GUI_EVENT_CLOSE, "MouseClickPopupClose")
EndFunc


Func SetMouseClickL($xPos, $yPos, $editfield)
	
	Local $editfieldtext = GUICtrlRead($editfield)
	$editfieldtext = $editfieldtext & "<[McL-" & $xPos & "-" & $yPos & "]>"
	GUICtrlSetData ($editfield, $editfieldtext)
	SetMouseClickPopupClose()
	;MsgBox($MB_SYSTEMMODAL, "Lkey", $editfieldtext & "-" & $xPos & "-" & $yPos)
EndFunc


Func SetMouseClickR($xPos, $yPos, $editfield)
	
	Local $editfieldtext = GUICtrlRead($editfield)
	$editfieldtext = $editfieldtext & "<[McR-" & $xPos & "-" & $yPos & "]>"
	GUICtrlSetData ($editfield, $editfieldtext)
	SetMouseClickPopupClose()
EndFunc


Func SetMouseClickPopupClose()
	;GUICtrlSetData ($KeySetupEdit, $KeyText)
	
	GUIDelete($MouseClickPopupWin)
	;GUISetState(@SW_ENABLE, $keysetupwin)
	;GUISetState(@SW_SHOW)
EndFunc





Func INSERT()
   If $INSERTsetENABLE = 1 Then
		CommandInterpreter($INSERTtext)
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
		CommandInterpreter($HOMEtext)
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
		CommandInterpreter($PGUPtext)
		If $PGUPsetAddBACKSPACE = 1 Then
			Send("{BACKSPACE}")
		EndIf
		If $PGUPsetAddENTER = 1 Then
			Send("{ENTER}")
		EndIf
	EndIf
EndFunc

Func END()
   If $ENDsetENABLE = 1 Then
		CommandInterpreter($ENDtext)
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
		CommandInterpreter($PGDNtext)
		If $PGDNsetAddBACKSPACE = 1 Then
			Send("{BACKSPACE}")
		EndIf
		If $PGDNsetAddENTER = 1 Then
			Send("{ENTER}")
		EndIf
	EndIf
EndFunc

Func f1()
   If $f1setENABLE = 1 Then
		;MsgBox(0, 'Debug', $f1text)
		CommandInterpreter($f1text)
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
		CommandInterpreter($f2text)
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
		CommandInterpreter($f3text)
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
		CommandInterpreter($f4text)
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
		CommandInterpreter($f5text)
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
		CommandInterpreter($f6text)
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
		CommandInterpreter($f7text)
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
		CommandInterpreter($f8text)
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
		CommandInterpreter($f9text)
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
			CommandInterpreter($NumPLUStext)
			;Send($NumPLUStext)
			If $NumPLUSsetAddBACKSPACE = 1 Then
			  Send("{BACKSPACE}")
			EndIf
			If $NumPLUSsetAddENTER = 1 Then
			  Send("{ENTER}")
			EndIf
	   EndIf
   EndIf
EndFunc



Func CommandInterpreter($Command)
	Local $CommandArray[1]
	Local $CommandTypeArray[1]

	Local $CommandLenght = StringLen($Command)
	
	Local $CommStart = 0
	Local $CommEnd = 0
	Local $CommType = 0 ; 0 for legacy, 1 for command
	
	Local $LastCommEnd = 1
	
	If $CommandLenght < 11 Then
		_ArrayAdd($CommandArray, $Command)
		_ArrayAdd($CommandTypeArray, '0')
	Else
		While $LastCommEnd <> $CommandLenght
			If $LastCommEnd <> $CommandLenght - 2 Then
			
				$checksymb1 = StringMid($Command, $LastCommEnd, 1)
				$checksymb2 = StringMid($Command, $LastCommEnd+1, 1)
			
				If $checksymb1 == "<" AND $checksymb2 == "[" Then
					$CommStart = $LastCommEnd + 2
					For $c = $LastCommEnd to $CommandLenght
						$checksymb1 = StringMid($Command, $c, 1)
						$checksymb2 = StringMid($Command, $c+1, 1)
						If $checksymb1 == "]" AND $checksymb2 == ">" Then
							$CommEnd = $c - 1
							ExitLoop
						EndIf
					Next
					If $CommEnd == 0 OR $CommEnd <= $CommStart Then
						$CommStart = $LastCommEnd
						$CommEnd = $CommandLenght
						$CommType = 0
						;'Legacy'
					Else
						$CommType = 1
						;'Command'
					EndIf
					
				Else
					;'Legacy'
					$CommType = 0
					$CommStart = $LastCommEnd
					For $c = $LastCommEnd to $CommandLenght
						$checksymb1 = StringMid($Command, $c, 1)
						$checksymb2 = StringMid($Command, $c+1, 1)
						If $checksymb1 == "<" AND $checksymb2 == "[" Then
							$CommEnd = $c - 1
							ExitLoop
						EndIf
					Next
					If $CommEnd == 0 Then
						$CommEnd = $CommandLenght
					EndIf
				EndIf
				
				
				
				$ExecCommand =  StringMid($Command, $CommStart, $CommEnd - $CommStart + 1)
				_ArrayAdd($CommandArray, $ExecCommand)
				
				If $CommType == 1 Then
					$LastCommEnd = $CommEnd + 3
					If $LastCommEnd > $CommandLenght Then
						$LastCommEnd = $CommandLenght
					EndIf
					_ArrayAdd($CommandTypeArray, '1')
				Else
					$LastCommEnd = $CommEnd + 1
					If $LastCommEnd > $CommandLenght Then
						$LastCommEnd = $CommandLenght
					EndIf
					_ArrayAdd($CommandTypeArray, '0')
				EndIf
				
				;MsgBox(0, 'Debug', $CommType & @CRLF & $CommStart & ' - ' & $CommEnd & @CRLF & 'LastCommEnd ' & $LastCommEnd & ', len ' & $CommandLenght & @CRLF & $ExecCommand)
				$CommStart = 0
				$CommEnd = 0
				
			Else
				ExitLoop
			EndIf
			
		WEnd
	EndIf
	
	
	_ArrayDelete($CommandArray, 0)
	_ArrayDelete($CommandTypeArray, 0)
	
	;_ArrayDisplay($CommandArray)
	;_ArrayDisplay($CommandTypeArray)
	
	Local $CommandArrayLen = UBound($CommandArray, $UBOUND_ROWS)
	
	For $c = 0 to $CommandArrayLen - 1
		If $CommandTypeArray[$c] == 0 Then
			Send($CommandArray[$c])
		Else
			MouseManager($CommandArray[$c])
		EndIf
	Next
	
EndFunc


Func MouseManager($MouseCommand)
	If StringLen($MouseCommand) > 6 Then
		$ClickType = StringMid($MouseCommand, 1, 3)
		$ClickX = 0
		$ClickY = 0
		
		For $c = 5 To StringLen($MouseCommand)
			$sym = StringMid($MouseCommand, $c, 1)
			
			If $sym == '-' Then
				$ClickX = StringMid($MouseCommand, 5, $c-5)
				ExitLoop
			EndIf
		Next
		
		$ClickX = StringMid($MouseCommand, 5, $c-5)
		$ClickX = Number($ClickX)
		$ClickY = StringMid($MouseCommand, $c+1, StringLen($MouseCommand))
		$ClickY = Number($ClickY)
		
		;MsgBox(0, 'Debug', 'type ' & $ClickType & @CRLF & 'clx ' & $ClickX & @CRLF & 'cly ' & $ClickY)
	;Else
		;MsgBox(0, 'Debug', 'Incorrect command')
	EndIf
	
	
	If $ClickType == 'McL' Then
		MouseClick($MOUSE_CLICK_LEFT, $ClickX, $ClickY, 1, 0)
	ElseIf $ClickType == 'McR' Then
		MouseClick($MOUSE_CLICK_RIGHT, $ClickX, $ClickY, 1, 0)
	EndIf
	
EndFunc




Func CommandInterpreterHowTo()
   Global $cihowtowin = GUICreate("Справка комманд",310,235)
   GUISetState(@SW_SHOW)
   Local $cihowto1 = GUICtrlCreateLabel("Для ввода Enter вписать команду {ENTER}", 20, 20, 250, 20)
   Local $cihowto2 = GUICtrlCreateLabel("  Можно указать количество нажатий,", 20, 40, 250, 20)
   Local $cihowto3 = GUICtrlCreateLabel("  например {ENTER 2} для сразу двух нажатий", 20, 60, 250, 20)
   Local $cihowto4 = GUICtrlCreateLabel("Добавить задержку: {Sleep время},", 20, 90, 250, 20)
   Local $cihowto5 = GUICtrlCreateLabel("  где время - 100 для 1сек, 50 для 0,5сек и тд", 20, 110, 250, 20)
   Local $cihowto6 = GUICtrlCreateLabel("  Пример {Sleep 130} для 1,5сек ожидания", 20, 130, 250, 20)
   Local $cihowto7 = GUICtrlCreateLabel("Клики мыши: <[тип.клика-коорд.X-коорд.Y]>.", 20, 160, 250, 20)
   Local $cihowto8 = GUICtrlCreateLabel("  Типы кликов McL - левый, McR - правый", 20, 180, 250, 20)
   Local $cihowto9 = GUICtrlCreateLabel("  Пример <[McL-50-100]> Клик левой по X=50, Y=100", 20, 200, 300, 20)

   GUISetOnEvent($GUI_EVENT_CLOSE, "CommandInterpreterHowToClose")
EndFunc


Func CommandInterpreterHowToClose()
   GUIDelete($cihowtowin)
EndFunc




Func Detect()
	Local $SearchResult
	Local $LettersFinded = 0

   If WinGetHandle($orbhfulltext) = 0 Then
		;MsgBox(0, 'Ошибка', "Нет подключения")
   Else
		If $detectlang == 0 Then
			$orbtext = ControlGetText($orbh, "", $orbitext)
			Send("{Enter}")
			;ControlSetText ($orbh, "", $orbitext, $orbtext)
			ControlSend ($orbh, "", $orbitext, $orbtext)
			Sleep(100)
			Send("{Enter}")
		ElseIf $detectlang == 1 Then
			fastlangchangeF2()
			$orbtext = ControlGetText($orbh, "", $orbitext)
			Send("{Enter}")
			;ControlSetText ($orbh, "", $orbitext, $orbtext)
			ControlSend ($orbh, "", $orbitext, $orbtext)
			fastlangchangeF1()
			Sleep(100)
			Send("{Enter}")
		ElseIf $detectlang == 2 Then
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


Func RestartProgram()
	Run(@ScriptDir & "\flame.exe")
	Exit
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





Func _FindControlHandleByText($hCallersWindow, $SearchText)
    $sClassList = WinGetClassList($hCallersWindow)
    $aClassList = StringSplit($sClassList, @CRLF, 2)
    _ArraySort($aClassList)
    _ArrayDelete($aClassList, 0)

    Local $iCurrentClass = "", $iCurrentCount = 1, $iTotalCounter = 1

    For $i = 0 To UBound($aClassList) - 1
        If $aClassList[$i] = $iCurrentClass Then
            $iCurrentCount += 1
        Else
            $iCurrentClass = $aClassList[$i]
            $iCurrentCount = 1
        EndIf

        $hControl = ControlGetHandle($hCallersWindow, "", "[CLASSNN:" & $iCurrentClass & $iCurrentCount & "]")
        $text = StringRegExpReplace(ControlGetText($hCallersWindow, "", $hControl), "[\n\r]", "{@CRLF}")
		
		;If $text == $SearchText Then Return $hControl
		If $text == $SearchText Then Return StringFormat("%19s", $iCurrentClass & $iCurrentCount)
		
        If Not WinExists($hCallersWindow) Then ExitLoop
        $iTotalCounter += 1
    Next
EndFunc


Func _SingleScript($iMode = 0)
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


#comments-start

Слева от перезапуска и сворачивания в трей кнопки "загрузить ini" и "сохранить ini"

!!!!! HOWTO в разделе DETECT

! Сброс строчных символов в полях F1 F2 из-за работы функции автоопределения языка?
! Интеграция Updater в бинарном виде в тело программы
! Настройки расположения файлов чата и папки обновления
! Обновление через Git







Общая функция обработки нажатия вместо f2, insert и пр
Обработчик строки памяти
	служебные символы и команды для мыши
	класс для отработки блоков текста и команд
	убрать конфигуратор мыши на PGUP PGDW
Добавить F9-F12
База .ini файлов с pop-up window для быстрого выбора (возможно, на F12)
Универсальные классы для окон настроек
Блок комментария в списке встроенных комманд, переносящий каретку в поле редактирования и добавления комманд кнопки

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