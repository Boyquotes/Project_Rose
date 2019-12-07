extends "./Free_Motion_State.gd"

#Potential tether design:
"""
On pierce hit, save creature to an array owned by a new state called the "tethering" 
state.
If after the hitbox is deactivated the player is holding the pierce button, 
change player state to the "tethering" state. Once in the tethering state, the player
has a few seconds to give input. If the pierce button is released or the time elapses,
the creatures are struck upwards by default. If the player gives any directional input, 
the creatures are struck in that direction.
If the player is in the air, give the player a small jump before exiting the state.

The player getting hit out of the state and into the hurt state should trigger 
default behavior, but it should be easy to cancel everything.

This strike is not an attack; upon entering the tethering state, the creatures will be
sent to their default stun states and a number of visual indicators will be instanced, 
marking the creatures as tethered. When the player's input or lackthereof is indicated,
each of these indicators will get a signal. The signal triggers the "attack."
This attack should work on all creatures that can be tethered. The attacks should also
handle freeing all the "visual indicator" scenes. Exiting the "tethering" state should
clear all the arrays.
"""

var creatures = [];
var tethers = [];
var end = false;
var time = 2;
var direction;

func enter():
	host.move_state = 'tethering';
	host.deactivate_grav();
	host.deactivate_fric();
	host.hspd = 0;
	host.vspd = 0;
	for c in creatures:
		c.states['stun'].true_time = time;
		c.states[c.state].exit(c.states['stun']);
		c.deactivate_grav();
		c.deactivate_fric();
		c.hspd = 0;
		c.vspd = 0;
		c.velocity = Vector2(0,0);
		tethers.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Tether/Tether.tscn").instance());
		tethers[tethers.size()-1].host = host;
		host.get_parent().add_child(tethers[tethers.size()-1]);
		tethers[tethers.size()-1].global_position = c.global_position;
	$tetherTimer.start();

func handleAnimation():
	host.get_node("TopAnim").stop();
	pass;

func handleInput():
	if(up_wider()):
		direction = -90;
		direction += (int(right_wider()) - int(left_wider())) * 45;
	elif(down_wider()):
		direction = 90;
		direction += (int(left_wider()) - int(right_wider())) * 45;
	else:
		direction = int(left_wider()) * 180;
	if(left() || right() || up() || down()):
		launch(direction);
		host.change_mana(-30);
		if(get_attack_pressed()):
			exit(attack);
		else:
			exit_g_or_a();
	elif(!Input.is_action_pressed("Use_Mana") || end):
		launch();
		host.change_mana(-30);
		exit_g_or_a();

func left_wider():
	return Input.get_joy_axis(0,0) < -0.3 || Input.get_joy_axis(0,2) < -0.3;

func right_wider():
	return Input.get_joy_axis(0,0) > 0.3 || Input.get_joy_axis(0,2) > 0.3;

func up_wider():
	return Input.get_joy_axis(0,1) < -0.3 || Input.get_joy_axis(0,3) < -0.3;

func down_wider():
	return Input.get_joy_axis(0,1) > 0.3 || Input.get_joy_axis(0,3) > 0.3;

func left():
	return Input.is_action_just_pressed("Move_Left") || Input.is_action_just_pressed("Dodge_Move_Left")

func right():
	return Input.is_action_just_pressed("Move_Right") || Input.is_action_just_pressed("Dodge_Move_Right")

func up():
	return Input.is_action_just_pressed("Move_Up") || Input.is_action_just_pressed("Dodge_Move_Up")

func down():
	return Input.is_action_just_pressed("Move_Down") || Input.is_action_just_pressed("Dodge_Move_Down")

func execute(delta):
	pass;

func launch(deg = -90):
	for t in tethers:
		t.launch(deg);

func exit(state):
	$tetherTimer.stop();
	host.activate_grav();
	host.activate_fric();
	end = false;
	if(!host.on_floor()):
		host.jump();
	creatures.clear();
	tethers.clear();
	.exit(state);

func _on_tetherTimer_timeout():
	end = true;
