extends Node2D

@onready var host : Player = get_parent().get_parent()

@export var footsteps_dirt : Array[AudioStream] = []
@export var footsteps_grass : Array[AudioStream] = []
@export var slide_dirt : Array[AudioStream] = []
@export var slide_grass : Array[AudioStream] = []
@export var playing : bool = true
var rng = RandomNumberGenerator.new()
var mat := "Dirt"
var aud_buffer : Array[AudioStreamPlayer2D] = []
var suppress_size := 0

func _ready():
	rng.randomize()

func _process(_delta):
	for aud in aud_buffer:
		if not aud.playing:
			aud_buffer.erase(aud)
			aud.queue_free()
			if suppress_size > 0:
				suppress_size -= 1
	if suppress_size <= aud_buffer.size():
		for i in suppress_size:
			aud_buffer[i].volume_db -= .5

func instantiate_stream():
	update_mat()
	rng.randomize()
	var aud = AudioStreamPlayer2D.new()
	add_child(aud)
	aud.position = Vector2(0.0, 0.0)
	aud_buffer.push_back(aud)
	return aud

func update_mat():
	var collision : KinematicCollision2D = host.get_slide_collision(0)
	
	if collision:
		var collider = collision.get_collider()
		if collider is TileMap:
			var map : TileMap = collider
			var cell_coords = map.local_to_map(map.to_local(collision.get_position()))
			var data = map.get_cell_tile_data(0, cell_coords)
			if data:
				mat = data.get_custom_data("mat")

func _on_rose_footstep(pitch_adjust: float = 0.0, vol_adjust: float = 0.0):
	if not playing:
		printerr("Not Playing Sounds From Player!")
		return
	var aud = instantiate_stream()
	match(mat):
		"Dirt":
			aud.pitch_scale = aud.pitch_scale + pitch_adjust + rng.randf_range(-0.5, 0.5)
			aud.volume_db = aud.volume_db + vol_adjust
			aud.stream = footsteps_dirt[rng.randi_range(0,footsteps_dirt.size())-1]
			aud.play()
		"Grass":
			aud.pitch_scale = aud.pitch_scale + pitch_adjust + rng.randf_range(-0.5, 0.5)
			aud.volume_db = aud.volume_db + vol_adjust
			var aud2 = instantiate_stream()
			aud2.pitch_scale = aud2.pitch_scale + pitch_adjust + rng.randf_range(-0.5, 0.5)
			aud2.volume_db = aud2.volume_db - 15 + vol_adjust
			aud.stream = footsteps_dirt[rng.randi_range(0,footsteps_dirt.size())-1]
			aud2.stream = footsteps_grass[rng.randi_range(0,footsteps_grass.size())-1]
			aud.play()
			#aud2.play()

func _on_rose_sliding(pitch_adjust: float = 0.0, vol_adjust: float = 0.0):
	if not playing:
		printerr("Not Playing Sounds From Player!")
		return
	var aud = instantiate_stream()
	match(mat):
		"Dirt":
			aud.pitch_scale = aud.pitch_scale + pitch_adjust + rng.randf_range(0.0, 0.0)
			aud.volume_db = aud.volume_db + vol_adjust
			aud.stream = slide_dirt[rng.randi_range(0,slide_dirt.size())-1]
			#aud.play()
		"Grass":
			aud.pitch_scale = aud.pitch_scale + pitch_adjust + rng.randf_range(0.0, 0.0)
			aud.volume_db = aud.volume_db + vol_adjust
			#var aud2 = instantiate_stream()
			#aud2.pitch_scale = aud2.pitch_scale + pitch_adjust + rng.randf_range(0.0, 0.0)
			#aud2.volume_db = aud2.volume_db + vol_adjust
			aud.stream = slide_dirt[rng.randi_range(0,slide_dirt.size())-1]
			#aud2.stream = slide_grass[rng.randi_range(0,slide_grass.size())-1]
			aud.play()
			#aud2.play()


func _on_rose_silence():
	suppress_size = aud_buffer.size()
