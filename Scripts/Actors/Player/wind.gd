extends Marker2D

enum WindType {NONE, GENTLE, MILD, STRONG, TORRENT}

@export var wind := Vector2(0.0, 0.0)
@export var wind_type = WindType.GENTLE
@export var directional := false
@export var direction := 0.0
@export var time_mod := 1.0
var prev_type = WindType.GENTLE
var rng = RandomNumberGenerator.new()
var roll_wind = false
var wind_chaos := 0.0

var deltatime = 0.0

func _process(_delta):
	rng.randomize()
	
	deltatime += _delta * time_mod
	
	match(wind_type):
		WindType.NONE:
			wind = Vector2(0,0)
		WindType.GENTLE:
			var mod_rotation = rotation + sin(deltatime) * PI/6
			wind_chaos = -1
			if roll_wind:
				roll_wind = false
			wind = Vector2(500, 0).rotated(scale.x * mod_rotation)
		WindType.MILD:
			wind_chaos = -.5
			if roll_wind:
				roll_wind = false
			wind = Vector2(1000, 0).rotated(scale.x * rotation)
		WindType.STRONG:
			wind_chaos = 2
			if roll_wind:
				roll_wind = false
			wind = Vector2(2000, 0).rotated(scale.x * rotation)
		WindType.TORRENT:
			wind_chaos = 3
			if directional:
				wind = (Vector2(1000, 0) * (1.25 * (sin(deltatime + rng.randf_range(0, 4))) + .5)).rotated(direction + rng.randf_range(-PI/4, PI/4))
			else:
				if roll_wind:
					roll_wind = false
				wind = Vector2(4000, 0).rotated(scale.x * rotation)
