class_name PlayerState
extends State

@export var can_turn := true

var move_direction : int
var can_move := true

var switch_slash := false
var switch_bash := false
var switch_pierce := false

#returns direction based checked input
func get_move_direction():
	var right := int(Input.is_action_pressed("Move_Right"))
	var left := int(Input.is_action_pressed("Move_Left"))
	var input_direction := right - left
	return input_direction


#note: this was previously get_move_direction
#note: this is broken, host needs a target
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


#func get_look_direction():
#	var right := int(Input.is_action_pressed("Aim_Right") or host.mouse_r()) 
#	var left := int(Input.is_action_pressed("Aim_Left") or host.mouse_l())
#
#	var input_direction := right - left 
#
#	return input_direction

#sets direction and turns the player appropriately
func update_look_direction_and_scale(direction):
	if direction == 0:
		return
	if host.hor_dir != direction:
		turn(direction)


func turn(direction):
	if host.hor_dir != 0:
		host.get_node("Sprites").scale.x = host.get_node("Sprites").scale.x * -1
		host.get_node("MoveStates").scale.x = host.get_node("MoveStates").scale.x * -1
		host.get_node("CollisionBox").scale.x = host.get_node("CollisionBox").scale.x * -1
		host.get_node("HitBoxComponent").scale.x = host.get_node("HitBoxComponent").scale.x * -1
		host.get_node("CrouchHitBoxComponent").scale.x = host.get_node("CrouchHitBoxComponent").scale.x * -1
		host.get_node("Utilities/CapeTarget").scale.x = host.get_node("Utilities/CapeTarget").scale.x * -1
		host.emit_signal("turned")
	host.hor_dir = direction


func update_aim_direction(direction):
	if direction == 0:
		return
	if host.hor_dir != direction:
		host.hor_dir = direction


func _handle_input():
	move_direction = get_move_direction()
	if can_turn:
		update_look_direction_and_scale(move_direction)
	handle_action()

func handle_action():
	if host.move_state != 'action' and host.move_state != 'hit':
		if get_action_just_pressed():
			_exit(FSM.action_state)
		elif get_switch_pressed():
			if Input.is_action_just_pressed("Switch_Bash") and host.has_powerup(GlobalEnums.Powerups.METEOR_STYLE):
				switch_bash = true
			elif Input.is_action_just_pressed("Switch_Pierce") and host.has_powerup(GlobalEnums.Powerups.VOLT_STYLE):
				switch_pierce = true
			elif Input.is_action_just_pressed("Switch_Slash") and host.has_powerup(GlobalEnums.Powerups.VORTEX_STYLE):
				switch_slash = true


func _execute(_delta):
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
	super._exit(state)


func exit_ground_or_air():
	match(host.is_on_floor()):
		true:
			_exit(FSM.move_on_ground_state)
		false:
			_exit(FSM.move_in_air_state)


func exit_air():
	_exit(FSM.move_in_air_state)


func exit_ground():
	_exit(FSM.move_on_ground_state)

func get_switch_pressed():
	return (
		Input.is_action_just_pressed("Switch_Bash") ||
		Input.is_action_just_pressed("Switch_Pierce") ||
		Input.is_action_just_pressed("Switch_Slash")
	)

func get_action_pressed():
	return (
	Input.is_action_pressed("Primary_Attack") || 
	Input.is_action_pressed("Dodge") ||
	Input.is_action_pressed("Use_Item") ||
	Input.is_action_pressed("Secondary_Attack"))

func get_action_just_released():
	return (
	Input.is_action_just_released("Primary_Attack") || 
	Input.is_action_just_released("Dodge") ||
	Input.is_action_just_released("Use_Item") ||
	Input.is_action_just_released("Secondary_Attack"))

func get_action_just_pressed():
	return (
	Input.is_action_just_pressed("Primary_Attack") || 
	Input.is_action_just_pressed("Dodge") ||
	Input.is_action_just_pressed("Use_Item") ||
	Input.is_action_just_pressed("Secondary_Attack"))
