extends HBoxContainer

signal right_mouse_button_pressed;
signal disable_all;
signal enable_all;
var disabled = false;
onready var host = get_parent().get_parent().get_parent().get_parent();
onready var action = get_parent().get_parent().Action_Name

func init():
	disabled = false;
	for event in InputMap.get_action_list(action):
		var button = Button.new();
		add_child(button);
		button.text = parse_event(event);
		init_button(button);
	var button = Button.new();
	add_child(button);
	button.text = "add new input";
	init_button(button);
	for idx in get_child_count():
		if(get_child_count() <= 1):
			pass;
		elif(idx == 0):
			get_child(idx).focus_neighbour_right = get_child(idx+1).get_path();
		elif(idx == get_child_count()-1):
			get_child(idx).focus_neighbour_right = get_child(0).get_path();
			get_child(idx).focus_neighbour_left = get_child(idx-1).get_path();
		else:
			get_child(idx).focus_neighbour_right = get_child(idx+1).get_path();
			get_child(idx).focus_neighbour_left = get_child(idx-1).get_path();

func set_reinit():
	disabled = true;
	get_parent().get_node("initTimer").start();

func on_timeout():
	init();

func init_button(button : Button):
	button.connect("pressed",self,"on_button_pressed");
	button.action_mode = button.ACTION_MODE_BUTTON_RELEASE;

var pressed = false;
var listening = false;
var listen_button = null;

func _input(event):
	if(listening):
		var eventString = parse_event(event);
		if(eventString != ""):
			if(listen_button.get_index()) == InputMap.get_action_list(action).size():
				UserSettings.add_keybinding(action,event);
			else:
				UserSettings.replace_keybinding(action,listen_button.get_index(),event);
			get_child(get_child_count()-1).disabled = false;
			listen_button.text = eventString;
			listening = false;
			listen_button = null;
			emit_signal("enable_all");
	elif(!disabled):
		if(get_child(get_child_count()-1).is_hovered()):
			if(event.get_class() == "InputEventMouseButton"):
				if(event.button_index == BUTTON_RIGHT && event.pressed):
					emit_signal("right_mouse_button_pressed");
		else:
			pressed = false;

func _on_HBoxContainer_right_mouse_button_pressed():
	if(get_child(get_child_count()-3)):
		get_child(get_child_count()-3).focus_neighbour_right = get_child(get_child_count()-1).get_path();
		get_child(get_child_count()-1).focus_neighbour_left = get_child(get_child_count()-3).get_path();
	get_child(get_child_count()-2).queue_free();

func on_button_pressed():
	for idx in get_child_count():
		if(get_child(idx).pressed):
			if(idx == get_child_count() - 1 && get_child_count() < 10):
				get_child(idx).disabled = true;
				var button = Button.new();
				add_child(button);
				button.text = "add new input";
				get_child(idx).text = "null";
				get_child(idx).focus_neighbour_right = get_child(idx+1).get_path();
				get_child(idx).focus_neighbour_left = get_child(idx-1).get_path();
				get_child(idx+1).focus_neighbour_left = get_child(idx).get_path();
				get_child(idx+1).focus_neighbour_right = get_child(0).get_path();
				get_child(idx-1).focus_neighbour_right = get_child(idx).get_path();
				init_button(button);
				listen_for_input(idx);
			else:
				listen_for_input(idx);

func listen_for_input(idx):
	get_child(idx).text = "Listening for input..."
	listen_button = get_child(idx);
	listening = true;
	emit_signal("disable_all");

func parse_event(event : InputEvent):
	
	match event.get_class():
		"InputEventJoypadMotion":
			match event.axis:
				JOY_AXIS_0:
					if(event.axis_value < -0.5):
						return "Joypad Left Stick Left";
					elif(event.axis_value > 0.5):
						return "Joypad Left Stick Right";
				JOY_AXIS_1:
					if(event.axis_value < -0.5):
						return "Joypad Left Stick Up";
					elif(event.axis_value > 0.5):
						return "Joypad Left Stick Down";
				JOY_AXIS_2:
					if(event.axis_value < -0.5):
						return "Joypad Right Stick Left";
					elif(event.axis_value > 0.5):
						return "Joypad Right Stick Right";
				JOY_AXIS_3:
					if(event.axis_value < -0.5):
						return "Joypad Right Stick Up";
					elif(event.axis_value > 0.5):
						return "Joypad Right Stick Down";
		"InputEventKey":
			return event.as_text();
		"InputEventMouseButton":
			match event.button_index:
				BUTTON_LEFT:
					return "Mouse Button Left";
				BUTTON_RIGHT:
					return "Mouse Button Right";
				BUTTON_WHEEL_DOWN:
					return "Mouse Wheel Down";
				BUTTON_WHEEL_LEFT:
					return "Mouse Wheel Left";
				BUTTON_WHEEL_RIGHT:
					return "Mouse Wheel Right";
				BUTTON_WHEEL_UP:
					return "Mouse Wheel Up";
				BUTTON_MIDDLE:
					return "Mouse Button Middle";
		"InputEventJoypadButton":
			match event.button_index:
				JOY_BUTTON_0:
					return "Joypad Face South";
				JOY_BUTTON_1:
					return "Joypad Face East";
				JOY_BUTTON_2:
					return "Joypad Face West";
				JOY_BUTTON_3:
					return "Joypad Face North";
				JOY_BUTTON_4:
					return "Joypad L1";
				JOY_BUTTON_5:
					return "Joypad R1";
				JOY_BUTTON_6:
					return "Joypad L2";
				JOY_BUTTON_7:
					return "Joypad R2";
				JOY_BUTTON_8:
					return "Joypad L3";
				JOY_BUTTON_9:
					return "Joypad R3";
				JOY_BUTTON_12:
					return "Joypad Dpad Up";
				JOY_BUTTON_13:
					return "Joypad Dpad Down";
				JOY_BUTTON_14:
					return "Joypad Dpad Left";
				JOY_BUTTON_15:
					return "Joypad Dpad Right";
				
	return "";