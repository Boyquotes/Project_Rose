extends "res://Objects/Actors/Enemies/Enemy.gd"

func _ready():
	states = {
	'default' : $States/Default,
	'chase' : $States/Chase,
	'hurt' : $States/Hurt,
	'stun' : $States/Stun,
	'attack' : $States/Attack
	};
	._ready();

func Kill():
	var part = preload("./Death_Particle.tscn").instance();
	get_parent().add_child(part);
	part.global_position = global_position;
	part.scale.x = Direction;
	.Kill();