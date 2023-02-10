extends AudioStreamPlayer2D

@export var windStreams : Array[AudioStream] = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	if !playing:
		stream = windStreams[rng.randi_range(0,windStreams.size())-1]
		play()
