class_name ActionController
extends Node2D

### debug_vars ###
export(bool) var debug_input := true


var enter_primary := false
var enter_item := false
var enter_dodge := false
var enter_secondary := false

var slotted_primary := false
var slotted_item := false
var slotted_dodge := false
var slotted_secondary := false

var on_cooldown := false
var hit := false
var action_can_start := false
var action_ended := false
var action_is_saved := false
var action_triggered := false

var save_action := false
var dodge_can_interrupt := false
var move_can_interrupt := false
var action_can_interrupt := false
var action_resets_jump := false

var animate := false
var exit_dodge_early := false

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
	if exit_dodge_early and action_stack[1] == "saved_action":
		if !Input.is_action_pressed("Dodge"):
			clear_action()
			action_state.exit_ground_or_air()
	if (dodge_can_interrupt || move_can_interrupt || action_can_interrupt) && action_is_saved: #TODO: Revisit follow_up
		action_is_saved = false
		clear_action()
		previous_action = action_stack[0]
		action_stack[0] = action_stack[1]
		combo = action_stack[1] #to make a proper combo, use += instead
		action_stack[1] = "saved_action"
		commit_action()
	if !action_state.action_committed:
		if parse_action(0):
			combo = action_stack[0]
			commit_action()
	if save_action:
		if parse_action(1):
			action_is_saved = true
			save_action = false


### Handles animation, incomplete ###
func _handle_animation():
	if !debug_input:
		if action_state.action_committed && animate :
			host.animate(host.base_anim, action_str, true)
			animate = false


func _execute(_delta):
	pass

### begins parsing player action if an action is triggered ###
func parse_action(idx):
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
	
	if Input.is_action_just_released("Primary_Attack") && slotted_primary:
		return record_action(idx, "Primary")
	if Input.is_action_just_released("Use_Item") && slotted_item:
		return record_action(idx, "Item")
	if Input.is_action_just_released("Secondary_Attack") && slotted_secondary:
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

### Resets action strings ###
func reset_strings():
	action_stack[0] = "current_action"
	action_stack[1] = "saved_action"
	action_str = "action_str"

### Triggers appropriate action based on the strings constructed by player input ###
func commit_action():
	construct_action_string()
	var input_direction = get_parent().get_aim_direction()
	action_degrees = host.deg
	action_state.can_turn = true
	get_parent().update_look_direction_and_scale(input_direction)
	action_state.can_turn = false
	clear_slotted_vars()
	clear_enter_vars()
	action_ended = false
	action_state.action_committed = true
	action_is_saved = false
	action_can_start = true
	if(debug_input):
		print(action_str)
		clear_action()
	else:
		animate = true
		action_state.combo_timer.stop()

### Constructs the string used to look up action hitboxes and animations ###
func construct_action_string():
	action_str = action_prefix + "_" + combo
	if combo in ["Primary", "Secondary"]:
		action_str += "_" + host.style_states[host.style_state]
		if Input.is_action_pressed("Focus"):
			action_str += "_" + "Focused"
		if Input.is_action_pressed("Channel"):
			action_str += "_" + "Channeled"

func clear_action():
	host.i_frame(0)
	if(!action_is_saved):
		clear_slotted_vars()
	hit = false
	clear_enter_vars()
	action_ended = true
	action_state.action_committed = false
	action_triggered = false
	save_action = false
	move_can_interrupt = false
	action_can_interrupt = false
	dodge_can_interrupt = false
	reset_strings()
	action_state.hover = false
	action_state.use_default_movement = true
	action_state.can_turn = true
	exit_dodge_early = false
	host.normalize_grav()
	host.activate_grav()
	host.activate_fric()
	action_resets_jump = false
	action_state.combo_timer.start()

func clear_action_stack():
	action_stack = ["current_action", "saved_action"]
	combo = ""
	action_str = "action_str"
	previous_action = "previous_action"

func set_save_commit_action():
	save_action = true
	action_state.can_turn = false


func set_dodge_can_interrupt():
	dodge_can_interrupt = true

func set_exit_dodge_early():
	exit_dodge_early = true


func set_move_interrupt():
	move_can_interrupt = true

func set_action_interrupt():
	action_can_interrupt = true

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
			if !host.on_floor() && action_resets_jump:
				action_state.jump_is_reset = true;


func _on_BaseAnimator_animation_finished(_anim_name):
	if host.move_state == "action":
		if !action_is_saved:
			action_state.exit_ground_or_air()
		host.activate_fric()

