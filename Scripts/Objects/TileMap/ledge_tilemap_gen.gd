extends TileMap

func _ready():
	var par : TileMap = get_parent()
	var cells = par.get_used_cells(0)
	for cell in cells:
		var left = par.get_cell_source_id(0, Vector2i(cell.x-1,cell.y))
		var up = par.get_cell_source_id(0, Vector2i(cell.x,cell.y-1))
		var right = par.get_cell_source_id(0, Vector2i(cell.x+1,cell.y))
		if (left == -1 and up == -1) or (right == -1 and up == -1):
			set_cell(0, Vector2i(cell.x, cell.y), 0, Vector2i(0, 0), 0)


