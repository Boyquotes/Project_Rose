class_name HitState
extends PlayerState

@export var crit_thresh := 50
@export var iframes := 30
@export var crit_iframe_factor := 2
# at move_thresh = iframes, player has total control of movement
# at move_thresh = 0, player has no control over movement in the hit state
@export var move_thresh := 20
@export var fall_flag := false


var hit_flag := true
var damage := 0
var compare_to


func _ready():
	fall_flag = false


func _enter():
	host.move_state = 'hit'
	if damage >= crit_thresh:
		host.iframe(iframes * crit_iframe_factor)
	else:
		host.iframe(iframes)
	# These are set when the player is hit
	# host.change_hp(-damage)
	update_look_direction_and_scale(move_direction) 


func _handle_input():
	if host.iframes <= move_thresh:
		move_direction = get_move_direction()
		if can_turn:
			update_look_direction_and_scale(move_direction)
	else:
		move_direction = 0
	if can_turn && move_direction != 0:
		host.activate_fric()
		exit_ground_or_air()


func _handle_animation():
	if host.on_floor() && fall_flag:
		host.animate(host.base_anim, "LandFromHit", false)
	if hit_flag:
		host.animate(host.base_anim, "Hit", false)
		hit_flag = false


func _execute(delta):
	super._execute(delta)


func _exit(state):
	print(state.name)
	damage = 0
	fall_flag = false
	hit_flag = true
	super._exit(state)


func knock_back(speed : float, angle : float):
	if compare_to.x < host.global_position.x:
		angle = -180 - angle
	host.add_vel(speed, angle)
