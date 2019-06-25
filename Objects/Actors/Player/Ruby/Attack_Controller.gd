extends Node2D

onready var host = get_parent();

signal vault;
signal attack;

### temp inits ###
var combo_step = 0;
var bash_charge = 0;
var bash_charge_increment = 10;
var attacking = false;
var on_cooldown = false;
var combo_end = false;
var save_input = false;
var hit = false;
var floating = false;
#starting the attack
var attack_start = false;
#middle of the attack
var attack_mid = false;
#end of the attack
var attack_end = false;
var animate = false;
var attack_spawned = false;
var attack_is_saved = false;
var ignore_bash_release = false;
### attack codes ###
var type = "slashing";
var dir = "horizontal";
var vdir = "";
var place = "_ground";
var magic = "";
var current_attack = 'nil';
var attack_str = "";
var attack_idx = "";
var charge_level = "low";


### modifiable inits ###
var end_time = .5;
var interrupt_time = .5;
var vault_time = .2;
var distance_traversable = 80;
var air_counter = 1;
var cool = 1;
var base_cost = 15;
var spec_cost = 25;
var basic_cost = 15;
var cur_cost = 0;
var cast_length = 75;


### item_vars ###
var pierce_enabled = false;
var bash_enabled = false;

### debug_vars ###
var input_testing = false;


func _on_Attack_Controller_attack():
	save_input = true;
	saveInput(Input);
	pass;

### Prepares next move if user input is detected ###
func saveInput(event):
	if(host.resource < -10):
		return;
	if(event.is_action_just_released("bash_attack") && !ignore_bash_release):
		current_attack = 'bash';
		cur_cost = basic_cost;
		bash_charge = 0;
		save_input = false;
		$BashChargeTimer.stop();
	elif(event.is_action_just_released("bash_attack")):
		bash_charge = 0;
		$BashChargeTimer.stop();
	elif(host.is_attack_triggered()):
		if(event.is_action_just_pressed("bash_attack")):
			$BashChargeTimer.start();
			ignore_bash_release = false
		elif(event.is_action_just_pressed("slash_attack")):
			current_attack = 'slash';
			cur_cost = basic_cost;
			save_input = false;
		elif(event.is_action_just_pressed("pierce_attack")):
			current_attack = 'pierce';
			cur_cost = basic_cost;
			save_input = false;
		if(event.is_action_pressed("bash_attack") && charge_level != "low"):
			current_attack += 'bash';
			cur_cost = spec_cost;
			save_input = false;
		if(event.is_action_just_pressed("dodge")):
			current_attack = 'dodge';
			cur_cost = spec_cost;
			save_input = false;
			#TODO: allow input for shortly after start and mid-start for special attacks
		elif(!event.is_action_just_pressed("bash_attack")):
			ignore_bash_release = true;
			bash_charge = 0;
	if(!save_input):
		attacking = true;
		set_position_vars(event);
	pass;

### Determines direction of attack ###
func atk_left(event):
	return event.is_action_pressed("rleft") || event.is_action_pressed("left") || (host.mouse_l() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_right(event):
	return event.is_action_pressed("rright") || event.is_action_pressed("right") || (host.mouse_r() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_up(event):
	return event.is_action_pressed("rup") || event.is_action_pressed("up") || (host.mouse_u() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_down(event):
	return event.is_action_pressed("rdown") || event.is_action_pressed("down") || (host.mouse_d() && host.ActiveInput == host.InputType.KEYMOUSE);

### Handles all player input to decide what attack to trigger ###
func set_position_vars(event):
	if(atk_left(event)):
		dir = "horizontal"
	elif(atk_right(event)):
		dir = "horizontal";
	if(atk_down(event) || atk_up(event)):
		if(!atk_left(event) && !atk_right(event)):
			dir = "";
		if(atk_up(event)):
			vdir = "_up";
		elif(atk_down(event)):
			vdir = "_down";
	else:
		vdir = "";
		dir = "horizontal"
	if(init_attack()):
		attack();
	pass;

"""
### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(attack_end):
			#landing frames
			if(host.on_floor()):
				pass;
				#if(combo_attack.length()%2 == 1):
				#	host.new_anim = combo_attack.substr(combo_attack.length()-1,1) + "land";
				#else:
				#	host.new_anim = "-" + combo_attack.substr(combo_attack.length()-1,1) + "land";
		elif(attack_start):
			host.animate(attack_str + attack_idx, false);
	
	pass;
"""

### Initializes attack once the player has committed ###
func init_attack():
	host.reset_hitbox();
	if(input_testing):
		#construct_attack_string();
		#attack_is_saved = false;
		return true;
	else:
		#stopTimers();
		attack_start = true;
		combo_step += 1;
		attack_end = false;
		attack_is_saved = false;
		return true;
	pass;

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	var tdir = dir;
	var tvdir = vdir;
	if(dir != ""):
		tdir = "_" + dir;
	
	attack_str = current_attack+tdir+tvdir+magic;
	print(attack_str);
	pass;

### Resets attack strings ###
func reset_strings():
	dir = "horizontal";
	vdir = "";
	place = "_ground";
	magic = "";
	current_attack = 'nil';
	attack_str = "";
	charge_level = "low";
	pass;

### Triggers appropriate attack based on the strings constructed by player input ###
func attack():
	#TODO: put this signal in the attacks instead
	#host.emit_signal("consume_resource", cur_cost);
	animate = true;
	attack_spawned = true;
	
	construct_attack_string();
	
	"""
	var path = "res://Objects/Actors/Player/Rose/AttackObjects/" + type + "/" + current_attack + "/";
	#Ignore certain string combinations that result in existing attacks
	if(current_attack == "basic"):
		if(attack_idx == "_1"):
			attack_idx = "_2";
		else:
			attack_idx = "_1";
		magic = "";
		if(dir == "horizontal"):
			if(!atk_up(Input) && !atk_down(Input)):
				vdir = "";
				place = "";
			elif(!atk_down(Input)):
				place = "";
			elif(atk_down(Input) && place == "ground"):
				attack_idx = "";
		elif(atk_up(Input)):
			place = "";
		
		path += dir+vdir+place+"_attack.tscn";
	
	
	if(current_attack == "special"):
		if(type == "slashing" || type == "bashing"):
			if(dir == "horizontal"):
				if(!atk_up(Input) && !atk_down(Input)):
					vdir = "";
					place = "";
				elif(!atk_down(Input) || type == "bashing"):
					place = "";
			elif(atk_up(Input)):
				place = "";
				
		
		path += dir+vdir+place+magic+"_attack.tscn";
	
	var true_length = cast_length;
	if((atk_down(Input) || atk_up(Input)) && (atk_right(Input) || atk_left(Input))):
		true_length = true_length / sqrt(2);
	if(atk_down(Input)):
		host.get_node("vault_cast").cast_to.y = true_length;
	elif(atk_up(Input)):
		host.get_node("vault_cast").cast_to.y = -true_length;
	else:
		host.get_node("vault_cast").cast_to.y = 0;
	if(atk_right(Input)):
		host.get_node("vault_cast").cast_to.x = true_length;
	elif(atk_left(Input)):
		host.get_node("vault_cast").cast_to.x = -true_length;
	else:
		host.get_node("vault_cast").cast_to.x = 0;
	
	var effect = load(path).instance();
	effect.host = host;
	effect.attack_state = self;
	host.add_child(effect);
	
	charge_level = "low";
	pass;


### Stops and resets all timers and related variables ###
func stopTimers():
	$InterruptTimer.stop();
	$RecoilTimer.stop();
	$FloatTimer.stop();
	floating = false;
	combo_end = false;
	pass;


### Timer for player recoil post-attack ###
func _on_RecoilTimer_timeout():
	$InterruptTimer.wait_time = interrupt_time;
	$InterruptTimer.start();
	reset_strings();
	pass;

### Timer allowing for player to interrupt the current attack and animation ###
func _on_InterruptTimer_timeout():
	if(Input.is_action_pressed("attack")):
		track_input = false;
	combo_end = true;
	pass;

### Timer allowing player to float a little after an attack lands mid-air ###
func _on_FloatTimer_timeout():
	floating = false;
	pass;

### Timer allowing player to vault using certain special attacks ###
func _on_Attack_vault():
	host.get_node("vault_cast").cast_to = Vector2(0, cast_length);
	if(dir == "horizontal" && current_attack == "basic"):
		host.animate("vault_lift");
		host.hspd = 500 * host.Direction;
		host.vspd = -200;
		
		$VaultTimer.wait_time = vault_time;
	else:
		host.animate("vault_still");
		$VaultTimer.wait_time = 0.1;
	$VaultTimer.start();
	pass;

### Ends the vault sending the player to the vault state ###
func _on_VaultTimer_timeout():
	host.hspd = 0;
	host.vspd = 0;
	
	exit("vault");
	pass;
"""

func _on_BashChargeTimer_timeout():
	bash_charge += bash_charge_increment;
	print(bash_charge);
	if(bash_charge < 20):
		charge_level = "low";
	elif(bash_charge < 40):
		ignore_bash_release = false;
		charge_level = "med";
	elif(bash_charge < 60):
		charge_level = "high";
	pass;