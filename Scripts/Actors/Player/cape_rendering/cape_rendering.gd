tool
extends Polygon2D

var host

export(int) var bone_idx := 0
export(Image) var image : Image
export(Image) var image_temp : Image
export(Texture) var normal : Texture
export(Texture) var secondary_normal : Texture
export(int) var hframes := 1
export(int) var vframes := 1
export(int) var frame := 0
export(Shader) var shader
export(bool) var reinit := false

var true_normal : Texture
var true_hframes := 1
var true_vframes := 1
var true_frame := 0

func init():
	host.call_init_in_children(host, self)
	if Engine.editor_hint or not Engine.editor_hint:
		material = ShaderMaterial.new()
		material.shader = shader
		reinit = false

func _process(_delta):
	if Engine.editor_hint or not Engine.editor_hint:
		if reinit:
			init()
		var bone = get_node(str(skeleton) + '/' + str(bones[bone_idx]))
		material.set_shader_param("theta", bone.global_rotation)
		if true_normal != normal:
			material.set_shader_param("norm", normal)
			material.set_shader_param("uv", uv)
			true_normal = normal
	
	if not Engine.editor_hint:
		if host.vel.x < 0:
			material.set_shader_param("norm", secondary_normal)
		else:
			material.set_shader_param("norm", normal)
