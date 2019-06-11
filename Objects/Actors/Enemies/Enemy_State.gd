extends Node2D

onready var host = get_parent().get_parent();
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