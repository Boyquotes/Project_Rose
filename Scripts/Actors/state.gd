class_name State
extends Node2D

var host
var FSM

func init():
	FSM = get_parent()
	host = FSM.host
	host.call_init_in_children(self)

func _enter():
	pass;

func _handle_animation():
	pass;

func _handle_input():
	pass;

func _execute(_delta):
	pass;

func _paused_execute(_delta):
	pass;

func _paused_handle_animation():
	pass;

func _paused_handle_input():
	pass;


func _exit(state):
	state._enter();
