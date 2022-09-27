@tool
extends Node2D

const DEBUG_DRAW_LINE_LENGTH = 128.0

class_name SS2D_Shape_Anchor, "../assets/Anchor.svg"

@export (NodePath) var shape_path: NodePath :
	get:
		return shape_path # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_shape_path
@export (int) var shape_point_index: int = 0 :
	get:
		return shape_point_index # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_shape_point_index
@export (float, 0.0, 1.0) var shape_point_offset: float = 0.0 :
	get:
		return shape_point_offset # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_shape_point_offset
@export (float, 0, 3.14) var child_rotation: float = 3.14 :
	get:
		return child_rotation # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_child_rotation
@export (bool) var use_shape_scale: bool = false :
	get:
		return use_shape_scale # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_use_shape_scale

@export (bool) var debug_draw: bool = false :
	get:
		return debug_draw # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_debug_draw

var cached_shape_transform:Transform2D = Transform2D.IDENTITY
var shape = null


###########
# SETTERS #
###########
func set_shape_path(value: NodePath):
	# Assign path value
	shape_path = value
	set_shape()

	notify_property_list_changed()
	refresh()

func set_shape():
	# Disconnect old shape
	if shape != null:
		disconnect_shape(shape)

	# Set shape if path is valid and connect
	shape = null
	if has_node(shape_path):
		var new_node = get_node(shape_path)
		if not new_node is SS2D_Shape_Base:
			push_error("Shape3D Path3D isn't a valid subtype of SS2D_Shape_Base! Aborting...")
			return
		shape = new_node
		connect_shape(shape)
		shape_point_index = get_shape_index_range(shape, shape_point_index)



func get_shape_index_range(s:SS2D_Shape_Base, idx:int)->int:
	var point_count = s.get_point_count()
	# Subtract 2;
	#   'point_count' is out of bounds; subtract 1
	#   cannot use final idx as starting point_index; subtract another 1
	var final_idx = point_count - 2
	if idx < 0:
		idx = final_idx
	idx = idx % (final_idx + 1)
	return idx

func set_shape_point_index(value: int):
	if value == shape_point_index:
		return

	if shape == null:
		shape_point_index = value
		return

	shape_point_index = get_shape_index_range(shape, value)
	#notify_property_list_changed()
	refresh()


func set_shape_point_offset(value: float):
	shape_point_offset = value
	#notify_property_list_changed()
	refresh()


func set_use_shape_scale(value: bool):
	use_shape_scale = value
	#notify_property_list_changed()
	refresh()


func set_child_rotation(value: float):
	child_rotation = value
	#notify_property_list_changed()
	refresh()


func set_debug_draw(v: bool):
	debug_draw = v
	#notify_property_list_changed()
	refresh()


##########
# EVENTS #
##########
func _process(delta):
	if shape == null:
		set_shape()
		return
	if shape.is_queued_for_deletion():
		return
	if shape.get_global_transform() != cached_shape_transform:
		cached_shape_transform = shape.get_global_transform()
		refresh()


func _monitored_node_leaving():
	set_shape_path("")


func _handle_point_change():
	refresh()


#########
# LOGIC #
#########
func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s


func disconnect_shape(s: SS2D_Shape_Base):
	s.disconnect("points_modified",Callable(self,"_handle_point_change"))
	s.disconnect("tree_exiting",Callable(self,"_monitored_node_leaving"))


func connect_shape(s: SS2D_Shape_Base):
	s.connect("points_modified",Callable(self,"_handle_point_change"))
	s.connect("tree_exiting",Callable(self,"_monitored_node_leaving"))


func refresh():
	if shape == null:
		return
	if not is_instance_valid(shape):
		return
	if shape.is_queued_for_deletion():
		disconnect_shape(shape)
		shape = null
		return

	# Subtract one, cannot use final point as starting index
	var point_count = shape.get_point_count() - 1

	var pt_a_index = shape_point_index
	var pt_b_index = shape_point_index + 1
	var pt_a_key = shape.get_point_key_at_index(pt_a_index)
	var pt_b_key = shape.get_point_key_at_index(pt_b_index)

	var pt_a: Vector2 = shape.global_transform * shape.get_point_position(pt_a_key)
	var pt_b: Vector2 = shape.global_transform * shape.get_point_position(pt_b_key)

	var pt_a_handle: Vector2
	var pt_b_handle: Vector2

	var n_pt: Vector2
	var n_pt_a: Vector2
	var n_pt_b: Vector2

	var angle = 0.0

	pt_a_handle = shape.global_transform.xform(
		shape.get_point_position(pt_a_key) + shape.get_point_out(pt_a_key)
	)
	pt_b_handle = shape.global_transform.xform(
		shape.get_point_position(pt_b_key) + shape.get_point_in(pt_b_key)
	)

	n_pt = _cubic_bezier(pt_a, pt_a_handle, pt_b_handle, pt_b, shape_point_offset)
	n_pt_a = _cubic_bezier(
		pt_a, pt_a_handle, pt_b_handle, pt_b, clamp(shape_point_offset - 0.1, 0.0, 1.0)
	)
	n_pt_b = _cubic_bezier(
		pt_a, pt_a_handle, pt_b_handle, pt_b, clamp(shape_point_offset + 0.1, 0.0, 1.0)
	)

	angle = atan2(n_pt_a.y - n_pt_b.y, n_pt_a.x - n_pt_b.x)

	self.global_transform = Transform2D(angle + child_rotation, n_pt)

	if use_shape_scale:
		self.scale = shape.scale

	update()


func _draw():
	if Engine.editor_hint and debug_draw:
		draw_line(Vector2.ZERO, Vector2(0, -DEBUG_DRAW_LINE_LENGTH), self.modulate)
