extends "./Free_Motion_State.gd"

var wasnt_wall = false;
var is_wall = false;
var jumping = false;
var jump_displacement = 0;
var posy = 0;
var base_traversal = 64;
var jump_traversal = base_traversal;

func ready():
	posy = host.position.y;
	pass;

func enter():
	if(host.vspd < 0):
		jumping = true;
	host.state = 'move_in_air';
	pass

func handleAnimation():
	if(host.vspd < 0):
		host.animate("jump", false);
	elif(host.vspd > 0):
		host.animate("fall", false);
	pass;

func handleInput(event):
	if(event.is_action_just_pressed("attack") && host.resource >= attack.base_cost):
		exit('attack');
	elif(event.is_action_just_released("jump")):
		jump_traversal = jump_displacement;
	elif(host.on_floor()):
		exit('move_on_ground');
	elif(event.is_action_pressed("grab")):
		host.get_node("ledge_cast").enabled = true;
		if(!host.get_node("ledge_cast").is_colliding()):
			wasnt_wall = true;
		if(wasnt_wall && host.get_node("ledge_cast").is_colliding()):
			is_wall = true;
		if(host.vspd > 0 && wasnt_wall && is_wall):
			exit('ledge_grab');
	pass

func execute(delta):
	var input_direction = get_input_direction();
	update_look_direction(input_direction);
	if(input_direction != 0):
		host.hspd = host.mspd * host.Direction;
	else:
		host.hspd = 0;
	if(jumping):
		displacey();
	pass;

func exit(state):
	wasnt_wall = false;
	is_wall = false;
	jumping = false;
	jump_displacement = 0;
	posy = host.position.y;
	jump_traversal = base_traversal;
	.exit(state);
	pass

func displacey():
	if(host.position.y < posy):
		jump_displacement += host.position.y - posy;
		posy = host.position.y;
	if(abs(jump_displacement) > jump_traversal):
		jumping = false;
		jump_traversal = base_traversal;
	if(host.vspd > 0):
		jumping = false;
		jump_traversal = base_traversal;
	pass