class_name MoveOnGroundState
extends PlayerState

"""
func _handle_animation():
	if slide:
		slide = false
		#host.animate(host.base_anim, "Slide", false)
	else:
		host.animate(host.base_anim, "Crouch", false)
	._handle_animation()
"""

var jump := false
var crouch := false
var look_up := false
var slide := false

func _enter():
	host.move_state = 'move_on_ground'


func _handle_input():
	if Input.is_action_just_pressed("Jump"):
		jump = true
	if Input.is_action_pressed("Move_Down") and move_direction == 0:
		crouch = true
	else:
		crouch = false
	if Input.is_action_pressed("Move_Up") and move_direction == 0:
		look_up = true
	else:
		look_up = false
	._handle_input()


func _handle_animation():
	if jump:
		host.animate(host.base_anim, "Jump", false)
	elif crouch:
		host.animate(host.base_anim, "Crouch", false)
	elif look_up:
		host.animate(host.base_anim, "LookUp", false)
	elif move_direction != 0:
		host.animate(host.base_anim, "Run", false)
	else:
		host.animate(host.base_anim, "Idle", false)
	._handle_animation()


func _execute(delta):
	._execute(delta)
	if not host.on_floor():
		exit_air()


func _exit(state):
	jump = false
	._exit(state)
