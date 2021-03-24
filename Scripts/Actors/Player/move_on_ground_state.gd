class_name MoveOnGroundState
extends PlayerState

var jump := false

func _enter():
	host.move_state = 'move_on_ground'


func _handle_input():
	if Input.is_action_just_pressed("Jump"):
		jump = true;
	._handle_input()


func _handle_animation():
	if jump:
		host.animate(host.base_anim, "Jump", false)
	._handle_animation()


func _execute(delta):
	._execute(delta)
	if not host.on_floor():
		exit_air()


func _exit(state):
	jump = false
	._exit(state)
