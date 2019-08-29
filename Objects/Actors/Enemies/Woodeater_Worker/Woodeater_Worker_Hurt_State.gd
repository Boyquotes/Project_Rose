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