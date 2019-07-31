extends "./Move_State.gd"

#returns direction based on input
func get_input_direction():
	var input_direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"));
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
		host.get_node("AttackParticles").scale.x = host.get_node("AttackParticles").scale.x * -1;
	host.Direction = direction;

func update_look_direction(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		host.Direction = direction;

var acceleration = 30;
var decceleration = 50;

func execute(delta):
	var input_direction = get_input_direction();
	update_look_direction_and_scale(input_direction);
	if(input_direction != 0 && (host.mspd >= abs(host.hspd))):
		if(host.Direction != sign(host.hspd)):
			acceleration = 50;
		else:
			acceleration = 30;
		if(!(host.mspd == abs(host.hspd)) || sign(host.hspd) != host.Direction):
			host.hspd += acceleration * host.Direction;
		if(host.mspd < abs(host.hspd)):
			host.hspd = host.mspd * host.Direction;
	elif(host.hspd != 0 && abs(host.hspd) > host.mspd && host.fric_activated):
		if(input_direction != 0 && sign(host.hspd) != input_direction):
			host.hspd -= acceleration * sign(host.hspd);
		else:
			host.hspd -= decceleration/10 * sign(host.hspd);
	elif(host.hspd != 0 && host.fric_activated):
		if(abs(host.hspd) <= decceleration):
			host.hspd = 0;
		else:
			host.hspd -= decceleration * sign(host.hspd);
	