extends Light2D


export(float) var speed := 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if visible:
		if global_position.y < (get_global_mouse_position().y - 10.0):
			global_position.y += speed
		if global_position.y > (get_global_mouse_position().y + 10.0):
			global_position.y -= speed
			
		if global_position.x < (get_global_mouse_position().x - 10.0):
			global_position.x += speed
		if global_position.x > (get_global_mouse_position().x + 10.0):
			global_position.x -= speed
