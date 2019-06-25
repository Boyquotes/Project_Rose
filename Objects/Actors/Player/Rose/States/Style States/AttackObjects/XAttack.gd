extends "./Attack.gd"

### All attacks need versions of these ###
func _on_AttackTimer_timeout():
	._on_AttackTimer_timeout();
	if(attack_state.hit && !host.on_floor()):
		host.vspd = 0;
		host.velocity.y = 0;
		attack_state.floating = true;
		attack_state.get_node("FloatTimer").wait_time = fl;
		attack_state.get_node("FloatTimer").start();
	attack_state.get_node("RecoilTimer").wait_time = recoil;
	attack_state.get_node("RecoilTimer").start();
	pass;