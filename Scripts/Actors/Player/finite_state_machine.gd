class_name FiniteStateMachine
extends Node2D


@export var host_path : NodePath
@export var move_states := {}

var move_on_ground_state : MoveOnGroundState
var move_in_air_state : MoveInAirState
var ledge_grab_state : LedgeGrabState
var hit_state : HitState
var action_state : ActionState
var crouch_state : CrouchState

var host : Player
var move_state := "move_on_ground"
var current_state : PlayerState

func init():
	host = get_node(host_path)
	host.call_init_in_children(host, self)
	for key in move_states.keys():
		move_states[key] = get_node(move_states[key])
	move_on_ground_state = move_states["move_on_ground"]
	move_in_air_state = move_states["move_in_air"]
	ledge_grab_state = move_states["ledge_grab"]
	hit_state = move_states["hit"]
	action_state = move_states["action"]
	crouch_state = move_states["crouch"]

func execute(delta):
	current_state = move_states[move_state]
	move_states[move_state]._handle_input()
	move_states[move_state]._handle_animation()
	move_states[move_state]._execute(delta)

func paused_execute(delta):
	move_states[move_state]._paused_handle_input()
	move_states[move_state]._paused_handle_animation()
	move_states[move_state]._paused_execute(delta)
