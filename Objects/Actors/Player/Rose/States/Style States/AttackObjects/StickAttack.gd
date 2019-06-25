extends "res://Objects/Actors/Player/Rose/AttackObjects/DontMoveAttack.gd"

func initialize():
	.initialize();
	attack_traversal.x = 32;
	attack_traversal.y = 16;
	pass;

func _on_AttackTimer_timeout():
	._on_AttackTimer_timeout();
	attack_state.get_node("RecoilTimer").wait_time = recoil;
	attack_state.get_node("RecoilTimer").start();
	attack_state.dashing = false;
	pass;

func on_area_entered(area):
	.on_area_entered(area);
	#TODO: enemy stick
	pass;

func on_body_entered(body):
	host.hspd = 0;
	host.vspd = 0;
	attack_state.emit_signal("vault");
	pass;