extends TileMap

func _ready():
	var par = get_parent()
	var cells = par.get_used_cells()
	for cell in cells:
		var left = par.get_cell(cell.x-1,cell.y)
		var up = par.get_cell(cell.x,cell.y-1)
		var right = par.get_cell(cell.x+1,cell.y)
		if (left == -1 and up == -1) or (right == -1 and up == -1):
			set_cell(cell.x, cell.y, 0)
