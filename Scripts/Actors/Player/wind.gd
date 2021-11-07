extends Position2D

enum WindType {NONE, GENTLE, MILD, STRONG, TORRENT}

export (Vector2) var wind := Vector2(0.0, 0.0)
export (WindType) var wind_type = WindType.GENTLE
export (bool) var directional := false
export(float) var direction := 0.0
var prev_type = WindType.GENTLE
var rng = RandomNumberGenerator.new()
var roll_wind = false
var wind_chaos := 0.0



func _ready():
	$Timer.start(rng.randf_range(0.5, 5.0))
	set_wind()

var deltatime = 0.0

func _process(_delta):
	rng.randomize()
	
	deltatime += _delta
	
	match(wind_type):
		WindType.NONE:
			wind = Vector2(0,0)
		WindType.GENTLE:
			wind_chaos = -1
			if roll_wind:
				rotation += rng.randf_range(-PI/6, PI/6)
				roll_wind = false
			wind = Vector2(500, 0).rotated(scale.x * rotation)
		WindType.MILD:
			wind_chaos = -.5
			if roll_wind:
				rotation += rng.randf_range(-PI/4, PI/4)
				roll_wind = false
			wind = Vector2(1000, 0).rotated(scale.x * rotation)
		WindType.STRONG:
			wind_chaos = 2
			if roll_wind:
				rotation += rng.randf_range(-PI/3, PI/3)
				roll_wind = false
			wind = Vector2(2000, 0).rotated(scale.x * rotation)
		WindType.TORRENT:
			wind_chaos = 3
			if directional:
				wind = (Vector2(1000, 0) * (1.25 * (sin(deltatime + rng.randf_range(0, 4))) + .5)).rotated(direction + rng.randf_range(-PI/4, PI/4))
			else:
				if roll_wind:
					rotation += rng.randf_range(-PI/2, PI/2)
					roll_wind = false
				wind = Vector2(4000, 0).rotated(scale.x * rotation)

func set_wind():
	match(wind_type):
		WindType.NONE:
			rotation = -PI/2
		WindType.GENTLE:
			rotation = PI * scale.x
		WindType.MILD:
			rotation = PI * scale.x
		WindType.STRONG:
			rotation = PI * scale.x
		WindType.TORRENT:
			rotation = PI * scale.x

func _on_Timer_timeout():
	roll_wind = true
	$Timer.start(max(rng.randf_range(0.0, 3.25) - wind_chaos, 0.25))
