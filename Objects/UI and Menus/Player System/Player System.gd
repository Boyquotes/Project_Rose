extends Control

signal hit_zero;

var hp_lifetime;
var mana_lifetime;
var hp_count;
var mana_count;

func _ready():
	hp_lifetime = $HealthBar/Particles2D.lifetime;
	mana_lifetime = $ManaBar/Particles2D.lifetime;
	hp_count = $HealthBar/Particles2D.amount;
	mana_count = $ManaBar/Particles2D.amount;

func _on_Rose_hp_changed(hp):
	$HealthBar.value = hp;
	var percent = $HealthBar.value/$HealthBar.max_value;
	if($HealthBar/Particles2D.lifetime > 1):
		$HealthBar/Particles2D.lifetime = hp_lifetime * percent;
	if(percent <= .2):
		$HealthBar/Particles2D.emitting = false;
	else:
		$HealthBar/Particles2D.emitting = true;
	if($HealthBar.value <= 0):
		emit_signal("hit_zero");

func _on_Rose_mana_changed(mana):
	$ManaBar.value = mana;
	var percent = $ManaBar.value/$ManaBar.max_value;
	if(percent > .1):
		$ManaBar/Particles2D.lifetime = mana_lifetime * percent;
	if(percent <= .2):
		$ManaBar/Particles2D.emitting = false;
	else:
		$ManaBar/Particles2D.emitting = true;

func _on_Rose_focus_changed(focus):
	$FocusSprite.frame = int(focus);
