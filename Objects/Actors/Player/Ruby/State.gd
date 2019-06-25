extends Node2D

onready var host = get_parent().get_parent();
#onready var attack_controller = get_parent().get_parent().get_node("Attack_Controller");

func enter():
	pass;

func handleAnimation():
	pass;

func handleInput():
	pass;

func execute(delta):
	pass;

func exit(state):
	state.enter();
	pass;