extends "./Move_State.gd"

var canTurn = true;

#returns direction based on input
func get_input_direction():
	var input_direction = int(Input.is_action_pressed("Move_Right")) - int(Input.is_action_pressed("Move_Left"));
	return input_direction;

func get_move_direction():
	var input_direction = (
	int(Input.is_action_pressed("Move_Right") || Input.is_action_pressed("Dodge_Move_Right") || host.mouse_r()) - 
	int(Input.is_action_pressed("Move_Left") || Input.is_action_pressed("Dodge_Move_Left") || host.mouse_l()));
	return input_direction;

func get_aim_direction():
	var input_direction = (
	int(Input.is_action_pressed("Aim_Right") || host.mouse_r()) - 
	int(Input.is_action_pressed("Aim_Left") || host.mouse_l()));
	if(input_direction == 0):
		input_direction = (
		int(host.mouse_r()) -
		int(host.mouse_l()));
	return input_direction;

func get_look_direction():
	var input_direction = int(Input.is_action_pressed("Aim_Right") || host.mouse_r()) - int(Input.is_action_pressed("Aim_Left") || host.mouse_l());
	return input_direction;

#sets direction and turns the player appropriately
func update_look_direction_and_scale(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		turn(direction);

func turn(direction):
	if(host.Direction != 0):
		host.get_node("Sprites").scale.x = host.get_node("Sprites").scale.x * -1;
		host.get_node("Movement_States").scale.x = host.get_node("Movement_States").scale.x * -1;
		host.get_node("PhysicsCollider").scale.x = host.get_node("PhysicsCollider").scale.x * -1;
		host.get_node("Hitbox").scale.x = host.get_node("Hitbox").scale.x * -1;
	host.Direction = direction;

func update_look_direction(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		host.Direction = direction;

var true_acceleration = 30;
var base_acceleration = 30

func execute(delta):
	var input_direction = get_input_direction();
	if(canTurn):
		update_look_direction_and_scale(input_direction);
	if(input_direction != 0 && (host.true_mspd >= abs(host.hspd))):
		if(input_direction != sign(host.hspd)):
			true_acceleration = base_acceleration * 1.5;
		else:
			true_acceleration = base_acceleration;
		if(!(host.true_mspd == abs(host.hspd)) || sign(host.hspd) != input_direction):
			host.hspd += true_acceleration * input_direction;
		if(host.true_mspd < abs(host.hspd)):
			host.hspd = host.true_mspd * input_direction;
	elif(host.hspd != 0 && host.fric_activated):
		if(abs(host.hspd) <= host.true_friction):
			host.hspd = 0;
		else:
			host.hspd -= host.true_friction * sign(host.hspd);
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