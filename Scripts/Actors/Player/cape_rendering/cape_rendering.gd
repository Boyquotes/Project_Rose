@tool
extends Polygon2D

var host

@export var rot_bone_path : NodePath
@export var z_bone_path : NodePath

var rot_bone : Bone2D
var z_bone : Bone2D

func _ready():
	rot_bone = get_node(rot_bone_path)
	z_bone = get_node(z_bone_path)

func _process(_delta):
	z_index = z_bone.z_index
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		material. set_shader_parameter("theta", rot_bone.global_rotation)
