@tool
extends Node2D

@onready @export var targetLight : Node2D

func _process(delta):
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		if targetLight:
			rotation = targetLight.rotation
