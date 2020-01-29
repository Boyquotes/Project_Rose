extends "res://Objects/Actors/Enemies/Enemy_State.gd"

var animated = false;
var on_cooldown = false;
export(bool)var trigger = false;
export(float) var attack_speed = 400;

func _ready():
	trigger = false;

func enter():
	on_cooldown = true;
	host.state = 'attack';
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			turn_around();
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			turn_around();

func exit(state):
	trigger = false;
	animated = false;
	.exit(state);

func _on_cooldownTimer_timeout():
	on_cooldown = false;

func set_hitbox_attached(var inst):
	set_hitbox(inst);
	inst.host = host;

func set_hitbox(var inst):
	inst.global_position = global_position;
	inst.scale.x = host.Direction;