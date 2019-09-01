extends "res://Objects/Actors/Enemies/Enemy_Default_State.gd"

onready var chase = get_parent().get_node("Chase");
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

func go():
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		tspd = rand_range(host.true_mspd/Min_Movement_Denom, host.true_mspd);
	else:
		host.actionTimer.wait_time = host.wait+1;
		host.actionTimer.start();
		tspd = 0;

func move():
	if(!halt):
		host.hspd = cos(deg2rad(angle)) * tspd * host.Direction;
		host.vspd = sin(deg2rad(angle)) * tspd;
	else:
		host.hspd = 0;

func exit(state):
	halt = false;
	tspd = 0;
	.exit(state)

func handleInput(event):
	if(host.canSeePlayer()):
		exit(chase);