class_name ActionHitbox
extends Area2D

var host
var action_controller
var action_instancer

@export var displacement_strength := 45
@export var displacement_type = 0 # (GlobalEnums.DisplacementType)
@export var attack_type = 0 # (GlobalEnums.AttackType)
@export var direction := 0.0
@export var hit_limit := 0
@export var damage := 25

var true_displacement_strength := 0
var hits := 0
var disabled := false
