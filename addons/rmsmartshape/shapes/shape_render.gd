@tool
extends Node2D
class_name SS2D_Shape_Render

"""
Node is used to render shape geometry
"""

var mesh = null :
	get:
		return mesh # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_mesh


func set_mesh(m):
	mesh = m
	if m != null:
		material = mesh.material
		z_index = mesh.z_index
		z_as_relative = mesh.z_as_relative
	else:
		material = null
		z_index = 0
		z_as_relative = true
	update()


func _draw():
	if mesh != null:
		mesh.render(self)
