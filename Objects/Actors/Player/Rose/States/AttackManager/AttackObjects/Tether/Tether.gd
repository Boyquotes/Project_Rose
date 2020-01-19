extends Node2D
var direction;
var host;

func launch(dir = -90):
	$TetherSpear/Area2D.host = host;
	direction = dir;
	$TetherSpear.rotation_degrees = direction;
	$TetherTimer.start(rand_range(0.01,0.5));

func cleanup():
	host.cleanup();

func _on_TetherTimer_timeout():
	$TetherSpear/Area2D.direction = direction;
	
	var x = cos(deg2rad(direction)) * 200;
	var y = sin(deg2rad(direction)) * 200;
	$TetherSpear.apply_impulse(Vector2(0,0),Vector2(x,y));
	$AnimationPlayer.play("New Anim");


func _on_CleanupTimer_timeout():
	cleanup();
