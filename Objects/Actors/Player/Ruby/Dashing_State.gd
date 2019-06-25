extends "./Free_Motion_State.gd"

var wasnt_wall = false;
var is_wall = false;

func enter():
	host.move_state = 'boost';
	update_look_direction(int(host.mouse_l()) - int(host.mouse_r()));
	pass

func handleAnimation():
	
	pass;

func handleInput():
	
	
	pass;

func execute(delta):
	host.vspd = sin(host.rad) * host.mspd * 2;
	host.hspd = cos(host.rad) * host.mspd * 2;
	
	update_look_direction(sign(host.velocity.x));
	pass;

func exit(state):
	
	.exit(state);
	pass