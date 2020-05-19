extends Area2D

onready var host = get_parent();
var hittable = false;

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
enum STUN_TYPE {FLINCHED, STUNNED, NILL}
var stun_type;
export(int) var HP = 10;
export(ATTACK_TYPE) var attack_type;
export(Dictionary) var vulnerabilities = {
	ATTACK_TYPE.SLASH : false,
	ATTACK_TYPE.BASH : false,
	ATTACK_TYPE.PIERCE : false,
	ATTACK_TYPE.TRUE : false,
}
export(Dictionary) var weaknesses = {
	ATTACK_TYPE.SLASH : false,
	ATTACK_TYPE.BASH : false,
	ATTACK_TYPE.PIERCE : false,
	ATTACK_TYPE.TRUE : false,
}
export(Dictionary) var armor = {
	ATTACK_TYPE.SLASH : 0,
	ATTACK_TYPE.BASH : 0,
	ATTACK_TYPE.PIERCE : 0,
	ATTACK_TYPE.TRUE : 0,
}


func _on_HitBox_area_entered(area):
	if(hittable):
		var damage = area.damage;
		damage = damage - armor[area.attack_type] * int(vulnerabilities[area.attack_type]);
		if(damage < 0):
			damage = 0;
		
		host.stun_damage += damage; #make stun damage heal over time
		host.hp -= damage;
		if(weaknesses[area.attack_type]):
			stun_type = STUN_TYPE.FLINCHED;
		if(HP <= 0):
			break_part();
		if(stun_type != STUN_TYPE.NILL):
			host.states['stun'].mitigation = (global_position.distance_to(area.global_position) * sign(area.true_knockback))/10
			host.states['stun'].knockback_type = area.knockback_type;
			host.states['stun'].knockback = area.true_knockback;
			host.states[host.state].exit(host.states['stun']); #have to actually write this.

func break_part():
	stun_type = STUN_TYPE.STUNNED;
