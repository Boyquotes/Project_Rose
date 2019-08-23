extends "res://Objects/Actors/Enemies/Enemy_State.gd"
var base_time = 1;
var true_time = 1;

func enter():
	host.state = 'stun';
	if(true_time != 0):
		$stunTimer.start(true_time);
	pass;

func handleAnimation():
	pass;

func handleInput(event):
	pass;

func execute(delta):
	pass;

func exit(state):
	.exit(state)
	pass;

func _on_stunTimer_timeout():
	true_time = base_time;
	host.activate_grav();
	host.activate_fric();
	exit(default);
