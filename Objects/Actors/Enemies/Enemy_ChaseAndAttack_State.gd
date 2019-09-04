extends "res://Objects/Actors/Enemies/Enemy_Chase_State.gd"

onready var attack = get_parent().get_node("Attack");

func handleInput(event):
	if(global_position.distance_to(host.player.global_position) <= host.attack_range && !attack.on_cooldown):
		host.hspd = 0;
		host.velocity.x = 0;
		exit(attack);
	.handleInput(event);