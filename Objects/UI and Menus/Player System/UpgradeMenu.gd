extends PopupMenu

signal update_powerup

func _ready():
	add_check_item("Focus Training: Allows use of several expanded abilities with other powerups. Unlocks swirling attacks, which attacks in both directions and triggers a jump when an enemy is hit.");
	add_check_item("Channel Training: While standing still and channeling, double mana regen. Allows use of several expanded abilities with other powerups.");
	add_check_item("Reinforced Stitching: Allows you to use ranged wind attacks with Channeling.");
	add_check_item("Vortex Circuit: Allows you to take the form of wind, damaging enemies, becoming immune to most damage, and constantly drain mana.");
	add_check_item("Magus Sleeve: Upgrades pierce attacks and allows you to use dash attacks if an enemy can be hit.");
	add_check_item("Binding Sleeve: Allows you to use an attack which puts all marked enemies in stasis and pierce them all again.");
	add_check_item("Lightning Rune: Allows you to take the form of lightning, seeking out enemies and dispatching them instantaneously");
	add_check_item("Reinforced Casing: Allows you to use launching bash attacks.");
	add_check_item("Regrowth Casing: Allows you to use lunging bash attacks which bounce off enemies and surfaces.");
	add_check_item("Boulder Rune: Allows you to take the form of molten earth, charging forward with reckless abandon.");
	add_check_item("Cape Circuit: Allows you to glide and dodge in mid-air while channeling");
	add_check_item("Aether Hook: Allows you to cling to all walls, not just ledges, while focusing");
	
	for idx in get_item_count():
		var switch = GameFlags.powerups.values()[idx]
		set_item_checked(idx, switch);

func _on_PopupMenu_index_pressed(index):
	set_item_checked(index, !is_item_checked(index));
	UserSettings.set_upgrade(GameFlags.powerups.keys()[index], is_item_checked(index));
	emit_signal("update_powerup",index, is_item_checked(index));