extends "res://Objects/Actors/Enemies/Enemy.gd"

export(bool) var injured = false;


func _ready():
	states = {
	'default' : $States/Default,
	'chase' : $States/Chase,
	'hurt' : $States/Hurt,
	'stun' : $States/Stun,
	'attack' : $States/Attack,
	'backoff' : $States/Backoff
	};
	._ready();
	if(injured):
		break_shell();

func Kill():
	if(!injured):
		break_shell();
	var part = preload("./Death_Particle.tscn").instance();
	get_parent().add_child(part);
	part.global_position = global_position;
	part.scale.x = Direction;
	.Kill();

func break_shell():
	injured = true;
	var part = preload("res://Objects/Actors/Enemies/Kadbug/Kadbug_Shell_Particle.tscn").instance();
	get_parent().add_child(part);
	part.global_position = global_position;
	part.scale.x = Direction;
	
	$States/Hurt.vulnerable[0] = true;
	$States/Hurt.armor = [0,0,0,0];
	$Sprites/Sprite.texture = load("res://Assets/Sprites/Actors/Enemies/Kadbug/Kadbug_injured_Prototype.png");