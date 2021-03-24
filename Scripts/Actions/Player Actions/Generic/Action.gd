class_name Action
extends Node2D

export(int) var cost := 5

var host
var action_controller
var action_instancer
var follow_target

func start():
	$Animator.play("Action")
	var err := $Animator.connect("animation_finished", self, "_on_animation_finished", [], CONNECT_REFERENCE_COUNTED)
	if err != 0:
		printerr(err)

func _process(delta):
	execute(delta)

func execute(_delta):
	if follow_target:
		global_position = follow_target.global_position

func _physics_process(delta):
	phys_execute(delta)

func phys_execute(_delta):
	pass


func _on_animation_finished(_anim_name):
	action_instancer.dequeue_action(self)
