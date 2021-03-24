tool
class_name EnemyHitbox
extends Area2D

signal hitbox_broken

enum LockType {SINGLE, ALL}

export(int) var hit_points := 5
export(bool) var broken := false
export(NodePath) var host
export(LockType) var lock_type
export(ActionEnums.AttackType) var attack_type
export(ActionEnums.DisplacementType) var displacement_type
export(Array) var parent_box_paths := []
export(Array) var child_box_paths := []

var activated_displacement = ActionEnums.DisplacementType.None
var attack : Action
var parent_boxes
var child_boxes
var locked : bool

func _ready():
	
	if not Engine.editor_hint:
		if not child_box_paths:
			locked = false
		if broken:
			hit_points = 0

func _on_Area2D_area_entered(area):
	print("!!!")

func _process(delta):
	if not Engine.editor_hint:
		if not broken and hit_points <= 0:
			emit_signal("hitbox_broken", attack)
		if locked:
			var broke_count = 0
			for child in child_boxes:
				if child.broken:
					if lock_type == LockType.SINGLE:
						locked = false
					else:
						broke_count += 1
			if broke_count == child_boxes.size():
				locked = false
	if Engine.editor_hint and not get_parent() is Viewport:
		var clean_run = true
		while clean_run or child_boxes is String:
			child_boxes = get_parent().check_box_paths(child_box_paths)
			clean_run = false
		
		clean_run = true
		while clean_run or parent_boxes is String:
			parent_boxes = get_parent().check_box_paths(parent_box_paths)
			clean_run = false

func create_child():
	var hb = get_parent().create_hitbox()
	child_box_paths.push_back(get_parent().get_path_to(hb))
	hb.parent_box_paths.push_back(get_parent().get_path_to(self))

func create_parent():
	var hb = get_parent().create_hitbox()
	parent_box_paths.push_back(get_parent().get_path_to(hb))
	hb.child_box_paths.push_back(get_parent().get_path_to(self))


func _on_EnemyHitbox_hitbox_broken(attack : Action):
	broken = true
	if attack.displacement_type >= displacement_type:
		activated_displacement = displacement_type
	elif attack.displacement_type < displacement_type:
		activated_displacement = attack_type
	#animate break
	#apply effect
