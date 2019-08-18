extends Node2D

func init(time):
	var anim = $AnimationPlayer.get_animation("New Anim");
	anim.length = time;
	anim.track_insert_key(0,time,{"method": "cleanup", "args": []});
	$AnimationPlayer.play("New Anim");

func cleanup():
	$Area2D.rotation_degrees = 0
	$Area2D.inchdir = 1;
	queue_free();