extends "res://Objects/Actors/Enemies/Enemy_State.gd"

var jumped = false;

func enter():
	host.state = 'chase';
	pass;

func handleAnimation():
	host.animate(host.get_node("animator"),"move", false);

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
	if(host.on_floor()):
		jumped = false;
	else:
		jumped = true;
	if((host.get_node("Casts").get_node("jump_cast_feet").is_colliding() || host.player.global_position.y+50 < host.global_position.y) && !jumped):
		if(host.true_jspd > 0):
			jumped = true;
			host.vspd = -host.true_jspd;
	host.hspd = host.true_mspd * host.Direction;