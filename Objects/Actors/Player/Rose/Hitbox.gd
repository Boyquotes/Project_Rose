extends Area2D

enum HIT_TYPE{DAMAGE,SLOW};
onready var hurt = get_parent().get_node("Movement_States/Hurt");
onready var status = get_parent().get_node("StatusEffects");

func _ready():
	$Hitbox.disabled = false;

func _on_Hitbox_area_entered(area):
	if(get_parent().iframe):
		return;
	match(area.hit_type):
		HIT_TYPE.DAMAGE:
			hurt.damage = area.damage;
			get_parent().move_states[get_parent().move_state].exit(hurt);
			hurt.direction = sign(area.global_position.x - global_position.x);
		HIT_TYPE.SLOW:
			status.emit_signal("slow");