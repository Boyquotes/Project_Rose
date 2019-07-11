extends "./Free_Motion_State.gd"

var wasnt_wall = false;
var is_wall = false;
onready var ledge_cast = host.get_node("ledge_cast_right");
func enter():
	host.move_state = 'move_in_air';
	pass

func handleAnimation():
	if(host.vspd < 0):
		if(!host.style_states[host.style_state].busy):
			host.animate(host.get_node("TopAnim"),"jump", false);
			#host.animate(host.get_node("BotAnim"),"jump", false);
	else: 
		if(!host.style_states[host.style_state].busy):
			host.animate(host.get_node("TopAnim"),"fall", false);
			#host.animate(host.get_node("BotAnim"),"fall", false);
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
	
	if(host.on_floor()):
		exit(ground)
	pass

func execute(delta):
	.execute(delta);
	pass;

func exit(state):
	wasnt_wall = false;
	is_wall = false;
	.exit(state);
	pass