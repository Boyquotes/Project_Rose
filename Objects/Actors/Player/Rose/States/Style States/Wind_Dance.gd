extends "./Style_State.gd"

func enter():
	.enter();
	get_parent().style_state = 'wind_dance';
	style = "Wind_Dance";

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

func parse_attack():
	if(chargedx):
		current_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(X_pressed() && $ChargeXTimer.is_stopped() && !slottedx):
		if(previous_event == "Y" || combo == "XX"):
			current_event = "HoldX";
			slottedx = true;
			combo = "";
		else:
			current_event = "X";
			$ChargeXTimer.start();
			slottedx = true;
	if(Input.is_action_just_released("attack") && slottedx && (current_event == "X" || current_event == "HoldX")):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(B_pressed()):
		#if(Input.is_action_pressed("attack")):
		#	current_event = "X+B";
		#elif(previous_event == "X" && hit):
		#	current_event = "XB";
		#else:
		current_event = "B";
		
		if(current_event == "B"):# || current_event == "XB"  || current_event == "X+B"):
			if(!host.on_floor() && !hit):
				started_save = false;
				current_event = "current_event";
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
	
	if(chargedy && host.mana >= 100):
		current_event = "Y";
		slottedy = true;
		#combo = "";
		#TODO: HoldY
	elif(Y_pressed() && $ChargeYTimer.is_stopped() && !slottedy):
		current_event = "Y";
		$ChargeYTimer.start();
		slottedy = true;
	if(Input.is_action_just_released("special") && slottedy && (current_event == "Y" || current_event == "HoldY")):
		if(current_event == "Y" || combo == "X" || combo == "XX"):
			combo = "";
		$ChargeYTimer.stop();
		cur_cost = basic_cost;
		return true;
	switch();
	return false;

func parse_next_attack():
	if(chargedx):
		saved_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(X_pressed() && !slottedx):
		started_save = true;
		if(current_event == "Y" || combo == "XX"):
			saved_event = "HoldX";
			slottedx = true;
			combo = "";
		else:
			saved_event = "X";
			$ChargeXTimer.start();
			slottedx = true;
	if(Input.is_action_just_released("attack") && slottedx && (saved_event == "X" || saved_event == "HoldX")):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(B_pressed()):
		started_save = true;
		#if(Input.is_action_pressed("attack")):
		#	saved_event = "X+B";
		#elif(previous_event == "X" && hit):
		#	saved_event = "XB";
		#else:
		saved_event = "B";
		
		if(saved_event == "B"): #|| saved_event == "XB"  || saved_event == "X+B"):
			
			if(!host.on_floor() && !hit):
				started_save = false;
				saved_event = "saved_event";
				slottedx = false;
				slottedy = false;
				B = false;
				return false;
			combo = "";
			$ChargeXTimer.stop();
			cur_cost = basic_cost;
			return true;
	
	if(chargedy && host.mana >= 100):
		saved_event = "Y";
		slottedy = true;
		#combo = "";
		#TODO: HoldY
	elif(Y_pressed() && $ChargeYTimer.is_stopped() && !slottedy):
		started_save = true;
		saved_event = "Y";
		$ChargeYTimer.start();
		slottedy = true;
	if(Input.is_action_just_released("special") && slottedy && (saved_event == "Y" || saved_event == "HoldY")):
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
	X = false;
	Y = false;
	B = false;
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
				if(place == "_Ground"):
					vdir = "";
					dir = "_Hor";
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

func construct_attack_string():
	.construct_attack_string();
	if(((dir != "_Hor" && vdir == "_Down") || current_event == "HoldX") || (current_event == "Y" && (dir != "_Hor" && vdir == "_Down"))):
		attack_str = style + "_" + combo+dir+vdir+place;
	else:
		attack_str = style + "_" + combo+dir+vdir;
	if(current_event == "HoldX" || current_event == "B"):
		bot_str = attack_str;
	else:
		bot_str = style + "_" + combo + place; 

func attack_done():
	if(!saved_event):
		if(!Input.is_action_pressed("attack")):
			chargedx = false;
		if(!Input.is_action_pressed("special")):
			chargedy = false;
		slottedx = false;
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
	get_parent().exit_g_or_a();
