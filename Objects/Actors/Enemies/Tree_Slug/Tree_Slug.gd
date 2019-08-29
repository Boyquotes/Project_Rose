extends "res://Objects/Actors/Enemies/Enemy.gd"

func _ready():
	states = {
	'default' : $States/Default,
	'hurt' : $States/Hurt,
	'stun' : $States/Stun
	};
	._ready();

func Kill():
	enabled = false;
	$Sprites.visible = false;
	var part = preload("res://Objects/Actors/Enemies/Tree_Slug/Tree_Slug_Death_Particle.tscn").instance();
	get_parent().add_child(part);
	part.global_position = global_position;
	part.scale.x = Direction;
	.Kill();