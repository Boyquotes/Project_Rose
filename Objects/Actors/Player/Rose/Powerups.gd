extends Node2D

export(bool) var reinforced_casing = false;
export(bool) var balancing_harness = false;
export(bool) var reinforced_fabric = false;
export(bool) var mana_fabric = false;
export(bool) var rock_rune = false;
export(bool) var explosive_rune = false;
export(bool) var magus_sleeve = false
export(bool) var mounting_hook = false;
export(bool) var quick_mechanism = false;
export(bool) var hurricane_rune = false;
export(bool) var breaker_rune = false;
export(bool) var huntress_rune = false;
var glide;

func _ready():
	glide = mana_fabric && reinforced_fabric;

func _process(delta):
	glide = mana_fabric && reinforced_fabric;