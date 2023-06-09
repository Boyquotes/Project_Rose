class_name Vitality
extends Node

signal vital_died
signal vital_injured

@export var max_health := 5
@export var vital_type := GlobalEnums.VitalType.BRAIN
@export var weakness := GlobalEnums.AttackType.ALL
@export var hitboxes : Array
var health := 0

func _ready():
	hitboxes = hitboxes.duplicate()
	health = max_health
	for i in hitboxes.size():
		hitboxes[i] = get_node(hitboxes[i])
		hitboxes[i].area_entered.connect(_on_hit)


func change_health(change := 0):
	health += change

func upgrade_health(change := 1):
	max_health += change

func _on_player_hit(area):
	var attack = area.get_parent() as Enemy
	if not attack:
		attack = area.get_parent().action as CharacterAction
		if not attack:
			printerr("somehow hit by something that isn't an attack or enemy...")
			return
	
	change_health(-attack.damage)
	if health <= 0:
		emit_signal("vital_died", self)
		get_parent().set_deferred("monitoring", false);
		get_parent().set_deferred("monitorable", false);
		return
	emit_signal("vital_injured", self)

func _on_hit(area):
	var attack_container := area.get_parent() as ActionHitboxContainer
	var attack := attack_container.action as CharacterAction
	if not attack:
		printerr("somehow hit by something that isn't an attack...")
		return
	
	if attack.hits >= attack.hit_limit:
		return
	
	var valid := false
	for hitbox in hitboxes:
		if attack_container.valid_targets.has(hitbox):
			valid = true
		if not valid:
			return
	
	attack.hits += 1
	var modifier = 1
	if attack.type == weakness:
		modifier = 2
	elif attack.type != weakness && weakness != GlobalEnums.AttackType.ALL:
		modifier = 0.5
	change_health(-attack.damage * modifier)
	if health <= 0:
		emit_signal("vital_died", self)
		get_parent().set_deferred("monitoring", false);
		get_parent().set_deferred("monitorable", false);
		return
	emit_signal("vital_injured", self)
