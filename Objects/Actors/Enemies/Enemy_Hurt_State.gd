extends "res://Objects/Actors/Enemies/Enemy_State.gd"

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};

export(Array, bool) var vulnerable = [false,false,false,false];
export(Array, int) var armor = [0,0,0,0];
var tinch = 0;
var damage = 0;
var damage_type;
var knockback_type;
var damage_area;
var mitigation;
var knockback;

func enter():
	host.deactivate_fric();
	host.deactivate_grav();
	host.state = 'hurt';
	$Damage_Timer.start();
	damage = damage + damage * .5 * int(vulnerable[damage_type]) - armor[damage_type];
	if(damage < 0):
		damage = 0;
	match(damage_type):
		ATTACK_TYPE.SLASH:
			slash_damage();
		ATTACK_TYPE.BASH:
			bash_damage();
		ATTACK_TYPE.PIERCE:
			pierce_damage();
		ATTACK_TYPE.TRUE:
			true_damage();
	host.hp -= damage;

func handleAnimation():
	pass;

func handleInput(event):
	if(host.stun_damage >= host.stun_threshold):
		stunned();

func execute(delta):
	if(abs(host.hspd) > 0):
		if(abs(host.hspd) < 2):
			host.hspd = 0;
		host.hspd -= 2 * sign(host.hspd);
	if(abs(host.vspd) > 0):
		if(abs(host.vspd) < 3):
			host.vspd = 0;
		host.vspd -= 3 * sign(host.vspd);

func exit(state):
	if(state != hurt):
		damage_type = null;
		damage = 0;
		knockback_type = null;
		damage_area = null;
		mitigation = null;
		knockback = null;
	$Damage_Timer.stop();
	.exit(state)

func _on_Damage_Timer_timeout():
	$Damage_Timer.wait_time = 0.5;
	exit(default);
	host.activate_fric();
	host.activate_grav();

func normal_knockback():
	match(knockback_type):
		KNOCKBACK_TYPE.AWAY:
			host.hspd = cos(get_angle_to(damage_area.global_position)) * knockback * -1;
			host.vspd = ((sin(get_angle_to(damage_area.global_position)) * knockback) + (tinch*sign(tinch) - abs(mitigation))) * -1;
		KNOCKBACK_TYPE.LINEAR:
			var rad = atan2(damage_area.host.vspd, damage_area.host.hspd);
			host.hspd = cos(rad) * knockback;
			host.vspd = ((sin(rad) * knockback) + tinch);
		KNOCKBACK_TYPE.DIRECTIONAL:
			host.hspd = cos(deg2rad(damage_area.direction)) * knockback;
			host.vspd = ((sin(deg2rad(damage_area.direction)) * knockback) + tinch);

func slash_damage():
	pass;
func bash_damage():
	pass;
func pierce_damage():
	pass;
func true_damage():
	pass;
func stunned():
	host.stun_damage = 0;
	exit(stun);