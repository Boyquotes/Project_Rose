class_name Spidahli
extends Actor

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player

var health = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rng = RandomNumberGenerator.new()
var direction = 0

func _ready():
	rng.randomize()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _on_timer_timeout():
	$Timer.start()
	direction = rng.randi_range(-1, 1)


func _on_area_2d_area_entered(_area):
	print("!!!")
	health -= 1
	if health <= 0:
		queue_free()
