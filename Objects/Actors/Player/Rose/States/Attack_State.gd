extends "./Free_Motion_State.gd"

onready var style_states = {
	'wind_dance' : $Wind_Dance,
	'closed_fan' : $Closed_Fan
}
var style_state = 'wind_dance';

var leave = false;
var update = false;
var exit_early = false;

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
	#if(!get_attack_pressed() && exit_early):
	#	style_states[style_state].attack_done();
	#	exit(ground);
	var input_direction = get_input_direction();
	if(style_states[style_state].save_event || style_states[style_state].event_is_saved || style_states[style_state].interrupt):
		update = true;
	else:
		update = false;
	if((style_states[style_state].event_is_saved || style_states[style_state].interrupt) && update):
		update_look_direction_and_scale(input_direction);
	
	style_states[style_state].handleInput();
	
	if(!get_attack_pressed() && (style_states[style_state].save_event || style_states[style_state].attack_end)):
		if(!style_states[style_state].attack_is_saved):
			if(Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("up") || Input.is_action_pressed("down")):
				leave = true;
			elif(Input.is_action_just_pressed("jump")):
				ground.jump = true;
				leave = true;
	if(leave && (style_states[style_state].interrupt || style_states[style_state].attack_end)):
		style_states[style_state].attack_done();
		exit_g_or_a();

func execute(delta):
	if(style_states[style_state].busy):
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
			exit(air);

func exit(state):
	leave = false;
	update = false;
	exit_early = false;
	.exit(state);