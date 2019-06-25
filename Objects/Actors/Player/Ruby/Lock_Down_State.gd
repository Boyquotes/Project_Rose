extends "./Free_Motion_State.gd"

onready var cam = host.get_node("Camera2D");
var prev_lim_left;
var prev_lim_right;
var prev_lim_top;
var prev_lim_bottom;
func enter():
	host.move_state = 'lock_down';
	host.remove_child(cam);
	host.get_node("MousePointer").add_child(cam);
	prev_lim_left = cam.limit_left;
	prev_lim_right = cam.limit_right;
	prev_lim_top = cam.limit_top;
	prev_lim_bottom = cam.limit_bottom;
	update_look_direction(int(host.mouse_r()) - int(host.mouse_l()));
	if(host.Direction == 1):
		cam.limit_right = host.get_global_position().x + 1500;
		cam.limit_left = host.get_global_position().x - 100;
	elif(host.Direction == -1):
		cam.limit_left = host.get_global_position().x - 1500;
		cam.limit_right = host.get_global_position().x + 100;
	cam.limit_top = host.get_global_position().y - 1500;
	cam.limit_bottom = host.get_global_position().y + 100;
	if(host.is_on_floor()):
		host.hspd = 0;
	
	pass

func handleAnimation():
	
	pass;

func handleInput():
	if(Input.is_action_just_pressed("jump")):
		host.vspd = -host.jspd;
		exit(host.get_node("Movement_States").get_node("Move_In_Air"));
	
	pass;

func execute(delta):
	if(host.is_on_floor()):
		host.hspd = 0;
	pass;

func exit(state):
	cam.limit_left = prev_lim_left;
	cam.limit_right = prev_lim_right;
	cam.limit_top = prev_lim_top;
	cam.limit_bottom = prev_lim_bottom;
	host.get_node("MousePointer").remove_child(cam);
	host.add_child(cam);
	
	.exit(state);
	pass