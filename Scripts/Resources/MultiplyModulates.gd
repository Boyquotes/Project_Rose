@tool
extends CanvasModulate

@export var mult_node : CanvasModulate
@export var base_color : Color
@export_range(0,1) var fac := 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if mult_node:
		color = base_color.lerp(mult_node.color, fac)
