extends Node2D

onready var host = get_parent().get_parent();

func get_attack_pressed():
	return (Input.is_action_pressed("attack") || Input.is_action_pressed("dodge") || Input.is_action_pressed("special"));

func get_attack_just_pressed():
	return (Input.is_action_just_pressed("attack") || Input.is_action_just_pressed("dodge") || Input.is_action_just_pressed("special"));

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