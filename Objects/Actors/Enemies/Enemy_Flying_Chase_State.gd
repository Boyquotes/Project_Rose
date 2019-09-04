extends "res://Objects/Actors/Enemies/Enemy_State.gd"

func enter():
	host.state = 'chase';

func handleInput(event):
	if(!host.canSeePlayer()):
		exit(default);

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			turn_around();
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			turn_around();
	host.hspd = -cos(global_position.angle_to_point(host.player.global_position)) * host.true_mspd;
	host.vspd = -sin(global_position.angle_to_point(host.player.global_position)) * host.true_mspd;