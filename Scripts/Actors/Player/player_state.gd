class_name PlayerState
extends MoveState

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
	return handle_action()

func handle_action():
	if state_machine.move_state != 'action' and state_machine.move_state != 'hit':
		if get_action_just_pressed():
			_exit(state_machine.action_state)
			return true
		elif get_switch_pressed():
			if Input.is_action_just_pressed("Switch_Bash") and host.has_powerup(GlobalEnums.Powerups.METEOR_STYLE):
				switch_bash = true
			elif Input.is_action_just_pressed("Switch_Pierce") and host.has_powerup(GlobalEnums.Powerups.VOLT_STYLE):
				switch_pierce = true
			elif Input.is_action_just_pressed("Switch_Slash") and host.has_powerup(GlobalEnums.Powerups.VORTEX_STYLE):
				switch_slash = true
	return false

func _exit(state):
	super._exit(state)


func exit_ground_or_air():
	match(host.is_on_floor()):
		true:
			_exit(state_machine.move_on_ground_state)
		false:
			_exit(state_machine.move_in_air_state)


func exit_air():
	_exit(state_machine.move_in_air_state)


func exit_ground():
	_exit(state_machine.move_on_ground_state)

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
