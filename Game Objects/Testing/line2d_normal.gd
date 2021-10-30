extends Line2D


@export var normals : Texture

func _process(delta):
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		material.set_shader_param("norm", normals)
