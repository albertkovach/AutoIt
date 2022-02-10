#include <GUIConstantsEx.au3>


   Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent
   $mainwindow = GUICreate("Mers", 230, 180)
   GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClick")
   GUISetState(@SW_SHOW)

   Global $TEXTlabel = GUICtrlCreateLabel("Текст", 15, 10)
   Global $TEXTedit = GUICtrlCreateInput ( "",  15, 30, 200)

   Global $DATElabel = GUICtrlCreateLabel("Дата", 15, 70)
   Global $DATEedit = GUICtrlCreateInput ( "", 15, 90, 200)

   Global $REFRESHbtn = GUICtrlCreateButton("Запомнить", 70, 130, 90)
   GUICtrlSetOnEvent($REFRESHbtn, "RefreshAndSave")
   $sPath_ini = @ScriptDir & "\prefs.ini"

   LoadPrefs()



HotKeySet("{PGDN}", "MersRos")
HotKeySet("{PGUP}", "Mers")
HotKeySet("{TAB}", "NewFolder")


Func LoadPrefs()
   Global $Text = IniRead($sPath_ini, "MainDATA", "$TEXTedit", "")
   Global $Date = IniRead($sPath_ini, "MainDATA", "$DATEedit", "")

   GUICtrlSetData ($TEXTedit, $Text)
   GUICtrlSetData ($DATEedit, $Date)
EndFunc

Func RefreshAndSave()
   $Text = GUICtrlRead($TEXTedit)
   $Date = GUICtrlRead($DATEedit)

   IniWrite($sPath_ini, "MainDATA", "$TEXTedit", $Text)
   IniWrite($sPath_ini, "MainDATA", "$DATEedit", $Date)
EndFunc


Func NewFolder()
   Send("^f")
EndFunc

Func Mers()
   Send("1")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send($Text)
   Send("{Enter}")
   Send($Date)
   Send("{Enter}")
   Send($Date)
   Send("{Enter}")
   Send("Да")
   Send("{Enter}")
   Send("{Enter}")
EndFunc

Func MersRos()
   Send("1")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("1")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("1-отп")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send("0")
   Send("{Enter}")
   Send($Text)
   Send("{Enter}")
   Send($Date)
   Send("{Enter}")
   Send($Date)
   Send("{Enter}")
   Send("Да")
   Send("{Enter}")
   Send("{Enter}")
EndFunc



Func CLOSEClick()
  Exit
EndFunc


While 1
   Sleep(100)
WEnd