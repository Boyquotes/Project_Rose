@tool
extends Node2D

@export var target_path : NodePath
var target : Node2D

func _ready():
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		target = get_node(target_path)

func _process(delta):
	if Engine.is_editor_hint() or not Engine.is_editor_hint():
		rotation = target.rotation
