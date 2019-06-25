extends "./Attack.gd"

#For attacks that don't trigger set displacement

func _on_AttackTimer_timeout():
	._on_AttackTimer_timeout();
	if(attack_state.hit && !host.on_floor()):
		attack_state.floating = true;
		attack_state.get_node("FloatTimer").wait_time = fl;
		attack_state.get_node("FloatTimer").start();
	attack_state.get_node("RecoilTimer").wait_time = recoil;
	attack_state.get_node("RecoilTimer").start();
	attack_state.dashing = false;
	pass;


func _on_WindupTimer_timeout():
	._on_WindupTimer_timeout();
	attack_state.dashing = true;
	pass;
