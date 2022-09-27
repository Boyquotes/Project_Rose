@tool
extends Polygon2D

var host

@export var bone_idx := 0
@export var image : Image
@export var image_temp : Image
@export var normal : Texture2D
@export var secondary_normal : Texture2D
@export var hframes := 1
@export var vframes := 1
@export var frame := 0
@export var shader : Shader
@export var reinit := false

var true_normal : Texture2D
var true_hframes := 1
var true_vframes := 1
var true_frame := 0

func init():
	host.call_init_in_children(host, self)
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		material = ShaderMaterial.new()
		material.shader = shader
		reinit = false

func _process(_delta):
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		if reinit:
			init()
		var bone = get_node(str(skeleton) + '/' + str(bones[bone_idx]))
		material.set_shader_parameter("theta", bone.global_rotation)
		if true_normal != normal:
			material.set_shader_parameter("norm", normal)
			material.set_shader_parameter("uv", uv)
			true_normal = normal
	
	if not Engine.is_editor_hint():
		if host.vel.x < 0:
			material.set_shader_parameter("norm", secondary_normal)
		else:
			material.set_shader_parameter("norm", normal)
