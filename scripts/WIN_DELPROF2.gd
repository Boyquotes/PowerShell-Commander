extends Window

var hostname : LineEdit
var username : LineEdit

signal consoleMSG(text : String)

func _ready():
	hostname = find_child("PC_Hostname")
	username = find_child("User")

func _on_close_requested() -> void:
	hide()

func reset() -> void:
	position = Vector2i(50,100)
	hostname.text = ""
	username.text = ""

func consoleCommand(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func consoleCommandDel(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("applets\\DelProf2.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func _on_button_pressed() -> void:
	var _pcName : bool = false
	var _userName : bool = false
	
	if hostname.text != "": _pcName = true
	if username.text != "": _userName = true
	
	if (_pcName && _userName):
		var _textBuffer : String = consoleCommandDel(["/u", "/c:" + hostname.text, "/id:" + username.text])
		emit_signal("consoleMSG", _textBuffer)
	elif (!_pcName && _userName):
		var _textBuffer : String = consoleCommandDel(["/u", "/id:" + username.text])
		emit_signal("consoleMSG", _textBuffer)
	elif (_pcName && !_userName):
		var _textBuffer : String = consoleCommandDel(["/u", "/c:" + hostname.text])
		emit_signal("consoleMSG", _textBuffer)
	else:
		pass

func _on_button_2_pressed() -> void:
	var _textBuffer : String = consoleCommand([".\\applets\\DelAll.bat" ,username.text])
	emit_signal("consoleMSG", _textBuffer)
