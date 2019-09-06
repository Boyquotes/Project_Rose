extends "res://Objects/Actors/Enemies/Enemy_Attack_State.gd"

onready var orbit = get_parent().get_node("Orbit");
var attack_target;
var charged = false;

func enter():
	$cooldownTimer.wait_time = rand_range(1.5,4);
	$cooldownTimer.start();
	.enter();

func handleAnimation():
	#TODO: Spawn attack instance during attack animation
	if(!charged):
		charged = true;
		host.animate(host.get_node("animator"),"charge", true);
	if(trigger):
		trigger = false;
		attack_target = host.player.global_position;
		host.animate(host.get_node("animator"),"attack", true);

func thrust():
	host.hspd = -cos(global_position.angle_to_point(attack_target)) * attack_speed;
	host.vspd = -sin(global_position.angle_to_point(attack_target)) * attack_speed;

func pull():
	host.hspd = cos(global_position.angle_to_point(attack_target)) * attack_speed;
	host.vspd = sin(global_position.angle_to_point(attack_target)) * attack_speed;

func exit_orbit():
	exit(orbit);

func exit(state):
	charged = false;
	attack_target = null;
	.exit(state);