extends Position2D


var prev_position := Vector2()
var prev_glob_position := Vector2()
var moved := false

func _ready():
	prev_glob_position = global_position
	prev_position = position

func _process(delta):
	if moved:
		prev_position = position
		prev_glob_position = global_position
		moved = false
	if prev_position != position:
		moved = true
