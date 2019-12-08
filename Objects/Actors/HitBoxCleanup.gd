extends Node2D
var attached = false;
var follow;

func init():
	var time;
	var anim = $AnimationPlayer.get_animation("New Anim");
	time = anim.length;
	anim.track_insert_key(0,time,{"method": "cleanup", "args": []});
	$AnimationPlayer.play("New Anim");

func _process(delta):
	if(attached):
		global_position = follow.global_position;

func cleanup():
	queue_free();