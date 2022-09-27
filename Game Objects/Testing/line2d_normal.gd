@tool
extends Line2D


@export var normals: Texture2D

func _process(delta):
	if Engine.editor_hint or not Engine.editor_hint:
		material.set_shader_parameter("norm", normals)
