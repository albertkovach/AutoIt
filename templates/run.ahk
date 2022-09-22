;Run "C:\Users\ORB User\Desktop\instamart.lnk"

Hotkey, F1, F1comm
Hotkey, F2, F2comm
return

F1comm:
try
{
	Run "C:\Users\ORB User\Desktop\instamart.lnk"
}
catch e
{
    Run "C:\Users\ORBUser\Desktop\instamart.lnk"
}
return

F2comm:
Send ^s
Sleep 800
Send !{f4}
return