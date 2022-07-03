class_name ActionInstancer
extends Node2D


var action_queue := []

export(NodePath) var action_target_path

var action_controller : ActionController
var action_state : ActionState
var host : Player
var action_spawn

func init():
	action_controller = get_parent()
	action_state = action_controller.action_state
	host = action_controller.host
	action_spawn = get_node(action_target_path)

func initialize_action(action, instance_on_spawn=false):
	host.connect("hurt", action, "on_player_hurt")
	if instance_on_spawn:
		action.action_spawn = action_spawn
	action.z_index = host.z_index + 1
	action.global_position = host.global_position
	host.get_parent().add_child(action)

func initialize_hitboxes(action):
	var hitboxes = action.get_node("Hitboxes")
	hitboxes.host = host
	hitboxes.action_controller = action_controller
	hitboxes.action_instancer = self
	hitboxes.init()
	return action

func initialize_particles(action):
	var particles = action.get_node("Particles")

func initialize_sprites(action):
	var sprites = action.get_node("Sprites")
