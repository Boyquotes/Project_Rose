extends Node2D

onready var host = get_parent().get_parent();

func get_attack_pressed():
	return (
	Input.is_action_pressed("slash_attack") || 
	Input.is_action_pressed("dodge") || abs(Input.get_joy_axis(0,2)) >= .5 || abs(Input.get_joy_axis(0,3)) >= .5 ||
	Input.is_action_pressed("pierce_attack") ||
	Input.is_action_pressed("bash_attack"));

func get_attack_just_pressed():
	return (
	Input.is_action_just_pressed("slash_attack") || 
	Input.is_action_just_released("slash_attack") ||
	Input.is_action_just_pressed("dodge") || abs(Input.get_joy_axis(0,2)) >= .5 || abs(Input.get_joy_axis(0,3)) >= .5 ||
	Input.is_action_just_pressed("pierce_attack") ||
	Input.is_action_just_pressed("bash_attack"));

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