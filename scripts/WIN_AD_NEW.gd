extends Window

# TODO:
# 1. Sheriffs -> Sheriff's
# 2. Adding User to Groups

signal consoleMSG(text : String)

@export var first_name : LineEdit
@export var last_name : LineEdit
@export var username : LineEdit
@export var password : LineEdit
@export var badge : LineEdit
@export var user_position : MenuButton

var distinguishedName : String = ""
var list_of_groups : Dictionary = {1 : "Patrol Global"}

func _ready():
	var user_pos_popup : PopupMenu = user_position.get_popup()
	user_pos_popup.id_pressed.connect(User_Position_Menu_Popup)

func _on_close_requested() -> void:
	hide()

func reset() -> void:
	position = Vector2i(50,100)
	list_of_groups = {}
	distinguishedName = ""
	first_name.text = ""
	last_name.text = ""
	username.text = ""
	password.text = ""
	badge.text = ""
	user_position.text = "Position"

func consoleCommand(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func User_Position_Menu_Popup(id : int) -> void:
	match id:
		0:
			user_position.text = "Deputy (PATROL)"
			distinguishedName = "OU=ISDEPT,DC=kcsdadmn,DC=com"
		1:
			user_position.text = "Deputy (JAIL)"
			distinguishedName = "OU=ISDEPT,DC=kcsdadmn,DC=com"
		2:
			user_position.text = "Emergency Communications Officer (Dispatcher)"
			distinguishedName = "OU=ISDEPT,DC=kcsdadmn,DC=com"

func _on_button_pressed() -> void:
	if (distinguishedName != ""):
		var badge_text : String = ""
		if (badge.text != ""):
			badge_text = "' '#" + badge.text 

		var _textBuffer : String = consoleCommand([
			"New-ADUser",
			"-Name", username.text.to_lower(),
			"-SamAccountName", username.text.to_lower(),
			"-UserPrincipalName", str(username.text.to_lower() + "@kcsdadmn.com"),
			"-GivenName", first_name.text,
			"-Surname", last_name.text,
			"-DisplayName", str(first_name.text + "' '" + last_name.text),
			"-EmailAddress", str(first_name.text.left(1).to_lower() + last_name.text.to_lower() + "@kcgov.us"),
			"-AccountPassword", str("(ConvertTo-SecureString -AsPlainText " + password.text + " -Force)"),
			"-CannotChangePassword",  "$false",
			"-ChangePasswordAtLogon", "$true",
			"-Description", str("PC/Network' 'Specialist" + badge_text),
			"-Title", "PC/Network' 'Specialist",
			"-Department", "IT",
			"-Company", "Kootenai' 'County' 'Sheriffs' 'Office",
			"-Path", distinguishedName.replace(",", "','"),
			"-Profilepath", str("\\\\kcsdadmn.com\\userfilespace\\UserProfiles\\" + username.text.to_lower()),
			"-Enabled $false"
		])
		
		consoleMSG.emit("User Creation Attempt. \n" + _textBuffer)
		
		for group in list_of_groups.values():
			_textBuffer = consoleCommand(["Add-ADGroupMember", "-Identity", str(group).replace(" ", "\' \'"), "-Members", username.text])
			consoleMSG.emit(username.text + " Added to " + str(group) + ".")
