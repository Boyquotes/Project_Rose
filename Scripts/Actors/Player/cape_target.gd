extends Node2D

signal z_index_changed

var z_change : int


func add_z_index(z : int):
	emit_signal("z_index_changed", z)


func _on_Rose_animation_changed():
	emit_signal("z_index_changed", 0)
