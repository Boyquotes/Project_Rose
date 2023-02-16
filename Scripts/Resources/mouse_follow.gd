extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position += Vector2(int(Input.is_action_pressed("Debug_Right")) - int(Input.is_action_pressed("Debug_Left")), 
	int(Input.is_action_pressed("Debug_Down")) - int(Input.is_action_pressed("Debug_Up")))
