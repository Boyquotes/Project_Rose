class_name MoveOnGroundState
extends PlayerState

var jump := false
var jumping := false

func _enter():
	host.move_state = 'move_on_ground'

func _handle_animation():
	if(jump && !jumping):
		jumping = true
		host.animate(host.base_anim,"Jump", false)
	._handle_animation()

func _handle_input():
	if(Input.is_action_just_pressed("jump")):
		jump = true;
	._handle_input()

func _execute(delta):
	._execute(delta)

func _exit(state):
	jump = false
	jumping = false
	._exit(state)
