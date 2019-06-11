extends "./MoveAttack.gd"

func initialize():
	.initialize();
	host.hspd = speedx * host.Direction;
	host.vspd = speedy * vDirection;
	attack_state.dashing = true;
	pass;

