extends "./Style_State.gd"

func enter():
	.enter();
	host.style_state = 'pierce';
	type = "pierce";
	pass;