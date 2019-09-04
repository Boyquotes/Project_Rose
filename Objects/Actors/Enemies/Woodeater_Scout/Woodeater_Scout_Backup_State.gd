extends "res://Objects/Actors/Enemies/Enemy_State.gd"

onready var orbit = get_parent().get_node("Orbit");

func enter():
	host.state = 'backup';
	pass;

func handleAnimation():
	host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	
	if(global_position.distance_to(host.player.global_position) > host.orbit_threshold):
		host.hspd = 0;
		host.velocity.x = 0;
		exit(orbit);
	if(!host.canSeePlayer()):
		exit(default);

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			turn_around();
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			turn_around();
	host.hspd = cos(global_position.angle_to_point(host.player.global_position)) * host.true_mspd;
	host.vspd = sin(global_position.angle_to_point(host.player.global_position)) * host.true_mspd;