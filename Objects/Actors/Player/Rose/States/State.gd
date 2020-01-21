extends Node2D

onready var host = get_parent().get_parent();

func get_attack_pressed():
	return (
	Input.is_action_pressed("Slash_Attack") || 
	Input.is_action_pressed("Dodge") ||
	Input.is_action_pressed("Pierce_Attack") ||
	Input.is_action_pressed("Bash_Attack"));

func get_attack_just_pressed():
	return (
	Input.is_action_just_pressed("Slash_Attack") || 
	Input.is_action_just_pressed("Dodge") ||
	Input.is_action_just_pressed("Pierce_Attack") ||
	Input.is_action_just_pressed("Bash_Attack"));

func enter():
	pass;

func handleAnimation():
	pass;

func handleInput():
	pass;

func execute(delta):
	pass;

func pausedExecute(delta):
	pass;

func pausedHandleAnimation():
	pass;

func pausedHandleInput():
	pass;


func exit(state):
	state.enter();
	pass;