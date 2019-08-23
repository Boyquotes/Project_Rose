extends "res://Objects/Actors/Enemies/Enemy_State.gd"

var jumped = false;

func enter():
	host.state = 'chase';
	pass;

func handleAnimation():
	pass;

func handleInput(event):
	"""
	if(global_position.distance_to(host.player.global_position) <= host.attack_range && attack.on_cooldown):
		host.hspd = 0;
		host.velocity.x = 0;
		exit(attack);"""
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
		if(host.jspd > 0):
			jumped = true;
			host.vspd = -host.jspd;
	host.hspd = host.true_mspd * host.Direction;