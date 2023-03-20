extends Node

signal health_changed
signal died

@export var max_health := 10
var health;

func _ready():
	health = max_health
	# TODO: load health from save state maybe?

func _process(_delta):
	if health <= 0:
		emit_signal("died")

func change_hp(change):
	health += change
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health)
