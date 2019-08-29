extends "../Enemy_Hurt_State.gd"

var animated = false;

func handleAnimation():
	if(!animated):
		animated = true;
		host.animate(host.get_node("animator"),"hurt", false);
		host.animate(host.get_node("shaderAnimator"),"hurt", true);

func exit(state):
	animated = false;
	.exit(state);

func slash_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * knockback;

func bash_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * knockback;
	host.stun_damage += damage;

func pierce_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * knockback;

func true_damage():
	host.hspd = cos(deg2rad(damage_area.direction)) * knockback;