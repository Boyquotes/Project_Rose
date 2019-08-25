extends PopupMenu

signal update_powerup

func _ready():
	add_check_item("Reinforced Casing: Adds directional launches to bash attacks");
	add_check_item("Balancing Harness: Allows you to slash attacks while dodging if you hold attack button beforehand");
	add_check_item("Reinforced Fabric: Allows you to do charged slash attacks");
	add_check_item("Mana Fabric: Allows you to do ranged tornado attacks by pressing the pierce and slash attacks simultaneously");
	add_check_item("Rock Rune: Allows you to do ranged rock attacks by pressing the pierce and bash attacks simultaneously");
	add_check_item("Explosive Rune: Allows you to do a short explosive dash if you dodge while you hold the bash attack button beforehand");
	add_check_item("Magus Sleeve: Upgrades pierce attacks and allows you to tether and launch enemies by holding the Left Channel button when enemies are struck");
	add_check_item("Mounting Hook: Allows you to cling to all walls, not just ledges");
	add_check_item("Quick Mechanism: Upgrades slash attacks to be much faster; adds a double-hit to charged slash attacks");
	add_check_item("Hurricane Rune: Not implemented yet");
	add_check_item("Breaker Rune: Not implemented yet");
	add_check_item("Huntress Rune: Not implemented yet");
	for idx in get_item_count():
		var switch = GameFlags.powerups.values()[idx]
		set_item_checked(idx, switch);

func _on_PopupMenu_index_pressed(index):
	set_item_checked(index, !is_item_checked(index));
	UserSettings.set_upgrade(GameFlags.powerups.keys()[index], is_item_checked(index));
	emit_signal("update_powerup",index, is_item_checked(index));