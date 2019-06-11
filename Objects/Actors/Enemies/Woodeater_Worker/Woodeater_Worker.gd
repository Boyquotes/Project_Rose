extends "res://Objects/Actors/Enemies/Enemy.gd"

func _ready():
	states = {
	'default' : $States/Default,
	'chase' : $States/Chase,
	'attack' : $States/Attack
	}
	
	max_hp = 1;
	damage = 1;
	mspd = 100;
	jspd = 50;
	hp = max_hp;
	pass;
