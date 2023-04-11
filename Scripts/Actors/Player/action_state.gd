class_name ActionState
extends PlayerState

signal debug_exit

# Review these variables
@export var use_default_movement := true
var hover = false

var exit_state_normally_flag := false
var action_committed := false
var action_interrupted := false


@onready var action_controller = $ActionController
@onready var action_instancer = $ActionController/ActionInstancer
@onready var combo_timer = $ComboTimer


### Initialize Action State ###
func _ready():
	use_default_movement = true


func _enter():
	host.move_state = 'action'
	action_controller._enter()


func _handle_input():
	super._handle_input()
	action_controller._handle_input()
	# if the player is using a movement input, try to leave the action state
	if(Input.is_action_pressed("Move_Left")
			or Input.is_action_pressed("Move_Right")
			or Input.is_action_pressed("Move_Down")):
		exit_state_normally_flag = true
	
	# if the player intends to commit an action, override the move
	if (get_action_just_pressed() or get_action_just_released()
			or action_committed
			or action_controller.action_is_saved):
		exit_state_normally_flag = false
	
	# if the player tries to jump, override the action
	if Input.is_action_just_pressed("Jump"):
		if host.is_on_floor():
			FSM.move_on_ground_state.jump = true
			exit_state_normally_flag = true
		elif FSM.move_in_air_state.jump_charge > 0:
			FSM.move_in_air_state.jump_charge -= 1
			FSM.move_in_air_state.jump = true
			exit_state_normally_flag = true
	
	# if the player is dodging but is not committing to a new action or holding
		# the dodge button, end the action early
	if (action_controller.action_str == "Action_Dodge"
			and action_controller.action_stack[1] == "saved_action"
			and !Input.is_action_pressed("Dodge")):
		exit_state_normally_flag = true
	
	if (exit_state_normally_flag
			and (action_controller.action_ended or action_controller.action_can_interrupt)):
		if(host.move_state == "action"):
			exit_ground_or_air()
	


func _handle_animation():
	action_controller._handle_animation()


func _execute(delta):
	### Determining player movement from actions ###
	if use_default_movement:
		super._execute(delta)
	else:
		no_movement_input(delta)
	action_controller._execute(delta)

func no_movement_input(_delta):
	# deccelerate after some special movement
	if host.hor_spd != 0 and host.fric_activated:
		if abs(host.hor_spd) <= host.true_fric:
			host.hor_spd = 0
		else:
			host.hor_spd -= host.true_fric * sign(host.hor_spd)

func _exit(state):
	if state == FSM.hit_state:
		action_instancer.clear_cancelable_actions()
	use_default_movement = true
	exit_state_normally_flag = false
	action_committed = false
	action_interrupted = false
	action_controller.clear_action()
	action_controller.clear_save_vars()
	action_controller.clear_slotted_vars()
	action_controller.animate = false
	action_controller.clear_action_stack()
	can_turn = true
	super._exit(state)

func _on_ComboTimer_timeout():
	#action_controller.combo = ""
	#if(host.move_state == 'action'):
	#	exit_ground_or_air()
	pass


func _on_action_debug_exit():
	exit_ground_or_air()


func _on_rose_landed():
	if host.move_state == "action":
		#exit_ground()
		host.change_to_grounded_anim(host.base_anim, action_instancer.last_queued_action)
