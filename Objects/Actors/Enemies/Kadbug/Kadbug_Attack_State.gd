extends "res://Objects/Actors/Enemies/Enemy_Attack_State.gd"

onready var backoff = get_parent().get_node("Backoff");

var inst;

func handleAnimation():
	host.makeDecision();
	if(!trigger):
		trigger = true;
		host.hspd = 200 * host.Direction;
		if(1 <= host.decision && host.decision <= 50):
			host.animate(host.get_node("animator"),"Vslice", true);
			$cooldownTimer.wait_time = rand_range(.2,1);
			$cooldownTimer.start();
		elif(51 <= host.decision && host.decision <= 100):
			host.animate(host.get_node("animator"),"Hslice", true);
			$cooldownTimer.wait_time = rand_range(.2,1);
			$cooldownTimer.start();

func handleInput(event):
	if(Input.is_action_just_pressed("Jump") && host.player.on_floor()):
		on_cooldown = false;
		exit(backoff);

func vslice():
	inst = preload("./vslice.tscn").instance();
	add_child(inst);
	inst.global_position = global_position;
	inst.scale.x = host.Direction;
	inst.init();

func hslice():
	host.deactivate_fric();
	inst = preload("./hslice.tscn").instance();
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
