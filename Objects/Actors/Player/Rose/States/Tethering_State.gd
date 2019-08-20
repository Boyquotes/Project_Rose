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

func enter():
	exit(attack); #TODO: get rid of this
	host.move_state = 'tethering';
	for c in creatures:
		#put c in stunned state
		#make sure stunning doesn't timeout
		#create tethers on each creature
		pass;
	$tetherTimer.start();

func handleAnimation():
	pass;

func handleInput():
	#TODO: directions
	if(!Input.is_action_pressed("pierce_attack") || end):
		launch();

func execute(delta):
	pass;

func launch(deg = -90):
	for t in tethers:
		t.launch(deg);

func exit(state):
	end = false;
	if(!host.on_floor()):
		host.jump();
	creatures.clear();
	tethers.clear();
	.exit(state);

func _on_tetherTimer_timeout():
	end = true;
