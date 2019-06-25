extends Node2D

onready var host = get_parent().get_parent();
onready var ground = get_parent().get_node("Move_On_Ground");
onready var air = get_parent().get_node("Move_In_Air");
onready var ledge = get_parent().get_node("Ledge_Grab");

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