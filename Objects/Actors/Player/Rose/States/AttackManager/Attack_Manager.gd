extends "../State.gd"

onready var ground = get_parent().get_parent().get_node("Move_On_Ground");
onready var air = get_parent().get_parent().get_node("Move_In_Air");
onready var ledge = get_parent().get_parent().get_node("Ledge_Grab");
onready var attack = get_parent().get_parent().get_node("Attack");

signal attack;

### temp inits ###
var on_cooldown = false;
var hit = false;
export(bool) var attack_start = false;
var attack_end = false;
var attack_is_saved = false;
var attack_triggered = false;
var save_event = false;
var event_is_saved = false;
var dodge_interrupt = false;
var interrupt = false;
var started_save = false;
var follow_up = false;
var enterSlash = false;
var enterPierce = false;
var enterDodge = false;
var enterDodgeash = false;
var chargedSlash = false;
var chargedPierce = false;
var slottedSlash = false;
var slottedPierce = false;
var slottedDodgeash = false;
var animate = false;
var switchUp = false;
var switchDown = false;
var dodgeDir = 0;

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

func execute(delta):
	if(Input.is_action_just_pressed("dodge")):
		if(Input.is_joy_button_pressed(0,4)):
			dodgeDir = -1;
		elif(Input.is_joy_button_pressed(0,5)):
			dodgeDir = 1;
		else:
			dodgeDir = 0;
	if(!Input.is_action_pressed("slash_attack")):
		chargedSlash = false;
		$ChargeSlashTimer.stop();
	else:
		attack.ComboTimer.start();
	if(!Input.is_action_pressed("pierce_attack")):
		chargedPierce = false;
		$ChargePierceTimer.stop();
	else:
		attack.ComboTimer.start();

func enter():
	if(Input.is_action_just_pressed("slash_attack")):
		enterSlash = true;
	elif(Input.is_action_just_pressed("dodge")):
		enterDodge = true;
	elif(Input.is_action_just_pressed("pierce_attack")):
		enterPierce = true;
	elif(Input.is_action_just_pressed("bash_attack")):
		enterDodgeash = true;

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
	if(chargedSlash):
		eventArr[idx] = "HoldSlash";
		slottedSlash = true;
		combo = "";
	>>elif
	"""
	if(Slash_pressed() && $ChargeSlashTimer.is_stopped() && !slottedSlash):
		"""
		TODO: put this back in
		if(previous_event == "Pierce" || combo == "SlashSlash"):
			eventArr[idx] = "HoldSlash";
			slottedSlash = true;
			combo = "";
		else:"""
		if(combo == "SlashSlash"):
			combo = "";
		if(combo == "DodgeashDodgeash"):
			combo = "";
		if(combo == "Dodgeash"):
			combo = "Slash";
		eventArr[idx] = "Slash";
		$ChargeSlashTimer.start();
		slottedSlash = true;
	if(Input.is_action_just_released("slash_attack") && slottedSlash && (eventArr[idx] == "Slash" || eventArr[idx] == "HoldSlash")):
		$ChargeSlashTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(Dodge_pressed()):
		if(Input.is_action_pressed("slash_attack") && hit):
			eventArr[idx] = "HitSlash+Dodge";
		if(Input.is_action_pressed("slash_attack")):
			eventArr[idx] = "Slash+Dodge";
		elif(hit):
			eventArr[idx] = "HitDodge";
		else:
			eventArr[idx] = "Dodge";
		
		if(eventArr[idx] == "Dodge" || eventArr[idx] == "HitDodge"  || eventArr[idx] == "Slash+Dodge" || eventArr[idx] == "HitSlash+Dodge"):
			if(!host.on_floor() && (!hit && !attack.hop)):
				started_save = false;
				eventArr[idx] = "current_event";
				clear_slotted_vars();
				enterDodge = false;
				attack_done();
				get_parent().exit_g_or_a();
				return false;
			combo = "";
			$ChargeSlashTimer.stop();
			cur_cost = basic_cost;
			if(dodge_interrupt):
				attack.attack_broken = true;
			return true;
	
	if(chargedPierce):
		eventArr[idx] = "Pierce";
		slottedPierce = true;
		#combo = "";
		#TODO: HoldPierce
	elif(Pierce_pressed() && $ChargePierceTimer.is_stopped() && !slottedPierce):
		eventArr[idx] = "Pierce";
		$ChargePierceTimer.start();
		slottedPierce = true;
	if(Input.is_action_just_released("pierce_attack") && slottedPierce && (eventArr[idx] == "Pierce" || eventArr[idx] == "HoldPierce")):
		combo = "";
		$ChargePierceTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(Bash_pressed() && !slottedDodgeash):
		if(combo == "BashBash"):
			combo = "";
		if(combo == "SlashSlash"):
			combo = "";
		if(combo == "Slash"):
			combo = "Bash";
		eventArr[idx] = "Bash";
		slottedDodgeash = true;
	if(Input.is_action_just_released("bash_attack") && slottedDodgeash && eventArr[idx] == "Bash"):
		cur_cost = basic_cost;
		return true;
	return false;

func Slash_pressed():
	return enterSlash || Input.is_action_just_pressed("slash_attack");

func Dodge_pressed():
	return enterDodge || Input.is_action_just_pressed("dodge") || abs(Input.get_joy_axis(0,2)) >= .5 || abs(Input.get_joy_axis(0,3)) >= .5;

func Pierce_pressed():
	return enterPierce || Input.is_action_just_pressed("pierce_attack");

func Bash_pressed():
	return enterDodgeash || Input.is_action_just_pressed("bash_attack");


### Determines direction of attack ###
func atk_left():
	return Input.is_action_pressed("dleft") || Input.is_action_pressed("rleft") || Input.is_action_pressed("left") || (host.mouse_l() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_right():
	return Input.is_action_pressed("dright") || Input.is_action_pressed("rright") || Input.is_action_pressed("right") || (host.mouse_r() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_up():
	return Input.is_action_pressed("dup") || Input.is_action_pressed("rup") || Input.is_action_pressed("up") || (host.mouse_u() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_down():
	return Input.is_action_pressed("ddown") || Input.is_action_pressed("rdown") || Input.is_action_pressed("down") || (host.mouse_d() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_is_dodge():
	return (eventArr[0] == "Dodge" || eventArr[0] == "HitDodge"  || eventArr[0] == "Slash+Dodge" || eventArr[0] == "HitSlash+Dodge")

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
	if(eventArr[0] == "Slash"):
		if(dir == "_Hor"):
			vdir = "";
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
	if(eventArr[0] == "Dodge"):
		dir = "";
		vdir = "";
		place = "";
	if(eventArr[0] == "HitDodge"):
		place = "";
	if(eventArr[0] == "HitSlash+Dodge"):
		place = "";
	if(eventArr[0] == "Slash+Dodge"):
		place = "";
	if(eventArr[0] == "Pierce"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
		place = "";
	if(eventArr[0] == "Bash"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
		place = ""
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
	
	if(atk_is_dodge() && dodgeDir != 0):
		get_parent().update_look_direction_and_scale(dodgeDir);
	else:
		print(input_direction);
		get_parent().update_look_direction_and_scale(input_direction);
	
	if(input_testing):
		print(attack_str);
		attack_done();
	else:
		animate = true;
		attack.ComboTimer.start();
	clear_charged_vars();
	clear_slotted_vars();
	clear_enter_vars();
	attack_end = false;
	attack.busy = true;
	follow_up = false;
	attack_is_saved = false;
	attack_start = true;

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	if(eventArr[0] == "Bash"):
		if(dir == "" && vdir == ""):
			pass;
		else:
			if(combo == "BashBash"):
				combo = "Bash";
			combo += "_Directional";
	if(input_testing):
		attack_str = event_prefix + "_" + combo+dir+vdir+place;
	else:
		attack_str = event_prefix + "_" + combo + place;

func attack_done():
	if(!attack_is_saved):
		if(!Input.is_action_pressed("slash_attack")):
			chargedSlash = false;
		if(!Input.is_action_pressed("pierce_attack")):
			chargedPierce = false;
		clear_slotted_vars();
	if(eventArr[0] != "Slash" && eventArr[0] != "Bash"):
		combo = "";
	if(combo == "SlashSlashSlash" || combo == "Pierce" || combo == "Bash_Directional" ):
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
	host.activate_grav();
	host.activate_fric();
	$AttackParticles._on_particleTimer_timeout();

func clear_enter_vars():
	enterSlash = false;
	enterDodge = false;
	enterPierce = false;
	enterDodgeash = false;

func clear_slotted_vars():
	slottedSlash = false;
	slottedPierce = false;
	slottedDodgeash = false;

func clear_charged_vars():
	chargedSlash = false;
	chargedPierce = false;

func on_hit(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.1, 15, 8);
		hit = true;
		if(eventArr[0] == "Slash" && !host.on_floor() && vdir == "_Down"):
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

func _on_ChargeSlashTimer_timeout():
	chargedSlash = true;

func _on_ChargePierceTimer_timeout():
	chargedPierce = true;