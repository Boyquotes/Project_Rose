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
var X = false;
var Y = false;
var B = false;
var chargedx = false;
var chargedy = false;
var slottedx = false;
var slottedy = false;
var animate = false;
var switchUp = false;
var switchDown = false;

### attack codes ###
var style = "Wind_Dance"; #TODO: get rid of this
var dir = "_Hor";
var vdir = "";
var eventArr = ["current_event", "saved_event"];
var combo = "";
var place = "_Ground";
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

func execute(delta):
	if(!Input.is_action_pressed("slash_attack")):
		chargedx = false;
		$ChargeXTimer.stop();
	else:
		attack.ComboTimer.start();
	if(!Input.is_action_pressed("wind_attack")):
		chargedy = false;
		$ChargeYTimer.stop();
	else:
		attack.ComboTimer.start();

func enter():
	if(Input.is_action_just_pressed("slash_attack")):
		X = true;
	elif(Input.is_action_just_pressed("dodge")):
		B = true;
	elif(Input.is_action_just_pressed("wind_attack")):
		Y = true;

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(attack.busy && animate):
			host.animate(host.get_node("TopAnim"),attack_str, true);
			animate = false;
	pass;

### Prepares next move if user input is detected ###
func handleInput():
	if((interrupt || (follow_up && !started_save)) && attack_is_saved):
		attack_done();
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
	if(X_pressed() && $ChargeXTimer.is_stopped() && !slottedx):
		"""
		TODO: put this back in
		if(previous_event == "Y" || combo == "XX"):
			eventArr[idx] = "HoldX";
			slottedx = true;
			combo = "";
		else:"""
		if(combo == "XX"):
			combo = "";
		eventArr[idx] = "X";
		$ChargeXTimer.start();
		slottedx = true;
	if(Input.is_action_just_released("slash_attack") && slottedx && (eventArr[idx] == "X" || eventArr[idx] == "HoldX")):
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
			if(!host.on_floor() && !hit):
				started_save = false;
				eventArr[idx] = "current_event";
				slottedx = false;
				slottedy = false;
				B = false;
				attack_done();
				get_parent().exit_g_or_a();
				return false;
			combo = "";
			$ChargeXTimer.stop();
			cur_cost = basic_cost;
			return true;
	
	if(chargedy):
		eventArr[idx] = "Y";
		slottedy = true;
		#combo = "";
		#TODO: HoldY
	elif(Y_pressed() && $ChargeYTimer.is_stopped() && !slottedy):
		eventArr[idx] = "Y";
		$ChargeYTimer.start();
		slottedy = true;
	if(Input.is_action_just_released("wind_attack") && slottedy && (eventArr[idx] == "Y" || eventArr[idx] == "HoldY")):
		if(eventArr[idx] == "Y" || combo == "X" || combo == "XX"):
			combo = "";
		$ChargeYTimer.stop();
		cur_cost = basic_cost;
		return true;
	return false;

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
	if(!host.on_floor()):
		place = "_Air";
		if(eventArr[0] == "HoldX"):
			eventArr[0] = "X";
			combo = "X"
		if(atk_down() && eventArr[0] == "X"):
			dir = "";
			vdir = "_Down";
		if(atk_up() && eventArr[0] == "X"):
			dir = "";
			vdir = "_Up";
	else:
		place = "_Ground";
		if(atk_up() && (eventArr[0] == "X" || eventArr[0] == "HoldX")):
			if(eventArr[0] == "HoldX"):
				eventArr[0] = "X";
				combo = "X"
			dir = "";
			vdir = "_Up";
		if(atk_down() && eventArr[0] == "HoldX"):
			dir = "";
			vdir = "_Down";
	if(eventArr[0] == "Y" || eventArr[0] == "HitB" || eventArr[0] == "HitX+B"):
		if(atk_left()):
			dir = "_Hor"
		elif(atk_right()):
			dir = "_Hor";
		if(atk_down() || atk_up()):
			if(!atk_left() && !atk_right()):
				dir = "";
			if(atk_up()):
				vdir = "_Up";
			elif(atk_down()):
				vdir = "_Down";
				if(place == "_Ground"):
					vdir = "";
					dir = "_Hor";
		else:
			vdir = "";
			dir = "_Hor"
	if(eventArr[0] == "XB" || eventArr[0] == "B" || eventArr[0] == "X+B"):
		dir = "";
		place = "";
	chargedx = false;
	chargedy = false;
	slottedx = false;
	slottedy = false;
	X = false;
	Y = false;
	B = false;
	attack_end = false;
	attack.busy = true;
	follow_up = false;
	attack_is_saved = false;
	attack_start = true;
	attack();

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	if(((dir != "_Hor" && vdir == "_Down") || eventArr[0] == "HoldX") || (eventArr[0] == "Y" && (dir != "_Hor" && vdir == "_Down"))):
		attack_str = style + "_" + combo+place;
	else:
		attack_str = style + "_" + combo;
	if(eventArr[0] == "HoldX" || eventArr[0] == "B"):
		bot_str = attack_str;
	else:
		bot_str = style + "_" + combo + place; 

### Resets attack strings ###
func reset_strings():
	dir = "_Hor";
	vdir = "";
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
	#TODO: Get appropriate path to attack scene
	pass;

func set_save_event():
	save_event = true;
	attack_start = false;

func set_dodge_interrupt():
	dodge_interrupt = true;
	attack_start = true;

func unset_dodge_interrupt():
	dodge_interrupt = false;
	started_save = false;
	attack_is_saved = false;
	save_event = false;
	slottedx = false;
	slottedy = false;

func set_interrupt():
	interrupt = true;
	follow_up = true;

func check_combo():
	pass;

func attack_done():
	if(!attack_is_saved):
		if(!Input.is_action_pressed("slash_attack")):
			chargedx = false;
		if(!Input.is_action_pressed("wind_attack")):
			chargedy = false;
		slottedx = false;
		slottedy = false;
	if(eventArr[0] != "X"):
		combo = "";
	if(combo == "XXX" || combo == "Y"):
		combo = "";
	hit = false;
	X = false;
	Y = false;
	B = false;
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
	pass;

func X_pressed():
	return X || Input.is_action_just_pressed("slash_attack");

func B_pressed():
	return B || Input.is_action_just_pressed("dodge");

func Y_pressed():
	return Y || Input.is_action_just_pressed("wind_attack");

func _on_ChargeXTimer_timeout():
	chargedx = true;

func _on_ChargeYTimer_timeout():
	chargedy = true;

func on_hit(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.2, 15, 8);
		hit = true;
		if(eventArr[0] != "Y"):
			if(place == "_Air" && vdir == "_Down"):
				attack.hop = true;
				host.jump()
				host.activate_grav();
				hit = false;
			elif(!host.on_floor()):
				attack.hover = true;
				host.deactivate_grav();
				$HitGravTimer.start();

func _on_HitGravTimer_timeout():
	hit = false;
	host.activate_grav();