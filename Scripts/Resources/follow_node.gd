extends Node2D

@export var target : Camera2D
@export_node_path var target_path
@export var dir : float = 1.0
var prev
var curr

func _ready():
	curr = target.get_screen_center_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	prev = target.get_screen_center_position()
	if prev != curr and curr:
		global_position += (curr - prev) * dir
	curr = prev
