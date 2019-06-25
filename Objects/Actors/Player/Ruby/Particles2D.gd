extends Particles2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _process(delta):
	rotation_degrees = -get_parent().deg;
	#process_material.angle = -get_parent().deg;
	pass;
