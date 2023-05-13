class_name RestState
extends PlayerState


#signal exit_rest
#
#func _ready():
#	var err = connect("exit_rest",Callable(self,"on_exit_rest"))
#	if err:
#		print(err)


func _enter():
	state_machine.move_state = 'rest'


func _handle_input():
	pass


func _handle_animation():
	host.animate(host.base_anim, "Rest", false)
	super._handle_animation()


func _execute(_delta):
	pass


func _exit(state):
	super._exit(state)


func on_exit_rest():
	exit_ground_or_air()
