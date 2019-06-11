extends "./Attack.gd"

export(int) var post_movement = 25;
export(bool) var movex = true;
export(bool) var movey = true;
export(bool) var iframe = false;
export(bool) var floaty = true;
func _physics_process(delta):
	if(movex):
		displacex();
	if(movey):
		displacey();

func _on_AttackTimer_timeout():
	._on_AttackTimer_timeout();
	if(!host.on_floor() && floaty):
		attack_state.floating = true;
		attack_state.get_node("FloatTimer").wait_time = fl;
		attack_state.get_node("FloatTimer").start();
		if(movey):
			host.vspd = post_movement;
		if(movex):
			host.hspd = post_movement * host.Direction;
	attack_state.get_node("RecoilTimer").wait_time = recoil;
	attack_state.get_node("RecoilTimer").start();
	attack_state.dashing = false;
	pass;


func _on_WindupTimer_timeout():
	._on_WindupTimer_timeout();
	attack_state.dashing = true;
	if(!iframe):
		if(!Input.is_action_pressed("lock")):
			host.hspd = speedx * host.Direction;
		host.vspd = speedy * vDirection;
	else:
		host.hspd = speedx * host.Direction;
		host.vspd = speedy * vDirection;
	pass;
