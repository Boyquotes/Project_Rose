extends Area2D

onready var host = get_parent();
var hittable = false;



func _on_HitBox_area_entered(area):
	if("knockback" in area):
		if(hittable):
			host.deactivate_fric();
			host.deactivate_grav();
			#TODO: LINEAR knockback
			#below is AWAY knockback
			host.hspd = cos(get_angle_to(area.global_position)) * area.knockback * -1
			host.vspd = ((sin(get_angle_to(area.global_position)) * area.knockback) + 50) * -1
			host.damaged = true;
			host.get_node("damage_timer").start();
	pass;
