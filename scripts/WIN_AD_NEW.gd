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

@onready var positions_file : String = "config\\positions.cfg"

var positions : Dictionary = {}
var config : Dictionary = {"distinguishedName" = ""}
var list_of_groups : Dictionary = {1 : "Empty"}

func _ready():
	Load_Positions_Config()
	var user_pos_popup : PopupMenu = user_position.get_popup()
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
	Load_Positions_Config()

func consoleCommand(cmdArg : PackedStringArray) -> String:
	var _consoleBuffer : Array = []
	OS.execute("POWERSHELL.exe", cmdArg, _consoleBuffer, true)
	return _consoleBuffer[0]

func User_Position_Menu_Popup(id : int) -> void:
	for n in positions.keys():
		if (str_to_var(n) == id):
			user_position.text = positions[n].name
			config.distinguishedName = positions[n].data.distinguishedName
			config.description = positions[n].data.description
			config.title = positions[n].data.title
			config.department = positions[n].data.department
			config.company = positions[n].data.company
			list_of_groups = positions[n].data.groups
			break

func _on_button_pressed() -> void:
	if (config.distinguishedName != "" && username.text != ""):
		var badge_text : String = ""
		if (badge.text != ""):
			badge_text = " - #" + badge.text
		
		var console_command : String = str("New-ADUser"+" -Name "+str("\""+username.text.to_lower()+"\"")+" -SamAccountName "+str("\""+username.text.to_lower()+"\"")+" -UserPrincipalName "+str("\""+username.text + "@kcsdadmn.com"+"\"").to_lower()+" -GivenName "+str("\""+first_name.text+"\"")+" -Surname "+str("\""+last_name.text+"\"")+" -DisplayName "+str("\""+first_name.text + " " + last_name.text+"\"")+" -EmailAddress "+str("\""+first_name.text.left(1) + last_name.text + "@kcgov.us"+"\"").to_lower()+" -AccountPassword "+"(ConvertTo-SecureString -AsPlainText " + password.text + " -Force)"+" -CannotChangePassword $false"+" -ChangePasswordAtLogon $true"+" -Description "+str("\""+config.description + badge_text+"\"")+" -Title "+str("\""+config.title+"\"")+" -Department "+str("\""+config.department+"\"")+" -Company "+str("\""+config.company+"\"")+" -Path "+str("\""+config.distinguishedName+"\"")+" -Profilepath "+str("\""+"\\\\kcsdadmn.com\\userfilespace\\UserProfiles\\" + username.text.to_lower()+"\"")+" -Enabled $false")
		consoleMSG.emit(console_command)
		
		#		var _textBuffer : String = consoleCommand([
#			"New-ADUser",
#			"-Name", 				username.text.to_lower(),
#			"-SamAccountName", 		username.text.to_lower(),
#			"-UserPrincipalName", 	str(username.text + "@kcsdadmn.com").to_lower(),
#			"-GivenName", 			first_name.text,
#			"-Surname", 			last_name.text,
#			"-DisplayName", 		str(first_name.text + "' '" + last_name.text),
#			"-EmailAddress", 		str(first_name.text.left(1) + last_name.text + "@kcgov.us").to_lower(),
#			"-AccountPassword", 	str("(ConvertTo-SecureString -AsPlainText " + password.text + " -Force)"),
#			"-CannotChangePassword", "$false",
#			"-ChangePasswordAtLogon", "$true",
#			"-Description", 		str(config.description + badge_text).replace(" ", "' '"),
#			"-Title", 				config.title.replace(" ", "' '"),
#			"-Department", 			config.department.replace(" ", "' '"),
#			"-Company", 			str(config.company).replace(" ", "' '").replace(",", "\\2C"),
#			"-Path", 				str(config.distinguishedName).replace(" ", "' '").replace(",", "\\2C"),
#			"-Profilepath", 		str("\\\\kcsdadmn.com\\userfilespace\\UserProfiles\\" + username.text.to_lower()),
#			"-Enabled $false"
#		])

func Add_Groups() -> void:
	var _textBuffer : String = ""
	for group in list_of_groups.values():
		_textBuffer = consoleCommand(["Add-ADGroupMember", "-Identity", group.replace(" ", "\' \'"), "-Members", username.text])
		var _test : String = ""
		if (group.contains("'")):
			print("&apos")
			consoleMSG.emit("[color=red]" + "[u]" + username.text + "[/u]" + " Needs to be manually added to " + "\"" +group + "\"" + "." + "[/color]")
		else:
			consoleMSG.emit("[color=light green]" + "[u]" + username.text + "[/u]" + " Added to " + "\"" +group + "\"" + "." + "[/color]")

func Load_Positions_Config() -> void:
	if (FileAccess.file_exists(positions_file)):
		var file = FileAccess.open(positions_file, FileAccess.READ)
		var text : String = file.get_as_text()
		file.open(positions_file, FileAccess.READ)
		var json : JSON = JSON.new()
		var error = json.parse(text)
		if error == OK:
			positions = json.data
			var user_pos_popup : PopupMenu = user_position.get_popup()
			user_pos_popup.clear()
			for n in positions.values():
				user_pos_popup.add_item(n.name)
		else:
			consoleMSG.emit(str("ERROR::LOADING::"+ positions_file + " JSON Parse Error: ", json.get_error_message(), " in ", text, " at line ", json.get_error_line()))
			print(str("ERROR::LOADING::"+ positions_file + " JSON Parse Error: ", json.get_error_message(), " in ", text, " at line ", json.get_error_line()))
		json.is_queued_for_deletion()
		file.is_queued_for_deletion()
