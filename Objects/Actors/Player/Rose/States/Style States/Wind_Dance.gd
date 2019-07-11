extends "./Style_State.gd"

var chargedx = false;
var chargedy = false;
var slottedx = false;
var slottedy = false;

func enter():
	.enter();
	host.style_state = 'wind_dance';
	style = "Wind_Dance";
	pass;

func _process(delta):
	if(!Input.is_action_pressed("attack")):
		chargedx = false;
		$ChargeXTimer.stop();
	if(!Input.is_action_pressed("special")):
		chargedy = false;
		$ChargeYTimer.stop();
func parse_attack():
	if(chargedx):
		current_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(Input.is_action_just_pressed("attack") && $ChargeXTimer.is_stopped() && !slottedx):
		if(previous_event == "Y" || combo == "XX"):
			current_event = "HoldX";
			slottedx = true;
			combo = "";
		else:
			current_event = "X";
			$ChargeXTimer.start();
			slottedx = true;
	if(Input.is_action_just_released("attack") && slottedx):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		saved_event = current_event;
		return true;
	
	if(Input.is_action_just_pressed("dodge")):
		if(Input.is_action_pressed("attack")):
			current_event = "X+B";
		elif(previous_event == "X" && hit):
			current_event = "XB";
		elif(host.on_floor()):
			current_event = "B";
		
		if(current_event == "B" || current_event == "XB"  || current_event == "X+B"):
			combo = "";
			$ChargeXTimer.stop();
			dashing = true;
			cur_cost = basic_cost;
			saved_event = current_event;
			return true;
	
	if(chargedy && host.mana >= 100):
		current_event = "HoldY";
		slottedy = true;
		combo = "";
	elif(Input.is_action_just_pressed("special") && $ChargeYTimer.is_stopped() && !slottedy):
		current_event = "Y";
		$ChargeYTimer.start();
		slottedy = true;
	if(Input.is_action_just_released("special") && slottedy):
		if(current_event == "Y" || combo == "X" || combo == "XX"):
			combo = "";
		$ChargeYTimer.stop();
		cur_cost = basic_cost;
		saved_event = current_event;
		return true;
	switch();

func parse_next_attack():
	if(chargedx):
		current_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(Input.is_action_just_pressed("attack") && !slottedx):
		#print(combo + current_event);
		if(current_event == "Y" || combo == "XX"):
			saved_event = "HoldX";
			slottedx = true;
			combo = "";
		else:
			saved_event = "X";
			$ChargeXTimer.start();
			slottedx = true;
	if(Input.is_action_just_released("attack") && slottedx):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(Input.is_action_just_pressed("dodge")):
		if(Input.is_action_pressed("attack")):
			saved_event = "X+B";
		elif(previous_event == "X" && hit):
			saved_event = "XB";
		elif(host.on_floor()):
			saved_event = "B";
		
		if(saved_event == "B" || saved_event == "XB"  || saved_event == "X+B"):
			combo = "";
			$ChargeXTimer.stop();
			dashing = true;
			cur_cost = basic_cost;
			return true;
	
	if(chargedy && host.mana >= 100):
		saved_event = "HoldY";
		slottedy = true;
		combo = "";
	elif(Input.is_action_just_pressed("special") && $ChargeYTimer.is_stopped() && !slottedy):
		saved_event = "Y";
		$ChargeYTimer.start();
		slottedy = true;
	if(Input.is_action_just_released("special") && slottedy):
		if(current_event == "Y" || combo == "X" || combo == "XX"):
			combo = "";
		$ChargeYTimer.stop();
		cur_cost = basic_cost;
		return true;
	switch();
	return false;

func set_position_vars():
	chargedx = false;
	chargedy = false;
	slottedx = false;
	slottedy = false;
	if(!host.on_floor()):
		place = "_Air";
		if(current_event == "HoldX"):
			current_event = "X";
			combo = "X"
		if(atk_down() && current_event == "X"):
			dir = "";
			vdir = "_Down";
		if(atk_up() && current_event == "X"):
			dir = "";
			vdir = "_Up";
	else:
		place = "_Ground";
		if(atk_up() && (current_event == "X" || current_event == "HoldX")):
			if(current_event == "HoldX"):
				current_event = "X";
				combo = "X"
			dir = "";
			vdir = "_Up";
		if(atk_down() && current_event == "HoldX"):
			dir = "";
			vdir = "_Down";
	if(current_event == "Y" || current_event == "XB"):
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
		else:
			vdir = "";
			dir = "_Hor"
	if(current_event == "XB" || current_event == "B"):
		dir = "";
		place = "";
	if(init_attack()):
		attack();
	pass;

func exit(state):
	.exit(state);
	chargedx = false;
	slottedx = false;
	chargedy = false;
	slottedy = false;

func attack_done():
	chargedx = false;
	slottedx = false;
	chargedy = false;
	slottedy = false;
	check_combo();
	.attack_done();
	pass;

func check_combo():
	if(current_event == "HoldX" || current_event == "B" || current_event == "X+B" || current_event == "HoldY"):
		combo = "";
	if(combo == "XXX" || combo == "Y"):
		combo = "";

func set_save_event():
	.set_save_event();
	
func set_interrupt():
	.set_interrupt();

func _on_ChargeXTimer_timeout():
	chargedx = true;


func _on_ChargeYTimer_timeout():
	chargedy = true;


func _on_ComboTimer_timeout():
	combo = "";
