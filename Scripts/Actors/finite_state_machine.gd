class_name FiniteStateMachine
extends Node2D


@export var host_path : NodePath
@export var move_states := {}
@export var default_state := ""

var host : Actor
var move_state := ""
var current_state : State

func init():
	move_states = move_states.duplicate()
	move_state = default_state
	host = get_node(host_path)
	host.call_init_in_children(host, self)
	for key in move_states.keys():
		if move_states[key] is NodePath:
			move_states[key] = get_node(move_states[key])

func execute(delta):
	current_state = move_states[move_state]
	move_states[move_state]._handle_input()
	move_states[move_state]._handle_animation()
	move_states[move_state]._execute(delta)

func paused_execute(delta):
	move_states[move_state]._paused_handle_input()
	move_states[move_state]._paused_handle_animation()
	move_states[move_state]._paused_execute(delta)
