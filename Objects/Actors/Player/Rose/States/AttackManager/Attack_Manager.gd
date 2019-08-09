extends "../State.gd"

onready var ground = get_parent().get_parent().get_node("Move_On_Ground");
onready var air = get_parent().get_parent().get_node("Move_In_Air");
onready var ledge = get_parent().get_parent().get_node("Ledge_Grab");
onready var attack = get_parent().get_parent().get_node("Attack");

signal attack;

### temp inits ###
var on_cooldown = false;
var hit = false;
var attack_start = false;
var attack_end = false;
var attack_is_saved = false;
var attack_triggered = false;
var save_event = false;
var event_is_saved = false;
var dodge_interrupt = false;
var interrupt = false;
var started_save = false;
var follow_up = false;
var enterX = false;
var enterY = false;
var enterB = false;
var enterRb = false;
var chargedX = false;
var chargedY = false;
var slottedX = false;
var slottedY = false;
var slottedRb = false;
var animate = false;
var switchUp = false;
var switchDown = false;

### attack codes ###
var event_prefix = "Event";
var dir = "";
var vdir = "";
var eventArr = ["current_event", "saved_event"];
var combo = "";
var place = "";
var attack_str = "attack_str";
var bot_str = "bot_str";
var previous_event = "previous_event";

### modifiable inits ###
var air_counter = 1;
var cool = 1;
var base_cost = 15;
var spec_cost = 25;
var basic_cost = 15;
var cur_cost = 0;

var attack_degrees = 0;

### debug_vars ###
export(bool) var input_testing = false;

func execute(deRba):
	if(!Input.is_action_pressed("slash_attack")):
		chargedX = false;
		$ChargeXTimer.stop();
	else:
		attack.ComboTimer.start();
	if(!Input.is_action_pressed("wind_attack")):
		chargedY = false;
		$ChargeYTimer.stop();
	else:
		attack.ComboTimer.start();

func enter():
	if(Input.is_action_just_pressed("slash_attack")):
		enterX = true;
	elif(Input.is_action_just_pressed("dodge")):
		enterB = true;
	elif(Input.is_action_just_pressed("wind_attack")):
		enterY = true;
	elif(Input.is_action_just_pressed("bash_attack")):
		enterRb = true;

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(attack.busy && animate):
			host.animate(host.get_node("TopAnim"),attack_str, true);
			animate = false;
	pass;

### Prepares next move if user input is detected ###
func handleInput():
	if((attack.attack_broken || interrupt || (follow_up && !started_save)) && attack_is_saved):
		attack_done();
		attack.attack_broken = false;
		eventArr[0] = eventArr[1];
		combo += eventArr[1];
		set_position_vars();
	if(!attack.busy && !started_save):
		if(parse_attack(0)):
			combo += eventArr[0];
			set_position_vars();
	if(save_event || started_save):
		if(parse_attack(1)):
			started_save = false;
			attack_is_saved = true;
			save_event = false;
	"""
		print(String(interrupt) + " || " + String(!started_save) + ") && " + String(attack_is_saved));
		print(busy);
	if(Input.is_action_just_released("slash_attack")):
		print(String(interrupt) + " || " + String(!started_save) + ") && " + String(attack_is_saved));
		print(busy);
		print("____________________");"""

###begins parsing player attack if an attack is triggered##
func parse_attack(idx):
	"""
	TODO: put this back in
	if(chargedx):
		eventArr[idx] = "HoldX";
		slottedx = true;
		combo = "";
	>>elif
	"""
	if(X_pressed() && $ChargeXTimer.is_stopped() && !slottedX):
		"""
		TODO: put this back in
		if(previous_event == "Y" || combo == "XX"):
			eventArr[idx] = "HoldX";
			slottedx = true;
			combo = "";
		else:"""
		if(combo == "XX"):
			combo = "";
		if(combo == "RbRb"):
			combo = "";
		if(combo == "Rb"):
			combo = "X";
		eventArr[idx] = "X";
		$ChargeXTimer.start();
		slottedX = true;
	if(Input.is_action_just_released("slash_attack") && slottedX && (eventArr[idx] == "X" || eventArr[idx] == "HoldX")):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(B_pressed()):
		if(Input.is_action_pressed("slash_attack") && hit):
			eventArr[idx] = "HitX+B";
		if(Input.is_action_pressed("slash_attack")):
			eventArr[idx] = "X+B";
		elif(hit):
			eventArr[idx] = "HitB";
		else:
			eventArr[idx] = "B";
		
		if(eventArr[idx] == "B" || eventArr[idx] == "HitB"  || eventArr[idx] == "X+B" || eventArr[idx] == "HitX+B"):
			if(!host.on_floor() && (!hit && !attack.hop)):
				started_save = false;
				eventArr[idx] = "current_event";
				clear_slotted_vars();
				enterB = false;
				attack_done();
				get_parent().exit_g_or_a();
				return false;
			combo = "";
			$ChargeXTimer.stop();
			cur_cost = basic_cost;
			if(dodge_interrupt):
				attack.attack_broken = true;
			return true;
	
	if(chargedY):
		eventArr[idx] = "Y";
		slottedY = true;
		#combo = "";
		#TODO: HoldY
	elif(Y_pressed() && $ChargeYTimer.is_stopped() && !slottedY):
		eventArr[idx] = "Y";
		$ChargeYTimer.start();
		slottedY = true;
	if(Input.is_action_just_released("wind_attack") && slottedY && (eventArr[idx] == "Y" || eventArr[idx] == "HoldY")):
		combo = "";
		$ChargeYTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(Rb_pressed() && !slottedRb):
		if(combo == "RbRb"):
			combo = "";
		if(combo == "XX"):
			combo = "";
		if(combo == "X"):
			combo = "Rb";
		eventArr[idx] = "Rb";
		slottedRb = true;
	if(Input.is_action_just_released("bash_attack") && slottedRb && eventArr[idx] == "Rb"):
		cur_cost = basic_cost;
		return true;
	return false;

func X_pressed():
	return enterX || Input.is_action_just_pressed("slash_attack");

func B_pressed():
	return enterB || Input.is_action_just_pressed("dodge");

func Y_pressed():
	return enterY || Input.is_action_just_pressed("wind_attack");

func Rb_pressed():
	return enterRb || Input.is_action_just_pressed("bash_attack");


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
		dir = "_Hor"
	elif(atk_right()):
		dir = "_Hor";
	if(atk_down() || atk_up()):
		if(!atk_left() && !atk_right()):
			dir = "";
	if(atk_up()):
		vdir = "_Up";
	if(atk_down()):
		vdir = "_Down";
	if(host.on_floor()):
		place = "_Ground";
	else:
		place = "_Air";
	if(eventArr[0] == "X"):
		if(dir == "_Hor"):
			vdir = "";
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
	if(eventArr[0] == "B"):
		dir = "";
		vdir = "";
		place = "";
	if(eventArr[0] == "HitB"):
		place = "";
	if(eventArr[0] == "HitX+B"):
		place = "";
	if(eventArr[0] == "X+B"):
		place = "";
	if(eventArr[0] == "Y"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
		place = "";
	if(eventArr[0] == "Rb"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
		place = ""
	clear_charged_vars();
	clear_slotted_vars();
	clear_enter_vars();
	attack_end = false;
	attack.busy = true;
	follow_up = false;
	attack_is_saved = false;
	attack_start = true;
	attack();

### Resets attack strings ###
func reset_strings():
	dir = "";
	vdir = "";
	place = "";
	eventArr[0] = 'current_event';
	attack_str = "attack_str";
	bot_str = "bot_str";
	pass;

### Triggers appropriate attack based on the strings constructed by player input ###
func attack():
	#TODO: put this signal in the attacks instead
	#host.emit_signal("consume_resource", cur_cost);
	construct_attack_string();
	var input_direction = get_parent().get_aim_direction();
	if(vdir == "_Up"):
		attack_degrees = -90;
		if(dir == "_Hor"):
			attack_degrees = -45;
	elif(vdir == "_Down"):
		attack_degrees = 90;
		if(dir == "_Hor"):
			attack_degrees = 45;
	else:
		attack_degrees = 0;
	
	get_parent().update_look_direction_and_scale(input_direction);
	if(input_testing):
		print(attack_str);
		attack_done();
	else:
		animate = true;
		attack.ComboTimer.start();
	pass;

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	if(eventArr[0] == "Rb"):
		if(dir == "" && vdir == ""):
			pass;
		else:
			if(combo == "RbRb"):
				combo = "Rb";
			combo += "_Directional";
	if(input_testing):
		attack_str = event_prefix + "_" + combo+dir+vdir+place;
	else:
		attack_str = event_prefix + "_" + combo + place;

func attack_done():
	if(!attack_is_saved):
		if(!Input.is_action_pressed("slash_attack")):
			chargedX = false;
		if(!Input.is_action_pressed("wind_attack")):
			chargedY = false;
		clear_slotted_vars();
	if(eventArr[0] != "X" && eventArr[0] != "Rb"):
		combo = "";
	if(combo == "XXX" || combo == "Y" || combo == "Rb_Directional" ):
		combo = "";
	hit = false;
	clear_enter_vars();
	attack_end = true;
	attack.busy = false;
	attack_triggered = false;
	save_event = false;
	previous_event = eventArr[0];
	interrupt = false;
	dodge_interrupt = false;
	reset_strings();
	attack.ComboTimer.start();
	attack.hop = false;
	attack.hover = false;
	attack.mobile = true;
	attack.attack_dashing = false;
	host.normalize_grav();
	$AttackParticles._on_particleTimer_timeout();

func clear_enter_vars():
	enterX = false;
	enterB = false;
	enterY = false;
	enterRb = false;

func clear_slotted_vars():
	slottedX = false;
	slottedY = false;
	slottedRb = false;

func clear_charged_vars():
	chargedX = false;
	chargedY = false;

func on_hit(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.1, 15, 8);
		hit = true;
		if(eventArr[0] == "X" && !host.on_floor() && vdir == "_Down"):
			attack.hop = true;
			host.jump()
			host.activate_grav();
			hit = false;
		elif(!host.on_floor() && !attack.attack_dashing):
			attack.hover = true;
			host.mitigate_grav();

func set_save_event():
	save_event = true;

func set_dodge_interrupt():
	dodge_interrupt = true;

func unset_dodge_interrupt():
	dodge_interrupt = false;
	started_save = false;
	attack_is_saved = false;
	save_event = false;
	clear_slotted_vars();

func set_interrupt():
	interrupt = true;
	follow_up = true;

func _on_ChargeXTimer_timeout():
	chargedX = true;

func _on_ChargeYTimer_timeout():
	chargedY = true;