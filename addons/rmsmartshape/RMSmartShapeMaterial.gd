@tool
extends Resource
class_name RMS2D_Material

@export (Texture2D) var fill_texture = null :
	get:
		return fill_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_fill_texture
@export (Texture2D) var fill_texture_normal = null :
	get:
		return fill_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_fill_texture_normal

@export (float, 0, 180.0) var top_texture_tilt = 20.0 :
	get:
		return top_texture_tilt # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_texture_tilt
@export (float, 0, 180.0) var bottom_texture_tilt = 20.0 :
	get:
		return bottom_texture_tilt # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_texture_tilt

@export (Array, Texture2D) var top_texture :
	get:
		return top_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_texture
@export (Array, Texture2D) var top_texture_normal :
	get:
		return top_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_texture_normal

@export (Array, Texture2D) var left_texture :
	get:
		return left_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_left_texture
@export (Array, Texture2D) var left_texture_normal :
	get:
		return left_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_left_texture_normal

@export (Array, Texture2D) var right_texture :
	get:
		return right_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_right_texture
@export (Array, Texture2D) var right_texture_normal :
	get:
		return right_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_right_texture_normal

@export (Array, Texture2D) var bottom_texture :
	get:
		return bottom_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_texture
@export (Array, Texture2D) var bottom_texture_normal :
	get:
		return bottom_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_texture_normal

@export (bool) var use_corners = true :
	get:
		return use_corners # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_use_corners
# Textures for 90 angles
# Inner Angles
@export (Texture2D) var top_left_inner_texture :
	get:
		return top_left_inner_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_left_inner_texture
@export (Texture2D) var top_left_inner_texture_normal :
	get:
		return top_left_inner_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_left_inner_texture_normal

@export (Texture2D) var top_right_inner_texture :
	get:
		return top_right_inner_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_right_inner_texture
@export (Texture2D) var top_right_inner_texture_normal :
	get:
		return top_right_inner_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_right_inner_texture_normal

@export (Texture2D) var bottom_right_inner_texture :
	get:
		return bottom_right_inner_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_right_inner_texture
@export (Texture2D) var bottom_right_inner_texture_normal :
	get:
		return bottom_right_inner_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_right_inner_texture_normal

@export (Texture2D) var bottom_left_inner_texture :
	get:
		return bottom_left_inner_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_left_inner_texture
@export (Texture2D) var bottom_left_inner_texture_normal :
	get:
		return bottom_left_inner_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_left_inner_texture_normal

# Outer Angles
@export (Texture2D) var top_left_outer_texture :
	get:
		return top_left_outer_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_left_outer_texture
@export (Texture2D) var top_left_outer_texture_normal :
	get:
		return top_left_outer_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_left_outer_texture_normal

@export (Texture2D) var top_right_outer_texture :
	get:
		return top_right_outer_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_right_outer_texture
@export (Texture2D) var top_right_outer_texture_normal :
	get:
		return top_right_outer_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_top_right_outer_texture_normal

@export (Texture2D) var bottom_right_outer_texture :
	get:
		return bottom_right_outer_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_right_outer_texture
@export (Texture2D) var bottom_right_outer_texture_normal :
	get:
		return bottom_right_outer_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_right_outer_texture_normal

@export (Texture2D) var bottom_left_outer_texture :
	get:
		return bottom_left_outer_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_left_outer_texture
@export (Texture2D) var bottom_left_outer_texture_normal :
	get:
		return bottom_left_outer_texture_normal # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_bottom_left_outer_texture_normal

@export (bool) var weld_edges = false :
	get:
		return weld_edges # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_weld_edges
@export (float, -1.0, 1.0) var render_offset = 0.0 :
	get:
		return render_offset # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_render_offset

"""
The multiplier applied to the width of the quads
"""
@export (float, 0, 1.5) var collision_width = 1.0 :
	get:
		return collision_width # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_collision_width
"""
The offset applied to the position of the quads
"""
@export (float, -1.5, 1.5) var collision_offset = 0.0 :
	get:
		return collision_offset # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_collision_offset
"""
The amount the first and final quads extend past the texture (Does not apply to closed shapes)
"""
@export (float, -1.0, 1.0) var collision_extends = 0.0 :
	get:
		return collision_extends # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_collision_extends


func _set_fill_texture(value):
	fill_texture = value
	emit_signal("changed")


func _set_fill_texture_normal(value):
	fill_texture_normal = value
	emit_signal("changed")


func _set_render_offset(value):
	render_offset = value
	emit_signal("changed")

func _set_bottom_texture(value):
	bottom_texture = value
	emit_signal("changed")


func _set_bottom_texture_normal(value):
	bottom_texture_normal = value
	emit_signal("changed")


func _set_bottom_texture_tilt(value):
	bottom_texture_tilt = value
	emit_signal("changed")


func _set_collision_width(value:float):
	collision_width = value
	emit_signal("changed")


func _set_collision_offset(value:float):
	collision_offset = value
	emit_signal("changed")


func _set_collision_extends(value:float):
	collision_extends = value
	emit_signal("changed")


func _set_left_texture(value):
	left_texture = value
	emit_signal("changed")


func _set_left_texture_normal(value):
	left_texture_normal = value
	emit_signal("changed")


func _set_right_texture(value):
	right_texture = value
	emit_signal("changed")


func _set_right_texture_normal(value):
	right_texture_normal = value
	emit_signal("changed")


func _set_top_texture(value):
	top_texture = value
	emit_signal("changed")


func _set_top_texture_normal(value):
	top_texture_normal = value
	emit_signal("changed")


func _set_top_texture_tilt(value):
	top_texture_tilt = value
	emit_signal("changed")


func _set_weld_edges(value):
	weld_edges = value
	emit_signal("changed")


func _set_use_corners(value):
	use_corners = value
	emit_signal("changed")


func _set_top_left_inner_texture(value):
	top_left_inner_texture = value
	emit_signal("changed")


func _set_top_right_inner_texture(value):
	top_right_inner_texture = value
	emit_signal("changed")


func _set_bottom_right_inner_texture(value):
	bottom_right_inner_texture = value
	emit_signal("changed")


func _set_bottom_left_inner_texture(value):
	bottom_left_inner_texture = value
	emit_signal("changed")


func _set_top_left_inner_texture_normal(value):
	top_left_inner_texture_normal = value
	emit_signal("changed")


func _set_top_right_inner_texture_normal(value):
	top_right_inner_texture_normal = value
	emit_signal("changed")


func _set_bottom_right_inner_texture_normal(value):
	bottom_right_inner_texture_normal = value
	emit_signal("changed")


func _set_bottom_left_inner_texture_normal(value):
	bottom_left_inner_texture_normal = value
	emit_signal("changed")


func _set_top_left_outer_texture(value):
	top_left_outer_texture = value
	emit_signal("changed")


func _set_top_right_outer_texture(value):
	top_right_outer_texture = value
	emit_signal("changed")


func _set_bottom_right_outer_texture(value):
	bottom_right_outer_texture = value
	emit_signal("changed")


func _set_bottom_left_outer_texture(value):
	bottom_left_outer_texture = value
	emit_signal("changed")


func _set_top_left_outer_texture_normal(value):
	top_left_outer_texture_normal = value
	emit_signal("changed")


func _set_top_right_outer_texture_normal(value):
	top_right_outer_texture_normal = value
	emit_signal("changed")


func _set_bottom_right_outer_texture_normal(value):
	bottom_right_outer_texture_normal = value
	emit_signal("changed")


func _set_bottom_left_outer_texture_normal(value):
	bottom_left_outer_texture_normal = value
	emit_signal("changed")
