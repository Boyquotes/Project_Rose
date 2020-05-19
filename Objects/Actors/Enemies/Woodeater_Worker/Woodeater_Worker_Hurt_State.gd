extends "../Enemy_Hurt_State.gd"

func slash_damage():
	if(host.injured):
		normal_knockback();
	else:
		host.hspd = cos(deg2rad(damage_area.direction)) * 75;

func bash_damage():
	normal_knockback();
	host.stun_damage += damage;
func pierce_damage():
	if(host.injured):
		normal_knockback();
	else:
		host.hspd = cos(deg2rad(damage_area.direction)) * 75;
func true_damage():
	normal_knockback();

func stunned():
	if(!host.injured):
		host.break_shell();
	.stunned();
