Main()

Func Main()
   Run("C:\Орбита\ORBit.exe")


   Sleep(15000)

   Local $hWndLogin = WinGetHandle("ORBita", "")
   ControlSetText($hWndLogin, "", "WindowsForms10.EDIT.app.0.141b42a_r7_ad12", "KovachAG")
   ControlSend($hWndLogin, "", "WindowsForms10.EDIT.app.0.141b42a_r7_ad11", "Linda1294")
   ControlClick($hWndLogin, "", "WindowsForms10.Window.8.app.0.141b42a_r7_ad17")
EndFunc