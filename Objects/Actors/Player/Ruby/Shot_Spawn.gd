extends Position2D

var H = position.x

func _process(delta):
	position.x = H * cos(get_parent().rad);
	position.y = H * sin(get_parent().rad);