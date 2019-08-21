extends Area2D

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};

export(float) var knockback;
export(KNOCKBACK_TYPE) var knockback_type;
export(ATTACK_TYPE) var attack_type;
export(float) var direction;
export(float) var inchdir = 1;
export(int) var hit_limit = 0;
export(bool) var absorbing = true;
var hits = 0;
var true_knockback = 0;
var calc_direction = true;

func _ready():
	true_knockback = knockback;

func _physics_process(delta):
	true_knockback -= 3;
	if(true_knockback <= 0):
		true_knockback = 0;

var host;
var attack_controller;

func _on_Area2D_area_entered(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.1, 15, 8);
		hits += 1;
		if(hits >= hit_limit && hit_limit > 0):
			get_child(0).call_deferred("disabled",true);
		if(absorbing):
			host.change_mana(5);
		if(attack_controller):
			attack_controller.on_hit(area);