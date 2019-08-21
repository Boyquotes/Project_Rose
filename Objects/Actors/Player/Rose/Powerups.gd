extends Node2D

onready var powerups = {
	'reinforced_casing' : 1,
	'balancing_harness' : 2,
	'reinforced_fabric' : 3,
	'mana_fabric' : 4,
	'rock_rune' : 5,
	'explosive_rune' : 6,
	'magus_sleeve' : 7,
	'mounting_hook' : 8,
	'quick_mechanism' : 9,
	'hurricane_rune' : 10,
	'breaker_rune' : 11,
	'huntress_rune' : 12
}
onready var powerups_idx = {
	1 : false,
	2 : false,
	3 : false,
	4 : false,
	5 : false,
	6 : false,
	7 : false,
	8 : false,
	9 : false,
	10 : false,
	11 : false,
	12 : false
}
var glide;

func _ready():
	glide = get_powerup('mana_fabric') && get_powerup('reinforced_fabric');

func _process(delta):
	glide = get_powerup('mana_fabric') && get_powerup('reinforced_fabric');

func get_powerup(key):
	return powerups_idx[powerups[key]];