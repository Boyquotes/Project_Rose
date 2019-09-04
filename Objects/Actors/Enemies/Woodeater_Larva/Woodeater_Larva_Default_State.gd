extends "res://Objects/Actors/Enemies/Enemy_State.gd"

onready var attack = get_parent().get_node("Attack");

func enter():
	host.state = 'default';

func handleAnimation():
	host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	if(host.canSeePlayer() && global_position.distance_to(host.player.global_position) <= host.attack_range && !attack.on_cooldown):
		exit(attack);
