class_name State
extends Node2D

var host : Actor
var state_machine : FiniteStateMachine
var exiting := false

func init():
	state_machine = get_parent()
	host = state_machine.host
	host.call_init_in_children(host, self)

func _enter():
	exiting = false

func _handle_animation():
	return exiting

func _handle_input():
	return exiting

func _execute(_delta):
	return exiting

func _paused_execute(_delta):
	pass;

func _paused_handle_animation():
	pass;

func _paused_handle_input():
	pass;


func _exit(state):
	state._enter();
