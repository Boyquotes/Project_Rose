extends "../Enemy_Hurt_State.gd"

func handleAnimation():
	if(!animated):
		animated = true;
		host.animate(host.get_node("shaderAnimator"),"hurt", true);

func slash_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;

func bash_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;
	host.stun_damage += stun_damage;

func pierce_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;

func true_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * 25;

func stunned():
	hurt.armor = [0,0,0,0];
	.stunned();