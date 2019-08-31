extends "res://Objects/Actors/Enemies/Enemy_Default_State.gd"

func enter():
	host.state = 'default';

func handleAnimation():
	if(host.hspd == 0):
		host.animate(host.get_node("animator"),"idle", false);
	else:
		host.animate(host.get_node("animator"),"move", false);

func execute(delta):
	host.hspd = host.true_mspd * host.Direction;
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("Casts").get_node("jump_cast_feet").is_colliding() && !jumped):
		
		var jump = randi() % 5 + 1
		if(!host.get_node("Casts").get_node("jump_cast_head").is_colliding() && jump > 2 && host.jspd > 0):
			jumped = true;
			host.vspd = -host.jspd;
		else:
			turn_around();

func exit(state):
	halt = false;
	tspd = 0;
	.exit(state)