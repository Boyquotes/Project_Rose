extends "./Free_Motion_State.gd"

onready var attack_manager = get_node("Attack_Manager");

var leave = false;
var busy = false;
var hover = false;
var hop = false;
var attack_broken = false;
export(bool) var attack_dashing = false;
export(bool) var mobile = true;

onready var ComboTimer = get_node("ComboTimer");

### Initialize Attack States ###
func _ready():
	$Attack_Manager.host = host;

func enter():
	host.move_state = 'attack';
	attack_manager.enter();

func handleAnimation():
	attack_manager.handleAnimation();

func handleInput():
	attack_manager.handleInput();
	### for leaving the attack state early ###
	if(!get_attack_pressed() && (attack_manager.interrupt || attack_manager.attack_end)):
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
		attack_manager.attack_done();
		exit_g_or_a();

func execute(delta):
	### Determining player movement from attacks ###
	if(mobile):
		if(!host.on_floor()):
			host.true_mspd = host.base_mspd/2;
		else:
			host.true_mspd = host.base_mspd;
		.execute(delta);
	else:
		host.true_mspd = host.base_mspd;
		if(!host.on_floor() && (host.true_mspd >= abs(host.hspd)) && attack_manager.hit && hover):
			host.hspd += true_acceleration/4 * host.Direction;
			host.vspd -= true_acceleration/15;
		elif(!host.on_floor() && !(abs(host.hspd) > host.true_mspd) && hop):
			var input_direction = get_aim_direction();
			update_look_direction_and_scale(input_direction);
			host.hspd += true_acceleration * host.Direction;
		elif(!host.on_floor() && !(abs(host.hspd) > host.true_mspd) && attack_manager.hit && attack_manager.vdir == "_Up"):
			host.vspd -= true_acceleration/15;
		else:
			if(host.hspd != 0 && abs(host.hspd) > host.true_mspd && host.fric_activated):
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
	attack_manager.clear_slotted_vars();
	attack_manager.animate = false;
	attack_manager.combo = "";
	host.true_mspd = host.base_mspd;
	.exit(state);

func _on_ComboTimer_timeout():
	attack_manager.combo = "";
	if(host.move_state == 'attack'):
		exit_g_or_a();