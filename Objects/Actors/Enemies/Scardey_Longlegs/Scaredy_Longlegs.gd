extends "res://Objects/Actors/Enemies/Enemy.gd"

export(bool) var injured = false;

func _ready():
	states = {
	'default' : $States/Default,
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