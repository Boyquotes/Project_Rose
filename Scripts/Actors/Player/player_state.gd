class_name PlayerState
extends State

onready var move_on_ground_state := get_parent().get_node("MoveOnGround")
onready var move_in_air_state := get_parent().get_node("MoveInAir")
onready var ledge_grab_state := get_parent().get_node("LedgeGrab")
onready var hit_state := get_parent().get_node("Hit")

onready var powerups := get_parent().get_parent().get_node("Powerups")

var move_direction : int
var can_turn := true
var can_move := true

#returns direction based on input
func get_move_direction():
	var right := int(Input.is_action_pressed("Move_Right"))
	var left := int(Input.is_action_pressed("Move_Left"))
	
	var input_direction := right - left
	return input_direction

#note: this was previously get_move_direction
func get_input_direction():
	var right := int(Input.is_action_pressed("Move_Right")
		or Input.is_action_pressed("Dodge_Move_Right") 
		or host.mouse_r())
	
	var left := int(Input.is_action_pressed("Move_Left")
		or Input.is_action_pressed("Dodge_Move_Left")
		or host.mouse_l())
	
	var input_direction = right - left
	return input_direction


func get_aim_direction():
	var right := int(Input.is_action_pressed("Aim_Right") or host.mouse_r())
	var left := int(Input.is_action_pressed("Aim_Left") or host.mouse_l())
	
	var input_direction := right - left 
	
	if input_direction == 0:
		input_direction = int(host.mouse_r()) - int(host.mouse_l())
	return input_direction

"""
func get_look_direction():
	var right := int(Input.is_action_pressed("Aim_Right") or host.mouse_r()) 
	var left := int(Input.is_action_pressed("Aim_Left") or host.mouse_l())
	
	var input_direction := right - left 
	
	return input_direction
"""

#sets direction and turns the player appropriately
func update_look_direction_and_scale(direction):
	if(direction == 0):
		return
	if(host.hor_dir != direction):
		turn(direction)


func turn(direction):
	if(host.hor_dir != 0):
		host.get_node("Sprites").scale.x = host.get_node("Sprites").scale.x * -1
		host.get_node("MoveStates").scale.x = host.get_node("MoveStates").scale.x * -1
		host.get_node("CollisionBox").scale.x = host.get_node("CollisionBox").scale.x * -1
		host.get_node("HitArea").scale.x = host.get_node("HitArea").scale.x * -1
	host.hor_dir = direction


func update_aim_direction(direction):
	if(direction == 0):
		return
	if(host.hor_dir != direction):
		host.hor_dir = direction

func _handle_input():
	move_direction = get_move_direction()
	if can_turn:
		update_look_direction_and_scale(move_direction)

func _execute(delta):
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

func _exit(state):
	state.can_turn = can_turn
	state.can_move = can_move
	can_turn = true
	can_move = true
	._exit(state)

func exit_ground_or_air():
	match(host.on_floor()):
		true:
			_exit(move_on_ground_state)
		false:
			_exit(move_in_air_state)

func exit_air():
	_exit(move_in_air_state)

func exit_ground():
	_exit(move_on_ground_state)
