extends Area2D

onready var host = get_parent();
var hittable = false;

enum HIT_TYPE {AWAY, LINEAR, VORTEX};
var hit_type;

func _on_HitBox_area_entered(area):
	if("knockback" in area):
		if(hittable):
			host.deactivate_fric();
			host.deactivate_grav();
			
			print(area.true_knockback);
			
			hit_type = area.knockback_type;
			match(hit_type):
				HIT_TYPE.AWAY:
					host.hspd = cos(get_angle_to(area.global_position)) * area.true_knockback * -1;
					host.vspd = ((sin(get_angle_to(area.global_position)) * area.true_knockback) + 50) * -1;
				HIT_TYPE.LINEAR:
					
					var rad = atan2(area.host.vspd, area.host.hspd);
					host.hspd = cos(rad) * area.true_knockback;
					host.vspd = ((sin(rad) * area.true_knockback) + 50);
			
			host.hit = true;
			host.get_node("damage_timer").start();
	pass;
