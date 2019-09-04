extends "res://Objects/Actors/Enemies/Enemy_State.gd"

var animated = false;
var on_cooldown = false;
var attack_target;
export(float) var attack_speed = 400;


func enter():
	on_cooldown = true;
	attack_target = host.player.global_position;
	host.state = 'attack';

func handleAnimation():
	if(!animated):
		animated = true;
		host.animate(host.get_node("animator"),"attack", true);

func execute(delta):
	if(!host.canSeePlayer() || !global_position.distance_to(host.player.global_position) <= host.attack_range):
		exit(default);

func spawn_projectile():
	var ball = preload("./Spit.tscn").instance();
	host.get_parent().add_child(ball);
	ball.global_position = global_position;
	var tx = -cos(global_position.angle_to_point(attack_target)) * attack_speed;
	var ty = -sin(global_position.angle_to_point(attack_target)) * attack_speed;
	ball.apply_impulse(Vector2(0,0),Vector2(tx,ty - 25));
	$cooldownTimer.wait_time = rand_range(3,5);
	$cooldownTimer.start();

func exit_default():
	exit(default);

func exit(state):
	animated = false;
	.exit(state);

func _on_cooldownTimer_timeout():
	on_cooldown = false;
