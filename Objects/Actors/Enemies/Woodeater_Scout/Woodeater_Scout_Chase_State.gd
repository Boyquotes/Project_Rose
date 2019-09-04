extends "res://Objects/Actors/Enemies/Enemy_Flying_Chase_State.gd"

onready var orbit = get_parent().get_node("Orbit");

func handleAnimation():
	host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	if(global_position.distance_to(host.player.global_position) <= host.attack_range):
		host.hspd = 0;
		host.velocity.x = 0;
		exit(orbit);
	.handleInput(event);