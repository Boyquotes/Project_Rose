extends "../Enemy_Stun_State.gd"


func handleAnimation():
	pass;

func handleInput(event):
	pass;

func continue_stun():
	.continue_stun();
	hurt.get_node("Damage_Timer").wait_time += $stunTimer.time_left;