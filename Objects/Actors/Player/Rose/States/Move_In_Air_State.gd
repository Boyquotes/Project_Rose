extends "./Free_Motion_State.gd"

var jumped = false;
var wasnt_wall_R = false;
var is_wall_R = false;
var wasnt_wall_L = false;
var is_wall_L = false;
var land = false;
var up_to_down_proc = true;
var doneUp = false;
var doneDown = false;
var jump = false;
var cutoff = false;

onready var ledge_cast_R = host.get_node("ledge_cast_right");
onready var ledge_cast_L = host.get_node("ledge_cast_left");
onready var Ledgebox_R = host.get_node("Ledgebox_R");
onready var Ledgebox_L = host.get_node("Ledgebox_L");

func enter():
	host.move_state = 'move_in_air';

func handleAnimation():
	if(jump):
		#TODO: special hit-jump
		host.animate(host.get_node("TopAnim"),"airjump", false);
	elif(host.on_floor() && !land):
		land = true;
		host.animate(host.get_node("TopAnim"),"land", false);
	elif(!land):
		if(host.vspd > -300 && host.vspd < host.g_max/2):
			if(abs(host.hspd) > 0):
				host.animate(host.get_node("TopAnim"),"up_to_down_moving", false);
			else:
				host.animate(host.get_node("TopAnim"),"up_to_down_idle", false);
		elif((!doneUp || !doneDown) && abs(host.hspd) > 0):
			if(host.vspd < 0 && !doneUp):
				host.animate(host.get_node("TopAnim"),"air_move_up", false);
				doneUp = true;
				doneDown = false;
			if(host.vspd > 0 && !doneDown):
				host.animate(host.get_node("TopAnim"),"air_move_down", false);
				doneDown = true;
				doneUp = false;
		elif(host.hspd == 0):
			host.animate(host.get_node("TopAnim"),"air_idle", false);
			doneUp = false;
			doneDown = false;

func handleInput():
	if(get_attack_just_pressed()):
		exit(attack);
		return;
	if(jumped && !Input.is_action_pressed("jump") && !cutoff):
		cutoff = true;
		host.vspd += host.jspd/2;
	
	if(!ledge_cast_R.is_colliding()):
		wasnt_wall_R = true;
	if(wasnt_wall_R && ledge_cast_R.is_colliding()):
		is_wall_R = true;
	else:
		is_wall_R = false;
	if(wasnt_wall_R && is_wall_R && Ledgebox_R.get_overlapping_bodies().size() == 0):
		ledge.ledge_cast = ledge_cast_R;
		ledge.dir = 1;
		exit(ledge);
		return;
	
	if(!ledge_cast_L.is_colliding()):
		wasnt_wall_L = true;
	if(wasnt_wall_L && ledge_cast_L.is_colliding()):
		is_wall_L = true;
	else:
		is_wall_L = false;
	#print(String(wasnt_wall_L) + " " + String(is_wall_L) + " " + String(Ledgebox_L.get_overlapping_bodies().size()));
	if(wasnt_wall_L && is_wall_L && Ledgebox_L.get_overlapping_bodies().size() == 0):
		ledge.ledge_cast = ledge_cast_L;
		ledge.dir = -1;
		exit(ledge);
		return;

func execute(delta):
	.execute(delta);

func exit(state):
	land = false;
	up_to_down_proc = true;
	wasnt_wall_R = false;
	is_wall_R = false;
	wasnt_wall_L = false;
	is_wall_L = false;
	doneUp = false;
	doneDown = false;
	jumped = false;
	cutoff = false;
	.exit(state);
	pass

func up_to_down_done():
	up_to_down_proc = false;

func _on_Land_Timer_timeout():
	if(host.move_state == 'move_in_air'):
		exit(ground);


func _on_Jump_Timer_timeout():
	jump = false;
