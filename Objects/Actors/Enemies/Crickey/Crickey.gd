extends "res://Objects/Actors/Enemies/Enemy.gd"

func _ready():
	states = {
	'default' : $States/Default,
	'runaway' : $States/Runaway,
	'hurt' : $States/Hurt,
	'stun' : $States/Stun
	};
	._ready();

func Kill():
	var part = preload("./Death_Particle.tscn").instance();
	get_parent().add_child(part);
	part.global_position = global_position;
	part.scale.x = Direction;
	.Kill();

func start_getaway():
	$getawayTimer.start();

func _on_getawayTimer_timeout():
	queue_free();
