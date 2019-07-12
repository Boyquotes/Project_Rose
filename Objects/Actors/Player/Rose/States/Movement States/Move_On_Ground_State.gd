extends "./Free_Motion_State.gd"

var jump = false;

func enter():
	host.move_state = 'move_on_ground';
	handleInput();

func handleAnimation():
	if(!host.style_states[host.style_state].busy):
		if(jump):
			host.animate(host.get_node("TopAnim"),"jump", false);
		elif(host.hspd > 0 || host.hspd < 0):
			host.animate(host.get_node("TopAnim"),"run", false);
		else: 
			host.animate(host.get_node("TopAnim"),"idle", false);

func handleInput():
	if(Input.is_action_just_pressed("jump")):
		jump = true;
	elif(!host.on_floor() && !jump):
		exit(host.get_node("Movement_States").get_node("Move_In_Air"));

func execute(delta):
	.execute(delta);
	if(host.Direction != sign(host.velocity.x) && get_input_direction() != 0 ):
		host.hspd -= 10 * sign(host.hspd);

func exit(state):
	jump = false;
	.exit(state);
