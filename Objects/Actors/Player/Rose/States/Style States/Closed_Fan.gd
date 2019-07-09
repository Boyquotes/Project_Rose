extends "./Style_State.gd"

var chargedx = false;
var chargedy = false;
var slottedx = false;
var slottedy = false;

func enter():
	.enter();
	host.style_state = 'closed_fan';
	style = "closed_fan";
	pass;

func handleInput():
	.handleInput();
	if(!attack_triggered):
		if(chargedx):
			current_event = "HoldX";
			slottedx = true;
			combo = "";
		elif(Input.is_action_just_pressed("attack") && $ChargeXTimer.is_stopped() && !slottedx):
			if(previous_event == "B"):
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
			attack_triggered = true;
		
		if(Input.is_action_just_pressed("dodge")):
			
			if(current_event == "X" || current_event == "HoldX" && host.on_floor()):
				current_event = "X+B";
			elif(previous_event == "Y" && hit):
				current_event = "YB";
			elif(host.on_floor()):
				current_event = "B";
			if(current_event == "B" || current_event == "XB"  || current_event == "X+B"):
				combo = "";
				$ChargeXTimer.stop();
				dashing = true;
				cur_cost = basic_cost;
				attack_triggered = true;
		
		if(chargedy && host.mana >= 100):
			current_event = "HoldY";
			slottedy = true;
			combo = "";
		elif(Input.is_action_just_pressed("special") && $ChargeYTimer.is_stopped() && !slottedy):
			current_event = "Y";
			$ChargeYTimer.start();
			slottedy = true;
		if(Input.is_action_just_released("special") && slottedy):
			if(previous_event == "Y" || combo == "X"):
				combo = "";
			$ChargeYTimer.stop();
			cur_cost = basic_cost;
			attack_triggered = true;
		switch();

func set_position_vars():
	if(!host.on_floor()):
		if(atk_down() && current_event == "X" || current_event == "HoldX"):
			dir = "";
			vdir = "_down";
	elif(current_event == "B"):
		if(atk_up()):
			vdir = "_up";
		elif(atk_down()):
			vdir = "_down";
	if(current_event == "Y" || current_event == "YB"):
		if(atk_left()):
			dir = "_horizontal"
		elif(atk_right()):
			dir = "_horizontal";
		if(atk_down() || atk_up()):
			if(!atk_left() && !atk_right()):
				dir = "";
			if(atk_up()):
				vdir = "_up";
			elif(atk_down()):
				vdir = "_down";
		else:
			vdir = "";
			dir = "_horizontal"
	if(current_event == "HoldY"):
		dir = "";
		vdir 
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
	if(previous_event == "HoldX"):
		combo = "";
	if(current_event == "X+B" || current_event == "HoldY"):
		combo = "";
	if(combo == "XX"):
		combo = "";
	.attack_done();
	pass;

func _on_ChargeXTimer_timeout():
	chargedx = true;


func _on_ChargeYTimer_timeout():
	chargedy = true;
