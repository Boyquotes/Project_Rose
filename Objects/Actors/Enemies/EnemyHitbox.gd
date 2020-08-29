extends Area2D

onready var host = get_parent();
var hittable = false;

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
enum STUN_TYPE {KNOCKED, FLINCHED, STUNNED, NILL}
enum RESISTANCE {IMMUNE, VULNERABLE, WEAK}
var stun_type;
export(int) var HP = 10;
export(Dictionary) var info = {
	"SLASH" : {"Resistance Type" : RESISTANCE.VULNERABLE, "Armor" : 0},
	"BASH" : {"Resistance Type" : RESISTANCE.VULNERABLE, "Armor" : 0},
	"PIERCE" : {"Resistance Type" : RESISTANCE.VULNERABLE, "Armor" : 0},
	"TRUE" : {"Resistance Type" : RESISTANCE.WEAK, "Armor" : 0},
}


func _on_HitBox_area_entered(area):
	if("knockback" in area):
		if(hittable):
			var atk_type = info.keys()[info.keys().find(ATTACK_TYPE.keys()[area.attack_type])];
			
			var damage = area.damage;
			damage = (damage - info[atk_type]["Armor"]) * int(info[atk_type]["Resistance Type"]);
			if(damage < 0):
				damage = 0;
			
			host.hp -= damage;
			HP -= damage;
			
			#if the knockback type allows for knocking back without stunning
				#stun_type = STUN_TYPE.KNOCKED
			if(info[atk_type]["Resistance Type"] == RESISTANCE.WEAK):
				stun_type = STUN_TYPE.FLINCHED;
			if(HP <= 0):
				break_part();
			if(stun_type != STUN_TYPE.NILL):
				host.states['stun'].stun_type = stun_type;
				host.states['stun'].knockback_type = area.knockback_type;
				host.states['stun'].knockback = area.true_knockback;
				host.states[host.state].exit(host.states['stun']); #have to actually write this.
				stun_type = STUN_TYPE.NILL;

func break_part():
	stun_type = STUN_TYPE.STUNNED;
