
HotKeySet("{PRINTSCREEN}", "Main")


Func Main()
   ;Старая орбита
   ;Local $hWnd = WinGetHandle("[CLASS:WindowsForms10.Window.8.app.0.21093c0_r7_ad1]", "")
   ;ControlClick($hWnd, "", "WindowsForms10.Window.b.app.0.21093c0_r7_ad121")

   ;Новая орбита
   Local $hWnd = WinGetHandle("[CLASS:WindowsForms10.Window.8.app.0.21093c0_r7_ad1]", "")
   ControlClick($hWnd, "", "WindowsForms10.Window.b.app.0.21093c0_r7_ad122")
EndFunc


While 1
   Sleep(100)
WEnd