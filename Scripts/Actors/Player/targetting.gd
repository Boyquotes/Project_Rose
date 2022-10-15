extends Node2D


@onready var host = get_parent().get_parent();
var rad := 0.0;
var trad := 0.0;
var x := 0.0;
var y := 0.0;


func execute(_delta):
	var tween := create_tween();
	if(host.active_input == host.InputType.KEYMOUSE):
		y = get_global_mouse_position().y - global_position.y
		x = get_global_mouse_position().x - global_position.x
	elif(host.active_input == host.InputType.GAMEPAD):
		if(abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))>.2 || abs(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X))>.2):
			y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
			x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		if(abs(Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))>.2 || abs(Input.get_joy_axis(0,JOY_AXIS_LEFT_X))>.2):
			y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
			x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	
	trad = atan2(y , x)
	
	if(trad < -PI/2 && rad > PI/2):
		tween.tween_property(
		self, "rad", 
		PI + 0.025, .025)
	elif(rad < -PI/2 && trad > PI/2):
		tween.tween_property(
		self, "rad", 
		-PI - 0.025, .025)
	else:
		tween.tween_property(
		self, "rad", 
		trad, .025)
	
	if(rad > PI):
		rad = -PI + (rad - PI);
		tween.stop()
	elif(rad < -PI):
		rad = PI + (rad + PI);
		tween.stop()
	return rad;
