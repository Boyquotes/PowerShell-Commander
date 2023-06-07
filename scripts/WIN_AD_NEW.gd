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

var positions : Dictionary = {1 : "Deputy (PATROL)", 2 : "Deputy (JAIL)"}

var config : Dictionary = {"distinguishedName" : "", "description" : "", "title" : "", "department" : "",
"company" : ""}
var list_of_groups : Dictionary = {1 : "Patrol Global"}

func _ready():
	var user_pos_popup : PopupMenu = user_position.get_popup()
	for n in positions.keys():
		user_pos_popup.add_item(positions[n])
	user_pos_popup.id_pressed.connect(User_Position_Menu_Popup)

func _on_close_requested() -> void:
	hide()

func reset() -> void:
	position = Vector2i(50,100)
	list_of_groups = {}
	config.distinguishedName = ""
	config.description = ""
	config.title = ""
	config.department = ""
	config.company = ""
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
	for n in positions.keys():
		if (n - 1 == id):
			user_position.text = positions[n]
			config.distinguishedName = "OU=ISDEPT,DC=kcsdadmn,DC=com"
			config.description = "PC/Network Specialist"
			config.title = "PC/Network Specialist"
			config.department = "IT"
			config.company = "Kootenai County Sheriffs Office"
			break

func _on_button_pressed() -> void:
	if (config.distinguishedName != ""):
		var badge_text : String = ""
		if (badge.text != ""):
			badge_text = " #" + badge.text 

		var _textBuffer : String = consoleCommand([
			"New-ADUser",
			"-Name", username.text.to_lower(),
			"-SamAccountName", username.text.to_lower(),
			"-UserPrincipalName", str(username.text + "@kcsdadmn.com").to_lower(),
			"-GivenName", first_name.text,
			"-Surname", last_name.text,
			"-DisplayName", str(first_name.text + "' '" + last_name.text),
			"-EmailAddress", str(first_name.text.left(1) + last_name.text + "@kcgov.us").to_lower(),
			"-AccountPassword", str("(ConvertTo-SecureString -AsPlainText " + password.text + " -Force)"),
			"-CannotChangePassword",  "$false",
			"-ChangePasswordAtLogon", "$true",
			"-Description", str(config.description + badge_text).replace(" ", "' '"),
			"-Title", config.title.replace(" ", "' '"),
			"-Department", config.department.replace(" ", "' '"),
			"-Company", config.company.replace(" ", "' '"),
			"-Path", config.distinguishedName.replace(",", "','"),
			"-Profilepath", str("\\\\kcsdadmn.com\\userfilespace\\UserProfiles\\" + username.text.to_lower()),
			"-Enabled $false"
		])
		
		consoleMSG.emit("User Creation Attempt. \n" + _textBuffer)
		
		for group in list_of_groups.values():
			_textBuffer = consoleCommand(["Add-ADGroupMember", "-Identity", group.replace(" ", "\' \'"), "-Members", username.text])
			consoleMSG.emit(username.text + " Add to " + group + ".")
