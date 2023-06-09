class_name EnemyIdleState
extends MoveState

@export_range(0, 100) var move_chance := 25

var decision_maker := RandomNumberGenerator.new()
var decision_made := false

func _handle_input():
	if super._handle_input():
		return
	# handle if an "enemy" is spotted
	
	# no threat spotted, do normal behavior
	if not decision_made:
		var to_move = decision_maker.randi_range(0, 100)
		to_move = to_move < move_chance
		if to_move:
			decide_direction()
		else:
			move_direction = 0
		$MoveTimer.start(decision_maker.randi_range(0.5,1.5))
		decision_made = true
	update_look_direction_and_scale(move_direction)

# by default, decides between left and right.
	# TODO: overload to handle omnidirectional enemies
func decide_direction():
	var left_right = decision_maker.randi_range(0, 100)
	move_direction = -1 + 2 * int(left_right < 50)
	print(move_direction)

func _on_move_timer_timeout():
	decision_made = false
