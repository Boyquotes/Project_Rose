extends "../State.gd"

onready var ground = get_parent().get_node("Move_On_Ground");
onready var air = get_parent().get_node("Move_In_Air");
onready var ledge = get_parent().get_node("Ledge_Grab");