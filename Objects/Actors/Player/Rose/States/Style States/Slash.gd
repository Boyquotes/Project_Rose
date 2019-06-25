extends "./Style_State.gd"

func enter():
	.enter();
	host.style_state = 'slash';
	type = "slash";
	pass;