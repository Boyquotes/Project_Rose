extends Node2D

signal z_index_changed

var z_change : int


func add_z_index(z : int):
	z_index += z
	print(z_index)
	z_change = z
	emit_signal("z_index_changed")


func _on_BaseAnimator_animation_changed(old_name, new_name):
	
	z_index = 0
	z_change = -z_change
	emit_signal("z_index_changed")
