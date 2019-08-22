extends Node2D

onready var powerups = {
	'reinforced_casing' : 0,
	'balancing_harness' : 1,
	'reinforced_fabric' : 2,
	'mana_fabric' : 3,
	'rock_rune' : 4,
	'explosive_rune' : 5,
	'magus_sleeve' : 6,
	'mounting_hook' : 7,
	'quick_mechanism' : 8,
	'hurricane_rune' : 9,
	'breaker_rune' : 10,
	'huntress_rune' : 11
}
onready var powerups_idx = {
	0 : false,
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
	11 : false
}
var glide;

func _ready():
	glide = get_powerup('mana_fabric') && get_powerup('reinforced_fabric');

func _process(delta):
	glide = get_powerup('mana_fabric') && get_powerup('reinforced_fabric');

func get_powerup(key):
	return powerups_idx[powerups[key]];