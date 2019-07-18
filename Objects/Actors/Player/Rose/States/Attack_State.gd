extends "./Free_Motion_State.gd"

onready var style_states = {
	'wind_dance' : $Wind_Dance,
	'closed_fan' : $Closed_Fan
}
var style_state = 'wind_dance';

var leave = false;
var update = false;

func _ready():
	$Wind_Dance.host = host;
	$Closed_Fan.host = host;

func enter():
	host.move_state = 'attack';
	style_states[style_state].enter();
	if(Input.is_action_just_pressed("attack")):
		style_states[style_state].X = true;
	elif(Input.is_action_just_pressed("dodge")):
		style_states[style_state].B = true;
	elif(Input.is_action_just_pressed("special")):
		style_states[style_state].Y = true;

func handleAnimation():
	style_states[style_state].handleAnimation();

func handleInput():
	var input_direction = get_input_direction();
	if(style_states[style_state].save_event || style_states[style_state].event_is_saved || style_states[style_state].interrupt):
		update = true;
	else:
		update = false;
	if((style_states[style_state].event_is_saved || style_states[style_state].interrupt) && update):
		update_look_direction_and_scale(input_direction);
	
	style_states[style_state].handleInput();
	
	if(Input.is_action_just_pressed("jump") && style_states[style_state].hit && !host.on_floor()):
		
		air.jump = true;
		leave = true;
	elif(!get_attack_pressed() && (style_states[style_state].save_event || style_states[style_state].attack_end)):
		if(!style_states[style_state].attack_is_saved):
			if(Input.is_action_just_pressed("jump") && host.on_floor()):
				ground.jump = true;
				leave = true;
			elif(Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down")):
				leave = true;
	
	if(leave && (style_states[style_state].interrupt || style_states[style_state].attack_end)):
		style_states[style_state].attack_done();
		exit_g_or_a();

func execute(delta):
	if(!host.on_floor() && !(abs(host.hspd) > host.mspd/2) && style_states[style_state].hit && style_states[style_state].dir == "_Hor"):
		host.hspd += host.mspd/10 * host.Direction;
	elif(!host.on_floor() && !(abs(host.hspd) > host.mspd) && style_states[style_state].hit && style_states[style_state].vdir == "_Down"):
		host.hspd += host.mspd/10 * host.Direction;
	else:
		if(host.hspd != 0 && abs(host.hspd) > host.mspd && host.fric_activated):
			host.hspd -= 20 * sign(host.hspd);
		elif(host.fric_activated):
			host.hspd = 0;
	
	style_states[style_state].execute(delta);

func exit_g_or_a():
	match(host.on_floor()):
		true:
			exit(ground)
		false:
			print("$$$");
			exit(air);

func exit(state):
	leave = false;
	update = false;
	style_states[style_state].animate = false;
	host.activate_grav();
	host.activate_fric();
	.exit(state);