@tool
extends Camera2D

@export var player : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		if player:
			global_position = player.global_position
