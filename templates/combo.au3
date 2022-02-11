#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <WindowsConstants.au3>

Local $msg, $Combo1, $Combo2, $hGUI, $add, $add_set, $insert, $clear, $close, $index, $read, $setsel, $count, $select, $find_string, $del_item, $tmp, $sList
$hGUI = GUICreate("Раскрывающийся список") ; Создаёт окно в центре экрана

; Генерирует список пунктов для Combo1
For $i = 1 To 100
    $sList &= 'Пункт ' & $i & '|'
Next
$sList = StringTrimRight($sList, 1)

; Создаёт "Combo" со стилем точного указания высоты выпадающего списка
$Combo1 = GUICtrlCreateCombo("", 10, 10, 200, 150, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
GUICtrlSetData(-1, $sList , "Пункт 3") ; добавляет другие пункты и устанавливает новый по умолчанию
GUICtrlSendMsg(-1, $CB_SETDROPPEDWIDTH, 370, 0) ; Ширина выпадающего списка

$Combo2 = GUICtrlCreateCombo("", 10, 40, 200, 23, $CBS_DROPDOWNLIST + $WS_VSCROLL) ; стиль не редактируемого списка
GUICtrlSetData(-1, "не редактируемый|элемент1|элемент2|элемент3|элемент4|Отсчёт с 0", "не редактируемый")

$read = GUICtrlCreateButton("Текст выбранного", 233, 30, 132, 25)
$index = GUICtrlCreateButton("Индекс выделенного", 233, 60, 132, 25)
$setsel = GUICtrlCreateButton("Выделить пункт 4", 233, 90, 132, 25)
$select = GUICtrlCreateButton("Выделить элемент1", 233, 120, 132, 25)
$find_string = GUICtrlCreateButton("Найти строку элемент3", 233, 150, 132, 25)
$del_item = GUICtrlCreateButton("Удалить строку 3", 233, 180, 132, 25)
$count = GUICtrlCreateButton("Количество пунктов", 233, 210, 132, 25)
$add = GUICtrlCreateButton("Добавить пункт", 233, 240, 132, 25)
$add_set = GUICtrlCreateButton("Добавить и выбрать", 233, 270, 132, 25)
$insert = GUICtrlCreateButton("Вставить в позицию", 233, 300, 132, 25)
$clear = GUICtrlCreateButton("Очистить список", 233, 330, 132, 25)

GUISetState() ; показывает созданное окно

; Запускается цикл опроса GUI до тех пор пока окно не будет закрыто
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            ExitLoop
        Case $Combo1
            MsgBox(4096, 'Тест', 'Combo 1, выбор: "' & GUICtrlRead($Combo1) & '"', 0, $hGUI)
        Case $Combo2
            MsgBox(4096, 'Тест', 'Combo 2, выбор: "' & GUICtrlRead($Combo2) & '"', 1, $hGUI)
        Case $add
            GUICtrlSetData($Combo2, "Добавленный пункт|") ; без символа "|" повторный вызов делает выбор
        Case $add_set
            GUICtrlSetData($Combo2, "Пункт добавлен и выбран|", "Пункт добавлен и выбран") ; без символа "|" повторный вызов делает выбор
        Case $insert
            GUICtrlSendMsg($Combo2, $CB_INSERTSTRING, 3, 'Вставлен в позицию 3')
        Case $clear
            GUICtrlSetData($Combo2, "|")
            ; GUICtrlSendMsg($Combo2, $CB_RESETCONTENT, 0, 0) ; или так
        Case $index
            $tmp = GUICtrlSendMsg($Combo2, $CB_GETCURSEL, 0, 0)
            MsgBox(4096, 'Индекс выбранного пункта', $tmp)
        Case $read
            $tmp = GUICtrlRead($Combo2)
            MsgBox(4096, 'Текст выбранного пункта в списке', $tmp)
        Case $setsel
            GUICtrlSendMsg($Combo2, $CB_SETCURSEL, 4, 0)
        Case $count
            $tmp = GUICtrlSendMsg($Combo2, $CB_GETCOUNT, 0, 0)
            MsgBox(4096, 'Количество пунктов в списке', $tmp)
        Case $select
            GUICtrlSendMsg($Combo2, $CB_SELECTSTRING, 0, 'элемент1')
        Case $find_string
            $tmp = GUICtrlSendMsg($Combo2, $CB_FINDSTRINGEXACT, 0, 'элемент3')
            MsgBox(4096, 'Найдена точная строка в списке - элемент3', 'Индекс = ' & $tmp)
        Case $del_item
            $tmp = GUICtrlSendMsg($Combo2, $CB_DELETESTRING, 3, 0)
    EndSwitch
WEnd