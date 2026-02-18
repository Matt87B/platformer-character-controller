class_name OnGroundState extends StateMachine

@onready var fall_state : StateMachine = $FallState
@onready var idle_state : StateMachine = $IdleState
@onready var run_state : StateMachine = $RunState
@onready var jump_state : StateMachine = $JumpState
@onready var wall_slide_state : StateMachine = $WallSlideState

const FALL := 3
const IDLE := 4
const RUN := 5
const JUMP := 6
const WALL := 7

func _ready() -> void:
	#Load all on ground states
	load_sub_state(idle_state)
	load_sub_state(run_state)
	load_sub_state(jump_state)
	load_sub_state(fall_state)
	load_sub_state(wall_slide_state)
	
	#Idle state transitions
	add_transition(idle_state, run_state, RUN)
	add_transition(idle_state, jump_state, JUMP)
	add_transition(idle_state, fall_state, FALL)
	
	#Run state transitions
	add_transition(run_state, jump_state, JUMP)
	add_transition(run_state, idle_state, IDLE)
	add_transition(run_state, fall_state, FALL)
	
	#Jump state transitions
	add_transition(jump_state, idle_state, IDLE)
	add_transition(jump_state, wall_slide_state, WALL)
	
	#Fall state transitions
	add_transition(fall_state, jump_state, JUMP)
	add_transition(fall_state, run_state, RUN)
	add_transition(fall_state, idle_state, IDLE)
	add_transition(fall_state, wall_slide_state, WALL)
	
	#Wall slide state transitions
	add_transition(wall_slide_state, fall_state, FALL)
	add_transition(wall_slide_state, jump_state, JUMP)
	
	_default = fall_state

func _on_update(_delta: float) -> void:
	if player.is_in_water:
		send_trigger(MovementStateMachine.SWIM)
