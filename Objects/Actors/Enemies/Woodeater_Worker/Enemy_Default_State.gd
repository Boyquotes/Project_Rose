extends "res://Objects/Actors/Enemies/Enemy_State.gd"

var halt = false;
var tspd = 0;

func enter():
	host.state = 'default';
	pass;

func handleAnimation():
	
	pass;

func handleInput(event):
	if(host.canSeePlayer()):
		exit('chase');
	pass;

func execute(delta):
	if(1 <= host.decision && host.decision <= 40 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
		go();
	elif(41 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
		go();
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		go();
	
	move();
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("jump_cast_feet").is_colliding()):
		host.Direction = host.Direction * -1;
		host.scale.x = host.scale.x * -1;
		"""
		var jump = randi() % 2 + 1
		if(host.fspd >=0):
			if(!host.get_node("jump_cast_head").is_colliding() && jump == 1 && host.jspd > 0):
				host.vspd = -host.jspd;
			else:
		"""
	pass

func go():
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		tspd = rand_range(20, host.mspd*2);
	else:
		host.actionTimer.wait_time = host.wait+1;
		host.actionTimer.start();
		tspd = 0;
	pass

func move():
	if(!halt):
		host.hspd = tspd * host.Direction;
		host.get_node("animator").playback_speed = abs(host.hspd/host.mspd);
	else:
		host.hspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass

func exit(state):
	halt = false;
	tspd = 0;
	.exit(state)
	pass;