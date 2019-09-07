extends "res://Objects/Actors/Enemies/Enemy_ChaseAndAttack_State.gd"

onready var backoff = get_parent().get_node("Backoff");

func handleInput(event):
	if(Input.is_action_just_pressed("Jump") && host.player.on_floor()):
		exit(backoff);
	.handleInput(event);
