extends Node2D

func _ready():
	$AnimationPlayer.play("New Anim");
	pass;


func _on_StartButton_pressed():
	$menu_select.play();
	$AnimationPlayer2.play("start");
	pass;


func _on_AudioStreamPlayer_finished():
	#play();
	pass;


func _on_AnimationPlayer2_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Test_Scene.tscn")
	pass

func _on_StartButton_mouse_entered():
	$menu_move.play();
	pass;

func _on_patreonButton_pressed():
	OS.shell_open("https://www.patreon.com/Tyo");
	pass;

func _on_twitterButton_pressed():
	OS.shell_open("https://twitter.com/tyodevs");
	pass;


func _on_twitchButton_pressed():
	OS.shell_open("https://www.twitch.tv/tyodevs");
	pass;


func _on_youtubeButton_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCLifYFuLPaQwH7YdtBh1uuA");
	pass;
