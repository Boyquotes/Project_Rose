extends "../Enemy_Hurt_State.gd"

func slash_damage():
	normal_knockback();

func bash_damage():
	normal_knockback();
	host.stun_damage += damage;

func pierce_damage():
	normal_knockback();

func true_damage():
	normal_knockback();

func stunned():
	.stunned();