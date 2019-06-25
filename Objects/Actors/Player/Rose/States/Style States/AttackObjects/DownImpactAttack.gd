extends "res://Objects/Actors/Player/Rose/AttackObjects/Attack.gd"

var impacted = false;

func initialize():
	.initialize();
	host.hspd = 0;

func _physics_process(delta):
	if(host.on_floor() && !impacted):
		impact();
	pass;

func _on_WindupTimer_timeout():
	col.disabled = false;
	visible = true;
	attack_state.attack_mid = true;
	attack_state.attack_start = false;
	attack_state.dashing = true;
	host.vspd = speedy;
	pass;

func impact():
	host.vspd = 0;
	$AttackTimer.wait_time = attack;
	$AttackTimer.start();
	$collider2.disabled = false;
	$collider2.visible = true;
	knockback = Vector2(200, -400);
	attack_state.attack_mid = false;
	attack_state.dashing = false;
	impacted = true;

func _on_AttackTimer_timeout():
	._on_AttackTimer_timeout();
	attack_state.get_node("RecoilTimer").wait_time = recoil;
	attack_state.get_node("RecoilTimer").start();
	pass;