extends "./Free_Motion_State.gd"

onready var style_states = {
	'wind_dance' : $Wind_Dance,
	'closed_fan' : $Closed_Fan
}
var style_state = 'wind_dance';

var leave = false;
var update = false;
var busy = false;
var hover = false;
var hop = false;
var attack_broken = false;

onready var ComboTimer = get_node("ComboTimer");

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
	
	if(!get_attack_pressed() && (style_states[style_state].save_event || style_states[style_state].attack_end)):
		if(!style_states[style_state].attack_is_saved):
			if(Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("up") || Input.is_action_pressed("down")):
				leave = true;
			else:
				leave = false;
	if(get_attack_just_pressed() || get_attack_pressed() || style_states[style_state].attack_start):
		leave = false;
	if(Input.is_action_just_pressed("jump") && style_states[style_state].hit && !host.on_floor()):
		air.jump = true;
		leave = true;
		attack_broken = true;
	if(Input.is_action_just_pressed("jump") && host.on_floor()):
		ground.jump = true;
		leave = true;
		attack_broken = true;
	if(leave && (style_states[style_state].interrupt || style_states[style_state].attack_end)):
		style_states[style_state].attack_done();
		exit_g_or_a();
	if(leave && attack_broken && (style_states[style_state].dodge_interrupt || !busy)):
		if(!style_states[style_state].interrupt):
			host.get_node("AttackParticles")._on_particleTimer_timeout();
		style_states[style_state].attack_done();
		exit_g_or_a();

func execute(delta):
	if(!host.on_floor() && (host.mspd >= abs(host.hspd)) && style_states[style_state].hit && hover):
		host.hspd += acceleration/4 * host.Direction;
		host.vspd -= acceleration/15;
	elif(!host.on_floor() && !(abs(host.hspd) > host.mspd) && hop):
		var input_direction = get_input_direction();
		update_look_direction_and_scale(input_direction);
		host.hspd += acceleration * host.Direction;
	elif(!host.on_floor() && !(abs(host.hspd) > host.mspd) && style_states[style_state].hit && style_states[style_state].vdir == "_Up"):
		host.vspd -= acceleration/15;
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
			exit(air);

func exit(state):
	leave = false;
	update = false;
	busy = false;
	attack_broken = false;
	style_states[style_state].slottedx = false;
	style_states[style_state].slottedy = false;
	style_states[style_state].animate = false;
	style_states[style_state].combo = "";
	.exit(state);

func _on_ComboTimer_timeout():
	style_states[style_state].combo = "";
	style_states[style_state].chargedx = false;
	style_states[style_state].chargedy = false;
	if(host.move_state == 'attack'):
		exit_g_or_a();