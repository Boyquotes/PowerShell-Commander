extends Window

signal consoleMSG(text : String)

func _on_close_requested() -> void:
	hide()

func reset() -> void:
	position = Vector2i(50,100)

func consoleCommand(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func _on_ALL_button_pressed() -> void:
	var _textBuffer : String = consoleCommand(["IPCONFIG", "/ALL"])
	emit_signal("consoleMSG", _textBuffer)

func _on_FLUSH_DNS_button_pressed() -> void:
	var _textBuffer : String = consoleCommand(["IPCONFIG", "/FLUSHDNS"])
	emit_signal("consoleMSG", _textBuffer)

func _on_RELEASE_button_pressed() -> void:
	var _textBuffer : String = consoleCommand(["IPCONFIG", "/RELEASE"])
	emit_signal("consoleMSG", _textBuffer)

func _on_RENEW_button_pressed() -> void:
	var _textBuffer : String = consoleCommand(["IPCONFIG", "/RENEW"])
	emit_signal("consoleMSG", _textBuffer)
