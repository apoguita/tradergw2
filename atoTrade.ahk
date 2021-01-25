#NoEnv
#Persistent
#SingleInstance, Force
;#NoTrayIcon
SetWinDelay, 0
SendMode Input
SetBatchLines,-1
Coordmode,Mouse,Relative
SetKeyDelay , 20, 20

#include C:\Users\Apo\Desktop\AHK\csvlib.ahk


MousePosToggle := 0 ;starts in off position; change to 1 to start in on position
PauseToggle := 1
; VARS

;ESTADOS
;0 - Detenido/Pausado
;0 - Busqueda Item
;1 - Espera busqueda item
;2 - Espera Info Item (cargar imagen Offered)
;3 - Configurando Compra
;4 - Esperando Coins
;5 - Terminado
Estado := 0
EstadoPtr := 0

if wHandle := WinExist("GW3")
{
	WinActivate
	WinGetPos, XWin, YWin, WinWidth, WinHeight, GW3
}
else
{
	ExitApp
}

;Read Ini file
IniRead, CaraLeonX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, CARALEON, X
IniRead, CaraLeonY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, CARALEON, Y
IniRead, BalanzaX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, BALANZA, X
IniRead, BalanzaY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, BALANZA, Y
IniRead, BuyItemsX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, BUYITEMS, X
IniRead, BuyItemsY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, BUYITEMS, Y
IniRead, PrimerItemX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, PRIMERITEM, X
IniRead, PrimerItemY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, PRIMERITEM, Y
IniRead, OrderX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, ORDER, X
IniRead, OrderY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, ORDER, Y
IniRead, CopperLessX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, COPPERLESS, X
IniRead, CopperLessY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, COPPERLESS, Y
IniRead, CopperMoreX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, COPPERMORE, X
IniRead, CopperMoreY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, COPPERMORE, Y
IniRead, QtyX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, QUANTITY, X
IniRead, QtyY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, QUANTITY, Y
IniRead, OkBtnX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, OKBUTTON, X
IniRead, OkBtnY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, OKBUTTON, Y
IniRead, CloseBtnX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, CLOSEBUTTON, X
IniRead, CloseBtnY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, CLOSEBUTTON, Y
IniRead, SearchBarX, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, SEARCH, X
IniRead, SearchBarY, C:\Users\Apo\Desktop\BLTCIMG\pixels.ini, SEARCH, Y

;auto calibrado, ajustar pixel devuelto para la imagen exacta tomada
WinActivate
sleep, 500

InitTries := 0
Init: 

ImageSearch, FoundX, FoundY, 1, 1, 500, 500, *100 C:\Users\Apo\Desktop\BLTCIMG\BLTC.PNG
FoundX := FoundX + 7
FoundY := FoundY + 20

if (ErrorLevel = 2)
    MsgBox error desconocido
else if (ErrorLevel = 1) {
	if (InitTries = 0)
	{
		
		Controlsend,,O, GW3
		sleep 1000
		InitTries := 1
		Goto, Init
	}
	else
	    MsgBox No Se pudo Auto Calibrar,hacerlo manual.
}

;msgbox,x%FoundX% y%FoundY%
CaraLeonX := FoundX
CaraLeonY := FoundY

BalanzaX := BalanzaX + CaraLeonX
BalanzaY := BalanzaY + CaraLeonY
BuyItemsX := BuyItemsX + CaraLeonX
BuyItemsY := BuyItemsY + CaraLeonY
PrimerItemX := PrimerItemX + CaraLeonX
PrimerItemY :=PrimerItemY + CaraLeonY
OrderX := OrderX + CaraLeonX
OrderY := OrderY + CaraLeonY
CopperLessX := CopperLessX + CaraLeonX
CopperLessY := CopperLessY + CaraLeonY
CopperMoreX := CopperMoreX + CaraLeonX
CopperMoreY := CopperMoreY + CaraLeonY
QtyX := QtyX + CaraLeonX
QtyY := QtyY + CaraLeonY
OkBtnX := OkBtnX + CaraLeonX
OkBtnY := OkBtnY + CaraLeonY
CloseBtnX := CloseBtnX + CaraLeonX
CloseBtnY := CloseBtnY + CaraLeonY
SearchBarX := SearchBarX + CaraLeonX
SearchBarY := SearchBarY + CaraLeonY

;Posiciona en ventana, buy items
;sleep 150
ControlClick, x%BalanzaX% y%BalanzaY%, ahk_id %wHandle%,,,,NA
sleep 1000
ControlClick, x%BuyItemsX% y%BuyItemsY%, ahk_id %wHandle%,,,,NA


Gui, 1: +AlwaysOnTop +ToolWindow +LastFound ;+E0x08000000
Gui, Add, Tab3,, Compra|Venta|Config  ; Tab2 vs. Tab requires [v1.0.47.05+].
Gui, Add, Edit, x15 y40 w200 h20 vPathArchivo , Seleccionar archivo
Gui, Add, Button, x225 y40 w50 h20 gCargarCSV , Cargar
Gui, Add, Text, x15 y70 w30 h20 , Total
Gui, Add, Edit, x45 y70 w30 h20 vTotal, 0
Gui, Add, Text, x85 y70 w30 h20 , Actual
Gui, Add, Edit, x125 y70 w30 h20 vActual, 0
;Gui, Add, Button, x175 y120 w100 h20 , Empezar/Pausar
Gui, Add, Button, x165 y70 w100 h20 gTogPause vTogPause, % PauseToggle?"Empezar":"Pausar"

Gui, Add, Progress, x15 y100 w250 h10 , 0
Gui, Add, Text, x15 y120 w250 h20 vStrEstado, Detenido
Gui, Add, ListView, vData x15 y150 w260 h200 Grid Checked,Nombre|Cantidad

Gui, Tab, 2
Gui, Add, Radio, vMyRadio, Sample radio1
Gui, Add, Radio,, Sample radio2
;Gui, Add, Button, x175 y120 w100 h20 gOCRCheck,OCR
Gui, Tab, 3

Gui, Add, Picture, x10 y30 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\BLTC.PNG
Gui, Add, Text, x40 y40 w10 h20 , X:
Gui, Add, Edit, x60 y40 w30 h20 , %CaraLeonX%
Gui, Add, Text, x100 y40 w10 h20 , Y:
Gui, Add, Edit, x120 y40 w30 h20 , %CaraLeonY%

Gui, Add, Picture, x160 y30 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\searchbar.PNG
Gui, Add, Text, x190 y40 w10 h20 , X:
Gui, Add, Edit, x210 y40 w30 h20 , %SearchBarX%
Gui, Add, Text, x250 y40 w10 h20 , Y:
Gui, Add, Edit, x270 y40 w30 h20 , %SearchBarY%


Gui, Add, Picture, x10 y70 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\balanza.PNG
Gui, Add, Text, x40 y80 w10 h20 , X:
Gui, Add, Edit, x60 y80 w30 h20 , %BalanzaX%
Gui, Add, Text, x100 y80 w10 h20 , Y:
Gui, Add, Edit, x120 y80 w30 h20 , %BalanzaY%

Gui, Add, Picture, x160 y70 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\buyitems.PNG
Gui, Add, Text, x190 y80 w10 h20 , X:
Gui, Add, Edit, x210 y80 w30 h20 , %BuyItemsX%
Gui, Add, Text, x250 y80 w10 h20 , Y:
Gui, Add, Edit, x270 y80 w30 h20 , %BuyItemsY%

Gui, Add, Picture, x10 y120 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\1stitem.PNG
Gui, Add, Text, x40 y130 w10 h20 , X:
Gui, Add, Edit, x60 y130 w30 h20 , %PrimerItemX%
Gui, Add, Text, x100 y130 w10 h20 , Y:
Gui, Add, Edit, x120 y130 w30 h20 , %PrimerItemY%

Gui, Add, Picture, x160 y120 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\ordered.PNG
Gui, Add, Text, x190 y130 w10 h20 , X:
Gui, Add, Edit, x210 y130 w30 h20 , %OrderX%
Gui, Add, Text, x250 y130 w10 h20 , Y:
Gui, Add, Edit, x270 y130 w30 h20 , %OrderY%

Gui, Add, Picture, x10 y170 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\copperup.PNG
Gui, Add, Text, x40 y180 w10 h20 , X:
Gui, Add, Edit, x60 y180 w30 h20 , %CopperlessX%
Gui, Add, Text, x100 y180 w10 h20 , Y:
Gui, Add, Edit, x120 y180 w30 h20 , %CopperLessY%

Gui, Add, Picture, x160 y170 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\quantity.PNG
Gui, Add, Text, x190 y180 w10 h20 , X:
Gui, Add, Edit, x210 y180 w30 h20 , %QtyX%
Gui, Add, Text, x250 y180 w10 h20 , Y:
Gui, Add, Edit, x270 y180 w30 h20 , %QtyY%

Gui, Add, Picture, x10 y220 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\okbutton.PNG
Gui, Add, Text, x40 y230 w10 h20 , X:
Gui, Add, Edit, x60 y230 w30 h20 , %OkBtnX%
Gui, Add, Text, x100 y230 w10 h20 , Y:
Gui, Add, Edit, x120 y230 w30 h20 , %OkBtnY%

Gui, Add, Picture, x160 y220 w20 h30 , C:\Users\Apo\Desktop\BLTCIMG\closebutton.PNG
Gui, Add, Text, x190 y230 w10 h20 , X:
Gui, Add, Edit, x210 y230 w30 h20 , %CloseBtnX%
Gui, Add, Text, x250 y230 w10 h20 , Y:
Gui, Add, Edit, x270 y230 w30 h20 , %CloseBtnY%

Gui, Add, Button, x10 y260 w100 h20 gToggle vToggle, % MousePosToggle?"MousePos: on":"MousePos: off"

Gui, Tab  ; i.e. subsequently-added controls will not belong to the tab control.

PosX := XWin + WinWidth -350
PosY := YWin + 260
Gui, Show, x%PosX% y%PosY%, TradeWin

SetTimer, CheckMousePos, 50
SetTimer, CheckFocus, 100
SetTimer, CheckState, 200

return

OCRCheck:
;hBitmap := HBitmapFromScreen(GetArea()*)
;pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
;DllCall("DeleteObject", "Ptr", hBitmap)
;text := ocr(pIRandomAccessStream, "en")
;MsgBox, % text
return

CheckState:
if !PauseToggle{
	;Estado := 1
	Switch Estado {
		Case 0:
			EstadoPtr := LV_GetNext(EstadoPtr,"C")

			if !EstadoPtr {
				Estado := 0
				PauseToggle := 1
				guicontrol, ,TogPause, % PauseToggle?"Empezar":"Pausar"
				msgbox, "No mas Lineas"
				return
			}

			GuiControl, Text, StrEstado,"Buscando Item"
			GuiControl, Text, Actual,%EstadoPtr%
			LV_GetText(SendTxt, EstadoPtr , 1)
			ControlClick, x%SearchBarX% y%SearchBarY%, ahk_id %wHandle%,,,,NA
			sleep 150
			Controlsend,, ^a, GW3
			sleep 150
			Controlsend,,{del}{backspace}, GW3
			sleep 150
			Controlsend,,%SendTxt%, GW3
			sleep 2000
			Estado := 1
			return
		Case 1:
			WinActivate
			GuiControl, Text, StrEstado,"Resultados de busqueda"
			ImageSearch, FoundX, FoundY, CaraLeonX + 200,CaraLeonY +100, CaraLeonX + 400, CaraLeonY + 250, *50 C:\Users\Apo\Desktop\BLTCIMG\Emptysearch.PNG
			if (ErrorLevel = 2)
				MsgBox error desconocido
			else if (ErrorLevel = 1) {
				GuiControl, Text, StrEstado,"Resultados de busqueda - Encontrado"
				;msgbox resultados de busqueda no esta vacio
				ControlClick, x%PrimerItemX% y%PrimerItemY%, ahk_id %wHandle%,,,,NA
				sleep 500
				ControlClick, x%PrimerItemX% y%PrimerItemY%, ahk_id %wHandle%,,,,NA
				sleep 500
				Estado := 2
				return
			}
			;msgbox resultados de busqueda estan vacios x%FoundX% y%FoundY%
			GuiControl, Text, StrEstado,"Resultados de busqueda - VACIO"
			sleep 250
			return
		Case 2:
			WinActivate
			GuiControl, Text, StrEstado,"Ventana Trade - Buscando"
			sleep 250
			
			ImageSearch, FoundX, FoundY, CaraLeonX + 150, CaraLeonY + 300, CaraLeonX + 250, CaraLeonY + 450, *130 C:\Users\Apo\Desktop\BLTCIMG\ordered.PNG
			if (ErrorLevel = 2)
				MsgBox error desconocido
			else if (ErrorLevel = 1) {
				GuiControl, Text, StrEstado,"Ventana Trade - NO Encontrada"
				sleep 250
				return
			}
			;msgbox ventana trade encontrada en x%FoundX% y%FoundY%
			Estado := 3
			sleep 500
			return
		Case 3:
			WinActivate
			GuiControl, Text, StrEstado,"configurando Compra"
			ControlClick, x%OrderX% y%OrderY%, ahk_id %wHandle%,,,,NA
			sleep 250
			ControlClick, x%OrderX% y%OrderY%, ahk_id %wHandle%,,,,NA
			sleep 250
			ControlClick, x%CopperMoreX% y%CopperMoreY%, ahk_id %wHandle%,,,,NA
			sleep 250
			ControlClick, x%QtyX% y%QtyY%, ahk_id %wHandle%,,,,NA
			sleep 250
			Controlsend,, ^a, GW3
			sleep 150
			Controlsend,,{del}{backspace}{backspace}{backspace}, GW3
			LV_GetText(SendTxt, EstadoPtr , 2)
			Controlsend,,%SendTxt%, GW3
			sleep 250
			Estado := 4
			return
		Case 4:
			WinActivate
			GuiControl, Text, StrEstado,"Esperando Confirmacion coins"
			;WinActivate
			;sleep 200
			ImageSearch, FoundX, FoundY, CaraLeonX + 150, CaraLeonY + 300, CaraLeonX + 250, CaraLeonY + 450, *50 C:\Users\Apo\Desktop\BLTCIMG\SellCoins.PNG
			if (ErrorLevel = 2)
				MsgBox error desconocido
			else if (ErrorLevel = 1) {
				;msgbox no hay coins
				ControlClick, x%CopperLessX% y%CopperLessY%, ahk_id %wHandle%,,,,NA
				sleep 250
				return
			}
			;msgbox click en boton close x%CloseBtnX% y%CloseBtnY%
			ControlClick, x%OkBtnX% y%OkBtnY%, ahk_id %wHandle%,,,,NA
			sleep 250
				
			
			Estado := 5
			return
		Case 5:
			
			WinActivate
			GuiControl, Text, StrEstado,"Esperando Success"
			sleep 200
			ImageSearch, FoundX, FoundY, CaraLeonX + 350, CaraLeonY + 150, CaraLeonX + 450, CaraLeonY + 250, *50 C:\Users\Apo\Desktop\BLTCIMG\success.PNG
			if (ErrorLevel = 2)
				MsgBox error desconocido
			else if (ErrorLevel = 1) {
				sleep 250
				return
			}
			;msgbox click en boton close x%CloseBtnX% y%CloseBtnY%
			ControlClick, x%CloseBtnX% y%CloseBtnY%, ahk_id %wHandle%,,,,NA
			sleep 250
				
			
			Estado := 6
			return
		Case 6:
			WinActivate
			GuiControl, Text, StrEstado,"Finalizando compra"
			LV_Modify(EstadoPtr, "-Check")
			Estado := 0
			sleep 1000
			
			;msgbox compra finalizada
			return
			
	}
}

return


CheckMousePos:
MouseGetPos, xx, yy
if MousePosToggle
	Tooltip %xx%`, %yy%
else
	Tooltip
return

Toggle:
MousePosToggle := !MousePosToggle
guicontrol, ,Toggle, % MousePosToggle?"MousePos: on":"MousePos: off"
return

TogPause:
PauseToggle := !PauseToggle
Estado := 0
guicontrol, ,TogPause, % PauseToggle?"Empezar":"Pausar"
return


CargarCSV:
FileSelectFile, SelectedFile, 3, , Open a file, Text Documents (*.txt; *.csv)
if (SelectedFile != "")
{
	GuiControl, Text, PathArchivo,%SelectedFile%
	CSV_Load("C:\Users\Apo\Desktop\AutoSell.csv","Data")
	CSV_LVLoad("Data", , 15, 150, 260, 100, "Articulo|Cantidad")
	
	temp :=LV_GetCount()
	Estado := 0
	EstadoPtr := 0
	GuiControl, Text, Total,%temp%
	GuiControl, Text, Actual,%EstadoPtr%
}
return


GuiClose:
ButtonOK:
Gui, Submit  ; Save the input from the user to each control's associated variable.
ExitApp

CheckFocus:
IfWinActive, GW3
	{
	Gui, 1: +AlwaysOnTop
	}
Else
	Gui, 1: -AlwaysOnTop

return



