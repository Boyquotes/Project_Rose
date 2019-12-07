extends Node2D
var direction;
var host;

func launch(dir = -90):
	$TetherSpear/Area2D.host = host;
	direction = dir;
	$Timer.start(rand_range(0.01,0.5));

func _on_Timer_timeout():
	$TetherSpear/Area2D.direction = direction;
	$TetherSpear.rotation_degrees = direction;
	var x = cos(deg2rad(direction)) * 200;
	var y = sin(deg2rad(direction)) * 200;
	$TetherSpear.apply_impulse(Vector2(0,0),Vector2(x,y));
	$AnimationPlayer.play("New Anim");
