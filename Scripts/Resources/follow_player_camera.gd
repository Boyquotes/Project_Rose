@tool
extends Camera2D

@export var playerCam : Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		if playerCam:
			global_position = playerCam.get_screen_center_position()
