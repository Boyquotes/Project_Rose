extends Node2D


export(NodePath) var host_path

onready var move_on_ground_state = $MoveOnGround
onready var move_in_air_state = $MoveInAir
onready var ledge_grab_state = $LedgeGrab
onready var hit_state = $Hit
onready var action_state = $Action
onready var FSM = self

var host

func init():
	host = get_node(host_path)
	host.call_init_in_children(self)
