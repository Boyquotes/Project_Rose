class_name ActionHitbox
extends Area2D

var host
var action_controller
var action_instancer

export(float) var displacement_strength := 45
export(ActionEnums.DisplacementType) var displacement_type = 0
export(ActionEnums.AttackType) var attack_type = 0
export(float) var direction := 0.0
export(int) var hit_limit := 0
export(int) var damage := 25

var true_displacement_strength := 0
var hits := 0
var disabled := false
