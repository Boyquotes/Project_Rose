tool
extends Line2D


export(Texture) var normals

func _process(delta):
	if Engine.editor_hint or not Engine.editor_hint:
		material.set_shader_param("norm", normals)
