extends AnimationPlayer

signal animate

var prev_anim := ""

func on_animate(animator : AnimationPlayer, anim : String, cont = true):
	if prev_anim != anim:
		emit_signal("animation_changed", prev_anim, anim)
		prev_anim = anim
		animator.stop(cont)
	animator.play(anim)
