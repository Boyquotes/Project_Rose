extends AudioStreamPlayer2D

@export var footsteps : Array[AudioStream] = []
var rng = RandomNumberGenerator.new()
var pitch

func _ready():
	pitch = pitch_scale
	rng.randomize()

func _on_rose_footstep():
	stream = footsteps[rng.randi_range(0,footsteps.size())-1]
	pitch_scale = pitch + rng.randf_range(-0.1, 0.1)
	play()
