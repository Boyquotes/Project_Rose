class_name MoveInAirState
extends PlayerState

export(bool) var jumped := false
export(bool) var transitioned := false
export(bool) var jump := false
export(NodePath) var ledge_cast_l_path
export(NodePath) var ledge_cast_r_path


var cutoff := false
var land := false
var done_ascent := false
var done_descent := false
var wasnt_wall_r := false
var is_wall_r := false
var wasnt_wall_l := false
var is_wall_l := false
var ledge_cast_l
var ledge_cast_r

onready var ledge_disable_timer = $LedgeDisableTimer

func init():
	.init()
	ledge_cast_r = get_node(ledge_cast_r_path)
	ledge_cast_l = get_node(ledge_cast_l_path)

func _ready():
	jumped = false


func _enter():
	host.move_state = 'move_in_air'

func _handle_input():
	if jumped && !Input.is_action_pressed("Jump") && host.vert_spd < 0:
		cutoff = true
		host.vert_spd += 60
	._handle_input()

func _handle_animation():
	if(jump):
		host.animate(host.spr_anim,"AirJump", false);
	if host.on_floor() && !land:
		land = true
		host.animate(host.base_anim, "Land", false)
	elif !land:
		if (cutoff && !transitioned) or (host.vert_spd > -250 && !transitioned):
			host.animate(host.base_anim,"AscendToDescend", false)
		elif !done_ascent || !done_descent:
			if host.vert_spd < 0 && !done_ascent:
				print("!!!")
				host.animate(host.base_anim, "Ascend", false)
				done_ascent = true
				done_descent = false
			if host.vert_spd > 0 && !done_descent:
				host.animate(host.base_anim, "Descend", false)
				done_descent = true
				done_ascent = false
	._handle_animation()


func _execute(delta):
	if detect_ledge(ledge_cast_r, 1):
		return
	if detect_ledge(ledge_cast_l, -1):
		return
	
	._execute(delta)


func _exit(state):
	jump = false
	jumped = false
	transitioned = false
	cutoff = false
	land = false
	done_ascent = false
	done_descent = false
	wasnt_wall_r = false
	is_wall_r = false
	wasnt_wall_l = false
	is_wall_l = false
	._exit(state)

func detect_ledge(ledge_cast, dir : int):
	if ledge_cast.is_colliding():
		FSM.ledge_grab_state.ledge_cast = ledge_cast
		FSM.ledge_grab_state.move_direction = dir
		_exit(FSM.ledge_grab_state)
		return true
	return false


func ledge_detection_switch():
	ledge_cast_r.enabled = !ledge_cast_r.enabled
	ledge_cast_l.enabled = !ledge_cast_l.enabled


func _on_LedgeDisableTimer_timeout():
	ledge_detection_switch()


func _on_BaseAnimator_animation_finished(anim_name):
	if(anim_name == "AscendToDescend"):
		transitioned = true;
