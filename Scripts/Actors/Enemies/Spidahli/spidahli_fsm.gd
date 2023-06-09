class_name SpidahliFiniteStateMachine
extends FiniteStateMachine


var idle_state : EnemyIdleState
var flee_state : State
var hit_state : State

func init():
	super.init()
	idle_state = move_states["idle"]
	#flee_state = move_states["flee"]
	#hit_state = move_states["hit"]
