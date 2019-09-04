extends "res://Objects/Actors/Enemies/Enemy_RandMove_Default_State.gd"

var angle = 0;

func handleAnimation():
	host.animate(host.get_node("animator"),"idle", false);

func execute(delta):
	if(1 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		angle = rand_range(-90.0,90.0);
		if(angle >= 270.0 || angle <= 90.0):
			if(host.Direction != 1):
				turn_around();
		else:
			if(host.Direction != -1):
				turn_around();
		halt = false;
		go();
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		go();
	
	move();
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("Casts").get_node("jump_cast_feet").is_colliding() && !jumped):
		
		var jump = randi() % 5 + 1
		if(!host.get_node("Casts").get_node("jump_cast_head").is_colliding() && jump > 2 && host.base_jspd > 0):
			jumped = true;
			host.vspd = -host.true_jspd;
		else:
			turn_around();

func move():
	if(!halt):
		host.hspd = cos(deg2rad(angle)) * tspd * host.Direction;
		host.vspd = sin(deg2rad(angle)) * tspd;
	else:
		host.hspd = 0;
