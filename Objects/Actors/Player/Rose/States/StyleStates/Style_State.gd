extends "../State.gd"

onready var Wind_Dance = get_parent().get_node("Wind_Dance");
onready var Closed_Fan = get_parent().get_node("Closed_Fan");
onready var ground = get_parent().get_parent().get_node("Move_On_Ground");
onready var air = get_parent().get_parent().get_node("Move_In_Air");
onready var ledge = get_parent().get_parent().get_node("Ledge_Grab");
onready var attack = get_parent().get_parent().get_node("Attack");

signal attack;

### temp inits ###
var on_cooldown = false;
var hit = false;
#end of the attack
var attack_end = false;
var attack_is_saved = false;
var attack_triggered = false;
var busy = false;
var save_event = false;
var event_is_saved = false;
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
var air_counter = 1;
var cool = 1;
var base_cost = 15;
var spec_cost = 25;
var basic_cost = 15;
var cur_cost = 0;

### debug_vars ###
export(bool) var input_testing = false;
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

func execute(delta):
	if(!Input.is_action_pressed("attack")):
		chargedx = false;
		$ChargeXTimer.stop();
	else:
		$ComboTimer.start();
	if(!Input.is_action_pressed("special")):
		chargedy = false;
		$ChargeYTimer.stop();
	else:
		$ComboTimer.start();

func _process(delta):
	if(Input.is_action_just_pressed("switchUp")):
		if(get_parent().style_state != 'wind_dance'):
			exit(Wind_Dance);
	if(Input.is_action_just_pressed("switchDown")):
		if(get_parent().style_state != 'closed_fan'):
			exit(Closed_Fan);

func enter():
	attack_end = false;
	#print("   " + get_parent().get_child(style_idx).name);
	#print(get_parent().get_child(stm1).name + "   " + get_parent().get_child(stp1).name);

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		if(busy && animate):
			host.animate(host.get_node("TopAnim"),attack_str, true);
			animate = false;
	pass;

### Prepares next move if user input is detected ###
func handleInput():
	if((interrupt || (follow_up && !started_save)) && attack_is_saved):
		attack_done();
		attack_end = false;
		current_event = saved_event;
		combo += saved_event;
		busy = true;
		follow_up = false;
		attack_is_saved = false;
		set_position_vars();
	if(!busy && !started_save):
		if(parse_attack()):
			attack_end = false;
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
	"""
		print(String(interrupt) + " || " + String(!started_save) + ") && " + String(attack_is_saved));
		print(busy);
	if(Input.is_action_just_released("attack")):
		print(String(interrupt) + " || " + String(!started_save) + ") && " + String(attack_is_saved));
		print(busy);
		print("____________________");"""

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
	combo = "";
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
	attack_end = false;
	attack_is_saved = false;
	attack();

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	pass;

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
	
	construct_attack_string();
	if(input_testing):
		print(attack_str);
		attack_done();
	else:
		animate = true;
		$ComboTimer.start();
	#TODO: Get appropriate path to attack scene
	pass;

func set_save_event():
	save_event = true;

func set_interrupt():
	interrupt = true;
	follow_up = true;

func check_combo():
	pass;

func attack_done():
	hit = false;
	X = false;
	Y = false;
	B = false;
	attack_end = true;
	busy = false;
	attack_triggered = false;
	save_event = false;
	previous_event = current_event;
	interrupt = false;
	reset_strings();
	$ComboTimer.start();

	pass;

func X_pressed():
	return X || Input.is_action_just_pressed("attack");

func B_pressed():
	return B || Input.is_action_just_pressed("dodge");

func Y_pressed():
	return Y || Input.is_action_just_pressed("special");