extends "res://Objects/Actors/Enemies/Enemy_RandMove_Default_State.gd"

onready var runaway = get_parent().get_node("Runaway");

func handleInput(event):
	if(host.canSeePlayer()):
		host.start_getaway();
		exit(runaway);