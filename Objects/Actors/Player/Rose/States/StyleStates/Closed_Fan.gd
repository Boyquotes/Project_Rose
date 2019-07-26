extends "./Style_State.gd"

func enter():
	.enter();
	get_parent().style_state = 'closed_fan';
	style = "Closed_Fan";

func parse_attack():
	.parse_attack();
	if(chargedx):
		current_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(X_pressed() && $ChargeXTimer.is_stopped() && !slottedx):
		if(previous_event == "B"):
			current_event = "HoldX";
			slottedx = true;
			combo = "";
		elif(previous_event == "HoldX" || previous_event == "Y"):
			current_event = "QuickX";
			slottedx = true;
			combo = "";
		else:
			current_event = "X";
			$ChargeXTimer.start();
			slottedx = true;
	if(Input.is_action_just_released("attack") && slottedx && (current_event == "X" || current_event == "HoldX" || current_event == "QuickX")):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(B_pressed()):
		if(previous_event == "Y" && hit):
			current_event = "YB";
		elif(host.on_floor()):
			current_event = "B";
		
		if(current_event == "B" || current_event == "YB"):
			if(current_event == "B" && !host.on_floor()):
				current_event = "";
				return false;
			if(current_event == "YB" && !hit):
				current_event = "";
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
	return false;

func parse_next_attack():
	if(.parse_next_attack()):
		return true;
	if(chargedx):
		saved_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(X_pressed() && !slottedx):
		started_save = true;
		if(current_event == "B"):
			saved_event = "HoldX";
			slottedx = true;
			combo = "";
		elif(current_event == "HoldX" || current_event == "Y"):
			saved_event = "QuickX";
			slottedx = true;
			combo = "";
		else:
			saved_event = "X";
			$ChargeXTimer.start();
			slottedx = true;
	if(Input.is_action_just_released("attack") && slottedx && (saved_event == "X" || saved_event == "HoldX" || saved_event == "QuickX")):
		$ChargeXTimer.stop();
		cur_cost = basic_cost;
		return true;
	
	if(B_pressed()):
		started_save = true;
		if(current_event == "Y" && hit):
			saved_event = "YB";
		elif(host.on_floor()):
			saved_event = "B";
		
		if(saved_event == "B" || saved_event == "YB"):
			if(saved_event == "B" && !host.on_floor()):
				saved_event = "";
				return false;
			if(saved_event == "YB" && !hit):
				saved_event = "";
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
	return .parse_next_attack();

func set_position_vars():
	if(!host.on_floor()):
		if(atk_down()):
			if(current_event == "QuickX"):
				current_event = "X";
				combo = "X";
			dir = "";
			vdir = "_Down";
			place = "_Air"
		else:
			place = "";
	else:
		place = "";
		vdir = "";
	if(current_event == "B"):
		if(atk_up()):
			vdir = "_Up";
		else:
			vdir = "";
	if(current_event == "Y" || current_event == "YB"):
		if(atk_left() || atk_right()):
			dir = "_Hor"
		if(atk_down() || atk_up()):
			if(!atk_left() && !atk_right()):
				dir = "";
			if(atk_up()):
				vdir = "_Up";
			elif(atk_down()):
				vdir = "_Down";
			if(atk_down() && host.on_floor()):
				dir = "_Hor";
				vdir = "";
			elif(atk_down()):
				place = "_Air";
		else:
			vdir = "";
			dir = "_Hor"
	if(current_event == "HoldY" && host.on_floor()):
		dir = "";
		vdir = "";
	elif(current_event == "HoldY" && !host.on_floor()):
		if(atk_left() || atk_right()):
			dir = "_Hor"
		if(atk_down() || atk_up()):
			if(!atk_left() && !atk_right()):
				dir = "";
			if(atk_up()):
				vdir = "_Up";
			elif(atk_down()):
				vdir = "_Down";
	.set_position_vars();

func exit(state):
	.exit(state);
	chargedx = false;
	slottedx = false;
	chargedy = false;
	slottedy = false;

func construct_attack_string():
	.construct_attack_string();
	attack_str = style + "_" + combo+dir+vdir+place;
"""
	if(((dir != "_Hor" && vdir == "_Down") || current_event == "HoldX") || (current_event == "Y" && (dir != "_Hor" && vdir == "_Down"))):
		attack_str = style + "_" + combo+dir+vdir+place;
	else:
		attack_str = style + "_" + combo+dir+vdir;
	if(current_event == "HoldX" || current_event == "B"):
		bot_str = attack_str;
	else:
		bot_str = style + "_" + combo + place; 
"""

func set_save_event():
	.set_save_event();

func set_interrupt():
	.set_interrupt();

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

"""
func attack_done():
	print("!!!");
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
"""

func check_combo():
	if(previous_event == "HoldX"):
		combo = "";
	if(combo == "Y" || current_event == "B" || current_event == "YB" || current_event == "HoldY" || current_event == "QuickX"):
		combo = "";
	if(combo == "XX"):
		combo = "";


func _on_ChargeXTimer_timeout():
	chargedx = true;


func _on_ChargeYTimer_timeout():
	chargedy = true;


func _on_ComboTimer_timeout():
	combo = "";
	if(host.move_state == 'attack'):
		get_parent().exit_g_or_a();

func on_hit(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.3, 20, 8);
		hit = true;
		if(place == "_Air" && vdir == "_Down" && current_event == "HoldX"):
			attack.hop = true;
			host.hspd += 200;
			host.jump()
			$HitGravTimer.start();
		elif(!host.on_floor()):
			attack.hover = true;
			host.deactivate_grav();
			$HitGravTimer.start();

func _on_HitGravTimer_timeout():
	hit = false;
	host.activate_grav();
