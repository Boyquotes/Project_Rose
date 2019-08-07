extends "./Free_Motion_State.gd"

onready var attack_manager = get_node("Attack_Manager");

var leave = false;
var busy = false;
var hover = false;
var hop = false;
var attack_broken = false;
export(bool) var mobile = true;

onready var ComboTimer = get_node("ComboTimer");

### Initialize Attack States ###
func _ready():
	$Attack_Manager.host = host;

func enter():
	host.move_state = 'attack';
	attack_manager.enter();
	if(Input.is_action_just_pressed("attack")):
		attack_manager.X = true;
	elif(Input.is_action_just_pressed("dodge")):
		attack_manager.B = true;
	elif(Input.is_action_just_pressed("special")):
		attack_manager.Y = true;

func handleAnimation():
	attack_manager.handleAnimation();

func handleInput():
	attack_manager.handleInput();
	
	### for leaving the attack state early ###
	if(!get_attack_pressed() && (attack_manager.save_event || attack_manager.attack_end)):
		if(!attack_manager.attack_is_saved):
			if(Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("up") || Input.is_action_pressed("down")):
				leave = true;
			else:
				leave = false;
	if(get_attack_just_pressed() || get_attack_pressed() || attack_manager.attack_start):
		leave = false;
	if(attack_manager.dodge_interrupt || !busy):
		if(Input.is_action_just_pressed("jump") && attack_manager.hit && !host.on_floor()):
			air.jump = true;
			leave = true;
			attack_broken = true;
		if(Input.is_action_just_pressed("jump") && host.on_floor()):
			ground.jump = true;
			leave = true;
			attack_broken = true;
	
	if(leave && (attack_manager.interrupt || attack_manager.attack_end)):
		attack_manager.attack_done();
		exit_g_or_a();
	if(leave && attack_broken):
		host.get_node("AttackParticles")._on_particleTimer_timeout();
		attack_manager.attack_done();
		exit_g_or_a();

func execute(delta):
	### Determining player movement from attacks ###
	if(mobile):
		.execute(delta);
	else:
		if(!host.on_floor() && (host.mspd >= abs(host.hspd)) && attack_manager.hit && hover):
			host.hspd += acceleration/4 * host.Direction;
			host.vspd -= acceleration/15;
		elif(!host.on_floor() && !(abs(host.hspd) > host.mspd) && hop):
			var input_direction = get_aim_direction();
			update_look_direction_and_scale(input_direction);
			host.hspd += acceleration * host.Direction;
		elif(!host.on_floor() && !(abs(host.hspd) > host.mspd) && attack_manager.hit && attack_manager.vdir == "_Up"):
			host.vspd -= acceleration/15;
		else:
			if(host.hspd != 0 && abs(host.hspd) > host.mspd && host.fric_activated):
				host.hspd -= 20 * sign(host.hspd);
			elif(host.fric_activated):
				host.hspd = 0;
	
	attack_manager.execute(delta);

func exit_g_or_a():
	match(host.on_floor()):
		true:
			exit(ground)
		false:
			exit(air);

func exit(state):
	leave = false;
	busy = false;
	attack_broken = false;
	attack_manager.slottedx = false;
	attack_manager.slottedy = false;
	attack_manager.animate = false;
	attack_manager.combo = "";
	.exit(state);

func _on_ComboTimer_timeout():
	attack_manager.combo = "";
	attack_manager.chargedx = false;
	attack_manager.chargedy = false;
	if(host.move_state == 'attack'):
		exit_g_or_a();