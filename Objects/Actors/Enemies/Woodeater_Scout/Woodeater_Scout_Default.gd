extends "res://Objects/Actors/Enemies/Enemy_Flying_RandMove_Default_State.gd"

onready var chase = get_parent().get_node("Chase");

func handleAnimation():
	host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	if(host.canSeePlayer()):
		exit(chase);