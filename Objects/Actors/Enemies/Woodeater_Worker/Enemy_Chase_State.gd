extends "res://Objects/Actors/Enemies/Enemy_State.gd"

func enter():
	host.state = 'chase';
	pass;

func handleAnimation():
	pass;

func handleInput(event):
	#if((host.global_position.x > host.player.global_position.x && host.global_position.x - host.player.global_position.x < host.attack_range) || (host.global_position.x < host.player.global_position.x && host.player.global_position.x - host.global_position.x < host.attack_range)):
	#	host.hspd = 0;
	#	host.velocity.x = 0;
	#	exit('attack');
	if(!host.canSeePlayer()):
		exit('default');
	pass;

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
	host.hspd = host.mspd * host.Direction;
	pass