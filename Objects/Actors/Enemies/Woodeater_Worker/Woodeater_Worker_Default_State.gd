extends "res://Objects/Actors/Enemies/Enemy_Default_State.gd"

onready var chase = get_parent().get_node("Chase");

func handleInput(event):
	if(host.canSeePlayer()):
		exit(chase);