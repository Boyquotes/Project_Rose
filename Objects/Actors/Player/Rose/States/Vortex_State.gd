extends "./Free_Motion_State.gd"

export(float) var cost = 2;

func enter():
	host.can_channel_and_focus = false;
	host.regain_mana = false;
	$costTimer.start();
	host.move_state = 'vortex';
	update_look_direction_and_scale(1);

func handleAnimation():
	host.animate(host.spr_anim,"Vortex", false);
	host.get_node("Sprites/Sprite").rotation = host.rad;

func handleInput():
	if(Input.is_action_just_pressed("Jump")):
		exit_g_or_a();
		return;
	if(host.mana < cost):
		exit_g_or_a();
		return;

func execute(delta):
	host.vspd = sin(host.rad) * host.base_mspd * 1.2;
	host.hspd = cos(host.rad) * host.base_mspd * 1.2;

func exit(state):
	host.can_channel_and_focus = true;
	host.regain_mana = true;
	$costTimer.stop();
	host.set_rotation_to_origin("Sprites/Sprite");
	.exit(state);

func _on_costTimer_timeout():
	host.change_mana(-cost);
