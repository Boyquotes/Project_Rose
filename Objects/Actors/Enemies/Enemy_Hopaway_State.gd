extends "res://Objects/Actors/Enemies/Crickey/Enemy_Runaway_State.gd"

func enter():
	host.state = 'runaway';

func handleAnimation():
	if(host.vspd < 0): 
		host.animate(host.get_node("animator"),"jump", false);
	elif(host.vspd > 0): 
		host.animate(host.get_node("animator"),"fall", false);
	else: 
		host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	if(!host.canSeePlayer()):
		exit(default);

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != -1):
			turn_around();
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != 1):
			turn_around();
	if(host.on_floor()):
		if(host.true_jspd > 0):
			host.vspd = -host.true_jspd;
	else:
		jumped = true;
	
	host.hspd = host.true_mspd * host.Direction;