extends "./MoveBeforeAttack.gd"
var hit = false;

func _on_AttackTimer_timeout():
	._on_AttackTimer_timeout();
	if(!hit):
		host.hspd = 0;
		host.vspd = 0;
	pass;


func on_area_entered(area):
	speedx = 100;
	speedy = 300;
	hit = true;
	.on_area_entered(area);
	host.hspd = speedx * host.Direction * mDir;
	host.vspd = speedy * vDirection;
	pass;