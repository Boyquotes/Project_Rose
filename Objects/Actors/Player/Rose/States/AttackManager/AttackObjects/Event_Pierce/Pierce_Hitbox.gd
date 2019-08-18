extends "../HitBoxParent.gd"

var spawned = false;

func _on_Area2D_area_entered(area):
	._on_Area2D_area_entered(area);
	if(!spawned):
		spawned = true;
		var rock = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Pierce/Pierce_Hit_Particle.tscn").instance();
		if(direction == 180):
			direction = -1;
			rock.scale.x *= -1
		else:
			direction = 1;
		host.get_parent().add_child(rock);
		var spc = get_world_2d().direct_space_state;
		var origin = get_child(0).global_position;
		var adjust1 = Vector2(50 * cos(rotation) - 0 * sin(rotation), 0 * cos(rotation) + 50 * sin(rotation));
		var adjust2 = Vector2(50 * cos(rotation) - -3 * sin(rotation), -3 * cos(rotation) + 50 * sin(rotation));
		var adjust3 = Vector2(50 * cos(rotation) - 3 * sin(rotation), 3 * cos(rotation) + 50 * sin(rotation));
		#rock.global_position = origin - adjust1;
		var result = spc.intersect_ray(origin - adjust1 * direction, origin + adjust1 * direction, [self], collision_mask);
		if(result):
			rock.global_position = result["position"];
		else:
			result = spc.intersect_ray(origin - adjust2 * direction, origin + adjust2 * direction, [self], collision_mask);
			if(result):
				rock.global_position = result["position"];
			else:
				result = spc.intersect_ray(origin - adjust3 * direction, origin + adjust3 * direction, [self], collision_mask);
				if(result):
					rock.global_position = result["position"];
				else:
					rock.global_position = Vector2((origin.x + area.global_position.x)/2,(origin.y + area.global_position.y)/2);