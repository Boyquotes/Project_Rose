extends Node2D

enum KnockbackType {AWAY, LINEAR, VORTEX};

export(float) var knockback;
export(KnockbackType) var knockback_type;