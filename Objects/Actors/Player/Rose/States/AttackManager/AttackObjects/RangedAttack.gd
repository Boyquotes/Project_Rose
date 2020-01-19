extends "res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/HitBoxParent.gd"

func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in host.targettable_hitboxes:
		item.hittable = nextRay(self,item,space_state);
