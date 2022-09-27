@tool
extends Sprite2D

@export var true_node_path: NodePath
@export var light_paths: Array := []

var true_node
var light_nodes := []

func _ready():
	if Engine.editor_hint or not Engine.editor_hint:
		if true_node_path:
			true_node = get_node(true_node_path)
		if(light_paths):
			for light_path in light_paths:
				light_nodes.append(get_node(light_path))

func _process(delta):
	if Engine.editor_hint or not Engine.editor_hint:
		material.set_shader_parameter("norm", normal_map)
		material.set_shader_parameter("theta", rotation)
		material.set_shader_parameter("true_pos", tolocal(true_node.global_position))
		if(light_nodes):
			var i = 0
			for light_node in light_nodes:
				var local_light_pos = light_node.position
				material.set_shader_parameter("light_position" + str(i), local_light_pos)
				material.set_shader_parameter("light_energy" + str(i), light_node.energy)
				if(!light_node.visible):
					material.set_shader_parameter("light_position" + str(i), Vector2(0,0))
				i += 1

func tolocal(pos):
	var loc_pos = get_parent().get_parent().to_local(pos)
	return loc_pos
