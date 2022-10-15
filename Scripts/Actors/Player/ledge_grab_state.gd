class_name LedgeGrabState
extends PlayerState

#how fast you stick to the wall
@export var stick_var := 5.0
#how fast you climb up or down towards the ledge
@export var climb_var := 1.0


var grab_animation_done := false
var jump := false
var climb := false
var hstop := false
var going_up := false

var ledge_cast

func _enter():
	host.move_state = 'ledge_grab'
	host.deactivate_grav()
	host.hor_spd = 0
	going_up = true
	update_look_direction_and_scale(move_direction)


func _handle_input():
	move_direction = get_move_direction()
	if !jump and !climb and Input.is_action_pressed("Move_Down"):
		FSM.move_in_air_state.ledge_disable_timer.start(.25)
		FSM.move_in_air_state.ledge_detection_switch()
		_exit(FSM.move_in_air_state)
	elif (!jump and !climb and grab_animation_done
			and ((Input.is_action_pressed("Move_Up")
					and move_direction == host.hor_dir)
				or move_direction == host.hor_dir)
			and $ClimbBox.get_overlapping_bodies().size() == 0):
		climb = true
	elif !climb and Input.is_action_just_pressed("Jump"):
		FSM.move_in_air_state.ledge_disable_timer.start(.2)
		FSM.move_in_air_state.ledge_detection_switch()
		jump = true

func _handle_animation():
	if !grab_animation_done:
		host.animate(host.base_anim, "LedgeGrab", false)
	elif(climb):
		host.animate(host.base_anim, "Climb", false)
	elif(jump):
		host.animate(host.base_anim, "LedgeJump", false)
	super._handle_animation()


func _execute(_delta):
	if jump && grab_animation_done:
		turn(host.hor_dir * -1)
		host.hor_spd = host.true_soft_speed_cap * host.hor_dir
	#Snap to ledge side
	if host.is_on_wall():
		hstop = true
	if !host.test_move(host.transform, Vector2(1 * host.hor_dir,0)) and !hstop:
		host.position.x += stick_var * host.hor_dir
		stick_var -= 1
	else:
		hstop = true
	#Snap to ledge height or fall if it's a bad detect
	if ledge_cast.is_colliding() and not going_up:
		exit_ground_or_air()
	if going_up:
		var gridset_idx = int((int(ledge_cast.global_position.y) + sign(ledge_cast.global_position.y)*12) / 32)
		var gridset_actual = (gridset_idx * 32) - sign(gridset_idx)*25
		host.global_position.y = gridset_actual
		going_up = false



func _exit(state):
	host.get_node("CollisionBox").call_deferred("set_disabled", false)
	host.activate_grav()
	hstop = false
	grab_animation_done = false
	climb = false
	jump = false
	going_up = false
	stick_var = 5
	super._exit(state)


func set_grab_animation_done(flag := true):
	grab_animation_done = flag
