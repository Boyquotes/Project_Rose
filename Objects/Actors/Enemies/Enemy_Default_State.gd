extends "res://Objects/Actors/Enemies/Enemy_State.gd"

var halt = false;
var tspd = 0;
var jumped = false;
func enter():
	host.state = 'default';

func handleAnimation():
	pass;

func handleInput(event):
	if(host.canSeePlayer()):
		exit(chase);

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
		
		var jump = randi() % 5 + 1
		if(!host.get_node("Casts").get_node("jump_cast_head").is_colliding() && jump > 2 && host.jspd > 0):
			jumped = true;
			host.vspd = -host.jspd;
		else:
			turn_around();

func go():
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		tspd = rand_range(host.true_mspd/10, host.true_mspd);
	else:
		host.actionTimer.wait_time = host.wait+1;
		host.actionTimer.start();
		tspd = 0;

func move():
	if(!halt):
		host.hspd = tspd * host.Direction;
		host.get_node("animator").playback_speed = abs(host.hspd/host.true_mspd);
	else:
		host.hspd = 0;
		host.get_node("animator").playback_speed = 1;

func exit(state):
	halt = false;
	tspd = 0;
	.exit(state)