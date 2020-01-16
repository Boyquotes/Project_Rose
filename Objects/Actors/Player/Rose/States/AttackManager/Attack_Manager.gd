extends "../State.gd"

onready var ground_state = get_parent().get_parent().get_node("Move_On_Ground");
onready var air_state = get_parent().get_parent().get_node("Move_In_Air");
onready var ledge_state = get_parent().get_parent().get_node("Ledge_Grab");
onready var attack_state = get_parent().get_parent().get_node("Attack");
onready var tethering_state = get_parent().get_parent().get_node("Tethering");
onready var vortex_state = get_parent().get_parent().get_node("Vortex");
onready var charge_state = get_parent().get_parent().get_node("Charge");
onready var hurt_state = get_parent().get_parent().get_node("Hurt");
onready var powerups = get_parent().get_parent().get_parent().get_node("Powerups");
signal attack;

### properties for animation ###
export(bool) var rotate = true;


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
var enterSlash = false;
var enterPierce = false;
var enterDodge = false;
var enterBash = false;
var slottedSlash = false;
var slottedPierce = false;
var slottedBash = false;
var animate = false;
var switchUp = false;
var switchDown = false;
var attackDir = 0;
var done_if_not_held = false;
var attack_type = "";
var bash_plus_dodge_procs = 0;
var max_bash_plus_dodge_procs = 1;
var bounce = false;
var tether = false;
var twirl = false;

var tethered_creature;

### attack codes ###
var event_prefix = "Event";
var eventArr = ["current_event", "saved_event"];
var combo = "";
var attack_str = "attack_str";
var bot_str = "bot_str";
var previous_event = "previous_event";

### modifiable inits ###
var air_counter = 1;
var cool = 1;

var attack_degrees = 0;

### debug_vars ###
export(bool) var input_testing = true;

func _ready():
	host = get_parent().get_parent().get_parent();
	rotate = true;

func execute(delta):
	if(done_if_not_held):
		if(attack_type == "dodge"):
			if(!Input.is_action_pressed("Dodge")):
				attack_done();
				attack_state.exit_g_or_a();

func enter():
	if(Input.is_action_just_pressed("Slash_Attack")):
		enterSlash = true;
	elif(Input.is_action_just_pressed("Dodge")):
		enterDodge = true;
	elif(Input.is_action_just_pressed("Pierce_Attack")):
		enterPierce = true;
	elif(Input.is_action_just_pressed("Bash_Attack")):
		enterBash = true;

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(attack_state.busy && animate):
			host.animate(host.spr_anim,attack_str, true);
			animate = false;

### Prepares next move if user input is detected ###
func handleInput():
	if(((dodge_interrupt && twirl) || interrupt || (follow_up && !started_save)) && attack_is_saved):
		attack_is_saved = false;
		if(!twirl && eventArr[1] == "Dodge"):
			return;
		attack_done();
		if(twirl && eventArr[1] == "Dodge"):
			eventArr[1] = "HitDodge";
		eventArr[0] = eventArr[1];
		combo += eventArr[1];
		attack();
	if(!attack_state.busy && !started_save):
		if(parse_attack(0)):
			combo += eventArr[0];
			attack();
	if(save_event || started_save):
		if(parse_attack(1)):
			started_save = false;
			attack_is_saved = true;
			save_event = false;

###begins parsing player attack if an attack is triggered##
func parse_attack(idx):
	if(Slash_pressed() && !slottedSlash):
		eventArr[idx] = "Slash";
		if(powerups.get_powerup('focus') && Input.is_action_pressed("Focus")):
			eventArr[idx] = "SlashSwirl";
		if(powerups.get_powerup('reinforced_stitching') && powerups.get_powerup('channel') && Input.is_action_pressed("Channel")):
			eventArr[idx] = "SlashWind";
		if(powerups.get_powerup('vortex_rune') && powerups.get_powerup('focus') && powerups.get_powerup('channel') && Input.is_action_pressed("Channel") && Input.is_action_pressed("Focus")):
			eventArr[idx] = "ToVortex";
		slottedSlash = true;
	elif(Pierce_pressed() && !slottedPierce):
		eventArr[idx] = "Pierce";
		if(powerups.get_powerup('magus_sleeve') && powerups.get_powerup('focus') && Input.is_action_pressed("Focus")):
			eventArr[idx] = "PierceDash";
		if(powerups.get_powerup('bounding_sleeve') && powerups.get_powerup('channel') && Input.is_action_pressed("Channel")):
			eventArr[idx] = "PierceStasis";
		if(powerups.get_powerup('lightning_rune') && powerups.get_powerup('focus') && powerups.get_powerup('channel') && Input.is_action_pressed("Channel") && Input.is_action_pressed("Focus")):
			eventArr[idx] = "PierceHoming";
		slottedPierce = true;
	elif(Bash_pressed() && !slottedBash):
		eventArr[idx] = "Bash";
		if(powerups.get_powerup('reinforced_casing') && powerups.get_powerup('focus') && Input.is_action_pressed("Focus")):
			eventArr[idx] = "BashLaunch";
		if(powerups.get_powerup('regrowth_casing')  && powerups.get_powerup('channel') && Input.is_action_pressed("Channel")):
			eventArr[idx] = "BashLunge";
		if(powerups.get_powerup('boulder_rune') && powerups.get_powerup('focus') && powerups.get_powerup('channel') && Input.is_action_pressed("Channel") && Input.is_action_pressed("Focus")):
			eventArr[idx] = "ToCharge";
		slottedBash = true;
	elif(Dodge_pressed()):
		if(idx == 0 && host.on_floor() || idx == 1):
			eventArr[idx] = "Dodge";
	
	if(Input.is_action_just_released("Slash_Attack") && slottedSlash):
		return record_event("slash");
	if(Input.is_action_just_released("Pierce_Attack") && slottedPierce):
		return record_event("pierce");
	if(Input.is_action_just_released("Bash_Attack") && slottedBash):
		return record_event("bash");
	if(eventArr[idx] == "Dodge"):
		return record_event("dodge");
	
	clear_enter_vars();
	return false;

func record_event(atk):
	clear_enter_vars();
	combo = "";
	attack_type = atk;
	return true;

func Slash_pressed():
	return enterSlash || Input.is_action_just_pressed("Slash_Attack");

func Dodge_pressed():
	return enterDodge || Input.is_action_just_pressed("Dodge");

func Pierce_pressed():
	return enterPierce || Input.is_action_just_pressed("Pierce_Attack");

func Bash_pressed():
	return enterBash || Input.is_action_just_pressed("Bash_Attack");

### Resets attack strings ###
func reset_strings():
	eventArr[0] = 'current_event';
	attack_str = "attack_str";
	bot_str = "bot_str";
	pass;

### Triggers appropriate attack based on the strings constructed by player input ###
func attack():
	host.tweened = false;
	attack_state.hop = false;
	twirl = false;
	construct_attack_string();
	var input_direction = get_parent().get_aim_direction();
	attack_degrees = host.deg;
	if(!rotate):
		attack_degrees = 0;
	attack_state.canTurn = true;
	get_parent().update_look_direction_and_scale(input_direction);
	attack_state.canTurn = false;
	
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
	attack_str = event_prefix + "_" + combo;

func attack_done():
	if(!host.tweened):
		host.tween_rotation_to_origin("Sprites/Sprite");
	host.get_node("Hitbox/Hitbox").disabled = false;
	if(!attack_is_saved):
		clear_slotted_vars();
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
	attack_state.hover = false;
	attack_state.mobile = true;
	attack_state.attack_dashing = false;
	attack_state.canTurn = true;
	done_if_not_held = false;
	host.normalize_grav();
	host.activate_grav();
	host.activate_fric();
	host.true_friction = host.base_friction;
	attack_state.ComboTimer.start();
	bounce = false;
	rotate = true;
	change_state();
	

func change_state():
	if(previous_event == "ToVortex"):
		attack_state.exit(vortex_state);
		attack_state.get_node("ComboTimer").stop();
	if(previous_event == "ToCharge"):
		attack_state.exit(charge_state);
		attack_state.get_node("ComboTimer").stop();
	if(Input.is_action_pressed("Use_Mana") && tether && host.mana > 0):
		tether = false;
		attack_state.exit(tethering_state);
		attack_state.get_node("ComboTimer").stop();
	else:
		tether = false;
		tethering_state.creatures.clear();

func attack_done_reset():
	twirl = false;
	attack_done();

func clear_enter_vars():
	enterSlash = false;
	enterDodge = false;
	enterPierce = false;
	enterBash = false;

func clear_slotted_vars():
	slottedSlash = false;
	slottedPierce = false;
	slottedBash = false;

func clear_save_vars():
	started_save = false;
	attack_is_saved = false;
	save_event = false;

func on_hit(col):
	if(tether):
		tethering_state.creatures.push_back(tethered_creature);
		tethered_creature = null;
	if(bounce):
		host.bounce();
	if("hittable" in col):
		if(col.hittable):
			hit = true;
			if(eventArr[0] == "Slash" && !host.on_floor()):
				attack_state.hop = true;
				hit = false;
			if(eventArr[0] == "Pierce"):
				twirl = true;
				hit = false;
			if(eventArr[0] == "BashLunge"):
				host.add_velocity(500, attack_degrees+180);
			"""
			elif(!host.on_floor() && !attack_state.attack_dashing):
				#NOTE: This might mess up; if the grav screws up again this is probably at fault
				attack_state.hover = true;
				host.mitigate_grav();"""

func set_save_event():
	save_event = true;
	attack_state.canTurn = false;

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
