tool
class_name EnemyHitboxContainer
extends Node2D

const Hitbox = preload("res://Game Objects/Actors/Enemies/Generic/EnemyHitbox.tscn")

func create_child():
	var hb = Hitbox.instance()
	add_child(hb)
	hb.set_owner(get_tree().get_edited_scene_root())
	hb.child_box_paths = []
	hb.parent_box_paths = []
	hb.name = "EnemyHitbox"

func create_hitbox():
	var hb = Hitbox.instance()
	add_child(hb)
	hb.set_owner(get_tree().get_edited_scene_root())
	hb.child_box_paths = []
	hb.parent_box_paths = []
	hb.name = "EnemyHitbox"
	return hb

func check_box_paths(box_paths):
	var box_array := []
	for box_path in box_paths:
		var box = get_node(box_path)
		if box:
			box_array.append(box)
		else:
			box_paths.erase(box_path)
			return "try again"
	return box_array
