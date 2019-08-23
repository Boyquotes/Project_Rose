extends Area2D

onready var hurt = get_parent().get_node("Movement_States/Hurt");

func _ready():
	$Hitbox.disabled = false;

func _on_Hitbox_area_entered(area):
	get_parent().move_states[get_parent().move_state].exit(hurt);
	hurt.damage = area.damage;
	hurt.direction = sign(area.global_position.x - global_position.x);