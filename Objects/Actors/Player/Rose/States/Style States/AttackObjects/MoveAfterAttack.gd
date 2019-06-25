extends "./MoveAttack.gd"

var gpos;

func initialize():
	.initialize();
	gpos = global_position;

func _on_WindupTimer_timeout():
	._on_WindupTimer_timeout();
	host.remove_child(self);
	host.get_parent().add_child(self);
	position = gpos;
	pass;