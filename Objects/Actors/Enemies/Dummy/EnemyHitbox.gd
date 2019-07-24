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
			
			hit_type = area.knockback_type;
			var mitigation = (global_position.distance_to(area.global_position) * sign(area.true_knockback))/10
			var knockback = area.true_knockback - mitigation;
			
			match(hit_type):
				HIT_TYPE.AWAY:
					host.hspd = cos(get_angle_to(area.global_position)) * knockback * -1;
					host.vspd = ((sin(get_angle_to(area.global_position)) * knockback) + (50 - abs(mitigation))) * -1;
				HIT_TYPE.LINEAR:
					var rad = atan2(area.host.vspd, area.host.hspd);
					host.hspd = cos(rad) * knockback;
					host.vspd = ((sin(rad) * knockback) + 50);
			
			host.hit = true;
			host.get_node("damage_timer").start();
	pass;
