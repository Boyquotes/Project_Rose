extends Node2D

onready var host = get_parent().get_parent();
onready var attack = get_parent().get_node("Attack");
onready var vault = get_parent().get_node("Vault");
onready var animator = get_parent().get_parent().get_node("animator");

func enter():
	pass;

func handleAnimation():
	pass;

func handleInput(event):
	pass;

func execute(delta):
	pass;

func exit(state):
	host.states[state].enter();
	pass;

func exit_g_or_a():
	if(host.on_floor()):
		exit('move_on_ground');
	else:
		exit('move_in_air');
	pass;