extends Node2D

enum MAT {DIRT, GRASS, WOOD}

@onready var host : Player = get_parent().get_parent()

@export var footsteps_dirt : Array[AudioStream] = []
@export var footsteps_grass : Array[AudioStream] = []
@export var slide_dirt : Array[AudioStream] = []
@export var slide_grass : Array[AudioStream] = []
@export var playing : bool = true
var rng = RandomNumberGenerator.new()
var aud_buffer : Array[AudioStreamPlayer2D] = []
var suppress_size := 0
var mat := MAT.DIRT

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
		if collider is StaticBody2D:
			var shape : SS2D_Shape_Base = collider.get_child(1)
			var closest = INF
			for _point in shape._points._points.values():
				var point : SS2D_Point = _point
				var glob = shape.to_global(point.position)
				var dist = global_position.distance_to(glob)
				if dist < closest:
					closest = dist
					mat = point.properties.texture_idx as MAT


func _on_rose_footstep(pitch_adjust: float = 0.0, vol_adjust: float = 0.0):
	if not playing:
		printerr("Not Playing Sounds From Player!")
		return
	var aud = instantiate_stream()
	match(mat):
		MAT.DIRT:
			aud.pitch_scale = aud.pitch_scale + pitch_adjust + rng.randf_range(-0.5, 0.5)
			aud.volume_db = aud.volume_db + vol_adjust
			aud.stream = footsteps_dirt[rng.randi_range(0,footsteps_dirt.size())-1]
			aud.play()
		MAT.GRASS:
			aud.pitch_scale = aud.pitch_scale + pitch_adjust + rng.randf_range(-0.5, 0.5)
			aud.volume_db = aud.volume_db + vol_adjust
			var aud2 = instantiate_stream()
			aud2.pitch_scale = aud2.pitch_scale + pitch_adjust + rng.randf_range(-0.5, 0.5)
			aud2.volume_db = aud2.volume_db - 5 + vol_adjust
			aud.stream = footsteps_dirt[rng.randi_range(0,footsteps_dirt.size())-1]
			aud2.stream = footsteps_grass[rng.randi_range(0,footsteps_grass.size())-1]
			aud.play()
			aud2.play()

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
