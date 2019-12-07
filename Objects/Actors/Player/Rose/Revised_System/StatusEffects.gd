extends Node2D

signal slow;

func _on_StatusEffects_slow():
	get_parent().true_mspd = get_parent().base_mspd / 2;
	get_parent().true_jspd = get_parent().base_jspd / 2;
	$slowTimer.start();


func _on_slowTimer_timeout():
	get_parent().true_mspd = get_parent().base_mspd;
	get_parent().true_jspd = get_parent().base_jspd;
