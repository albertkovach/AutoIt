#include <Array.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>

Dim $aWin = WinList(), $aWindows[1][1]
Dim $hUser32 = DllOpen('user32.dll')
Dim $iEx_Style, $iCounter = 0


For $i = 1 To $aWin[0][0]
    $iEx_Style = BitAND(GetWindowLong($aWin[$i][1], $GWL_EXSTYLE), $WS_EX_TOOLWINDOW)
    Local $iStyle = BitAND(WinGetState($aWin[$i][1]), 2)
    
    If $iEx_Style <> -1 And Not $iEx_Style And $iStyle Then
        ReDim $aWindows[$iCounter+1][1]
        $aWindows[$iCounter][0] = $aWin[$i][0]
        $iCounter += 1
    EndIf
Next
        
_ArrayDisplay($aWindows)    
    
DllClose($hUser32)


Func GetWindowLong($hWnd, $iIndex, $hUser = 'user32.dll')
    Local $Ret = DllCall($hUser, 'int', 'GetWindowLong', 'hwnd', $hWnd, 'int', $iIndex)
    If Not @error Then Return $Ret[0]
    Return SetError(-1, 0, -1)
EndFunc