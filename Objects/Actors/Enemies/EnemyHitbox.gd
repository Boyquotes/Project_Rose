extends Area2D

onready var host = get_parent();
var hittable = false;

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
export(ATTACK_TYPE) var attack_type;

func _on_HitBox_area_entered(area):
	if("knockback" in area):
		if(hittable):
			host.states['hurt'].damage_area = area;
			host.states['hurt'].mitigation = (global_position.distance_to(area.global_position) * sign(area.true_knockback))/10
			host.states['hurt'].knockback_type = area.knockback_type;
			host.states['hurt'].knockback = area.true_knockback;
			host.states['hurt'].damage = area.damage;
			host.states['hurt'].damage_type = area.attack_type;
			host.states[host.state].exit(host.states['hurt']);