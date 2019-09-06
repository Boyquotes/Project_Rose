extends "res://Objects/Actors/Enemies/Enemy_Attack_State.gd"

var inst;

func handleAnimation():
	if(!trigger):
		trigger = true;
		if(1 <= host.decision && host.decision <= 50 && host.actionTimer.time_left <= 0.1):
			host.animate(host.get_node("animator"),"Vslice", true);
			$cooldownTimer.wait_time = rand_range(1,3);
			$cooldownTimer.start();
		elif(51 <= host.decision && host.decision <= 100 && host.actionTimer.time_left <= 0.1):
			host.animate(host.get_node("animator"),"Hslice", true);
			$cooldownTimer.wait_time = rand_range(1,3);
			$cooldownTimer.start();
		else:
			trigger = false;

func execute(delta):
	pass;


func stomp():
	inst = preload("./StompAttack.tscn").instance();
	host.get_parent().add_child(inst);
	inst.global_position = global_position + Vector2(0,-32)
	inst.scale.x = host.Direction;
	inst.init();

func charge():
	host.deactivate_fric();
	host.hspd = host.true_mspd * 4 * host.Direction;
	inst = preload("./ChargeAttack.tscn").instance();
	add_child(inst);
	inst.global_position = global_position;
	inst.scale.x = host.Direction;
	inst.init();


func exit_default():
	exit(default);

func exit(state):
	host.activate_fric();
	if(is_instance_valid(inst)):
		inst.cleanup();
	inst = null;
	.exit(state);