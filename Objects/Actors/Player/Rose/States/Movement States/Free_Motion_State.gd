extends "./Move_State.gd"

#returns direction based on input
func get_input_direction():
	var input_direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"));
	return input_direction;

#sets direction and turns the player appropriately
func update_look_direction(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		if(host.Direction != 0):
			host.get_node("Sprites").scale.x = host.get_node("Sprites").scale.x * -1;
			host.get_node("Movement_States").scale.x = host.get_node("Movement_States").scale.x * -1;
		host.Direction = direction;

func execute(delta):
	var input_direction = get_input_direction();
	update_look_direction(input_direction);
	if(input_direction != 0 && !(abs(host.hspd) > host.mspd) && !host.style_states[host.style_state].busy):
		host.hspd += host.mspd/10 * host.Direction;
	elif(host.hspd != 0 && abs(host.hspd) > host.mspd):
		host.hspd -= 5 * sign(host.hspd);
	else:
		host.hspd = 0;