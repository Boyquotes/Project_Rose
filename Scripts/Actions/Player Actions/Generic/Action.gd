class_name Action
extends Node2D

@export var cancelable := true
@export var flora_cost := 0
@export var focus_cost := 0

var action_spawn : Node2D
var host : Player

func start():
	if action_spawn:
		global_position = action_spawn.global_position
	if flora_cost:
		host.change_flora(-flora_cost)
	if focus_cost:
		host.change_focus(-focus_cost)
	
	$Animator.play("Action")
	var err := $Animator.connect("animation_finished",Callable(self,"_on_animation_finished").bind(),CONNECT_REFERENCE_COUNTED)
	if err != 0:
		printerr(err)

func _process(delta):
	execute(delta)

func execute(_delta):
	pass

func _physics_process(delta):
	phys_execute(delta)

func phys_execute(_delta):
	pass


func _on_animation_finished(_anim_name):
	queue_free()

func _on_player_hurt():
	if cancelable:
		queue_free()
