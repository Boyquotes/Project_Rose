extends "State.gd"

signal attack;

### temp inits ###
var on_cooldown = false;
var hit = false;
#starting the attack
var attack_start = false;
#middle of the attack
var attack_mid = false;
#end of the attack
var attack_end = false;
var animate = false;
var attack_spawned = false;
var attack_is_saved = false;
var attack_triggered = false;
var busy = false;
### attack codes ###
var type = "slashing";
var dir = "horizontal";
var vdir = "";
var current_event = 'nil';
var attack_str = "";
var attack_idx = "";

### modifiable inits ###
var end_time = .5;
var interrupt_time = .5;
var distance_traversable = 80;
var air_counter = 1;
var cool = 1;
var base_cost = 15;
var spec_cost = 25;
var basic_cost = 15;
var cur_cost = 0;

### debug_vars ###
var input_testing = false;

func enter():
	host.style_state = 'ranged';
	pass;

### Prepares next move if user input is detected ###
func handleInput():
	if(busy):
		return;
	if(!attack_triggered):
		if(Input.is_action_just_released("attack")):
			if(host.boosting):
				host.move_states[host.move_state].exit(host.get_node("Movement_States").get_node("Move_In_Air"));
				host.boosting = false;
			current_event = 'rattack';
			cur_cost = basic_cost;
			attack_triggered = true;
		if(Input.is_action_just_pressed("dodge")):
			if(host.boosting || host.locking):
				host.move_states[host.move_state].exit(host.get_node("Movement_States").get_node("Move_In_Air"));
				host.boosting = false;
				host.locking = false;
			current_event = 'rdodge';
			cur_cost = basic_cost;
			attack_triggered = true;
			#TODO: allow input for shortly after start and mid-start for special attacks
		if(Input.is_action_just_pressed("special")):
			host.locking = true;
			host.move_states[host.move_state].exit(host.get_node("Movement_States").get_node("Lock_Down"));
		if(Input.is_action_just_pressed("switch")):
			host.move_states[host.move_state].exit(host.get_node("Movement_States").get_node("Move_In_Air"));
			exit(host.get_node("Style_States").get_node("Melee"));
			host.locking = false;
	if(attack_triggered):
		busy = true;
		set_position_vars();
	pass;

func exit(state):
	.exit(state);
	reset_strings();
	attack_triggered = false;
	busy = false;

### Determines direction of attack ###
func atk_left():
	return Input.is_action_pressed("rleft") || Input.is_action_pressed("left") || (host.mouse_l() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_right():
	return Input.is_action_pressed("rright") || Input.is_action_pressed("right") || (host.mouse_r() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_up():
	return Input.is_action_pressed("rup") || Input.is_action_pressed("up") || (host.mouse_u() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_down():
	return Input.is_action_pressed("rdown") || Input.is_action_pressed("down") || (host.mouse_d() && host.ActiveInput == host.InputType.KEYMOUSE);

### Handles all player input to decide what attack to trigger ###
func set_position_vars():
	if(atk_left()):
		dir = "horizontal"
	elif(atk_right()):
		dir = "horizontal";
	if(atk_down() || atk_up()):
		if(!atk_left() && !atk_right()):
			dir = "";
		if(atk_up()):
			vdir = "_up";
		elif(atk_down()):
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
	
	attack_str = current_event+tdir+tvdir;
	print(attack_str);
	pass;

### Resets attack strings ###
func reset_strings():
	dir = "horizontal";
	vdir = "";
	current_event = 'nil';
	attack_str = "";
	pass;

### Triggers appropriate attack based on the strings constructed by player input ###
func attack():
	#TODO: put this signal in the attacks instead
	#host.emit_signal("consume_resource", cur_cost);
	#animate = true;
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
	"""
	busy = false;
	attack_triggered = false;
	pass;

"""
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