; Script written by Google Gemini and gelatinguy. Inspired by DTScribe, to count how many times he's moved his wrist while drawing.
; This script now includes a settings window and saves/loads settings to a file.
#SingleInstance Force
Menu, Tray, Icon, StrokeCounterIcon.ico

; --- SCRIPT INITIALIZATION ---
; Define the settings file name.
; This script uses a settings file, below
IniFile := A_ScriptDir "\StrokeCounterSettings.ini"

; Load settings from the INI file. If keys don't exist, use default values.
IniRead, StrokeLimit, %IniFile%, Settings, StrokeLimit, 100
IniRead, MyMessage, %IniFile%, Settings, MyMessage, Hey, time to stretch those wrists!
IniRead, EnableMsgBox, %IniFile%, Settings, EnableMsgBox, 1
IniRead, EnableTrayTip, %IniFile%, Settings, EnableTrayTip, 1

; Convert the checkbox values from 0/1 to "Checked"/"Unchecked" for the GUI.
MsgBoxChecked := (EnableMsgBox = 1) ? "Checked" : ""
TrayTipChecked := (EnableTrayTip = 1) ? "Checked" : ""

; --- GUI SETUP ---
; Create a settings window that appears when the script is launched.
Gui, Add, Text,, Alert after this many Strokes:
; The Edit field now defaults to the value read from the INI file.
Gui, Add, Edit, vStrokeLimit w100, %StrokeLimit%

; Add a new text label and an input field for the custom message.
Gui, Add, Text,, Custom Message:
; The Edit field for the message now defaults to the value read from the INI file.
Gui, Add, Edit, vMyMessage w300, %MyMessage%

; Add some vertical space before the checkbox line using the 'y+10' option.
Gui, Add, Checkbox, y+10 vEnableMsgBox %MsgBoxChecked%, Enable Message Box
Gui, Add, Checkbox, vEnableTrayTip %TrayTipChecked%, Enable Toast Notification

; Create a button to save the settings and start the script.
; The 'g' option points to the corrected label name 'ButtonSaveSettings'.
Gui, Add, Button, Default gButtonSaveSettings, Save Settings

; Set a smaller font for the copyright message.
; 's8' sets the font size to 8 points.
Gui, Font, s7
; Add a simple text control at the bottom of the GUI for the copyright message.
Gui, Add, Text, y+10 Center, ©2025 gelatinguy, inspired by DTScribe
; Reset the font to the default size for any other controls that might be added later.
Gui, Font, s10


; Show the GUI window.
Gui, Show, , Stroke Counter Settings

; --- GUI LOGIC ---
; Return prevents the main script from running until the GUI is closed.
return

; This is the labe that runs when the "Save Settings" button is clicked or Enter is pressed.
ButtonSaveSettings:
; Get the values from the GUI controls and store them in variables.
Gui, Submit
; Write the settings to the INI file for persistence.
IniWrite, %StrokeLimit%, %IniFile%, Settings, StrokeLimit
IniWrite, %MyMessage%, %IniFile%, Settings, MyMessage
IniWrite, %EnableMsgBox%, %IniFile%, Settings, EnableMsgBox
IniWrite, %EnableTrayTip%, %IniFile%, Settings, EnableTrayTip
; Close the GUI window.
Gui, Destroy

; The GUI has been closed, so we can now initialize the main script variables.
StrokeCount := 0

; --- MAIN SCRIPT LOGIC ---
; This is the hotkey for the left mouse button.
~LButton::
    ; Increment the counter each time a left Stroke is detected.
    StrokeCount := StrokeCount + 1

    ; Check if the Stroke count is a multiple of the user-defined limit.
    if Mod(StrokeCount, StrokeLimit) == 0
    {
        ; Create a variable to hold the full toast notification message.
        ToastTitle := "Stroke count: " . StrokeCount
        ToastNotification := MyMessage

        ; Check if the "Enable Toast Notification" checkbox was checked.
        if EnableTrayTip
        {
            TrayTip, %ToastTitle%, %ToastNotification%
        }

        ; Check if the "Enable Message Box" checkbox was checked.
        if EnableMsgBox
        {
            MsgBox, Stroke count: %StrokeCount%`n`n%MyMessage%
        }
    }

return

; If the GUI is closed via the X button, this label runs and exits the script.
GuiClose:
ExitApp
