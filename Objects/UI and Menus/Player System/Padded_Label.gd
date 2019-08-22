extends Label

export(int) var padding = 35;

func _ready():
	#add_font_override("font", load("res://Prototyping/consola.ttf"));
	var pad = "%-" + String(padding) + "s";
	text = pad % text;