extends "res://Objects/Actors/Enemies/Enemy_Attack_State.gd"

func handleAnimation():
	if(!trigger):
		trigger = true;
		#if(1 <= host.decision && host.decision <= 50 && host.actionTimer.time_left <= 0.1):
		host.animate(host.get_node("animator"),"stomp", true);
		$cooldownTimer.wait_time = 4;
		$cooldownTimer.start();
		#elif(51 <= host.decision && host.decision <= 100 && host.actionTimer.time_left <= 0.1):
		#	host.animate(host.get_node("animator"),"charge", true);
		#else:
		#	trigger = false;

func stomp():
	var inst = preload("./StompAttack.tscn").instance();
	host.get_parent().add_child(inst);
	inst.global_position = global_position + Vector2(0,-32)
	inst.scale.x = host.Direction;
	inst.init();

func exit_default():
	exit(default);
