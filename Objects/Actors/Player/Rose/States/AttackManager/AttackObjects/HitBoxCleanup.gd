extends Node2D

export(float) var time = .2;

func _ready():
	var anim = $AnimationPlayer.get_animation("New Anim");
	anim.length = time;
	anim.track_insert_key(0,time,{"method": "cleanup", "args": []});
	$AnimationPlayer.play("New Anim");

func cleanup():
	$Area2D.rotation_degrees = 0
	$Area2D.inchdir = 1;
	queue_free();