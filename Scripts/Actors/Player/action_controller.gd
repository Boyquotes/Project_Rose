class_name ActionController
extends Node2D

### debug_vars ###
@export var debug_input := true

@export var action_can_interrupt := false
@export var action_charges_jump := false

var enter_primary := false
var enter_item := false
var enter_dodge := false
var enter_secondary := false

var slotted_primary := false
var slotted_item := false
var slotted_dodge := false
var slotted_secondary := false

var crouched := false

var on_cooldown := false
var hit := false

var action_ended := false
var action_is_saved := false
var action_triggered := false
var save_action := false

var animate := false

### modifiable inits ###
var air_counter := 1
var cool := 1

var action_degrees := 0.0
var host
var action_state

### action codes ###
var action_prefix := "Action"
var action_stack := ["current_action", "saved_action"]
var combo := ""
var action_str := "action_str"
var previous_action := "previous_action"
var attack_counter := 1

func _ready():
	action_can_interrupt = false
	action_charges_jump = false

func init():
	action_state = get_parent()
	host = action_state.host
	host.call_init_in_children(host, self)


func _enter():
	if Input.is_action_just_pressed("Primary_Attack"):
		enter_primary = true
	elif Input.is_action_just_pressed("Dodge"):
		enter_dodge = true
	elif Input.is_action_just_pressed("Use_Item"):
		enter_item = true
	elif Input.is_action_just_pressed("Secondary_Attack"):
		enter_secondary = true

### Prepares next move if user input is detected ###
func _handle_input():
	if action_can_interrupt && action_is_saved:
		save_action = false
		action_is_saved = false
		clear_action()
		previous_action = action_str
		action_stack[0] = action_stack[1]
		combo = action_stack[0]
		action_stack[1] = "saved_action"
		commit_action()
	if !action_state.action_committed:
		if parse_action(0):
			combo = action_stack[0]
			commit_action()
	if save_action:
		if parse_action(1):
			action_is_saved = true
			


### Handles animation, incomplete ###
func _handle_animation():
	if !debug_input:
		if action_state.action_committed && animate :
			host.animate(host.base_anim, action_str, false)
			animate = false


func _execute(_delta):
	pass

### begins parsing player action if an action is triggered ###
func parse_action(idx):
	clear_slotted_vars()
	if primary_pressed():
		slotted_primary = true
	elif item_pressed():
		slotted_item = true
	elif secondary_pressed():
		slotted_secondary = true
	elif dodge_pressed():
		if idx == 0 && host.is_on_floor() || idx == 1:
			slotted_dodge = true
	
	clear_enter_vars()
	
	if slotted_primary:
		return record_action(idx, "Primary")
	if slotted_item:
		return record_action(idx, "Item")
	if slotted_secondary:
		return record_action(idx, "Secondary")
	if slotted_dodge:
		return record_action(idx, "Dodge")
	
	return false

func record_action(idx, atk):
	action_stack[idx] = atk
	return true

func primary_pressed():
	return enter_primary || Input.is_action_just_pressed("Primary_Attack")

func dodge_pressed():
	return enter_dodge || Input.is_action_just_pressed("Dodge")

func item_pressed():
	return enter_item || Input.is_action_just_pressed("Use_Item")

func secondary_pressed():
	return enter_secondary || Input.is_action_just_pressed("Secondary_Attack")


### Triggers appropriate action based checked the strings constructed by player input ###
func commit_action():
	construct_action_string()
	if action_str == previous_action:
		attack_counter += 1
		action_str += str(attack_counter)
	else:
		attack_counter = 1
	if debug_input or not host.base_anim.has_animation(action_str):
		print(action_str)
		clear_action()
		action_state.emit_signal("debug_exit")
		return
	var input_direction = get_parent().get_aim_direction()
	if input_direction == 0:
		input_direction = get_parent().get_move_direction()
	action_degrees = host.deg
	action_state.can_turn = true
	get_parent().update_look_direction_and_scale(input_direction)
	action_state.can_turn = false
	clear_slotted_vars()
	clear_enter_vars()
	action_ended = false
	action_state.action_committed = true
	action_is_saved = false
	animate = true
	action_state.combo_timer.stop()
	save_action = true

### Constructs the string used to look up action hitboxes and animations ###
func construct_action_string():
	action_str = action_prefix + "_" + combo
	if combo in ["Primary", "Secondary"]:
		action_str += "_" + host.style_states[host.style_state]
		action_str += attack_direction()
		if crouched:
			action_str += "_Crouched"
		if not host.is_on_floor():
			action_str += "_Air"
		if Input.is_action_pressed("Focus"):
			action_str += "_Focused"
		if Input.is_action_pressed("Channel"):
			action_str += "_Channeled"
	else:
		action_str += attack_direction()

func attack_direction():
	var dir = ""
	var hor = ""
	var vert = ""
	if (abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X)) > .4
			or abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)) > .4):
		hor = "Hor"
	if (Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) > .4
			or Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) > .4):
		vert = "Down"
	if (Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) < -.4
			or Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) < -.4):
		vert = "Up"
	if vert:
		dir += vert
		if hor:
			dir = hor + dir
	if dir:
		dir = "_" + dir
	return dir

func clear_action():
	host.i_frame(0)
	if(!action_is_saved):
		clear_slotted_vars()
	hit = false
	clear_enter_vars()
	action_ended = false
	action_state.action_committed = false
	action_triggered = false
	save_action = false
	action_can_interrupt = false
	action_state.hover = false
	action_state.use_default_movement = true
	action_state.can_turn = true
	host.normalize_grav()
	host.activate_grav()
	host.activate_fric()
	crouched = false
	action_charges_jump = false
	action_state.combo_timer.start()

func clear_action_stack():
	action_stack = ["current_action", "saved_action"]
	combo = ""
	action_str = "action_str"
	previous_action = "previous_action"
	attack_counter = 1

func clear_enter_vars():
	enter_primary = false
	enter_dodge = false
	enter_item = false
	enter_secondary = false

func clear_slotted_vars():
	slotted_primary = false
	slotted_item = false
	slotted_secondary = false
	slotted_dodge = false


func clear_save_vars():
	action_is_saved = false
	save_action = false


func on_hit(col):
	if "hittable" in col:
		if col.hittable:
			host.get_node("Camera2D").shake(.1, 15, 8)
			if !host.on_floor() && action_charges_jump:
				action_state.FSM.move_in_air_state.jump_charge += 1
