extends TileMap


func _ready():
	pass
	"""
	var par = get_parent()
	var cells = par.get_used_cells(0)
	for cell in cells:
		var left = par.get_neighbor_cell(Vector2(cell.x, cell.y), 8) in cells
		var up = par.get_neighbor_cell(Vector2(cell.x, cell.y), 12) in cells
		var right = par.get_neighbor_cell(Vector2(cell.x, cell.y), 0) in cells
		if (!left and !up) or (!right and !up):
			set_cell(0, Vector2(cell.x, cell.y), -1, Vector2(-1, -1), 0)
	"""
