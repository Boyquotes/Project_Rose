extends "./Move_State.gd"


onready var style_states = {
	'wind_dance' : $Style_States/Wind_Dance,
	'closed_fan' : $Style_States/Closed_Fan
}
var style_state = 'wind_dance';

func _ready():
	style_states[style_state].enter();

func enter():
	host.move_state = 'attack';

func handleAnimation():
	style_states[style_state].handleAnimation();

func handleInput():
	style_states[style_state].handleInput();

func execute(delta):
	.execute(delta);

func exit(state):
	.exit(state);
	pass