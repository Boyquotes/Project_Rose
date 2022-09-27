extends Marker2D


var prev_position := Vector2()
var prev_glob_position := Vector2()
var moved := false
var rng = RandomNumberGenerator.new()
var deltatime := 3.0
var yspeed := 0.0
var xspeed := 0.0
var length := 0.0
var initial_x := 0.0
var thresh := -60.0
var offset := 0.0

func _ready():
	prev_glob_position = global_position
	prev_position = position
	initial_x = position.x
	rng.randomize()
	yspeed = rng.randf_range(50.0, 100.0)
	xspeed = rng.randf_range(1, 5)
	length = rng.randf_range(20.0, 40.0)


func _process(_delta):
	if moved:
		prev_position = position
		prev_glob_position = global_position
		moved = false
	if prev_position != position:
		moved = true
	if position.x < thresh:
		position.x = initial_x
		rng.randomize()
		yspeed = rng.randf_range(7.5, 10.0)
		xspeed = rng.randf_range(1, 3.5)
		offset = rng.randf_range(-100, 100)
		length = rng.randf_range(5.0, 20.0)
		thresh = rng.randf_range(-40.0, -80.0)
		prev_position = position
		prev_glob_position = global_position
		moved = false
	position.y = sin((position.x + offset) / yspeed) * length
	print()
	position.x -= xspeed
