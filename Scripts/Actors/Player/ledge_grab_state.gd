class_name LedgeGrabState
extends PlayerState

var grab_animation_done := false
var jump := false
var climb := false
var hstop := false
var going_up := true

var ledge_cast : RayCast2D

func init():
	super.init()
	can_turn = false
	can_move = false

func _enter():
	super._enter()
	host.move_state = 'ledge_grab'
	host.deactivate_grav()
	host.hor_spd = 0
	update_look_direction_and_scale(move_direction)


func _handle_input():
	if super._handle_input():
		return
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
	if super._handle_animation():
		return
	if !grab_animation_done:
		host.animate(host.base_anim, "LedgeGrab", false)
	elif(climb):
		host.collision_box.disabled = true
		host.animate(host.base_anim, "Climb", false)
		exiting = true
	elif(jump):
		host.animate(host.base_anim, "LedgeJump", false)
	super._handle_animation()


func _execute(_delta):
	if super._execute(_delta):
		return
	if jump && grab_animation_done:
		turn(host.hor_dir * -1)
		host.hor_spd = host.true_soft_speed_cap * host.hor_dir
	#Snap to ledge side
	if host.is_on_wall():
		hstop = true
	if !hstop:
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsRayQueryParameters2D.new()
		query.collision_mask = ledge_cast.collision_mask
		query.from = host.global_position
		query.to = host.global_position
		query.to.x +=  + host.collision_box.shape.get_rect().size.x / 2 * host.hor_dir
		while (space_state.intersect_ray(query).size() == 0):
			query.from.x += host.hor_dir
			query.to.x += host.hor_dir
		host.global_position.x += abs(query.from.x - host.global_position.x) * host.hor_dir
		hstop = true
	#Snap to ledge height or fall if it's a bad detect
	if going_up:
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsRayQueryParameters2D.new()
		query.collision_mask = ledge_cast.collision_mask
		query.from = ledge_cast.global_position
		query.to = ledge_cast.global_position + ledge_cast.target_position
		while (space_state.intersect_ray(query)):
			query.from.y -= 1
			query.to.y -= 1
		host.global_position.y -= abs(query.from.y - ledge_cast.global_position.y)
		going_up = false



func _exit(state):
	host.collision_box.disabled = false
	host.activate_grav()
	hstop = false
	grab_animation_done = false
	climb = false
	jump = false
	going_up = true
	super._exit(state)


func set_grab_animation_done(flag := true):
	grab_animation_done = flag
