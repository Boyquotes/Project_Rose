class_name ActionElement
extends PanelContainer

@export var label_path : NodePath
@export var button_list_path : NodePath
var label : Label
var button_list

func _ready():
	label = get_node(label_path)
	button_list = get_node(button_list_path)
