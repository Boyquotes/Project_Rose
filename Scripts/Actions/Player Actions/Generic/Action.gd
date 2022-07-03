class_name Action
extends Node2D

export(bool) var cancelable := true
export(int) var flora_cost := 0
export(bool) var expend_focus := false

var action_spawn : Node2D
var host : Player

func start():
	if action_spawn:
		global_position = action_spawn.global_position
	if flora_cost:
		host.change_flora(-flora_cost)
	if expend_focus:
		host.change_focus(-1)
	
	$Animator.play("Action")
	var err := $Animator.connect("animation_finished", self, "_on_animation_finished", [], CONNECT_REFERENCE_COUNTED)
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
