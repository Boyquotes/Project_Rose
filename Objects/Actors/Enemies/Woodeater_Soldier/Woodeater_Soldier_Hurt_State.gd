extends "../Enemy_Hurt_State.gd"

func slash_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;

func bash_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;
	host.stun_damage += damage;

func pierce_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;

func true_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;

func stunned():
	.stunned();