extends "res://Objects/Actors/Enemies/Enemy_Flying_RandMove_Default_State.gd"

onready var backup = get_parent().get_node("Backup");
onready var attack = get_parent().get_node("Attack");
onready var chase = get_parent().get_node("Chase");
func enter():
	host.state = 'orbit';

func handleAnimation():
	host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	if(!host.canSeePlayer()):
		exit(default);
	elif(!attack.on_cooldown):
		host.hspd = 0;
		host.vspd = 0;
		host.velocity = Vector2(0,0);
		exit(attack);
	elif(global_position.distance_to(host.player.global_position) > host.attack_range && host.actionTimer.time_left <= 0.1):
		exit(chase);
	elif(global_position.distance_to(host.player.global_position) <= host.orbit_threshold && host.actionTimer.time_left <= 0.1):
		exit(backup);

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			turn_around();
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			turn_around();
	if(1 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		angle = rand_range(0,360);
		halt = false;
		go();
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		go();
	
	move();

func go():
	host.actionTimer.wait_time = rand_range(.1, .5);
	if(!halt):
		host.actionTimer.start();
		tspd = rand_range(host.true_mspd/Min_Movement_Denom, host.true_mspd);
	else:
		host.actionTimer.start();
		tspd = 0;

func move():
	if(!halt):
		host.hspd = cos(deg2rad(angle)) * tspd;
		host.vspd = sin(deg2rad(angle)) * tspd;
	else:
		host.hspd = 0;