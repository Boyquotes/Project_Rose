class_name ActionInstancer
extends Node2D


var last_queued_action

@export var action_target_path: NodePath

var action_controller : ActionController
var action_state : ActionState
var host : Player
var action_spawn

func init():
	action_controller = get_parent()
	action_state = action_controller.action_state
	host = action_controller.host
	action_spawn = get_node(action_target_path)

func initialize_action(action, instance_on_spawn=false, attached=false):
	#host.connect("hurt", Callable(action,"on_player_hurt"))
	action.host = host
	if instance_on_spawn:
		action.action_spawn = action_spawn
	action.z_index = host.z_index + 1
	if not attached:
		host.get_parent().add_child(action)
	else:
		host.add_child(action)
	action.global_position = host.global_position
	action.scale.x = host.hor_dir
	return action

func initialize_hitboxes(action):
	var hitboxes = action.get_node("Hitboxes")
	hitboxes.host = host
	hitboxes.action_controller = action_controller
	hitboxes.action_instancer = self
	hitboxes.init()
	return action
