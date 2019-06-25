extends "./Style_State.gd"

func enter():
	.enter();
	host.style_state = 'bash';
	type = "bash";
	pass;