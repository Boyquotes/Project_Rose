extends "./Free_Motion_State.gd"

var wasnt_wall = false;
var is_wall = false;
var land = false;
var up_to_down_proc = true;
var doneUp = false;
var doneDown = false;

onready var ledge_cast = host.get_node("ledge_cast_right");
func enter():
	host.move_state = 'move_in_air';
	pass

func handleAnimation():
	if(host.on_floor() && !land):
		land = true;
		host.animate(host.get_node("TopAnim"),"land", false);
	elif(!host.style_states[host.style_state].busy && !land):
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
		"""
		if(host.vspd < -host.jspd/2):
			up_to_down_proc = true;
		if(host.vspd > -host.jspd/2 && (up_to_down_proc) && abs(host.hspd) > 0):
			host.animate(host.get_node("TopAnim"),"up_to_down_moving", false);
		elif(host.vspd > -host.jspd/2 && (up_to_down_proc) && host.hspd == 0):
			host.animate(host.get_node("TopAnim"),"up_to_down_idle", false);
		
		if(host.hspd > 0 || host.hspd < 0):
			if(host.vspd < 0):
				host.animate(host.get_node("TopAnim"),"air_move_up", false);
			if(host.vspd > 0):
				host.animate(host.get_node("TopAnim"),"air_move_down", false);
		else: 
			host.animate(host.get_node("TopAnim"),"idle_air", false);
		"""
		pass;
	
	pass;

func handleInput():
	if(Input.is_action_just_released("jump")):
		host.vspd += host.jspd/3;
	
	if(host.Direction == 1):
		ledge_cast = host.get_node("ledge_cast_right");
	if(host.Direction == -1):
		ledge_cast = host.get_node("ledge_cast_left");
	
	if(!ledge_cast.is_colliding()):
		wasnt_wall = true;
	if(wasnt_wall && ledge_cast.is_colliding()):
		is_wall = true;
	else:
		is_wall = false;
	#print(String(wasnt_wall) + " " + String(is_wall) + " " + String($Ledgebox.get_overlapping_bodies().size()));
	if(wasnt_wall && is_wall && $Ledgebox.get_overlapping_bodies().size() == 0):
		ledge.ledge_cast = ledge_cast;
		exit(ledge);
	pass

func execute(delta):
	.execute(delta);
	pass;

func exit(state):
	land = false;
	up_to_down_proc = true;
	wasnt_wall = false;
	is_wall = false;
	doneUp = false;
	doneDown = false;
	.exit(state);
	pass

func up_to_down_done():
	print("!!!");
	up_to_down_proc = false;