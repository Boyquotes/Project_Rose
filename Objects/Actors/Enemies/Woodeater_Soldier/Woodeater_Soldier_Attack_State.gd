extends "res://Objects/Actors/Enemies/Enemy_Attack_State.gd"

var inst;

func handleAnimation():
	if(!trigger):
		trigger = true;
		if(1 <= host.decision && host.decision <= 50 && host.actionTimer.time_left <= 0.1):
			host.animate(host.get_node("animator"),"stomp", true);
			$cooldownTimer.wait_time = 4;
			$cooldownTimer.start();
		elif(51 <= host.decision && host.decision <= 100 && host.actionTimer.time_left <= 0.1):
			host.animate(host.get_node("animator"),"charge", true);
			$cooldownTimer.wait_time = 3;
			$cooldownTimer.start();
		else:
			trigger = false;

func execute(delta):
	if(host.is_on_wall()):
		if(is_instance_valid(inst)):
			inst.cleanup();
		exit(stun);

func stomp():
	inst = preload("./StompAttack.tscn").instance();
	host.get_parent().add_child(inst);
	set_hitbox_attached(inst);
	inst.init();

func charge():
	host.deactivate_fric();
	host.hspd = host.true_mspd * 4 * host.Direction;
	inst = preload("./ChargeAttack.tscn").instance();
	add_child(inst);
	set_hitbox_attached(inst);
	inst.init();

func exit_default():
	exit(default);

func exit(state):
	host.activate_fric();
	if(is_instance_valid(inst)):
		inst.cleanup();
	inst = null;
	.exit(state);