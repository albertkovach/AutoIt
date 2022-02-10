@echo off
echo       == SRV Updater ==
echo For copy ONLY executables, print 1
echo  if you need to copy all - 2
set /p Input=Enter number: 
IF %Input%==1 (
	echo You selected 1
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\FLAME.exe" "C:\Users\ORB User\Documents\Настраиваемые шаблоны Office\FLAME.exe"
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\FLAME compact.exe" "C:\Users\ORB User\Documents\Настраиваемые шаблоны Office\FLAME compact.exe"
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\parser.exe" "C:\Users\ORB User\Documents\Настраиваемые шаблоны Office\parser.exe"
	
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\update from srv.bat" "C:\Users\ORB User\Documents\Настраиваемые шаблоны Office\update from srv.bat"
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\update from usb.bat" "C:\Users\ORB User\Documents\Настраиваемые шаблоны Office\update from usb.bat"
	
	
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\FLAME.exe" "C:\Users\ORBUser\Documents\Настраиваемые шаблоны Office\FLAME.exe"
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\FLAME compact.exe" "C:\Users\ORBUser\Documents\Настраиваемые шаблоны Office\FLAME compact.exe"
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\parser.exe" "C:\Users\ORBUser\Documents\Настраиваемые шаблоны Office\parser.exe"
	
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\update from srv.bat" "C:\Users\ORBUser\Documents\Настраиваемые шаблоны Office\update from srv.bat"
	copy /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates\update from usb.bat" "C:\Users\ORBUser\Documents\Настраиваемые шаблоны Office\update from usb.bat"
)
IF %Input%==2 (
	echo Copying entire folder...
	xcopy /e /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates" "C:\Users\ORB User\Documents\Настраиваемые шаблоны Office\"
	xcopy /e /y "\\zorb-srv\Operators\ORBScan\1\Папка\AutoIT final\updates" "C:\Users\ORBUser\Documents\Настраиваемые шаблоны Office\"
)
set /p Input=DONE!