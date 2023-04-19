extends Node

@onready var console_outut = %CONSOLE_OUTPUT

var windows : Dictionary = {}
var listOfLockedUsers : Dictionary = {}

func _ready():
	$Main_Window.show()
	
	windows.ping = %WIN_PING
	windows.ipconfig = %WIN_IPCONFIG
	windows.ad = %WIN_AD
	windows.delprof2 = %WIN_DELPROF2
	windows.PsLoggedOn = %WIN_PS_LOGGED_ON
	
	windows.ping.consoleMSG.connect(addToConsole, 1)
	windows.ipconfig.consoleMSG.connect(addToConsole, 1)
	var _win_pingTab : MenuButton = %IP_COMMAND_TABS
	var _win_pingPop : PopupMenu = _win_pingTab.get_popup()
	_win_pingPop.id_pressed.connect(IPCommandTabMenu, 1)
	
	windows.ad.consoleMSG.connect(addToConsole, 1)
	var _ADTab : MenuButton = %ACTIVE_DIRECTORY_TABS
	var _ADPop : PopupMenu = _ADTab.get_popup()
	_ADPop.id_pressed.connect(ADTabMenu, 1)
	
	windows.delprof2.consoleMSG.connect(addToConsole, 1)
	windows.PsLoggedOn.consoleMSG.connect(addToConsole, 1)
	var _DelTab : MenuButton = %APPS
	var _DelPop : PopupMenu = _DelTab.get_popup()
	_DelPop.id_pressed.connect(AppTabMenu, 1)

func _process(_delta):
	if (Input.is_action_pressed("ui_cancel")):
		for i in windows:
			windows[i].hide()
			windows[i].reset()

func signalClearConsole() -> void:
	clearConsole()

func clearConsole() -> void:
	console_outut.text = ""

func addToConsole(cInput : String) -> void:
	cInput = cInput.replacen("Copyright (C) 2000-2016 Mark Russinovich", "")
	cInput = cInput.replacen("Sysinternals - www.sysinternals.com", "")
	console_outut.text += cInput
	console_outut.text += "\n" + "[center][color=hotpink]<(^^<) (>^^)> (>^^<) ([b]Line Brake[/b]) (>^^<) <(^^<) (>^^)>[/color][/center]" + "\n"

func consoleCommand(cmdArg : PackedStringArray) -> void:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	var _consoleOutput : String = _consoleBuffer[0]
	addToConsole(_consoleOutput)

func consoleCommandADLocked(cmdArg : PackedStringArray) -> void:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	var _consoleOutput : String = _consoleBuffer[0]
	
#	Populate Locked Accounts Dict : listOfLockedUsers
	if "SamAccountName" in _consoleOutput:
		var placeHolderLoop : bool = true
		var placeHolder : int = 0
		var placeHolderOffset : int = 0
		var numOfLockedUsers : int = 0
		while (placeHolderLoop):
			placeHolder = _consoleOutput.findn("SamAccountName", placeHolder) + 1
			placeHolderOffset = _consoleOutput.findn("SID", placeHolder) + 1
			if (placeHolder == 0):
				placeHolderLoop = false
			else:
				var user : Dictionary = {"user" : _consoleOutput.substr(placeHolder + 23, placeHolderOffset - 25 - placeHolder)}
				listOfLockedUsers[str(numOfLockedUsers)] = user
				numOfLockedUsers += 1
			
		_consoleOutput = _consoleOutput.replacen("SamAccountName", "[color=green]SamAccountName")
		_consoleOutput = _consoleOutput.replacen("SID", "[/color]SID")
		_consoleOutput = _consoleOutput.replacen("PasswordExpired       : True", "[color=darkred]PasswordExpired       : True[/color]")
		_consoleOutput = _consoleOutput.replacen("PasswordExpired       : False", "[color=darkgreen]PasswordExpired       : False[/color]")
	addToConsole(_consoleOutput)

func IPCommandTabMenu(id : int) -> void:
	match id:
		0:
			windows.ping.hide()
			windows.ping.reset()
			windows.ping.show()
		1:
			windows.ipconfig.hide()
			windows.ipconfig.reset()
			windows.ipconfig.show()

func ADTabMenu(id : int) -> void:
	match id:
		0:
			consoleCommandADLocked(["Search-AdAccount", "-LockedOut"])
		1:
			windows.ad.hide()
			windows.ad.reset()
			windows.ad.show()

func AppTabMenu(id : int) -> void:
	match id:
		1:
			windows.delprof2.hide()
			windows.delprof2.reset()
			windows.delprof2.show()
		2:
			windows.PsLoggedOn.hide()
			windows.PsLoggedOn.reset()
			windows.PsLoggedOn.show()
