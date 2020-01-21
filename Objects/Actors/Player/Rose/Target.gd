extends Node2D

onready var host = get_parent();
var rad=0;

func _process(delta):
	if(host.active_input == host.InputType.KEYMOUSE):
		rad = atan2(get_global_mouse_position().y - global_position.y , get_global_mouse_position().x - global_position.x);
	elif(host.active_input == host.InputType.GAMEPAD):
		if(abs(Input.get_joy_axis(0,JOY_ANALOG_RY))>.4 || abs(Input.get_joy_axis(0,JOY_ANALOG_RX))>.4):
			rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_RY), Input.get_joy_axis(0, JOY_ANALOG_RX));
		elif(abs(Input.get_joy_axis(0,JOY_ANALOG_LY))>.4 || abs(Input.get_joy_axis(0,JOY_ANALOG_LX))>.4):
			rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_LY), Input.get_joy_axis(0, JOY_ANALOG_LX));
	
	global_rotation_degrees = host.deg;