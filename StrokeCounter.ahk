; Script written by Google Gemini and gelatinguy. Inspired by DTScribe, to count how many times he's moved his wrist while drawing.
; This script is for AutoHotkey 1.1.
#SingleInstance Force
Menu, Tray, Icon, StrokeCounterIcon.ico

; --- SCRIPT INITIALIZATION ---
; Define the settings file name.
IniFile := A_ScriptDir . "\StrokeCounterSettings.ini"

; Load settings from the INI file. If keys don't exist, use default values.
IniRead, StrokeLimit, %IniFile%, Settings, StrokeLimit, 100
IniRead, MyMessage, %IniFile%, Settings, MyMessage, Hey, time to stretch those wrists!
IniRead, EnableMsgBox, %IniFile%, Settings, EnableMsgBox, 1
IniRead, EnableTrayTip, %IniFile%, Settings, EnableTrayTip, 1
IniRead, EnableAlwaysOnTop, %IniFile%, Settings, EnableAlwaysOnTop, 0
IniRead, EnableCounter, %IniFile%, Settings, EnableCounter, 1
; New settings for the live counter's font, size, label text, and window title.
IniRead, CounterText, %IniFile%, Settings, CounterText, Strokes
IniRead, CounterFont, %IniFile%, Settings, CounterFont, Arial
IniRead, CounterSize, %IniFile%, Settings, CounterSize, 16
IniRead, CounterTitle, %IniFile%, Settings, CounterTitle, Live Stroke Counter
; Read the new color and transparency settings.
IniRead, CounterFontColor, %IniFile%, Settings, CounterFontColor, Black
IniRead, CounterBackColor, %IniFile%, Settings, CounterBackColor, White
IniRead, EnableTransparency, %IniFile%, Settings, EnableTransparency, 0
; New setting to enable or disable the ToolWindow style for OBS compatibility.
IniRead, EnableOBSCapture, %IniFile%, Settings, EnableOBSCapture, 1
; New settings for the sound alert.
IniRead, AlertSound, %IniFile%, Settings, AlertSound, alert.wav
IniRead, EnableSound, %IniFile%, Settings, EnableSound, 0
; New setting for the image alert filename.
IniRead, AlertImage, %IniFile%, Settings, AlertImage, stretch.png
; New setting for the image alert checkbox.
IniRead, EnableImageCheckbox, %IniFile%, Settings, EnableImageCheckbox, 1
; New setting for the message box transparency checkbox.
IniRead, EnableMsgBoxTransparency, %IniFile%, Settings, EnableMsgBoxTransparency, 0

; Initialize the global stroke counter variable.
StrokeCount := 0

; Convert the checkbox values from 0/1 to "Checked"/"Unchecked" for the GUI.
MsgBoxChecked := (EnableMsgBox = 1) ? "Checked" : ""
TrayTipChecked := (EnableTrayTip = 1) ? "Checked" : ""
AlwaysOnTopChecked := (EnableAlwaysOnTop = 1) ? "Checked" : ""
CounterChecked := (EnableCounter = 1) ? "Checked" : ""
TransparencyChecked := (EnableTransparency = 1) ? "Checked" : ""
OBSCaptureChecked := (EnableOBSCapture = 1) ? "Checked" : ""
SoundChecked := (EnableSound = 1) ? "Checked" : ""
; Use the new variable for the image checkbox state.
ImageChecked := (EnableImageCheckbox = 1) ? "Checked" : ""
MsgBoxTransparencyChecked := (EnableMsgBoxTransparency = 1) ? "Checked" : ""

; --- MAIN SETTINGS GUI SETUP (GUI 1) ---
; Create the main settings window.
Gui, 1: Default

Gui, Add, Text, y+10, Alert after this many Strokes:
; The Edit field now defaults to the value read from the INI file.
Gui, Add, Edit, vStrokeLimit w100, %StrokeLimit%

; Add a new text label and an input field for the custom message.
Gui, Add, Text, y+10, Custom Message:
; The Edit field for the message now defaults to the value read from the INI file.
Gui, Add, Edit, vMyMessage w300, %MyMessage%

; New controls for the sound alert. The `gToggleSoundFile` label will enable/disable the text field.
Gui, Add, Checkbox, y+10 vEnableSound gToggleSoundFile %SoundChecked%, Play a Sound
Gui, Add, Text, x30 y+0, WAV File:
Gui, Add, Edit, vAlertSound x+5 w150, %AlertSound%

; New controls for the message box. The `gToggleMsgBox` label will enable/disable the fields.
Gui, Add, Checkbox, x10 y+10 vEnableMsgBox gToggleMsgBox %MsgBoxChecked%, Pop-up Message Box
; Use the new variable for the image checkbox.
Gui, Add, Checkbox, x30 vEnableImageCheckbox gToggleImageFile %ImageChecked%, Show an Image
Gui, Add, Text, x30 y+5, PNG File:
; New input field for the image filename. This is conditionally enabled.
Gui, Add, Edit, vAlertImage x+5 w150, %AlertImage%
; New checkbox to make the message box transparent. The 'gToggleMsgBoxTransparency' label will handle enabling/disabling of the transparency.
Gui, Add, Checkbox, x+5 vEnableMsgBoxTransparency gToggleMsgBoxTransparency %MsgBoxTransparencyChecked%, Transparent Background

; Add some vertical space before the checkbox line using the 'y+10' option.
Gui, Add, Checkbox, x10 y+10 vEnableTrayTip %TrayTipChecked%, Pop-up Toast Notification
; New checkbox to enable/disable the live counter window. The 'g' option links it to a label.
Gui, Add, Checkbox, y+10 vEnableCounter gToggleAllSettings %CounterChecked%, Show Live Stroke Counter
; Add the "Always On Top" checkbox with an indentation.
Gui, Add, Checkbox, x30 y+10 vEnableAlwaysOnTop %AlwaysOnTopChecked%, Always On Top
; Add the new "Enable OBS Capture Mode" checkbox.
; When enabled, this removes the ToolWindow style for better OBS compatibility.
Gui, Add, Checkbox, x30 y+10 vEnableOBSCapture %OBSCaptureChecked%, Enable OBS Capture

; Add controls for customizing the live counter's font, size, and text.
; These will be placed on a new line and aligned to the left.
Gui, Add, Text, y+10, Live Counter Window Title:
Gui, Add, Edit, vCounterTitle w200, %CounterTitle%

Gui, Add, Text, y+10, Live Counter Text:
Gui, Add, Edit, vCounterText w100, %CounterText%

Gui, Add, Text, y+10, Live Counter Font:
; Font selection uses a ComboBox, which allows typing and selecting from the list.
Gui, Add, ComboBox, x30 vCounterFont w170, Arial|Calibri|Comic Sans MS|Papyrus|Segoe UI|Tahoma|Verdana|Consolas|Courier New|Times New Roman|Impact

; This new line sets the text field of the ComboBox to the value loaded from the INI file.
GuiControl, Text, CounterFont, %CounterFont%

Gui, Add, Edit, x+20 vCounterSize w50, %CounterSize%

; Add new controls for font and background color.
Gui, Add, Text, x30 y+10, Foreground Color (e.g. Black, Red, #00FF00):
Gui, Add, Edit, vCounterFontColor w100, %CounterFontColor%

Gui, Add, Text, y+10, Background Color (e.g. White, Blue, #FFFFFF):
Gui, Add, Edit, vCounterBackColor w100, %CounterBackColor%
; Add the new checkbox for transparency.
; This setting uses WinSet, TransColor to create transparency for OBS's Color Key filter.
Gui, Add, Checkbox, x+20 vEnableTransparency %TransparencyChecked%, Transparent Background

; --- Initial GUI state fixes ---
; Conditionally disable the controls if the live counter is not enabled at script start.
if (EnableCounter = 0)
{
    GuiControl, Disable, EnableAlwaysOnTop
    GuiControl, Disable, EnableOBSCapture
    GuiControl, Disable, CounterTitle
    GuiControl, Disable, CounterText
    GuiControl, Disable, CounterFont
    GuiControl, Disable, CounterSize
    GuiControl, Disable, CounterFontColor
    GuiControl, Disable, CounterBackColor
    GuiControl, Disable, EnableTransparency
}

; Conditionally disable the sound file field if the sound checkbox is not checked at script start.
if (EnableSound = 0)
{
    GuiControl, Disable, AlertSound
}

; Conditionally disable the image file field if the image checkbox is not checked at script start.
; This is the fix for the reported bug.
if (EnableImageCheckbox = 0)
{
    GuiControl, Disable, AlertImage
}

; Conditionally disable the transparent checkbox and the image checkbox
; if the message box is not checked.
if (EnableMsgBox = 0)
{
    GuiControl, Disable, EnableImageCheckbox
    GuiControl, Disable, EnableMsgBoxTransparency
}

; --- Buttons and script info ---
; Create a button to save the settings and start the script.
; The 'g' option points to the corrected label name 'ButtonSaveSettings'.
; The 'x10' option here forces the button to the left side of the window, and 'y+14' moves it to a new line.
Gui, Add, Button, x10 y+14 Default gButtonSaveSettings, Save Settings

; Set a smaller font for the copyright message.
Gui, Font, s7
Gui, Add, Text, y+10, ©2025 gelatinguy and DTScribe

; Reset the font to the default size for any other controls that might be added later.
Gui, Font, s10

; Show the GUI window.
Gui, Show, , Stroke Counter Settings

; --- LIVE COUNTER WINDOW SETUP (GUI 2) ---
; Create a second GUI for the live stroke counter.
Gui, 2: Default
; We now check if the color string starts with a '#' and remove it if it does.
if (SubStr(CounterFontColor, 1, 1) = "#")
{
    CounterFontColor := SubStr(CounterFontColor, 2)
}
if (SubStr(CounterBackColor, 1, 1) = "#")
{
    CounterBackColor := SubStr(CounterBackColor, 2)
}
; Use the variables to set the font and size.
Gui, Font, s%CounterSize% Bold c%CounterFontColor%, %CounterFont%
; Set the window style before showing it to avoid the "Invalid Option" error.
; We now check the new setting to apply the ToolWindow style conditionally.
if not EnableOBSCapture
{
    ; ToolWindow style prevents the window from appearing in the Alt-Tab list,
    ; but can sometimes prevent OBS from seeing the window.
    Gui, 2: +ToolWindow
}
; The `-Resize` and `+ToolWindow` options are now applied here.
; Removed fixed dimensions and added +Resize to allow the window to be resized.
Gui, 2: +Resize
; Apply the new background color setting.
Gui, 2: Color, %CounterBackColor%
; The 'g' option now points to the GuiSize label to handle dynamic resizing.
; Removed +BackgroundTrans and added gRedrawCounterText to handle clicks.
Gui, Add, Text, vStrokeCountText gRedrawCounterText, %CounterText% %StrokeCount%
; Removed fixed dimensions. The GuiSize label will handle resizing after creation.
Gui, 2: Show, NoActivate, %CounterTitle%

; Check the saved setting and apply the AlwaysOnTop property to the counter window.
if EnableAlwaysOnTop
{
    Gui, 2: +AlwaysOnTop
}
else
{
    Gui, 2: -AlwaysOnTop
}

; Apply transparency if the setting is enabled.
if EnableTransparency
{
    ; This command sets the background color as the transparent color.
    ; This is used with OBS's "Color Key" filter.
    Gui, 2: +LastFound
    WinSet, TransColor, %CounterBackColor%
}
else
{
    Gui, 2: +LastFound
    WinSet, TransColor, Off
}

; Hide the counter window for now. It will be shown after settings are saved.
Gui, 2: Hide

; --- GUI LOGIC ---
; Return prevents the main script from running until the GUI is closed.
return

; This is the label that runs when the "Play a Sound" checkbox is clicked.
ToggleSoundFile:
    GuiControlGet, EnableSound
    if EnableSound
    {
        GuiControl, Enable, AlertSound
    }
    else
    {
        GuiControl, Disable, AlertSound
    }
return

; This is the label that runs when the "Pop-up Message Box" checkbox is clicked.
; It now only toggles the visibility of the "Show an Image" checkbox.
ToggleMsgBox:
    GuiControlGet, EnableMsgBox
    if EnableMsgBox
    {
        GuiControl, Enable, EnableImageCheckbox
        GuiControl, Enable, EnableMsgBoxTransparency
    }
    else
    {
        GuiControl, Disable, EnableImageCheckbox
        GuiControl, Disable, EnableMsgBoxTransparency
    }
return

; This is the label that runs when the "Show an Image" checkbox is clicked.
; It now only toggles the PNG file field.
ToggleImageFile:
    GuiControlGet, EnableImageCheckbox
    if EnableImageCheckbox
    {
        GuiControl, Enable, AlertImage
    }
    else
    {
        GuiControl, Disable, AlertImage
    }
return

; This is the label that runs when the "Transparent Background" checkbox is clicked.
ToggleMsgBoxTransparency:
    ; This checkbox doesn't disable any other controls, but we need the label to be here.
return

; This is the label that runs when the "Show Live Stroke Counter" checkbox is clicked.
ToggleAllSettings:
GuiControlGet, EnableCounter
if EnableCounter
{
    ; If the live counter is enabled, enable all the related controls.
    GuiControl, Enable, EnableAlwaysOnTop
    GuiControl, Enable, EnableOBSCapture
    GuiControl, Enable, CounterTitle
    GuiControl, Enable, CounterText
    GuiControl, Enable, CounterFont
    GuiControl, Enable, CounterSize
    GuiControl, Enable, CounterFontColor
    GuiControl, Enable, CounterBackColor
    GuiControl, Enable, EnableTransparency
}
else
{
    ; If the live counter is disabled, disable all the related controls.
    GuiControl, Disable, EnableAlwaysOnTop
    GuiControl, Disable, EnableOBSCapture
    GuiControl, Disable, CounterTitle
    GuiControl, Disable, CounterText
    GuiControl, Disable, CounterFont
    GuiControl, Disable, CounterSize
    GuiControl, Disable, CounterFontColor
    GuiControl, Disable, CounterBackColor
    GuiControl, Disable, EnableTransparency
}
return

; This is the label that runs when the "Save Settings" button is clicked or Enter is pressed.
ButtonSaveSettings:
; Get the values from the GUI controls and store them in variables.
Gui, 1: Submit, NoHide
; Write the settings to the INI file for persistence.
IniWrite, %StrokeLimit%, %IniFile%, Settings, StrokeLimit
IniWrite, %MyMessage%, %IniFile%, Settings, MyMessage
IniWrite, %EnableMsgBox%, %IniFile%, Settings, EnableMsgBox
IniWrite, %EnableTrayTip%, %IniFile%, Settings, EnableTrayTip
IniWrite, %EnableAlwaysOnTop%, %IniFile%, Settings, EnableAlwaysOnTop
IniWrite, %EnableCounter%, %IniFile%, Settings, EnableCounter
; Write the new OBS capture setting.
IniWrite, %EnableOBSCapture%, %IniFile%, Settings, EnableOBSCapture
; Write the new sound settings.
IniWrite, %EnableSound%, %IniFile%, Settings, EnableSound
IniWrite, %AlertSound%, %IniFile%, Settings, AlertSound
; Write the new image filename.
IniWrite, %AlertImage%, %IniFile%, Settings, AlertImage
; Write the new image checkbox state.
IniWrite, %EnableImageCheckbox%, %IniFile%, Settings, EnableImageCheckbox
; Write the new message box transparency setting.
IniWrite, %EnableMsgBoxTransparency%, %IniFile%, Settings, EnableMsgBoxTransparency

; The GUI has been closed, so we can now initialize the main script variables.
StrokeCount := 0

; Check if the "Enable Counter" checkbox was checked and show/hide the window accordingly.
if EnableCounter
{
    ; Re-initialize the counter GUI with the new settings.
    Gui, 2: Destroy
    Gui, 2: Default
    Gui, Font, s%CounterSize% Bold c%CounterFontColor%, %CounterFont%
    ; Apply the ToolWindow style conditionally.
    if not EnableOBSCapture
    {
        Gui, 2: +ToolWindow
    }
    ; Removed fixed dimensions and added +Resize
    Gui, 2: +Resize
    ; Apply the new background color setting.
    Gui, 2: Color, %CounterBackColor%
    ; The 'g' option now points to the GuiSize label to handle dynamic resizing.
    ; Removed +BackgroundTrans and added gRedrawCounterText to handle clicks.
    Gui, Add, Text, vStrokeCountText gRedrawCounterText, %CounterText% %StrokeCount%
    ; Removed fixed dimensions. The GuiSize label will handle resizing after creation.
    Gui, 2: Show, NoActivate, %CounterTitle%

    ; Check the saved setting and apply the AlwaysOnTop property to the counter window.
    if EnableAlwaysOnTop
    {
        Gui, 2: +AlwaysOnTop
    }
    else
    {
        Gui, 2: -AlwaysOnTop
    }

    ; Apply transparency if the setting is enabled.
    if EnableTransparency
    {
        Gui, 2: +LastFound
        WinSet, TransColor, %CounterBackColor%
    }
    else
    {
        Gui, 2: +LastFound
        WinSet, TransColor, Off
    }
}
else
{
    Gui, 2: Hide
}

; Close the GUI window.
Gui, 1: Destroy

; --- MAIN SCRIPT LOGIC ---
; This is the hotkey for the left mouse button.
~LButton::
    ; Increment the counter each time a left Stroke is detected.
    StrokeCount := StrokeCount + 1

    ; Only update the counter GUI if the counter is enabled.
    if EnableCounter
    {
        ; Update the text control with the new stroke count.
        GuiControl, 2: , StrokeCountText, %CounterText% %StrokeCount%
    }

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
            ; Always use the custom GUI now to provide consistent behavior.
            GoSub, ShowImageMsgBox
        }

        ; Check if the "Play a Sound" checkbox was checked.
        if EnableSound
        {
            ; Play the sound file. The 'Wait' option prevents the script from trying to play
            ; the same sound repeatedly if the hotkey is triggered in quick succession.
            SoundPlay, %A_ScriptDir%\%AlertSound%, Wait
        }
    }

return

; --- CUSTOM IMAGE MESSAGE BOX GUI ---
; This label creates a temporary GUI to show the image and message.
ShowImageMsgBox:
    ; Create a new GUI window that is not associated with GUI 1 or 2.
    ; Added -Caption which is a shortcut for -Border -TitleBar
    Gui, New, -Caption, Custom Alert

    ; Use the new variable for the checkbox state.
    if (EnableImageCheckbox && EnableMsgBoxTransparency)
    {
        ; Set the background color to a unique, less-jarring color and make it transparent.
        ; This color (#000001) is a near-black that is less likely to show up
        ; as a noticeable artifact than bright magenta.
        Gui, Color, 000001
        Gui, +LastFound
        WinSet, TransColor, 000001
        Gui, Add, Picture, +BackgroundTrans gCloseImageMsgBox, %A_ScriptDir%\%AlertImage%
        ; This line is the key to creating a borderless pop-up.
        ; You must click on the image itself to close it.
        Gui, Show, , Stroke Counter Alert
    }
    else
    {
        ; Create the standard message box with an optional image and text.
        Gui, Font, s10
        Gui, Color, F0F0F0
        Gui, Add, Text, , Stroke count: %StrokeCount%`n%MyMessage%
        ; Check if the image checkbox is enabled AND the file exists before adding the picture control.
        if EnableImageCheckbox && FileExist(A_ScriptDir . "\" . AlertImage)
        {
            Gui, Add, Picture, , %A_ScriptDir%\%AlertImage%
        }
        Gui, Add, Button, Default gCloseImageMsgBox, OK
        Gui, Show, , Stroke Counter Alert
    }
return

; This label handles the closing of the custom message box when the button is clicked or the image is clicked.
CloseImageMsgBox:
    Gui, Destroy
return

; This is the label that runs when the Text control is clicked.
; AHK has an issue where the Text disappears when focus changes, so this forces it to draw again.
RedrawCounterText:
GuiControl, 2: , StrokeCountText, %CounterText% %StrokeCount%
return

; This is the label that runs when GUI 2 is resized.
2GuiSize:
; I've corrected this line to use a variable for the width and height calculations,
; which is the correct syntax for AutoHotkey 1.1.
newWidth := A_GuiWidth - 20
newHeight := A_GuiHeight - 20
GuiControl, Move, StrokeCountText, W%newWidth% H%newHeight%
; Call the new label to redraw the text after resizing.
GoSub, RedrawCounterText
return

; If the GUI is closed via the X button, this label runs and exits the script.
1GuiClose:
ExitApp
