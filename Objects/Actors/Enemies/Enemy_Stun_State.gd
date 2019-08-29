extends "res://Objects/Actors/Enemies/Enemy_State.gd"
var base_time = 1;
var true_time = 1;
var stunned = false;

func enter():
	host.state = 'stun';
	stunned = true;
	if(true_time != 0):
		$stunTimer.start(true_time);

func handleAnimation():
	pass;

func handleInput(event):
	pass;

func execute(delta):
	if(abs(host.hspd) > 0):
		if(abs(host.hspd) < 2):
			host.hspd = 0;
		host.hspd -= 2 * sign(host.hspd);
	if(abs(host.vspd) > 0):
		if(abs(host.vspd) < 3):
			host.vspd = 0;
		host.vspd -= 3 * sign(host.vspd);

func exit(state):
	if(stunned):
		continue_stun();
	.exit(state)
	pass;

func continue_stun():
	stunned = false;

func _on_stunTimer_timeout():
	stunned = false;
	true_time = base_time;
	host.activate_grav();
	host.activate_fric();
	exit(default);
