extends Node2D

@export var target : Camera2D
var prev
var curr

func _ready():
	curr = target.get_screen_center_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	prev = target.get_screen_center_position()
	if prev != curr:
		global_position += curr - prev
	curr = prev
