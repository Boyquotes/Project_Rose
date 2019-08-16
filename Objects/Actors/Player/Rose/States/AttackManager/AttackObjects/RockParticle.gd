extends Particles2D

func _ready():
	emitting = true;
	$AnimationPlayer.play("New Anim");