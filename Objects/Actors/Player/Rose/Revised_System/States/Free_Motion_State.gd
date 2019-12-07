extends "./Move_State.gd"



func get_move_direction():
	var input_direction = (
	int(Input.is_action_pressed("Move_Right") || Input.is_action_pressed("Dodge_Move_Right") || host.mouse_r()) - 
	int(Input.is_action_pressed("Move_Left") || Input.is_action_pressed("Dodge_Move_Left") || host.mouse_l()));
	return input_direction;

func get_aim_direction():
	var input_direction = (
	int(Input.is_action_pressed("Aim_Right") || Input.is_action_pressed("Move_Right") || Input.is_action_pressed("Dodge_Move_Right") || host.mouse_r()) - 
	int(Input.is_action_pressed("Aim_Left") || Input.is_action_pressed("Move_Left") || Input.is_action_pressed("Dodge_Move_Left") || host.mouse_l()));
	return input_direction;

func get_look_direction():
	var input_direction = int(Input.is_action_pressed("Aim_Right") || host.mouse_r()) - int(Input.is_action_pressed("Aim_Left") || host.mouse_l());
	return input_direction;

#sets direction and turns the player appropriately



func update_look_direction(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		host.Direction = direction;



func execute(delta):
	
		"""
	elif(host.hspd != 0 && abs(host.hspd) > host.true_mspd && host.fric_activated):
		if(input_direction != 0 && sign(host.hspd) != input_direction):
			host.hspd -= true_acceleration * sign(host.hspd);
		else:
			host.hspd -= decceleration/10 * sign(host.hspd);
	"""

func exit_g_or_a():
	match(host.on_floor()):
		true:
			exit(ground)
		false:
			exit(air);