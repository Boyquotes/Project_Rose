extends Node2D
var attached = false;
var follow;
var host;

func init():
	var time;
	var anim = $AnimationPlayer.get_animation("New Anim");
	time = anim.length;
	anim.track_insert_key(0,time,{"method": "cleanup", "args": []});
	$AnimationPlayer.play("New Anim");
	$AnimationPlayer.connect("animation_finished",self,"_on_AnimationPlayer_animation_finished");

func _process(delta):
	if(attached):
		global_position = follow.global_position;

func cleanup():
	host.cleanup();

func _on_AnimationPlayer_animation_finished(anim_name):
	cleanup();
