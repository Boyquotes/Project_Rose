extends "./Move_State.gd"

#returns direction based on input
func get_input_direction():
	var input_direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"));
	return input_direction;

func get_aim_direction():
	var input_direction = int(Input.is_action_pressed("right") || Input.is_action_pressed("rright") || host.mouse_r()) - int(Input.is_action_pressed("left") || Input.is_action_pressed("rleft") || host.mouse_l());
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
	update_look_direction_and_scale(input_direction);
	if(input_direction != 0 && (host.true_mspd >= abs(host.hspd))):
		if(host.Direction != sign(host.hspd)):
			true_acceleration = base_acceleration * 1.5;
		else:
			true_acceleration = base_acceleration;
		if(!(host.true_mspd == abs(host.hspd)) || sign(host.hspd) != host.Direction):
			host.hspd += true_acceleration * host.Direction;
		if(host.true_mspd < abs(host.hspd)):
			host.hspd = host.true_mspd * host.Direction;
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