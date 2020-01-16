extends "res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/HitBoxParent.gd"

func _ready():
	host = get_parent().get_parent().get_parent();

func _on_ChargeAttackBox_area_entered(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.1, 15, 8);
	if(mark):
		area.host.mark = attack_type;