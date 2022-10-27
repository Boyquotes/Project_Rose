extends PanelContainer

@export var hostpath : NodePath
@export var listpath : NodePath
@export var defpath : NodePath
var host : Control
var list : VBoxContainer
var def : Button
var action_ui_list : Array
var listen_button : Button
var button_list : Array
var prev_input : String

func _ready():
	init()

func init():
	def = get_node(defpath)
	host = get_node(hostpath);
	list = get_node(listpath)
	
	var action_list := InputMap.get_actions()
	for action in action_list:
		if not "ui_" in action:
			var action_element : ActionElement = preload("res://Game Objects/GUI/ActionElementPanel.tscn").instantiate()
			list.add_child(action_element)
			action_element.label.text = action
			
			var event_list := InputMap.action_get_events(action)
			for event in event_list:
				var button = Button.new()
				action_element.button_list.add_child(button)
				var text = event.as_text()
				#if event.get_class() == "InputEventJoypadMotion":
				#	text = event
				button.text = text
				button.pressed.connect(_on_button_pressed);
				button_list.push_back(button)
				button.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
			var button = Button.new()
			action_element.button_list.add_child(button)
			button.text = "add new input"
			button.pressed.connect(_on_button_pressed);
			button.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
			button_list.push_back(button)
			
			action_ui_list.push_back(action_element)

func _input(event):
	if listen_button:
		if event.get_class() != "InputEventMouseMotion":
			if event.get_class() == "InputEventJoypadMotion":
				if abs(event.axis_value) > 0.5:
					assign(event)
			else:
				assign(event)

func assign(event):
	listen_button.text = event.as_text()
	var action = listen_button.get_parent().get_parent().get_parent().label.text
	if prev_input == "add new input":
		UserSettings.add_keybinding(action, event.as_text())
	else:
		UserSettings.replace_keybinding(action, listen_button.get_index(),event);
	listen_button = null
	enable_all()

func _process(_delta):
	if Input.is_action_just_pressed("ui_pause") and not listen_button and visible:
		get_parent().grab_focus()
		get_parent().can_unpause = true
		hide()

func enable_all():
	for button in button_list:
		if button is Button:
			button.disabled = false;

func disable_all():
	for button in button_list:
		if button is Button:
			button.disabled = true;

func _on_button_pressed():
	for _button in button_list:
		if _button is Button:
			var button : Button = _button
			if button.pressed:
				prev_input = button.text
				button.text = "Listening for input..."
				listen_button = button
				disable_all()
				return

func _on_default_button_pressed():
	InputMap.load_from_project_settings()
	UserSettings._create_default_key_bindings();
	UserSettings._load_key_bindings()
	for action in action_ui_list:
		action.queue_free();
	action_ui_list.clear()
	button_list.clear()
	init()
	#defaults aren't loading like they should, need to revisit

