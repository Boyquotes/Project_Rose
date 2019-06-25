extends Bone2D

export(Color) var color;
export(int) var length;

func _draw():
	draw_line(Vector2(0,0), get_child(0).position, color, 2);

func _process(delta):
	update();
	default_length = length;
	pass;