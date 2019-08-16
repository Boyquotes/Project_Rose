extends Area2D

enum ATTACK_TYPE {SLASH, BASH, PIERCE};
enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};

export(float) var knockback;
export(KNOCKBACK_TYPE) var knockback_type;
export(ATTACK_TYPE) var attack_type;
export(float) var direction;
export(float) var inchdir = 1;
export(bool) var deactivate_with_time = false;
export(int) var hit_limit = 0;
var hits = 0;
var true_knockback = 0;

var calc_direction = true;

func _ready():
	true_knockback = knockback;
	if(deactivate_with_time):
		$AnimationPlayer.play("New Anim");

func _physics_process(delta):
	true_knockback -= 3;
	if(true_knockback <= 0):
		true_knockback = 0;

var host;

func _on_RigidBody2D_body_entered(body):
	pass;

func _on_Area2D_area_entered(area):
	hits += 1;
	if(hits >= hit_limit && hit_limit > 0):
		get_child(0).call_deferred("disabled",true);