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

func exit(state):
	trigger = false;
	animated = false;
	.exit(state);

func _on_cooldownTimer_timeout():
	on_cooldown = false;
