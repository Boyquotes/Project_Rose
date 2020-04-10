# User settings singleton
extends Node

const USER_SETTINGS_PATH = "user://user_settings.cfg"

const KEY_BINDING_SECTION = "key_binding"

const GAMEFLAGS_SECTION = "game_flags"

var _user_settings : ConfigFile;
### IMPORTANT: TURN THIS FALSE WHEN EXPORTING ###
var load_defaults = true;

func _ready():
	load_settings()
	if not _user_settings.has_section(KEY_BINDING_SECTION):
		_create_default_key_bindings()
	if not _user_settings.has_section(GAMEFLAGS_SECTION):
		_create_game_flags();
	_load_key_bindings()
	_load_upgrades()
	if(load_defaults):
		_create_default_key_bindings();

func load_settings():
	# We create an empty file if not present to avoid error while loading settings
	var file = File.new()
	if not file.file_exists(USER_SETTINGS_PATH):
		file.open(USER_SETTINGS_PATH, file.WRITE)
		file.close()
	
	_user_settings = ConfigFile.new()
	var err = _user_settings.load(USER_SETTINGS_PATH)
	if err != OK:
		print("[ERROR] Cannot load user settings")
	
func save_settings():
	var err = _user_settings.save(USER_SETTINGS_PATH)
	if err != OK:
		print("[ERROR] Cannot save user settings")
		
func get_keybindings(action):
	return _user_settings.get_value(KEY_BINDING_SECTION, action)
	
func replace_keybinding(action, idx, input):
	var previous = InputMap.get_action_list(action)
	previous[idx] = input;
	_user_settings.set_value(KEY_BINDING_SECTION, action, previous)
	save_settings()
	_load_key_bindings()

func add_keybinding(action, input):
	var previous = InputMap.get_action_list(action)
	previous.push_back(input);
	_user_settings.set_value(KEY_BINDING_SECTION, action, previous)
	save_settings()
	_load_key_bindings()

func _create_default_key_bindings():
	for idx in InputMap.get_actions().size():
		_user_settings.set_value(KEY_BINDING_SECTION, InputMap.get_actions()[idx], InputMap.get_action_list(InputMap.get_actions()[idx]))
	save_settings()
 
func _load_key_bindings():
	var bindings = _user_settings.get_section_keys(KEY_BINDING_SECTION)
	for binding in bindings:
		if(InputMap.has_action(binding)):
			InputMap.erase_action(binding)
			InputMap.add_action(binding)
			var inputs = _user_settings.get_value(KEY_BINDING_SECTION, binding)
			for input in inputs:
				InputMap.action_add_event(binding, input)
		else:
			print(binding);

func _create_game_flags():
	for idx in GameFlags.powerups.keys().size():
		_user_settings.set_value(GAMEFLAGS_SECTION, GameFlags.powerups.keys()[idx], GameFlags.powerups.values()[idx])
	save_settings()

func set_upgrade(upgrade, activated):
	var previous = GameFlags.powerups;
	previous[upgrade] = activated;
	_user_settings.set_value(GAMEFLAGS_SECTION, upgrade, activated);
	save_settings();
	_load_upgrades()

func _load_upgrades():
	var upgrades = _user_settings.get_section_keys(GAMEFLAGS_SECTION)
	for upgrade in upgrades:
		var switch = _user_settings.get_value(GAMEFLAGS_SECTION, upgrade)
		GameFlags.powerups[upgrade] = switch;
