extends Node2D

var clicked = false;
var default_vol = -15
var vol = default_vol;
func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol);
	pass;

func _process(delta):
	if(clicked):
		$TextureButton.rect_global_position.x = get_global_mouse_position().x-8;
		if($TextureButton.rect_position.x >= 40):
			$TextureButton.rect_position.x = 40;
		elif($TextureButton.rect_position.x <= -40):
			$TextureButton.rect_position.x = -40;
		vol = default_vol + $TextureButton.rect_position.x;
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol);
	pass;

func _on_TextureButton_button_down():
	clicked = true;
	pass;

func _on_TextureButton_button_up():
	clicked = false;
	pass;
