extends Area2D

onready var host = get_parent();
var hittable = false;



func _on_HitBox_area_entered(area):
	if("dam" in area):
		if(hittable):
			if(area.host.global_position >= global_position):
				host.Direction = -1;
			else:
				host.Direction = 1;
			host.hspd = area.knockback.x * host.Direction; 
			host.vspd = area.knockback.y;
			host.friction = 0;
			host.damaged = true;
			host.get_node("damage_timer").wait_time = area.attack;
			host.get_node("damage_timer").start();
	pass;
