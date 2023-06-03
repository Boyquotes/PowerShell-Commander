extends Window

signal consoleMSG(text : String)

@export var textField : LineEdit
@export var menu : MenuButton

func _on_close_requested() -> void:
	hide()

func reset() -> void:
	position = Vector2i(50,100)
	textField.text = ""
	menu.text = "Position"

func consoleCommandPSLoggedOn(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("PsLoggedon64.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func _on_button_pressed() -> void:
	pass

func _on_line_edit_text_submitted(_new_text):
	_on_button_pressed()
