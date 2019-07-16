extends "../State.gd"

onready var Wind_Dance = get_parent().get_node("Wind_Dance");
onready var Closed_Fan = get_parent().get_node("Closed_Fan");

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
var dashing = false;
var save_event = false;
var event_is_saved = false;
var interrupt = false;
var started_save = false;
var follow_up = false;

### attack codes ###
var style = "style";
var dir = "_Hor";
var vdir = "";
var current_event = "current_event";
var saved_event = "saved_event";
var combo = "";
var place = "_Ground";
var attack_str = "attack_str";
var bot_str = "bot_str";
var previous_event = "previous_event";

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
var style_idx = 0;
var style_n = 0;
var stm1;
var stp1;

func _ready():
	style_n = get_parent().get_child_count();
	style_idx = get_index();
	stm1 = style_idx - 1;
	if(stm1 < 0):
		stm1 = style_n - 1;
	stp1 = style_idx + 1;
	if(stp1 >= style_n):
		stp1 = 0;

func enter():
	print("   " + get_parent().get_child(style_idx).name);
	print(get_parent().get_child(stm1).name + "   " + get_parent().get_child(stp1).name);

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(busy):
			host.animate(host.get_node("TopAnim"),attack_str, false);
	pass;

### Prepares next move if user input is detected ###
func handleInput():
	"""
	if(Input.is_action_just_pressed("attack")):
		print(String(interrupt) + " || " + String(!started_save) + ") && " + String(attack_is_saved));
		print(busy);
	if(Input.is_action_just_released("attack")):
		print(String(interrupt) + " || " + String(!started_save) + ") && " + String(attack_is_saved));
		print(busy);
		print("____________________");"""
	if((interrupt || (follow_up && !started_save)) && attack_is_saved):
		attack_done();
		current_event = saved_event;
		combo += saved_event;
		busy = true;
		follow_up = false;
		attack_is_saved = false;
		set_position_vars();
	if(!busy && !started_save):
		if(parse_attack()):
			combo += current_event;
			busy = true;
			follow_up = false;
			attack_is_saved = false;
			set_position_vars();
	if(save_event || started_save):
		if(parse_next_attack()):
			started_save = false;
			attack_is_saved = true;
			save_event = false;

###begins parsing player attack if an attack is triggered##
#overloaded by children states
func parse_attack():
	pass;

func parse_next_attack():
	pass;

func switch():
	if(Input.is_action_just_pressed("switchL")):
		exit(get_parent().get_child(stm1));
	if(Input.is_action_just_pressed("switchR")):
		exit(get_parent().get_child(stp1));

func exit(state):
	.exit(state);
	reset_strings();
	attack_triggered = false;
	busy = false;
	dashing = false;

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
			vdir = "_up";
		elif(atk_down()):
			vdir = "_down";
	else:
		vdir = "";
		dir = "_Hor"
	if(init_attack()):
		attack();
	pass;

### Initializes attack once the player has committed ###
func init_attack():
	if(input_testing):
		#construct_attack_string();
		#attack_is_saved = false;
		return true;
	else:
		#stopTimers();
		attack_start = true;
		attack_end = false;
		attack_is_saved = false;
		$StartTimer.start();
		return true;
	pass;

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	if(host.move_state == "ledge_grab"):
		host.move_states[host.move_state].update_look_direction_and_scale(host.Direction * -1);

### Resets attack strings ###
func reset_strings():
	dir = "_Hor";
	vdir = "";
	current_event = 'current_event';
	attack_str = "attack_str";
	bot_str = "bot_str";
	pass;

### Triggers appropriate attack based on the strings constructed by player input ###
func attack():
	#TODO: put this signal in the attacks instead
	#host.emit_signal("consume_resource", cur_cost);
	#animate = true;
	attack_spawned = true;
	
	construct_attack_string();
	#TODO: Get appropriate path to attack scene
	"""
	var path = "res://Objects/Actors/Player/Rose/AttackObjects/" + type + "/" + current_attack + "/";
	path += dir+vdir+place+"_attack.tscn";
	var effect = load(path).instance();
	effect.host = host;
	effect.attack_state = self;
	host.add_child(effect);
	"""
	pass;

func set_save_event():
	save_event = true;

func set_interrupt():
	interrupt = true;
	follow_up = true;

func check_combo():
	pass;

func attack_done():
	busy = false;
	attack_triggered = false;
	dashing = false;
	save_event = false;
	previous_event = current_event;
	interrupt = false;
	reset_strings();
	$ComboTimer.start();
	#host.activate_grav();
	pass;