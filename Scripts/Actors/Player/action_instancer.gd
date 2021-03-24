class_name ActionInstancer
extends Node2D


var action_queue := []

export(NodePath) var action_target_path

var action_controller
var action_state
var host
var action_target

func init():
	action_controller = get_parent()
	action_state = action_controller.action_state
	host = action_controller.host
	action_target = get_node(action_target_path)

func initialize_action(action, follow_target = false):
	action.follow_target = action_target
	action_controller.action_can_start = false
	action.host = host
	action.action_controller = action_controller
	action.action_instancer = self
	action.follow_target = follow_target
	action.z_index = 2
	action.scale = scale
	action.global_position = host.global_position
	host.get_parent().add_child(action)
	#host.change_mana(-action.cost)

func initialize_hitboxes(action):
	var hitboxes = action.get_node("Hitboxes")
	hitboxes.host = host
	hitboxes.action_controller = action_controller
	hitboxes.action_instancer = self
	hitboxes.init()
	set_rot(action, hitboxes)
	return action

func initialize_particles(action):
	var particles = action.get_node("Particles")
	#particles.init()
	particles.scale = scale

func initialize_sprite(action):
	var sprite = action.get_node("Sprite")
	sprite.scale = scale

func set_rot(_action, _hitboxes):
	pass
"""
	for hitbox in hitboxes.get_children():
		if(is_instance_valid(hitbox)):
			if(action_controller.rotate):
				hitbox.global_rotation_degrees += action_controller.attack_degrees
				if(hitbox.direction == 0):
					hitbox.direction = hitbox.global_rotation_degrees * host.Direction
				hitbox.scale.y = host.Direction
			else:
				hitbox.scale.x = host.Direction
				hitbox.direction = hitbox.global_rotation_degrees * host.Direction
"""

func clear_actions():
	for node in action_queue:
		dequeue_action(node)
	action_queue.clear()

func dequeue_action(node):
	action_queue.erase(node)
	if is_instance_valid(node):
		if node.follow_target:
			node.global_rotation_degrees = 0
			node.queue_free()
		else:
			node.queue_free()
