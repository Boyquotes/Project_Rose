@tool
extends Polygon2D

func _ready():
	var custom_rect:Rect2 = Rect2(Vector2.ZERO,Vector2(1000,1000))
	RenderingServer.canvas_item_set_custom_rect(get_canvas_item(), true, custom_rect)
