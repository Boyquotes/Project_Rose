class_name State
extends Node2D

onready var host = get_parent().get_parent();

func _enter():
	pass;

func _handle_animation():
	pass;

func _handle_input():
	pass;

func _execute(delta):
	pass;

func _paused_execute(delta):
	pass;

func _paused_handle_animation():
	pass;

func _paused_handle_input():
	pass;


func _exit(state):
	state._enter();
