extends Node2D
var attached = false;

func init():
	var time;
	var anim = $AnimationPlayer.get_animation("New Anim");
	time = anim.length;
	anim.track_insert_key(0,time,{"method": "cleanup", "args": []});
	$AnimationPlayer.play("New Anim");

func cleanup():
	$Area2D.rotation_degrees = 0
	$Area2D.inchdir = 1;
	queue_free();