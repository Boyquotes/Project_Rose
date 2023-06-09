class_name MoveState
extends State

@export var can_turn := true

var move_direction : int
var can_move := true

#sets direction and turns the player appropriately
func update_look_direction_and_scale(direction):
	if direction == 0:
		return
	if host.hor_dir != direction:
		turn(direction)

func turn(direction):
	if host.hor_dir != 0:
		host.get_node("Sprites").scale.x = host.get_node("Sprites").scale.x * -1
		host.get_node("FiniteStateMachine").scale.x = host.get_node("FiniteStateMachine").scale.x * -1
		host.get_node("CollisionBox").scale.x = host.get_node("CollisionBox").scale.x * -1
		host.get_node("Hitbox").scale.x = host.get_node("Hitbox").scale.x * -1
		host.emit_signal("turned")
	host.hor_dir = direction

func _execute(_delta):
	if super._execute(_delta):
		return exiting
	if (move_direction != 0
			and host.true_soft_speed_cap >= abs(host.hor_spd)
			and can_move):
		# if you're changing direction, accelerate faster in the other direction for !!game feel!!
		if move_direction != sign(host.hor_spd):
			host.true_acceleration = host.base_acceleration * 1.5
		else:
			host.true_acceleration = host.base_acceleration
		
		if not host.true_soft_speed_cap == abs(host.hor_spd) or sign(host.hor_spd) != move_direction:
			host.hor_spd += host.true_acceleration * move_direction
		if host.true_soft_speed_cap < abs(host.hor_spd):
			host.hor_spd = host.true_soft_speed_cap * move_direction
	# deccelerate after some special movement
	elif host.hor_spd != 0 and host.fric_activated:
		if abs(host.hor_spd) <= host.true_fric:
			host.hor_spd = 0
		else:
			host.hor_spd -= host.true_fric * sign(host.hor_spd)
	return exiting
