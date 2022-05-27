class_name ActionState
extends PlayerState

# Review these variables
export(bool) var use_default_movement := true
var hover = false
var jump_is_reset = false

var exit_state_flag = false
var action_committed = false
var action_interrupted = false


onready var action_controller = $ActionController
onready var action_instancer = $ActionController/ActionInstancer
onready var combo_timer = $ComboTimer


### Initialize Action State ###
func _ready():
	use_default_movement = true


func _enter():
	host.move_state = 'action'
	action_controller._enter()


func _handle_input():
	action_controller._handle_input()
	### for leaving the action state early ###
	if (!get_action_pressed()
			and (action_controller.move_can_interrupt
				or action_controller.action_ended)):
		if !action_controller.action_is_saved:
			if(Input.is_action_pressed("Move_Left")
					or Input.is_action_pressed("Move_Right")
					or Input.is_action_pressed("Move_Up")
					or Input.is_action_pressed("Move_Down")):
				exit_state_flag = true
			else:
				exit_state_flag = false
	
	if (get_action_just_pressed() or get_action_pressed()
			or action_controller.action_can_start):
		exit_state_flag = false
	
	if action_controller.dodge_can_interrupt or !action_committed:
		if (Input.is_action_just_pressed("Jump") and jump_is_reset
				and !host.on_floor()):
			FSM.move_in_air_state.jump = true
			exit_state_flag = true
			action_interrupted = true
		if Input.is_action_just_pressed("Jump") and host.is_on_floor():
			FSM.move_on_ground_state.jump = true
			exit_state_flag = true
			action_interrupted = true
	
	if (exit_state_flag and (action_controller.move_can_interrupt
			or action_controller.action_ended)):
		action_controller.clear_action()
		if(host.move_state == "action"):
			exit_ground_or_air()
	if exit_state_flag and action_interrupted:
		action_controller.clear_action()
		exit_ground_or_air()
	._handle_input()


func _handle_animation():
	action_controller._handle_animation()


func _execute(delta):
	### Determining player movement from actions ###
	if use_default_movement:
		._execute(delta)
	else:
		#handles when we use special movement
		pass
	action_controller._execute(delta)


func _exit(state):
	if state == FSM.hit_state:
		action_instancer.clear_cancelable_actions()
	use_default_movement = true
	exit_state_flag = false
	action_committed = false
	jump_is_reset = false
	action_interrupted = false
	action_controller.clear_action()
	action_controller.clear_save_vars()
	action_controller.clear_slotted_vars()
	action_controller.animate = false
	action_controller.clear_action_stack()
	._exit(state)

func _on_ComboTimer_timeout():
	action_controller.combo = ""
	if(host.move_state == 'action'):
		exit_ground_or_air()
