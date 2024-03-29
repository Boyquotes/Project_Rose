@tool
extends Resource
class_name SS2D_Material_Edge

"""
This material represents the set of textures used for a single edge
This consists of:
- textures
- corner_textures
- taper_textures
- normals for each texture
"""
# All variations of the main edge texture
# _textures[0] is considered the "main" texture for the EdgeMaterial
#### Will be used to generate an icon representing an edge texture
@export (Array, Texture2D) var textures: Array = [] :
	get:
		return textures # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_textures
@export (Array, Texture2D) var texture_normals: Array = [] :
	get:
		return texture_normals # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_texture_normals

# Textures for the final left and right quad of the edge when the angle is steep
@export (Array, Texture2D) var textures_corner_outer: Array = [] :
	get:
		return textures_corner_outer # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_textures_corner_outer
@export (Array, Texture2D) var textures_corner_inner: Array = [] :
	get:
		return textures_corner_inner # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_textures_corner_inner
@export (Array, Texture2D) var texture_normals_corner_outer: Array = [] :
	get:
		return texture_normals_corner_outer # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_texture_normals_corner_outer
@export (Array, Texture2D) var texture_normals_corner_inner: Array = [] :
	get:
		return texture_normals_corner_inner # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_texture_normals_corner_inner

# Textures for the final left and right quad of the edge when the angle is shallow
# Named as such because the desired look is that the texture "tapers-unchecked"
@export (Array, Texture2D) var textures_taper_left: Array = [] :
	get:
		return textures_taper_left # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_textures_taper_left
@export (Array, Texture2D) var textures_taper_right: Array = [] :
	get:
		return textures_taper_right # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_textures_taper_right
@export (Array, Texture2D) var texture_normals_taper_left: Array = [] :
	get:
		return texture_normals_taper_left # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_texture_normals_taper_left
@export (Array, Texture2D) var texture_normals_taper_right: Array = [] :
	get:
		return texture_normals_taper_right # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_texture_normals_taper_right

# If the texture choice should be randomized instead of the choice by point setup
@export (bool) var randomize_texture: bool = false :
	get:
		return randomize_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_randomize_texture
# If corner textures should be used
@export (bool) var use_corner_texture: bool = true :
	get:
		return use_corner_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_use_corner
# If taper textures should be used
@export (bool) var use_taper_texture: bool = true :
	get:
		return use_taper_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_use_taper
# if set to true, then squishing can occur when texture doesn't fit nicely into total length.
enum FITMODE {SQUISH_AND_STRETCH, CROP}
@export (FITMODE) var fit_mode = FITMODE.SQUISH_AND_STRETCH :
	get:
		return fit_mode # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_fit_texture

@export (Material) var material: Material = null :
	get:
		return material # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of _set_material


###########
# SETTERS #
###########
func _set_textures(ta: Array):
	textures = ta
	emit_signal("changed")


func _set_texture_normals(ta: Array):
	texture_normals = ta
	emit_signal("changed")


func _set_textures_corner_outer(a: Array):
	textures_corner_outer = a
	emit_signal("changed")


func _set_texture_normals_corner_outer(a: Array):
	texture_normals_corner_outer = a
	emit_signal("changed")


func _set_textures_corner_inner(a: Array):
	textures_corner_inner = a
	emit_signal("changed")


func _set_texture_normals_corner_inner(a: Array):
	texture_normals_corner_inner = a
	emit_signal("changed")


func _set_textures_taper_left(a: Array):
	textures_taper_left = a
	emit_signal("changed")


func _set_texture_normals_taper_left(a: Array):
	texture_normals_taper_left = a
	emit_signal("changed")


func _set_textures_taper_right(a: Array):
	textures_taper_right = a
	emit_signal("changed")


func _set_texture_normals_taper_right(a: Array):
	texture_normals_taper_right = a
	emit_signal("changed")


func _set_randomize_texture(b: bool):
	randomize_texture = b
	emit_signal("changed")


func _set_use_corner(b: bool):
	use_corner_texture = b
	emit_signal("changed")


func _set_use_taper(b: bool):
	use_taper_texture = b
	emit_signal("changed")
	
func _set_fit_texture(fitmode):
	fit_mode = fitmode
	emit_signal("changed")

func _set_material(m:Material):
	material = m
	emit_signal("changed")


###########
# GETTERS #
###########
func get_texture(idx: int):
	return _get_element(idx, textures)


func get_texture_normal(idx: int):
	return _get_element(idx, texture_normals)


func get_texture_corner_inner(idx: int):
	return _get_element(idx, textures_corner_inner)


func get_texture_normal_corner_inner(idx: int):
	return _get_element(idx, texture_normals_corner_inner)


func get_texture_corner_outer(idx: int):
	return _get_element(idx, textures_corner_outer)


func get_texture_normal_corner_outer(idx: int):
	return _get_element(idx, texture_normals_corner_outer)


func get_texture_taper_left(idx: int):
	return _get_element(idx, textures_taper_left)


func get_texture_normal_taper_left(idx: int):
	return _get_element(idx, texture_normals_taper_left)


func get_texture_taper_right(idx: int):
	return _get_element(idx, textures_taper_right)


func get_texture_normal_taper_right(idx: int):
	return _get_element(idx, texture_normals_taper_right)


#########
# USAGE #
#########
func get_icon_texture() -> Texture2D:
	"""
	Returns main texture used to visually identify this edge material
	"""
	if not textures.is_empty():
		return textures[0]
	return null


############
# INTERNAL #
############
func _get_element(idx: int, a: Array):
	if a.is_empty():
		return null
	return a[_adjust_idx(idx, a)]


func _adjust_idx(idx: int, a: Array) -> int:
	return idx % a.size()
