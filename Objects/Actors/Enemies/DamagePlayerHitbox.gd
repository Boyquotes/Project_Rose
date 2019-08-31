extends Area2D

enum HIT_TYPE{DAMAGE,SLOW};
export(int) var damage;
export(HIT_TYPE) var hit_type = HIT_TYPE.DAMAGE;
var host