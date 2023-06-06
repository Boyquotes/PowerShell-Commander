extends Window

signal consoleMSG(text : String)

@export var first_name : LineEdit
@export var last_name : LineEdit
@export var username : LineEdit
@export var badge : LineEdit
@export var user_position : MenuButton

var badge_use : bool = false

enum Data_Packet_Type{Patrol_Deputy,Jail_Deputy,Dispatcher}

func _ready():
	Badge_Hide()
	var user_pos_popup : PopupMenu = user_position.get_popup()
	user_pos_popup.id_pressed.connect(User_Position_Menu_Popup)

func _on_close_requested() -> void:
	Badge_Hide()
	hide()

func reset() -> void:
	Badge_Hide()
	position = Vector2i(50,100)
	first_name.text = ""
	last_name.text = ""
	username.text = ""
	badge.text = ""
	user_position.text = "Position"

func consoleCommandPSLoggedOn(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("applets\\DelProf2.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func User_Position_Menu_Popup(id : int) -> void:
	match id:
		Data_Packet_Type.Patrol_Deputy:
			user_position.text = "Deputy (PATROL)"
			Badge_Show()
		Data_Packet_Type.Jail_Deputy:
			user_position.text = "Deputy (JAIL)"
			Badge_Show()
		Data_Packet_Type.Dispatcher:
			user_position.text = "Emergency Communications Officer (Dispatcher)"
			Badge_Hide()
		3:
			user_position.text = "Position"
			Badge_Hide()

func _on_button_pressed() -> void:
	print("Submit")

func Badge_Show() -> void:
	badge.show()
	badge_use = true
	size.y = 185

func Badge_Hide() -> void:
	badge.hide()
	badge_use = false
	size.y = 150
