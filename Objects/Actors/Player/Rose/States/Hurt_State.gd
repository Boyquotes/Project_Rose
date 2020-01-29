extends "./Free_Motion_State.gd"

var damage = 0;
var direction = 0;
var compare_to;

func enter():
	host.move_state = 'hurt';
	host.change_hp(-damage);
	host.deactivate_fric();
	update_look_direction_and_scale(direction);
	$hurtTimer.start();

func handleAnimation():
	host.animate(host.spr_anim,"hurt", false);

func handleInput():
	pass;

func execute(delta):
	if(host.hspd != 0 && host.fric_activated):
		if(abs(host.hspd) <= host.true_friction):
			host.hspd = 0;
		else:
			host.hspd -= host.true_friction * sign(host.hspd);

func exit(state):
	damage = 0;
	direction = 0;
	host.activate_fric();
	.exit(state);

func _on_hurtTimer_timeout():
	host.get_node("Hitbox").get_child(0).disabled = false;

func KnockBack(var speed, var angle):
	var buffer = 0;
	if(compare_to.x > host.global_position.x):
		buffer = 90;
	host.add_velocity(speed,angle-buffer);
