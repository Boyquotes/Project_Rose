class_name RestState
extends PlayerState

signal exit_rest


func _ready():
	connect("exit_rest", self, "on_exit_rest")


func _enter():
	host.move_state = 'rest'


func _handle_input():
	pass


func _handle_animation():
	host.animate(host.base_anim, "Rest", false)
	._handle_animation()


func _execute(delta):
	pass


func _exit(state):
	._exit(state)


func on_exit_rest():
	exit_ground_or_air()
