#include <Array.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Local $hWindow, $vWinStyle, $aWinNormal[1][2]


Local $aWinList = WinList()
;Local $aProcList = ProcessList ()

Local $aProcList = ProcessList ("ORBita.exe")
;_ArrayDisplay($aProcList)

$hWnd = _GetHwndFromPID($aProcList[1][1])
;_ArrayDisplay($aWinList)

$hWnd = WinGetHandle("[REGEXPCLASS:(?i)WindowsForms10.Window.8.app.0.21*]")
Msgbox(0, "handle", ($hWnd = 0) ? "error" : $hWnd)

$aContrArray = _WinGetControls($hWnd)
;_ArrayDisplay($aContrArray)

$sClassList = WinGetClassList($hWnd)
;MsgBox($MB_SYSTEMMODAL, "", $sClassList)

Local $sText = WinGetText($hWnd)
;MsgBox($MB_SYSTEMMODAL, "", $sText)




Local $aTextContrArray[1][2]

For $c = 1 To UBound($aContrArray, $UBOUND_ROWS)
	_ArrayAdd($aTextContrArray, $aContrArray[$c-1][0]  & "|" &  ControlGetText($hWnd, "", $aContrArray[$c-1][1]))
Next
;_ArrayDisplay($aTextContrArray)



$ControlHandle = FindControlHandleByText($hWnd, "Балансы")
MsgBox($MB_SYSTEMMODAL, "", $ControlHandle)



Func _GetHwndFromPID($PID)
	$hWnd = 0
	$winlist = WinList()
	Do
		For $i = 1 To $winlist[0][0]
			If $winlist[$i][0] <> "" Then
				$iPID2 = WinGetProcess($winlist[$i][1])
				If $iPID2 = $PID Then
					$hWnd = $winlist[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
	Until $hWnd <> 0
	Return $hWnd
EndFunc

Func _WinGetControls($Title, $Text="")
	Local $WndControls, $aControls, $sLast="", $n=1
	$WndControls = WinGetClassList($Title, $Text)
	$aControls = StringSplit($WndControls, @CRLF)
	Dim $aResult[$aControls[0]+1][2]
	For $i = 1 To $aControls[0]
		If $aControls[$i] <> "" Then
			If $sLast = $aControls[$i] Then 
				$n+=1
			Else
				$n=1
			EndIf
			$aControls[$i] &= $n
			$sLast = StringTrimRight($aControls[$i],1)
		EndIf
		If $i < $aControls[0] Then 
			$aResult[$i][0] = $aControls[$i]
		Else ; last item in array
			$aResult[$i][0] = WinGetTitle($Title) ; return WinTitle
		EndIf
		$aResult[$i][1] = ControlGetHandle($Title, $Text, $aControls[$i])   
	Next
	$aResult[0][0] = "ClassnameNN"
	$aResult[0][1] = "Handle"
	Return $aResult
EndFunc




Func Var_GetAllWindowsControls($hCallersWindow)
    ; Get all list of controls
    $sClassList = WinGetClassList($hCallersWindow)
    ; Create array
    $aClassList = StringSplit($sClassList, @CRLF, 2)
    ; Sort array
    _ArraySort($aClassList)
    _ArrayDelete($aClassList, 0)

    ; Loop
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
        $aPos = ControlGetPos($hCallersWindow, "", $hControl)
        $sControlID = _WinAPI_GetDlgCtrlID($hControl)
        If IsArray($aPos) Then
            ConsoleWrite("Func=[Var_GetAllWindowsControls]: ControlCounter=[" & StringFormat("%3s", $iTotalCounter) & "] ControlID=[" & StringFormat("%5s", $sControlID) & "] Handle=[" & StringFormat("%10s", $hControl) & "] ClassNN=[" & StringFormat("%19s", $iCurrentClass & $iCurrentCount) & "] XPos=[" & StringFormat("%4s", $aPos[0]) & "] YPos=[" & StringFormat("%4s", $aPos[1]) & "] Width=[" & StringFormat("%4s", $aPos[2]) & "] Height=[" & StringFormat("%4s", $aPos[3]) & "] Text=[" & $text & "]." & @CRLF)
        Else
            ConsoleWrite("Func=[Var_GetAllWindowsControls]: ControlCounter=[" & StringFormat("%3s", $iTotalCounter) & "] ControlID=[" & StringFormat("%5s", $sControlID) & "] Handle=[" & StringFormat("%10s", $hControl) & "] ClassNN=[" & StringFormat("%19s", $iCurrentClass & $iCurrentCount) & "] XPos=[winclosed] YPos=[winclosed] Width=[winclosed] Height=[winclosed] Text=[" & $text & "]." & @CRLF)
        EndIf
        If Not WinExists($hCallersWindow) Then ExitLoop
        $iTotalCounter += 1
    Next
EndFunc   ;==>Var_GetAllWindowsControls




Func FindControlHandleByText($hCallersWindow, $SearchText)
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