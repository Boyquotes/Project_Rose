class_name PlayerFiniteStateMachine
extends FiniteStateMachine


var move_on_ground_state : MoveOnGroundState
var move_in_air_state : MoveInAirState
var ledge_grab_state : LedgeGrabState
var hit_state : HitState
var action_state : ActionState
var crouch_state : CrouchState

func init():
	super.init()
	move_on_ground_state = move_states["move_on_ground"]
	move_in_air_state = move_states["move_in_air"]
	ledge_grab_state = move_states["ledge_grab"]
	hit_state = move_states["hit"]
	action_state = move_states["action"]
	crouch_state = move_states["crouch"]
