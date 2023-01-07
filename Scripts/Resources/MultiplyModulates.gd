@tool
extends CanvasModulate

@export var mult_node_path : NodePath
@export var base_color : Color
@export_range(0,1) var fac := 0.5
var mult_node

func _ready():
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		mult_node = get_node(mult_node_path)
		if not mult_node:
			mult_node = get_parent().get_parent().find_child("MainCanvasModulate")
			mult_node_path = get_path_to(mult_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	color = base_color.lerp(mult_node.color, fac)
