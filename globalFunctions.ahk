; ===================================================================
; [ Global Functions]

; Project:			HPSM, Beter Flow
; Author:			Kenneth
; ===================================================================

; [ GLOBAL VARIABLES ]
; ============================
global glSurName:=""
global glName:=""
global glPhone:=""
global glMail:=""
global glFloor:=""
global glService:=""
global glTag:=1
global glTitleTag:=""
global glBhv:=""
global glPriority:=""
global glScriptAvailable:=""
global glScriptId:=""
global glScriptfollow:=""
global glScriptResult:=""
global glTitle:=""
global glDescription:=""
global glIsSolved:=""

global glReport:="" ;; Implement later

; [ FUNCTIONS ]
; ============================

; Creates the initial window to select the correct troubleshoot
createInitWindow() {
	global
	Gui, Destroy
	Gui, Show, w500 h500, :D

	Gui, Add, Button, x30 y30 w440 h60 vSTANDAARDTROUBLESHOOT gSTANDAARDTROUBLESHOOT Center, Standaard Troubleshoot
	Gui, Add, Button, w440 h60 vVPNTROUBLESHOOT gVPNTROUBLESHOOT Center, VPN Troubleshoot
	Gui, Add, Button, w440 h60 vMAILTROUBLESHOOT gMAILTROUBLESHOOT Center, Mail Troubleshoot
	
	Return
	STANDAARDTROUBLESHOOT:
	{
		Gui, Submit
		standardTroubleshootLayout()
		return
	}
	MAILTROUBLESHOOT:
	{
		Gui, Submit
		mailTroubleshootLayout()
		return
	}
	VPNTROUBLESHOOT:
	{
		Gui, Submit
		vpnTroubleshootLayout()
		return
	}
	return
}

; Function to tab forward a %count% amount of steps
multTab(count) {
	str:=
	loop, %count% {
		str := str . "{tab}"
	}

	Send, %str%
}

; Function to tab forward a %count% amount of steps with CONTROL hold down
multTabControl(count) {
	Sleep, 1000
	str:=
	loop, %count% {
		str := str . "^{tab}"
	}

	Send, %str%
}

; Function to tab back a %count% amount of steps
multTabBack(count) {
	str:=
	loop, %count% {
		str := str . "^+{tab}"
	}

	Send, %str%
}

; Checks what the service is, and sets its accordingly
serviceCheck() {
	if (glService == "Software") {
		if (glPriority != 5)
			glService = wpaas - software (vobe){tab}{space}
		else
			glService = wpaas - software (vobe)
	} else if (glService == "Windows") {
		if (glPriority != 5)
			glService = wpaas - windows 7 (vobe){tab}{space}
		else
			glService = wpaas - windows 7 (vobe)
	} else if (glService == "Outlook") {
		if (glPriority != 5)
			glService = wpaas - outlook (vobe){tab}{space}
		else
			glService = wpaas - outlook (vobe)
	} else if (glService == "Leeg laten") {
		glService = {tab}+{tab}	
	} else {
		glService = {tab}+{tab}	
	}
}

; Checks if the tag is correct
tagCheck() {
	glTagLength := StrLen(glTag)
	StringLen, glTagLength, glTag

	if (glTag == "" || glTagLength != 7) {
		glTag := ""
		glTitleTag := ""
	} else {
		glTitleTag = %glTag% -
		glTag = %glTag% ;{tab}{space}
	}
}

; Checks what the current priority is set to, and than sets it to the correspending number
priorityCheck() {
	if (glPriority == "Priority 1") {
		glPriority = 1
	} else if (glPriority == "Priority 2") {
		glPriority = 2
	} else if (glPriority == "Priority 3") {
		glPriority = 3
	} else if (glPriority == "Priority 4") {
		glPriority = 4
	} else if (glPriority == "Priority 5"){
		glPriority = 5
	}
}

; A function which finds the location of VOBE
FindVobe() {
	Loop, 20 {
		clipboard = 
		Send ^a
		Send ^c
		ClipWait, 1
		if (clipboard == "VOBE") {
			Sleep, 750 
			Break
		} else {
			Send, ^+{tab}
		}
	}
}

FindVobeForward() {
	Loop, 20 {
		clipboard = 
		Send ^a
		Send ^c
		ClipWait, 1
		if (clipboard == "VOBE") {
			Sleep, 750 
			Break
		} else {
			Send, ^{tab}
		}
	}
}

troubleshootSendTop() {
	; Make sure HPSM is active
	IfWinExist, HP Service Manager 
	    WinActivate ; use the window found above
	else 
	    ExitApp

	Send, {tab}{tab}{Down}{Enter}
	multTab(2)
	Send, VOBE{tab}EXTERNE.GEBRUIKER@VOBE{tab}{space}
	FindVobeForward()
	
	if (glPriority == 5) {
		multTab(21)
		Send, {space}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{enter}
		multTab(19)
		Send, {Delete}
		multTabBack(7) 	
	}
	else {
		multTab(13)
	}

	Sleep, 1000 
	Send, %glService%

	FindVobe()
	multTab(16)
	Sleep, 1500 

	Send, %glTag%
	FindVobe() 
	if (glPriority == 5) {
		multTab(22) 
	}
	else {
		multTab(21) 
	}
	Send, %glSurName%, %glName% - %glTitleTag% %glTitle%
	multTab(3)
	Send, ^a {delete}
}

troubleshootSendBottom() {
	Send, ^{tab}{tab}
	Send, incident{tab}{tab}application{tab}{tab}performance degradation{tab}{tab}

	if (glPriority == 3 || glPriority == 4 || glPriority == 5) {
		Send, {tab}%glPriority%{tab}
	} else {
		Send, %glPriority%{tab}%glPriority%{tab}
	}

	if (glIsSolved == 1)
	{
		multTab(4)
		Send, Solved
		multTab(6)
		Send, %glDescription%
		Send, {enter}
		Send, GAS
	} 
	else 
	{
		multTab(11)
	}

	if (glPriority == 5)
		multTabBack(44)
	else
		multTabBack(43)
	

	Sleep, 1000

	Send, ^a
	Send, %glSurName%, %glName% 
	Send, {tab}{space}
}

byeBye() {
	MsgBox, , Done and Done, Script is done running.`nYour life got 30`% easier.`n`nYou're welcome., 5
}