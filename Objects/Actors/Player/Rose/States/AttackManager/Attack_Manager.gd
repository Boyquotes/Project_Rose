extends "../State.gd"

onready var ground_state = get_parent().get_parent().get_node("Move_On_Ground");
onready var air_state = get_parent().get_parent().get_node("Move_In_Air");
onready var ledge_state = get_parent().get_parent().get_node("Ledge_Grab");
onready var attack_state = get_parent().get_parent().get_node("Attack");
onready var tethering_state = get_parent().get_parent().get_node("Tethering");
onready var powerups = get_parent().get_parent().get_parent().get_node("Powerups");
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
var enterBash = false;
var chargedSlash = false;
var chargedPierce = false;
var slottedSlash = false;
var slottedPierce = false;
var slottedBash = false;
var activateSlash = false;
var animate = false;
var switchUp = false;
var switchDown = false;
var dodgeDir = 0;
var done_if_not_held = false;
var attack_type = "";
var bash_plus_dodge_procs = 0;
var max_bash_plus_dodge_procs = 1;
var bounce = false;
var tether = false;
var tethered_creature;

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

var attack_degrees = 0;

### debug_vars ###
export(bool) var input_testing = false;

func _ready():
	host = get_parent().get_parent().get_parent();

func execute(delta):
	if(Input.is_action_just_pressed("dodge")):
		change_dodge_dir();
	if(!Input.is_action_pressed("slash_attack") && !activateSlash):
		chargedSlash = false;
		$ChargeSlashTimer.stop();
	else:
		attack_state.ComboTimer.start();
	if(!Input.is_action_pressed("pierce_attack")):
		chargedPierce = false;
		$ChargePierceTimer.stop();
	else:
		attack_state.ComboTimer.start();
	if(done_if_not_held):
		if(attack_type == "dodge"):
			if(!Input.is_action_pressed("dodge")):
				attack_done();
				attack_state.exit_g_or_a();
	if(host.on_floor()):
		bash_plus_dodge_procs = 0;

func change_dodge_dir():
	if(Input.is_joy_button_pressed(0,4) || Input.get_joy_axis(0,2) <= -0.5):
		dodgeDir = -1;
	elif(Input.is_joy_button_pressed(0,5) || Input.get_joy_axis(0,2) >= 0.5):
		dodgeDir = 1;
	else:
		dodgeDir = 0;

func enter():
	if(Input.is_action_just_pressed("slash_attack")):
		enterSlash = true;
	if(Input.is_action_just_released("slash_attack")):
		if(!chargedSlash):
			enterSlash = true;
		activateSlash = true;
	elif(Input.is_action_just_pressed("dodge")):
		enterDodge = true;
	elif(Input.is_action_just_pressed("pierce_attack")):
		enterPierce = true;
	elif(Input.is_action_just_pressed("bash_attack")):
		enterBash = true;

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(attack_state.busy && animate):
			host.animate(host.get_node("TopAnim"),attack_str, true);
			animate = false;

### Prepares next move if user input is detected ###
func handleInput():
	if((attack_state.attack_broken || interrupt || (follow_up && !started_save)) && attack_is_saved):
		attack_done();
		attack_state.attack_broken = false;
		eventArr[0] = eventArr[1];
		combo += eventArr[1];
		set_position_vars();
	if(!attack_state.busy && !started_save):
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
	if(chargedSlash):
		eventArr[idx] = "ChargedSlash";
		slottedSlash = true;
		combo = "";
	elif(Slash_pressed() && $ChargeSlashTimer.is_stopped() && !slottedSlash):
		if(combo == "SlashSlash"):
			combo = "";
		if(combo == "BashBash"):
			combo = "";
		if(combo == "Bash"):
			combo = "Slash";
		eventArr[idx] = "Slash";
		if(powerups.get_powerup('reinforced_fabric')):
			$ChargeSlashTimer.start();
		slottedSlash = true;
	if((Input.is_action_just_released("slash_attack") || activateSlash) && slottedSlash && (eventArr[idx] == "Slash" || eventArr[idx] == "ChargedSlash")):
		activateSlash = false;
		$ChargeSlashTimer.stop();
		attack_type = "slash";
		return true;
	
	if(Dodge_pressed()):
		if(powerups.get_powerup('explosive_rune') && Input.is_action_pressed("bash_attack")):
			eventArr[idx] = "Bash+Dodge";
		elif(powerups.get_powerup('balancing_harness') && Input.is_action_pressed("slash_attack") && hit):
			eventArr[idx] = "HitSlash+Dodge";
		elif(powerups.get_powerup('balancing_harness') && Input.is_action_pressed("slash_attack")):
			eventArr[idx] = "Slash+Dodge";
		elif(hit):
			eventArr[idx] = "HitDodge";
		else:
			eventArr[idx] = "Dodge";
		
		if(eventArr[idx] == "Dodge" || eventArr[idx] == "HitDodge"  || eventArr[idx] == "Slash+Dodge" || eventArr[idx] == "HitSlash+Dodge" || eventArr[idx] == "Bash+Dodge"):
			change_dodge_dir();
			if(!host.on_floor() && 
			((!hit && !attack_state.hop) && 
			(eventArr[idx] != "Bash+Dodge" || bash_plus_dodge_procs >= max_bash_plus_dodge_procs))
			):
				started_save = false;
				eventArr[idx] = "current_event";
				clear_slotted_vars();
				enterDodge = false;
				attack_done();
				get_parent().exit_g_or_a();
				return false;
			if(eventArr[idx] == "Bash+Dodge" && !host.on_floor()):
				bash_plus_dodge_procs += 1;
			combo = "";
			$ChargeSlashTimer.stop();
			if(dodge_interrupt):
				attack_state.attack_broken = true;
			attack_type = "dodge";
			return true;
	
	if(chargedPierce):
		eventArr[idx] = "Pierce";
		slottedPierce = true;
		#combo = "";
		#TODO: HoldPierce
	elif(Pierce_pressed() && $ChargePierceTimer.is_stopped() && !slottedPierce):
		if(powerups.get_powerup('magus_sleeve') && host.mana > 0):
			eventArr[idx] = "UpgradedPierce";
		elif(powerups.get_powerup('magus_sleeve') && !host.mana > 0):
			return false;
		else:
			eventArr[idx] = "Pierce";
		$ChargePierceTimer.start();
		slottedPierce = true;
	if(Input.is_action_just_released("pierce_attack") && slottedPierce && (eventArr[idx] == "Pierce" || eventArr[idx] == "HoldPierce"|| eventArr[idx] == "UpgradedPierce")):
		combo = "";
		$ChargePierceTimer.stop();
		attack_type = "pierce";
		return true;
	
	if(Bash_pressed() && !slottedBash):
		if(combo == "BashBash"):
			combo = "";
		if(combo == "SlashSlash"):
			combo = "";
		if(combo == "Slash"):
			combo = "Bash";
		eventArr[idx] = "Bash";
		slottedBash = true;
	if(Input.is_action_just_released("bash_attack") && slottedBash && eventArr[idx] == "Bash"):
		attack_type = "bash";
		return true;
	
	if(((slottedPierce && Input.is_action_pressed("slash_attack")) || (slottedSlash && Input.is_action_pressed("pierce_attack"))) && powerups.get_powerup('mana_fabric') && host.mana > 0):
		combo = "";
		eventArr[idx] = "RangedSlash";
		$ChargePierceTimer.stop();
		$ChargeSlashTimer.stop();
		attack_type = "slash";
		return true;
	if(((slottedPierce && Input.is_action_pressed("bash_attack")) || (slottedBash && Input.is_action_pressed("pierce_attack"))) && powerups.get_powerup('rock_rune') && host.mana > 0):
		combo = "";
		eventArr[idx] = "RangedBash";
		$ChargePierceTimer.stop();
		$ChargeSlashTimer.stop();
		attack_type = "bash";
		return true;
	return false;

func Slash_pressed():
	return enterSlash || Input.is_action_just_pressed("slash_attack");

func Dodge_pressed():
	return enterDodge || Input.is_action_just_pressed("dodge") || abs(Input.get_joy_axis(0,2)) >= .5 || abs(Input.get_joy_axis(0,3)) >= .5;

func Pierce_pressed():
	return enterPierce || Input.is_action_just_pressed("pierce_attack");

func Bash_pressed():
	return enterBash || Input.is_action_just_pressed("bash_attack");


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
	return (eventArr[0] == "Dodge" || eventArr[0] == "HitDodge"  || eventArr[0] == "Slash+Dodge" || eventArr[0] == "HitSlash+Dodge" || eventArr[0] == "Bash+Dodge")

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
	if(eventArr[0] == "ChargedSlash"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "";
			else:
				dir = "_Hor";
				vdir = "";
			place = "_Ground";
		else:
			dir = "_Hor"
			vdir = "";
			place = "_Air";
	if(eventArr[0] == "RangedSlash"):
		if(dir == "_Hor"):
			vdir = "";
		place = "";
	if(eventArr[0] == "RangedBash"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
		place = "";
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
	if(eventArr[0] == "Bash+Dodge"):
		place = "";
	if(eventArr[0] == "Pierce"):
		if(host.on_floor()):
			if(vdir == "_Down"):
				dir = "_Hor";
				vdir = "";
		place = "";
	if(eventArr[0] == "UpgradedPierce"):
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
		get_parent().update_look_direction_and_scale(input_direction);
	
	clear_charged_vars();
	clear_slotted_vars();
	clear_enter_vars();
	attack_end = false;
	attack_state.busy = true;
	follow_up = false;
	attack_is_saved = false;
	attack_start = true;
	if(input_testing):
		print(attack_str);
		attack_done();
	else:
		animate = true;
		attack_state.ComboTimer.stop();

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	if(eventArr[0] == "Bash"):
		if(dir == "" && vdir == ""):
			pass;
		elif(powerups.get_powerup('reinforced_casing')):
			if(combo == "BashBash"):
				combo = "Bash";
			combo += "_Directional";
	if(input_testing):
		attack_str = event_prefix + "_" + combo+dir+vdir+place;
	else:
		
		if(powerups.get_powerup('quick_mechanism') && (eventArr[0] == "Slash" || eventArr[0] == "ChargedSlash")):
			if(eventArr[0] == "ChargedSlash"):
				combo += "Quick" + dir + vdir;
				attack_str = event_prefix + "_" + combo + place;
			else:
				attack_str = event_prefix + "_" + combo + "Quick" + place;
		else:
			if(eventArr[0] == "ChargedSlash"):
				attack_str = event_prefix + "_" + combo + dir + vdir + place;
			else:
				attack_str = event_prefix + "_" + combo + place;

func attack_done():
	host.get_node("TopAnim").playback_speed = 1;
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
	attack_state.busy = false;
	attack_triggered = false;
	save_event = false;
	previous_event = eventArr[0];
	interrupt = false;
	dodge_interrupt = false;
	reset_strings();
	attack_state.ComboTimer.start();
	attack_state.hop = false;
	attack_state.hover = false;
	attack_state.mobile = true;
	attack_state.attack_dashing = false;
	done_if_not_held = false;
	host.normalize_grav();
	host.activate_grav();
	host.activate_fric();
	host.true_gravity = host.base_gravity;
	host.true_friction = host.base_friction;
	$Attack_Instancing.clear();
	bounce = false;
	if(Input.is_action_pressed("ChannelLeft") && tether && host.mana > 0):
		tether = false;
		attack_state.exit(tethering_state);
		attack_state.get_node("ComboTimer").stop();
	else:
		tether = false;
		tethering_state.creatures.clear();

func clear_enter_vars():
	enterSlash = false;
	enterDodge = false;
	enterPierce = false;
	enterBash = false;

func clear_slotted_vars():
	slottedSlash = false;
	slottedPierce = false;
	slottedBash = false;

func clear_charged_vars():
	chargedSlash = false;
	chargedPierce = false;

func on_hit(col):
	if(tether):
		tethering_state.creatures.push_back(tethered_creature);
		tethered_creature = null;
	if(bounce):
		host.bounce();
	if("hittable" in col):
		if(col.hittable):
			hit = true;
			if(eventArr[0] == "Slash" && !host.on_floor() && vdir == "_Down"):
				attack_state.hop = true;
				host.jump()
				host.activate_grav();
				hit = false;
			elif(!host.on_floor() && !attack_state.attack_dashing):
				attack_state.hover = true;
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

func set_done_if_not_held():
	done_if_not_held = true;

func set_interrupt():
	interrupt = true;
	follow_up = true;

func _on_ChargeSlashTimer_timeout():
	chargedSlash = true;

func _on_ChargePierceTimer_timeout():
	chargedPierce = true;