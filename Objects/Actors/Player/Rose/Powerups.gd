extends Node2D

onready var powerups = {
	'focus' : 0,
	'channel' : 1,
	'reinforced_stitching' : 2,
	'vortex_rune' : 3,
	'magus_sleeve' : 4,
	'bounding_sleeve' : 5,
	'lightning_rune' : 6,
	'reinforced_casing' : 7,
	'regrowth_casing' : 8,
	'boulder_rune' : 9,
	'cape_circuit' : 10,
	'aether_hook' : 11
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

func _ready():
	for idx in powerups_idx.size():
		var switch = GameFlags.powerups.values()[idx]
		powerups_idx[idx] = switch;

func get_powerup(key):
	return powerups_idx[powerups[key]];
