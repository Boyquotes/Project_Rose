extends "./Style_State.gd"

func enter():
	.enter();
	get_parent().style_state = 'closed_fan';
	style = "Closed_Fan";

func parse_attack():
	if(chargedx):
		current_event = "HoldX";
		slottedx = true;
		combo = "";
	elif(X_pressed() && $ChargeXTimer.is_stopped() && !slottedx):
		if(previous_event == "B"):
			current_event = "HoldX";
			slottedx = true;
			combo = "";
		elif(previous_event == "HoldX"):
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
		else:
			current_event = "B";
		
		if(current_event == "B" || current_event == "YB"):
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

func set_position_vars():
	if(!host.on_floor()):
		if(current_event == "HoldX" || current_event == "QuickX"):
			current_event = "X";
		if(atk_down() && current_event == "X"):
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
			if(atk_down() && !(atk_left() || atk_right()) && host.on_floor()):
				vdir = "";
				dir = "_Hor"
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

func attack_done():
	chargedx = false;
	slottedx = false;
	chargedy = false;
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
	if(current_event == "X+B" || current_event == "HoldY" || current_event == "QuickX"):
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
		host.get_node("Camera2D").shake(.2, 15, 8);
		hit = true;
		if(current_event != "Y"):
			if(place == "_Air" && vdir == "_Down"):
				host.jump()
				$HitGravTimer.start();
			elif(!host.on_floor()):
				host.deactivate_grav();
				$HitGravTimer.start();

func _on_HitGravTimer_timeout():
	hit = false;
	host.activate_grav();
