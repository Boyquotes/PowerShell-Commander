extends Window

signal consoleMSG(text : String)

var textField : LineEdit

func _ready():
	textField = find_child("LineEdit")

func _on_close_requested() -> void:
	hide()

func reset() -> void:
	position = Vector2i(50,100)
	textField.text = ""

func consoleCommand(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func _on_examine_button_pressed() -> void:
	if(textField.text != ""):
		var _textBuffer : String = consoleCommand(["NET", "USER", "/DOMAIN", textField.text])
		emit_signal("consoleMSG", _textBuffer)

func _on_unlock_button_pressed() -> void:
	if(textField.text != ""):
		var _textBuffer : String = consoleCommand(["Unlock-ADAccount", textField.text])
		emit_signal("consoleMSG", "Unlocked User " + textField.text)

func _on_line_edit_text_submitted(_new_text):
	_on_examine_button_pressed()
