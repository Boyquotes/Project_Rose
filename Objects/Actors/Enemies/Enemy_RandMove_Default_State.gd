extends "res://Objects/Actors/Enemies/Enemy_BackAndForth_Default_State.gd"

func execute(delta):
	if(host.on_floor()):
		jumped = false;
	if(!jumped):
		if(1 <= host.decision && host.decision <= 40 && host.actionTimer.time_left <= 0.1):
			halt = false;
			if(host.Direction != -1):
				turn_around();
			go();
		elif(41 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
			halt = false;
			if(host.Direction != 1):
				turn_around();
			go();
		elif(host.actionTimer.time_left <= 0.1):
			halt = true;
			go();
		
	move();
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("Casts").get_node("jump_cast_feet").is_colliding() && !jumped):
		
		var jump = 3#randi() % 5 + 1
		if(!host.get_node("Casts").get_node("jump_cast_head").is_colliding() && jump > 2 && host.base_jspd > 0):
			jumped = true;
			host.vspd = -host.true_jspd;
		else:
			turn_around();

func go():
	if(!halt):
		host.actionTimer.wait_time = rand_range(.5, 2);
		host.actionTimer.start();
		tspd = rand_range(host.true_mspd/Min_Movement_Denom, host.true_mspd);
	else:
		host.actionTimer.wait_time = rand_range(.5, 2)+1;
		host.actionTimer.start();
		tspd = 0;

func move():
	if(!halt):
		host.hspd = tspd * host.Direction;
	else:
		host.hspd = 0;